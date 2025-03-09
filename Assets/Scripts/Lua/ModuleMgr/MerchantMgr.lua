require "Common/TimeMgr"

---@module ModuleMgr.MerchantMgr
module("ModuleMgr.MerchantMgr", package.seeall)

--------------------------------------------事件--Start----------------------------------
EventDispatcher = EventDispatcher.new()

-- 跑商状态更改
MERCHANT_STATE_UPADTE = "MERCHANT_STATE_UPADTE"
-- 跑商玩家选择，通知UI刷新
MERCHANT_GOODS_CHANGED = "MERCHANT_GOODS_CHANGED"
-- 数据更新
MERCHANT_DATA_UPDATE = "MERCHANT_DATA_UPDATE"
-- 当前跑商事件信息更新
MERCHANT_EVENT_UPDATE = "MERCHANT_EVENT_UPDATE"
-- 场景切换
ON_SCENE_ENTER = "ON_SCENE_ENTER"
-- 通知切换到出售页面
CHANGE_TOG_PANEL = "CHANGE_TOG_PANEL"
-- 寻路信息更新
ON_NAVIGATE_UPDATE = "ON_NAVIGATE_UPDATE"

--------------------------------------------事件--End----------------------------------

local l_businessInterruptSessionTimer           -- 用于延迟销毁寻路信息，防止被打断后不能恢复
local l_data                                    -- 数据引用

--------------------------------------------生命周期接口--Start----------------------------------

function OnInit()
    l_data = DataMgr:GetData("MerchantData")
end

-- 登出
function OnLogout()
    Reset()
end

-- 卸载
function OnUnInit()
    Reset()
end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    OnSelectRoleNtf(l_roleAllInfo)
end

-- 切换场景(处理UI显示问题)
function OnEnterScene(sceneId)
    if not StageMgr:CurStage():IsConcreteStage() then
        return
    end

    if l_data.CurMerchantState ~= l_data.EMerchantState.None then
        notifyMerchantStateUpdate()
    end

    EventDispatcher:Dispatch(ON_SCENE_ENTER)
end


--------------------------------------------生命周期接口--End----------------------------------

--------------------------------------------协议--Start----------------------------------
-- 登入
function OnSelectRoleNtf(info)
    local l_isRunning = l_data.OnSelectRoleNtf(info)

    if l_isRunning then
        notifyMerchantStateUpdate()
    end
end

-- 更新跑商状态信息
function OnMerchantUpdateNotify(msg)
    ---@type MerchantUpdateNotifyInfo
    local l_info = ParseProtoBufToTable("MerchantUpdateNotifyInfo", msg)

    l_data.CurMerchantState = l_info.state
    l_data.MerchantStartTime = l_info.start_time
    log("OnMerchantUpdateNotify", l_info.state, l_info.start_time, l_info.money_count)
    if l_data.CurMerchantState == l_data.EMerchantState.Running then
        l_data.CurMerchantState = l_data.EMerchantState.Running
        showMarkUI(l_data.EMerchantState.Running)
    else
        l_data.CurMerchantState = l_data.EMerchantState.None
        if l_info.state == l_data.EMerchantState.Success then
            showMarkUI(l_data.EMerchantState.Success)
            showResultUI(l_data.EMerchantState.Success, l_info.start_time, l_info.money_count)
        elseif l_info.state == l_data.EMerchantState.Failure then
            showMarkUI(l_data.EMerchantState.Failure)
            showResultUI(l_data.EMerchantState.Failure, l_info.start_time, l_info.money_count)
        end

        closeMapUI()
    end

    notifyMerchantStateUpdate()
end

-- 根据npc请求商店信息
function RequestMerchantGetShopInfo(npcUid, npcId)
    npcUid = npcUid or l_data.MerchantNpcUid
    npcId = npcId or l_data.MerchantNpcId
    if not npcUid or not npcId then
        return
    end

    local l_msgId = Network.Define.Rpc.MerchantGetShopInfo
    ---@type MerchantGetShopInfoArg
    local l_sendInfo = GetProtoBufSendTable("MerchantGetShopInfoArg")
    l_sendInfo.npc_uuid = tostring(npcUid)
    l_sendInfo.npc_id = npcId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 收到商人商店消息
function OnMerchantGetShopInfo(msg, sendArg)
    ---@type MerchantGetShopInfoRes
    local l_info = ParseProtoBufToTable("MerchantGetShopInfoRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    l_data.OnMerchantGetShopInfo(l_info, sendArg)
    openShopUI()
end

-- 请求购买
function RequestMerchantShopBuy(itemId, itemCount)
    -- 查询商品价格
    local l_price
    local l_remainingCount
    if not l_data.MerchantShopDatas or not l_data.MerchantShopDatas.buy_items then
        logError("MerchantMgr RequestMerchantShopBuy fail, not init yet")
        return
    end

    for i, v in ipairs(l_data.MerchantShopDatas.buy_items) do
        if v.item_id == itemId then
            l_price = v.price
            l_remainingCount = v.item_count
            break
        end
    end

    if not l_price then
        logError("MerchantMgr RequestMerchantShopBuy error, 找不到npc售卖的道具信息")
        return
    end

    if itemCount > l_remainingCount then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GOODS_NOT_ENOUGH"))
        return
    end

    local l_propNum = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.MerchantCoin)
    if l_propNum < itemCount * l_price then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_COIN_NOT_ENOUGH"))
        return
    end

    local l_msgId = Network.Define.Rpc.MerchantShopBuy
    ---@type MerchantShopBuyArg
    local l_sendInfo = GetProtoBufSendTable("MerchantShopBuyArg")
    l_sendInfo.npc_uuid = tostring(l_data.MerchantNpcUid)
    l_sendInfo.npc_id = l_data.MerchantNpcId
    l_sendInfo.item.item_id = itemId
    l_sendInfo.item.item_count = itemCount
    l_sendInfo.item.price = l_price
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 购买响应
function OnMerchantShopBuy(msg, sendArg)
    ---@type MerchantShopBuyRes
    local l_info = ParseProtoBufToTable("MerchantShopBuyRes", msg)
    if l_info.error_info ~= nil and l_info.error_info.errorno > 0 then
        if l_info.error_info.errorno == ErrorCode.BAG_EXTRA_SPACE_NEED then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BagExtraSpaceNeed", l_info.error_info.param[1].value))
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_info.errorno))
        return
    end

    -- 本地做商店数据更新
    l_data.OnMerchantShopBuy(sendArg.item.item_id, sendArg.item.item_count)

    notifyMerchantStateUpdate()

    EventDispatcher:Dispatch(MERCHANT_DATA_UPDATE)
end

-- 请求售卖道具
function RequestMerchantShopSell()
    if not l_data.MerchantShopDatas or not l_data.MerchantPreSellProps then
        logError("MerchantMgr RequestMerchantShopSell fail, not init yet")
        return
    end

    if #l_data.MerchantPreSellProps <= 0 then
        log("MerchantMgr RequestMerchantShopSell fail, 没有选择售卖的道具")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Shop_SellEmpty"))
        return
    end

    local l_msgId = Network.Define.Rpc.MerchantShopSell
    ---@type MerchantShopSellArg
    local l_sendInfo = GetProtoBufSendTable("MerchantShopSellArg")
    l_sendInfo.npc_uuid = tostring(l_data.MerchantNpcUid)
    l_sendInfo.npc_id = l_data.MerchantNpcId
    for i, v in ipairs(l_data.MerchantPreSellProps) do
        local l_item = l_sendInfo.items:add()
        l_item.item_uuid = v.item_uuid
        l_item.item_id = v.item_id
        l_item.item_count = tonumber(v.item_count)
        l_item.price = v.price
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 出售响应
function OnMerchantShopSell(msg)
    ---@type MerchantShopSellRes
    local l_info = ParseProtoBufToTable("MerchantShopSellRes", msg)
    if l_info.error_code ~= 0 then
        -- logError("l_info.error_code", l_info.error_code)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    EventDispatcher:Dispatch(MERCHANT_DATA_UPDATE)
end


-- 提交任务
function RequestMerchantSubmit()
    local function _secondCheckStepFunc()
        local l_curCoinCount = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.MerchantCoin)
        local l_needCoinCount = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("FinishBoliCoin").Value)
        if l_curCoinCount < l_needCoinCount then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_NOT_FINISH_NOTIFY"))
            return
        end

        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SUBMIT_MERCHANT_CONFIRM"), function()
            RequestMerchantTaskComplete()
        end)
    end

    if #l_data.MerchantBagProps > 0 then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MERCHANT_SUBMIT_CONFIRM"), function()
            _secondCheckStepFunc()
        end)
        return
    end

    _secondCheckStepFunc()
end

-- 请求当前拥有的事件
function RequestGetEvent(cb, notNotify)

    local l_msgId = Network.Define.Rpc.MerchantGetEventInfo
    ---@type MerchantGetEventInfoArg
    local l_sendInfo = GetProtoBufSendTable("MerchantGetEventInfoArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo, { callback = cb, notNotify = notNotify })
end

-- 事件消息响应
function OnGetEvent(msg, _, params)
    ---@type MerchantGetEventInfoRes
    local l_info = ParseProtoBufToTable("MerchantGetEventInfoRes", msg)
    -- log("OnGetEvent", ToString(l_info))
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    l_data.OnGetEvent(l_info)
    if params and params.notNotify then
        -- do nothing
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GET_EVENT"))
    end

    EventDispatcher:Dispatch(MERCHANT_EVENT_UPDATE, l_info)
    if params and params.callback then
        params.callback(l_data.MerchantEventDatas)
    end
end

-- 查询事件信息
function RequestMerchantEventPreBuy()
    local l_npcUid, l_npcId = GetSelectNpcInfo()
    if not l_npcUid or not l_npcId then
        return
    end

    local l_msgId = Network.Define.Rpc.MerchantEventPreBuy
    ---@type MerchantEventPreBuyArg
    local l_sendInfo = GetProtoBufSendTable("MerchantEventPreBuyArg")
    l_sendInfo.npc_uuid = tostring(l_npcUid)
    l_sendInfo.npc_id = l_npcId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 响应查询
function OnMerchantEventPreBuy(msg)
    ---@type MerchantEventPreBuyRes
    local l_info = ParseProtoBufToTable("MerchantEventPreBuyRes", msg)
    if l_info.error_code ~= 0 then
        -- logError("l_info.error_code", l_info.error_code)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MERCHANT_EVENT_BUY_FORMAT", l_info.price), function()
        RequestMerchantEventBuy(l_info.price)
    end)
end

-- 请求购买事件
function RequestMerchantEventBuy(price)

    local l_npcUid, l_npcId = GetSelectNpcInfo()
    if not l_npcUid or not l_npcId then
        return
    end

    local l_msgId = Network.Define.Rpc.MerchantEventBuy
    ---@type MerchantEventBuyArg
    local l_sendInfo = GetProtoBufSendTable("MerchantEventBuyArg")
    l_sendInfo.npc_uuid = tostring(l_npcUid)
    l_sendInfo.npc_id = l_npcId
    l_sendInfo.price = price

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 响应购买事件
function OnMerchantEventBuy(msg)
    ---@type MerchantEventBuyRes
    local l_info = ParseProtoBufToTable("MerchantEventBuyRes", msg)
    if l_info.error_code ~= 0 then
        -- logError("l_info.error_code", l_info.error_code)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    RequestGetEvent(function(events)
        if not events or #events <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GET_EVENT_NONE"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_GET_EVENT_SUCCESS"))
        end
    end)
end

-- 功能响应事件
function OpenMerchantShopEvent()
    local l_npcUid, l_npcId = GetSelectNpcInfo()
    if not l_npcUid or not l_npcId then
        return
    end

    RequestMerchantGetShopInfo(l_npcUid, l_npcId)
end


-- 请求提交任务
function RequestMerchantTaskComplete()
    local l_msgId = Network.Define.Rpc.MerchantTaskComplete
    Network.Handler.SendRpc(l_msgId)
end

function OnMerchantTaskComplete(msg)
    ---@type MerchantTaskCompleteRes
    local l_info = ParseProtoBufToTable("MerchantTaskCompleteRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
end


-- 寻路信息回调
function OnNavigateUpdate(info)

    if info.result == nil or info.result == 0 then
        EventDispatcher:Dispatch(ON_NAVIGATE_UPDATE, info.paths)
    end
end

--------------------------------------------协议--End----------------------------------

--------------------------------------------操作相关--Start----------------------------------

-- 一键添加相同id的道具到出售页面
function SellAllGoodsById(propId)
    local l_ret = {}
    local l_propId = propId
    for i, v in ipairs(l_data.MerchantBagProps) do
        if v.TID == l_propId then
            table.insert(l_ret, { v.UID, v.ItemCount })
        end
    end

    for i, v in ipairs(l_ret) do
        AddMerchantSellItem(v[1], v[2])
    end
end

-- 主动触发切换到出售界面
function ChangeToSellPanel(add)
    g_tmpShowIndex = add.showIndex
    l_data.MerchantShopType = l_data.EMerchantShopType.Sell
    EventDispatcher:Dispatch(CHANGE_TOG_PANEL, true)
end

-- 提示不可传送
function NotifyCannotTeleport()
    if l_data.CurMerchantState == l_data.EMerchantState.Running then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_CANNOT_TELEPORT"))
    end
end

-- 初始化所有数据
function Reset()
    l_data.Reset()
    CloseBusinessInterruptSessionTimer()
end

-- 更新session
function UpdateBusinessInterruptSession()
    CloseBusinessInterruptSessionTimer()
    l_businessInterruptSessionTimer = Timer.New(function()
        l_data.MerchantTargetScene = nil
        l_data.MerchantTargetNpcId = nil
    end, l_data.MerchantBusinessInterruptSessionTime)
    l_businessInterruptSessionTimer:Start()
end

-- 关闭session timer
function CloseBusinessInterruptSessionTimer()
    if l_businessInterruptSessionTimer then
        l_businessInterruptSessionTimer:Stop()
        l_businessInterruptSessionTimer = nil
    end
end

---@return ItemData
function _getMerchantItemByUid(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Merchant }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

-- 添加待出售道具
function AddMerchantSellItem(uid, count)

    -- 必须有本地数据
    if not l_data.MerchantBagProps or not l_data.MerchantShopDatas then
        logError("AddMerchantSellItem fail, not init yet")
        return
    end

    -- 背包要有此道具
    local l_propInfo = _getMerchantItemByUid(uid)
    if not l_propInfo then
        logError("AddMerchantSellItem fail, 找不到道具", uid)
        return
    end

    local l_compareUid = uid
    -- 查询在不在虚拟背包列表中
    ---@type ItemData
    local l_bagRet
    ---@type number
    local l_bagRetIndex
    for i, v in ipairs(l_data.MerchantBagProps) do
        if v.UID:equals(l_compareUid) then
            l_bagRet = v
            l_bagRetIndex = i
            break
        end
    end

    if not l_bagRet then
        logError("AddMerchantSellItem fail, 背包找不到道具")
        return
    end

    -- 获取此道具出售价格
    local l_sellRet = l_data.GetShopItemSellPrice(l_propInfo.TID)
    if not l_sellRet then
        logError("AddMerchantSellItem fail, 商店此道具无价格", l_data.MerchantNpcUid, l_data.MerchantNpcId, l_propInfo.TID)
        return
    end

    -- 查询是否已经在待出售列表中
    local l_preSellRet
    for i, v in ipairs(l_data.MerchantPreSellProps) do
        if v.item_uuid:equals(l_compareUid) then
            l_preSellRet = v
            break
        end
    end

    if not l_preSellRet then
        l_preSellRet = {
            item_uuid = l_propInfo.UID,
            item_id = l_propInfo.TID,
            item_count = 0,
            price = l_sellRet,
        }
        table.insert(l_data.MerchantPreSellProps, l_preSellRet)
    end

    local l_hasCount = l_bagRet.ItemCount
    local l_sellCount = l_preSellRet.item_count

    -- 数量修正
    if l_hasCount < count then
        logWarn("AddMerchantSellItem count max than have")
        count = (l_hasCount - l_sellCount)
    end

    l_preSellRet.item_count = l_preSellRet.item_count + count
    l_bagRet.ItemCount = l_bagRet.ItemCount - count
    -- 列表修正
    if l_bagRet.ItemCount <= 0 then
        table.remove(l_data.MerchantBagProps, l_bagRetIndex)
    end

    EventDispatcher:Dispatch(MERCHANT_GOODS_CHANGED)
end

-- 功能响应事件
function OpenMerchantShopMap()
    if MgrMgr:GetMgr("TaskMgr").CheckTaskCanFinish(l_data.MerchantTaskID) then
        GotoMerchantTaskNpc()
    else
        showTransferUI()
    end
end

function GotoMerchantTaskNpc()
    local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(l_data.MerchantTaskID)
    local l_sceneId, l_npcId = l_taskInfo.finishNpcMapId, l_taskInfo.finishNpcId
    local l_actionMgr = MgrMgr:GetMgr("ActionTargetMgr")

    l_actionMgr.ResetActionQueue()
    l_actionMgr.MoveToTalkWithNpc(l_sceneId, l_npcId)
end

--------------------------------------------操作相关--End----------------------------------


--------------------------------------------UI相关--Start----------------------------------

-- 通知跑商状态更新
function notifyMerchantStateUpdate()
    if l_data.CurMerchantState ~= l_data.EMerchantState.None then
        if not UIMgr:IsActiveUI(UI.CtrlNames.RunningBusinessIcon) then
            UIMgr:ActiveUI(UI.CtrlNames.RunningBusinessIcon)
        end
    end

    EventDispatcher:Dispatch(MERCHANT_STATE_UPADTE)
end

-- 打开商店主界面
function openShopUI()

    -- 如果此时未打开
    local l_ctrlName = UI.CtrlNames.RunningBusiness
    if not UIMgr:IsActiveUI(l_ctrlName) then
        l_data.MerchantShowBagType = l_data.EMerchantBagType.Shop
        l_data.MerchantShopType = l_data.EMerchantShopType.Buy
        UIMgr:ActiveUI(l_ctrlName)
    else
        EventDispatcher:Dispatch(MERCHANT_DATA_UPDATE)
    end
end
-- 打开提示界面
function showMarkUI(state)
    local l_ctrlName = UI.CtrlNames.RunningBusinessMark
    if UIMgr:IsActiveUI(l_ctrlName) then
        UIMgr:DeActiveUI(l_ctrlName)
    end

    UIMgr:ActiveUI(l_ctrlName, state)
end

-- 打开结算界面
function showResultUI(state, startTime, moneyCount)

    local l_ctrlName = UI.CtrlNames.RunningBusinessSettlement
    if UIMgr:IsActiveUI(l_ctrlName) then
        UIMgr:DeActiveUI(l_ctrlName)
    end

    if UIMgr:IsActiveUI(UI.CtrlNames.RunningBusiness) then
        UIMgr:DeActiveUI(UI.CtrlNames.RunningBusiness)
        -- 同时也关闭tips
        if UIMgr:IsActiveUI(UI.CtrlNames.CommonItemTips) then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        end
    end

    UIMgr:ActiveUI(UI.CtrlNames.RunningBusinessSettlement,
            {
                state = state,
                startTime = startTime,
                moneyCount = moneyCount,
            })
end

function closeMapUI()
    UIMgr:DeActiveUI(UI.CtrlNames.TransferController)
end

-- 打开地图界面
function showTransferUI()
    CloseBusinessInterruptSessionTimer()
    UIMgr:ActiveUI(UI.CtrlNames.TransferController, {
        showMerchant = true
    })
end

--------------------------------------------UI相关--End----------------------------------

--返回玩家是否处于跑商状态
function IsInMerchant()
    return l_data.IsInMerchant()
end

-- 获取当前选中npc的guid,npcid
function GetSelectNpcInfo()
    require "Command/CommandMacro"
    local l_npcId = CommandMacro.NPCId()
    if not l_npcId then
        return
    end

    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_npcId)
    if not l_npcEntity then
        logError("MerchantMgr OpenMerchantShopEvent fail, 找不到npc", l_npcId)
        return
    end

    return l_npcEntity.UID, l_npcId
end

return ModuleMgr.MerchantMgr