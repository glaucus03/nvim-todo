-- データ構造の定義
local Project = {}
Project.__index = Project
function Project:new(name)
    return setmetatable({name = name, productBacklogs = {}}, Project)
end

local ProductBacklog = {}
ProductBacklog.__index = ProductBacklog
function ProductBacklog:new(name)
    return setmetatable({name = name, scrumBacklogs = {}}, ProductBacklog)
end

local ScrumBacklog = {}
ScrumBacklog.__index = ScrumBacklog
function ScrumBacklog:new(name, deadline, status)
    return setmetatable({name = name, deadline = deadline, status = status, tasks = {}}, ScrumBacklog)
end

function ScrumBacklog:addTask(task)
    table.insert(self.tasks, task)
end

local Task = {}
Task.__index = Task
function Task:new(name, status)
    return setmetatable({name = name, status = status}, Task)
end

-- パーサーモジュールの定義
local Parser = {}

-- ステータス判定関数
function Parser.determineStatus(statusMark)
    if statusMark == " " then return "not_started"
    elseif statusMark == ">" then return "in_progress"
    elseif statusMark == "r" then return "review"
    elseif statusMark == "x" then return "completed"
    else return "unknown"
    end
end

function Parser.parse(content)
    local projects = {}
    local currentProject
    local currentProductBacklog
    local currentScrumBacklog

    for line in content:gmatch("[^\r\n]+") do
        if line:match("^##[^#]") then
            local projectName = line:match("^##%s*(.+)")
            currentProject = Project:new(projectName)
            table.insert(projects, currentProject)
        elseif currentProject and line:match("^###[^#]") then
            local productBacklogName = line:match("^###%s*(.+)")
            currentProductBacklog = ProductBacklog:new(productBacklogName)
            table.insert(currentProject.productBacklogs, currentProductBacklog)  -- 正しく関連付け
        elseif currentProductBacklog and line:match("^%-%s*%[.-%]%s+.+") and not line:match("^%s") then
            local statusMark, rest = line:match("^%-%s*%[(.-)%]%s*(.+)")
            local name, deadline = rest:match("^(.-)%s*@(%d%d%d%d%d%d%d%d)$")
            local status = Parser.determineStatus(statusMark)
            currentScrumBacklog = ScrumBacklog:new(name, deadline, status)
            table.insert(currentProductBacklog.scrumBacklogs, currentScrumBacklog)
        elseif currentScrumBacklog and line:match("^%s+%-%s*%[.-%]%s+.+") then
            local statusMark, name = line:match("^%s+%-%s*%[(.-)%]%s*(.+)")
            local status = Parser.determineStatus(statusMark)
            local task = Task:new(name, status)
            currentScrumBacklog:addTask(task)
        end
    end

    return projects
end

function Parser.toMarkdown(projects)
    local markdownContent = ""
    for _, project in ipairs(projects) do
        markdownContent = markdownContent .. "## " .. project.name .. "\n"
        for _, productBacklog in ipairs(project.productBacklogs) do
            markdownContent = markdownContent .. "### " .. productBacklog.name .. "\n"
            for _, scrumBacklog in ipairs(productBacklog.scrumBacklogs) do
                local statusMark = scrumBacklog.status == "completed" and "x" or (scrumBacklog.status == "in_progress" and ">" or (scrumBacklog.status == "review" and "r" or " "))
                markdownContent = markdownContent .. "- [" .. statusMark .. "] " .. scrumBacklog.name .. " @" .. (scrumBacklog.deadline or "") .. "\n"
                for _, task in ipairs(scrumBacklog.tasks) do
                    local taskStatusMark = task.status == "completed" and "x" or (task.status == "in_progress" and ">" or (task.status == "review" and "r" or " "))
                    markdownContent = markdownContent .. "    - [" .. taskStatusMark .. "] " .. task.name .. "\n"
                end
            end
        end
    end
    return markdownContent
end

return Parser
