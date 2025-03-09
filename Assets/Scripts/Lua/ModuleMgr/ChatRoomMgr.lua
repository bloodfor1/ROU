---@module ModuleMgr.ChatRoomMgr
module("ModuleMgr.ChatRoomMgr", package.seeall)

------------------------------
chatMgr = nil
local chatDataMgr=DataMgr:GetData("ChatData")
RoomShowMax = false
LoginFristShow = false
EventDispatcher = EventDispatcher.new()
Event =
{
    ResetData = "ResetData",        --刷新所有数据
    ResetSetting = "ResetSetting",  --房间设置刷新
    CaptainChange = "CaptainChange",--队长改变

    MemberAdd = "MemberAdd",        --增加组员
    MemberRemove = "MemberRemove",  --移除组员
    MemberState = "MemberState",    --组队离线状态
    MemberChange = "MemberChange",  --头像数据改变
}

------------------------------房间数据
Room = {
    UID = nil,          --房间uid uint64
    Name = nil,         --房间名 string
    Type = 0,           --房间类型 int32
    MaxNum = 0,         --容量上限 int32
    Code = nil,           --密码 string
    Captain = nil,      --房主
    CreatTime = nil,    --创建时间 uint64
    Members = {},       --成员表

    Has = function(self)    --聊天室存在
        if self.UID == nil then
            return false
        end
        return true
    end,

    --获取一个成员信息
    GetMember = function(self,uid)
        for i=1,#self.Members do
            if self.Members[i].uid == uid then
                return self.Members[i]
            end
        end
        return nil
    end,

    --自身是否为房主
    SelfCaptain = function(self)
        return self:Has() and self.Captain and self.Captain.uid == MPlayerInfo.UID
    end,
}

-----------------------------------生命周期
function OnInit()
    GlobalEventBus:Add(EventConst.Names.BeginTouchJoyStack, OnNavigationMove)
    GlobalEventBus:Add(EventConst.Names.OnClickGroud, OnNavigationMove)
    GlobalEventBus:Add(EventConst.Names.OnNavigationMove, OnNavigationMove)
    GlobalEventBus:Add(EventConst.Names.SceneInteractClick, OnNavigationMove)
end

function OnUpdate()

end

function OnLogout()
    ResetRoomData(nil)
    MoveHintTime = nil
end

function OnLeaveStage()

end

function OnReconnected(reconnectData) --断线重连
    RequestGetChatRoomInfo()
end

function OnSelectRoleNtf(roleInfo) --角色登陆成功
    LoginFristShow = true
    RequestGetChatRoomInfo()
end

function ChatMgr()
    chatMgr = chatMgr or MgrMgr:GetMgr("ChatMgr")
    return chatMgr
end

---------------------------------------function
function TryShowRoom()
    if Room:Has() then
        RequestGetChatRoomInfo()
        TrySetPanelMax(true)
        return
    end

    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_Z_ChatRoom) then
        return
    end

    UIMgr:ActiveUI(UI.CtrlNames.CreateChatRoom)
end

--尝试创建聊天室
function TryCreatRoom(name,num,type,code)
    if Room:Has() then
        logError("当前已存在聊天室,不能创建")
        return false
    end
    if string.ro_isEmpty(name) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_NameNil"))--房间名不能为空
        return false
    end

    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_Z_ChatRoom) then
        return
    end

    RequestCreatChatRoom(name,num,type,code)
    return true
end

--尝试加入聊天室
function TryJoinRoom(rid,title,code,affirm)
    if Room:Has() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_RepeatJoin"))--您不能同时进入两个聊天室
        return
    end

    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_Z_ChatRoom) then
        return
    end

    if affirm then
        local l_txt = Lang("ChatRoom_ConfirmJoin",title)--是否进入%s？
        local l_txtConfirm = Lang("DLG_BTN_YES")--"确定"
        local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
        CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_txt, l_txtConfirm, l_txtCancel,
        function()
            RequestApplyJoinRoom(rid,code)
        end)
    else
        RequestApplyJoinRoom(rid,code)
    end
end

--尝试退出聊天室
function TryLeaveRoom()
    if not Room:Has() then
        return
    end

    local l_txt = Lang("ChatRoom_ConfirmExit")--是否要退出聊天室？
    local l_txtConfirm = Lang("DLG_BTN_YES")--"确定"
    local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
        if Room:SelfCaptain() then
            l_txt = Lang("ChatRoom_ConfirmExit_Captain")--您退出后，房主将转交他人哦，确定要退出吗？
            CommonUI.Dialog.ShowYesNoDlg(false, nil, l_txt, function()
                RequestLeaveRoom()
                UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
            end, function()
                UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
            end)
        else
            RequestLeaveRoom()
        end
    end)
end

--尝试解散聊天室
function TryDissolveRoom()
    if not Room:Has() then
        return
    end

    local l_txt = Lang("ChatRoom_Dissolve")--是否要解散聊天室？解散后聊天室将不复存在哦
    local l_txtConfirm = Lang("DLG_BTN_YES")--"确定"
    local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_txt, l_txtConfirm, l_txtCancel,
    function()
        RequestDissolveRoom()
    end)
end

--尝试踢人
function TryKickMember(uid)
    if not Room:Has() then
        return
    end
    if not Room:SelfCaptain() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ONLY_CAPTAIN_CAN_KICK"))
        return
    end
    if uid == MPlayerInfo.UID then
        -- 现在聊天室房主在自己标签上不能看到踢出按钮
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("非法功能")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANNOT_KICK_SELF"))
        return
    end
    local l_member = Room:GetMember(uid)
    if not l_member then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_EXIST_MEMBER"))
        return
    end

    local l_txt = Lang("ChatRoom_Kick",l_member.member.name)--是否将该玩家[%s]踢出聊天室？
    local l_txtConfirm = Lang("DLG_BTN_YES")--"确定"
    local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_txt, l_txtConfirm, l_txtCancel,
    function()
        RequestKickRoomMember(uid)
    end)
end

--尝试修改房间属性
function TrySetRoom(name,num,type,code)
    if not Room:Has() then
        logError("房间不存在,不能修改")
        return false
    end
    if string.ro_isEmpty(name) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_NameNil"))
        return false
    end

    RequestChangeRoomSetting(name,num,type,code)
    return true
end

--最大化/最小化
function TrySetPanelMax(isMax,ignoreAfk)
    RoomShowMax = isMax
    if isMax then
        UIMgr:DeActiveUI(UI.CtrlNames.ChatRoomMini)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.ChatRoom)
    end

    if not Room:Has() then
        return
    end

    if isMax then
        UIMgr:ActiveUI(UI.CtrlNames.ChatRoom)
        if not ignoreAfk then
            RequestRoomAfk(false)
        end
    else
        MoveHintTime = nil
        UIMgr:ActiveUI(UI.CtrlNames.ChatRoomMini)
        if not ignoreAfk then
            RequestRoomAfk(true)
        end
    end
end
function BeforeEnterChatRoom()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    MTransferMgr:NavigationDisabledBySystem(l_openSystemMgr.eSystemId.ChatRoom,function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ChatRoom_MoveHint"))
    end)
end
function AfterExitChatRoom()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    MTransferMgr:NavigationEnabledBySystem(l_openSystemMgr.eSystemId.ChatRoom)
end
----------------------------------------数据处理

--重新设聊天室所有数据
function ResetRoomData(info) --ChatRoomInfo
    if info==nil or info.room_uid==nil or info.room_uid==0 or info.room_uid=="0" then
        Room.UID = nil
        Room.Name = nil
        Room.Members = {}
        Room.Captain = nil

        --清除记录
        chatDataMgr.ClearChatInfoCacheByChannel(chatDataMgr.EChannel.ChatRoomChat)

        UIMgr:DeActiveUI(UI.CtrlNames.ChatRoom)
        UIMgr:DeActiveUI(UI.CtrlNames.ChatRoomMini)
        EventDispatcher:Dispatch(Event.ResetData)
    else
        Room.UID = info.room_uid                --房间uid uint64
        Room.CreatTime = info.create_time       --创建时间 uint64
        Room.Members = {}
        for i=1,#info.room_member.info do            --成员表
            AddMember(info.room_member.info[i])
        end
        --房主uid uint64
        ResetRoomSetting(info.room_setting)
        ResetCaptain(info.room_captain_uid,info.room_setting.room_code)

        EventDispatcher:Dispatch(Event.ResetData)
    end

    ResetBubbleInfo()
end

--重新设置聊天设置
function ResetRoomSetting(set)
    if Room:Has() then
        Room.Name = set.room_name       --房间名 string
        Room.Type = set.room_type       --房间类型 int32
        Room.MaxNum = set.room_capacity --容量上限 int32
        Room.Code = set.room_code       --密码 int32

        EventDispatcher:Dispatch(Event.ResetSetting)
        ResetBubbleInfo()
    end
end

--重新设置队长
function ResetCaptain(uid,code)
    if Room:Has() then
        if not Room.Captain or Room.Captain.uid ~= uid then
            local l_newCaptain = Room:GetMember(uid)
            if l_newCaptain == nil then
                logError("找不到目标房主数据,切换房主失败")
                return false
            end
            Room.Captain = l_newCaptain
            Room.Code = code
            --排序-房主置顶-其次自身-进入先后
            for i=1,#Room.Members do
                Room.Members[i].sort = #Room.Members - i
            end
            Room:GetMember(MPlayerInfo.UID).sort = 1000
            Room.Captain.sort = 1001
            table.sort(Room.Members,function(a,b)
                return a.sort > b.sort
            end)

            EventDispatcher:Dispatch(Event.CaptainChange)
            ResetBubbleInfo()
            return true
        end
    end
    return false
end

--重新设置离线状态
function ResetMemberState(uid,state)
    if not Room:Has() then
        return false
    end
    local l_member = Room:GetMember(uid)
    if l_member == nil then
        return false
    end
    if l_member.state == state then
        return false
    end

    l_member.state = state
    EventDispatcher:Dispatch(Event.MemberState,l_member)
    return true
end

--添加一个成员
function AddMember(member)
    if Room:Has() then
        --重复的替换
        for i=1,#Room.Members do
            if Room.Members[i].uid == member.role_uid then
                Room.Members[i].member = member
                EventDispatcher:Dispatch(Event.MemberChange,Room.Members[i])
                return true
            end
        end

        local l_member = {
            member = MgrMgr:GetMgr("PlayerInfoMgr").CreatMemberData(member),
            uid = member.role_uid,
            state = member.status == MemberStatus.CHAT_ROOM_MEMBER_AFK,
            isSelf = MPlayerInfo.UID == member.role_uid,
        }
        --自身永远在线
        if l_member.isSelf then
            l_member.state = false
        end
        table.insert(Room.Members, l_member)
        --logError("AddMember => uid={0}; name={1}; state={2}",member.role_uid,member.name,l_member.state)
        EventDispatcher:Dispatch(Event.MemberAdd,l_member)
        return true
    end
    return false
end

--移除一个成员
function RemoveMember(uid)
    if not Room:Has() then
        return false
    end
    if uid == MPlayerInfo.UID then
        ResetRoomData(nil)
        return true
    end
    if uid == Room.Captain.uid then
        Room.Captain = nil
        -- logError("为什么会把房主踢掉？？？")
    end
    for i=1,#Room.Members do
        local l_member = Room.Members[i]
        if l_member.uid == uid then
            table.remove(Room.Members,i)
            EventDispatcher:Dispatch(Event.MemberRemove,l_member)
            return true
        end
    end
    return false
end

--刷新头顶冒泡信息
function ResetBubbleInfo()
    local l_data = nil
    if Room:Has() then
        l_data = {
            room_uid = Room.UID,
            name = Room.Name,
            have_code = not string.ro_isEmpty(Room.Code),
            is_captain = Room:SelfCaptain(),
        }
    end

    -- logError("ResetBubbleInfo => hasRoom={0}",Room:Has())
    MgrMgr:GetMgr("ChatRoomBubbleMgr").ResetData(MPlayerInfo.UID,l_data)
end

--刷新聊天室所有成员的头像
function SyncAllMemberInfo()
    if not Room:Has() then
        return false
    end

    local l_mgr = MgrMgr:GetMgr("PlayerInfoMgr")
    for i=1,#Room.Members do
        local l_member = Room.Members[i]
        l_mgr.GetPlayerInfoFromServer(l_member.uid,function(data)
            if not Room:Has() then
                return
            end
            for i=1,#Room.Members do
                if Room.Members[i].uid == data.uid then
                    Room.Members[i].member = data
                    EventDispatcher:Dispatch(Event.MemberChange,Room.Members[i])
                    return
                end
            end
        end)
    end
end

----------------------------------------协议
--拉取聊天室所有数据
function RequestGetChatRoomInfo()
    local l_msgId = Network.Define.Rpc.GetChatRoomInfo
    ---@type ChatRoomInfoArg
    local l_sendInfo = GetProtoBufSendTable("ChatRoomInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnGetChatRoomInfo(msg, arg)
    ---@type ChatRoomInfoRes
    local l_resInfo = ParseProtoBufToTable("ChatRoomInfoRes", msg)
    if l_resInfo.result ~= 0 then
        if l_resInfo.result == ErrorCode.ERR_ROOM_NOT_EXIST then
            --当前没有聊天室
            ResetRoomData(nil)
            LoginFristShow = false
            return
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        end
    end
    BeforeEnterChatRoom()
    ResetRoomData(l_resInfo.room_info)
    if LoginFristShow then
        LoginFristShow = false
        TrySetPanelMax(false)
    end
end

--请求创建聊天室
function RequestCreatChatRoom(name,num,type,code)
    local l_msgId = Network.Define.Rpc.CreateChatRoom
    ---@type CreateChatRoomArg
    local l_sendInfo = GetProtoBufSendTable("CreateChatRoomArg")
    l_sendInfo.setting.room_name = name
    l_sendInfo.setting.room_type = type
    l_sendInfo.setting.room_capacity = num
    if not string.ro_isEmpty(code) then
        l_sendInfo.setting.room_code = code
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnCreateChatRoom(msg, arg)
    ---@type CreateChatRoomRes
    local l_resInfo = ParseProtoBufToTable("CreateChatRoomRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        BeforeEnterChatRoom()
        TrySetPanelMax(true,true)
        local l_hinSt = Lang("ChatRoom_CreatHint")--你开启了聊天室
        MgrMgr:GetMgr("TeamMgr").SetEndAutoFollow()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt)
        ChatMgr().SendSystemInfo(chatDataMgr.EChannelSys.Hint,l_hinSt)
        SendChatInRoom(l_hinSt)
    end
end

--请求修改房间设置
function RequestChangeRoomSetting(name,num,type,code)
    local l_msgId = Network.Define.Rpc.ChangeRoomSetting
    ---@type ChangeRoomSettingArg
    local l_sendInfo = GetProtoBufSendTable("ChangeRoomSettingArg")
    l_sendInfo.setting.room_name = name
    l_sendInfo.setting.room_type = type
    l_sendInfo.setting.room_capacity = num
    if not string.ro_isEmpty(code) then
        l_sendInfo.setting.room_code = code
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnChangeRoomSetting(msg, arg)
    ---@type ChangeRoomSettingRes
    local l_resInfo = ParseProtoBufToTable("ChangeRoomSettingRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end
function OnRoomSettingChangeNtf(msg)
    ---@type ChangeRoomData
    local l_resInfo = ParseProtoBufToTable("ChangeRoomData", msg)
    ResetRoomSetting(l_resInfo.setting)
end

--请求踢出成员
function RequestKickRoomMember(uid)
    local l_msgId = Network.Define.Rpc.KickRoomMember
    ---@type KickRoomMemberArg
    local l_sendInfo = GetProtoBufSendTable("KickRoomMemberArg")
    l_sendInfo.kick_role_uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnKickRoomMember(msg, arg)
    ---@type KickRoomMemberRes
    local l_resInfo = ParseProtoBufToTable("KickRoomMemberRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end
function OnRoomKickMemberNtf(msg)
    ---@type UserID
    local l_resInfo = ParseProtoBufToTable("UserID", msg)
    local l_roomName = Room.Name
    local l_member = Room:GetMember(l_resInfo.uid)
    local l_sure = RemoveMember(l_resInfo.uid)
    if l_sure then
        if l_resInfo.uid == MPlayerInfo.UID then
            local l_hinSt = Lang("ChatRoom_Kick_Self",l_roomName)--您不小心被馅饼砸中，退出了聊天室%s
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt)
            ChatMgr().SendSystemInfo(chatDataMgr.EChannelSys.Hint,l_hinSt)
            AfterExitChatRoom()
        else
            --显示成员退出消息
            SendChatInRoom(Lang("ChatRoom_Kick_Other",l_member.member.name))--%s退出了聊天室
        end
    end
end

--请求离开房间
function RequestLeaveRoom()
    local l_msgId = Network.Define.Rpc.LeaveRoom
    ---@type LeaveRoomArg
    local l_sendInfo = GetProtoBufSendTable("LeaveRoomArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnLeaveRoom(msg, arg)
    ---@type LeaveRoomRes
    local l_resInfo = ParseProtoBufToTable("LeaveRoomRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        AfterExitChatRoom()
    end
end
function OnLeaveRoomNft(msg)
    ---@type LeaveRoomNftData
    local l_resInfo = ParseProtoBufToTable("LeaveRoomNftData", msg)
    local isSceneChange = l_resInfo.reason == RoomChangeReason.ROOM_CHANGE_SCENE

    local l_roomName = Room.Name
    local l_member = Room:GetMember(l_resInfo.role_uid)
    local l_sure = RemoveMember(l_resInfo.role_uid)
    if l_sure then
        if l_resInfo.role_uid == MPlayerInfo.UID then
            local l_hinSt = Lang("ChatRoom_Leave_Self",l_roomName) --已退出聊天室%s
            ChatMgr().SendSystemInfo(chatDataMgr.EChannelSys.Hint,l_hinSt)
            if isSceneChange then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt);
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt)
            end
            AfterExitChatRoom()
        else
            --显示成员退出消息
            SendChatInRoom(Lang("ChatRoom_Kick_Other",l_member.member.name))--%s退出了聊天室
        end
    end
end

--请求解散房间
function RequestDissolveRoom()
    local l_msgId = Network.Define.Rpc.DissolveRoom
    ---@type DissolveRoomArg
    local l_sendInfo = GetProtoBufSendTable("DissolveRoomArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnDissolveRoom(msg, arg)
    ---@type DissolveRoomRes
    local l_resInfo = ParseProtoBufToTable("DissolveRoomRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        AfterExitChatRoom()
    end
end
function OnRoomDissolveNtf(msg)
    ---@type RoomDissolveNtfData
    local l_resInfo = ParseProtoBufToTable("RoomDissolveNtfData", msg)
    local isSceneChange = l_resInfo.reason == RoomChangeReason.ROOM_CHANGE_SCENE
    if Room.Name == nil or Room.Name == "" then
        return
    end
    local l_hinSt = Lang("ChatRoom_Dissolve_Done",Room.Name) --聊天室%s已被解散
    ResetRoomData(nil)

    ChatMgr().SendSystemInfo(chatDataMgr.EChannelSys.Hint,l_hinSt)
    if isSceneChange then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt);
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_hinSt)
    end
    AfterExitChatRoom()
end

--请求申请加入
function RequestApplyJoinRoom(rid,code)
    local l_msgId = Network.Define.Rpc.ApplyJoinRoom
    ---@type ApplyJoinRoomArg
    local l_sendInfo = GetProtoBufSendTable("ApplyJoinRoomArg")
    l_sendInfo.room_uid = rid
    if code then
        l_sendInfo.room_code = code
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnApplyJoinRoom(msg, arg)
    ---@type ApplyJoinRoomRes
    local l_resInfo = ParseProtoBufToTable("ApplyJoinRoomRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        MgrMgr:GetMgr("TeamMgr").SetEndAutoFollow()
        BeforeEnterChatRoom()
        TrySetPanelMax(true,true)
        SendChatInRoom(Lang("ChatRoom_JoinHint"))--你进入了聊天室
    end
end

--请求房主变化
function RequestRoomChangeCaptain(rid)
    local l_msgId = Network.Define.Rpc.RoomChangeCaptain
    ---@type RoomChangeCaptainArg
    local l_sendInfo = GetProtoBufSendTable("RoomChangeCaptainArg")
    l_sendInfo.new_captain_uid = rid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnRoomChangeCaptain(msg, arg)
    ---@type RoomChangeCaptainRes
    local l_resInfo = ParseProtoBufToTable("RoomChangeCaptainRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end
function OnRoomChangeCaptainNtf(msg)
    ---@type RoomChangeCaptainData
    local l_resInfo = ParseProtoBufToTable("RoomChangeCaptainData", msg)
    ResetCaptain(l_resInfo.captain.uid,l_resInfo.room_code)
end

--离线状态
function RequestRoomAfk(is_afk)
    local l_msgId = Network.Define.Rpc.RoomAfk
    ---@type RoomAfkArg
    local l_sendInfo = GetProtoBufSendTable("RoomAfkArg")
    l_sendInfo.is_afk = is_afk
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnRoomAfk(msg, arg)
    ---@type RoomAfkRes
    local l_resInfo = ParseProtoBufToTable("RoomAfkRes", msg)
    if l_resInfo.result ~= 0 then
        if l_resInfo.result == ErrorCode.ERR_ROOM_ALREADY_IN_STATUS then
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end
function OnRoomMerberStatusNft(msg)
    ---@type RoomMerberStatusNtfData
    local l_resInfo = ParseProtoBufToTable("RoomMerberStatusNtfData", msg)
    ResetMemberState(l_resInfo.role_uid,l_resInfo.status == MemberStatus.CHAT_ROOM_MEMBER_AFK)
end


--进入房间时拿到的房间信息
function OnRoomInfoNtf(msg)
    ---@type ChatRoomInfo
    local l_resInfo = ParseProtoBufToTable("ChatRoomInfo", msg)
    ResetRoomData(l_resInfo)
end

--一个用户加入房间
function OnNewRoomMemberNtf(msg)
    ---@type MemberBaseInfo
    local l_resInfo = ParseProtoBufToTable("MemberBaseInfo", msg)
    local l_sure = AddMember(l_resInfo)
    local l_member = Room:GetMember(l_resInfo.role_uid)
    if l_sure then
        --显示成员加入消息
        SendChatInRoom(Lang("ChatRoom_Join_Done",l_member.member.name)) -- %s进入了聊天室
    end
end

--向聊天室发送一个消息
function SendChatInRoom(content)
    if not Room:Has() then
        return false
    end
    local l_MsgPkg={}
    l_MsgPkg.channel=chatDataMgr.EChannel.ChatRoomChat
    l_MsgPkg.lineType=chatDataMgr.EChatPrefabType.Hint
    l_MsgPkg.content=content
    ChatMgr().BoardCastMsg(l_MsgPkg)
    return true
end

--尝试寻路
--这里只给提示，约束移动由服务器套buff实现
function OnNavigationMove()
    if MoveHintTime then
        local l_time = MServerTimeMgr.UtcSeconds - MoveHintTime
        l_time = MLuaCommonHelper.Long2Int(l_time)
        if l_time <= 180 then
            return
        end
        MoveHintTime = nil
    end

    if Room:Has() then
        MoveHintTime = MServerTimeMgr.UtcSeconds
    end
end

function CanReleaseSkill()
    if Room:Has() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_MoveHint"))--您当前处于聊天室中，不能进行该操作
        return false
    end
    return true
end
return ModuleMgr.ChatRoomMgr