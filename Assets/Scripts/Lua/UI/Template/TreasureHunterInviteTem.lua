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
---@class TreasureHunterInviteTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Signature MoonClient.MLuaUICom
---@field RoleName MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Btn_Small_03 MoonClient.MLuaUICom

---@class TreasureHunterInviteTem : BaseUITemplate
---@field Parameter TreasureHunterInviteTemParameter

TreasureHunterInviteTem = class("TreasureHunterInviteTem", super)
--lua class define end

--lua functions
function TreasureHunterInviteTem:Init()
    super.Init(self)
    self.friendId = 0
    self.Parameter.Btn_Small_03:AddClick(function()
        if self.Parameter.Btn_Small_03 ~= 0 then
            MgrMgr:GetMgr("TreasureHunterMgr").SendHelpToFirend(self.friendId)
        end
    end)

	self._head = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.Parameter.Head.transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})
end --func end
--next--
function TreasureHunterInviteTem:BindEvents()
	-- do nothing
end --func end
--next--
function TreasureHunterInviteTem:OnDestroy()
	-- do nothing
end --func end
--next--
function TreasureHunterInviteTem:OnDeActive()
	-- do nothing
end --func end
--next--

function TreasureHunterInviteTem:OnSetData(data)
    self.Parameter.RoleName.LabText = data.base_info.name
    self.friendId = data.uid
	local playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
	local equipData = playerInfoMgr.GetEquipData(data.base_info)
	---@type HeadTemplateParam
	local param = {
		EquipData = equipData
	}

	self._head:SetData(param)
end