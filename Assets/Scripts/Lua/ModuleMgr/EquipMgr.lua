require "Data/Model/BagModel"
require "Common/Bit32"

---@module ModuleMgr.EquipMgr
module("ModuleMgr.EquipMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
AppraiseEquipSucceed = "AppraiseEquipSucceed"

AttrTypeAttr = 0 -- 基础属性
AttrTypeBuff = 1 -- BUFF
AttrTypeSpecialSkill = 3 -- 特技
AttrTypeSkill = 4 -- 技能

HoldingModeNone = 0
HoldingModeSingle = 1   --单手武器
HoldingModeDouble = 2   --双手武器
HoldingModeDoubleHand = 3 --双持武器
HoldingModeAssist = 4     --盾牌

elementName = {
    [0] = Common.Utils.Lang("WU"),
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_FENG"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DI"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_HUO"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHUI"),
    [5] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DU"),
    [6] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHENG"),
    [7] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_AN"),
    [8] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_NIAN"),
    [9] = Common.Utils.Lang("UnitRace_4"),
}

eEquipTypeName = {
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_WUQI"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FUSHOU"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_KUIJIA"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_PIFENG"),
    [5] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_XIEZI"),
    [6] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
    [7] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_TOUSHI"),
    [8] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_LIANSHI"),
    [9] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ZUISHI"),
    [10] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_BEISHI"),
    [11] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_ZAIJU"),
    [15] = Common.Utils.Lang("TRADE_DES_ITEM_6"),
}

eCardColorName = {
    [1] = Common.Utils.Lang("PURPLE"),
    [2] = Common.Utils.Lang("BLUE"),
    [3] = Common.Utils.Lang("GREEN"),
}

eHeadColorName = {
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_TOUBU"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_LIANBU"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_ZUIBU"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_BEIBU"),
    [5] = Common.Utils.Lang("RARE_ITEMS"),
}

eRecoveHeadColorName = {
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_TOUBU"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_LIANBU"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_ZUIBU"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_EQUIP_BEIBU"),
}

eRecoveEquipName = {
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_WUQI"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FANGJU"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
}

eExtractEquipName = {
    [1] = Common.Utils.Lang("TRADE_DES_ITEM_1"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_DAOJU"),
}
BuffTableInfo = {}
OrnamentTableInfo = {}

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync)
end

----------------------------饰品数据begin-----------------------------
function InitOrnamentTable()
    local tableInfo = TableUtil.GetOrnamentTable().GetTable()
    for i = 1, #tableInfo do
        OrnamentTableInfo[tableInfo[i].OrnamentID] = tableInfo[i]
    end
end

function RemoveOrnament(item_id, pos)
    local itemInfo = TableUtil.GetItemTable().GetRowByItemID(item_id)
    local l_pos = nil
    --如果是装备
    if itemInfo and itemInfo.TypeTab == 1 then
        l_pos = pos
    end

    if OrnamentTableInfo[item_id] then
        local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(item_id)
        local type = row.OrnamentType
        if type == 1 then
            MPlayerInfo.OrnamentHeadFromBag = 0
        elseif type == 2 then
            MPlayerInfo.OrnamentFaceFromBag = 0
        elseif type == 3 then
            MPlayerInfo.OrnamentMouthFromBag = 0
        elseif type == 4 then
            MPlayerInfo.OrnamentBackFromBag = 0
        elseif type == 5 then
            MPlayerInfo.OrnamentTailFromBag = 0
        end
        -- 模型
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetOrnament(type, 0, true)
        end

        RefreshPlayerOrnament(type, 0, true)
    elseif l_pos and l_pos == EquipPos.MAIN_WEAPON then
        MPlayerInfo.WeaponFromBag = 0
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                attrComp:SetWeapon(0, true)
            end
        end
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetWeapon(0, true)
        end
    elseif l_pos and l_pos == EquipPos.SECONDARY_WEAPON then
        MPlayerInfo.WeaponExFromBag = 0
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                attrComp:SetWeaponEx(0, true)
            end
        end

        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetWeaponEx(0, true)
        end
    elseif l_pos and l_pos == EquipPos.HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipVehicle(0)
    elseif l_pos and l_pos == EquipPos.BATTLE_HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipBattleVehicle(0)
    elseif l_pos and l_pos == EquipPos.FASHION then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            MPlayerInfo.FashionFromBag = 0
            l_ui:SetFashion(MPlayerInfo.Fashion)
        end
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                MPlayerInfo.FashionFromBag = 0
                attrComp:SetFashion(MPlayerInfo.Fashion)
            end
        end
    end
end

function IsEquipRide()
    local clientEnum = Data.BagModel.WeapType.Ride + 1
    local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, clientEnum)
    if l_info == nil then
        return false
    end
    return true
end

function SetOrnamentEx(item_id, index)
    local itemInfo = TableUtil.GetItemTable().GetRowByItemID(item_id)
    local l_pos = nil

    --如果是装备
    if itemInfo and itemInfo.TypeTab == 1 then
        l_pos = index
    end
    if OrnamentTableInfo[item_id] then
        local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(item_id)
        local type = row.OrnamentType
        if type == 1 then
            MPlayerInfo.OrnamentHeadFromBag = item_id
        elseif type == 2 then
            MPlayerInfo.OrnamentFaceFromBag = item_id
        elseif type == 3 then
            MPlayerInfo.OrnamentMouthFromBag = item_id
        elseif type == 4 then
            MPlayerInfo.OrnamentBackFromBag = item_id
        elseif type == 5 then
            MPlayerInfo.OrnamentTailFromBag = item_id
        end
        -- 模型
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetOrnament(type, item_id, true)
        end

        RefreshPlayerOrnament(type, item_id, true)
    elseif l_pos and l_pos == EquipPos.MAIN_WEAPON then
        MPlayerInfo.WeaponFromBag = item_id
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                attrComp:SetWeapon(item_id, true)
            end
        end
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetWeapon(item_id, true)
        end
    elseif l_pos and l_pos == EquipPos.SECONDARY_WEAPON then
        MPlayerInfo.WeaponExFromBag = item_id
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                attrComp:SetWeaponEx(item_id, true)
            end
        end
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetWeaponEx(item_id, true)
        end
    elseif l_pos and l_pos == EquipPos.HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipVehicle(item_id)
    elseif l_pos and l_pos == EquipPos.BATTLE_HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipBattleVehicle(item_id)
    elseif l_pos and l_pos == EquipPos.FASHION then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            MPlayerInfo.FashionFromBag = item_id
            l_ui:SetFashion(MPlayerInfo.Fashion)
        end

        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                MPlayerInfo.FashionFromBag = item_id
                attrComp:SetFashion(MPlayerInfo.Fashion)
            end
        end
    end
end

function SetOrnament(item_id)
    local itemInfo = TableUtil.GetItemTable().GetRowByItemID(item_id)
    local l_pos = nil
    --如果是装备
    if itemInfo and itemInfo.TypeTab == 1 then
        local equipInfo = TableUtil.GetEquipTable().GetRowById(item_id)
        local l_eId = equipInfo.EquipId
        l_pos = Data.BagModel.WeapTableType[l_eId]
    end
    if OrnamentTableInfo[item_id] then
        local row = TableUtil.GetOrnamentTable().GetRowByOrnamentID(item_id)
        local type = row.OrnamentType
        if type == 1 then
            MPlayerInfo.OrnamentHeadFromBag = item_id
        elseif type == 2 then
            MPlayerInfo.OrnamentFaceFromBag = item_id
        elseif type == 3 then
            MPlayerInfo.OrnamentMouthFromBag = item_id
        elseif type == 4 then
            MPlayerInfo.OrnamentBackFromBag = item_id
        elseif type == 5 then
            MPlayerInfo.OrnamentTailFromBag = item_id
        end
        -- 模型
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetOrnament(type, item_id, true)
        end

        RefreshPlayerOrnament(type, item_id, true)
    elseif l_pos and l_pos == EquipPos.MAIN_WEAPON then
        MPlayerInfo.WeaponFromBag = item_id
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                attrComp:SetWeapon(item_id, true)
            end
        end
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            l_ui:SetWeapon(item_id, true)
        end
    elseif l_pos and l_pos == EquipPos.HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipVehicle(item_id)
    elseif l_pos and l_pos == EquipPos.BATTLE_HORSE then
        MgrMgr:GetMgr("VehicleMgr").EquipBattleVehicle(item_id)
    elseif l_pos and l_pos == EquipPos.FASHION then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
        if l_ui then
            MPlayerInfo.FashionFromBag = item_id
            l_ui:SetFashion(MPlayerInfo.Fashion)
        end
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            local attrComp = MEntityMgr.PlayerEntity.AttrComp
            if attrComp ~= nil then
                MPlayerInfo.FashionFromBag = item_id
                attrComp:SetFashion(MPlayerInfo.Fashion)
            end
        end
    end
end

function RefreshPlayerOrnament(ornamentType, itemId, flag)
    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        local attrComp = MEntityMgr.PlayerEntity.AttrComp
        if attrComp ~= nil then
            attrComp:SetOrnamentByIntType(ornamentType, itemId, flag)
        end
    end
end
--初始化饰品数据
InitOrnamentTable()
----------------------------饰品数据end-----------------------------

--- 背包同步要刷新角色显示数据
function _onBagSync()
    local itemContMgr = MgrMgr:GetMgr("ItemContainerMgr")
    local equips = itemContMgr.GetEquips()
    for i = 1, #equips do
        local singleEquip = equips[i]
        SetOrnamentEx(singleEquip.TID, singleEquip.SvrSlot)
    end
end

--- 这个写法是为了避免替换的时候出问题
---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[EquipMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        --logError("equip mgr itemUpdateDataList i : "..singleData.OldItem .TID)
        if GameEnum.EBagContainerType.Equip == singleData.OldContType then
            RemoveOrnament(singleData.OldItem.TID, singleData.OldItem.SvrSlot)
        end
    end

    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        --logError("equip mgr itemUpdateDataList i : "..singleData.NewItem.TID)
        if GameEnum.EBagContainerType.Equip == singleData.NewContType then
            SetOrnamentEx(singleData.NewItem.TID, singleData.NewItem.SvrSlot)
        end
    end
end

function RequestAppraiseEquip(uids, id)
    if not uids or (#uids <= 0) then
        logError("传的uid有问题：" .. tostring(uids))
        return
    end
    local l_msgId = Network.Define.Rpc.AppraiseEquip
    ---@type AppraiseEquipArg
    local l_sendInfo = GetProtoBufSendTable("AppraiseEquipArg")
    for i = 1, #uids do
        local oneItem = l_sendInfo.uids:add()
        oneItem.value = uids[i].uid
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo, id)
end

function OnAppraiseEquipResponse(msg, _, id)
    ---@type AppraiseEquipRes
    local l_info = ParseProtoBufToTable("AppraiseEquipRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(id)
        local equipTableInfo = TableUtil.GetEquipTable().GetRowById(id)
        local l_identifyInfo = MgrMgr:GetMgr("EquipMgr").GetEquipConsumeTableId(l_itemInfo.TypeTab, equipTableInfo.level[0])
        local l_id = l_identifyInfo.IdentificationConsume:get_Item(0, 0)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_id, nil, nil, nil, true)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("EQUIP_IDENTIFICATION_SUCCESSFUL"))
        EventDispatcher:Dispatch(AppraiseEquipSucceed)
    end
end

--是否是双手武器
function IsDoubleHandWeaponWithId(id)
    local l_HoldingMode = GetEquipHoldingModeById(id)
    if l_HoldingMode == HoldingModeDouble then
        return true
    end
    return false
end

--是否武器是两个手拿的
function IsWeaponUseTwoHandWithId(id)
    local l_HoldingMode = GetEquipHoldingModeById(id)
    if l_HoldingMode == HoldingModeDouble or l_HoldingMode == HoldingModeDoubleHand then
        return true
    end
    return false
end

--是否是盾牌
function IsShieldWithId(id)
    local l_HoldingMode = GetEquipHoldingModeById(id)
    if l_HoldingMode == HoldingModeAssist then
        return true
    end
    return false
end

function GetEquipHoldingModeById(equipId)
    local l_equipRow = TableUtil.GetEquipTable().GetRowById(equipId)
    if l_equipRow == nil then
        logError("cannot find EquipTable, id=" .. equipId)
        return HoldingModeNone
    end

    local l_weaponType = l_equipRow.WeaponId
    local l_HoldingMode = HoldingModeNone
    if l_weaponType ~= 0 then
        local l_weaponRow = TableUtil.GetEquipWeaponTable().GetRowById(l_weaponType)
        if l_weaponRow == nil then
            logError("cannot find EquipWeaponTable, id=" .. l_weaponType)
            return HoldingModeNone
        end
        l_HoldingMode = l_weaponRow.HoldingMode
    end
    return l_HoldingMode
end

--得到推荐流派的文字详情
function GetGenreText(id)
    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(id)
    local h = equipTableInfo.RecommendSchool
    local RecommendSchool = Common.Functions.VectorToTable(h)
    if RecommendSchool[1] == nil or RecommendSchool[1] == 0 then
        return nil
    else
        local l_ret = {}
        local l_sign = Lang("SUIT_RECOMMAND_SPLIT")
        for i = 1, #RecommendSchool do
            local l_professionTextTable = TableUtil.GetProfessionTextTable().GetRowByNAME(RecommendSchool[i])
            table.insert(l_ret, l_professionTextTable.SchoolName)
        end

        return table.concat(l_ret, l_sign)
    end
end

--得到装备的装备最低等级
function GetEquipLimitLevel(id)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(id, true)
    if itemTableInfo == nil then
        return 0
    end

    return itemTableInfo.LevelLimit:get_Item(0)
end

--根据品质得到颜色值
function GetEquipQualityColor(id)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(id)
    return RoQuality.GetColorTag(itemTableInfo.ItemQuality)
end

--根据品质得到颜色值
function GetEquipNameWithColor(id)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(id)
    if itemTableInfo  then
        local itemName = itemTableInfo.ItemName
        if itemTableInfo.ItemQuality > 0 then
            return GetColorText(itemName, GetEquipQualityColor(id))
        end
        return itemName
    end
    return tostring(id)
end

--得到此装备位置的所有装备
function GetEquipsWithEquipId(id)
    local equips = GetEquipsInBagWithEquipId(id)
    local wearEquips = GetEquipOnBodyWithEquipId(id)
    table.ro_insertRange(equips, wearEquips)
    return equips
end

--得到背包里此装备位置的所有装备
---@return ItemData[]
function GetEquipsInBagWithEquipId(equipID)
    if GameEnum.ELuaBaseType.Number ~= type(equipID) then
        logError("[BagEquipMgr] invalid param")
        return {}
    end

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    local types = { GameEnum.EBagContainerType.Bag }
    local conditions = {
        { Cond = itemFuncUtil.ItemMatchesEquipID, Param = equipID },
        { Cond = itemFuncUtil.ItemMatchesTypes, Param = { GameEnum.EItemType.Equip } },
    }

    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

--id为装备表中的EquipId字段
--根据表中的装备位置来取身上的装备
function GetEquipOnBodyWithEquipId(id)
    local equips = {}
    local position = Data.BagModel.WeapTableType[id]
    local propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, position + 1)
    if propInfo ~= nil then
        table.insert(equips, propInfo)
    end

    if position == EquipPos.ORNAMENT1 then
        local clientEnum = EquipPos.ORNAMENT2 + 1
        propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, clientEnum)
        if propInfo ~= nil then
            table.insert(equips, propInfo)
        end
    end

    return equips
end

function IsSexMale(sex)
    local isMale = true
    if sex == 1 then
        isMale = false
    end
    return isMale
end

function IsPlayerConformProfessionWithPlayerParentProfession(professionInfo, parentProfessions)
    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    if l_professionTableInfo == nil then
        logError("ProfessionTable表没有配，id：" .. tostring(MPlayerInfo.ProfessionId))
        return false
    end

    local l_professionCount = professionInfo.Length
    if l_professionCount == 0 then
        return true
    end
    if professionInfo[0][0] == 0 then
        return true
    end
    for i = 1, l_professionCount do
        local l_professionId = professionInfo[i - 1][0]
        if l_professionId == MPlayerInfo.ProfessionId then
            return true
        end
        if professionInfo[i - 1][1] == 0 then
            if table.ro_contains(parentProfessions, l_professionId) then
                return true
            end
        end
    end
    return false
end

--玩家的职业是否符合表配的职业
function IsPlayerConformProfession(professionInfo)
    return IsPlayerConformProfessionWithPlayerParentProfession(professionInfo, GetPlayerParentProfession())
end

function GetPlayerParentProfession()
    local l_parentProfessions = {}

    local l_parentProfession = MPlayerInfo.ProfessionId
    while true do
        l_parentProfession = GetParentProfessionWithProfessionId(l_parentProfession)
        if l_parentProfession == 0 then
            return l_parentProfessions
        end
        table.insert(l_parentProfessions, l_parentProfession)
    end

    return l_parentProfessions
end

function GetParentProfessionWithProfessionId(professionId)
    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(professionId)
    if l_professionTableInfo == nil then
        logError("ProfessionTable表没有配，id：" .. tostring(MPlayerInfo.ProfessionId))
        return 0
    end
    return l_professionTableInfo.ParentProfession
end

--判断是否是穿戴装备
function CheckEquipIsBody(uid)
    for equipIndex, name in pairs(eEquipTypeName) do
        local equips = GetEquipOnBodyWithEquipId(equipIndex)
        for i, v in pairs(equips) do
            if v.UID == uid then
                return true
            end
        end
    end
    return false
end

function IsRaity(propInfo)
    if propInfo == nil then
        return false
    end

    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)
    return l_itemTableInfo.IsRare == 1
end

--得到置换器的属性
---@param itemData ItemData
function GetEquipReplaceAttrInfo(itemData)
    if nil == itemData then
        return {}
    end

    return itemData.AttrSet[GameEnum.EItemAttrModuleType.Device][1]
end

--装备ICON洞
function SetEquipIconHole(data, l_holeList)
    --未打洞的
    local l_dontHole = MgrMgr:GetMgr("EquipMakeHoleMgr").GetNotOpenHoleCount(data)
    for i = 1, l_dontHole do
        l_holeList[i].gameObject:SetActiveEx(true)
        l_holeList[i]:SetSprite("Common", "UI_Common_Icon_Kacao03.png")
    end
    --已打洞未插卡的
    local l_cardCount = #MgrMgr:GetMgr("EquipMakeHoleMgr").GetCardIds(data)
    local l_notCard = data:GetOpenHoleCount() - l_cardCount
    for i = l_dontHole + 1, l_dontHole + l_notCard do
        l_holeList[i].gameObject:SetActiveEx(true)
        l_holeList[i]:SetSprite("Common", "UI_Common_Icon_Kacao02.png")
    end
    for i = l_dontHole + l_notCard + 1, l_dontHole + l_notCard + l_cardCount do
        l_holeList[i].gameObject:SetActiveEx(true)
        l_holeList[i]:SetSprite("Common", "UI_Common_Icon_Kacao01.png")
    end
end

--获取装备消耗ID
function GetEquipConsumeTableId(type, level)
    local l_consumeId = type * 10000 + level
    if l_consumeId % 10 ~= 0 then
        l_consumeId = math.ceil(tonumber(StringEx.Format("{0:F1}", l_consumeId / 10))) * 10
    end

    local l_identifyInfo = TableUtil.GetEquipConsumeTable().GetRowByID(l_consumeId)
    if not l_identifyInfo then
        logError("EquipConsumeTable id error " .. l_consumeId)
        return
    end

    return l_identifyInfo
end

--是否是武器
function IsWeapon(itemid)
    local l_item = TableUtil.GetItemTable().GetRowByItemID(itemid)
    if l_item and 1 == l_item.TypeTab then
        local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(itemid)
        if l_equipTableInfo then
            return l_equipTableInfo.EquipId == 1
        end
    end

    return false
end

function GetEquipTypeName(id)
    local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(id)
    if l_equipTableInfo == nil then
        logError("cannot find equip by itemid:" .. tostring(id))
        return "invalid equip"
    end

    return eEquipTypeName[l_equipTableInfo.EquipId]
end

-- 根据部位获取部位描述
function GetEquipTypeNameByEquipID(equipID)
    if nil == equipID then
        return "invalid equip"
    end

    return eEquipTypeName[equipID]
end

function GetAllAttrText(AttrDatas, valueColor)
    local l_texts = {}
    for i = 1, #AttrDatas do
        table.insert(l_texts, GetAttrStrByData(AttrDatas[i], valueColor))
    end
    return table.concat(l_texts, "、")
end

--得到装备的属性描述
--参数三 buff预览类型 不传则显示为Default
--不包括流派词条
--attrData 属性
--valueColor 数值颜色
--Entry 类型
function GetAttrStrByData(AttrData, valueColor)
    local l_ret = "table error"
    if AttrData == nil then
        return "data error"
    end

    if AttrData.type == AttrTypeBuff then
        --Buff
        l_ret = TableUtil.GetBuffTable().GetRowById(AttrData.id).Description
        if string.ro_isEmpty(l_ret) then
            logError("BuffTable表的Description字段没有配，查看一下是否有问题，id：" .. tostring(AttrData.id))
        end
    else
        l_ret = GetAttrName(AttrData, valueColor)
    end

    return l_ret
end

--得到通用的属性描述
function GetAttrName(AttrData, valueColor)
    local l_ret = "table error"
    if AttrData == nil then
        return "data error"
    end

    if AttrData.type == AttrTypeAttr then
        --基础属性
        local attrInfo = TableUtil.GetAttrDecision().GetRowById(AttrData.id)
        if attrInfo then
            local l_num = MgrMgr:GetMgr("ItemPropertiesMgr").GetPropertyValueText(attrInfo, AttrData.val)
            local l_valueText = nil
            if valueColor == nil then
                l_valueText = tostring(l_num)
            else
                l_valueText = GetColorText(tostring(l_num), valueColor)
            end
            l_ret = StringEx.Format(attrInfo.TipTemplate, l_valueText)
        else
            l_ret = "AttrDecision not have id：" .. tostring(AttrData.id)
        end
    elseif AttrData.type == AttrTypeSpecialSkill then
        --特技
        l_skill = TableUtil.GetBuffTable().GetRowById(AttrData.id)
        if l_skill == nil then
            logError("BuffTable not have" .. AttrData.id)
            return l_ret
        end
        l_ret = StringEx.Format(Common.Utils.Lang("CARD_SPECIAL_SKILL"), l_skill.InGameName)
    elseif AttrData.type == AttrTypeSkill then
        --技能
        l_skill = TableUtil.GetSkillTable().GetRowById(AttrData.id)
        if l_skill == nil then
            logError("SkillTable not have" .. AttrData.id)
            return l_ret
        end
        l_ret = StringEx.Format(Common.Utils.Lang("CARD_SKILL"), l_skill.Name)
    else
        l_ret = "type error:" .. tostring(AttrData.type) .. "  id:" .. tostring(AttrData.id)
    end

    return l_ret
end

--- 获取所有的装备
---@return ItemData[]
function _getAllEquips()
    local types = { GameEnum.EBagContainerType.Equip }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

function IsEquipNotInSell(propId)
    local l_commondit = TableUtil.GetCommoditTable().GetRowByCommoditID(propId, true)
    local l_stallDetail = TableUtil.GetStallDetailTable().GetRowByItemID(propId, true)
    local l_gift = TableUtil.GetGiftTable().GetRowByItemID(propId, true)
    return l_commondit == nil and l_stallDetail == nil and l_gift == nil
end

return ModuleMgr.EquipMgr