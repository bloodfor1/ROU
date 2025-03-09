--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PropertyPreviewPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
PropertyPreviewPanelCtrl = class("PropertyPreviewPanelCtrl", super)
--lua class define end

--lua functions
function PropertyPreviewPanelCtrl:ctor()
    super.ctor(self, CtrlNames.PropertyPreviewPanel, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.PropertyPreviewPanel
end --func end
--next--
function PropertyPreviewPanelCtrl:Init()
    self.panel = UI.PropertyPreviewPanelPanel.Bind(self)
    super.Init(self)

    self:_initTemplatePoolConfig()
    self:_initWidgets()
end --func end
--next--
function PropertyPreviewPanelCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function PropertyPreviewPanelCtrl:OnActive()
    self:_showAttrs()
end --func end
--next--
function PropertyPreviewPanelCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function PropertyPreviewPanelCtrl:Update()
    -- do nothing
end --func end
--next--
function PropertyPreviewPanelCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function PropertyPreviewPanelCtrl:_initTemplatePoolConfig()
    self._attrTemplatePoolConfig = {
        TemplateClassName = "MakeHolePropertyPreviewTemplate",
        TemplatePath = "UI/Prefabs/MakeHolePropertyPreviewPrefab",
        TemplateParent = self.panel.PropertyPreviewParent.Transform,
    }
end

function PropertyPreviewPanelCtrl:_initWidgets()
    self._attrTemplatePool = self:NewTemplatePool(self._attrTemplatePoolConfig)
    --local onClose = function()
    --    self:_onClose()
    --end
    --
    --self.panel.ClosePropertyPreviewPanelButton:AddClick(onClose)
end

function PropertyPreviewPanelCtrl:_onClose()
    UIMgr:DeActiveUI(UI.CtrlNames.PropertyPreviewPanel)
end

function PropertyPreviewPanelCtrl:_showAttrs()
    local inputParam = self.uiPanelData
    local templatePoolParam = { Datas = inputParam }
    self._attrTemplatePool:ShowTemplates(templatePoolParam)
end

--lua custom scripts end
return PropertyPreviewPanelCtrl