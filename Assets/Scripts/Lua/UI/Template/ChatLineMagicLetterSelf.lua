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
---@class ChatLineMagicLetterSelfParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_PlayerName MoonClient.MLuaUICom
---@field Txt_Permission MoonClient.MLuaUICom
---@field Txt_CurrentTime MoonClient.MLuaUICom
---@field Txt_Channel MoonClient.MLuaUICom
---@field Txt_Blessing MoonClient.MLuaUICom
---@field Obj_PlayerHead MoonClient.MLuaUICom
---@field Img_UnOpenLetter MoonClient.MLuaUICom
---@field Img_OpenedLetter MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom

---@class ChatLineMagicLetterSelf : BaseUITemplate
---@field Parameter ChatLineMagicLetterSelfParameter

ChatLineMagicLetterSelf = class("ChatLineMagicLetterSelf", super)
--lua class define end

--lua functions
function ChatLineMagicLetterSelf:Init()

    super.Init(self)
    ---@type MagicLetterMgr
    self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
    ---@type ModuleMgr.ChatMgr
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self._selfHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Obj_PlayerHead.Transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end--func end
--next--
function ChatLineMagicLetterSelf:BindEvents()
	
	    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnMagicLetterDetailInfoChanged, self.refreshLetterInfo)
	    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnGetMagicLetterInfo, self.refreshLetterInfo)
	
end --func end
--next--
function ChatLineMagicLetterSelf:OnDestroy()
	
	    self.chatMgr.DestroyHeadObj(self.Parameter.Obj_PlayerHead.Transform)
	
end --func end
--next--
function ChatLineMagicLetterSelf:OnDeActive()
	
	    -- do nothing
	
end --func end
--next--
function ChatLineMagicLetterSelf:OnSetData(data)

    self:_setCustom()
    if data == nil then
        return
    end
    ---@type ChatMsgPack
    self.msgPack = data

    ---@type HeadTemplateParam
    local param = {
        IsPlayerSelf = true,
        ShowProfession = true,
        ShowLv = true,
    }
    self._selfHead:SetData(param)

    self.chatMgr.SetSelfChatMsg(data, self.Parameter.Txt_PlayerName,
            self.Parameter.Txt_Permission, self.Parameter.BiaoQian, self.Parameter.Obj_PlayerHead.Transform)
    self:refreshLetterInfo()

end--func end
--next--
--lua functions end

--lua custom scripts
function ChatLineMagicLetterSelf:refreshLetterInfo()
    if self.msgPack == nil then
        return
    end

    ---@type LinkInputMgr
    local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
    local l_letterParam = l_linkInputMgr.GetMagicLetterInfoByExtraParam(self.msgPack.Param)
    if l_letterParam ~= nil then
        --动态表情替换
        local l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(self.msgPack.content)
        self.Parameter.Txt_Blessing.LabText = StringEx.Format("@{0} {1}", l_letterParam.receiveRoleName, l_content)

        local l_hasGrabRedEnvelope = self.magicLetterMgr.HasGradMagicLetterRedEnvelope(l_letterParam.letterUid)
        self.Parameter.Img_OpenedLetter:SetActiveEx(l_hasGrabRedEnvelope)
        self.Parameter.Img_UnOpenLetter:SetActiveEx(not l_hasGrabRedEnvelope)
        if l_hasGrabRedEnvelope then
            self.Parameter.Img_OpenedLetter:AddClick(function()
                self.magicLetterMgr.CheckMagicLetter(l_letterParam.letterUid)
            end, true)
        else
            self.Parameter.Img_UnOpenLetter:AddClick(function()
                self.magicLetterMgr.CheckMagicLetter(l_letterParam.letterUid)
            end, true)
        end
    end
end

--- 设置个性化气泡框和字体
function ChatLineMagicLetterSelf:_setCustom()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentID = mgr.GetBubbleID()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local data = dialogBgMgr.GetDataByID(currentID)
    local targetColor = CommonUI.Color.Hex2Color(data.config.Color)
    self.Parameter.Txt_Blessing.LabColor = targetColor

    --- 设置聊天标签
    local tagID = mgr.GetChatTagID()
    local chatTagMgr = MgrMgr:GetMgr("ChatTagMgr")
    local chatTagData = chatTagMgr.GetDataByID(tagID)
    if nil == chatTagData then
        logError("[ChatLine] invalid tag id: " .. tostring(tagID))
        return
    end

    local showTag = not string.ro_isEmpty(chatTagData.config.Icon)
    self.Parameter.img_chat_tag.gameObject:SetActive(showTag)
    if not showTag then
        return
    end

    self.Parameter.img_chat_tag:SetSpriteAsync(chatTagData.config.Atlas, chatTagData.config.Icon, nil, false)
end
--lua custom scripts end
return ChatLineMagicLetterSelf