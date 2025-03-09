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
---@class PrivilegeTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Img_Icon MoonClient.MLuaUICom
---@field Btn_Bg MoonClient.MLuaUICom

---@class PrivilegeTemplate : BaseUITemplate
---@field Parameter PrivilegeTemplateParameter

PrivilegeTemplate = class("PrivilegeTemplate", super)
--lua class define end

--lua functions
function PrivilegeTemplate:Init()
    super.Init(self)
end --func end
--next--
function PrivilegeTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function PrivilegeTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function PrivilegeTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function PrivilegeTemplate:OnSetData(data)
    if data == nil then
        return
    end
    ---@type MonthCardTable
    local l_monthCardItem = data.monthCardItem
    self.Parameter.Img_Icon:SetSpriteAsync(l_monthCardItem.AtlasName, l_monthCardItem.IconName, nil, true)
    self.Parameter.Btn_Bg:AddClick(function()
        if not data.openFromBag then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_GET_VIP_CARD"))
            return
        end

        local l_remainTime = data.deadLineTime - Common.TimeMgr.GetNowTimestamp()
        if l_remainTime <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VIP_CARD_OUT_DATE"))
            return
        end

        local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_monthCardItem.LinkId)
        if method ~= nil then
            method()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.CapraCard)
    end, true)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return PrivilegeTemplate