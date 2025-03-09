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
---@class ChatLineStickerShareOtherParameter
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
---@field backgroud MoonClient.MLuaUICom

---@class ChatLineStickerShareOther : BaseUITemplate
---@field Parameter ChatLineStickerShareOtherParameter

ChatLineStickerShareOther = class("ChatLineStickerShareOther", super)
--lua class define end

--lua functions
function ChatLineStickerShareOther:Init()

    super.Init(self)
    ---@type ModuleMgr.ChatMgr
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self._playerHead = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Head.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function ChatLineStickerShareOther:BindEvents()

    -- do nothing

end --func end
--next--
function ChatLineStickerShareOther:OnDestroy()

    self.chatMgr.DestroyHeadObj(self.Parameter.Head.Transform)

end --func end
--next--
function ChatLineStickerShareOther:OnDeActive()

    -- do nothing

end --func end
--next--
function ChatLineStickerShareOther:OnSetData(data)

    self:_setCustom(data)
    self.msgPack = data
    self.playerInfo = data.playerInfo
    self:_setPlayerData(self.msgPack, self.Parameter.PlayerName, self.Parameter.Permission, self.Parameter.BiaoQian)
    self:_setPlayerHead(data)
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
function ChatLineStickerShareOther:_setPlayerHead(msgPack)
    if nil == msgPack then
        return
    end

    ---@type HeadTemplateParam
    param = {
        EquipData = msgPack.playerInfo:GetEquipData(),
        ShowLv = true,
        ShowProfession = true,
        Level = msgPack.playerInfo.level,
        Profession = msgPack.playerInfo.type,
        OnClick = self._onIconClick,
        OnClickSelf = self
    }

    self._playerHead:SetData(param)
end

function ChatLineStickerShareOther:_onIconClick()
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.msgPack.playerInfo.uid, self.msgPack.playerInfo)
    if self.MethodCallback then
        self.MethodCallback(self.msgPack)
    end
end

---@param msgPack ChatMsgPack
---@param nameCom MoonClient.MLuaUICom @名字组件
---@param permissionCom MoonClient.MLuaUICom @权限组件
---@param tagCom MoonClient.MLuaUICom @标签处理
function ChatLineStickerShareOther:_setPlayerData(msgPack, nameCom, permissionCom, tagCom)
    if msgPack == nil then
        return
    end

    --玩家名
    if not MLuaCommonHelper.IsNull(nameCom) then
        nameCom.LabText = msgPack.playerInfo.name
    end

    --公会职称
    if not MLuaCommonHelper.IsNull(permissionCom) then
        permissionCom:SetActiveEx(false)
        if msgPack.playerInfo.data.guild_permission ~= nil then
            local l_showPermission = msgPack.channel == self.chatMgr.EChannel.GuildChat
            l_showPermission = l_showPermission and (msgPack.playerInfo.data.guild_permission <= 4) and (msgPack.playerInfo.data.guild_permission > 0)
            permissionCom:SetActiveEx(l_showPermission)
            local l_Permission = DataMgr:GetData("GuildData").GetPositionName(msgPack.playerInfo.data.guild_permission) or ""
            l_Permission = StringEx.Format("[{0}]", l_Permission)
            permissionCom.LabText = l_Permission
        end
    end
    -- 标签处理
    if not MLuaCommonHelper.IsNull(tagCom) then
        MgrMgr:GetMgr("RoleTagMgr").SetTag(tagCom, msgPack.playerInfo.tag)
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(msgPack)
end

---@param data ChatMsgPack
function ChatLineStickerShareOther:_setCustom(data)
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
    self.Parameter.TextMessage.LabColor = targetColor

    --- 设置聊天标签
    local tagID = data.playerInfo.ChatTagID
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
            self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end

--lua custom scripts end
return ChatLineStickerShareOther