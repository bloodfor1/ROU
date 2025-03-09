--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AnnouncementPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_pushTime = 0.5
--lua fields end

--lua class define
AnnouncementCtrl = class("AnnouncementCtrl", super)
--lua class define end

--lua functions
function AnnouncementCtrl:ctor()
	
	super.ctor(self, CtrlNames.Announcement, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function AnnouncementCtrl:Init()
	
	self.panel = UI.AnnouncementPanel.Bind(self)
	super.Init(self)

	l_pushTime = tonumber(TableUtil.GetGlobalTable().GetRowByName("PushadTime").Value) or 0.5
	self.mgr = MgrMgr:GetMgr("AdMgr")
	self.data = DataMgr:GetData("AdData")
	self.panel.BtnClose:AddClick(function()
		self.mgr.ForcesActiveUI(false)
	end)
	self.tweenId = 0
	self.nowAd = self.data.GetNowAd()
	--先把图片能load的load下来
	for i = 2, #self.nowAd.imageList do
		self.panel.titleImg:DownLoadImageWithURL(self.nowAd.imageList[i].imgURL)
	end
	for i = 1, #self.panel.node do
		self.panel.node[i]:SetActiveEx(i <= #self.nowAd.imageList)
		self.panel.choose[i]:SetActiveEx(i == self.data.nowImgIndex)
	end
	self.panel.titleImg:SetActiveEx(true)
	self.panel.BtnLeft:AddClick(function()
		local l_lastIndex = self.data.nowImgIndex
		self:Refresh(l_lastIndex, self.data.NextAdImg(true))
	end)
	self.panel.BtnRight:AddClick(function()
		local l_lastIndex = self.data.nowImgIndex
		self:Refresh(l_lastIndex, self.data.NextAdImg(false))
	end)
	self:Refresh(0, self.data.nowImgIndex)

end --func end
--next--
function AnnouncementCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function AnnouncementCtrl:OnActive()
	
	
end --func end
--next--
function AnnouncementCtrl:OnDeActive()

	if self.tweenId > 0 then
		MUITweenHelper.KillTween(self.tweenId)
		self.tweenId = 0
	end

end --func end
--next--
function AnnouncementCtrl:Update()
	
	
end --func end
--next--
function AnnouncementCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AnnouncementCtrl:GetImgInfo(lastIndex, index)

	if lastIndex > 0 then
		self.panel.choose[lastIndex]:SetActiveEx(false)
		self.panel.choose[index]:SetActiveEx(true)
	end
	self.panel.BtnText.LabText = self.nowAd.imageList[index].btnName
	self.panel.BtnGo:AddClick(function()
		str = string.ro_split(self.nowAd.imageList[index].btnURL, "=")
		str = string.ro_split(str[2], ">")
		MgrMgr:GetMgr("CapraFAQMgr").ParsHref(str[1])
	end)

end

function AnnouncementCtrl:Refresh(lastIndex, index)

	if self.tweenId > 0 then
		MUITweenHelper.KillTween(self.tweenId)
		self.tweenId = 0
	end
	--self.nowAd.imageList[index].imgURL = "www.zsasgasg.com"
	if lastIndex ~= index and lastIndex > 0 then
		self.tweenId = MUITweenHelper.TweenAlpha(self.panel.titleImg.gameObject, 1, 0, l_pushTime, function()
			self.panel.titleImg:UseLoadImageWithURL(self.nowAd.imageList[index].imgURL, 1360, 840, function()
				self:GetImgInfo(lastIndex, index)
				self.tweenId = MUITweenHelper.TweenAlpha(self.panel.titleImg.gameObject, 0, 1, l_pushTime, function()
					self.tweenId = 0
				end)
			end, false)
		end)
	elseif lastIndex == 0 then
		self.panel.titleImg:UseLoadImageWithURL(self.nowAd.imageList[index].imgURL, 1360, 840, function()
			self:GetImgInfo(lastIndex, index)
			self.tweenId = MUITweenHelper.TweenAlpha(self.panel.titleImg.gameObject, 0, 1, l_pushTime, function()
				self.tweenId = 0
			end)
		end, false)
	end

end
--lua custom scripts end
return AnnouncementCtrl