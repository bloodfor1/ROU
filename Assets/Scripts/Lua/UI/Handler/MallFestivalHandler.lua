--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/MallFestivalPanel"
require "UI/Template/MallFestivalPrefab"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
--- @class MallFestivalHandler:UIBaseHandler
MallFestivalHandler = class("MallFestivalHandler", super)
--lua class define end

--lua functions
function MallFestivalHandler:ctor()
	
	super.ctor(self, HandlerNames.MallFestival, 0)
	
end --func end
--next--
function MallFestivalHandler:Init()
	
	self.panel = UI.MallFestivalPanel.Bind(self)
	super.Init(self)

	self.giftMgr = MgrMgr:GetMgr("GiftPackageMgr")
	self.mallMgr = MgrMgr:GetMgr("MallMgr")

	self.rewardPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.MallFestivalPrefab,
		TemplatePrefab = self.panel.MallFestivalPrefab.gameObject,
		ScrollRect = self.panel.ItemGroup.LoopScroll,
	})
	
end --func end
--next--
function MallFestivalHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MallFestivalHandler:OnActive()

	self.panel.NoGiftData:SetActiveEx(false)
	self:RefreshDetail()
	--self.giftMgr.RequestTimeGiftInfo()
	
end --func end
--next--
function MallFestivalHandler:OnDeActive()
	
	
end --func end
--next--
function MallFestivalHandler:Update()
	
	
end --func end
--next--
function MallFestivalHandler:BindEvents()

	self:BindEvent(MgrMgr:GetMgr("FestivalMgr").EventDispatcher, MgrMgr:GetMgr("FestivalMgr").Event.RefreshFestival, self.RefreshDetail,self)
	self:BindEvent(self.giftMgr.EventDispatcher, self.giftMgr.EventType.TimeGiftInfoRefresh, self.RefreshDetail,self)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function MallFestivalHandler:RefreshDetail()

	local groupInfo = MgrMgr:GetMgr("GiftPackageMgr").GetGroupInfos()
	local groupId = 0
	if #groupInfo > 0 then
		groupId = groupInfo[#groupInfo].mainId
	end
	local l_groupEndTimeStamp = self.giftMgr.GetGroupEndTimeStamp(groupId)
	local timeData = os.date("!*t", Common.TimeMgr.GetLocalTimestamp(l_groupEndTimeStamp))
	local day = timeData.hour == 0 and timeData.day - 1 or timeData.day
	local hour = timeData.hour == 0 and "24" or timeData.hour
	local min = timeData.min == 0 and "00" or timeData.min
	local sec = timeData.sec == 0 and "00" or timeData.sec
	self.panel.Time.LabText = Lang("MALL_FESTIVSL_DATE_YY_MM_DD", timeData.year, timeData.month, day,hour,min,sec)
	local l_giftPackageList = self.giftMgr.GetGiftIdsByGroupId(groupId)
	local l_hasGiftInfo = #l_giftPackageList>0
	self.rewardPool:ShowTemplates({Datas = l_giftPackageList})
	self.panel.ItemGroup:SetLoopScrollGameObjListener(self.panel.BtnPrevious.gameObject, self.panel.BtnNext.gameObject, nil, nil)
	self.panel.NoGiftData:SetActiveEx(not l_hasGiftInfo)
	self.panel.Time:SetActiveEx(l_hasGiftInfo)

	MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GiftPackage)
end

--lua custom scripts end
return MallFestivalHandler