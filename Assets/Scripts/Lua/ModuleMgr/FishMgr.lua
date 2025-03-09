---
--- Created by cmd(TonyChen).
--- DateTime: 2018/7/27 19:42
---
---@module ModuleMgr.FishMgr
module("ModuleMgr.FishMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--更新鱼饵数量的事件
ON_UPDATE_BAIT_NUM = "ON_UPDATE_BAIT_NUM"
--刷新钓鱼用品界面事件
ON_REFRESH_FISH_PROP_PANEL = "ON_REFRESH_FISH_PROP_PANEL"
--钓鱼拉杆提示展示事件
ON_SHOW_PULL_ROD_TIP = "ON_SHOW_PULL_ROD_TIP"
--钓鱼拉杆提示关闭事件
ON_CLOSE_PULL_ROD_TIP = "ON_CLOSE_PULL_ROD_TIP"
--自动钓鱼开始事件
ON_START_AUTO_FISHING = "ON_START_AUTO_FISHING"
--自动钓鱼结束事件
ON_END_AUTO_FISHING = "ON_END_AUTO_FISHING"
--获取自动钓鱼相关信息事件
ON_GET_AUTO_FISHING_INFO = "ON_GET_AUTO_FISHING_INFO"
------------- END 事件相关  -----------------

--生活技能数据获取
local l_lifeData = DataMgr:GetData("LifeProfessionData")

--鱼竿和遮阳棚的数据内容为
--{
--  atlas  所在图集
--  propId  物品表ID
--  propNum  数量
--  quality  品质
--  sortId  排序编号
--  sprite  精灵名
--  type 类型
--  uid  UID
--  isUse   是否正在使用
--}
---@type FishItemData[]
g_rodDatas = {}  --鱼竿的全数据
---@type FishItemData[]
g_seatDatas = {}  --遮阳棚的全数据

g_isBaitOverTiped = false  --是否已经提示过鱼饵用尽
g_isAutoContuine = false  --自动钓鱼是否自动续时间
---@type ItemIdCountPair
local l_awardInfo = nil --钓鱼钓到的奖励
local l_fishInfo = nil  --钓起的鱼

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

--登出时初始化公会相关信息
function OnLogout()
    InitLifeEquipDatas()
    g_isBaitOverTiped = false
    l_awardInfo = nil
    l_fishInfo = nil
end

--钓鱼用具缓存初始化
function InitLifeEquipDatas()
    g_rodDatas = {}
    g_seatDatas = {}
end

-----------------------------内部工具方法---------------------------------------
---@return ItemData
function _serializeItemData(tid)
    local item = Data.BagModel:CreateItemWithTid(tid)
    ---@class FishItemData
    local ret = {
        itemData = item,
        isUse = false,
    }

    return ret
end

--确认道具使用中
--useId  使用中的Id
--dataList  物品数据列表
---@param dataList FishItemData[]
function CheckPropIsUsing(useId, dataList)
    for i = 1, #dataList do
        if dataList[i].itemData.TID == useId then
            dataList[i].isUse = true
        else
            dataList[i].isUse = false
        end
    end
end
-----------------------------END 内部工具方法--------------------------------------------

------------------------CS调用的事件方法------------------------------------
--接收CS传来的进入钓鱼的事件
function OnEnterFishing(...)
    g_isBaitOverTiped = false  --每一次进入钓鱼都会提示一次
    local l_openUIData = {
        type = l_lifeData.EUIOpenType.FishMain
    }
    UIMgr:ActiveUI(UI.CtrlNames.FishMain, l_openUIData)
    RefreshMainUI()
    --弹出进入钓鱼提示
    local l_fishTipCountStr = UserDataManager.GetStringDataOrDef("FISH_TIP_COUNT", MPlayerSetting.GLOBAL_SETING_GROUP, "0")
    local l_fishTipCount = tonumber(l_fishTipCountStr)
    if l_fishTipCount < 3 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ENTER_FISH_TIP"))
        UserDataManager.SetDataFromLua("FISH_TIP_COUNT", MPlayerSetting.GLOBAL_SETING_GROUP, tostring(l_fishTipCount + 1))
    end

    MInput:Reset(true)
    --MUIManager:HideUI(MUIManager.MOVE_CONTROLLER)
    MgrMgr:GetMgr("MoveControllerMgr").HideMoveController()
end

--接收CS传来的退出钓鱼的事件
function OnExitFishing(...)

    if game:IsLogout() then
        return
    end

    UIMgr:DeActiveUI(UI.CtrlNames.FishMain)
    UIMgr:DeActiveUI(UI.CtrlNames.FishProp)
    UIMgr:DeActiveUI(UI.CtrlNames.FishAutoSetting)

    --自动钓鱼结果结算界面设置不关闭
    local l_curStage = StageMgr:CurStage()
    l_curStage:AddKeepActiveUI(UI.CtrlNames.LifeProfessionReward)
    --技能面板还原 及 自动战斗按钮还原
    RefreshMainUI()
    --强制切换回技能界面
    MgrMgr:GetMgr("MainUIMgr").ShowSkill(true)
    --主界面内容还原
    game:ShowMainPanel()
    --弓箭手的箭矢还原
    local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
    if ui then
        ui:FadeAction(false, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    elseif ui then
        MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
    end

    --自动钓鱼结果结算界面移出不关闭列表
    l_curStage:RemoveKeepActiveUI(UI.CtrlNames.LifeProfessionReward)

    if UIMgr:IsActiveUI(UI.CtrlNames.MoveControllerContainer) then
        MgrMgr:GetMgr("MoveControllerMgr").ShowMoveController()
    else
        MgrMgr:GetMgr("MoveControllerMgr").ActiveMoveController()
    end

end

--接收CS传来的钓鱼拉杆提示展示事件
function OnShowPullRodTip(luaType, pos, lastTimeValue)
    EventDispatcher:Dispatch(ON_SHOW_PULL_ROD_TIP, pos, lastTimeValue)
end

--接收CS传来的钓鱼拉杆提示关闭事件
function OnClosePullRodTip(...)
    EventDispatcher:Dispatch(ON_CLOSE_PULL_ROD_TIP)
end

--接收CS传来的展示钓鱼结果事件
function OnShowFishEvent(...)
    if l_awardInfo then
        if MLuaCommonHelper.Long(l_awardInfo.count) > MLuaCommonHelper.Long(0) then
            local l_opt = {
                itemId = l_awardInfo.id,
                itemOpts = { num = l_awardInfo.count, icon = { size = 18, width = 1.4 } },
            }

            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)  --获取提示
        end

        --判断是否是自动钓鱼 自动钓鱼时不显示其他内容
        if MEntityMgr.PlayerEntity and (not MEntityMgr.PlayerEntity.IsAutoFishing) then
            if l_fishInfo then
                --是鱼则展示鱼的结果界面
                local l_openUIData = {
                    type = l_lifeData.EUIOpenType.FishResult,
                    itemId = l_fishInfo.item_id,
                    size = l_fishInfo.fish_size,
                }
                UIMgr:ActiveUI(UI.CtrlNames.FishResult, l_openUIData)
                l_fishInfo = nil
            end
        end

        l_awardInfo = nil
    end
end

--自动钓鱼自然结束事件
function OnEndAutoFishing()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUTO_FISHING_END"))
    EventDispatcher:Dispatch(ON_END_AUTO_FISHING)
end

--钓鱼抛竿
function OnThrowFishing()
    --播放抛竿音效
    MAudioMgr:Play("event:/UI/Skills/Fishing_Throw")
end

--钓鱼成功起杆
function OnSucceedUpFishing()
    --播放起杆的声音
    MAudioMgr:Play("event:/UI/Skills/Fishing_Pull")
end

-- C#和lua调用，隐藏或展示自动战斗和技能面板
function RefreshMainUI()
    -- 自动战斗按钮
    local main_ui = UIMgr:GetUI(UI.CtrlNames.Main)
    if main_ui ~= nil then
        main_ui:CheckSpecialState()
    end

    -- 技能面板
    --MUIManager:RefreshSkillUI()
    MgrMgr:GetMgr("SkillControllerMgr").RefreshSkillUI()
end
---------------------------END CS调用的事件方法--------------------------------


-------------------------------其他协议接收后的分支方法-----------------------------------------------
--登录时获取钓鱼用具信息
--协议为SelectRoleNtf
--分支于MgrMgr:GetMgr("SelectRoleMgr").OnSelectRoleNtf
---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    --信息赋值
    local l_lifeEquipInfos = info.lifeequip
    local l_curUse = l_lifeEquipInfos.equip
    local l_all = l_lifeEquipInfos.got_equip

    --缓存初始化
    InitLifeEquipDatas()

    --钓鱼相关的装备全数据获取
    for i = 1, #l_all do
        local type = l_all[i].type
        local ids = l_all[i].equip_ids
        for j = 1, #ids do
            local itemData = _serializeItemData(ids[j].value)
            if LifeEquipType.LIFE_EQUIP_TYPE_FOD == type then
                table.insert(g_rodDatas, itemData)
            elseif LifeEquipType.LIFE_EQUIP_TYPE_SEAT == type then
                table.insert(g_seatDatas, itemData)
            end
        end
    end

    --当前使用的装备加标记
    for i = 1, #l_curUse do
        if l_curUse[i].type == LifeEquipType.LIFE_EQUIP_TYPE_FOD then
            --鱼竿数据
            CheckPropIsUsing(l_curUse[i].equip_id, g_rodDatas)
        elseif l_curUse[i].type == LifeEquipType.LIFE_EQUIP_TYPE_SEAT then
            --遮阳棚数据
            CheckPropIsUsing(l_curUse[i].equip_id, g_seatDatas)
        end
    end
end

--接收奖励结果 判断展示结果的界面类型
--协议为ItemAwardNtf
--分支于MgrMgr:GetMgr("NoticeMgr").OnItemAwardNtf
function ShowFishAward(info)
    if #info.awards ~= 0 then
        --有内容则记录鱼的信息
        l_fishInfo = info.awards[1].items[1]
    end
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[FishMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdateInfo = itemUpdateDataList[i]
        local singleCompareInfo = singleUpdateInfo:GetItemCompareData()
        local fishConfig = TableUtil.GetFishTable().GetRowByID(singleCompareInfo.id, true)
        if ItemChangeReason.ITEM_REASON_COLLECT_FISHING == singleUpdateInfo.Reason
                and nil ~= fishConfig
                and not singleUpdateInfo:GetNewOrOldItem():IsVirtualItem()
        then
            l_awardInfo = singleCompareInfo
        end
    end
end
------------------END 其他协议接收后的分支方法-----------------------------------------

--------------------------以下是服务器交互PRC------------------------------------------
--请求钓鱼（LUA这边只处理自动钓鱼的请求）
function ReqFish(fishType, costNum, isAutoContuine)
    local l_msgId = Network.Define.Rpc.LifeSkillFishing
    ---@type LifeSkillFishingArg
    local l_sendInfo = GetProtoBufSendTable("LifeSkillFishingArg")
    l_sendInfo.option = fishType
    l_sendInfo.auto_fish_item.item_id = MGlobalConfig:GetInt("AutoFishingItemID")
    l_sendInfo.auto_fish_item.item_count = costNum
    l_sendInfo.is_auto_use_item = isAutoContuine
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收请求钓鱼结果（LUA这边只处理钓鱼次数过多 和 自动钓鱼）
function OnReqFish(msg, arg)
    ---@type LifeSkillFishingRes
    local l_info = ParseProtoBufToTable("LifeSkillFishingRes", msg)

    if l_info.result ~= 0 and l_info.result == ErrorCode.ERR_LIFE_SKILL_NO_LEFT_TIME then
        CommonUI.Dialog.ShowOKDlg(true, nil, Lang("FISH_TOO_MUCH"), function()
            MEventMgr:LuaFireEvent(MEventType.MEvent_StopFish, MEntityMgr.PlayerEntity)
        end)
    end

    if l_info.result == 0 and arg then
        if arg.option == FishingType.FISHING_TYPE_AUTO_FISH then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUTO_FISHING_START"))
            EventDispatcher:Dispatch(ON_START_AUTO_FISHING)
        end
    end
end

--请求使用钓鱼相关物品
function ReqUseFishItem(type, id)
    local l_msgId = Network.Define.Rpc.LifeEquipChange
    ---@type LifeEquipChangeArg
    local l_sendInfo = GetProtoBufSendTable("LifeEquipChangeArg")

    local oneItem = l_sendInfo.equip:add()
    oneItem.type = type
    oneItem.equip_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收使用钓鱼相关物品结果
function OnReqUseFishItem(msg, arg)
    ---@type LifeEquipChangeRes
    local l_info = ParseProtoBufToTable("LifeEquipChangeRes", msg)
    if l_info.result == 0 then
        --在OnLifeEquipNtf中已经有刷新数据了 这里不再刷新
        EventDispatcher:Dispatch(ON_REFRESH_FISH_PROP_PANEL)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--请求获取自动钓鱼的相关信息
function ReqGetAutoFishInfo()
    local l_msgId = Network.Define.Rpc.AutoFishPush
    ---@type AutoFishPushArg
    local l_sendInfo = GetProtoBufSendTable("AutoFishPushArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收请求获取自动钓鱼的相关信息结果
function OnReqGetAutoFishInfo(msg)
    ---@type AutoFishPushRes
    local l_info = ParseProtoBufToTable("AutoFishPushRes", msg)
    g_isAutoContuine = l_info.is_continue == 1  --是否自动续时间
    EventDispatcher:Dispatch(ON_GET_AUTO_FISHING_INFO, l_info.left_time, g_isAutoContuine)
end

------------------------------PRC  END------------------------------------------

---------------------------以下是服务器推送 PTC------------------------------------
--接收钓鱼工具的推送
function OnLifeEquipNtf(msg)
    ---@type LifeEquipData
    local l_info = ParseProtoBufToTable("LifeEquipData", msg)

    --信息赋值
    local l_curUse = l_info.equip
    local l_all = l_info.got_equip

    --钓鱼相关的装备全数据获取
    for i = 1, #l_all do
        if l_all[i].type == LifeEquipType.LIFE_EQUIP_TYPE_FOD then
            --鱼竿数据
            local l_rodIds = l_all[i].equip_ids
            for j = 1, #l_rodIds do
                --判断原本是否存在
                local l_rodInfo = nil
                for i = 1, #g_rodDatas do
                    local itemData = g_rodDatas[i].itemData
                    if itemData.TID == l_rodIds[j].value then
                        l_rodInfo = itemData
                        break
                    end
                end

                --若不存在则新增
                if l_rodInfo == nil then
                    local l_itemData = _serializeItemData(l_rodIds[j].value)
                    table.insert(g_rodDatas, l_itemData)
                end
            end
        elseif l_all[i].type == LifeEquipType.LIFE_EQUIP_TYPE_SEAT then

            --遮阳棚数据
            local l_seatIds = l_all[i].equip_ids
            for j = 1, #l_seatIds do

                --判断原本是否存在
                local l_seatInfo = nil
                for i = 1, #g_seatDatas do
                    local seatItemData = g_seatDatas[i].itemData
                    if seatItemData.TID == l_seatIds[j].value then
                        l_seatInfo = seatItemData
                        break
                    end
                end

                --若不存在则新增
                if l_seatInfo == nil then
                    local l_itemData = _serializeItemData(l_seatIds[j].value)
                    table.insert(g_seatDatas, l_itemData)
                end
            end
        end
    end

    --更新当前使用的装备加标记
    for i = 1, #l_curUse do
        if l_curUse[i].type == LifeEquipType.LIFE_EQUIP_TYPE_FOD then
            --鱼竿数据
            CheckPropIsUsing(l_curUse[i].equip_id, g_rodDatas)
        elseif l_curUse[i].type == LifeEquipType.LIFE_EQUIP_TYPE_SEAT then
            --遮阳棚数据
            CheckPropIsUsing(l_curUse[i].equip_id, g_seatDatas)
        end
    end
end

--接收本次自动钓鱼的全部收获
function OnAutoFishResultNtf(msg)
    ---@type AutoFishResultData
    local l_info = ParseProtoBufToTable("AutoFishResultData", msg)

    local l_openUIData = {
        type = l_lifeData.EUIOpenType.LifeProfessionReward_Fish,
        classID = MgrMgr:GetMgr("LifeProfessionMgr").ClassID.Fish,
        info = l_info.info,
    }
    UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionReward, l_openUIData)
end
------------------------------PTC  END------------------------------------------

return ModuleMgr.FishMgr
