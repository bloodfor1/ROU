--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RankRewardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class RankRewardCtrl : UIBaseCtrl
RankRewardCtrl = class("RankRewardCtrl", super)
--lua class define end

--lua functions
function RankRewardCtrl:ctor()

    super.ctor(self, CtrlNames.RankReward, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function RankRewardCtrl:Init()

    self.panel = UI.RankRewardPanel.Bind(self)
    super.Init(self)
    self.rowTem = nil
    self.rewardInfos = {}
    self.panel.Btn_Close:AddClickWithLuaSelf(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RankReward)
    end, self)
end --func end
--next--
function RankRewardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
	self.rowTem = nil
end --func end
--next--
function RankRewardCtrl:OnActive()
    local nameStr = ""
    if self.uiPanelData then
        self.rewardInfos = self.uiPanelData.rewardInfo
        nameStr = nameStr .. self.uiPanelData.rankName
    end
    self.panel.Txt_Title.LabText = nameStr .. Common.Utils.Lang("TXT_RANK_AWARD")
    self:RefreshPanel()
end --func end
--next--
function RankRewardCtrl:OnDeActive()


end --func end
--next--
function RankRewardCtrl:Update()


end --func end
--next--
function RankRewardCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

function RankRewardCtrl:RefreshPanel()
    if self.rowTem == nil then
        self.rowTem = self:NewTemplatePool({
            TemplateClassName = "RankRowRewardTem",
            TemplatePrefab = self.panel.RankRowRewardTem.gameObject,
            ScrollRect = self.panel.ScrollRect.LoopScroll,
        })
    end
    local datas = {}
    for i = 1, #self.rewardInfos do
        local mailInfo = TableUtil.GetMailTable().GetRowById(self.rewardInfos[i][3]).MailGroupContent
        if mailInfo.Length > 0 then
            table.insert(datas, {
                left = self.rewardInfos[i][1],
                right = self.rewardInfos[i][2],
                items = Common.Functions.VectorSequenceToTable(mailInfo)
            })
        end
    end
    self.rowTem:ShowTemplates({ Datas = datas })
end

--lua custom scripts end
return RankRewardCtrl