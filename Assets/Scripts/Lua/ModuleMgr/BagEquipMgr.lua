require "Data/Model/BagApi"

module("ModuleMgr.BagEquipMgr", package.seeall)

local l_currentSelectEquipPart = nil
local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()

--背包中是否有这个装备部位的装备
function IsHaveEquipWithEquipPart(equipPart)
    local items = _getItemsInBagByEquipID(equipPart)
    return 0 < #items
end

--- 通过EquipID来获取背包中的道具
---@return ItemData[]
function _getItemsInBagByEquipID(equipID)
    if GameEnum.ELuaBaseType.Number ~= type(equipID) then
        logError("[BagEquipMgr] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesEquipID, Param = equipID }
    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function GetCurrentSelectEquipPart()
    return l_currentSelectEquipPart
end

function SetCurrentSelectEquipPart(equipPart)
    l_currentSelectEquipPart = equipPart
end