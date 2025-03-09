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
---@class GuildRewardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Progress MoonClient.MLuaUICom
---@field Txt_PersonalNormalRewardNum MoonClient.MLuaUICom
---@field Txt_GuildNormalRewardNum MoonClient.MLuaUICom
---@field Img_RedHint MoonClient.MLuaUICom
---@field Img_PersonalNormalReward MoonClient.MLuaUICom
---@field Img_PersonalFinishReward MoonClient.MLuaUICom
---@field Img_NoFinish MoonClient.MLuaUICom
---@field Img_InProgress MoonClient.MLuaUICom
---@field Img_guildNormalReward MoonClient.MLuaUICom
---@field Img_GuildFinishReward MoonClient.MLuaUICom
---@field Img_Finish MoonClient.MLuaUICom
---@field Btn_PersonalReward MoonClient.MLuaUICom
---@field Btn_GuildNoramlReward MoonClient.MLuaUICom

---@class GuildRewardTemplate : BaseUITemplate
---@field Parameter GuildRewardTemplateParameter

GuildRewardTemplate = class("GuildRewardTemplate", super)
--lua class define end

--lua functions
function GuildRewardTemplate:Init()
	
	    super.Init(self)
	    ---@type ModuleMgr.GuildMgr
	    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
	
end --func end
--next--
function GuildRewardTemplate:BindEvents()
	
	self:BindEvent(self.guildMgr.EventDispatcher, self.guildMgr.ON_GUILD_ORGANIZE_PROGRESS_UPDATE, self.refreshStateInfo, self)
	self:BindEvent(self.guildMgr.EventDispatcher, self.guildMgr.ON_GET_GUILD_ORGANIZATION_PERSONAL_REWARD, self.refreshStateInfo, self)
	
end --func end
--next--
function GuildRewardTemplate:OnDestroy()
	
	self.itemTemplate = nil
	self.guildPropInfo = nil
	self.personalPropInfo = nil
	self.redSignProcessor = nil
	
end --func end
--next--
function GuildRewardTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildRewardTemplate:OnSetData(data)
	
	if data == nil then
		return
	end
	---@type UnityEngine.RectTransform
	local l_rectTrans = self:rectTransform()
	local l_anchoredPos = l_rectTrans.anchoredPosition
	l_anchoredPos.x = data.rewardPosX
	l_rectTrans.anchoredPosition = l_anchoredPos
	---@type GuildManualTable
	self.guildManualItem = data.guildManualItem
	local l_GuildItem = TableUtil.GetItemTable().GetRowByItemID(self.guildManualItem.RewardItemId)
	self.Parameter.Txt_GuildNormalRewardNum.LabText = self.guildManualItem.RewardAmount
	if not MLuaCommonHelper.IsNull(l_GuildItem) then
		self.Parameter.Img_GuildFinishReward:SetSpriteAsync(l_GuildItem.ItemAtlas, l_GuildItem.ItemIcon,nil,true)
		self.Parameter.Img_guildNormalReward:SetSpriteAsync(l_GuildItem.ItemAtlas, l_GuildItem.ItemIcon,nil,true)
		self.guildPropInfo = Data.BagModel:CreateItemWithTid(self.guildManualItem.RewardItemId)
		self.Parameter.Btn_GuildNoramlReward:AddClick(function()
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(self.guildPropInfo, self.Parameter.Img_guildNormalReward.Transform, nil)
		end,true)
	end
	local l_personalRewardItemID = self.guildManualItem.PersonalReward[0]
	local l_personalRewardNum = self.guildManualItem.PersonalReward[1]
	self.Parameter.Txt_PersonalNormalRewardNum.LabText = l_personalRewardNum
	local l_personalItem = TableUtil.GetItemTable().GetRowByItemID(l_personalRewardItemID)
	if not MLuaCommonHelper.IsNull(l_personalItem) then
		self.Parameter.Img_PersonalFinishReward:SetSpriteAsync(l_personalItem.ItemAtlas, l_personalItem.ItemIcon,nil,true)
		self.Parameter.Img_PersonalNormalReward:SetSpriteAsync(l_personalItem.ItemAtlas, l_personalItem.ItemIcon,nil,true)
		self.personalPropInfo = Data.BagModel:CreateItemWithTid(l_personalRewardItemID)
		self.Parameter.Btn_PersonalReward:AddClick(function()
			local l_hasGetPersonalReward = self.guildMgr.HasGetOrganizePersonalReward(self.guildManualItem.ManualScore)
			if not l_hasGetPersonalReward then
				local l_currentOrganizeContribution = self.guildMgr.GetCurrentOrganizeProgressValue()
				local l_isFinish = l_currentOrganizeContribution >= self.guildManualItem.ManualScore
				if l_isFinish then
					self.guildMgr.ReqGetGuildOrganizationPersonalAward(self.guildManualItem.ManualScore)
					return
				end
			end
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(self.personalPropInfo, self.Parameter.Img_PersonalNormalReward.Transform, nil)
		end,true)
	end
	self.Parameter.Txt_Progress.LabText = self.guildManualItem.ManualScore
	self:refreshStateInfo()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildRewardTemplate:refreshStateInfo()
    if MLuaCommonHelper.IsNull(self.guildManualItem) then
        return
    end
    local l_currentOrganizeContribution = self.guildMgr.GetCurrentOrganizeProgressValue()
    local l_isFinish = l_currentOrganizeContribution >= self.guildManualItem.ManualScore
	local l_hasGetPersonalReward = self.guildMgr.HasGetOrganizePersonalReward(self.guildManualItem.ManualScore)
    self.Parameter.Img_Finish:SetActiveEx(l_isFinish and l_hasGetPersonalReward)
    self.Parameter.Img_NoFinish:SetActiveEx(not l_isFinish)
    self.Parameter.Img_InProgress:SetActiveEx(l_isFinish and not l_hasGetPersonalReward)
	self.Parameter.Img_GuildFinishReward:SetActiveEx(l_isFinish)
	self.Parameter.Img_PersonalFinishReward:SetActiveEx(l_isFinish and l_hasGetPersonalReward)
	self.Parameter.Img_RedHint:SetActiveEx(l_isFinish and not l_hasGetPersonalReward)
end
--lua custom scripts end
return GuildRewardTemplate