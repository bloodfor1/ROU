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
---@class SchoolPreviewEquipItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class SchoolPreviewEquipItemTemplate : BaseUITemplate
---@field Parameter SchoolPreviewEquipItemTemplateParameter

SchoolPreviewEquipItemTemplate = class("SchoolPreviewEquipItemTemplate", super)
--lua class define end

--lua functions
function SchoolPreviewEquipItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SchoolPreviewEquipItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SchoolPreviewEquipItemTemplate:OnSetData(data)
	
	local l_equipId = data.id
	local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_equipId)
	if l_itemData == nil then
		logError("在ItemTable中找不到Id："..l_equipId)
		return
	end
	self.Parameter.ItemIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon)
	self.Parameter.ItemName.LabText = l_itemData.ItemName
	self.Parameter.ItemButton:AddClick(function()
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_equipId, self.Parameter.ItemButton.transform)
	end)
	
end --func end
--next--
function SchoolPreviewEquipItemTemplate:BindEvents()
	
	
end --func end
--next--
function SchoolPreviewEquipItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SchoolPreviewEquipItemTemplate