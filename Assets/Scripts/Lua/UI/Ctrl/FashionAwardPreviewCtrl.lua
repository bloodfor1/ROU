--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionAwardPreviewPanel"
require "UI/Template/ItemTemplate"
require "UI/Template/RankRewardAllTemplate"
require "Common/Utils"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
FashionAwardPreviewCtrl = class("FashionAwardPreviewCtrl", super)
--lua class define end

--lua functions
function FashionAwardPreviewCtrl:ctor()
    
    super.ctor(self, CtrlNames.FashionAwardPreview, UILayer.Function, nil, ActiveType.None)
    
end --func end
--next--
function FashionAwardPreviewCtrl:Init()
    
    self.panel = UI.FashionAwardPreviewPanel.Bind(self)
    super.Init(self)

    self.mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.itemPoolZ = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.ScrollRectZ.LoopScroll,
    })
    self.itemPoolAll = self:NewTemplatePool({
        UITemplateClass = UITemplate.RankRewardAllTemplate,
        TemplatePrefab = self.panel.RankRewardAll.gameObject,
        ScrollRect = self.panel.ScrollRectRank.LoopScroll,
    })

    local l_awardId = MGlobalConfig:GetInt("FashionBaseRewardId")
    local l_awardData = MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardId(l_awardId)
    self:InitAwardData(l_awardData, self.itemPoolZ)

    local l_leaderAward = TableUtil.GetLeaderBoardComponentTable().GetRowByID(self.mgr.FashionScoreRankID)
    self:InitRank(l_leaderAward.Reward, self.itemPoolAll)
    
end --func end
--next--
function FashionAwardPreviewCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil

    self.itemPoolZ = nil
    
end --func end
--next--
function FashionAwardPreviewCtrl:OnActive()
    
    
end --func end
--next--
function FashionAwardPreviewCtrl:OnDeActive()
    
    
end --func end
--next--
function FashionAwardPreviewCtrl:Update()

	if MoonClient.MRaycastTouchUtils.IsNoTouchedForLua(self.panel.BackGround.UObj, true, UnityEngine.TouchPhase.Began) then
        UIMgr:DeActiveUI(UI.CtrlNames.FashionAwardPreview)
	end
    
end --func end
--next--
function FashionAwardPreviewCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function FashionAwardPreviewCtrl:InitRank(rankData, pool)

    if not rankData then
        return
    end

    local l_colorGroup = {
        [1] = "F59C34FF",
        [2] = "7493DAFF",
        [3] = "4B6CBBFF"
    }
    rankData = Common.Functions.VectorToTable(rankData)
    local l_data = {}
    for i = 1, #rankData do
        local l_temp = Common.Functions.SequenceToTable(rankData[i])
        local l_table = {down = l_temp[1], up = l_temp[2], mail = l_temp[3], color = l_colorGroup[math.min(i, 3)]}
        table.insert(l_data, l_table)
    end
    pool:ShowTemplates({ Datas = l_data })

end

function FashionAwardPreviewCtrl:InitAwardData(data, pool)
    
    local l_costDatas = {}
    for i, v in ipairs(data) do
        table.insert(l_costDatas, { ID = v.item_id, Count = v.count, IsShowCount = false })
    end
    pool:ShowTemplates({ Datas = l_costDatas })

end
--lua custom scripts end
return FashionAwardPreviewCtrl