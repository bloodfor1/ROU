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
---@class DisplacerMaterialSelectItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class DisplacerMaterialSelectItemTemplate : BaseUITemplate
---@field Parameter DisplacerMaterialSelectItemTemplateParameter

DisplacerMaterialSelectItemTemplate = class("DisplacerMaterialSelectItemTemplate", super)
--lua class define end

--lua functions
function DisplacerMaterialSelectItemTemplate:Init()
    super.Init(self)


end --func end
--next--
function DisplacerMaterialSelectItemTemplate:OnDeActive()


end --func end
--next--
function DisplacerMaterialSelectItemTemplate:OnSetData(data)
    self.data = data
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(data.itemId)
    self.Parameter.IconButton:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.itemId, nil, nil, nil, true)
    end)
    self.Parameter.IconImg:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon)
    self.Parameter.Name.LabText = l_itemData.ItemName
    self.Parameter.Effect.LabText = ""

    --点击事件
    self.Parameter.BtnSelect:AddClick(function()
        self:MethodCallback(self)
    end)
end --func end
--next--
function DisplacerMaterialSelectItemTemplate:BindEvents()
	
	
end --func end
--next--
function DisplacerMaterialSelectItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DisplacerMaterialSelectItemTemplate