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
---@class TowerDefenseAnimationTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Trail MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field GetMagicAnimation MoonClient.MLuaUICom
---@field FromPosition MoonClient.MLuaUICom

---@class TowerDefenseAnimationTemplate : BaseUITemplate
---@field Parameter TowerDefenseAnimationTemplateParameter

TowerDefenseAnimationTemplate = class("TowerDefenseAnimationTemplate", super)
--lua class define end

--lua functions
function TowerDefenseAnimationTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function TowerDefenseAnimationTemplate:BindEvents()
	
	
end --func end
--next--
function TowerDefenseAnimationTemplate:OnDestroy()
	
	
end --func end
--next--
function TowerDefenseAnimationTemplate:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseAnimationTemplate:OnSetData(data)
	
	local l_manaCount=data.MagicCount
	--logGreen("111")
	self:SetGameObjectActive(true)
	self.Parameter.FromPosition.gameObject:SetRectTransformPos(data.PositionX,data.PositionY)
	local l_animation=self.Parameter.GetMagicAnimation.FxAnim
	l_animation:PlayAll()
	local l_trailGameObject=self.Parameter.Trail.gameObject
	local l_trail=l_trailGameObject:GetComponent("TrailRenderer")
	l_trail:Clear()
	l_trail.enabled = true
	l_animation:addFinishCallbackByIndex(function()
		local l_mgr=MgrMgr:GetMgr("TowerDefenseMgr")
		l_mgr.EventDispatcher:Dispatch(l_mgr.AnimationTemplateFinishEvent,self,l_manaCount)
		if not MLuaCommonHelper.IsNull(l_trailGameObject) then
			l_trailGameObject:GetComponent("TrailRenderer").enabled = false
		end
		--logGreen("222")
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return TowerDefenseAnimationTemplate