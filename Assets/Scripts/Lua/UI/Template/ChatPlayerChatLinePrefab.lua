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
---@class ChatPlayerChatLinePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WarningTag MoonClient.MLuaUICom
---@field WarningRect MoonClient.MLuaUICom
---@field txt_tag_lv MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field img_tag_bg MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field BubbleRect MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field AudioTime MoonClient.MLuaUICom
---@field AudioObj MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field AudioAnim MoonClient.MLuaUICom

---@class ChatPlayerChatLinePrefab : BaseUITemplate
---@field Parameter ChatPlayerChatLinePrefabParameter

ChatPlayerChatLinePrefab = class("ChatPlayerChatLinePrefab", super)
--lua class define end

--lua functions
function ChatPlayerChatLinePrefab:Init()

    super.Init(self)

end --func end
--next--
function ChatPlayerChatLinePrefab:OnDeActive()

    if self.msgPack ~= nil then
        MgrMgr:GetMgr("ChatAudioMgr").ClearCallBack(self.msgPack.AudioObj)
    end
    if self.Parameter.Message ~= nil then
        self.Parameter.Message:GetRichText().PopulateMeshAct = nil
        self.Parameter.Message:GetRichText().onDown = nil
    end

end --func end
--next--
function ChatPlayerChatLinePrefab:OnSetData(data)

    self.msgPack = data
    self:_setCustomData()
    --玩家名
    self.Parameter.PlayerName.LabText = tostring(MPlayerInfo.Name)
    -- 标签处理
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, DataMgr:GetData("RoleTagData").GetActiveTagId())
    --内容
    local l_content = self.msgPack.content
    --动态表情替换
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    --道具链接替换
    l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, self.msgPack.Param, true)
    self.Parameter.Message.gameObject:SetActiveEx(true)
    --设置回掉
    local BtnJoinFunc = function()
        if tostring(self.msgPack.uid) == tostring(MPlayerInfo.UID) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_APPLYTEAM"))
            return
        end
        MgrMgr:GetMgr("TeamMgr").BegInTeam(self.msgPack.uid)
    end
    self.Parameter.Message:GetRichText():AddImageClickFuncToDic("UI_Common_Btn_Join.png", BtnJoinFunc)
    self.Parameter.Message:GetRichText():AddImageClickFuncToDic("UI_icon_item_xietongzhizheng.png", function(go, eventData)
        local pos = Vector2.New(eventData.position.x,eventData.position.y-20) 
        eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("TEAM_XIE_TONG"), eventData, Vector2(0, 1))
    end)
    self.Parameter.Message.LabText = l_content
    --超链接回调
    self.Parameter.Message.LabRayCastTarget = true
    self.Parameter.Message:GetRichText().onHrefClick:Release()
    self.Parameter.Message:GetRichText().onHrefClick:AddListener(function(key)
        if key == "TeamShout" then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_APPLYTEAM"))
            return
        end
        MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key, {
            fixationPosX = 130,
            fixationPosY = 0,
            originText = self.Parameter.Message
        }, self.msgPack)
    end)
    self.Parameter.Message:GetRichText().onDown = function()
        if self.MethodCallback then
            self.MethodCallback(self.msgPack)
        end
    end
    --音效
    self.Parameter.AudioObj.gameObject:SetActiveEx(self.msgPack.AudioObj ~= nil)
    if self.msgPack.AudioObj ~= nil then
        if self.msgPack.AudioObj.Duration >= 9 then
            self.Parameter.AudioBtn.LayoutEle.preferredWidth = 230
        elseif self.msgPack.AudioObj.Duration >= 6 then
            self.Parameter.AudioBtn.LayoutEle.preferredWidth = 180
        elseif self.msgPack.AudioObj.Duration >= 3 then
            self.Parameter.AudioBtn.LayoutEle.preferredWidth = 130
        else
            self.Parameter.AudioBtn.LayoutEle.preferredWidth = 80
        end
        self.Parameter.Point.gameObject:SetActiveEx(not self.msgPack.AudioObj.PlayOver)
        self.Parameter.AudioTime.LabText = Lang("Audio_Duration", self.msgPack.AudioObj.Duration)
        MgrMgr:GetMgr("ChatAudioMgr").SetCallBack(self.msgPack.AudioObj, function()
            self.Parameter.Point.gameObject:SetActiveEx(false)
            self.Parameter.AudioAnim.FxAnim:PlayAll()
        end, function()
            self.Parameter.AudioAnim.FxAnim:StopAll()
            self.Parameter.AudioAnim.Img.color = Color.New(195 / 255.0, 205 / 255.0, 223 / 255.0, 1.0)
        end)
        self.Parameter.AudioBtn:AddClick(function()
            if MgrMgr:GetMgr("ChatAudioMgr").CanPlaying(self.msgPack.AudioObj) then
                MgrMgr:GetMgr("ChatAudioMgr").Stop()
            else
                MgrMgr:GetMgr("ChatAudioMgr").Play(self.msgPack.AudioObj)
            end
            MgrMgr:GetMgr("ChatAudioMgr").Clear()
            if self.MethodCallback then
                self.MethodCallback(self.msgPack)
            end
        end, true)
        if string.ro_isEmpty(l_content) then
            self.Parameter.Message.gameObject:SetActiveEx(false)
        end
    end
    --公会职称
    self.Parameter.Permission.LabColor = Color.New(106 / 255, 159 / 255, 240 / 255, 1);
    self.Parameter.PlayerName.LabColor = Color.New(106 / 255, 159 / 255, 240 / 255, 1);
    local l_guildData = DataMgr:GetData("GuildData")
    self.Parameter.Permission:SetActiveEx(false)
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() and l_guildData.GetSelfGuildPosition() <= l_guildData.EPositionType.Beauty and l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.NotInGuild then
        local l_showPermission = self.msgPack.channel == DataMgr:GetData("ChatData").EChannel.GuildChat
        self.Parameter.Permission:SetActiveEx(l_showPermission)
        local l_Permission = l_guildData.GetPositionName(l_guildData.GetSelfGuildPosition()) or ""
        l_Permission = StringEx.Format("[{0}]", l_Permission)
        self.Parameter.Permission.LabText = l_Permission
        if DataMgr:GetData("GuildData").IsGuildBeauty(l_guildData.GetSelfGuildPosition()) then
            self.Parameter.Permission.LabColor = Color.New(255 / 255, 134 / 255, 157 / 255, 1)
            --self.Parameter.PlayerName.LabColor = Color.New(255 / 255, 134 / 255, 157 / 255, 1)
        else
            self.Parameter.Permission.LabColor = RoColor.Hex2Color("FF9A23FF")
        end
    end
    --发送失败的tag
    local l_warning = self.msgPack.WarningTag
    self.Parameter.WarningTag:SetActiveEx(l_warning)
    self.Parameter.WarningRect.LGroup.padding.right = l_warning and self.Parameter.WarningTag.transform.sizeDelta.x or 0
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)

end --func end
--next--
function ChatPlayerChatLinePrefab:OnDestroy()

    self.head2d = nil

end --func end
--next--
function ChatPlayerChatLinePrefab:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
function ChatPlayerChatLinePrefab:OnDisable()
    -- do nothing
end

function ChatPlayerChatLinePrefab:_updatePlayerHead()
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

--- 设置个性化数据，主要设置角色气泡框和字体颜色
function ChatPlayerChatLinePrefab:_setCustomData()
    self:_updatePlayerHead()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local currentID = mgr.GetBubbleID()
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local data = dialogBgMgr.GetDataByID(currentID)
    if nil == data then
        logError("[ChatLine] invalid data")
        return
    end

    self.Parameter.BubbleRect:SetSpriteAsync(data.config.Atlas, data.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(data.config.Color)
    self.Parameter.Message.LabColor = targetColor

    --- 设置聊天标签
    local tagID = mgr.GetChatTagID()
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
            self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end
--lua custom scripts end
return ChatPlayerChatLinePrefab