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
---@class ChatLineMagicLetterOtherParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_PlayerName MoonClient.MLuaUICom
---@field Txt_Permission MoonClient.MLuaUICom
---@field Txt_CurrentTime MoonClient.MLuaUICom
---@field Txt_Channel MoonClient.MLuaUICom
---@field Txt_Blessing MoonClient.MLuaUICom
---@field Obj_Head MoonClient.MLuaUICom
---@field Img_UnOpenLetter MoonClient.MLuaUICom
---@field Img_OpenedLetter MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field backgroud MoonClient.MLuaUICom

---@class ChatLineMagicLetterOther : BaseUITemplate
---@field Parameter ChatLineMagicLetterOtherParameter

ChatLineMagicLetterOther = class("ChatLineMagicLetterOther", super)
--lua class define end

--lua functions
function ChatLineMagicLetterOther:Init()

    super.Init(self)
    ---@type MagicLetterMgr
    self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
    ---@type ModuleMgr.ChatMgr
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self._otherHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Obj_Head.Transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end--func end
--next--
function ChatLineMagicLetterOther:BindEvents()
	
	    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnMagicLetterDetailInfoChanged, self.refreshLetterInfo)
	    self:BindEvent(self.magicLetterMgr.EventDispatcher, self.magicLetterMgr.EMagicEvent.OnGetMagicLetterInfo, self.refreshLetterInfo)
	
end --func end
--next--
function ChatLineMagicLetterOther:OnDestroy()
	
    self.chatMgr.DestroyHeadObj(self.Parameter.Obj_Head.Transform)
    self.playerInfo = nil
end --func end
--next--
function ChatLineMagicLetterOther:OnDeActive()
	
	    -- do nothing
	
end --func end
--next--
function ChatLineMagicLetterOther:OnSetData(data)

    if data == nil then
        return
    end
    ---@type ChatMsgPack
    self.msgPack = data
    self.playerInfo = data.playerInfo
    ---@type HeadTemplateParam
    local param = {
        EquipData = self.playerInfo:GetEquipData(),
        ShowProfession = true,
        Profession = self.playerInfo.type,
        ShowLv = true,
        Level = self.playerInfo.level,
        OnClick = self.onPlayerHeadClick,
        OnClickSelf = self,
    }
    self._otherHead:SetData(param)

    self.chatMgr.SetOtherChatMsg(self.msgPack, self.Parameter.Btn_Icon, self.MethodCallback,
             self.Parameter.Txt_PlayerName, self.Parameter.Txt_Permission, self.Parameter.BiaoQian)
    ---@type LinkInputMgr
    local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
    local l_letterParam = l_linkInputMgr.GetMagicLetterInfoByExtraParam(self.msgPack.Param)
    if l_letterParam ~= nil then
        local l_wiseContent = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(self.msgPack.content)
        self.Parameter.Txt_Blessing.LabText = StringEx.Format("@{0} {1}", l_letterParam.receiveRoleName, l_wiseContent)
        local l_hasGrabRedEnvelope = self.magicLetterMgr.HasGradMagicLetterRedEnvelope(l_letterParam.letterUid)
        self.Parameter.Img_OpenedLetter:SetActiveEx(l_hasGrabRedEnvelope)
        self.Parameter.Img_UnOpenLetter:SetActiveEx(not l_hasGrabRedEnvelope)
        if l_hasGrabRedEnvelope then
            self.Parameter.Img_OpenedLetter:AddClick(function()
                self.magicLetterMgr.CheckMagicLetter(l_letterParam.letterUid)
            end, true)
        else
            self.Parameter.Img_UnOpenLetter:AddClick(function()
                ---@type letterInfo
                local l_letterInfo = self.magicLetterMgr.GetLetterInfoByUid(l_letterParam.letterUid)
                --聊天传递的魔法信笺信息如果不存在，需要创建一个
                if l_letterInfo == nil then
                    self.magicLetterMgr.CreateSimpleLetterInfo(l_letterParam.letterUid, self.msgPack.name)
                end
                self.magicLetterMgr.CheckMagicLetter(l_letterParam.letterUid)
            end, true)
        end
    end

end--func end
--next--
--lua functions end

--lua custom scripts
function ChatLineMagicLetterOther:refreshLetterInfo()
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
    end
end
function ChatLineMagicLetterOther:onPlayerHeadClick()
    if self.playerInfo==nil then
        return
    end
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
end
---@param data ChatMsgPack
function ChatLineMagicLetterOther:_setCustom(data)
    if nil == data or nil == data.playerInfo then
        logError("[ChatChannel] invalid param")
        return
    end

    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetData = dialogBgMgr.GetDataByID(data.playerInfo.ChatBubbleID)
    if nil == targetData then
        logError("[ChatChannel] invalid id: " .. tostring(data.playerInfo.ChatBubbleID))
        return
    end

    self.Parameter.backgroud:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.Parameter.Txt_Blessing.LabColor = targetColor

    --- 设置聊天标签
    local tagID = data.playerInfo.ChatTagID
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
return ChatLineMagicLetterOther