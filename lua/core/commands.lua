-- OldFiles user command
vim.api.nvim_create_user_command(
    'OldFiles',
    require("util").populate_qf_with_positions,
    { desc = 'Populate quickfix list with old files and their last positions' }
)
-- fix cursor
local user_group = vim.api.nvim_create_augroup('UserCommands', { clear = true })
vim.api.nvim_create_autocmd('VimLeave', {
	command = 'set guicursor= | call chansend(v:stderr, "\x1b[ q")',
	group = user_group
})

