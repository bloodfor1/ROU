--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildHuntInfoPanel"
require "UI/Template/ItemTemplate"
require "UI.Template/GHBuffTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_guildData = nil
local l_guildHuntMgr
local l_timer                               --计时器
local l_selectDungeonInfo                   --当前选中的难度副本
local l_effect                              --特效
local l_effectPath_close = "Effects/Prefabs/Creature/Ui/Fx_Ui_BaoXiang_01"
local l_effectPath_open = "Effects/Prefabs/Creature/Ui/Fx_Ui_BaoXiang_02"
local l_effectPath_add = "Effects/Prefabs/Creature/Ui/Fx_Ui_TiShi_01"
local l_DiffcultData = {"EASY", "NORMAL", "HARD", "GET_ERROR_FROM_SERVER"}
--next--
--lua fields end

--lua class define
GuildHuntInfoCtrl = class("GuildHuntInfoCtrl", super)
--lua class define end

--lua functions
function GuildHuntInfoCtrl:ctor()

    super.ctor(self, CtrlNames.GuildHuntInfo, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent

end --func end
--next--
function GuildHuntInfoCtrl:Init()

    self.panel = UI.GuildHuntInfoPanel.Bind(self)
    super.Init(self)
    l_guildData = DataMgr:GetData("GuildData")
    l_guildHuntMgr = MgrMgr:GetMgr("GuildHuntMgr")
    --self:SetBlockOpt(BlockColor.Transparent)
    self.isDragging = false
    self.scrollRect = self.panel.RingScrollView.gameObject:GetComponent("MoonClient.MRingScrollRect")

    --活动奖励列表项的池创建
    self.awardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.AwardScrollView.LoopScroll
    })
    --副本奖励列表项的池创建
    self.dungeonsAwardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.DungeonsAwardScrollView.LoopScroll
    })
    --BUFF列表项的池创建
    self.buffTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GHBuffTemplate,
        TemplatePrefab = self.panel.GHBuffPrefab.gameObject,
        ScrollRect = self.panel.BuffScrollView.LoopScroll
    })
    self.panel.GHBuffPrefab.gameObject:SetActiveEx(false)
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildHuntInfo)
    end)
    --解释界面点击关闭
    self.panel.BtnCloseExplain:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
    end)

    self.panel.Describe.LabText = Lang("GUILDHUNT_DESCRIBE")

end --func end
--next--
function GuildHuntInfoCtrl:Uninit()

    if self.scrollRect then
        self.scrollRect.OnStartDrag=nil
        self.scrollRect.OnEndDrag=nil
        self.scrollRect.OnItemIndexChanged=nil
        self.scrollRect.onInitItem=nil
        self.scrollRect=nil
    end
    self.isDragging = nil
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    --特效销毁
    if l_effect ~= nil then
        self:DestroyUIEffect(l_effect)
        l_effect = nil
    end

    l_selectDungeonInfo = nil
    self.awardTemplatePool = nil
    self.dungeonsAwardTemplatePool = nil
    self.buffTemplatePool = nil

    l_guildData = nil
    l_guildHuntMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildHuntInfoCtrl:OnActive()

    l_guildHuntMgr.ReqGetGuildHuntInfo()
    l_guildHuntMgr.ReqGuildHuntFindTeamMate()

end --func end
--next--
function GuildHuntInfoCtrl:OnDeActive()

end --func end
--next--
function GuildHuntInfoCtrl:Update()

end --func end

function GuildHuntInfoCtrl:OnShow()

end
--next--
function GuildHuntInfoCtrl:BindEvents()

    --公会狩猎信息获取后事件，刷新界面（开启or关闭）
    self:BindEvent(l_guildHuntMgr.EventDispatcher, l_guildHuntMgr.ON_GET_GUILD_HUNT_INFO, function(self)
        if l_guildData.guildHuntInfo.state == 0 then
            self:ShowContent_NotOpen()
        else
            self:ShowContent_Open()
        end
    end)
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG, function(object, ...)
        self:GetPreviewAwards(...)
    end)
    --被踢出回调
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher,MgrMgr:GetMgr("GuildMgr").ON_GUILD_KICKOUT, function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildHuntInfo)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
-----------------------------------------------------------------------------------------
--==========================以下是活动未开启时界面相关函数==================================
-----------------------------------------------------------------------------------------
--活动未开启时的内容展示
function GuildHuntInfoCtrl:ShowContent_NotOpen()

    --显示的界面控制
    self.panel.HuntNotOpen.UObj:SetActiveEx(true)
    self.panel.HuntOpen.UObj:SetActiveEx(false)

    --开启时间
    local l_openTimeStr = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingOpenTime").Value
    local l_openTimeGroup = string.ro_split(l_openTimeStr, "=")
    self.panel.OpenTimeText.LabText = StringEx.Format("{0}~{1}",
        self:GetOpenTimeFromStr(l_openTimeGroup[1]), self:GetOpenTimeFromStr(l_openTimeGroup[2]))

    --剩余次数
    self.panel.AvailableTimesText.LabText = StringEx.Format("{0} / {1}",
        l_guildData.guildHuntInfo.maxTimes_open - l_guildData.guildHuntInfo.usedTimes_open,
        l_guildData.guildHuntInfo.maxTimes_open)
    if l_effect ~= nil then
        self:DestroyUIEffect(l_effect)
        l_effect = nil
    end
    self.panel.AddRaw:SetActiveEx(false)
    self.panel.BtnAdd:SetActiveEx(l_guildData.guildHuntInfo.add == l_guildData.EHuntExCount.None)
    if l_guildData.guildHuntInfo.maxTimes_open - l_guildData.guildHuntInfo.usedTimes_open == 0 and l_guildData.guildHuntInfo.add ~= l_guildData.EHuntExCount.NoneExtra then
        self.panel.AddRaw:SetActiveEx(true)
        l_fxViewCom = self.panel.AddRaw
        l_fxPath = l_effectPath_add
        local l_fxData_effect = {}
        l_fxData_effect.rawImage = l_fxViewCom.RawImg
        l_fxData_effect.loadedCallback = function(a) l_fxViewCom.gameObject:SetActiveEx(true) end
        l_fxData_effect.destroyHandler = function()
            l_effect = nil
        end
        l_effect = self:CreateUIEffect(l_fxPath, l_fxData_effect)
    end
    --活动奖励数据预览获取
    local l_dailyActivityInfo = TableUtil.GetDailyActivitiesTable().GetRowById(
        MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildHunt)
    if l_dailyActivityInfo then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_dailyActivityInfo.AwardText)
    end

    --设置开启按钮样式
    self:SetOpenButtonStyle()

    --开启按钮点击事件添加
    self.panel.BtnOpen:AddClick(function()
        if l_guildData.guildHuntInfo.cdTime > 0 then
            --通知还在Cd
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ACTIVITY_IS_IN_CODE_TIME_COME_TOMORROW"))
        else
            if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then
                --非 会长/副会长 则联系会长
                --私聊接入
                local l_chairmanInfo = l_guildData.guildBaseInfo.chairman.base_info
                MgrMgr:GetMgr("FriendMgr").AddTemporaryContacts(l_chairmanInfo)

                MgrMgr:GetMgr("FriendMgr").OpenFriendAndSetUID(l_chairmanInfo.role_uid)
            else
                --会长/副会长 开启副本
                --判断次数
                if l_guildData.guildHuntInfo.usedTimes_open >= l_guildData.guildHuntInfo.maxTimes_open then
                    if l_guildData.guildHuntInfo.add == l_guildData.EHuntExCount.None then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_HUNT_OPEN_TIMES_NEED_ADD"))
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_HUNT_OPEN_TIMES_IS_OVER"))
                    end
                    return
                end
                local l_minLevel = TableUtil.GetOpenSystemTable().GetRowById(
                    MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GuildHunt).BaseLevel
                if MPlayerInfo.Lv < l_minLevel then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILDHUNT_NOT_OPEN", l_minLevel))
                    return
                end
                --请求开启 开启时间客户端会有误差 让服务器验证
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SECOND_CHECK_OPEN_GUILD_HUNT"),
                    function()
                        l_guildHuntMgr.ReqOpenHuntActivity()
                    end, nil, 20)
            end
        end
    end)
    self.panel.BtnAdd:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildHuntInfo)
        UIMgr:ActiveUI(UI.CtrlNames.GuildBook)
    end)

    --未开启界面帮助按钮点击事件
    self.panel.BtnInfoHelp:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingGameTips").Value)
        end)
    end)

end

--通过字符串获取开启时间
function GuildHuntInfoCtrl:GetOpenTimeFromStr(str)

    local l_num = tonumber(str)
    local l_hour = math.floor(l_num / 10000)
    l_num = l_num % 10000
    local l_minuite = math.floor(l_num / 100)
    return StringEx.Format("{0}:{1}", self:GetDoubleDigitTimeStr(l_hour), self:GetDoubleDigitTimeStr(l_minuite))

end

--设置开启按钮样式
function GuildHuntInfoCtrl:SetOpenButtonStyle()

    if l_guildData.guildHuntInfo.cdTime > 0 then
        --有CD时
        self.panel.NextOpenCountDown.UObj:SetActiveEx(true)
        --原计时器清理
        if l_timer then
            self:StopUITimer(l_timer)
            l_timer = nil
        end
        --剩余时间展示
        local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildHuntInfo.cdTime)
        self.panel.NextOpenCountDown.LabText = Lang("NEXT_OPEN_CD_COUNT_DOWN",
            self:GetDoubleDigitTimeStr(l_day * 24 + l_hour),
            self:GetDoubleDigitTimeStr(l_minuite),
            self:GetDoubleDigitTimeStr(l_second))
        --设置新的计时器
        l_timer = self:NewUITimer(function()
            l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildHuntInfo.cdTime)
            self.panel.NextOpenCountDown.LabText = Lang("NEXT_OPEN_CD_COUNT_DOWN",
                self:GetDoubleDigitTimeStr(l_day * 24 + l_hour),
                self:GetDoubleDigitTimeStr(l_minuite),
                self:GetDoubleDigitTimeStr(l_second))
            if l_guildData.guildHuntInfo.cdTime <= 0 and l_timer then
                self:SetOpenButtonStyle()  --CD时间到后重新设置按钮
                self:StopUITimer(l_timer)
                l_timer = nil
            end
            l_guildData.guildHuntInfo.cdTime = l_guildData.guildHuntInfo.cdTime - 1
        end, 1, -1, true)
        l_timer:Start()
        --按钮置灰
        self.panel.BtnOpen:SetGray(true)
        self.panel.BtnOpenText:SetOutLineColor(Color.New(118/255.0, 118/255.0, 118/255.0, 0.5))
    else
        --无CD时
        if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then
            --非 会长/副会长 显示等待开启
            self.panel.NextOpenCountDown.UObj:SetActiveEx(true)
            self.panel.NextOpenCountDown.LabText = Lang("WAIT_OPEN")
        else
            --会长/副会长 开启按钮上啥都不显示
            self.panel.NextOpenCountDown.UObj:SetActiveEx(false)
        end
        --按钮取消置灰
        self.panel.BtnOpen:SetGray(false)
        self.panel.BtnOpenText:SetOutLineColor(Color.New(58/255.0, 96/255.0, 158/255.0, 1))
    end

    --按钮文字显示
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then
        --非 会长/副会长 提醒会长
        self.panel.BtnOpenText.LabText = Lang("REMIND_CHAIRMAN")
    else
        --会长/副会长 开启副本
        self.panel.BtnOpenText.LabText = Lang("OPEN_ACTIVITY")
    end

end

-----------------------------------------------------------------------------------------
--==========================以下是活动开启时界面相关函数===================================
-----------------------------------------------------------------------------------------
--活动开启时的内容展示
function GuildHuntInfoCtrl:ShowContent_Open()

    --显示的界面控制
    self.panel.HuntNotOpen.UObj:SetActiveEx(false)
    self.panel.HuntOpen.UObj:SetActiveEx(true)

    --设置进度相关信息  （进度条 副本按钮 宝箱）
    self:SetProgressInfo()
    --设置简易排行榜信息  （前5名排名 查看排行榜按钮）
    self:SetSimpleLeaderboard()
    --设置活动信息  （剩余奖励次数 剩余时间 前往按钮）
    self:SetActivityInfo()

    --活动开启界面帮助按钮点击事件
    self.panel.BtnProgressHelp:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingGameTips").Value)
        end)
        --[[self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainText.LabText = Lang("GUILD_HUNT_HELP_INFO_OPEN")
        self.panel.ExplainBubble.RectTransform.pivot = Vector2.New(0, 1)
        local l_worldPos = self.panel.BtnProgressHelp.Transform.position
        local l_viewPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.ExplainPanel.Transform)
        self.panel.ExplainBubble.RectTransform.anchoredPosition = Vector2.New(l_viewPos.x + 20, l_viewPos.y + 15)]]
    end)

end

--设置进度相关信息（进度条、副本按钮、宝箱）
function GuildHuntInfoCtrl:SetProgressInfo()

    local l_allBossNum = 0  --总体所有BOSS数量
    local l_curFinishNum = 0  --目前已完成的BOSS数量
    local l_resData = {}  --副本资源数据

    --遍历所有的副本数据 获取进度相关信息
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        local l_temp = l_guildData.guildHuntInfo.dungeonList[i]
        --计算进度总数
        if l_temp.max_count ~= -1 then  --副本通用机制 -1表示无上限 不用统计
            l_allBossNum = l_allBossNum + l_temp.max_count
            l_curFinishNum = l_curFinishNum + l_temp.cur_count
        end
        l_resData[i] = TableUtil.GetGuildHuntConfigTable().GetRowByDifficulty(l_temp.type + 1)
        if not l_resData[i] then
            logError("GuildHuntConfigTable找不到对应副本的资源数据！！！@策划")
            break
        end
        l_resData[i].maxCount = l_temp.max_count
        l_resData[i].curCount = l_temp.cur_count
        l_resData[i].serverData = l_temp
        if not l_selectDungeonInfo then
            self:SelectDifficultDungeon(l_temp, l_resData[i].Description)
        end
    end

    --加载UI资源
    self.scrollRect:SetSensitive(1.6)
    self.scrollRect.OnStartDrag = function()
        self.isDragging = true
    end
    self.scrollRect.OnEndDrag = function()
        self.isDragging = false
    end
    self.scrollRect.OnItemIndexChanged = function()
        if self.scrollRect ~= nil then
            self:SelectDifficultDungeon(l_resData[self.scrollRect.CurItemIndex + 1].serverData,
            l_resData[self.scrollRect.CurItemIndex + 1].Description)
        end
    end
    self.scrollRect.onInitItem = function(go, index)
        local l_data = l_resData[index + 1]
        local l_slider = go.transform:Find("Slider")
        local l_icon = go.transform:Find("DungeonsIcon")
        local l_diff = go.transform:Find("DifficultText")
        local l_aim = go.transform:Find("AimText")
        local l_count = go.transform:Find("CountText")
        local l_pass = go.transform:Find("Success")
        l_icon:GetComponent("MLuaUICom"):SetSprite(l_data.Atlas, l_data.Pic)
        l_slider:GetComponent("MLuaUICom").Img.fillAmount = l_data.curCount / l_data.maxCount
        l_pass:GetComponent("MLuaUICom").gameObject:SetActiveEx(l_data.curCount == l_data.maxCount)
        l_diff:GetComponent("MLuaUICom").LabText = Lang(l_DiffcultData[l_data.Difficulty])
        if l_data.maxCount == -1 then
            l_aim:GetComponent("MLuaUICom").LabText = Lang("NO_LIMIT")
            l_count:GetComponent("MLuaUICom").gameObject:SetActiveEx(true)
            l_count:GetComponent("MLuaUICom").LabText = Lang("EDEN_TASK_FINISHED") .. ": " .. l_data.curCount
        else
            l_aim:GetComponent("MLuaUICom").LabText = string.format("%d/%d", l_data.curCount, l_data.maxCount)
            l_count:GetComponent("MLuaUICom").gameObject:SetActiveEx(false)
        end
    end
    self.scrollRect:SetCount(#l_resData)
    self.panel.LeftArrow:AddClick(function()
        local index = self.scrollRect.CurItemIndex
        if index == 0 then
            index = #l_resData - 1
        else
            index = index - 1
        end
        self.scrollRect:SelectIndex(index, true)
    end)
    self.panel.RightArrow:AddClick(function()
        local index = self.scrollRect.CurItemIndex
        if index == #l_resData - 1 then
            index = 0
        else
            index = index + 1
        end
        self.scrollRect:SelectIndex(index, true)
    end)

    --进度展示
    self.panel.ProgressText.LabText = Lang("CURRENT_EACH_AREA_BOSS_NUM_PROGRESS", l_curFinishNum, l_allBossNum)
    self.panel.ProgressSlider.Slider.value = l_curFinishNum / l_allBossNum

    --宝箱相关
    --宝箱原特效清理
    if l_effect ~= nil then
        self:DestroyUIEffect(l_effect)
        l_effect = nil
    end
    --宝箱展示
    if l_curFinishNum < l_allBossNum then
        --未完成所有目标时
        self.panel.AwardBoxClose:SetGray(true)
        self.panel.AwardBoxClose.UObj:SetActiveEx(true)
        self.panel.AwardBoxOpen.UObj:SetActiveEx(false)
        self.panel.FxViewOpen.UObj:SetActiveEx(false)
        self.panel.FxViewClose.UObj:SetActiveEx(false)
    else
        --完成所有目标时
        self.panel.AwardBoxClose:SetGray(false)
        self.panel.AwardBoxClose.UObj:SetActiveEx(not l_guildData.guildHuntInfo.isGetFinalReward)
        self.panel.AwardBoxOpen.UObj:SetActiveEx(l_guildData.guildHuntInfo.isGetFinalReward)
        --宝箱特效
        local l_fxViewCom
        local l_fxPath
        if l_guildData.guildHuntInfo.isGetFinalReward then
            --l_fxViewCom = self.panel.FxViewOpen
            --l_fxPath = l_effectPath_open
            --logYellow("策划说不要播放宝箱打开的特效")
        else
            l_fxViewCom = self.panel.FxViewClose
            l_fxPath = l_effectPath_close
            local l_fxData_effect = {}
            l_fxData_effect.rawImage = l_fxViewCom.RawImg
            l_fxData_effect.loadedCallback = function(a) l_fxViewCom.gameObject:SetActiveEx(true) end
            l_fxData_effect.destroyHandler = function()
                l_effect = nil
            end
            l_effect = self:CreateUIEffect(l_fxPath, l_fxData_effect)
        end
    end

    --宝箱点击事件
    self.panel.BtnAwardBox:AddClick(function()
        if l_curFinishNum < l_allBossNum then
            --目标未完成时   狩猎目标未完成，无法领取奖励
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_HUNT_AIM_IS_NOT_ACHIEVED"))
        elseif l_guildData.guildHuntInfo.usedTimes_reward == 0 then
            --没有参加过活动   你未参与此次狩猎，无法领取奖励
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ATTEND_GUILD_HUNT_ACTIVITY"))
        elseif l_guildData.guildHuntInfo.state ~= 2 then
            --活动还未结束   请等待活动结束时再来领取奖励
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_HUNT_ACTIVITY_IS_NOT_OVER"))
        elseif l_guildData.guildHuntInfo.isGetFinalReward then
            --已领取过奖励   你已领取过狩猎奖励
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_GET_GUILD_HUNT_AWARD_BOX"))
        else
            --请求领奖
            l_guildHuntMgr.ReqGetGuildHuntAwardBox()
        end
    end)

end

--设置简易排行榜信息  （前5名排名 查看排行榜按钮）
function GuildHuntInfoCtrl:SetSimpleLeaderboard()

    for i = 1, 8 do
        --建议排行榜只显示5个
        if not l_guildData.guildHuntInfo.scoreList or i > #l_guildData.guildHuntInfo.scoreList then
            self.panel.RankName[i].LabText = "???????"
            self.panel.RankScore[i].LabText = "????"
        else
            local l_temp = l_guildData.guildHuntInfo.scoreList[i]
            self.panel.RankName[i].LabText = l_temp.member_info.name
            self.panel.RankScore[i].LabText = l_temp.score
        end
    end

    --查看排行榜详细按钮点击
    self.panel.BtnViewDeatil:AddClick(function()
        if l_guildData.guildHuntInfo.scoreList and #l_guildData.guildHuntInfo.scoreList > 0 then
            UIMgr:ActiveUI(UI.CtrlNames.Leaderboard)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_HUNT_NO_ONE_ATTEND"))
        end
    end)

end

--设置活动信息  （剩余奖励次数 剩余时间 前往按钮）
function GuildHuntInfoCtrl:SetActivityInfo()
    --已得奖励次数
    self.panel.LeftAwardTimes.LabText = StringEx.Format("{0}/{1}",
        l_guildData.guildHuntInfo.usedTimes_reward,
        l_guildData.guildHuntInfo.maxTimes_reward)

    --倒计时与前往按钮的样式设置
    if l_guildData.guildHuntInfo.state == 1 then
        --活动正在进行中
        --清理计时器
        if l_timer then
            self:StopUITimer(l_timer)
            l_timer = nil
        end
        --展示剩余时间
        local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildHuntInfo.leftTime)
        --local l_minStr = l_minuite > 9 and tostring(l_minuite) or "0"..tostring(l_minuite)
        self.panel.LeftTimeText.LabText = Lang("ACTIVITY_TIME_REMAINED").. "：" .. StringEx.Format("{0}:{1}:{2}",
            self:GetDoubleDigitTimeStr(l_day * 24 + l_hour),
            self:GetDoubleDigitTimeStr(l_minuite),
            self:GetDoubleDigitTimeStr(l_second))
        --设置新的计时器
        l_timer = self:NewUITimer(function()
            l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildHuntInfo.leftTime)
            self.panel.LeftTimeText.LabText = Lang("ACTIVITY_TIME_REMAINED").. "：" .. StringEx.Format("{0}:{1}:{2}",
                self:GetDoubleDigitTimeStr(l_day * 24 + l_hour),
                self:GetDoubleDigitTimeStr(l_minuite),
                self:GetDoubleDigitTimeStr(l_second))
            l_guildData.guildHuntInfo.leftTime = l_guildData.guildHuntInfo.leftTime - 1
            if l_guildData.guildHuntInfo.leftTime <= 0 and l_timer then
                l_guildHuntMgr.ReqGetGuildHuntInfo()  --重新请求公会狩猎信息
                l_guildHuntMgr.ReqGuildHuntFindTeamMate()
                self:StopUITimer(l_timer)
                l_timer = nil
            end
        end,1,-1,true)
        l_timer:Start()
        --按钮样式为可点击
        self.panel.BtnGoTo:SetGray(false)
        self.panel.BtnGoToText:SetOutLineColor(Color.New(58/255.0, 96/255.0, 158/255.0, 1))
    else
        --活动已结束
        --关闭计时器
        if l_timer then
            self:StopUITimer(l_timer)
            l_timer = nil
        end
        --倒计时位置显示 活动已结束
        self.panel.LeftTimeText.LabText = Lang("ACTIVITY_IS_ALREADY_OVER")
        --按钮置灰
        self.panel.BtnGoTo:SetGray(true)
        self.panel.BtnGoToText:SetOutLineColor(Color.New(118/255.0, 118/255.0, 118/255.0, 0.5))
    end

    --立即前往按钮点击
    self.panel.BtnGoTo:AddClick(function()
        if not self.isDragging then
            if l_guildData.guildHuntInfo.state == 1 then
                --正在活动中 寻路去相关位置
                local l_type = l_selectDungeonInfo.type
                if l_type == l_guildData.EGuildHuntDungeonType.Easy then
                    local l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingEasyNpcID").Value
                    local l_val = string.ro_split(l_data, "=")
                    l_guildData.huntDoorId = l_val[1]
                elseif l_type == l_guildData.EGuildHuntDungeonType.Normal then
                    local l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingNormalNpcID").Value
                    local l_val = string.ro_split(l_data, "=")
                    local l_dungeon = l_guildData.guildHuntInfo.dungeonList[l_type + 1]
                    if l_dungeon.cur_count == l_dungeon.max_count then
                        l_guildData.huntDoorId = l_val[2]
                    else
                        l_guildData.huntDoorId = l_val[1]
                    end
                elseif l_type == l_guildData.EGuildHuntDungeonType.Hard then
                    local l_data = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingHardNpcID").Value
                    local l_val = string.ro_split(l_data, "=")
                    local l_dungeon = l_guildData.guildHuntInfo.dungeonList[l_type + 1]
                    if l_dungeon.cur_count == l_dungeon.max_count then
                        l_guildData.huntDoorId = l_val[2]
                    else
                        l_guildData.huntDoorId = l_val[1]
                    end
                end
                l_guildHuntMgr.GoToAttendGuildHunt(l_guildData.huntDoorId)
            else
                --不在活动时间显示活动已结束
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
            end
        end
    end)

end

function GuildHuntInfoCtrl:SelectDifficultDungeon(dungeonInfo, info)

    --不同副本的奖励预览ID获取
    local l_dungeonsAwardPre = TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingAwardID").Value
    local l_dungeonsAwardPreGroup = string.ro_split(l_dungeonsAwardPre, "|")
    --设置选中项
    l_selectDungeonInfo = dungeonInfo
    --请求对应的奖励预览和描述信息
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(tonumber(l_dungeonsAwardPreGroup[l_selectDungeonInfo.type + 1]))
    self.panel.LeftAwardTimesText.LabText = info

    --更新Buff数据
    local l_buffData = {}
    if dungeonInfo.type == l_guildData.EGuildHuntDungeonType.Hard then
        local l_buffConfig = TableUtil.GetGuildHuntBuffTable().GetTable()
        if #l_buffConfig <= 0 then
            logError(StringEx.Format("找不到数据：@陈阳"))
        end
        for i, v in ipairs(l_buffConfig) do
            local data
            if v.Type == 1 then
                if not l_guildHuntMgr.BuffJudge(v.Times, 0) then
                    if v.Config[0] == 0 then
                        data = {Name = v.Name, Pic = v.Pic, PicAtlas = v.PicAtlas, NextEffect = v.Effect,
                            NextAccess = v.Access, Time = v.Times}
                        data.Type = 1                     --1：未激活；2：已激活，不是最高级；3：已激活最高级
                        data.BuffType = 1       --通关次数设定
                        table.insert(l_buffData, data)
                    end
                elseif v.Config[1] ~= 0 then
                    local l_nextData = TableUtil.GetGuildHuntBuffTable().GetRowByBUFFID(v.Config[1])
                    if not l_nextData then
                        logError("下一级BUFF不存在，ID={0}", v.Config[1])
                    end
                    if not l_guildHuntMgr.BuffJudge(l_nextData.Times, 0) then
                        data = {Name = v.Name, Pic = v.Pic, PicAtlas = v.PicAtlas, Effect = v.Effect,
                            NextEffect = v.NextEffect, Access = v.Access, NextAccess = v.NextAccess, Time = l_nextData.Times}
                        data.Type = 2                     --1：未激活；2：已激活，不是最高级；3：已激活最高级
                        data.BuffType = 1       --通关次数设定
                        table.insert(l_buffData, data)
                    end
                else
                    data = {Name = v.Name, Pic = v.Pic, PicAtlas = v.PicAtlas, Effect = v.Effect, Access = v.Access}
                    data.Type = 3                     --1：未激活；2：已激活，不是最高级；3：已激活最高级
                    data.BuffType = 1       --通关次数设定
                    table.insert(l_buffData, data)
                end
            elseif v.Type == 2 then
                local l_level = math.min(l_guildData.guildHuntInfo.seal, v.Times)
                local l_nextLevel = math.min(l_guildData.guildHuntInfo.seal + 1, v.Times)
                data = {Name = v.Name, Pic = v.Pic, PicAtlas = v.PicAtlas, Effect = v.Effect,
                    NextEffect = v.NextEffect, Access = v.Access, NextAccess = v.NextAccess}
                if l_level == 0 then data.Type = 1
                elseif l_level == l_nextLevel then data.Type = 3
                else data.Type = 2
                end
                local l_configTable = Common.Functions.VectorToTable(v.Config)
                for j, val in ipairs(l_configTable) do
                    local l_effect, l_access = data.Effect, data.Access
                    data.Effect = self:StringFormat(l_effect, val * l_level)
                    data.NextEffect = self:StringFormat(l_effect, val * l_nextLevel)
                    data.Access = self:StringFormat(l_access, l_level)
                    data.NextAccess = self:StringFormat(l_access, l_nextLevel)
                end
                data.BuffType = 2       --灵魂碎片设定
                table.insert(l_buffData, data)
            end
        end
    end
    self.buffTemplatePool:ShowTemplates({Datas = l_buffData})

end


-----------------------------------------------------------------------------------------
--===============================以下是通用工具函数========================================
-----------------------------------------------------------------------------------------
--字符串转换
function GuildHuntInfoCtrl:StringFormat(data, val)

    local l_id = string.find(data, "X")
    if not l_id then
        logError("找不到匹配数据，检查下表GUILDHUNTBUFFTABLE是否正确")
        return ""
    end
    local l_newData = string.sub(data, 1, l_id - 1)
    l_newData = l_newData .. val .. string.sub(data, l_id + 1)
    return l_newData

end

--奖励预览显示
function GuildHuntInfoCtrl:GetPreviewAwards(...)

    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
    local l_previewnum = l_awardPreviewRes.preview_num
    if l_awardList then
        local l_rewardDatas = {}
        for i, v in ipairs(l_awardList) do
            table.insert(l_rewardDatas, {ID = v.item_id, Count = v.count,
                IsShowCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewnum, v.count)})
            if i >= l_previewCount then break end
        end
        --数据展示
        if l_guildData.guildHuntInfo.state == 0 then
            self.awardTemplatePool:ShowTemplates({Datas = l_rewardDatas})
        else
            self.dungeonsAwardTemplatePool:ShowTemplates({Datas = l_rewardDatas})
        end
    end

end

--获取两位数的时间显示格式
function GuildHuntInfoCtrl:GetDoubleDigitTimeStr(time)
    return time < 10 and "0"..tostring(time) or tostring(time)
end

return GuildHuntInfoCtrl
--lua custom scripts end
