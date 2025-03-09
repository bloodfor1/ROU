require "Data/Model/BagApi"

module("ModuleMgr.BodyEquipMgr", package.seeall)

--根据服务器的装备部位枚举，取表里配的装备部位（EquipId）
function GetEquipPartWithServerEnum(serverEnum)
    local l_trueServerEnum = serverEnum
    if serverEnum == EquipPos.ORNAMENT2 then
        l_trueServerEnum = EquipPos.ORNAMENT1
    else
        l_trueServerEnum = serverEnum
    end

    for i = 1, #Data.BagModel.WeapTableType do
        if Data.BagModel.WeapTableType[i] == l_trueServerEnum then
            return i
        end
    end

    return 0
end

--根据表里配的装备部位（EquipId），取服务器的装备部位枚举
function GetEquipServerEnumWithEquipPart(equipPart)
    return Data.BagModel.WeapTableType[equipPart]
end

---@param itemData ItemData
function GetEquipServerEnumWithPropInfo(itemData)
    local l_equipTableInfo = itemData.EquipConfig
    if l_equipTableInfo == nil then
        return 0
    end

    return Data.BagModel.WeapTableType[l_equipTableInfo.EquipId]
end

--根据表里配的装备部位（EquipId），取身上的装备
function GetBodyEquipWithEquipPart(equipPart)
    local serverEnum = GetEquipServerEnumWithEquipPart(equipPart)
    local clientEnum = serverEnum + 1
    return Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, clientEnum)
end

--根据服务器的装备部位枚举，取身上的装备
function GetBodyEquipWithServerEnum(serverEnum)
    local clientEnum = serverEnum + 1
    return Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, clientEnum)
end

--是否装备了双手武器
function IsEquipDoubleHandWeapon()
    local l_mainWeapon = GetBodyEquipWithServerEnum(Data.BagModel.WeapType.MainWeapon)
    if l_mainWeapon == nil then
        return false
    end
    local l_isDoubleHandWeapon = MgrMgr:GetMgr("EquipMgr").IsDoubleHandWeaponWithId(l_mainWeapon.TID)
    if l_isDoubleHandWeapon then
        return true
    end
    return false
end

--是否装备了两个手拿的武器
function IsEquipUseTwoHandWeapon()
    local l_mainWeapon = GetBodyEquipWithServerEnum(Data.BagModel.WeapType.MainWeapon)
    if l_mainWeapon == nil then
        return false
    end
    local l_isDoubleHandWeapon = MgrMgr:GetMgr("EquipMgr").IsWeaponUseTwoHandWithId(l_mainWeapon.TID)
    if l_isDoubleHandWeapon then
        return true
    end
    return false
end

--是否装备了盾牌
function IsEquipShield()
    local l_assist = GetBodyEquipWithServerEnum(Data.BagModel.WeapType.Assist)
    if l_assist == nil then
        return false
    end
    local l_isShield = MgrMgr:GetMgr("EquipMgr").IsShieldWithId(l_assist.TID)
    if l_isShield then
        return true
    end
    return false
end

--根据uid取设身上的装备
function GetBodyEquipWithUid(uid)
    if nil == uid then
        logError("[BodyEquipMgr] invalid param type: " .. type(uid))
        return {}
    end

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    local types = {
        GameEnum.EBagContainerType.Equip,
    }

    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

---@return ItemData
function _getItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--根据uid取装备是否在身上或在背包里
function IsEquipOnBodyOrBagWithUid(uid)
    local l_equip
    l_equip = GetBodyEquipWithUid(uid)
    if l_equip then
        return true
    end

    local l_equip = _getItemByUID(uid)
    if l_equip then
        return true
    end
    return false
end

--根据id取身上的装备
function GetBodyEquipWithId(id)
    if GameEnum.ELuaBaseType.Number ~= type(id) then
        logError("[BodyEquipMgr] invalid param type: " .. type(id))
        return {}
    end

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    local types = {
        GameEnum.EBagContainerType.Equip,
    }

    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, id }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--根据id取装备是否在身上或在背包里
function IsEquipOnBodyOrBagWithId(id)
    local l_equip
    l_equip = GetBodyEquipWithId(id)
    if l_equip then
        return true
    end

    local l_count = Data.BagModel:GetBagItemCountByTid(id)
    if l_count > 0 then
        return true
    end
    return false
end

function IsFullEquipOnBody()
    local l_equips = _getAllEquips()
    local l_equipPositions = Data.BagModel.WeapTableType
    if table.ro_size(l_equips) == table.ro_size(l_equipPositions) then
        return true
    end

    return false
end

--- 获取所有的装备
---@return ItemData[]
function _getAllEquips()
    local types = {
        GameEnum.EBagContainerType.Equip,
    }

    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

--得到当前的装备数据
--equipsData是RoleAllInfo中的Equips数据
function GetCurrentBodyEquipsWithServerEquipsData(equipsData)
    return GetBodyEquipsByPageWithServerEquipsData(equipsData, equipsData.cur_page + 1)
end

--根据page得到装备数据
--equipsData是RoleAllInfo中的Equips数据
function GetBodyEquipsByPageWithServerEquipsData(equipsData, page)
    local l_allPageEquips = equipsData.equip_page
    if page <= 0 or page > #l_allPageEquips then
        logError("传递的page有问题，page：" .. tostring(page))
        page = 1
    end

    return l_allPageEquips[page].equip
end