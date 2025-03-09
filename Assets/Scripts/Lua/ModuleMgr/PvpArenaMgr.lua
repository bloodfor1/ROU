---
--- Created by chauncyhu.
--- DateTime: 2019/2/16 15:04
---

---@module ModuleMgr.PvpArenaMgr
module("ModuleMgr.PvpArenaMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

SHOW_ARENA_ROOM_LIST = "SHOW_ARENA_ROOM_LIST"
UPDATE_ARENA_ROOM_INFO_NTF = "UPDATE_ARENA_ROOM_INFO_NTF"
LEAVE_ARENA_ROOM_INFO_NTF = "LEAVE_ARENA_ROOM_INFO_NTF"
ON_PVP_MEMBER_UPDATE_HP = "ON_PVP_MEMBER_UPDATE_HP"
ON_PVP_CANINVITE_UPDATE = "ON_PVP_CANINVITE_UPDATE"

----------------------------------------pvp----------------------------------------------------

local m_pvpRomeListReqCount = 0
m_pvpRomeListInfo = {}
m_arenaRoomInfo = nil
m_memberInfo = {}
m_canInvite = false

m_limitTime = MGlobalConfig:GetInt("CustomArenaButtonCD") or 30
m_inviteTimeLimit = {}
m_recruitTimeLimit = {}

function OnLogout()
    m_arenaRoomInfo = nil
    m_memberInfo = {}
    m_canInvite = false
    m_pvpRomeListInfo = {}
end

function OnEnterScene(sceneId)
    m_pvpRomeListInfo = {}
end

function SetReqCount(value)
    m_pvpRomeListReqCount = value
end
--[[
创建房间
--]]
function CreateArenaPvpCustom()
    local l_msgId = Network.Define.Rpc.CreateArenaPvpCustom
    ---@type CreateArenaPvpCustomArg
    local l_sendInfo = GetProtoBufSendTable("CreateArenaPvpCustomArg")
    --TODO
    l_sendInfo.mapid = 1001
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnCreateArenaPvpCustom(msg)
    ---@type CreateArenaPvpCustomRes
    local l_info = ParseProtoBufToTable("CreateArenaPvpCustomRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end
--[[
加入房间
--]]
function ActiveJoinArenaRoom(arenaRoomInfo)
    local l_msgId = Network.Define.Rpc.ActiveJoinArenaRoom
    ---@type ActiveJoinArenaRoomArg
    local l_sendInfo = GetProtoBufSendTable("ActiveJoinArenaRoomArg")
    --TODO
    l_sendInfo.scene_id = tonumber(arenaRoomInfo.id)
    --l_sendInfo.gsline   = 1
    --l_sendInfo.arena_type = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnActiveJoinArenaRoom(msg)
    ---@type ActiveJoinArenaRoomRes
    local l_info = ParseProtoBufToTable("ActiveJoinArenaRoomRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end
--[[
修改房间条件
--]]
function ChangeArenaRoomCondition(minLevel, maxLevel, playmode)
    local l_msgId = Network.Define.Rpc.ChangeArenaRoomCondition
    ---@type ChangeArenaRoomConditionArg
    local l_sendInfo = GetProtoBufSendTable("ChangeArenaRoomConditionArg")
    if minLevel ~= nil then
        l_sendInfo.open_min_level = minLevel
    end
    if maxLevel ~= nil then
        l_sendInfo.open_max_level = maxLevel
    end
    if playmode ~= nil then
        l_sendInfo.playmode = playmode
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnChangeArenaRoomCondition(msg)
    ---@type ChangeArenaRoomConditionRes
    local l_info = ParseProtoBufToTable("ChangeArenaRoomConditionRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end
--[[
房间列表
--]]
function ShowArenaRoomList()
    m_pvpRomeListReqCount = m_pvpRomeListReqCount + 1
    local l_msgId = Network.Define.Rpc.ShowArenaRoomList
    ---@type ShowListArenaPvpArg
    local l_sendInfo = GetProtoBufSendTable("ShowListArenaPvpArg")
    l_sendInfo.type = ArenaType.ARENA_CUSTOM
    l_sendInfo.page = m_pvpRomeListReqCount
    l_sendInfo.show_count = 10
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnShowArenaRoomList(msg)
    ---@type ShowListArenaPvpRes
    local l_info = ParseProtoBufToTable("ShowListArenaPvpRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if #l_info.rooms == 0 then
        EventDispatcher:Dispatch(SHOW_ARENA_ROOM_LIST)
        return
    end
    local count = table.ro_size(m_pvpRomeListInfo)
    local l_count = #(l_info.rooms)
    if l_count > 0 then
        for i = 1, l_count do
            count = count + 1
            m_pvpRomeListInfo[count] = l_info.rooms[i]
        end
    end
    EventDispatcher:Dispatch(SHOW_ARENA_ROOM_LIST)
end
--[[
加入房间
--]]
function PushIntoArenaPvpCustom()
    local l_msgId = Network.Define.Ptc.PushIntoArenaPvpCustom
    ---@type CreateArenaPvpCustomArg
    local l_sendInfo = GetProtoBufSendTable("CreateArenaPvpCustomArg")
    --TODO
    l_sendInfo.mapid = 1002
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end
--[[
同步房间状态
--]]
function OnSyncArenaRoomBriefInfoNtf(msg)
    ---@type ArenaRoomInfo
    local l_info = ParseProtoBufToTable("ArenaRoomInfo", msg)
    --logError("----->>>>OnSyncArenaRoomBriefInfoNtf:"..tostring(l_info))
    UpdateArenaRoomInfo(l_info)
    UpdateMemberInfo(l_info)
    EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
end

function UpdateArenaRoomInfo(info)
    m_arenaRoomInfo = {}
    m_arenaRoomInfo = info
    m_canInvite = info.member_can_invite
end
---@param msg ArenaRoomInfo
function UpdateMemberInfo(msg)
    m_memberInfo = {}
    local l_count = #(msg.custom_room.member)
    if l_count > 0 then
        for i = 1, l_count do
            local l_roleId = tostring(msg.custom_room.member[i].role_id)
            m_memberInfo[l_roleId] = {}
            m_memberInfo[l_roleId].RoleId = l_roleId
            m_memberInfo[l_roleId].FightGroup = msg.custom_room.member[i].fight_group
            m_memberInfo[l_roleId].HP = 1
            local l_role = MEntityMgr:GetRole(l_roleId, true)
            m_memberInfo[l_roleId].professionId = msg.custom_room.member[i].role_type
            m_memberInfo[l_roleId].Name = msg.custom_room.member[i].role_name
            if l_role and l_role.AttrComp then
                m_memberInfo[l_roleId].HP = l_role.AttrComp.HPPercent
            end
            EventDispatcher:Dispatch(ON_PVP_MEMBER_UPDATE_HP, l_roleId)
        end
    end
    --Common.Functions.DumpTable(m_memberInfo, "<var>", 6)
end

function OnUpdateHP(table, roleId, hpValue)

    local l_roleId = tostring(roleId)
    if m_memberInfo[l_roleId] == nil then
        return
    end
    m_memberInfo[l_roleId].HP = hpValue
    EventDispatcher:Dispatch(ON_PVP_MEMBER_UPDATE_HP, l_roleId)
end

function JudgeIsOwner(roleId)
    if m_arenaRoomInfo == nil then
        return false
    end
    if tostring(m_arenaRoomInfo.owner.roleID) == tostring(roleId) then
        return true
    else
        return false
    end
end
--[[
同步房间状态
--]]
function OnArenaRoomStateNtf(msg)
    if not m_arenaRoomInfo then
        return
    end
    ---@type ArenaRoomStateData
    local l_info = ParseProtoBufToTable("ArenaRoomStateData", msg)
    --logError("----->>>>OnArenaRoomStateNtf:"..tostring(l_info))
    if l_info.type == ArenaSyncType.kArenaSyncTypeChangeCamp then
        local l_roleId = tostring(l_info.camp_info.role_id)
        m_memberInfo[l_roleId] = {}
        m_memberInfo[l_roleId].RoleId = l_roleId
        m_memberInfo[l_roleId].FightGroup = l_info.camp_info.new_camp
        m_memberInfo[l_roleId].HP = 1
        local l_role = MEntityMgr:GetRole(l_roleId, true)
        m_memberInfo[l_roleId].professionId = 1000
        if l_role and l_role.AttrComp then
            m_memberInfo[l_roleId].HP = l_role.AttrComp.HPPercent
            m_memberInfo[l_roleId].professionId = l_role.AttrComp.ProfessionID
            m_memberInfo[l_roleId].Name = l_role.AttrComp.Name
        end
        EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
        return
    end
    if l_info.type == ArenaSyncType.kArenaSyncTypeChangeOwner then
        m_arenaRoomInfo.owner.roleID = l_info.owner_info.new_owner.roleID
        EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
        return
    end
    if l_info.type == ArenaSyncType.kArenaSyncTypeChangePlayMode then
        m_arenaRoomInfo.play_mode = l_info.mode_info.new_mode
        EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
        return
    end
    if l_info.type == ArenaSyncType.kArenaSyncTypeMemberCanInvite then
        local l_state = l_info.invite_info.can
        if l_state then
            m_canInvite = true
        else
            m_canInvite = false
        end
        EventDispatcher:Dispatch(ON_PVP_CANINVITE_UPDATE)
        EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
        return
    end
    if l_info.type == ArenaSyncType.kArenaSyncTypeMemberLeave then
        local l_roleid = l_info.leave_info.role_id
        for k, v in pairs(m_memberInfo) do
            if tostring(k) == tostring(l_roleid) then
                m_memberInfo[k] = nil
                EventDispatcher:Dispatch(UPDATE_ARENA_ROOM_INFO_NTF)
                EventDispatcher:Dispatch(LEAVE_ARENA_ROOM_INFO_NTF)
                --Common.Functions.DumpTable(m_memberInfo, "<var>", 6)
                break
            end
        end
        return
    end
end
--[[
邀请
--]]
function ArenaInviteRequet(id)
    local l_msgId = Network.Define.Rpc.ArenaInviteRequet
    ---@type ArenaInviteRequetArg
    local l_sendInfo = GetProtoBufSendTable("ArenaInviteRequetArg")
    l_sendInfo.role_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnArenaInviteResponse(msg)
    ---@type ArenaInviteRequetRes
    local l_info = ParseProtoBufToTable("ArenaInviteRequetRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end
--[[
设置邀请
--]]
function ArenaSetMemberInvite()
    local l_msgId = Network.Define.Rpc.ArenaSetMemberInvite
    ---@type ArenaSetMemberInviteArg
    local l_sendInfo = GetProtoBufSendTable("ArenaSetMemberInviteArg")
    l_sendInfo.can = not m_canInvite
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnArenaSetMemberInvite(msg)
    ---@type ArenaSetMemberInviteRes
    local l_info = ParseProtoBufToTable("ArenaSetMemberInviteRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

function ArenaInviteNtf(msg)
    ---@type ArenaInviteNtfData
    local l_info = ParseProtoBufToTable("ArenaInviteNtfData", msg)
    local l_name = tostring(l_info.sender.name).." "
    local l_v = tostring(l_info.sender.level)
    local l_id = l_info.room_id
    if l_id then
        UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer,  function(ctrl)
            ctrl:ShowContentCallBackWithoutCountdown("Lv."..(l_v)..l_name..Common.Utils.Lang("PVP_INVITATE_JOIN_ROOM"),
            function()
                ActiveJoinArenaRoom({id = l_id})
            end)
        end)
    end
end
--[[
招募
--]]
function SendPvpArenaRecruit(str,channel)
    if m_arenaRoomInfo then
        local l_chatMgr=MgrMgr:GetMgr("ChatMgr")
        if l_chatMgr.CanSendMsg(channel,false) then
            local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetPvpPack(str,m_arenaRoomInfo.id)
            local l_channel = channel
            l_chatMgr.SendChatMsg(MPlayerInfo.UID, l_msg, l_channel, l_msgParam)
        end
    end
end
