local ICON_TYPE = { "alt_font", "emoji", "html_colors", "nerd_font", "symbols", }

local M = {}

local icon_type_data = { --{{{
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
  ["html_colors"] = {
    icons = require("icon-picker.icons.html-colors"),
    spaces = 1,
  },
} --}}}

local list_types = { --{{{
  ["PickAltFont"] = {
    icon_types = { "alt_font" },
    desc = "Pick an Alt Font Character",
  },
  ["PickAltFontAndSymbols"] = {
    icon_types = { "alt_font", "symbols" },
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
    icon_types = ICON_TYPE,
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
  ["PickHTMLColors"] = {
    icon_types = { "html_colors" },
    desc = "Pick an hexa HTML Color",
  },
} --}}}

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

    local current_line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

    if cursor_col + 1 >= #current_line then
      vim.api.nvim_put({ split[1] }, "", true, true)
    else
      vim.api.nvim_put({ split[1] }, "", false, false)
    end

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
end --}}}

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
end -- }}}

--- create list of icons and descriptions for UI and call UI with list {{{
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

-- New API --{{{
function Split(s, delimiter) -- from code grep
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    if #match > 0 then
      table.insert(result, match)
    end
  end
  return result
end

local new_API_table = {
  -- need better variable name
  ["Normal"] = insert_user_choice_normal,
  ["Insert"] = insert_user_choice_insert,
  ["Yank"] = yank_user_choice_normal,
}

-- loops through the table & create user commands
for command, callback in pairs(new_API_table) do
  vim.api.nvim_create_user_command("IconPicker" .. command, function(opts)
    local args = Split(opts.args, " ") -- split command arguments
    local desc = "Pick"

    if #args == 0 then
      args = ICON_TYPE
    end

    local item_list = {}
    for _, argument in ipairs(args) do
      local cur_tbl = icon_type_data[argument]
      if cur_tbl == nil then
        return
      end

      -- push icon results into item_list
      item_list = push_map(cur_tbl["icons"], cur_tbl["spaces"], item_list)
      desc = desc .. " " .. argument
    end

    custom_ui_select(item_list, desc, callback)
  end, {
    nargs = "?",
    complete = function()
      return ICON_TYPE
    end,
  })
end --}}}

-- init all commands (legacy)
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

M.setup = function(opts) --{{{
  if opts.disable_legacy_commands then
    for type, data in pairs(list_types) do
      local status_ok, _ = pcall(vim.api.nvim_del_user_command, type)
      if not status_ok then
        return
      end

      vim.api.nvim_del_user_command(type .. "Insert")
      vim.api.nvim_del_user_command(type .. "Yank")
    end
  end
end --}}}

return M
-- vim: foldmethod=marker foldmarker={{{,}}} foldlevel=0
