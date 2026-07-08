-- General LPS configuration
require("lspconfig")

local servers = {
  gopls = 'gopls',
  jsonls = 'vscode-json-language-server',
  pyright = 'pyright-langserver',
  sourcekit = 'sourcekit-lsp'
}

for name, executable in pairs(servers) do
    if vim.fn.executable(executable) == 1 then
        vim.lsp.enable(name)
    end
end

vim.lsp.enable(servers)

-- Setup key mapping
vim.lsp.config("*", {
  on_attach = function(client, bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
    map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n', '<leader>F', '<cmd>lua vim.lsp.buf.format()<CR>')
  end

})
