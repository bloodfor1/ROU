require "UI/Template/FriendChatTemplate"
require "UI/Template/FriendChatMagicLetterTemplate"

---@module ModuleMgr.FriendMgr
module("ModuleMgr.FriendMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

EFriendChatType = {
    Normal = 1, --正常模式
    MagicLetter = 2, --信笺模式
}

--收到一条聊天信息
ReceivePrivateChatEvent = "ReceivePrivateChatEvent"
--收到历史记录聊天信息
GetRecordChatDatasEvent = "GetRecordChatDatasEvent"
--已读消息
ReadMessage = "ReadMessage"
--好友度改变
IntimacyDegreeChangeEvent = "IntimacyDegreeChangeEvent"
ResetFriendInfoEvent = "ResetFriendInfoEvent"
SearchRoleEvent = "SearchRoleEvent"
--删除好友数据
ChangeFriendDataEvent = "ChangeFriendDataEvent"
UpdateContactData = "UpdateContactData"
--联系人改变上线状态
ChangeOnlineEvent = "ChangeOnlineEvent"
--添加好友
AddFriendEvent = "AddFriendEvent"
--好友状态改变
FriendStageChangeEvent = "FriendStageChangeEvent"
HelperSignChange = "HelperSignChange"
--好友数据
---@type FriendInfo[]
FriendDatas = {}
--所有的联系人数据
---@type FriendInfo[]
ContactsDatas = {}

--两条消息显示时间的间隔
FriendChatIntervalTime = MLuaCommonHelper.ULong(300)

ContactsChangePositionIntervalTime = 1

--当前聊天的聊天信息
CurrentFriendChatDatas = {}
--未读信息
UnReadData = {}
--当前选中的聊天对象的数据
CurrentFriendData = {}
--UnReadCount=0
CurrentSelectFriendIndex = 0
--聊天数据库
ChatSqlite = nil
--MessageTable中的id
ChatAddFriendMessageId = 64001
--助手的npcID
HelperNpcID = 0
HelperSign = nil

function OnInit()
    HelperNpcID = MGlobalConfig:GetInt("KapulaHelperId")
end

function OnUnInit()
    if ChatSqlite then
        ChatSqlite:Close()
        ChatSqlite = nil
    end
end

function OnSelectRoleNtf(roleData)
    GetChatSqlite()
    RequestGetFriendInfo()
end

--MgrMgr调用
function OnLogout()
    FriendDatas = {}
    CurrentFriendChatDatas = {}
    UnReadData = {}
    ClearNewMessage(true)
    if ChatSqlite then
        ChatSqlite:Close()
        ChatSqlite = nil
    end
end

function GetChatSqlite()
    if ChatSqlite~=nil then
        return ChatSqlite
    end
    ChatSqlite = MoonClient.ChatDataMgr.New()
    ChatSqlite:Open()
    return ChatSqlite
end

---------------------------------------

function OpenFriendPanel()
    RequestGetFriendInfo()
end

function RequestSendPrivateChatMsg(uid, content, params, serverTrigger)
    local l_msgId = Network.Define.Ptc.SendPrivateChatMsg
    ---@type PrivateChatInfo
    local l_sendInfo = GetProtoBufSendTable("PrivateChatInfo")

    l_sendInfo.uid = tostring(uid)
    l_sendInfo.content = content
    l_sendInfo.medium_type = ChatMediumType.ChatMediumTypeText
    if serverTrigger then
        l_sendInfo.server_trigger = true
    end

    if params ~= nil then
        for i = 1, #params do
            local l_param = params[i]
            local l_data = l_sendInfo.extra_param:add()
            l_data.type = l_param.type
            if l_param.param32 ~= nil then
                for j = 1, #l_param.param32 do
                    l_data.param32:add().value = l_param.param32[j].value
                end
            end
            if l_param.param64 ~= nil then
                for j = 1, #l_param.param64 do
                    l_data.param64:add().value = l_param.param64[j].value
                end
            end
            if l_param.name ~= nil then
                for j = 1, #l_param.name do
                    logGreen(tostring((#l_data.name)))
                    table.insert(l_data.name, l_param.name[j])
                end
            end
        end
    end
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function RequestSendAudioChatMsg(uid, audioID, translate, length)
    local l_msgId = Network.Define.Ptc.SendPrivateChatMsg
    ---@type PrivateChatInfo
    local l_sendInfo = GetProtoBufSendTable("PrivateChatInfo")

    l_sendInfo.uid = tostring(uid)
    l_sendInfo.medium_type = ChatMediumType.ChatMediumTypeAudio
    l_sendInfo.audio.audio_id = audioID
    l_sendInfo.audio.text = translate
    l_sendInfo.audio.duration = length
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function ReceivePrivateChatNtf(msg)
    ---@type PrivateDetailChatInfo
    local l_info = ParseProtoBufToTable("PrivateDetailChatInfo", msg)
    --收到聊天信息之后，先更新头像数据
    MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(l_info.chat_uid, function(obj)
        local l_getNewData = function(a)
            return {
                uid = a.uid,
                friend_type = a.friend_type,
                intimacy_degree = a.intimacy_degree,
                base_info = obj.data,
            }
        end
        for i = 1, #FriendDatas do
            if FriendDatas[i].uid == l_info.chat_uid then
                FriendDatas[i] = l_getNewData(FriendDatas[i])
            end
        end
        for i = 1, #ContactsDatas do
            if ContactsDatas[i].uid == l_info.chat_uid then
                ContactsDatas[i] = l_getNewData(ContactsDatas[i])
            end
        end
        if CurrentFriendData and CurrentFriendData.uid == l_info.chat_uid then
            CurrentFriendData = l_getNewData(CurrentFriendData)
            updateContactsData(CurrentFriendData)
        end
        AddNewMessage()

        EventDispatcher:Dispatch(ReceivePrivateChatEvent, l_info)
    end)
end
---@param msgContent PrivateDetailChatInfo
function GetFriendChatType(msgContent)
    local l_chatType = EFriendChatType.Normal
    if msgContent.extra_param ~= nil then
        ---@type ModuleMgr.ChatMgr
        local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
        local l_extraParam = MgrMgr:GetMgr("LinkInputMgr").StringToPack(msgContent.extra_param)
        if l_extraParam ~= nil then
            for i = 1, #l_extraParam do
                local l_paramInfo = l_extraParam[i]
                if l_paramInfo.type == l_chatMgr.ChatHrefType.FriendMagicLetter then
                    l_chatType = EFriendChatType.MagicLetter
                    break
                end
            end
        end
    end
    return l_chatType
end

function GetFriendChatPrefabAndClass(msgContent)
    local l_friendChatType = GetFriendChatType(msgContent)
    local l_class, l_prefab
    if l_friendChatType == EFriendChatType.MagicLetter then
        l_class = UITemplate.FriendChatMagicLetterTemplate
        l_prefab = "UI/Prefabs/ChatLine/FriendChatMagicLetterPrefab"
    else
        l_class = UITemplate.FriendChatTemplate
        l_prefab = "UI/Prefabs/ChatLine/FriendChatPrefab"
    end

    return l_class, l_prefab
end

function RequestGetFriendInfo()
    local l_msgId = Network.Define.Rpc.GetFriendInfo
    ---@type GetFriendInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetFriendInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveGetFriendInfo(msg)
    ---@type GetFriendInfoRes
    local l_info = ParseProtoBufToTable("GetFriendInfoRes", msg)

    --FriendDatas=l_info.friend_list
    ContactsDatas = {}
    FriendDatas = { { npcID = HelperNpcID } } --第一个默认显示为助手
    UnReadData = l_info.message_info.unread_counts
    for i = 1, #l_info.friend_list do
        local l_friendData = l_info.friend_list[i]
        if l_friendData.friend_type == 1 or l_friendData.friend_type == 3 then
            table.insert(ContactsDatas, l_friendData)
            if l_friendData.friend_type == 1 then
                table.insert(FriendDatas, l_friendData)
            end
        end
    end


    --添加临时联系人
    if TemporaryContact ~= nil then
        --ContactsDatas
        local l_ContactsDatas = {}
        table.insert(l_ContactsDatas, TemporaryContact)
        for i = 1, #ContactsDatas do
            local l_data = ContactsDatas[i]
            if l_data.uid ~= TemporaryContact.uid then
                table.insert(l_ContactsDatas, l_data)
            else
                TemporaryContact.friend_type = l_data.friend_type
                TemporaryContact.intimacy_degree = l_data.intimacy_degree
            end
        end
        ContactsDatas = l_ContactsDatas

        --UnReadData
        local l_unReadHas = false
        for i = 1, #UnReadData do
            local l_data = UnReadData[i]
            if l_data.uid == TemporaryContact.uid then
                l_data.last_chat_time = tostring(MServerTimeMgr.LastSyncServerTime)
                l_unReadHas = true
                break
            end
        end
        if not l_unReadHas then
            table.insert(UnReadData, {
                uid = TemporaryContact.uid,
                count = 0,
                last_chat_time = tostring(MServerTimeMgr.LastSyncServerTime),
            })
        end
        TemporaryContact = nil
    end

    sortFriend(FriendDatas)

    EventDispatcher:Dispatch(ResetFriendInfoEvent, nil)
    --UIMgr:ActiveUI(UI.CtrlNames.Community)
end

function sortFriend(friendDatas)
    table.sort(friendDatas, function(a, b)
        if not a.base_info or not b.base_info then
            return false
        end
        -- 排序顺序 好友是否在线 > 好友度
        local l_curValueA = (a.base_info.status == MemberStatus.MEMBER_NORMAL) and 1 or 0
        local l_curValueB = (b.base_info.status == MemberStatus.MEMBER_NORMAL) and 1 or 0
        if l_curValueA ~= l_curValueB then
            return l_curValueA > l_curValueB
        end
        return a.intimacy_degree > b.intimacy_degree
    end)
end
---@return FriendInfo[]
function GetFriendInfos()
    return FriendDatas
end

--添加一个临时联系人
function AddTemporaryContacts(menmberInfo)
    if menmberInfo ~= nil then
        TemporaryContact = {
            uid = menmberInfo.role_uid,
            friend_type = FriendType.TYPE_CONTACT,
            intimacy_degree = 0,
            base_info = menmberInfo,
        }

        --界面如果已经打开
        local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Community)
        if l_ctrl ~= nil then
            local l_handler = l_ctrl:GetHandlerByName(UI.HandlerNames.Friends)
            if l_handler ~= nil and l_handler.isActive then
                RequestGetFriendInfo()
            end
        end
    else
        TemporaryContact = nil
    end
end

function RequestAddFriend(uid)

    if MPlayerInfo.UID == uid then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Friend_CantAddSelfText"))
        return
    end

    local l_msgId = Network.Define.Rpc.AddFriend
    ---@type AddFriendArg
    local l_sendInfo = GetProtoBufSendTable("AddFriendArg")

    l_sendInfo.friend_uid = tostring(uid)

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestAddFriend(msg, arg)
    ---@type AddFriendRes
    local l_info = ParseProtoBufToTable("AddFriendRes", msg)
    if l_info.result ~= 0 then
        require "Common/Functions"
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    sortFriend(FriendDatas)
    EventDispatcher:Dispatch(AddFriendEvent, arg.friend_uid)
end

--更新联系人数据，删除好友也会收到这个
function ReceiveUpdateOrAddFriendNtf(msg)
    ---@type UpdateOrAddFriendData
    local l_info = ParseProtoBufToTable("UpdateOrAddFriendData", msg)
    updateContactsData(l_info.friend_info)
end

function RequestDeleteFriend(uid)
    local l_msgId = Network.Define.Rpc.DeleteFriend
    ---@type DeleteFriendArg
    local l_sendInfo = GetProtoBufSendTable("DeleteFriendArg")

    l_sendInfo.friend_uid = tostring(uid)

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--删除聊天记录
function RequestDeleteRecord(uid)
    local l_msgId = Network.Define.Ptc.ClearChatRecordNtf
    ---@type ClearChatRecordData
    local l_sendInfo = GetProtoBufSendTable("ClearChatRecordData")
    l_sendInfo.chat_uid = tostring(uid)
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--删除好友和联系人数据
function ReceiveDeleteFriendNtf(msg)
    ---@type DeleteFriendData
    local l_info = ParseProtoBufToTable("DeleteFriendData", msg)

    deleteFriendData(FriendDatas, l_info.friend_uid)
    deleteFriendData(ContactsDatas, l_info.friend_uid)
end

function RequestReadPrivateMessage(uid, squence)
    local l_msgId = Network.Define.Rpc.ReadPrivateMessage
    ---@type ReadPrivateMessageArg
    local l_sendInfo = GetProtoBufSendTable("ReadPrivateMessageArg")

    l_sendInfo.uid = tostring(uid)
    l_sendInfo.squence = squence

    --logGreen("发送协议")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveReadPrivateMessage(msg, arg)
    ---@type ReadPrivateMessageRes
    local l_info = ParseProtoBufToTable("ReadPrivateMessageRes", msg)
    local l_chatDatas = l_info.private_chat_list
    for i = #l_chatDatas, 1, -1 do
        for j = 1, #CurrentFriendChatDatas do
            if CurrentFriendChatDatas[j].chatSquence == l_chatDatas[i].squence then
                table.remove(l_chatDatas, i)
                break
            end
        end
    end
    --logGreen("接收的协议")
    if #l_chatDatas > 0 then
        EventDispatcher:Dispatch(GetRecordChatDatasEvent, l_chatDatas)
    end

    EventDispatcher:Dispatch(ReadMessage, arg.uid)
end
function ReceiveUnReadMessageCountNtf(msg)
    ---@type UnReadMessageCountData
    local l_info = ParseProtoBufToTable("UnReadMessageCountData", msg)

    --UnReadCount=l_info.total_unread_count
    for i = 1, #l_info.unread_counts do
        setUnReadData(l_info.unread_counts[i])
    end

end

function ReceiveFriendIntimacyDegreeNtf(msg)
    ---@type FriendIntimacyDegreeData
    local l_info = ParseProtoBufToTable("FriendIntimacyDegreeData", msg)

    local l_friendData = GetContactsData(l_info.friend_uid)
    --logError("好友度变化协议 => data={0}; degree={1}",l_friendData,l_info.intimacy_degree)
    if l_friendData ~= nil then
        l_friendData.intimacy_degree = l_info.intimacy_degree

        EventDispatcher:Dispatch(IntimacyDegreeChangeEvent, l_friendData)
    end
end

function ReceiveAddFriendTipNtf(msg)
    ---@type AddFriendTipNtfData
    local l_info = ParseProtoBufToTable("AddFriendTipNtfData", msg)

    local l_uid = l_info.friend_uid
    local l_messageId = l_info.message_id

    local l_contactsData = GetContactsData(l_uid)
    if l_contactsData ~= nil then
        local l_messageChatInfo
        if l_messageId == 65001 then
            l_messageChatInfo = Common.Utils.Lang("Friend_AddFriendSucceedText")
        elseif l_messageId == 66001 then
            l_messageChatInfo = Common.Utils.Lang("Friend_AddedToFriendSucceedText")
        end
        if l_messageChatInfo == nil then
            logError("服务器发的数据不对")
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(l_messageChatInfo, Common.Utils.PlayerName(l_contactsData.base_info.name)))
        end

        EventDispatcher:Dispatch(FriendStageChangeEvent)
    end
end

function ReceiveRoleOnlineNtf(msg)
    ---@type RoleOnlineData
    local l_info = ParseProtoBufToTable("RoleOnlineData", msg)

    --logGreen("收到上线uid："..tostring(l_info.role_uid).."    is_online:"..tostring(l_info.is_online))
    changeOnline(ContactsDatas, l_info.role_uid, l_info.is_online)
    changeOnline(FriendDatas, l_info.role_uid, l_info.is_online)
    EventDispatcher:Dispatch(ChangeOnlineEvent)
    if l_info.is_online and l_info.is_need_notice then
        if l_info.friend_data and l_info.friend_data.base_info then
            local l_text = StringEx.Format(Lang("Friend_OnlineText"), Common.Utils.PlayerName(l_info.friend_data.base_info.name))
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_text)
            MgrMgr:GetMgr("ChatMgr").SendSystemInfo(DataMgr:GetData("ChatData").EChannelSys.System, l_text)
        end
    end
end

function changeOnline(datas, uid, isOnline)
    for i = 1, #datas do
        if datas[i].uid == uid then
            if isOnline then
                datas[i].base_info.status = MemberStatus.MEMBER_NORMAL
            else
                datas[i].base_info.status = MemberStatus.MEMBER_OFFLINE
            end
            return
        end
    end
end


--function CheckRedSignMethod()
--    return UnReadCount
--end

function updateContactsData(data)
    addOrReplaceContactsData(ContactsDatas, data)
    EventDispatcher:Dispatch(UpdateContactData, data)
    if data.friend_type == 1 then
        addOrReplaceContactsData(FriendDatas, data)
    else
        deleteFriendData(FriendDatas, data.uid)
        EventDispatcher:Dispatch(ChangeFriendDataEvent, data)
    end
end

function addOrReplaceContactsData(sourceDatas, data)
    for i = 1, #sourceDatas do
        if sourceDatas[i].uid == data.uid then
            sourceDatas[i] = data
            return
        end
    end
    table.insert(sourceDatas, data)
end

function GetContactsData(uid)
    for i = 1, #ContactsDatas do
        if ContactsDatas[i].uid == uid then
            return ContactsDatas[i]
        end
    end
    logError("联系人信息没有uid:" .. tostring(uid))
    return nil
end

--删除好友数据
function deleteFriendData(datas, uid)
    for i = 1, #datas do
        if datas[i].uid == uid then
            table.remove(datas, i)
            break
        end
    end
end

function setUnReadData(data)
    for i = 1, #UnReadData do
        if UnReadData[i].uid == data.uid then
            UnReadData[i] = data
            return
        end
    end
    table.insert(UnReadData, data)
end

--得到未读数据
function GetUnReadData(uid)
    for i = 1, #UnReadData do
        if UnReadData[i].uid == uid then
            return UnReadData[i]
        end
    end
    return nil
end

function GetContactsDatas(uid)
    for i = 1, #ContactsDatas do
        if ContactsDatas[i].uid == uid then
            return ContactsDatas[i]
        end
    end
    return nil
end

function RequestSearchRole(name)
    local l_msgId = Network.Define.Rpc.RoleSearch
    ---@type RoleSearchArg
    local l_sendInfo = GetProtoBufSendTable("RoleSearchArg")
    l_sendInfo.match_name = name

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSearchRole(msg)
    ---@type RoleSearchRes
    local l_info = ParseProtoBufToTable("RoleSearchRes", msg)

    if l_info.result ~= 0 then
        logError("OnSearchRole error: " .. tostring(l_info.result))
        require "Common.Functions"
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(SearchRoleEvent, l_info.match_role_list)
end

function AddNewMessage()
    local l_mainCtrl = UIMgr:GetUI(UI.CtrlNames.Main)
    if l_mainCtrl and l_mainCtrl:IsShowing() then
        return
    end

    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Community)
    if l_ctrl ~= nil then
        local l_handler = l_ctrl:GetHandlerByName(UI.HandlerNames.Friends)
        if l_handler ~= nil then
            if l_handler.isShowing then
                return
            end
        end
    end

    NewMessageNum = NewMessageNum or 0
    NewMessageNum = NewMessageNum + 1
    ResetNewMessage()
end

function ClearNewMessage(closePanel)
    NewMessageNum = 0
    if closePanel then
        UIMgr:DeActiveUI(UI.CtrlNames.QuickChat)
    end
end

function ResetNewMessage()
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.QuickChat)
    local l_oldShow = l_ctrl and l_ctrl:IsShowing()

    NewMessageNum = NewMessageNum or 0
    local l_show = NewMessageNum > 0
    if l_show then
        local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Main)
        if l_ctrl then
            l_show = false
        end
    end

    if l_show then
        UIMgr:ActiveUI(UI.CtrlNames.QuickChat)
    elseif l_oldShow then
        ClearNewMessage(true)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.QuickChat)
    end
end

function OpenAssistantUrl()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    Common.CommonUIFunc.InvokeFunctionByFuncId(l_openSystemMgr.eSystemId.CapraFaq)
    --干掉红点
    local l_redMgr = MgrMgr:GetMgr("RedSignMgr")
    l_redMgr.DirectUpdateRedSign(eRedSignKey.FriendHelper, 0)
end


--获得卡普拉签名信息
function SendQueryKapulaSign()
    local l_msgId = Network.Define.Rpc.QueryKapulaSign
    ---@type KapulaSignArg
    local l_sendInfo = GetProtoBufSendTable("KapulaSignArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnQueryKapulaSign(msg)
    ---@type KapulaSignRes
    local l_info = ParseProtoBufToTable("KapulaSignRes", msg)

    HelperSign = Lang(l_info.sign)
    EventDispatcher:Dispatch(HelperSignChange)
end

--阅读卡普拉的消息
function SendReadKapulaAssis()
    local l_msgId = Network.Define.Rpc.ReadKapulaAssis
    ---@type ReadKapulaAssisArg
    local l_sendInfo = GetProtoBufSendTable("ReadKapulaAssisArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnReadKapulaAssis(msg)

end

--为什么从2开始访问 因为第一个是Npc问答Npc
function IsFriend(id)
    local l_data = FriendDatas
    if #l_data > 0 then
        for i = 2, #l_data do
            if l_data[i].npcID == nil and
                    tostring(l_data[i].base_info.role_uid) ~= tostring(MPlayerInfo.UID) and
                    tostring(l_data[i].base_info.role_uid) == tostring(id) then
                return true
            end
        end
    end
    return false
end

--为什么从2开始访问 因为第一个是Npc问答Npc
function IsFriendOnline(uid)
    local l_data = FriendDatas
    if #l_data > 0 then
        for i = 2, #l_data do
            if tostring(l_data[i].uid) == tostring(uid) then
                return l_data[i].base_info.status == MemberStatus.MEMBER_NORMAL
            end
        end
    end
    return false
end

function OpenCommunity()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isFriendOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    local l_isEmailOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Email)
    if l_isEmailOpen or l_isFriendOpen then
        UIMgr:ActiveUI(UI.CtrlNames.Community)
    end
end

function OpenFriend()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isFriendOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    if not l_isFriendOpen then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.Community, function(ctrl)
        ctrl:SelectOneHandler(UI.HandlerNames.Friends)
    end)
end

function OpenFriendAndSetUID(uid)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isFriendOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    if not l_isFriendOpen then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.Community, function(ctrl)
        ctrl:SelectOneHandler(UI.HandlerNames.Friends):SetDefSelectFriend(uid)
    end)
end

return ModuleMgr.FriendMgr