--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MvpRankPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MvpRankCtrl = class("MvpRankCtrl", super)
--lua class define end

--lua functions
function MvpRankCtrl:ctor()

    super.ctor(self, CtrlNames.MvpRank, UILayer.Function, UITweenType.Up, ActiveType.Standalone)

    self.InsertPanelName=UI.CtrlNames.DailyTask
    --self:SetParent(UI.CtrlNames.DailyTask)

end --func end
--next--
function MvpRankCtrl:Init()

    self.panel = UI.MvpRankPanel.Bind(self)
    super.Init(self)
    self.mvpMgr = MgrMgr:GetMgr("MvpMgr")
    self:OnEnterPanel()

end --func end
--next--
function MvpRankCtrl:Uninit()
    self:OnExitPanel()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MvpRankCtrl:OnActive()


end --func end
--next--
function MvpRankCtrl:OnDeActive()


end --func end
--next--
function MvpRankCtrl:Update()

end --func end


--next--
function MvpRankCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
local m_item = {}
local m_selfItem = {}

local RefrashType = -- the boss type
{
    Timing = "1",
    Random = "2"
}

local m_timerState = false

function MvpRankCtrl:OnEnterPanel()
    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MvpRank)
    end)
    self:InitMonsterInfo()
    self:InitSelfRankInfo()
    self:InitRankInfo()
end

function MvpRankCtrl:OnExitPanel()
    m_item = {}
    m_selfItem = {}
    m_timerState = false
end

function MvpRankCtrl:InitMonsterInfo()
    local l_mvpInfo = self.mvpMgr.m_mvpRankInfo.staticInfo
    self.panel.nameLabel.LabText = tostring(l_mvpInfo.entityInfo.Name)
    self.panel.lvLab.LabText = "Lv" .. tostring(l_mvpInfo.entityInfo.UnitLevel)
    self.panel.sceneLab.LabText = tostring(l_mvpInfo.sceneInfo.Comment)
    local l_sprite = l_mvpInfo.mvpInfo.HeadIcon
    local l_atlas = l_mvpInfo.mvpInfo.HeadAtlas
    if l_atlas and l_sprite then
        self.panel.headIcon:SetSpriteAsync(tostring(l_atlas), tostring(l_sprite))
    end
    if l_mvpInfo.mvpInfo.Type == RefrashType.Random then
        if l_mvpInfo.netInfo.is_refresh then
            self.panel.timeLab.LabText = Common.Utils.Lang("HAVE_UPDATE")
        else
            self.panel.timeLab.LabText = Common.Utils.Lang("NOT_UPDATE")
        end
    else
        if l_mvpInfo.netInfo.is_refresh then
            self.panel.timeLab.LabText = Common.Utils.Lang("HAVE_UPDATE")
            return
        end
        local l_time = l_mvpInfo.netInfo.refresh_time
        self.min, temp = math.modf(l_time / 60)
        self.secod = l_time - self.min * 60
        self.interval = 0
        self.ActiveTimeTiks = MgrMgr:GetMgr("MvpMgr").m_mvpTimeTiks
        m_timerState = true
    end
end

function MvpRankCtrl:InitSelfRankInfo()
    local l_rankInfo = self.mvpMgr.m_mvpRankInfo.netInfo
    self:ExportItem(m_selfItem, self.panel.myTeam.gameObject)
    m_selfItem.IconFemale:SetActiveEx(false)
    m_selfItem.IconMale:SetActiveEx(false)
    m_selfItem.IconTeam:SetActiveEx(false)
    if l_rankInfo.self_rank == 0 then
        m_selfItem.rankLab.LabText = Common.Utils.Lang("NOT_IN_MVPRANK")
        m_selfItem.scoreLab.LabText = "0"
        m_selfItem.nameLab.LabText = MPlayerInfo.Name
        if MPlayerInfo.IsMale then
            m_selfItem.IconMale:SetActiveEx(true)
        else
            m_selfItem.IconTeam:SetActiveEx(true)
        end
    else
        self:InitItem(m_selfItem, l_rankInfo.rank_list[l_rankInfo.self_rank])
    end
end

function MvpRankCtrl:InitRankInfo()
    local l_rankInfo = self.mvpMgr.m_mvpRankInfo.netInfo
    self.uiWrapContent = self.panel.Content.gameObject:GetComponent("UIWrapContent")
    self.uiWrapContent:InitContent()
    local l_count = table.maxn(l_rankInfo.rank_list)
    self.uiWrapContent.updateOneItem = function(obj, index)
        if m_item[index] == nil then
            m_item[index] = {}
            self:ExportItem(m_item[index], obj)
        end
        self:InitItem(m_item[index], l_rankInfo.rank_list[index + 1])
    end
    self.uiWrapContent:SetContentCount(l_count)
end

function MvpRankCtrl:ExportItem(item, obj)
    item.ui = obj
    item.rankLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("TxtRank"))
    item.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("TxtName"))
    item.scoreLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("TxtName (1)"))
    item.IconFemale = item.ui.transform:Find("IconFemale").gameObject
    item.IconMale = item.ui.transform:Find("IconMale").gameObject
    item.IconTeam = item.ui.transform:Find("IconTeam").gameObject
end

function MvpRankCtrl:InitItem(item, info)
    --info:MVPRankInfo
    if item == nil or info == nil then
        return
    end
    item.rankLab.LabText = tostring(info.rank)
    item.nameLab.LabText = tostring(info.name)
    item.scoreLab.LabText = tostring(info.score)
    item.IconFemale:SetActiveEx(false)
    item.IconMale:SetActiveEx(false)
    item.IconTeam:SetActiveEx(false)
    if info.is_team then
        item.IconTeam:SetActiveEx(true)
    else
        if info.sex == SexType.SEX_MALE then
            item.IconMale:SetActiveEx(true)
        else
            item.IconFemale:SetActiveEx(true)
        end
    end
end

function MvpRankCtrl:UpdateBeat()
    if not m_timerState then
        return
    end
    local nowInterval = Time.realtimeSinceStartup - self.ActiveTimeTiks
    local temp = math.modf(nowInterval - self.interval)
    if temp >= 1 then
        self.interval = self.interval + temp
        self.panel.timeLab.LabText = self:GetTimerStr()
    end
end

function MvpRankCtrl:GetTimerStr()

    local l_remain = self.min * 60 + self.secod - self.interval
    if l_remain < 1 then
        m_timerState = false
        return Common.Utils.Lang("HAVE_UPDATE")
    end
    if l_remain < 60 then
        if l_remain < 10 then
            return "00:0" .. tostring(l_remain)
        else
            return "00:" .. tostring(l_remain)
        end
    end
    local l_m, temp = math.modf(l_remain / 60)
    local l_s = l_remain - l_m * 60

    local l_mstr
    local l_sStr
    if l_m < 10 then
        l_mstr = "0" .. tostring(l_m)
    else
        l_mstr = tostring(l_m)
    end
    if l_s < 10 then
        l_sStr = "0" .. tostring(l_s)
    else
        l_sStr = tostring(l_s)
    end
    return l_mstr .. ":" .. l_sStr
end

--lua custom scripts end
