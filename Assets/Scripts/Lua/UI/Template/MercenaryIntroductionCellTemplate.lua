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
---@class MercenaryIntroductionCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SchoolText MoonClient.MLuaUICom
---@field School MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field Male MoonClient.MLuaUICom
---@field Gender MoonClient.MLuaUICom
---@field Female MoonClient.MLuaUICom
---@field ContentText MoonClient.MLuaUICom
---@field ConstellationImg MoonClient.MLuaUICom
---@field Constellation MoonClient.MLuaUICom

---@class MercenaryIntroductionCellTemplate : BaseUITemplate
---@field Parameter MercenaryIntroductionCellTemplateParameter

MercenaryIntroductionCellTemplate = class("MercenaryIntroductionCellTemplate", super)
--lua class define end

--lua functions
function MercenaryIntroductionCellTemplate:Init()
	
	super.Init(self)
	    self.Parameter.ConstellationImg.Listener.onDown = function(go, eventData)
	        if self.constellationName then
	            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.constellationName, eventData, Vector2(0, 0), true)
	        end
	    end
	
end --func end
--next--
function MercenaryIntroductionCellTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenaryIntroductionCellTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryIntroductionCellTemplate:OnSetData(data)
	
	    self.Parameter.Gender:SetActiveEx(false)
	    self.Parameter.School:SetActiveEx(false)
	    self.Parameter.Constellation:SetActiveEx(false)
	    self.Parameter.ContentText:SetActiveEx(true)
	    local l_sizeFitter = self.Parameter.ContentText:GetComponent("ContentSizeFitter")
	    --l_sizeFitter.horizontalFit = FitMode.PreferredSize
	    --l_sizeFitter.verticalFit = FitMode.Unconstrained
	    local l_isBirthday = false
	    if string.find(data.des, "birthday") then
	        l_isBirthday = true
            data.des = string.gsub(data.des, "birthday", "")
	    end
        self.Parameter.NameText.LabText = data.des
	    self.constellationName = nil
        self.Parameter.ContentText:SetActiveEx(false)
	    if l_isBirthday then
	        self.Parameter.Constellation:SetActiveEx(true)
	        self.Parameter.ConstellationImg:SetSprite(data.mercenaryInfo.tableInfo.ConstellationAtlas, data.mercenaryInfo.tableInfo.ConstellationIcon)
	        self.constellationName = data.mercenaryInfo.tableInfo.Constellation
	    elseif data.schoolName then
	        self.Parameter.School:SetActiveEx(true)
	        self.Parameter.SchoolText.LabText = data.schoolName
	        --刷新布局
	        LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.School.RectTransform)
	    elseif data.isMale then
	        self.Parameter.Gender:SetActiveEx(true)
	        self.Parameter.Male:SetActiveEx(true)
	        self.Parameter.Female:SetActiveEx(false)
	    elseif data.isFemale then
	        self.Parameter.Gender:SetActiveEx(true)
	        self.Parameter.Male:SetActiveEx(false)
	        self.Parameter.Female:SetActiveEx(true)
	    else
	        --l_sizeFitter.horizontalFit = FitMode.Unconstrained
	        --l_sizeFitter.verticalFit = FitMode.PreferredSize
	        self.Parameter.ContentText.RectTransform.sizeDelta.x = 160
	        --刷新布局
	        LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.ContentText.RectTransform)
	    end
	    self.Parameter.ContentText.LabText = l_content
	    --刷新布局
	    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.LuaUIGroup.RectTransform)
	
end --func end
--next--
function MercenaryIntroductionCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryIntroductionCellTemplate