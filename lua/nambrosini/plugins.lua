---@module 'gitsigns'
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" }, ---@diagnostic disable-line: missing-fields
		change = { text = "~" }, ---@diagnostic disable-line: missing-fields
		delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
		topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
		changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
	},
})

---@module 'which-key'
vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

require("which-key").setup({
	-- delay between pressing a key and opening which-key (milliseconds)
	delay = 0,
	icons = { mappings = vim.g.have_nerd_font },

	-- Document existing key chains
	spec = {
		{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } }, -- Enable gitsigns recommended keymaps first
		{ "gr", group = "LSP Actions", mode = { "n" } },
	},
})

---@module "snacks"
vim.keymap.set("n", "<leader><leader>", function()
	Snacks.picker.buffers()
end, { desc = "Find Buffer" })
vim.keymap.set("n", "<leader>sz", function()
	Snacks.picker.recent()
end, { desc = "[F]ind [R]ecent" })
vim.keymap.set("n", "<leader>sf", function()
	Snacks.picker.files()
end, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>gc", function()
	Snacks.picker.git_log()
end, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<leader>gg", function()
	Snacks.picker.git_status()
end, { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "[S]earch Current [B]uffer" })
vim.keymap.set("n", "<leader>sc", function()
	Snacks.picker.command_history()
end, { desc = "[S]earch [c]ommand history" })
vim.keymap.set("n", "<leader>sd", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "[S]earch Documents [d]iagnostics" })
vim.keymap.set("n", "<leader>sD", function()
	Snacks.picker.diagnostics()
end, { desc = "[S]earch Workspace [D]iagnostics" })
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "[S]earch [G]rep (Root dir)" })
vim.keymap.set("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "[S]earch [H]elp Pages" })
vim.keymap.set("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sq", function()
	Snacks.picker.qflist()
end, { desc = "[S]earch [Q]uickfix" })
vim.keymap.set("n", "<leader>sr", function()
	Snacks.picker.resume()
end, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "[S]earch [s]ymbol" })
vim.keymap.set("n", "<leader>sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "[S]earch Workspace [S]ymbol" })
vim.keymap.set("n", "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "[S]earch [w]ord" })
vim.keymap.set("v", "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "[S]earch selection" })
vim.keymap.set("n", "<leader>sn", function()
	Snacks.picker.files({
		cwd = vim.fn.stdpath("config"),
		prompt = "Neovim> ",
	})
end, { desc = "[S]earch [N]eovim" })

---@module "conform"
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
local conform = require("conform")
conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true, java = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		kotlin = { "ktlint" },
		lua = { "stylua" },
		-- Conform can also run multiple formatters sequentially
		-- python = { "isort", "black" },
		--
		-- You can use 'stop_after_first' to run the first available formatter from the list
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		conform.format({ bufnr = args.buf })
	end,
})

---@module "tokyonight"
vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
})
require("tokyonight").setup()
vim.cmd.colorscheme("tokyonight-night")

---@module "todo-comments"
vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})
require("todo-comments").setup({})

---@module "mini"
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
})
-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
local mini = require("nambrosini.util.mini")
local ai = require("mini.ai")

ai.setup({
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({ -- code block
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}),
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
		t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
		d = { "%f[%d]%d+" }, -- digits
		e = { -- Word with case
			{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
			"^().*()$",
		},
		g = mini.ai_buffer, -- buffer
		u = ai.gen_spec.function_call(), -- u for "Usage"
		U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
	},
})

-- Add/delete/replace surroundings (brackets, quotes, etc.)
require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`
	},
})

-- Shows inline diff
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = {
			add = "▎",
			change = "▎",
			delete = "",
		},
	},
})

vim.keymap.set("n", "<leader>gd", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle [G]it [D]iff" })

-- Autopairs
require("mini.pairs").setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require("mini.statusline")
-- set use_icons to true if you have a Nerd Font
statusline.setup({ use_icons = vim.g.have_nerd_font })

---@module "neo-tree"
vim.pack.add({
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})
require("neo-tree").setup({
	filesystem = {
		window = {
			mappings = {
				["\\"] = "close_window",
			},
		},
	},
})

vim.keymap.set("n", "\\", ":Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true })

---@module "fugitive"
vim.pack.add({
	{ src = "https://github.com/tpope/vim-fugitive" },
})

vim.keymap.set("n", "<leader>gs", "<CMD>Git<CR>", { desc = "[G]it [Status]" })

---@module "miniharp"
vim.pack.add({
	{ src = "https://github.com/vieitesss/miniharp.nvim" },
})

require("miniharp").setup({
	autoload = true, -- load marks for this cwd on startup (default: true)
	autosave = true, -- save marks for this cwd on exit (default: true)
	show_on_autoload = true, -- show popup list after a successful autoload (default: false)
})

vim.keymap.set("n", "<leader>m", require("miniharp").toggle_file, { desc = "miniharp: toggle file mark" })
vim.keymap.set("n", "<C-n>", require("miniharp").next, { desc = "miniharp: next file mark" })
vim.keymap.set("n", "<C-p>", require("miniharp").prev, { desc = "miniharp: prev file mark" })
vim.keymap.set("n", "<leader>l", require("miniharp").show_list, { desc = "miniharp: list marks" })

---@module "helm-ls"
vim.pack.add({
	{ src = "https://github.com/qvalentin/helm-ls.nvim" },
	{ src = "https://github.com/towolf/vim-helm" },
})

require("helm-ls").setup()

---@module "nvim-lint"
-- Linting
vim.pack.add({
	"https://github.com/mfussenegger/nvim-lint",
})
local lint = require("lint")
lint.linters_by_ft = {
	dockerfile = { "hadolint" },
	json = { "jsonlint" },
	markdown = { "markdownlint" },
	rust = { "clippy" },
	terraform = { "tflint" },
	zig = { "zlint" },
}
-- cargo/clippy exits 101 when it reports diagnostics; that's not a failure.
lint.linters.clippy.ignore_exitcode = true

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		-- Only run the linter in buffers that you can modify in order to
		-- avoid superfluous noise, notably within the handy LSP pop-ups that
		-- describe the hovered symbol using Markdown.
		if vim.bo.modifiable then
			lint.try_lint()
		end
	end,
})

---@module "crates.nvim"
vim.pack.add({
	"https://github.com/saecki/crates.nvim",
})

require("crates").setup({})

---@module "go.nvim"
vim.pack.add({
	"https://github.com/ray-x/go.nvim",
})

require("go").setup()

---@module "noice"
vim.pack.add({
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
})

require("noice").setup({
	presets = {
		bottom_search = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
})

---@module "snacks"
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
	indent = { enabled = true },
	picker = { enabled = true, ui_select = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = false },
	words = { enabled = true },
})

---@module "flash"
vim.pack.add({
	{ src = "https://github.com/folke/flash.nvim" },
})

require("flash").setup()

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

---@module "vimtex"
vim.pack.add({
	{ src = "https://github.com/lervag/vimtex" },
})

vim.g.vimtex_view_method = "skim" -- macOS; requires Skim.app

---@module "devcontainer"
vim.pack.add({
	{ src = "https://codeberg.org/esensar/nvim-dev-container" },
})

require("devcontainer").setup({})

-- vim: ts=2 sts=2 sw=2 et
