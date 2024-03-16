-- nvim-todo/lua/nvim-todo/utils/utils.lua
local M = {}

-- ファイルの存在を確認する関数
function M.file_exists(file_path)
    local f = io.open(file_path, "r")
    if f then
        io.close(f)
        return true
    else
        return false
    end
end

-- ファイルからテキストを読み込む関数
function M.read_file(file_path)
    if not M.file_exists(file_path) then
        return nil, "File does not exist: " .. file_path
    end

    local file = io.open(file_path, "r")
    local content = file:read("*all")
    file:close()
    return content
end

-- ファイルにテキストを書き込む関数
function M.write_file(file_path, content)
    local file = io.open(file_path, "w")
    file:write(content)
    file:close()
end

-- 文字列をトリムする関数
function M.trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- 現在の日付を YYYY-MM-DD 形式で取得する関数
function M.get_current_date()
    return os.date("%Y-%m-%d")
end

return M
