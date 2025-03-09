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
---@class FriendChatMagicLetterTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field SystemChatText MoonClient.MLuaUICom
---@field SystemChat MoonClient.MLuaUICom
---@field PlayerWarningTag MoonClient.MLuaUICom
---@field PlayerLeftRect MoonClient.MLuaUICom
---@field PlayerChatText MoonClient.MLuaUICom
---@field PlayerChatHead MoonClient.MLuaUICom
---@field PlayerChat MoonClient.MLuaUICom
---@field OtherChatText MoonClient.MLuaUICom
---@field OtherChatHead MoonClient.MLuaUICom
---@field OtherChat MoonClient.MLuaUICom
---@field Img_UnOpenGiftSelf MoonClient.MLuaUICom
---@field Img_UnOpenGiftOther MoonClient.MLuaUICom
---@field img_tag_other_other MoonClient.MLuaUICom
---@field img_tag_lv_self MoonClient.MLuaUICom
---@field img_tag_bg_self MoonClient.MLuaUICom
---@field img_tag_bg_other MoonClient.MLuaUICom
---@field img_chat_tag_self MoonClient.MLuaUICom
---@field img_chat_tag_other MoonClient.MLuaUICom
---@field img_bg_self MoonClient.MLuaUICom
---@field img_bg_other MoonClient.MLuaUICom

---@class FriendChatMagicLetterTemplate : BaseUITemplate
---@field Parameter FriendChatMagicLetterTemplateParameter

FriendChatMagicLetterTemplate = class("FriendChatMagicLetterTemplate", super)
--lua class define end

--lua functions
function FriendChatMagicLetterTemplate:Init()

    super.Init(self)
    self.currentChatData = nil
    ---@type ModuleMgr.ChatMgr
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    ---@type ModuleMgr.FriendMgr
    self.friendMgr = MgrMgr:GetMgr("FriendMgr")
    self._selfHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.PlayerChatHead.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
    self._otherHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.OtherChatHead.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function FriendChatMagicLetterTemplate:BindEvents()

    -- do nothing

end --func end
--next--
function FriendChatMagicLetterTemplate:OnDestroy()

    -- do nothing

end --func end
--next--
function FriendChatMagicLetterTemplate:OnDeActive()

end --func end
--next--
function FriendChatMagicLetterTemplate:OnSetData(data)

    self:showChat(data)

end --func end
--next--
--lua functions end

--lua custom scripts
function FriendChatMagicLetterTemplate:showChat(data)
    self.Parameter.Time:SetActiveEx(false)
    self.Parameter.OtherChat:SetActiveEx(false)
    self.Parameter.PlayerChat:SetActiveEx(false)
    self.Parameter.SystemChat:SetActiveEx(false)
    self.Parameter.OtherChatText.LabRayCastTarget = true
    self.Parameter.OtherChatText:GetRichText().onHrefClick:Release()
    self.Parameter.PlayerChatText.LabRayCastTarget = true
    self.Parameter.PlayerChatText:GetRichText().onHrefClick:Release()
    self.Parameter.Img_UnOpenGiftSelf:SetActiveEx(false)
    self.Parameter.Img_UnOpenGiftOther:SetActiveEx(false)

    ---@type MoonClient.ChatDataMgr.ChatData
    self.currentChatData = data
    if self.ShowIndex == 1 then
        self:showChatTime(self.currentChatData.chatTime)
    end

    local lastChat = nil
    if self.ShowIndex - 1 >= 1 then
        lastChat = self.friendMgr.CurrentFriendChatDatas[self.ShowIndex - 1]
    end
    if lastChat ~= nil then
        if self.currentChatData.chatTime - lastChat.chatTime > self.friendMgr.FriendChatIntervalTime then
            self:showChatTime(self.currentChatData.chatTime)
        end
    end

    local l_content = data.content
    --动态表情替换
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    ---@type LinkInputMgr
    local l_linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
    local l_magicLetterInfo = self:getFriendMagicLetterInfoByExtraParam(l_linkInputMgr.StringToPack(self.currentChatData.extra_param))
    if l_magicLetterInfo ~= nil then
        local l_isMeReceiveLetter = self.currentChatData.whoChat == 2
        if l_isMeReceiveLetter then
            self.Parameter.Img_UnOpenGiftOther:SetActiveEx(true)
            self.Parameter.Img_UnOpenGiftOther:AddClick(function()
                local l_friendData = self.friendMgr.CurrentFriendData
                if l_friendData == nil then
                    logError("没有好友数据")
                    return
                end
                UIMgr:ActiveUI(UI.CtrlNames.MagicLetter, {
                    isSendLetter = false,
                    receiveLetterInfo = {
                        letterUId = l_magicLetterInfo.letterUId,
                        fragranceId = l_magicLetterInfo.fragranceId,
                        blessing = l_content,
                        receivePlayerName = l_friendData.base_info.name,
                        receivePlayerUId = self.currentChatData.chatUid,
                    }
                })
            end, true)
        else
            self.Parameter.Img_UnOpenGiftSelf:SetActiveEx(true)
        end
    end

    if self.currentChatData.whoChat == 1 or self.currentChatData.whoChat == 3 or self.currentChatData.whoChat == 4 then
        self.Parameter.PlayerChat.gameObject:SetActiveEx(true)
        self.Parameter.PlayerChatText.LabText = l_content
        self.Parameter.PlayerChatText:GetRichText().onHrefClick:AddListener(function(key)
            MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key, {
                fixationPosX = -215,
                fixationPosY = 0,
            }, self.currentChatData)
        end)

        --发送失败提示
        local l_isSendFaild = self.currentChatData.whoChat == 3
        self.Parameter.PlayerWarningTag:SetActiveEx(l_isSendFaild)
        self.Parameter.PlayerLeftRect.gameObject:SetRectTransformWidth(l_isSendFaild and 345.2 or 359.6)
        self:_setSelfCustomData()
    elseif self.currentChatData.whoChat == 2 then
        local l_friendData = self.friendMgr.CurrentFriendData
        if l_friendData == nil then
            logError("没有好友数据")
            return
        end

        self.Parameter.OtherChat.gameObject:SetActiveEx(true)
        self.Parameter.OtherChatText.LabText = l_content
        self.Parameter.OtherChatText:GetRichText().onHrefClick:AddListener(function(key)
            MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key, {
                fixationPosX = -215,
                fixationPosY = 0,
            }, self.currentChatData)
        end)

        self:_setOtherCustomData(l_friendData.base_info)
    end
end

function FriendChatMagicLetterTemplate:showChatTime(time)
    self.Parameter.Time.gameObject:SetActiveEx(true)
    self.Parameter.Time.LabText = Common.TimeMgr.GetChatTimeFormatStr(time)
end

function FriendChatMagicLetterTemplate:getFriendMagicLetterInfoByExtraParam(extraParam)
    for i = 1, #extraParam do
        local l_magicParam = extraParam[i]
        if l_magicParam.type == self.chatMgr.ChatHrefType.FriendMagicLetter then
            local l_letterInfo = {
                letterUId = l_magicParam.param64[1].value,
                fragranceId = l_magicParam.param32[1].value,
            }
            return l_letterInfo
        end

    end
end

--- 好友界面prefab是左右做在一起的，这个是设置自己的问题
function FriendChatMagicLetterTemplate:_setSelfCustomData()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")

    ---@type HeadTemplateParam
    local param = {
        IsPlayerSelf = true,
        ShowProfession = true,
        ShowLv = true,
    }

    self._selfHead:SetData(param)
    local currentDialogBgId = mgr.GetBubbleID()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetData = dialogBgMgr.GetDataByID(currentDialogBgId)
    if nil == targetData then
        logError("[FriendPrefab] invalid id: " .. tostring(currentDialogBgId))
        return
    end

    self.Parameter.img_bg_self:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.Parameter.PlayerChatText.LabColor = targetColor
    local currentTagID = mgr.GetChatTagID()
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(currentTagID,self.Parameter.img_chat_tag_self,
            self.Parameter.img_tag_bg_self, self.Parameter.img_tag_lv_self)
end

function FriendChatMagicLetterTemplate:_onOtherHeadSelected()
    Common.CommonUIFunc.RefreshPlayerMenuLByUid(self.currentChatData.chatUid)
end

--- 设置其他玩家的个性化数据
---@param data MemberBaseInfo
function FriendChatMagicLetterTemplate:_setOtherCustomData(data)
    if nil == data then
        logError("[FriendPrefab] invalid data")
        return
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data),
        ShowProfession = true,
        Profession = data.type,
        ShowLv = true,
        Level = data.base_level,
        OnClick = self._onOtherHeadSelected,
        OnClickSelf = self,
    }

    self._otherHead:SetData(param)
    local currentDialogBgId = self:_getValidChatBubbleID(data.chat_frame)
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetData = dialogBgMgr.GetDataByID(currentDialogBgId)
    if nil == targetData then
        logError("[FriendPrefab] invalid id: " .. tostring(currentDialogBgId))
        return
    end

    self.Parameter.img_bg_other:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.Parameter.OtherChatText.LabColor = targetColor
    local currentTagID = data.chat_tag
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(currentTagID,self.Parameter.img_chat_tag_other,
            self.Parameter.img_tag_bg_other, self.Parameter.img_tag_other_other)
end

function FriendChatMagicLetterTemplate:_getValidChatBubbleID(bubbleID)
    local default = MgrMgr:GetMgr("DialogBgMgr").GetDefault()
    if nil == bubbleID or 0 >= bubbleID then
        return default
    end

    return bubbleID
end
--lua custom scripts end
return FriendChatMagicLetterTemplate