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
---@class ChatRoomMiniTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field MessageText MoonClient.MLuaUICom

---@class ChatRoomMiniTem : BaseUITemplate
---@field Parameter ChatRoomMiniTemParameter

ChatRoomMiniTem = class("ChatRoomMiniTem", super)
--lua class define end

--lua functions
function ChatRoomMiniTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChatRoomMiniTem:OnDestroy()
	
	
end --func end
--next--
function ChatRoomMiniTem:OnDeActive()
	
	
end --func end
--next--
function ChatRoomMiniTem:OnSetData(msg)
	
	local l_content = msg.content
	--动态表情替换
	l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
	--道具链接替换
	l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content,msg.Param,false)
	--文本内容
	if msg.lineType == DataMgr:GetData("ChatData").EChatPrefabType.System then
		l_content = GetColorText(l_content, RoColorTag.Yellow)
	elseif msg.playerInfo~=nil then
		if msg.AudioObj~=nil then
			l_content = GetImageText("Ui_Chat_Play1.png", "Common", 25, 1.3) .. l_content
			l_content = GetColorText(msg.playerInfo.name..": ", RoColorTag.Blue) .. l_content
		else
			l_content = GetColorText(msg.playerInfo.name..": ", RoColorTag.Blue) .. l_content
		end
	end
	self.Parameter.MessageText:GetText().enabled = true
	self.Parameter.MessageText.LabText = l_content
	
end --func end
--next--
function ChatRoomMiniTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatRoomMiniTem