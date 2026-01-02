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

local FILTER_COMMAND = [[%s | rg -i '%s' | rg -i -v '%s']]

local function command()
  if git.is_git_repo() then
    return GIT_COMMAND
  else
    return RG_COMMAND
  end
end

local function tokenize(name)
  name = name:lower()
  name = name:gsub("[-_/]", " ")

  for _, word in ipairs(STOPWORDS) do
    name = name:gsub(word, "")
  end

  name = name:gsub("%s+", " ")
  name = name:gsub("^%s+", "")
  name = name:gsub("%s+$", "")

  if name == "" then return {} end

  return vim.split(name, " ")
end

local function inflect(name)
  local tokens = tokenize(name)
  if #tokens == 0 then return {} end

  local last_token = tokens[#tokens]
  local first_tokens = table.concat(tokens, "_", 1, #tokens - 1)
  if first_tokens ~= "" then first_tokens = first_tokens .. "_" end

  local inflected = {}

  for _, i in ipairs(inflection.inflections(last_token)) do
    table.insert(inflected, first_tokens .. i)
  end

  return inflected
end

local function use_parent_folder(name)
  local basename = vim.fn.fnamemodify(name, ":t")
  for _, stop in ipairs(USE_FOLDERS) do
    if basename:find(stop) then
      return true
    end
  end
  return false
end

local function extract_parent_folder(name)
  name = vim.fn.fnamemodify(name, ":h")
  name = vim.fn.fnamemodify(name, ":t")
  return name
end

local function extract_file_name(name)
  name = vim.fn.fnamemodify(name, ":t")
  name = vim.fn.fnamemodify(name, ":r")
  return name
end

local function build_names()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then return {} end
  if name:match("NvimTree_") then return {} end

  if use_parent_folder(name) then
    name = extract_parent_folder(name)
  else
    name = extract_file_name(name)
  end

  return inflect(name)
end

local function filter(source, names)
  local filename_pattern = [[(%s)[^/]*$]]
  local parent_pattern = [[(%s)[^/]*/[^/]*(%s)[^/]*$]]
  local word_pattern = [[(^|\b|[-_])(%s)([_-]|\b|$)]]

  local pattern = string.format(word_pattern, table.concat(names, "|"))
  local use_folders = string.format(word_pattern, table.concat(USE_FOLDERS, "|"))

  local exclude = table.concat(IGNORE_FOLDERS, "|")
  local include = table.concat({
    string.format(filename_pattern, pattern),
    string.format(parent_pattern, pattern, use_folders),
  }, "|")

  local cmd = string.format(FILTER_COMMAND, source, include, exclude)
  local result = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    return {}
  end

  return result
end

local function open_picker(names, results)
  local prompt = table.concat(names, "|")
  pickers.new({}, {
    prompt_title = "Jump to `" .. prompt .. "`",
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

  local results = filter(command(), names)
  open_picker(names, results)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>/", jump_search)
end

return M
