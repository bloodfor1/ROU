---@module ModuleMgr.ChatRoomBubbleMgr
module("ModuleMgr.ChatRoomBubbleMgr", package.seeall)

Datas = {}

-----------------------------------生命周期
function OnInit()
    GlobalEventBus:Add(EventConst.Names.UnitAppearChatRoomData, function(dataLis)
        if dataLis then
            local l_count = dataLis.Count
            for i=0,l_count-1 do
                local l_data = dataLis:get_Item(i)
                ResetData(tostring(l_data.uID),{
                    room_uid = tostring(l_data.room_uid),
                    name = l_data.name,
                    have_code = l_data.have_code,
                    is_captain = l_data.is_captain,
                },true)
            end
        end
    end)
end

function OnUpdate()
end

function OnLogout()
    Datas = {}
end

function OnLeaveStage()
    UIMgr:DeActiveUI(UI.CtrlNames.Inputpassword)
end

function OnReconnected(reconnectData) --断线重连
    ClearDatas(true)
    ResetDatas(reconnectData.others_in_view)
end

function OnLuaDoEnterScene(allInfo)
    ClearDatas(true)
    ResetDatas(allInfo.others_in_view)
end

function OnSelectRoleNtf(roleInfo) --角色登陆成功

end

---------------------------------------
--刷新当前所有角色的聊天冒泡
function ResetCurData()
    for k,v in pairs(Datas) do
        ResetData(k,v,false)
    end
end

function ResetDatas(datas)
    for i=1,#datas do
        local l_data = datas[i]
        if l_data.room_info and l_data.room_info.room_uid~=0 then
            ResetData(l_data.uID,l_data.room_info,true)
        end
    end
end

function ClearDatas(send)
    if send then
        local l_rids = {}
        for k,v in pairs(Datas) do
            table.insert(l_rids,k)
        end

        for i=1,#l_rids do
            ResetData(l_rids[i],nil,true)
        end
    end
    Datas = {}
    MgrMgr:GetMgr("ChatRoomMgr").ResetBubbleInfo()
end

function ResetData(rid,room,distinct)
    if room and ((room.room_uid==0) or string.ro_isEmpty(tostring(room.room_uid))) then
        room = nil
    end

    rid = tostring(rid)

    if distinct then
        local l_oldData = Datas[rid]
        if room==nil and l_oldData==nil then
            return
        end

        if room~=nil and l_oldData~=nil then
            if room.room_uid == l_oldData.room_uid and
                room.name == l_oldData.name and
                room.have_code == l_oldData.have_code and
                room.is_captain == l_oldData.is_captain then
                return
            end
        end
    end

    -- if room then
    --     logError("rid={0}; roomID={1}",rid,tostring(room.room_uid))
    -- else
    --     logError("rid={0};",rid)
    -- end

    if room == nil then
        Datas[rid] = nil
    else
        Datas[rid] = room
    end

    local l_com = GetEntityCom(MEntityMgr:GetEntity(rid))
    if l_com then
        if room == nil then
            l_com:SetRoomInfo(0,nil,false,false)
        else
            local l_uid = MoonCommonLib.MLuaCommonHelper.ULong(room.room_uid)
            l_com:SetRoomInfo(l_uid,room.name,room.have_code,room.is_captain)
        end
    else
        --logError("l_com = nil => rid={0}",rid)
    end
end

function TryGetRoomInfo(com,rid)
    rid = tostring(rid)
    if not com then
        com = GetEntityCom(MEntityMgr:GetEntity(rid))
    end
    if not com then
        return
    end

    local l_data = Datas[rid]
    if l_data == nil then
        com:SetRoomInfo(0,nil,false,false)
    else
        local l_uid = MoonCommonLib.MLuaCommonHelper.ULong(l_data.room_uid)
        com:SetRoomInfo(l_uid,l_data.name,l_data.have_code,l_data.is_captain)
    end
end

--eData:ugui的点击事件
--rid：点击到的角色uid
--roomID：点击到的房间名
function TryClick(eData, rid, roomID, title, hasCode, isCaptain)
    if eData~=nil and tostring(eData:GetType()) == "MoonClient.MPointerEventData" and eData.Tag==UI.CtrlNames.NumberCodeInput then
        return
    end

    rid = tostring(rid)
    roomID = tostring(roomID)
    if not isCaptain then
        return
    end

    local l_room = MgrMgr:GetMgr("ChatRoomMgr")
    if rid == tostring(MPlayerInfo.UID) then
        --自己点击自己的房间
        l_room.TrySetPanelMax(true)
        return
    end

    if l_room.Room:Has() and l_room.Room.UID == roomID then
        --点击当前已加入的房间
        l_room.TrySetPanelMax(true)
        return
    end

    if hasCode then
        UIMgr:ActiveUI(UI.CtrlNames.Inputpassword,function(ctrl)
            ctrl:SetRoomInfo(roomID,title)
        end)
    else
        l_room.TryJoinRoom(roomID,title,nil,true)
    end
end

function GetEntityCom(entity)
    if entity then
        local l_uuid = MCommonFunctions.GetHash("HUDChatRoomComponent")
        return entity:GetMComponentByUUID(l_uuid)
    end
end

-----------------------------------------

--冒泡信息同步
function OnRoomBriefNeighbourNtf(msg)
    ---@type RoomBriefNeighbourNtfData
    local l_resInfo = ParseProtoBufToTable("RoomBriefNeighbourNtfData", msg)
    --logError("房间信息同步 => uid={0}; roomid={1}",l_resInfo.role_uid,l_resInfo.brief.room_uid)
    ResetData(l_resInfo.role_uid,l_resInfo.brief,true)
end
