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
---@class FriendChatTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_tag_lv_other MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field SystemChatText MoonClient.MLuaUICom
---@field SystemChat MoonClient.MLuaUICom
---@field PlayerWarningTag MoonClient.MLuaUICom
---@field PlayerLeftRect MoonClient.MLuaUICom
---@field PlayerChatText MoonClient.MLuaUICom
---@field PlayerChatHead MoonClient.MLuaUICom
---@field PlayerChat MoonClient.MLuaUICom
---@field PlayerAudioTime MoonClient.MLuaUICom
---@field PlayerAudioPoint MoonClient.MLuaUICom
---@field PlayerAudioObj MoonClient.MLuaUICom
---@field PlayerAudioBtn MoonClient.MLuaUICom
---@field PlayerAudioAnim MoonClient.MLuaUICom
---@field OtherChatText MoonClient.MLuaUICom
---@field OtherChatHead MoonClient.MLuaUICom
---@field OtherChat MoonClient.MLuaUICom
---@field OtherAudioTime MoonClient.MLuaUICom
---@field OtherAudioPoint MoonClient.MLuaUICom
---@field OtherAudioObj MoonClient.MLuaUICom
---@field OtherAudioBtn MoonClient.MLuaUICom
---@field OtherAudioAnim MoonClient.MLuaUICom
---@field img_tag_lv_self MoonClient.MLuaUICom
---@field img_tag_bg_self MoonClient.MLuaUICom
---@field img_tag_bg_other MoonClient.MLuaUICom
---@field img_other_bg MoonClient.MLuaUICom
---@field img_chat_tag_self MoonClient.MLuaUICom
---@field img_chat_tag_other MoonClient.MLuaUICom
---@field img_bg_self MoonClient.MLuaUICom

---@class FriendChatTemplate : BaseUITemplate
---@field Parameter FriendChatTemplateParameter

FriendChatTemplate = class("FriendChatTemplate", super)
--lua class define end

--lua functions
function FriendChatTemplate:Init()

    super.Init(self)
    self.currentChatData = nil

end --func end
--next--
function FriendChatTemplate:OnDeActive()

    MgrMgr:GetMgr("ChatAudioMgr").ClearCallBack(self.AudioObj)
    self.AudioObj = nil

end --func end
--next--
function FriendChatTemplate:OnSetData(data)

    self:showChat(data)

end --func end
--next--
function FriendChatTemplate:BindEvents()

    -- do nothing

end --func end
--next--
function FriendChatTemplate:OnDestroy()

    self.head2d_player = nil
    self.head2d_other = nil

end --func end
--next--
--lua functions end

--lua custom scripts
function FriendChatTemplate:showChat(data)
    self.Parameter.Time:SetActiveEx(false)
    self.Parameter.OtherChat:SetActiveEx(false)
    self.Parameter.PlayerChat:SetActiveEx(false)
    self.Parameter.SystemChat:SetActiveEx(false)
    self.Parameter.OtherChatText.LabRayCastTarget = true
    self.Parameter.OtherChatText:GetRichText().onHrefClick:Release()
    self.Parameter.PlayerChatText.LabRayCastTarget = true
    self.Parameter.PlayerChatText:GetRichText().onHrefClick:Release()
    self.currentChatData = data

    if self.ShowIndex == 1 then
        self:showChatTime(self.currentChatData.chatTime)
    end

    self:MessageChange()
    if self.currentChatData.chatType == 0 then
        self.Parameter.SystemChat.gameObject:SetActiveEx(true)
        self.Parameter.SystemChatText.LabText = self.currentChatData.content
    else
        local lastChat = nil
        if self.ShowIndex - 1 >= 1 then
            lastChat = MgrMgr:GetMgr("FriendMgr").CurrentFriendChatDatas[self.ShowIndex - 1]
        end
        if lastChat ~= nil then
            if self.currentChatData.chatTime - lastChat.chatTime > MgrMgr:GetMgr("FriendMgr").FriendChatIntervalTime then
                self:showChatTime(self.currentChatData.chatTime)
            end
        end

        local l_content = data.content
        --动态表情替换
        l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
        --道具链接替换
        local l_paramPack = MgrMgr:GetMgr("LinkInputMgr").StringToPack(data.extra_param)
        l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_paramPack, true)
        if data.chatType == ChatMediumType.ChatMediumTypeAudio then
            self.AudioObj = {
                ID = data.audioID,
                Text = data.audioText,
                Duration = data.audioDuration,
                PlayOver = data.audioPlayOver,
            }
        else
            self.AudioObj = nil
        end

        local l_data = DataMgr:GetData("ChatData")
        if self.currentChatData.whoChat == l_data.EChatWhoType.ISaid or self.currentChatData.whoChat == l_data.EChatWhoType.ISaidDefault
                or self.currentChatData.whoChat == l_data.EChatWhoType.ServerSaid then
            self.Parameter.PlayerChat.gameObject:SetActiveEx(true)
            self.Parameter.PlayerChatText.LabText = l_content
            self.Parameter.PlayerChatText:GetRichText().onHrefClick:AddListener(function(key)
                MgrMgr:GetMgr("LinkInputMgr").ClickHrefInfo(key, {
                    fixationPosX = -215,
                    fixationPosY = 0,
                }, self.currentChatData)
            end)

            self:SetAudioInfo(self.Parameter.PlayerAudioObj,
                    self.Parameter.PlayerAudioBtn,
                    self.Parameter.PlayerAudioPoint,
                    self.Parameter.PlayerAudioTime,
                    self.Parameter.PlayerAudioAnim,
                    self.Parameter.PlayerChatText)

            if not self.head2d_player then
                self.head2d_player = self:NewTemplate("HeadWrapTemplate", {
                    TemplateParent = self.Parameter.PlayerChatHead.transform,
                    TemplatePath = "UI/Prefabs/HeadWrapTemplate"
                })
            end

            ---@type HeadTemplateParam
            local param = {
                IsPlayerSelf = true,
            }

            self.head2d_player:SetData(param)
            self:_setSelfCustomData()
            --发送失败提示
            local l_isSendFaild = self.currentChatData.whoChat == 3
            self.Parameter.PlayerWarningTag:SetActiveEx(l_isSendFaild)
            self.Parameter.PlayerLeftRect.gameObject:SetRectTransformWidth(l_isSendFaild and 345.2 or 359.6)
        elseif self.currentChatData.whoChat == l_data.EChatWhoType.OtherSaid then
            local l_friendData = MgrMgr:GetMgr("FriendMgr").CurrentFriendData
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

            local l_uid = self.currentChatData.chatUid
            local onClick = function()
                Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_uid)
            end
            if not self.head2d_other then
                self.head2d_other = self:NewTemplate("HeadWrapTemplate", {
                    TemplateParent = self.Parameter.OtherChatHead.transform,
                    TemplatePath = "UI/Prefabs/HeadWrapTemplate"
                })
            end

            ---@type HeadTemplateParam
            local param = {
                EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_friendData.base_info),
                OnClick = onClick
            }

            self.head2d_other:SetData(param)
            self:_setOtherCustomData(l_friendData.base_info)
            self:SetAudioInfo(self.Parameter.OtherAudioObj,
                    self.Parameter.OtherAudioBtn,
                    self.Parameter.OtherAudioPoint,
                    self.Parameter.OtherAudioTime,
                    self.Parameter.OtherAudioAnim,
                    self.Parameter.OtherChatText)
        end
    end
end

function FriendChatTemplate:showChatTime(time)
    self.Parameter.Time.gameObject:SetActiveEx(true)
    self.Parameter.Time.LabText = Common.TimeMgr.GetChatTimeFormatStr(time)
end

function FriendChatTemplate:showSystemChatText()
    -- do nothing
end

--添加好友链接
function FriendChatTemplate:AddOtherChatHref()
    self.Parameter.OtherChatText.LabRayCastTarget = true
    self.Parameter.OtherChatText:GetRichText().onHrefClick:Release()
    self.Parameter.OtherChatText:GetRichText().onHrefClick:AddListener(function(hrefName)
        if hrefName == "AddFriend" then
            local l_friendData = MgrMgr:GetMgr("FriendMgr").CurrentFriendData
            MgrMgr:GetMgr("FriendMgr").RequestAddFriend(l_friendData.uid)
            local l_messageChatInfo = TableUtil.GetMessageTable().GetRowByID(self.currentChatData.contentID).Content
            local l_text = Common.Utils.Lang("Friend_AddedText")
            self.Parameter.OtherChatText.LabText = StringEx.Format(l_messageChatInfo, Common.Utils.PlayerName(l_friendData.base_info.name), l_text)
        end
    end)
end

--添加设置链接
function FriendChatTemplate:AddSystemChatHref()
    self.Parameter.SystemChatText.LabRayCastTarget = true
    self.Parameter.SystemChatText:GetRichText().onHrefClick:Release()
    self.Parameter.SystemChatText:GetRichText().onHrefClick:AddListener(function(hrefName)
        if hrefName == "PlayerSetting" then
            UIMgr:ActiveUI(UI.CtrlNames.Setting, function(ctrl)
                local settingMgr = MgrMgr:GetMgr("SettingMgr")
                settingMgr.SetIsOpenToPlayerPrivate(true)
                ctrl:SelectOneHandler(UI.HandlerNames.SettingPlayer)
            end)
        end
    end)
end

function FriendChatTemplate:SetAudioInfo(AudioObj, AudioBtn, Point, Time, Anim, ContentText)
    --音效
    AudioObj:SetActiveEx(self.AudioObj ~= nil)
    if self.AudioObj ~= nil then
        Point:SetActiveEx(not self.AudioObj.PlayOver)
        Time.LabText = Lang("Audio_Duration", self.AudioObj.Duration)
        MgrMgr:GetMgr("ChatAudioMgr").SetCallBack(self.AudioObj, function()
            Point:SetActiveEx(false)
            Anim.FxAnim:PlayAll()
        end, function()
            Anim.FxAnim:StopAll()
            Anim.Img.color = Color.New(195 / 255.0, 205 / 255.0, 223 / 255.0, 1.0)
        end)
        AudioBtn:AddClick(function()
            if MgrMgr:GetMgr("ChatAudioMgr").CanPlaying(self.AudioObj) then
                MgrMgr:GetMgr("ChatAudioMgr").Stop()
            else
                MgrMgr:GetMgr("ChatAudioMgr").Play(self.AudioObj)
            end
            MgrMgr:GetMgr("ChatAudioMgr").Clear()
        end, true)
        if string.ro_isEmpty(self.AudioObj.Text) then
            ContentText:SetActiveEx(false)
        end
    else
        ContentText:SetActiveEx(true)
    end
end

function FriendChatTemplate:MessageChange()
    local l_friendData = MgrMgr:GetMgr("FriendMgr").CurrentFriendData
    local l_row = TableUtil.GetMessageTable().GetRowByID(self.currentChatData.contentID, true)
    if l_row == nil then
        return
    end

    if self.currentChatData.contentID == 64001 then
        self.currentChatData.chatType = 1
        self.currentChatData.whoChat = 2
        local l_messageChatInfo = l_row.Content
        local l_text
        if l_friendData.friend_type == 1 then
            l_text = Common.Utils.Lang("Friend_AddedText")
        else
            self:AddOtherChatHref()
            l_text = StringEx.Format(" <a href=AddFriend>{0}</a>", Common.Utils.Lang("Friend_AddFriendText"))
        end

        self.currentChatData.content = StringEx.Format(l_messageChatInfo, Common.Utils.PlayerName(l_friendData.base_info.name), l_text)
    elseif self.currentChatData.contentID == 63002 then
        self.currentChatData.content = l_row.Content
        self.currentChatData.content = StringEx.Format(self.currentChatData.content, "PlayerSetting")
        self:AddSystemChatHref()
    elseif self.currentChatData.contentID == 63001 then
        self.currentChatData.content = l_row.Content
        self.currentChatData.content = StringEx.Format(self.currentChatData.content, Common.Utils.PlayerName(l_friendData.base_info.name))
    else
        self.currentChatData.content = l_row.Content
    end
end

--- 好友界面prefab是左右做在一起的，这个是设置自己的问题
function FriendChatTemplate:_setSelfCustomData()
    local mgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
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

--- 设置其他玩家的个性化数据
---@param data MemberBaseInfo
function FriendChatTemplate:_setOtherCustomData(data)
    if nil == data then
        logError("[FriendPrefab] invalid data")
        return
    end

    local currentDialogBgId = self:_getValidChatBubbleID(data.chat_frame)
    local dialogBgMgr = MgrMgr:GetMgr("DialogBgMgr")
    local targetData = dialogBgMgr.GetDataByID(currentDialogBgId)
    if nil == targetData then
        logError("[FriendPrefab] invalid id: " .. tostring(currentDialogBgId))
        return
    end

    self.Parameter.img_other_bg:SetSpriteAsync(targetData.config.Atlas, targetData.config.Photo)
    local targetColor = CommonUI.Color.Hex2Color(targetData.config.Color)
    self.Parameter.OtherChatText.LabColor = targetColor
    local currentTagID = data.chat_tag
    MgrMgr:GetMgr("ChatMgr").UpdateChatTag(currentTagID,self.Parameter.img_chat_tag_other,
            self.Parameter.img_tag_bg_other, self.Parameter.txt_tag_lv_other)
end

function FriendChatTemplate:_getValidChatBubbleID(bubbleID)
    local default = MgrMgr:GetMgr("DialogBgMgr").GetDefault()
    if nil == bubbleID or 0 >= bubbleID then
        return default
    end

    return bubbleID
end
--lua custom scripts end
return FriendChatTemplate