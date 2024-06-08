return {
	"rcarriga/nvim-dap-ui",
	event = { "BufNewFile", "BufReadPre" },
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dapui = require("dapui")

		local opts = {
			layouts = {
				{
					elements = {
						{
							id = "scopes",
							size = 0.25,
						},
						{
							id = "breakpoints",
							size = 0.25,
						},
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "watches",
							size = 0.25,
						},
					},
					position = "left",
					size = 60,
				},
				{
					elements = {
						{
							id = "repl",
							size = 0.5,
						},
						{
							id = "console",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 10,
				},
			},
		}

		dapui.setup(opts)

		-- vim.keymap.set("n", "<leader>duo", function()
		-- 	dapui.open()
		-- end, { desc = "[D]ap[U]i [O]pen" })
		-- vim.keymap.set("n", "<leader>duc", function()
		-- 	dapui.close()
		-- end, { desc = "[D]ap[U]i [C]close" })
		-- vim.keymap.set("n", "<leader>du", function()
		-- 	dapui.toggle()
		-- end, { desc = "[D]ap[U]i Toggle" })
		local dap = require("dap")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
