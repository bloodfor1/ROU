--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/PanelRankPanel"
require "UI/Template/RankItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
PanelRankHandler = class("PanelRankHandler", super)
--lua class define end

--lua functions
function PanelRankHandler:ctor()

    super.ctor(self, HandlerNames.PanelRank, 0)

end --func end
--next--
function PanelRankHandler:Init()

    self.panel = UI.PanelRankPanel.Bind(self)
    super.Init(self)

    self.curSelectedItem = nil
    --排行榜池建立
    self.rankTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.RankItemTemplate,
        TemplatePrefab = self.panel.RankItemPrefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })
    self.panel.RankItemPrefab.gameObject:SetActiveEx(false)

end --func end
--next--
function PanelRankHandler:Uninit()

    self.curSelectedItem = nil
    self.rankTemplatePool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PanelRankHandler:OnActive()
    local l_guildData = DataMgr:GetData("GuildData")
    self.rankTemplatePool:ShowTemplates({Datas = l_guildData.guildHuntInfo.scoreList,
        Method = function(memberItem)
            self:OnSelectRankMemberItem(memberItem)
        end})

    --自己的排行数据展示
    local l_selfRank = l_guildData.guildHuntInfo.selfScore.rank
    local l_selfScore = l_guildData.guildHuntInfo.selfScore.score
    self.PlayerHead2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.HeadDummySelf.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    ---@type HeadTemplateParam
    local param = {}
    param.IsPlayerSelf = true
    self.PlayerHead2D:SetData(param)
    self.panel.RankText.LabText = l_selfRank
    self.panel.Score.LabText = l_selfScore
    self.panel.Lv.LabText = "Lv."..MPlayerInfo.Lv
    self.panel.Name.LabText = MPlayerInfo.Name
    local l_jobRow = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    self.panel.JobName.LabText = l_jobRow.Name

end --func end
--next--
function PanelRankHandler:OnDeActive()


end --func end
--next--
function PanelRankHandler:Update()


end --func end


--next--
function PanelRankHandler:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
--选中某个成员的点击事件
function PanelRankHandler:OnSelectRankMemberItem(memberItem)

    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = memberItem
    self.curSelectedItem:SetSelect(true)
    --显示玩家详细界面
    local l_ui = UIMgr:GetUI(UI.CtrlNames.PlayerMenuL)
    if (not l_ui) or (not l_ui.isActive) then
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(MLuaCommonHelper.Long(memberItem.data.member_info.role_uid))
    end

end
--lua custom scripts end
return PanelRankHandler