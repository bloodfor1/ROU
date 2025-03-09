require "UI/BaseUITemplate"
require "UI/Template/ShortcutChatPrefab"

module("UITemplate", package.seeall)

local super = UITemplate.ShortcutChatPrefab
ShortcutFriendPrefab = class("ShortcutFriendPrefab", super)

function ShortcutFriendPrefab:OnSetData(data)
    self.chatDataMgr = MgrMgr:GetMgr("FriendMgr").GetChatSqlite()
    self.chatDataMgr:CreateTable(tostring(data.uid))
    super.OnSetData(self, data)
end

function ShortcutFriendPrefab:OnDestroy()
    if self.recordObj ~= nil then
        self.recordObj:Unint()
        self.recordObj = nil
    end

    self.chatTemsPool = nil
end

---------------------------------------
function ShortcutFriendPrefab:ResetShow()
    self.Parameter.Main:SetActiveEx(not self.Data.mini)
    self.Parameter.Mini:SetActiveEx(self.Data.mini)
    self.WaitRecordTime = nil
    self.recordObj:OnUp(obj, data)

    local l_playerName = self.Data.friendInfo and Common.Utils.PlayerName(self.Data.friendInfo.base_info.name) or "?"

    ------------------缩小模式
    if self.Data.mini then
        self.Parameter.Channel:SetActiveEx(false)
        self.Parameter.Friend:SetActiveEx(true)
        self.chatTemsPool:ShowTemplates({ Datas = {} })
        local l_unReadData = self.friendMgr.GetUnReadData(self.Data.uid)
        self.Parameter.FriendLight:SetActiveEx(l_unReadData and l_unReadData.count > 0)

        if string.ro_len(l_playerName) > self.mgr.MiniNameLenght then
            l_playerName = string.ro_cut(l_playerName, self.mgr.MiniNameLenght)
            l_playerName = l_playerName .. ".."
        end
        self.Parameter.FriendText.LabText = l_playerName
        -- 留个注释，这个是为了解决切换场景闪的问题的，直接把特效干掉了
        -- 如果后期确认要启用这个特效再给他加回来
        --self.Parameter.FriendFinish:SetActiveEx(true)
        --self.Parameter.FriendFinish.FxAnim:PlayAll()
        return
    end

    -----------------放大模式
    --标题
    self.Parameter.Title.LabText = l_playerName

    self:showChatMsg(true)

    self.Parameter.FriendLight:SetActiveEx(false)
    self.Parameter.FriendFinish:SetActiveEx(false)
end
function ShortcutFriendPrefab:showChatMsg(needRequestPrivateMsg)
    local l_chatMsgNum =0
    --列出所有消息
    local l_msgs = {}
    local l_chatDatas = self.chatDataMgr:GetDatas()
    for i = 0, l_chatDatas.Count - 1 do
        local l_data = l_chatDatas[i]
        l_data.audioPlayOver = true
        l_msgs[#l_msgs + 1] = self:creatFriendMsg(l_data)
    end
    table.sort(l_msgs, function(a, b)
        return a.FriendData.chatSquence < b.FriendData.chatSquence
    end)

    if needRequestPrivateMsg then
        if l_chatMsgNum > 0 then
            self.notFindPrivateMsgOnOpen = false
            --已读最后一条
            self.friendMgr.RequestReadPrivateMessage(self.Data.uid, l_msgs[#l_msgs].FriendData.chatSquence)
        else
            self.notFindPrivateMsgOnOpen = true
            self.friendMgr.RequestReadPrivateMessage(self.Data.uid, 0)
        end
    end

    l_chatMsgNum = #l_msgs
    if l_chatMsgNum > 0 then
        for i = l_chatMsgNum, 1, -1 do
            local l_timeMsg = self:tryCreatTimeMsg(l_msgs, i)
            if l_timeMsg then
                table.insert(l_msgs, i, l_timeMsg)
            end
        end
    end

    self.chatTemsPool:ShowTemplates({ Datas = l_msgs, StartScrollIndex = #l_msgs })
end
function ShortcutFriendPrefab:onInitOver()
    self.recordObj = self.recordObj or UI.ChatRecordObj.new()
    self.recordObj:Init(self.Parameter.AudioBtn):SetChannel(self.chatDataLuaMgr.EChannel.FriendChat)
        :SetSendAction(function(audioID, translate, time, channel)
        if self.Data and self.Data.uid then
            self.friendMgr.RequestSendAudioChatMsg(self.Data.uid, audioID, translate, time)
        end
    end):SetOnDown(function()
        self:lastSibling()
    end)

    self.chatTemsPool = self.chatTemsPool or self:NewTemplatePool({
        ScrollRect = self.Parameter.ChatScroll.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = self.chatDataLuaMgr.GetChannelLineTemInfo,
    })
end

--next--
function ShortcutFriendPrefab:BindEvents()
    super.BindEvents(self)
    --收到一批新消息
    self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.GetRecordChatDatasEvent, function(self, datas)
        if not UIMgr:IsActiveUI(UI.CtrlNames.ShortcutChat) then
            return
        end
        if #datas == 0 or datas[1].chat_uid ~= self.Data.uid then
            return
        end
        table.sort(datas, function(a, b)
            return a.squence < b.squence
        end)
        if self.Data.mini then
            self.Parameter.FriendLight:SetActiveEx(true)
            return
        end

        for i = 1, #datas do
            local l_chatData = self:creatSaveData(datas[i])
            local l_msgPake = self:creatFriendMsg(l_chatData)
            local l_timePake = self:tryCreatTimeMsg(self.chatTemsPool.Datas, #self.chatTemsPool.Datas + i, l_msgPake)
            self.chatDataMgr:SaveData(l_chatData)
            if l_timePake then
                self.chatTemsPool:AddTemplate(l_timePake)
            end
            self.chatTemsPool:AddTemplate(l_msgPake)
            self.Parameter.ChatScroll.LoopScroll:ScrollToCell(#self.chatTemsPool.Datas - 1, 2000)
            if i == #datas then
                self.friendMgr.RequestReadPrivateMessage(self.Data.uid, l_chatData.chatSquence)
            end
        end
    end)

    --收到好友已读已读
    self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.ReadMessage, function(self, uid)
        if self.Data.uid == uid then
            local l_unReadData = self.friendMgr.GetUnReadData(self.Data.uid)
            self.Parameter.FriendLight:SetActiveEx(l_unReadData and l_unReadData.count > 0)
        end
    end)

    
    --接受到一条新消息
    self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.ReceivePrivateChatEvent, function(self, data)
        if not UIMgr:IsActiveUI(UI.CtrlNames.ShortcutChat) then
            return
        end
        if data.chat_uid ~= self.Data.uid then
            return
        end
        if self.Data.mini then
            self.Parameter.FriendLight:SetActiveEx(true)
            return
        end
        local l_chatData = self:creatSaveData(data)
        local l_msgPake = self:creatFriendMsg(l_chatData)
        local l_timePake = self:tryCreatTimeMsg(self.chatTemsPool.Datas, #self.chatTemsPool.Datas + 1, l_msgPake)
        self.chatDataMgr:SaveData(l_chatData)
        if l_timePake then
            self.chatTemsPool:AddTemplate(l_timePake)
        end
        self.chatTemsPool:AddTemplate(l_msgPake)
        self.Parameter.ChatScroll.LoopScroll:ScrollToCell(#self.chatTemsPool.Datas - 1, 2000)
        self.friendMgr.RequestReadPrivateMessage(self.Data.uid, l_chatData.chatSquence)
    end)
end --func end

function ShortcutFriendPrefab:onCancelBtn()
    if self.mgr.RemoveData(self.Data.uid, self.Data.channel) then
        self.mgr.RemoveFriendTag(self.Data.uid)
    end
end

function ShortcutFriendPrefab:onSendBtn()
    self:lastSibling()
    --初心者没改名不允许发言
    if MPlayerInfo.ChangeNameCount <= 0 then
        --登记姓名后才可以发送消息哦，先去找斯普拉琪吧~
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PrivateChat_Name_Astrict"))
        return
    end
    --你开启了n级以下陌生人消息过滤，无法发送消息给此人
    if MgrMgr:GetMgr("SettingMgr").GetIsPrivateChatLevel() then
        local l_contact = self.friendMgr.GetContactsDatas(self.Data.uid)
        local l_level = self.chatDataLuaMgr.GetPrivateChatFilterLevel()
        if l_contact ~= nil then
            if l_contact.friend_type == FriendType.TYPE_CONTACT then
                if l_contact.base_info.base_level <= l_level then
                    --你开启了%d级以下陌生人消息过滤，无法发送消息给此人
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PrivateChat_Level_Astrict", l_level))
                    return
                end
            end
        end
    end

    local l_content = self.Parameter.InputMessage.Input.text
    if string.ro_isEmpty(l_content) then
        return
    end
    local l_content, l_params = self.linkInputMgr.ReplaceSendMsg(l_content)
    self.friendMgr.RequestSendPrivateChatMsg(self.Data.uid, l_content, l_params)
    self.Parameter.InputMessage.Input.text = ""
end

function ShortcutFriendPrefab:creatFriendMsg(data)
    local l_msgPage = {}
    l_msgPage.FriendData = data
    l_msgPage.FriendInfo = self.Data.friendInfo
    l_msgPage.channel = self.chatDataLuaMgr.EChannel.FriendChat
    l_msgPage.Param = self.linkInputMgr.StringToPack(data.extra_param)
    l_msgPage.content = data.content

    --语音包 ChatMediumTypeAudio=2
    if l_msgPage.FriendData.chatType == ChatMediumType.ChatMediumTypeAudio then
        l_msgPage.AudioObj = {
            ID = data.audioID,
            Text = data.audioText,
            Duration = data.audioDuration,
            PlayOver = data.audioPlayOver,
        }
    end

    if l_msgPage.FriendData.whoChat == 1 or l_msgPage.FriendData.whoChat == 3 then
        l_msgPage.lineType = self.chatDataLuaMgr.EChatPrefabType.Self
        l_msgPage.WarningTag = l_msgPage.FriendData.whoChat == 3
    elseif l_msgPage.FriendData.whoChat == 2 or l_msgPage.FriendData.contentID == 64001 then
        l_msgPage.lineType = self.chatDataLuaMgr.EChatPrefabType.Other
        l_msgPage.playerInfo = MgrMgr:GetMgr("PlayerInfoMgr").CreatMemberData(self.Data.friendInfo.base_info)
        if l_msgPage.FriendData.contentID == 64001 then
            --对方邀请添加好友的链接？
            local l_row = TableUtil.GetMessageTable().GetRowByID(l_msgPage.FriendData.contentID, true)
            if l_row then
                local l_text = self.Data.friendInfo.friend_type == 1 and Lang("Friend_AddedText") or StringEx.Format(" <a href=AddFriend>{0}</a>", Common.Utils.Lang("Friend_AddFriendText"))
                l_msgPage.content = StringEx.Format(l_row.Content, l_msgPage.playerInfo.name, l_text)
            end
        end
    elseif l_msgPage.FriendData.chatType == 0 then
        l_msgPage.lineType = self.chatDataLuaMgr.EChatPrefabType.Box
        l_msgPage.uid = self.Data.uid
    end
    return l_msgPage
end

function ShortcutFriendPrefab:creatSaveData(data)
    local l_chatData = MoonClient.ChatDataMgr.ChatData.New()
    l_chatData.chatUid = data.chat_uid
    l_chatData.content = data.content
    l_chatData.chatTime = data.chat_time
    l_chatData.chatType = data.chat_type
    l_chatData.contentID = data.id
    l_chatData.whoChat = data.who_type
    l_chatData.chatSquence = data.squence
    l_chatData.audioID = data.audio.audio_id
    l_chatData.audioText = data.audio.text
    l_chatData.audioDuration = data.audio.duration
    l_chatData.audioPlayOver = false
    l_chatData.extra_param = self.linkInputMgr.PackToString(data.extra_param)
    if l_chatData.chatType == ChatMediumType.ChatMediumTypeAudio then
        l_chatData.content = l_chatData.audioText
    end
    return l_chatData
end

function ShortcutFriendPrefab:tryCreatTimeMsg(dataLis, curIndex, curData)
    if not dataLis then
        return
    end
    if curData==nil and #dataLis<0 then
        return
    end
    curData = curData or dataLis[curIndex]
    if curIndex == 1 then
        return self:creatTimeMsg(curData)
    else
        local l_lastData = dataLis[curIndex - 1]
        if l_lastData and curData and l_lastData.FriendData and curData.FriendData then
            if curData.FriendData.chatTime - l_lastData.FriendData.chatTime > self.friendMgr.FriendChatIntervalTime then
                return self:creatTimeMsg(curData)
            end
        end
    end
end

function ShortcutFriendPrefab:creatTimeMsg(data)
    if not data then
        return
    end
    local l_msgPage = {}
    l_msgPage.channel = self.chatDataLuaMgr.EChannel.FriendChat
    l_msgPage.lineType = self.chatDataLuaMgr.EChatPrefabType.Time

    l_msgPage.time = data.FriendData and data.FriendData.chatTime or data.chatTime
    l_msgPage.time = l_msgPage.time or data.chat_time
    return l_msgPage
end
return ShortcutFriendPrefab