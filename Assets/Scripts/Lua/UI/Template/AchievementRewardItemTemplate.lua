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
---@class AchievementRewardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field NotAward MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class AchievementRewardItemTemplate : BaseUITemplate
---@field Parameter AchievementRewardItemTemplateParameter

AchievementRewardItemTemplate = class("AchievementRewardItemTemplate", super)
--lua class define end

--lua functions
function AchievementRewardItemTemplate:Init()
	
	    super.Init(self)
	self._data=nil
	self.Parameter.ItemButton:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	self.Parameter.Selected:SetActiveEx(false)
	
end --func end
--next--
function AchievementRewardItemTemplate:OnDestroy()
	
	self._data=nil
	
end --func end
--next--
function AchievementRewardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementRewardItemTemplate:OnSetData(data)
	
	self._data=data
	local l_mgr=MgrMgr:GetMgr("AchievementMgr")
	--local l_award=data.Award
	local l_awardData= l_mgr.GetAchievementAwardDatas(data.Award)
	if l_awardData==nil or #l_awardData==0 then
		logError("奖励数据出问题了,id："..tostring(data.Award))
		return
	end
	local l_award=l_awardData[1]
	--l_award.id=1010000
	--l_award.count=100
	local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_award.item_id)
	if l_itemTableInfo==nil then
		logError("AchievementTotalPointsAwardTable表的Award字段配置有问题："..data.Id)
		return
	end
	self.Parameter.Icon:SetSprite(l_itemTableInfo.ItemAtlas, l_itemTableInfo.ItemIcon, true)
	self.Parameter.Name.LabText = l_itemTableInfo.ItemName
	self.Parameter.Count.LabText = tostring(data.Point)
	self:ShowRedSign()
	if l_mgr.IsAchievementPointRewarded(data.Id) then
		self.Parameter.NotAward:SetActiveEx(false)
	else
		self.Parameter.NotAward:SetActiveEx(true)
	end
	
end --func end
--next--
function AchievementRewardItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementRewardItemTemplate:OnSelect()
	self.Parameter.RedPrompt:SetActiveEx(false)
	self.Parameter.Selected:SetActiveEx(true)
end
function AchievementRewardItemTemplate:OnDeselect()
	self.Parameter.Selected:SetActiveEx(false)
	self:ShowRedSign()
end

function AchievementRewardItemTemplate:ShowRedSign()
	if self._data==nil then
		return
	end

	local l_mgr=MgrMgr:GetMgr("AchievementMgr")
	if l_mgr.IsAchievementPointRewarded(self._data.Id) or self._data.Point>l_mgr.TotalAchievementPoint then
		self.Parameter.RedPrompt:SetActiveEx(false)
	else
		self.Parameter.RedPrompt:SetActiveEx(true)
	end
end
--lua custom scripts end
return AchievementRewardItemTemplate