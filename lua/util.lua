local M = {}

function M.lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        return
    end
    -- override the lua-language-server settings for Neovim config
    client.settings = vim.tbl_deep_extend('force', client.settings, {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    })
end

function M.populate_qf_with_positions()
	local items = {}
	local function get_last_position(filename)
		local last_pos = vim.fn.getpos("'" .. filename)
		if last_pos ~= [[0,0,0,0]] then
			return {
				lnum = last_pos[2],
				col = last_pos[3]
			}
		end
		return { lnum = 1, col = 1 }
	end
	for _, file in ipairs(vim.v.oldfiles) do
		local pos = get_last_position(file)
		table.insert(items, {
			filename = file,
			lnum = pos.lnum,
			col = pos.col,
			text = string.format('%s:%d:%d', file,
			pos.lnum ,
			pos.col)
		})
	end
	vim.fn.setqflist({}, ' ', {items = items, title = 'OldFiles'})
	vim.cmd('copen')
end

return M
