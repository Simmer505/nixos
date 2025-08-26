local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false;

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            imports = {
                group = {
                    enable = false,
                },
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
}

lspconfig.matlab_ls.setup {
    capabilities = capabilities,
    settings = {
        MATLAB = {
            indexWorkspace = false,
            installPath = "",
        },
    },
}

lspconfig.omnisharp.setup {
    cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll"}
}

local default_servers = {'pylsp', 'ccls', 'r_language_server', 'lua_ls', 'nil_ls', 'tinymist'}

for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities
    }
end

local luasnip = require 'luasnip'
local cmp = require 'cmp'


cmp.setup {
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
    },
}


