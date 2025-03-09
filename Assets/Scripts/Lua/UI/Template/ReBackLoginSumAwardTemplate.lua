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
---@class ReBackLoginSumAwardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemPrefabParent MoonClient.MLuaUICom
---@field GetAward MoonClient.MLuaUICom
---@field DayText MoonClient.MLuaUICom

---@class ReBackLoginSumAwardTemplate : BaseUITemplate
---@field Parameter ReBackLoginSumAwardTemplateParameter

ReBackLoginSumAwardTemplate = class("ReBackLoginSumAwardTemplate", super)
--lua class define end

--lua functions
function ReBackLoginSumAwardTemplate:Init()
	
	super.Init(self)
	self.awardItemTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.Parameter.ItemPrefabParent.Transform,
	})

	self.Parameter.GetAwardButton:AddClickWithLuaSelf(self._onGetAwardButton,self)
	
end --func end
--next--
function ReBackLoginSumAwardTemplate:BindEvents()
	local reBackLoginMgr = MgrMgr:GetMgr("ReBackLoginMgr")
	self:BindEvent(reBackLoginMgr.EventDispatcher, reBackLoginMgr.ReceiveGetReturnLoginPrizeEvent, self._onGetAward)
	
end --func end
--next--
function ReBackLoginSumAwardTemplate:OnDestroy()
	self.Parameter.CanGetAwardEffect:StopDynamicEffect()
	
end --func end
--next--
function ReBackLoginSumAwardTemplate:OnDeActive()
	
	
end --func end
--next--
function ReBackLoginSumAwardTemplate:OnSetData(data)
	self:_showTemplateWithData(data)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ReBackLoginSumAwardTemplate:_showTemplateWithData(data)

	local awardTable = data.AwardList
	if #awardTable == 0 then
		logError("回归奖励的奖励数据是空的")
		return
	end
	local award = awardTable[1]
	local itemData = {
		ID = award.item_id,
		IsShowCount = true,
		Count = award.count,
		IsShowTips = true }

	self.awardItemTemplate:SetData(itemData)

	self.Parameter.DayText.LabText = Lang("ReBackLogin_SumAwardTemplateTitle",data.Day)

	local reBackLoginMgr=MgrMgr:GetMgr("ReBackLoginMgr")
	self.Parameter.CanGetAwardEffect:SetActiveEx(false)
	self.Parameter.CanGetAwardEffect:StopDynamicEffect()
	self.Parameter.GetAwardFinish:SetActiveEx(false)

	if reBackLoginMgr.IsSumAwardCanGet(self.ShowIndex) then
		self.Parameter.CanGetAwardEffect:SetActiveEx(true)
		self.Parameter.CanGetAwardEffect:PlayDynamicEffect()
	elseif reBackLoginMgr.IsSumAwardGetFinish(self.ShowIndex) then
		self.Parameter.GetAwardFinish:SetActiveEx(true)
	end

end

function ReBackLoginSumAwardTemplate:_onGetAward(isDaily, index)
	if isDaily then
		return
	end
	if index~=self.ShowIndex-1 then
		return
	end
	self.Parameter.GetAwardFinish:SetActiveEx(true)
end

function ReBackLoginSumAwardTemplate:_onGetAwardButton()
	MgrMgr:GetMgr("ReBackLoginMgr").RequestGetReturnLoginPrize(false, self.ShowIndex-1)
end
--lua custom scripts end
return ReBackLoginSumAwardTemplate