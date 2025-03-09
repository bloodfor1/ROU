--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerRewardPanel"

require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TowerRewardCtrl = class("TowerRewardCtrl", super)
--lua class define end

--lua functions
function TowerRewardCtrl:ctor()

	super.ctor(self, CtrlNames.TowerReward, UILayer.Function, nil, ActiveType.Normal)
    self.awardMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
end --func end
--next--
function TowerRewardCtrl:Init()
    self.preview_num = 1

	self.panel = UI.TowerRewardPanel.Bind(self)
    super.Init(self)

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TowerReward)
    end)
	self.panel.BtnOK:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.TowerReward)
	end)

end --func end
--next--
function TowerRewardCtrl:Uninit()
    self.itemPool = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TowerRewardCtrl:OnActive()
    local dungeonId = MPlayerDungeonsInfo.DungeonID
    local l_monsters = MgrMgr:GetMgr("DungeonMgr").GetDungeonsMonster(dungeonId)
    if #l_monsters > 0 then
        self:ShowPreviewRewards(dungeonId)
    else
        MgrMgr:GetMgr("DungeonMgr").RequestDungeonsMonster()
    end
end --func end
--next--
function TowerRewardCtrl:OnDeActive()

end --func end
--next--
function TowerRewardCtrl:Update()


end --func end

--next--
function TowerRewardCtrl:BindEvents()
    self:BindEvent(self.awardMgr.EventDispatcher,self.awardMgr.AWARD_PREWARD_MSG, self.RefreshPreviewAwards)
    self:BindEvent(self.dungeonMgr.EventDispatcher,self.dungeonMgr.DUNGEON_MONSTERS_REFRESH, self.OnDungeonMonstersRefresh)
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerRewardCtrl:ShowPreviewRewards(dungeonId)
    local rewardIds = {}
    local dungeonId = MPlayerDungeonsInfo.DungeonID
    local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId)
    local l_awardId = 0
    if dungeonData and dungeonData.DisplayAward.Length > 0 then
        local l_num = tonumber(dungeonData.DisplayAward[0])
        if l_num and l_num > 0 then
            l_awardId = l_num
        end
    end
    if l_awardId>0 then
        table.insert(rewardIds, l_awardId)
    end

    local l_monsters = MgrMgr:GetMgr("DungeonMgr").GetDungeonsMonster(dungeonId)

    if #l_monsters > 0 then
        for i, v in ipairs(l_monsters) do
            local entitySdata = TableUtil.GetEntityTable().GetRowById(v)
            if self:IsPreviewRewardMonster(entitySdata) and entitySdata.Award.Count > 0 then
                local eAwarIds = Common.Functions.VectorToTable(entitySdata.Award)
                for _, eid in ipairs(eAwarIds) do
                    table.insert(rewardIds, eid)
                end
            end
        end
    end

    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(rewardIds)
end

function TowerRewardCtrl:RefreshPreviewAwards(...)
    local datas = self.awardMgr.HandleBatchAwardRes(...)
    self.itemPool:ShowTemplates({Datas = datas, Parent=self.panel.RewardContent.transform})
end

function TowerRewardCtrl:IsPreviewRewardMonster(entitySdata)
    local ret = false
    local UnitTypeLevel = GameEnum.UnitTypeLevel
    local entitySdata = entitySdata
    if entitySdata then
        ret = entitySdata.UnitTypeLevel == UnitTypeLevel.Boss
            or entitySdata.UnitTypeLevel == UnitTypeLevel.Mini
            or entitySdata.UnitTypeLevel == UnitTypeLevel.Mvp
    end
    return ret
end

function TowerRewardCtrl:OnDungeonMonstersRefresh()
    self:ShowPreviewRewards(MPlayerDungeonsInfo.DungeonID)
end

--lua custom scripts end

return TowerRewardCtrl
