-- nvim-todo/lua/nvim-todo/core/parser.lua
local M = {}

-- Markdownのタスク項目を解析する正規表現パターン
local task_pattern = '(%s*)[-*]%s*%[(%s?)(x?)(%s?)%]%s+(.+)'

-- Markdownファイルからタスクを解析してリストとして返す
function M.parse_todo_file(filepath)
    local tasks = {}
    local lines = vim.fn.readfile(filepath)
    
    for _, line in ipairs(lines) do
        -- 各行を解析してタスクの情報を取得
        for indent, pre, checked, post, description in string.gmatch(line, task_pattern) do
            local task = {
                indent = #indent, -- インデントの深さ
                status = (checked ~= '' and 'completed') or 'pending', -- タスクの状態
                description = description, -- タスクの説明
            }
            table.insert(tasks, task)
        end
    end
    
    return tasks
end

-- タスクの状態を更新する関数（例: 未完了から完了へ）
-- 実際のファイル更新処理は省略
function M.update_task_status(filepath, line_number, new_status)
    -- ここにファイルの特定行を更新するロジックを実装
end

return M
