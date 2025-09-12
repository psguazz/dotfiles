local autoformat = true

local function format_on() autoformat = true end
local function format_off() autoformat = false end
local function format_toggle() autoformat = not autoformat end

local function custom_format(cmd, args)
  local function after_format(res)
    if res.code ~= 0 then
      local message = string.sub(res.stderr or "", 1, 100)
      vim.notify("Format failed!\n" .. message, vim.log.levels.ERROR)
      return
    end

    vim.schedule(function()
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd("checktime")
      end)
    end)
  end

  vim.system(cmd, { text = true, }, after_format)
end

local function prettier_format(args)
  local name = vim.api.nvim_buf_get_name(args.buf)
  custom_format({ "prettier", "--prose-wrap", "always", "--write", name }, args)
end

local function erb_format(args)
  local name = vim.api.nvim_buf_get_name(args.buf)
  custom_format({ "erb-format", name, "--write", "--print-width", 480 }, args)
end

local custom_formatters = {
  prettier = {
    callback = prettier_format,
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "yaml",
      "html",
      "css",
      "scss",
      "markdown",
      "markdown.mdx",
    },
  },
  erb = {
    callback = erb_format,
    filetypes = {
      "eruby",
    }
  }
}

local function find_formatter(buf)
  local filetype = vim.bo[buf].filetype

  for _, formatter in pairs(custom_formatters) do
    for _, type in ipairs(formatter.filetypes) do
      if type == filetype then return formatter.callback end
    end
  end
end

local function format_pre(args)
  local formatter = find_formatter(args.buf)
  if formatter ~= nil then return end

  local clients = vim.lsp.get_clients({ bufnr = args.buf })
  if #clients == 0 then return end

  vim.lsp.buf.format({ bufnr = args.buf, async = false })
end

local function format_post(args)
  local formatter = find_formatter(args.buf)
  if formatter == nil then return end

  return formatter(args)
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Format", format_toggle, {})
  vim.api.nvim_create_user_command("FormatOn", format_on, {})
  vim.api.nvim_create_user_command("FormatOff", format_off, {})

  vim.api.nvim_create_autocmd("BufWritePre", { callback = format_pre })
  vim.api.nvim_create_autocmd("BufWritePost", { callback = format_post })
end

return M
