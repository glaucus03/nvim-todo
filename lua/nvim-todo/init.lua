-- nvim-todo/init.lua
local M = {}

-- プラグインの設定を格納するテーブル
M.config = {
    -- デフォルト設定値
    todo_file_path = vim.fn.stdpath('data') .. '/todo.md', -- デフォルトのTodoファイルパス
}

-- プラグインの設定を更新する関数
function M.setup(user_config)
    -- ユーザーから提供された設定でデフォルト設定を更新
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

-- タスクの追加、編集、削除などのコア機能を提供するモジュールの読み込み
local core = require('nvim-todo.core')

-- Telescopeとの統合を提供するモジュールの読み込み
local telescope_integration = require('nvim-todo.ui.telescope_integration')

-- プラグイン初期化関数
function M.init()
    -- 必要な初期化処理をここに記述
    -- 例: コマンドの登録、キーマッピングの設定など
end

-- init関数を自動的に実行
M.init()

-- モジュールMを外部に公開
return M
