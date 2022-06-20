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

local function insert_user_choice_normal(choice)
	local split = vim.split(choice, " ")

	--> without vim.schedule it won't exit to normal mode
	vim.schedule(function()
		vim.cmd("norm! i" .. split[1] .. "")
	end)
end
local function insert_user_choice_insert(choice)
	if choice then
		local split = vim.split(choice, " ")

		vim.cmd("norm! a" .. split[1])
		local key = vim.api.nvim_replace_termcodes("<Right>", true, true, true)
		vim.api.nvim_feedkeys(key, "i", false)
	end
end

local function custom_ui_select(items, prompt, callback)
	vim.ui.select(items, {
		prompt = prompt,
	}, callback)
end

-- Commands for Normal Mode
vim.api.nvim_create_user_command("PickEmoji", function()
	item_list = {}
	push_emojis()
	custom_ui_select(item_list, "Pick an emoji", insert_user_choice_normal)
end, {})
vim.api.nvim_create_user_command("PickNerd", function()
	item_list = {}
	push_nerd_fonts()
	custom_ui_select(item_list, "Pick a Nerd Font", insert_user_choice_normal)
end, {})
vim.api.nvim_create_user_command("PickIcons", function()
	item_list = {}
	push_emojis()
	push_nerd_fonts()
	custom_ui_select(item_list, "Pick an Icon", insert_user_choice_normal)
end, {})

-- Commands for Insert Mode
vim.api.nvim_create_user_command("PickEmojiInsert", function()
	item_list = {}
	push_emojis()
	custom_ui_select(item_list, "Pick an emoji", insert_user_choice_insert)
end, {})
vim.api.nvim_create_user_command("PickNerdInsert", function()
	item_list = {}
	push_nerd_fonts()
	custom_ui_select(item_list, "Pick a Nerd Font", insert_user_choice_insert)
end, {})
vim.api.nvim_create_user_command("PickIconsInsert", function()
	item_list = {}
	push_emojis()
	push_nerd_fonts()
	custom_ui_select(item_list, "Pick an Icon", insert_user_choice_insert)
end, {})

return M
