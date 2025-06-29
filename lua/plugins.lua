vim.g.have_nerd_font = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.cmd([[
  augroup filetype_dts
    autocmd!
    autocmd BufRead,BufNewFile *.dts,*.dtsi setlocal commentstring=//\ %s
  augroup END
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "light"
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"laktak/tome",
		opts = {},
		keys = {
			{ "<Leader>,", "<Plug>(TomePlayLine)", mode = { "n" }, desc = "[p]lay line" },
			-- { "<Leader>p", "<Plug>(TomePlayParagraph)", mode = { "n" }, desc = "play [P]aragraph" },
			{ "<Leader>,", "<Plug>(TomePlaySelection)", mode = { "x" }, desc = "[p]lay selection" },
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 500,
			spec = {
				{ "<leader><leader>", group = "compat" },
				{ "<leader>c", group = "[c]ode" },
				{ "<leader>d", group = "[d]ebug" },
				{ "<leader>f", group = "[f]ind" },
				{ "<leader>g", group = "[g]it", mode = { "n", "v" } },
				{ "<leader>q", group = "[q]ustom" },
				{ "<leader>t", group = "[t]asks" },
				{ "<leader>v", group = "[v]imrc" },
				{ "<leader>w", group = "[w]orkspace" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		opts = {
			keywords = { WIP = { icon = " ", color = "hint" } },
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next [t]odo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev [t]odo comment",
			},
			{
				"<leader>fn",
				"<CMD>TodoTelescope keywords=WIP<CR>",
				desc = "[f]ind wip [n]otes",
			},
			{
				"<leader>ft",
				"<CMD>TodoTelescope<CR>",
				desc = "[f]ind [t]odos",
			},
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>ws",
				function()
					require("persistence").load()
				end,
				desc = "Re[s]tore session",
			},
			{
				"<leader>wS",
				function()
					require("persistence").select()
				end,
				desc = "[S]elect session",
			},
			{
				"<leader>wl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore [l]ast session",
			},
			{
				"<leader>wd",
				function()
					require("persistence").stop()
				end,
				desc = "[d]iscard current session",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				"echasnovski/mini.bufremove",
				opts = {},
				keys = {
					{ "X", "<cmd>lua MiniBufremove.delete()<CR>", desc = "Delete buffer [X]" },
				},
			},
		},
		opts = {
			-- close_if_last_window = true, -- Its buggy and closes neovim when bd
			filesystem = {
				follow_current_file = { enabled = true },
				filtered_items = {
					visible = true, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
			},
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree reveal<CR>", desc = "Open [e]xplorer" },
			{ "<leader>E", "<cmd>Neotree close<CR>", desc = "Close [E]xplorer" },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			sections = {
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{ "overseer" },
				},
			},
			inactive_sections = {
				lualine_c = {
					{ "filename", path = 1 },
				},
			},
			tabline = {
				lualine_a = {
					{
						"buffers",
						max_length = function()
							return vim.o.columns
						end,
					},
				},
				lualine_z = { "tabs" },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "[s]tage Hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "[r]eset Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "[S]tage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "[u]ndo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "[R]eset Buffer")
        map("n", "<leader>gp", gs.preview_hunk_inline, "[p]review Hunk Inline")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "[b]lame Line")
        map("n", "<leader>gB", function() gs.blame() end, "Blame [B]uffer")
        map("n", "<leader>gd", gs.diffthis, "[d]iff this")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "[D]iff this ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true } },
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"python",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ak"] = { query = "@block.outer", desc = "around block" },
						["ik"] = { query = "@block.inner", desc = "inside block" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["a?"] = { query = "@conditional.outer", desc = "around conditional" },
						["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
						["af"] = { query = "@function.outer", desc = "around function " },
						["if"] = { query = "@function.inner", desc = "inside function " },
						["ao"] = { query = "@loop.outer", desc = "around loop" },
						["io"] = { query = "@loop.inner", desc = "inside loop" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]k"] = { query = "@block.outer", desc = "Next block start" },
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
					},
					goto_next_end = {
						["]K"] = { query = "@block.outer", desc = "Next block end" },
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
					},
					goto_previous_start = {
						["[k"] = { query = "@block.outer", desc = "Previous block start" },
						["[f"] = { query = "@function.outer", desc = "Previous function start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
					},
					goto_previous_end = {
						["[K"] = { query = "@block.outer", desc = "Previous block end" },
						["[F"] = { query = "@function.outer", desc = "Previous function end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">K"] = { query = "@block.outer", desc = "Swap next block" },
						[">F"] = { query = "@function.outer", desc = "Swap next function" },
						[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
					},
					swap_previous = {
						["<K"] = { query = "@block.outer", desc = "Swap previous block" },
						["<F"] = { query = "@function.outer", desc = "Swap previous function" },
						["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
					},
				},
			},
		},
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						n = {
							["X"] = require("telescope.actions").delete_buffer,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
			vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "[f]ind telescope [p]icker" })
			vim.keymap.set(
				"n",
				"<leader>fd",
				"<CMD>Telescope find_files find_command=fd<CR>",
				{ desc = "[f]in[d] files" }
			)
			vim.keymap.set(
				"n",
				"<leader>ff",
				"<CMD>Telescope find_files find_command=fd,--hidden<CR>",
				{ desc = "[f]ind including (hidden) [f]iles" }
			)
			vim.keymap.set(
				"n",
				"<leader>fF",
				"<CMD>Telescope find_files find_command=fd,--hidden,--no-ignore<CR>",
				{ desc = "[f]ind including (ignored hidden) [F]iles" }
			)
			vim.keymap.set("n", "<leader>fa", function()
				builtin.live_grep({ additional_args = {} })
			end, { desc = "[f]ind string in files [a]" })
			vim.keymap.set(
				"v",
				"<leader>fa",
				'"zy<CMD>lua require("telescope.builtin").live_grep({additional_args = {}})<CR><c-r>z<ESC>',
				{ desc = "[f]ind selection in files [a]" }
			)
			vim.keymap.set("n", "<leader>fs", function()
				builtin.live_grep({ additional_args = { "--hidden" } })
			end, { desc = "[f]ind [s]tring in files (--hidden)" })
			vim.keymap.set(
				"v",
				"<leader>fs",
				'"zy<CMD>lua require("telescope.builtin").live_grep({additional_args = {"--hidden"}})<CR><c-r>z<ESC>',
				{ desc = "[f]ind [s]election in files (--hidden)" }
			)
			vim.keymap.set("n", "<leader>fS", function()
				builtin.live_grep({
					additional_args = function()
						return { "--hidden", "--no-ignore" }
					end,
				})
			end, { desc = "[f]ind [S]tring in files (--hidden --no-ignore)" })
			vim.keymap.set(
				"v",
				"<leader>fS",
				'"zy<CMD>lua require("telescope.builtin").live_grep({additional_args = {"--hidden", "--no-ignore"}})<CR><c-r>z<ESC>',
				{ desc = "[f]ind [S]election in files (--hidden --no-ignore)" }
			)
			vim.keymap.set("n", "<leader>fg", builtin.git_status, { desc = "[f]ind [g]it modified files" })
			vim.keymap.set("n", "<leader>fG", builtin.diagnostics, { desc = "[f]ind dia[G]nostics" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[f]ind [r]esume" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>fo", builtin.buffers, { desc = "[f]ind [o]pen buffers" })
			vim.keymap.set(
				"n",
				"<leader>/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "[/] Fuzzily search in current buffer" }
			)
			vim.keymap.set(
				"v",
				"<leader>/",
				'"zy<CMD>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR><c-r>z<ESC>',
				{ desc = "[/] Fuzzily search selection in current buffer" }
			)
			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[f]ind [/] in Open Files" })
		end,
	},

	-- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ "nvim-dap-ui" },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>co", require("telescope.builtin").lsp_document_symbols, "[c]ode [o]utline")
					map(
						"<leader>csw",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[c]ode [s]ymbols [w]orkspace"
					)
					map("<leader>crn", vim.lsp.buf.rename, "[c]ode [r]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>cih", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[c]ode [i]nlay [h]ints")
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				clangd = {
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields", "duplicated-fields" } },
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"cortex-debug",
				"buf",
				"clang-format",
				"debugpy",
				"pylsp",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
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
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[c]ode [f]ormat buffer",
			},
			{
				"<leader>cF",
				function()
					vim.g.disable_autoformat = not vim.g.disable_autoformat
					print("Format on save: " .. tostring(not vim.g.disable_autoformat))
				end,
				mode = "",
				desc = "[c]ode toggle [F]ormat on save",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				-- local disable_filetypes = { c = true, cpp = true }
				if vim.g.disable_autoformat then
					return
				end
				local disable_filetypes = {} --{ c = true, cpp = true }
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
				c = { "clang-format" },
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")

			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext / [p]revious item
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
				},
			})
		end,
	},
	--------------------------DAP-------------------
	{
		"mfussenegger/nvim-dap",
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
		dependencies = {
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
			"jay-babu/mason-nvim-dap.nvim",
		},
    -- stylua: ignore
    keys = {
      { "<leader>n", function() require("dap").terminate() end, desc = "[d]ebug terminate [s]" },
      { "<leader>m", function() require("dap").continue() end, desc = "[d]ebug continue [f]" },
      { "<leader>i", function() require("dap").down() end, desc = "[d]ebug scope down [i]" },
      { "<leader>o", function() require("dap").up() end, desc = "[d]ebug scope up [o]" },
      { "<leader>p", function() require("dap").toggle_breakpoint() end, desc = "[d]ebug break[.]oint" },
      { "<leader>h", function() require("dap").pause() end, desc = "[d]ebug pause [h]" },
      { "<leader>j", function() require("dap").step_into() end, desc = "[d]ebug step into [j]" },
      { "<leader>k", function() require("dap").step_out() end, desc = "[d]ebug step out [k]" },
      { "<leader>l", function() require("dap").step_over() end, desc = "[d]ebug step over [l]" },
    },

		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			require("mason-nvim-dap").setup()

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			---@diagnostic disable-next-line: duplicate-set-field
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
	{
		"jedrzejboczar/nvim-dap-cortex-debug",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = {},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{
				"<leader>du",
				function()
					require("overseer").close()
					require("dapui").toggle({})
				end,
				desc = "[d]ebug [u]I",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "[d]ebug [e]val",
				mode = { "n", "v" },
			},
		},
		opts = {
			layouts = {
				{
					elements = {
						{
							id = "repl",
							size = 0.10,
						},
						{
							id = "scopes",
							size = 0.40,
						},
						{
							id = "breakpoints",
							size = 0.10,
						},
						{
							id = "stacks",
							size = 0.30,
						},
						{
							id = "watches",
							size = 0.10,
						},
						-- {
						-- 	id = "console",
						-- 	size = 0.10,
						-- },
					},
					position = "right",
					size = 40,
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
		keys = {
			{ "<leader>b", "<CMD>OverseerRun Build<CR>", desc = "[b]uild" },
			{ "<leader>tl", "<CMD>OverseerOpen<CR><CMD>OverseerRun<CR>", desc = "[t]ask [l]aunch" },
			{ "<leader>tu", "<CMD>OverseerToggle<CR>", desc = "[t]ask [u]i" },
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
