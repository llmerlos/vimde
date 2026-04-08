vim.g.have_nerd_font = true
vim.o.exrc = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>vp", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "[v]im plugin list" })
vim.keymap.set("n", "<leader>vr", "<CMD>restart<CR>", { desc = "[v]im restart" })
vim.keymap.set("n", "<leader>ve", "<CMD>e $MYVIMRC<CR><CMD>cd %:h<CR>", { desc = "[v]im edit" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
local gr = vim.api.nvim_create_augroup("custom-config", {})
local on_packchanged = function(plugin_name, kinds, callback, desc)
	local f = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd(plugin_name)
		end
		callback()
	end
	vim.api.nvim_create_autocmd("PackChanged", { group = gr, pattern = "*", callback = f, desc = desc })
end

-- Small ======================================================================
vim.pack.add({
	"https://github.com/tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
})

-- Theme ======================================================================
vim.pack.add({
	"https://github.com/sainnhe/gruvbox-material",
	"https://github.com/sainnhe/everforest",
})

vim.opt.background = "light"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "original"
vim.cmd.colorscheme("gruvbox-material")
-- vim.cmd.colorscheme("everforest")

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

-- UI =========================================================================

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim", -- dep
	"https://github.com/nvim-tree/nvim-web-devicons", -- dep
	"https://github.com/MunifTanjim/nui.nvim", -- dep
	"https://github.com/nvim-mini/mini.bufremove",
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/folke/which-key.nvim",
})

require("neo-tree").setup({
	filesystem = {
		follow_current_file = { enabled = true },
		filtered_items = {
			visible = true, -- when true, they will just be displayed differently than normal items
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = false,
		},
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal<CR>", { desc = "Open [e]xplorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Neotree close<CR>", { desc = "Close [E]xplorer" })

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
		{ "<leader>d", group = "[d]ebug" },
		{ "<leader>f", group = "[f]ind" },
		{ "<leader>g", group = "[g]it", mode = { "n", "v" } },
		{ "<leader>q", group = "[q]ustom" },
		{ "<leader>t", group = "[t]asks" },
		{ "<leader>v", group = "[v]imrc" },
		{ "<leader>w", group = "[w]orkspace" },
	},
})

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = true })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Tree-sitter ================================================================
local ts_update = function()
	vim.cmd("TSUpdate")
end
on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local languages = {
	"lua",
	"vimdoc",
	"markdown",
	"c",
}
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
	"https://github.com/ibhagwan/fzf-lua",
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

-- Language servers ===========================================================
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
})

require("blink.cmp").setup({
	keymap = { preset = "cmdline" },
	appearance = { nerd_font_variant = "mono" },
	completion = { documentation = { auto_show = false } },
	sources = { default = { "lsp", "path", "buffer" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})

require("conform").setup({
	default_format_opts = {
		lsp_format = "fallback",
	},
	notify_on_error = false,
	format_on_save = function(bufnr)
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
	-- formatters_by_ft = { lua = { 'stylua' } },
})

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
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

		--  To jump back, press <C-t>.
		map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
		map("gd", fzf.lsp_definitions, "[g]oto [d]efinition")
		map("gr", fzf.lsp_references, "[g]oto [r]eferences")
		map("gI", fzf.lsp_implementations, "[g]oto [I]mplementation")
		map("<leader>co", fzf.lsp_document_symbols, "[c]ode [o]utline")
		map("<leader>cr", vim.lsp.buf.rename, "[c]ode [r]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>cih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[c]ode [i]nlay [h]ints")
		end
	end,
})

require("mason").setup()
require("mason-lspconfig").setup()

-- -- Debug ======================================================================
-- vim.cmd("packadd! termdebug")
-- vim.g.termdebug_config = {
-- 	wide = 1,
-- }
-- vim.keymap.set("n", "<leader>ds", "<cmd>Termdebug<cr>", { desc = "debug start" })
-- vim.keymap.set("n", "<leader>n", function()
-- 	vim.cmd("call TermDebugSendCommand('quit')")
-- 	vim.defer_fn(function()
-- 		vim.cmd("call TermDebugSendCommand('y')")
-- 	end, 100)
-- end, { desc = "debug shutdown" })
-- vim.keymap.set("n", "<leader>m", "<cmd>Continue<cr>", { desc = "debug continue" })
-- vim.keymap.set("n", "<leader>i", "<cmd>Down<cr>", { desc = "debug scope down" })
-- vim.keymap.set("n", "<leader>o", "<cmd>Up<cr>", { desc = "debug scope up" })
-- vim.keymap.set("n", "<leader>p", "<cmd>Break<cr>", { desc = "debug breakpoint" })
-- vim.keymap.set("n", "<leader>P", "<cmd>Clear<cr>", { desc = "debug breakpoint" })
-- vim.keymap.set("n", "<leader>h", "<cmd>Stop<cr>", { desc = "debug stop" })
-- vim.keymap.set("n", "<leader>j", "<cmd>Step<cr>", { desc = "debug step into" })
-- vim.keymap.set("n", "<leader>k", "<cmd>Finish<cr>", { desc = "debug step out" })
-- vim.keymap.set("n", "<leader>l", "<cmd>Over<cr>", { desc = "debug step over" })
-- vim.keymap.set("n", "<leader>u", "<cmd>Gdb<cr>", { desc = "debug gdb prompt" })
-- vim.keymap.set({ "n", "v" }, "<leader>de", "<cmd>Evaluate<cr>", { desc = "debug evaluate" })

-- DAP ========================================================================
vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/jedrzejboczar/nvim-dap-cortex-debug",
})

require("mason-nvim-dap").setup()
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

-- setup dap config by VsCode launch.json file
local vscode = require("dap.ext.vscode")
local json = require("plenary.json")
vscode.json_decode = function(str)
	return vim.json.decode(json.json_strip_comments(str))
end

require("nvim-dap-virtual-text").setup()
require("dap-cortex-debug").setup()

require("dapui").setup({
	layouts = {
		{
			elements = {
				{ id = "console", size = 0.10 },
				{ id = "breakpoints", size = 0.10 },
				{ id = "scopes", size = 0.40 },
				{ id = "stacks", size = 0.30 },
				{ id = "watches", size = 0.10 },
			},
			position = "right",
			size = 40,
		},
	},
})

require("dap").listeners.before.attach.dapui_config = function()
	require("dapui").open()
end
require("dap").listeners.before.launch.dapui_config = function()
	require("dapui").open()
end
require("dap").listeners.before.event_terminated.dapui_config = function()
	require("dapui").close()
end
require("dap").listeners.before.event_exited.dapui_config = function()
	require("dapui").close()
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>n", function() require("dap").terminate() end, { desc = "debug terminate" })
vim.keymap.set("n", "<leader>m", function() require("dap").continue() end, { desc = "debug continue" })
vim.keymap.set("n", "<leader>i", function() require("dap").down() end, { desc = "debug scope down" })
vim.keymap.set("n", "<leader>o", function() require("dap").up() end, { desc = "debug scope up" })
vim.keymap.set("n", "<leader>p", function() require("dap").toggle_breakpoint() end, { desc = "debug breakpoint" })
vim.keymap.set("n", "<leader>h", function() require("dap").pause() end, { desc = "debug pause" })
vim.keymap.set("n", "<leader>j", function() require("dap").step_into() end, { desc = "debug step into" })
vim.keymap.set("n", "<leader>k", function() require("dap").step_out() end, { desc = "debug step out" })
vim.keymap.set("n", "<leader>l", function() require("dap").step_over() end, { desc = "debug step over" })
vim.keymap.set("n", "<leader>u", function() require("dap").repl.open() end, { desc = "debug repl open" })
vim.keymap.set("n", "<leader>U", function() require("dap").repl.close() end, { desc = "debug repl close" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle({}) end, { desc = "[d]ebug [u]I" })
vim.keymap.set({ "n", "v" }, "<leader>de", function() require("dapui").eval() end, { desc = "[d]ebug [e]val" })
-- stylua: ignore end
