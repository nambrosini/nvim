vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/j-hui/fidget.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.*") },
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/AlexandrosAlexiou/kotlin.nvim",
	"https://github.com/mrcjkb/rustaceanvim",
})

-- Neovim's built-in filetype detection doesn't tag compose files as
-- yaml.docker-compose, which docker_compose_language_service requires.
vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
	pattern = {
		["docker%-compose%.[%w_.-]+%.ya?ml"] = "yaml.docker-compose",
		["compose%.[%w_.-]+%.ya?ml"] = "yaml.docker-compose",
	},
})

local parsers = {
	"bash",
	"c",
	"diff",
	"dockerfile",
	"helm",
	"html",
	"java",
	"kotlin",
	"lua",
	"luadoc",
	"markdown_inline",
	"markdown",
	"query",
	"rust",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
}
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		-- check if parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- enables syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- enables treesitter based folds
		-- for more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		-- enables treesitter based indentation (skip kotlin — indent queries are incomplete)
		if filetype ~= "kotlin" then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
require("mason").setup({})
require("fidget").setup({})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", "<CMD>FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", "<CMD>FzfLua lsp_references<CR>", "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", "<CMD>FzfLua lsp_implementations<CR>", "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", "<CMD>FzfLua lsp_typedefs<CR>", "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", "<CMD>FzfLua lsp_document_symbols<CR>", "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", "<CMD>FzfLua lsp_live_workspace_symbols<CR>", "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", function()
			if vim.bo[event.buf].filetype == "kotlin" then
				vim.cmd("KotlinCodeAction")
			else
				vim.lsp.buf.code_action()
			end
		end, "[C]ode [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Shows the signature in a small floating box; pressing it again
		-- while the box is open moves focus into it for scrolling.
		map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
	dockerls = {},
	docker_compose_language_service = {},
	gopls = {},
	helm_ls = {
		yamlls = {
			path = "yaml-language-server",
		},
	},
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					}),
				},
			})
		end,
		settings = {
			Lua = {},
		},
	},
	pyright = {},
}

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, { "stylua", "ktlint", "kotlin-lsp", "rust-analyzer" })

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("kotlin").setup({
	-- Optional: Specify root markers for multi-module projects
	-- Default: { "build.gradle", "build.gradle.kts", "pom.xml", "mvnw" }
	root_markers = {
		"gradlew",
		".git",
		"mvnw",
		"settings.gradle",
	},

	-- Optional: Java Runtime to run the kotlin-lsp server itself
	-- LEGACY ONLY — ignored on v262.4739.0+ (bin/intellij-server manages
	-- its own JBR; a warning is shown if this is set on a new install).
	-- Only useful with older builds that ship kotlin-lsp.sh / kotlin-lsp.cmd.
	--
	-- When set, the plugin parses JVM args from the bundled launcher script
	-- and invokes your custom JRE with the correct flags
	-- Must point to JAVA_HOME (directory containing bin/java)
	-- Examples:
	--   macOS:   "/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"
	--   Linux:   "/usr/lib/jvm/java-25-openjdk"
	--   Windows: "C:\\Program Files\\Java\\jdk-25"
	--   Env var: os.getenv("JAVA_HOME") or os.getenv("JDK25")
	jre_path = nil,

	-- Optional: JDK for symbol resolution (analyzing your Kotlin code)
	-- This is the JDK that your project code will be analyzed against
	-- Different from jre_path (which runs the server)
	-- Required for: Analyzing JDK APIs, standard library symbols, platform types
	--
	-- Usually should match your project's target JDK version
	-- Examples:
	--   macOS:   "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
	--   Linux:   "/usr/lib/jvm/java-17-openjdk"
	--   Windows: "C:\\Program Files\\Java\\jdk-17"
	--   SDKMAN:  os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.8-tem"
	jdk_for_symbol_resolution = nil, -- Auto-detect from project

	-- Optional: Specify additional JVM arguments for the kotlin-lsp server
	jvm_args = {
		"-Xmx4g", -- Increase max heap (useful for large projects)
	},

	-- Optional: Configure inlay hints (requires kotlin-lsp v261+)
	-- All settings default to true, set to false to disable specific hints
	inlay_hints = {
		enabled = true, -- Enable inlay hints (auto-enable on LSP attach)
		parameters = true, -- Show parameter names
		parameters_compiled = true, -- Show compiled parameter names
		parameters_excluded = false, -- Show excluded parameter names
		types_property = true, -- Show property types
		types_variable = true, -- Show local variable types
		function_return = true, -- Show function return types
		function_parameter = true, -- Show function parameter types
		lambda_return = true, -- Show lambda return types
		lambda_receivers_parameters = true, -- Show lambda receivers/parameters
		value_ranges = true, -- Show value ranges
		kotlin_time = true, -- Show kotlin.time warnings
	},

	-- Optional: LSP-driven folding (requires kotlin-lsp v262.4739.0+)
	-- Enabled by default; set folding.enabled = false to opt out.
	folding = { enabled = true },

	-- Optional: build-importer preference (requires kotlin-lsp v262.4739.0+)
	-- Mirrors the VSCode `intellij.buildTool` setting:
	--   nil = let the server pick (default)
	--   "gradle" or "maven" = force a specific importer
	--   ""    = none (single-file / no build system)
	-- build_tool = "gradle",

	-- Optional: file templates for new Kotlin files (requires kotlin-lsp v262.4739.0+)
	-- When you create a new .kt file the plugin asks the server to interpolate the
	-- chosen template. Pass a table of name → Velocity template to override the
	-- defaults (Class, File, Interface, Data Class, Enum, Annotation, Object).
	-- Set { enabled = false } on the table to disable the prompt entirely.
	-- file_templates = {
	--     enabled = true,
	--     -- Class = "package ${PACKAGE_NAME}\n\nclass ${NAME} {\n\t|\n}",
	-- },
})

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { "lsp", "path", "snippets" },
	},
	snippets = { preset = "luasnip" },
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})

-- vim: ts=2 sts=2 sw=2 et
