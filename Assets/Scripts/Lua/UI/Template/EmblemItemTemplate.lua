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
---@class EmblemItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field ClickBtn MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class EmblemItemTemplate : BaseUITemplate
---@field Parameter EmblemItemTemplateParameter

EmblemItemTemplate = class("EmblemItemTemplate", super)
--lua class define end

--lua functions
function EmblemItemTemplate:Init()
    super.Init(self)
end --func end
--next--
function EmblemItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function EmblemItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function EmblemItemTemplate:OnSetData(data)
    local sdata = TableUtil.GetItemTable().GetRowByItemID(data.id)
    if not sdata then
        logError("find item sdata fail ", data.id)
        return
    end

    self.Parameter.Checkmark:SetActiveEx(false)
    self.Parameter.InfoTittle.LabText = sdata.ItemName
    self.Parameter.Name.LabText = sdata.ItemName
    self.Parameter.ItemIcon:SetSprite(sdata.ItemAtlas, sdata.ItemIcon)
    self.Parameter.ItemCount.LabText = tostring(data.count)
    local propInfo = Data.BagModel:CreateItemWithTid(data.id)
    self.Parameter.ClickBtn:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, self:transform(), nil, { IsShowCloseButton = true })
        self.MethodCallback(self.ShowIndex, data)
    end)
end --func end
--next--
function EmblemItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function EmblemItemTemplate:OnSelect()
    self.Parameter.Checkmark:SetActiveEx(true)
    self.Parameter.InfoTittle:SetActiveEx(false)
end

function EmblemItemTemplate:OnDeselect()
    self.Parameter.Checkmark:SetActiveEx(false)
    self.Parameter.InfoTittle:SetActiveEx(true)
end

--lua custom scripts end
return EmblemItemTemplate