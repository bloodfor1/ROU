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
---@class AchievementPileTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field NoFinish MoonClient.MLuaUICom
---@field IndexText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field ClickButton MoonClient.MLuaUICom

---@class AchievementPileTemplate : BaseUITemplate
---@field Parameter AchievementPileTemplateParameter

AchievementPileTemplate = class("AchievementPileTemplate", super)
--lua class define end

--lua functions
function AchievementPileTemplate:Init()
	
	    super.Init(self)
	self.Data=nil
	self._mgr=MgrMgr:GetMgr("AchievementMgr")
	
end --func end
--next--
function AchievementPileTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementPileTemplate:OnSetData(data)
	
	self.Data=data
	local l_tableInfo= TableUtil.GetAchievementDetailTable().GetRowByID(data.achievementid)
	self.Parameter.Icon:SetSprite(l_tableInfo.Atlas, l_tableInfo.Icon, true)
	self.Parameter.Point.LabText=tostring(l_tableInfo.Point)
	self.Parameter.ClickButton:AddClick(function()
		self:ShowSelect()
		UIMgr:ActiveUI(UI.CtrlNames.AchievementDetails,function(ctrl)
			ctrl:ShowDetails(self.Data.achievementid,MPlayerInfo.UID,self.Data.finishtime,true)
		end)
	end)
	if MgrMgr:GetMgr("AchievementMgr").IsFinish(data) then
		self.Parameter.NoFinish:SetActiveEx(false)
	else
		self.Parameter.NoFinish:SetActiveEx(true)
	end
	self.Parameter.RedPrompt:SetActiveEx(false)
	self.Parameter.Selected:SetActiveEx(false)
	if self._mgr.IsAchievementCanAward(self.Data) then
		self.Parameter.RedPrompt:SetActiveEx(true)
	else
		self.Parameter.RedPrompt:SetActiveEx(false)
	end
	self.Parameter.IndexText.LabText=MgrMgr:GetMgr("AchievementMgr").IntToRomanNumeral(self.ShowIndex)
	
end --func end
--next--
function AchievementPileTemplate:OnDestroy()
	
	self.Data=nil
	self._mgr=nil
	
end --func end
--next--
function AchievementPileTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementPileTemplate:ShowSelect()
	self.Parameter.Selected:SetActiveEx(true)
	self.Parameter.RedPrompt:SetActiveEx(false)
	self.MethodCallback(self.ShowIndex)
end

function AchievementPileTemplate:HidSelect()
	if self._mgr.IsAchievementCanAward(self.Data) then
		self.Parameter.RedPrompt:SetActiveEx(true)
	else
		self.Parameter.RedPrompt:SetActiveEx(false)
	end
	self.Parameter.Selected:SetActiveEx(false)
end

function AchievementPileTemplate:HideRedSign()
	self.Parameter.RedPrompt:SetActiveEx(false)
end
--lua custom scripts end
return AchievementPileTemplate