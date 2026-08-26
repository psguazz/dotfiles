return {
  cmd = { 'herb-language-server', '--stdio' },
  filetypes = { 'html', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  settings = {
    languageServerHerb = {
      linter = {
        rules = {
          ['erb-strict-locals-required'] = {
            enabled = true,
          },
        },
      },
    },
  },
}
