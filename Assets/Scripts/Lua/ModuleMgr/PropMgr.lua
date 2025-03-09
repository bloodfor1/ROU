require "Data/Model/BagApi"
require "Data/Model/PlayerInfoModel"
require "Data/Model/BagModel"
require "ModuleMgr/QuickUseMgr"

---@module ModuleMgr.PropMgr
module("ModuleMgr.PropMgr", package.seeall)

l_virProp = GameEnum.l_virProp
EventDispatcher = EventDispatcher.new()

ReceiveEquipItemEvent = "ReceiveEquipItemEvent"
ItemChangeEvent = "ItemChangeEvent"
ItemChangeSelectEquip = "ItemChangeSelectEquip"
ItemChangeEquipCard = "ItemChangeEquipCard"
CHOOSE_GIFT_SUC = "CHOOSE_GIFT_SUC"
LEVEL_CHANGE = "LEVEL_CHANGE"
USE_ITEM_REPLY = "USE_ITEM_REPLY"   --使用支付道具结果Reply

FliesWingsID = 2031002 -- 苍蝇翅膀ID
ButterflyWingsID = 0 -- 蝴蝶翅膀ID
-- 全自动守护装置
PotionSettingItemId = 2040011
-- 战斗加速糖使用引导ID
FightCandyUseGuide = 192

partialCoinHash = {
    [l_virProp.Coin104] = 1,
    [l_virProp.Coin103] = 1,
    [l_virProp.Coin101] = 1,
    [l_virProp.Coin102] = 1,
    [l_virProp.Prestige] = 1,
}

coinHash = {
    [l_virProp.Coin104] = 1,
    [l_virProp.Coin103] = 1,
    [l_virProp.Coin101] = 1,
    [l_virProp.Coin102] = 1,
    [l_virProp.Prestige] = 1,
    [l_virProp.Yuanqi] = 1,
    [l_virProp.GuildContribution] = 1,
    [l_virProp.ArenaCoin] = 1,
    [l_virProp.AssistCoin] = 1,
    [l_virProp.MonsterCoin] = 1,
    [l_virProp.Certificates] = 1,
    [l_virProp.MerchantCoin] = 1,
}

local gameEventMgr = MgrProxy:GetGameEventMgr()

function OnInit()
    ButterflyWingsID = MGlobalConfig:GetInt("ButterflyWingsID", 2031002)
    FliesWingsID = MGlobalConfig:GetInt("FliesWingsID", 2031003)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagItemUpdate, nil)
end

function OnUnInit()
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, nil)
end

function OnLogout()
    MPlayerInfo.Exp = 0
    MPlayerInfo.JobExp = 0
    MPlayerInfo.Coin104 = 0
    MPlayerInfo.Coin103 = 0
    MPlayerInfo.Coin101 = 0
    MPlayerInfo.Coin102 = 0
    MPlayerInfo.Yuanqi = 0
    MPlayerInfo.BoliPoint = 0
    MPlayerInfo.GuildContribution = 0
    MPlayerInfo.ArenaCoin = 0
    MPlayerInfo.Prestige = 0
    MPlayerInfo.AssistCoin = 0
    MPlayerInfo.MonsterCoin = 0
    MPlayerInfo.CertificatesCount = 0
    MPlayerInfo.MerchantCoin = 0
    MPlayerInfo.Debris = 0
    Data.BagModel:deleteAll()
    SetGiftIsAllUse(true)
end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    local l_m = Data.BagModel:getOpenModel()
    Data.BagModel:deleteAll()
    Data.BagModel:OnSelectRoleNtf(l_roleAllInfo)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
    if l_ui then
        l_shop = UIMgr:GetUI(UI.CtrlNames.Shop)
        if l_shop then
            if l_m == Data.BagModel.OpenModel.Sale then
                Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Sale)
            end
        end

        l_ui:FreshProp()
        l_ui:FreshQuick()
        l_ui:FreshWeapon()
        l_ui:FreshPot()
    end
end

function IsCoin(id)
    return nil ~= partialCoinHash[id]
end

function IsVirtualCoin(id)
    local delegateMgr = MgrMgr:GetMgr("DelegateModuleMgr")
    ret = nil ~= coinHash[id]
    if not ret then
        return delegateMgr.IsMedal(id)
    end

    return ret
end

function OnLevelChangeNtf(msg)
    ---@type LevelChanged
    local l_info = ParseProtoBufToTable("LevelChanged", msg)
    MPlayerInfo.Lv = l_info.level
    MPlayerInfo.Exp = l_info.exp
    if l_info.extra_base_exp ~= nil then
        MPlayerInfo.BlessExp = l_info.extra_base_exp
    end

    if l_info.extra_job_exp ~= nil then
        MPlayerInfo.BlessJobExp = l_info.extra_job_exp
    end

    if l_info.extra_fight_time ~= nil then
        Data.PlayerInfoModel:SetExtraFightTime(l_info.extra_fight_time)
    end

    Data.PlayerInfoModel:setBaseLv(l_info.level)
    Data.PlayerInfoModel:setBaseExpData(MPlayerInfo.ExpRate)
    Data.PlayerInfoModel:setBaseExpBlessData(MPlayerInfo.BlessExpRate)
    Data.PlayerInfoModel:setJobExpBlessData(MPlayerInfo.BlessJobExpRate)
    MgrProxy:GetQuickUseMgr().OnUpgrade()
    EventDispatcher:Dispatch(LEVEL_CHANGE)

    -- SDK打点
    MgrMgr:GetMgr("AdjustTrackerMgr").BaseLevelEvent(MPlayerInfo.Lv)
    MgrMgr:GetMgr("CrashReportMgr").SetPlayerInfo()
end

function OnJobLevelChangeNtf(msg)
    ---@type LevelChanged
    local l_info = ParseProtoBufToTable("LevelChanged", msg)
    MPlayerInfo.JobLv = l_info.level
    MPlayerInfo.JobExp = l_info.exp
    MPlayerInfo.BlessJobExp = l_info.extra_job_exp
    Data.PlayerInfoModel:setJobLv(l_info.level)
    Data.PlayerInfoModel:setJobExpData(MPlayerInfo.JobExpRate)
    Data.PlayerInfoModel:setJobExpBlessData(MPlayerInfo.BlessJobExpRate)

    -- SDK打点
    MgrMgr:GetMgr("AdjustTrackerMgr").JobLevelEvent(MPlayerInfo.JobLv)
    MgrMgr:GetMgr("CrashReportMgr").SetPlayerInfo()
end

function OnMoveItem(msg)
    ---@type MoveItemRes
    local l_info = ParseProtoBufToTable("MoveItemRes", msg)
    if ErrorCode.ERR_SUCCESS == l_info.error then
        return
    end

    local l_s = Common.Functions.GetErrorCodeStr(l_info.error)
    if l_info.error == 1711 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GardrobeError1711"))
        return
    end

    if l_s ~= nil and l_s ~= "" then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
    end
end

-- todo obsolete
function RequestSortBag(type)
    -- do nothing
end

-- todo obsolete
function OnSortBag(msg, arg)
    -- do nothing
end

--检查道具是否是变身道具
function CheckIsTransfingerItem(id)
    local l_data = TableUtil.GetItemFunctionTable().GetRowByItemId(id, true)
    if l_data == nil then
        return false
    end

    local itemFunctionValue = l_data.ItemFunctionValue
    for k = 0, itemFunctionValue.Length - 1 do
        local buffdata = TableUtil.GetBuffTable().GetRowById(itemFunctionValue[k], true)
        if buffdata == nil then
            return false
        end

        if buffdata.Type == 24 or buffdata.Type == 5 then
            return true
        else
            return false
        end
    end

    return false
end

-- 物品使用前的二次确认处理
function CheckUseItem(uid, itemId, useItemFunc)
    local l_functionRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
    if l_functionRow then
        if l_functionRow.ItemFunction == GameEnum.EItemFunctionType.GuaJiJiaSu then
            MgrMgr:GetMgr("AutoFightItemMgr").CheckUseGuaJiJiaSuItem(itemId, useItemFunc)
            return
        elseif l_functionRow.ItemFunction == GameEnum.EItemFunctionType.DaBaoTang then
            MgrMgr:GetMgr("AutoFightItemMgr").CheckUseDaBaoItem(itemId, useItemFunc)
            return
        end
    end

    if useItemFunc then
        useItemFunc()
    end
end

function RequestUseItem(uid, count, propId, operate_type, additionalData)
    local l_cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(propId)
    if l_cd > 0 then
        return
    end

    --有一些特殊判定的道具 不需要显示使用按钮
    local UnUseIdTb = MGlobalConfig:GetSequenceOrVectorInt("ItemsWithoutUseButton")
    for i = 1, UnUseIdTb.Length do
        if UnUseIdTb[i - 1] == propId then
            return
        end
    end

    --工会邀请函判断
    if CheckIsThemeDanceLatter(propId) then
        return
    end

    --工会礼盒判断
    if CheckGuildBox(propId, additionalData) then
        return
    end

    --Buff检测
    if UseItemCheckBuff(propId, additionalData) then
        return
    end

    if MgrMgr:GetMgr("VehicleMgr").VehicleUseItemCheck(propId) then
        return
    end

    --蝴蝶翅膀特判
    if propId == ButterflyWingsID then
        local itemCount = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, propId)
        if 0 >= itemCount then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_INSUFFICIENT_ITEM_COUNT"))
            return
        end

        local l_commonItemTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
        if l_commonItemTips then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        end

        local l_ifcRow = TableUtil.GetItemFunctionTable().GetRowByItemId(propId)
        local l_itemLmtId = l_ifcRow.ItemLimitID[0][0]
        local l_itemUseRow = TableUtil.GetItemUseLimitTable().GetRowByID(l_itemLmtId)
        local l_paras = l_itemUseRow.Para
        local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
        local l_show = true
        for i = 0, l_paras.Length - 1 do
            if l_sceneRow.SceneType == l_paras[i] then
                l_show = false
            end
        end

        if l_show == true then
            UIMgr:ActiveUI(UI.CtrlNames.TransferController)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(ErrorCode.ITEM_CANNOT_USE_CUR_SCENE))
        end

        return
    end

    -- 抽奖券
    local l_item_func_row = TableUtil.GetItemFunctionTable().GetRowByItemId(propId, true)
    if l_item_func_row and l_item_func_row.ItemFunction == Data.BagModel.ItemFunction.Ticket then
        --因为ItemFunctionTable的ItemFunctionValue修改 所以抽奖券取第一个值
        MgrMgr:GetMgr("TurnTableMgr").OpenUI(l_item_func_row.ItemFunctionValue[0], propId)
        return
    end

    --选择礼包物品
    if l_item_func_row and l_item_func_row.ItemFunction == Data.BagModel.ItemFunction.Award then
        UIMgr:ActiveUI(UI.CtrlNames.ChooseGift, function(ctrl)
            if giftIsAllUse then
                ctrl:ShowChooseItems(l_item_func_row)
            else
                ctrl:ShowChooseItems(l_item_func_row, uid)
            end
        end)
        return
    end

    if l_item_func_row and l_item_func_row.ItemFunction == Data.BagModel.ItemFunction.ExchangeItemShop then
        local l_sceneId, l_npcId = l_item_func_row.ItemFunctionValue[0], l_item_func_row.ItemFunctionValue[1]
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        UIMgr:DeActiveUI(UI.CtrlNames.Bag)
        MTransferMgr:GotoNpc(l_sceneId, l_npcId, function()
            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_sceneId, l_npcId)
        end)
        return
    end

    if l_item_func_row and l_item_func_row.ItemFunction == Data.BagModel.ItemFunction.EvilTicket then
        MgrMgr:GetMgr("DelegateModuleMgr").ShowItemAchievePlacePanel(1)
        return
    end

    --使用时尚评分杂志道具
    if MgrMgr:GetMgr("FashionRatingMgr").TryUseItem(uid, propId) then
        return
    end

    if l_item_func_row and l_item_func_row.ItemFunction == GameEnum.EItemFunctionType.Bingo then
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
        if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.BingoActivity) then
            UIMgr:ActiveUI(UI.CtrlNames.Bingo)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_BOLI_NOT_OPEN"))
        end
        return
    end

    if l_item_func_row and l_item_func_row.ItemFunction == GameEnum.EItemFunctionType.VehicleBreach then
        local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
        if not l_vehicleInfoMgr.CanUseAddVehicleExpOrBreachProp() then
            local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
            local l_unlockLevel = l_openSysMgr.GetSystemOpenBaseLv(l_openSysMgr.eSystemId.VehicleAbility)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_PROP_USE_CONDITION", l_unlockLevel))
            return
        end
    end

    -- 全自动守护装置
    if propId == PotionSettingItemId then
        UIMgr:ActiveUI(UI.CtrlNames.PotionSetting)
        return
    end

    --此处需要判断点击的是否是变身的道具
    --状态互斥状态机判断可行性
    if CheckIsTransfingerItem(propId) then
        if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_A_InitiativeTransfigured) then
            return
        end
    end

    --公会原石雕刻
    --[[if MgrMgr:GetMgr("StoneSculptureMgr").TryUseItem(uid, propId) then
        return
    end]]

    --公会红包使用
    if MgrMgr:GetMgr("GuildHuntMgr").TryUseItem(uid, propId) then
        return
    end

    local l_msgId = Network.Define.Rpc.UseItem
    ---@type UseItemArg
    local l_sendInfo = GetProtoBufSendTable("UseItemArg")
    l_sendInfo.uid = uid
    l_sendInfo.count = tostring(count)
    l_sendInfo.item_id = propId
    if operate_type ~= nil then
        l_sendInfo.operate_type = operate_type
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo, additionalData)
    CommandBlockTriggerManager.LuaTrigger("ON_START_USE_ITEM", {
        ItemId = propId
    })
end

function OnUseItem(msg, arg, additionalData)
    ---@type UseItemRes
    local l_info = ParseProtoBufToTable("UseItemRes", msg)
    local l_error = l_info.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    if l_errorNo == ErrorCode.ERR_SUCCESS then
        UseItemCompleted(arg.item_id)
        CommandBlockTriggerManager.LuaTrigger("ON_FINISH_USE_ITEM", {
            ItemId = arg.item_id
        })
    else
        local l_autoUse = additionalData and additionalData.isAutoUse
        -- 自动使用的道具不弹提示
        if not l_autoUse then
            MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)
        end
    end
end

--工会礼盒的特殊判断
function CheckGuildBox(propId, additionalData)
    if additionalData ~= nil then
        return additionalData.GuildCheck
    end

    if propId == nil then
        return false
    end

    local boxId = TableUtil.GetGuildSettingTable().GetRowBySetting("GuildGiftBoxId").Value
    if boxId == nil then
        return false
    end

    if tostring(propId) ~= tostring(boxId) then
        return false
    end

    local cost = TableUtil.GetGuildSettingTable().GetRowBySetting("GuildGiftBoxOpenCost").Value
    if cost == nil then
        logError("GuildSettingTable的GuildGiftBoxOpenCost是空的")
        return false
    end
    local costStrGroup = string.ro_split(cost, "=")
    if costStrGroup == nil then
        logError("GuildSettingTable的GuildGiftBoxOpenCost配置的不对")
        return false
    end

    if costStrGroup[1] == nil then
        logError("GuildSettingTable的GuildGiftBoxOpenCost配置的不对")
        return false
    end

    if costStrGroup[2] == nil then
        logError("GuildSettingTable的GuildGiftBoxOpenCost配置的不对")
        return false
    end

    local l_costId = tonumber(costStrGroup[1])

    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_costId)
    local richText = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_itemTableInfo.ItemIcon, l_itemTableInfo.ItemAtlas, 16, 1.8)
    local dialogStr = Lang("CHECK_GUILD_BOX", richText .. costStrGroup[2])--..l_itemTableInfo.ItemName)

    --如果配置的消耗小于等于0 则不显示

    local currentCost = tonumber(costStrGroup[2])
    if currentCost <= 0 then
        return false
    end

    local currentCount = Data.BagModel:GetCoinNumById(l_costId)
    local l_uid = _getFirstItemUID(propId)
    local comfirmFunc = function()
        if currentCount < currentCost then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CONTRIBUTION_NOT_ENOUGH"))
            return
        end
        MgrMgr:GetMgr("PropMgr").RequestUseItem(l_uid, 1, propId, nil, { GuildCheck = false })
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, dialogStr, comfirmFunc)
    return true
end

function _getFirstItemUID(tid)
    local items = _getBagItemByTID(tid)
    if nil == items then
        return nil
    end

    if 0 == #items then
        return nil
    end

    return items[1].UID
end

---@return ItemData[]
function _getBagItemByTID(tid)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function CheckIsThemeDanceLatter(propId)
    if propId == nil then
        return false
    end

    local themeDanceItemId = TableUtil.GetThemePartyTable().GetRowBySetting("InvitationLetterId").Value
    if themeDanceItemId == nil then
        return false
    end

    if tonumber(themeDanceItemId) == propId then
        UIMgr:ActiveUI(UI.CtrlNames.PartyInvitation)
    else
        return false
    end

    return true
end

function UseItemCheckBuff(propId, additionalData)
    if propId == nil then
        return false
    end

    if additionalData ~= nil then
        return additionalData.buffCheck
    end

    itemFunctionInfo = TableUtil.GetItemFunctionTable().GetRowByItemId(propId, true)
    if itemFunctionInfo == nil then
        return false
    end

    --产生Buff类的道具的特殊判断
    local isBuffLevelLower = false
    local isBuffLevelHigher = false
    if itemFunctionInfo.ItemFunction == 1 then
        local buffId = itemFunctionInfo.ItemFunctionValue[0]
        local buffData = TableUtil.GetBuffTable().GetRowById(buffId)
        if buffId and buffData then
            if MEntityMgr.PlayerEntity:HasBuff(buffData.BuffId) then
                local level = MEntityMgr.PlayerEntity:GetBuffLevel(buffData.BuffId)
                isBuffLevelLower = level < buffData.Level
                isBuffLevelHigher = level > buffData.Level
            end
        end
    end

    local l_uid = _getFirstItemUID(propId)
    --如果玩家身上有比即将加上去的buff等级更高的同一buff
    if isBuffLevelHigher then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("USE_ITEM_BUFF_HIGHER"))
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        return true
    end

    --如果玩家身上有比即将加上去的buff等级更低的同一buff
    if isBuffLevelLower then
        local comfirmFunc = function()
            MgrMgr:GetMgr("PropMgr").RequestUseItem(l_uid, 1, propId, nil, { buffCheck = false })
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            return true
        end

        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("USE_ITEM_BUFF_LOWER"), comfirmFunc)
        return true
    end

    return false
end

function UseItemCompleted(itemId)
    DoUseItemAction(itemId)
    ShowUseItemFx(itemId)
    DoUseItemBehaviour(itemId)

    local l_row = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
    if l_row == nil then
        logError("ItemFunctionTable表中没有配这个数据：" .. tostring(itemId))
        return
    end
    local l_audioId = l_row.AudioID
    if l_audioId ~= nil then
        MAudioMgr:Play(l_audioId)
    end
    MgrMgr:GetMgr("ItemCdMgr").AddCd(itemId)
end

function OnBagFullSendMailNtf(msg)
    ---@type BagFullSendMailNtfData
    local l_info = ParseProtoBufToTable("BagFullSendMailNtfData", msg)
    local l_err = l_info.info
    local l_itemIds = l_info.infos
    local l_items = {}
    local l_isTurnTableAction = MgrMgr:GetMgr("TurnTableMgr").IsAction()
    local l_isWabaoAction = MgrMgr:GetMgr("WabaoAwardMgr").IsAction()
    for k, v in ipairs(l_itemIds) do
        local l_id = v.item_id
        local l_count = v.count
        local l_row = TableUtil.GetItemTable().GetRowByItemID(l_id)
        if l_row ~= nil then
            --log(tostring(l_err.errorno))
            local l_tips
            if l_err.errorno == ErrorCode.ERR_BAG_MAX_LOAD then
                l_tips = StringEx.Format(Lang("FULL_LOAD_TIP"), l_row.ItemName)
            else
                l_tips = StringEx.Format(Lang("FULL_BAG_TIP"), l_row.ItemName)
            end
            if l_isTurnTableAction then
                MgrMgr:GetMgr("TurnTableMgr").CacheTips(l_tips)
            elseif l_isWabaoAction then
                MgrMgr:GetMgr("WabaoAwardMgr").CacheTips(l_tips)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
            end

            table.insert(l_items, { id = l_id, count = l_count })
        end
    end
    MgrMgr:GetMgr("ThemeDungeonMgr").SetRewardItemsMail(l_items)
end

function RequestUnlockBlank(type)
    local l_msgId = Network.Define.Rpc.UnlockBlank
    ---@type UnlockBlankArg
    local l_sendInfo = GetProtoBufSendTable("UnlockBlankArg")
    l_sendInfo.type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnUnlockBlank(msg, arg)
    ---@type UnlockBlankRes
    local l_info = ParseProtoBufToTable("UnlockBlankRes", msg)
    local l_type = arg.type
    local l_error = l_info.error or ErrorCode.ERR_SUCCESS
    if l_error ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        if l_error == ErrorCode.ERR_ITEM_NOT_ENOUGH then
            if l_type == ErrorCode.BAG then
                -- do nothing
            elseif l_type == BagType.WAREHOUSE then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(Data.BagModel:getPotUnlockItemId(), nil, nil, nil, true)
            end
        end
        return
    end

    local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
    if l_type == BagType.BAG then
        Data.BagModel:deleteAddWeightNum(-1)
    elseif l_type == BagType.WAREHOUSE then
        Data.BagModel:addPotPageUnlock()
        if l_ui then
            l_ui:FreshPotPage()
            l_ui:AddPotPageLockCellCount()
        end
    end
end

function ShowUseItemFx(id)
    local l_data = TableUtil.GetItemFunctionTable().GetRowByItemId(id);
    if l_data == nil then
        return
    end
    local l_target = Common.Functions.SequenceToTable((l_data.EffectPos))
    local l_sceneId = l_target[1]
    if MScene.SceneID ~= l_sceneId then
        return
    end
    local l_pos = Vector3.New(l_target[2], l_target[3], l_target[4])
    local l_effectData = TableUtil.GetEffectTable().GetRowById(l_data.ItemEffect)
    if l_effectData == nil then
        return
    end
    MPlayerInfo:FocusToPosition(l_pos)
    local l_fxData = MFxMgr:GetDataFromPool()
    l_fxData.playTime = l_effectData.PlayTime
    l_fxData.position = l_pos
    l_fxData.scaleFac = Vector3.New(l_effectData.ScaleX, l_effectData.ScaleY, l_effectData.ScaleZ)
    MFxMgr:CreateFx("Effects/Prefabs/" .. l_effectData.Path, l_fxData)
    MFxMgr:ReturnDataToPool(l_fxData)
end

function DoUseItemAction(id)
    local l_data = TableUtil.GetItemFunctionTable().GetRowByItemId(id);
    if l_data == nil then
        return
    end
    local l_actiondId = l_data.ItemAction
    if l_actiondId == 0 then
        return
    end

    local l_actiondData = TableUtil.GetAnimationTable().GetRowByID(l_actiondId)
    if l_actiondData == nil then
        logError("actionId :<" .. l_actiondId .. "> not exists in AnimationTable")
        return
    end

    MEventMgr:LuaFireEvent(MEventType.MEvent_Special, MEntityMgr.PlayerEntity,
            ROGameLibs.kEntitySpecialType_Action, l_actiondId)

    local l_actionTime = l_actiondData.MaxTime
    MgrMgr:GetMgr("TaskMgr").TaskUseItem(id, l_actionTime)
end

function DoUseItemBehaviour(id)
    local l_data = TableUtil.GetItemFunctionTable().GetRowByItemId(id);
    if l_data == nil then
        return
    end
    if l_data.ItemFunction == GameEnum.EItemFunctionType.GuaJiJiaSu then
        if not MgrMgr:GetMgr("BeginnerGuideMgr").CheckGuideMask(FightCandyUseGuide) then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            UIMgr:DeActiveUI(UI.CtrlNames.Bag)
            local l_beginnerGuideChecks = {"FightCandyUseGuide"}
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks,UI.CtrlNames.Main)
        end
    end
end

function AddRed(itemInfo)
    local l_ifRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemInfo.ItemID, true)
    if l_ifRow ~= nil and l_ifRow.ItemFunction == Data.BagModel.ItemFunction.Gift then
        Data.BagModel:addRed(itemInfo.uid)
    end
end

-- isAuto是否是系统自动使用，如自动喝药
function RequestUseItemByItemId(l_itemId, isAutoUse)
    local items = _getBagItemByTID(l_itemId)
    local l_info = items[1]
    if nil == l_info then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
        return
    end

    RequestUseItem(l_info.UID, 1, l_itemId, 1, { isAutoUse = isAutoUse })
end

function OnItemChangeNtf(msg)
    local l_quickUi = UIMgr:GetUI(UI.CtrlNames.QuickItem)
    ---@type ItemChange
    local l_info = ParseProtoBufToTable("ItemChange", msg)
    local cppIdx = l_info.tar_equipment_page
    MgrProxy:GetMultiTalentEquipMgr().SetCurrentPage(cppIdx + 1)

    local l_cgTable = l_info.change_items
    local l_addTable = l_info.add_items
    local l_rmTable = l_info.remove_items
    local l_reason = l_info.reason
    local l_isNewloot = l_info.is_new_loot
    local l_loadInfo = l_info.infos

    local l_openModel = Data.BagModel:getOpenModel()
    local l_realModel = nil
    if l_openModel == Data.BagModel.OpenModel.Sale then
        l_realModel = Data.BagModel.OpenModel.Sale
        Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Normal)
    end

    for k, v in ipairs(l_addTable) do
        ---@type ItemChangeInfo
        local itemAddInfo = v
        local l_type = itemAddInfo.type or BagType.BAG
        local l_it = itemAddInfo.item

        if l_type == BagType.BAG then
            if l_isNewloot == true then
                AddRed(l_it)
            end
        end
    end

    for k, v in ipairs(l_cgTable) do
        ---@type ItemChangeInfo
        local itemChangeInfo = v
        local l_type = itemChangeInfo.type or BagType.BAG
        local l_it = itemChangeInfo.item

        if l_type == BagType.BAG then
            if l_isNewloot == true then
                AddRed(l_it)
            end

            if l_reason == ItemChangeReason.ITEM_REASON_APPRAISE_EQUIP then
                local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
                if l_ui and l_ui.isActive and l_ui.uObj then
                    l_ui:RefreshAppraiseInfo(l_it.uid)
                end
            end
        end
    end

    if l_realModel == Data.BagModel.OpenModel.Sale then
        Data.BagModel:mdOpenModel(l_realModel)
    end

    for k, v in ipairs(l_loadInfo) do
        local l_type = v.type or BagType.BAG
        if l_type == BagType.BAG then
            MgrMgr:GetMgr("ItemWeightMgr").SetMaxWeightByType(GameEnum.EBagContainerType.Bag, v.max_load)
        elseif l_type == BagType.CART then
            Data.BagModel:mdMaxCarItemNum(v.max_blank)
            MgrMgr:GetMgr("ItemWeightMgr").SetMaxWeightByType(GameEnum.EBagContainerType.Cart, v.max_load)
        end
    end

    if #l_cgTable > 0 or #l_addTable > 0 or #l_rmTable > 0 then
        if l_quickUi and l_quickUi.isActive then
            l_quickUi:FreshQuick()
        end
    end

    local l_gameEventMgr = MgrProxy:GetGameEventMgr()
    if l_info.extra_base_exp ~= nil then
        MPlayerInfo.BlessExp = l_info.extra_base_exp
        Data.PlayerInfoModel:setBaseExpBlessData(MPlayerInfo.BlessExpRate)
        l_gameEventMgr.RaiseEvent(l_gameEventMgr.OnBlessExpChanged)
    end

    if l_info.extra_job_exp ~= nil then
        MPlayerInfo.BlessJobExp = l_info.extra_job_exp
        Data.PlayerInfoModel:setJobExpBlessData(MPlayerInfo.BlessJobExpRate)
    end

    if l_info.extra_fight_time ~= nil then
        Data.PlayerInfoModel:SetExtraFightTime(l_info.extra_fight_time)
    end
end

specialTipsTb = {}
function CalculateItemChangeData(l_addTable)
    for k, v in ipairs(l_addTable) do
        local l_data = v.item
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_data.ItemID)
        local l_Sex = MPlayerInfo.IsMale and 0 or 1

        if l_itemData and (l_itemData.SexLimit == 2 or l_itemData.SexLimit == l_Sex) then
            --加了道具性别限制 只提示和自己性别相同的和无限制的道具
            if l_itemData.AccessPrompt == 1 or l_itemData.AccessPrompt == 2 then
                table.insert(specialTipsTb, v)
            end
        end
    end

    local tempTb = UniqueTable(specialTipsTb)
    specialTipsTb = tempTb
    ShowTips()
end

--去重
function UniqueTable(tb)
    local l_ret = {}
    local l_valueSet = {}
    for k, v in pairs(tb) do
        if l_valueSet[v.item.ItemID] == nil then
            l_valueSet[v.item.ItemID] = true
            table.insert(l_ret, v)
        end
    end

    return l_ret
end

function ShowTips()
    if table.ro_size(specialTipsTb) > 0 then
        local l_data = specialTipsTb[1]
        local l_it = l_data.item
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_it.ItemID)
        if l_itemData then
            if MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType ~= MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.None then
                table.ro_removeValue(specialTipsTb, l_data)
                return
            end

            ShowSpecialTips(specialTipsTb[1], l_it.ItemID, l_data.incr_value)
        end
    end
end

function ShowSpecialTips(itemData, itemId, itemCount)
    local endFunc = function()
        if table.ro_size(specialTipsTb) > 1 then
            table.ro_removeValue(specialTipsTb, itemData)
            ShowTips()
        else
            specialTipsTb = {}
            UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
        end
    end

    MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(itemId, itemCount, endFunc)
end

function ResetSpecialTipsData(...)
    for k, v in pairs(specialTipsTb) do
        table.ro_removeValue(specialTipsTb, v)
    end

    specialTipsTb = {}
end

--得到装备的置换器属性
function GetItemDeviceAttrInfo(propInfo)
    if propInfo.device_component == nil then
        return nil
    end
    return propInfo.device_component.entrys
end

--根据道具信息 获取到物件的置换器信息
function GetAttrDeviceTipsInfo(propInfo, Color)
    local attrInfoTipsTb = {}
    if Color == nil then
        Color = RoColorTag.None
    end

    if propInfo.device_component == nil then
        return attrInfoTipsTb
    end

    local l_ReplaceAttrs = {}
    local itemtableData = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)
    if itemtableData then
        --设置类型为12的置换器物品
        if itemtableData.TypeTab == 12 then
            l_ReplaceAttrs = MgrMgr:GetMgr("PropMgr").GetItemDeviceAttrInfo(propInfo)
        elseif itemtableData.TypeTab == 1 then
            --设置类型为1的武器
            l_ReplaceAttrs = MgrMgr:GetMgr("EquipMgr").GetEquipReplaceAttrInfo(propInfo)
        end
    end

    for i = 1, #l_ReplaceAttrs do
        local txt = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(l_ReplaceAttrs[i], Color)
        table.insert(attrInfoTipsTb, txt)
    end
    return attrInfoTipsTb
end

--根据礼包ID获取可获得的道具
function GetGiftItemsToChoose(itemFunctionData)
    local showItemTable = {}
    --找出要显示的物品
    local itemFunctionValue = itemFunctionData.ItemFunctionValue
    if itemFunctionValue.Length < 2 then
        logError(StringEx.Format("ItemFunctionTable.id = {0} ItemFunctionValue格式不正确 @廖萧萧", itemFunctionData.ItemId))
        return {}
    end
    local awardId = itemFunctionValue[0]
    local type = itemFunctionValue[1]
    local awardTable = TableUtil.GetAwardTable().GetRowByAwardId(awardId)
    if awardTable then
        local awardPackTable = TableUtil.GetAwardPackTable().GetRowByPackId(awardTable.PackIds[0])
        if awardPackTable then
            --只要第一个ID 其他的抛弃掉
            local groupContent = awardPackTable.GroupContent
            for i = 0, groupContent.Length - 1 do
                local v = groupContent[i]
                table.insert(showItemTable, { id = v[0], num = v[1], idx = i + 1, type = type, awardId = awardId })
            end
        end
    end

    return showItemTable
end

--礼包道具ID
local giftItemId
--是否使用全部礼包
local giftIsAllUse = true

function SetGiftIsAllUse(value)
    giftIsAllUse = value
end

--请求选择礼包
function RequestChooseGift(itemUid, rewardId, idx, count, giftId)
    local l_msgId = Network.Define.Rpc.ExchangeAwardPack
    ---@type ExchangeAwardPackArg
    local l_sendInfo = GetProtoBufSendTable("ExchangeAwardPackArg")
    l_sendInfo.item_uid = itemUid
    l_sendInfo.reward_id = rewardId
    l_sendInfo.item_count = count
    l_sendInfo.idx = idx
    giftItemId = giftId

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取选择礼包
function ResponseChooseGift(msg)
    ---@type ExchangeAwardPackRes
    local l_info = ParseProtoBufToTable("ExchangeAwardPackRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        UIMgr:DeActiveUI(UI.CtrlNames.ChooseGift)
        return
    end

    if giftItemId then
        local uid = _getFirstItemUID(giftItemId)
        local propNum = Data.BagModel:GetBagItemCountByTid(giftItemId)
        if propNum > 0 then
            local l_itemFunctionSdata = TableUtil.GetItemFunctionTable().GetRowByItemId(giftItemId)
            local l_giftCtrl = UIMgr:GetUI(UI.CtrlNames.ChooseGift)
            if l_giftCtrl then
                l_giftCtrl:ShowChooseItems(l_itemFunctionSdata, uid, propNum)
            else
                UIMgr:ActiveUI(UI.CtrlNames.ChooseGift, function(ctrl)
                    ctrl:ShowChooseItems(l_itemFunctionSdata, uid, propNum)
                end)
            end
        else
            UIMgr:DeActiveUI(UI.CtrlNames.ChooseGift)
        end
    end
end

function _getFirstItemUID(tid)
    local items = _getBagItemByTID(tid)
    if nil == items then
        return nil
    end

    if 0 == #items then
        return nil
    end

    return items[1].UID
end

---@return ItemData[]
function _getBagItemByTID(tid)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function ReceiveGarbageCollectNtf(msg)
    MgrMgr:GetMgr("ChatMgr").SendSystemInfo(DataMgr:GetData("ChatData").EChannelSys.Private, Lang("Bag_FullText"))
end

function OnSelectRoleNtf()
    -- do nothing
end

function OnBagLoadUnlockNtf(msg)
    ---@type BagLoadUnlockNtfData
    local l_info = ParseProtoBufToTable("BagLoadUnlockNtfData", msg)
    if l_info.unlock_type == 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILL_WEIGHT"))
    elseif l_info.unlock_type == 2 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ATTR_WEIGHT"))
    elseif l_info.unlock_type == 3 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("VIP_WEIGHT"), l_info.unlock_load))
    end
end

--兑换货币的反馈
function BarterItem(ItemData)
    local l_msgId = Network.Define.Rpc.BarterItem
    ---@type BarterItemArg
    local l_sendInfo = GetProtoBufSendTable("BarterItemArg")
    for i = 1, #ItemData do
        local oneItem = l_sendInfo.items_brief:add()
        oneItem.item_id = ItemData[i].item_id
        oneItem.item_count = tostring(ItemData[i].item_count)
        oneItem.is_bind = ItemData[i].is_bind
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnBarterItem(msg)
    ---@type BarterItemRes
    local l_info = ParseProtoBufToTable("BarterItemRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXCHANGE_SUCCESS"))
end

---@param updateInfo ItemUpdateData[]
function _onBagItemUpdate(updateInfo)
    if nil == updateInfo then
        logError("[PropMgr] invalid param")
        return
    end

    local C_INVALID_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_NONE] = 1,
        [ItemChangeReason.ITEM_REASON_MOVE_ITEM] = 1,
    }

    -- 新手引导处理
    for i = 1, #updateInfo do
        local singleUpdateInfo = updateInfo[i]
        if singleUpdateInfo:IsItemNewAcquire()
                and singleUpdateInfo.NewItem.TID == PotionSettingItemId
                and nil == C_INVALID_REASON_MAP[singleUpdateInfo.Reason]
        then
            local l_beginnerGuideChecks = { "GetAutoDev" }
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.Main)
            break
        end
    end
end

function OnUseItemReplyClientPtc(msg)
    ---@type UseItemReplyClientData
    local l_info = ParseProtoBufToTable("UseItemReplyClientData", msg)
    local l_useItemSuc = l_info.result == 0
    if not l_useItemSuc then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
    local l_extraData = nil
    if l_info.ask_type == AskGsUseItemType.AskGsUseItemType_MagicPaper then
        l_extraData = l_info.magic_paper_brief
    end
    EventDispatcher:Dispatch(USE_ITEM_REPLY, l_info.ask_type, l_useItemSuc, l_extraData)
end

return ModuleMgr.PropMgr