-- nvim-todo/lua/nvim-todo/core/state_manager.lua
local M = {}
local parser = require('nvim-todo.core.parser')

-- タスクの状態を更新する関数
function M.update_task_status(file_path, task_name, new_status)
    -- タスクファイルを解析してタスクリストを取得
    local tasks = parser.parse_todo_file(file_path)
    local lines = vim.fn.readfile(file_path)
    local updated = false

    for i, task in ipairs(tasks) do
        if task.name == task_name and task.status ~= new_status then
            -- タスクの状態を更新
            local new_line = lines[i]:gsub("%[.%]", "["..(new_status == "completed" and "x" or " ").."]")
            lines[i] = new_line
            updated = true
            break
        end
    end

    if updated then
        -- ファイルに変更を書き戻す
        vim.fn.writefile(lines, file_path)
    end

    return updated
end

-- 特定の状態のタスクのみをフィルタリングして返す関数
function M.filter_tasks_by_status(file_path, status_filter)
    local tasks = parser.parse_todo_file(file_path)
    local filtered_tasks = {}

    for _, task in ipairs(tasks) do
        if task.status == status_filter then
            table.insert(filtered_tasks, task)
        end
    end

    return filtered_tasks
end

return M
