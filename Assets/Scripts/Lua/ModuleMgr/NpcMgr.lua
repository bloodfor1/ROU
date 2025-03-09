
module("ModuleMgr.NpcMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
--NPC消失事件
ON_NPC_DESTORY = "ON_NPC_DESTORY"

NPCTYPE = {
    NONE = 0,
    NORMAL = 1,
    INTERACTION = 2
}

NPC_SELECT_TYPE = {
    TASK = 1,--任务选项
    FUNC = 2,--功能选项
    NORMAL = 3--普通选项
}

CurrentNpcId=-1
CurrentSceneId=-1
--npc交互控制flag
g_npcInteractFlags = {}

local l_easyPathNpcRange=1
--每个npc只会同时处理一个block
local npcRunningBlockTable = {}
--正在转身的npc
local tweeningNpc = {}


function OnInit()
    l_easyPathNpcRange = MGlobalConfig:GetFloat("EasyPathNpcRange")
    g_npcInteractFlags = {}
end

function GotoNpc(luaType, sceneId, npcId)
    if IsTalking() then
        return
    end

    sceneId = tonumber(sceneId)
    npcId = tonumber(npcId)

    --取消Special状态
    --MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, MEntityMgr.PlayerEntity);
    MTransferMgr:Interrupt()
    local l_actionMgr = MgrMgr:GetMgr("ActionTargetMgr")
    if IsTooFar(npcId, sceneId) then
        l_actionMgr.ResetActionQueue()
        --移动会自动停止 special_state 
        l_actionMgr.MoveToTalkWithNpc(sceneId, npcId)
    else
        if MEntityMgr.PlayerEntity.CurrentState == ROGameLibs.StateDefine.kStateSpecial then
            --logError("xxxxoooo")
            MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, MEntityMgr.PlayerEntity);
            MEntityMgr.PlayerEntity:StopState()
            --logError("yyyyyyy")
        end
        l_actionMgr.ResetActionQueue()
        l_actionMgr.TalkWithNpc(sceneId, npcId)
    end

end

--==============================--
--@Description:和上一个npc对话
--@Date: 2018/9/11
--@Param: [args]
--@Return:
--==============================--
function TalkWithLastNpc()
    if CurrentNpcId ~= -1 and CurrentSceneId ~= -1 then
        TalkWithNpc(CurrentSceneId, CurrentNpcId)
    end
end

function TalkWithNpc(sceneId, npcId, continue)
    local l_npcData = TableUtil.GetNpcTable().GetRowById(npcId)

    if not l_npcData then
        return
    end

    if l_npcData.NpcType == NPCTYPE.NONE or not CanInteract(npcId) then
        return
    end

    continue = continue or false

    --if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_K_NpcInteractive) then
        --return
    --end

    --停止自动寻路
    MEventMgr:LuaFireEvent(MEventType.MEvent_StopMove, MEntityMgr.PlayerEntity)
    --停止跟随 停止自动战斗
    if DataMgr:GetData("TeamData").Isfollowing then
        MgrMgr:GetMgr("TeamMgr").FollowSet(false)
    end

    --已经有正在转身的对话对象则不允许对话
    for _,v in pairs(tweeningNpc) do
        if v == true then
            return
        end
    end

    if not continue and IsTalking() then
        return
    end

    local error = CanTalk(npcId, sceneId)
    if error ~= nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(error)
        return
    end

    sceneId = tonumber(sceneId)
    npcId = tonumber(npcId)

    if CommandBlockManager.IsNpcUsing(npcId) then
        logRed("Npc"..npcId.."正在使用")
        return
    end

    local talkDlgMgr = MgrMgr:GetMgr("NpcTalkDlgMgr")
    talkDlgMgr.Reset()

    CurrentNpcId = npcId
    CurrentSceneId = sceneId

    RotateToPos(MEntityMgr.PlayerEntity, MSceneMgr:GetNpcPos(npcId, sceneId,0))

    local l_npc = MNpcMgr:FindNpcInViewport(npcId)
    if l_npc == nil then
        return
    end
    local l_npcUuid = l_npc.UID
    local l_npcRotate
    if l_npc ~= nil and l_npcData.FaceToPlayer then
        l_npcRotate = l_npc.Rotation
    end

    local l_npcActionFunc = function()

        SetNpcMovableWhenTalk(l_npcUuid, false)
        local l_callback = function()
            if l_npc ~= nil and l_npcRotate ~= nil then
                RotateToDir(l_npc, l_npcRotate.eulerAngles)
            end
            SetNpcMovableWhenTalk(l_npcUuid, true)
        end

        if GetCurrentNpcId() ~= npcId then
            talkDlgMgr.SetCurrentNpcId(npcId, true)
        end

        --普通NPC：会执行对话
        if l_npcData.NpcType == NPCTYPE.NORMAL then
            --如果无任务，无功能
            --如果有一个主线任务
            --如果多个任务
            --如果有任务也有功能
            local l_taskIdList,l_autoRun = talkDlgMgr.GetTaskSelectInfoList(sceneId, npcId)
            --如果不是自动运行，执行剧本
            if not l_autoRun then
                --功能列表，通过事件返回给对话按钮
                local selectInfos = MgrMgr:GetMgr("NpcFuncMgr").GetNpcFuncSelectInfoList(l_npcData)
                for i, v in ipairs(selectInfos) do
                    talkDlgMgr.AddSelectInfo(v.buttonName, v.method, v.isCloseOnClick, v.selectType)
                end

                local selectInfos = talkDlgMgr.GetSelectInfos()
                if selectInfos and #selectInfos > 0 then
                    game:ShowMainPanel({UI.CtrlNames.TalkDlg2})

                    RunNpcCommandBlock(npcId, sceneId, callback)

                    talkDlgMgr.ActiveTalkDlgOrBroadcastEvent()
                else
                    -- 无选项
                    RunNpcCommandBlock(npcId, sceneId, l_callback)
                end
            end

        --交互NPC：直接运行剧本内容
        elseif l_npcData.NpcType == NPCTYPE.INTERACTION then
            RunNpcCommandBlock(npcId, sceneId, l_callback)
        elseif l_npcData.NpcType == NPCTYPE.NONE then
        else
            logError("角色类型配置出错 @天考 ，NpcId为"..npcId)
        end
    end

    if l_npc ~= nil and l_npcData.FaceToPlayer then
        MEntityMgr.PlayerEntity.IsMovable = false
        RotateToPos(l_npc, MEntityMgr.PlayerEntity.Position, function()
            MEntityMgr.PlayerEntity.IsMovable = true
            local error = CanTalk(npcId, sceneId)
            if error ~= nil then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(error)
                RotateToDir(l_npc, l_npcRotate.eulerAngles)
                return
            end
            l_npcActionFunc()
        end)
    else
        l_npcActionFunc()
    end

end

function RunNpcCommandBlock(npcId, sceneId, callback)

    local l_npcData = TableUtil.GetNpcTable().GetRowById(npcId)
    npcRunningBlockTable[npcId] = true

    if l_npcData == nil then
        logError("缺少NPCTable配置 @天考，id为"..npcId)
        return
    end

    local l_commandscript = l_npcData.NPCScript
    if l_commandscript.Capacity < 2 then
        logError("CommandScript参数数量配置错误 @天考，id为"..npcId)
        return
    end
    local l_commandId = l_commandscript[0]
    local l_commandTag = l_commandscript[1]

    if string.len(l_commandId) <= 0 then return end

     --执行剧本
    local l_block = CommandBlock.OpenAndRunBlock("CommandScript/NPC/"..tostring(l_commandId), l_commandTag)
    if l_block ~= nil then
        l_block:SetCallback(function(block)
            if callback then callback() end
        end)
    end

end

function GetCurrentNpcId()

    return MgrMgr:GetMgr("NpcTalkDlgMgr").GetCurrentNpcId()
end

function GetCurrentNpcName()
    return TableUtil.GetNpcTable().GetRowById(GetCurrentNpcId()).Name
end

function CanInteract(npcId)
    return g_npcInteractFlags[npcId] ~= false
end

function CanTalk(npcId, sceneId)

    --[[
    if MEntityMgr.PlayerEntity.CurrentState ~= ROGameLibs.StateDefine.kStateDefault then
        return Lang("NPC_CANNOTTALK_NOW_STATE")
    end
    ]]--

    local l_npcData = TableUtil.GetNpcTable().GetRowById(npcId)
    if l_npcData and l_npcData.IsDynamicNpc == 1 then
        return nil
    end

    local l_npc = MNpcMgr:FindNpcInViewport(npcId)

    if l_npc == nil then
        logRed("npcId:"..npcId.."is nil 如果是弱网且不卡流程请忽略")
    end

    if not MEntity.ValideEntity(l_npc) then
        --return Lang("NPC_CANNOTTALK_NO_NPC")
        return "NotShow"  --弱网异常 不需要提示玩家NPC不存在 已和陈敏确认
    end

    if IsTooFar(npcId, sceneId) then
        return Lang("NPC_CANNOTTALK_TOO_FAR")
    end

    if MEntityMgr.PlayerEntity.IsDead then
        return Lang("NPC_CANNOT_TALK_WHEN_DEAD")
    end

    return nil
end

function IsTooFar(npcId, sceneId)
    local l_npcPos = MSceneMgr:GetNpcPos(npcId, sceneId,0)
    if(l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1)then
        logError("NPC pos is nil")
        return false
    end
    if sceneId ~= MScene.SceneID or l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
        return true
    end
    if MEntityMgr.PlayerEntity == nil then
        return true
    end

    local l_playerPos = MEntityMgr.PlayerEntity.Position
    local l_dis = (l_npcPos.x - l_playerPos.x) *  (l_npcPos.x - l_playerPos.x) +  (l_npcPos.z - l_playerPos.z)*(l_npcPos.z - l_playerPos.z)
    l_dis=math.sqrt(l_dis)
    if l_dis > l_easyPathNpcRange + 0.2 then
        return true
    end

    return false
end

function IsTalking()

    local l_talkDlg = UIMgr:GetUI(UI.CtrlNames.TalkDlg2)
    return l_talkDlg ~= nil and l_talkDlg.isActive
end

function RotateToPos(entity, pos, callback)
    if pos.x == -1 and pos.y == -1 and pos.z == -1 then
        logError("NPC pos is nil")
        return
    end
    local l_toDir = pos - entity.Position
    if l_toDir.x == 0 and l_toDir.z == 0 then
        if callback ~= nil then
            callback()
        end
        return
    end
    l_toDir.y = 0
    RotateToDir(entity, Quaternion.LookRotation(l_toDir).eulerAngles, callback)
end

function RotateToDir(entity, rotation, callback)
    if entity == nil or entity.VehicleOrModel.Trans == nil then
        if callback ~= nil then
            callback()
        end
        return
    end
    local l_npcId = nil
    if entity.ToNpc ~= nil and entity.ToNpc ~= nil and entity.AttrComp ~= nil then
        l_npcId = entity.AttrComp.NpcID
        tweeningNpc[l_npcId] = true
    end
    local l_time = math.abs(entity.VehicleOrModel.Trans.eulerAngles.y - rotation.y) / 180.0 * 0.3
    local l_tweener = entity.VehicleOrModel.Trans:DORotate(rotation, l_time)
    entity:AddTweener(l_tweener)
    l_tweener:OnComplete(function ()
        if l_npcId ~= nil then
            tweeningNpc[l_npcId] = nil
        end
        if callback ~= nil then
            callback()
        end
        if entity then
            entity:RemoveTweener(l_tweener)
        end
    end)
end

function SetNpcMovableWhenTalk(npcid, canMove)

    local l_msgId = Network.Define.Ptc.NpcTalkReq
    ---@type NpcTalkArgs
    local l_sendInfo = GetProtoBufSendTable("NpcTalkArgs")
    l_sendInfo.npc_uuid = tostring(npcid)
    l_sendInfo.enable = not canMove
    Network.Handler.SendPtc(l_msgId, l_sendInfo)

end

function SetNpcInterState(npcId, flag)
    if npcId and flag ~= nil then
        npcId = tonumber(npcId)
        g_npcInteractFlags[npcId] = flag
    end
end

--监听NPC消失事件
function OnNpcDestory(luaType, ...)
    local l_npcIds = {...}
    local l_npcId = l_npcIds[1]
    EventDispatcher:Dispatch(ON_NPC_DESTORY, l_npcId)
end

return NpcMgr