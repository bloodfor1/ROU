--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FriendsPanel"
require "UI/Template/FriendsItemTemplate"
--require "UI/Template/FriendChatTemplate"
require "UI/Template/FriendsHelperPrefab"
require "UI/UIBaseHandler"
require "CommonUI/ChatRecordObj"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
FriendsHandler = class("FriendsHandler", super)
--lua class define end
local l_eContactsType = { Contacts = 1, Friend = 2 }
--lua functions
function FriendsHandler:ctor()
    super.ctor(self, HandlerNames.Friends, 0)
end --func end
--next--
function FriendsHandler:Init()
    ---@type FriendsPanel
    self.panel = UI.FriendsPanel.Bind(self)
    super.Init(self)
    self.friendsRelationTitles = MoonClient.MTableAnalysis.GetVectorSequence(TableUtil.GetSocialGlobalTable().GetRowByName("FriendsRelationTitle").Value)
    self.currentFriendData = nil
    self.currentContactsDatas = {}
    self.currentContactsType = nil
    self.isCanChange = true
    self.changeTimer = 0
    self.isOnActive = false
    ---@type ModuleMgr.FriendMgr
    self.Mgr = MgrMgr:GetMgr("FriendMgr")
    self.ShortcutChatMgr = MgrMgr:GetMgr("ShortcutChatMgr")
    self.chatDataMgr = self.Mgr.ChatSqlite
    ---@type ModuleMgr.OpenSystemMgr
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.panel.InputMessage:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        --输入字数限制
        local l_maxLenght = tonumber(TableUtil.GetSocialGlobalTable().GetRowByName("FriendMaxNum").Value)
        if l_maxLenght > 0 then
            --表情代码扩充输入上限,表情代码算两个长度
            local l_expand = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(value);
            if string.ro_len(value) > l_maxLenght + l_expand then
                value = string.ro_cut(value, l_maxLenght + l_expand);
                if LenghtHitTime ~= Time.frameCount then
                    LenghtHitTime = Time.frameCount
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_LIMIT", l_maxLenght))
                end
            end
        end
        self.panel.InputMessage.Input.text = value;
    end, false)

    self.panel.FriendsItemPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.FriendsHelperPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.IntimacyDegreeDeatialPanel:SetActiveEx(false)
    self.panel.IntimacyDegreeDeatialText.LabText = Lang("Friend_IntimacyDegreeDeatialText")
    self.panel.Assistant:SetActiveEx(false)

    self.friendItemTemplatePool = self:NewTemplatePool({
        ScrollRect = self.panel.FriendsScroll.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = function(data)
            if nil == data then
                logError("[FriendsHandler] param got nil:stateInfo:" .. tostring(self:printStateInfo()))
                return UITemplate.FriendsHelperPrefab, self.panel.FriendsHelperPrefab.LuaUIGroup.gameObject
            end

            if data.uid then
                return UITemplate.FriendsItemTemplate, self.panel.FriendsItemPrefab.LuaUIGroup.gameObject
            end
            return UITemplate.FriendsHelperPrefab, self.panel.FriendsHelperPrefab.LuaUIGroup.gameObject
        end,
    })

    self.friendChatTemplatePool = self:NewTemplatePool({
        ScrollRect = self.panel.ChatScroll.LoopScroll,
        PreloadPaths = {},
        GetDatasMethod = function()
            return self:getCurrentChatDatas()
        end,
        GetTemplateAndPrefabMethod = self.Mgr.GetFriendChatPrefabAndClass,
    })
    self.panel.Tog_Friends_RecentChat.TogEx.onValueChanged:AddListener(function(isOn)

        if isOn then
            if self.currentContactsType ~= l_eContactsType.Contacts then
                self:clearSelect()
                self:showRecentChat()
            end
        end
    end)
    self.panel.Tog_Friends_Friend.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            if self.currentContactsType ~= l_eContactsType.Friend then
                self:clearSelect()
                self:showFriend()
            end
        end
    end)
    self.panel.DeletionRecordButton:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, nil, StringEx.Format(Common.Utils.Lang("Friend_DeleteChatText"), Common.Utils.PlayerName(self.currentFriendData.base_info.name)),
                function()
                    self:onDeletionRecordButton()
                end,
                function()
                end)
    end)
    self.panel.BtnSend:AddClick(function()
        self:onBtnSend()
    end)
    self.panel.BtnFace.Listener.onClick = function(obj, eventData)
        if eventData ~= nil and tostring(eventData:GetType()) == "MoonClient.MPointerEventData" and eventData.Tag == CtrlNames.Multitool then
            return
        end
        local l_chatDataMgr = DataMgr:GetData("ChatData")
        --打开标签页签，对话框上移
        local l_toPosition
        l_toPosition = -(MUIManager.UIRoot.transform.sizeDelta.y - 639) / 2 + 200
        local l_Community_ctrl = UIMgr:GetUI(UI.CtrlNames.Community)
        if l_Community_ctrl then
            l_Community_ctrl:ChangePositionY(l_toPosition)
        end
        local l_openPanelParam = {
            channelType = l_chatDataMgr.EChannel.FriendChat,
            needSetPositionMiddle = true,
            inputActionData = {
                inputFunc = function(st)
                    self.panel.InputMessage.Input.text = self.panel.InputMessage.Input.text .. st
                end,
                inputItemFunc = function(item, hrefType)
                    local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr");
                    self.panel.InputMessage.Input.text = l_linkInputMgr.AddInputHref(self.panel.InputMessage.Input.text, item, hrefType)
                end,
                extraData = {
                    fixationPosX = -215,
                    fixationPosY = 116.5,
                },
                inputHrefDirectFunc = function(st)
                    self.panel.InputMessage.Input.text = st
                end,
            },
            deActiveAction = function()
                local l_Community_ctrl = UIMgr:GetUI(UI.CtrlNames.Community)
                if l_Community_ctrl then
                    l_Community_ctrl:ChangePositionY(0)
                end
            end,
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool, l_openPanelParam)
    end
    self.panel.Btn_Friends_AddFriend:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.AddFriends)
    end)
    self.panel.Btn_Friends_Jiapu:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
    end)
    self.panel.Btn_Friends_Jiayuan:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
    end)

    self.panel.ShowIntimacyDegreeDeatialButton:AddClick(function()
        self.panel.IntimacyDegreeDeatialPanel:SetActiveEx(true)
    end)
    self.panel.CloseDegreeDeatialButton:AddClick(function()
        self.panel.IntimacyDegreeDeatialPanel:SetActiveEx(false)
    end)

    self.panel.AudioPanel:SetActiveEx(false)
    self.panel.Btn_Friends_VoiceChat:AddClick(function()
        self.panel.AudioPanel:SetActiveEx(true)
        self.panel.Btn_Friends_VoiceChat:SetActiveEx(false)
        self.panel.BtnSend:SetActiveEx(false)
        self.panel.InputMessage:SetActiveEx(false)
        self.panel.BtnFace:SetActiveEx(false)
    end)
    self.panel.KeyboardBtn:AddClick(function()
        self.panel.AudioPanel:SetActiveEx(false)
        self.panel.Btn_Friends_VoiceChat:SetActiveEx(true)
        self.panel.BtnSend:SetActiveEx(true)
        self.panel.InputMessage:SetActiveEx(true)
        self.panel.BtnFace:SetActiveEx(true)
    end)

    self.RecordObj = UI.ChatRecordObj.new()
    self.RecordObj:Init(self.panel.AudioBtn):SetSendAction(function(audioID, translate, time, channel)
        if self.currentFriendData ~= nil then
            self.Mgr.RequestSendAudioChatMsg(self.currentFriendData.uid, audioID, translate, time)
        end
    end):SetChannel(DataMgr:GetData("ChatData").EChannel.FriendChat)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local AssistIsOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.CapraFaq) and l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Consultation)
    self.panel.AssistantBtn2:SetGray(not AssistIsOpen)
    self.panel.AssistantBtn1:AddClick(function()
        if AssistIsOpen then
            self.Mgr.OpenAssistantUrl()
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("FriendsAssistantTips"))
        end
    end, true)
    self.panel.AssistantBtn2:AddClick(function()
        if AssistIsOpen then
            self.Mgr.OpenAssistantUrl()
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("FriendsAssistantTips"))
        end
    end, true)

    --快捷聊天标签
    self.panel.OnlyWearToggle:SetActiveEx(false)
    self.panel.OnlyWearToggle:AddClick(function()
        if self.currentFriendData and self.currentFriendData.uid then
            if self.panel.OnlyWearToggleLight.gameObject.activeSelf then
                self.ShortcutChatMgr.RemoveFriendTag(self.currentFriendData.uid)
                self.panel.OnlyWearToggleLight:SetActiveEx(false)
            else
                if self.ShortcutChatMgr.AddFriendTag(self.currentFriendData.uid) then
                    self.panel.OnlyWearToggleLight:SetActiveEx(true)
                end
            end
        end
    end, true)

    self.RedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.FriendHelper,
        ClickButton = self.panel.AssistantBtn2,
    })

    self.Mgr.SendQueryKapulaSign()
end --func end
--next--
function FriendsHandler:Uninit()
    self.friendItemTemplatePool = nil
    self.friendChatTemplatePool = nil
    self.currentFriendData = nil
    self.DefSelectFriendID = nil
    self.currentContactsDatas = {}
    if self.RecordObj ~= nil then
        self.RecordObj:Unint()
        self.RecordObj = nil
    end
    self.RedSignProcessor = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FriendsHandler:OnActive()

    self.isOnActive = true

    self.isCanChange = true
    self.changeTimer = 0

    self.Mgr.RequestGetFriendInfo()
    self.Mgr.ClearNewMessage(true)
    self:clearSelect()
    self:refreshChatVoiceState()
end --func end
--next--
function FriendsHandler:OnDeActive()

    self.isOnActive = false

    if self.Mgr ~= nil then
        self.Mgr.CurrentFriendChatDatas = {}
        self.Mgr.CurrentFriendData = nil
    end

    self.currentFriendData = nil

    self.DefSelectFriendID = nil
    self.currentContactsDatas = {}

end --func end
--next--
function FriendsHandler:Update()
    if self.isOnActive then
        if not self.isCanChange then
            self.changeTimer = self.changeTimer + Time.deltaTime
            if self.changeTimer >= self.Mgr.ContactsChangePositionIntervalTime then
                self.isCanChange = true
                self.changeTimer = 0
            end
        end
    end
    if self.RecordObj ~= nil then
        self.RecordObj:Update()
    end
end --func end


--next--
function FriendsHandler:OnReconnected()
    super.OnReconnected(self)
    self:clearSelect()
    self.Mgr.RequestGetFriendInfo()
end --func end
--next--
function FriendsHandler:BindEvents()
    self:AddEvent()
end --func end
--next--
--lua functions end

--lua custom scripts
function FriendsHandler:showRecentChat()
    self.currentContactsType = l_eContactsType.Contacts
    self:showFriendItem(self.currentContactsDatas)
end
function FriendsHandler:showFriend()
    self.currentContactsType = l_eContactsType.Friend
    self:showFriendItem(self.Mgr.FriendDatas)
end
function FriendsHandler:getValidData(datas)
    for i = #datas, 1, -1 do
        if datas[i] == nil then
            logError("[FriendsHandler] find invalid data!")
            table.remove(datas, i)
        end
    end
    return datas
end
---@Description:稳定后删除
function FriendsHandler:printStateInfo()
    local l_contactData
    if self.currentContactsType == l_eContactsType.Contacts then
        l_contactData = self.currentContactsDatas
    else
        l_contactData = self.Mgr.FriendDatas
    end
    local l_contactInfo = " l_contactData~=nil:" .. tostring(l_contactData ~= nil)
    if l_contactData ~= nil then
        l_contactInfo = l_contactInfo .. " maxInfo:" .. tostring(#l_contactData)
        for i = 1, #l_contactData do
            if l_contactData[i] == nil then
                l_contactInfo = l_contactInfo .. " nullIndex:" .. tostring(i)
            end
        end
    end
    local l_stateInfo = " isActive:" .. tostring(self.isActive)
            .. "  self.currentContactsType:" .. tostring(self.currentContactsType)
            .. l_contactInfo
    return l_stateInfo
end
function FriendsHandler:showFriendItem(datas)
    datas = self:getValidData(datas)

    self.Mgr.CurrentSelectFriendIndex = 0
    if #datas == 0 then
        self.panel.NonFriendText.gameObject:SetActiveEx(true)
        self.friendItemTemplatePool:DeActiveAll()
        return
    end

    self.panel.NonFriendText.gameObject:SetActiveEx(false)
    self.friendItemTemplatePool:ShowTemplates({ Datas = datas, Method = function(item)
        self:onFriendItem(item)
    end })

    --默认选中的好友
    if self.DefSelectFriendID ~= nil then
        local l_tem = self.friendItemTemplatePool:FindShowTem(function(a)
            return a.Data.uid == self.DefSelectFriendID
        end)
        if l_tem ~= nil then
            self:onFriendItem(l_tem)
        end
        self.DefSelectFriendID = nil
    end
end
function FriendsHandler:clearSelect()
    self.panel.Friends_Talk_Emty.gameObject:SetActiveEx(true)
    self.panel.Friends_Light.gameObject:SetActiveEx(false)
    self.currentFriendData = nil
    self.panel.Assistant:SetActiveEx(false)
end

function FriendsHandler:onFriendItem(item)
    if self.Mgr.CurrentSelectFriendIndex == item.ShowIndex then
        return
    end
    local l_lastIndex = self.Mgr.CurrentSelectFriendIndex
    self.Mgr.CurrentSelectFriendIndex = item.ShowIndex
    local l_lastTemplate = self.friendItemTemplatePool:GetItem(l_lastIndex)
    if not MLuaCommonHelper.IsNull(l_lastTemplate) then
        self.panel.FriendsScroll.LoopScroll:RefreshCell(l_lastIndex - 1)
    end
    item:showSelect(true)
    --选择小月
    if not item.Data.uid then
        self.panel.Assistant:SetActiveEx(true)
        self.panel.Friends_Light.gameObject:SetActiveEx(false)
        self.panel.Friends_Talk_Emty.gameObject:SetActiveEx(false)
        self.currentFriendData = nil
        return
    end

    self.Mgr.CurrentFriendData = item.Data
    self.currentFriendData = item.Data

    self:ResetFriendInfo()

    local l_DataCount = 0
    local l_squence = 0
    self.Mgr.CurrentFriendChatDatas = {}
    if self.chatDataMgr ~= nil then
        self.chatDataMgr:CreateTable(tostring(self.currentFriendData.uid))
        local l_chatDatas = self.chatDataMgr:GetDatas()
        l_DataCount = l_chatDatas.Count

        for i = 0, l_DataCount - 1 do
            l_chatDatas[i].audioPlayOver = true
            table.insert(self.Mgr.CurrentFriendChatDatas, l_chatDatas[i])
        end

        if l_DataCount > 0 then
            self:sortChatData(self.Mgr.CurrentFriendChatDatas)
            l_squence = self.Mgr.CurrentFriendChatDatas[l_DataCount].chatSquence
        end
    end

    self.Mgr.RequestReadPrivateMessage(self.currentFriendData.uid, l_squence)
    self.friendChatTemplatePool:ShowTemplates({ StartScrollIndex = #self.Mgr.CurrentFriendChatDatas })
end

function FriendsHandler:SetDefSelectFriend(rid)
    self.DefSelectFriendID = rid
end

function FriendsHandler:getCurrentChatDatas()
    return self.Mgr.CurrentFriendChatDatas
end

function FriendsHandler:ResetFriendInfo()
    if self.currentFriendData == nil then
        self.panel.FriendText.LabText = ""
        self.panel.IntimacyDegree.LabText = ""
        return
    end
    local l_friendData = self.Mgr.GetContactsData(self.currentFriendData.uid)
    self.currentFriendData = l_friendData or self.currentFriendData
    self.panel.Assistant:SetActiveEx(false)
    self.panel.Friends_Talk_Emty.gameObject:SetActiveEx(false)
    self.panel.Friends_Light.gameObject:SetActiveEx(true)

    --好友度
    local l_intimacy_degree = self.currentFriendData.intimacy_degree or 0
    self.panel.IntimacyDegree.LabText = tostring(l_intimacy_degree)

    --普通好友
    if self.currentFriendData.friend_type == 1 then
        local l_friendsRelationTitle
        local l_currentShow
        for i = 1, self.friendsRelationTitles.Length do
            l_friendsRelationTitle = self.friendsRelationTitles[i - 1]
            if l_friendsRelationTitle.Length ~= 2 then
                logError("SocialGlobalTable中FriendsRelationTitle字段配的不对")
                return
            end
            if tonumber(l_friendsRelationTitle[0]) >= self.currentFriendData.intimacy_degree then
                l_currentShow = l_friendsRelationTitle
                break
            end
        end
        if l_currentShow == nil then
            l_currentShow = self.friendsRelationTitles[self.friendsRelationTitles.Length - 1]
        end
        self.panel.FriendText.LabText = Lang(l_currentShow[1])
    elseif self.currentFriendData.friend_type == 3 then
        self.panel.FriendText.LabText = Lang("Friend_StrangerText")
    end

    self:ShowQuickTag()
end

--刷新聊天快捷键按钮
function FriendsHandler:ShowQuickTag()
    local l_showTag = self.currentFriendData and self.currentFriendData.uid
            and self.currentFriendData.intimacy_degree and self.currentFriendData.intimacy_degree >= self.ShortcutChatMgr.FriendIntimacyDegree
    self.panel.OnlyWearToggle:SetActiveEx(l_showTag)
    if l_showTag then
        self.panel.OnlyWearToggleLight:SetActiveEx(self.ShortcutChatMgr.ContainsFriend(self.currentFriendData.uid) and true)
    end
end


--删除聊天记录
function FriendsHandler:onDeletionRecordButton()
    if self.chatDataMgr ~= nil then
        self.chatDataMgr:DeleteDatas()
        self.friendChatTemplatePool:DeActiveAll()
        self.Mgr.CurrentFriendChatDatas = {}

        --发送协议通知服务器
        if self.currentFriendData ~= nil then
            self.Mgr.RequestDeleteRecord(self.currentFriendData.uid)
        end
    end
end
function FriendsHandler:onBtnSend()
    if self.currentFriendData == nil then
        return
    end
    --初心者没改名不允许发言
    if MPlayerInfo.ChangeNameCount <= 0 then
        --登记姓名后才可以发送消息哦，先去找斯普拉琪吧~
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PrivateChat_Name_Astrict"))
        return
    end
    --你开启了n级以下陌生人消息过滤，无法发送消息给此人
    if MgrMgr:GetMgr("SettingMgr").GetIsPrivateChatLevel() then
        local l_contact = self.Mgr.GetContactsDatas(self.currentFriendData.uid)
        local l_level = DataMgr:GetData("ChatData").GetPrivateChatFilterLevel()
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
    local l_content = self.panel.InputMessage.Input.text
    if string.ro_isEmpty(l_content) then
        return
    end
    local l_content, l_params = MgrMgr:GetMgr("LinkInputMgr").ReplaceSendMsg(l_content)

    self.Mgr.RequestSendPrivateChatMsg(self.currentFriendData.uid, l_content, l_params)
    self.panel.InputMessage.Input.text = ""
end

function FriendsHandler:getChatData(data)
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
    l_chatData.extra_param = MgrMgr:GetMgr("LinkInputMgr").PackToString(data.extra_param)
    if l_chatData.chatType == ChatMediumType.ChatMediumTypeAudio then
        l_chatData.content = l_chatData.audioText
    end
    return l_chatData
end

function FriendsHandler:sortChatData(chatDatas)
    table.sort(chatDatas, function(a, b)
        return a.chatSquence < b.chatSquence
    end)
end

function FriendsHandler:isContainContactsData(ContactsDatas, uid)
    for i = 1, #ContactsDatas do
        if ContactsDatas[i].uid == uid then
            return true
        end
    end
    return false
end

function FriendsHandler:AddEvent()
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.ResetFriendInfoEvent, self.onResetInfo)
    --收到一条聊天信息
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.ReceivePrivateChatEvent, self.onPrivateChatMsg)
    --收到历史记录聊天信息
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.GetRecordChatDatasEvent, self.onChatRecordGet)
    --好友度改变
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.IntimacyDegreeChangeEvent, self.onIntimacyChanged)
    --删除好友数据
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.ChangeFriendDataEvent, self.onDeleteFriendData)
    --更新联系人数据
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.UpdateContactData, self.onUpdateContactData)
    --添加好友
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.AddFriendEvent, self.onAddFriendEvent)
    --联系人改变上线状态
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.ChangeOnlineEvent, self.onOnlineEventChanged)
    --卡普拉助手签名改变
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.HelperSignChange, self.onHelperSignChange)
    self:BindEvent(self.openMgr.EventDispatcher, self.openMgr.OpenSystemUpdate, function(self)
        self:refreshChatVoiceState()
    end)
end

function FriendsHandler:onResetInfo()
    table.sort(self.Mgr.UnReadData, function(a, b)
        return a.last_chat_time > b.last_chat_time
    end)

    self.currentContactsDatas = { { npcID = self.Mgr.HelperNpcID } }
    for i = 1, #self.Mgr.UnReadData do
        local l_contactsData = self.Mgr.GetContactsData(self.Mgr.UnReadData[i].uid)
        if l_contactsData ~= nil then
            table.insert(self.currentContactsDatas, l_contactsData)
        end
    end

    if self.panel.Tog_Friends_RecentChat.TogEx.isOn then
        self.currentContactsType = nil
        self:clearSelect()
        self:showRecentChat()
    else
        self.panel.Tog_Friends_RecentChat.TogEx.isOn = true
    end
end

function FriendsHandler:onPrivateChatMsg(data)
    local l_currentDataChatUid = data.chat_uid

    if self.currentFriendData ~= nil then
        if self.currentFriendData.uid == l_currentDataChatUid then
            local l_chatData = self:getChatData(data)
            if self.chatDataMgr ~= nil then
                self.chatDataMgr:SaveData(l_chatData)
            end
            table.insert(self.Mgr.CurrentFriendChatDatas, l_chatData)
            self.friendChatTemplatePool:AddTemplate()
            self.panel.ChatScroll.LoopScroll:ScrollToCell(#self.Mgr.CurrentFriendChatDatas - 1, 2000)
            self.Mgr.RequestReadPrivateMessage(self.currentFriendData.uid, l_chatData.chatSquence)
        end
    end

    --得到一个聊天数据的时候会对联系人的位置进行调整
    if self.isCanChange then
        local l_currentChatContactsData
        local l_needChange = true
        local l_oldCount = #self.currentContactsDatas
        for i = 1, #self.currentContactsDatas do
            local l_tempContactsData = self.currentContactsDatas[i]
            if l_tempContactsData ~= nil then
                if l_tempContactsData.uid == l_currentDataChatUid then
                    --当此聊天信息的联系人本来就是第二个的时候不调整,第一位固定为卡普拉助手
                    if i == 2 then
                        l_needChange = false
                        break
                    end
                    l_currentChatContactsData = l_tempContactsData
                    table.remove(self.currentContactsDatas, i)
                    break
                end
            end
        end
        if l_needChange then
            if l_currentChatContactsData == nil then
                l_currentChatContactsData = self.Mgr.GetContactsData(l_currentDataChatUid)
            end
            if l_currentChatContactsData ~= nil then
                --第一位固定为卡普拉助手
                table.insert(self.currentContactsDatas, 2, l_currentChatContactsData)
            end


            --当在最近聊天页的时候才进行交换
            if self.currentContactsType == l_eContactsType.Contacts then
                if self.currentFriendData ~= nil then
                    for i = 1, #self.currentContactsDatas do
                        local l_tempContactsData = self.currentContactsDatas[i]
                        if l_tempContactsData ~= nil then
                            if l_tempContactsData.uid == self.currentFriendData.uid then
                                self.Mgr.CurrentSelectFriendIndex = i
                                break
                            end
                        end
                    end

                end

                --重新显示相应的数据
                for i = l_oldCount + 1, #self.currentContactsDatas do
                    self.panel.FriendsScroll.LoopScroll:AddCell()
                end
                self.panel.FriendsScroll.LoopScroll:RefreshCells()
                --如果现在是选中好友的状态，则进行相应的显示
            end
            self.isCanChange = false
        end
    end

    for i = 1, #self.currentContactsDatas do
        local l_data = self.currentContactsDatas[i]
        if nil ~= l_data then
            local l_itemUid = l_data.uid
            --相应的item显示红点
            if l_itemUid == l_currentDataChatUid then
                if self.currentFriendData == nil or l_itemUid ~= self.currentFriendData.uid then
                    local l_item = self.friendItemTemplatePool:GetItem(i)
                    if l_item ~= nil then
                        l_item:showChatPrompt(true)
                    end
                end
            end
        end
    end
end

function FriendsHandler:onChatRecordGet(datas)
    if #datas == 0 then
        return
    end

    local l_currentDataChatUid = datas[1].chat_uid
    if self.currentFriendData ~= nil then
        if self.currentFriendData.uid == l_currentDataChatUid then
            local l_chatDatas = {}
            for i = 1, #datas do
                local l_chatData = self:getChatData(datas[i])
                if self.chatDataMgr ~= nil then
                    self.chatDataMgr:SaveData(l_chatData)
                end
                table.insert(l_chatDatas, l_chatData)
            end

            self:sortChatData(l_chatDatas)
            for i = 1, #l_chatDatas do
                table.insert(self.Mgr.CurrentFriendChatDatas, l_chatDatas[i])
                self.friendChatTemplatePool:AddTemplate()
                self.panel.ChatScroll.LoopScroll:ScrollToCell(#self.Mgr.CurrentFriendChatDatas - 1, 2000)
            end
        end
    end
end

function FriendsHandler:onIntimacyChanged(data)
    self:ResetFriendInfo()
end

function FriendsHandler:onDeleteFriendData(data)
    if self.currentContactsType == l_eContactsType.Friend then
        self:clearSelect()
        self:showFriend()
    elseif self.Mgr.CurrentFriendData then
        if self.Mgr.CurrentFriendData.uid == data.uid then
            self.panel.FriendText.LabText = Common.Utils.Lang("Friend_StrangerText")
        end
    end
end

function FriendsHandler:onUpdateContactData(data)
    for i = 1, #self.currentContactsDatas do
        local l_tempContactsDatas = self.currentContactsDatas[i]
        if l_tempContactsDatas ~= nil then
            if l_tempContactsDatas.uid == data.uid then
                self.currentContactsDatas[i] = data
                if self.currentFriendData and self.currentFriendData.uid == data.uid then
                    self:ResetFriendInfo()
                end
                break
            end
        end
    end
end

function FriendsHandler:onAddFriendEvent(uid)
    if self.currentFriendData and self.currentFriendData.uid == uid then
        self:ResetFriendInfo()
    elseif self.currentContactsType == l_eContactsType.Friend then
        self:clearSelect()
        self:showFriend()
    elseif self.currentContactsType == l_eContactsType.Contacts then
        self:clearSelect()
        self:showRecentChat()
    end
end

function FriendsHandler:onOnlineEventChanged()
    self.friendItemTemplatePool:RefreshCells()
end

function FriendsHandler:onHelperSignChange()
    local l_tem = self.friendItemTemplatePool:FindShowTem(function(a)
        return not a.uid
    end)
    if l_tem then
        l_tem:SetData(l_tem.Data)
    end
end
function FriendsHandler:refreshChatVoiceState()
    local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)
    self.panel.Btn_Friends_VoiceChat:SetActiveEx(l_chatVoiceOpen)

    local l_inputSize = self.panel.InputMessage.RectTransform.rect.size
    l_inputSize.x = self.panel.Panel_Input.RectTransform.rect.size.x
    if l_chatVoiceOpen then
        l_inputSize.x = l_inputSize.x - self.panel.Btn_Friends_VoiceChat.RectTransform.rect.size.x
    end
    self.panel.InputMessage.RectTransform.sizeDelta = l_inputSize
end
--lua custom scripts end

return FriendsHandler
