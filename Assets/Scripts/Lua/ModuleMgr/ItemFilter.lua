---@module ModuleMgr.ItemFilter
module("ModuleMgr.ItemFilter", package.seeall)

--- 条件列表当中的数据
---@class FiltrateCond
---@field Cond fun (item:ItemData, param):boolean
---@field Param number

-- 对给定的列表进行过滤
---@param itemTable table<string, ItemData>
---@param condMap FiltrateCond[]
---@return ItemData[]
function FiltrateItemData(itemTable, condMap)
    if not itemTable then
        return {}
    end

    -- 遍历条件列表
    local ret = {}
    for uid, itemData in pairs(itemTable) do
        local cond = _isCondSatisfied(condMap, itemData)
        if cond then
            table.insert(ret, itemData)
        end
    end

    return ret
end

-- 道具是否满足条件，利用lua本身的特性来完成表驱动道具过滤
---@param propInfo ItemData
---@param condMap FiltrateCond[]
---@return boolean
function _isCondSatisfied(condMap, propInfo)
    if nil == propInfo then
        logError("[ItemFilter] item must not be nil")
        return false
    end

    if nil == condMap then
        return true
    end

    -- 这里判断是一个短路逻辑，如果有一个条件没有满足，就说明这个条件不满足
    for i = 1, #condMap do
        local l_singleCond = condMap[i]
        if l_singleCond then
            local l_condFunc = l_singleCond.Cond
            local l_param = l_singleCond.Param
            local result = l_condFunc(propInfo, l_param)
            if not result then
                return false
            end
        end
    end

    return true
end

return ModuleMgr.ItemFilter