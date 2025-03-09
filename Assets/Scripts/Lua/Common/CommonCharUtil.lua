---@module Common.CommonCharUtil
module("Common.CommonCharUtil", package.seeall)

local L_CONST_WIDE_CHAR_COUNT = {
    [1] = 1,
    [2] = 2,
    [3] = 2,
    [4] = 2,
}

local L_CONST_NO_WIDE_CHAR_COUNT = {
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 1,
}

-- 计算字符数量，全角字符算一个
---@param str string
---@param isWideCharContained boolean
---@return number
function CalcCharCount(str, isWideCharContained)
    if not str or #str <= 0 then
        return 0
    end

    local l_length = 0
    local i = 1
    while true do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 239 then
            byteCount = 4  -- 4字节字符
        elseif curByte > 223 then
            byteCount = 3  -- 汉字
        elseif curByte >= 128 then
            byteCount = 2  -- 双字节字符
        else
            byteCount = 1  -- 单字节字符
        end

        -- 根据是否是计算全角字符来进行判定
        local l_value = 0
        if isWideCharContained then
            l_value = L_CONST_WIDE_CHAR_COUNT[byteCount]
        else
            l_value = L_CONST_NO_WIDE_CHAR_COUNT[byteCount]
        end

        l_length = l_length + l_value
        i = i + byteCount
        if i > #str then
            break
        end
    end

    return l_length
end