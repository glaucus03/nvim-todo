-- tests/parser_spec.lua
package.path = package.path .. ";./lua/?.lua"

describe("Parser", function()
    local parser = require("nvim-todo.core.parser")

    it("parses tasks correctly", function()
        -- 仮のTodoファイルを作成
        local test_file_path = "/tmp/todo_test.md"
        local test_content = [[
- [ ] Task 1
- [x] Task 2
- [ ] Task 3
]]
        -- ファイルにテスト用の内容を書き込み
        local file = io.open(test_file_path, "w")
        file:write(test_content)
        file:close()

        -- パーサーをテスト
        local tasks = parser.parse_todo_file(test_file_path)
        assert.are.equal(3, #tasks)
        assert.are.equal("pending", tasks[1].status)
        assert.are.equal("completed", tasks[2].status)
        assert.are.equal("Task 3", tasks[3].name)
    end)
end)
