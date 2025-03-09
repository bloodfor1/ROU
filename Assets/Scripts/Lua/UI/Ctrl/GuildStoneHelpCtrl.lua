--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildStoneHelpPanel"
require "UI/Template/GuildStoneDetailPrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
LastOpenRecord =
{
    None = 1,
    HelpRecord = 2
}
--next--
--lua fields end

--lua class define
GuildStoneHelpCtrl = class("GuildStoneHelpCtrl", super)
--lua class define end

--lua functions
function GuildStoneHelpCtrl:ctor()

    super.ctor(self, CtrlNames.GuildStoneHelp, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function GuildStoneHelpCtrl:Init()

    self.panel = UI.GuildStoneHelpPanel.Bind(self)
    super.Init(self)

    self.mgr = MgrMgr:GetMgr("StoneSculptureMgr")
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.GuildStoneHelp)
    end, true)
    self.panel.HelpDay.LabText = Lang("STONE_HELPER_DAY", self.mgr.StoneCarveHelpLimitDay)

    self.lastRefresh = LastOpenRecord.None
    self.panel.Describe[1].LabText = Lang("Stone_Spar_Tips_Content")
    self.panel.Describe[2].LabText = Lang("Stone_Spar_Tips_Content_2")
    self.Pool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildStoneDetailPrefab,
        TemplatePrefab = self.panel.GuildStoneDetail.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll,
        GetDatasMethod = function()
            return self:GetNowData()
        end,
        Method = function(id, rid, state)
            self:SetButtonState(id, rid, state)
        end
    })
    self.panel.BtnEnter:AddClick(function()
        local l_roleData = {}
        for k, v in pairs(self.mgr.chooseId) do
            if v.isChoose then
                table.insert(l_roleData, v.rid)
            end
        end
        if #l_roleData > 0 then
            self.mgr.AssignSouvenirCrystal(l_roleData)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GIFTSTONE_ENTER_NOCHOOSE"))
        end
    end)
    self.mgr.GetGuildStoneHelper()

end --func end
--next--
function GuildStoneHelpCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildStoneHelpCtrl:OnActive()

end --func end
--next--
function GuildStoneHelpCtrl:OnDeActive()


end --func end
--next--
function GuildStoneHelpCtrl:Update()


end --func end

--next--
function GuildStoneHelpCtrl:BindEvents()

    --刷新所有数据
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.HelperData, function(self)
        self:Refresh(self.mgr.StoneHelpData)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildStoneHelpCtrl:GetNowData()
    return self.nowData
end

function GuildStoneHelpCtrl:SetButtonState(id, rid, isChoose)

    self.panel.BtnEnter:SetGray(isClear)
    if self.mgr.chooseId[id] == nil then
        self.mgr.chooseId[id] = {isChoose = isChoose, rid = rid}
    else
        self.mgr.chooseId[id].isChoose = isChoose
    end
    if isChoose then
        self.mgr.chooseNum = self.mgr.chooseNum + 1
    else
        self.mgr.chooseNum = self.mgr.chooseNum - 1
    end
    self.panel.BtnEnter:SetGray(self.mgr.chooseNum == 0)

end

function GuildStoneHelpCtrl:Refresh(data)

    self.mgr.chooseId = {}
    self.mgr.chooseNum = 0
    local l_beginnerGuideChecks = {"SouvenirStoneGuide3"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    self.panel.BtnEnter:SetGray(true)
    self.panel.GiftNum.LabText = tostring(data.giftNum)

    local l_id = 1
    self.nowData = {}
    for i = 1, #data.helper do
        if tostring(MPlayerInfo.UID) ~= tostring(data.helper[i].role_id) then
            data.helper[i].id = l_id
            table.insert(self.nowData, data.helper[i])
            l_id = l_id + 1
        end
    end
    table.sort(self.nowData, function(m, n)
        if m.helped_times ~= n.helped_times then
            return m.helped_times > n.helped_times
        end
        return m.friend_degree > n.friend_degree
    end)
    self.mgr.StoneGiftNowChoose = 0
    if self.lastRefresh == LastOpenRecord.HelpRecord then
        self.Pool:RefreshCells()
    else
        self.Pool:ShowTemplates()
    end
    self.lastRefresh = LastOpenRecord.HelpRecord

end
--lua custom scripts end
return GuildStoneHelpCtrl
