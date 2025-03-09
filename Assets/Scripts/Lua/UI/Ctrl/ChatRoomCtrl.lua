--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChatRoomPanel"
require "UI/Template/ChatRomPlayerTem"

require "UI/Template/ChatHistoryPrefab"
require "UI/Template/ChatHintChatLinePrefab"
require "UI/Template/ChatOtherChatLinePrefab"
require "UI/Template/ChatPlayerChatLinePrefab"
require "UI/Template/ChatSystemChatLinePrefab"
require "CommonUI/ChatRecordObj"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ChatRoomCtrl = class("ChatRoomCtrl", super)
--lua class define end

--lua functions
function ChatRoomCtrl:ctor()

	super.ctor(self, CtrlNames.ChatRoom, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function ChatRoomCtrl:Init()

	self.panel = UI.ChatRoomPanel.Bind(self)
	super.Init(self)
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self.roomMgr = MgrMgr:GetMgr("ChatRoomMgr")
    self.chatDataMgr=DataMgr:GetData("ChatData")
    self:initSenderPanel()

    self.panel.CloseBtn:AddClick(function()
        self.roomMgr.TrySetPanelMax(false)
    end,true)

    self.panel.DissolveBtn:AddClick(function()
        self.roomMgr.TryDissolveRoom()
    end,true)

    self.panel.SetBtn.Listener.onClick=function(obj,data)
        if data~=nil and tostring(data:GetType()) == "MoonClient.MPointerEventData" and data.Tag==CtrlNames.SetupChatRoom then
            return
        end
        UIMgr:ActiveUI(UI.CtrlNames.SetupChatRoom)
    end

    self.panel.ExitBtn:AddClick(function()
        self.roomMgr.TryLeaveRoom()
    end,true)

    self.chatTemlatePool = self:NewTemplatePool({
        ScrollRect = self.panel.ChatScroll.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = handler(self,self.getMsgTemInfo),
    })

    self.playerTemPool = self:NewTemplatePool({
        ScrollRect = self.panel.PlayerScroll.LoopScroll,
        UITemplateClass = UITemplate.ChatRomPlayerTem,
        TemplatePrefab = self.panel.PlayerPrefab.LuaUIGroup.gameObject,
        Method=function(tem)
	        self.playerTemPool:SelectTemplate(tem.ShowIndex)
        end
    })

    self.roomMgr.SyncAllMemberInfo()
end --func end
--next--
function ChatRoomCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
    self.chatTemlatePool = nil
    self.playerTemPool = nil
    if self.recordObj ~= nil then
        self.recordObj:Unint()
        self.recordObj = nil
    end
end --func end
--next--
function ChatRoomCtrl:OnActive()
    self:resetRoomData()
    self:refreshVoiceBtnState()
end --func end
--next--
function ChatRoomCtrl:OnDeActive()
    UIMgr:DeActiveUI(CtrlNames.Multitool)

end --func end
--next--
function ChatRoomCtrl:Update()
    if self.recordObj ~= nil then
        self.recordObj:Update()
    end

    if self.panel~=nil then
        if self.panel.NewMessageHint.gameObject.activeSelf then
            if not self.panel.ChatScroll.LoopScroll.Moveing then
                if self:canMoveDown() then
                    self.panel.NewMessageHint:SetActiveEx(false)
                    self.panel.ChatScroll.LoopScroll:ScrollToCell(#self.chatTemlatePool.Datas-1,2000)
                end
            end
        end
    end

end --func end

--next--
function ChatRoomCtrl:BindEvents()
    --收到新消息
    self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg,function(self, msg)
        self:newChatMsg(msg)
    end)
    
    --旧的聊天被改变
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.Modification, function(self,msgPack)
		local l_tem = self.chatTemlatePool:FindShowTem(function(tem)
			return msgPack == tem.msgPack
		end)
		if l_tem then
			l_tem:SetData(msgPack)
		end
	end)

    --刷新所有数据
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.ResetData,function(self)
        if self.roomMgr.Room:Has() then
            self:resetRoomData()
        else
            UIMgr:DeActiveUI(UI.CtrlNames.ChatRoom)
        end
    end)

    --房间设置刷新
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.ResetSetting,function(self)
        self:resetRoomData()
    end)

    --队长改变
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.CaptainChange,function(self)
        self:resetRoomData()
    end)

    --增加组员
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.MemberAdd,function(self,member)
        self.playerTemPool:AddTemplate(member)
    end)

    --移除组员
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.MemberRemove,function(self,member)
        local l_selectTem = self.playerTemPool:GetCurrentSelectTemplateData()
        if l_selectTem and l_selectTem.member.uid == member.uid then
            self.playerTemPool:SelectTemplate(0)
        end
        self.playerTemPool:RemoveTemplate(member)
        -- self.playerTemPool:RefreshCells()
    end)

    --组队离线状态
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.MemberState,function(self,member)
        local l_tem = self.playerTemPool:FindShowTem(function(a)
            return a.data == member
        end)
        if l_tem~=nil then
            l_tem:SetData(member)
        end
    end)

    --头像数据变化
    self:BindEvent(self.roomMgr.EventDispatcher,self.roomMgr.Event.MemberChange,function(self,member)
        local l_tem = self.playerTemPool:FindShowTem(function(a)
            return a.data == member
        end)
        if l_tem~=nil then
            l_tem:SetData(member)
        end
    end)
    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openMgr.EventDispatcher,l_openMgr.OpenSystemUpdate, function(self)
        self:refreshVoiceBtnState()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function ChatRoomCtrl:initSenderPanel()
	local l_txtPlaceHolder = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.InputMessage.transform:Find("Placeholder"))
	l_txtPlaceHolder.LabText = Lang("CHAT_CLICK_INPUT_HINT")--"点击这里输入..."

	--发送消息
	self.panel.BtnSend:AddClick(function()
        if not self.roomMgr.Room:Has() then
            return
        end
		local l_uid = MEntityMgr.PlayerEntity.UID
		local l_msg = self.panel.InputMessage.Input.text
		local l_channel = self.chatDataMgr.EChannel.ChatRoomChat

		if self.chatMgr.SendChatMsgSimple(l_uid, l_msg, l_channel, nil,true) then
            self.panel.InputMessage.Input.text = ""
        end
	end)

    self.panel.InputPanel.gameObject:SetActiveEx(true)
    self.panel.AudioPanel.gameObject:SetActiveEx(false)
	--语音
	self.panel.BtnVoice:AddClick(function()
        self.panel.InputPanel.gameObject:SetActiveEx(false)
        self.panel.AudioPanel.gameObject:SetActiveEx(true)
	end)
    self.panel.KeyboardBtn:AddClick(function()
        self.panel.InputPanel.gameObject:SetActiveEx(true)
        self.panel.AudioPanel.gameObject:SetActiveEx(false)
    end)

    self.recordObj = UI.ChatRecordObj.new()
    self.recordObj:Init(self.panel.AudioBtn)
    self.recordObj:SetChannel(self.chatDataMgr.EChannel.ChatRoomChat)

    self.panel.BtnFace.Listener.onClick = function(obj,eventData)
        if eventData~=nil and tostring(eventData:GetType()) == "MoonClient.MPointerEventData" and eventData.Tag==CtrlNames.Multitool then
            return
        end
        local l_floor = self.panel.PanelRef.transform
        --打开标签页签，对话框上移
        local l_toPosition = l_floor.localPosition
        l_toPosition.y = -(MUIManager.UIRoot.transform.sizeDelta.y - 514.4) / 2 + 226.5
        MUITweenHelper.TweenPos(l_floor.gameObject,l_floor.localPosition,l_toPosition, 0.2)
        local l_openToolPanelParam=
        {
            channelType=self.chatDataMgr.EChannel.ChatRoomChat,
            deActiveAction=function()
                local l_toPosition = l_floor.localPosition
                l_toPosition.y = 0
                MUITweenHelper.TweenPos(l_floor.gameObject,l_floor.localPosition,l_toPosition, 0.2)
            end,
            inputActionData=
            {
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
                end
            },
            needSetPositionMiddle=true,
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool,l_openToolPanelParam)
	end

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
        local l_maxLenght=self.chatDataMgr.GetChatMaxNum(self.chatDataMgr.EChannel.ChatRoomChat)
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
            self.chatTemlatePool:ShowTemplates({Datas=self.chatTemlatePool.Datas,StartScrollIndex=#self.chatTemlatePool.Datas})
        end
        self.panel.ChatScroll.LoopScroll:ScrollToCell(#self.chatTemlatePool.Datas-1,2000)
    end)
end

function ChatRoomCtrl:resetRoomData()
    if not self.roomMgr.Room:Has() then
        -- UIMgr:DeActiveUI(UI.CtrlNames.ChatRoom)
        self.chatTemlatePool:ShowTemplates({Datas={}})
        self.playerTemPool:ShowTemplates({Datas={}})
        self.panel.TitleText.LabText = ""
        self.panel.DissolveBtn:SetActiveEx(false)
        self.panel.SetBtn:SetActiveEx(false)
        self.panel.ExitBtn:SetActiveEx(false)
        return
    end

    --房间名
    self.panel.TitleText.LabText = self.roomMgr.Room.Name

    --按钮
    self.panel.DissolveBtn:SetActiveEx(self.roomMgr.Room:SelfCaptain())
    self.panel.SetBtn:SetActiveEx(self.roomMgr.Room:SelfCaptain())
    self.panel.ExitBtn:SetActiveEx(true)

    --
    if string.ro_isEmpty(self.roomMgr.Room.Code) then
        self.panel.TitleIcon:SetSprite("Icon_Function01","UI_Icon_Function_Liaotianshi01.png")
    else
        self.panel.TitleIcon:SetSprite("Icon_Function01","UI_Icon_Function_Liaotianshi02.png")
    end

    --聊天信息
    local l_cacheQueue = self.chatDataMgr.GetChannelCache(self.chatDataMgr.EChannel.ChatRoomChat)
    local l_msgs={}
    if l_cacheQueue ~= nil then
        local l_cacheTable = l_cacheQueue:enumerate()
        for _,msg in pairs(l_cacheTable) do
            if self:getMsgTemInfo(msg) then
                table.insert(l_msgs,msg)
            end
        end
    end
    self.panel.ChatScroll.LoopScroll:ClearActiveCells()
    self.chatTemlatePool:ShowTemplates({Datas=l_msgs,StartScrollIndex=#l_msgs})

    --玩家列表
    local l_members = {}
    for i=1,#self.roomMgr.Room.Members do
        l_members[#l_members+1] = self.roomMgr.Room.Members[i]
    end
    self.playerTemPool:ShowTemplates({Datas=l_members})
    self.playerTemPool:SelectTemplate(0)
end

function ChatRoomCtrl:newChatMsg(msg)
    local l_class,l_prefab = self:getMsgTemInfo(msg)
    if l_class==nil or l_prefab==nil then
        return
    end

    local l_max = self.chatDataMgr.GetLocalCacheNum(self.chatDataMgr.EChannel.ChatRoomChat)
    local l_self = msg.lineType == self.chatDataMgr.EChatPrefabType.Self
    local l_inDown = self:canMoveDown(msg)
    self.chatTemlatePool:AddTemplate(msg,l_max)

    --新消息计数
    if l_inDown or l_self then
        if l_self and not l_inDown then  --自己说的话滑动到底部
            self.chatTemlatePool:ShowTemplates({Datas=self.chatTemlatePool.Datas,StartScrollIndex=#self.chatTemlatePool.Datas})
        end
        self.panel.ChatScroll.LoopScroll:ScrollToCell(#self.chatTemlatePool.Datas-1,2000)
        self.panel.NewMessageHint:SetActiveEx(false)
        self.NewMessageCount = nil
    else
        if not self.panel.NewMessageHint.gameObject.activeSelf then
            self.NewMessageCount = 0
        end
        self.NewMessageCount = (self.NewMessageCount or 0) + 1
        self.panel.NewMessageHint:SetActiveEx(true)
        --%s条新消息↓
        self.panel.NewMessageContent.LabText = StringEx.Format(Lang("NewMessageHintCount"),tostring(self.NewMessageCount))
    end
end

function ChatRoomCtrl:getMsgTemInfo(msg)
    if msg.isNpc then
        return
    end
    if msg.channel == self.chatDataMgr.EChannel.ChatRoomChat then
        return self.chatDataMgr.GetChannelLineTemInfo(msg)
    end
end
function ChatRoomCtrl:refreshVoiceBtnState()
    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_chatVoiceOpen = l_openMgr.IsSystemOpen(l_openMgr.eSystemId.ChatVoice)
    self.panel.BtnVoice:SetActiveEx(l_chatVoiceOpen)

    local l_inputComSize=self.panel.InputMessage.RectTransform.rect.size
    l_inputComSize.x = self.panel.Panel_InputAndVoice.RectTransform.rect.size.x
    if l_chatVoiceOpen then
        l_inputComSize.x = l_inputComSize.x - self.panel.BtnVoice.RectTransform.rect.size.x
    end
    self.panel.InputMessage.RectTransform.sizeDelta = l_inputComSize
end
function ChatRoomCtrl:canMoveDown(msgPack)
    if self.panel.ChatScroll.LoopScroll.Moveing then
        return true
    end
    if self.panel.ChatScroll.LoopScroll.m_Dragging then
        return false
    end
    if self.panel.ChatScroll.LoopScroll.cellEndIndex ~= self.panel.ChatScroll.LoopScroll.totalCount then
        return false
    end
    if self.panel.ChatScroll.LoopScroll.content.sizeDelta.y <= self.panel.ChatScroll.LoopScroll.transform.sizeDelta.y then
        return true
    end

    local l_maxPos = self.panel.ChatScroll.LoopScroll.content.sizeDelta.y - self.panel.ChatScroll.LoopScroll.transform.sizeDelta.y
    l_maxPos = l_maxPos - 10
    return self.panel.ChatScroll.LoopScroll.content.anchoredPosition.y >= l_maxPos
end
--lua custom scripts end
return ChatRoomCtrl