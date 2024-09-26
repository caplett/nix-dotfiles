--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--"                                init.vim                                "
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vim.opt.hidden = true

vim.cmd("set termguicolors")
vim.api.nvim_command('set completeopt=menu,menuone,noselect')

-- Don't lose selection when shifting sidewards
vim.keymap.set("x", '<', '<gv')
vim.keymap.set("x", '>', '>gv')

-- VIm Autoscroll. 
vim.api.nvim_command('set scrolloff=4')

--Enables the experimental Lua module loader:
--overrides loadfile
--adds the Lua loader using the byte-compilation cache
--adds the libs loader
--removes the default Nvim loader
vim.loader.enable()

-- Do default action for previous item.
-- vim.keymap.set("n", '<silent> <space>=  :set ea noea<CR>

-- Map Leader
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

--"""""""""""""""""
--"  Vim Plugins  "
--"""""""""""""""""

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
{'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<F3>", "<cmd>Neotree float toggle<cr>", desc = "NeoTree" },
    }
},

{'simrat39/symbols-outline.nvim',
    config = function()
        require("symbols-outline").setup()
        vim.keymap.set("n", "<F4>", ":SymbolsOutline<CR>")
    end,
},

{'williamboman/nvim-lsp-installer',
    config = function()
        require("nvim-lsp-installer").setup({
        automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗"
            }
        }
    })
    end,
},

'neovim/nvim-lspconfig',

{'nvim-treesitter/nvim-treesitter',
    config=function()
        require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        highlight = {
            enable = true,
        },
        indent = {
            enable = true
        },

            -- List of parsers to ignore installing
        ignore_install = { "norg" }
        }
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
},

{
'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
    opts = {
        -- add any options here
    },
    lazy = false,
},

{'nvim-lua/lsp-status.nvim',
    config=function()
        lsp_status = require('lsp-status')
        lsp_status.register_progress()
        lsp_status.config({
            status_symbol = "",
        })
    end,
},

{'nvim-telescope/telescope.nvim',
    config=function()
        require('telescope').setup({
        defaults = {
            layout_config = {
            vertical = { width = 0.95 }
            -- other layout configuration here
            },
            layout_strategy = "vertical",
            -- sorting_strategy= "ascending",
            sorting_strategy= "descending",
            -- other defaults configuration here
        },
        -- other configuration values here
        })
    end,
},

'nvim-lua/plenary.nvim',
'nvim-lua/popup.nvim',

'sheerun/vim-polyglot',

'pocco81/true-zen.nvim',

{'tzachar/local-highlight.nvim',
    config = function()
        require('local-highlight').setup({
            file_types = {'python', 'cpp'},
            hlgroup = 'Search',
            cw_hlgroup = nil,
            })
    end,
},

{'airblade/vim-gitgutter',
        config = function()
            vim.api.nvim_command('let g:gitgutter_map_keys = 0')
        end,
},


'dkarter/bullets.vim',
'lervag/wiki.vim',
'michal-h21/vim-zettel',

'samoshkin/vim-mergetool',

'rhysd/vim-clang-format',
'tpope/vim-fugitive',
'tpope/vim-unimpaired',
'tpope/vim-repeat',
'kana/vim-operator-user',

'christoomey/vim-tmux-navigator',
'edkolev/tmuxline.vim',
'tmux-plugins/vim-tmux',

'simeji/winresizer',

'psf/black',

'nvim-neo-tree/neo-tree.nvim',

{'folke/trouble.nvim',
    config = function()
        vim.keymap.set("n", '<F2>', '<cmd>TroubleToggle<cr>', {})

        --- more config can be found here: 
        --- https://github.com/folke/trouble.nvim
        require("trouble").setup { }
    end,
},

'folke/lsp-colors.nvim',

-- Git Blame auf steroiden
'rhysd/git-messenger.vim',

-- Another eye friendly colortheme
{'sainnhe/everforest',
    priority=1000,
    config = function()
        vim.cmd("colorscheme everforest")
    end,
},

'rmehri01/onenord.nvim', 
'EdenEast/nightfox.nvim',
'arcticicestudio/nord-vim',
'rebelot/kanagawa.nvim',
'morhetz/gruvbox',


-- Highlight Colorcodes in theire color
{'norcalli/nvim-colorizer.lua',
    config=function()
        require("colorizer").setup()
    end,
},

-- Highlight and search for TODO and other
{'folke/todo-comments.nvim',
    config=function()
        require("todo-comments").setup {
                signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
            FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
            },
            TODO = { icon = " ", color = "warning" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", color = "info", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            QUESTION = { icon = "?", color = Orange },
        },
        merge_keywords = true, -- when true, custom keywords will be merged with the defaults
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
            before = "", -- "fg" or "bg" or empty
            keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
            after = "fg", -- "fg" or "bg" or empty
            pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
            max_line_len = 400, -- ignore lines longer than this
            exclude = {}, -- list of file types to exclude highlighting
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of hilight groups or use the hex color if hl not found as a fallback
        colors = {
            error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
            warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
            info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
            hint = { "LspDiagnosticsDefaultHint", "#10B981" },
            default = { "Identifier", "#7C3AED" },
            },
        search = {
            command = "rg",
            args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            },
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
            -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
        }
    end,
},


{'lervag/vimtex',
    config=function()
        vim.g.tex_flavor='xelatex'
        vim.g.vimtex_view_method='zathura'
        vim.g.vimtex_quickfix_mode=0
        vim.g.tex_conceal='abdmg'
        vim.opt.conceallevel=1
        vim.api.nvim_create_autocmd({"BufEnter"}, {
            pattern = {"*.tex"},
            command = "nnoremap <leader>t <cmd>VimtexTocToggle<CR>",
            })
    end,
},


{'ahmedkhalf/project.nvim',
    config=function()
        require("project_nvim").setup {}
        require('telescope').load_extension('projects')
    end,
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
},


'direnv/direnv.vim',

{'folke/which-key.nvim',
    config=function()
        require("which-key").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end,
},

{'junegunn/vim-easy-align',
    config=function()
        -- Start interactive EasyAlign in visual mode (e.g. vipga)
        vim.api.nvim_command("xmap ga <Plug>(EasyAlign)")

        -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
        vim.api.nvim_command("nmap ga <Plug>(EasyAlign)")
    end,
},

{ 
    "danymat/neogen", 
    dependencies = "nvim-treesitter/nvim-treesitter", 
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*" 
},

'simrat39/symbols-outline.nvim',

'nvim-treesitter/nvim-treesitter-context',

'wellle/targets.vim',

'tpope/vim-surround',

    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },

'saadparwaiz1/cmp_luasnip',



    { 
        'zbirenbaum/copilot.lua',
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>"
                    },
                    layout = {
                        position = "bottom", -- | top | left | right
                        ratio = 0.4
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-l>",
                        accept_word = false,
                        accept_line = false,  
                        next = "<C-j>",
                        prev = "<C-k>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_node_command = 'node', -- Node.js version must be > 16.x
                server_opts_overrides = {}, 
            })
        end,
    },


{
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
        show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
        debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
        disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
        language = "English" -- Copilot answer language settings when using default prompts. Default language is English.
        -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
        -- temperature = 0.1,
    },
    config = function()
        require("CopilotChat").setup({})
    end,
},

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            -- 'hrsh7th/cmp-copilot'
    build = function()
        vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    lazy = false,
    tag = "v1.6.1",
    -- event = "VeryLazy",
    keys = {
        { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
        { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
        {
        "<leader>ccT",
        "<cmd>CopilotChatVsplitToggle<cr>",
        desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
        },
        config=function()
            local cmp = require'cmp'
            require("luasnip").setup()

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
                sources = {
                    { name = 'nvim_lsp' },
                    -- { name = "copilot" },
                    -- { name = 'cmp_tabnine' },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                    { name = 'buffer' },
                    { name = 'cmdline' },
                    { name = 'path' }
                }
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
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
    },


-- { import = 'custom.plugins' },

}, {})


-- allow backspacing over everything in insert mode
vim.opt.backspace="indent,eol,start"

vim.opt.backup = true -- keep a backup filel

vim.opt.ruler = true		-- show the cursor position all the time

vim.opt.showcmd = true		-- display incomplete commands

vim.opt.incsearch = true		-- do incremental searching

vim.opt.wildmenu = true --Tab autovervollständigung"
vim.opt.wildmode = 'list:longest,full'

vim.opt.hlsearch = false

-- Enable file type detection.
-- Use the default filetype settings, so that mail gets 'tw' set to 72,
-- 'cindent' is on in C files, etc.
-- Also load indent files, to automatically do language-dependent indenting.
vim.api.nvim_command('filetype plugin indent on')

-- Put these in an autocmd group, so that we can delete them easily.
vim.api.nvim_command('au!')

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
-- Also don't do it when the mark is in the first line, that is the default
-- position when opening a file.

vim.opt.autowrite = true
vim.opt.autowriteall = true

-- Some servers have issues with backup files, see #649
vim.opt.backupdir=vim.fn.expand("~/.vim/backupdir")
vim.opt.directory=vim.fn.expand("~/.vim/backupdir")

vim.opt.undodir=vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true

-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime=100

-- always show signcolumns
vim.opt.signcolumn="auto"

-- History lenght. Maybe helpful for fzf history search
vim.opt.history=10000
 
-- Ask to save before buffer change"
vim.opt.confirm = true

-- dont use mouse
vim.opt.mouse=nv

-- Bei suche nicht auf groß- und kleinschreibung achten
vim.opt.ignorecase = true

vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.softtabstop=4
vim.opt.shiftround = true

-- Free movement on empty lines
vim.opt.virtualedit = "all"

vim.opt.number = true
vim.opt.cursorline = true
vim.wo.cursorline = true



--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--"                  ViWiki  (deprecated)                                  "
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

--autocmd BufEnter *.md TSDisable highlight      
--
--let g:wiki_root = '~/vimwiki'
--let g:wiki_filetypes = ['md']
--let g:wiki_link_extension = '.md'
--let g:wiki_link_target_type = 'md'
--
--
--let wiki_1 = {}
--let wiki_1.path = '/home/stefan/vimwiki'
--let wiki_1.syntax = 'markdown'
--let wiki_1.ext = '.md'
--let wiki_1.auto_tags = 1
--let wiki_1.automatic_nested_syntaxes = 1
--" Refresh TOC if exists on save
--let wiki_1.auto_toc = 1
--" Highlight wiki links to non existing pages
--let wiki_1.maxhi = 1
--let wiki_1.auto_diary_index = 1
--
--let g:vimwiki_conceal_pre = 1
--
--let g:vimwiki_list = [wiki_1]
--let g:vimwiki_use_mouse = 0
--"let g:vimwiki_folding = 'expr'
--let g:vimwiki_auto_chdir = 1
--
--let g:zettel_format = "%Y-%m-%d_%H-%M_%A"
--
--let g:nv_search_paths = ['~stefan/vimwiki']
--
--nnoremap <leader>nn :NV!
--
--nnoremap <leader>zb :ZettelBackLinks<cr>
--nnoremap <leader>zz :ZettelNew<space>
--nnoremap <leader>zl :ZettelSearch<cr>
--
--"Mandatory for Ultisnips   
--let g:vimwiki_table_mappings = 0
--
--let g:vimwiki_hl_headers = 1
--
--" Set highliting of Headers in vimwiki more visible
--highlight! VimwikiHeaderChar cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#5e81ac guibg=#2e3440
--highlight! link VimwikiLink SpellRare
--highlight! link VimwikiList markdownH1
--
--highlight! VimwikiHeader1 cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#2e3440 guibg=#BF616A
--highlight! VimwikiHeader2 cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#3B4252 guibg=#d08770
--highlight! VimwikiHeader4 cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#2E3440 guibg=#A3BE8C
--highlight! VimwikiHeader3 cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#2E3440 guibg=#EBCB8B


--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--"                          Clipboard management                          "
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

--" Copy to clipboard
vim.keymap.set("v", '<leader>y', '"+y')
vim.keymap.set("n", '<leader>Y', '"+yg_')
vim.keymap.set("n", '<leader>y', '"+y')
vim.keymap.set("n", '<leader>yy', '"+yy')

--" Paste from clipboard
vim.keymap.set("n", '<leader>p', '"+p')
vim.keymap.set("n", '<leader>P', '"+P')
vim.keymap.set("v", '<leader>p', '"+p')
vim.keymap.set("v", '<leader>P', '"+P')

--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--"                              Key mappings                              "
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


--" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
--" so that you can undo CTRL-U after inserting a line break.
vim.keymap.set("i", "<C-U>", "<C-G>u<c-U>")

--" Tmux style window movement
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")

vim.keymap.set("n", "L", ":tabnext<CR>")
vim.keymap.set("n", "H", ":tabprev<CR>")
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>")

vim.keymap.set("n", "<leader>F", "<cmd>lua require('telescope.builtin').find_files()<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")


vim.keymap.set("n", "<leader>H", "<cmd>lua require('telescope.builtin').man_pages()<CR>")

vim.keymap.set("n", "<leader>dd", ":BufferClose<CR>")

vim.keymap.set("n", "<Space><space>", "<cmd>lua require('telescope.builtin').buffers()<CR>")


vim.keymap.set("n", "<Leader>r", "'")


vim.keymap.set("n", "<Leader>j", "<cmd>lua require('telescope.builtin').jumplist{}<CR>")


--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--"                               lsp Stuff                                "
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vim.api.nvim_create_user_command( 'Declaration', ":lua vim.lsp.buf.declaration()", {})
vim.api.nvim_create_user_command( 'Definition', ":lua vim.lsp.buf.definition()", {})
vim.api.nvim_create_user_command( 'Hover', ":lua vim.lsp.buf.hover()", {})
vim.api.nvim_create_user_command( 'Implementation', ":lua vim.lsp.buf.implementation()", {})
vim.api.nvim_create_user_command( 'SignatureHelp', ":lua vim.lsp.buf.signature_help()", {})
vim.api.nvim_create_user_command( 'TypeDefinition', ":lua vim.lsp.buf.type_definition()", {})
vim.api.nvim_create_user_command( 'References', ":lua require'telescope.builtin'.lsp_references{}", {})
vim.api.nvim_create_user_command( 'DocumentSymbol', ":lua vim.lsp.buf.document_symbol()", {})
vim.api.nvim_create_user_command( 'WorkspaceSymbol', ":lua vim.lsp.buf.workspace_symbol()", {})
vim.api.nvim_create_user_command( 'Format', ":lua vim.lsp.buf.formatting_sync(nil, 1000)", {})
vim.api.nvim_create_user_command( 'Rename', ":lua vim.lsp.buf.rename()", {})

vim.keymap.set("n", 'K',  '<cmd>Hover<CR>', { silent = true, })
vim.keymap.set("n", 'gd', '<cmd>Definition<CR>', { silent = true, })
vim.keymap.set("n", 'gy', '<cmd>TypeDefinition<CR>', { silent = true, })
vim.keymap.set("n", 'gi', '<cmd>Implementation<CR>', { silent = true, })
vim.keymap.set("n", 'gr', '<cmd>References<CR>', { silent = true, })
vim.keymap.set("n", ']d', ':lua vim.lsp.diagnostic.goto_next()<CR>', { silent = true, })
vim.keymap.set("n", '[d', ':lua vim.lsp.diagnostic.goto_prev()<CR>', { silent = true, })

vim.keymap.set("n", '<leader>f',  '<cmd>Format<CR>', {})
vim.keymap.set("n", '<leader>r',  '<cmd>Rename<CR>', {})
vim.keymap.set("n", '<leader>p',  "<cmd>lua require'telescope.builtin'.git_files{}<CR>", {})
vim.keymap.set("n", '<leader>ws', "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<CR>", {})
vim.keymap.set("n", '<leader>ds', "<cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>", {})
vim.keymap.set("n", '<leader>w',  '<cmd>update<CR>', {})
vim.keymap.set("n", '<leader>q',  '<cmd>quit<CR>', {})



vim.keymap.set("n", '<leader>a', ':ClangdSwitchSourceHeader<CR>', {})



