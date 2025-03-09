--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InfinityTowerStageInfoPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
InfinityTowerStageInfoCtrl = class("InfinityTowerStageInfoCtrl", super)
--lua class define end

--lua functions
function InfinityTowerStageInfoCtrl:ctor()

    super.ctor(self, CtrlNames.InfinityTowerStageInfo, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName = UI.CtrlNames.InfinityTower

end --func end
--next--
function InfinityTowerStageInfoCtrl:Init()

    self.panel = UI.InfinityTowerStageInfoPanel.Bind(self)
    super.Init(self)
    self.itemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate
    })

end --func end
--next--
function InfinityTowerStageInfoCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.itemTemplatePool = nil

end --func end
--next--
function InfinityTowerStageInfoCtrl:OnActive()

    self.panel.BtnClose:AddClick(function()
        self:OnClose()
    end)

end --func end
--next--
function InfinityTowerStageInfoCtrl:OnDeActive()


end --func end
--next--
function InfinityTowerStageInfoCtrl:Update()


end --func end





--next--
function InfinityTowerStageInfoCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function InfinityTowerStageInfoCtrl:InitWithTowerLevel(id)

    local l_mgr = MgrMgr:GetMgr("InfiniteTowerDungeonMgr")
    local l_row = TableUtil.GetEndlessTowerTable().GetRowByID(id)

    self.panel.TmpStageInfoTitle.LabText = Lang("LEVEL_NUMBER", id)

    self.panel.BtnChallengeLevel:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("GOTO_INFINITE_TOWER"),
                function()
                    l_mgr.OnSelectLevel(id)
                end,
                function()
                end)
    end)
    if not l_mgr.IsCleared(id) then
        self.panel.TxtRecommandChallengeLevel.LabText = Lang("WORLD_EVENT_RECOMMAND_LEVEL", l_row.RecommendedLv)
    else
        self.panel.TxtRecommandChallengeLevel.LabText = Lang("HAS_GET_AWARD")
    end
    self:InitReward(id)
end

function InfinityTowerStageInfoCtrl:InitReward(id)
    local l_rewardList = {}
    local l_row = TableUtil.GetEndlessTowerTable().GetRowByID(id)
    if l_row.IsBossFloor then
        self.panel.MVPImage:SetSprite("CommonIcon", "UI_CommonIcon_TowerLevelicon_02.png")
        self.panel.MVPImage.gameObject:SetActiveEx(true)
    else
        self.panel.MVPImage:SetSprite("CommonIcon", "UI_CommonIcon_TowerLevelicon_01.png")
        self.panel.MVPImage.gameObject:SetActiveEx(false)
    end

    repeat
        local l_dungeonsId = l_row.DungeonsID[0][1]
        local l_monsters = MgrMgr:GetMgr("DungeonMgr").GetDungeonsMonster(l_dungeonsId)
        local l_levelReward = MPlayerDungeonsInfo:GetDungeonsReward(l_dungeonsId)
        for i = 0, l_levelReward.Count - 1 do
            l_rewardList[l_levelReward[i]] = {
                ID = l_levelReward[i],
                IsShowCount = false
            }
        end

        for _, monsterId in pairs(l_monsters) do
            local l_monsterReward = MPlayerDungeonsInfo:GetMonsterReward(monsterId)
            for i = 0, l_monsterReward.Count - 1 do
                l_rewardList[l_monsterReward[i]] = {
                    ID = l_monsterReward[i],
                    IsShowCount = false
                }
            end
        end

        id = id + 1
        if id <= TableUtil.GetEndlessTowerTable().GetTableSize() then
            l_row = TableUtil.GetEndlessTowerTable().GetRowByID(id)
        else
            l_row = nil
        end
    until (l_row == nil or l_row.IsSave == 1)

    local l_datas = {}
    for k, v in pairs(l_rewardList) do
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(v.ID, true)
        if nil ~= itemConfig then
            v.TipsRelativePos = { fixationPosX = 220, fixationPosY = 0 }
            table.insert(l_datas, v)
        else
            logError("[无限塔] 道具ID: " .. v.ID .. " 不存在，请检查奖励表")
        end
    end

    table.sort(l_datas, function(a, b)
        local l_itema = TableUtil.GetItemTable().GetRowByItemID(a.ID)
        local l_itemb = TableUtil.GetItemTable().GetRowByItemID(b.ID)
        if nil == l_itema or nil == l_itemb then
            return false
        end

        return l_itema.ItemQuality > l_itemb.ItemQuality
    end)

    self.itemTemplatePool:ShowTemplates({ Datas = l_datas, Parent = self.panel.StageInfoRewardContent.transform })
end

function InfinityTowerStageInfoCtrl:OnClose()
    UIMgr:DeActiveUI(UI.CtrlNames.InfinityTowerStageInfo)
end

--lua custom scripts end
return InfinityTowerStageInfoCtrl