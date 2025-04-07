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

local function lsp_format()
  if not autoformat then return end
  if prettier_filetypes[vim.bo.filetype] then return end

  vim.lsp.buf.format({ async = false })
end

local function prettier_format()
  if not autoformat then return end
  if not prettier_filetypes[vim.bo.filetype] then return end

  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)

  local function after_format(res)
    if res.code ~= 0 then
      vim.notify("Prettier failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
      return
    end

    vim.schedule(function()
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("edit!")
      end)
    end)
  end

  vim.system({ "prettier", "--write", name }, { text = true, }, after_format)
end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.api.nvim_create_autocmd("BufWritePre", { buffer = args.buf, callback = lsp_format })
    vim.api.nvim_create_autocmd("BufWritePost", { buffer = args.buf, callback = prettier_format })


    vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end
})

vim.api.nvim_create_user_command("Format", format_toggle, {})
vim.api.nvim_create_user_command("FormatOn", format_on, {})
vim.api.nvim_create_user_command("FormatOff", format_off, {})

vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', {})

vim.lsp.enable({
  "gopls",
  "luals",
  "pylsp",
  "standardrb",
  "tailwindcss",
  "ts-ls",
})
