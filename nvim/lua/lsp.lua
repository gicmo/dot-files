-- General LSP configuration

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

-- Shared config: buffer-local key mappings on attach
vim.lsp.config("*", {
  on_attach = function(_, bufnr)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map('K', vim.lsp.buf.hover, 'Hover')
    map('gi', vim.lsp.buf.implementation, 'Goto Implementation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'List Workspace Folders')
    map('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>F', function() vim.lsp.buf.format({ async = true }) end, 'Format')
  end
})
