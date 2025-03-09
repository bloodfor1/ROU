---@module ModuleMgr.SyncTakePhotoStatusMgr
module("ModuleMgr.SyncTakePhotoStatusMgr", package.seeall)

local string_format = StringEx.Format

function BroadacstExpression(expressionRowId)
    local l_id = expressionRowId
    local l_msgId = Network.Define.Ptc.BroadcastTakePhotoStatus
    ---@type BroadcastTakePhotoStatus
    local l_sendInfo = GetProtoBufSendTable("BroadcastTakePhotoStatus")
    l_sendInfo.take_photo_status = l_id
	l_sendInfo.take_photo_type = 2
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function BroadacstFaceExpression(faceExpressionRowId)
    local l_id = faceExpressionRowId
    local l_msgId = Network.Define.Ptc.BroadcastTakePhotoStatus
    ---@type BroadcastTakePhotoStatus
    local l_sendInfo = GetProtoBufSendTable("BroadcastTakePhotoStatus")
    l_sendInfo.take_photo_status = l_id
	l_sendInfo.take_photo_type = 3
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function BroadacstAction(actionRowId)
    MgrMgr:GetMgr("SyncTakePhotoStatusMgr").PreCheckOperateLegalArg(_,MExlusionStates.State_F_SingleAction,function()
        local l_id = actionRowId
		local l_msgId = Network.Define.Ptc.BroadcastTakePhotoStatus
        ---@type BroadcastTakePhotoStatus
        local l_sendInfo = GetProtoBufSendTable("BroadcastTakePhotoStatus")
        l_sendInfo.take_photo_status = l_id
		l_sendInfo.take_photo_type = 1
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end)
end

--播放天气动作接口
function BroadacstWeatherAction(actionRowId)
    MgrMgr:GetMgr("SyncTakePhotoStatusMgr").PreCheckOperateLegalArg(_,MExlusionStates.State_R_WeatherAction,function()
        local l_id = actionRowId
        --MEventMgr:LuaFireEvent(MEventType.MEvent_Special, MEntityMgr.PlayerEntity, ROGameLibs.kEntitySpecialType_Action,actionRowId)
        local l_msgId = Network.Define.Ptc.BroadcastTakePhotoStatus
        ---@type BroadcastTakePhotoStatus
        local l_sendInfo = GetProtoBufSendTable("BroadcastTakePhotoStatus")
        l_sendInfo.take_photo_status = l_id
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end)
end

----预处理逻辑
preCheckSuccessFunc = nil
function PreCheckOperateLegalArg(_, taregtStateType,successFunc)
    local l_msgId = Network.Define.Rpc.PreCheckOperateLegal
    ---@type PreCheckOperateLegalArg
    local l_sendInfo = GetProtoBufSendTable("PreCheckOperateLegalArg")
    local intType = StateExclusionManager:GetExclusionStateIntNum(taregtStateType)
    l_sendInfo.operate_type = intType
    preCheckSuccessFunc = nil
    preCheckSuccessFunc = successFunc
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnPreCheckOperateLegalRes(msg)
    ---@type PreCheckOperateLegalRes
    local l_info = ParseProtoBufToTable("PreCheckOperateLegalRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        if type(preCheckSuccessFunc) == "userdata" then
            preCheckSuccessFunc:DynamicInvoke()
        else
            preCheckSuccessFunc()
        end
    end
end