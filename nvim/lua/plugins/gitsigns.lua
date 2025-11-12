return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map({ "n", "v" }, "g.", function()
        if vim.wo.diff then
          return "g."
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Jump to next hunk" })

      map({ "n", "v" }, "g,", function()
        if vim.wo.diff then
          return "g,"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Jump to previous hunk" })

      map("n", "<leader>hb", function()
        gs.blame_line { full = true }
      end, { desc = "git blame line" })

      map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
      map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

      vim.api.nvim_create_user_command("Blame", function()
        vim.cmd("Gitsigns blame")
      end, {})

      vim.api.nvim_create_user_command("GitSignsResetAll", function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modifiable then
            pcall(vim.api.nvim_buf_call, buf, function()
              pcall(gs.reset_base)
            end)
          end
        end
      end, {})
    end,
  },
}
