# bottomline.nvim
**Yet another neovim statusline**

A simple minimal statusline plugin that supports
- gitsigns
- LSP
- winbar

![Demo image](https://github.com/mnjm/github-media-repo/blob/6a351736a158012ff40b008895c2a308e5aa4bdb/bottomline.nvim/1.png)
![Demo image](https://github.com/mnjm/github-media-repo/blob/6a351736a158012ff40b008895c2a308e5aa4bdb/bottomline.nvim/2.png)

- Checkout [topline.nvim](https://github.com/mnjm/topline.nvim) for tabline plugin

## Installation

```lua
'mnjm/bottomline.nvim'
```
Install with your favorite plugin manager

Dependencies - Optional
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

## Configurations

### Default configurations

```lua
highlights = {
    {'BLFill',          {fg = "#ffffff", bg="#282828", bold = false}},
    {'BLNormalMode',    {fg = "#000000", bg="#5faf00", bold = true}},
    {'BLReplaceMode',   {fg = "#000000", bg="#d7875f", bold = true}},
    {'BLCommandMode',   {fg = "#000000", bg="#ffaf00", bold = true}},
    {'BLInsertMode',    {fg = "#000000", bg="#5fafd7", bold = true}},
    {'BLVisualMode',    {fg = "#000000", bg="#ff5faf", bold = true}},
    {'BLUnknownMode',   {fg = "#000000", bg="#b3684f", bold = true}},
    {'BLTrail',         {fg = "#ffffff", bg="#585858", bold = false}},
    {'BLOtherInfo',     {fg = "#000000", bg="#5f8787", bold = false}},
    {'BLFileInfo',      {fg = "#000000", bg="#00afaf", bold = true}},
},
enable_git = true,
enable_lsp = true,
enable_winbar = true,
display_buf_no = false,
git_symbols = {
    branch = "",
    added = "+",
    removed = "-",
    changed = "~",
},
lsp_symbols = {
    error = "Err",
    warn = "Wrn",
    info = "Info",
    hint = "Hint",
},
```

You can pass custom configurations to setup call, for ex

```lua
require('bottomline.nvim').setup({
    highlights = {
        {'BLNormalMode',    {fg = "#000000", bg="#5faf00", bold = true}},
        {'BLVisualMode',    {fg = "#000000", bg="#ff5faf", bold = true}},
    },
    enable_lsp = false,
    display_buf_no = true,
    git_symbols = { branch = "" },
})
```

## Addendum
This work is derived from
- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
- https://elianiva.my.id/post/neovim-lua-statusline

