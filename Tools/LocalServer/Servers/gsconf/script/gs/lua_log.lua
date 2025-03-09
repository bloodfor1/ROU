local function _formatStr(...)
    local l_arg = { ... }
    if not next(l_arg) then
        return
    elseif #l_arg==1 then
        return tostring(l_arg[1])
    end
    local str = ""
    local n = select('#', ...)
    local first = tostring(select(1, ...))
    local isFormat = first and string.find(first, "%{%d+%}")
    if isFormat then
        local args = {}
        for i = 2, n do
            table.insert(args, tostring(select(i, ...)))
        end
        str = StringEx.Format(first, unpack(args))
    else
        for i = 1, n do
            str = str .. ( n > 1 and '\t' or '') .. tostring(select(i, ...))
        end
    end
    return str
end

-- 通用方法 --
function log(...)
    print("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end
function logGreen(...)
    print("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logYellow(...)
    print("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logRed(...)
    print("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logError(...)
    print("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end
function logWarn(...)
    print("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end