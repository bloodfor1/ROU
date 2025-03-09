--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChatPanel"
require "UI/Template/ChatHistoryPrefab"
require "UI/Template/ChatHintChatLinePrefab"
require "UI/Template/ChatOtherChatLinePrefab"
require "UI/Template/ChatPlayerChatLinePrefab"
require "UI/Template/ChatSystemChatLinePrefab"
require "UI/Template/ChatLineRedEnvelopeOther"
require "UI/Template/ChatLineRedEnvelopeSelf"
require "UI/Template/ChatLineStickerShareSelf"
require "UI/Template/ChatLineStickerShareOther"
require "CommonUI/ChatRecordObj"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ChatCtrl = class("ChatCtrl", super)
--lua class define end

--lua functions
function ChatCtrl:ctor()
    super.ctor(self, CtrlNames.Chat, UILayer.Function, UITweenType.Right, ActiveType.None)
    self.cacheGrade = EUICacheLv.VeryLow
    self.basePanelTweenDelta = 512
    self.chatContentPool = nil
end --func end
--next--
function ChatCtrl:Init()
    self.isLockPos = self.isLockPos or false --是否锁定位置
    self.panel = UI.ChatPanel.Bind(self)
    super.Init(self)
    self:initBaseInfo()
    self:initSenderPanel()
    
end --func end
--next--
function ChatCtrl:Uninit()
    if self.recordObj ~= nil then
        self.recordObj:Unint()
        self.recordObj = nil
    end

    self.chatContentPool = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ChatCtrl:OnActive()
    
    self:initChannelToggleGroup()
    --监听聊天事件
    self.panel.InputMessage.Input.text = self.lastMsg or ""
    local l_needChangeToCurrentChannel=false
    local l_changeToChannel=self.last_currentChannel
    if self.uiPanelData~=nil then
        l_needChangeToCurrentChannel= self.uiPanelData.needChangeToCurrentChannel
        if self.uiPanelData.changeToChannel~=nil then
            l_changeToChannel=self.uiPanelData.changeToChannel
        end
    end
    if self.mgr.currentChannel==nil or l_needChangeToCurrentChannel then
        self:toggleCurrentChannel(l_changeToChannel)
    end
    
    self:resetChatRoom()
    self:refreshChatBtnState()
end --func end
--next--
function ChatCtrl:OnDeActive()
    if UIMgr:IsActiveUI(CtrlNames.MainChat) then
        UIMgr:ShowUI(CtrlNames.MainChat)
    else
        if game:IsLogout()==false then
            UIMgr:ActiveUI(CtrlNames.MainChat)
        end
    end

    self:clearMsgPack()
    self.last_currentChannel = self.mgr.currentChannel
    self.mgr.currentChannel = nil
    self.lastMsg = self.panel.InputMessage.Input.text
    -- 打开
    UIMgr:DeActiveUI(CtrlNames.Multitool)
    self:ReleaseData()
end --func end
--next--
function ChatCtrl:Update()
    if self.recordObj ~= nil then
        self.recordObj:Update()
    end

    if self.panel~=nil then
        if self.panel.NewMessageHint.gameObject.activeSelf then
            if not self.panel.ChatLineGroup.LoopScroll.Moveing then
                if self:canMoveDown() then
                    self.panel.NewMessageHint:SetActiveEx(false)
                    self:updateDialogPosition()
                end
            end
        end
        --置顶消息倒计时处理
        if self.ShowZD then
            self.panel.TopMsgLeftTime.LabText = Lang("TIMESHOW_S",math.ceil(self.mgr.chatNewsZdTable[self.mgr.currentChannel].zdNewsTimer.time))
        end
    end
end --func end

--next--
function ChatCtrl:OnLogout()
    self:clearSetting()

end --func end
--next--
function ChatCtrl:BindEvents()

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher,l_logoutMgr.OnLogoutEvent, self.OnLogout)

    self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg, function(self, msg)
        self:onNewChatMsg(msg)
    end)
    --已经存在的信息显示
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.ClearChannelChat, function(self,channel)
        if channel == self.mgr.currentChannel then
            self:toggleCurrentChannel(channel)
        end
    end)
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.Modification, function(self,msgPack)
        local l_tem = self.chatContentPool:FindShowTem(function(tem)
            return msgPack == tem.msgPack
        end)
        if l_tem then
            l_tem:SetData(msgPack)
        end
    end)
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.ClearChatPanelSetting, function(self)
        self:clearSetting()
    end)
    self:BindEvent(self.openMgr.EventDispatcher,self.openMgr.OpenSystemUpdate, function(self)
        self:resetChatRoom()
        self:refreshChatBtnState()
    end)
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.ECloseZDNews, function(self)
        self:ShowZDNews()
    end)
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.UpdateForbidPlayerInfo, function(self)
        self:onForbidPlayerInfosUpdate(true,nil,nil)
    end)
    self:BindEvent(self.mgr.EventDispatcher,self.dataMgr.EEventType.GetForbidPlayerInfoList, function(self,playerUid,isAdd)
        self:onForbidPlayerInfosUpdate(false,playerUid,isAdd)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--region--------------------------------左侧频道Toggle------------------------------

function ChatCtrl:initChannelToggleGroup()

    self.l_toggleGroup = {}
    local EChannel = self.dataMgr.EChannel
    self.l_toggleGroup[EChannel.WorldChat] = self.panel.TogWorld
    self.l_toggleGroup[EChannel.TeamChat] = self.panel.TogTeam
    self.l_toggleGroup[EChannel.GuildChat] = self.panel.TogGuild
    self.l_toggleGroup[EChannel.CurSceneChat] = self.panel.TogNearBy
    self.l_toggleGroup[EChannel.SystemChat] = self.panel.TogSystem

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        self.l_toggleGroup[EChannel.WatchChat] = self.panel.TogWatch
        self.panel.TogWatch.gameObject:SetActiveEx(true)
    else
        self.panel.TogWatch.gameObject:SetActiveEx(false)
    end

    self.panel.ChatSenderPanel.gameObject:SetActiveEx(true)
    self.panel.AudioPanel.gameObject:SetActiveEx(false)
    self.audioInputModel = false
    for currentType,currentTog in pairs(self.l_toggleGroup) do
        currentTog:OnToggleChanged(function(on)
            if on then
                self.panel.ChatLineGroup.LoopScroll:StopScroll()
                self.mgr.currentChannel = currentType
                self:changeCurrentChannel(currentType)
                currentTog.transform:Find("Background/Checkmark").gameObject:SetActiveEx(true)
                if currentType == EChannel.SystemChat then
                    self.panel.ChatSenderPanel.gameObject:SetActiveEx(false)
                    self.panel.AudioPanel.gameObject:SetActiveEx(false)
                else
                    self.panel.ChatSenderPanel.gameObject:SetActiveEx(not self.audioInputModel)
                    self.panel.AudioPanel.gameObject:SetActiveEx(self.audioInputModel)
                end
                self:ShowZDNews()
            else
                currentTog.transform:Find("Background/Checkmark").gameObject:SetActiveEx(false)
            end
        end)
    end

    --默认聊天页面
    local l_defChannel = self.currentChannel or EChannel.WorldChat
    --self:toggleCurrentChannel(l_defChannel)
    for currentType,currentTog in pairs(self.l_toggleGroup) do
        if currentType == l_defChannel then
            currentTog.Tog.isOn = false
            currentTog.Tog.isOn = true
        else
            currentTog.Tog.isOn = true
            currentTog.Tog.isOn = false
        end
    end
end

function ChatCtrl:toggleCurrentChannel(channelType)
    channelType = (channelType or self.last_currentChannel) or self.dataMgr.EChannel.WorldChat
    local l_tog = self.l_toggleGroup[channelType]
    if l_tog~=nil then
        l_tog.Tog.isOn = false
        l_tog.Tog.isOn = true
    end
end

--切换当前频道
function ChatCtrl:changeCurrentChannel(channelType)
    self:clearMsgPack()

    local l_cacheQueue = self.dataMgr.GetFilterChannelCache(channelType)

    if l_cacheQueue ~= nil then
        local l_cacheTable = l_cacheQueue:enumerate()
        local l_msgs={}
        local l_classNames={}
        local l_prefabs={}
        for _,msg in pairs(l_cacheTable) do
            local l_class,l_prefab = self:getMsgTemInfo(msg)
            if l_class~=nil and l_prefab~=nil then
                table.insert(l_msgs,msg)
            end
        end
        --self.chatContentPool:ShowTemplates(l_msgs,l_classNames,l_prefabs,#l_msgs)
        self.chatContentPool:ShowTemplates({Datas=l_msgs,StartScrollIndex=#l_msgs})
    end

    self.panel.NewMessageHint:SetActiveEx(false)
    self.recordObj:SetChannel(channelType)
end

--endregion---------------------------------左侧频道Toggle结束--------------------------

--region---------------------------------对话栏-------------------------------------
function ChatCtrl:updateDialogPosition()
    if not self.panel.ChatLineGroup.gameObject.activeInHierarchy then
        return
    end

    -- self.panel.ChatLineGroup.LoopScroll:MoveToDown()
    self.panel.ChatLineGroup.LoopScroll:ScrollToCell(#self.chatContentPool.Datas-1,2000)
end
--endregion---------------------------------对话栏-------------------------------------

--region---------------------------------下侧发送框---------------------------------
function ChatCtrl:initBaseInfo()
    self.mgr = MgrMgr:GetMgr("ChatMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.dataMgr = DataMgr:GetData("ChatData")
    self.chatContentPool = self:NewTemplatePool({
        ScrollRect = self.panel.ChatLineGroup.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = handler(self,self.getMsgTemInfo),
    })
    self.panel.BtnClose:AddClick(function()
        UIMgr:ShowUI(CtrlNames.MainChat)
        GlobalEventBus:Dispatch(EventConst.Names.ShowMainChatCtrl)
        UIMgr:DeActiveUI(UI.CtrlNames.Chat)
    end, true)
end
function ChatCtrl:initSenderPanel()
    local l_txtPlaceHolder = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.InputMessage.transform:Find("Placeholder"))
    l_txtPlaceHolder.LabText = Common.Utils.Lang("CHAT_CLICK_INPUT_HINT")--"点击这里输入..."
    --发送消息
    self.panel.BtnSend:AddClick(function()
        local l_uid = MEntityMgr.PlayerEntity.UID
        local l_msg = self.panel.InputMessage.Input.text
        l_msg=Common.Functions.DeleteRichText(l_msg)
        local l_channel = self.mgr.currentChannel

        if self.mgr.SendChatMsgSimple(l_uid, l_msg, l_channel, nil,true) then
            self.panel.InputMessage.Input.text = ""
        end
    end)
    --语音
    self.panel.BtnVoice:AddClick(function()
        self.audioInputModel = true
        self.panel.ChatSenderPanel.gameObject:SetActiveEx(not self.audioInputModel)
        self.panel.AudioPanel.gameObject:SetActiveEx(self.audioInputModel)
    end)
    self.panel.KeyboardBtn:AddClick(function()
        self.audioInputModel = false
        self.panel.ChatSenderPanel.gameObject:SetActiveEx(not self.audioInputModel)
        self.panel.AudioPanel.gameObject:SetActiveEx(self.audioInputModel)
    end)
    self.recordObj = UI.ChatRecordObj.new()
    self.recordObj:Init(self.panel.AudioBtn)

    self.panel.BtnFace.Listener.onClick = function(obj,eventData)
        if eventData~=nil and tostring(eventData:GetType()) == "MoonClient.MPointerEventData" and eventData.Tag==CtrlNames.Multitool then
            return
        end
        local l_floor = self.panel.Floor.RectTransform
        --打开标签页签，对话框上移
        local l_toPosition = l_floor.anchoredPosition
        l_toPosition.y = -(MUIManager.UIRoot.transform.sizeDelta.y - 639) / 2 + 226.5
        MUITweenHelper.TweenAnchoredPos(l_floor.gameObject,l_floor.anchoredPosition,l_toPosition, 0.2)
        local l_openPanelParam={
            channelType=self.mgr.currentChannel,
            deActiveAction=function()
                local l_toPosition = l_floor.anchoredPosition
                l_toPosition.y = 0
                if self:IsActive() then
                    MUITweenHelper.TweenAnchoredPos(l_floor.gameObject,l_floor.anchoredPosition,l_toPosition, 0.2)
                else
                    if not MLuaCommonHelper.IsNull(l_floor) then
                        self.panel.Floor.RectTransform.anchoredPosition = l_toPosition
                    end
                end
            end,
            inputActionData={
                inputFunc=function(st)
                    self.panel.InputMessage.Input.text = self.panel.InputMessage.Input.text..st
                end,
                inputItemFunc=function(item,hrefType)
                    local l_linkInputMgr=MgrMgr:GetMgr("LinkInputMgr");
                    self.panel.InputMessage.Input.text = l_linkInputMgr.AddInputHref(self.panel.InputMessage.Input.text,item,hrefType)
                end,
                extraData={
                    fixationPosX = 130, -- -202
                    fixationPosY = 116.5,
                },
                inputHrefDirectFunc=function(st)
                    self.panel.InputMessage.Input.text=st
                end,
            }
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool,l_openPanelParam)
    end

    self.panel.SettingBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Chatseting)
    end)

    self.panel.ChatRoomBtn:AddClick(function()
        MgrMgr:GetMgr("ChatRoomMgr").TryShowRoom()
    end)

    self.panel.Btn_ForbidPlayerInfo:AddClickWithLuaSelf(self.onClickForbidPlayerInfos,self,true)

    self.panel.InputMessage.Input.onSelect = function(eventData)
        l_txtPlaceHolder.LabText = ""
    end

    self.panel.InputMessage.Input.onDeselect = function(eventData)
        l_txtPlaceHolder.LabText = Common.Utils.Lang("CHAT_CLICK_INPUT_HINT")
    end

    self.panel.InputMessage:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        --输入字数限制
        local l_maxLenght=self.dataMgr.GetChatMaxNum(self.mgr.currentChannel)
        if l_maxLenght>0 then
            --表情代码扩充输入上限,表情代码算两个长度
            local l_expand=MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(value);
            if string.ro_len(value)>l_maxLenght + l_expand then
                value=string.ro_cut(value,l_maxLenght + l_expand);
                if LenghtHitTime ~= Time.frameCount then
                    LenghtHitTime = Time.frameCount
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_LIMIT", l_maxLenght))
                end
            end
        end
        self.panel.InputMessage.Input.text=value;
    end,false)

    self.panel.NewMessageHint:SetActiveEx(false)
    self.panel.NewMessageHint:AddClick(function()
        self.panel.NewMessageHint:SetActiveEx(false)
        if not self:canMoveDown() then
            self.chatContentPool:ShowTemplates({Datas=self.chatContentPool.Datas,StartScrollIndex=#self.chatContentPool.Datas})
        end
        self:updateDialogPosition()
    end)
end
--endregion---------------------------------下侧发送框---------------------------------

--region---------------------------------事件处理-----------------------------------
function ChatCtrl:getMsgTemInfo(msg)
    if msg.isNpc then
        return
    end
    if self.mgr.currentChannel==msg.channel then
       return self.dataMgr.GetChannelLineTemInfo(msg)
    end
end

function ChatCtrl:onNewChatMsg(msg)
    local l_class,l_prefab = self:getMsgTemInfo(msg)
    if l_class~=nil and l_prefab~=nil then
        local l_max = self.dataMgr.GetLocalCacheNum(msg.channel)
        local l_self = msg.lineType == self.dataMgr.EChatPrefabType.Self
        local l_inDown = self:canMoveDown(msg)
        --self.chatContentPool:Add(msg,l_class,l_prefab,l_max)
        --调试时候再打开 这个dump
        --Common.Functions.DumpTable(msg) 
        self.chatContentPool:AddTemplate(msg,l_max)

        --新消息计数
        if l_inDown or l_self then
            if l_self and not l_inDown then  --自己说的话滑动到底部
                --self.chatContentPool:ShowTemplates(self.chatContentPool.Datas,self.chatContentPool.ClassNames,self.chatContentPool.Prefabs,#self.chatContentPool.Datas)
                self.chatContentPool:ShowTemplates({Datas=self.chatContentPool.Datas,StartScrollIndex=#self.chatContentPool.Datas})
            end
            self:updateDialogPosition()
            self.panel.NewMessageHint:SetActiveEx(false)
            self.NewMessageCount = nil
        else
            if not self.panel.NewMessageHint.gameObject.activeSelf then
                self.NewMessageCount = 0
            end
            self.NewMessageCount = (self.NewMessageCount or 0) + 1
            self.panel.NewMessageHint:SetActiveEx(true)
            --%s条新消息↓
            self.panel.Content.LabText = StringEx.Format(Lang("NewMessageHintCount"), tostring(self.NewMessageCount))
        end
    end
end

function ChatCtrl:clearMsgPack()
    if self.chatContentPool~=nil then
        self.chatContentPool:DeActiveAll()
    end
end

function ChatCtrl:canMoveDown(msgPack)
    if self.panel.ChatLineGroup.LoopScroll.Moveing then
        return true
    end
    if self.panel.ChatLineGroup.LoopScroll.m_Dragging then
        return false
    end
    if self.panel.ChatLineGroup.LoopScroll.cellEndIndex ~= self.panel.ChatLineGroup.LoopScroll.totalCount then
        return false
    end
    if self.panel.ChatLineGroup.LoopScroll.content.sizeDelta.y <= self.panel.ChatLineGroup.LoopScroll.transform.sizeDelta.y then
        return true
    end

    local l_maxPos = self.panel.ChatLineGroup.LoopScroll.content.sizeDelta.y - self.panel.ChatLineGroup.LoopScroll.transform.sizeDelta.y
    l_maxPos = l_maxPos - 10
    if self.panel.ChatLineGroup.LoopScroll.content.anchoredPosition.y >= l_maxPos then
        return true
    else
        return false
    end
end

function ChatCtrl:resetChatRoom()
    local l_roomOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatRoom)
    self.panel.ChatRoomBtn:SetActiveEx(l_roomOpen)
end

function ChatCtrl:onClickForbidPlayerInfos()
    UIMgr:ActiveUI(CtrlNames.ForbidChatPlayerInfos)
end

---@param refreshAll boolean 是否屏蔽列表全部刷新 
---@param playerUid uint64 玩家uid 
---@param isAdd boolean 是否新增了屏蔽玩家
function ChatCtrl:onForbidPlayerInfosUpdate(refreshAll,playerUid,isAdd)
    local l_cacheQueue,l_isChatDataChanged = self.dataMgr.GetFilterChannelCache(self.mgr.currentChannel)
    if not l_isChatDataChanged then
        return
    end
    if l_cacheQueue ~= nil then
        local l_cacheTable = l_cacheQueue:enumerate()
        local l_msgs={}

        for _,msg in pairs(l_cacheTable) do
            local l_class,l_prefab = self:getMsgTemInfo(msg)
            if l_class~=nil and l_prefab~=nil then
                table.insert(l_msgs,msg)
            end
        end

        self.chatContentPool:ShowTemplates({
            Datas=l_msgs,
            StartScrollIndex=self.chatContentPool:GetCellStartIndex(),
            IsNeedShowCellWithStartIndex=false,
            IsToStartPosition=false
        })
    end
end

function ChatCtrl:filterCurrentChannelForbidChatMsg()
    --self.mgr.currentChannel
    self:clearMsgPack()

    local l_cacheQueue = self.dataMgr.GetChannelCache(self.mgr.currentChannel)
    if l_cacheQueue ~= nil then
        local l_cacheTable = l_cacheQueue:enumerate()
        local l_msgs={}

        for _,msg in pairs(l_cacheTable) do
            local l_class,l_prefab = self:getMsgTemInfo(msg)
            if l_class~=nil and l_prefab~=nil then
                table.insert(l_msgs,msg)
            end
        end
        --self.chatContentPool:ShowTemplates(l_msgs,l_classNames,l_prefabs,#l_msgs)
        self.chatContentPool:ShowTemplates({Datas=l_msgs,StartScrollIndex=#l_msgs})
    end
end
--置顶消息处理
function ChatCtrl:ShowZDNews()
    self.panel.TopMsg:GetRichText().onHrefClick:Release()
    self.panel.TopMsg:GetRichText().raycastTarget = true
    self.panel.TopMsg:GetRichText().onHrefClick:AddListener(function(key)
        if key == "GuildLake" then
            local data = self.mgr.chatNewsZdTable[self.mgr.currentChannel] and self.mgr.chatNewsZdTable[self.mgr.currentChannel].otherInfo
            if data then
                local l_txtTitle = Lang(data.CongratulationTitle)
                local l_content = self.mgr.chatNewsZdTable[self.mgr.currentChannel].zdNewsText
                local l_default = Lang(data.CongratulationTalk)
                if MgrMgr:GetMgr("GuildMgr").GuildNewsGetLakeState(l_content) then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_LAKED"))
                    return
                end
                local l_announceData = self.mgr.chatNewsZdTable[self.mgr.currentChannel].announceData
                local l_additionData = {announceData = l_announceData}
                MgrMgr:GetMgr("TipsMgr").ShowLikesDialog(l_txtTitle,l_content,l_default,l_additionData,function (data)
                    if MgrMgr:GetMgr("GuildMgr").SendGuildNewsMsg(data) then
                        self.panel.TopMsg.LabText = MgrMgr:GetMgr("GuildMgr").ShowAlreadyLaked(self.panel.TopMsg.LabText)
                    end
                end)
            end
        end
    end)
    if self.mgr.chatNewsZdTable[self.mgr.currentChannel] and self.mgr.chatNewsZdTable[self.mgr.currentChannel].zdNewsTimer ~= nil then
        self.panel.TopMsgBox.gameObject:SetActiveEx(true)
        self.panel.TopMsg.LabText = self.mgr.chatNewsZdTable[self.mgr.currentChannel].zdNewsText
        self:ReleaseData()
        self.zdNewsAnim,self.zdNewsTimer = Common.CommonUIFunc.SetItemTemAnimation(self.panel.TopMsg,self.panel.TopMsgBox,false,true,3)
        self:SaveTimerData(self.zdNewsTimer)
        self.ShowZD = true
    else
        self.panel.TopMsgBox.gameObject:SetActiveEx(false)
        self.ShowZD = false
    end
end
--endregion---------------------------------事件处理-----------------------------------

--region-----------------------------------通用方法-----------------------------------
function ChatCtrl:clearSetting()
    self.lastMsg = ""
    self.last_currentChannel=nil
    self.mgr.currentChannel=nil
end

function ChatCtrl:ReleaseData()
    if self.zdNewsAnim then
        self.zdNewsAnim:DOKill()
        self.zdNewsAnim = nil
    end
    if self.zdNewsTimer then
        self:StopUITimer(self.zdNewsTimer)
        self.zdNewsTimer = nil
    end 
end

function ChatCtrl:refreshChatBtnState()
    local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)
    self.panel.BtnVoice:SetActiveEx(l_chatVoiceOpen)

    local l_chatForbidOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatForbid)
    self.panel.Btn_ForbidPlayerInfo:SetActiveEx(l_chatForbidOpen)
end
--endregion---------------------------------通用方法-----------------------------------
--lua custom scripts end

return ChatCtrl