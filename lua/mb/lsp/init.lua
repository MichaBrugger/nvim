local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "mb.lsp.mason"
require("mb.lsp.handlers").setup()
require "mb.lsp.null-ls"
