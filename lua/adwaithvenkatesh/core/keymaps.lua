vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- general keymaps

keymap.set("i", "jk", "<ESC>") -- use jk to get out of insert mode

keymap.set("n", "<leader>nh", ":nohl<CR>") -- in normal mode leader+nh will remove highlighting
keymap.set("n", "x", '"_x') -- in normal mode hitting x will delete the charecter but will not copy to the clipboard

keymap.set("n", "<leader>+", "<C-a>") -- increment the number in normal mode
keymap.set("n", "<leader>-", "<C-x>") -- decrement the number in normal mode

-- add the shortcuts for adding comments to code
keymap.set("n", "<leader>cc", "gcc")
keymap.set("v", "<leader>c", "gc")

-- align window splits and other functions
keymap.set("n", "<leader>sv", "<C-w>v") -- split windows vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split windows horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- Move between windows
keymap.set("n", "<leader>ml", "<C-w>h") -- Move to window to the left
keymap.set("n", "<leader>mr", "<C-w>l") -- Move to window to the right
keymap.set("n", "<leader>mu", "<C-w>k") -- Move to window to the upper
keymap.set("n", "<leader>mb", "<C-w>j") -- Move to the window below
-- tab functionality
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

-- plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim treesitter
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- directory keymaps
local function get_current_node()
	local node = vim.treesitter.get_node_at_cursor()
	return node
end
local function get_parent_directory(node)
	local file_path = vim.fn.expand("%:p")
	local parent_dir = vim.fn.fnamemodify(file_path, ":h")
	return parent_dir
end
local function createNewDirectory(parent_dir)
	local new_dir_name = vim.fn.input("Enter Directory name: ")
	local new_dir_path = parent_dir .. "/" .. new_dir_name
	vim.fn.mkdir(new_dir_name, "p")
	vim.notify("Directory created: " .. new_dir_path)
end
keymap.set(
	"n",
	"<leader>nd",
	":lua createNewDirectory(get_parent_directory(get_current_node()))<CR>",
	{ noremap = true, silent = true }
)

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary
