-- nvim-todo/init.lua
package.path = package.path .. ";./lua/?.lua"
-- モジュールの読み込み
local telescope_integration = require('nvim-todo.ui.telescope_integration')
local file_manager = require('nvim-todo.core.file_manager')
local parser = require('nvim-todo.core.parser')
local state_manager = require('nvim-todo.core.state_manager')

-- カスタムTelescopeピッカーの登録
-- local function register_custom_picker()
--     local telescope = require('telescope')
--
--     telescope.setup{
--         extensions = {
--             nvim_todo = telescope_integration.showProjects or function() end
--         }
--     }
--
--     telescope.load_extension('nvim_todo')
-- end
--
-- カスタムピッカーの登録関数を呼び出す
telescope_integration.showProjects()
-- キーマッピング: Telescopeのカスタムピッカーを開く
vim.api.nvim_set_keymap('n', '<leader>tp', "<cmd>Telescope nvim_todo<CR>", {noremap = true, silent = true})

-- その他、プラグインや開発中の機能に必要な設定や関数をここに記述
