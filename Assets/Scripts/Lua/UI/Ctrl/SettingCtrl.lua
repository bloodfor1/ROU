--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SettingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SettingCtrl = class("SettingCtrl", super)
--lua class define end

--lua functions
function SettingCtrl:ctor()
    super.ctor(self, CtrlNames.Setting, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
end --func end
--next--

function SettingCtrl:Init()

    self.panel = UI.SettingPanel.Bind(self)
    super.Init(self)

    self.panel.BtnClose:AddClick(function()
        MgrMgr:GetMgr("AnnounceMgr").SetIsShow(false)
        UIMgr:DeActiveUI(self.name)
    end)
    self:SetPlayerHandlerScrollTo(nil)
    self.handlerNames = {
        HandlerNames.SettingSystem,
        HandlerNames.SettingPlayer,
        HandlerNames.SettingAuto,
		HandlerNames.SettingPushNotification
    }
end --func end
--next--
function SettingCtrl:Uninit()

    self:SetPlayerHandlerScrollTo(nil)
    super.Uninit(self)

    self.panel = nil

end --func end

function SettingCtrl:SetupHandlers()

    local l_handlerTb = {
        { HandlerNames.SettingSystem, Lang("SETTING_TAG_SYSTEM"), "CommonIcon", "UI_CommonIcon_Tabicon_xitong_01.png", "UI_CommonIcon_Tabicon_xitong_01.png" },
        { HandlerNames.SettingPlayer, Lang("SETTING_TAG_PLAYER"), "CommonIcon", "UI_CommonIcon_Tabicon_geren_01.png", "UI_CommonIcon_Tabicon_geren_01.png" },
        { HandlerNames.SettingAuto, Lang("SETTING_TAG_AUTO"), "CommonIcon", "UI_CommonIcon_Tabicon_guaji_01.png", "UI_CommonIcon_Tabicon_guaji_01.png" },
    }
    local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PushNotification)
    if l_tableData and l_tableData.IsOpen == 1 then
        table.insert(l_handlerTb, { HandlerNames.SettingPushNotification, Lang("SETTING_TAG_PUSH"), "CommonIcon", "UI_CommonIcon_Tabicon_Push_01.png", "UI_CommonIcon_Tabicon_Push_01.png" })
    end
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)

end

--next--
function SettingCtrl:OnActive()
	if self.uiPanelData and type(self.uiPanelData) == "table" then
		self:SelectOneHandler(self.handlerNames[self.uiPanelData.selectId])
    end
end --func end
--next--
function SettingCtrl:OnDeActive()

end --func end
--next--
function SettingCtrl:Update()
    super.Update(self)
end --func end

--next--
function SettingCtrl:BindEvents()

end --func end

--next--
function SettingCtrl:OnHandlerSwitch(handlerName)

    super.OnHandlerSwitch(self, handlerName)
    if handlerName == HandlerNames.SettingPlayer then
        if self.scrollToObjName then
            local l_handler = self:GetHandlerByName(HandlerNames.SettingPlayer)
            l_handler:ScrollToArea(self.scrollToObjName)
            self.scrollToObjName = nil
        end
    end

end --func end
--next--

--lua functions end

--lua custom scripts

function SettingCtrl:SetPlayerHandlerScrollTo(name)
    self.scrollToObjName = name
end

function SettingCtrl:SetAlpha(alpha)
    self.panel.Setting.CanvasGroup.alpha = alpha
end

--lua custom scripts end
return SettingCtrl
