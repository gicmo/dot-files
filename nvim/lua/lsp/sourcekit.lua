---@type vim.lsp.Config
return {
  filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objc', 'objective-cpp' },

  on_init = function(client, initialization_result)
    if client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
  get_language_id = function(_, ftype)
    if ftype == "objc" then
      return "objective-c"
    elseif ftype == "objcpp" then
      return "objective-cpp"
    end
    return ftype
  end,
}
