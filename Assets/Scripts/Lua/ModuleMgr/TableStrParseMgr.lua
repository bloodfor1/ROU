--- 解析配置表当中的string的，可以指定类型

---@module ModuleMgr.TableStrParseMgr
module("ModuleMgr.TableStrParseMgr", package.seeall)

local C_MATRIX_SPLIT_SYMBOL = "|"
local C_ARRAY_SPLIT_SYMBOL = "="

local function _parseValue(str, type)
    if GameEnum.ELuaBaseType.String == type then
        return str
    elseif GameEnum.ELuaBaseType.Number == type then
        return tonumber(str)
    end

    return nil
end

local function _parseInlineArray(str, type, symbol)
    local strArray = string.ro_split(str, symbol)
    if GameEnum.ELuaBaseType.String == type then
        return strArray
    elseif GameEnum.ELuaBaseType.Number == type then
        local ret = {}
        for i = 1, #strArray do
            ret[i] = tonumber(strArray[i])
        end

        return ret
    end

    return nil
end

local function _parseArray(str, type)
    return _parseInlineArray(str, type, C_MATRIX_SPLIT_SYMBOL)
end

local function _parseMatrix(str, resultType)
    if GameEnum.ELuaBaseType.String ~= type(str) then
        return nil
    end

    local arrayList = string.ro_split(str, C_MATRIX_SPLIT_SYMBOL)
    local matrix = {}
    for i = 1, #arrayList do
        matrix[i] = _parseInlineArray(arrayList[i], resultType, C_ARRAY_SPLIT_SYMBOL)
    end

    return matrix
end

local C_TYPE_FUNC_MAP = {
    [GameEnum.EStrParseType.Value] = _parseValue,
    [GameEnum.EStrParseType.Array] = _parseArray,
    [GameEnum.EStrParseType.Matrix] = _parseMatrix,
}

--- 比如工会活动表当中的value，就是用这个方法进行解析的
--- 第二个参数是数据维度类型，对应枚举GameEnum.EStrParseType
--- 第三个参数对应维度类型，对应GameEnum.ELuaBaseType，只解析string和number
---@param str string
---@param resultStruct number
---@param resultType string
function ParseValue(str, resultStruct, resultType)
    if nil == str then
        logError("[StringParser] invalid param")
        return nil
    end

    local func = C_TYPE_FUNC_MAP[resultStruct]
    if nil == func then
        logError("[StringParser] invalid type: " .. tostring(resultStruct))
        return nil
    end

    local ret = func(str, resultType)
    return ret
end