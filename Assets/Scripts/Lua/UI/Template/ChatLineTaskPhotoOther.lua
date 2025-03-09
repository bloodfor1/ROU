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
---@class ChatLineTaskPhotoOtherParameter
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
---@field backgroud MoonClient.MLuaUICom

---@class ChatLineTaskPhotoOther : BaseUITemplate
---@field Parameter ChatLineTaskPhotoOtherParameter

ChatLineTaskPhotoOther = class("ChatLineTaskPhotoOther", super)
--lua class define end

--lua functions
function ChatLineTaskPhotoOther:Init()

    super.Init(self)

end --func end
--next--
function ChatLineTaskPhotoOther:OnDestroy()

    self.head2d = nil

end --func end
--next--
function ChatLineTaskPhotoOther:OnDeActive()

    -- do nothing

end --func end
--next--
function ChatLineTaskPhotoOther:OnSetData(data)

    self.msgPack = data
    self.playerInfo = data.playerInfo
    self:_setCustom(data)
    -- 标签处理
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, self.playerInfo.tag)
    --玩家名
    self.Parameter.PlayerName.LabText = self.playerInfo.name
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
    self.Parameter.Permission:SetActiveEx(false)
    if self.playerInfo.data.guild_permission ~= nil then
        local l_showPermission = self.msgPack.channel == DataMgr:GetData("ChatData").EChannel.GuildChat
        l_showPermission = l_showPermission and (self.playerInfo.data.guild_permission <= 4) and (self.playerInfo.data.guild_permission > 0)
        self.Parameter.Permission:SetActiveEx(l_showPermission)
        local l_Permission = DataMgr:GetData("GuildData").GetPositionName(self.playerInfo.data.guild_permission) or ""
        l_Permission = StringEx.Format("[{0}]", l_Permission)
        self.Parameter.Permission.LabText = l_Permission
    end
    --任务图片显示
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
function ChatLineTaskPhotoOther:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
function ChatLineTaskPhotoOther:_onHeadClick()
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
    if self.MethodCallback then
        self.MethodCallback(self.msgPack)
    end
end

function ChatLineTaskPhotoOther:_setCustomHead()
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Head.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = self.playerInfo:GetEquipData(),
        ShowProfession = true,
        Profession = self.playerInfo.type,
        ShowLv = true,
        Level = self.playerInfo.level,
        OnClick = self._onHeadClick,
        OnClickSelf = self,
    }

    self.head2d:SetData(param)
end

---@param data ChatMsgPack
function ChatLineTaskPhotoOther:_setCustom(data)
    if nil == data or nil == data.playerInfo then
        logError("[ChatChannel] invalid param")
        return
    end

    self:_setCustomHead()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetData = dialogBgMgr.GetDataByID(data.playerInfo.ChatBubbleID)
    if nil == targetData then
        logError("[ChatChannel] invalid id: " .. tostring(data.playerInfo.ChatBubbleID))
        return
    end

    self.Parameter.backgroud:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.Parameter.Message.LabColor = targetColor

    --- 设置聊天标签
    local tagID = data.playerInfo.ChatTagID
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
            self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end
--lua custom scripts end
return ChatLineTaskPhotoOther