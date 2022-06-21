local M = {}

local nerd_font_data = require("icon-picker.icons.nf-icon-list")
local emoji_data = require("icon-picker.icons.emoji-list")
local alt_font_data = require("icon-picker.icons.alt-fonts")
local symbols_data = require("icon-picker.icons.symbol-list")

local item_list = {}

-- Push Item Functions{{{
local function push_emojis()
	for _, value in pairs(emoji_data) do
		table.insert(item_list, value)
	end
end

local function push_nerd_fonts()
	for key, value in pairs(nerd_font_data) do
		table.insert(item_list, value .. " " .. key)
	end
end

local function push_alt_font()
	for _, item in ipairs(alt_font_data) do
		table.insert(item_list, item[1] .. "  " .. item[2])
	end
end

local function push_symbols()
	for _, item in ipairs(symbols_data) do
		table.insert(item_list, item[1] .. "  " .. item[2])
	end
end --}}}

-- vim.ui.select Functions{{{
local function insert_user_choice_normal(choice)
	if choice then
		local split = vim.split(choice, " ")

		--> without vim.schedule it won't exit to normal mode
		vim.schedule(function()
			vim.cmd("norm! a" .. split[1] .. "")
		end)
	end
end

local function insert_user_choice_insert(choice)
	if choice then
		local split = vim.split(choice, " ")

		vim.cmd("norm! i" .. split[1])

		vim.schedule(function()
			local key = vim.api.nvim_replace_termcodes("<Right>", true, true, true)
			vim.api.nvim_feedkeys(key, "i", false)
		end)
	end
end

local function custom_ui_select(items, prompt, callback)
	vim.ui.select(items, {
		prompt = prompt,
	}, callback)
end --}}}

-- Commands for Normal Mode{{{
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
vim.api.nvim_create_user_command("PickSymbols", function()
	item_list = {}
	push_symbols()
	custom_ui_select(item_list, "Pick a Symbol", insert_user_choice_normal)
end, {})
vim.api.nvim_create_user_command("PickAltFont", function()
	item_list = {}
	push_alt_font()
	custom_ui_select(item_list, "Pick an Alt Font Character", insert_user_choice_normal)
end, {})
vim.api.nvim_create_user_command("PickAltFontAndSymbols", function()
	item_list = {}
	push_symbols()
	push_alt_font()
	custom_ui_select(item_list, "Pick Alt Font Character or Symbol", insert_user_choice_normal)
end, {}) --}}}

-- Commands for Insert Mode{{{
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
vim.api.nvim_create_user_command("PickSymbolsInsert", function()
	item_list = {}
	push_symbols()
	custom_ui_select(item_list, "Pick a Symbol", insert_user_choice_insert)
end, {})
vim.api.nvim_create_user_command("PickAltFontInsert", function()
	item_list = {}
	push_alt_font()
	custom_ui_select(item_list, "Pick an Alt Font Character", insert_user_choice_insert)
end, {})
vim.api.nvim_create_user_command("PickAltFontAndSymbolsInsert", function()
	item_list = {}
	push_symbols()
	push_alt_font()
	custom_ui_select(item_list, "Pick Alt Font Character or Symbol", insert_user_choice_insert)
end, {}) --}}}

return M

-- vim: foldmethod=marker foldmarker={{{,}}} foldlevel=0
