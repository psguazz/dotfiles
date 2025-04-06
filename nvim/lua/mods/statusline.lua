local f = require("lib.format")
local git = require("lib.git")
local palette = require("lib.palette")

local full = false

local modes = {
  ["n"]     = { group = "Normal", label = "Normal" },
  ["no"]    = { group = "Normal", label = "Operator-pending" },
  ["nov"]   = { group = "Normal", label = "Operator-pending (forced charwise)" },
  ["noV"]   = { group = "Normal", label = "Operator-pending (forced linewise)" },
  ["no\22"] = { group = "Normal", label = "Operator-pending (forced blockwise)" },

  ["v"]     = { group = "Visual", label = "Visual" },
  ["V"]     = { group = "Visual", label = "Visual-line" },
  ["\22"]   = { group = "Visual", label = "Visual-block" },

  ["s"]     = { group = "Select", label = "Select" },
  ["S"]     = { group = "Select", label = "Select-line" },
  ["\19"]   = { group = "Select", label = "Select-block" },

  ["i"]     = { group = "Insert", label = "Insert" },
  ["ic"]    = { group = "Insert", label = "Insert (completion)" },
  ["ix"]    = { group = "Insert", label = "Insert (CTRL-X mode)" },

  ["R"]     = { group = "Replace", label = "Replace" },
  ["Rc"]    = { group = "Replace", label = "Replace (completion)" },
  ["Rx"]    = { group = "Replace", label = "Replace (CTRL-X mode)" },
  ["Rv"]    = { group = "Replace", label = "Virtual Replace" },

  ["c"]     = { group = "Command", label = "Command-line" },
  ["cv"]    = { group = "Command", label = "Ex" },
  ["ce"]    = { group = "Command", label = "Normal Ex" },

  ["r"]     = { group = "Replace", label = "Hit-enter" },
  ["rm"]    = { group = "Replace", label = "Confirm" },
  ["r?"]    = { group = "Replace", label = "Prompt" },

  ["!"]     = { group = "Command", label = "Shell or External" },

  ["t"]     = { group = "Command", label = "Terminal" }
}

local left_pill = ""
local right_pill = ""
local space = "%#StatuslineBackground# "

local disabled_filetypes = { "NvimTree", "fugitive" }

local function should_hide(buf)
  local filetype = vim.bo[buf].filetype

  for _, ft in ipairs(disabled_filetypes) do
    if filetype == ft then
      return true
    end
  end

  return false
end

local function concat_pill(line, pill)
  if pill == "" then
    return line
  end

  if line == "" then
    return pill
  end

  return line .. space .. pill
end

local function pill(base_group, is_active, text)
  if is_active then base_group = base_group .. "Active" end
  text = " " .. text .. " "

  local group = "Statusline" .. base_group
  local pill_group = "StatuslinePill" .. base_group

  return f.format(pill_group, left_pill) .. f.format(group, text) .. f.format(pill_group, right_pill)
end


local function mode(is_active, current_mode, big)
  local text = ""
  if big then text = modes[current_mode].label or "Unknown" end

  local base_group = modes[current_mode].group
  return pill(base_group, is_active, text)
end

local function filename(buf, is_active, current_mode)
  local text = vim.api.nvim_buf_get_name(buf)
  text = vim.fn.fnamemodify(text, ":p")
  text = text:gsub("^" .. vim.pesc(vim.fn.getcwd() .. "/"), "")

  if text == "" then return "" end

  local base_group = modes[current_mode].group .. "Inverted"
  return pill(base_group, is_active, text)
end

local function diagnostics(buf)
  local errors = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.INFO })

  local counts = {}

  if errors > 0 then
    table.insert(counts, f.format("DiagnosticError", " " .. errors))
  end
  if warnings > 0 then
    table.insert(counts, f.format("DiagnosticWarn", " " .. warnings))
  end
  if hints > 0 then
    table.insert(counts, f.format("DiagnosticHint", " " .. hints))
  end
  if info > 0 then
    table.insert(counts, f.format("DiagnosticInfo", " " .. info))
  end

  if #counts > 0 then
    return pill("Plain", false, table.concat(counts, " "))
  else
    return ""
  end
end

local function file_type(buf, is_active)
  local icon = f.colored_icon(vim.fn.expand("%:p"), is_active)
  local type = vim.bo[buf].filetype
  if type == "" then type = "?" end

  return pill("Plain", false, icon .. " " .. f.format("StatuslinePlain", type))
end

local function git_status(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local group = "StatuslineGit" .. git.status(name)
  local branch = vim.fn.FugitiveHead()

  if not branch or branch == "" then return "" end

  local s = vim.b.gitsigns_status_dict
  s = s or { added = 0, changed = 0, removed = 0 }

  local counts = {}

  if (s.added or 0) > 0 then
    table.insert(counts, f.format("GitSignsAdd", "+" .. s.added))
  end
  if (s.changed or 0) > 0 then
    table.insert(counts, f.format("GitSignsChange", "~" .. s.changed))
  end
  if (s.removed or 0) > 0 then
    table.insert(counts, f.format("GitSignsDelete", "-" .. s.removed))
  end

  local text = f.format(group, " " .. branch)
  if #counts > 0 then
    text = text .. f.format("StatuslinePlain", " | ") .. table.concat(counts, " ")
  end

  return pill("Plain", false, text)
end

local function location(is_active, current_mode)
  if not is_active then return "" end

  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local row = string.format("%2d", r)
  local col = string.format("%-2d", c)
  local text = row .. ":" .. col

  local base_group = modes[current_mode].group
  return pill(base_group, is_active, text)
end

local function placeholder_line(is_active, current_mode)
  return mode(is_active, current_mode, false)
end

local function bare_line(buf, is_active, current_mode)
  local line = ""

  line = concat_pill(line, mode(is_active, current_mode, false))

  if is_active then
    line = concat_pill(line, filename(buf, false, current_mode))
  end

  return line
end

local function full_line(buf, is_active, current_mode)
  local left = ""
  local right = ""

  left = concat_pill(left, mode(is_active, current_mode, true))
  left = concat_pill(left, filename(buf, is_active, current_mode))

  if is_active then
    left = concat_pill(left, diagnostics(buf))

    right = concat_pill(right, file_type(buf, is_active))
    right = concat_pill(right, git_status(buf))
    right = concat_pill(right, location(is_active, current_mode))
  end

  return left .. "%=" .. right
end

local function statusline()
  local winid = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(winid)
  local is_active = winid == vim.fn.win_getid()
  local current_mode = vim.api.nvim_get_mode().mode

  local line = ""

  if should_hide(buf) then
    line = placeholder_line(is_active, current_mode)
  elseif full then
    line = full_line(buf, is_active, current_mode)
  else
    line = bare_line(buf, is_active, current_mode)
  end

  return "%#StatuslineBackground#" .. line .. "%#StatuslineBackground#"
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("S", function()
    if full then
      vim.cmd("Soff")
    else
      vim.cmd("Son")
    end
  end, {})

  vim.api.nvim_create_user_command("Son", function()
    full = true
  end, {})

  vim.api.nvim_create_user_command("Soff", function()
    full = false
  end, {})

  vim.api.nvim_set_hl(0, "StatuslineBackground", { bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslinePlain", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillPlain", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineGitNone", { fg = palette.fg, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslineGitNew", { fg = palette.green, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslineGitModified", { fg = palette.yellow, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslineGitDeleted", { fg = palette.red, bg = palette.bg0 })

  vim.api.nvim_set_hl(0, "StatuslineNormalActive", { fg = palette.bg0, bg = palette.bg_blue })
  vim.api.nvim_set_hl(0, "StatuslinePillNormalActive", { fg = palette.bg_blue, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineNormalInvertedActive", { fg = palette.bg_blue, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillNormalInvertedActive", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineVisualActive", { fg = palette.bg0, bg = palette.purple })
  vim.api.nvim_set_hl(0, "StatuslinePillVisualActive", { fg = palette.purple, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineVisualInvertedActive", { fg = palette.purple, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillVisualInvertedActive", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineInsertActive", { fg = palette.bg0, bg = palette.bg_green })
  vim.api.nvim_set_hl(0, "StatuslinePillInsertActive", { fg = palette.bg_green, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineInsertInvertedActive", { fg = palette.bg_green, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillInsertInvertedActive", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineCommandActive", { fg = palette.bg0, bg = palette.yellow })
  vim.api.nvim_set_hl(0, "StatuslinePillCommandActive", { fg = palette.yellow, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineCommandInvertedActive", { fg = palette.yellow, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillCommandInvertedActive", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineReplaceActive", { fg = palette.bg0, bg = palette.bg_red })
  vim.api.nvim_set_hl(0, "StatuslinePillReplaceActive", { fg = palette.bg_red, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineReplaceInvertedActive", { fg = palette.bg_red, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillReplaceInvertedActive", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineNormal", { fg = palette.bg0, bg = palette.grey })
  vim.api.nvim_set_hl(0, "StatuslinePillNormal", { fg = palette.grey, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineNormalInverted", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillNormalInverted", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineVisual", { fg = palette.bg0, bg = palette.grey })
  vim.api.nvim_set_hl(0, "StatuslinePillVisual", { fg = palette.grey, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineVisualInverted", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillVisualInverted", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineInsert", { fg = palette.bg0, bg = palette.grey })
  vim.api.nvim_set_hl(0, "StatuslinePillInsert", { fg = palette.grey, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineInsertInverted", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillInsertInverted", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineCommand", { fg = palette.bg0, bg = palette.grey })
  vim.api.nvim_set_hl(0, "StatuslinePillCommand", { fg = palette.grey, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineCommandInverted", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillCommandInverted", { fg = palette.bg0, bg = palette.bg1 })

  vim.api.nvim_set_hl(0, "StatuslineReplace", { fg = palette.bg0, bg = palette.grey })
  vim.api.nvim_set_hl(0, "StatuslinePillReplace", { fg = palette.grey, bg = palette.bg1 })
  vim.api.nvim_set_hl(0, "StatuslineReplaceInverted", { fg = palette.grey, bg = palette.bg0 })
  vim.api.nvim_set_hl(0, "StatuslinePillReplaceInverted", { fg = palette.bg0, bg = palette.bg1 })

  _G.my_statusline = statusline
  vim.o.statusline = '%!v:lua.my_statusline()'
end

return M
