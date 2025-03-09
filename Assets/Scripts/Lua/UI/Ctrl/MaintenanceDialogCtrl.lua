--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MaintenanceDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
MaintenanceDialogCtrl = class("MaintenanceDialogCtrl", super)
--lua class define end

--维护公告
local l_maintenanceTitle=Common.Utils.Lang("MAINTENANCE_TITLE")
local l_maintenanceEndText=Common.Utils.Lang("MAINTENANCE_END_TIME")

--lua functions
function MaintenanceDialogCtrl:ctor()
	
	super.ctor(self, CtrlNames.MaintenanceDialog, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
	
	self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
end --func end
--next--
function MaintenanceDialogCtrl:Init()
	
	self.panel = UI.MaintenanceDialogPanel.Bind(self)
	super.Init(self)

	--关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)
	--确定按钮
	self.panel.BtnOK:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)
end --func end
--next--
function MaintenanceDialogCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MaintenanceDialogCtrl:OnActive()
	--设置维护消息和维护结束时间
	local l_maintenanceInfo=self.uiPanelData.maintenanceInfo
	local l_endTime=self.uiPanelData.endTime
	local l_utcEndTime=self.uiPanelData.utcEndTime
	if l_utcEndTime and tonumber(l_utcEndTime) == 0 then
		self.panel.TexMaintenanceEndTime.gameObject:SetActiveEx(false)
	else
		self.panel.TexMaintenanceEndTime.gameObject:SetActiveEx(true)
	end
	if l_maintenanceInfo and l_endTime then
		self:SetMaintenanceContent(l_maintenanceInfo,l_endTime)
	else
		logError("维护信息或结束时间为空")
	end
end --func end

function MaintenanceDialogCtrl:SetMaintenanceContent(maintenanceInfo,endTime)
	self.panel.TexTitle.LabText=l_maintenanceTitle
	self.panel.TexMaintenanceContent.LabText=maintenanceInfo
	self.panel.TexMaintenanceEndTime.LabText=l_maintenanceEndText..endTime
end
--next--
function MaintenanceDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function MaintenanceDialogCtrl:Update()
	
	
end --func end
--next--
function MaintenanceDialogCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MaintenanceDialogCtrl