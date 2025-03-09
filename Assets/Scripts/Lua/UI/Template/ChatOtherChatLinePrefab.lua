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
---@class ChatOtherChatLinePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_tag_lv MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field img_tag_cover MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field backgroud MoonClient.MLuaUICom
---@field AudioTime MoonClient.MLuaUICom
---@field AudioObj MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field AudioAnim MoonClient.MLuaUICom

---@class ChatOtherChatLinePrefab : BaseUITemplate
---@field Parameter ChatOtherChatLinePrefabParameter

ChatOtherChatLinePrefab = class("ChatOtherChatLinePrefab", super)
--lua class define end

--lua functions
function ChatOtherChatLinePrefab:Init()

    super.Init(self)

end --func end
--next--
function ChatOtherChatLinePrefab:OnDeActive()

    if self.msgPack ~= nil then
        MgrMgr:GetMgr("ChatAudioMgr").ClearCallBack(self.msgPack.AudioObj)
    end
    if self.Parameter.Message ~= nil then
        self.Parameter.Message:GetRichText().PopulateMeshAct = nil
    end

end --func end
--next--
function ChatOtherChatLinePrefab:OnSetData(data)

    if data == nil then
        return
    end
    self.msgPack = data
    self.playerInfo = data.playerInfo
    if self.playerInfo == nil then
        return
    end
    self:_setCustom(data)
    --玩家名
    self.Parameter.PlayerName.LabText = Common.Utils.PlayerName(self.playerInfo.name)
    -- 标签处理
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, self.playerInfo.tag)
    --内容
    local l_content = self.msgPack.content
    --动态表情替换
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    --道具链接替换
    l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, self.msgPack.Param, true)
    --消息内容
    self.Parameter.Message.gameObject:SetActiveEx(true)
    self.Parameter.Message:GetRichText():AddImageClickFuncToDic("UI_Common_Btn_Join.png", function()
        if self.playerInfo.uid == tostring(MPlayerInfo.UID) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_APPLYTEAM"))
            return
        end
        MgrMgr:GetMgr("TeamMgr").BegInTeam(self.playerInfo.uid)
    end)
    self.Parameter.Message:GetRichText():AddImageClickFuncToDic("UI_icon_item_xietongzhizheng.png", function(go, eventData)
        local pos = Vector2.New(eventData.position.x,eventData.position.y-20) 
        eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("TEAM_XIE_TONG"), eventData, Vector2(0, 0))
    end)
    self.Parameter.Message.LabText = l_content
    --超链接回调
    self.Parameter.Message.LabRayCastTarget = true
    self.Parameter.Message:GetRichText().onHrefClick:Release()
    self.Parameter.Message:GetRichText().onHrefClick:AddListener(function(key)
        if key == "AddFriend" then
            if self.msgPack.playerInfo and self.msgPack.FriendData then
                MgrMgr:GetMgr("FriendMgr").RequestAddFriend(self.msgPack.uid)
                local l_messageChatInfo = TableUtil.GetMessageTable().GetRowByID(self.msgPack.FriendData.contentID).Content
                local l_text = Common.Utils.Lang("Friend_AddedText")
                self.Parameter.Message.LabText = StringEx.Format(l_messageChatInfo, Common.Utils.PlayerName(self.msgPack.playerInfo.name), l_text)
            end
            return
        end
        if key == "TeamShout" then
            if self.playerInfo.uid == tostring(MPlayerInfo.UID) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_APPLYTEAM"))
                return
            end
            MgrMgr:GetMgr("TeamMgr").BegInTeam(self.playerInfo.uid)
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
        self.Parameter.AudioTime.LabText = Lang("Audio_Duration", self.msgPack.AudioObj.Duration)--{0:F1}秒
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
    self.Parameter.Permission.LabColor = Color.New(106 / 255, 159 / 255, 240 / 255, 1);
    self.Parameter.PlayerName.LabColor = Color.New(106 / 255, 159 / 255, 240 / 255, 1);
    --公会职称
    self.Parameter.Permission:SetActiveEx(false)
    if self.playerInfo.data.guild_permission ~= nil then
        local l_showPermission = self.msgPack.channel == DataMgr:GetData("ChatData").EChannel.GuildChat
        l_showPermission = l_showPermission and (self.playerInfo.data.guild_permission <= 5) and (self.playerInfo.data.guild_permission > 0)
        self.Parameter.Permission:SetActiveEx(l_showPermission)
        local l_Permission = DataMgr:GetData("GuildData").GetPositionName(self.playerInfo.data.guild_permission) or ""
        l_Permission = StringEx.Format("[{0}]", l_Permission)
        self.Parameter.Permission.LabText = l_Permission
        if DataMgr:GetData("GuildData").IsGuildBeauty(self.playerInfo.data.guild_permission) and l_showPermission then
            self.Parameter.Permission.LabColor = Color.New(255 / 255, 134 / 255, 157 / 255, 1)
        else
            self.Parameter.Permission.LabColor = RoColor.Hex2Color("FF9A23FF")
        end
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)

end --func end
--next--
function ChatOtherChatLinePrefab:BindEvents()

    -- do nothing

end --func end
--next--
function ChatOtherChatLinePrefab:OnDestroy()

    self.head2d = nil

end --func end
--next--
--lua functions end

--lua custom scripts
function ChatOtherChatLinePrefab:_onIconClick()
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
    if self.MethodCallback then
        self.MethodCallback(self.msgPack)
    end
end

function ChatOtherChatLinePrefab:_updateHead()
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
        OnClick = self._onIconClick,
        OnClickSelf = self,
    }

    self.head2d:SetData(param)
end

---@param data ChatMsgPack
function ChatOtherChatLinePrefab:_setCustom(data)
    if nil == data or nil == data.playerInfo then
        logError("[ChatChannel] invalid param")
        return
    end

    self:_updateHead()
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
            self.Parameter.img_tag_cover, self.Parameter.txt_tag_lv)
end
--lua custom scripts end
return ChatOtherChatLinePrefab