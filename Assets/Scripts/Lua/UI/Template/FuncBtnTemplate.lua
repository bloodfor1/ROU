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
---@class FuncBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_UnSelectFuncName MoonClient.MLuaUICom
---@field Txt_SelectFuncName MoonClient.MLuaUICom
---@field Panel_UnSelect MoonClient.MLuaUICom
---@field Panel_Select MoonClient.MLuaUICom
---@field Img_UnSelectFunc MoonClient.MLuaUICom
---@field Img_SelectFunc MoonClient.MLuaUICom
---@field FuncBtn MoonClient.MLuaUICom

---@class FuncBtnTemplate : BaseUITemplate
---@field Parameter FuncBtnTemplateParameter

FuncBtnTemplate = class("FuncBtnTemplate", super)
--lua class define end

--lua functions
function FuncBtnTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function FuncBtnTemplate:OnDestroy()
	
	
end --func end
--next--
function FuncBtnTemplate:OnDeActive()
	
	self:CancelSelect()
	
end --func end
--next--
function FuncBtnTemplate:OnSetData(data)
	if data==nil then
		return
	end
	if data.id==nil then
		self:ClearTemplateInfo()
		return
	end
	local l_openSysData=TableUtil.GetOpenSystemTable().GetRowById(data.id)
	if l_openSysData==nil then
		logError("OpenSystemTable not exist ID:"..tostring(data.id))
		return
	end

	self.Parameter.Txt_SelectFuncName.LabText=l_openSysData.Title
	self.Parameter.Txt_UnSelectFuncName.LabText=l_openSysData.Title

	self.Parameter.Panel_Select:SetActiveEx(data.chooseState)
	self.Parameter.Panel_UnSelect:SetActiveEx(not data.chooseState)

	local l_selectIconName = StringEx.Format(l_openSysData.SystemIcon,1)
	local l_unSelectIconName = StringEx.Format(l_openSysData.SystemIcon,2)
	self.Parameter.Img_SelectFunc:SetSprite(l_openSysData.SystemAtlas,l_selectIconName)
	self.Parameter.Img_UnSelectFunc:SetSprite(l_openSysData.SystemAtlas,l_unSelectIconName)

	self.Parameter.FuncBtn:AddClick(function()
		local l_showSelectBtn= data.buttonMethod(data.id,data.dataIndex)
		if self:IsInited() then
			self.Parameter.Panel_Select:SetActiveEx(l_showSelectBtn)
			self.Parameter.Panel_UnSelect:SetActiveEx(not l_showSelectBtn)
		end
	end ,true)
	
end --func end
--next--
function FuncBtnTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function FuncBtnTemplate:CancelSelect()
	self.Parameter.Panel_Select:SetActiveEx(false)
	self.Parameter.Panel_UnSelect:SetActiveEx(true)
end
function FuncBtnTemplate:ClearTemplateInfo()
	self.Parameter.Panel_Select:SetActiveEx(false)
	self.Parameter.Panel_UnSelect:SetActiveEx(false)
end
--lua custom scripts end
return FuncBtnTemplate