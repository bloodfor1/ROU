--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PvpArenaPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PvpArenaPanelCtrl = class("PvpArenaPanelCtrl", super)
--lua class define end

--lua functions
function PvpArenaPanelCtrl:ctor()

    super.ctor(self, CtrlNames.PvpArenaPanel, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName=UI.CtrlNames.DailyTask
    --self:SetParent(UI.CtrlNames.DailyTask)

end --func end
--next--
function PvpArenaPanelCtrl:Init()

    self.panel = UI.PvpArenaPanelPanel.Bind(self)
    super.Init(self)
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")
    self:OnInit()

end --func end
--next--
function PvpArenaPanelCtrl:Uninit()

    self:OnUninit()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PvpArenaPanelCtrl:OnActive()


end --func end
--next--
function PvpArenaPanelCtrl:OnDeActive()


end --func end
--next--
function PvpArenaPanelCtrl:Update()


end --func end

--next--
function PvpArenaPanelCtrl:BindEvents()
    self:BindEvent(self.pvpArenaMgr.EventDispatcher,self.pvpArenaMgr.SHOW_ARENA_ROOM_LIST, function()
        if StageMgr:GetCurStageEnum() == MStageEnum.ArenaPre then
            return
        end
        UIMgr:ActiveUI(UI.CtrlNames.PvpArenaRoomList)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function PvpArenaPanelCtrl:OnInit()
    self.panel.But_Bg:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaPanel)
    end)
    self.panel.pvpClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaPanel)
    end)
    self.panel.pvpJoinBtn:AddClick(function()
        if MEntityMgr.PlayerEntity.IsRidePubVehicle then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PUBVEHICLE_CANNOT_PVP"))
            return
        end
        if MEntityMgr.PlayerEntity.IsClimb then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CLIMB_CANNOT_PVP"))
            return
        end
        self.pvpArenaMgr.ShowArenaRoomList()
    end)
    self.panel.pvpCreatBtn:AddClick(function()
        if MEntityMgr.PlayerEntity.IsRidePubVehicle then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PUBVEHICLE_CANNOT_PVP"))
            return
        end
        if MEntityMgr.PlayerEntity.IsClimb then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CLIMB_CANNOT_PVP"))
            return
        end
        self.pvpArenaMgr.CreateArenaPvpCustom()
    end)
    self.panel.pvpInfoBtn:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_WARNING_EVENT_UNAVAILABLE"))
    end)
    self.panel.pvpInfoBtn.gameObject:SetActiveEx(false)
    local l_activityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Pvp
    local l_tableInfo = TableUtil.GetDailyActivitiesTable().GetRowById(l_activityId)
    self.panel.TextPvpDesc.LabText = l_tableInfo.AcitiveText
    self.panel.BgImg:SetRawTexAsync(string.format("%s/%s",l_tableInfo.ContentPicAtlas, l_tableInfo.ContentPicName))
end

function PvpArenaPanelCtrl:OnUninit()

end

--lua custom scripts end
return PvpArenaPanelCtrl