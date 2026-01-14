local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local make_entry = require("telescope.make_entry")

local git = require("lib.git")
local inflection = require("lib.inflection")

local STOPWORDS = {
  "applications?",
  "components?",
  "controllers?",
  "jobs?",
  "policies",
  "policy",
  "specs?",
  "tests?",
}

local USE_FOLDERS = {
  ".erb",
  ".html",
  "index.js",
  "__init__.py",
}

local IGNORE_FOLDERS = {
  "node_modules/",
  "db/migrate/",
  "vendor/",
  "log/",
  "tmp/",
  "public/",
  "assets/",
}

local GIT_COMMAND = "git -c core.quotepath=false ls-files --exclude-standard --cached --others"
local RG_COMMAND = "rg --files ."

local function command()
  if git.is_git_repo() then
    return GIT_COMMAND
  else
    return RG_COMMAND
  end
end

local function match_any(name, patterns)
  for _, pattern in ipairs(patterns) do
    if name:match(pattern) then return true end
  end

  return false
end

local function important_name(path)
  local file = vim.fn.fnamemodify(path, ":t")
  local name = vim.fn.fnamemodify(path, ":t:r")
  local parent = vim.fn.fnamemodify(path, ":h:t")

  if match_any(file, USE_FOLDERS) then
    return parent
  end

  return name
end

local function tokenize(name)
  name = name:gsub("(%l)(%u)", "%1_%2")
  name = name:gsub("[-_/]", " ")
  name = name:lower()
  name = name:gsub("%s+", " ")
  name = name:gsub("^%s+", "")
  name = name:gsub("%s+$", "")

  local tokens = {}

  for _, word in ipairs(vim.split(name, " ")) do
    if not match_any(word, STOPWORDS) then
      table.insert(tokens, word)
    end
  end

  return tokens
end

local function inflect(name)
  local tokens = tokenize(name)
  if #tokens == 0 then return {} end

  local last_token = tokens[#tokens]
  local first_tokens = table.concat(tokens, ".?", 1, #tokens - 1)
  if first_tokens ~= "" then first_tokens = first_tokens .. ".?" end

  local names = {}

  for _, inf in ipairs(inflection.inflections(last_token)) do
    table.insert(names, first_tokens .. inf)
  end

  return names
end

local function build_names()
  local buf = vim.api.nvim_buf_get_name(0)

  if buf == "" then return {} end
  if buf:match("NvimTree_") then return {} end

  vim.print(buf)

  local name = important_name(buf)
  return inflect(name)
end

local function filter(raw_results, names)
  local results = {}

  for _, path in ipairs(raw_results) do
    local name = important_name(path)
    if match_any(name, names) then
      table.insert(results, path)
    end
  end

  return results
end

local function get_raw_results(names)
  local base_cmd = command()

  local folders = table.concat(IGNORE_FOLDERS, ",")
  local filter_cmd = "rg -i --glob '!**/{" .. folders .. "}/**'"

  for _, name in ipairs(names) do
    filter_cmd = filter_cmd .. " -e " .. name
  end

  local cmd = string.format("%s | %s", base_cmd, filter_cmd)
  return vim.fn.systemlist(cmd)
end

local function open_picker(names, results)
  pickers.new({}, {
    prompt_title = "Jump to `" .. table.concat(names, "|") .. "`",
    finder = finders.new_table {
      entry_maker = make_entry.gen_from_file({}),
      results = results,
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.vim_buffer_cat.new({}),
  }):find()
end

local function jump_search()
  local names = build_names()
  if #names == 0 then return end

  local raw_results = get_raw_results(names)
  local results = filter(raw_results, names)

  open_picker(names, results)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>n", jump_search)
end

return M
