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
---@class GardrobeStoreCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemName1 MoonClient.MLuaUICom
---@field IconContent MoonClient.MLuaUICom
---@field GarderobeStoreBtn MoonClient.MLuaUICom
---@field BtnStore1 MoonClient.MLuaUICom

---@class GardrobeStoreCellTemplate : BaseUITemplate
---@field Parameter GardrobeStoreCellTemplateParameter

GardrobeStoreCellTemplate = class("GardrobeStoreCellTemplate", super)
--lua class define end

--lua functions
function GardrobeStoreCellTemplate:Init()
    super.Init(self)
    self:Bind()
    self.ItemTem = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.Parameter.IconContent.transform,
    })
end --func end
--next--
function GardrobeStoreCellTemplate:OnDestroy()
    self.ItemTem = nil
end --func end
--next--
function GardrobeStoreCellTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function GardrobeStoreCellTemplate:OnSetData(data)
    if data ~= nil then
        self.cellData = data
        self:RefreshCell()
    end
end --func end
--next--
function GardrobeStoreCellTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function GardrobeStoreCellTemplate:Bind()
    self.Parameter.BtnStore1:AddClick(function()
        if self.MethodCallback ~= nil then
            self.MethodCallback(self.cellData)
        end
    end)
end

function GardrobeStoreCellTemplate:RefreshCell()
    local l_showData = {
        PropInfo = self.cellData,
        IsShowCount = false,
    }

    self.ItemTem:SetData(l_showData)
    local itemRow = self.cellData.ItemConfig
    local level = MgrMgr:GetMgr("RefineMgr").GetRefineLevel(self.cellData)
    if level > 0 then
        self.Parameter.ItemName1.LabText = ("+" .. tostring(level) .. itemRow.ItemName)
    else
        self.Parameter.ItemName1.LabText = itemRow.ItemName
    end
end
--lua custom scripts end
return GardrobeStoreCellTemplate