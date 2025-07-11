--[[
Author: hotchilipowder
--]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.o`
--
vim.wo.foldmethod = "manual"

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>fed", ":e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>ws", ":split<Return><C-w>w")
vim.keymap.set("n", "<leader>wv", ":vsplit<Return><C-w>w")
vim.keymap.set("", "<leader>wh", "<C-w>h")
vim.keymap.set("", "<leader>wk", "<C-w>k")
vim.keymap.set("", "<leader>wj", "<C-w>j")
vim.keymap.set("", "<leader>wl", "<C-w>l")
vim.keymap.set("", "<leader>wq", "<C-w>q")

-- this code is from old config, and translated by chatgpt
_G.buf_read_post = function()
	local line = vim.api.nvim_eval([[line("'\"")]])
	local last_line = vim.api.nvim_eval([[line("$")]])

	if line > 0 and line <= last_line then
		vim.api.nvim_exec('normal! g`"', false)
	end
end

if vim.fn.has("autocmd") then
	vim.cmd("augroup VimrcBufReadPost")
	vim.cmd("autocmd! BufReadPost * lua _G.buf_read_post()")
	vim.cmd("augroup END")
end

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration

	"lervag/vimtex",
	{
		"ojroques/vim-oscyank",
		config = function()
			vim.keymap.set("v", "<leader>y", "<Cmd>:OSCYankVisual<CR>")
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		keys = {
			{ "<C-h>", ":<C-U>TmuxNavigateLeft<cr>" },
			{ "<C-j>", ":<C-U>TmuxNavigateDown<cr>" },
			{ "<C-k>", ":<C-U>TmuxNavigateUp<cr>" },
			{ "<C-l>", ":<C-U>TmuxNavigateRight<cr>" },
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {} },
			{ "<Space><Right>", "<Cmd>BufferLineCloseRight<CR>", {} },
			{ "<Space>q", "<Cmd>:bp <BAR> bd #<CR>", {} },
			{ "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>" },
			{ "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>" },
			{ "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>" },
			{ "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>" },
			{ "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>" },
			{ "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>" },
			{ "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>" },
			{ "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>" },
			{ "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>" },
			{ "<leader>$", "<Cmd>BufferLineGoToBuffer -1<CR>" },
		},
		config = function()
			require("bufferline").setup()
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	"tpope/vim-surround",
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 20,
			direction = "float",
			open_mapping = [[<c-\>]],
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			sort_by = "case_sensitive",
			view = {
				adaptive_size = true,
			},
			renderer = {
				group_empty = true,
			},
			git = {
				ignore = false,
			},
			filters = {
				dotfiles = false,
			},
		},
		keys = {
			{ "<leader>pt", ":NvimTreeToggle<CR>", mode = "" },
			{ "<leader>r", ":NvimTreeRefresh<CR>", mode = "n" },
		},
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		opts = {
			-- add your options that should be passed to the setup() function here
			position = "right",
		},
	},
	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		opts = {},
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	{ -- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		-- https://github.com/catppuccin/nvim
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{ -- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		main = "ibl",
		opts = {},
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",

			"hrsh7th/cmp-vsnip",
			{
				"hrsh7th/vim-vsnip",
				config = function()
					vim.g.vsnip_snippet_dir = vim.fn.fnamemodify(vim.fn.expand("~/.config/nvim/vsnip_snippets"), ":p:h")
				end,
			},
      -- ultisnips
			{
				"SirVer/ultisnips",
				dependencies = { "hotchilipowder/vim-snippets" },
				config = function()
					vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
					vim.g.ultisnips_python_style = "numpy"
					vim.g.UltiSnipsExpandTrigger = "<tab>"
					vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
					vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
					vim.g.UltiSnipsEditSplit = "vertical"
					vim.api.nvim_exec(
						[[
            autocmd FileType ultisnips setlocal nofoldenable
          ]],
						false
					)
				end,
				lazy = false,
			},
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = "ConformInfo",
		dependencies = { "mason.nvim" },
		lazy = true,
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			log_level = vim.log.levels.DEBUG,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_format" }
					else
						return { "isort", "black" }
					end
				end,
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				-- Use the "*" filetype to run formatters on all filetypes.
				["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "prettierd", "prettier" },
			},
		},
	},

	-- https://www.lazyvim.org/plugins/lsp#null-lsnvim
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "mason.nvim" },
		opts = function(_, opts)
			local null_ls = require("null-ls")
			opts.root_dir = opts.root_dir
				or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
			opts.sources = vim.list_extend(opts.sources or {}, {
				-- see https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
				-- python
				null_ls.builtins.formatting.black,

				null_ls.builtins.diagnostics.djlint,
				null_ls.builtins.formatting.djlint,
				-- js
				null_ls.builtins.formatting.prettier,
			})
		end,
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
}, {})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})
-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { "python", "tsx", "typescript", "vimdoc", "vim", "lua", "typst" },

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = false,

	highlight = { enable = true },
	indent = { enable = true, disable = { "python" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<M-space>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	-- nmap('<leader>wl', function()
	--    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer

	vim.keymap.set("v", "<leader>f", vim.lsp.buf.format)
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	pyright = {},
	rust_analyzer = {},
	ts_ls = {},
	texlab = {},
	tinymist = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

-- nvim-cmp setup
local cmp = require("cmp")
-- local luasnip = require 'luasnip'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		{ name = "ultisnips" }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		{ name = "buffer" },
		{ name = "path" },
	}),
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.g.tmux_navigator_no_mappings = 1
