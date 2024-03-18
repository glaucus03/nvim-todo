-- ダミーのプロジェクトデータを作成するヘルパー関数
local function createDummyProjectData()
    return {
        {
            name = "Project A",
            productBacklogs = {
                {
                    name = "Product Backlog A1",
                    scrumBacklogs = {
                        {
                            name = "Scrum Backlog A1-1",
                            deadline = "20240101",
                            status = "not_started",
                            tasks = {
                                { name = "Task A1-1-1", status = "not_started" },
                                { name = "Task A1-1-2", status = "completed" },
                            }
                        }
                    }
                }
            }
        }
    }
end

package.path = package.path .. ";./lua/?.lua"

describe("FileManager and Parser Integration", function()
    local FileManager = require("nvim-todo.core.file_manager")  -- 適切なパスに修正
    local tempFilePath = "temp_test_project.md"

    after_each(function()
        -- テスト後に一時ファイルを削除
        os.remove(tempFilePath)
    end)

    it("saves projects to markdown and loads them correctly", function()
        -- ダミーのプロジェクトデータを作成
        local projects = createDummyProjectData()

        -- プロジェクトデータをマークダウンファイルに保存
        FileManager.saveProjects(projects, tempFilePath)

        -- マークダウンファイルからプロジェクトデータを読み込み
        local loadedProjects = FileManager.loadProjects(tempFilePath)

        -- 読み込んだデータが元のデータと一致することを検証
        assert.are.equal("Project A", loadedProjects[1].name)
        assert.are.equal("Product Backlog A1", loadedProjects[1].productBacklogs[1].name)
        assert.are.equal("Scrum Backlog A1-1", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].name)
        assert.are.equal("20240101", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].deadline)
        assert.are.equal("not_started", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].status)
        assert.are.equal("Task A1-1-1", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].tasks[1].name)
        assert.are.equal("not_started", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].tasks[1].status)
        assert.are.equal("Task A1-1-2", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].tasks[2].name)
        assert.are.equal("completed", loadedProjects[1].productBacklogs[1].scrumBacklogs[1].tasks[2].status)
    end)
end)
