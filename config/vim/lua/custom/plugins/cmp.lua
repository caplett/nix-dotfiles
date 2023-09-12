--
--
-- Nvim-cmp
return {
    'hrsh7th/nvim-cmp',
        dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
    },
        config=function()
            local cmp = require'cmp'
    
            cmp.setup({
                snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
                },
                mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                --['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                -- { name = 'cmp_tabnine' },
                -- { name = 'vsnip' }, -- For vsnip users.
                -- { name = 'luasnip' }, -- For luasnip users.
                { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
                { name = 'buffer' },
                })
            })
    
            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                { name = 'buffer' }
                }
            })
    
            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                { name = 'path' }
                }, {
                { name = 'cmdline' }
                })
            })
    
            -- Setup lspconfig.
            local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
            --  capabilities = capabilities
            -- }
            local lspconfig = require'lspconfig'
            
            lspconfig.clangd.setup{
                cmd = { "clangd-10", "--background-index" , "--cross-file-rename", "--all-scopes-completion", "--completion-style=detailed", "-j=10"},
                capabilities = capabilities
                }
            
            lspconfig.cmake.setup{
                capabilities = capabilities
            }
            
            
            --Enable (broadcasting) snippet capability for completion
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities.textDocument.completion.completionItem.snippetSupport = true
            
            
            lspconfig.html.setup {
                capabilities = capabilities,
                }
    
            lspconfig.pyright.setup{
            capabilities = capabilities,
            settings = {
                pyright = {
                    analysis = {
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "strict",
                            diagnosticMode = "workspace",
                            autoSearchPaths = true,
                            },
                    exclude = "wandb/**",
                    }
                }
            }
            
            require'lspconfig'.texlab.setup{
                capabilities = capabilities,
            }
    
            require'lspconfig'.marksman.setup{
                capabilities = capabilities
                }
        end,
    }
