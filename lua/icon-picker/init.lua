local M = {}

local nerd_font_data = require("icon-picker.icons.nf-icon-list")
local emoji_data = require("icon-picker.icons.emoji-list")

local item_list = {}

local function push_emojis()
	-- get data for Emoji
	for _, value in pairs(emoji_data) do
		table.insert(item_list, value)
	end
end

local function push_nerd_fonts()
	-- get data for Nerd Fonts
	for key, value in pairs(nerd_font_data) do
		table.insert(item_list, value .. " " .. key)
	end
end

vim.api.nvim_create_user_command("PickEmoji", function()
	item_list = {}
	push_emojis()

	vim.ui.select(item_list, {
		prompt = "Emoji Picker",
	}, function(choice)
		if choice then
			print("I chose " .. choice)
		end
	end)
end, {})
vim.api.nvim_create_user_command("PickNerd", function()
	item_list = {}
	push_nerd_fonts()

	vim.ui.select(item_list, {
		prompt = "Nerd Font Icon Picker Picker",
	}, function(choice)
		if choice then
			print("I chose " .. choice)
		end
	end)
end, {})
vim.api.nvim_create_user_command("PickIcons", function()
	item_list = {}
	push_emojis()
	push_nerd_fonts()

	vim.ui.select(item_list, {
		prompt = "Emojis & Nerd Font Picker",
	}, function(choice)
		if choice then
			print("I chose " .. choice)
		end
	end)
end, {})

return M
