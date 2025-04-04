# search-this.nvim
Easily search the web via any provider from Neovim.

Searching is possible with a visual selection or a manual entry from normal mode.

## Notes
Feel free to open issues/PRs if you face any problems or want to add improvements.

I liked the idea of being able to initiate a web search for docs or a general question on a specific site/search engine from inside Neovim.

I made this as a personal plugin but I hope someone else will find it useful :)

## Install
Lazy:
```lua
"jamesukiyo/search-this.nvim",
name = "search-this",
config = function()
    require("search-this").setup()
end
```

## Options
Pick a default search provider with the `default_engine` option followed by it's name (default is "google")
You can configure your own providers in the following format. The shortname is used when specifying a provider in the search prompt (see below).

```lua
config = function()
    require("search-this").setup({
        default_engine = "google",
        engines = {
            google = {
                url = "https://www.google.com/search?q=",
                shortname = "g"
            },
        }
    })
end
```

A default mapping is assigned to `<leader>st` (think "search this") in visual and normal mode.
If you want to change it:
```lua
vim.api.nvim_set_keymap("v", "<your_remap>", ":SearchThis<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<your_remap>", ":SearchThisNormal<CR>", { noremap = true, silent = true })
```

By default, the following search providers are included. You can overwrite them in the setup by reusing the names.
```lua
engines = {
    google = { url = "https://www.google.com/search?q=", shortname = "g" },
    stackoverflow = { url = "https://stackoverflow.com/search?q=", shortname = "s" },
    github = { url = "https://github.com/search?q=", shortname = "gh" },
    docs = { url = "https://devdocs.io/#q=", shortname = "d" },
    ddg = { url = "https://duckduckgo.com/?q=", shortname = "ddg" },
    tailwind = { url = "https://tailwindcss.com/docs/search?q=", shortname = "tw" },
    mdn = { url = "https://developer.mozilla.org/en-US/search?q=", shortname = "mdn" },
    react = { url = "https://react.dev/search?query=", shortname = "react" },
    vue = { url = "https://vuejs.org/v2/api/?q=", shortname = "vue" },
    svelte = { url = "https://svelte.dev/search#q=", shortname = "svelte" },
}
```

## Usage

There are 2 ways to use the plugin, in visual and normal mode.

Visual:
- Make a visual selection
- Press the mapping (`<leader>st` by default) or run `:SearchThis<CR>`
- A prompt will appear with the selected text where you can then adjust it
- Optionally, add a @{shortname} to the end e.g. `something I selected @ddg` to use a different provider than the default for this search
- Press enter and your default browser should open a tab with the search

Normal:
- Press the mapping (`<leader>st` by default) or run `:SearchThisNormal<CR>`
- A prompt will appear where you can enter your desired search
- Optionally, add a @{shortname} to the end e.g. `my search @ddg` to use a different provider than the default for this search
- Press enter and your default browser should open a tab with the search

## Improvements and Ideas
- ~~Make it possible to search without a visual selection quickly~~
- Search with filetype context (e.g. prefix search with filetype)
- Select search provider based on filetype
- Allow mappings for other providers rather than having to specify with @
- Add video or gif showing features

## License MIT
