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
---@class PollyRegionRewardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Seal MoonClient.MLuaUICom
---@field CountText MoonClient.MLuaUICom
---@field ContentItem MoonClient.MLuaUICom
---@field Btn_Receive MoonClient.MLuaUICom

---@class PollyRegionRewardTemplate : BaseUITemplate
---@field Parameter PollyRegionRewardTemplateParameter

PollyRegionRewardTemplate = class("PollyRegionRewardTemplate", super)
--lua class define end

--lua functions
function PollyRegionRewardTemplate:Init()
	
	super.Init(self)
	self._awardItemTemplatePool = self:NewTemplatePool({
			TemplateClassName = "ItemTemplate",
	        TemplateParent = self.Parameter.ContentItem.transform
	    })
	
end --func end
--next--
function PollyRegionRewardTemplate:BindEvents()
	
	
end --func end
--next--
function PollyRegionRewardTemplate:OnDestroy()
	
	
end --func end
--next--
function PollyRegionRewardTemplate:OnDeActive()
	
	
end --func end
--next--
function PollyRegionRewardTemplate:OnSetData(data)
	
	self.Parameter.CountText.LabText = StringEx.Format(Common.Utils.Lang("POLLY_REGION_COUNT_TIP"),data.award.count)
	self.Parameter.Seal.gameObject:SetActiveEx(data.award.gotAward)
	self.Parameter.Btn_Receive.gameObject:SetActiveEx(not data.award.gotAward)
	if not data.gotAward then
		self.Parameter.Btn_Receive:SetGray(not data.award.finish)
		if data.award.finish then
			self.Parameter.Btn_Receive:AddClick(function( ... )
				local l_mgr = MgrMgr:GetMgr("BoliGroupMgr")
				l_mgr.RequestGetPollyAward(l_mgr.EPollyAwardType.Region,data.award.regionId,data.award.count)
			end)
		end
	end	
	self._awardItemTemplatePool:ShowTemplates({Datas = data.awardData})
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return PollyRegionRewardTemplate