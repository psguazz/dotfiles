local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local make_entry = require("telescope.make_entry")

local git = require("lib.git")

BLACKLIST = {
  "controllers?",
  "components?",
  "jobs?",
  "tests?",
}

FOLDER_EXTENSIONS = {
  "erb",
  "html",
}

IGNORE_FOLDERS = {
  "node_modules",
  "db/migrate",
}

GIT_COMMAND = "git -c core.quotepath=false ls-files --exclude-standard --cached --others"
RG_COMMAND = "rg --files ."

FILTER_COMMAND = [[%s | rg "%s" | rg -v "%s"]]

local function command()
  if git.is_git_repo() then
    return GIT_COMMAND
  else
    return RG_COMMAND
  end
end

local function normalize(token)
  token = token:lower()
  token = token:gsub("[-_]", " ")

  for _, word in ipairs(BLACKLIST) do
    token = token:gsub(word, "")
  end

  token = token:gsub("^%s+", "")
  token = token:gsub("%s+$", "")
  token = token:gsub("%s+", " ")

  return vim.split(token, " ")
end


local function use_parent_folder(token)
  local ext = vim.fn.fnamemodify(token, ":e")
  for _, extension in ipairs(FOLDER_EXTENSIONS) do
    if ext == extension then
      return true
    end
  end
  return false
end

local function extract_parent_folder(token)
  token = vim.fn.fnamemodify(token, ":h")
  token = vim.fn.fnamemodify(token, ":t")
  return token
end

local function extract_file_name(token)
  token = vim.fn.fnamemodify(token, ":t")
  token = vim.fn.fnamemodify(token, ":r")
  return token
end


local function build_token()
  local token = vim.api.nvim_buf_get_name(0)
  if token == "" then return {} end

  if use_parent_folder(token) then
    token = extract_parent_folder(token)
  else
    token = extract_file_name(token)
  end

  return normalize(token)
end

local function filter(source, query)
  local include = table.concat(query, "|")
  local exclude = table.concat(IGNORE_FOLDERS, "|")

  local cmd = string.format(FILTER_COMMAND, source, include, exclude)
  local result = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("fzf error: " .. vim.v.shell_error)
    return {}
  end

  return result
end

local function open_picker(token, results)
  local prompt = table.concat(token, "|")
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
  local token = build_token()
  if #token == 0 then return end

  local results = filter(command(), token)
  open_picker(token, results)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>/", jump_search)
end

return M
