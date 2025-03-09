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
---@class MagicLetterRewardGeterTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtPlayerName MoonClient.MLuaUICom
---@field Txt_RedEnvelopeType MoonClient.MLuaUICom
---@field Txt_GetReward MoonClient.MLuaUICom
---@field Obj_Head MoonClient.MLuaUICom
---@field Img_SelfBg MoonClient.MLuaUICom

---@class MagicLetterRewardGeterTemplate : BaseUITemplate
---@field Parameter MagicLetterRewardGeterTemplateParameter

MagicLetterRewardGeterTemplate = class("MagicLetterRewardGeterTemplate", super)
--lua class define end

--lua functions
function MagicLetterRewardGeterTemplate:Init()
	
	super.Init(self)
	self.roleUid = 0
	self.playerInfo = nil
	self.playerHead = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.Parameter.Obj_Head.Transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})
	
end --func end
--next--
function MagicLetterRewardGeterTemplate:BindEvents()
	
	    ---@type ModuleMgr.PlayerInfoMgr
	    local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
	    self:BindEvent(l_playerInfoMgr.EventDispatcher, l_playerInfoMgr.GET_GROUP_PLAYERINFO_FROM_SERVER, function()
	        self:refreshHeadInfo(self.roleUid)
	    end)
	
end --func end
--next--
function MagicLetterRewardGeterTemplate:OnDestroy()
	
	self.playerInfo=nil
	if not MLuaCommonHelper.IsNull(self.headObj) then
		MResLoader:DestroyObj(self.headObj)
		self.headObj = nil
	end
	
end --func end
--next--
function MagicLetterRewardGeterTemplate:OnDeActive()
	
	
end --func end
--next--
function MagicLetterRewardGeterTemplate:OnSetData(data)
	
	    if data == nil then
	        return
	    end
	    self.roleUid = data.role_uid
	    local l_rewardInfo = data.envelop.items[1]
	    if l_rewardInfo == nil then
	        return
	    end
		local l_isSelf = self.roleUid==MPlayerInfo.UID
		self.Parameter.Img_SelfBg:SetActiveEx(l_isSelf)
	    local l_redEnvelopeTypeStr
	    if data.envelop.display_type == EnvelopeType.EnvelopeTypeSuperGift then
	        l_redEnvelopeTypeStr= Lang("GRAB_SUPER_RED_ENVELOPE")
	    elseif data.envelop.display_type == EnvelopeType.EnvelopeTypeFirstOne then
	        l_redEnvelopeTypeStr= Lang("FIRST_GRAB_RED_ENVELOPE")
	    elseif data.envelop.display_type == EnvelopeType.EnvelopeTypeBigEvenlope then
	        l_redEnvelopeTypeStr= Lang("GRAB_SUPER_MONEY_RED_ENVELOPE")
	    elseif data.envelop.display_type == EnvelopeType.EnvelopeTypeFirstItem then
	        l_redEnvelopeTypeStr= Lang("FIRST_GRAB_PROP_RED_ENVELOPE")
	    else
	        l_redEnvelopeTypeStr= ""
	    end
	    self.Parameter.Txt_RedEnvelopeType.LabText = l_redEnvelopeTypeStr
	    local l_rewardItem = TableUtil.GetItemTable().GetRowByItemID(l_rewardInfo.item_id)
	    if MLuaCommonHelper.IsNull(l_rewardItem) then
	        logError("ItemTable not exist Id:" .. tostring(l_rewardInfo.item_id))
	        return
	    end
	    local l_rewardPropText = GetImageText(l_rewardItem.ItemIcon, l_rewardItem.ItemAtlas, 20, 26, false)
	    local l_rewardStr
	    if MgrMgr:GetMgr("PropMgr").IsCoin(l_rewardInfo.item_id) then
	        l_rewardStr = StringEx.Format("{0}{1}", l_rewardPropText,MNumberFormat.GetNumberFormat(tostring(l_rewardInfo.item_count)) )
	    else
	        l_rewardStr = StringEx.Format("{0} {1}", l_rewardPropText, l_rewardInfo.item_count)
	    end
	    self.Parameter.Txt_GetReward.LabText = l_rewardStr
	    self:refreshHeadInfo(self.roleUid)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MagicLetterRewardGeterTemplate:refreshHeadInfo(uid, playerInfo)
    if playerInfo == nil then
        playerInfo = MgrMgr:GetMgr("PlayerInfoMgr").GetCachePlayerInfo(uid)
        if playerInfo == nil then
            return
        end
    end
	self.playerInfo = playerInfo
	self.Parameter.TxtPlayerName.LabText = self.playerInfo.name
	local l_isSelf = uid == MPlayerInfo.UID
	---@type HeadTemplateParam
	local l_param = nil
	if l_isSelf then
		---@type HeadTemplateParam
		l_param = {
			IsPlayerSelf = true,
			ShowProfession = true,
			ShowLv = true,
		}
	else
		l_param = {
			EquipData = playerInfo.GetEquipData(playerInfo),
			ShowProfession = true,
			Profession = playerInfo.type,
			ShowLv = true,
			Level = playerInfo.level,
			OnClick = self.onHeadClick,
			OnClickSelf = self,
		}
	end
	self.playerHead:SetData(l_param)
end
function MagicLetterRewardGeterTemplate:onHeadClick()
	if self.playerInfo==nil then
		return
	end
	MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid,self.playerInfo)
end
--lua custom scripts end
return MagicLetterRewardGeterTemplate