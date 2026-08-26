-- [[ ASH & AMBER EDITION: MAXIMALIST NODE/TS POWERHOUSE ]]

do
	vim.g.mapleader, vim.g.maplocalleader = " ", " "
	vim.g.have_nerd_font = true

	local opt = vim.opt
	opt.termguicolors = true
	opt.number, opt.relativenumber = true, true
	opt.mouse, opt.showmode = "a", false
	vim.schedule(function()
		opt.clipboard = "unnamedplus"
	end)
	opt.breakindent, opt.undofile = true, true
	opt.ignorecase, opt.smartcase = true, true
	opt.signcolumn, opt.updatetime, opt.timeoutlen = "yes", 250, 300
	opt.splitright, opt.splitbelow = true, true
	opt.list, opt.listchars = true, { tab = "» ", trail = "·", nbsp = "␣" }
	opt.inccommand, opt.cursorline, opt.scrolloff = "split", true, 10
	opt.confirm, opt.autoindent, opt.smartindent = true, true, true

	-- Global Inlay Hints (The Maximalist TS Dream)
	vim.lsp.inlay_hint.enable(true)

	local map = vim.keymap.set
	map("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- Windows Muscle Memory
	map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")
	map("n", "<C-a>", "ggVG")
	map("v", "<C-c>", '"+y')
	map("n", "<C-v>", '"+p')
	map("v", "<C-v>", '"+p')
	map("i", "<C-v>", "<C-r>+")

	-- Line Swapping
	map("n", "<M-Down>", "<cmd>m .+1<cr>==")
	map("n", "<M-Up>", "<cmd>m .-2<cr>==")
	map("v", "<M-Down>", ":m '>+1<cr>gv=gv")
	map("v", "<M-Up>", ":m '<-2<cr>gv=gv")

	-- Centered Scrolling
	map("n", "<C-d>", "<C-d>zz")
	map("n", "<C-u>", "<C-u>zz")
	map("n", "n", "nzzzv")
	map("n", "N", "Nzzzv")

	local num_group = vim.api.nvim_create_augroup("SmartNumberToggle", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
		group = num_group,
		callback = function()
			if opt.nu:get() and vim.fn.mode() ~= "i" then
				opt.relativenumber = true
			end
		end,
	})
	vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
		group = num_group,
		callback = function()
			if opt.nu:get() then
				opt.relativenumber = false
			end
		end,
	})

	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		virtual_text = true,
		virtual_lines = false,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },
	})
	map("n", "<leader>q", vim.diagnostic.setloclist)

	-- Terminal & Splits
	map("n", "<C-t>", "<cmd>botright split | resize 15 | terminal<cr>", { silent = true })
	vim.api.nvim_create_autocmd("TermOpen", {
		callback = function()
			vim.cmd("startinsert")
		end,
	})
	map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })
	map("n", "<C-h>", "<C-w><C-h>")
	map("n", "<C-l>", "<C-w><C-l>")
	map("n", "<C-j>", "<C-w><C-j>")
	map("n", "<C-k>", "<C-w><C-k>")
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

-- [[ LAZY.NVIM BOOTSTRAP ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ PLUGINS: THE MAXIMALIST ROSTER ]]
require("lazy").setup({
	-- UI, Animations & Visuals
	{ "NMAC427/guess-indent.nvim", config = true },
	{
		"lewis6991/gitsigns.nvim",
		opts = { signs = { add = { text = "+" }, change = { text = "~" }, delete = { text = "_" } } },
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>h", group = "Git [H]unk" },
				{ "<leader>x", group = "Trouble" },
			},
		},
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	{
		"folke/flash.nvim",
		opts = { modes = { search = { enabled = true } } },
		keys = { {
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
		} },
	},
	{ "goolord/alpha-nvim", dependencies = { "MaximilianLloyd/ascii.nvim", "nvim-tree/nvim-web-devicons" } },
	{ "scottmckendry/cyberdream.nvim" },
	{ "folke/todo-comments.nvim", opts = { signs = true } },
	{ "nvim-mini/mini.nvim" },
	{
		"echasnovski/mini.animate",
		version = false,
		config = function()
			require("mini.animate").setup()
		end,
	},
	{ "sphamba/smear-cursor.nvim", opts = { stiffness = 0.8, trailing_stiffness = 0.5 } },
	{ "MunifTanjim/nui.nvim" },
	{ "rcarriga/nvim-notify" },
	{
		"folke/noice.nvim",
		opts = { presets = { command_palette = true, lsp_doc_border = true }, notify = { enabled = true } },
	},
	{ "NvChad/nvim-colorizer.lua", opts = { user_default_options = { tailwind = true, mode = "virtualtext" } } },
	{
		"folke/zen-mode.nvim",
		opts = { window = { backdrop = 0.95, width = 120 } },
		keys = { { "<leader>z", "<cmd>ZenMode<cr>" } },
	},
	{ "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
	{ "nvim-lualine/lualine.nvim" },

	-- Maximalist Tools (Diagnostics & Node.js Magic)
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = { { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" } },
	},
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
		end,
	},
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		config = true,
		event = "BufRead package.json",
	},

	-- Navigation
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-telescope/telescope-ui-select.nvim" } },
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	},

	-- LSP, Completion & DAP
	{ "j-hui/fidget.nvim", config = true },
	{ "p00f/clangd_extensions.nvim" },
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = { preset = "super-tab" },
			appearance = { nerd_font_variant = "mono" },
			signature = { enabled = true },
		},
	},
	{ "neovim/nvim-lspconfig" },
	{ "mason-org/mason.nvim" },
	{ "mason-org/mason-lspconfig.nvim" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "stevearc/conform.nvim" },
	{ "windwp/nvim-ts-autotag", config = true },
	{ "windwp/nvim-autopairs", config = true },
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
})

-- [[ CONFIGURE UI (ASH & AMBER OVERRIDES) ]]
require("notify").setup({ background_colour = "#18181a", fps = 60, render = "minimal" })
vim.notify = require("notify")

require("ibl").setup({
	indent = { char = "│" },
	scope = { enabled = true, show_start = false, show_end = false },
	exclude = { filetypes = { "alpha", "neo-tree", "TelescopePrompt", "trouble" } },
})

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = require("ascii").get_random("anime", "onepiece")
dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("x", "  Trouble", ":Trouble diagnostics toggle<CR>"),
	dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
}
vim.api.nvim_set_hl(0, "DashHeader", { fg = "#ff7a00", bold = true })
vim.api.nvim_set_hl(0, "DashButtons", { fg = "#d4d4d6", bold = true })
dashboard.section.header.opts.hl, dashboard.section.buttons.opts.hl = "DashHeader", "DashButtons"
require("alpha").setup(dashboard.opts)

require("cyberdream").setup({ transparent = false, italic_comments = true, hide_fillchars = true })
vim.cmd("colorscheme cyberdream")

local hl = vim.api.nvim_set_hl
hl(0, "Normal", { bg = "#18181a", fg = "#d4d4d6" })
hl(0, "NormalFloat", { bg = "#18181a" })
hl(0, "FloatBorder", { bg = "#18181a", fg = "#ff7a00" })
hl(0, "NeoTreeNormal", { bg = "#18181a" })
hl(0, "NeoTreeNormalNC", { bg = "#18181a" })
hl(0, "Comment", { fg = "#5c7e9c", italic = true })
hl(0, "String", { fg = "#8abeb7" })
hl(0, "Function", { fg = "#ff7a00", bold = true })
hl(0, "Keyword", { fg = "#d97736", italic = true })
hl(0, "Identifier", { fg = "#d4d4d6" })
hl(0, "Type", { fg = "#e05f65", bold = true })
hl(0, "IblIndent", { fg = "#242427" })
hl(0, "IblScope", { fg = "#ff7a00" })
hl(0, "CursorLine", { bg = "#242427" })
hl(0, "Visual", { bg = "#3f3f44" })
hl(0, "Cursor", { fg = "#18181a", bg = "#ff7a00" })
hl(0, "TermCursor", { fg = "#18181a", bg = "#ff7a00" })
hl(0, "LightBulbSign", { fg = "#ff7a00", bg = "NONE" })

require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()
require("bufferline").setup({
	options = { mode = "buffers", themeable = true, separator_style = "thin", always_show_bufferline = true },
})
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
require("lualine").setup({ options = { theme = "auto", globalstatus = true } })

-- [[ CONFIGURE NAVIGATION ]]
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
require("telescope").setup({ extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } } })
pcall(require("telescope").load_extension, "ui-select")
local b = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", b.find_files)
vim.keymap.set("n", "<leader>sg", b.live_grep)
vim.keymap.set("n", "<leader>sw", b.grep_string)
vim.keymap.set("n", "<leader>sd", b.diagnostics)
vim.keymap.set("n", "<leader><leader>", b.buffers)

-- [[ CONFIGURE LSP & FORMATTING ]]
local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("blink.cmp").get_lsp_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local b_tele = require("telescope.builtin")
		local b_map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = event.buf })
		end
		b_map("grr", b_tele.lsp_references)
		b_map("grd", b_tele.lsp_definitions)
		b_map("gri", b_tele.lsp_implementations)
		b_map("grt", b_tele.lsp_type_definitions)
		b_map("grn", vim.lsp.buf.rename)
		b_map("gra", vim.lsp.buf.code_action)
		if vim.bo[event.buf].filetype == "cpp" or vim.bo[event.buf].filetype == "c" then
			b_map("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>")
		end
	end,
})

-- Aggressive TS Inlay Hints Configuration
local vtsls_settings = {
	vtsls = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
}

local servers = {
	clangd = {
		cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--fallback-style=llvm" },
	},
	zls = {},
	gopls = { settings = { gopls = { gofumpt = true, analyses = { unusedparams = true }, staticcheck = true } } },
	basedpyright = { settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } } },
	html = {},
	ols = {},
	rust_analyzer = { settings = { ["rust-analyzer"] = { checkOnSave = true } } },
	vtsls = { settings = vtsls_settings },
	lua_ls = { settings = { Lua = { workspace = { checkThirdParty = false }, hint = { enable = true } } } },
}

require("mason").setup({})
local ensure_tools = vim.tbl_keys(servers)
vim.list_extend(ensure_tools, { "ruff", "goimports", "gofumpt", "stylua", "prettier" })
require("mason-tool-installer").setup({ ensure_installed = ensure_tools })

for name, server in pairs(servers) do
	server.capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {})
	require("lspconfig")[name].setup(server)
end

require("conform").setup({
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	formatters_by_ft = {
		lua = { "stylua" },
		zig = { "zigfmt" },
		rust = { "rustfmt" },
		go = { "goimports", "gofumpt" },
		python = { "ruff_format", "ruff_fix" },
		odin = { "odinfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
	},
})
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true })
end)

-- [[ TREESITTER ]]
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"go",
		"python",
		"zig",
		"html",
		"lua",
		"markdown",
		"vim",
		"javascript",
		"typescript",
		"json",
	},
	auto_install = true,
	highlight = { enable = true },
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
})

-- [[ DEBUGGING (DAP) ]]
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.adapters.gdb = { type = "executable", command = "gdb", args = { "-i", "dap" } }
dap.configurations.cpp = {
	{
		name = "Launch Project",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}
dap.configurations.c, dap.configurations.rust = dap.configurations.cpp, dap.configurations.cpp

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
