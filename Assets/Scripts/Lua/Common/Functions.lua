--==============================--
--@Description: 公共函数扩展
--@Date: 2018/8/22
--@Param: [args]
--@Return:
--==============================--
module("Common.Functions", package.seeall)
--[[
    获取字符串的32位哈希值（与c#方法对应）
    times33算法（快速哈希算法）
    返回32位uint，取值范围为[0, (2^32-1)]
    number取值范围为[-2^53, +2^53]
]]
function GetHash32(str)
    if str == nil then
        return 0
    end

    str = tostring(str)
    local l_hash = 0
    local l_strLen = string.len(str)
    for i = 1, l_strLen do
        l_hash = Common.Bit32._lshift(l_hash, 5) + l_hash + string.byte(str, i)
        if l_hash > 4294967295--[[2^32-1]] then
            --超出了uint的范围
            l_hash = l_hash - 4294967295 - 1 --因为取值从0开始，所以最终值为：超出的部分-1
        end
    end

    return l_hash
end

--c# list ==> table
function ListToTable(list)
    local result = {}
    local i = 1
    while i <= list.Count do
        result[i] = list[i - 1]
        i = i + 1
    end
    return result
end

--c#的vector数据转lua table数据
function VectorToTable(vector)
    local result = {}
    local i = 1
    while i <= vector.Length do
        result[i] = vector[i - 1]
        i = i + 1
    end
    return result
end

--c#的seq数据转lua table数据
function SequenceToTable(seq)
    local result = {}
    for i = 1, seq.Length do
        result[i] = seq[i - 1]
    end
    return result
end

--c#的vectorseq数据转lua table数据
function VectorSequenceToTable(info)
    local ret = {}
    for i = 1, info.Length do
        ret[i] = {}
        for j = 1, info[i - 1].Length do
            ret[i][j] = info[i - 1][j - 1]
        end
    end
    return ret
end

--vectorvector数据转luatable
function VectorVectorToTable(vecvec)
    local ret = {}
    for i = 0, vecvec.Length - 1 do
        ret[i + 1] = {}
        for j = 0, vecvec[i].Length - 1 do
            ret[i + 1][j + 1] = vecvec[i][j]
        end
    end
    return ret
end

ErrorList = nil
ErrorTable = nil
--根据错误id获取错误的描述字符串
function GetErrorCodeStr(errorId)

    --服务器返回过来的ErrorCode有的是不需要显示的 在GetErrorCode那里返回了字符串"NotShow"直接Return
    if errorId == ErrorCode.ERR_SERVER_CUSTOM_ERR or
            errorId == ErrorCode.ERR_CHECK_STATE_FAIL or
            errorId == ErrorCode.ERR_ROLE_NOTEXIST then
        --todo @tm 暂时屏蔽掉ERR_ROLE_NOTEXIST的提示，需要在下个版本处理掉这种错误
        return "NotShow"
    end

    if ErrorList == nil then
        ErrorList = {}
        for k, v in pairs(ErrorCode) do
            ErrorList[v] = string.ro_camelize(k)
        end
    end
    if ErrorTable == nil then
        ErrorTable = {}
        local tableInfo = TableUtil.GetErrorTable().GetTable()
        for i = 1, table.maxn(tableInfo) do
            ErrorTable[tableInfo[i].Id] = tableInfo[i].Value
        end
    end
    local errorStr = ErrorList[errorId]
    if errorStr then
        return ErrorTable[errorStr] or tostring(errorId)
    else
        return tostring(errorId)
    end
end

function GetErrorCodeKey(errorId)
    -- body
    if ErrorList == nil then
        ErrorList = {}
        for k, v in pairs(ErrorCode) do
            ErrorList[v] = string.ro_camelize(k)
        end
    end
    if ErrorList[errorId] ~= nil then
        return ErrorList[errorId]
    end
    logError("error code :<" .. errorId .. "> not exists !")

    return nil
end

--[[
    dump表结构（用做调试用）
    @params table hashTab 要dump的数据
    @params string desciption 输出的结构描述
    @params number nesting 最多dump的层级
]]
function DumpTable(hashTab, desciption, nesting)
    if type(nesting) ~= "number" then
        nesting = 3
    end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    logGreen("dump from: " .. (traceback[3]))

    local function _dump(datas, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(datas) ~= "table" then
            result[#result + 1] = StringEx.Format("{0}{1}{2} = {3}", indent, _v(desciption), spc, _v(datas))
        elseif lookupTable[datas] then
            result[#result + 1] = StringEx.Format("{0}{1}{2} = *REF*", indent, desciption, spc)
        else
            lookupTable[datas] = true
            if nest > nesting then
                result[#result + 1] = StringEx.Format("{0}{1} = *MAX NESTING*", indent, desciption)
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local l_newTable = {}
                for k, v in pairs(datas) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    l_newTable[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(l_newTable[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(hashTab, desciption, "- ", 1)

    for i, line in ipairs(result) do
        logGreen(line)
    end
end

---比较两个long的大小，返回为低32位+高32位
function Compare2long(long1, long2)
    local l_str1 = tostring(long1)
    local l_str2 = tostring(long2)
    local l_num1 = int64.new(l_str1)
    local l_num2 = int64.new(l_str2)
    local l_low1, l_hig1 = int64.tonum2(l_num1)
    local l_low2, l_hig2 = int64.tonum2(l_num2)
    return (l_low2 - l_low1), (l_hig2 - l_hig1)
end

function SecondsToTimeStr(second)
    local l_seconds = second % 60
    local l_mins = math.floor(second / 60)
    local l_hour = 0
    if l_mins > 60 then
        l_hour = math.floor(l_mins / 60)
        l_mins = l_mins % 60
    end
    return StringEx.Format("{0:00}:{1:00}:{2:00}", l_hour, l_mins, l_seconds)
end

--计算下线时间
--lastOfflineTime 最后下线的时间
function CalculateOfflineTimeToStr(lastOfflineTime)
    local l_curTime = tonumber(tostring(MServerTimeMgr.UtcSeconds))
    local l_offlineTimeStr = Lang("OFFLINE_STATE_COMMON")
    local l_offlineTime = l_curTime - lastOfflineTime
    if l_offlineTime < 1800 then
        l_offlineTimeStr = Lang("OFFLINE_STATE_RIGHTNOW")
    elseif l_offlineTime < 3600 then
        l_offlineTimeStr = Lang("OFFLINE_STATE_30MIN")
    elseif l_offlineTime < 86400 then
        l_offlineTimeStr = Lang("HOURS_AGO", tostring(math.floor(l_offlineTime / 3600)))
    elseif l_offlineTime < 2592000 then
        l_offlineTimeStr = Lang("DAYS_AGO", tostring(math.floor(l_offlineTime / 86400)))
    else
        --超过30天统一显示
        l_offlineTimeStr = Lang("OFFLINE_STATE_30DAY")
    end
    return l_offlineTimeStr
end
--秒转换为 天数 小时数 分钟数 秒数
function SecondsToDayTime(second)
    local tempTime = second > 0 and second or 0
    local day = math.floor(tempTime / 86400)
    tempTime = tempTime % 86400
    local hour = math.floor(tempTime / 3600)
    tempTime = tempTime % 3600
    local minuite = math.floor(tempTime / 60)
    local second = tempTime % 60

    return day, hour, minuite, second
end

--得到客户端存储PlayerPrefs的key
function GetPlayerPrefsKey(type)
    return tostring(MPlayerInfo.UID) .. type
end

-- --用法
-- switch(key)
-- {
--  [key1] = function()
--  end,
--  default = function()
--  end,
-- }
function switch(case)
    return function(cases)
        local l_func = cases[case] and cases[case] or cases.default
        if l_func then
            return l_func()
        end
    end
end

function handler(self, func)
    return function(...)
        return func(self, ...)
    end
end

--- 将数据强转到int64
---@return int64
function ToInt64(value)
    local ret = _convertToInt64(0)
    if nil == tonumber(value) then
        return ret
    end

    local retCode, pcallValue = pcall(_convertToInt64, tostring(value))
    if not retCode then
        logError("invalid int64 value: " .. tostring(value))
        return ret
    end

    return pcallValue
end

---@return int64
function _convertToInt64(value)
    return int64.new(value)
end

--- 将数据强转成为uint64
---@return uint64
function ToUInt64(value)
    local l_uint64Value = convertToUint64(0)
    if tonumber(value) == nil then
        return l_uint64Value
    end

    local l_suc, l_returnValue = pcall(convertToUint64, tostring(value))
    if l_suc then
        return l_returnValue
    else
        logError("uint64.new传递的数据不对，l_uid：" .. tostring(value) .. " error:" .. tostring(l_returnValue))
        return l_uint64Value
    end

    return l_uint64Value
end

---@return uint64
function convertToUint64(value)
    return uint64.new(value)
end

function ToString(t, level, tab, history)
    if level and level <= 0 then
        return tostring(t)
    elseif type(t) == "table" then
        local meta = getmetatable(t)
        if meta and meta.__tostring then
            return meta.__tostring(t)
        end
        tab = tab or 1
        local temp = {}
        for k, v in pairs(t) do
            local kstr
            local vstr
            if type(k) == "string" then
                kstr = k
            else
                kstr = "[" .. tostring(k) .. "]"
            end
            if type(v) == "table" then
                history = history or { [t] = "self" }
                if history[v] then
                    vstr = "<" .. tostring(history[v]) .. ">"
                else
                    history[v] = k
                    vstr = ToString(v, level and level - 1, tab + 1, history)
                end
            else
                vstr = ToString(v, level and level - 1, tab + 1, history)
            end
            if vstr then
                temp[#temp + 1] = string.rep("\t", tab) .. kstr .. " = " .. vstr
            end
        end
        return "{\n" .. table.concat(temp, ",\n") .. " }"
    elseif type(t) == "string" then
        return "'" .. t .. "'"
    else
        return tostring(t)
    end
end

function IsNil(obj)
    return obj == nil or obj:Equals(nil)
end

function IsEmptyOrNil(str)
    return not str or str == ""
end

function TimeSpanToString(span)
    local l_result = ""
    if span.Milliseconds > 0 then
        if span.Days > 0 then
            l_result = l_result .. Lang("TIME_DAY", span.Days)
        end
        if span.Days > 0 or span.Hours > 0 or span.Minutes > 0 or span.Seconds > 0 then

            l_result = l_result .. " " .. Lang("TIME_HOUR", span.Hours) .. Lang("TIME_MINUTE", span.Minutes) .. span.Seconds .. Lang("TIME_SECOND")
        end
    else
        l_result = l_result .. " " .. Lang("TIME_HOUR", tostring(0)) .. Lang("TIME_MINUTE", tostring(0)) .. tostring(0) .. Lang("TIME_SECOND")
    end
    return l_result
end

function NumberFormat(num, deperator)
    local str1 =""
    local str = tostring(num)
    local strLen = string.len(str)
        
    if deperator == nil then
        deperator = ","
    end
    deperator = tostring(deperator)
        
    for i = 1, strLen do
        str1 = string.char(string.byte(str, strLen + 1 - i)) .. str1
        if i % 3 == 0 then
            --下一个数 还有
            if strLen - i ~= 0 then
                str1 = ","..str1
            end
        end
    end
    return str1
end

-- 根据二进制位切分整数，分隔下表从1开始
function SplitNumber(n, splits)
    local l_splitNumbers = {}
    local l_binStr = System.Convert.ToString(n, 2)
    for _, split in ipairs(splits) do
        local l_subStr = string.sub(l_binStr, -split[2], -split[1])
        if l_subStr == "" then
            l_subStr = "0"
        end
        table.insert(l_splitNumbers, System.Convert.ToInt32(l_subStr ,2))
    end
    return table.unpack(l_splitNumbers)
end

local _patterns={
    "[cC][oO][lL][oO][rR]",
    "[sS][iI][zZ][eE]",
    "[qQ][uU][aA][dD]",
    "[bB]",
    "[iI]",
    "[mM][aA][tT][eE][rR][iI][aA][lL]",

}

function DeleteRichText(value)
    local currentPattern
    for i = 1, #_patterns do
        currentPattern="(</?".._patterns[i].."(.-)>)"
        value=(string.gsub(value, currentPattern, ""))
    end
    return value
end