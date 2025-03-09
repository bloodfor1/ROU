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
---@class AchievementPandectFunctionAwardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Mask MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class AchievementPandectFunctionAwardTemplate : BaseUITemplate
---@field Parameter AchievementPandectFunctionAwardTemplateParameter

AchievementPandectFunctionAwardTemplate = class("AchievementPandectFunctionAwardTemplate", super)
--lua class define end

--lua functions
function AchievementPandectFunctionAwardTemplate:Init()
	
	    super.Init(self)
	self._id=nil
	self.Parameter.Button:AddClick(function()
		if self._id==nil then
			return
		end
		UIMgr:ActiveUI(UI.CtrlNames.AchievementAwardTips,function(ctrl)
			ctrl:ShowTips(self._id)
		end)
	end)
	
end --func end
--next--
function AchievementPandectFunctionAwardTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementPandectFunctionAwardTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementPandectFunctionAwardTemplate:OnSetData(data,isGray)
	
	self._id=data
	local l_privilegeSystemDesTableInfo=TableUtil.GetPrivilegeSystemDesTable().GetRowById(data)
	self.Parameter.Icon:SetSpriteAsync(l_privilegeSystemDesTableInfo.SystemAtlas, l_privilegeSystemDesTableInfo.SystemIcon)
	if isGray then
		self.Parameter.Mask:SetActiveEx(true)
	else
		self.Parameter.Mask:SetActiveEx(false)
	end
	
end --func end
--next--
function AchievementPandectFunctionAwardTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AchievementPandectFunctionAwardTemplate