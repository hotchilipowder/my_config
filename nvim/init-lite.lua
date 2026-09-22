-- Standalone, offline quick editor. Neovim 0.10+, no plugin manager.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.termguicolors = true
vim.opt.signcolumn = "auto"
vim.opt.scrolloff = 4
vim.opt.statusline = "%f %h%m%r%=%l:%c %p%%"
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/.venv/*", "*.pyc" })
-- Avoid clipboard provider detection on startup/ordinary yanks (especially SSH).
-- Neovim's native provider handles OSC 52 when supported by the terminal.
local map = vim.keymap.set
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>ws", "<Cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>wv", "<Cmd>vsplit<CR>", { desc = "Split vertically" })
for _, direction in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. direction .. ">", "<C-w>" .. direction, { desc = "Move to split" })
  map("n", "<leader>w" .. direction, "<C-w>" .. direction, { desc = "Move to split" })
end
map("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader><Space>", ":ls<CR>:buffer ", { desc = "Choose buffer" })
map("n", "<leader>ff", ":edit ", { desc = "Open file (Tab to complete)" })
map("n", "<leader>pt", "<Cmd>Explore<CR>", { desc = "Browse files" })
map("n", "<leader>fed", function()
  vim.cmd.edit(vim.env.MYVIMRC or (vim.fn.stdpath("config") .. "/init.lua"))
end, { desc = "Edit config" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Leave terminal mode" })
local group = vim.api.nvim_create_augroup("LiteConfig", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) and vim.bo[args.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
-- Built-in syntax, gc/gcc comments, Ctrl-n/Ctrl-p word completion and netrw.
