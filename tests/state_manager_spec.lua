-- tests/state_manager_spec.lua
package.path = package.path .. ";./lua/?.lua"

describe("State Manager", function()
    local StateManager = require("nvim-todo.core.state_manager") -- 適切なパスに置き換えてください。
    local projects = {}

    before_each(function()
        -- 各テストの前にプロジェクト構造をリセット
        projects = {}
        StateManager.addProject(projects, "Project 1")
        StateManager.addProductBacklog(projects, "Project 1", "Product Backlog 1")
        StateManager.addScrumBacklog(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "20240101", "not_started")
        StateManager.addTask(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "Task 1", "not_started")
    end)

    it("adds entities correctly", function()
        assert.are.equal("Project 1", projects[1].name)
        assert.are.equal("Product Backlog 1", projects[1].productBacklogs[1].name)
        assert.are.equal("Scrum Backlog 1", projects[1].productBacklogs[1].scrumBacklogs[1].name)
        assert.are.equal("Task 1", projects[1].productBacklogs[1].scrumBacklogs[1].tasks[1].name)
    end)

    it("removes entities correctly", function()
        StateManager.removeTask(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "Task 1")
        assert.are.equal(0, #projects[1].productBacklogs[1].scrumBacklogs[1].tasks)
        StateManager.removeScrumBacklog(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1")
        assert.are.equal(0, #projects[1].productBacklogs[1].scrumBacklogs)
        StateManager.removeProductBacklog(projects, "Project 1", "Product Backlog 1")
        assert.are.equal(0, #projects[1].productBacklogs)
        StateManager.removeProject(projects, "Project 1")
        assert.are.equal(0, #projects)
    end)

    it("updates entities correctly", function()
        StateManager.updateScrumBacklog(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "in_progress", "20240202")
        local scrumBacklog = projects[1].productBacklogs[1].scrumBacklogs[1]
        assert.are.equal("in_progress", scrumBacklog.status)
        assert.are.equal("20240202", scrumBacklog.deadline)

        StateManager.updateTask(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "Task 1", "completed")
        local task = projects[1].productBacklogs[1].scrumBacklogs[1].tasks[1]
        assert.are.equal("completed", task.status)
    end)

    it("filters tasks by status correctly", function()
        StateManager.addTask(projects, "Project 1", "Product Backlog 1", "Scrum Backlog 1", "Task 2", "completed")
        local completedTasks = StateManager.filterTasksByStatus(projects, "completed")
        assert.are.equal(1, #completedTasks)
        assert.are.equal("Task 2", completedTasks[1].name)
    end)
end)
