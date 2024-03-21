package.path = package.path .. ";./lua/?.lua"

local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local entry_display = require "telescope.pickers.entry_display"
local Parser = require("nvim-todo.core.parser") -- parser.luaのパスを適切に設定

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
local function showProjects(opts)
  local projects = Parser.parse(markdownContent)
  -- Flatten the project structure for display in Telescope
  local items = {}
  local icon_dic = {}
  icon_dic["not_started"] = "🆕"
  icon_dic["in_progress"] = "⏭️"
  icon_dic["review"] = "☎️"
  icon_dic["completed"] = "🆗"

  for _, project in ipairs(projects) do
    for _, pb in ipairs(project.productBacklogs) do
      for _, sb in ipairs(pb.scrumBacklogs) do
        for _, task in ipairs(sb.tasks) do
          table.insert(items, {
            project = project.name,
            productBacklog = pb.name,
            scrumBacklog = sb.name,
            task = task.name,
            status = icon_dic[task.status] or "test",
            deadline = sb.deadline
          })
        end
      end
    end
  end


  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 2 },
      { width = 10 },
      { remaining = true },
      { remaining = true },
      { width = 10 },
    }
  }

  local make_display = function(entry)
    local metadata = entry.value
    return displayer {
      metadata.status,
      { metadata.project, "TelescopeResultsIdentifier" },
      "[" .. metadata.productBacklog .. " / " ..
      metadata.scrumBacklog .. "]",
      metadata.task,
      "⏲️ " .. metadata.deadline,
    }
  end

  pickers.new(opts, {
    prompt_title = "Projects",
    finder = finders.new_table({
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.project .. " " .. entry.productBacklog .. " " .. entry.scrumBacklog .. " " .. entry.task,
          path = "TODO.md",
        }
      end,
    }),
    previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry)
                -- 選択したタスクの詳細をプレビュー表示するロジックをここに実装
                -- selfはプレビューアのインスタンス、entryは選択したタスクの情報
                -- 以下はプレビューバッファにタスクのタイトルを表示する単純な例
                local lines = {"Task: " .. entry.value.task}
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            end,
        }),
    sorter = conf.generic_sorter({}),
  }):find()
end

return {
  showProjects = showProjects,
}
