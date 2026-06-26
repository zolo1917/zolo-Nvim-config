-- load lspconfig to register default configurations
local lspconfig_status, _ = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- set keybinds when lsp server is attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local opts = { noremap = true, silent = true, buffer = bufnr }
		local keymap = vim.keymap

		-- set keybinds
		keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
		keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
		keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
		keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
		keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
		keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
		keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
		keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
		keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
		keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
		keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side
		keymap.set("n", "<C-S-H>", "<cmd>Lspsaga incoming_calls<CR>", opts) -- show call hierarchy
	end,
})

-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure and enable servers
local basic_servers = {
	"html",
	"cssls",
	"tailwindcss",
	"yamlls",
	"pyre",
}
for _, server in ipairs(basic_servers) do
	vim.lsp.enable(server)
end

-- configure typescript server
vim.lsp.config("ts_ls", {
	settings = {
		typescript = {
			suggest = {
				autoImports = true,
			},
		},
		javascript = {
			suggest = {
				autoImports = true,
			},
		},
	},
})
vim.lsp.enable("ts_ls")

-- configure go server
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})
vim.lsp.enable("gopls")

-- configure emmet language server
vim.lsp.config("emmet_ls", {
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})
vim.lsp.enable("emmet_ls")

-- configure jdtls (java)
vim.lsp.config("jdtls", {
	settings = {
		java = {
			completion = {
				importOrder = { "java", "javax", "com", "org" }
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		}
	}
})
vim.lsp.enable("jdtls")

-- configure pyright (python)
vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
			},
		},
	},
})
vim.lsp.enable("pyright")

-- configure lua server
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
vim.lsp.enable("lua_ls")
