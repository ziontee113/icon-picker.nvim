# icon-picker.nvim

This is a Neovim plugin that helps you pick Nerd Font Icons &amp; Emojis ✨

https://user-images.githubusercontent.com/102876811/174574267-d38861f2-cd11-416f-81b8-93ff115fe6b5.mp4

https://user-images.githubusercontent.com/102876811/174574279-37d4dc95-3fa3-41e2-881c-4c89860bbe22.mp4

# Installation

#### This plugin utilizes `vim.ui.select()`, so you're gonna need something like [dressing.nvim](https://github.com/stevearc/dressing.nvim) and a fuzzy finder like [Telescope](nvim-telescope/telescope.nvim).

For Packer

```lua
use "stevearc/dressing.nvim"
use({
  "ziontee113/icon-picker.nvim",
  config = function()
    require("icon-picker")
  end,
})
```

# Usage

#### Sample Config:

```lua
local opts = { noremap = true, silent = true }

vim.keymap.set("i", "<C-i>", "<cmd>PickIconsInsert<cr>", opts)
vim.keymap.set("n", "<Leader><Leader>i", "<cmd>PickIcons<cr>", opts)
```
I personally use `<C-i>` for `PickIconsInsert`. If you also want to map `<C-I>` and can't do it, you can check out my quick guide to solve that on YouTube: [Enable Special Keyboard Combinations in Alacritty / Kitty for Neovim](https://www.youtube.com/watch?v=lHBD6pdJ-Ng)

#### Available Commands:

- Normal Mode:
  - `PickIcons`
  - `PickEmoji`
  - `PickNerd`
- Insert Mode:
  - `PickIconsInsert`
  - `PickEmojiInsert`
  - `PickNerdInsert`

## Todo

- Deal with the crazy Emojis that are not working properly in Terminals (either find a solution or disable them completely)
- Add ASCII Symbols as one of the sources.

## Feedback

If you run into issues or come up with an awesome idea, please feel free to open an issue or PR.

## License

The project is licensed under MIT license. See [LICENSE](./LICENSE) file for details.
