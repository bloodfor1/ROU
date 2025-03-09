require "Data/Model/EquipReformApi"

---@module ModuleMgr.EquipReformMgr
module("ModuleMgr.EquipReformMgr", package.seeall)

EquipReformApi = Data.EquipReformApi.new()
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
local playerEquipFilter = MgrMgr:GetMgr("PlayerItemFilter")
local EAttrType = GameEnum.EItemAttrModuleType

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemChangeBroadCast, nil)
end

function OnLogout()
    EquipReformApi:Clear()
end

---@param data ItemData[]
---@return ItemData[]
function GetSelectEquips(data)
    if nil == data then
        logError("[EquipReform] invalid param")
        return data
    end

    local equipIDs = {
        GameEnum.EEquipSlotType.Weapon,
        GameEnum.EEquipSlotType.Armor,
        GameEnum.EEquipSlotType.Cape,
        GameEnum.EEquipSlotType.Boot,
        GameEnum.EEquipSlotType.BackUpHand,
    }

    local equipTypeIDs = {
        GameEnum.EEquipSourceType.Forge,
        GameEnum.EEquipSourceType.Instance,
    }

    local equipIDCond = { cond = _itemMatchesEquipIDList, param = equipIDs }
    local equipTypeIDCond = { cond = _itemMatchesSource, param = equipTypeIDs }
    local equipLvCond = { cond = _validReformLv, param = equipTypeIDs }
    local condMap = {
        equipIDCond,
        equipTypeIDCond,
        equipLvCond
    }

    local ret = playerEquipFilter.FiltrateItemData(data, condMap)
    return ret
end

function GetNoneEquipText()
    return Common.Utils.Lang("C_NO_REFORM_EQUIP")
end

--- 验证道具是否符合条件
---@param item ItemData
---@return boolean
function ValidateSingleItem(item)
    if nil == item then
        logError("[EquipReform] invalid param")
        return false
    end

    local equipIDs = {
        GameEnum.EEquipSlotType.Weapon,
        GameEnum.EEquipSlotType.Armor,
        GameEnum.EEquipSlotType.Cape,
        GameEnum.EEquipSlotType.Boot,
        GameEnum.EEquipSlotType.BackUpHand,
    }

    local equipTypeIDs = {
        GameEnum.EEquipSourceType.Forge,
        GameEnum.EEquipSourceType.Instance,
    }

    if not _validReformLv(item) then
        return false
    end

    local equipIDMatchResult = _itemMatchesEquipIDList(item, equipIDs)
    local equipTypeIDMatchResult = _itemMatchesSource(item, equipTypeIDs)
    return equipIDMatchResult and equipTypeIDMatchResult
end

---@param itemData ItemData
function _validReformLv(itemData)
    if nil == itemData then
        return false
    end

    local C_VALID_LV = MGlobalConfig:GetInt("EquipReformlevelLimit")
    local ret = C_VALID_LV <= itemData:GetEquipTableLv()
    return ret
end

--- 确认改造，数据是保存在API当中的，所以不需要传参
function ReqEquipReform()
    local currentItem = EquipReformApi:GetCurrentSelectItem()
    if nil == currentItem then
        logError("[EquipReformMgr] current item got nil, plis check")
        return
    end

    local uid = currentItem.UID
    local msgID = Network.Define.Rpc.EquipReform
    ---@type EquipReformArg
    local msg = GetProtoBufSendTable("EquipReformArg")
    msg.uid = uid
    Network.Handler.SendRpc(msgID, msg)
end

function OnEquipReformConfirmed(msg)
    ---@type EquipReformRes
    local pbMsg = ParseProtoBufToTable("EquipReformRes", msg)
    local errorCode = pbMsg.result
    if ErrorCode.ERR_SUCCESS ~= errorCode then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(errorCode)
    end
end

--- 获取当前被选中的道具数据
---@return ItemData
function GetCurrentItemData()
    return EquipReformApi:GetCurrentSelectItem()
end

--- 设置制定的道具数据
---@param itemData ItemData
function SetCurrentItemData(itemData)
    if nil == itemData then
        logError("[EquipReformMgr] current item got nil, plis check")
        return
    end

    EquipReformApi:SetCurrentSelectItem(itemData)
end

--- 获取缓存的对比数据
---@param itemData ItemData
---@return ItemData
function GetCacheItemData(itemData)
    if nil == itemData then
        logError("[EquipReformMgr] current item got nil, plis check")
        return nil
    end

    local uid = itemData.UID
    return EquipReformApi:GetCacheDataByUid(uid)
end

--- 获取道具需要显示的流派属性和基础属性
---@param itemData ItemData
---@return EquipAttrPair[]
function GetItemDisplayAttrs(itemData)
    if nil == itemData then
        logError("[EquipReform] invalid param")
        return {}
    end

    local baseAttrList = itemData.AttrSet[EAttrType.Base]
    local paramBaseAttrs = nil
    if nil ~= baseAttrList then
        paramBaseAttrs = baseAttrList[1]
    end

    local schoolAttrList = itemData.AttrSet[EAttrType.School]
    local paramSchoolAttrs = nil
    if nil ~= schoolAttrList then
        paramSchoolAttrs = schoolAttrList[1]
    end

    local strs = _genAttrDescList(paramBaseAttrs, paramSchoolAttrs, itemData.EquipConfig.EquipText)
    local attrList = {}
    local ret = {}
    table.ro_insertRange(attrList, paramBaseAttrs)
    table.ro_insertRange(attrList, paramSchoolAttrs)
    for i = 1, #attrList do
        local singleAttr = attrList[i]
        local isRare = singleAttr.RareAttr
        ---@type EquipAttrPair
        local singlePair = {
            desc = strs[i],
            isRare = isRare,
        }

        table.insert(ret, singlePair)
    end

    return ret
end

--- 获取道具的极品属性
---@param itemData ItemData
---@return string[]
function GetItemMaxAttrDesc(itemData)
    if nil == itemData then
        logError("[EquipReform] invalid input data")
        return {}
    end

    local baseAttrs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.MaxBase)
    local schoolAttrs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.MaxStyle)
    local strs = _genAttrDescList(baseAttrs, schoolAttrs, itemData.EquipConfig.EquipText)
    local attrList = {}
    local ret = {}
    table.ro_insertRange(attrList, baseAttrs)
    table.ro_insertRange(attrList, schoolAttrs)
    for i = 1, #attrList do
        ---@type EquipAttrPair
        local singlePair = {
            desc = strs[i],
            isRare = true,
        }

        table.insert(ret, singlePair)
    end

    return ret
end

--- 获取道具的那个改造消耗
---@param itemData ItemData
---@return ItemData[]
function GetItemReformConsume(itemData)
    if nil == itemData then
        logError("[EquipReform] invalid param")
        return {}
    end

    local C_EQUIP_ID_MAP = {
        GameEnum.EEquipSlotType.Weapon,
        GameEnum.EEquipSlotType.Armor,
        GameEnum.EEquipSlotType.Cape,
        GameEnum.EEquipSlotType.Boot,
        GameEnum.EEquipSlotType.BackUpHand,
    }

    local ret = {}
    local itemLv = itemData.ItemConfig.LevelLimit:get_Item(0)
    local equipReformTable = TableUtil.GetEquipReformTable().GetTable()
    for i = 1, #equipReformTable do
        local singleConfig = equipReformTable[i]
        if itemLv >= singleConfig.Level[0] and itemLv < singleConfig.Level[1] then

            ---@type number[][]
            local consumeConfig = nil
            if GameEnum.EEquipSlotType.Weapon == itemData.EquipConfig.EquipId then
                consumeConfig = singleConfig.Weaponcost
            elseif nil ~= C_EQUIP_ID_MAP[itemData.EquipConfig.EquipId] then
                consumeConfig = singleConfig.Armorcost
            end

            if nil ~= consumeConfig and 0 < consumeConfig.Length then
                local consumeCount = consumeConfig.Length - 1
                for j = 0, consumeCount do
                    local tid = consumeConfig[j][0]
                    local localItemCount = consumeConfig[j][1]
                    local localItemData = _createLocalItemData(tid, localItemCount)
                    table.insert(ret, localItemData)
                end

                return ret
            end
        end
    end

    return {}
end

---@param item ItemData
---@param equipIDList number[]
---@return boolean
function _itemMatchesEquipIDList(item, equipIDList)
    if nil == item then
        return false
    end

    if nil == item.EquipConfig then
        return false
    end

    if nil == equipIDList then
        return true
    end

    for i = 1, #equipIDList do
        local singleEquipID = equipIDList[i]
        if singleEquipID == item.EquipConfig.EquipId then
            return true
        end
    end

    return false
end

---@param itemData ItemData
---@param sourceList number[]
---@return boolean
function _itemMatchesSource(itemData, sourceList)
    if nil == itemData then
        return false
    end

    if nil == itemData.EquipConfig then
        return false
    end

    if nil == sourceList then
        return true
    end

    for i = 1, #sourceList do
        local singleTypeID = sourceList[i]
        if singleTypeID == itemData.EquipConfig.TypeId then
            return true
        end
    end

    return false
end

--- 道具更新同步，只获取制定的更新道具
---@param itemUpdateData ItemUpdateData[]
function _onItemChangeBroadCast(itemUpdateData)
    if nil == itemUpdateData then
        logError("[EquipReform] invalid event param")
        return
    end

    local currentItemData = EquipReformApi:GetCurrentSelectItem()
    if nil == currentItemData then
        return
    end

    local currentUID = currentItemData.UID
    for i = 1, #itemUpdateData do
        local singleUpdateData = itemUpdateData[i]
        if ItemChangeReason.ITEM_REASON_MAKEREFORM == singleUpdateData.Reason then
            if tostring(singleUpdateData:GetNewOrOldItem().UID) == tostring(currentUID) then
                EquipReformApi:UpdateCache(singleUpdateData.OldItem)
                EquipReformApi:SetCurrentSelectItem(singleUpdateData.NewItem)
                local str = Common.Utils.Lang("C_EQUIP_REFORM_CONFIRMED")
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
                gameEventMgr.RaiseEvent(gameEventMgr.OnEquipReformComplete, nil)

                if singleUpdateData.NewItem:IsEquipRareStyle() then
                    local rareStr = Common.Utils.Lang("C_EQUIP_REFORM_RARE")
                    local realStr = StringEx.Format(rareStr, singleUpdateData.NewItem.ItemConfig.ItemName)
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(realStr)
                end
            end
        end
    end
end

--- 将属性数据转化成为字符串，用来显示
---@param attrList ItemAttrData[]
---@param schoolAttrList ItemAttrData[]
---@return string[]
function _genAttrDescList(attrList, schoolAttrList, equipTextID)
    if nil == attrList then
        logError("[EquipReform] invalid input data")
        return {}
    end

    local ret = {}
    for i = 1, #attrList do
        local str = attrUtil.GetAttrStr(attrList[i], nil).FullValue
        table.insert(ret, str)
    end

    local schoolAttrs = attrUtil.GenItemSchoolAttrStrList(schoolAttrList, nil)
    table.ro_insertRange(ret, schoolAttrs)
    return ret
end

--- 创建本地数据
---@return ItemData
function _createLocalItemData(tid, count)
    local localItemData = Data.BagApi:CreateLocalItemData(tid)
    localItemData.ItemCount = ToInt64(count)
    return localItemData
end

return ModuleMgr.EquipReformMgr