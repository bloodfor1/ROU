--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ReBackTipsPanel"
require "UI/Template/ItemTemplate"
require "UI/Template/ReturnGift"
require "UI/Template/ReturnGuildItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ReBackTipsCtrl : UIBaseCtrl
ReBackTipsCtrl = class("ReBackTipsCtrl", super)
--lua class define end

--lua functions
function ReBackTipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.ReBackTips, UILayer.Function, nil, ActiveType.Exclusive)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	self.overrideSortLayer = UILayerSort.Function + 15
	
end --func end
--next--
function ReBackTipsCtrl:Init()
	
	self.panel = UI.ReBackTipsPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.panel.BtnMeetingGift:AddClickWithLuaSelf(self.OnBtnMeetGift,self)
	self.panel.BtnGift:AddClickWithLuaSelf(self.OnBtnGift,self)
	self.panel.BtnGuild:AddClickWithLuaSelf(self.OnBtnGuild,self)
	self.panel.BtnWelcomeBack:AddClickWithLuaSelf(self.OnBtnWelcomeBack,self)

	self.meetGiftTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		ScrollRect = self.panel.MeetGiftScroll.LoopScroll
	})

	self.giftBoxTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ReturnGift,
		ScrollRect = self.panel.GiftBoxScroll.LoopScroll,
		TemplatePrefab = self.panel.ReturnGift.gameObject,
	})

	self.guildRecommendTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ReturnGuildItem,
		ScrollRect = self.panel.GuildScroll.LoopScroll,
		TemplatePrefab = self.panel.ReturnGuildItem.gameObject,
	})
	
end --func end
--next--
function ReBackTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ReBackTipsCtrl:OnActive()

	self.chooseFriendUIDList = {}
	self.chooseGuildUIDList = {}

	local statue = self.mgr.GetStatue()
	if not statue then
		UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
		return
	end

	self:RefreshUI()

end --func end
--next--
function ReBackTipsCtrl:OnDeActive()

	
end --func end
--next--
function ReBackTipsCtrl:Update()
	
	
end --func end
--next--
function ReBackTipsCtrl:BindEvents()

	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_WELCOME_NEXT_RES,self.OnWelcomeNext,self)
	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_WELCOME_FRIEND_CHOOSE_CHANGE,self.OnFriendChooseChange,self)
	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_WELCOME_GUILD_CHOOSE_CHANGE,self.OnGuildChooseChange,self)
	self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,self.mgr.SIG_GET_MEET_GIFT_PREVIEW_ITEM,self.OnGetMeetGiftPreview)
	self:BindEvent(MgrMgr:GetMgr("RoleTagMgr").EventDispatcher, MgrMgr:GetMgr("RoleTagMgr").RoleTagChangeEvent, self.OnRoleTagChange)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackTipsCtrl:RefreshUI()
	local statue = self.mgr.GetStatue()
	self.panel.MeetingGift:SetActiveEx(false)
	self.panel.GuildRecommendation:SetActiveEx(false)
	self.panel.WelcomeBack:SetActiveEx(false)
	self.panel.GiftBox:SetActiveEx(false)

	if statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_prize then
		self:ShowMeetingGift()
	elseif statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_join_guild then
		self:ShowGuildRecommendation()
	elseif statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_end then
		self:ShowWelcomeBack()
		--elseif statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_friend_prize then
		--self:ShowGiftBox()
	elseif statue ~= 0 then
		UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
	else			-- 当出现意外情况(服务器和客户端版本不一致时)，服务器下发状态为0时，会导致卡死。但是断线重连时会重新下发数据，状态也为0。这里通过节点是否全是active判断是否卡死，如果卡死就关掉界面
		if not self.panel.MeetingGift.gameObject.activeSelf and
		not self.panel.GuildRecommendation.gameObject.activeSelf and
		not self.panel.WelcomeBack.gameObject.activeSelf and
		not self.panel.GiftBox.gameObject.activeSelf then
			UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
		end
	end
end

function ReBackTipsCtrl:ShowMeetingGift()
	self.panel.MeetingGift:SetActiveEx(true)
	local meetGiftPackageID = self.mgr.GetMeetGiftPackageID()
	MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(meetGiftPackageID, self.mgr.SIG_GET_MEET_GIFT_PREVIEW_ITEM)
end

function ReBackTipsCtrl:OnGetMeetGiftPreview(awardList)
	if awardList == nil then
		return
	end
	local dataTable = {}
	for _,v in ipairs(awardList.award_list) do
		local tempItem = {
			ID = v.item_id,
			IsShowCount = true,
			Count = v.count
		}
		table.insert(dataTable,tempItem)
	end
	self.meetGiftTemplatePool:ShowTemplates({ Datas = dataTable})
end

function ReBackTipsCtrl:ShowGiftBox()

	local data = self.mgr.GetReturnFriends()
	if #data == 0 then		-- 没有好友直接跳过
		self.mgr.ReqPrizeWelcomeNext()
	else
		self.panel.GiftBox:SetActiveEx(true)
		self.giftBoxTemplatePool:ShowTemplates({Datas = data})
	end
end

function ReBackTipsCtrl:ShowGuildRecommendation()
	local data = self.mgr.GetReturnGuild()
	if #data == 0 or MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then		-- 没有公会直接跳过
		self.mgr.ReqPrizeWelcomeNext()
	else
		for k,v in ipairs(data) do
			self.chooseGuildUIDList[v.guildId] = true
		end
		self.panel.GuildRecommendation:SetActiveEx(true)
		self.guildRecommendTemplatePool:ShowTemplates({Datas = data})
	end
end

function ReBackTipsCtrl:ShowWelcomeBack()
	self.panel.WelcomeBack:SetActiveEx(true)
end

function ReBackTipsCtrl:OnBtnMeetGift()
	self.mgr.ReqPrizeWelcomeNext()
end

function ReBackTipsCtrl:OnWelcomeNext()
	self:RefreshUI()
end

function ReBackTipsCtrl:OnFriendChooseChange(UID,value)
	if value then
		self.chooseFriendUIDList[UID] = true
	else
		self.chooseFriendUIDList[UID] = nil
	end
end

function ReBackTipsCtrl:OnBtnGift()
	local result = {}
	for k,v in pairs(self.chooseGuildUIDList) do
		if v then
			table.insert(result,k)
		end
	end
	self.mgr.ReqPrizeWelcomeNext(result)
end

function ReBackTipsCtrl:OnGuildChooseChange(UID,value)
	if value then
		self.chooseGuildUIDList[UID] = true
	else
		self.chooseGuildUIDList[UID] = nil
	end
end

function ReBackTipsCtrl:OnBtnGuild()
	for k,v in pairs(self.chooseGuildUIDList) do
		if v then
			MgrMgr:GetMgr("GuildMgr").ReqApply(tonumber(k))
		end
	end
	self.mgr.ReqPrizeWelcomeNext()
end

function ReBackTipsCtrl:OnBtnWelcomeBack()
	self.mgr.ReqPrizeWelcomeNext()
	UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
	UIMgr:ActiveUI(UI.CtrlNames.ReBack)
end

function ReBackTipsCtrl:OnRoleTagChange()
	if MPlayerInfo.ShownTagId ~= ROLE_TAG.RoleTagRegress then
		UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
	end
end

--lua custom scripts end
return ReBackTipsCtrl