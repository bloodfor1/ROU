--region Expand.lua
--Author : tmtan
--Date   : 2017/12/27
--方法扩展

-------------------------------------------------------------------------
----------------------------  String Function  ---------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--[Comment]
--分隔字符串
--@return 分隔后的串组成的table
string.ro_split = function(str, delimiter)

    if str == nil or str == '' or delimiter == nil then
        return {}
    end

    local l_result = {}

    local l_lastIndex = 1
    repeat
        local l_start, l_end = string.find(str, delimiter, l_lastIndex)
        if not l_start or not l_end then
            break
        end

        table.insert(l_result, string.sub(str, l_lastIndex, l_start - 1))
        l_lastIndex = l_end + 1
    until false

    if l_lastIndex <= #str then
        table.insert(l_result, string.sub(str, l_lastIndex, #str))
    end

    return l_result
end

--[Comment]
--去除首尾空格
string.ro_trim = function(str)
    if not str then
        return ""
    end
    --这里不加外层括号的话会返回两个值，一个是去除首尾空格后的字串，一个是替换的次数
    return (string.gsub(str, "^[%s|%z]*(.-)[%s|%z]*$", "%1"))
end

string.ro_camelize = function(str)
    if string.ro_isEmpty(str) then
        return ""
    end

    local l_camelize = (string.gsub(string.lower(str), "_[a-zA-z%d]", function(findstr)
        return string.upper(string.sub(findstr, 2, 2))
    end))

    return string.upper(string.sub(l_camelize, 1, 1)) .. string.sub(l_camelize, 2)
end

--[Comment]
--判断字符串是否含有非法字符
string.ro_isLegal = function(str)
    local l_str = tostring(str)
    local l_isLegal = nil
    local l_nLenInByte = #l_str
    local l_curByte = 0
    for i = 1, l_nLenInByte do
        l_curByte = string.byte(l_str, i)
        if l_curByte >= 97 and l_curByte <= 123 then
            l_isLegal = false
        elseif l_curByte >= 65 and l_curByte <= 90 then
            l_isLegal = false
        elseif l_curByte >= 48 and l_curByte <= 57 then
            l_isLegal = false
        elseif l_curByte > 127 then
            l_isLegal = false
        else
            l_isLegal = true
        end

        if l_isLegal then
            return true
        end
    end

    return l_isLegal
end

local function ro_chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

--判断手机用户是否输入了表情符
string.ro_emoji = function(str)
    local l_len = string.len(str)
    for i = 1, l_len do
        local l_char = string.byte(str, i)
        local l_size = ro_chsize(l_char)
        i = i + l_size - 1
        if not ((l_char == 0x00) or (l_char == 0x9) or
                (l_char == 0xA) or (l_char == 0xD) or
                ((l_char >= 0x20) and (l_char <= 0xD7FF)) or
                ((l_char >= 0xE000) and (l_char <= 0xFFFD)) or
                ((l_char >= 0x10000) and (l_char <= 0x10FFFF))) then
            return true
        end
    end
    return false
end

--[Comment]
--获取字符串长度(汉字按长度2计算)
string.ro_len = function(str)
    local l_str = tostring(str)

    local nLenInByte = #l_str
    local nWidth = 0

    for i = 1, nLenInByte do
        local curByte = string.byte(l_str, i)
        local byteCount = 0;
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 224 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 240 then
            byteCount = 3
        elseif curByte >= 240 and curByte < 248 then
            byteCount = 4
        end

        if byteCount > 0 then
            i = i + byteCount - 1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
        elseif byteCount > 1 then
            nWidth = nWidth + 2
        end
    end

    return nWidth
end

--[Comment]
--获取标准化字符串长度(汉字按长度1计算)
string.ro_len_normalize = function(str)
    local l_str = tostring(str)

    local nLenInByte = #l_str
    local nWidth = 0

    for i = 1, nLenInByte do
        local curByte = string.byte(l_str, i)
        local byteCount = 0;
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 224 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 240 then
            byteCount = 3
        elseif curByte >= 240 and curByte < 248 then
            byteCount = 4
        end

        if byteCount >= 1 then
            nWidth = nWidth + 1
        end
    end

    return nWidth
end

--[Comment]
--截取字符串(汉字按长度2计算)
string.ro_cut = function(str, count)
    local l_str = tostring(str)
    local l_count = tonumber(count)
    if l_count == nil then
        return l_str
    end

    local tCode = {}
    local tName = {}
    local nLenInByte = #l_str
    local nWidth = 0

    for i = 1, nLenInByte do
        local curByte = string.byte(l_str, i)
        local byteCount = 0;
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 224 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 240 then
            byteCount = 3
        elseif curByte >= 240 and curByte < 248 then
            byteCount = 4
        end

        local char = nil
        if byteCount > 0 then
            char = string.sub(l_str, i, i + byteCount - 1)
            i = i + byteCount - 1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName, char)
            table.insert(tCode, 1)
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName, char)
            table.insert(tCode, 2)
        end
    end

    if nWidth > l_count then
        local _sN = ""
        local _len = 0
        for i = 1, #tName do
            _len = _len + tCode[i]
            if _len > l_count then
                break
            end
            _sN = _sN .. tName[i]
        end
        str = _sN
    end

    return str
end

--[Comment]
--判断字符串是否为空
--@return 非字符串和非数字返回true，长度为0的串返回true，其他false
string.ro_isEmpty = function(str)
    local l_strType = type(str)
    if l_strType ~= "string" and l_strType ~= "number" then
        return true
    end

    if string.ro_len(str) == 0 then
        return true
    end

    return false
end

string.ro_concat = function(...)
    local arg = { ... }
    return table.concat(arg, "")
end

--[Comment]
--将utf8字符串拆分成单个字符
--@return 返回单个字符以及字符占位大小
string.ro_toChars = function(str)
    local l_result = {}
    local l_strType = type(str)
    if l_strType == "string" then

        local l_len = string.len(str)
        local l_index = 1
        while l_index <= l_len do
            local l_char = string.byte(str, l_index)
            local l_charSize = ro_chsize(l_char)
            local l_str = string.sub(str, l_index, l_index + l_charSize - 1)
            l_index = l_index + l_charSize
            table.insert(l_result, { charSize = l_charSize, char = l_str })
        end
    end

    return l_result
end

-------------------------------------------------------------------------
----------------------------  Table Function  ---------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--[Comment]
--表去重
--@return 返回去重的表
table.ro_unique = function(tb)
    local l_ret = {}
    local l_valueSet = {}
    for k, v in pairs(tb) do
        if l_valueSet[v] == nil then
            l_valueSet[v] = true
            table.insert(l_ret, v)
        end
    end

    return l_ret
end

--[Comment]
--获取table大小
table.ro_size = function(tb)
    local l_size = 0
    for _, _ in pairs(tb) do
        l_size = l_size + 1
    end

    return l_size
end

--[Comment]
--table排序（hash表才用这个方法，数组表请直接用table.sort）
--@return 返回元素为{key=xx1, value=xx2}的数组表
table.ro_sort = function(hashTb, sortFunc)
    local sortTab = {}
    for k, v in pairs(hashTb) do
        table.insert(sortTab, { ["key"] = k, ["value"] = v })
    end
    table.sort(sortTab, function(a, b)
        return sortFunc(a.value, b.value)
    end)

    return sortTab
end

--[Comment]
--table克隆
table.ro_clone = function(tb)
    local retTab = {}
    for k, v in pairs(tb) do
        retTab[k] = v
    end

    return retTab
end

--[Comment]
--table深拷贝
table.ro_deepCopy = function(object)
    local SearchTable = {}
    local function Func(object)
        if type(object) ~= "table" then
            return object
        elseif SearchTable[object] then
            return SearchTable[object]
        end
        local NewTable = {}
        SearchTable[object] = NewTable
        for k, v in pairs(object) do
            NewTable[Func(k)] = Func(v)
        end

        return setmetatable(NewTable, getmetatable(object))
    end
    return Func(object)
end

--[Comment]
--判断table中是否包含值（支持hash表和数组表）
--@author tm
--@return 是否包含
table.ro_contains = function(tb, value)
    for k, v in pairs(tb) do
        if v == value then
            return true
        end
    end

    return false
end

--- 判断table中是否包含键value
---@param value any 查找的key
---@return boolean true若包含
table.ro_containsKey = function(tb, value)
    for k, v in pairs(tb) do
        if k == value then
            return true
        end
    end

    return false
end

---递归检查两表格中的值是否相同，仅支持 nil,boolean,number,string,table类型
---@return boolean true若两表完全相等
table.ro_deepCompare = function(tb1, tb2)
    if type(tb1) ~= type(tb2) then -- 类型不匹配
        return false
    elseif type(tb1) == "table" then -- 都是表，比较表类型的大小
        if #tb1 ~= #tb2 then -- 大小不匹配
            return false
        else -- 大小匹配
            for key, _ in pairs(tb1) do
                if table.ro_containsKey(tb2, key) then -- 键值匹配
                    if not table.ro_deepCompare(tb1[key], tb2[key]) then -- 递归调用判断表是否相同
                        return false
                    end
                else -- 键值不匹配，两表不相同
                    return false
                end
            end
            return true
        end
    else -- 相同类型对象比较
        return tb1 == tb2
    end
end

--[Comment]
--table连接成字符串（支持hash表|数组表|userdata）
--@author tm
table.ro_kvConcat = function(tb)
    local l_retMsg = ""
    for k, v in pairs(tb) do
        if type(v) == "table" then
            l_retMsg = l_retMsg .. "|" .. table.ro_concat(v)
        elseif type(v) == "userdata" then
            local l_meta = getmetatable(v)
            l_meta = l_meta[".get"] or {}
            l_retMsg = l_retMsg .. "|" .. table.ro_concat(l_meta)
        else
            l_retMsg = l_retMsg .. "|" .. tostring(k) .. ":" .. tostring(v)
        end
    end

    return l_retMsg
end

--[Comment]
--table连接成字符串（只支持hash表，数组表请用table.concat）
--@author tm
table.ro_concat = function(hashTb, delimitation)
    local l_tmpTable = table.ro_values(hashTb)

    return table.concat(l_tmpTable, delimitation)
end

--[[
获取key组成的数组表（只支持hash表）
--]]
table.ro_keys = function(hashTb)
    local keys = {}
    for k, v in pairs(hashTb) do
        keys[#keys + 1] = k
    end

    return keys
end

--[[
获取value组成的数组表（只支持hash表）
--]]
table.ro_values = function(hashTb)
    local values = {}
    for k, v in pairs(hashTb) do
        values[#values + 1] = v
    end

    return values
end

table.ro_removeValue = function(tb, value)
    for i = #tb, 1, -1 do
        if tb[i] == value then
            table.remove(tb, i)
        end
    end
end

table.ro_removeOneSameValue = function(tb, value)
    for i = #tb, 1, -1 do
        if tb[i] == value then
            table.remove(tb, i)
            return i
        end
    end
    return 0
end

table.ro_insertRange = function(tb, values)
    if tb == nil then
        return
    end
    if values == nil then
        return
    end
    for i = 1, #values do
        table.insert(tb, values[i])
    end
end

table.ro_insertIndexRange = function(tb, values, index)
    if tb == nil then
        return
    end
    if values == nil then
        return
    end
    for i = 1, #values do
        table.insert(tb, index+i-1, values[i])
    end
end

table.count = table.ro_size

table.mergeArray = function(t1, t2)
    local ret = t1
    if not t1 or not t2 then
        return ret
    end
    for i, v in ipairs(t2) do
        table.insert(ret, v)
    end
    return t1
end

table.ro_reverse = function(tb)
    local ret = {}
    local table_insert = table.insert
    for i = #tb, 1, -1 do
        table_insert(ret, tb[i])
    end
    return ret
end

table.removebyvalue = function(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end
--==============================--
--@Description:是否包含另一个c#数组中的任意某个值
--@Date: 2019/6/20
--@Param: [args]
--@Return:
--==============================--
table.ro_containAnyInArray = function(tb, array)
    if tb == nil or array == nil then
        return false
    end
    local l_tbLen = #tb
    local l_arrayLen = #array
    for i = 1, l_tbLen do
        for j = 0, l_arrayLen - 1 do
            if tb[i] == array[j] then
                return true, array[i]
            end
        end
    end
    return false
end

local math_floor = math.floor
math.floor = function(n)
    if type(n) == "userdata" and n.tonum2 then
        return n
    end

    return math_floor(n)
end

local math_ceil = math.ceil
math.ceil = function(n)
    if type(n) == "userdata" and n.tonum2 then
        return n
    end

    return math_ceil(n)
end

--- 为什么直接覆盖，因为lua5.1 源码当中也是遍历参数个数来做的
--- 这种做法还能解决参数当中传了nil的问题，现在传了nil不会报错，而且支持int64和其他重载了元表的类
math.min = function(x, ...)
    local paramList = { ... }
    local ret = x
    for k, v in pairs(paramList) do
        if v < ret then
            ret = v
        end
    end

    return ret
end

math.max = function(x, ...)
    local paramList = { ... }
    local ret = x
    for k, v in pairs(paramList) do
        if v > ret then
            ret = v
        end
    end

    return ret
end

--- 分离小数和整数，如果是int64或者是uint64，则直接返回一个值和0
local math_modf = math.modf
math.modf = function(n)
    if "userdata" == type(n) and n.tonum2 then
        return n, 0
    end

    return math_modf(n)
end

local oldTonumber = tonumber
tonumber = function(e, base)
    if type(e) == "userdata" and e.tonum2 then
        return e:tonum2()
    end

    return oldTonumber(e, base)
end