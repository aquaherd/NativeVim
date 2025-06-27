-- :h lsp-config

-- enable lsp completion
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
		end
		local nset = function(keys, func, desc)
			vim.keymap.set('n', keys, func, { buffer = ev.buf, silent = true, desc = desc })
		end
	    nset('gd', vim.lsp.buf.definition, 'goto definition')
		nset('grq', vim.diagnostic.setqflist, 'diagnostic setqflist')
		nset('grh', vim.diagnostic.open_float, 'diagnostic float')
    end,
})

-- enable configured language servers
vim.lsp.enable({'clangd', 'lua_ls', 'bashls'})
