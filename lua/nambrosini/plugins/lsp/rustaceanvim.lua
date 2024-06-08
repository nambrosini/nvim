return {
	"mrcjkb/rustaceanvim",
	ft = { "rust", "toml" },
	event = { "BufNewFile", "BufReadPre" },
	version = "^4", -- Recommended
	config = function()
		vim.keymap.set("n", "<F5>", "<cmd>RustLsp debuggables<CR>", { desc = "[D]ebug [R]un" })
		vim.keymap.set("n", "<leader>tf", "<cmd>GoTestFunc -F<CR>", { desc = "[T]est [F]unction" })
		vim.keymap.set("n", "<leader>ta", "<cmd>GoTest -F<CR>", { desc = "[T]est [A]ll" })
		vim.keymap.set("n", "<leader>pr", "<cmd>GoRun -F<CR>", { desc = "[P]rogram [R]un" })
	end,
}
