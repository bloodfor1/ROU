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
---@class ChatLineTaskPhotoSelfParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_tag_lv MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field img_tag_bg MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom

---@class ChatLineTaskPhotoSelf : BaseUITemplate
---@field Parameter ChatLineTaskPhotoSelfParameter

ChatLineTaskPhotoSelf = class("ChatLineTaskPhotoSelf", super)
--lua class define end

--lua functions
function ChatLineTaskPhotoSelf:Init()

    super.Init(self)

end --func end
--next--
function ChatLineTaskPhotoSelf:OnDestroy()

    self.head2d = nil

end --func end
--next--
function ChatLineTaskPhotoSelf:OnDeActive()

    -- do nothing

end --func end
--next--
function ChatLineTaskPhotoSelf:OnSetData(data)

    self.msgPack = data
    self:_setCustom()
    --玩家名
    self.Parameter.PlayerName.LabText = MPlayerInfo.Name
    -- 标签处理
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, DataMgr:GetData("RoleTagData").GetActiveTagId())
    --内容
    local l_content = Lang("TaskPhoto_Help")--"求助：这是哪？"
    --动态表情替换
    self.Parameter.Bubble.gameObject:SetActiveEx(not string.ro_isEmpty(l_content))
    l_content = l_content or ""
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    self.Parameter.Message.gameObject:SetActiveEx(true)
    self.Parameter.Message.LabText = l_content
    self.Parameter.Message.LabRayCastTarget = true
    self.Parameter.Message:GetRichText().onDown = function()
        if self.MethodCallback then
            self.MethodCallback(self.msgPack)
        end
    end
    --公会职称
    local l_guildData = DataMgr:GetData("GuildData")
    self.Parameter.Permission:SetActiveEx(false)
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() and l_guildData.GetSelfGuildPosition() <= l_guildData.EPositionType.Deacon then
        local l_showPermission = self.msgPack.channel == DataMgr:GetData("ChatData").EChannel.GuildChat
        self.Parameter.Permission:SetActiveEx(l_showPermission)
        local l_Permission = l_guildData.GetPositionName(l_guildData.GetSelfGuildPosition()) or ""
        l_Permission = StringEx.Format("[{0}]", l_Permission)
        self.Parameter.Permission.LabText = l_Permission
    end
    --任务图片显示
    --self.Parameter.Image:SetActiveEx(self.msgPack.ViewportID and true)
    self.Parameter.Image:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(self.msgPack)
        end
    end, true)
    if self.msgPack.ViewportID then
        self.Parameter.Image:SetRawTex("ViewPort/Viewport" .. tostring(self.msgPack.ViewportID) .. ".jpg")
    else
        logError("未设置 ViewportID！")
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)

end --func end
--next--
function ChatLineTaskPhotoSelf:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
function ChatLineTaskPhotoSelf:_updatePlayerHead()
    --头像
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Head.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        ShowProfession = true,
        ShowLv = true,
        IsPlayerSelf = true
    }

    self.head2d:SetData(param)
end

function ChatLineTaskPhotoSelf:_setCustom()
    self:_updatePlayerHead()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentID = mgr.GetBubbleID()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local data = dialogBgMgr.GetDataByID(currentID)
    self.Parameter.Background:SetSpriteAsync(data.config.Atlas, data.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(data.config.Color)
    self.Parameter.Message.LabColor = targetColor

    --- 设置聊天标签
    local tagID = mgr.GetChatTagID()
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
            self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end

--lua custom scripts end
return ChatLineTaskPhotoSelf