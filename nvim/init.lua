--[[
Author: hotchilipowder
--]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Daily profile: Neovim 0.12+. The standalone light profile is init-lite.lua.
if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("Daily config requires Neovim 0.12+; use nvim-lite on older machines.", vim.log.levels.ERROR)
  return
end
local enable_lsp = vim.env.NVIM_ENABLE_LSP == "1"
local enable_ultisnips = vim.env.NVIM_ENABLE_ULTISNIPS ~= "0"
vim.api.nvim_create_user_command("LspEnableHint", function()
  print("Run: NVIM_ENABLE_LSP=1 nvim-daily; install servers with :LspInstall")
end, {})

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

-- Use <leader>y for the system clipboard; ordinary y stays local.
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

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

vim.keymap.set("n", "<leader>fed", function()
  vim.cmd.edit(vim.env.MYVIMRC or (vim.fn.stdpath("config") .. "/init.lua"))
end, { desc = "Edit config" })
vim.keymap.set("n", "<leader>ws", ":split<Return><C-w>w")
vim.keymap.set("n", "<leader>wv", ":vsplit<Return><C-w>w")
vim.keymap.set("", "<leader>wh", "<C-w>h")
vim.keymap.set("", "<leader>wk", "<C-w>k")
vim.keymap.set("", "<leader>wj", "<C-w>j")
vim.keymap.set("", "<leader>wl", "<C-w>l")
vim.keymap.set("", "<leader>wq", "<C-w>q")

local config_group = vim.api.nvim_create_augroup("PersonalConfig", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = config_group,
  callback = function(args)
    local line = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(args.buf) and vim.bo[args.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    end
  end,
})

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not install lazy.nvim: " .. output, vim.log.levels.ERROR)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
local setup_completion
require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  { "lervag/vimtex", ft = { "tex", "plaintex", "bib" } },
  {
    "christoomey/vim-tmux-navigator",
    init = function()
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
  "tpope/vim-surround",
  -- Git related plugins
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" } },
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- gc/gcc are provided by Neovim.

  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = { { [[<c-\>]], "<Cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" } },
    version = "*",
    opts = {
      size = 20,
      direction = "float",
      open_mapping = [[<c-\>]],
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeClose", "NvimTreeToggle", "NvimTreeRefresh" },
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
  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
    event = { "BufReadPre", "BufNewFile" },
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
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {},
  },

  { "neovim/nvim-lspconfig", enabled = enable_lsp },
  { "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate" }, opts = {} },
  { "mason-org/mason-lspconfig.nvim", enabled = enable_lsp, dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" } },

  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function() setup_completion() end,
    dependencies = {
      { "neovim/nvim-lspconfig", enabled = enable_lsp },
      { "hrsh7th/cmp-nvim-lsp", enabled = enable_lsp },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      -- ultisnips
      {
        "SirVer/ultisnips",
        dependencies = { "hotchilipowder/vim-snippets" }, -- Helpers imported by personal snippets.
        enabled = enable_ultisnips,
        init = function()
          vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
          vim.g.ultisnips_python_style = "numpy"
          vim.g.UltiSnipsExpandTrigger = "<tab>"
          vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
          vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
          vim.g.UltiSnipsEditSplit = "vertical"

          vim.api.nvim_create_autocmd("FileType", {
            pattern = "ultisnips",
            command = "setlocal nofoldenable",
          })
        end,
      },
      { "quangnguyen30192/cmp-nvim-ultisnips", enabled = enable_ultisnips },
    },
  },

  {
    "stevearc/conform.nvim",
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
        sh = { "shfmt" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },

      },
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {},
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { -- Highlight, edit, and navigate code
    -- The `master` branch is archived and incompatible with Neovim 0.12.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
  },
}, { checker = { enabled = false }, change_detection = { notify = false } })

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Resolve Telescope only when a mapping is used.
local function telescope(name)
  return function() require("telescope.builtin")[name]() end
end
-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", telescope("oldfiles"), { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", telescope("buffers"), { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>ff", telescope("find_files"), { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>fh", telescope("help_tags"), { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>fw", telescope("grep_string"), { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>fg", telescope("live_grep"), { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>fd", telescope("diagnostics"), { desc = "[S]earch [D]iagnostics" })

-- [[ Configure Treesitter ]]
-- Neovim provides highlighting and folds; indentation remains experimental in the plugin.
-- Use the rewritten main branch for parser/query management.
-- See `:help nvim-treesitter` and `:help treesitter`
do
  local treesitter_parsers = { "python", "tsx", "typescript", "javascript", "vimdoc", "vim", "lua", "typst", "markdown", "markdown_inline", "bash", "json", "yaml", "rust" }

  local nvim_treesitter = require("nvim-treesitter")
  -- `install_dir` is prepended to 'runtimepath' so freshly installed
  -- parsers/queries take priority over stale ones.
  nvim_treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  vim.api.nvim_create_user_command("TSInstallDefaults", function()
    if vim.fn.executable("tree-sitter") == 0 then
      vim.notify("Install tree-sitter-cli >= 0.26.1 and a C compiler first.", vim.log.levels.ERROR)
      return
    end
    nvim_treesitter.install(treesitter_parsers)
  end, { desc = "Install the usual parsers explicitly" })


  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      if not pcall(vim.treesitter.start, args.buf) then
        return
      end
      -- Treesitter indentation is experimental; python keeps its own filetype indent.
      if vim.bo[args.buf].filetype ~= "python" then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  local textobjects = require("nvim-treesitter-textobjects")
  textobjects.setup({
    select = {
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
    },
    move = {
      set_jumps = true, -- whether to set jumps in the jumplist
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")

  -- You can use the capture groups defined in textobjects.scm
  for lhs, query in pairs({
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
  }) do
  vim.keymap.set({ "x", "o" }, lhs, function()
    select.select_textobject(query, "textobjects")
  end, { desc = "Select " .. query })
end

local function map_move(lhs, func, query)
  vim.keymap.set({ "n", "x", "o" }, lhs, function()
    move[func](query, "textobjects")
  end, { desc = "Move to " .. query })
end

map_move("]m", "goto_next_start", "@function.outer")
map_move("]]", "goto_next_start", "@class.outer")
map_move("]M", "goto_next_end", "@function.outer")
map_move("][", "goto_next_end", "@class.outer")
map_move("[m", "goto_previous_start", "@function.outer")
map_move("[[", "goto_previous_start", "@class.outer")
map_move("[M", "goto_previous_end", "@function.outer")
map_move("[]", "goto_previous_end", "@class.outer")

vim.keymap.set("n", "<leader>a", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap with next parameter" })
vim.keymap.set("n", "<leader>A", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous parameter" })
end

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

if enable_lsp then
  -- LSP settings.
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end

      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", telescope("lsp_references"), "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", telescope("lsp_document_symbols"), "[D]ocument [S]ymbols")
    nmap("<leader>cs", telescope("lsp_document_symbols"), "Document symbols")
    nmap("<leader>ss", telescope("lsp_dynamic_workspace_symbols"), "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("gK", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")

  end

  local servers = {
    pyright = {},
    rust_analyzer = {},
    ts_ls = {},
    texlab = {},
    tinymist = {},
  }


  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  require("mason").setup()

  local mason_lspconfig = require("mason-lspconfig")

  mason_lspconfig.setup({
    ensure_installed = {}, -- Install explicitly with :LspInstall.
    automatic_enable = false,
  })

  for server_name, server_opts in pairs(servers) do
    server_opts.capabilities = capabilities
    server_opts.on_attach = on_attach
    vim.lsp.config(server_name, server_opts)
    vim.lsp.enable(server_name)
  end
end

setup_completion = function()
  local cmp = require("cmp")

  local cmp_sources = {
    { name = "buffer" },
    { name = "path" },
  }
  if enable_ultisnips then table.insert(cmp_sources, 1, { name = "ultisnips" }) end
  if enable_lsp then
    table.insert(cmp_sources, 1, { name = "nvim_lsp" })
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        if enable_ultisnips then
          vim.fn["UltiSnips#Anon"](args.body)
        else
          vim.snippet.expand(args.body)
        end
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
    sources = cmp.config.sources(cmp_sources),
  })

end

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
vim.api.nvim_create_autocmd("TermOpen", { group = config_group, callback = _G.set_terminal_keymaps })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.g.tmux_navigator_no_mappings = 1
