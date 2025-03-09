--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipAttrPanelDummyPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
EquipAttrPanelDummyCtrl = class("EquipAttrPanelDummyCtrl", super)
--lua class define end

--lua functions
function EquipAttrPanelDummyCtrl:ctor()
    super.ctor(self, CtrlNames.EquipAttrPanelDummy, UILayer.Function, nil, ActiveType.None)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.EquipAttrPanelDummy
end --func end
--next--
function EquipAttrPanelDummyCtrl:Init()
    self.panel = UI.EquipAttrPanelDummyPanel.Bind(self)
    super.Init(self)
    self:_initTemplateConfig()

end --func end
--next--
function EquipAttrPanelDummyCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self._attrPanelList = {}
end --func end
--next--
function EquipAttrPanelDummyCtrl:OnActive()
    ---@type AttrCompareListParam[]
    self._attrData = self.uiPanelData
    self:_initWidgets()
end --func end
--next--
function EquipAttrPanelDummyCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipAttrPanelDummyCtrl:Update()
    -- do nothing
end --func end
--next--
function EquipAttrPanelDummyCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
--- 这个界面现在有两个面板，如果需要添加，这边会重新调整为layout
function EquipAttrPanelDummyCtrl:_initTemplateConfig()
    self._attrBoard1stConfig = {
        name = "ItemAttrListTemplate",
        config = {
            TemplatePath = "UI/Prefabs/ItemAttrListTemplate",
            TemplateParent = self.panel.AttrDummyLeft.Transform,
        }
    }

    self._attrBoard2ndConfig = {
        name = "ItemAttrListTemplate",
        config = {
            TemplatePath = "UI/Prefabs/ItemAttrListTemplate",
            TemplateParent = self.panel.AttrDummyRight.Transform,
        }
    }

    self._attrBoardConfigList = {
        self._attrBoard1stConfig,
        self._attrBoard2ndConfig
    }
end

function EquipAttrPanelDummyCtrl:_initWidgets()
    if nil == self._attrData then
        logError("[EquipAttrPanel] invalid param")
        return
    end

    self._attrPanelList = {}
    for i = 1, #self._attrBoardConfigList do
        if nil ~= self._attrData[i] then
            local singlePanel = self:NewTemplate(self._attrBoardConfigList[i].name, self._attrBoardConfigList[i].config)
            singlePanel:SetData(self._attrData[i])
            table.insert(self._attrPanelList, singlePanel)
        end
    end
end

--lua custom scripts end
return EquipAttrPanelDummyCtrl