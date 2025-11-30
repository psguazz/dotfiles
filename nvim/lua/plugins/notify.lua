return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup()
    vim.notify = require("notify")

    vim.api.nvim_create_user_command("NC", function()
      vim.cmd("NotificationsClear")
    end, {})
  end
}
