--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicLetterSeePanel"
require "UI/Template/MagicLetterRewardGeterTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
MagicLetterSeeCtrl = class("MagicLetterSeeCtrl", super)
--lua class define end

--lua functions
function MagicLetterSeeCtrl:ctor()
	
	super.ctor(self, CtrlNames.MagicLetterSee, UILayer.Normal, nil, ActiveType.Exclusive)
	
end --func end
--next--
function MagicLetterSeeCtrl:Init()
	---@type MagicLetterSeePanel
	self.panel = UI.MagicLetterSeePanel.Bind(self)
	super.Init(self)

	---@type MagicLetterMgr
	self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	self.letterUid = 0
	self.panel.Btn_Close:AddClick(function()
		self:Close()
	end ,true)

	self.panel.Btn_OpenRedPacket:AddClick(function()
		self.magicLetterMgr.ReqGrabRedEnvelope(self.letterUid)
	end ,true)
	self.senderPlayerInfo = nil
	self.receiverPlayerInfo = nil
	self.senderHead = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.panel.Head_Sender.Transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})
	self.receiverHead = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.panel.Head_Receiver.transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})

	self.letterRewardsAllocatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.MagicLetterRewardGeterTemplate,
		TemplatePrefab = self.panel.Template_MagicLetterRewardGeter.gameObject,
		ScrollRect = self.panel.LoopScroll_GetRewardPlayers.LoopScroll
	})
end --func end
--next--
function MagicLetterSeeCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.senderHead = nil
	self.receiverHead = nil
	self.senderPlayerInfo = nil
	self.receiverPlayerInfo = nil
end --func end
--next--
function MagicLetterSeeCtrl:OnActive()
	if self.uiPanelData==nil then
		logError("MagicLetterSeeCtrl ui data is null!")
		self:Close()
		return
	end
	self.panel.Panel_DetailInfo:SetActiveEx(false)
	self.letterUid = self.uiPanelData.letterUid
	local l_showDetailInfo = self.uiPanelData.showDetail

	if l_showDetailInfo then
		self:showRedPacketDetailInfoPanel(self.letterUid)
	else
		self:showOpenRedPacketPanel()
	end
end --func end
--next--
function MagicLetterSeeCtrl:OnDeActive()
	
	
end --func end
--next--
function MagicLetterSeeCtrl:Update()
	
	
end --func end
--next--
function MagicLetterSeeCtrl:BindEvents()
	self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.OnGetMagicLetterDetailInfo,
			self.refreshLetterRewardInfo)
	self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.OnGetGrabRedEnvelopeResult,
			self.OnGetGrabRedEnvelopeResultInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
function MagicLetterSeeCtrl:OnGetGrabRedEnvelopeResultInfo(isSuc,letterUid)
	if int64.equals(self.letterUid, letterUid) then
		self:showRedPacketDetailInfoPanel(self.letterUid)
	end
end

function MagicLetterSeeCtrl:showOpenRedPacketPanel()
	local l_spine = self.panel.Spawn_Anim.Transform:GetComponent("SkeletonGraphic")
	l_spine.startingLoop = true
	l_spine.AnimationName = "Idle"
	self.panel.Effect_Qiang:SetActiveEx(true)
	self.panel.Effect_HuaBan:SetActiveEx(false)
	self.panel.Btn_OpenRedPacket:SetActiveEx(true)
	self.panel.Panel_DetailInfo:SetActiveEx(false)
end
function MagicLetterSeeCtrl:showRedPacketDetailInfoPanel(letterUid)
	---@type letterInfo
	self.letterInfo = self.magicLetterMgr.GetLetterInfoByUid(letterUid)
	if self.letterInfo == nil then
		logError("MagicLetterSeeCtrl error:letterInfo is null!")
		self:Close()
		return
	end
	self.panel.Effect_Qiang:SetActiveEx(false)
	self.panel.Effect_HuaBan:SetActiveEx(true)
	self.panel.Btn_OpenRedPacket:SetActiveEx(false)
	local l_spine = self.panel.Spawn_Anim.Transform:GetComponent("SkeletonGraphic")
	l_spine.startingLoop = false
	l_spine.AnimationName = "Open"
	self.showDetailInfoTimer = self:NewUITimer(function()
		self.panel.Panel_DetailInfo:SetActiveEx(true)
		self.magicLetterMgr.ReqMagicLetterDetailInfo(letterUid)
		self:refreshPanel()
	end, 0.4,1)
	self.showDetailInfoTimer:Start()
end
function MagicLetterSeeCtrl:closeTimer()
	if self.showDetailInfoTimer then
		self:StopUITimer(self.showDetailInfoTimer)
		self.showDetailInfoTimer = nil
	end
end
function MagicLetterSeeCtrl:refreshPanel()
	local l_wiseContent = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(self.letterInfo.blessing)
	self.panel.Txt_blessing.LabText = l_wiseContent

	self:setPlayerHead(self.letterInfo.receivePlayerUid,self.receiverHead,false)
	self:setPlayerHead(self.letterInfo.sendPlayerUid,self.senderHead,true)

	local l_giftInfos = MGlobalConfig:GetVectorSequence("MagicPaperGiftValue")
	if not MLuaCommonHelper.IsNull(l_giftInfos) and l_giftInfos.Length>1 then
		local l_firstPropItem = TableUtil.GetItemTable().GetRowByItemID(l_giftInfos[0][0])
		local l_secondPropItem = TableUtil.GetItemTable().GetRowByItemID(l_giftInfos[1][0])
		if not MLuaCommonHelper.IsNull(l_firstPropItem) and not MLuaCommonHelper.IsNull(l_secondPropItem) then
			local l_firstRewardPropText = GetImageText(l_firstPropItem.ItemIcon, l_firstPropItem.ItemAtlas, 16, 26, false)
			local l_secondRewardPropText = GetImageText(l_secondPropItem.ItemIcon, l_secondPropItem.ItemAtlas, 16, 26, false)
			self.panel.Txt_giftValue.LabText = Lang("MAGIC_LETTER_GIFT_VALUE",l_firstRewardPropText,MNumberFormat.GetNumberFormat(tostring(l_giftInfos[0][1])),
					l_secondRewardPropText,MNumberFormat.GetNumberFormat(tostring(l_giftInfos[1][1])))
		end
	end
	self:refreshLetterRewardInfo()
end
---@param headWrapTem HeadWrapTemplate
function MagicLetterSeeCtrl:setPlayerHead(playerUid,headWrapTem,isSender)
	local l_isSelf = playerUid == MPlayerInfo.UID
	if l_isSelf then
		---@type HeadTemplateParam
		local l_param = {
			IsPlayerSelf = true,
			ShowProfession = true,
			ShowLv = true,
			ShowName = true,
		}
		headWrapTem:SetData(l_param)
		return
	end

	---@type ModuleMgr.PlayerInfoMgr
	local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
	l_playerInfoMgr.GetPlayerInfoFromServer(playerUid,function(playerInfo)
		if playerInfo==nil then
			return
		end
		local l_onClickEvent = nil
		if isSender then
			self.senderPlayerInfo = playerInfo
			l_onClickEvent = self.onSenderHeadClick
		else
			self.receiverPlayerInfo = playerInfo
			l_onClickEvent = self.onReceiverHeadClick
		end
		---@type HeadTemplateParam
		local l_param = {
			EquipData = playerInfo.GetEquipData(playerInfo),
			ShowProfession = true,
			Profession = playerInfo.type,
			ShowLv = true,
			Level = playerInfo.level,
			OnClick = l_onClickEvent,
			OnClickSelf = self,
			ShowName = true,
			Name = playerInfo.name,
		}
		headWrapTem:SetData(l_param)
	end)
end

function MagicLetterSeeCtrl:onSenderHeadClick()
	if self.senderPlayerInfo==nil then
		return
	end
	MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.senderPlayerInfo.uid,self.senderPlayerInfo)
end
function MagicLetterSeeCtrl:onReceiverHeadClick()
	if self.receiverPlayerInfo==nil then
		return
	end
	MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.receiverPlayerInfo.uid,self.receiverPlayerInfo)
end
function MagicLetterSeeCtrl:getNeedReqPlayerInfo(grapList)
	---@type ModuleMgr.PlayerInfoMgr
	local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
	local l_needReqPlayerInfoList = {}
	for i = 1, #grapList do
		local l_grapInfo = grapList[i]
		local l_cachePlayerInfo = l_playerInfoMgr.GetCachePlayerInfo(l_grapInfo.role_uid)
		if l_cachePlayerInfo==nil then
			table.insert(l_needReqPlayerInfoList,l_grapInfo.role_uid)
		end
	end
	return l_needReqPlayerInfoList
end
function MagicLetterSeeCtrl:refreshLetterRewardInfo()
	if self.letterInfo==nil then
		return
	end
	local l_magicLetterDetailInfo = self.magicLetterMgr.GetMagicLetterDetailInfo(self.letterInfo.letterUid)
	if l_magicLetterDetailInfo==nil then
		return
	end
	if l_magicLetterDetailInfo.hasGrabRedEnvelopeInfos == nil or
			#l_magicLetterDetailInfo.hasGrabRedEnvelopeInfos<1 then
		return
	end
	local l_needReqPlayerInfoList = self:getNeedReqPlayerInfo(l_magicLetterDetailInfo.hasGrabRedEnvelopeInfos)
	if #l_needReqPlayerInfoList>0 then
		---@type ModuleMgr.PlayerInfoMgr
		local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
		l_playerInfoMgr.BatchGetPlayerInfoFromServer(l_needReqPlayerInfoList)
	end
	self.letterRewardsAllocatePool:ShowTemplates({
		Datas = l_magicLetterDetailInfo.hasGrabRedEnvelopeInfos,
		StartScrollIndex=self.letterRewardsAllocatePool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})
end
--lua custom scripts end
return MagicLetterSeeCtrl