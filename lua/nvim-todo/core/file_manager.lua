local Parser = require("nvim-todo.core.parser")  -- 適切なパスに修正

local FileManager = {}

-- マークダウンファイルからプロジェクトの状態を読み込む関数
function FileManager.loadProjects(filePath)
    local file, err = io.open(filePath, "r")
    if not file then
        error("Failed to open file for reading: " .. err)
    end
    local content = file:read("*all")
    file:close()

    return Parser.parse(content)
end

-- プロジェクトの状態をマークダウンファイルに書き出す関数
function FileManager.saveProjects(projects, filePath)
    local file, err = io.open(filePath, "w")
    if not file then
        error("Failed to open file for writing: " .. err)
    end

    local markdownContent = Parser.toMarkdown(projects)
    file:write(markdownContent)
    file:close()
end

return FileManager
