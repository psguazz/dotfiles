local format = {
  indentSize = 4,
  tabSize = 4,
  newLineCharacter = "\n",
  convertTabsToSpaces = true,
  indentStyle = 2,
  insertSpaceAfterConstructor = false,
  insertSpaceAfterCommaDelimiter = true,
  insertSpaceAfterSemicolonInForStatements = true,
  insertSpaceBeforeAndAfterBinaryOperators = true,
  insertSpaceAfterKeywordsInControlFlowStatements = true,
  insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
  insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
  insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
  insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
  insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
  insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
  insertSpaceBeforeFunctionParenthesis = false,
  placeOpenBraceOnNewLineForFunctions = false,
  placeOpenBraceOnNewLineForControlBlocks = false,
  semicolons = "insert",
  trimTrailingWhitespace = true,
  indentSwitchCase = true,
}

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git"
  },
  settings = {
    typescript = { format = format },
    javascript = { format = format }
  }
}
