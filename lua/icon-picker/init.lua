local icon_type_data = {
	["alt_font"] = {
		icons = require("icon-picker.icons.alt-fonts"),
		spaces = 1,
	},
	["emoji"] = {
		icons = require("icon-picker.icons.emoji-list"),
		spaces = 1,
	},
	["nerd_font"] = {
		icons = require("icon-picker.icons.nf-icon-list"),
		spaces = 2,
	},
	["symbols"] = {
		icons = require("icon-picker.icons.symbol-list"),
		spaces = 2,
	},
}

local list_types = {
	["PickAltFont"] = {
		icon_types = { "alt_font" },
		desc = "Pick an Alt Font Character",
	},
	["PickAltFontAndSymbols"] = {
		icon_types = { "symbols", "alt_font" },
		desc = "Pick Alt Font Characters & Symbols",
	},
	["PickEmoji"] = {
		icon_types = { "emoji" },
		desc = "Pick an emoji",
	},
	["PickIcons"] = {
		icon_types = { "emoji", "nerd_font" },
		desc = "Pick an Emoji & Nerd Font Icons",
	},
	["PickEverything"] = {
		icon_types = { "emoji", "nerd_font", "alt_font", "symbols" },
		desc = "Pick an icon",
	},
	["PickNerd"] = {
		icon_types = { "nerd_font" },
		desc = "Pick a Nerd Font",
	},
	["PickSymbols"] = {
		icon_types = { "symbols" },
		desc = "Pick a Symbol",
	},
}

-- vim.ui.select functionality {{{
local function insert_user_choice_normal(choice)
	if choice then
		local split = vim.split(choice, " ")

		vim.api.nvim_put({ split[1] }, "", false, true)
	end
end

local function insert_user_choice_insert(choice)
	if choice then
		local split = vim.split(choice, " ")

		vim.api.nvim_put({ split[1] }, "", true, true)
		vim.api.nvim_feedkeys("a", "t", false)
	end
end

local function yank_user_choice_normal(choice)
	if choice then
		local split = vim.split(choice, " ")

		vim.schedule(function()
			vim.cmd("let @+='" .. split[1] .. "'")
		end)
	end
end

local function custom_ui_select(items, prompt, callback)
	vim.ui.select(items, {
		prompt = prompt,
	}, callback)
end

--}}}

-- list functionality {{{
--- insert a key val pair into a list with an arbitrary amount of spaces
-- @param  map: hash map of pairs to insert into list
-- @param  num_spaces: number of spaces to insert between key and val
local function push_map(map, num_spaces, cur_list)
	local spaces = string.rep(" ", num_spaces)

	for key, val in pairs(map) do
		table.insert(cur_list, table.concat({ val, key }, spaces))
	end

	return cur_list
end

--- create list of icons and descriptions for UI and call UI with list
-- @param  keys: array table of icon list key names
-- @param  desc: description of picker functionality, e.g. "Pick an emoji"
-- @param  callback: user input callback function
local function generate_list(keys, desc, callback)
	local cur_tbl
	local item_list = {}

	for _, type_key in ipairs(keys) do
		cur_tbl = icon_type_data[type_key]
		item_list = push_map(cur_tbl["icons"], cur_tbl["spaces"], item_list)
	end

	custom_ui_select(item_list, desc, callback)
end -- }}}

-- init all commands
for type, data in pairs(list_types) do
	vim.api.nvim_create_user_command(type, function()
		generate_list(data["icon_types"], data["desc"], insert_user_choice_normal)
	end, {})

	vim.api.nvim_create_user_command(type .. "Yank", function()
		generate_list(data["icon_types"], data["desc"], yank_user_choice_normal)
	end, {})

	vim.api.nvim_create_user_command(type .. "Insert", function()
		generate_list(data["icon_types"], data["desc"], insert_user_choice_insert)
	end, {})
end

-- vim: foldmethod=marker foldmarker={{{,}}} foldlevel=0
