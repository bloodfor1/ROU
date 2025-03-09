require "Event/EventDispacher"
---@module ModuleMgr.WorldMapInfoMgr
module("ModuleMgr.WorldMapInfoMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
EventType = {
    WorldEventUpdate = "WorldEventUpdate", --世界事件更新
}
local  sceneIdArrived = {}
local  sceneInfluenceEvt = {}
local  dynamicNPC = {}
local  dynamicNPCId = {}

function OnSelectRoleNtf(info)
    sceneIdArrived={}
    local l_exInfo =  info.ExtraInfo
    local l_arrivedMap = l_exInfo.already_arrvied_map
    for i=1,#l_arrivedMap do
       sceneIdArrived[l_arrivedMap[i].value]=true
    end    
end
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    local l_exInfo = l_roleAllInfo.ExtraInfo
    local l_arrivedMap = l_exInfo.already_arrvied_map
    for i=1,#l_arrivedMap do
       sceneIdArrived[l_arrivedMap[i].value]=true
    end
end
function OnWorldEventUpdate()
    EventDispatcher:Dispatch(EventType.WorldEventUpdate)
end
--场景访问
function IsArrived(sceneId)
    if sceneId==nil or sceneIdArrived==nil then
       return false
    end
    return (sceneIdArrived[sceneId]==true)
end
function AddArrived(sceneId)
    if sceneId==nil or  sceneIdArrived==nil then
       return
    end
    sceneIdArrived[sceneId]=true
end
function ShowMapName()
    if UIMgr:IsActiveUI(UI.CtrlNames.FindAims) then
       local l_findAnimUI = UIMgr:GetUI(UI.CtrlNames.FindAims)
       if l_findAnimUI~=nil then
           l_findAnimUI:ShowMapName()
       end
       return
    end
    UIMgr:ActiveUI(UI.CtrlNames.FindAims,function ( ctrl )
       ctrl:ShowMapName()
    end)
end
function HideMapName()
    if UIMgr:IsActiveUI(UI.CtrlNames.FindAims) then
        local l_findAnimUI = UIMgr:GetUI(UI.CtrlNames.FindAims)
        if l_findAnimUI~=nil then
            l_findAnimUI:HideMapName()
        end
    end
end
function ShowKpl()
    if UIMgr:IsActiveUI(UI.CtrlNames.FindAims) then
        local l_findAnimUI = UIMgr:GetUI(UI.CtrlNames.FindAims)
        if l_findAnimUI~=nil then
            l_findAnimUI:ShowKpl()
        end
       return
    end
    UIMgr:ActiveUI(UI.CtrlNames.FindAims,function ( ctrl )
       ctrl:ShowKpl()
    end)
end
function FadeCallback()
    MSceneFirstInMgr:FadeCallback()
end
function Fade(fadeInTime,showTime,fadeOutTime)
    MgrMgr:GetMgr("BlackCurtainMgr").BlackCurtain(nil,FadeCallback,nil,fadeInTime,showTime,fadeOutTime)
end
--大世界事件
function AddInfluenceEvt(evt)
    if sceneInfluenceEvt[evt.scene_id] == nil then
        sceneInfluenceEvt[evt.scene_id] = {}
    end
    local l_fluenceEvt = {}
    l_fluenceEvt.endTime = evt.end_time
    sceneInfluenceEvt[evt.scene_id][evt.influence_id] = l_fluenceEvt
end
function OnAllSceneInfluenceNtf(msg)
    sceneInfluenceEvt = {}
    ---@type SceneInfluenceSet
    local l_info = ParseProtoBufToTable("SceneInfluenceSet", msg)
    local  l_evts =  l_info.evts
    for k,v in ipairs(l_evts) do
        AddInfluenceEvt(v)
    end
end 
function OnSceneInfluenceUpdate(msg)
    ---@type SceneInfluenceEvt
    local l_info = ParseProtoBufToTable("SceneInfluenceEvt", msg)
    AddInfluenceEvt(l_info)
end 
function GetSceneInfluence(sceneId)
    local l_res = {}
    local l_evts =  sceneInfluenceEvt[sceneId]
    if l_evts==nil then
        return l_res
    end
    local l_nowTime = MLuaCommonHelper.ULong(MServerTimeMgr.UtcSeconds)
    for k,v in pairs(l_evts) do
        local  l_cmp = MLuaCommonHelper.UIntCompareULong(v.endTime,l_nowTime)
        if  l_cmp==1 then
            l_res[#l_res+1]=k
        end
    end
    return l_res
end

--动态NPC信息
function AddDynamicDisplayNpc(npc)
    if npc==nil then
       return
    end
    if  dynamicNPCId[npc.scene_id]~=nil and  dynamicNPCId[npc.scene_id][npc.npc_table_id]==true then
       return
    end
    if  dynamicNPCId[npc.scene_id]==nil then
        dynamicNPCId[npc.scene_id]={}
    end
    dynamicNPCId[npc.scene_id][npc.npc_table_id]=true
    if  dynamicNPC[npc.scene_id]==nil then
        dynamicNPC[npc.scene_id]={}
    end
    local  l_newInfo = {}
    l_newInfo.tableId = npc.npc_table_id
    l_newInfo.pos = Vector3.New(npc.pos.x,npc.pos.y,npc.pos.z)
    l_newInfo.uid = npc.npc_uuid
    table.insert(dynamicNPC[npc.scene_id],  l_newInfo)
    
    if npc.scene_id == MScene.SceneID then
       local l_pos2D = Vector2.New(npc.pos.x,npc.pos.z)
       local l_npcRow = TableUtil.GetNpcTable().GetRowById(l_newInfo.tableId)
       if l_npcRow~=nil
               and l_npcRow.NpcMapIcon~=nil
               and l_npcRow.NpcMapIcon~="" then
          MapObjMgr:AddObj(MapObjType.DynamicNpc,l_newInfo.uid, l_pos2D)
          MapObjMgr:MdObj(MapObjType.DynamicNpc,l_newInfo.uid,l_npcRow.NpcMapIcon)
       end
    end
end
function DeleteDynamicDisplayNpc(npc)
    if npc==nil then
       return
    end
    if  dynamicNPC[npc.scene_id]==nil then
       return
    end
    if  dynamicNPCId[npc.scene_id]==nil or  dynamicNPCId[npc.scene_id][npc.npc_table_id]~=true then
       return
    end
    if  dynamicNPCId[npc.scene_id]==nil then
        dynamicNPCId[npc.scene_id]={}
    end
    dynamicNPCId[npc.scene_id][npc.npc_table_id]=false
    for k,v in pairs(dynamicNPC[npc.scene_id]) do
       if v.uid == npc.npc_uuid then
          table.remove(dynamicNPC[npc.scene_id],k)
          if v.scene_id==MScene.SceneID then
             MapObjMgr:RmObj(MapObjType.DynamicNpc,v.uid)
          end
          break
       end
    end
end
function GetDynamicDisplayNpcs(sceneId)
    if  dynamicNPC[sceneId]==nil then
        dynamicNPC[sceneId]={}
    end
    return  dynamicNPC[sceneId]
end
function OnDynamicDisplayNpcNtf(msg)
    ---@type DynamicDisplayNPCSet
    local l_info = ParseProtoBufToTable("DynamicDisplayNPCSet", msg)
    MapObjMgr:RmObj(MapObjType.DynamicNpc)
    dynamicNPC={}
    dynamicNPCId={}
    local  l_datas =  l_info.npc
    for k,v in ipairs(l_datas) do
       AddDynamicDisplayNpc(v)
    end
end
function OnDynamicDisplayNpcUpdate(msg)
    ---@type DynamicDisplayNPCUpdetaData
    local l_info = ParseProtoBufToTable("DynamicDisplayNPCUpdetaData", msg)
    local  l_data =  l_info.npc
    if  l_info.is_appear==1 then
       AddDynamicDisplayNpc(l_data)
    else
       DeleteDynamicDisplayNpc(l_data)
    end
end
function HideWorldMap()
    UIMgr:DeActiveUI(UI.CtrlNames.WorldMap)
    if MScene.SceneEntered then
       MTransferMgr:AddMapObj(MScene.SceneID)
       MgrMgr:GetMgr("MapInfoMgr").ShowMapPanel(false)
    end
end
return ModuleMgr.WorldMapInfoMgr