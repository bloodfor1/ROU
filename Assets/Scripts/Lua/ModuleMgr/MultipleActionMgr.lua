---@module ModuleMgr.MultipleActionMgr
module("ModuleMgr.MultipleActionMgr", package.seeall)


EventDispatcher = EventDispatcher.new()

ON_MULTIPLE_ACTION_EVENT = "ON_MULTIPLE_ACTION_EVENT"
ON_REQUEST_MULTIPLE_ACTION_PUSH_EVENT = "ON_REQUEST_MULTIPLE_ACTION_PUSH_EVENT"
ON_MULTIPLE_ACTION_SUCCESS_EVENT = "ON_MULTIPLE_ACTION_SUCCESS_EVENT"
ON_MULTIPLE_ACTION_REFUSED_EVENT = "ON_MULTIPLE_ACTION_REFUSED_EVENT"
ON_MULTIPLE_ACTION_REVOKED_EVENT = "ON_MULTIPLE_ACTION_REVOKED_EVENT"

local string_format = StringEx.Format

local l_wait_time = 10

local l_fragmentActionDistance
local l_permanentActionDistance

TargetInfo = nil

local l_last_request_time = -l_wait_time

-- 请求双人动作
function RequestMultipleAction(target_id, action_id, target_info)

    log("RequestMultipleAction", target_id, action_id)

    local l_remaining_time = (l_last_request_time + l_wait_time) - Time.realtimeSinceStartup
    if l_remaining_time > 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_CD", math.ceil(l_remaining_time)))
        return
    end

    CloseOffer()

    local l_msgId = Network.Define.Rpc.DoubleActiveApply
    ---@type DoubleActiveApplyArg
    local l_sendInfo = GetProtoBufSendTable("DoubleActiveApplyArg")
    l_sendInfo.friend_role_id = tostring(target_id)
    l_sendInfo.active_type = action_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo, target_info)
end

-- 请求双人动作的回包
function OnMultipleAction(msg, arg, target_info)
    ---@type DoubleActiveApplyRes
    local l_info = ParseProtoBufToTable("DoubleActiveApplyRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_last_request_time = Time.realtimeSinceStartup

    local l_config = {
        content = Lang("MULTIPLE_ACTION_WAIT"),
        action_id = arg.active_type,
        totalTime = l_wait_time,
        finishTime = Time.realtimeSinceStartup + l_wait_time,
        target_id = arg.friend_role_id,
        confirm_text = Lang("MULTIPLE_ACTION_CANEL"),
        confirm_callback = function()
            RequestMultipleActionRevoke(arg.friend_role_id, arg.active_type)
            CloseOffer()
        end,
        cancel_callback = function(not_close)
            RequestMultipleActionRevoke(arg.friend_role_id, arg.active_type)
            if not not_close then
                CloseOffer()
            end
        end
    }

    UpdateOfferUI(l_config, ON_MULTIPLE_ACTION_EVENT)
end

-- 收到别人的请求
function OnRequestMultipleActionPush(msg)

    log("OnRequestMultipleActionPush")
    ---@type DoubleActiveData
    local l_info = ParseProtoBufToTable("DoubleActiveData", msg)

    local l_config = {
        action_id = l_info.active_type,
        member_info = l_info.friend_info,
        totalTime = l_wait_time,
        finishTime = Time.realtimeSinceStartup + l_wait_time,
        confirm_callback = function()
            if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_X_CoupleActionFragment) then
                return false
            end
            --加入行为队列
            --MgrMgr:GetMgr("ExcludeStateActionMgr").DoSelfLeaveSceneObjToDouble(l_info.friend_info.role_uid,l_info.active_type)
            RequestApplyMultipleAction(l_info.friend_info.role_uid, l_info.active_type)
        end,
        cancel_callback = function(not_close)
            RequestMultipleActionRefuse(l_info.friend_info.role_uid, l_info.active_type)
            if not not_close then
                CloseOffer()
            end
        end
    }

    UpdateOfferUI(l_config, ON_REQUEST_MULTIPLE_ACTION_PUSH_EVENT)
end

-- 响应双人动作
function RequestApplyMultipleAction(target_id, action_id)
    local l_msgId = Network.Define.Rpc.DoubleActiveAgree
    ---@type DoubleActiveReplyArg
    local l_sendInfo = GetProtoBufSendTable("DoubleActiveReplyArg")
    l_sendInfo.friend_id = target_id
    l_sendInfo.active_type = action_id
    l_sendInfo.is_agree = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 响应双人动作的结果
function OnAccpetMultipleActionResult(msg)
    ---@type DoubleActiveReplyRes
    local l_info = ParseProtoBufToTable("DoubleActiveReplyRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

-- 拒绝邀请
function RequestMultipleActionRefuse(target_id, action_id)

    log("RequestMultipleActionRefuse", target_id, action_id)
    local l_msgId = Network.Define.Ptc.DoubleActiveRefuse
    ---@type DoubleActiveApplyArg
    local l_sendInfo = GetProtoBufSendTable("DoubleActiveApplyArg")
    l_sendInfo.friend_role_id = tostring(target_id)
    l_sendInfo.active_type = action_id

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

-- 取消申请
function RequestMultipleActionRevoke(target_id, action_id)

    log("RequestMultipleActionRevoke")
    local l_msgId = Network.Define.Ptc.DoubleActiveRevoke
    ---@type DoubleActiveApplyArg
    local l_sendInfo = GetProtoBufSendTable("DoubleActiveApplyArg")
    l_sendInfo.friend_role_id = target_id
    l_sendInfo.active_type = action_id

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function OnMultipleActionRefused(msg)

    log("OnMultipleActionRefused")
    ---@type DoubleActiveReplyRes
    local l_info = ParseProtoBufToTable("DoubleActiveReplyRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    UpdateOfferUI(nil, ON_MULTIPLE_ACTION_REFUSED_EVENT, l_info.friend_id)
end

function OnMultipleActionSuccess(msg)

    log("OnMultipleActionSuccess")

    CloseOffer()
end

function OnMultipleActionRevoked(msg)

    log("OnMultipleActionRevoked")
    ---@type DoubleActiveApplyArg
    local l_info = ParseProtoBufToTable("DoubleActiveApplyArg", msg)

    UpdateOfferUI(nil, ON_MULTIPLE_ACTION_REVOKED_EVENT, l_info.friend_role_id)
end

function CloseOffer()
    if UIMgr:IsActiveUI(UI.CtrlNames.MultipleActionOffer) then
        UIMgr:DeActiveUI(UI.CtrlNames.MultipleActionOffer)
    end
end

function CheckEntityInView(target_id)

    if not target_id then
        return false
    end

    if tostring(target_id) == tostring(MPlayerInfo.UID) then
        log("目标对象是自己")
        return false
    else
        local l_target_entity = MEntityMgr:GetEntity(target_id)
        if l_target_entity == nil or not MEntity.ValideEntityIncludeDead(l_target_entity) then
            log("找不到目标对象", tostring(target_id))
            return false
        else
            return true
        end
    end
end

function CheckEntityDistance(target_id, row)

    if not CheckEntityInView(target_id) then
        log("目标对象不在视野内")
        return false
    end

    local l_target_entity = MEntityMgr:GetEntity(target_id)
    if not l_target_entity then
        log("找不到目标对象")
        return false
    end

    local l_player_entity = MEntityMgr.PlayerEntity
    if not l_player_entity then
        logError("找不到自己的Entity")
        return false
    end

    local l_target_pos = l_target_entity.Position
    local l_player_pos = l_player_entity.Position
    local l_distance = math.sqrt(math.pow(l_player_pos.x - l_target_pos.x, 2) + math.pow(l_player_pos.z - l_target_pos.z, 2))

    local l_max_distance = row.RequestDistance

    if l_distance > l_max_distance then
        log("两人之间距离过大", l_distance)
        return false
    end

    if math.abs(l_player_pos.y - l_target_pos.y) > 1 then
        log("高度差太大")
        return false
    end

    return true
end

function OpenActionHandler(target_uid, target_lv)

    if UIMgr:IsActiveUI(UI.CtrlNames.SelectElement) then
        local l_ctrl = UIMgr:GetUI(UI.CtrlNames.SelectElement)
        l_ctrl:SelectOneHandler(UI.HandlerNames.SelectElementShowAction)
        return
    end
    -- 打开SelectElement时关闭独占UI(策划需求@廖萧萧)
    --UIMgr:ClearStack()
    UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
        ctrl:RemoveAllHandler()
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
        ctrl:SetDefaultHandler(UI.HandlerNames.SelectElementShowAction)
        ctrl:SetupHandlers()
        SetTargetInfo(target_uid, target_lv)
    end)
end

function GetTargetInfo()

    if TargetInfo then
        -- logError("GetFromCAche", TargetInfo.uid, TargetInfo.lv)
        return TargetInfo.uid, TargetInfo.lv
    end

    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.MainTargetInfo)
    if l_ctrl and UIMgr:IsActiveUI(UI.CtrlNames.MainTargetInfo) and l_ctrl.targetIsRole then
        local l_entity = MEntityMgr:GetEntity(l_ctrl.targetUid, true)
        if l_entity and l_entity.IsMirrorRole then
            return l_entity.MirrorOwnerUID, l_ctrl.targetLv, true
        else
            return l_ctrl.targetUid, l_ctrl.targetLv
        end
    end

    log("GetTargetID  没有玩家的Entity")
end



function CheckLimitScene(row)

    local l_scene_row = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    if not l_scene_row then
        logError("CheckLimitScene fail,找不到当前场景配置", tostring(MScene.SceneID))
        return true
    end

    for i = 0, row.LimitSceneType.Length - 1 do
        if row.LimitSceneType[i] == l_scene_row.SceneType then
            return true
        end
    end

    return false
end

function UpdateOfferUI(config, event, id)

    if not UIMgr:IsActiveUI(UI.CtrlNames.MultipleActionOffer) then
        if not config then
            return
        end
        CacheConfigData(config)
        UIMgr:ActiveUI(UI.CtrlNames.MultipleActionOffer)
    else
        EventDispatcher:Dispatch(event, config, id)
        CacheConfigData(config)
    end
end


local l_cache_config_data
function CacheConfigData(data)

    l_cache_config_data = data
end

function ClearCacheConfigData()
    l_cache_config_data = nil
end

function GetCacheConfigData()

    return l_cache_config_data
end

function SetTargetInfo(target_id, target_lv)
    TargetInfo = {
        uid = target_id,
        lv = target_lv,
    }
end

function ClearCacheTargetInfo()
    TargetInfo = nil
end

function ProcessSingleAction(action, ShowID)

    if action == nil then
        logError("actionId is Nil")
        return
    end

    --跟随中 播放单人动作 停止跟随
    if DataMgr:GetData("TeamData").Isfollowing then
        MgrMgr:GetMgr("TeamMgr").FollowSet(false)
    end

    local actionData = TableUtil.GetAnimationTable().GetRowByID(action)
    if actionData == nil then
        logError("actionData is nil in AnimationTable ID ： "..action)
        return
    end

    local actFunc = function()
        MTransferMgr:Interrupt()
        MEntityMgr.PlayerEntity:UpdateMove()
        if not MEntityMgr.PlayerEntity.IsTransfigured then
            MEntityMgr.PlayerEntity.Model:StopEmotion()
        end
        MgrMgr:GetMgr("SyncTakePhotoStatusMgr").BroadacstAction(action)
        GlobalEventBus:Dispatch(EventConst.Names.OnShowAction,ShowID)
    end

    if MEntityMgr.PlayerEntity.SpecialComp:HaveRideAnim(action) and MEntityMgr.PlayerEntity.IsRideBattleVehicle then
        actFunc()
        return
    end

    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_F_SingleAction) then
        return
    end

    actFunc()
end

function StopMultipleAction()
    local l_msgId = Network.Define.Rpc.DoubleActiveEnd
    ---@type DoubleActiveEndArg
    local l_sendInfo = GetProtoBufSendTable("DoubleActiveEndArg")
    l_sendInfo.role_id = MPlayerInfo.UID:tostring()
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnDoubleActiveEnd(msg)
    ---@type DoubleActiveEndRes
    local l_info = ParseProtoBufToTable("DoubleActiveEndRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

function ShowErrDialog(msg)

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(msg)
end

function OpenActionHandler()

    --打开SelectElement时关闭独占UI(策划需求@廖萧萧)
    --UIMgr:ClearStack()
    UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
        ctrl:RemoveAllHandler()
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
        ctrl:SetDefaultHandler(UI.HandlerNames.SelectElementShowAction)
        ctrl:SetupHandlers()
    end)
end

return MultipleActionMgr