local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install plugins here
return packer.startup(function(use)
	-- Core
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "nvim-telescope/telescope.nvim" })
	use({ "nvim-treesitter/nvim-treesitter" })
	use({ "akinsho/toggleterm.nvim" })
	use({ "lewis6991/impatient.nvim" })
	use({ "kyazdani42/nvim-tree.lua" })

	-- Cmp
	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({ "MunifTanjim/prettier.nvim" })
	use({
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	-- use({ "lukas-reineke/lsp-format.nvim" })

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	use({ "williamboman/mason.nvim" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
	use({ "RRethy/vim-illuminate" })
	use({ "leafOfTree/vim-svelte-plugin" })
	use({ "leafOfTree/vim-svelte-theme" })
	use({ "rafamadriz/friendly-snippets" })
	use({ "https://github.com/jalvesaq/zotcite" })
	use({ "https://github.com/jalvesaq/cmp-zotcite" })

	-- Syntax
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	use({ "windwp/nvim-autopairs" })
	use({ "folke/which-key.nvim" })
	use({ "numToStr/Comment.nvim" })

	-- Optics
	use({ "folke/tokyonight.nvim" })
	use({ "folke/trouble.nvim" })
	use({ "sainnhe/everforest" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use({ "joshdick/onedark.vim" })
	use({ "lunarvim/Onedarker.nvim" })
	use({ "ahmedkhalf/project.nvim" })
	use({ "moll/vim-bbye" })
	use({ "nvim-lualine/lualine.nvim" })
	use({ "akinsho/bufferline.nvim" })
	use({ "goolord/alpha-nvim" })
	use({
		"xiyaowong/transparent.nvim",
		require("transparent").setup({
			groups = { -- table: default groups
				"Normal",
				"NormalNC",
				"Comment",
				"Constant",
				"Special",
				"Identifier",
				"Statement",
				"PreProc",
				"Type",
				"Underlined",
				"Todo",
				"String",
				"Function",
				"Conditional",
				"Repeat",
				"Operator",
				"Structure",
				"LineNr",
				"NonText",
				"SignColumn",
				"CursorLineNr",
				"EndOfBuffer",
			},
			extra_groups = {
				"NormalFloat",
				"NvimTreeNormal",
			},
		}),
	})

	-- Snippets
	use({ "L3MON4D3/LuaSnip" })

	-- Languages support
	use({ "dmmulroy/tsc.nvim" }) -- Async project-wide TypeScript type-checking
	use({ "windwp/nvim-ts-autotag" })

	-- Integrations
	use({
		"epwalsh/obsidian.nvim",
		config = function()
			require("obsidian").setup({
				dir = "~/Documents/obsidian/phd",
				daily_notes = {
					folder = "notes",
				},
				notes_subdir = "notes",
				completion = {
					nvim_cmp = true,
					min_chars = 2,
					new_notes_location = "notes_subdir",
				},
				note_id_func = function(title)
					local sane_name = ""
					if title ~= nil then
						-- If title is given, transform it into valid file name.
						sane_name = title:gsub(" ", " "):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						-- If title is nil, just add 4 random uppercase letters to the suffix.
						for _ in 1, 4 do
							sane_name = sane_name .. string.char(math.random(65, 90))
						end
					end
					return sane_name
				end,
				use_advanced_uri = true,
				open_app_foreground = false,
				finder = "telescope.nvim",
			})
		end,
	})

	-- use({
	-- 	"zbirenbaum/copilot-cmp",
	-- 	after = { "copilot.lua" },
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- })
	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 16.x
				server_opts_overrides = {},
			})
		end,
	})
	-- use({
	-- 	"jcdickinson/codeium.nvim",
	-- 	commit = "b1ff0d6c993e3d87a4362d2ccd6c660f7444599f",
	-- 	config = true,
	-- })
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
