--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainChatPanel"
require "CommonUI/ChatRecordObj"
require "UI/Template/MainChatChannelTem"
require "Common/UI_TemplatePool"
require "Common/CommonScreenPosConverter"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainChatCtrl = class("MainChatCtrl", super)
--lua class define end

--lua functions
function MainChatCtrl:ctor()

    super.ctor(self, CtrlNames.MainChat, UILayer.Normal, nil, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self.newChatMsgTask = nil

    self.noticeBtns = {}
    self.customFuncBtnList = {
        zero_profit = {
            name = "zero_profit",
            condition = function()
                return (MPlayerInfo.ZeroProfitTime - System.DateTime.Now).TotalSeconds > 0
            end,
            callback = function()
                MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerZeroProfitDlg()
            end,
            Atlas = function()
                return MGlobalConfig:GetString("ZeroEarningsAtlas")
            end,
            Sprite = function()
                return MGlobalConfig:GetString("ZeroEarningsIcon")
            end
        }
    }
    self.currentCustomFunc = {}
end --func end
--next--
function MainChatCtrl:Init()
    self.panel = UI.MainChatPanel.Bind(self)
    super.Init(self)
    self.emailMgr = MgrMgr:GetMgr("EmailMgr")
    self.functionButtons = {}
    self.isBig = false
    self.updateFrame = 0
    self.chatDataMgr=DataMgr:GetData("ChatData")
    self.chatMgr=MgrMgr:GetMgr("ChatMgr")
    self.guildMgr = MgrMgr:GetMgr("GuildMgr")
    self.teamMgr = MgrMgr:GetMgr("TeamMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")

    self:initFunctionBtn()
    self:showFunctionWithScene()

    self.panel.BtnChangeChatSize:AddClick(function()
        self.isBig = not self.isBig
        self:extensionMessageBox(self.isBig)
    end)

    self.panel.GMButton.gameObject:SetActiveEx(MGameContext.IsOpenGM)
    self.panel.GMButton:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GM)
    end)

    self.panel.ChannelTem.LuaUIGroup.gameObject:SetActiveEx(false);

    self.panel.BtnFriend:AddClick(function()
        MgrMgr:GetMgr("FriendMgr").OpenCommunity()
    end)


    self.redSignProcessor = self:NewRedSign({
        Key = eRedSignKey.FriendAndEmail,
        ClickButton = self.panel.BtnFriend
    })
    self.redSignProcessor = self:NewRedSign({
        Key = eRedSignKey.FriendAndEmailEx,
        ClickButton = self.panel.BtnFriend
    })
    self.redSignProcessor = self:NewRedSign({
        Key = eRedSignKey.ImportantMail,
        ClickButton = self.panel.BtnFriend
    })

    self.msgPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MainChatChannelTem,
        TemplatePrefab = self.panel.ChannelTem.LuaUIGroup.gameObject,
        ScrollRect = self.panel.MessageBox.LoopScroll,
    })

    -- 单机动作
    self.panel.BtnShowAction:AddClick(function()
        if MEntityMgr.PlayerEntity.IsClimb then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CLIMB_NO_USE"))
        elseif MEntityMgr.PlayerEntity.IsDead then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DEAD_NO_USE"))
        end
        self:onOpenAction()
    end)

    self.panel.BtnEnterChat:AddClick(function()
        self:enterChatPanel()
    end)

    -- 拍照
    local l_sysFuncEventMgr=MgrMgr:GetMgr("SystemFunctionEventMgr")
    local l_funcSysId=MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Camera
    local l_cameraButtonMethod = l_sysFuncEventMgr.GetSystemFunctionEvent(l_funcSysId)
    self.panel.CameraButton:AddClick(l_cameraButtonMethod)

    self:initRecord()
    self.panel.NoticeBtn.UObj:SetActiveEx(false)

    self.panel.SettingBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Chatseting)
    end)

    self:updateViewMode();

    self.panel.Camera3D:AddClick(function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, true);
        self:updateViewMode();
    end)
    self.panel.Camera25D:AddClick(function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, false);
        self:updateViewMode();
    end)

    self.panel.WorldMessageBtn:AddClick(function()
        self.emailMgr.ReadWorldMsg()

        MgrMgr:GetMgr("EmailMgr").OpenEmail()
    end, true)

    self:initSystemBtns()
    self:initMessageContentPos()
end --func end

--next--
function MainChatCtrl:Uninit()
    if self.newChatMsgTask ~= nil then
        self.newChatMsgTask:Stop()
        self.newChatMsgTask = nil
    end
    if self.guildRecordObj ~= nil then
        self.guildRecordObj:Unint()
        self.guildRecordObj = nil
    end
    if self.teamRecordObj ~= nil then
        self.teamRecordObj:Unint()
        self.teamRecordObj = nil
    end
    self.msgPool = nil
    for i, v in ipairs(self.noticeBtns) do
        MResLoader:DestroyObj(v)
    end
    self.noticeBtns = {}
    self.systemBtnMap = {}

    self.redSignProcessor = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function MainChatCtrl:OnActive()
    self.panel.ChatGroupContent.gameObject:SetActiveEx(false)
    self.panel.ChatGroupContent.gameObject:SetActiveEx(true)

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isOpen = l_openSystemMgr.IsSystemOpen(104)
    self.panel.CameraButton.gameObject:SetActiveEx(l_isOpen)

    self:resetMainChat()
    self:updateNoticeBtns()
    self:resetRecordGroup()
    self:showCustomBtn()
    self:resetWorldMsg()
    self:updateImportantRedSignState()

    self.updateCustomFuncTimer = self:NewUITimer(function()
        self:updateCustomBtn()
    end, 1, -1)
    self.updateCustomFuncTimer:Start()
    
    self.panel.TopRoot.gameObject:SetActiveEx(not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator())

    self:_refreshFriendButton()
end --func end
--next--
function MainChatCtrl:OnDeActive()
    if self.updateCustomFuncTimer ~= nil then
        self:StopUITimer(self.updateCustomFuncTimer)
        self.updateCustomFuncTimer = nil
    end

    self:destroyCustomBtn()

end --func end
--next--
function MainChatCtrl:Update()
    if self.guildRecordObj ~= nil then
        self.guildRecordObj:Update()
    end
    if self.teamRecordObj ~= nil then
        self.teamRecordObj:Update()
    end
    if MPlayerDungeonsInfo.InDungeon then
        self.panel.DailyActivityGroup:SetActiveEx(false)
    else
        self.panel.DailyActivityGroup:SetActiveEx(true)
    end
end --func end

--next--
function MainChatCtrl:OnLogout()
    if self.msgPool ~= nil then
        self.msgPool:ShowTemplates({ Datas = {} })
    end
end --func end
--next--
function MainChatCtrl:BindEvents()
    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher,l_logoutMgr.OnLogoutEvent, self.OnLogout)

    self:BindEvent(GlobalEventBus,EventConst.Names.ARENA_MIN_OFFER, function(_self, id)
        self:showNoticeBtn(id)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.ARENA_CLOSE_OFFER, function(_self, id)
        self:removeNoticeBtn(id)
    end)

    --监听聊天事件
    self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg,function(self, msg)
        if not self.chatMgr.CanMainChatShow(msg) then
            return
        end
        --来自公会聊天记录不走这边，走resetMainChat消息
        if msg.isGuideHistoryMsg then
            return
        end
        self:onNewChatMsg(msg)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.ShowMainChatCtrl, function()
        self:resetMainChat()
    end)

    self:BindEvent(GlobalEventBus,EventConst.Names.MAIN_UI_UPDATE_WITH_SCENE, self.onUpdateFuncUI)

    --已经存在的信息显示
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.ResetMainChat, function(self)
        self:resetMainChat()
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.ViewModeChange, function(self)
        self:updateViewMode()
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.Modification, function(self, msgPack)
        local l_tem = self.msgPool:FindShowTem(function(tem)
            return msgPack == tem.msgPack
        end)
        if l_tem then
            l_tem:SetData(msgPack)
        end
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.ClearChat, function(self)
        self:resetMainChat()
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.EnterChatPanel, function(self,channel)
        self:enterChatPanel(channel)
    end)
    self:BindEvent(self.guildMgr.EventDispatcher,self.guildMgr.ON_GET_GUILD_INFO_CHANGE, function(self, data)
        self:resetRecordGroup()
    end)
    self:BindEvent(self.teamMgr.EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, function(self)
        self:resetRecordGroup()
    end)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.ChatSettingIndexChange, function(self)
        self:resetRecordGroup()
    end)
    self:BindEvent(self.openMgr.EventDispatcher,self.openMgr.OpenSystemUpdate, function(self)
        self:onSystemUpdate()
    end)
    self:BindEvent(self.emailMgr.EventDispatcher,self.emailMgr.EventType.WorldMsg, function(self)
        self:resetWorldMsg()
    end)

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openSystemMgr.EventDispatcher,l_openSystemMgr.OpenSystemUpdate, function(self,openIds)
        self:_showFriendButton(openIds)
    end)

    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.CloseSystemEvent, function(self, systemId)
        self:_closeFriendButton(systemId)
    end)

    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.UpdateForbidPlayerInfo,
            self.filterPlayerInfo,self)
    self:BindEvent(self.chatMgr.EventDispatcher,self.chatDataMgr.EEventType.GetForbidPlayerInfoList,
            self.filterPlayerInfo,self)

    local l_redSignCheckMgr = MgrMgr:GetMgr("RedSignCheckMgr")
    self:BindEvent(l_redSignCheckMgr.EventDispatcher,l_redSignCheckMgr.EventType.RedSignStateChanged,
            self.onRedSignStateChanged,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function MainChatCtrl:OnShow()
end
function MainChatCtrl:onRedSignStateChanged(key,count)
    if eRedSignKey.ImportantMail~=key then
        return
    end
    self:updateImportantRedSignState()
end
function MainChatCtrl:updateImportantRedSignState()
    local l_showImportantRedSign = MgrMgr:GetMgr("RedSignMgr").IsRedSignShow(eRedSignKey.ImportantMail)
    self.panel.Btn_Notice:SetActiveEx(l_showImportantRedSign)
end
function MainChatCtrl:showNoticeBtn(id)
    if not self.noticeBtns[id] then
        self.noticeBtns[id] = self:CloneObj(self.panel.NoticeBtn.UObj)
    end
    local btn = self.noticeBtns[id]
    btn:GetComponent("MLuaUICom").RectTransform:SetAsLastSibling()
    btn:SetActiveEx(true)
    btn.transform:SetParent(self.panel.DailyActivityGroup.transform, false)
    btn:GetComponent("MLuaUICom"):AddClick(function()
        ---特判:公会匹配赛观战;
        if id == MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatchWatch then
            UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
                ctrl:ShowContentWithoutCountdown(Lang("GUILD_MATCH_WATCH_OFFER", DataMgr:GetData("GuildMatchData").NowMatchRound),
                        MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatchWatch, true, Lang("WATCH_NOW"))
            end)
            return
        end
        local battleTime = MgrMgr:GetMgr("DailyTaskMgr").GetBattleTime(id)
        if battleTime ~= MServerTimeMgr.UtcSeconds then
            local noticeTime = math.max(0, battleTime - Common.TimeMgr.GetNowTimestamp())
            MgrMgr:GetMgr("DailyTaskMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("DailyTaskMgr").DAILY_ACTIVITY_SHOW_NOTICE_EVENT, noticeTime, id)
        end
    end)
end

function MainChatCtrl:removeNoticeBtn(id)
    if self.noticeBtns[id] then
        MResLoader:DestroyObj(self.noticeBtns[id])
        self.noticeBtns[id] = nil
    end
end

function MainChatCtrl:updateNoticeBtns()
    MgrMgr:GetMgr("DailyTaskMgr").OnNoticeCheck()
    for id, v in pairs(self.noticeBtns) do
        MResLoader:DestroyObj(self.noticeBtns[id])
    end
    self.noticeBtns = {}
    for id, _ in pairs(MgrMgr:GetMgr("DailyTaskMgr").g_activityNotices) do
        self:showNoticeBtn(id)
    end
end

function MainChatCtrl:initFunctionBtn()
    self.functionButtons["BtnShowAction"] = self.panel.BtnShowAction.gameObject
    self.functionButtons["CameraButton"] = self.panel.CameraButton.gameObject
end

function MainChatCtrl:initMessageContentPos()

    --获取安全区域的偏移
    self.chatContentOffsetY = tonumber(Common.CommonScreenPosConverter.GetScreenOffset())

    self.isBig = false

    self:extensionMessageBox()
end

function MainChatCtrl:showFunctionWithScene()
    array.veach(self.functionButtons, function(v)
        if v then
            v:SetActiveEx(false)
        end
    end)

    local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
    local l_h1 = l_MainUiTableData.ExtraUi
    local l_ExtraUis = Common.Functions.VectorToTable(l_h1)
    for i, uiName in ipairs(l_ExtraUis) do
        if self.functionButtons[uiName] then
            self.functionButtons[uiName]:SetActiveEx(true)
        end
    end
end

------------------------------------录音组件

function MainChatCtrl:initRecord()
    self.guildRecordObj = UI.ChatRecordObj.new()
    self.guildRecordObj:Init(self.panel.GuideRecordBtn):SetChannel(self.chatDataMgr.EChannel.GuildChat)
    self.teamRecordObj = UI.ChatRecordObj.new()
    self.teamRecordObj:Init(self.panel.TeamRecordBtn):SetChannel(self.chatDataMgr.EChannel.TeamChat)

    self:resetRecordGroup()
end

function MainChatCtrl:resetRecordGroup()
    local l_hasTeam = DataMgr:GetData("TeamData").myTeamInfo.isInTeam
    local l_hasGuild = self.guildMgr.IsSelfHasGuild()
    local l_bitTeam = Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, 1)) == 0
    local l_bitGuild = Common.Bit32.And(MPlayerSetting.ChatQuickIndex, Common.Bit32.Lshift(1, 2)) == 0
    local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)

    self.panel.GuideRecordObj.gameObject:SetActiveEx(l_hasGuild)
    self.panel.GuideRecordMain.gameObject:SetActiveEx(l_chatVoiceOpen and l_hasGuild and l_bitGuild )
    self.panel.TeamRecordObj.gameObject:SetActiveEx(l_hasTeam)
    self.panel.TeamRecordMain.gameObject:SetActiveEx(l_chatVoiceOpen and l_hasTeam and l_bitTeam)
end

function MainChatCtrl:resetWorldMsg()
    self.panel.WorldMessageBtn:SetActiveEx(self.emailMgr.ShowWorldMsg and true)
end

function MainChatCtrl:showCustomBtn()
    for name, funcBtn in pairs(self.customFuncBtnList) do
        if funcBtn.condition() then
            logGreen("funcBtn.condition()" .. tostring(funcBtn.condition()))
            local l_newBtn = MResLoader:CloneObj(self.panel.CustomBtnInstance.gameObject)
            local l_com = l_newBtn:GetComponent("MLuaUICom")
            local l_callback = funcBtn.callback
            l_newBtn.transform:SetParent(self.panel.CustomBtnInstance.transform.parent)
            l_newBtn:SetLocalScaleOne()
            l_newBtn:SetActive(true)
            self.currentCustomFunc[name] = l_newBtn
            l_com:SetSprite(funcBtn.Atlas(), funcBtn.Sprite())
            l_com:AddClick(function()
                l_callback()
            end)
        end
    end
end

function MainChatCtrl:updateCustomBtn()
    for name, btn in pairs(self.currentCustomFunc) do
        local l_btninfo = self.customFuncBtnList[name]
        if not l_btninfo.condition() then
            MResLoader:DestroyObj(btn)
            self.currentCustomFunc[name] = nil
        end
    end
end

function MainChatCtrl:destroyCustomBtn()
    for name, btn in pairs(self.currentCustomFunc) do
        MResLoader:DestroyObj(btn)
        self.currentCustomFunc[name] = nil
    end
    self.currentCustomFunc = {}
end
------------------------左侧按钮------------------------------
------------------------消息栏--------------------------------

--扩大MessageBox
function MainChatCtrl:extensionMessageBox()
    local time = 0.5

    local l_messageContentMaxHeight = 210
    local l_messageContentMinHeight = 107
    local l_messageBoxMaxHeight = l_messageContentMaxHeight - self.chatContentOffsetY
    local l_messageBoxMinHeight = l_messageContentMinHeight - self.chatContentOffsetY
    local l_messageContentHeight = 0
    --self:updateMessageBoxPosInfo(l_messageBoxMaxHeight,l_messageBoxMinHeight)

    if self.isBig then
        if self.panel.ChatGroupContent.RectTransform.rect.height < l_messageBoxMaxHeight then
            self:updateMessageBoxPosInfo(l_messageBoxMaxHeight,l_messageBoxMinHeight)
        end
        l_messageContentHeight = l_messageContentMaxHeight
        self.panel.BtnChangeChatSize.RectTransform:SetLocalScale(1, -1, 1)
    else
        l_messageContentHeight = l_messageContentMinHeight
        self.panel.BtnChangeChatSize.RectTransform:SetLocalScale(1, 1, 1)
    end
    local l_messageBoxSize = self.panel.MessageBox.RectTransform.rect.size

    MUITweenHelper.TweenRectTrans(self.panel.MessageContent.UObj, l_messageBoxSize.x,l_messageBoxSize.x,self.panel.MessageContent.RectTransform.rect.size.y
    , l_messageContentHeight, time, function()
                if self.panel.ChatGroupContent.RectTransform.rect.height <= l_messageBoxMaxHeight and
                        self.panel.ChatGroupContent.RectTransform.rect.height >= l_messageBoxMinHeight then
                    if not self.isBig then
                        self.panel.MessageBox.RectTransform.sizeDelta = self:getTempVector2(l_messageBoxSize.x,l_messageBoxMinHeight)
                    end
                end
                self:updateMessageBoxPosInfo(l_messageBoxMaxHeight,l_messageBoxMinHeight)
                self:updateDialogPosition()
            end)
    self.panel.TopRoot.transform:DOAnchorPosY(l_messageContentHeight +5, time)
end
---@Description:获得一个临时的Vector2结构数据，“随用随取”，不能用来存储数据
function MainChatCtrl:getTempVector2(posX,posY)
    if self.tempVector2Pos==nil then
        self.tempVector2Pos = Vector2.zero
    end
    self.tempVector2Pos.x = posX
    self.tempVector2Pos.y = posY
    return self.tempVector2Pos
end
function MainChatCtrl:updateMessageBoxPosInfo(messageBoxMaxHeight,messageBoxMinHeight)
    local l_currentMaxMsgBoxHeight = 0

    if self.isBig then
        l_currentMaxMsgBoxHeight = messageBoxMaxHeight
    else
        l_currentMaxMsgBoxHeight = messageBoxMinHeight
    end

    local l_messageBoxSize = self.panel.MessageBox.RectTransform.rect.size
    local l_currentChatContentHeight = self.panel.ChatGroupContent.RectTransform.rect.height
    if l_currentChatContentHeight <= l_currentMaxMsgBoxHeight  then
        local l_messageBoxPos = self:getTempVector2(0.5,1)
        self.panel.MessageBox.RectTransform.pivot = l_messageBoxPos
        self.panel.MessageBox.RectTransform.anchorMin = l_messageBoxPos
        self.panel.MessageBox.RectTransform.anchorMax = l_messageBoxPos
        --- 扩张状态下、聊天框大于缩小时框大小 、小于放大时大小，锚点数据会变更，需要更新位置
        if self.isBig and l_currentChatContentHeight > messageBoxMinHeight then
            self.panel.MessageBox.RectTransform.sizeDelta = self:getTempVector2(l_messageBoxSize.x, messageBoxMaxHeight)
            self:updateDialogPosition()
        end
        self.panel.MessageBox.RectTransform.anchoredPosition = self:getTempVector2(0,0)
    else
        local l_messageBoxPos = self:getTempVector2(0.5,0)
        self.panel.MessageBox.RectTransform.pivot = l_messageBoxPos
        self.panel.MessageBox.RectTransform.anchorMin = l_messageBoxPos
        self.panel.MessageBox.RectTransform.anchorMax = l_messageBoxPos
        local l_preferredMsgBoxHeight = l_currentMaxMsgBoxHeight
        --- 扩张状态下、聊天框大于放大时大小，MessageBox应保持最大大小
        if l_currentChatContentHeight > messageBoxMaxHeight then
            l_preferredMsgBoxHeight = messageBoxMaxHeight
        end
        self.panel.MessageBox.RectTransform.sizeDelta = self:getTempVector2(l_messageBoxSize.x, l_preferredMsgBoxHeight)
        self.panel.MessageBox.RectTransform.anchoredPosition = self:getTempVector2(0,self.chatContentOffsetY)
    end
end

function MainChatCtrl:onOpenAction()
    if UIMgr:IsActiveUI(UI.CtrlNames.SelectElement) then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
        ctrl:RemoveAllHandler()
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
        ctrl:SetupHandlers()
    end)
end

-------------------------消息栏-------------------------------
------------------------事件处理------------------------------
function MainChatCtrl:resetMainChat()
    if not self.panel.ChatGroupContent.gameObject.activeInHierarchy then
        return
    end
    if self.msgPool == nil then
        return
    end
    --已经存在的信息显示
    local l_cacheQueue = self.chatDataMgr.GetChannelCache(self.chatDataMgr.EChannel.AllChat)
    local l_cacheTable = l_cacheQueue:enumerate()
    local l_datas = {}
    for _, v in pairs(l_cacheTable) do
        l_datas[#l_datas + 1] = v
    end
    self.msgPool.ScrollRect:StopAllCoroutines()
    self.msgPool:ShowTemplates({
        Datas = l_datas,
        StartScrollIndex = #l_datas,
    })
end
function MainChatCtrl:filterPlayerInfo()
    if self.msgPool == nil then
        return
    end
    --已经存在的信息显示
    local l_cacheQueue,l_has = self.chatDataMgr.GetFilterChannelCache(self.chatDataMgr.EChannel.AllChat)
    local l_cacheTable = l_cacheQueue:enumerate()
    local l_datas = {}
    for _, v in pairs(l_cacheTable) do
        l_datas[#l_datas + 1] = v
    end
    self.msgPool.ScrollRect:StopAllCoroutines()
    self.msgPool:ShowTemplates({
        Datas = l_datas,
        StartScrollIndex = self.msgPool:GetCellStartIndex(),
        IsNeedShowCellWithStartIndex=false,
        IsToStartPosition=false
    })
end
function MainChatCtrl:GetButton(openSystemID)
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr");
    if openSystemID == openSystemMgr.eSystemId.Camera then
        local btn = {}
        btn.openSystemId = openSystemID
        btn.gameObject = function()
            return self.panel.CameraButton.UObj
        end
        btn.transform = function()
            return self.panel.CameraButton.UObj.transform
        end
        btn.ShowButton = function(_self, isShow)
            if isShow then
                isShow = openSystemMgr.IsSystemOpen(btn.openSystemId);
            end
            btn.gameObject():SetActiveEx(isShow)
        end
        return btn
    else
        logError(StringEx.Format("MainChatCtrl:GetButton invalid special open id:{0}", openSystemID))
    end
end

--当收到信消息的时候
function MainChatCtrl:onNewChatMsg(msg)
    if not self:IsActive() then
        return
    end
    if not self.panel.ChatGroupContent.gameObject.activeInHierarchy then
        return
    end

    --超出数量的干掉
    local l_maxCount = self.chatDataMgr.GetLocalCacheNum(self.chatDataMgr.EChannel.AllChat)

    if #self.msgPool.Datas < l_maxCount then
        self.msgPool:AddTemplate(msg)
    else
        table.insert(self.msgPool.Datas, msg)
        local l_overproof = #self.msgPool.Datas - l_maxCount
        for i = 1, l_overproof do
            table.remove(self.msgPool.Datas, 1)
        end
    end
    self:updateChatDialog()
end

function MainChatCtrl:updateChatDialog()
    local l_messageContentMaxHeight = 210
    local l_messageContentMinHeight = 107
    local l_messageBoxMaxHeight = l_messageContentMaxHeight - self.chatContentOffsetY
    local l_messageBoxMinHeight = l_messageContentMinHeight - self.chatContentOffsetY
    self:updateMessageBoxPosInfo(l_messageBoxMaxHeight,l_messageBoxMinHeight)
    self:updateDialogPosition()
end

function MainChatCtrl:updateDialogPosition()
    if self.panel == nil then
        return
    end
    if not self.panel.ChatGroupContent.gameObject.activeInHierarchy then
        return
    end
    if #self.msgPool.Datas > 0 then
        self.msgPool:ShowTemplates({Datas=self.msgPool.Datas,StartScrollIndex=#self.msgPool.Datas})
    end
end
function MainChatCtrl:updateViewMode()
    if MPlayerSetting.Is3DViewMode then
        self.panel.Camera3D:SetActiveEx(false);
        self.panel.Camera25D:SetActiveEx(true);
    else
        self.panel.Camera3D:SetActiveEx(true);
        self.panel.Camera25D:SetActiveEx(false);
    end
end
function MainChatCtrl:onUpdateFuncUI()
    self:showFunctionWithScene()
end

function MainChatCtrl:enterChatPanel(channel)
    UIMgr:ActiveUI(UI.CtrlNames.Chat,{ needChangeToCurrentChannel = true })
    UIMgr:HideUI(CtrlNames.MainChat)
end

function MainChatCtrl:initSystemBtns()
    self.systemBtnMap = {}
    self.systemBtnMap[self.openMgr.eSystemId.Camera] = self.panel.CameraButton.gameObject
end

function MainChatCtrl:onSystemUpdate()
    self:resetRecordGroup()
    if not self.systemBtnMap then return end

    for k, v in pairs(self.systemBtnMap) do
        v:SetActiveEx(self.openMgr.IsSystemOpen(k))
    end
end

function MainChatCtrl:_showFriendButton(openIds)
    if openIds == nil then
        return
    end
    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    for i = 1, #openIds do
        if openIds[i].value == l_openSystemMgr.eSystemId.Friend or openIds[i].value == l_openSystemMgr.eSystemId.Email then
            self.panel.BtnFriend:SetActiveEx(true)
            return
        end
    end

end
function MainChatCtrl:_closeFriendButton(closeId)
    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    if closeId ~= l_openSystemMgr.eSystemId.Friend and closeId ~= l_openSystemMgr.eSystemId.Email then
        return
    end
    self:_refreshFriendButton()
end
function MainChatCtrl:_refreshFriendButton()
    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    local l_isFriendOpen=l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Friend)
    local l_isEmailOpen=l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Email)
    if l_isFriendOpen or l_isEmailOpen then
        self.panel.BtnFriend:SetActiveEx(true)
    else
        self.panel.BtnFriend:SetActiveEx(false)
    end
end
------------------------事件处理------------------------------

--lua custom scripts end
return MainChatCtrl