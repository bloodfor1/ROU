--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildStoneDetailPanel"
require "UI/Template/StoneHelpPrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
LastOpenRecord = {
    None = 1,
    RecordForNow = 2,
    RecordForAll = 3
}
--next--
--lua fields end

--lua class define
GuildStoneDetailCtrl = class("GuildStoneDetailCtrl", super)
--lua class define end

--lua functions
function GuildStoneDetailCtrl:ctor()

    super.ctor(self, CtrlNames.GuildStoneDetail, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.GuildStoneDetail

end --func end
--next--
function GuildStoneDetailCtrl:Init()

    self.panel = UI.GuildStoneDetailPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("StoneSculptureMgr")

    self.panel.BtnClose:AddClick(function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.GuildStone)
        if not l_ui then
            local l_openData = {
                type = DataMgr:GetData("GuildData").EUIOpenType.GuildStone,
                roleId = MPlayerInfo.UID
            }
            UIMgr:ActiveUI(UI.CtrlNames.GuildStone, l_openData)
        end
        UIMgr:DeActiveUI(CtrlNames.GuildStoneDetail)
    end, true)

    self.lastRefresh = LastOpenRecord.None
    self.panel.TogNow.TogEx.onValueChanged:AddListener(function()
        if self.panel.TogNow.TogEx.isOn then
            self:RefreshNow(self.mgr.StoneData.curInfo)
        end
    end)
    self.panel.TogAll.TogEx.onValueChanged:AddListener(function()
        if self.panel.TogAll.TogEx.isOn then
            self:RefreshAll(self.mgr.StoneData.allInfo)
        end
    end)
    self.panel.StoneQuestion.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_STONE_HELP_DESCRIBE"), ed, Vector2(1, 1), false)
    end

    self.panel.Count.LabText = Lang("TODAY_HELP", self.mgr.StoneData.love, self.mgr.StoneHelpOtherCount)
    self.Pool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StoneHelpPrefab,
        TemplatePrefab = self.panel.StoneHelp.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll,
        GetDatasMethod = function()
            return self:GetNowData()
        end
    })

    self.nowData = {}
    self.mgr.SendGetCobblestoneInfo(MPlayerInfo.UID)
end --func end
--next--
function GuildStoneDetailCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.Pool = nil
    self.mgr = nil
    self.nowData = nil
end --func end
--next--
function GuildStoneDetailCtrl:OnActive()

end --func end
--next--
function GuildStoneDetailCtrl:OnDeActive()


end --func end
--next--
function GuildStoneDetailCtrl:Update()

end --func end

--next--
function GuildStoneDetailCtrl:BindEvents()

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.StoneData, function(self)
        if tostring(MPlayerInfo.UID) ~= tostring(self.mgr.StoneData.roleId) then
            return
        end
        if self.panel.TogNow.TogEx.isOn then
            self:RefreshNow(self.mgr.StoneData.curInfo)
        else
            self:RefreshAll(self.mgr.StoneData.allInfo)
        end
        self.panel.Count.LabText = Lang("TODAY_HELP", self.mgr.StoneData.love, self.mgr.StoneHelpOtherCount)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildStoneDetailCtrl:RefreshNow(data)

    self.nowData = {}
    for i = 1, #data do
        if tostring(MPlayerInfo.UID) ~= tostring(data[i].carver_id) then
            table.insert(self.nowData, data[i])
        end
    end
    table.sort(self.nowData, function(m, n)
        return m.carve_time[1] < n.carve_time[1]
    end)
    self.mgr.DetailIsNow = true
    if self.lastRefresh == LastOpenRecord.RecordForNow then
        self.Pool:RefreshCells()
    else
        self.Pool:ShowTemplates()
    end
    self.lastRefresh = LastOpenRecord.RecordForNow
    self.panel.None:SetActiveEx(#data <= 0)

end

function GuildStoneDetailCtrl:RefreshAll(data)

    self.nowData = {}
    for i = 1, #data do
        if tostring(MPlayerInfo.UID) ~= tostring(data[i].carver_id) then
            table.insert(self.nowData, data[i])
        end
    end
    table.sort(self.nowData, function(m, n)
        return #m.carve_time > #n.carve_time
    end)
    self.mgr.DetailIsNow = false
    if self.lastRefresh == LastOpenRecord.RecordForAll then
        self.Pool:RefreshCells()
    else
        self.Pool:ShowTemplates()
    end
    self.lastRefresh = LastOpenRecord.RecordForAll
    self.panel.None:SetActiveEx(#data <= 0)

end

function GuildStoneDetailCtrl:GetNowData()
    return self.nowData or {}
end
--lua custom scripts end
return GuildStoneDetailCtrl