# icon-picker.nvim

icon-picker.nvim is a Neovim plugin that helps you pick 𝑨𝕃𝚻 Font Characters, Symbols Σ, Nerd Font Icons  & Emojis ✨

https://user-images.githubusercontent.com/102876811/174574267-d38861f2-cd11-416f-81b8-93ff115fe6b5.mp4

https://user-images.githubusercontent.com/102876811/174574279-37d4dc95-3fa3-41e2-881c-4c89860bbe22.mp4

![Pick Symbol Screenshot](https://user-images.githubusercontent.com/102876811/174749829-de1f8ab6-bd5a-4c5e-87db-78c3b5c96d49.png)

![Alt Font Screenshot](https://user-images.githubusercontent.com/102876811/174749842-4802bd94-d517-4e53-942a-53351646f5cc.png)

# Installation

#### This plugin utilizes `vim.ui.select()`, so you're gonna need something like [dressing.nvim](https://github.com/stevearc/dressing.nvim) and a fuzzy finder like [Telescope](https://github.com/nvim-telescope/telescope.nvim) or [fzf-lua](https://github.com/ibhagwan/fzf-lua)

For Packer

```lua
use "stevearc/dressing.nvim"
use({
  "ziontee113/icon-picker.nvim",
  config = function()
    require("icon-picker").setup({
      disable_legacy_commands = true
    })
  end,
})
```

For Vim Plug

```
Plug 'stevearc/dressing.nvim'
Plug 'ziontee113/icon-picker.nvim'

lua << EOF
require("icon-picker").setup({ disable_legacy_commands = true })
EOF
```

# Usage

### Sample Config (new):

```lua
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader><Leader>i", "<cmd>IconPickerNormal<cr>", opts)
vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
```

#### Available Commands:

- `IconPickerNormal` - Pick Icon and insert it to the buffer (normal mode)
- `IconPickerInsert` - Pick Icon and insert it to the buffer (insert mode)
- `IconPickerYank` - Pick Icon and yank it to register (will not input to buffer)

You can cherry pick the Icon source to your preference using arguments, for example:

```
:IconPickerInsert alt_font symbols
:IconPickerInsert nerd_font emoji
:IconPickerInsert nerd_font
:IconPickerInsert emoji nerd_font alt_font symbols
```

Available arguments for the `IconPicker` commands:

- alt_font
- emoji
- html_colors
- nerd_font
- symbols

I personally use `<C-i>` for `IconPickerInsert`. If you also want to map `<C-I>` and can't do it, you can check out my quick guide to solve that on YouTube: [Enable Special Keyboard Combinations in Alacritty / Kitty for Neovim](https://www.youtube.com/watch?v=lHBD6pdJ-Ng)

#### Sample Config (legacy):

<details>

```lua
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader><Leader>i", "<cmd>PickEverything<cr>", opts)
vim.keymap.set("n", "<Leader><Leader>y", "<cmd>PickEverythingYank<cr>", opts)
vim.keymap.set("i", "<C-i>", "<cmd>PickEverythingInsert<cr>", opts)
```

#### Available Commands:

- Normal Mode:
  - `PickEverything` (Nerd Font Icons & Emojis & Alt Font & Symbols)
  - `PickIcons` (Nerd Font Icons & Emojis)
  - `PickEmoji`
  - `PickNerd`
  - `PickSymbols`
  - `PickAltFont`
  - `PickAltFontAndSymbols`
- Normal Mode (yank):
  These commands will Yank the selected icon into register
  - `PickEverythingYank` (Nerd Font Icons & Emojis & Alt Font & Symbols)
  - `PickIconsYank` (Nerd Font Icons & Emojis)
  - `PickEmojiYank`
  - `PickNerdYank`
  - `PickSymbolsYank`
  - `PickAltFontYank`
  - `PickAltFontAndSymbolsYank`
- Insert Mode:
  - `PickEverythingInsert` (Nerd Font Icons & Emojis & Alt Font & Symbols)
  - `PickIconsInsert` (Nerd Font Icons & Emojis)
  - `PickEmojiInsert`
  - `PickNerdInsert`
  - `PickSymbolsInsert`
  - `PickAltFontInsert`
  - `PickAltFontAndSymbolsInsert`

You can use `:help ` to see the details for any of those commands.
Example: `:help PickAltFont`

</details>

## Todo:

Fine tune the Insert Mode experience.

## Feedback

If you run into issues or come up with an awesome idea, please feel free to open an issue or PR.

## Special Thanks To

### [@mcauley-penney](https://github.com/mcauley-penney) for the amazing [#3](https://github.com/ziontee113/icon-picker.nvim/pull/3) :fire:

### [@logan-connolly](https://github.com/logan-connolly) for adding Yank commands [#7](https://github.com/ziontee113/icon-picker.nvim/pull/7) :thumbsup:

### [@KaminoU](https://github.com/KaminoU) for adding HTML Color Picker [#14](https://github.com/ziontee113/icon-picker.nvim/pull/14) :thumbsup:

## License

The project is licensed under MIT license. See [LICENSE](./LICENSE) file for details.
