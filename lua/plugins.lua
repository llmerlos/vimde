vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.keymap.set("n", "<leader>vp", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "[v]im plugin list" })
vim.keymap.set("n", "<leader>vr", "<CMD>restart<CR>", { desc = "[v]im restart" })
vim.keymap.set("n", "<leader>ve", "<CMD>e $MYVIMRC<CR><CMD>cd %:h<CR>", { desc = "[v]im edit" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Theme ======================================================================
vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material", -- Theme
})

vim.opt.background = "light"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "original"
vim.cmd.colorscheme("gruvbox-material")

-- Editor =====================================================================
vim.pack.add({
	"https://github.com/tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
})

-- Git ========================================================================
vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
})
require("gitsigns").setup({
	on_attach = function(buffer)
		local gs = package.loaded.gitsigns

		vim.keymap.set("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end, { buffer = buffer, desc = "Next Hunk" })
		vim.keymap.set("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, { buffer = buffer, desc = "Prev Hunk" })
		vim.keymap.set("n", "]H", function()
			gs.nav_hunk("last")
		end, { buffer = buffer, desc = "Last Hunk" })
		vim.keymap.set("n", "[H", function()
			gs.nav_hunk("first")
		end, { buffer = buffer, desc = "First Hunk" })
		vim.keymap.set(
			{ "n", "v" },
			"<leader>gs",
			":Gitsigns stage_hunk<CR>",
			{ buffer = buffer, desc = "[s]tage Hunk" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>gr",
			":Gitsigns reset_hunk<CR>",
			{ buffer = buffer, desc = "[r]eset Hunk" }
		)
		vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { buffer = buffer, desc = "[S]tage Buffer" })
		vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { buffer = buffer, desc = "[u]ndo Stage Hunk" })
		vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { buffer = buffer, desc = "[R]eset Buffer" })
		vim.keymap.set("n", "<leader>gp", gs.preview_hunk_inline, { buffer = buffer, desc = "[p]review Hunk Inline" })
		vim.keymap.set("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, { buffer = buffer, desc = "[b]lame Line" })
		vim.keymap.set("n", "<leader>gB", function()
			gs.blame()
		end, { buffer = buffer, desc = "Blame [B]uffer" })
		vim.keymap.set("n", "<leader>gd", gs.diffthis, { buffer = buffer, desc = "[d]iff this" })
		vim.keymap.set("n", "<leader>gD", function()
			gs.diffthis("~")
		end, { buffer = buffer, desc = "[D]iff this ~" })
		vim.keymap.set(
			{ "o", "x" },
			"ih",
			":<C-U>Gitsigns select_hunk<CR>",
			{ buffer = buffer, desc = "GitSigns Select Hunk" }
		)
	end,
})

-- UI/UX ======================================================================
vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons", -- DEPENDENCY (Icons)
	"https://github.com/nvim-mini/mini.bufremove", -- Keep layout when bd
	"https://github.com/nvim-tree/nvim-tree.lua", -- File tree
	"https://github.com/nvim-lualine/lualine.nvim", -- Buffer line mostly
	"https://github.com/folke/which-key.nvim", -- Helper for remembering keymaps
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
	sync_root_with_cwd = true,
	update_focused_file = { enable = true },
	filters = {
		dotfiles = false,
		git_ignored = false,
	},
	git = { enable = true },
	renderer = {
		icons = {
			git_placement = "right_align",
		},
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>", { desc = "Open [e]xplorer" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeClose<CR>", { desc = "Close [E]xplorer" })

require("mini.bufremove").setup()
vim.keymap.set("n", "X", "<cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete buffer [X]" })

require("lualine").setup({
	sections = {
		lualine_c = { { "filename", path = 1 } },
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 1 } },
	},
	tabline = {
		lualine_a = { {
			"buffers",
			max_length = function()
				return vim.o.columns
			end,
		} },
		lualine_z = { "tabs" },
	},
})

require("which-key").setup({
	delay = 500,
	spec = {
		{ "<leader><leader>", group = "compat" },
		{ "<leader>c", group = "[c]ode" },
		{ "<leader>f", group = "[f]ind" },
		{ "<leader>g", group = "[g]it" },
		{ "<leader>q", group = "[q]ustom" },
		{ "<leader>t", group = "[t]asks" },
		{ "<leader>v", group = "[v]imrc" },
	},
})

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = true })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Tree-sitter ================================================================
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("ts-augroup", { clear = true }),
	pattern = "*",
	desc = ":TSUpdate",
	callback = function(ev)
		if ev.data.spec.name ~= "nvim-treesitter" or ev.data.kind ~= "update" then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd("nvim-treesitter")
		end
		vim.cmd("TSUpdate")
	end,
})

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local languages = {
	"lua",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"c",
}
-- Its a no-op if the language is already installed
require("nvim-treesitter").install(languages)

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(languages) do
	for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
		table.insert(filetypes, ft)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("tree-attach", { clear = true }),
	callback = function(ev)
		vim.treesitter.start(ev.buf)
	end,
	pattern = filetypes,
	desc = "Start tree-sitter",
})

-- Fuzzy Finder ===============================================================
vim.pack.add({
	"https://github.com/ibhagwan/fzf-lua", -- Fuzzy finder
})

local fzf = require("fzf-lua")
fzf.setup({ "default-title" })
fzf.register_ui_select()

local RG_OPTS = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096"

vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "[f]ind [h]elp" })
vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "[f]ind [k]eymaps" })
vim.keymap.set("n", "<leader>fp", fzf.builtin, { desc = "[f]ind fzf [p]icker" })
vim.keymap.set("n", "<leader>fd", function()
	fzf.files({ cmd = "fd --type f" })
end, { desc = "[f]in[d] files" })
vim.keymap.set("n", "<leader>ff", function()
	fzf.files({ cmd = "fd --type f --hidden" })
end, { desc = "[f]ind including (hidden) [f]iles" })
vim.keymap.set("n", "<leader>fF", function()
	fzf.files({ cmd = "fd --type f --hidden --no-ignore" })
end, { desc = "[f]ind including (ignored hidden) [F]iles" })
vim.keymap.set("n", "<leader>fa", fzf.live_grep, { desc = "[f]ind string in files [a]" })
vim.keymap.set("v", "<leader>fa", fzf.grep_visual, { desc = "[f]ind selection in files [a]" })
vim.keymap.set("n", "<leader>fs", function()
	fzf.live_grep({ rg_opts = RG_OPTS .. " --hidden" })
end, { desc = "[f]ind [s]tring in files (--hidden)" })
vim.keymap.set("v", "<leader>fs", function()
	fzf.grep_visual({ rg_opts = RG_OPTS .. " --hidden" })
end, { desc = "[f]ind [s]election in files (--hidden)" })
vim.keymap.set("n", "<leader>fS", function()
	fzf.live_grep({ rg_opts = RG_OPTS .. " --hidden --no-ignore" })
end, { desc = "[f]ind [S]tring in files (--hidden --no-ignore)" })
vim.keymap.set("v", "<leader>fS", function()
	fzf.grep_visual({ rg_opts = RG_OPTS .. " --hidden --no-ignore" })
end, { desc = "[f]ind [S]election in files (--hidden --no-ignore)" })
vim.keymap.set("n", "<leader>fg", fzf.git_status, { desc = "[f]ind [g]it modified files" })
vim.keymap.set("n", "<leader>fG", fzf.diagnostics_workspace, { desc = "[f]ind dia[G]nostics" })
vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "[f]ind [r]esume" })
vim.keymap.set("n", "<leader>f.", fzf.oldfiles, { desc = '[f]ind Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>fo", fzf.buffers, { desc = "[f]ind [o]pen buffers" })
vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("v", "<leader>/", function()
	fzf.lgrep_curbuf({ search = fzf.utils.get_visual_selection() })
end, { desc = "[/] Fuzzily search selection in current buffer" })
vim.keymap.set("n", "<leader>f/", fzf.lines, { desc = "[f]ind [/] in Open Files" })

-- Language (LSP) =============================================================
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") }, -- Autocompletion
	"https://github.com/stevearc/conform.nvim", -- Autoformat
	"https://github.com/neovim/nvim-lspconfig", -- LSP config database
	"https://github.com/mason-org/mason.nvim", -- Tool installer
	"https://github.com/mason-org/mason-lspconfig.nvim", -- glues mason and lspconfig
	"https://github.com/MeanderingProgrammer/render-markdown.nvim", -- requires ts: markdown & markdown_inline
})

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		list = {
			selection = { preselect = false, auto_insert = true },
		},
	},
	sources = { default = { "lsp", "path", "buffer" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})

require("conform").setup({
	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "mdformat" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("format-on-save", { clear = true }),
	callback = function(args)
		if vim.g.disable_autoformat then
			return
		end
		require("conform").format({ bufnr = args.buf, timeout_ms = 500, quiet = true })
	end,
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "[c]ode [f]ormat buffer" })

vim.keymap.set("n", "<leader>cF", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	print("Format on save: " .. tostring(not vim.g.disable_autoformat))
end, { desc = "[c]ode toggle [F]ormat on save" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
		map("gd", fzf.lsp_definitions, "[g]oto [d]efinition")
		map("gr", fzf.lsp_references, "[g]oto [r]eferences")
		map("gI", fzf.lsp_implementations, "[g]oto [I]mplementation")
		map("<leader>co", fzf.lsp_document_symbols, "[c]ode [o]utline")
		map("<leader>cr", vim.lsp.buf.rename, "[c]ode [r]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>ch", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[c]ode inlay [h]ints")
		end
	end,
})

require("mason").setup()
require("mason-lspconfig").setup()

require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
})
