---
--- Created by richardjiang.
--- DateTime: 2018/8/22 10:27
--- Lua 日志管理类
---


local function _formatStr(...)
    local l_arg = { ... }
    if not next(l_arg) then
        return
    elseif #l_arg==1 then
        return string.ro_trim(tostring(l_arg[1]))
    end
    local str = ""
    local n = select('#', ...)
    local first = tostring(select(1, ...))
    local isFormat = first and string.find(first, "%{%d+%}")
    if isFormat then
        local args = {}
        for i = 2, n do
            table.insert(args, string.ro_trim(tostring(select(i, ...))))
        end
        str = StringEx.Format(first, unpack(args))
    else
        for i = 1, n do
            str = str .. string.ro_trim(tostring(select(i, ...))) .. (n > 1 and '\t' or '')
        end
    end
    return str
end

-- 通用方法 --
local l_isRelease = not MGameContext.IsDebug
function log(...)
    if l_isRelease then
        return
    end
    MLuaCommonHelper.Log("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end
function logGreen(...)
    if l_isRelease then
        return
    end
    MLuaCommonHelper.LogGreen("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logYellow(...)
    if l_isRelease then
        return
    end
    MLuaCommonHelper.LogYellow("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logRed(...)
    if l_isRelease then
        return
    end
    MLuaCommonHelper.LogRed("[lua] ".._formatStr(...).."</color>\n[traceback] "..debug.traceback())
end
function logError(...)
    MLuaCommonHelper.LogError("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end
function logWarn(...)
    if l_isRelease then
        return
    end
    MLuaCommonHelper.LogWarning("[lua] ".._formatStr(...).."\n[traceback] "..debug.traceback())
end

function PCallAndDebug(method,value,...)
    local resultErrorCode,resultErrorInfo= pcall(method,value, ...)
    if resultErrorCode == false then
        logError(resultErrorInfo)
    end
end



