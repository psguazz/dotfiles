local M = {}

function M.open(prompt, callback)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.min(80, math.floor(vim.o.columns * 0.7))
  local height = math.min(8, math.floor(vim.o.lines * 0.5))

  local y_pos = math.floor((vim.o.lines - height) / 2)
  local x_pos = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = height,
    row = y_pos,
    col = x_pos,
    title_pos = "center",
    title = " " .. prompt .. " ",
  })

  vim.bo[buf].buftype = "acwrite"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"

  local submit = function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n"):match("^%s*(.-)%s*$")

    vim.api.nvim_win_close(win, true)
    callback(text)
  end

  local abort = function()
    vim.api.nvim_win_close(win, true)
    callback(nil)
  end

  vim.cmd("startinsert")

  vim.keymap.set("n", "<CR>", submit, { buffer = buf })
  vim.keymap.set("n", "<Esc>", abort, { buffer = buf })
end

return M
