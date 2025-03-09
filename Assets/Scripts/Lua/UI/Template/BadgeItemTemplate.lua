--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class BadgeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Star5 MoonClient.MLuaUICom
---@field Star3 MoonClient.MLuaUICom
---@field Star2 MoonClient.MLuaUICom
---@field ShareButton MoonClient.MLuaUICom
---@field RateText MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field BadgeName MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom

---@class BadgeItemTemplate : BaseUITemplate
---@field Parameter BadgeItemTemplateParameter

BadgeItemTemplate = class("BadgeItemTemplate", super)
--lua class define end

--lua functions
function BadgeItemTemplate:Init()
	
	    super.Init(self)
	self.Parameter.RateText:SetActiveEx(false)
	self.currentTableInfo=nil
	self.point=nil
	self._level=nil
	self.Parameter.ShareButton:AddClick(function()
		local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetAchievementBPack("",self.currentTableInfo.Level,self.point,self._level,tostring(MPlayerInfo.UID))
		MgrMgr:GetMgr("AchievementMgr").ShareAchievement(l_msg,l_msgParam,Vector2.New(202.99,54.9))
	end)
	
end --func end
--next--
function BadgeItemTemplate:BindEvents()
	
	self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetBadgeRateInfoEvent,function(selfa,rate,index)
		if index~=self.ShowIndex then
			return
		end
		self.Parameter.RateText:SetActiveEx(true)
		self.Parameter.RateText.LabText=StringEx.Format(Lang("Achievement_BadgeRateText"),MgrMgr:GetMgr("AchievementMgr").GetRateText(rate))
	end)
	
end --func end
--next--
function BadgeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BadgeItemTemplate:OnSetData(data)
	
	self:showBadgeItem(data)
	
end --func end
--next--
function BadgeItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function BadgeItemTemplate:showBadgeItem(data)

	local point=data.Point
	self.point=data.Point
    self._level=data.Level

    local l_currentTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self._level,true)
    local l_nextTableInfo= TableUtil.GetAchievementBadgeTable().GetRowByLevel(self._level+1,true)
	--local l_currentTableInfo=MgrMgr:GetMgr("AchievementMgr").GetBadgeTableInfo(point)

	MgrMgr:GetMgr("AchievementMgr").RequestAchievementGetBadgeRateInfo(l_currentTableInfo.Level,self.ShowIndex)

	self.currentTableInfo=l_currentTableInfo

	local l_sliderValue=point/l_nextTableInfo.Point
	local l_textValue=tostring(point).."/"..tostring(l_nextTableInfo.Point)

	self.Parameter.ProgressSlider.Slider.value=l_sliderValue
	self.Parameter.ProgressText.LabText=l_textValue

	self.Parameter.BadgeName.LabText=l_currentTableInfo.Name
	self.Parameter.BadgeIcon:SetSprite(l_currentTableInfo.Atlas, l_currentTableInfo.Icon, true)

	self.Parameter.Star2:SetActiveEx(false)
	self.Parameter.Star3:SetActiveEx(false)
	self.Parameter.Star5:SetActiveEx(false)

	local l_currentStar
	local l_starCount=0
	if l_currentTableInfo.StarType==2 then
		l_currentStar=self.Parameter.Star2
		l_starCount=2
		self.Parameter.Star2:SetActiveEx(true)
	elseif l_currentTableInfo.StarType==3 then
		l_currentStar=self.Parameter.Star3
		l_starCount=3
		self.Parameter.Star3:SetActiveEx(true)
	else
		l_currentStar=self.Parameter.Star5
		l_starCount=5
		self.Parameter.Star5:SetActiveEx(true)
	end

	if l_currentStar~=nil then
		local l_star
		for i = 1, l_starCount do
			l_star=l_currentStar.transform:Find("star"..i)
			if l_star~=nil then
				if i<=l_currentTableInfo.LightNumber then
					l_star.gameObject:SetActiveEx(true)
				else
					l_star.gameObject:SetActiveEx(false)
				end

			end
		end
	end


	if data.IsShowShare==nil then
		data.IsShowShare=false
	end

	if data.IsShowShare then
		self.Parameter.ShareButton:SetActiveEx(true)
	else
		self.Parameter.ShareButton:SetActiveEx(false)
	end


	if tostring(data.PlayerUid)==tostring(MPlayerInfo.UID) then
		self.Parameter.PlayerName.LabText=Lang("Achievement_SelfBadgeText")

	else

		MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(data.PlayerUid,function(info)
			if info~=nil then
				self.Parameter.PlayerName.LabText=StringEx.Format(Lang("Achievement_BadgeText"),info.name)
			end

		end)
	end
end
--lua custom scripts end
return BadgeItemTemplate