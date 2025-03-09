--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildRank_ScorePanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local guildRankMgr = MgrMgr:GetMgr("GuildRankMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local EScoreType = GameEnum.EGuildScoreType
--lua fields end

--lua class define
GuildRank_ScorePanelCtrl = class("GuildRank_ScorePanelCtrl", super)
--lua class define end

--lua functions
function GuildRank_ScorePanelCtrl:ctor()
    super.ctor(self, CtrlNames.GuildRank_ScorePanel, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function GuildRank_ScorePanelCtrl:Init()
    self.panel = UI.GuildRank_ScorePanelPanel.Bind(self)
    super.Init(self)

    self._countDown = Common.CommonCountDownUtil.new()

    self:_initTemplateConfig()
    self:_initWidgets()
end --func end
--next--
function GuildRank_ScorePanelCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildRank_ScorePanelCtrl:OnActive()
    self:_refreshPanel()

    ---@type CountDownUtilParam
    local param = {
        totalTime = guildRankMgr.GetRemainSeconds(),
        clearCallback = self._onTimeOut,
        clearCallbackSelf = self,
    }

    self._countDown:Init(param)
    self._countDown:Start()
end --func end
--next--
function GuildRank_ScorePanelCtrl:OnDeActive()

end --func end
--next--
function GuildRank_ScorePanelCtrl:Update()
    self._countDown:OnUpdate()
end --func end
--next--
function GuildRank_ScorePanelCtrl:BindEvents()
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.ForceRefreshGuildRank, self._refreshPanel)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 创建几个模板的配置数据
function GuildRank_ScorePanelCtrl:_initTemplateConfig()
    self._gvgScoreConfig = {
        name = "GuildRankActScoreTemplate",
        config = {
            TemplateParent = self.panel.Guild_Dummy_4.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankActScoreTemplate"
        }
    }

    self._guildHuntConfig = {
        name = "GuildRankActScoreTemplate",
        config = {
            TemplateParent = self.panel.Guild_Dummy_1.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankActScoreTemplate"
        }
    }

    self._guildEliteMatchConfig = {
        name = "GuildRankActScoreTemplate",
        config = {
            TemplateParent = self.panel.Guild_Dummy_3.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankActScoreTemplate"
        }
    }

    self._guildCookConfig = {
        name = "GuildRankActScoreTemplate",
        config = {
            TemplateParent = self.panel.Guild_Dummy_2.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankActScoreTemplate"
        }
    }
end

--- 设置控件的响应数据，这个页面当中只有按钮
--- 创建四个模板
function GuildRank_ScorePanelCtrl:_initWidgets()
    ---@type GuildRankActScoreTemplate
    self._gvgTemp = self:NewTemplate(self._gvgScoreConfig.name, self._gvgScoreConfig.config)
    ---@type GuildRankActScoreTemplate
    self._guildHuntTemp = self:NewTemplate(self._guildHuntConfig.name, self._guildHuntConfig.config)
    ---@type GuildRankActScoreTemplate
    self._guildEliteTemp = self:NewTemplate(self._guildEliteMatchConfig.name, self._guildEliteMatchConfig.config)
    ---@type GuildRankActScoreTemplate
    self._guildCookTemp = self:NewTemplate(self._guildCookConfig.name, self._guildCookConfig.config)

    self.panel.ButtonClose:AddClick(guildRankMgr.OnCloseClick)
    self.panel.Btn_Rank:AddClick(guildRankMgr.OnRankClick)
    self.panel.Btn_Trophy:AddClick(guildRankMgr.OnTrophyClick)
    self.panel.Btn_Hint.Listener.onDown = self._onHintClick
end

function GuildRank_ScorePanelCtrl:_refreshPanel()
    self.panel.Txt_HelpDesc.LabText = Common.Utils.Lang("C_GUILD_RANK_HELP_DESC")
    self.panel.Txt_Rank.LabText = guildRankMgr.GetGuildRankStr()
    self.panel.Txt_Score.LabText = guildRankMgr.GetSelfGuildScoreByType(EScoreType.Total)
    self._guildHuntTemp:SetData(guildRankMgr.GetRankScorePairByScoreType(EScoreType.GuildHunt))
    self._guildEliteTemp:SetData(guildRankMgr.GetRankScorePairByScoreType(EScoreType.GuildEliteMatch))
    self._guildCookTemp:SetData(guildRankMgr.GetRankScorePairByScoreType(EScoreType.GuildCooking))
    self._gvgTemp:SetData(guildRankMgr.GetRankScorePairByScoreType(EScoreType.GVG))
end

--- 如果时间到了
function GuildRank_ScorePanelCtrl:_onTimeOut()
    guildRankMgr.ForceRefreshAll()
end

--- 点击问号获取提示
function GuildRank_ScorePanelCtrl._onHintClick(go, eventData)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("C_GUILD_RANK_SCORE_PANEL_HINT"), eventData, Vector2(0, 0), true)
end

--lua custom scripts end
return GuildRank_ScorePanelCtrl