-- tests/state_manager_spec.lua
describe("State Manager", function()
    local state_manager = require("nvim-todo.core.state_manager")

    -- テスト用のTodoファイルパス
    local test_file_path = "./tests/test_todo.md"

    before_each(function()
        -- テスト用のTodoファイルを準備
        local test_content = [[
- [ ] Task 1
- [x] Task 2
- [ ] Task 3
]]
        local file = io.open(test_file_path, "w")
        file:write(test_content)
        file:close()
    end)

    after_each(function()
        -- テスト用のファイルを削除
        os.remove(test_file_path)
    end)

    it("updates task status correctly", function()
        -- Task 1の状態を'completed'に更新
        local updated = state_manager.update_task_status(test_file_path, "Task 1", "completed")
        assert.is_true(updated)

        -- ファイルを読み込み、更新を確認
        local file = io.open(test_file_path, "r")
        local content = file:read("*all")
        file:close()

        assert.matches("- %[x%] Task 1", content)
    end)

    it("filters tasks by status correctly", function()
        -- 状態が'pending'のタスクをフィルタリング
        local pending_tasks = state_manager.filter_tasks_by_status(test_file_path, "pending")
        assert.are.equal(2, #pending_tasks)
        assert.are.equal("Task 1", pending_tasks[1].name)
        assert.are.equal("Task 3", pending_tasks[2].name)
    end)
end)
