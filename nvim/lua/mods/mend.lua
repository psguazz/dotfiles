local autoformat = true

local custom_filetypes = {
  prettier = {
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
  },
  erb = {
    eruby = true,
  }
}

local flat_custom_filetypes = {}
for _, group in pairs(custom_filetypes) do
  for k, v in pairs(group) do
    flat_custom_filetypes[k] = v
  end
end

local function format_on() autoformat = true end
local function format_off() autoformat = false end
local function format_toggle() autoformat = not autoformat end

local function lsp_format(args)
  local clients = vim.lsp.get_active_clients({ bufnr = args.buf })

  if not autoformat then return end
  if flat_custom_filetypes[vim.bo[args.buf].filetype] then return end
  if #clients == 0 then return end

  vim.lsp.buf.format({ bufnr = args.buf, async = false })
end

local function manual_format(cmd, args)
  if not autoformat then return end

  local function after_format(res)
    if res.code ~= 0 then
      vim.notify("Formt failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
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
  if not custom_filetypes.prettier[vim.bo[args.buf].filetype] then return end

  local name = vim.api.nvim_buf_get_name(args.buf)
  manual_format({ "prettier", "--write", name }, args)
end

local function erb_format(args)
  if not custom_filetypes.erb[vim.bo[args.buf].filetype] then return end

  local name = vim.api.nvim_buf_get_name(args.buf)
  manual_format({ "erb-format", name, "--write", "--print-width", 240 }, args)
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Format", format_toggle, {})
  vim.api.nvim_create_user_command("FormatOn", format_on, {})
  vim.api.nvim_create_user_command("FormatOff", format_off, {})

  vim.api.nvim_create_autocmd("BufWritePre", { callback = lsp_format })
  vim.api.nvim_create_autocmd("BufWritePost", { callback = prettier_format })
  vim.api.nvim_create_autocmd("BufWritePost", { callback = erb_format })
end

return M
