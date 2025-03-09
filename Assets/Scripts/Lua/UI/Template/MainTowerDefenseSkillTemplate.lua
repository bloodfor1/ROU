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
---@class MainTowerDefenseSkillTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillIcon MoonClient.MLuaUICom
---@field SkillButton MoonClient.MLuaUICom
---@field ImgCD MoonClient.MLuaUICom

---@class MainTowerDefenseSkillTemplate : BaseUITemplate
---@field Parameter MainTowerDefenseSkillTemplateParameter

MainTowerDefenseSkillTemplate = class("MainTowerDefenseSkillTemplate", super)
--lua class define end

--lua functions
function MainTowerDefenseSkillTemplate:Init()
	
	    super.Init(self)
	    self.data=nil

	self.Parameter.SkillButton.LongBtn.onClick = function(go, eventData)
		if self.data == nil then
			return
		end
		local l_mgr = MgrMgr:GetMgr("TowerDefenseMgr")
		l_mgr.ReqCommandSpirit({ summon_id = l_mgr.SummonCircleId, servant_cmd = self.data.ID })
	end

	self.Parameter.SkillButton.LongBtn.onLongClick = function(go, eventData)
		if self.data == nil then
			return
		end
		local l_pointEventData = {}
		l_pointEventData.position = Input.mousePosition
		l_pointEventData.pressEventCamera=MUIManager.UICamera
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.data.Desc, l_pointEventData, Vector2(0, 0), true)
	end

	
end --func end
--next--
function MainTowerDefenseSkillTemplate:OnDestroy()
	
	    self.data=nil
	
end --func end
--next--
function MainTowerDefenseSkillTemplate:OnDeActive()
	
	
end --func end
--next--
function MainTowerDefenseSkillTemplate:OnSetData(data)
	
	    self.data=data
	    --logGreen("SetSpriteAsync")
	    self.Parameter.SkillIcon:SetSpriteAsync(data.IconAtlas, data.IconName)
	    self:_showCd()
	
end --func end
--next--
function MainTowerDefenseSkillTemplate:BindEvents()
	
	    local l_mgr=MgrMgr:GetMgr("TowerDefenseMgr")
	    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ReceiveTowerDefenseMagicPowerNtfEvent, function()
	        self:_showCd()
	    end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MainTowerDefenseSkillTemplate:_showCd()
    if self.data == nil then
        return
    end

    if self.Parameter.ImgCD.GradualChange:IsPlaying() then
        return
    end

    local l_mgr=MgrMgr:GetMgr("TowerDefenseMgr")
    local l_currentTime = l_mgr.GetSkillCdWithId(self.data.ID)

    if l_currentTime <= 0 then
        self.Parameter.ImgCD:SetActiveEx(false)
    else
        self.Parameter.ImgCD:SetActiveEx(true)
        self.Parameter.ImgCD.GradualChange:SetData(l_currentTime,false)
        self.Parameter.ImgCD.GradualChange:SetTotalValue(self.data.CoolDown)
        self.Parameter.ImgCD.GradualChange:Play()
    end
end
--lua custom scripts end
return MainTowerDefenseSkillTemplate