--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class CompoundTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemPrafabParent MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom

---@class CompoundTem : BaseUITemplate
---@field Parameter CompoundTemParameter

CompoundTem = class("CompoundTem", super)
--lua class define end

--lua functions
function CompoundTem:Init()

    super.Init(self)
    self._equipItem = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ItemPrafabParent.transform })
    self._mgr = MgrMgr:GetMgr("CompoundMgr")

end --func end
--next--
function CompoundTem:OnDeActive()

    self.Data = nil

end --func end
--next--
function CompoundTem:OnSetData(data)

    self.Data = data
    self.ItemData = TableUtil.GetItemTable().GetRowByItemID(self.Data.ConsumableID)
    if self.ItemData ~= nil then
        self._equipItem:SetData({ ID = self.Data.ConsumableID, Count = self.Data.Count })
        self.Parameter.Name.LabText = self.ItemData.ItemName
        self.Parameter.GenreText.LabText = ""
    end
    self.Parameter.ImageEquipFlag.gameObject:SetActiveEx(false)
    self.Parameter.ItemPrompt.gameObject:SetActiveEx(false)
    self.Parameter.ItemButton:AddClick(function()
        self.MethodCallback(self, self.Data, self.ShowIndex)
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
    end)
    self:SetLightActive(self._mgr.CurIndex == self.ShowIndex)

end --func end
--next--
function CompoundTem:OnDestroy()

    self._equipItem = nil

end --func end
--next--
function CompoundTem:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
--function CompoundTem:OnDeActive()
--    self.Data = nil
--end
function CompoundTem:SetLightActive(b)
    if self.Data == nil then
        return
    end
    self.Parameter.Selected.gameObject:SetActiveEx(b)
end
--lua custom scripts end
return CompoundTem