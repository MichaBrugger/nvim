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
	-- use { "kyazdani42/nvim-tree.lua" }

	-- Cmp
	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	use({ "williamboman/mason.nvim" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
	use({ "RRethy/vim-illuminate" })

	-- Syntax
	use({ "kylechui/nvim-surround" }) -- Adding/changing/deleting surrounding delimiter pairs
	use({ "windwp/nvim-autopairs" })
	use({ "folke/which-key.nvim" })
	use({ "numToStr/Comment.nvim" })

	-- Optics
	use({ "folke/tokyonight.nvim" })
	use({ "ahmedkhalf/project.nvim" })
	use({ "moll/vim-bbye" })
	use({ "nvim-lualine/lualine.nvim" })
	use({ "akinsho/bufferline.nvim" })
	use({ "goolord/alpha-nvim" })

	-- Snippets
	use({ "L3MON4D3/LuaSnip" })

	-- Languages support
	use({ "dmmulroy/tsc.nvim" }) -- Async project-wide TypeScript type-checking

	-- Integrations
	use({
		"epwalsh/obsidian.nvim",
		config = function()
			require("obsidian").setup({
				use_advanced_uri = true,
				dir = "~/Documents/phd",
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
						sane_name = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						-- If title is nil, just add 4 random uppercase letters to the suffix.
						for _ in 1, 4 do
							sane_name = sane_name .. string.char(math.random(65, 90))
						end
					end
					return sane_name
				end,
				open_app_foreground = false,
				finder = "telescope.nvim",
			})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
