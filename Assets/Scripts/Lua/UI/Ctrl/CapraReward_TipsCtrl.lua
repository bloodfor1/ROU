--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CapraReward_TipsPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CapraReward_TipsCtrl = class("CapraReward_TipsCtrl", super)
--lua class define end

--lua functions
function CapraReward_TipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.CapraReward_Tips, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.overrideSortLayer = UILayerSort.Function + 3
	
end --func end
--next--
function CapraReward_TipsCtrl:Init()
	
	self.panel = UI.CapraReward_TipsPanel.Bind(self)
	super.Init(self)
	    self.panel.Btn_Close:AddClick(function()
	        UIMgr:DeActiveUI(UI.CtrlNames.CapraReward_Tips)
	    end)

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.ItemScroll.LoopScroll,
    })
end --func end
--next--
function CapraReward_TipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CapraReward_TipsCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.giftId and self.uiPanelData.timeId then
        self:SetDetail(self.uiPanelData.giftId, self.uiPanelData.timeId)
    end
end --func end
--next--
function CapraReward_TipsCtrl:OnDeActive()
	
	
end --func end
--next--
function CapraReward_TipsCtrl:Update()
	
	
end --func end
--next--
function CapraReward_TipsCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "CapraRewardTip",function(object, ...)
        self:RefreshAward(...)
    end)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function CapraReward_TipsCtrl:SetDetail(giftId, timeId)
    local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(giftId)
    if l_giftRow then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_giftRow.AwardID, "CapraRewardTip")

        MgrMgr:GetMgr("ItemMgr").SetItemSprite(self.panel.CoinIcon, l_giftRow.Value[0][0])
        self.panel.PriceNum.LabText = l_giftRow.Value[0][1]
    end
    local l_beginTimeStamp = MgrMgr:GetMgr("ActivityMgr").GetBeginTimeStamp(timeId)
    local l_endTimeStamp = MgrMgr:GetMgr("ActivityMgr").GetEndTimeStamp(timeId)
    self.panel.Time.LabText = StringEx.Format("{0}-{1}", Common.TimeMgr.GetDataShowTime(l_beginTimeStamp), Common.TimeMgr.GetDataShowTime(l_endTimeStamp))
end

function CapraReward_TipsCtrl:RefreshAward(awardInfo, eventName, id)
    local datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardInfo)
    self.itemPool:ShowTemplates({ Datas = datas })
end

--lua custom scripts end
return CapraReward_TipsCtrl