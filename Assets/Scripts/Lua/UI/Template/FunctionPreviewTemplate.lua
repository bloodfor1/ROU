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
---@class FunctionPreviewTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_toggleOn MoonClient.MLuaUICom
---@field Txt_ToggleOff MoonClient.MLuaUICom
---@field Txt_OpenLevelToggleOn MoonClient.MLuaUICom
---@field Txt_OpenLevelToggleOff MoonClient.MLuaUICom
---@field Toggle_FuncBtn MoonClient.MLuaUICom

---@class FunctionPreviewTemplate : BaseUITemplate
---@field Parameter FunctionPreviewTemplateParameter

FunctionPreviewTemplate = class("FunctionPreviewTemplate", super)
--lua class define end

--lua functions
function FunctionPreviewTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function FunctionPreviewTemplate:BindEvents()
	
	
end --func end
--next--
function FunctionPreviewTemplate:OnDestroy()
	
	
end --func end
--next--
function FunctionPreviewTemplate:OnDeActive()
	
	
end --func end
--next--
function FunctionPreviewTemplate:OnSetData(data)
	
	local l_openSysItem = TableUtil.GetOpenSystemTable().GetRowById(data)
	if MLuaCommonHelper.IsNull(l_openSysItem) then
		return
	end
	self.Parameter.Txt_ToggleOff.LabText = l_openSysItem.Title
	self.Parameter.Txt_toggleOn.LabText = l_openSysItem.Title
	self.Parameter.Txt_OpenLevelToggleOff.LabText = Lang("FunctionPreview_ToggleLevelText", l_openSysItem.NoticeDescLv)
	self.Parameter.Txt_OpenLevelToggleOn.LabText = Lang("FunctionPreview_ToggleLevelText", l_openSysItem.NoticeDescLv)

	self.Parameter.Toggle_FuncBtn:OnToggleExChanged(function(on)
		if on then
			if self.MethodCallback~=nil then
				self.MethodCallback(data)
			end
		end
	end,true)
end --func end
--next--
--lua functions end

--lua custom scripts
function FunctionPreviewTemplate:ChooseFunction()
	self.Parameter.Toggle_FuncBtn.TogEx.isOn = true
end
--lua custom scripts end
return FunctionPreviewTemplate