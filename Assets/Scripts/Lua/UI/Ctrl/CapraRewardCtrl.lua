--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CapraRewardPanel"
require "UI/Template/CapraGiftItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CapraRewardCtrl = class("CapraRewardCtrl", super)
--lua class define end

--lua functions
function CapraRewardCtrl:ctor()
	
	super.ctor(self, CtrlNames.CapraReward, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function CapraRewardCtrl:Init()
	
	self.panel = UI.CapraRewardPanel.Bind(self)
	super.Init(self)

    self.groupId = 0

    self.panel.Btn_Back:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CapraReward)
    end)

    self.rewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CapraGiftItem,
        TemplatePrefab = self.panel.CapraGiftItem.LuaUIGroup.gameObject,
        ScrollRect = self.panel.GiftScroll.LoopScroll,
    })

    self.panel.GiftScroll:SetLoopScrollGameObjListener(self.panel.Btn_Left.gameObject, self.panel.Btn_Right.gameObject, nil, nil)

    --self:RefreshDetail()
end --func end
--next--
function CapraRewardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CapraRewardCtrl:OnActive()
    MgrMgr:GetMgr("GiftPackageMgr").RequestTimeGiftInfo()

    if self.uiPanelData and self.uiPanelData.groupId then
        self.groupId = self.uiPanelData.groupId or 0
    end

    self:RefreshDetail()
end --func end
--next--
function CapraRewardCtrl:OnDeActive()
	
	
end --func end
--next--
function CapraRewardCtrl:Update()
	
	
end --func end
--next--
function CapraRewardCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("FestivalMgr").EventDispatcher, MgrMgr:GetMgr("FestivalMgr").Event.RefreshFestival, function()
        self:RefreshDetail()
    end)
    local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
    self:BindEvent(l_giftPackageMgr.EventDispatcher, l_giftPackageMgr.EventType.TimeGiftInfoRefresh,
            self.RefreshDetail,self)
end --func end
--next--
--lua functions end

--lua custom scripts

function CapraRewardCtrl:RefreshDetail()
    local l_groupInfo = MgrMgr:GetMgr("GiftPackageMgr").GetTimeGiftInfo(self.groupId)
    if l_groupInfo then
        self.panel.Name.LabText = string.gsub(l_groupInfo.activityName, "\\n", "")
    end

    local l_groupEndTimeStamp = MgrMgr:GetMgr("GiftPackageMgr").GetGroupEndTimeStamp(self.groupId)
    self.panel.Time.LabText = Common.TimeMgr.GetDataShowTime(l_groupEndTimeStamp)

    local l_giftPackageList = MgrMgr:GetMgr("GiftPackageMgr").GetGiftIdsByGroupId(self.groupId)
    local l_hasGiftInfo = #l_giftPackageList>0
    self.rewardPool:ShowTemplates({Datas = l_giftPackageList})
    self.panel.NoGiftData:SetActiveEx(not l_hasGiftInfo)
    self.panel.Deadline:SetActiveEx(l_hasGiftInfo)
end

--lua custom scripts end
return CapraRewardCtrl