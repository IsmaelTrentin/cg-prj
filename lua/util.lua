local M = {}

M.NULL_DEVICE = os.ishost 'windows' and 'NUL' or '/dev/null'
M.SILENT = ' > ' .. M.NULL_DEVICE .. ' 2>&1'

function M.exists(path)
    local ok, err, code = os.rename(path, path)
    if ok then
        return true
    end

    -- code 13 = EACCES (permission denied)
    if code == 13 then
        return true
    end
    return false
end

function M.is_path_in_prj(target)
    -- normalize ..
    local root = path.getabsolute(_MAIN_SCRIPT_DIR)
    local abs = path.getabsolute(target)

    -- Windows paths are case-insensitive......
    if os.ishost 'windows' then
        root = root:lower()
        abs = abs:lower()
    end

    return abs ~= root and abs:sub(1, #root + 1) == root .. '/'
end

return M
