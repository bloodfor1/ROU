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
---@class MainChatChannelTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeIcon MoonClient.MLuaUICom
---@field TagText MoonClient.MLuaUICom
---@field MessageText MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class MainChatChannelTem : BaseUITemplate
---@field Parameter MainChatChannelTemParameter

MainChatChannelTem = class("MainChatChannelTem", super)
--lua class define end

--lua functions
function MainChatChannelTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MainChatChannelTem:OnDeActive()
	
	
end --func end
--next--
function MainChatChannelTem:OnSetData(msg)
	
	    self.Parameter.MessageText:GetText().enabled = true
	    self.msg = msg
		self.chatMgr=MgrMgr:GetMgr("ChatMgr")
		self.chatDataMgr=DataMgr:GetData("ChatData")
	    local l_icon = self.Parameter.TypeIcon
	    local l_txtChannelName = self.Parameter.TagText
	    local l_txtMsg = self.Parameter.MessageText
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
	            l_content = GetImageText("Ui_Chat_Play1.png", "Common", 25, 1.3) .. l_content
	            l_content = GetColorText(msg.playerInfo.name, RoColorTag.Blue) .. "：" .. GetColorText(l_content, RoColorTag.None)
	        else
	            l_content = GetColorText(msg.playerInfo.name, RoColorTag.Blue) .. "：" .. GetColorText(l_content, RoColorTag.None)
	        end
		end
		if msg.RedEnvelope then--红包特殊显示
			l_content = msg.content
		end
		if msg.ViewportID and msg.playerInfo then--照相任务特例
			l_content = Lang("MainChat_Viewport",msg.playerInfo.name)--{0}发出了一条拍照委托求助，大家快来帮帮他/她吧
		end
		-- 贴纸分享
	    if msg.stickers and msg.playerInfo then
	        l_content = Lang("STICKERS_SHARE", msg.playerInfo.name)
	    end
	    --重载频道名
	    if msg.lineType == self.chatDataMgr.EChatPrefabType.System then
	        l_txtChannelName.LabText = msg.subType
	    else
	        l_txtChannelName.LabText = self.chatDataMgr.GetChannelName(msg.channel)
	    end
	    l_txtMsg.LabText = l_content
	    l_icon.Img.color = self.chatDataMgr.GetChannelColor(msg.channel)
	    --由于图文混排导致[系统]标签与第一个字符错位
	    local l_textCom = self.Parameter.MessageText:GetText()
	    l_textCom.PopulateMeshAct = function()
	        l_textCom.PopulateMeshAct = nil
	        local l_rootpos = l_icon.transform.anchoredPosition
	        l_rootpos.y = (l_textCom.FirstChatPos.y + l_textCom.FirstChatRightTopPos.y)*0.5
	        MLuaCommonHelper.SetRectTransformPos(l_icon.gameObject,l_rootpos.x,l_rootpos.y);
	    end
	        self.Parameter.Btn:AddClick(function()
			if self.msg~=nil then
				self.chatMgr.EventDispatcher:Dispatch(self.chatDataMgr.EEventType.EnterChatPanel)
	            end
	        end,true)
	
end --func end
--next--
function MainChatChannelTem:BindEvents()
	
	
end --func end
--next--
function MainChatChannelTem:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MainChatChannelTem