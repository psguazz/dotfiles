local autoformat = true

local prettier_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  json = true,
  yaml = true,
  html = true,
  css = true,
  scss = true,
  markdown = true,
  ["markdown.mdx"] = true,
}

local function format_on() autoformat = true end
local function format_off() autoformat = false end
local function format_toggle() autoformat = not autoformat end

local function lsp_format(args)
  local clients = vim.lsp.get_active_clients({ bufnr = args.buf })

  if not autoformat then return end
  if prettier_filetypes[vim.bo[args.buf].filetype] then return end
  if #clients == 0 then return end

  vim.lsp.buf.format({ bufnr = args.buf, async = false })
end

local function prettier_format(args)
  if not autoformat then return end
  if not prettier_filetypes[vim.bo[args.buf].filetype] then return end

  local name = vim.api.nvim_buf_get_name(args.buf)

  local function after_format(res)
    if res.code ~= 0 then
      vim.notify("Prettier failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
      return
    end

    vim.schedule(function()
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd("checktime")
      end)
    end)
  end

  vim.system({ "prettier", "--write", name }, { text = true, }, after_format)
end

vim.api.nvim_create_user_command("Format", format_toggle, {})
vim.api.nvim_create_user_command("FormatOn", format_on, {})
vim.api.nvim_create_user_command("FormatOff", format_off, {})

vim.api.nvim_create_autocmd("BufWritePre", { callback = lsp_format })
vim.api.nvim_create_autocmd("BufWritePost", { callback = prettier_format })
