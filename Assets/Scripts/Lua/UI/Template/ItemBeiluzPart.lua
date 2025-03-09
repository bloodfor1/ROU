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
---@class ItemBeiluzPartParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Weight MoonClient.MLuaUICom
---@field Star MoonClient.MLuaUICom

---@class ItemBeiluzPart : BaseUITemplate
---@field Parameter ItemBeiluzPartParameter

ItemBeiluzPart = class("ItemBeiluzPart", super)
--lua class define end

--lua functions
function ItemBeiluzPart:Init()
	
	super.Init(self)
	
end --func end
--next--
function ItemBeiluzPart:BindEvents()
	
	
end --func end
--next--
function ItemBeiluzPart:OnDestroy()
	
	
end --func end
--next--
function ItemBeiluzPart:OnDeActive()
	
	
end --func end
--next--
function ItemBeiluzPart:OnSetData(data)
	self.Parameter.WeightRoot:SetActiveEx(false)
	self.Parameter.Star:SetActiveEx(false)
	self.Parameter.WheelRoot:SetActiveEx(false)
	if data then
        if data.Weight ~= 0 then        -- 未生成属性时重量为0
            self.Parameter.WeightRoot:SetActiveEx(true)
            self.Parameter.Weight.LabText = data.Weight
        end
		local attrs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		if #attrs >= 2 then
			self.Parameter.Star:SetActiveEx(true)
		end

		local mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
		local activeState = mgr.GetActiveState(data)
		if activeState == mgr.E_ACTIVE_STATE.NoLife then
			self.Parameter.WheelRoot:SetActiveEx(true)
			self.Parameter.UseUp:SetActiveEx(true)
			self.Parameter.Active:SetActiveEx(false)
		elseif activeState == mgr.E_ACTIVE_STATE.InUse then
			self.Parameter.WheelRoot:SetActiveEx(true)
			self.Parameter.UseUp:SetActiveEx(false)
			self.Parameter.Active:SetActiveEx(true)

			self.Parameter.Active.gameObject:GetComponent("FxAnimationHelper"):PlayAll()
		end
	else
		logError("ItemBeiluzPart 传了无效data")
	end
end --func end
--next--
--lua functions end

--lua custom scripts
ItemBeiluzPart.TemplatePath = "UI/Prefabs/ItemPart/ItemBeiluzPart"
--lua custom scripts end
return ItemBeiluzPart