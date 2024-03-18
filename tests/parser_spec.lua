package.path = package.path .. ";./lua/?.lua"

describe("Parser", function()
    local Parser = require("nvim-todo.core.parser")  -- parser.luaのパスを適切に設定

    it("correctly parses project structure from markdown", function()
        local markdownContent = [[
## Project XYZ
### Product Backlog 1
- [ ] Scrum Backlog 1 @20230101
    - [>] Task 1
    - [x] Task 2
### Product Backlog 2
- [ ] Scrum Backlog 2 @20230202
    - [r] Task 3
    - [ ] Task 4
]]

        local project = Parser.parse(markdownContent)

        -- プロジェクト名の検証
        assert.are.equal("Project XYZ", project.name)

        -- プロダクトバックログ数の検証
        assert.are.equal(2, #project.productBacklogs)

        -- スクラムバックログの検証
        local scrumBacklog1 = project.productBacklogs[1].scrumBacklogs[1]
        assert.are.equal("Scrum Backlog 1", scrumBacklog1.name)
        assert.are.equal("20230101", scrumBacklog1.deadline)
        assert.are.equal("not_started", scrumBacklog1.status)  -- 注意: スクラムバックログのデフォルトステータスまたは解析ルールに応じて調整

        -- タスクの検証
        assert.are.equal("in_progress", scrumBacklog1.tasks[1].status)
        assert.are.equal("completed", scrumBacklog1.tasks[2].status)
        assert.are.equal("Task 1", scrumBacklog1.tasks[1].name)
        assert.are.equal("Task 2", scrumBacklog1.tasks[2].name)

        -- 他のスクラムバックログとタスクに関する検証も同様に行う
    end)
end)
