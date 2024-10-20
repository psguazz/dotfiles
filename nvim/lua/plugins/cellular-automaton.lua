return {
  {
    "Eandrju/cellular-automaton.nvim",
    config = function()
      vim.api.nvim_create_user_command("Rain", "CellularAutomaton make_it_rain", {})
      vim.api.nvim_create_user_command("GOL", "CellularAutomaton game_of_life", {})
    end
  }
}
