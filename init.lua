if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("NativeVim only supports Neovim 0.11+", vim.log.levels.ERROR)
    return
end

require("core.options")
require("core.treesitter")
require("core.lsp")
require("core.statusline")

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

local function populate_qf_with_positions()
    local items = {}
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

-- Create a command to use this enhanced version
vim.api.nvim_create_user_command(
    'OldFiles',
    populate_qf_with_positions,
    { desc = 'Populate quickfix list with old files and their last positions' }
)
-- fix cursor
local user_group = vim.api.nvim_create_augroup('UserCommands', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
	command = 'set guicursor= | call chansend(v:stderr, "\x1b[ q")',
	group = user_group
})
