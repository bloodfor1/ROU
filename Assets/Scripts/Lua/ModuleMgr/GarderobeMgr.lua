require "Data/Model/BagModel"
require "Data/Model/BagApi"

---@module ModuleMgr.GarderobeMgr
module("ModuleMgr.GarderobeMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
--获取玩家信息事件
ON_WEAR_ORNAMENT = "ON_WEAR_ORNAMENT"
ON_WEAR_FASHION = "ON_WEAR_FASHION"
--获取道具
ON_GARDEROBE_ADD_ITEM = "ON_GARDEROBE_ADD_ITEM"
--小红点
ON_GARDEROBE_NEW_ITEM_CLICK = "ON_GARDEROBE_NEW_ITEM_CLICK"
ON_GARDEROBE_ITEM_CLICK = "ON_GARDEROBE_ITEM_CLICK"
ON_GARDEROBE_FASHION_STORE_REFRESH = "ON_GARDEROBE_FASHION_STORE_REFRESH"
ON_GARDEROBE_FASHION_STORE_ADD = "ON_GARDEROBE_FASHION_STORE_ADD"
ON_GARDEROBE_FASHION_STORE_REMOVE = "ON_GARDEROBE_FASHION_STORE_REMOVE"
ON_GARDEROBE_FASHION_AWARD_RES = "ON_GARDEROBE_FASHION_AWARD_RES"

--装扮状态
EFashionStatusForUI = {
    None = 0,
    NotExist = 1,
    GoStore = 2,
    Equiping = 3,
    Storing = 4,
}

EGarderobeType = {
    Ornament = 1,
    Fashion = 2,
    Eye = 3,
    Hair = 4,
}

EOrnamentType = {
    Head = 1,
    Face = 2,
    Mouth = 3,
    Back = 4,
    Tail = 5,
    Fashion = 6,
    Hair = 7,
    Eye = 8,
}

GarderobeItemWeightMap = {}
GarderobeCurrentWearOrnament = {}      -- 衣橱当前装扮的饰品 key为item_id | value为穿戴的部位
FashionRecord = {
    wear_fashion_uid = nil,
    fashion_count = nil,
    fashion_count_award = nil,
    wear_fashion = nil,
}

NewItemId = {}
JumpToEyeId = 6030001
JumpToEyeColorIndex = 1
EnableJumpToEyeShopFlag = false
JumpToBarberStyleId = 200101
EnableJumpToBarberShopFlag = false
CanStoreFilter = false
CanStrenthFilter = false
SearchFilter = false
SearchText = nil
StoreFashionCallBack = nil
SelectFashionNumberIndex = nil

UISelectItem = {
    ItemID = nil,
    Index = nil,
    Attr = nil
}

local luaBaseType = GameEnum.ELuaBaseType
local C_DEFAULT_DISPLAY_ITEM_WEIGHT = 1
local C_USING_DISPLAY_ITEM_WEIGHT = 11
local gameEventMgr = MgrProxy:GetGameEventMgr()

--- 饰品类型对显示类型映射表
local C_ORNAMENT_TO_WARDROBE_MAP = {
    [EOrnamentType.Head] = EGarderobeType.Ornament,
    [EOrnamentType.Face] = EGarderobeType.Ornament,
    [EOrnamentType.Mouth] = EGarderobeType.Ornament,
    [EOrnamentType.Back] = EGarderobeType.Ornament,
    [EOrnamentType.Tail] = EGarderobeType.Ornament,
    [EOrnamentType.Fashion] = EGarderobeType.Fashion,
    [EOrnamentType.Eye] = EGarderobeType.Eye,
    [EOrnamentType.Hair] = EGarderobeType.Hair,
}

local C_EQUIP_ID_MAP = {
    [GameEnum.EEquipSlotType.HeadWear] = 1,
    [GameEnum.EEquipSlotType.MouthGear] = 1,
    [GameEnum.EEquipSlotType.BackGear] = 1,
    [GameEnum.EEquipSlotType.FaceGear] = 1,
}

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync, nil)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagUpdate, nil)
    gameEventMgr.Register(gameEventMgr.OnPlayerDataSync, OnSync, nil)
end

function ClearUISelectItem()
    UISelectItem = {}
end

function OrnamentTypeToGarderobeType(ornamentType)
    if luaBaseType.Number ~= type(ornamentType) then
        logError("[GarderobeMgr] invalid param")
        return nil
    end

    return C_ORNAMENT_TO_WARDROBE_MAP[ornamentType]
end

function EnableJumpToBarberShop(enable)
    EnableJumpToBarberShopFlag = enable
end

function GetEnableJumpToBarberShopFlag()
    return EnableJumpToBarberShopFlag
end

function EnableJumpToEyeShop(enable)
    EnableJumpToEyeShopFlag = enable
end

function GetEnableJumpToEyeShopFlag()
    return EnableJumpToEyeShopFlag
end

--- 获取时尚分
function GetFashionPoint(itemId)
    return _getFashionPoint(itemId)
end

function _getFashionPoint(itemId)
    local globalOrnament = MGlobalConfig:GetVectorSequence("OrnamentCollectionScore")
    local ornamentTable = {}
    for i = 0, globalOrnament.Length - 1 do
        ornamentTable[tonumber(globalOrnament[i][0])] = tonumber(globalOrnament[i][1])
    end

    local globalFashion = MGlobalConfig:GetVectorSequence("FashionCollectionScore")
    local fashionTable = {}
    for i = 0, globalFashion.Length - 1 do
        fashionTable[tonumber(globalFashion[i][0])] = tonumber(globalFashion[i][1])
    end

    local point = 0
    local fashionType = nil
    local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId, false)
    if itemRow ~= nil then
        if GameEnum.EItemType.Equip == itemRow.TypeTab and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) == nil then
            local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(itemId, true)
            if row ~= nil and ornamentTable[itemRow.ItemQuality] ~= nil then
                point = ornamentTable[itemRow.ItemQuality]
                fashionType = row.OrnamentType
            end
        elseif GameEnum.EItemType.Equip == itemRow.TypeTab and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil then
            local row = TableUtil.GetFashionTable().GetRowByFashionID(itemId, true)
            if row ~= nil and fashionTable[itemRow.ItemQuality] ~= nil then
                point = fashionTable[itemRow.ItemQuality]
                fashionType = EOrnamentType.Fashion
            end
        end
    end
    return point, fashionType
end
--professionId 不传则为玩家职业
--isMail 不传则为玩家性别
--Fashion 穿一件时装
function GetRoleAttrByWear(professionId, isMail,Fashion)
    local l_professionId = professionId or MPlayerInfo.ProID
    local l_isMail = isMail or MPlayerInfo.IsMale
    local attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), "GarderobeCtrl", l_professionId, l_isMail, nil)
    attr:SetHair(MPlayerInfo.HairStyle)
    attr:SetEyeColor(MPlayerInfo.EyeColorID)
    attr:SetEye(MPlayerInfo.EyeID)
    if Fashion ~= nil and Fashion > 0 then
        attr:SetFashion(Fashion)
    else
        attr:SetFashion(MPlayerInfo.Fashion)
    end
    attr:SetOrnament(MPlayerInfo.OrnamentFace)
    attr:SetOrnament(MPlayerInfo.OrnamentMouth)
    attr:SetOrnament(MPlayerInfo.OrnamentBack)
    attr:SetOrnament(MPlayerInfo.OrnamentTail)
    attr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
    return attr
end
--professionId 不传则为玩家职业
--isMail 不传则为玩家性别
function GetRoleAttr(ctrlNames, professionId, isMale)

    local l_ctrlName = ctrlNames and (ctrlNames .. "Ctrl") or "GarderobeCtrl"
    local l_professionId = professionId or MPlayerInfo.ProID
    local l_isMale = isMale or MPlayerInfo.IsMale
    local attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), l_ctrlName, l_professionId, l_isMale, nil)
    attr:SetBeiLuZi(MPlayerInfo.BeiluzEffectID) 
    attr:SetHair(MPlayerInfo.HairStyle)
    attr:SetEyeColor(MPlayerInfo.EyeColorID)
    attr:SetEye(MPlayerInfo.EyeID)
    attr:SetFashion(MPlayerInfo.Fashion)
    attr:SetOrnament(MPlayerInfo.OrnamentHead)
    attr:SetOrnament(MPlayerInfo.OrnamentFace)
    attr:SetOrnament(MPlayerInfo.OrnamentMouth)
    attr:SetOrnament(MPlayerInfo.OrnamentBack)
    attr:SetOrnament(MPlayerInfo.OrnamentTail)
    attr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    attr:SetWeaponEx(MPlayerInfo.WeaponExFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
    return attr

end

--获取当前角色服饰对应初始动画
function GetRoleAnim(attr, fashionID)

    if attr.EquipData == nil then
        return attr.CommonIdleAnimPath
    end
    if fashionID ~= nil then
        local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(fashionID, true)
        if fashionRow ~= nil and fashionRow.IdleAnim ~= nil and fashionRow.IdleAnim ~= "" then
            local animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim)
            if animPath ~= nil and animPath ~= "" then
                return animPath
            end
        end
    end
    if attr.EquipData.FashionItemID > 0 then
        local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(attr.EquipData.FashionItemID, true)
        if fashionRow ~= nil and fashionRow.IdleAnim ~= nil and fashionRow.IdleAnim[0] ~= "" then
            local animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim[0])
            if animPath ~= nil and animPath ~= "" then
                return animPath
            end
        end
    end
    --衣橱时装没有设置则显示装备时装
    if attr.EquipData.FashionFromBagItemID > 0 then
        local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(attr.EquipData.FashionFromBagItemID, true)
        if fashionRow ~= nil and fashionRow.IdleAnim ~= nil and fashionRow.IdleAnim[0] ~= "" then
            local animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim[0])
            if animPath ~= nil and animPath ~= "" then
                return animPath
            end
        end
    end
    return attr.CommonIdleAnimPath

end

function GetOrnamentBarterItemByItemId(itemId)
    local result = {}
    local data = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(itemId, true)
    if data ~= nil then
        for i = 0, data.ItemCost.Length - 1 do
            if data.ItemCost[i] ~= nil then
                local itemData = {
                    ItemId = data.ItemCost[i][0],
                    Count = data.ItemCost[i][1],
                }

                table.insert(result, itemData)
            end
        end
    end

    return result
end

function SetSearchFilter(flag)
    SearchFilter = flag
end

function SetCanStoreFilter(flag)
    CanStoreFilter = flag
end

function SetCanStrengthFilter(flag)
    CanStrenthFilter = flag
end

function GetHairData()
    local allOrigin = TableUtil.GetBarberTable().GetTable()
    local idToStyleRows = {}
    local data = {}
    local sex = MPlayerInfo.IsMale and 0 or 1
    for i, row in ipairs(allOrigin) do
        local canAdd = true
        if row.SexLimit ~= sex or row.Hide then
            canAdd = false
        end

        if SearchFilter and canAdd then
            if string.find(row.BarberName, SearchText) == nil and SearchText ~= "" then
                canAdd = false
            end
        end

        if canAdd then
            local item = {
                row = row,
                styleRow = {},
                garderobeType = EGarderobeType.Hair,
            }

            table.insert(data, item)
            idToStyleRows[row.BarberID] = item.styleRow
        end
    end

    local allStyle = TableUtil.GetBarberStyleTable().GetTable()
    for i, row in ipairs(allStyle) do
        local rows = idToStyleRows[row.BarberID]
        if rows ~= nil then
            rows[row.Colour] = row
        end
    end

    return data
end

function GetEyeData()
    local allOrigin = TableUtil.GetEyeTable().GetTable()
    local data = {}
    local sex = MPlayerInfo.IsMale and 0 or 1
    for i, row in ipairs(allOrigin) do
        local canAdd = true
        if row.SexLimit ~= sex or row.Hide ~= false then
            canAdd = false
        end

        if SearchFilter and canAdd then
            if string.find(row.EyeName, SearchText) == nil and SearchText ~= "" then
                canAdd = false
            end
        end

        if canAdd then
            local item = {
                row = row,
                garderobeType = EGarderobeType.Eye,
            }

            table.insert(data, item)
        end
    end

    return data
end

function GetFashionCountPercent()
    local allOrigin = TableUtil.GetGarderobeAwardTable().GetTable()
    local maxLevel = 0              -- 当前典藏值已满足的奖励等级
    local cangetaward = false       -- 当前是否需要展示特效
    local fashionCount = FashionRecord.fashion_count
    local fashion_count_award = FashionRecord.fashion_count_award
    for _, v in ipairs(allOrigin) do
        if fashionCount < v.Point then
            break
        else
            maxLevel = v.ID
        end
    end
    for i = 1, maxLevel do
        local l_flag = false
        if fashion_count_award.repeat_pairs == nil then
            break
        end
        for j = 1, #fashion_count_award.repeat_pairs do
            local l_pair = fashion_count_award.repeat_pairs[j]
            if l_pair.second == 0 then
                cangetaward = true
                break
            end
        end
        if cangetaward == true then
            break
        end
    end
    if maxLevel == #allOrigin then
        return cangetaward, 0
    end
    return cangetaward, (fashionCount / allOrigin[maxLevel + 1].Point)
end

function GetGarderobeAwardData()
    local result = {}
    local allOrigin = TableUtil.GetGarderobeAwardTable().GetTable()
    for i, row in ipairs(allOrigin) do
        if row.AwardId ~= 0 then
            local data = {}
            local awardItem = TableUtil.GetAwardTable().GetRowByAwardId(row.AwardId, false)
            if awardItem then
                for j = 0, awardItem.PackIds.Count - 1 do
                    local showItemTable = {}
                    local packItem = TableUtil.GetAwardPackTable().GetRowByPackId(awardItem.PackIds[j])
                    if packItem then
                        for k = 0, packItem.GroupContent.Length - 1 do
                            table.insert(showItemTable, { id = packItem.GroupContent:get_Item(k, 0), num = packItem.GroupContent:get_Item(k, 1) })
                        end
                        data.index = i
                        data.garderobeRewardItem = row
                        data.packRewardItem = showItemTable
                        table.insert(result, data)
                    else
                        logError("AwardPackTable id: " .. tostring(awardItem.PackIds[j]) .. " got nil, plis check")
                    end
                end
            else
                logError("AwardTable id: " .. tostring(row.AwardId) .. " got nil, plis check")
            end
        end
    end

    return result
end

--构造时装数据
function GetFashionData()
    local allOrigin = TableUtil.GetFashionTable().GetTable()
    local data = {}
    local sex = MPlayerInfo.IsMale and 0 or 1
    for i, row in ipairs(allOrigin) do
        local itemRow = TableUtil.GetItemTable().GetRowByItemID(row.FashionID)
        local canAdd = true
        if itemRow.SexLimit ~= sex then
            canAdd = false
        end

        if SearchFilter and SearchText ~= "" and canAdd then
            if string.find(itemRow.ItemName, SearchText) == nil then
                canAdd = false
            end
        end

        if canAdd then
            item = {
                row = row,
                itemRow = itemRow,
                garderobeType = EGarderobeType.Fashion,
                weight = _getItemWeightByTid(row.FashionID)
            }

            if _itemValid(itemRow) then
                table.insert(data, item)
            end
        end
    end

    table.sort(data, _sortFuncFashion)
    return data
end

function IsWearByItemId(itemId)
    return GarderobeCurrentWearOrnament[itemId] ~= nil and GarderobeCurrentWearOrnament[itemId] ~= 0
end

--- 这个接口是判断是否拥有这个时装
function IsOwnByItemId(itemId)
    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.Wardrobe,
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.WareHouse,
    }

    local count = Data.BagApi:GetItemCountByContListAndTid(types, itemId)
    return 0 < count
end

function ReProcessWeight()
    _processGardrobeItemWeight()
end

--- 【内部接口】
--- 重新计算衣橱当中道具的权重，为了标记显示
--- 如果装备位上已经有改变外观的饰品，但是衣橱里应用了外观，这个时候是显示衣橱的外观，所以权重更大
function _processGardrobeItemWeight()
    local contTypes = {
        GameEnum.EBagContainerType.Wardrobe,
        GameEnum.EBagContainerType.Equip,
    }

    ---@type FiltrateCond
    local condition = {
        Cond = MgrProxy:GetItemDataFuncUtil().ItemHasModel,
        Param = true,
    }

    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(contTypes, conditions)
    GarderobeItemWeightMap = {}

    for i = 1, #items do
        local tid = items[i].TID
        GarderobeItemWeightMap[tid] = C_DEFAULT_DISPLAY_ITEM_WEIGHT
    end

    if nil ~= FashionRecord.wear_fashion then
        GarderobeItemWeightMap[FashionRecord.wear_fashion] = C_USING_DISPLAY_ITEM_WEIGHT
    end

    local displayTIDs = {
        [1] = MPlayerInfo.OrnamentHead,
        [2] = MPlayerInfo.OrnamentFace,
        [3] = MPlayerInfo.OrnamentMouth,
        [4] = MPlayerInfo.OrnamentBack,
        [5] = MPlayerInfo.OrnamentTail,
    }

    for key, value in pairs(displayTIDs) do
        if nil ~= value then
            GarderobeItemWeightMap[value] = C_USING_DISPLAY_ITEM_WEIGHT
        end
    end
end

function GetIndexAndOrnamentTypeByItemID(ornamentID)
    local index = -1
    local ornamentRow = TableUtil.GetOrnamentTable().GetRowByOrnamentID(ornamentID)
    if ornamentRow ~= nil then
        local data = GetOrnamentByTypeData({ ornamentRow.OrnamentType })
        for i, row in ipairs(data) do
            if row.row.OrnamentID == ornamentRow.OrnamentID then
                index = i
                return index, row
            end
        end
    end

    if index == -1 or ornamentRow == nil then
        logError("GetIndexAndOrnamentTypeByItemID itemId" .. tostring(ornamentID))
    end

    return -1, nil
end

--构造type数组指定的装备数据
function GetOrnamentByTypeData(OrnamentTypeArray)
    if OrnamentTypeArray == nil then
        logError("OrnamentTypeArray is nil")
        return
    end

    for i, ornamentType in ipairs(OrnamentTypeArray) do
        if ornamentType < EOrnamentType.Head or ornamentType > EOrnamentType.Tail then
            logError("OrnamentType out of range")
            return
        end
    end

    local ornamentTypeHash = {}
    for key, ornamentType in ipairs(OrnamentTypeArray) do
        ornamentTypeHash[ornamentType] = 1
    end

    local allOrigin = TableUtil.GetOrnamentTable().GetTable()
    local data = {}
    for i = 1, #allOrigin do
        local singleRow = allOrigin[i]
        if nil ~= ornamentTypeHash[singleRow.OrnamentType] then
            local itemConfig = TableUtil.GetItemTable().GetRowByItemID(singleRow.OrnamentID)
            local itemData = {
                row = singleRow,
                itemRow = itemConfig,
                garderobeType = EGarderobeType.Ornament,
                weight = _getItemWeightByTid(singleRow.OrnamentID)
            }

            if _itemValid(itemConfig) then
                table.insert(data, itemData)
            end
        end
    end

    table.sort(data, _sortFunc)
    return data
end

--- 这个逻辑比较复杂，客户端可能同时开3个过滤，要同时满足
---@param itemRow ItemTable
---@return boolean
function _itemValid(itemRow)
    return _validateName(itemRow) and _validateStorage(itemRow) and _validateEnhanced(itemRow)
end

function _validateName(itemRow)
    if not SearchFilter then
        return true
    end

    local result = string.find(itemRow.ItemName, SearchText) == nil and SearchText ~= ""
    return not result
end

function _validateStorage(itemRow)
    if not CanStoreFilter then
        return true
    end

    local result = IsStoreFashion(itemRow.ItemID) or not IsExsitInBag(itemRow.ItemID)
    return not result
end

function _validateEnhanced(itemRow)
    if not CanStrenthFilter then
        return true
    end

    local tid = itemRow.ItemID
    local containerTypes = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Wardrobe,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local items = _getItemsByContTypeTID(tid, containerTypes)
    for i = 1, #items do
        local singleItem = items[i]
        local result = _itemEnchanced(singleItem)
        if result then
            return true
        end
    end

    return false
end

--- 排序算法
function _sortFunc(data1, data2)
    if data1.weight == data2.weight then
        return data1.row.SortID < data2.row.SortID
    else
        return data1.weight > data2.weight
    end
end

--- 排序算法
function _sortFuncFashion(data1, data2)
    if data1.weight == data2.weight then
        return data1.row.FashionID < data2.row.FashionID
    else
        return data1.weight > data2.weight
    end
end

function _getItemWeightByTid(tid)
    if luaBaseType.Number ~= type(tid) then
        logError("[GarderobeMgr] invalid tid type: " .. type(tid))
        return 0
    end

    local ret = GarderobeItemWeightMap[tid]
    if nil ~= ret then
        return ret
    end

    local isOwned = IsOwnByItemId(tid)
    if true == isOwned then
        return C_DEFAULT_DISPLAY_ITEM_WEIGHT
    end

    return 0
end

function GetFashionUidByItemID(itemId)
    if luaBaseType.Number ~= type(itemId) then
        logError("[GarderobeMgr] invalid param")
        return 0
    end

    local items = _getItemsByCond(MgrProxy:GetItemDataFuncUtil().ItemMatchesTid, itemId)
    if 0 == #items then
        return 0
    end

    return items[1].UID
end

function GetFashionItemIdByUid(uid)
    if nil == uid then
        return 0
    end

    local items = _getItemsByCond(MgrProxy:GetItemDataFuncUtil().IsItemUID, uid)
    if 1 ~= #items then
        return 0
    end

    return items[1].TID
end

--- 按照条件获取对应的item列表
function _getItemsByCond(cond, param)
    if luaBaseType.Func ~= type(cond) then
        logError("[GarderobeMgr] invalid param")
        return {}
    end

    ---@type FiltrateCond
    local condition = {
        Cond = cond,
        Param = param
    }

    local type = GameEnum.EBagContainerType.Wardrobe
    local types = { type }
    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function SetFashion(uid, is_put_on)
    local item_id = GetFashionItemIdByUid(uid)
    if item_id ~= 0 then
        local row = TableUtil.GetFashionTable().GetRowByFashionID(item_id)
        if row then
            local type = OrnamentWearType.OrnamentWearType_Fashion
            -- 当前穿戴的时装全部重置，当前类型只会出现一次
            if is_put_on then
                for itemid, v in pairs(GarderobeCurrentWearOrnament) do
                    if v == type then
                        GarderobeCurrentWearOrnament[itemid] = 0
                    end
                end
            end
            -- 当前衣橱中穿戴在身上的时装
            GarderobeCurrentWearOrnament[item_id] = is_put_on and type or 0
        end
    end
    if not is_put_on then
        uid = 0
        item_id = MPlayerInfo.FashionFromBag
    end

    FashionRecord.wear_fashion_uid = uid
    FashionRecord.wear_fashion = item_id

    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        local attrComp = MEntityMgr.PlayerEntity.AttrComp
        if attrComp ~= nil then
            attrComp:SetFashion(item_id)
        end
    end
end

function SetAttrFashion(attr, uid, isPutOn)
    if attr == nil then
        logError("SetAttrFashion:Attr is nil")
        return
    end

    local itemId = 0
    if isPutOn then
        itemId = GetFashionItemIdByUid(uid)
    else
        uid = 0
        itemId = MPlayerInfo.FashionFromBag
    end
    attr:SetFashion(itemId)
end

function SetAttrOrnament(attr, itemId, isPutOn)
    if attr == nil then
        logError("SetAttrOrnament:Attr is nil")
    end

    local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(itemId)
    local type = row.OrnamentType
    if not isPutOn then
        itemId = 0
    end

    if attr ~= nil then
        attr:SetOrnamentByIntType(type, itemId)
    end
end

function GetOrnamentTypeById(itemId)
    local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId, false)
    local equipRow = TableUtil.GetEquipTable().GetRowById(itemId, true)
    local ornamentRow = TableUtil.GetOrnamentTable().GetRowByOrnamentID(itemId, true)
    local ornamentType = nil
    if nil == itemRow then
        return nil
    end

    if GameEnum.EItemType.Equip == itemRow.TypeTab and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) == nil then
        if nil == equipRow then
            logError("GetOrnamentTypeById itemId" .. tostring(itemId))
            return nil
        end

        if nil ~= C_EQUIP_ID_MAP[equipRow.EquipId] then
            if nil == ornamentRow then
                return nil
            end

            ornamentType = ornamentRow.OrnamentType
        end
    elseif GameEnum.EItemType.Equip == itemRow.TypeTab and TableUtil.GetFashionTable().GetRowByFashionID(itemId,true) ~= nil then
        ornamentType = EOrnamentType.Fashion
    end

    return ornamentType
end

function GetOrnamentByType(ornamentType)
    local result = 0
    local C_MAP = {
        [1] = MPlayerInfo.OrnamentHead,
        [2] = MPlayerInfo.OrnamentFace,
        [3] = MPlayerInfo.OrnamentMouth,
        [4] = MPlayerInfo.OrnamentBack,
        [5] = MPlayerInfo.OrnamentTail,
    }

    result = C_MAP[ornamentType]
    return result
end

function SetOrnament(item_id, is_put_on)
    local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(item_id)
    if row == nil then
        return
    end
    local type = row.OrnamentType
    -- 当前穿戴的头饰类型全部重置，当前类型只会出现一次
    if is_put_on then
        for itemid, v in pairs(GarderobeCurrentWearOrnament) do
            if v == type then
                GarderobeCurrentWearOrnament[itemid] = 0
            end
        end
    end
    -- 当前衣橱中穿戴在身上的头饰
    GarderobeCurrentWearOrnament[item_id] = is_put_on and type or 0
    if not is_put_on then
        item_id = 0
    end

    if type == 1 then
        MPlayerInfo.OrnamentHead = item_id
    elseif type == 2 then
        MPlayerInfo.OrnamentFace = item_id
    elseif type == 3 then
        MPlayerInfo.OrnamentMouth = item_id
    elseif type == 4 then
        MPlayerInfo.OrnamentBack = item_id
    elseif type == 5 then
        MPlayerInfo.OrnamentTail = item_id
    end

    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        local attrComp = MEntityMgr.PlayerEntity.AttrComp
        if attrComp ~= nil then
            attrComp:SetOrnamentByIntType(type, item_id)
        end
    end
end

function RequestStoreFashion(uid, propId, callback)
    StoreFashionCallBack = callback
    Data.BagApi:ReqSwapItem(uid, GameEnum.EBagContainerType.Wardrobe, nil, 1)
end

function RequestStoreBag(uid)
    Data.BagApi:ReqSwapItem(uid, GameEnum.EBagContainerType.Bag, nil, 1)
end

function GetFashionStatus(propId)
    local bagExsit = IsExsitInBag(propId)
    local equipExsit = IsExisInEquip(propId)
    local fashionStoreExsit = IsStoreFashion(propId)
    if fashionStoreExsit then
        --试穿 / 取出 or 脱下来
        return EFashionStatusForUI.Storing
    elseif bagExsit then
        --存入
        return EFashionStatusForUI.GoStore
    elseif equipExsit then
        --装备中
        return EFashionStatusForUI.Equiping
    else
        --获取途径
        return EFashionStatusForUI.NotExist
    end

    return EFashionStatusForUI.None
end

function IsExisInEquip(propId)
    if luaBaseType.Number ~= type(propId) then
        logError("[GarderobeMgr] invalid param")
        return false
    end

    local types = { GameEnum.EBagContainerType.Equip }
    local items = _getItemsByContTypeTID(propId, types)
    return 0 < #items
end

function GetItemFromFashionStore(propId)
    if luaBaseType.Number ~= type(propId) then
        logError("[GarderobeMgr] invalid param")
        return false
    end

    local types = { GameEnum.EBagContainerType.Wardrobe }
    local items = _getItemsByContTypeTID(propId, types)
    return items[1]
end

function IsStoreFashion(propId)
    if luaBaseType.Number ~= type(propId) then
        logError("[GarderobeMgr] invalid param")
        return false
    end

    local types = { GameEnum.EBagContainerType.Wardrobe }
    local items = _getItemsByContTypeTID(propId, types)
    return 0 < #items
end

--判断背包,仓库,手推车仓库是否拥有
---@return boolean
function IsExsitInBag(propId)
    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local count = Data.BagApi:GetItemCountByContListAndTid(types, propId)
    return 0 < count
end

--从背包,仓局,手推车仓库中拿到对应的数据
function GetPropInfoFromAllStored(propId)
    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local items = _getItemsByContTypeTID(propId, types)
    return items
end

function _getItemsByContTypeTID(propId, contTypes)
    if luaBaseType.Number ~= type(propId) then
        logError("[GarderobeMgr] invalid param")
        return {}
    end

    local types = contTypes
    ---@type FiltrateCond
    local condition = { Cond = MgrProxy:GetItemDataFuncUtil().ItemMatchesTid, Param = propId }
    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function GetPropInfoByUid(uid, propId)
    if nil == uid then
        logError("[GarderobeMgr] invalid param")
        return false
    end

    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    ---@type FiltrateCond
    local condition = { Cond = MgrProxy:GetItemDataFuncUtil().IsItemUID, Param = uid }
    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items[1]
end

--- 通过消息接收，当收到了背包更新
--- 不知道是角色同步先下来还是背包同步先下来
--- 只有添加和删除，没有更新操作
---@param msg ItemUpdateData[]
function _onBagUpdate(msg)
    if luaBaseType.Table ~= type(msg) then
        logError("[GarderobeMgr] bag update event got invalid param")
        return
    end

    for i = 1, #msg do
        local singleUpdateData = msg[i]
        if nil == singleUpdateData.OldItem and nil ~= singleUpdateData.NewItem then
            local newTID = singleUpdateData.NewItem.TID
            local ornamentType = GetOrnamentTypeById(newTID)
            if nil ~= ornamentType then
                table.insert(NewItemId, newTID)
                EventDispatcher:Dispatch(ON_GARDEROBE_ADD_ITEM, newTID)
                MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Garderobe)
            end
        elseif nil ~= singleUpdateData.OldItem and nil == singleUpdateData.NewItem then
            local displayMap = {
                [1] = MPlayerInfo.OrnamentHead,
                [2] = MPlayerInfo.OrnamentFace,
                [3] = MPlayerInfo.OrnamentMouth,
                [4] = MPlayerInfo.OrnamentBack,
                [5] = MPlayerInfo.OrnamentTail,
            }

            local deleteItem = singleUpdateData.OldItem
            if deleteItem.UID == FashionRecord.wear_fashion_uid then
                SetFashion(deleteItem.UID, false)
            end

            for idx, displayEquipTid in pairs(displayMap) do
                if displayEquipTid == deleteItem.TID then
                    SetOrnament(deleteItem.TID, false)
                end
            end
        elseif nil ~= singleUpdateData.OldItem and nil ~= singleUpdateData.NewItem then
            if singleUpdateData.NewContType == GameEnum.EBagContainerType.Wardrobe then
                EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_STORE_ADD)
            end
            if singleUpdateData.OldContType == GameEnum.EBagContainerType.Wardrobe and
                    singleUpdateData.NewContType == GameEnum.EBagContainerType.Bag then
                EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_STORE_REMOVE)
            end
        end
    end

    _processGardrobeItemWeight()
    if StoreFashionCallBack ~= nil then
        StoreFashionCallBack()
        StoreFashionCallBack = nil
    end

    EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_STORE_REFRESH)
end

function _onBagSync()
    _processGardrobeItemWeight()
end

---@param info RoleAllInfo
function OnSync(info)
    local pbFashionRecord = info.fashion
    FashionRecord = {
        wear_fashion_uid = pbFashionRecord.wear_fashion_uid,
        fashion_count = pbFashionRecord.ro_fashion.fashion_count,
        fashion_count_award = pbFashionRecord.ro_fashion.fashion_count_award,
        wear_fashion = nil -- pbFashionRecord.fas
    }

    local tmp_fashion_count_award = {}
    local awardTabel = TableUtil.GetGarderobeAwardTable().GetTable()
    for i=1,#awardTabel-1 do
        tmp_fashion_count_award[i] = {first = i,second = 0}
        for j, row in ipairs(FashionRecord.fashion_count_award.repeat_pairs) do
            if row.first == tmp_fashion_count_award[i].first then
                tmp_fashion_count_award[i].second = row.second
            end
        end
    end
    FashionRecord.fashion_count_award.repeat_pairs = tmp_fashion_count_award

    SetFashion(FashionRecord.wear_fashion_uid, true)
    -- 饰品ItemID
    MPlayerInfo.OrnamentHead = 0
    MPlayerInfo.OrnamentFace = 0
    MPlayerInfo.OrnamentMouth = 0
    MPlayerInfo.OrnamentBack = 0
    MPlayerInfo.OrnamentTail = 0

    for i, v in ipairs(pbFashionRecord.wear_ornament_ids) do
        SetOrnament(v.value, true)
    end
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    if nil == reconnectData then
        logError("[GarderobeMgr] reconnected data got nil")
        return
    end

    OnSync(reconnectData.role_data)
    _resetPlayerModel()
end

--- 重置角色模型
function _resetPlayerModel()
    local player = MEntityMgr.PlayerEntity
    local equipData = player.AttrComp.EquipData
    player.AttrComp:SetFashion(MPlayerInfo.Fashion)

    if equipData.OrnamentHeadItemID ~= MPlayerInfo.OrnamentHead then
        player.AttrComp:SetOrnamentByIntType(EOrnamentType.Head, MPlayerInfo.OrnamentHead)
    end

    if equipData.OrnamentFaceItemID ~= MPlayerInfo.OrnamentFace then
        player.AttrComp:SetOrnamentByIntType(EOrnamentType.Face, MPlayerInfo.OrnamentFace)
    end

    if equipData.OrnamentMouthItemID ~= MPlayerInfo.OrnamentMouth then
        player.AttrComp:SetOrnamentByIntType(EOrnamentType.Mouth, MPlayerInfo.OrnamentMouth)
    end

    if equipData.OrnamentBackItemID ~= MPlayerInfo.OrnamentBack then
        player.AttrComp:SetOrnamentByIntType(EOrnamentType.Back, MPlayerInfo.OrnamentBack)
    end

    if equipData.OrnamentTailItemID ~= MPlayerInfo.OrnamentTail then
        player.AttrComp:SetOrnamentByIntType(EOrnamentType.Tail, MPlayerInfo.OrnamentTail)
    end
end

function GetClothShareInfo()
    local containerTypes = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Wardrobe,
    }

    return _getPointMap(containerTypes)
end

function GetFashionTypeCollectPoint()
    local typeList = { GameEnum.EBagContainerType.Wardrobe }
    local slotMap, totalValue = _getPointMap(typeList)
    return slotMap
end

---@return number[]
---@return table<number, number>, number
function _getPointMap(typeList)
    local clothNums = {
        [EOrnamentType.Head] = 0,
        [EOrnamentType.Face] = 0,
        [EOrnamentType.Mouth] = 0,
        [EOrnamentType.Back] = 0,
        [EOrnamentType.Tail] = 0,
        [EOrnamentType.Fashion] = 0,
    }

    local containerTypes = typeList
    local items = Data.BagApi:GetItemsByTypesAndConds(containerTypes, nil)
    local totalPoint = 0
    for i = 1, #items do
        local singleItem = items[i]
        local fashionPoint, fashionType = _getFashionPoint(singleItem.TID)
        if fashionPoint ~= 0 and fashionType ~= nil then
            totalPoint = totalPoint + fashionPoint
            clothNums[fashionType] = clothNums[fashionType] + 1
        end
    end

    return clothNums, totalPoint
end

-- message: WearFashionReq
function RequestWearFashion(_uid, _item_id, _is_put_on)
    local l_rowData = TableUtil.GetFashionTable().GetRowByFashionID(_item_id)
    if l_rowData then
        local l_msgId = Network.Define.Rpc.WearFashion
        ---@type WearFashionReq
        local l_sendInfo = GetProtoBufSendTable("WearFashionReq")
        l_sendInfo.uid = _uid
        l_sendInfo.is_put_on = _is_put_on
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

-- message: WearFashionRes
function OnWearFashion(msg)
    ---@type WearFashionRes
    local l_info = ParseProtoBufToTable("WearFashionRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        logWarn("WearFashionRes error: " .. l_info.result)
        return
    end

    SetFashion(l_info.uid, l_info.is_put_on)
    _processGardrobeItemWeight()
    EventDispatcher:Dispatch(ON_WEAR_FASHION, l_info.uid, l_info.is_put_on)
end

function OnFashionCountNtf(msg)
    ---@type FashionCountData
    local l_info = ParseProtoBufToTable("FashionCountData", msg)
    if nil == l_info or nil == l_info.fashion_count then
        logError("OnFashionCountNtf data error")
        return
    end

    if nil ~= FashionRecord then
        FashionRecord.fashion_count = l_info.fashion_count
    end

    EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_STORE_REFRESH)
end
function Callfashionlevelbyfashioncount(fashioncount)
    local l_rowData = TableUtil.GetGarderobeAwardTable().GetTable()
    local level = 0
    if l_rowData then
        for i = 1, #l_rowData do
            if l_rowData[i].Point <= fashioncount then
                level = l_rowData[i].ID
            end
        end
    end
    return level
end
-- message: WearOrnamentArg
function RequestWearOrnament(_item_id, _is_put_on)
    local l_rowData = TableUtil.GetOrnamentTable().GetRowByOrnamentID(_item_id)
    if l_rowData then
        local l_msgId = Network.Define.Rpc.WearOrnament
        ---@type WearOrnamentArg
        local l_sendInfo = GetProtoBufSendTable("WearOrnamentArg")
        l_sendInfo.item_id = _item_id
        l_sendInfo.is_put_on = _is_put_on
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

-- message: WearOrnamentRes
function OnWearOrnament(msg)
    ---@type WearOrnamentRes
    local l_info = ParseProtoBufToTable("WearOrnamentRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        logWarn("WearOrnamentRes error: " .. l_info.result)
        return
    end

    SetOrnament(l_info.item_id, l_info.is_put_on)
    _processGardrobeItemWeight()
    EventDispatcher:Dispatch(ON_WEAR_ORNAMENT, l_info.item_id, l_info.is_put_on)
end

--典藏值奖励请求
function RequestFashionCountSendAward(awardId)
    local l_msgId = Network.Define.Rpc.FashionCountSendAward
    ---@type FashionCountSendAwardArg
    local l_sendInfo = GetProtoBufSendTable("FashionCountSendAwardArg")
    l_sendInfo.id = awardId
    Network.Handler.SendRpc(l_msgId, l_sendInfo, { id = awardId })
end

function OnFashionCountSendAward(msg, args, customData)
    ---@type FashionCountSendAwardRes
    local l_info = ParseProtoBufToTable("FashionCountSendAwardRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if customData ~= nil then
        if customData.id ~= nil then
            for i = 1,#FashionRecord.fashion_count_award.repeat_pairs do
                local l_pair = FashionRecord.fashion_count_award.repeat_pairs[i]
                if l_pair.first == customData.id then
                    FashionRecord.fashion_count_award.repeat_pairs[i].second = 1
                    --logError("FashionRecord.fashion_count_award.repeat_pairs[i] .."..i.." : "..FashionRecord.fashion_count_award.repeat_pairs[i].first.." ; "..FashionRecord.fashion_count_award.repeat_pairs[i].second)
                    EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_AWARD_RES)
                    return
                end
            end
        end
    end
    --logError("FashionRecord.fashion_count_award.repeat_pairs[i] .."..i.." : "..ustomData.id.." ; "..1)

    table.insert(FashionRecord.fashion_count_award.repeat_pairs,{first = customData.id,second = 1})
    EventDispatcher:Dispatch(ON_GARDEROBE_FASHION_AWARD_RES)
end

function FashionLevelChangePtc(msg)
    local l_info = ParseProtoBufToTable("FashionLevelChangeData", msg)
    UIMgr:ActiveUI(UI.CtrlNames.GarderobeFashionupgradeTips, function(ctrl)
        ctrl:SetInfo(l_info.new_level)
    end)end
--- 判断装备是否呗强化过
---@param propInfo ItemData
function _itemEnchanced(propInfo)
    local level = MgrMgr:GetMgr("RefineMgr").GetRefineLevel(propInfo)
    local holeCount = propInfo:GetOpenHoleCount()
    local isEnchant = MgrMgr:GetMgr("EnchantMgr").IsEnchanted(propInfo)
    return (level > 0) or (holeCount > 0) or (isEnchant == true)
end

function GetFashionCount()
    local types = {
        GameEnum.EItemType.Equip
    }

    local items = _getItemsByCond(MgrProxy:GetItemDataFuncUtil().ItemMatchesTypes, types)
    local Fashionitems = {}
    for i=1,#items do
        if TableUtil.GetFashionTable().GetRowByFashionID(items[i].TID,true) ~= nil then
            Fashionitems[#Fashionitems + 1] = items[i]
        end
    end
    return #Fashionitems
end

function CheckRedSignMethod()
    return #NewItemId
end
function CheckRedSignMethod_FashionAward()
    local awardTable = TableUtil.GetGarderobeAwardTable().GetTable()
    local myLevel = 0
    for i = 1, #awardTable do
        if awardTable[i].Point <= FashionRecord.fashion_count then
            myLevel = awardTable[i].ID
        else
            break
        end
    end
    for i, v in pairs(FashionRecord.fashion_count_award.repeat_pairs) do
        if awardTable[v.first+1].AwardId > 0 and v.second == 0 and myLevel >= v.first then
            return 1
        end
    end
    return 0
end
function IsEquipDataContainItemId(equipData, itemId)
    local barberID = 0
    if equipData == nil then
        return false
    end

    if equipData.HairStyleID ~= nil then
        local barberStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(equipData.HairStyleID)
        if barberStyleRow ~= nil then
            barberID = barberStyleRow.BarberID
        end
    end

    local itemIDHash = {
        [equipData.OrnamentHeadItemID] = 1,
        [equipData.OrnamentFaceItemID] = 1,
        [equipData.OrnamentMouthItemID] = 1,
        [equipData.OrnamentBackItemID] = 1,
        [equipData.OrnamentTailItemID] = 1,
        [equipData.FashionItemID] = 1,
        [equipData.EyeID] = 1,
        [barberID] = 1,
    }

    return nil ~= itemIDHash[itemId]
end

function RemoveNewItemId(id)
    table.ro_removeValue(NewItemId, id)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Garderobe)
end

function OnLogout()
    GarderobeItemWeightMap = {}
    GarderobeCurrentWearOrnament = {}
    FashionRecord = {}
    NewItemId = {}
    JumpToEyeId = 6030001
    JumpToEyeColorIndex = 1
    EnableJumpToEyeShopFlag = false
    JumpToBarberStyleId = 200101
    EnableJumpToBarberShopFlag = false
    NewItemId = {}

    gameEventMgr.UnRegister(gameEventMgr.OnBagSync, nil)
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, nil)
end

function OpenGarderobeWithItemId(ornamentID)
    UIMgr:ActiveUI(UI.CtrlNames.Garderobe, { ornamentID = ornamentID })
end

return ModuleMgr.GarderobeMgr