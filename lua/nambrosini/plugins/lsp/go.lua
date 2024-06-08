return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	event = { "BufNewFile", "BufReadPre" },
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		require("go").setup()
		vim.keymap.set("n", "<F5>", "<cmd>GoDebug<CR>", { desc = "[D]ebug [R]un" })
		vim.keymap.set("n", "<leader>tf", "<cmd>GoTestFunc -F<CR>", { desc = "[T]est [F]unction" })
		vim.keymap.set("n", "<leader>ta", "<cmd>GoTest -F<CR>", { desc = "[T]est [A]ll" })
		vim.keymap.set("n", "<leader>pr", "<cmd>GoRun -F<CR>", { desc = "[P]rogram [R]un" })
	end,
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
