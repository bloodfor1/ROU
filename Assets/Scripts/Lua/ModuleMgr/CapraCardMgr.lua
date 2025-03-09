---@module ModuleMgr.CapraCardMgr
module("ModuleMgr.CapraCardMgr", package.seeall)
local l_normalCapraCard = nil
local l_capraVIPCard = nil
local l_tipCache = {}--缓存的会员卡额外奖励提示
local l_waitRolesBattleInfo = false --是否处于等待返回角色助战信息状态

--region 生命周期方法
function OnInit()
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    l_dungeonMgr.EventDispatcher:Add(l_dungeonMgr.ENTER_DUNGEON, onEnterDungeon, ModuleMgr.CapraCardMgr)
end

function OnUnInit()
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    l_dungeonMgr.EventDispatcher:RemoveObjectAllFunc(l_dungeonMgr.ENTER_DUNGEON, ModuleMgr.CapraCardMgr)
end

function onEnterDungeon()
    if isNeedOpenReplicaCardDungeon() then
        showUseReplicaCardDialog()
    end
end

--endregion

--region api
---@param propInfo ItemData
function TryShowCapraCardPanel(propInfo, isShowAchieve, propStatus)
    UIMgr:DeActiveUI(UI.CtrlNames.CapraCard)
    UIMgr:DeActiveUI(UI.CtrlNames.ReplicaCard)
    if propStatus == Data.BagModel.WeaponStatus.MALL then
        return false
    end

    if IsCapraCard(propInfo.TID) then
        if not isShowAchieve then
            ShowCapraCard(propInfo)
        end

        return true
    end

    if IsReplicaCard(propInfo) then
        if not isShowAchieve then
            UIMgr:ActiveUI(UI.CtrlNames.ReplicaCard, { propInfo = propInfo })
        end

        return true
    end

    return false
end

---@param propInfo ItemData
function TryChangeReplicaCardState(propInfo)
    if propInfo == nil then
        return
    end
    if propInfo.UID == 0 then
        return
    end
    if not propInfo.IsUsing then
        local l_hasReplicaCard, replicaCardItems = HasReplicaCard()
        l_hasReplicaCard = true
        if l_hasReplicaCard then
            local l_hasUsingCard, useCardName = IsUsingReplicaCard(replicaCardItems)
            if l_hasUsingCard then
                showHasReplicaCardWarningDialog(useCardName, propInfo.UID)
                return
            end
        end
    end
    reqChangeReplicaCardUsingState(propInfo.UID)
end

function reqChangeReplicaCardUsingState(itemUID)
    local l_msgId = Network.Define.Rpc.ChangeReplicaCardState
    ---@type ActiveItemArg
    local l_sendInfo = GetProtoBufSendTable("ActiveItemArg")
    l_sendInfo.item_uid = itemUID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function RetChangeReplicaCardState(msg)
    ---@type ActiveItemRes
    local l_info = ParseProtoBufToTable("ActiveItemRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(
                Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

---@param roleBattleInfoList RolesBattleInfo
function RetRoleBattleInfo(roleBattleInfoList)
    if not l_waitRolesBattleInfo then
        return
    end
    l_waitRolesBattleInfo = false
    for k, v in pairs(roleBattleInfoList) do
        if v.role_id == MPlayerInfo.UID then
            if not v.isAssist then
                local l_title = Lang("TIP")
                local l_content = Lang("OPEN_REPLICA_CARD_TIPS")
                CommonUI.Dialog.ShowYesNoDlg(true, l_title, l_content, openBagPanel,
                        nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft)
            end
            break
        end
    end
end

function IsCapraCard(itemID)
    initCapraCardInfo()
    return itemID == l_normalCapraCard or itemID == l_capraVIPCard
end

function IsVIPCapraCard(itemID)
    initCapraCardInfo()
    return itemID == l_capraVIPCard
end

---@param propInfo ItemData
function IsReplicaCard(propInfo)
    if not propInfo:ItemMatchesType(GameEnum.EItemType.CountLimit) then
        return false
    end

    local l_itemUseCountItems = TableUtil.GetItemUseCountTable().GetRowByItemID(propInfo.TID)
    if not MLuaCommonHelper.IsNull(l_itemUseCountItems) and GameEnum.EItemUseCountType.ReplicaCard == l_itemUseCountItems.Subclass then
        return true
    end

    return false
end

---@param propInfo ItemData
function ShowCapraCard(propInfo)
    if propInfo == nil then
        return
    end

    ---@type ModuleMgr.OpenSystemMgr
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_openSysID = 0
    if IsVIPCapraCard(propInfo.TID) then
        l_openSysID = l_openSysMgr.eSystemId.VIPCard
    else
        l_openSysID = l_openSysMgr.eSystemId.CapraCard
    end

    if not l_openSysMgr.IsSystemOpen(l_openSysID) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_openSysMgr.GetOpenSystemTipsInfo(l_openSysID))
        return
    end

    UIMgr:ActiveUI(UI.CtrlNames.CapraCard, { itemData = propInfo })
end

---@Description:是否正在使用以太因子增幅卡
---@param itemDatas ItemData[]
function IsUsingReplicaCard(itemDatas)
    if itemDatas == nil then
        return false
    end
    for k, v in pairs(itemDatas) do
        if v.IsUsing then
            return true, v.ItemConfig.ItemName
        end
    end
    return false
end

function HasReplicaCard()
    local l_types = {
        GameEnum.EBagContainerType.Bag
    }
    local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = l_itemFuncUtil.ItemMatchesUseCountType,
                        Param = { GameEnum.EItemUseCountType.ReplicaCard } }
    local conditions = { condition }
    ---@return ItemData[]
    local l_retItemDatas = Data.BagApi:GetItemsByTypesAndConds(l_types, conditions)
    return #l_retItemDatas > 0, l_retItemDatas
end

--endregion

--region inner functions

function initCapraCardInfo()
    if l_normalCapraCard == nil then
        l_normalCapraCard = MGlobalConfig:GetInt("HuiyuankaId")
    end
    if l_capraVIPCard == nil then
        l_capraVIPCard = MGlobalConfig:GetInt("GuibinkaId")
    end
end

function showUseReplicaCardDialog()
    local l_hasReplicaCard, replicaCardItems = HasReplicaCard()
    if not l_hasReplicaCard then
        return
    end
    if IsUsingReplicaCard(replicaCardItems) then
        return
    end
    showDialogWhenReplicaCardCanUse()
end

function showDialogWhenReplicaCardCanUse()
    local l_dayPassCount, l_dayPassLimit = MgrMgr:GetMgr("ThemeDungeonMgr").GetDayPassCountAndLimit()
    local l_weekPassCount, l_weekPassLimit = MgrMgr:GetMgr("ThemeDungeonMgr").GetWeekPassCountAndLimit()
    --无有效次数，则不显示
    if l_dayPassCount >= l_dayPassLimit or l_weekPassCount >= l_weekPassLimit then
        return
    end
    l_waitRolesBattleInfo = true
    --判断是否为助战状态
    MgrMgr:GetMgr("PlayerInfoMgr").ReqGetRolesBattleInfo({ MPlayerInfo.UID })
end

function openBagPanel()
    Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Bag)
end

function showHasReplicaCardWarningDialog(cardName, itemUID)
    local l_title = Lang("TIP")
    local l_content = Lang("HAS_USING_REPLICA_CARD_TIPS", cardName)
    CommonUI.Dialog.ShowYesNoDlg(true, l_title, l_content, function()
        reqChangeReplicaCardUsingState(itemUID)
    end, nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft)
end

--是否需要提示开启Replica卡的地下城
function isNeedOpenReplicaCardDungeon()
    local l_itemUseCountItems = TableUtil.GetItemUseCountTable().GetTable()
    local l_currentDungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    local l_needPromptOpenReplicaCard = false
    if l_itemUseCountItems ~= nil then
        for i, row in ipairs(l_itemUseCountItems) do
            if row.Type == GameEnum.EItemUseCountType.ReplicaCard then
                for i = 0, row.Conditions.Length - 1 do
                    if row.Conditions[i] == l_currentDungeonID then
                        l_needPromptOpenReplicaCard = true
                        break
                    end
                end
                break
            end
        end
    end
    return l_needPromptOpenReplicaCard
end
--endregion

--region 会员卡额外奖励提示
function canShowTipDirect(itemId, itemCount)
    --小恶魔挖宝需等待挖宝结束弹提示
    ---@type ModuleMgr.WabaoAwardMgr
    local l_wabaoMgr = MgrMgr:GetMgr("WabaoAwardMgr")
    if l_wabaoMgr.IsAction() then
        table.insert(l_tipCache, {
            itemId = itemId,
            itemCount = itemCount,
        })
        l_wabaoMgr.EventDispatcher:Add(l_wabaoMgr.ON_SHOW_CACHE_REWARD_TIP_FINISH, function()
            l_wabaoMgr.EventDispatcher:RemoveObjectAllFunc(l_wabaoMgr.ON_SHOW_CACHE_REWARD_TIP_FINISH, self)
            showCapraExtraRewardTips()
        end, self)

        return false
    end
    return true
end

function CacheCapraExtraRewardTips(itemId, itemCount)
    if not canShowTipDirect(itemId, itemCount) then
        return
    end
    table.insert(l_tipCache, {
        itemId = itemId,
        itemCount = itemCount,
    })

    showCapraExtraRewardTips()
end

function showCapraExtraRewardTips()
    local l_cacheTipsNum = #l_tipCache
    if l_cacheTipsNum < 1 then
        return
    end
    local l_opt = {
        itemId = 0,
        itemOpts = { num = 0, icon = { size = 18, width = 1.4 } },
        title = Lang("CAPRA_CARD_REWARD_TIPS"),
        adapter = true,
    }
    for i = 1, l_cacheTipsNum do
        local l_tempTip = l_tipCache[i]
        l_opt.itemId = l_tempTip.itemId
        l_opt.itemOpts.num = l_tempTip.itemCount
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
    end
    l_tipCache = {}
end
--endregion

return ModuleMgr.CapraCardMgr