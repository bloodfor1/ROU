--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipAssistantBGPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_equipAssistDataMgr = MgrMgr:GetMgr("EquipAssistantDataMgr")
local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
local l_strTitle = nil

local C_HANDLER_NAME_SYS_ID_MAP = {
    [UI.HandlerNames.RefineTransfer] = openSystemMgr.eSystemId.RefineTransfer,
    [UI.HandlerNames.RefineUnseal] = openSystemMgr.eSystemId.RefineSeal,
    [UI.HandlerNames.EnchantmentExtract] = openSystemMgr.eSystemId.EnchantExtract,
    [UI.HandlerNames.EnchantInherit] = openSystemMgr.eSystemId.EnchantInherit,
}
--next--
--lua fields end

--lua class define
EquipAssistantBGCtrl = class("EquipAssistantBGCtrl", super)
--lua class define end

--lua functions
function EquipAssistantBGCtrl:ctor()
    super.ctor(self, CtrlNames.EquipAssistantBG, UILayer.Function, nil, ActiveType.Exclusive)
    self.IsGroup = true
end --func end
--next--
function EquipAssistantBGCtrl:Init()
    self.panel = UI.EquipAssistantBGPanel.Bind(self)
    super.Init(self)
    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.EquipAssistantBG)
    end)

    self._selectEquipTemplate = self:NewTemplate("SelectEquipTemplate", {
        TemplateParent = self.panel.SelectEquipParent.Transform,
    })
end --func end
--next--
function EquipAssistantBGCtrl:SetupHandlers()
    local l_handlerTb = {}
    local l_defaultHandlerName = nil
    if not l_equipAssistDataMgr then
        logError("[EquipAssistantDataMgr] EquipAssistantDataMgr is nil, plis check")
        return
    end

    local l_currentPageState = l_equipAssistDataMgr.GetPageState()
    -- 获取标题
    for i = 1, #l_equipAssistDataMgr.PageTitleConfig do
        local l_titleConfig = l_equipAssistDataMgr.PageTitleConfig[i]
        if l_titleConfig and l_titleConfig.mainPageType == l_currentPageState then
            l_strTitle = l_titleConfig.title
            break
        end
    end

    -- 获取handler数据
    for i = 1, #l_equipAssistDataMgr.PageConfig do
        local l_pageConfig = l_equipAssistDataMgr.PageConfig[i]
        local targetSystemID = C_HANDLER_NAME_SYS_ID_MAP[l_pageConfig.HandlerName]
        local systemOpen = false
        if nil ~= targetSystemID and openSystemMgr.IsSystemOpen(targetSystemID) then
            systemOpen = true
        end

        --- 如果没有默认名，则设置
        --- 如果有默认名，但是遇到了强制默认得页，则设置
        --- 如果没有默认页，且没有强制默认页，则设置第一个
        if l_pageConfig and l_pageConfig.mainPageType == l_currentPageState and systemOpen then
            if l_pageConfig.isDefault or nil == l_defaultHandlerName then
                l_defaultHandlerName = l_pageConfig.HandlerName
            end

            table.insert(l_handlerTb, l_pageConfig.pageConfig)
        end
    end

    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, l_defaultHandlerName)
end --func end

--next--
function EquipAssistantBGCtrl:Uninit()
    self._selectEquipTemplate = nil
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function EquipAssistantBGCtrl:OnActive()
    self.panel.Text_Main_Title.LabText = l_strTitle
end --func end
--next--
function EquipAssistantBGCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipAssistantBGCtrl:Update()
    -- do nothing
end --func end

--next--
function EquipAssistantBGCtrl:OnReconnected()
    super.OnReconnected(self)
    self._selectEquipTemplate:OnReconnected()
end --func end

--next--
function EquipAssistantBGCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

-- todo 这里可以暂时不进行修改，但是逻辑上感觉有点问题
function EquipAssistantBGCtrl:OnHandlerSwitch(handlerName, lastHandlerName)
    self.curHandler:SetSelectEquipDataOnHandlerSwitch()
end

function EquipAssistantBGCtrl:GetSelectEquipTemplate()
    return self._selectEquipTemplate
end
--lua custom scripts end
return EquipAssistantBGCtrl