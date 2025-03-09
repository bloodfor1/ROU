--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ReturnTaskItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Step MoonClient.MLuaUICom
---@field RewardRoot MoonClient.MLuaUICom
---@field Received MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field BtnReceive MoonClient.MLuaUICom

---@class ReturnTaskItem : BaseUITemplate
---@field Parameter ReturnTaskItemParameter

ReturnTaskItem = class("ReturnTaskItem", super)
--lua class define end

--lua functions
function ReturnTaskItem:Init()
	
	super.Init(self)

	self.Parameter.BtnReceive:AddClickWithLuaSelf(self.OnBtnReceive,self)
	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.itemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		TemplateParent = self.Parameter.RewardRoot.transform
	})
	
end --func end
--next--
function ReturnTaskItem:BindEvents()
	
	
end --func end
--next--
function ReturnTaskItem:OnDestroy()
	
	
end --func end
--next--
function ReturnTaskItem:OnDeActive()
	
	
end --func end
--next--
function ReturnTaskItem:OnSetData(data)
	if data then
		self.data = data
		self:RefreshTemplate()
	end
end --func end
--next--
--lua functions end

--lua custom scripts

function ReturnTaskItem:RefreshTemplate()
	self.Parameter.Name.LabText = self.data.cfg.ReturnTaskContent
	self.Parameter.Step.LabText = StringEx.Format(" ({0}/{1})",self.data.step,self.data.cfg.RuturnTaskParameter)
	self.Parameter.Received:SetActiveEx(self.data.isTaken)
	self.Parameter.BtnReceive:SetActiveEx(not self.data.isTaken)
	self.Parameter.BtnReceive:SetGray(not (self.data.isFinish and not self.data.isTaken))

	local itemPairs = {}
	local award = self.data.cfg.RuturnTaskAward
	for i=0,award.Length-1 do
		local awardCfg = TableUtil.GetAwardTable().GetRowByAwardId(award[i])
		for j=0,awardCfg.PackIds.Length - 1 do
			local awardPackCfg = TableUtil.GetAwardPackTable().GetRowByPackId(awardCfg.PackIds[j]).GroupContent
			for k = 0,awardPackCfg.Length - 1 do
				local itemPair = {
					ID = awardPackCfg[k][0],
					IsShowCount = true,
					Count = awardPackCfg[k][1]
				}
				table.insert(itemPairs,itemPair)
			end
		end
	end
	self.itemPool:ShowTemplates({ Datas = itemPairs })
end

function ReturnTaskItem:OnBtnReceive()
	if not self.data then return end
	if self.data.isFinish then
		self.mgr.ReqFinishTask(self.data.taskID)
	elseif not self.data.isFinish and not self.data.isTaken then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Return_Task_Tips_CantGet"))
	end
end

--lua custom scripts end
return ReturnTaskItem