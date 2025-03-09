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
---@class AchievementDetailsTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShareButton MoonClient.MLuaUICom
---@field RateText MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field AwardText MoonClient.MLuaUICom

---@class AchievementDetailsTemplate : BaseUITemplate
---@field Parameter AchievementDetailsTemplateParameter

AchievementDetailsTemplate = class("AchievementDetailsTemplate", super)
--lua class define end

--lua functions
function AchievementDetailsTemplate:Init()
	
	    super.Init(self)
	self.Data=nil
	self.finishTime=0
	self._mgr=MgrMgr:GetMgr("AchievementMgr")
	self.Parameter.RateText:SetActiveEx(false)
	self.Parameter.ShareButton:AddClick(function()
	    local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetAchievementDPack("",self.Data.AchievementId,tostring(MPlayerInfo.UID),tostring(self.finishTime or 0))
		MgrMgr:GetMgr("AchievementMgr").ShareAchievement(l_msg,l_msgParam,Vector2.New(202.99,54.9))
	end)
	
end --func end
--next--
function AchievementDetailsTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementDetailsTemplate:BindEvents()
	
	local l_awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
	self:BindEvent(l_awardPreviewMgr.EventDispatcher,l_awardPreviewMgr.AWARD_PREWARD_MSG,function(object, data,h,id)
		if self.Data==nil then
			return
		end
		local l_tableInfo= TableUtil.GetAchievementDetailTable().GetRowByID(self.Data.AchievementId)
		if l_tableInfo==nil then
			return
		end
		if l_tableInfo.Award==id then
			self:_showAwardText(data.award_list)
		end
	end)
	self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetFinishRateInfoEvent,function(selfa,rate)
		self.Parameter.RateText:SetActiveEx(true)
		self.Parameter.RateText.LabText=StringEx.Format(Lang("Achievement_DetailsRateText"),MgrMgr:GetMgr("AchievementMgr").GetRateText(rate))
	end)
	
end --func end
--next--
function AchievementDetailsTemplate:OnSetData(data)
	
	self.Data=data
	self.Parameter.AwardText:SetActiveEx(false)
	local l_achievement= MgrMgr:GetMgr("AchievementMgr").GetAchievementWithId(data.AchievementId)
	if l_achievement == nil then
		logError("没有取到成就数据，id："..tostring(data.AchievementId))
		return
	end
	local l_tableInfo=l_achievement:GetDetailTableInfo()
	if l_tableInfo == nil then
		return
	end
	if tostring(data.PlayerUid)==tostring(MPlayerInfo.UID) then
		self.finishTime=l_achievement.finishtime
		--logGreen("self.finishTime:"..tostring(self.finishTime))
		self.Parameter.ShareButton:SetActiveEx(true)
		--if MgrMgr:GetMgr("AchievementMgr").GetProgress(l_achievement)==0 then
		--	self.Parameter.Progress:SetActiveEx(false)
		--else
		--	self:showProgressText(MPlayerInfo.Name,self.finishTime)
		--end
		self:showProgressText(MPlayerInfo.Name,self.finishTime)
		if l_tableInfo.Award~=0 then
			MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_tableInfo.Award)
		else
			if l_tableInfo.Title~=0 then
				self:_showAwardText(nil)
			end
		end
	else
		self.Parameter.ShareButton:SetActiveEx(false)
		self.finishTime=data.FinishTime
		MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(data.PlayerUid,function(info)
			if info~=nil then
				self:showProgressText(info.name,self.finishTime)
			end
		end)
	end
	self.Parameter.Name.LabText=l_tableInfo.Name
	self.Parameter.Describe.LabText=MgrMgr:GetMgr("AchievementMgr").GetAchievementDetailsWithTableInfo(l_tableInfo)
	if data.IsShowShare==nil then
		data.IsShowShare=false
	end
	if data.IsShowShare then
		self.Parameter.ShareButton:SetActiveEx(true)
	else
		self.Parameter.ShareButton:SetActiveEx(false)
	end
	if MgrMgr:GetMgr("AchievementMgr").IsFinish(l_achievement) then
		--完成
		self.Parameter.Describe:SetActiveEx(true)
	elseif MgrMgr:GetMgr("AchievementMgr").IsAchievementInProgress(l_achievement) then
		--正在进行中
		self.Parameter.Describe:SetActiveEx(true)
	else
		--未开始
		self.Parameter.Describe:SetActiveEx(false)
	end
	
end --func end
--next--
function AchievementDetailsTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementDetailsTemplate:showProgressText(name,finishtime)

	if self:IsInited() == false then
		return
	end

	if self.Parameter == nil then
		return
	end

	if self.Parameter.Progress == nil then
		return
	end
	if finishtime==nil or finishtime==MLuaCommonHelper.Long(0) or finishtime=="0" or finishtime==0 then
		self.Parameter.Progress.LabText=StringEx.Format(Lang("Achievement_Going"),name)
	else
		self.Parameter.Progress.LabText=StringEx.Format(Lang("Achievement_Finish"),name,Common.TimeMgr.GetChatTimeFormatStr(finishtime,"!%Y-%m-%d"))
	end
end

function AchievementDetailsTemplate:_showAwardText(AwardData)

	if self.Data==nil then
		return
	end
	if self.Data.IsComparison then
		return
	end
	local l_tableInfo= TableUtil.GetAchievementDetailTable().GetRowByID(self.Data.AchievementId)
	if l_tableInfo==nil then
		return
	end

	local l_achievement= MgrMgr:GetMgr("AchievementMgr").GetAchievementWithId(self.Data.AchievementId)


	local l_texts={}
	if AwardData~=nil then
		for i = 1, #AwardData do
			local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(AwardData[i].item_id)
			local l_text=l_itemTableInfo.ItemName.."×"..AwardData[i].count
			table.insert(l_texts,l_text)
		end
	end

	if l_tableInfo.Title~=0 then
		local l_text=StringEx.Format(Lang("Achievement_DetailsTitleText"),l_tableInfo.Title)
		table.insert(l_texts,l_text)
	end

	local l_allText=""
	for i = 1, #l_texts do
		l_allText=l_allText..l_texts[i]
		if i<#l_texts then
			l_allText=l_allText.."、"
		end
	end

	self.Parameter.AwardText:SetActiveEx(true)
	if l_achievement.is_get_reward then
		self.Parameter.AwardText.LabText=StringEx.Format(Lang("Achievement_AwardedText"),l_allText)
	else
		self.Parameter.AwardText.LabText=StringEx.Format(Lang("Achievement_CanAwardText"),l_allText)
	end

end
--lua custom scripts end
return AchievementDetailsTemplate