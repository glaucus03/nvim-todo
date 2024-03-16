-- nvim-todo/lua/nvim-todo/ui/telescope_integration.lua
local telescope = require('telescope')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local state_manager = require('nvim-todo.core.state_manager')

-- タスクを検索して表示するTelescopeピッカーの定義
local function search_tasks(opts)
    opts = opts or {}

    -- タスクのリストを取得
    local tasks = state_manager.filter_tasks_by_status(opts.file_path, "pending") -- ここでフィルタリング条件をカスタマイズ可能

    -- タスクの名前のリストを作成
    local task_names = {}
    for _, task in ipairs(tasks) do
        table.insert(task_names, task.name)
    end

    -- Telescopeピッカーの設定
    pickers.new(opts, {
        prompt_title = "Search Tasks",
        finder = finders.new_table({
            results = task_names,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            -- タスクの状態を切り替えるアクションを定義
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                -- 選択されたタスクの状態を変更する処理（例：完了としてマーク）
                state_manager.update_task_status(opts.file_path, selection.value, "completed")
                print(selection.value .. " marked as completed")
            end)
            return true
        end,
    }):find()
end

return telescope.register_extension({
    exports = {
        search_tasks = search_tasks,
    },
})
