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
---@class AchieveTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field Title_02 MoonClient.MLuaUICom
---@field Title_01 MoonClient.MLuaUICom
---@field LvImage MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IsMvp MoonClient.MLuaUICom
---@field IsElite MoonClient.MLuaUICom
---@field AchieveTemplate MoonClient.MLuaUICom

---@class AchieveTemplate : BaseUITemplate
---@field Parameter AchieveTemplateParameter

AchieveTemplate = class("AchieveTemplate", super)
--lua class define end

--lua functions
function AchieveTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function AchieveTemplate:BindEvents()
	
	
end --func end
--next--
function AchieveTemplate:OnDestroy()
	
	
end --func end
--next--
function AchieveTemplate:OnDeActive()
	
	
end --func end
--next--
function AchieveTemplate:OnSetData(data)
	local functionId = data
	local l_Atlas, l_Icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(functionId)
	local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(functionId)
	local l_FuncName = Common.CommonUIFunc.GetFuncNameByFuncId(functionId)
	local l_showPlaceName = ""
	if l_isOpen then
		l_showPlaceName = ""
	else
		l_showPlaceName = l_showStr
	end
	local l_showBtnFunc = function()
		if not l_isOpen then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
			UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
			return
		end
		UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
		if functionId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LevelUp then
			UIMgr:ActiveUI(UI.CtrlNames.FarmPrompt)
			return
		end
		Common.CommonUIFunc.InvokeFunctionByFuncId(functionId)
	end
	
	self.Parameter.ItemIcon:SetSprite(l_Atlas,l_Icon)
	self.Parameter.LvImage.gameObject:SetActiveEx(false)
	self.Parameter.Title_01.LabText = l_FuncName
	self.Parameter.Title_02.LabText = l_showPlaceName
	self.Parameter.AchieveTemplate:AddClick(l_showBtnFunc)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AchieveTemplate