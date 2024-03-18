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

-- Markdownの解析関数
function Parser.parse(content)
    local project = Project:new("Unnamed Project")
    local currentProductBacklog
    local currentScrumBacklog

    for line in content:gmatch("[^\r\n]+") do
        if line:match("^##[^#]") then
            project.name = line:match("^##%s*(.+)")
        elseif line:match("^###[^#]") then
            local name = line:match("^###%s*(.+)")
            currentProductBacklog = ProductBacklog:new(name)
            table.insert(project.productBacklogs, currentProductBacklog)
        elseif line:match("^%-%s*%[.-%]%s+.+") and not line:match("^%s") then
            local statusMark, rest = line:match("^%-%s*%[(.-)%]%s*(.+)")
            local name, deadline = rest:match("^(.-)%s*@(%d%d%d%d%d%d%d%d)$")
            local status = Parser.determineStatus(statusMark)
            currentScrumBacklog = ScrumBacklog:new(name, deadline, status)
            if currentProductBacklog then
                table.insert(currentProductBacklog.scrumBacklogs, currentScrumBacklog)
            end
        elseif line:match("^%s+%-%s*%[.-%]%s+.+") then
            local statusMark, name = line:match("^%s+%-%s*%[(.-)%]%s*(.+)")
            local status = Parser.determineStatus(statusMark)
            local task = Task:new(name, status)
            if currentScrumBacklog then
                currentScrumBacklog:addTask(task)
            end
        end
    end

    return project
end

return Parser
