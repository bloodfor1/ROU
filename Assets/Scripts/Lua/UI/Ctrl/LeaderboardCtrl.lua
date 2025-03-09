--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LeaderboardPanel"
require "UI/Template/RankItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
LeaderboardCtrl = class("LeaderboardCtrl", super)
--lua class define end

--lua functions
function LeaderboardCtrl:ctor()

    super.ctor(self, CtrlNames.Leaderboard, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function LeaderboardCtrl:Init()

    self.panel = UI.LeaderboardPanel.Bind(self)
    super.Init(self)
    --self:SetBlockOpt(BlockColor.Dark)

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Leaderboard)
    end)

end --func end
--next--
function LeaderboardCtrl:SetupHandlers()

    local l_handlerTb = {
        {HandlerNames.PanelRank, Lang("GUILD_HUNT_SCORE"), "CommonIcon", "UI_Commonicon_Chengjiu_02.png", "UI_Commonicon_Chengjiu_01.png"},
        {HandlerNames.Teammate, Lang("MEMBER"), "CommonIcon", "UI_CommonIcon_Tab_zuduichengyuan_02.png", "UI_CommonIcon_Tab_zuduichengyuan_01.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, false)

end --func end
--next--
function LeaderboardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LeaderboardCtrl:OnActive()

    self:SelectOneHandler(HandlerNames.PanelRank)

end --func end
--next--
function LeaderboardCtrl:OnDeActive()

end --func end
--next--
function LeaderboardCtrl:Update()

    super.Update(self)

end --func end





--next--
function LeaderboardCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts
--lua custom scripts end
return LeaderboardCtrl
