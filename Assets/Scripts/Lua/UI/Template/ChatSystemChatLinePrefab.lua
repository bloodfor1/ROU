--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ChatSystemChatLinePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TagObj MoonClient.MLuaUICom
---@field TagColor MoonClient.MLuaUICom
---@field TagText MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom

---@class ChatSystemChatLinePrefab : BaseUITemplate
---@field Parameter ChatSystemChatLinePrefabParameter

ChatSystemChatLinePrefab = class("ChatSystemChatLinePrefab", super)
--lua class define end

--lua functions
function ChatSystemChatLinePrefab:Init()
	
	super.Init(self)
	
end --func end
--next--
function ChatSystemChatLinePrefab:OnDeActive()
	
	
end --func end
--next--
function ChatSystemChatLinePrefab:OnSetData(data)
	
	self.msgPack = data
	self.ChatMgr = MgrMgr:GetMgr("ChatMgr")
	self.chatDataMgr=DataMgr:GetData("ChatData")
	--内容
	local l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(self.msgPack.content)
	--道具链接替换
	l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content,self.msgPack.Param,true)
	self.Parameter.Message.LabRayCastTarget = true
	self.Parameter.Message.LabText = l_content
	self.Parameter.Message:GetRichText().PopulateMeshAct = function()
		self.Parameter.Message:GetRichText().PopulateMeshAct = nil
		local l_rootpos = self.Parameter.TagObj.transform.anchoredPosition
		l_rootpos.y = self.Parameter.Message:GetRichText().FirstChatPos.y - 2
		MLuaCommonHelper.SetRectTransformPos(self.Parameter.TagObj.gameObject,l_rootpos.x,l_rootpos.y);
	end
	self.Parameter.TagColor.Img.color = self.chatDataMgr.GetChannelColor(self.msgPack.channel)
	if self.msgPack.lineType == self.chatDataMgr.EChatPrefabType.System then
		self.Parameter.TagText.LabText = self.msgPack.subType
	else
		self.Parameter.TagText.LabText = self.chatDataMgr.GetChannelName(self.msgPack.channel)
	end
	--超链接回调
	self.Parameter.Message.LabRayCastTarget = true
	self.Parameter.Message:GetRichText().onHrefClick:Release()
	self.Parameter.Message:GetRichText().onHrefClick:AddListener(function(key)
		MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key,{
			fixationPosX = 130,
			fixationPosY = 0,
			originText = self.Parameter.Message,
			IsAchievementDetailsShowShare = self.msgPack.channel ~= DataMgr:GetData("ChatData").EChannel.GuildChat,  --目前两个地方用到 公会频道和系统频道  系统频道需要分享 为true
		}, self.msgPack)
	end)
	self.Parameter.Message:GetRichText().onDown = function()
		if self.MethodCallback then
			self.MethodCallback(self.msgPack)
		end
	end
	--已读消息
	MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)
	
end --func end
--next--
function ChatSystemChatLinePrefab:BindEvents()
	
	
end --func end
--next--
function ChatSystemChatLinePrefab:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatSystemChatLinePrefab