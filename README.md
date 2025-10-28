# `rr.nvim` (recursive replace to neovim)

![](https://s7.ezgif.com/tmp/ezgif-762893fa6927f3.gif)

`rr.nvim` is a Neovim plugin that brings the functionality of [rr](https://github.com/KiamMota/rr) directly into Neovim in a simple and seamless way. (`rr` itself is a separate C++ project also developed by me, which you can obtain [here](https://github.com/KiamMota/rr)).

This plugin allows you to use `rr` as a command-line tool inside Neovim, supporting all the same arguments you would normally pass to RR in the terminal.

Additionally, `rr.nvim` provides convenient keymaps for quick replacements:

- `<leader>rl` → Replace Local (within the current buffer)  
- `<leader>rg` → Replace Global (within the buffer's directory)  
- `<leader>rgv` → Replace Global Recursive (within the buffer's directory and all subdirectories)

# Installation

Installing the plugin is very easy: simply place the rrnvim.lua file inside your lua/ directory in Neovim and use on `init.lua`:
``` lua
require("rrnvim").setup()
```

# Keymap Customization

You can also override the default keymaps by passing your own values to `setup()`:

``` lua
require("rrnvim").setup({
    replace_local = "<leader>sl",           -- overrides the default <leader>rl
    replace_global = "<leader>sg",          -- overrides the default <leader>rg
    replace_global_recursive = "<leader>sv" -- overrides the default <leader>rgv
})

```


