-- ~/.config/nvim/init.lua
-- Starter Neovim config (requires Neovim 0.11+, git, and a C compiler for treesitter)
-- Optional but recommended: ripgrep (Telescope live grep), fd, a Nerd Font

----------------------------------------------------------------------
-- Leader keys (set before plugins load)
----------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable language providers you don't use (silences :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

----------------------------------------------------------------------
-- Options
----------------------------------------------------------------------
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = false

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitright = true
opt.splitbelow = true

opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share clipboard with the system
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.showmode = false -- lualine shows the mode

----------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Diagnostics
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

----------------------------------------------------------------------
-- Autocommands
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

----------------------------------------------------------------------
-- Plugin manager: lazy.nvim (auto-installs itself on first launch)
----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight-night") end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "tokyonight", globalstatus = true } },
  },

  -- Keybinding hints (press <leader> and wait)
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- File explorer: edit your filesystem like a buffer (press - to open)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "-", "<cmd>Oil<CR>", desc = "Open parent directory" } },
    opts = {},
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- Syntax highlighting / parsing
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "bash", "python", "javascript",
          "typescript", "json", "yaml", "markdown", "html", "css",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local o = function(d) return { buffer = bufnr, desc = d } end
        map("n", "]h", gs.next_hunk, o("Next hunk"))
        map("n", "[h", gs.prev_hunk, o("Previous hunk"))
        map("n", "<leader>hp", gs.preview_hunk, o("Preview hunk"))
        map("n", "<leader>hb", gs.blame_line, o("Blame line"))
      end,
    },
  },

  -- Auto-close brackets and quotes
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" }, -- <C-y> accept, <C-space> open, <C-n>/<C-p> select
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- LSP: Mason installs servers, lspconfig configures them
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()

      -- Settings applied to every server
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Per-server overrides
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Installs these servers and enables them automatically
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" }, -- add more, e.g. "pyright", "ts_ls", "bashls"
      })

      -- LSP keymaps, set when a server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local o = function(d) return { buffer = ev.buf, desc = d } end
          map("n", "gd", vim.lsp.buf.definition, o("Go to definition"))
          map("n", "gr", "<cmd>Telescope lsp_references<CR>", o("References"))
          map("n", "gi", vim.lsp.buf.implementation, o("Go to implementation"))
          map("n", "K", vim.lsp.buf.hover, o("Hover docs"))
          map("n", "<leader>rn", vim.lsp.buf.rename, o("Rename"))
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o("Code action"))
          map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, o("Format"))
        end,
      })
    end,
  },

}, {
  checker = { enabled = false }, -- don't auto-check for plugin updates
  change_detection = { notify = false },
})
