--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_NewTaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Theme_NewTaskCtrl = class("Theme_NewTaskCtrl", super)
--lua class define end

--lua functions
function Theme_NewTaskCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_NewTask, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function Theme_NewTaskCtrl:Init()
	
	self.panel = UI.Theme_NewTaskPanel.Bind(self)
	super.Init(self)

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    self.panel.GotBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Theme_NewTask)
    end)
	
end --func end
--next--
function Theme_NewTaskCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Theme_NewTaskCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.themeDungeonId then
        self:SetInfo(self.uiPanelData.themeDungeonId)
    end
	
end --func end
--next--
function Theme_NewTaskCtrl:OnDeActive()
    self.panel.DungeonImg:ResetRawTex()
	
end --func end
--next--
function Theme_NewTaskCtrl:Update()
    -- 刷新剩余时间
    if MServerTimeMgr.UtcSeconds_u < tonumber(self.themeDungeonMgr.nextRefreshTime) then
        self.panel.LeftTime.LabText = Lang("REFRESHTIME", Common.TimeMgr.GetLeftTimeStrEx(tonumber(self.themeDungeonMgr.nextRefreshTime) - MServerTimeMgr.UtcSeconds_u))
    else
        self.panel.LeftTime.LabText = Lang("REFRESHTIME", "0" .. Lang("TIME_SECOND"))
    end
	
end --func end
--next--
function Theme_NewTaskCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function Theme_NewTaskCtrl:SetInfo(themeDungeonId)
    local l_themeDungeonRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(themeDungeonId)
    if not l_themeDungeonRow then return end

    self.panel.Name.LabText = l_themeDungeonRow.ThemeName

    self.panel.DungeonImg:SetRawTexAsync(l_themeDungeonRow.ScenePic, nil, true)
end

--lua custom scripts end
return Theme_NewTaskCtrl