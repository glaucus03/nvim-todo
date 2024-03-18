local StateManager = {}

-- 新しいプロジェクトを追加する関数
function StateManager.addProject(projects, newProjectName)
    table.insert(projects, {name = newProjectName, productBacklogs = {}})
end

-- 新しいプロダクトバックログを追加する関数
function StateManager.addProductBacklog(projects, projectName, newProductBacklogName)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            table.insert(project.productBacklogs, {name = newProductBacklogName, scrumBacklogs = {}})
            return true
        end
    end
    return false
end

-- 新しいスクラムバックログを追加する関数
function StateManager.addScrumBacklog(projects, projectName, productBacklogName, newScrumBacklogName, deadline, status)
    status = status or "not_started"  -- デフォルトステータスは未着手
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    table.insert(productBacklog.scrumBacklogs, {name = newScrumBacklogName, deadline = deadline, status = status, tasks = {}})
                    return true
                end
            end
        end
    end
    return false
end

-- 新しいタスクを追加する関数
function StateManager.addTask(projects, projectName, productBacklogName, scrumBacklogName, newTaskName, status)
    status = status or "not_started"  -- デフォルトステータスは未着手
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                        if scrumBacklog.name == scrumBacklogName then
                            table.insert(scrumBacklog.tasks, {name = newTaskName, status = status})
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- プロジェクトを削除する関数
function StateManager.removeProject(projects, projectName)
    for i, project in ipairs(projects) do
        if project.name == projectName then
            table.remove(projects, i)
            return true
        end
    end
    return false
end

-- プロダクトバックログを削除する関数
function StateManager.removeProductBacklog(projects, projectName, productBacklogName)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for i, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    table.remove(project.productBacklogs, i)
                    return true
                end
            end
        end
    end
    return false
end

-- スクラムバックログを削除する関数
function StateManager.removeScrumBacklog(projects, projectName, productBacklogName, scrumBacklogName)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    for i, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                        if scrumBacklog.name == scrumBacklogName then
                            table.remove(productBacklog.scrumBacklogs, i)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- タスクを削除する関数
function StateManager.removeTask(projects, projectName, productBacklogName, scrumBacklogName, taskName)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                        if scrumBacklog.name == scrumBacklogName then
                            for i, task in ipairs(scrumBacklog.tasks) do
                                if task.name == taskName then
                                    table.remove(scrumBacklog.tasks, i)
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

-- スクラムバックログのステータスと期日を更新する関数
function StateManager.updateScrumBacklog(projects, projectName, productBacklogName, scrumBacklogName, newStatus, newDeadline)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                        if scrumBacklog.name == scrumBacklogName then
                            scrumBacklog.status = newStatus
                            scrumBacklog.deadline = newDeadline -- 期日も更新
                            return true -- 更新成功
                        end
                    end
                end
            end
        end
    end
    return false -- 更新失敗
end

-- タスクのステータスと期日を更新する関数
function StateManager.updateTask(projects, projectName, productBacklogName, scrumBacklogName, taskName, newStatus)
    for _, project in ipairs(projects) do
        if project.name == projectName then
            for _, productBacklog in ipairs(project.productBacklogs) do
                if productBacklog.name == productBacklogName then
                    for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                        if scrumBacklog.name == scrumBacklogName then
                            for _, task in ipairs(scrumBacklog.tasks) do
                                if task.name == taskName then
                                    task.status = newStatus
                                    return true -- 更新成功
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false -- 更新失敗
end

-- ステータスに基づいてタスクをフィルタリングする関数
function StateManager.filterTasksByStatus(projects, status)
    local filteredTasks = {}
    for _, project in ipairs(projects) do
        for _, productBacklog in ipairs(project.productBacklogs) do
            for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                for _, task in ipairs(scrumBacklog.tasks) do
                    if task.status == status then
                        table.insert(filteredTasks, task)
                    end
                end
            end
        end
    end
    return filteredTasks
end

return StateManager
