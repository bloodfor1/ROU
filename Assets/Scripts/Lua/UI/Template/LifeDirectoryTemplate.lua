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
---@class LifeDirectoryTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_ProfessionNameUnOpen MoonClient.MLuaUICom
---@field Txt_ProfessionNameUnChoose MoonClient.MLuaUICom
---@field Txt_ProfessionName MoonClient.MLuaUICom
---@field Txt_ProfessionLevelUnOpen MoonClient.MLuaUICom
---@field Txt_ProfessionLevelUnChoose MoonClient.MLuaUICom
---@field Txt_ProfessionLevel MoonClient.MLuaUICom
---@field Template_LifeDirectory MoonClient.MLuaUICom
---@field Img_UnOpen MoonClient.MLuaUICom
---@field Img_UnChoose MoonClient.MLuaUICom
---@field Img_LifeProfessionUnOpen MoonClient.MLuaUICom
---@field Img_LifeProfessionUnChoose MoonClient.MLuaUICom
---@field Img_LifeProfession MoonClient.MLuaUICom

---@class LifeDirectoryTemplate : BaseUITemplate
---@field Parameter LifeDirectoryTemplateParameter

LifeDirectoryTemplate = class("LifeDirectoryTemplate", super)
--lua class define end

--lua functions
function LifeDirectoryTemplate:Init()
	
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("LifeProfessionMgr")
	
end --func end
--next--
function LifeDirectoryTemplate:BindEvents()
	
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.DataChange, function()
		if self.directoryData == nil then
			return
		end
		local l_isOpen = self.mgr.CanOpenSystem(self.directoryData.classID)
		self:refreshLifeSkillDataInfo(l_isOpen,self.directoryData.classID)
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventType.LifeSkillLvUp, function(_,classID,level)
		if self.directoryData==nil then
			return
		end
		if self.IsOpen then
			return
		end
		if not self:isLifeDirectoryOpen(self.directoryData.classID) then
			return
		end
		self:OnSetData(self.directoryData)
	end)
end --func end
--next--
function LifeDirectoryTemplate:OnDestroy()
	
	self.directoryData = nil
	
end --func end
--next--
function LifeDirectoryTemplate:OnDeActive()
	
	
end --func end
--next--
function LifeDirectoryTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	self.directoryData = data
	self.IsOpen = self:isLifeDirectoryOpen(data.classID)
	self.Parameter.Img_UnChoose:SetActiveEx(not data.isChoose)
	local l_chooseFunc = function()
		self:NotiyPoolSelect()
		if data.OnSelectMethod~=nil then
			local ctrl=UIMgr:GetUI(UI.CtrlNames.LifeProfessionMain)
			if ctrl then
				data.OnSelectMethod(ctrl,data.classID)
			end
		end
	end
	if data.isChoose then
		l_chooseFunc()
	end
	self.Parameter.Template_LifeDirectory:AddClick(l_chooseFunc,true)
	self.Parameter.Txt_ProfessionName.LabText = self.mgr.GetCareerName(data.classID)
	self.Parameter.Txt_ProfessionNameUnChoose.LabText = self.Parameter.Txt_ProfessionName.LabText
	self.Parameter.Txt_ProfessionNameUnOpen.LabText = self.Parameter.Txt_ProfessionName.LabText
	self:refreshLifeSkillDataInfo(self.IsOpen,data.classID)
	self.Parameter.Img_UnOpen:SetActiveEx(not self.IsOpen)
	local l_atlas,l_icon = self.mgr.GetProfessionIconByID(data.classID)
	if l_icon~=nil then
		self.Parameter.Img_LifeProfession:SetSpriteAsync(l_atlas,l_icon,nil,true)
		self.Parameter.Img_LifeProfessionUnChoose:SetSpriteAsync(l_atlas,l_icon,nil,true)
		self.Parameter.Img_LifeProfessionUnOpen:SetSpriteAsync(l_atlas,l_icon,nil,true)
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LifeDirectoryTemplate:isLifeDirectoryOpen(classID)
	return self.mgr.CanOpenSystem(classID) and
			self.mgr.CanGetUnlockLifeSkillTaskByClassID(classID)
end
function LifeDirectoryTemplate:OnSelect()
	self.Parameter.Img_UnChoose:SetActiveEx(false)
	self.Parameter.Img_UnOpen:SetActiveEx(false)
end
function LifeDirectoryTemplate:OnDeselect()
	self.Parameter.Img_UnChoose:SetActiveEx(true)
	self.Parameter.Img_UnOpen:SetActiveEx(not self.IsOpen)
end
function LifeDirectoryTemplate:refreshLifeSkillDataInfo(isOpen,classID)
	local l_lifeProfessionLevel = self.mgr.GetLv(classID)
	if isOpen and l_lifeProfessionLevel>0 then
		self.Parameter.Txt_ProfessionLevel.LabText = "Lv"..tostring(l_lifeProfessionLevel)
	else
		self.Parameter.Txt_ProfessionLevel.LabText = ""
	end
	self.Parameter.Txt_ProfessionLevelUnChoose.LabText = self.Parameter.Txt_ProfessionLevel.LabText
	self.Parameter.Txt_ProfessionLevelUnOpen.LabText = self.Parameter.Txt_ProfessionLevel.LabText
end
--lua custom scripts end
return LifeDirectoryTemplate