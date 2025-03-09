--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipBGPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
---@class EquipBgCtrl
EquipBGCtrl = class("EquipBGCtrl", super)
--lua class define end

--lua functions
function EquipBGCtrl:ctor()
    super.ctor(self, CtrlNames.EquipBG, UILayer.Function, nil, ActiveType.Exclusive)
    self.IsGroup = true
end --func end
--next--
function EquipBGCtrl:Init()
    self.panel = UI.EquipBGPanel.Bind(self)
    super.Init(self)
    self._selectEquipTemplate = self:NewTemplate("SelectEquipTemplate", {
        TemplateParent = self.panel.SelectEquipParent.Transform,
    })

    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.EquipBG)
    end)

end --func end
--next--
function EquipBGCtrl:SetupHandlers()
    local l_handlerTb = {}
    local l_defaultHandlerName = nil
    local l_showMgr = MgrMgr:GetMgr("ShowEquipPanleMgr")
    if l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.MakeHole or l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.EquipCardForge then
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MakeHole) then
            table.insert(l_handlerTb, { HandlerNames.EquipMakeHole, Lang("MakeHoleText"), "CommonIcon", "UI_CommonIcon_Tab_dadong_01.png", "UI_CommonIcon_Tab_dadong_02.png" })
        end

        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard) then
            table.insert(l_handlerTb, { HandlerNames.EquipCardForge, Lang("EQUIP_INSERT_CARD"), "CommonIcon", "UI_CommonIcon_Tab_chaka_01.png", "UI_CommonIcon_Tab_chaka_02.png" })
        end

        if l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.MakeHole then
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MakeHole) then
                l_defaultHandlerName = HandlerNames.EquipMakeHole
            end
        else
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard) then
                l_defaultHandlerName = HandlerNames.EquipCardForge
            end
        end
    elseif l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.Enchant or l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.EnchantAdvanced then
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant) then
            table.insert(l_handlerTb, { HandlerNames.EquipEnchant, Lang("LowLevelText"), "CommonIcon", "UI_CommonIcon_Tab_chujifumo_01.png", "UI_CommonIcon_Tab_chujifumo_02.png" })
        end

        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EnchantAdvanced) then
            table.insert(l_handlerTb, { HandlerNames.EquipEnchantAdvanced, Lang("HighLevelText"), "CommonIcon", "UI_CommonIcon_Tab_gaojifumo_01.png", "UI_CommonIcon_Tab_gaojifumo_02.png" })
        end

        if l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.Enchant then
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant) then
                l_defaultHandlerName = HandlerNames.EquipEnchant
            end
        else
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EnchantAdvanced) then
                l_defaultHandlerName = HandlerNames.EquipEnchantAdvanced
            end
        end
    end

    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, l_defaultHandlerName)
end --func end
--next--
function EquipBGCtrl:Uninit()
    self._selectEquipTemplate = nil
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function EquipBGCtrl:OnActive()

    local l_showMgr = MgrMgr:GetMgr("ShowEquipPanleMgr")
    if l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.Enchant
            or l_showMgr.CurrentShowEquipPanelType == l_showMgr.eShowEquipPanelType.EnchantAdvanced
    then
        self._selectEquipTemplate:SetData({
            SelectEquipMgrName = "EnchantMgr",
            DefaultHideNoneText = true
        })
    end

end --func end
--next--
function EquipBGCtrl:OnDeActive()


end --func end
--next--
function EquipBGCtrl:Update()


end --func end


--next--
function EquipBGCtrl:OnReconnected()
    super.OnReconnected(self)
    self._selectEquipTemplate:OnReconnected()
end --func end


--next--
function EquipBGCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function EquipBGCtrl:OnHandlerSwitch(handlerName)
    if self.curHandler then
        if self.curHandler.ShowSelectEquip then
            self.curHandler:ShowSelectEquip()
        end
    end
end

---@return SelectEquipTemplate
function EquipBGCtrl:GetSelectEquipTemplate()
    return self._selectEquipTemplate
end

function EquipBGCtrl:ShowCard()
    self:SelectOneHandler(UI.HandlerNames.EquipCardForge)
end

function EquipBGCtrl:ShowMakeHole()
    self:SelectOneHandler(UI.HandlerNames.EquipMakeHole)
end
--lua custom scripts end
