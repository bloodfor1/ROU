--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MiniChatPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MiniChatCtrl = class("MiniChatCtrl", super)
--lua class define end

--lua functions
function MiniChatCtrl:ctor()

	super.ctor(self, CtrlNames.MiniChat, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function MiniChatCtrl:Init()

	self.panel = UI.MiniChatPanel.Bind(self)
	super.Init(self)
	self.chatMgr = MgrMgr:GetMgr("ChatMgr")
	self.chatDataMgr = DataMgr:GetData("ChatData")
	self.panel.MessageBox:AddClick(function()
		self.uObj:SetActiveEx(false)
		UIMgr:ActiveUI(UI.CtrlNames.Chat,{ needChangeToCurrentChannel = true })
	end, true)
end --func end
--next--
function MiniChatCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function MiniChatCtrl:OnActive()

	self:onNewChatMsg()

end --func end
--next--
function MiniChatCtrl:OnDeActive()


end --func end
--next--
function MiniChatCtrl:Update()


end --func end

--next--
function MiniChatCtrl:BindEvents()

	self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg,function(self, msg)
		self:onNewChatMsg()
	end)
	self:BindEvent(GlobalEventBus,EventConst.Names.ShowMainChatCtrl, function()
		self.uObj:SetActiveEx(true)
		self:onNewChatMsg()
	end)


end --func end
--next--
--lua functions end

--lua custom scripts
function MiniChatCtrl:onNewChatMsg()
	local l_cacheQueue = self.chatDataMgr.GetChannelCache(self.chatDataMgr.EChannel.AllChat)
	local l_cacheTable = l_cacheQueue:enumerate()
	local l_datas = {}
	for _,v in pairs(l_cacheTable) do
		l_datas[#l_datas+1] = v
	end
	if #l_datas>0 then
		self:SetData(l_datas[#l_datas])
	end
end

function MiniChatCtrl:SetData(msg)

	self.panel.MessageText:GetText().enabled = true
	self.msg = msg
	local l_icon = self.panel.TypeIcon
	local l_txtChannelName = self.panel.TagText
	local l_txtMsg = self.panel.MessageText
	local l_content = msg.content
	--动态表情替换
	l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
	--道具链接替换
	l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content,msg.Param,false)

	--文本内容
	if msg.lineType == self.chatDataMgr.EChatPrefabType.System then
		l_content = GetColorText(l_content, RoColorTag.Yellow)
	elseif msg.playerInfo~=nil then
		if msg.AudioObj~=nil then
			l_content = GetImageText("Ui_Chat_Play1.png", "Common", 25, 1.4)..l_content
			l_content = GetColorText(msg.playerInfo.name, RoColorTag.Blue) .. GetColorText(l_content, RoColorTag.None)
		else
			l_content = GetColorText(msg.playerInfo.name, RoColorTag.Blue) .. GetColorText(l_content, RoColorTag.None)
		end
	end
	--重载频道名
	if msg.lineType == self.chatDataMgr.EChatPrefabType.System then
		l_txtChannelName.LabText = msg.subType
	else
		l_txtChannelName.LabText = self.chatDataMgr.GetChannelName(msg.channel)
	end
	l_txtMsg.LabText = l_content
	l_icon.Img.color = self.chatDataMgr.GetChannelColor(msg.channel)

	local l_textCom = self.panel.MessageText:GetText()
	--由于图文混排导致[系统]标签与第一个字符错位
	l_textCom.PopulateMeshAct = function()
		l_textCom.PopulateMeshAct = nil
		local l_rootpos = l_icon.transform.anchoredPosition
		l_rootpos.y = l_textCom.FirstChatPos.y - 5
		MLuaCommonHelper.SetRectTransformPos(l_icon.gameObject,l_rootpos.x,l_rootpos.y);
	end
end

--lua custom scripts end
