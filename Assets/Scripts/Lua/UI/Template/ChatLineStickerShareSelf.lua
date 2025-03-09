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
---@class ChatLineStickerShareSelfParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_tag_lv MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom
---@field Sticker MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field img_tag_bg MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom

---@class ChatLineStickerShareSelf : BaseUITemplate
---@field Parameter ChatLineStickerShareSelfParameter

ChatLineStickerShareSelf = class("ChatLineStickerShareSelf", super)
--lua class define end

--lua functions
function ChatLineStickerShareSelf:Init()

    super.Init(self)
    ---@type ModuleMgr.ChatMgr
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self._playerHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Head.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function ChatLineStickerShareSelf:BindEvents()

    -- do nothing

end --func end
--next--
function ChatLineStickerShareSelf:OnDestroy()

    self.chatMgr.DestroyHeadObj(self.Parameter.Head.Transform)

end --func end
--next--
function ChatLineStickerShareSelf:OnDeActive()

    -- do nothing

end --func end
--next--
function ChatLineStickerShareSelf:OnSetData(data)

    self:_setCustom()
    self.msgPack = data
    self:_setPlayerHead(data)
    self:_setPlayerInfo(data, self.Parameter.PlayerName, self.Parameter.Permission, self.Parameter.BiaoQian)
    -- 贴纸
    self.stickersTemplate = self:NewTemplate("StickerWallTemplent", {
        TemplateParent = self.Parameter.Sticker.transform,
    })
    LayoutRebuilder.ForceRebuildLayoutImmediate(self:transform())
    local l_gridInfos = MgrMgr:GetMgr("TitleStickerMgr").ParseStickersPB(self.msgPack.stickers)
    self.stickersTemplate:SetData({ bgType = "white", gridInfos = l_gridInfos, isShowTip = true })

end --func end
--next--
--lua functions end

--lua custom scripts
---@param msgPack ChatMsgPack
function ChatLineStickerShareSelf:_setPlayerHead(msgPack)
    if nil == msgPack then
        return
    end

    ---@type HeadTemplateParam
    param = {
        ShowLv = true,
        ShowProfession = true,
        IsPlayerSelf = true
    }

    self._playerHead:SetData(param)
end

---@param msgPack ChatMsgPack
---@param nameCom MoonClient.MLuaUICom @名字组件
---@param permissionCom MoonClient.MLuaUICom @权限组件
---@param tagCom MoonClient.MLuaUICom @标签组件
function ChatLineStickerShareSelf:_setPlayerInfo(msgPack, nameCom, permissionCom, tagCom)
    if msgPack == nil then
        return
    end

    --玩家名
    if not MLuaCommonHelper.IsNull(nameCom) then
        nameCom.LabText = MPlayerInfo.Name
    end

    --公会职称
    if not MLuaCommonHelper.IsNull(permissionCom) then
        local l_guildData = DataMgr:GetData("GuildData")
        permissionCom:SetActiveEx(false)
        if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() and l_guildData.GetSelfGuildPosition() <= l_guildData.EPositionType.Deacon then
            local l_showPermission = msgPack.channel == self.chatMgr.EChannel.GuildChat
            permissionCom:SetActiveEx(l_showPermission)
            local l_Permission = l_guildData.GetPositionName(l_guildData.GetSelfGuildPosition()) or ""
            l_Permission = StringEx.Format("[{0}]", l_Permission)
            permissionCom.LabText = l_Permission
        end
    end

    -- 标签处理
    if not MLuaCommonHelper.IsNull(tagCom) then
        MgrMgr:GetMgr("RoleTagMgr").SetTag(tagCom, DataMgr:GetData("RoleTagData").GetActiveTagId())
    end

    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(msgPack)
end

function ChatLineStickerShareSelf:_setCustom()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentID = mgr.GetBubbleID()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local data = dialogBgMgr.GetDataByID(currentID)
    self.Parameter.Background:SetSpriteAsync(data.config.Atlas, data.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(data.config.Color)
    self.Parameter.TextMessage.LabColor = targetColor

    --- 设置聊天标签
    local tagID = mgr.GetChatTagID()
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
            self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end

--lua custom scripts end
return ChatLineStickerShareSelf