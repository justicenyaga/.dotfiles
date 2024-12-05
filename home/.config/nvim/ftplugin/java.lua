local keymap = vim.keymap -- for conciseness

local on_attach = function(client, bufnr)
	require("jdtls.dap").setup_dap_main_class_configs() -- Discover main classes for debugging

	local opts = { noremap = true, silent = true }
	opts.buffer = bufnr

	-- set keybinds
	opts.desc = "Show LSP references"
	keymap.set("n", "gf", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

	opts.desc = "Go to declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

	opts.desc = "Show LSP definitions"
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

	opts.desc = "Show LSP implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

	opts.desc = "Show LSP type definitions"
	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

	opts.desc = "See available code actions"
	keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

	opts.desc = "Rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

	opts.desc = "Go to previous diagnostic"
	keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

	opts.desc = "Go to next diagnostic"
	keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

	opts.desc = "Show documentation for what is under cursor"
	keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
end

local config = {
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
	on_attach = on_attach,
	handlers = {
		["language/status"] = function(_, result, ctx, _)
			if result.type == "ServiceReady" then
				for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end
		end,
	},
	settings = {
		java = {
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	},
	init_options = {
		bundles = {
			vim.fn.glob(
				vim.fn.stdpath("data")
					.. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
				1
			),
		},
	},
}

require("jdtls").start_or_attach(config)
