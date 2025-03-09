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
---@class SchoolPreviewHeadItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class SchoolPreviewHeadItemTemplate : BaseUITemplate
---@field Parameter SchoolPreviewHeadItemTemplateParameter

SchoolPreviewHeadItemTemplate = class("SchoolPreviewHeadItemTemplate", super)
--lua class define end

--lua functions
function SchoolPreviewHeadItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SchoolPreviewHeadItemTemplate:OnDestroy()
	
	
end --func end
--next--
function SchoolPreviewHeadItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SchoolPreviewHeadItemTemplate:OnSetData(data)
	
	local l_headId = data.id
	local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_headId)
	if l_itemData == nil then
		logError("在ItemTable中找不到Id："..l_headId)
		return
	end
	self.Parameter.ItemIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon)
	self.Parameter.ItemName.LabText = l_itemData.ItemName
	self.Parameter.ItemButton:AddClick(function()
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_headId, self.Parameter.ItemButton.transform)
	end)
	
end --func end
--next--
function SchoolPreviewHeadItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SchoolPreviewHeadItemTemplate