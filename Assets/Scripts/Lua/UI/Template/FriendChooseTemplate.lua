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
---@class FriendChooseTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtPlayerName MoonClient.MLuaUICom
---@field Img_Choice MoonClient.MLuaUICom
---@field Head_Player MoonClient.MLuaUICom
---@field Btn_Bg MoonClient.MLuaUICom

---@class FriendChooseTemplate : BaseUITemplate
---@field Parameter FriendChooseTemplateParameter

FriendChooseTemplate = class("FriendChooseTemplate", super)
--lua class define end

--lua functions
function FriendChooseTemplate:Init()
	
	super.Init(self)
	self.playerHead = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.Parameter.Head_Player.transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})
end --func end
--next--
function FriendChooseTemplate:BindEvents()
	
	-- do nothing
	
end --func end
--next--
function FriendChooseTemplate:OnDestroy()
	self.playerInfo = nil
	-- do nothing
	
end --func end
--next--
function FriendChooseTemplate:OnDeActive()
	
	-- do nothing
	
end --func end
--next--
function FriendChooseTemplate:OnSetData(data)
	---@type FriendInfo
	if data == nil then
		return
	end
	self.playerInfo = MgrMgr:GetMgr("PlayerInfoMgr").CreatMemberData(data.base_info)
	self.Parameter.Img_Choice:SetActiveEx(false)
	---@type HeadTemplateParam
	local l_param = {
		EquipData = self.playerInfo:GetEquipData(),
		ShowProfession = true,
		Profession = self.playerInfo.type,
		ShowLv = true,
		Level = self.playerInfo.level,
		OnClick = self.onHeadClick,
		OnClickSelf = self,
	}
	self.playerHead:SetData(l_param)
	self.Parameter.TxtPlayerName.LabText = self.playerInfo.name
	---@type MagicLetterMgr
	local l_magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	local l_receiveFriendInfo = l_magicLetterMgr.GetReceiveLetterFriendInfo()
	if l_receiveFriendInfo ~= nil and l_receiveFriendInfo.uid == data.uid then
		l_magicLetterMgr.SetReceiveLetterFriendInfo(data, self.ShowIndex, true)
	end

	self.Parameter.Btn_Bg:AddClick(function()
		local l_currentReceiveFriendInfo = l_magicLetterMgr.GetReceiveLetterFriendInfo(true)
		if l_currentReceiveFriendInfo ~= nil and l_currentReceiveFriendInfo.uid == data.uid then
			l_magicLetterMgr.SetReceiveLetterFriendInfo(nil, -1, true)
			return
		end
		l_magicLetterMgr.SetReceiveLetterFriendInfo(data, self.ShowIndex, true)
	end, true)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function FriendChooseTemplate:OnSelect()
    self.Parameter.Img_Choice:SetActiveEx(true)
end

function FriendChooseTemplate:OnDeselect()
    self.Parameter.Img_Choice:SetActiveEx(false)
end
function FriendChooseTemplate:onHeadClick()
	if self.playerInfo==nil then
		return
	end
	MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
end
--lua custom scripts end
return FriendChooseTemplate