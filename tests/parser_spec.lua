package.path = package.path .. ";./lua/?.lua"

describe("Parser", function()
    local Parser = require("nvim-todo.core.parser")  -- parser.luaのパスを適切に設定

  it("correctly parses multiple projects from markdown", function()
        local markdownContent = [[
## Project 1
### Product Backlog 1
- [ ] Scrum Backlog 1 @20230101
    - [>] Task 1
    - [x] Task 2
## Project 2
### Product Backlog 2
- [ ] Scrum Backlog 2 @20230202
    - [r] Task 3
    - [ ] Task 4
]]

        local projects = Parser.parse(markdownContent)

        -- プロジェクト数の検証
        assert.are.equal(2, #projects)

        -- 最初のプロジェクトの検証
        assert.are.equal("Project 1", projects[1].name)
        assert.are.equal(1, #projects[1].productBacklogs)
        assert.are.equal("Product Backlog 1", projects[1].productBacklogs[1].name)

        -- 二番目のプロジェクトの検証
        assert.are.equal("Project 2", projects[2].name)
        assert.are.equal(1, #projects[2].productBacklogs)
        assert.are.equal("Product Backlog 2", projects[2].productBacklogs[1].name)
    end)
end)
