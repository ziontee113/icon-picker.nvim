local type_data = {
	["nerd_font"] = {
		icons = require("icon-picker.icons.nf-icon-list"),
		spaces = 2,
	},
	["emoji"] = {
		icons = require("icon-picker.icons.emoji-list"),
		spaces = 1,
	},
	["alt_font"] = {
		icons = require("icon-picker.icons.alt-fonts"),
		spaces = 1,
	},
	["symbols"] = {
		icons = require("icon-picker.icons.symbol-list"),
		spaces = 2,
	},
}

local list_types = {
	["Emoji"] = {
		icon_types = { "emoji" },
		desc = "Pick an emoji",
	},
	["Nerd"] = {
		icon_types = { "nerd_font" },
		desc = "Pick a Nerd Font",
	},
	["Icons"] = {
		icon_types = { "emoji", "nerd_font" },
		desc = "Pick an icon",
	},
	["Symbols"] = {
		icon_types = { "symbols" },
		desc = "Pick a Symbol",
	},
	["AltFont"] = {
		icon_types = { "alt_font" },
		desc = "Pick an Alt Font Character",
	},
	["AltFontAndSymbols"] = {
		icon_types = { "symbols", "alt_font" },
		desc = "Pick Alt Font Character or Symbol",
	},
}

-- vim.ui.select functionality {{{
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
end

local callback_tbl = {
	[""] = insert_user_choice_normal,
	["Insert"] = insert_user_choice_insert,
} --}}}

-- list functionality {{{
--- insert a key val pair into a list with an arbitrary amount of spaces
-- @param  map: hash map of pairs to insert into list
-- @param  num_spaces: number of spaces to insert between key and val
local function push_map(map, num_spaces, cur_list)
	local spaces = string.rep(" ", num_spaces)

	for key, val in pairs(map) do
		table.insert(cur_list, table.concat({ val, spaces, key }))
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
		cur_tbl = type_data[type_key]
		item_list = push_map(cur_tbl["icons"], cur_tbl["spaces"], item_list)
	end

	custom_ui_select(item_list, desc, callback)
end -- }}}

-- init all commands
for type, data in pairs(list_types) do
	for _, mode in ipairs({ "", "Insert" }) do
		local cmd_name = table.concat({ "Pick", type, mode })

		vim.api.nvim_create_user_command(cmd_name, function()
			generate_list(data["icon_types"], data["desc"], callback_tbl[mode])
		end, {})
	end
end

-- vim: foldmethod=marker foldmarker={{{,}}} foldlevel=0
