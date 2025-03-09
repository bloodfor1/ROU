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
---@class TDAwardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Progress MoonClient.MLuaUICom
---@field GetAwardButtonText MoonClient.MLuaUICom
---@field GetAwardButton MoonClient.MLuaUICom
---@field Divide MoonClient.MLuaUICom
---@field Description MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field AwardItemScrollRect MoonClient.MLuaUICom

---@class TDAwardTemplate : BaseUITemplate
---@field Parameter TDAwardTemplateParameter

TDAwardTemplate = class("TDAwardTemplate", super)
--lua class define end

--lua functions
function TDAwardTemplate:Init()
	
	super.Init(self)
	self.data=nil
	self.awardItemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		ScrollRect=self.Parameter.AwardItemScrollRect.LoopScroll,
		TemplatePath = "UI/Prefabs/ItemPrefab"
	})
	self.Parameter.GetAwardButton:AddClick(function()
		if self.data == nil then
			return
		end
		MgrMgr:GetMgr("TowerDefenseMgr").RequestGetTowerDefenseWeekAward(self.data.ID)
	end)
	self._descriptionColor= self.Parameter.Description.LabColor
	self._progressColor=self.Parameter.Progress.LabColor
	self._divideColor=self.Parameter.Divide.Img.color
	
end --func end
--next--
function TDAwardTemplate:BindEvents()
	
	
end --func end
--next--
function TDAwardTemplate:OnDestroy()
	
	
end --func end
--next--
function TDAwardTemplate:OnDeActive()
	
	
end --func end
--next--
function TDAwardTemplate:OnSetData(data)
	
	self.data=data
	local l_mgr=MgrMgr:GetMgr("TowerDefenseMgr")
	local l_isGetAward=l_mgr.IsGetAwardWithId(data.ID,data.Type)
	local l_awardData= l_mgr.GetTDAwardDataWithAwardId(data.Award)
	if l_awardData then
		local l_itemDatas={}
		for i = 1, #l_awardData do
			local l_itemData={
				ID = l_awardData[i].item_id,
				IsShowCount = true,
				Count = l_awardData[i].count,
				IsGray=l_isGetAward,
				IsShowTips = true}
			table.insert(l_itemDatas, l_itemData)
		end
		self.awardItemPool:ShowTemplates({ Datas = l_itemDatas })
	else
		logError("奖励是空的")
	end
	self.Parameter.Description.LabText = StringEx.Format(data.Des, data.Arg)
	local l_currentProgress=l_mgr.GetAwardTaskProgressWithType(data.Type)
	if l_currentProgress<data.Arg or l_isGetAward then
		self.Parameter.GetAwardButton:SetGray(true)
	else
		self.Parameter.GetAwardButton:SetGray(false)
	end
	local l_currentProgressOnText=l_currentProgress
	if l_currentProgressOnText>data.Arg then
		l_currentProgressOnText=data.Arg
	end
	self.Parameter.Progress.LabText =l_currentProgressOnText.."/"..data.Arg

	self.Parameter.GetAwardButtonText.LabText =Lang("ButtonText_AwardGet")
	if l_isGetAward then
		self.Parameter.BG:SetGray(true)
		self.Parameter.Divide:SetGray(true)
		self.Parameter.Description.LabColor = RoColor.Hex2Color(RoColor.WordColor.Gray[1])
		self.Parameter.Progress.LabColor = RoColor.Hex2Color(RoColor.WordColor.Gray[1])
		self.Parameter.GetAwardButtonText.LabText =Lang("ButtonText_AwardGetFinish")
	else
		self.Parameter.BG:SetGray(false)
		self.Parameter.Divide.Img.color=self._divideColor
		--self.Parameter.Divide:SetGray(false)
		self.Parameter.Description.LabColor = self._descriptionColor
		self.Parameter.Progress.LabColor = self._progressColor
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return TDAwardTemplate