--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildRank_TrophyPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local guildRankMgr = MgrMgr:GetMgr("GuildRankMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local C_NIL_STR = "NIL"
--lua fields end

--lua class define
GuildRank_TrophyPanelCtrl = class("GuildRank_TrophyPanelCtrl", super)
--lua class define end

--lua functions
function GuildRank_TrophyPanelCtrl:ctor()
    super.ctor(self, CtrlNames.GuildRank_TrophyPanel, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function GuildRank_TrophyPanelCtrl:Init()
    self.panel = UI.GuildRank_TrophyPanelPanel.Bind(self)
    super.Init(self)

    self:_initTemplateConfig()
    self:_initWidgets()

    self._countDown = Common.CommonCountDownUtil.new()
end --func end
--next--
function GuildRank_TrophyPanelCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildRank_TrophyPanelCtrl:OnActive()
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
function GuildRank_TrophyPanelCtrl:OnDeActive()

end --func end
--next--
function GuildRank_TrophyPanelCtrl:Update()
    self._countDown:OnUpdate()
end --func end
--next--
function GuildRank_TrophyPanelCtrl:BindEvents()
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.ForceRefreshGuildRank, self._refreshPanel)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 如果时间到了
function GuildRank_TrophyPanelCtrl:_onTimeOut()
    guildRankMgr.ForceRefreshAll()
end

function GuildRank_TrophyPanelCtrl:_initTemplateConfig()
    self._trophyConfig1 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_1.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
    self._trophyConfig2 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_2.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
    self._trophyConfig3 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_3.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
    self._trophyConfig4 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_4.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
    self._trophyConfig5 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_5.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
    self._trophyConfig6 = {
        name = "GuildRankTrophy",
        config = {
            TemplateParent = self.panel.Dummy_6.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/GuildRankTrophy"
        }
    }
end

function GuildRank_TrophyPanelCtrl:_initWidgets()
    ---@type GuildRankTrophy[]
    self._trophies = {}
    self._trophyTlp1 = self:NewTemplate(self._trophyConfig1.name, self._trophyConfig1.config)
    self._trophyTlp2 = self:NewTemplate(self._trophyConfig2.name, self._trophyConfig2.config)
    self._trophyTlp3 = self:NewTemplate(self._trophyConfig3.name, self._trophyConfig3.config)
    self._trophyTlp4 = self:NewTemplate(self._trophyConfig4.name, self._trophyConfig4.config)
    self._trophyTlp5 = self:NewTemplate(self._trophyConfig5.name, self._trophyConfig5.config)
    self._trophyTlp6 = self:NewTemplate(self._trophyConfig6.name, self._trophyConfig6.config)

    table.insert(self._trophies, self._trophyTlp1)
    table.insert(self._trophies, self._trophyTlp2)
    table.insert(self._trophies, self._trophyTlp3)
    table.insert(self._trophies, self._trophyTlp4)
    table.insert(self._trophies, self._trophyTlp5)
    table.insert(self._trophies, self._trophyTlp6)

    self.panel.ButtonClose:AddClick(guildRankMgr.OnTrophyPanelClose)
    self.panel.Btn_Hint.Listener.onDown = self._onHintClick
end

function GuildRank_TrophyPanelCtrl:_refreshPanel()
    local trophyList = guildRankMgr.GetTrophyDataList()
    local str = StringEx.Format(Lang("C_GUILD_RANK_TROPHY_COUNT"), tostring(#trophyList))
    self.panel.Txt_Rank.LabText = str
    local showNotTrophyHint = nil == trophyList or 0 == #trophyList
    self.panel.NoneJiangBei.gameObject:SetActiveEx(showNotTrophyHint)
    self.panel.Img_Line.gameObject:SetActiveEx(not showNotTrophyHint)
    for i = 1, #self._trophies do
        if nil == trophyList[i] then
            self._trophies[i]:SetData(C_NIL_STR)
        else
            self._trophies[i]:SetData(trophyList[i])
        end
    end
end

--- 点击问号获取提示
function GuildRank_TrophyPanelCtrl._onHintClick(go, eventData)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("C_GUILD_RANK_TROPHY_HINT"), eventData, Vector2(0, 0), true)
end

--lua custom scripts end
return GuildRank_TrophyPanelCtrl