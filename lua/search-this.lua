-- search-this.nvim
-- A Neovim plugin for searching the web
-- Search a visual selection or any manual input
-- Created by: jamesukiyo (GitHub)

local M = {}

-- default config
local default_config = {
	engines = {
		google = {
			url = "https://www.google.com/search?q=",
			shortname = "g",
		},
		stackoverflow = {
			url = "https://stackoverflow.com/search?q=",
			shortname = "s",
		},
		github = {
			url = "https://github.com/search?q=",
			shortname = "gh",
		},
		docs = {
			url = "https://devdocs.io/#q=",
			shortname = "d",
		},
		ddg = {
			url = "https://duckduckgo.com/?q=",
			shortname = "ddg",
		},
		tailwind = {
			url = "https://tailwindcss.com/docs/search?q=",
			shortname = "tw",
		},
		mdn = {
			url = "https://developer.mozilla.org/en-US/search?q=",
			shortname = "mdn",
		},
		react = {
			url = "https://react.dev/search?query=",
			shortname = "react",
		},
		vue = {
			url = "https://vuejs.org/v2/api/?q=",
			shortname = "vue",
		},
		svelte = {
			url = "https://svelte.dev/search#q=",
			shortname = "svelte",
		},
	},
	default_engine = "google",
}

local config = {}
local active_engine = nil

-- trim whitespace from string
local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

-- get selected text in visual mode
local function get_visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("'<"))
	local _, le, ce = unpack(vim.fn.getpos("'>"))
	local lines = vim.fn.getline(ls, le)

	if #lines == 0 then
		return ""
	end
	lines[#lines] = string.sub(lines[#lines], 1, ce)
	lines[1] = string.sub(lines[1], cs)

	return trim(table.concat(lines, "\n"))
end

-- encode text for URL
local function url_encode(str)
	if str then
		str = str:gsub("[^%w%-_%.~]", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
	end
	return str
end


-- open URL in default browser
local function open_url(url)
	local cmd =
		vim.fn.has("win32") == 1
		and ('start "" "' .. url .. '"')
		or vim.fn.has("mac") == 1
		and ('open "' .. url .. '"')
		or ('xdg-open "' .. url .. '"')

	vim.fn.system(cmd)
end

-- search for visual selection
function M.search()
	local selection = get_visual_selection()

	if selection == "" then
		vim.api.nvim_err_writeln("No valid text selected.")
		return
	end

	local search_text = vim.fn.input("Search: ", selection)
	search_text = trim(search_text)
	if search_text == "" then
		return
	end

	local engine_name = active_engine or config.default_engine
	local engine_override = search_text:match("@(%w+)$")

	if engine_override then
		search_text = search_text:gsub("@%w+$", "")
		search_text = trim(search_text)

		local found_engine = false
		for name, engine in pairs(config.engines) do
			if engine.shortname == engine_override then
				engine_name = name
				found_engine = true
				break
			end
		end

		if not found_engine then
			vim.api.nvim_err_writeln("Invalid engine shortname: " .. engine_override)
			return
		end
	end

	local engine = config.engines[engine_name]
	if not engine then
		vim.api.nvim_err_writeln("Invalid search engine: " .. engine_name)
		return
	end

	local url = engine.url .. url_encode(search_text)
	open_url(url)
end

-- search for normal mode
function M.search_normal()
	local search_text = vim.fn.input("Search: ")
	search_text = trim(search_text)
	if search_text == "" then
		return
	end

	local engine_name = active_engine or config.default_engine
	local engine_override = search_text:match("@(%w+)$")

	if engine_override then
		search_text = search_text:gsub("@%w+$", "")
		search_text = trim(search_text)

		local found_engine = false
		for name, engine in pairs(config.engines) do
			if engine.shortname == engine_override then
				engine_name = name
				found_engine = true
				break
			end
		end

		if not found_engine then
			vim.api.nvim_err_writeln("Invalid engine shortname: " .. engine_override)
			return
		end
	end

	local engine = config.engines[engine_name]
	if not engine then
		vim.api.nvim_err_writeln("Invalid search engine: " .. engine_name)
		return
	end

	local url = engine.url .. url_encode(search_text)
	open_url(url)
end

-- setup
function M.setup(user_config)
	config = vim.tbl_deep_extend("force", default_config, user_config or {})
	active_engine = config.default_engine

	vim.api.nvim_create_user_command("SearchThis", M.search, { range = true, desc = "Search selected text" })
	vim.api.nvim_create_user_command("SearchThisNormal", M.search_normal, { desc = "Search for anything in normal mode" })

	vim.api.nvim_set_keymap("v", "<leader>st", ":SearchThis<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<leader>st", ":SearchThisNormal<CR>", { noremap = true, silent = true })
end

return M
