--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Set default folding method to 'indent' for VS Code like folding
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 1
vim.opt.foldenable = false -- Start with all folds open

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- vim.keymap.set("n", "<leader>e", "<cmd>e .<CR>", { desc = "[E]xplore current directory" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Example keymaps for creating splits
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>h", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- ADDED: Keymap for :Explore (netrw/neo-tree)
vim.keymap.set("n", "<leader>ex", "<cmd>Explore<CR>", { desc = "Open file explorer (netrw/:Explore)" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "[B]uffer [N]ew (empty)" })
vim.keymap.set("n", "<leader>bs", "<cmd>new<CR>", { desc = "[B]uffer [S]plit (empty)" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Autocommand for folding: open folds on BufEnter, then close based on indent
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("kickstart-folding", { clear = true }),
	callback = function()
		vim.opt.foldenable = true -- Enable folding when entering a buffer
		vim.opt.foldlevel = 99 -- Open all folds by default
		-- You might want to adjust foldlevel based on filetype or specific needs
	end,
})

-- ADDED: Open file explorer (netrw, or neo-tree if hijacking) on startup if no file is specified
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("kickstart-open-explorer-on-startup", { clear = true }),
	callback = function()
		-- Check if Neovim was started with a file argument
		-- and if the current buffer is the initial empty, normal buffer
		if vim.fn.argc() == 0 and vim.fn.bufname() == "" and vim.bo.buftype == "" then
			-- If neo-tree is hijacking netrw, :Explore will open neo-tree.
			-- Otherwise, it will open the built-in netrw.
			vim.cmd("Explore")
		end
	end,
	desc = "Open file explorer on startup if no file is specified and buffer is normal",
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies are already met by your existing config (nvim-treesitter, mini.nvim)
		-- You can explicitly list them if you prefer:
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
		ft = { "markdown" }, -- Ensures it loads for markdown files
		opts = {}, -- Uses default configuration
	},
	{
		"3rd/image.nvim",
		ft = { "png", "jpg", "jpeg", "gif", "webp" }, -- Load when opening these image filetypes
		opts = {
			backend = "chafa", -- Use chafa for rendering
			integrations = {
				markdown = {
					enabled = true, -- THIS WILL ATTEMPT TO RENDER IMAGES IN MARKDOWN FILES
					clear_in_insert_mode = false,
					download_remote_images = true,
					refresh_markdown_on_insert = true,
					filetypes = { "markdown" }, -- Specify filetypes for this integration
				},
				telescope = { -- If you use Telescope and want media previews
					enabled = true,
				},
				-- If you decide to use neo-tree.nvim again, you can enable its integration:
				-- neotree = {
				--   enabled = true,
				-- },
			},
			max_width_window_percentage = 0.7, -- e.g., image uses max 70% of window width
			max_height_window_percentage = 0.6, -- e.g., image uses max 60% of window height
			chafa_options = {
				symbols = "block,half,ascii,space", -- Experiment with chafa symbols
				-- You can add other chafa flags here, e.g.:
				-- fill = "all",
				-- size = "60x", -- e.g., 60 columns wide, auto height. nil for auto.
			},
		},
		config = function(_, opts)
			require("image").setup(opts)
		end,
	},
	-- {
	-- 	"github/copilot.vim",
	-- 	event = "InsertEnter", -- Load when you enter insert mode
	-- 	config = function()
	-- 		-- Ensure Copilot is enabled
	-- 		vim.g.copilot_enabled = 1
	--
	-- 		-- IMPORTANT: Disable the Copilot panel/window to focus on inline suggestions
	-- 		vim.g.copilot_panel_enabled = 0
	--
	-- 		-- Map Tab to accept the current Copilot suggestion
	-- 		-- This uses an `expr` mapping. copilot#Accept('<Tab>') is designed to:
	-- 		-- 1. Accept the suggestion if one is available. It might return an empty string
	-- 		--    (if it just accepts and consumes the Tab) or specific characters to insert.
	-- 		-- 2. Return the literal string "<Tab>" if no suggestion is active, allowing Tab
	-- 		--    to perform its default action or be used by another plugin (like nvim-cmp,
	-- 		--    though your current nvim-cmp config doesn't use Tab for completion).
	-- 		vim.keymap.set("i", "<Tab>", function()
	-- 			return vim.fn["copilot#Accept"]("<Tab>")
	-- 		end, {
	-- 			expr = true,
	-- 			silent = true,
	-- 			noremap = true, -- Essential to prevent recursion if "<Tab>" is returned
	-- 			desc = "Copilot: Accept Suggestion",
	-- 		})
	--
	-- 		-- Map Ctrl+I to show the next Copilot suggestion (or trigger one if available)
	-- 		-- This uses the <Plug> mapping provided by copilot.vim, which handles cycling
	-- 		-- through available inline suggestions or fetching one.
	-- 		-- Note: In some terminals, Ctrl+I sends the same code as Tab. If you find
	-- 		--       Ctrl+I behaving like Tab, your terminal might be the cause.
	-- 		--       Neovim can usually distinguish them if the terminal sends distinct codes.
	-- 		vim.keymap.set("i", "<C-I>", "<Plug>(copilot-next)", {
	-- 			silent = true,
	-- 			noremap = true,
	-- 			desc = "Copilot: Next Suggestion / Trigger",
	-- 		})
	--
	-- 		-- As a good practice with Copilot, you might also want a key to dismiss a suggestion
	-- 		-- For example, mapping Ctrl+E to dismiss:
	-- 		-- vim.keymap.set("i", "<C-E>", "<Plug>(copilot-dismiss)", { silent = true, noremap = true, desc = "Copilot: Dismiss Suggestion" })
	--
	-- 		-- Remember to run :Copilot setup or :Copilot auth the first time
	-- 		-- to authenticate with your GitHub account after installing the plugin.
	-- 	end,
	-- },
	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
	--

	-- Alternatively, use `config = function() ... end` for full control over the configuration.
	-- If you prefer to call `setup` explicitly, use:
	--    {
	--        'lewis6991/gitsigns.nvim',
	--        config = function()
	--            require('gitsigns').setup({
	--                -- Your gitsigns configuration here
	--            })
	--        end,
	--    }
	-- Insert this block within the require("lazy").setup({ ... }) table
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	branch = "v3.x", -- Use the latest stable release branch
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	-- 		"MunifTanjim/nui.nvim",
	-- 		-- "3rd/image.nvim", -- OPTIONAL: Required for image previews
	-- 	},
	-- 	config = function()
	-- 		-- Set neo-tree options here if desired
	-- 		-- See :help neo-tree-configuration
	-- 		require("neo-tree").setup({
	-- 			-- close_floats_on_escape_key = true, -- Close floats with <Esc>
	-- 			-- close_windows_on_escape_key = true, -- Close neo-tree window with <Esc>
	-- 			window = {
	-- 				position = "left", -- "left", "right", "float", "current"
	-- 				width = 30, -- Width of the window
	-- 				mappings = {
	-- 					-- Add/modify key Fbindings here if needed
	-- 					-- Example:
	-- 					-- ['<space>'] = "none" -- Disable a default mapping
	-- 				},
	-- 			},
	-- 			filesystem = {
	-- 				hijack_netrw_behavior = "open_current", -- Make Neo-tree handle :edit . etc.
	-- 				follow_current_file = {
	-- 					enabled = true, -- Automatically follow the current file in the tree
	-- 				},
	-- 				filtered_items = {
	-- 					visible = true, -- show hidden files by default
	-- 					hide_dotfiles = false,
	-- 					hide_gitignored = true,
	-- 				},
	-- 				-- Add other filesystem options here
	-- 			},
	-- 			-- Commented out the problematic event_handlers section
	-- 			-- event_handlers = {
	-- 			-- 	{
	-- 			-- 		event = "neo_tree_window_after_open",
	-- 			-- 		handler = function(args)
	-- 			-- 			-- make sure we’re in that tree window
	-- 			-- 			vim.api.nvim_set_current_win(args.tree_win_id)
	-- 			-- 			-- exit any insert state
	-- 			-- 			vim.cmd("stopinsert")
	-- 			-- 			-- jump to top of buffer
	-- 			-- 			vim.cmd("normal! gg")
	-- 			-- 		end,
	-- 			-- 	},
	-- 			-- },
	-- 			-- Add other setup options from neo-tree documentation if needed
	-- 		})
	--
	-- 		-- Keymap to toggle Neo-tree
	-- 		vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Explorer NeoTree (toggle)" })
	-- 		-- Keymap to focus Neo-tree if it's open, or open it
	-- 		vim.keymap.set("n", "<leader>E", "<cmd>Neotree focus<CR>", { desc = "Explorer NeoTree (focus/open)" })
	-- 		-- Keymap to reveal the current file in Neo-tree
	-- 		vim.keymap.set("n", "<leader>ef", "<cmd>Neotree reveal<CR>", { desc = "Explorer NeoTree (reveal file)" })
	-- 	end,
	-- },
	-- End of neo-tree block--
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" }, -- Load plugin only when needed
		-- IMPORTANT: This plugin requires nodejs and either npm or yarn installed on your system
		-- for the build step and to run the local preview server.
		-- If preview isn't working, ensure these are installed and then run `:Lazy clean` and `:Lazy install`
		-- or `:Lazy build markdown-preview.nvim` within Neovim.
		build = "call mkdp#util#install()", -- Runs the install script after plugin update/install
		config = function()
			-- Optional: You can add configuration here if needed later.
			-- For example, to enable it for other filetypes:
			-- vim.g.mkdp_filetypes = { "markdown", "vimwiki" }

			-- Or set a different theme (requires appropriate CSS on your system or web)
			-- vim.g.mkdp_theme = 'dark' -- 'dark' or 'light' are built-in

			-- See plugin documentation for more options:
			-- https://github.com/iamcco/markdown-preview.nvim#options
		end,
	},
	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`.
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Add `numToStr/Comment.nvim` for comment toggling
	{
		"numToStr/Comment.nvim",
		keys = {
			{
				"gc",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				mode = { "n", "v" },
				desc = "[G]eneric [C]omment Toggle Linewise",
			},
			{
				"gb",
				function()
					require("Comment.api").toggle.blockwise.current()
				end,
				mode = { "n", "v" },
				desc = "[G]eneric [B]lock Comment Toggle",
			},
		},
		opts = {}, -- Empty opts, use default setup
	},

	-- Add `nvim-dap` for debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio", -- Required for dap-ui
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim", -- To automatically install debuggers
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				layouts = {
					{
						elements = {
							-- You can change the order of elements here
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40, -- main window
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 0.25, -- output window
						position = "bottom",
					},
				},
				controls = {
					element = "buttons",
					icons = {
						expand = "",
						collapsed = "",
						expanded = "",
						-- For controls.element.buttons
						pause = "",
						play = "",
						step_into = "",
						step_over = "",
						step_out = "",
						step_back = "",
						run_last = "↻",
						terminate = "",
					},
				},
				floating = {
					max_height = nil, -- Floats will be sent to the top by default, so set to nil if you want to use below_cursor
					max_width = nil,
					border = "single", -- 'single' | 'double' | 'rounded' | 'solid' | 'none'
					-- Controls float window placement on the screen
					relative = "editor", -- 'editor' | 'win'
					-- Controls whether the float window should be placed below the cursor (if there are too many lines to show)
					below_cursor = true,
					-- If true, the float window will be displayed at the bottom of the buffer
					-- with no border (the border option will be ignored)
					no_fill = false,
					-- If true, the float window will have a scrollbar
					-- (only works with the 'native' float window option for now)
					no_scrollbar = false,
					-- If true, the float window will wrap around the cursor
					-- when reaching the last line
					wrap = false,
				},
			})

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true, -- creates the DapiToggleVirtualText command
				only_first_virtual_text = false,
				-- this function is used to format the virtual text
				format_value = function(value)
					return value
				end,
				-- how to position the virtual text
				-- can be 'eol' or 'inline'
				-- eol means end of line
				-- inline means next to the variable name
				placement = "eol",
				-- show or hide variables that have a nil value
				show_nil_values = true,
				-- whether to show a space between the variable name and value
				-- set this to false for less verbose virtual text
				virt_text_opts = {},
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Keymaps for debugging
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Set Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
			vim.keymap.set("n", "<leader>dl", function()
				dap.run_last()
			end, { desc = "DAP: Run Last" })
			vim.keymap.set({ "n", "v" }, "<leader>p", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "DAP: Evaluate" })

			-- Auto-install debuggers using mason-nvim-dap
			require("mason-nvim-dap").setup({
				ensure_installed = { "python" }, -- Add Python debugger (debugpy)
				automatic_installation = true,
				handlers = {}, -- use default handlers
			})

			-- Configure debuggers
			-- Python debugger
			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return vim.fn.exepath("python")
					end,
				},
			}
		end,
	},

	-- Add `ahmedkhalf/project.nvim` for project management
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				manual_mode = false,
				detection_methods = { "lsp", "pattern" },
				patterns = { ".git", "Makefile", "package.json", "go.mod" },
				datapath = vim.fn.stdpath("data"),
				exclude_dirs = {},
				ignore_lsp = {},
				scope_chdir = "git_root",
				show_hidden = true,
			})
			-- Keymaps for project.nvim
			vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "[F]ind [P]roject" })
		end,
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		-- "rebelot/kanagawa.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				-- Add groups for new plugins
				{ "<leader>D", group = "[D]ebug" }, -- Capital D to differentiate from document
				{ "<leader>f", group = "[F]ile" },
			},
		},
	},

	-- NOTE: Plugins can specify dependencies.
	--
	-- The dependencies are proper plugin specifications as well - anything
	-- you do for a plugin at the top level, you can do for a dependency.
	--
	-- Use the `dependencies` key to specify the dependencies of a particular plugin

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			{ "nvim-telescope/telescope-file-browser.nvim" },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- Load the extension BEFORE setting up Telescope or keymaps
			pcall(require("telescope").load_extension, "file_browser") -- Load the extension
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					file_browser = {
						-- theme = "ivy", -- Optional: Choose a theme like 'ivy' or 'dropdown'
						-- disables netrw and use telescope-file-browser instead
						hijack_netrw = false, -- Let Neo-tree handle netrw
						mappings = {
							["i"] = {
								-- You can add custom insert mode mappings here if needed later
							},
							["n"] = {
								-- You can add custom normal mode mappings here if needed later
							},
						},
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local fb = require("telescope").extensions.file_browser -- Get extension functions
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Add Command Palette like functionality (similar to Ctrl+Shift+P in VS Code)
			vim.keymap.set("n", "<leader>p", builtin.commands, { desc = "[P]alette (Commands)" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			vim.keymap.set("n", "<leader>sb", function()
				fb.file_browser({
					path = vim.fn.expand("%:p:h"), -- Start in directory of current file
					hijack_netrw = false, -- Ensure this specific call also doesn't hijack netrw
					-- You can add more options here, see :help telescope-file-browser.actions
					-- Example: attach_mappings = function(prompt_bufnr, map)
					--      map("n", "N", fb_actions.create_file) -- Map N in normal mode to create file
					--      return true
					--  end,
				})
			end, { desc = "[S]earch [B]rowser (Telescope)" }) -- Clarified description
		end,
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Brief aside: **What is LSP?**
			--
			-- LSP is an initialism you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- FIX: Updated client_supports_method to directly use the current API
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						return client:supports_method(method, { bufnr = bufnr })
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				clangd = {},
				-- gopls = {},
				pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"clangd",
				"pyright",
				"debugpy", -- For Python debugging
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clangd_client" },
				cpp = { "clangd_client" },
				-- Conform can also run multiple formatters sequentially
				python = { "isort", "black" }, -- Added Python formatters
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					--['<CR>'] = cmp.mapping.confirm { select = true },
					--['<Tab>'] = cmp.mapping.select_next_item(),
					--['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
				},
			})
		end,
	},

	-- THEME CONFIGURATION - CATPPUCCIN
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		-- opts = {
		-- 	flavour = "mocha", -- Or "latte", "frappe", "macchiato"
		-- 	no_italic = true,
		-- 	term_colors = true,
		-- 	transparent_background = false,
		-- 	styles = {
		-- 		comments = {},
		-- 		conditionals = {},
		-- 		loops = {},
		-- 		functions = {},
		-- 		keywords = {},
		-- 		strings = {},
		-- 		variables = {},
		-- 		numbers = {},
		-- 		booleans = {},
		-- 		properties = {},
		-- 		types = {},
		-- 	},
		-- 	color_overrides = {
		-- 		mocha = {
		-- 			base = "#000000",
		-- 			mantle = "#000000",
		-- 			crust = "#000000",
		-- 		},
		-- 	},
		-- 	integrations = {
		-- 		telescope = {
		-- 			enabled = true,
		-- 			style = "nvchad",
		-- 		},
		-- 		-- dropbar = { -- You can enable this if you use nvim-dropbar
		-- 		-- 	enabled = true,
		-- 		-- 	color_mode = true,
		-- 		-- },
		-- 	},
		-- },
		opts = {
			flavour = "mocha", -- Or "latte", "frappe", "macchiato"
			no_italic = true,
			term_colors = true,
			transparent_background = false, -- IMPORTANT: keep false for opaque floats with borders
			styles = { -- These are for syntax elements, not UI borders. Empty uses Catppuccin defaults.
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000", -- Your desired black background for editor
					mantle = "#000000", -- Your desired black background for UI elements like floats
					crust = "#000000", -- Your desired black background for the outermost UI layer
				},
			},
			custom_highlights = function(colors)
				-- `colors` here refers to the Catppuccin palette for the current flavour *after* `color_overrides`.
				-- `colors.mantle` will be #000000.
				-- We pick `colors.surface1` which is #45475A in Mocha and is not overridden.
				-- This will provide a visible border against the #000000 backgrounds.
				local border_fg_color = colors.surface1
				-- If colors.surface1 was also somehow black, you could use a hardcoded color:
				-- local border_fg_color = "#333333" -- A dark grey, visible against black

				return {
					-- Standard Neovim highlight groups for floating windows
					FloatBorder = { fg = border_fg_color },
					NormalFloat = { bg = colors.mantle }, -- Ensures float background uses your overridden mantle

					-- Specific plugin border highlight groups
					TelescopeBorder = { fg = border_fg_color },
					DiagnosticFloatBorder = { fg = border_fg_color }, -- For LSP diagnostic popups
					CmpBorder = { fg = border_fg_color }, -- For nvim-cmp completion menu
					DapUIFloatBorder = { fg = border_fg_color }, -- For DAP UI floats if applicable
					DapUIWinBorder = { fg = border_fg_color }, -- For DAP UI window borders

					-- You might need to add more specific groups if some borders are still missing
					-- e.g., LspInfoBorder = { fg = border_fg_color }, if Catppuccin uses it and it's not covered
				}
			end,
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad", -- This style should support borders; colors will be handled by custom_highlights
				},
				native_lsp = {
					enabled = true,
					-- Catppuccin's native_lsp integration will set up borders (e.g., rounded)
					-- for LSP hover/signatureHelp floats. The border color will be themed
					-- based on FloatBorder or LspInfoBorder, covered by custom_highlights.
				},
				cmp = true, -- Enable Catppuccin styling for nvim-cmp completion menu
				dap = { enabled = true, enable_ui = true }, -- For nvim-dap and dap-ui

				-- Optional: enable other integrations for consistent theming if you use these plugins
				gitsigns = true,
				treesitter = true,
				fidget = true, -- For LSP progress messages
				which_key = true,
				mason = true, -- For Mason UI
				-- mini = true,      -- If you use mini.nvim components that draw borders
				-- notify = true,    -- For nvim-notify
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	-- END OF THEME CONFIGURATION

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci:]quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			require("mini.pairs").setup()
			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"python",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},

	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- { import = 'custom.plugins' },
	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
	-- Or use telescope!
	-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
	-- you can continue same window with `<space>sr` which resumes last telescope search
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
