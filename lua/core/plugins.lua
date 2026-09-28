-- install plugins
if vim.fn.has("nvim-0.12") == 1 then
	vim.pack.add({
		"https://github.com/f-person/auto-dark-mode.nvim",
		"https://github.com/olimorris/onedarkpro.nvim",
		-- Linux only
		-- "https://github.com/aquaherd/timewarrior.nvim"
	})
	-- else install plugins to ~\AppData\Local\nvim-data\site\pack\plugins\start\
end
-- setup plugins
-- auto-dark-mode.nvim: detects Windows dark/light mode and sets background
local ok, adm = pcall(require, "auto-dark-mode")
if ok then 
	adm.setup({
		update_interval = 3000, -- check every 3 seconds
		set_dark_mode = function()
			vim.o.background = "dark"
		end,
		set_light_mode = function()
			vim.o.background = "light"
		end,
	})
end
local odpok, odp = pcall(require, 'onedarkpro')
if odpok then
	odp.setup({
		options = { transparency = false },
	})
	local function apply_theme()
		local ok, err = pcall(function()
			if vim.o.background == 'dark' then
				vim.cmd.colorscheme('onedark')
			else
				vim.cmd.colorscheme('onelight')
			end
		end)
		if not ok then vim.notify('onedarkpro: ' .. err, vim.log.levels.WARN) end
	end
	apply_theme()
	vim.api.nvim_create_autocmd('OptionSet', {
		pattern = 'background',
		callback = apply_theme,
	})
end

