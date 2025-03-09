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
---@class PollyTypeAwardNodeTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Seal MoonClient.MLuaUICom
---@field On MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field AwardNode MoonClient.MLuaUICom
---@field AwardFx MoonClient.MLuaUICom

---@class PollyTypeAwardNodeTemplate : BaseUITemplate
---@field Parameter PollyTypeAwardNodeTemplateParameter

PollyTypeAwardNodeTemplate = class("PollyTypeAwardNodeTemplate", super)
--lua class define end
local l_awardFxPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_BoLiTuan_JiangLi_01" 
--lua functions
function PollyTypeAwardNodeTemplate:Init()
	
	super.Init(self)
	self._itemTemplate = self:NewTemplate("ItemTemplate",{
	        TemplateParent = self.Parameter.Item.transform,
	    })
	self.data = nil
	self.fxAward = nil
	
end --func end

function PollyTypeAwardNodeTemplate:Uninit()
   	if self.fxAward ~= nil then
        self:DestroyUIEffect(self.fxAward )
        self.fxAward  = nil
    end
	super.Uninit(self)
end --func end


--next--
function PollyTypeAwardNodeTemplate:BindEvents()
	
	
end --func end
--next--
function PollyTypeAwardNodeTemplate:OnDestroy()
	
	
end --func end
--next--
function PollyTypeAwardNodeTemplate:OnDeActive()
	
	
end --func end
--next--
function PollyTypeAwardNodeTemplate:OnSetData(data)
	
	self.data = data
	self.Parameter.Count.LabText = tostring(data.award.count) 
	self.Parameter.Seal:SetActiveEx(data.award.gotAward)
	self.Parameter.On:SetActiveEx(data.award.finish)
	local l_showAwardFx = self.data.award.finish and not self.data.award.gotAward
	self.Parameter.AwardFx:SetActiveEx(l_showAwardFx)
	if l_showAwardFx then
		if 	self.fxAward ~= nil then
			self.Parameter.AwardFx.gameObject:SetActiveEx(true)
		else
			local l_fxData = {}
			l_fxData.rawImage = self.Parameter.AwardFx.RawImg
			l_fxData.loadedCallback = function(a) 
				self.Parameter.AwardFx.gameObject:SetActiveEx(true) 
			end
			l_fxData.destroyHandler = function ()
	            self.fxAward = nil
	            self.Parameter.AwardFx.gameObject:SetActiveEx(false)
	        end
	        self.fxAward = self:CreateUIEffect(l_awardFxPath, l_fxData)
	        
		end

	end
	self._itemTemplate:SetData({ID = data.previewItemId,Count = data.previewCount, IsShowCount = data.isShowCount ,ButtonMethod = function ( ... )
		if not self.data.award.finish or self.data.award.gotAward then
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.previewItemId)
			return
		end
		local l_mgr = MgrMgr:GetMgr("BoliGroupMgr")
		l_mgr.RequestGetPollyAward(l_mgr.EPollyAwardType.PollyType,data.award.typeId,data.award.count)
	end})
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return PollyTypeAwardNodeTemplate