--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillAttrPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SkillAttrCtrl = class("SkillAttrCtrl", super)
--lua class define end

--lua functions
function SkillAttrCtrl:ctor()

    super.ctor(self, CtrlNames.SkillAttr, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function SkillAttrCtrl:Init()

    self.panel = UI.SkillAttrPanel.Bind(self)
    self.data = DataMgr:GetData("SkillData")
    super.Init(self)
    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.SkillAttr)
    end)
    self.panelCanvas = self.panel.SkillPanel:GetComponent("CanvasGroup")

end --func end
--next--
function SkillAttrCtrl:Uninit()

    self.data = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SkillAttrCtrl:OnActive()
    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.ShowSkillInfo then
            self:ShowSkillInfo(self.uiPanelData.position, self.uiPanelData.data,self.uiPanelData.pivot)
        end
    end
end --func end
--next--
function SkillAttrCtrl:OnDeActive()


end --func end
--next--
function SkillAttrCtrl:Update()


end --func end



--next--
function SkillAttrCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
---@param AttrData SkillUIData
function SkillAttrCtrl:ShowSkillInfo(position, AttrData,pivot)
    if AttrData.type == 3 then
        l_skill = self.data.GetDataFromTable("BuffTable", AttrData.id)
        if l_skill == nil then
            logError("BuffTable not have" .. AttrData.id)
            return
        end
        self.panel.Desc.LabText = l_skill.Description
    else
        l_skill = self.data.GetDataFromTable("SkillTable", AttrData.id)
        if l_skill == nil then
            logError("SkillTable not have" .. AttrData.id)
            return
        end
        self.panel.Desc.LabText = l_skill.Desc
    end
    local pivot = pivot and pivot or Vector2.New(0.5,0.5)
    self:AdjustBoundary(position,pivot)
end

function SkillAttrCtrl:ShowDescription(position, description)

    self.panel.SkillPanel.transform:SetPos(position)
    self.panel.Desc.LabText = description

end

function SkillAttrCtrl:AdjustBoundary(position,pivot)
    self.panel.SkillPanel.RectTransform.pivot = pivot
    self.panel.SkillPanel.transform:SetPos(position)
    self.panelCanvas.alpha = 0
    local func = function()
        local contentLocalPos =self.panel.SkillPanel.transform.localPosition --self.panel.SkillPanel.RectTransform.anchoredPosition
        local contentSize = self.panel.SkillPanelRect.RectTransform.sizeDelta
        local resolution = MUIManager:GetCanvasScalerReferenceResolution()
        local screenWidth = resolution.x
        local screenHeight = resolution.y
        local xMin = pivot.x * contentSize.x - screenWidth / 2                  -- contentSize.x / 2 - screenWidth / 2 + (pivot.x - 0.5) * contentSize.x
        local xMax = screenWidth / 2 + (pivot.x - 1) * contentSize.x            -- screenWidth / 2 - contentSize.x / 2 + (pivot.x - 0.5) * contentSize.x
        local yMin = pivot.y * contentSize.y - screenHeight / 2                 -- contentSize.y / 2 - screenHeight / 2 + (pivot.y - 0.5) * contentSize.y
        local yMax = screenHeight / 2 + (pivot.y - 1) * contentSize.y           -- screenHeight / 2 - contentSize.y / 2 + (pivot.y - 0.5) * contentSize.y
        if contentLocalPos.x < xMin then
            contentLocalPos.x = xMin
        end
        if contentLocalPos.x > xMax then
            contentLocalPos.x = xMax
        end
        if contentLocalPos.y < yMin then
            contentLocalPos.y = yMin
        end
        if contentLocalPos.y > yMax then
            contentLocalPos.y = yMax
        end
        self.panel.SkillPanel.RectTransform.anchoredPosition = contentLocalPos
        self.panelCanvas.alpha = 1
    end
    self:NewUITimer(func,0.07,1):Start()
end

--lua custom scripts end
