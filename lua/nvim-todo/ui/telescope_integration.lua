package.path = package.path .. ";./lua/?.lua"

local telescope = require('telescope')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local Parser = require("nvim-todo.core.parser")  -- parser.luaのパスを適切に設定

-- ダミーデータ
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

-- プロジェクトデータを表示するカスタムピッカーの関数
local function showProjects()
    local projects = Parser.parse(markdownContent)
    -- Flatten the project structure for display in Telescope
    local items = {}
    for _, project in ipairs(projects) do
        for _, pb in ipairs(project.productBacklogs) do
            for _, sb in ipairs(pb.scrumBacklogs) do
                for _, task in ipairs(sb.tasks) do
                    table.insert(items, {
                        project = project.name,
                        productBacklog = pb.name,
                        scrumBacklog = sb.name,
                        task = task.name,
                        status = task.status,
                        deadline = sb.deadline
                    })
                end
            end
        end
    end

    pickers.new({}, {
        prompt_title = "Projects",
        finder = finders.new_table({
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format("%s > %s > %s: %s [%s, %s]", entry.project, entry.productBacklog, entry.scrumBacklog, entry.task, entry.status, entry.deadline),
                    ordinal = entry.project .. " " .. entry.productBacklog .. " " .. entry.scrumBacklog .. " " .. entry.task,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
    }):find()
end

return {
    showProjects = showProjects,
}
