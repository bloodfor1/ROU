--行为目标管理器，用于管理角色自动行为队列
module("ModuleMgr.ActionTargetMgr", package.seeall)
require "Common/ActionQueue"

CurrentActionQueue = Common.ActionQueue.new()

function ResetActionQueue()
    CurrentActionQueue:Clear()
end

--暂时放到这里比较好处理
function CancelSelectQuickTask()
    -- MgrMgr:GetMgr("TaskMgr").ResetSelectTask()
    -- GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

------------------------任务处理函数-------------------------

------------------------任务处理函数-------------------------
------------------------常用行为队列函数-------------------------

--移动到Npc处
function MoveToNpc(sceneId, npcId, onArrive, onCancel)
    -- logGreen("MoveToNpc:msceneId:"..sceneId..",npcId:"..npcId)
    if sceneId == nil or npcId == nil then
        -- logError("move to npc:scene:"..tostring(sceneId)..",npcId:"..tostring(npcId))
        ResetActionQueue()
        return
    end
    CurrentActionQueue:AddAciton(function(cb)
        MTransferMgr:GotoNpc(sceneId, npcId, function()
            if onArrive ~= nil then
                onArrive()
            end
            cb()
        end, function()
            if onCancel ~= nil then
                onCancel()
            end
            -- logGreen("取消寻路！")
            ResetActionQueue()
            CancelSelectQuickTask()
        end)
    end, function()
        -- logGreen("取消寻路 中断处理")
        MTransferMgr:Interrupt()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

--移动到某位置
function MoveToPos(sceneId, position, onArrive, onCancel,face,range)
    if sceneId == nil or position == nil then
        -- logError("move to scenePos:"..tostring(sceneId)..",position:"..tostring(position))
        ResetActionQueue()
        return
    end
    if face == nil then
        face = 360
    end
    if range == nil then
        range = 0
    end
    CurrentActionQueue:AddAciton(function(cb)
        MTransferMgr:GotoPosition(sceneId, position,
         function()
            if onArrive ~= nil then
                onArrive()
            end
            cb()
        end,
        function()
            if onCancel ~= nil then
                onCancel()
            end
            ResetActionQueue()
            CancelSelectQuickTask()
        end,face,range)
    end, function()
            MTransferMgr:Interrupt()
        end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

--移动到场景
function MoveToScene(sceneId, onArrive, onCancel)
    if sceneId == nil then
        logError("move to scene:"..tostring(sceneId))
        ResetActionQueue()
        return
    end
    CurrentActionQueue:AddAciton(function(cb)
        MTransferMgr:GotoScene(sceneId, function()
            if onArrive ~= nil then
                onArrive()
            end
            cb()
        end, function()
            if onCancel ~= nil then
                onCancel()
            end
            ResetActionQueue()
            CancelSelectQuickTask()
        end)
    end, function()
        MTransferMgr:Interrupt()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

--与NPC对话
function TalkWithNpc(sceneId, npcId)
    if sceneId == nil or npcId == nil then
        logError("move to npc:scene:"..tostring(sceneId)..",npcId:"..tostring(npcId))
        ResetActionQueue()
        return
    end
    CurrentActionQueue:AddAciton(function(cb)
        MgrMgr:GetMgr("NpcMgr").TalkWithNpc(sceneId, npcId)
        cb()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end


function MoveToTalkWithNpc(sceneId,npcId)
    if MgrMgr:GetMgr("NpcMgr").IsTooFar(npcId, sceneId) then
        MoveToNpc(sceneId,npcId,function ()
            TalkWithNpc(sceneId,npcId)
        end)
    else
        TalkWithNpc(sceneId,npcId)
    end
end

--杀死怪物开启自动战斗
function KillMonster( targetId )
    if MEntityMgr.PlayerEntity == nil then
        return
    end
    if targetId == nil then
        logError("move to targetId:"..tostring(targetId))
        ResetActionQueue()
        return
    end
    if MEntityMgr.PlayerEntity.Target ~= nil then
        if not MEntityMgr.PlayerEntity.Target.IsMonster then
            MEntityMgr.PlayerEntity.Target = nil
        else
            if MEntityMgr.PlayerEntity.Target.AttrComp ~= nil then
                if MEntityMgr.PlayerEntity.Target.AttrComp.EntityID ~= targetId then
                    MEntityMgr.PlayerEntity.Target = nil
                end
            end
        end
    end
    CurrentActionQueue:AddAciton(function(cb)
        local l_AutoBattleInTask = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataId.kCDT_AUTO_BATTLE_STATUS) == 1
        if l_AutoBattleInTask then
            MUIEvent.SendLuaMessage("ENUM_UI_ON_TASK_START_AUTO_FIGHT", targetId)
        else
            MSkillTargetMgr.singleton:FindEnemyBySkillBtn(true,function(entity)
                if not IsNil(entity) and not IsNil(entity.AttrComp) then
                    return entity.AttrComp.EntityID == targetId
                end
                return false
            end)
        end
        cb()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

--停止自动战斗
function StopAutoBattle()
    CurrentActionQueue:AddAciton(function(cb)
        MgrMgr:GetMgr("FightAutoMgr").CloseFightAuto()
        cb()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

--开始拍照
function TakePhoto(photoType, targetPos)
    if photoType ~= "Photo" and photoType ~= "SelfPhoto" and photoType ~= "VR360Photo" and photoType ~= "ARPhoto" then
        logError("不存在照相类型为 "..tostring(photoType).."的情况！！！ 可用的情况只有 Photo SelfPhoto VR360Photo ARPhoto")
        return
    end
    CurrentActionQueue:AddAciton(function(cb)
        local l_photoData = {
            openType = DataMgr:GetData("FashionData").EUIOpenType.SPECIAL_PHOTO,
            targetPos = targetPos,
            photoType = photoType
        }
        UIMgr:ActiveUI(UI.CtrlNames.Photograph, {[UI.CtrlNames.Photograph] = l_photoData})
        game:ShowMainPanel()
        cb()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

function EnterDungeons( dungeonsId )
    if dungeonsId == nil then
        logError("move to dungeonsId:"..tostring(dungeonsId))
        ResetActionQueue()
        return
    end
    CurrentActionQueue:AddAciton(function(cb)
        if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon(dungeonsId) then
            cb()
            return
        end
        MgrMgr:GetMgr("DungeonMgr").EnterDungeons(dungeonsId, 0, 0)
        cb()
    end)
    return MgrMgr:GetMgr("ActionTargetMgr")
end

function SetCallback(callback)
    CurrentActionQueue:SetCallback(callback)
end

function PublicVehicle(vehicleId)
    CurrentActionQueue:AddAciton(function(cb)
        MgrMgr:GetMgr("VehicleMgr").RequestRideCommonVehicle(vehicleId)
        cb()
    end)
end
------------------------常用行为队列函数-------------------------

return ActionTargetMgr