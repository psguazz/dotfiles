local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local f = require("lib.format")
local h = require("mods.hook")
local palette = require("lib.palette")

local function display(hook)
  local group = "Peek"

  local prefix_group = group .. "Prefix"
  if hook.index == " " then prefix_group = prefix_group .. "Temp" end
  if hook.is_perm then prefix_group = prefix_group .. "Pin" end

  local number_group = group .. "Number"
  local name_group = group .. "Name"

  local prefix = "▐"

  local number = " " .. hook.index .. " "
  local icon, icon_group = f.icon_and_color(hook.path)

  local name = " " .. vim.fn.fnamemodify(hook.path, ":.")

  return function()
    local string = prefix .. number .. icon .. name
    local highlights = {
      { { 0, #prefix },                                                   prefix_group },
      { { #prefix, #prefix + #number },                                   number_group },
      { { #prefix + #number, #prefix + #number + #icon },                 icon_group },
      { { #prefix + #number + #icon, #prefix + #number + #icon + #name }, name_group },
    }

    return string, highlights
  end
end

local function ordinal(hook)
  return hook.index .. " " .. vim.fn.fnamemodify(hook.path, ":.")
end

local function hook_search()
  local hooks = h.all_hooks()

  pickers.new({}, {
    prompt_title = "Hooked Files",
    finder = finders.new_table({
      results = hooks,
      entry_maker = function(hook)
        return {
          value = hook,
          display = display(hook),
          ordinal = ordinal(hook),
          path = hook.path,
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.vim_buffer_cat.new({}),
    attach_mappings = function(prompt_bufnr, map)
      local function open_file()
        local hook = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. vim.fn.fnameescape(hook.path))
      end

      map("i", "<CR>", open_file)
      map("n", "<CR>", open_file)
      return true
    end,
  }):find()
end

M = {}

function M.setup()
  vim.keymap.set("n", "<leader>/", hook_search)

  vim.api.nvim_set_hl(0, "PeekPrefix", { fg = palette.orange })
  vim.api.nvim_set_hl(0, "PeekPrefixPin", { fg = palette.red })
  vim.api.nvim_set_hl(0, "PeekPrefixTemp", { fg = palette.yellow })
  vim.api.nvim_set_hl(0, "PeekNumber", { fg = palette.grey })
  vim.api.nvim_set_hl(0, "PeekName", { fg = palette.fg })
end

return M
