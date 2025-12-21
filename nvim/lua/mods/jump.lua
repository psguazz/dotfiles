local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local make_entry = require("telescope.make_entry")

local git = require("lib.git")
local inflection = require("lib.inflection")

local BLACKLIST = {
  "applications?",
  "controllers?",
  "components?",
  "jobs?",
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

local FILTER_COMMAND = [[%s | rg '%s' | rg -v '%s']]

local function command()
  if git.is_git_repo() then
    return GIT_COMMAND
  else
    return RG_COMMAND
  end
end

local function normalize(token)
  token = token:lower()
  token = token:gsub("[-_/]", " ")

  for _, word in ipairs(BLACKLIST) do
    token = token:gsub(word, "")
  end

  token = token:gsub("^%s+", "")
  token = token:gsub("%s+$", "")
  token = token:gsub("%s+", " ")

  return vim.split(token, " ")
end

local function inflect(tokens)
  local inflected = {}

  for _, token in ipairs(tokens) do
    for _, i in ipairs(inflection.inflections(token)) do
      table.insert(inflected, i)
    end
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


local function build_tokens()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then return {} end

  if use_parent_folder(name) then
    name = extract_parent_folder(name)
  else
    name = extract_file_name(name)
  end

  return inflect(normalize(name))
end

local function filter(source, tokens)
  local filename_pattern = [[(%s)[^/]*$]]
  local parent_pattern = [[(%s)[^/]*/[^/]*(%s)[^/]*$]]

  local pattern = table.concat(tokens, "|")
  local use_folders = table.concat(USE_FOLDERS, "|")

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

local function open_picker(tokens, results)
  local prompt = table.concat(tokens, "|")
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
  local tokens = build_tokens()
  if #tokens == 0 then return end

  local results = filter(command(), tokens)
  open_picker(tokens, results)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>/", jump_search)
end

return M
