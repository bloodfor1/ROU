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
---@class TestFuncTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Btn_TestFuncTemplate MoonClient.MLuaUICom

---@class TestFuncTemplate : BaseUITemplate
---@field Parameter TestFuncTemplateParameter

TestFuncTemplate = class("TestFuncTemplate", super)
--lua class define end

--lua functions
function TestFuncTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function TestFuncTemplate:OnDestroy()
	
	
end --func end
--next--
function TestFuncTemplate:OnDeActive()
	
	
end --func end
--next--
function TestFuncTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	self.Parameter.Text.LabText=data.funcName
	self.Parameter.Btn_TestFuncTemplate:AddClick(function()
		local l_gmCtrl= UIMgr:GetUI(UI.CtrlNames.GM)
		if l_gmCtrl~=nil then
			local l_date = os.date("!*t",Common.TimeMgr.GetLocalNowTimestamp())
			local l_clickInfo = string.format("%s click %02d-%02d-%02d:",data.funcName, l_date.hour, l_date.min, l_date.sec)
			l_gmCtrl:AddTempTestInfo(l_clickInfo)
		end
		data.method()
	end ,true)
	
end --func end
--next--
function TestFuncTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return TestFuncTemplate