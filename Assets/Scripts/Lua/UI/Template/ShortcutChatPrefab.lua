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
---@class ShortcutChatPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field RestoreBtn MoonClient.MLuaUICom
---@field RecordBtn MoonClient.MLuaUICom
---@field Panel_InputAndVoice MoonClient.MLuaUICom
---@field NewMessageHint MoonClient.MLuaUICom
---@field NewMessageContent MoonClient.MLuaUICom
---@field Mini MoonClient.MLuaUICom
---@field MainFloor MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field KeyboardBtn MoonClient.MLuaUICom
---@field InputPanel MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field HideBtn MoonClient.MLuaUICom
---@field FriendText MoonClient.MLuaUICom
---@field FriendLight MoonClient.MLuaUICom
---@field FriendFloor MoonClient.MLuaUICom
---@field FriendFinish MoonClient.MLuaUICom
---@field FriendChatParent MoonClient.MLuaUICom
---@field Friend MoonClient.MLuaUICom
---@field ChatScroll MoonClient.MLuaUICom
---@field ChannelText MoonClient.MLuaUICom
---@field ChannelLight MoonClient.MLuaUICom
---@field ChannelFloor MoonClient.MLuaUICom
---@field ChannelFinish MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field CancelBtn MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnFace MoonClient.MLuaUICom
---@field AudioPanel MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom

---@class ShortcutChatPrefab : BaseUITemplate
---@field Parameter ShortcutChatPrefabParameter

ShortcutChatPrefab = class("ShortcutChatPrefab", super)
--lua class define end

--lua functions
function ShortcutChatPrefab:Init()

    super.Init(self)
    self.mgr = MgrMgr:GetMgr("ShortcutChatMgr")
    self.chatMgr = MgrMgr:GetMgr("ChatMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.linkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
    self.friendMgr = MgrMgr:GetMgr("FriendMgr")
    self.chatDataLuaMgr = DataMgr:GetData("ChatData")
    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
    self.teamMgr = MgrMgr:GetMgr("TeamMgr")
    self.sceneSize = Vector2.New(Screen.width, Screen.height) / 2.0
    self.uISize = MUIManager.UIRoot.transform.sizeDelta / 2.0

end --func end
--next--
function ShortcutChatPrefab:OnDestroy()

    if self.recordObj ~= nil then
        self.recordObj:Unint()
        self.recordObj = nil
    end
    self.ChatTems = nil

end --func end
--next--
function ShortcutChatPrefab:OnDeActive()


end --func end
--next--
function ShortcutChatPrefab:OnSetData(data)

    self.Data = data
    self:initChat()
    self:ResetShow()
    self.Parameter.HideBtn:AddClick(function()
        self:lastSibling()
        if self.Data:SetMini(true) then
            self:ResetShow()
        end
    end, true)
    self.Parameter.RestoreBtn:AddClick(function()
        self:lastSibling()
        if self.Data:ResetPos() then
            self.Parameter.LuaUIGroup.gameObject:SetRectTransformPos(self.Data.pos.x, self.Data.pos.y)
        end
    end, true)
    self.Parameter.CancelBtn:AddClick(handler(self, self.onCancelBtn))
    self.Parameter.ChatScroll.Listener.onDown = handler(self, self.lastSibling)
    self.Parameter.MainFloor.Listener.beginDrag = handler(self, self.onDragStart)
    self.Parameter.MainFloor.Listener.onDrag = handler(self, self.onDrag)
    self.Parameter.MainFloor.Listener.endDrag = handler(self, self.onDragEnd)
    self.Parameter.MainFloor.Listener.onDown = handler(self, self.lastSibling)
    --点击、长按录音、拖动位移
    self.CanClick = true
    self.Parameter.ChannelFloor.Listener.onDown = function(obj, data)
        self:lastSibling()
        local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)
        if l_chatVoiceOpen then
            self.WaitRecordTime = Time.unscaledTime + self.mgr.LongClickTime
            self.CanClick = true
        end
    end
    self.Parameter.ChannelFloor.Listener.onUp = function(obj, data)
        self.WaitRecordTime = nil
        self.recordObj:OnUp(obj, data)
    end
    self.Parameter.ChannelFloor.Listener.onEnter = function(obj, data)
        self.recordObj:OnEnter(obj, data)
    end
    self.Parameter.ChannelFloor.Listener.onExit = function(obj, data)
        self.recordObj:OnExit(obj, data)
    end
    self.Parameter.ChannelFloor.Listener.onClick = function(go, data)
        if self.CanClick and not self.DragId and not self.recordObj.InRecord then
            if self.Data:SetMini(false) then
                self:ResetShow()
            end
        end
    end
    self.Parameter.ChannelFloor.Listener.beginDrag = function(obj, data)
        self.WaitRecordTime = nil
        if not self.recordObj.InRecord then
            self:onDragStart(obj, data)
        end
    end
    self.Parameter.ChannelFloor.Listener.onDrag = handler(self, self.onDrag)
    self.Parameter.ChannelFloor.Listener.endDrag = handler(self, self.onDragEnd)
    --
    self.Parameter.FriendFloor.Listener.onDown = self.Parameter.ChannelFloor.Listener.onDown
    self.Parameter.FriendFloor.Listener.onUp = self.Parameter.ChannelFloor.Listener.onUp
    self.Parameter.FriendFloor.Listener.onEnter = self.Parameter.ChannelFloor.Listener.onEnter
    self.Parameter.FriendFloor.Listener.onExit = self.Parameter.ChannelFloor.Listener.onExit
    self.Parameter.FriendFloor.Listener.onClick = self.Parameter.ChannelFloor.Listener.onClick
    self.Parameter.FriendFloor.Listener.beginDrag = self.Parameter.ChannelFloor.Listener.beginDrag
    self.Parameter.FriendFloor.Listener.onDrag = handler(self, self.onDrag)
    self.Parameter.FriendFloor.Listener.endDrag = handler(self, self.onDragEnd)
    --初始化位置
    self.Parameter.LuaUIGroup.gameObject:SetRectTransformPos(self.Data.pos.x, self.Data.pos.y)
    self.Parameter.ChannelLight:SetActiveEx(false)
    self:refreshVoiceBtnState()

end --func end
--next--
function ShortcutChatPrefab:BindEvents()

    --收到新消息
    ---@param msg ChatMsgPack
    self:BindEvent(GlobalEventBus, EventConst.Names.NewChatMsg, function(self, msg)
        if not UIMgr:IsActiveUI(UI.CtrlNames.ShortcutChat) then
            return
        end
        if msg.channel ~= self.Data.channel then
            return
        end
        if self.Data.mini then
            self.Parameter.ChannelLight:SetActiveEx(not msg.isRed)
            return
        end
        local l_class, l_prefab = self.chatDataLuaMgr.GetChannelLineTemInfo(msg)
        if l_class == nil or l_prefab == nil then
            return
        end
        local l_max = self.chatDataLuaMgr.GetLocalCacheNum(self.Data.channel)
        local l_self = msg.lineType == self.chatDataLuaMgr.EChatPrefabType.Self
        local l_inDown = self:canMoveDown(msg)
        self.ChatTems:AddTemplate(msg, l_max)
        --新消息计数
        if l_inDown or l_self then
            if l_self and not l_inDown then
                --自己说的话滑动到底部
                self.ChatTems:ShowTemplates({
                    Datas = self.ChatTems.Datas,
                    StartScrollIndex = #self.ChatTems.Datas,
                    Method = handler(self, self.lastSibling)
                })
            end
            self.Parameter.ChatScroll.LoopScroll:ScrollToCell(#self.ChatTems.Datas - 1, 2000)
            self.Parameter.NewMessageHint:SetActiveEx(false)
            self.NewMessageCount = nil
        else
            if not self.Parameter.NewMessageHint.gameObject.activeSelf then
                self.NewMessageCount = 0
            end
            self.NewMessageCount = (self.NewMessageCount or 0) + 1
            self.Parameter.NewMessageHint:SetActiveEx(true)
            --%s条新消息↓
            self.Parameter.NewMessageContent.LabText = StringEx.Format(Lang("NewMessageHintCount"), tostring(self.NewMessageCount))
        end
    end)
    --旧聊天改变
    self:BindEvent(self.chatMgr.EventDispatcher, self.chatDataLuaMgr.EEventType.Modification, function(self, msgPack)
        if self.ChatTems==nil then
            return
        end
        local l_tem = self.ChatTems:FindShowTem(function(tem)
            return msgPack == tem.msgPack
        end)
        if l_tem then
            l_tem:SetData(msgPack)
        end
    end)
    --消息已读
    self:BindEvent(self.chatMgr.EventDispatcher, self.chatDataLuaMgr.EEventType.MsgRead, function(self, msgPack)
        if msgPack.channel ~= self.Data.channel then
            return
        end
        if not self.Parameter.ChannelLight.gameObject.activeSelf then
            return
        end
        local l_dataLis = self.chatDataLuaMgr.GetChannelCache(msgPack.channel)
        if l_dataLis.last and l_dataLis.last.value == msgPack then
            self.Parameter.ChannelLight:SetActiveEx(false)
        end
    end)
    --重置位置问题
    local l_resetPosFunc = function(self)
        if self.Data.channel then
            if not self.Data.moved and self.Data:ResetPos() then
                self.Parameter.LuaUIGroup.gameObject:SetRectTransformPos(self.Data.pos.x, self.Data.pos.y)
            end
        end
    end
    l_resetPosFunc(self)
    self:BindEvent(self.guildMgr.EventDispatcher, self.guildMgr.ON_GET_GUILD_INFO_CHANGE, l_resetPosFunc)
    self:BindEvent(self.teamMgr.EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, l_resetPosFunc)
    self:BindEvent(self.openMgr.EventDispatcher, self.openMgr.OpenSystemUpdate, function(self)
        self:refreshVoiceBtnState()
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataLuaMgr.EEventType.UpdateForbidPlayerInfo, self.onForbidPlayerInfosUpdate,self)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataLuaMgr.EEventType.GetForbidPlayerInfoList, self.onForbidPlayerInfosUpdate,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function ShortcutChatPrefab:ResetShow()
    self.Parameter.Main:SetActiveEx(not self.Data.mini)
    self.Parameter.Mini:SetActiveEx(self.Data.mini)
    self.WaitRecordTime = nil
    self.recordObj:OnUp()

    ------------------缩小模式
    if self.Data.mini then
        self.Parameter.Channel:SetActiveEx(true)
        self.Parameter.Friend:SetActiveEx(false)
        if self.Data.channel == self.chatDataLuaMgr.EChannel.TeamChat then
            self.Parameter.ChannelText.LabText = Lang("ChatAudio_Team")--"队"
        elseif self.Data.channel == self.chatDataLuaMgr.EChannel.GuildChat then
            self.Parameter.ChannelText.LabText = Lang("ChatAudio_Guild")--"会"
        elseif self.Data.channel == self.chatDataLuaMgr.EChannel.WatchChat then
            self.Parameter.ChannelText.LabText = ""
        end

        if self.Data.channel == self.chatDataLuaMgr.EChannel.WatchChat then
            self.Parameter.Image:SetSpriteAsync("OverseaChangeAll", "UI_Icon_Guanzhan.png", nil, true)
            MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Image.gameObject, 0)
        else
            self.Parameter.Image:SetSpriteAsync("OverseaChangeAll", "UI_Main_Btn_QuickChat2.png", nil, true)
            MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Image.gameObject, 2.1)
        end

        self.ChatTems:ShowTemplates({ Datas = {} })

        -- 留个注释，这个是为了解决切换场景闪的问题的，直接把特效干掉了
        -- 如果后期确认要启用这个特效再给他加回来
        self.Parameter.ChannelFinish:SetActiveEx(false)
        -- self.Parameter.ChannelFinish.FxAnim:PlayAll()
        return
    end

    -----------------放大模式
    --标题
    if self.Data.channel == self.chatDataLuaMgr.EChannel.TeamChat then
        self.Parameter.Title.LabText = Lang("Team_Channel_Name")--"组队频道"
    elseif self.Data.channel == self.chatDataLuaMgr.EChannel.GuildChat then
        self.Parameter.Title.LabText = Lang("Guild_Channel_Name")--"公会频道"
    elseif self.Data.channel == self.chatDataLuaMgr.EChannel.WatchChat then
        self.Parameter.Title.LabText = Lang("Watch_Channel_Name")--"观战频道"
    end

    MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Main.gameObject, (self.Data.channel == self.chatDataLuaMgr.EChannel.WatchChat) and -50 or 0)

    --列出所有消息
    local l_cacheQueue = self.chatDataLuaMgr.GetFilterChannelCache(self.Data.channel)
    local l_msgs = {}
    if l_cacheQueue then
        local l_cacheTable = l_cacheQueue:enumerate()
        for _, msg in pairs(l_cacheTable) do
            if self.chatDataLuaMgr.GetChannelLineTemInfo(msg) then
                table.insert(l_msgs, msg)
            end
        end
    end
    self.ChatTems:ShowTemplates({
        Datas = l_msgs,
        StartScrollIndex = #l_msgs,
        Method = handler(self, self.lastSibling)
    })
    self.Parameter.NewMessageHint:SetActiveEx(false)
    self.Parameter.ChannelLight:SetActiveEx(false)
    self.Parameter.ChannelFinish:SetActiveEx(false)
end

function ShortcutChatPrefab:lastSibling()
    self.Parameter.LuaUIGroup.transform:SetAsLastSibling()
end

function ShortcutChatPrefab:onDragStart(go, data)
    if self.DragId then
        return
    end
    self.DragId = data.pointerId
    self.DragStartPos = data.pressPosition - self.sceneSize
    self.DragStartPos.x = (self.DragStartPos.x / self.sceneSize.x) * self.uISize.x
    self.DragStartPos.y = (self.DragStartPos.y / self.sceneSize.y) * self.uISize.y
    self.DragStartPos = self.Parameter.LuaUIGroup.transform.anchoredPosition - self.DragStartPos
end

function ShortcutChatPrefab:onDrag(go, data)
    if self.DragId ~= data.pointerId then
        return
    end
    local l_pos = data.position
    l_pos.x = (l_pos.x / self.sceneSize.x) * self.uISize.x
    l_pos.y = (l_pos.y / self.sceneSize.y) * self.uISize.y
    l_pos = l_pos - self.uISize + self.DragStartPos
    l_pos.x = math.max(l_pos.x, -self.uISize.x)
    l_pos.y = math.max(l_pos.y, -self.uISize.y)
    l_pos.x = math.min(l_pos.x, self.uISize.x - 60)
    l_pos.y = math.min(l_pos.y, self.uISize.y - 60)
    if self.Data:SetPos(l_pos) then
        self.Parameter.LuaUIGroup.gameObject:SetRectTransformPos(l_pos.x, l_pos.y)
    end
end

function ShortcutChatPrefab:onDragEnd(go, data)
    if self.DragId ~= data.pointerId then
        return
    end
    self.DragStartPos = nil
    self.DragId = nil
end

-------------------------聊天内容
function ShortcutChatPrefab:initChat()
    local l_txtPlaceHolder = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.InputMessage.transform:Find("Placeholder"))
    l_txtPlaceHolder.LabText = Lang("CHAT_CLICK_INPUT_HINT")--"点击这里输入..."

    --发送消息
    self.Parameter.BtnSend:AddClick(handler(self, self.onSendBtn))

    self.Parameter.InputPanel.gameObject:SetActiveEx(true)
    self.Parameter.AudioPanel.gameObject:SetActiveEx(false)
    --语音
    self.Parameter.RecordBtn:AddClick(function()
        self:lastSibling()
        self.Parameter.InputPanel.gameObject:SetActiveEx(false)
        self.Parameter.AudioPanel.gameObject:SetActiveEx(true)
    end)
    self.Parameter.KeyboardBtn:AddClick(function()
        self:lastSibling()
        self.Parameter.InputPanel.gameObject:SetActiveEx(true)
        self.Parameter.AudioPanel.gameObject:SetActiveEx(false)
    end)

    self.Parameter.BtnFace.Listener.onClick = function(obj, eventData)
        self:lastSibling()
        if eventData ~= nil and tostring(eventData:GetType()) == "MoonClient.MPointerEventData" and eventData.Tag == UI.CtrlNames.Multitool then
            return
        end
        local l_openPanelParam = {
            channelType = self.Data.channel,
            needSetPositionMiddle = true,
            inputActionData = {
                inputFunc = function(st)
                    if not self:IsActive() then
                        return
                    end
                    self.Parameter.InputMessage.Input.text = self.Parameter.InputMessage.Input.text .. st
                end,
                inputItemFunc = function(item, hrefType)
                    if not self:IsActive() then
                        return
                    end
                    self.Parameter.InputMessage.Input.text = self.linkInputMgr.AddInputHref(self.Parameter.InputMessage.Input.text, item, hrefType)
                end,
                extraData = {
                    fixationPosX = 130, -- -202
                    fixationPosY = 116.5,
                },
                inputHrefDirectFunc = function(st)
                    self.Parameter.InputMessage.Input.text = st
                end,
            },
        }
        UIMgr:ActiveUI(UI.CtrlNames.Multitool, l_openPanelParam)
    end

    self.Parameter.InputMessage.Input.onSelect = function(eventData)
        self:lastSibling()
        l_txtPlaceHolder.LabText = ""
    end

    self.Parameter.InputMessage.Input.onDeselect = function(eventData)
        l_txtPlaceHolder.LabText = Common.Utils.Lang("CHAT_CLICK_INPUT_HINT")
    end

    self.Parameter.InputMessage:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        --输入字数限制
        local l_maxLenght = self.Data.channel and self.chatDataLuaMgr.GetChatMaxNum(self.Data.channel)
                or tonumber(TableUtil.GetSocialGlobalTable().GetRowByName("FriendMaxNum").Value)
        if l_maxLenght > 0 then
            --表情代码扩充输入上限,表情代码算两个长度
            local l_expand = MoonClient.DynamicEmojHelp.GetInputTextEmojiLength(value);
            if string.ro_len(value) > l_maxLenght + l_expand then
                value = string.ro_cut(value, l_maxLenght + l_expand);
                if LenghtHitTime ~= Time.frameCount then
                    LenghtHitTime = Time.frameCount
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_LIMIT", l_maxLenght))
                end
            end
        end
        self.Parameter.InputMessage.Input.text = value;
    end, true)

    self.Parameter.NewMessageHint:SetActiveEx(false)
    self.Parameter.NewMessageHint:AddClick(function()
        self:lastSibling()
        self.Parameter.NewMessageHint:SetActiveEx(false)
        if not self:canMoveDown() then
            self.ChatTems:ShowTemplates({
                Datas = self.ChatTems.Datas,
                StartScrollIndex = #self.ChatTems.Datas,
                Method = handler(self, self.lastSibling)
            })
        end
        self.Parameter.ChatScroll.LoopScroll:ScrollToCell(#self.ChatTems.Datas - 1, 2000)
    end)

    self:onInitOver()
end

function ShortcutChatPrefab:onForbidPlayerInfosUpdate()
    if self.ChatTems==nil then
        return
    end

    --列出所有消息
    local l_cacheQueue = self.chatDataLuaMgr.GetFilterChannelCache(self.Data.channel)
    local l_msgs = {}
    if l_cacheQueue then
        local l_cacheTable = l_cacheQueue:enumerate()
        for _, msg in pairs(l_cacheTable) do
            if self.chatDataLuaMgr.GetChannelLineTemInfo(msg) then
                table.insert(l_msgs, msg)
            end
        end
    end
    self.ChatTems:ShowTemplates({
        Datas = l_msgs,
        StartScrollIndex=self.ChatTems:GetCellStartIndex(),
        IsNeedShowCellWithStartIndex=false,
        IsToStartPosition=false
    })
end

function ShortcutChatPrefab:canMoveDown(msgPack)
    if self.Parameter.ChatScroll.LoopScroll.Moveing then
        return true
    end
    if self.Parameter.ChatScroll.LoopScroll.m_Dragging then
        return false
    end
    if self.Parameter.ChatScroll.LoopScroll.cellEndIndex ~= self.Parameter.ChatScroll.LoopScroll.totalCount then
        return false
    end
    if self.Parameter.ChatScroll.LoopScroll.content.sizeDelta.y <= self.Parameter.ChatScroll.LoopScroll.transform.sizeDelta.y then
        return true
    end

    local l_maxPos = self.Parameter.ChatScroll.LoopScroll.content.sizeDelta.y - self.Parameter.ChatScroll.LoopScroll.transform.sizeDelta.y
    l_maxPos = l_maxPos - 10
    return self.Parameter.ChatScroll.LoopScroll.content.anchoredPosition.y >= l_maxPos
end

function ShortcutChatPrefab:Update()
    if self.recordObj then
        if self.WaitRecordTime and Time.unscaledTime > self.WaitRecordTime then
            self.CanClick = false
            self.WaitRecordTime = nil
            self.recordObj:OnDown()
        end
        self.recordObj:Update()
    end

    if self.Parameter and self.Parameter.NewMessageHint then
        if self.Parameter.NewMessageHint.gameObject.activeSelf then
            if not self.Parameter.ChatScroll.LoopScroll.Moveing then
                if self:canMoveDown() then
                    self.Parameter.NewMessageHint:SetActiveEx(false)
                    self.Parameter.ChatScroll.LoopScroll:ScrollToCell(#self.ChatTems.Datas - 1, 2000)
                end
            end
        end
    end
end

------------------------
function ShortcutChatPrefab:onInitOver()
    self.recordObj = self.recordObj or UI.ChatRecordObj.new()
    self.recordObj:Init(self.Parameter.AudioBtn):SetChannel(self.Data.channel):SetOnDown(function()
        self:lastSibling()
    end)

    self.ChatTems = self.ChatTems or self:NewTemplatePool({
        ScrollRect = self.Parameter.ChatScroll.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = self.chatDataLuaMgr.GetChannelLineTemInfo,
    })
end
function ShortcutChatPrefab:onCancelBtn()
    if self.mgr.RemoveData(self.Data.uid, self.Data.channel) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SHORTCUT_CHAT_HINT_CANCEL"))--已关闭快捷聊天，可以在聊天设置中再次打开
        if self.Data.channel == self.chatDataLuaMgr.EChannel.TeamChat then
            if Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, 1)) ~= 0 then
                MPlayerSetting.ChatQuickIndex = MPlayerSetting.ChatQuickIndex - Common.Bit32.Lshift(1, 1)
                self.chatMgr.OnChatSettingIndexChange()
            end
        end
        if self.Data.channel == self.chatDataLuaMgr.EChannel.GuildChat then
            if Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, 2)) ~= 0 then
                MPlayerSetting.ChatQuickIndex = MPlayerSetting.ChatQuickIndex - Common.Bit32.Lshift(1, 2)
                self.chatMgr.OnChatSettingIndexChange()
            end
        end
        if self.Data.channel == self.chatDataLuaMgr.EChannel.WatchChat then
            if Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, 3)) ~= 0 then
                MPlayerSetting.ChatQuickIndex = MPlayerSetting.ChatQuickIndex - Common.Bit32.Lshift(1, 3)
                self.chatMgr.OnChatSettingIndexChange()
            end
        end
    end
end

function ShortcutChatPrefab:onSendBtn()
    self:lastSibling()
    if self.Data and self.Data.channel
            and (not MLuaCommonHelper.IsNull(MEntityMgr.PlayerEntity)) then
        local l_uid = MEntityMgr.PlayerEntity.UID
        local l_msg = self.Parameter.InputMessage.Input.text
        local l_channel = self.Data.channel

        if self.chatMgr.SendChatMsgSimple(l_uid, l_msg, l_channel) then
            self.Parameter.InputMessage.Input.text = ""
        end
    end
end
function ShortcutChatPrefab:refreshVoiceBtnState()
    local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)
    self.Parameter.RecordBtn:SetActiveEx(l_chatVoiceOpen)

    local l_inputComSize = self.Parameter.InputMessage.RectTransform.rect.size
    l_inputComSize.x = self.Parameter.Panel_InputAndVoice.RectTransform.rect.size.x
    if l_chatVoiceOpen then
        l_inputComSize.x = l_inputComSize.x - self.Parameter.RecordBtn.RectTransform.rect.size.x
    end
    self.Parameter.InputMessage.RectTransform.sizeDelta = l_inputComSize
end
--lua custom scripts end
return ShortcutChatPrefab