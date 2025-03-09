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
---@class MagicLetterTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_SendPlayerName MoonClient.MLuaUICom
---@field Txt_ReceivePlayerName MoonClient.MLuaUICom
---@field Panel_LetterInfo MoonClient.MLuaUICom
---@field Img_SendGift MoonClient.MLuaUICom
---@field Img_NoneBG MoonClient.MLuaUICom
---@field Img_AllAlocated MoonClient.MLuaUICom
---@field Effect_LiHe MoonClient.MLuaUICom
---@field CanvasGroup_WishInfo MoonClient.MLuaUICom
---@field But_LetterBg MoonClient.MLuaUICom

---@class MagicLetterTemplate : BaseUITemplate
---@field Parameter MagicLetterTemplateParameter

MagicLetterTemplate = class("MagicLetterTemplate", super)
--lua class define end

--lua functions
function MagicLetterTemplate:Init()
	
	super.Init(self)
	self.magicLetterMgr=MgrMgr:GetMgr("MagicLetterMgr")
	
end --func end
--next--
function MagicLetterTemplate:BindEvents()
	
	
end --func end
--next--
function MagicLetterTemplate:OnDestroy()
	
	
end --func end
--next--
function MagicLetterTemplate:OnDeActive()
	
	
end --func end
--next--
function MagicLetterTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	---@type showLetterInfo
	local l_showLetterInfo = data
	self.Parameter.Img_NoneBG:SetActiveEx(l_showLetterInfo.isEmptyData)
	if l_showLetterInfo.isLoadingData then
		self.Parameter.Panel_LetterInfo:SetActiveEx(false)
		if l_showLetterInfo.isLastLoadingData then
			self.magicLetterMgr.ReqAllMagicLetters()
		end
		return
	end
	---@type letterInfo
	local l_letterInfo = self.magicLetterMgr.GetLetterInfoByUid(l_showLetterInfo.letterUid)
	if l_letterInfo==nil then
		return
	end
	self.Parameter.Panel_LetterInfo:SetActiveEx(true)
	self.Parameter.But_LetterBg:AddClick(function()
		self.magicLetterMgr.CheckMagicLetter(l_letterInfo.letterUid)
	end,true)
	self.Parameter.Txt_SendPlayerName.LabText = l_letterInfo.sendPlayerName
	self.Parameter.Txt_ReceivePlayerName.LabText = l_letterInfo.receivePlayerName
	self.Parameter.Img_AllAlocated:SetActiveEx(l_letterInfo.isAllAllocated)
	local l_wiseInfoAlpha = 1
	if l_letterInfo.isAllAllocated then
		l_wiseInfoAlpha = 0.5
	end
	self.Parameter.CanvasGroup_WishInfo.CanvasGroup.alpha = l_wiseInfoAlpha
	if not l_letterInfo.isAllAllocated and (not l_letterInfo.isReceived) then
		self.Parameter.Effect_LiHe:PlayDynamicEffect()
	else
		self.Parameter.Effect_LiHe:StopDynamicEffect()
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MagicLetterTemplate