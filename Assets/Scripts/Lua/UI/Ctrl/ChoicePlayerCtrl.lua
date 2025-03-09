--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChoicePlayerPanel"
require "UI/Template/FriendChooseTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ChoicePlayerCtrl = class("ChoicePlayerCtrl", super)
--lua class define end

--lua functions
function ChoicePlayerCtrl:ctor()
	
	super.ctor(self, CtrlNames.ChoicePlayer, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function ChoicePlayerCtrl:Init()
	---@type ChoicePlayerPanel
	self.panel = UI.ChoicePlayerPanel.Bind(self)
	super.Init(self)
	self.mask = self:NewPanelMask(BlockColor.Dark, nil)
	---@type ModuleMgr.FriendMgr
	self.friendMgr = MgrMgr:GetMgr("FriendMgr")
	---@type MagicLetterMgr
	self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	self.panel.Btn_Cancel:AddClick(function()
		self:Close()
	end)
	self.panel.Bg:AddClick(function()
		self:Close()
	end)
	self.panel.Btn_Determine:AddClick(function()
		self.magicLetterMgr.SetReceiveLetterFriendInfo(self.playerInlinePool:GetCurrentSelectTemplateData(),nil,false)
		self:Close()
	end,true)
	self.playerInlinePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.FriendChooseTemplate,
		ScrollRect = self.panel.Loop_Players.LoopScroll,
		TemplatePrefab = self.panel.Template_playerInfo.gameObject,
	})
end --func end
--next--
function ChoicePlayerCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ChoicePlayerCtrl:OnActive()
	self.friendMgr.RequestGetFriendInfo()
end --func end
--next--
function ChoicePlayerCtrl:OnDeActive()
	self.magicLetterMgr.SetReceiveLetterFriendInfo(nil,-1,true)
	
end --func end
--next--
function ChoicePlayerCtrl:Update()
	
	
end --func end
--next--
function ChoicePlayerCtrl:BindEvents()
	self:BindEvent(self.friendMgr.EventDispatcher,self.friendMgr.ResetFriendInfoEvent,self.refreshPanel)
	self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.OnCurrentReceiveLetterFriendChanged,function (_,isTemp,index)
		if isTemp then
			self:setSelectFriendIndex(index)
		end
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function ChoicePlayerCtrl:setSelectFriendIndex(index)
	if self.playerInlinePool==nil then
		return
	end
	self.playerInlinePool:CancelSelectTemplate()
	if index>=0 then
		self.playerInlinePool:SelectTemplate(index)
	end
end
function ChoicePlayerCtrl:refreshPanel()
	local l_friendInfos = self.friendMgr.GetFriendInfos()
	local l_sendGiftFriendInfo={}
	local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
	local l_letterOpenLevel = l_openSysMgr.GetSystemOpenBaseLv(l_openSysMgr.eSystemId.MagicLetter)
	--好友模块已排好序，此处仅抽出其中的在线好友数据
	for i = 1, #l_friendInfos do
		---@type FriendInfo
		local l_friendInfo = l_friendInfos[i]
		if l_friendInfo.base_info~=nil then
			if l_friendInfo.friend_type == FriendType.TYPE_FRIEND
				and l_friendInfo.base_info.status == MemberStatus.MEMBER_NORMAL
				and l_letterOpenLevel <= l_friendInfo.base_info.base_level then
				table.insert(l_sendGiftFriendInfo,l_friendInfo)
			end
		end
	end
	if #l_sendGiftFriendInfo<1 then
		self.panel.Panel_NonePlayer:SetActiveEx(true)
		return
	end
	self.panel.Panel_NonePlayer:SetActiveEx(false)

	self.playerInlinePool:ShowTemplates({
		Datas = l_sendGiftFriendInfo,
		StartScrollIndex=self.playerInlinePool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})
end
--lua custom scripts end
return ChoicePlayerCtrl