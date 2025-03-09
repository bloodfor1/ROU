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
---@class GatherPropInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_name MoonClient.MLuaUICom
---@field Img_IconBg MoonClient.MLuaUICom
---@field Btn_GoTo MoonClient.MLuaUICom

---@class GatherPropInfoTemplate : BaseUITemplate
---@field Parameter GatherPropInfoTemplateParameter

GatherPropInfoTemplate = class("GatherPropInfoTemplate", super)
--lua class define end

--lua functions
function GatherPropInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function GatherPropInfoTemplate:BindEvents()
	
	
end --func end
--next--
function GatherPropInfoTemplate:OnDestroy()
	self.itemTemplate = nil
	
end --func end
--next--
function GatherPropInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function GatherPropInfoTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	local l_propItem = TableUtil.GetItemTable().GetRowByItemID(data.ID)
	if MLuaCommonHelper.IsNull(l_propItem) then
		return
	end
	self.Parameter.Txt_name.LabText = l_propItem.ItemName
	if MLuaCommonHelper.IsNull(self.itemTemplate) then
		self.itemTemplate = self:NewTemplate("ItemTemplate",{
			TemplateParent = self.Parameter.Img_IconBg.Transform,
			Data=data
		})
	else
		self.itemTemplate:SetData(data)
	end
	self.Parameter.Btn_GoTo:AddClick(function()
		if not UIMgr:IsActiveUI(UI.CtrlNames.LifeProfessionSite) then
			UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionSite,data.gatherData)
		end
	end,true)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GatherPropInfoTemplate