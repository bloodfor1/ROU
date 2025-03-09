--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InfinityTowerFirstRewardPanel"
require "UI/Template/TowerFirstRewardTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
InfinityTowerFirstRewardCtrl = class("InfinityTowerFirstRewardCtrl", super)
--lua class define end

--lua functions
function InfinityTowerFirstRewardCtrl:ctor()

    super.ctor(self, CtrlNames.InfinityTowerFirstReward, UILayer.Function, nil, ActiveType.Standalone)

    self.InsertPanelName = UI.CtrlNames.InfinityTower
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.InfinityTowerFirstReward

end --func end
--next--
function InfinityTowerFirstRewardCtrl:Init()

    self.panel = UI.InfinityTowerFirstRewardPanel.Bind(self)
    super.Init(self)

    self.ItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TowerFirstRewardTemplate,
        TemplateParent = self.panel.InfinityTowerFirstRewardContent.transform,
        TemplatePrefab = self.panel.TowerFirstRewardTemplate.LuaUIGroup.gameObject
    })


end --func end
--next--
function InfinityTowerFirstRewardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function InfinityTowerFirstRewardCtrl:OnActive()
    self.panel.BtnClose.gameObject:SetActiveEx(true)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.InfinityTowerFirstReward)
    end)

    self.panel.BtnCloseRight:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.InfinityTowerFirstReward)
    end)

    self:InitRwardList()
end --func end
--next--
function InfinityTowerFirstRewardCtrl:OnDeActive()
	-- do nothing
end --func end
--next--
function InfinityTowerFirstRewardCtrl:Update()
	-- do nothing
end --func end
--next--
function InfinityTowerFirstRewardCtrl:BindEvents()
	-- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts

function InfinityTowerFirstRewardCtrl:InitRwardList()
    local l_rewardList = self:GetRewards()
    local l_datas = {}
    for lv, item in pairs(l_rewardList) do
        table.insert(l_datas, {
            lv = lv,
            items = item,
        })
    end

    array.sortby(l_datas, "lv", false)
    self.ItemPool:ShowTemplates({
        Datas = l_datas
    })
end

function InfinityTowerFirstRewardCtrl:GetRewards()
    local l_result = {}
    local l_table = TableUtil.GetEndlessTowerTable().GetTable()
    for lv, row in pairs(l_table) do
        if row.FirstArrivalReward ~= 0 then
            local l_rewardItemList = MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardId(row.FirstArrivalReward)
            if 0 == #l_rewardItemList then
                logError("[无限塔] EndlessTowerTable ID: " .. tostring(lv) .. "奖励配置为空")
            end
            l_result[lv] = l_rewardItemList
        end
    end

    return l_result
end

--lua custom scripts end
return InfinityTowerFirstRewardCtrl