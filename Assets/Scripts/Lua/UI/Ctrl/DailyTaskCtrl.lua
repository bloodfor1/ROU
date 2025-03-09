--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DailyTaskPanel"
require "Data/Model/BagModel"
require "Common/TimeMgr"
require "UI/Template/DailyActvityTemplate"
require "UI/Template/DailyMapIconTemplate"
require "UI/Template/DailyWeekInfoTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end
local l_lastOpenBlessTime = -1
local l_RepelMonsters = { MGlobalConfig:GetInt("ExpAwardID"), MGlobalConfig:GetInt("JewelryAwardID") }
--local l_RepelMonsters = { 1001 }
local l_RepelExportMonsterItems = {}
local l_RepelMonsterItemInfos = {}
local l_RepelContentIsInit = false
local l_snapEntity = nil
--lua class define
local super = UI.UIBaseCtrl
DailyTaskCtrl = class("DailyTaskCtrl", super)
--lua class define end
local ActivityShowType = GameEnum.ActivityShowType

--lua functions
function DailyTaskCtrl:ctor()
    super.ctor(self, CtrlNames.DailyTask, UILayer.Function, nil, ActiveType.Exclusive)
    self.dailyTaskFx = {}
    ---@type ModuleMgr.DailyTaskMgr
    self.mgr = MgrMgr:GetMgr("DailyTaskMgr")
end --func end
--next--
function DailyTaskCtrl:Init()
    self.panel = UI.DailyTaskPanel.Bind(self)
    super.Init(self)

    self.tweenId = 0
    self:InitBaseInfo()

end --func end
--next--
function DailyTaskCtrl:Uninit()

    MoonClient.MPostEffectMgr.OutlineInstance.IgnoreOutline = self.state

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end

    self:OnUninit()
    MPlayerInfo:FocusToMyPlayer()
    MEntityMgr.HideNpcAndRole = false

    l_RepelContentIsInit = false
    if l_snapEntity then
        l_snapEntity = MEntityMgr:DeleteObject(l_snapEntity)
        l_snapEntity = nil
    end

    if self.panelTween and self.panelTween > 0 then
        MUITweenHelper.KillTween(self.panelTween)
        self.panelTween = 0
    end

    self.awardPool = nil

    super.Uninit(self)

    MgrProxy:GetGameEventMgr().RaiseEvent(MgrProxy:GetGameEventMgr().OnDailyTaskClose)

    self.panel = nil

end --func end

function DailyTaskCtrl:OnHide()
    MScene.GameCamera.CameraEnabled = true
end

-- 显示
function DailyTaskCtrl:OnShow()
    MScene.GameCamera.CameraEnabled = self.inTween
end
--next--
function DailyTaskCtrl:OnActive()
    self.panel.GetFashionInviteTxt.LabText = Lang("FASHION_LETTER_GET")
    --todo 日常信息面板下的RectMask2D组件会遮挡所有活动，严重影响大家使用，现暂时利用重新关闭、激活画布来解决此问题
    self.panel.Panel_DailyList:SetActiveEx(false)
    self.panel.Panel_DailyList:SetActiveEx(true)
    local l_canShowGuide = true --没有同时打开子面板的情况下开启引导
    if self.uiPanelData ~= nil then
        if self.uiPanelData.distinationActivityId then
            self:GoToPosByActivityId(self.uiPanelData.distinationActivityId)
            l_canShowGuide = false
        end
        if self.uiPanelData.openFarmPrompt then
            UIMgr:DeActiveUI(CtrlNames.MonsterRepel)
            UIMgr:ActiveUI(UI.CtrlNames.FarmPrompt)
            l_canShowGuide = false
        end
    end
    if l_canShowGuide then
        self:firstOpenDailyHandler()
    end
end --func end
--next--
function DailyTaskCtrl:OnDeActive()
    MScene.GameCamera.CameraEnabled = true
    UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaPanel)
    UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
    UIMgr:DeActiveUI(UI.CtrlNames.InfoWorldPve)
    UIMgr:DeActiveUI(UI.CtrlNames.MonsterRepel)
    MInput.needSendScrollInfoToLua = false
    self.targetMapScale = -1
    if self.changeMapScaleTimer ~= nil then
        self:StopUITimer(self.changeMapScaleTimer)
        self.changeMapScaleTimer = nil
    end

    self.StartChangeScaleCount = 0
    self.currentCenterPos = nil
    self.FuncIconPool = nil
end --func end

--next--
function DailyTaskCtrl:Update()
    if self.alpha == nil or self.Index == nil then
        return
    end
    if self.alpha > 0 then
        if self.Index < 0 then
            self.alpha = self.alpha - 0.03
            if self.panel then
                self.panel.Img_DailyTaskBg.CanvasGroup.alpha = 1
                self.panel.Img_Mask.CanvasGroup.alpha = self.alpha
            end
        else
            self.Index = self.Index - 1
        end
    end
end --func end



--next--
function DailyTaskCtrl:BindEvents()
    self:BindEvent(GlobalEventBus, EventConst.Names.ScrollOperation, function(self, value)
        if not self.initComplete then
            return
        end
        if self.targetMapScale > 0 then
            --设置目标放大缩小比例，使放大缩小过程更平滑
            self.targetMapScale = self.targetMapScale + value / 500
        else
            self.targetMapScale = self.currentMapSize + value / 500
        end

        if self.targetMapScale < self.minMapSize then
            self.targetMapScale = self.minMapSize
        elseif self.targetMapScale > self.maxMapSize then
            self.targetMapScale = self.maxMapSize
        end
    end)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.DAILY_ACTIVITY_EXPEL_INFO, self.OnExpelMonsterInfo)

    self:BindEvent(self.AwardPreviewMgr.EventDispatcher, self.AwardPreviewMgr.AWARD_PREWARD_MSG, function(object, ...)
        self:RefreshPreviewAwards(...)
    end)

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.DAILY_ACTIVITY_UPDATE_EVENT, function()
        self:OnDailyTaskInfoUpdate()
    end)

    self:BindEvent(MgrMgr:GetMgr("FashionRatingMgr").EventDispatcher, MgrMgr:GetMgr("FashionRatingMgr").Event.LetterData, function()
        self.panel.GetFashionInviteTxt.LabText = Lang("FASHION_LETTER_OPEN")
    end)

    self:BindEvent(self.mgr.EventDispatcher, self.mgr.NEW_DAY_COMING, self.onNewDayComing, self)
end --func end
--next--
--lua functions end

--lua custom scripts

local l_rewardItem = {}
local l_timerItem = {}
local l_timer = nil
local l_reward = {}
local l_rewardResult = {}
local l_contentInit = false
local l_curItem = nil

local l_battleApply = true
local l_battleStart = true

function DailyTaskCtrl:OnDailyTaskInfoUpdate()
    local l_infoCount = #self.mgr.g_netInfo
    if l_infoCount < 1 then
        return
    end
    local l_timerItemCount = #l_timerItem
    if l_timerItemCount < 1 then
        return
    end
    for i = 1, l_timerItemCount do
        local l_timeLimitItem = l_timerItem[i]
        if l_timeLimitItem.state == self.mgr.g_ActivityState.Runing then
            for i = 1, l_infoCount do
                local l_netInfo = self.mgr.g_netInfo[i]
                if l_netInfo.id == l_timeLimitItem.id then
                    l_timeLimitItem.runState = l_netInfo.runState
                end
            end
        end
    end
end

function DailyTaskCtrl:OnUninit()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    for k, v in pairs(self.getTotalActivityInfos) do
        self.mgr.ReleaseDailyActivityTemplate(v)
    end
    self.getTotalActivityInfos = {}
    self.activityInfoList = {}
    self.initComplete = false

    l_timerItem = {}
    l_contentInit = false
    l_rewardResult = {}

    if self.fx ~= nil then
        self:DestroyUIEffect(self.fx)
        self.fx = nil
    end
    for i, v in pairs(self.dailyTaskFx) do
        if v ~= nil then
            self:DestroyUIEffect(v)
        end
    end
    self.dailyTaskFx = {}

    for i, v in pairs(l_rewardItem) do
        MResLoader:DestroyObj(v)
    end
    l_rewardItem = {}

    self.ActivityPool = nil
    self.RedSignProcessor = nil
    self.expelMonterRedSignProcessor = nil
end

function DailyTaskCtrl:GetAlignPosByItem(item, activeType)

    -- 限时活动
    if activeType == 2 then
        return Vector3(138, 0, 0), Vector3(178, 9, 0)
    end

    local l_x = item.item.gameObject.transform.localPosition.x
    if item.item.gameObject.transform.localPosition.x < 0 then
        return Vector3(l_x + 250, 0, 0), Vector3(l_x + 290, 9, 0)
    else
        return Vector3(l_x - 250, 0, 0), Vector3(l_x - 210, 9, 0)
    end
end

function DailyTaskCtrl:CreateTweenInObj()
    if self.panelTween and self.panelTween > 0 then
        MUITweenHelper.KillTween(self.panelTween)
        self.panelTween = 0
    end
    self.panelTween = Common.CommonUIFunc.CreateTween(self.panel.InfoPanel.gameObject, 3, 32, 0.3, false, function()

    end)
end


--[[
    @Description: 收到驱魔数据刷新界面
    @Date: 2018/8/2
    @Param: [args]
    @Return
--]]
function DailyTaskCtrl:OnExpelMonsterInfo(info)
    if not self:IsShowing() or self.ActivityPool == nil then
        return
    end
    self:InitRepelMonsterItems(info)
    local l_monsterExpelTem = self.ActivityPool:GetItem(self.expelMonsterActivityIndex)
    if not MLuaCommonHelper.IsNull(l_monsterExpelTem) and l_monsterExpelTem["RefreshData"] ~= nil then
        l_monsterExpelTem:RefreshData({
            isMonsterExpel = true,
            info = info,
            itemInfo = self:GetItemInfoByActivityId(self.mgr.g_ActivityType.activity_Magic),
        })
    end
end

--[[
    @Description: 初始化驱魔怪物
    @Date: 2018/8/2
    @Param: [args]
    @Return
--]]
function DailyTaskCtrl:InitRepelMonsterItems(info)
    l_RepelExportMonsterItems = {}
    l_RepelMonsterItemInfos = {}
    local function GetKillCount(monId)
        local num = 0
        for i, info in ipairs(info.monsters) do
            if info.monster_id == monId then
                num = info.kill_num
                break
            end
        end
        return num
    end
    for i, monsId in ipairs(l_RepelMonsters) do
        table.insert(l_RepelMonsterItemInfos, {
            killCount = GetKillCount(monsId),
            monsId = monsId })
    end
end

function DailyTaskCtrl:ExportRepelMonsItem(item, exportItem)
    exportItem.ui = item.gameObject
    exportItem.icon = exportItem.ui.transform:Find("ItemIcon"):GetComponent("Image")
    exportItem.count = MLuaClientHelper.GetOrCreateMLuaUICom(exportItem.ui.transform:Find("ItemCount"))
    exportItem.btn = exportItem.ui.transform:Find("ItemButton"):GetComponent("Button")
    exportItem.headIcon = exportItem.ui.transform:Find("Target/TargetIcon"):GetComponent("MLuaUICom")
end

--[[
    @Description: 初始化单个魔物
    @Date: 2018/8/2
    @Param: [args]
    @Return
--]]
function DailyTaskCtrl:InitRepelMonsItem(exportItem, itemData)
    local entitySdata = TableUtil.GetEntityTable().GetRowById(itemData.monsId)
    if not entitySdata then
        return logError("EntityTable 读取失败 Id = {0}", itemData.monsId)
    end
    local presentSdata = TableUtil.GetPresentTable().GetRowById(entitySdata.PresentID)
    if not presentSdata then
        return logError("PresentTable 读取失败 Id = {0}", entitySdata.PresentID)
    end
    exportItem.icon:SetNativeSize()
    exportItem.count.LabText = itemData.killCount
    exportItem.btn:GetComponent("MLuaUICom"):AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowMonsterInfoTips(itemData.monsId, exportItem.ui.gameObject.transform.position, true)
    end)
    local img = exportItem.headIcon:GetComponent("Image")
    if not img then
        exportItem.headIcon.gameObject:AddComponent(System.Type.GetType("UnityEngine.UI.Image, UnityEngine.UI"))
    end
    exportItem.headIcon:GetComponent("MLuaUICom"):SetSpriteAsync(tostring(presentSdata.Atlas), tostring(presentSdata.Icon))
end

function DailyTaskCtrl:OnExpelOperate(info)
    self.panel.openBlessBtn.gameObject:SetActiveEx(not info.is_blessing)
    self.panel.closeBlessBtn.gameObject:SetActiveEx(info.is_blessing)
    if info.is_blessing then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXPEL_MONSTER_OPEN_SUCC_TIP"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXPEL_MONSTER_OPEN_FAIL_TIP"))
    end
end

function DailyTaskCtrl:RefreshPreviewAwards(...)
    if MLuaCommonHelper.IsNull(l_curItem) then
        return
    end

    local l_grid = self.panel.rewardGrid
    local awardPreviewRes = ...
    local l_reward = awardPreviewRes and awardPreviewRes.award_list
    local previewCount = awardPreviewRes.preview_count == -1 and #l_reward or awardPreviewRes.preview_count
    local previewnum = awardPreviewRes.preview_num
    for i, v in ipairs(l_rewardItem) do
        MResLoader:DestroyObj(l_rewardItem[i])

    end
    l_rewardItem = {}
    local l_times = l_curItem.tableInfo.AcitiveTimes
    local l_acitiveAward2 = l_curItem.tableInfo.AcitiveAwardTimes[1]
    local l_rewardRate = l_times / l_acitiveAward2
    local l_rewardCount = 0
    local l_target = l_curItem.tableInfo.AcitiveAward
    for i = 0, l_target.Count - 1 do
        if l_target:get_Item(i, 0) == 301 then
            l_rewardCount = l_target:get_Item(i, 1) * l_rewardRate
        end
    end

    local rewardInfo = {}
    if l_curItem and l_rewardCount > 0 then
        table.insert(rewardInfo, {
            itemInfo = TableUtil.GetItemTable().GetRowByItemID(301),
            itemCount = l_rewardCount,
            ID = 301,
            IsShowCount = true,
        })
    end
    for i = 0, l_target.Count - 1 do
        local l_itemId = l_target:get_Item(i, 0)
        if l_itemId ~= 301 then
            table.insert(rewardInfo, {
                itemInfo = TableUtil.GetItemTable().GetRowByItemID(l_itemId),
                itemCount = 0,
                ID = l_itemId,
                IsShowCount = false,
            })
        end
    end
    for i, v in ipairs(l_reward) do
        table.insert(rewardInfo, {
            itemInfo = TableUtil.GetItemTable().GetRowByItemID(v.item_id),
            itemCount = v.count,
            ID = v.item_id,
            IsShowCount = false,
        })
        if i >= previewCount then
            break
        end
    end

    self.awardPool:ShowTemplates({ Datas = rewardInfo })
    self.panel.rewardGrid.gameObject:SetActiveEx(true)
end

--【新版未规划特效，待调整】
function DailyTaskCtrl:CreateLimitFx(item)
    if self.dailyTaskFx[item.id] then
        return
    end
    local l_fxData = {}
    local l_effect = self.panel.Effect.gameObject
    item.effect = self:CloneObj(l_effect).gameObject:GetComponent("MLuaUICom")
    item.effect.transform:SetParent(item.item.transform)
    item.effect.RectTransform.anchoredPosition = Vector3.New(-9, 2, 0)
    item.effect.transform:SetLocalScaleOne()
    item.effect.RectTransform.sizeDelta = Vector2.New(230, 240)
    l_fxData.rawImage = item.effect.RawImg
    self.dailyTaskFx[item.id] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_HuoDongKaiQi_01", l_fxData)

end

function DailyTaskCtrl:DestroyLimitFx(item)
    if self.dailyTaskFx[item.id] ~= nil then
        self:DestroyUIEffect(self.dailyTaskFx[item.id])
        self.dailyTaskFx[item.id] = nil
    end
end

function DailyTaskCtrl:GetTimeDes(sec)
    local l_hour, l_rem = math.modf(sec / 3600)
    local l_min = math.modf(l_rem * 60 + 0.5)
    return l_hour, l_min
end

function DailyTaskCtrl:ForceUpdate(item)
    if item.tableInfo.ActiveType ~= 0 then
        return
    end
    if item.item then
        LayoutRebuilder.ForceRebuildLayoutImmediate(item.item.transform)
    end
end

-----------------------new add------------------------
function DailyTaskCtrl:InitPanelAfterStartAnim()
    self:InitItemInfos()
    self:InitActivityDetailInfos()
    self:InitDailyTaskList()
    self:InitMapInfos()
    self:InitActivityDetailInfos()
    self.initComplete = true
end
function DailyTaskCtrl:InitDailyTaskList()
    self.ActivityType = {
        Limit = 0,
        Advanced = 1,
    }

    local l_dailyListAnimMoveDis = self.panel.Img_Listbg.RectTransform.rect.width
    self.dailyActivityShowState = true
    self.dailyListSourcePos = self.panel.Panel_DailyList.RectTransform.anchoredPosition3D
    self.dailyListTargetPos = self.dailyListSourcePos + Vector3.New(l_dailyListAnimMoveDis + self.adaptOffset, 0, 0)
    self.expelMonsterActivityIndex = 0

    self.panel.Panel_DailyList:SetActiveEx(true)

    self.panel.Btn_On:SetActiveEx(self.dailyActivityShowState)
    self.panel.Btn_Off:SetActiveEx(not self.dailyActivityShowState)

    self.ActivityPool = self:NewTemplatePool({
        ScrollRect = self.panel.Loop_ActivityList.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = function(data)
            return self:GetTemplateAndPrefab(data)
        end,
    })
    self.currentShowActivityType = nil
    self.panel.ToggleEx_Adventure:OnToggleExChanged(function(on)
        if on then
            if self.currentShowActivityType == self.ActivityType.Advanced then
                return
            end
            self.showActivityType = self.ActivityType.Advanced
            self.currentShowActivityType = self.showActivityType
            self.ActivityPool:DeActiveAll()
            self.ActivityPool:ShowTemplates({ Datas = self:GetActivityData(false) })
            self.ActivityPool:CancelSelectTemplate()
        end
    end)
    self.panel.ToggleEx_Limitedtime:OnToggleExChanged(function(on)
        if on then
            if self.currentShowActivityType == self.ActivityType.Limit then
                return
            end
            self.showActivityType = self.ActivityType.Limit
            self.currentShowActivityType = self.showActivityType
            self.ActivityPool:DeActiveAll()
            self.ActivityPool:ShowTemplates({ Datas = self:GetActivityData(true) })
            self.ActivityPool:CancelSelectTemplate()
        end
    end)
    if self.showActivityType == nil then
        self.showActivityType = self.ActivityType.Advanced
    end
    if self.showActivityType == self.ActivityType.Advanced then
        self.panel.ToggleEx_Adventure.TogEx.isOn = true
    else
        self.panel.ToggleEx_Limitedtime.TogEx.isOn = true
    end
    self.panel.Btn_On:AddClick(function()
        self:ShowDailyActivityList(false)
    end, true)
    self.panel.Btn_Off:AddClick(function()
        self:ShowDailyActivityList(true)
    end, true)
end
function DailyTaskCtrl:InitMapInfos()
    MInput.needSendScrollInfoToLua = true

    self.panel.Btn_AwardPreviewOFF:AddClick(function()
        self:RefreshMapData(true)
    end, true)
    self.panel.Btn_AwardPreviewON:AddClick(function()
        self:RefreshMapData(false)
    end, true)
    self.panel.InfoBG:AddClick(function()
        self.panel.InfoPanel:SetActiveEx(false)
        self:SetPassThroughFunc(true, self.panel.InfoBG.UObj, true, 1, true)
    end, true)

    self.showAward = true
    self.maxMapSize = MGlobalConfig:GetFloat("ActivityMapMaxSize")
    self.minMapSize = MGlobalConfig:GetFloat("ActivityMapMinSize")
    self.currentMapSize = MGlobalConfig:GetFloat("ActivityMapInitialSize")
    self.currentMapScale = Vector3.one * self.currentMapSize
    self.tempScrollVec2 = Vector2.New(0, 0)
    self.StartChangeScaleCount = 0
    self.panel.Obj_itemParent.Transform.parent.localScale = self.currentMapScale
    self.targetMapScale = -1
    self.panel.Scroll_MapIcon:OnScrollRectChange(function(value)
        self:UpdateMapScrollPos(value)
    end, true)
    self.FuncIconPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DailyMapIconTemplate,
        TemplateParent = self.panel.Obj_itemParent.transform,
        TemplatePrefab = self.panel.DailyMapIconTemplate.gameObject,
    })
    self:RefreshMapData(self.showAward, true)

    self:GoToPos(Vector2.New(-73, -175))

    self.changeMapScaleTimer = self:NewUITimer(function()
        self:UpdateMapScale()
    end, 0.01, -1, true)
    self.changeMapScaleTimer:Start()
end
function DailyTaskCtrl:InitActivityDetailInfos()
    self.panel.rewardGrid.gameObject:SetActiveEx(false)
    self.awardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.rewardGrid.transform
    })

    self.panel.But_Introduce:AddClick(function()
        if l_curItem == nil or l_curItem.tableInfo == nil then
            return
        end

        local l_helpTextInfo = l_curItem.tableInfo.HelpTextId
        if l_helpTextInfo == nil or l_helpTextInfo.Length < 2 then
            return
        end

        local l_textType = tonumber(l_helpTextInfo[0])
        if GameEnum.EDailyTaskHintType.ShowRichTextContext == l_textType then
            --文本说明
            local l_content = Common.Utils.Lang(l_helpTextInfo[1])
            l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(l_content)
            MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
                content = l_content,
                alignment = UnityEngine.TextAnchor.MiddleRight,
                relativeLeftPos = {
                    screenPos = MUIManager.UICamera:WorldToScreenPoint(self.panel.But_Introduce.Transform.position)
                },
                width = 400,
            })
        elseif GameEnum.EDailyTaskHintType.ShowHowToPlay == l_textType then
            --图文说明
            self.panel.InfoPanel:SetActiveEx(false)
            UIMgr:ActiveUI(CtrlNames.Howtoplay, function(ctrl)
                ctrl:ShowPanel(tonumber(l_helpTextInfo[1]))
            end)
        elseif GameEnum.EDailyTaskHintType.ShowGameHelp == l_textType then
            local subType = tonumber((l_helpTextInfo[1]))
            local C_BATTLE_TYPE_MAP = {
                [GameEnum.EPvPLuaType.BattleField] = MStageEnum.Battle
            }

            UIMgr:ActiveUI(CtrlNames.GameHelp, { type = C_BATTLE_TYPE_MAP[subType] })
        else
            logError("[DailyTaskCtrl] invalid data: " .. tostring(l_textType))
        end
    end, true)
end

function DailyTaskCtrl:InitStartAnim()
    local l_timeOut
    local l_time = self.mgr.g_lastTime
    local l_playerState = (not MEntityMgr.PlayerEntity.IsMoving)
            and (not MEntityMgr.PlayerEntity.IsFly)
            and (not MEntityMgr.PlayerEntity.IsFishing)
            and (not MEntityMgr.PlayerEntity.IsClimb)
            and (not MEntityMgr.PlayerEntity.IsOnSeat)
            and (not MEntityMgr.PlayerEntity.IsRideAnyVehicle)
            and (not MPlayerInfo.IsAutoBattle)

    if l_time == nil or Time.realtimeSinceStartup - l_time > 5 then
        l_timeOut = true
    else
        l_timeOut = false
    end
    self.mgr.g_lastTime = Time.realtimeSinceStartup
    if l_timeOut and l_playerState then
        MoonClient.MPostEffectMgr.OutlineInstance.IgnoreOutline = true
        local l_state = MPlayerInfo:FocusOpenBookView()
        MEntityMgr.HideNpcAndRole = true
        if l_state then
            self.inTween = true
            l_timer = self:NewUITimer(function()
                if self.tweenId > 0 then
                    MUITweenHelper.KillTween(self.tweenId)
                    self.tweenId = 0
                end
                self.tweenId = MUITweenHelper.TweenAlpha(self.panel.Img_Mask.UObj, 0, 0.5, 0.4,
                        function()
                            self.panel.Img_DailyTaskBg.CanvasGroup.alpha = 1
                            self.panel.Img_Mask.CanvasGroup.alpha = 1
                            self:InitPanelAfterStartAnim()
                            self.alpha = 1
                            self.Index = 0
                        end)
            end, 0.7, 0, true)
            l_timer:Start()
            return true
        end
    end
    return false
end
function DailyTaskCtrl:UpdateMapScrollPos(value, force)
    if (value.x > 1 or value.x < 0) or (value.y > 1 or value.y < 0) or force then
        self.tempScrollVec2.x = Mathf.Clamp(value.x, 0, 1)
        self.tempScrollVec2.y = Mathf.Clamp(value.y, 0, 1)
        self.panel.Scroll_MapIcon.Scroll.normalizedPosition = self.tempScrollVec2
    end
end
function DailyTaskCtrl:ShowDailyActivityList(isShow)
    if self.dailyActivityShowState == isShow then
        return
    end
    self.dailyActivityShowState = not self.dailyActivityShowState

    local l_sourcePos = self.dailyListSourcePos
    local l_targetPos = self.dailyListTargetPos
    if isShow then
        l_sourcePos = l_targetPos
        l_targetPos = self.dailyListSourcePos
    end
    self.panel.Panel_DailyList:PlayDynamicEffect(-1, {
        endValueV3_DailyListMove = l_targetPos,
        autoRewind_DailyListMove = false,
        completeCallback_DailyListMove = function()
            self.panel.Btn_On:SetActiveEx(isShow)
            self.panel.Btn_Off:SetActiveEx(not isShow)
        end
    })
end
function DailyTaskCtrl:RefreshMapData(isShowReward, isReInit)
    self.panel.Btn_AwardPreviewOFF:SetActiveEx(not isShowReward)
    self.panel.Btn_AwardPreviewON:SetActiveEx(isShowReward)
    self.showAward = isShowReward
    if isReInit then
        self.FuncIconPool:ShowTemplates({ Datas = self:getValidMapActivities() })
    else
        local l_mapItems = self.FuncIconPool:GetItems()
        for i = 1, #l_mapItems do
            local l_tempItem = l_mapItems[i]
            l_tempItem:ShowRewardProp(isShowReward)
        end
    end
end
function DailyTaskCtrl:GetTemplateAndPrefab(data)
    if data == nil then
        return
    end
    if data.isWeekDayShow then
        l_class = UITemplate.DailyWeekInfoTemplate
        l_prefab = self.panel.Template_PreShow.gameObject
    else
        l_class = UITemplate.DailyActvityTemplate
        l_prefab = self.panel.DailyActvityTemplate.gameObject
    end
    return l_class, l_prefab
end
function DailyTaskCtrl:SetMapSizeScale(scale)
    if scale > self.maxMapSize then
        scale = self.maxMapSize
    elseif scale < self.minMapSize then
        scale = self.minMapSize
    end
    if MCommonFunctions.IsEqual(scale, self.currentMapSize) then
        return
    end
    self.currentMapSize = scale
    self.currentMapScale.x = scale
    self.currentMapScale.y = scale
    self.currentMapScale.z = scale
    self.panel.Obj_itemParent.Transform.parent.localScale = self.currentMapScale

    self:UpdateMapScrollPos(self.panel.Scroll_MapIcon.Scroll.normalizedPosition)
    self:GoToPos(self.currentCenterPos)
end
function DailyTaskCtrl:GoToPosByActivityId(id)
    if not self:IsShowing() then
        return
    end
    local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(id)
    if l_info == nil then
        return
    end
    if self.mgr.IsTimeLimitActivity(l_info.ActiveType) then
        self.panel.ToggleEx_Limitedtime.TogEx.isOn = true
    end
    self:GoToPos(Vector2.New(l_info.Position[0], l_info.Position[1]))
    self:ShowDetailInfoPanel(id)
end
function DailyTaskCtrl:GoToPos(pos)
    local l_scrollViewWidth = self.panel.Scroll_MapIcon.RectTransform.rect.width
    local l_scrollViewHeight = self.panel.Scroll_MapIcon.RectTransform.rect.height

    local l_contentWidth = self.panel.Obj_Content.RectTransform.rect.width
    local l_contentHeight = self.panel.Obj_Content.RectTransform.rect.height

    local l_currentPos = Vector2.New(l_contentWidth / 2, l_contentHeight / 2) + pos  --相对于左下角的坐标
    local l_offsetValue = l_currentPos * self.currentMapSize - Vector2.New(l_scrollViewWidth / 2, l_scrollViewHeight / 2)

    self.tempScrollVec2.x = l_offsetValue.x / (l_contentWidth * self.currentMapSize - l_scrollViewWidth)  --归一化的偏移值
    self.tempScrollVec2.y = l_offsetValue.y / (l_contentHeight * self.currentMapSize - l_scrollViewHeight)
    self:UpdateMapScrollPos(self.tempScrollVec2, true)
end
--- 日常活动在大地图中仅显示开放的非限时活动及当天的限时活动
function DailyTaskCtrl:getValidMapActivities()
    local l_allActivities = self:GetActivityData(false, true)
    local l_activityNum = #l_allActivities

    for i = l_activityNum, 1, -1 do
        local l_tempActivityData = l_allActivities[i]
        local l_isTimeLimit = l_tempActivityData.weekDay ~= nil
        if l_isTimeLimit and self.currentWeekDay ~= l_tempActivityData.weekDay then
            table.remove(l_allActivities, i)
        end
    end

    return l_allActivities
end

function DailyTaskCtrl:GetActivityData(isTimeLimitActivity, isAll)
    local l_tempTable = {}
    for k, v in ipairs(self.activityInfoList) do
        if isAll then
            table.insert(l_tempTable, v)
        else
            local l_isTimeLimit = v.weekDay ~= nil
            local l_showConditon = (isTimeLimitActivity and l_isTimeLimit) or (not isTimeLimitActivity and not l_isTimeLimit)
            if l_showConditon then
                table.insert(l_tempTable, v)
            end
        end
    end

    table.sort(l_tempTable, function(a, b)
        return self:activitySortFunc(a, b)
    end)

    local l_needCheckExpelActivityIndex = not isTimeLimitActivity and not isAll
    local l_lastCheckActivityData = nil
    for i = #l_tempTable, 1, -1 do
        local l_activityData = l_tempTable[i]
        --- 魔物驱逐检测为非限时活动，此过程不会插入时间数据
        if l_needCheckExpelActivityIndex and l_activityData.activityInfo.isExpel then
            self.expelMonsterActivityIndex = i
        end

        if isTimeLimitActivity then
            if l_lastCheckActivityData ~= nil and
                    l_lastCheckActivityData.weekDay ~= l_activityData.weekDay then
                table.insert(l_tempTable, i + 1, {
                    isWeekDayShow = true,
                    weekDay = l_lastCheckActivityData.weekDay,
                })
            end
            if i == 1 then
                table.insert(l_tempTable, i, {
                    isWeekDayShow = true,
                    weekDay = l_activityData.weekDay,
                })
            end
            l_lastCheckActivityData = l_activityData
        end
    end
    return l_tempTable
end

function DailyTaskCtrl:getSortWeekDay(sourceWeekDay)
    if sourceWeekDay == nil then
        --- 非限时活动返回最大排序值
        return 999
    end
    local l_sortWeekDay = sourceWeekDay
    local l_weekTotalDay = 7
    if l_sortWeekDay < self.currentWeekDay then
        l_sortWeekDay = l_sortWeekDay + l_weekTotalDay
    end
    return l_sortWeekDay
end

function DailyTaskCtrl:activitySortFunc(a, b)
    --- 显示活动，按课程表顺序排列（如当前周二，排序为 周二、周三。。。周日、周一）
    if a.weekDay ~= b.weekDay then
        local l_sortWeekDayA = self:getSortWeekDay(a.weekDay)
        local l_sortWeekDayB = self:getSortWeekDay(b.weekDay)
        return l_sortWeekDayA < l_sortWeekDayB
    end
    --- 已开放的排在前面
    if a.activityInfo.isOpen ~= b.activityInfo.isOpen then
        return a.activityInfo.isOpen and not b.activityInfo.isOpen
    end

    --- 开显示的排在前面
    if a.activityInfo.isShow ~= b.activityInfo.isShow then
        return a.activityInfo.isShow and not b.activityInfo.isShow
    end

    ---状态为结束的排在后面
    if a.activityInfo.state ~= b.activityInfo.state then
        if b.activityInfo.state == self.mgr.g_ActivityState.Non then
            return true
        elseif a.activityInfo.state == self.mgr.g_ActivityState.Non then
            return false
        else
            return a.activityInfo.state ~= self.mgr.g_ActivityState.Finish
                    and b.activityInfo.state == self.mgr.g_ActivityState.Finish
        end
    end

    --- 活动排序优先级小的排在前面
    if a.activityInfo.tableInfo.ActivitySortId ~= b.activityInfo.ActivitySortId then
        return a.activityInfo.tableInfo.ActivitySortId <
                b.activityInfo.tableInfo.ActivitySortId
    end
    --- id小的排在前面
    return a.id < b.id
end

function DailyTaskCtrl:ShowDetailInfoPanel(activityId)
    l_curItem = self:GetItemInfoByActivityId(activityId)
    if l_curItem == nil or l_curItem.tableInfo == nil then
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.FarmPrompt)
    UIMgr:DeActiveUI(UI.CtrlNames.DemonEvictionTips)
    UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaPanel)
    UIMgr:DeActiveUI(UI.CtrlNames.MvpPanel)
    UIMgr:DeActiveUI(UI.CtrlNames.InfoWorldPve)
    UIMgr:DeActiveUI(UI.CtrlNames.MonsterRepel)
    UIMgr:DeActiveUI(UI.CtrlNames.PvpArenaRoomList)
    UIMgr:DeActiveUI(CtrlNames.ExplainPanelTips)
    self.panel.InfoPanel:SetActiveEx(false)
    if l_curItem.isGuildHunter and (not l_curItem.unOpenTime) then
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)
        return
    end
    if l_curItem.isPvp then
        UIMgr:ActiveUI(UI.CtrlNames.PvpArenaPanel)
        return
    end
    if l_curItem.isMvp then
        UIMgr:ActiveUI(UI.CtrlNames.MvpPanel)
        return
    end
    if l_curItem.isWorldEvent then
        UIMgr:ActiveUI(UI.CtrlNames.InfoWorldPve)
        return
    end
    if l_curItem.isExpel then
        UIMgr:ActiveUI(UI.CtrlNames.MonsterRepel)
        return
    end

    self.panel.InfoPanel:SetActiveEx(true)
    self.panel.BgImg:SetRawTexAsync(string.format("%s/%s", l_curItem.tableInfo.ContentPicAtlas, l_curItem.tableInfo.ContentPicName))
    self.panel.InfoContext.LabText = l_curItem.tableInfo.AcitiveText
    self.panel.InfoLv.LabText = StringEx.Format(Lang("DELEGATE_JOIN_LV"), self.OpenSysMgr.GetSystemOpenBaseLv(l_curItem.tableInfo.FunctionID))
    self.panel.InfoMod.LabText = l_curItem.tableInfo.ModeTextDisplay
    self.panel.InfoTime.LabText = l_curItem.tableInfo.TimeTextDisplay
    self.panel.InfoTittle.LabText = l_curItem.tableInfo.ActivityName

    self.panel.InfoFinish:SetActiveEx(false)
    local l_isEmpty = false
    self.panel.InfoNum.LabText, l_isEmpty = self.mgr.GetShowTextByDailyActivityItem(l_curItem.tableInfo, true, false)
    self.panel.timesLab.UObj:SetActiveEx(not l_isEmpty and (not l_curItem.unOpenTime))

    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_curItem.tableInfo.AwardText)

    self.panel.InfoTeamBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        local l_teamTargetInfo = self.mgr.GetTeamTargetInfo(activityId)
        if l_teamTargetInfo.teamTargetType ~= 0 then
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(l_teamTargetInfo.teamTargetType, l_teamTargetInfo.teamTargetId)
            end)
        end
    end, true)

    self.panel.infoGoBtn:AddClick(function()
        if l_curItem == nil then
            return
        end
        self:GotoActivityScenePos(activityId, l_curItem.tableInfo.FunctionID)
    end, true)
    self.panel.GetFashionInvite:AddClick(function()
        --if MgrMgr:GetMgr("FashionRatingMgr").ClickItemOwner(2040010) then
        if self.mgr.IsActivityOpend(self.mgr.g_ActivityType.activity_Fashion) then
            UIMgr:ActiveUI(UI.CtrlNames.FashionCollection)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("OPEN_SYSTEM_LIMIT_TIME"))
        end
        --[[else
            MgrMgr:GetMgr("FashionRatingMgr").ApplyFashionTicket()
        end]]
    end, true)
    self.panel.InfoTeamBtn:SetActiveEx(l_curItem.tableInfo.isTeamActivity == 1 and not l_curItem.unOpenTime)
    --时尚杂志按钮特判
    if l_curItem.tableInfo.Id == self.mgr.g_ActivityType.activity_Fashion then
        self.panel.GetFashionInvite:SetActiveEx(self.mgr.IsActivityOpend(self.mgr.g_ActivityType.activity_Fashion))
        self.panel.infoGoBtn:SetActiveEx(false)
        --if MgrMgr:GetMgr("FashionRatingMgr").ClickItemOwner(2040010) then
        self.panel.GetFashionInviteTxt.LabText = Lang("FASHION_LETTER_OPEN")
        --[[else
            self.panel.GetFashionInviteTxt.LabText = Lang("FASHION_LETTER_GET")
        --end]]
    else
        self.panel.infoGoBtn:SetActiveEx(not l_curItem.unOpenTime)
        self.panel.GetFashionInvite:SetActiveEx(false)
    end
    local l_showIntroduce = false
    if l_curItem.tableInfo.HelpTextId ~= nil and l_curItem.tableInfo.HelpTextId.Length > 1 then
        if l_curItem.tableInfo.HelpTextId[0] ~= "0" then
            l_showIntroduce = true
        end
    end
    self.panel.But_Introduce:SetActiveEx(l_showIntroduce)

    ---显示奖励
    self.AwardPreviewMgr.GetPreviewRewards(l_curItem.tableInfo.AwardText)
end
function DailyTaskCtrl:GotoActivityScenePos(activityId, functionId)
    local l_target = nil
    for i, v in pairs(self.activityInfoList) do
        if v.id == activityId then
            l_target = v.activityInfo
            break
        end
    end
    if l_target == nil then
        return
    end
    local l_state = l_target.state
    if l_state == self.mgr.g_ActivityState.Waiting then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ACTIVITY_BOLI_NOT_OPEN"))
        return
    end
    ---特判:公会宴会跨动态场景寻路;
    if activityId == self.mgr.g_ActivityType.activity_GuildCook or activityId == self.mgr.g_ActivityType.activity_GuildCookWeek then
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        MgrMgr:GetMgr("GuildMgr").GuildFindPath_ActivitiesId(activityId)
        return
    end
    ---特判:公会匹配赛跨动态场景寻路;
    if activityId == self.mgr.g_ActivityType.activity_GuildMatch then
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        MgrMgr:GetMgr("GuildMgr").GuildFindPath_ActivitiesId(activityId)
        return
    end
    ---特判:主题派对寻路到指定Npc并打开对话
    if activityId == self.mgr.g_ActivityType.activity_WeekParty then
        if Common.CommonUIFunc.InvokeFunctionByFuncId(functionId, nil, true) then
            UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
        end
        return
    end
    if activityId == self.mgr.g_ActivityType.activity_WorldNews then
        self.mgr.GotoDailyTask(activityId, nil, true)
        return
    end
    local l_sceneInfo = l_target.tableInfo.ScenePosition
    local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_target.functionId)
    if l_sceneInfo.Length == 1 then
        l_sceneInfo = l_sceneInfo[0]
        local l_sceneId = l_sceneInfo[0]
        local l_scenePos = Vector3.New(l_sceneInfo[1], l_sceneInfo[2], l_sceneInfo[3])
        if l_sceneId and l_sceneId > 0 then
            MTransferMgr:GotoPosition(MLuaCommonHelper.Int(l_sceneId), l_scenePos, method)
            UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
            return
        end
    end
    if l_sceneInfo.Length > 1 then
        local sceneTb = {}
        local posTb = {}
        local j = 1
        while j <= l_sceneInfo.Length do
            local l_targetPosInfo = l_sceneInfo[j - 1]
            sceneTb[j] = l_targetPosInfo[0]
            posTb[j] = Vector3.New(l_targetPosInfo[1], l_targetPosInfo[2], l_targetPosInfo[3])
            j = j + 1
        end
        Common.CommonUIFunc.ShowItemAchievePlacePanel(sceneTb, posTb, function()
            UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
            method()
        end)
        return
    end
    Common.CommonUIFunc.InvokeFunctionByFuncId(functionId, nil, nil, function()
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
    end)
end
function DailyTaskCtrl:GetItemInfoByActivityId(activityId)
    for k, v in pairs(self.activityInfoList) do
        if v ~= nil and v.id == activityId then
            return v.activityInfo
        end
    end
    return nil
end
-----------------------new end------------------------
-----------------------Optimize----------------------------
function DailyTaskCtrl:InitBaseInfo()
    if self.initComplete then
        return
    end
    self.panel.EmblemPanel.gameObject:SetActiveEx(false)
    self.inTween = false
    MScene.GameCamera.CameraEnabled = true
    self.state = MoonClient.MPostEffectMgr.OutlineInstance.IgnoreOutline
    self:InitScreenAdaptInfo()

    self:InitPanelAfterStartAnim()

end
function DailyTaskCtrl:InitScreenAdaptInfo()
    local l_dailyCanvasRectTransform = self.panel.Img_DailyTaskBg.Transform.parent:GetComponent("RectTransform")
    local l_dailyCanvasSize = l_dailyCanvasRectTransform.rect.size
    local l_fullScreenSize = MUIManager:GetUIScreenSize()
    self.adaptOffset = (l_fullScreenSize.x - l_dailyCanvasSize.x) / 2 --全面屏适配锚点缩进值
    l_dailyCanvasSize.x = l_fullScreenSize.x + 3  --适当增加滚动列表显示区域，避免看到边缘
    l_dailyCanvasSize.y = l_fullScreenSize.y + 3
    local l_scrollViewRectT = self.panel.Obj_Content.Transform.parent:GetComponent("RectTransform")
    l_scrollViewRectT.sizeDelta = l_dailyCanvasSize  --适配背景滚动视图，铺满屏幕
end
function DailyTaskCtrl:InitItemInfos()
    ---初始化
    if l_timer ~= nil then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    l_timerItem = {}
    l_reward = {}
    l_contentInit = false
    l_rewardResult = {}

    l_battleApply = true
    l_battleStart = true
    self.fx = nil
    self.RedSignProcessor = nil
    self.AwardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.OpenSysMgr = MgrMgr:GetMgr("OpenSystemMgr")

    MScene.GameCamera.CameraEnabled = false

    self.panel.InfoPanel.gameObject:SetActiveEx(false)
    self.panel.rewardGrid.gameObject:SetActiveEx(false)
    self.panel.ComeBackBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DailyTask)
    end)

    l_timerItem = {}
    self.activityInfoList = {}
    self.getTotalActivityInfos = {}
    local l_count = #self.mgr.g_netInfo
    self.currentWeekDay = Common.TimeMgr.GetNowWeekDay()
    for i = 1, l_count do
        local l_netInfo = self.mgr.g_netInfo[i]
        local l_id = l_netInfo.id
        local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(l_id)
        local l_isOpen, l_show = self:GetFunctionState(l_id, l_info.FunctionID)
        if l_isOpen or l_show then
            self:AddActivityItem(l_netInfo, l_info, l_isOpen, l_show)
        end
    end

    local l_activities = TableUtil.GetDailyActivitiesTable().GetTable()
    for i, v in pairs(l_activities) do
        local l_isOpen, l_show = self:GetFunctionState(v.Id, v.FunctionID)
        if l_isOpen or l_show then
            self:AddActivityItem(nil, v, l_isOpen, l_show)
        end
    end

    --红点;
    if self.RedSignProcessor == nil then
        self.RedSignProcessor = self:NewRedSign({
            Key = eRedSignKey.DailyTask,
            ClickButton = self.panel.EmblemPanel
        })
    end
end

function DailyTaskCtrl:GetFunctionState(activityId, functionId)
    local l_isOpen = self.OpenSysMgr.IsSystemOpen(functionId)
    local l_show = self.OpenSysMgr.IsCanPreview(functionId) and (not l_isOpen)
    return l_isOpen, l_show
end
---@param tableInfo DailyActivityTable
function DailyTaskCtrl:AddActivityItem(netInfo, tableInfo, isOpen, isShow)
    if tableInfo == nil then
        logError("DailyTaskCtrl:AddActivityItem param error!")
        return
    end
    if self:ContainActivityInfo(tableInfo.Id) then
        return
    end
    if tableInfo.isMapDisplay == 0 then
        return
    end
    ---@type DailyActivityInfo
    local l_tempData = self.mgr.GetDailyActivityTemplate()
    l_tempData:InitInfo(netInfo, tableInfo, isOpen, isShow)
    table.insert(self.getTotalActivityInfos, l_tempData)
    --- 公会狩猎为限时活动，因需在冒险处显示，此处需排除
    if self.mgr.IsTimeLimitActivity(tableInfo.ActiveType) and
            tableInfo.Id ~= self.mgr.g_ActivityType.activity_GuildHunt then
        local l_tempWeekDay = 0
        for i = 0, tableInfo.TimeCycle.Count - 1 do
            l_tempWeekDay = tableInfo.TimeCycle[i]
            if l_tempWeekDay == 7 then
                l_tempWeekDay = 0
            end
            table.insert(self.activityInfoList, {
                id = l_tempData.id,
                weekDay = l_tempWeekDay,
                activityInfo = l_tempData,
                scrollRectObj = self.panel.Loop_ActivityList.UObj
            })
        end
    else
        table.insert(self.activityInfoList, {
            id = l_tempData.id,
            activityInfo = l_tempData,
            scrollRectObj = self.panel.Loop_ActivityList.UObj
        })
    end

    if l_tempData.netInfo ~= nil then
        if l_tempData.netInfo.startTime ~= 0 and l_tempData.netInfo.startTime ~= nil then
            table.insert(l_timerItem, l_tempData)
        end
    end

    self:ForceUpdate(l_tempData)
end
function DailyTaskCtrl:ContainActivityInfo(activityId)
    for k, v in pairs(self.activityInfoList) do
        if v.id == activityId then
            return true
        end
    end
    return false
end
function DailyTaskCtrl:ActivityStartRemainDay(activityId)
    --活动还有多少天开启
    local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
    if l_info == nil then
        return -1
    end
    if not self.mgr.IsTimeLimitActivity(l_info.ActiveType) then
        return -1
    end
    if activityId == self.mgr.g_ActivityType.activity_GuildHunt then
        return DataMgr:GetData("GuildData").guildHuntInfo.state == 0 and 7 or 0
    end
    if l_info.TimeCycle == nil or l_info.TimeCycle.Count < 1 then
        return 0
    end

    local l_weekDay = Common.TimeMgr.GetNowWeekDay()
    local l_tempRemainDay = 7
    for i = 0, l_info.TimeCycle.Count - 1 do
        local l_tempWeekDay = l_info.TimeCycle[i]
        if l_tempWeekDay == 7 then
            l_tempWeekDay = 0
        end
        if l_tempWeekDay < l_weekDay then
            l_tempWeekDay = l_tempWeekDay + 7
        end
        l_tempRemainDay = math.min(l_tempRemainDay, l_tempWeekDay - l_weekDay)
    end
    return l_tempRemainDay
end
function DailyTaskCtrl:UpdateMapScale()
    if self.targetMapScale <= 0 then
        return
    end
    if MCommonFunctions.IsEqual(self.targetMapScale, self.currentMapSize) then
        --比例达到目标值尝试终止放大缩小缓动效果
        if MInput:GetTouchCount() < 2 then
            --大于1说明处于放大缩小状态，仍需屏蔽滚动视图滑动操作
            self.targetMapScale = -1  --  -1表示退出map比例渐变
            self.panel.RaycastImg_ShieldScroll:SetActiveEx(false)
            self.StartChangeScaleCount = 0
            if self.currentCenterPos ~= nil then
                if not self.panel.Scroll_MapIcon.Scroll.enabled then
                    self.panel.Scroll_MapIcon.Scroll.enabled = true
                end
                self:GoToPos(self.currentCenterPos)
                self.currentCenterPos = nil
            end
        else
            if self.currentCenterPos ~= nil then
                self:GoToPos(self.currentCenterPos)
            end
        end
        return
    else
        if self.StartChangeScaleCount == 0 then
            self.panel.RaycastImg_ShieldScroll:SetActiveEx(true)
            self.panel.Scroll_MapIcon.Scroll.enabled = false
            if self.currentCenterPos == nil then
                --放大缩小屏幕会发生一定偏移，需记录放大缩小前的中心位置，防止偏移
                self.currentCenterPos = self:GetCenterPos()
            end
            self.StartChangeScaleCount = 1
        elseif self.StartChangeScaleCount <= 3 then
            self.StartChangeScaleCount = self.StartChangeScaleCount + 1
            if self.StartChangeScaleCount == 2 then
                self.panel.Scroll_MapIcon.Scroll.enabled = true
            end
            self:GoToPos(self.currentCenterPos)
            return
        end
    end
    local l_changeScalePerUpdate = 0.1 --放大缩小比例变化速率
    local l_mapScale = 1

    if self.targetMapScale > self.maxMapSize then
        self.targetMapScale = self.maxMapSize
    elseif self.targetMapScale < self.minMapSize then
        self.targetMapScale = self.minMapSize
    end

    local l_scale = Mathf.Abs(self.targetMapScale - self.currentMapSize)
    if self.currentMapSize < self.targetMapScale then
        l_mapScale = self.currentMapSize + l_changeScalePerUpdate
    else
        l_mapScale = self.currentMapSize - l_changeScalePerUpdate
    end
    if l_scale <= l_changeScalePerUpdate then
        l_mapScale = self.targetMapScale
    end
    self:SetMapSizeScale(l_mapScale)
end
--获取当前屏幕中心位置
function DailyTaskCtrl:GetCenterPos()
    local l_screenCenterPos = Vector2.New(Screen.width / 2, Screen.height / 2)
    local _, centerPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Obj_itemParent.RectTransform, l_screenCenterPos, MUIManager.UICamera, nil)
    centerPos.x = centerPos.x - centerPos.x % 0.1
    centerPos.y = centerPos.y - centerPos.y % 0.1
    return centerPos
end
function DailyTaskCtrl:firstOpenDailyHandler()
    local l_nowTime = Common.TimeMgr.GetNowTimestamp()
    local l_firstOpenDailyKey = Common.Functions.GetPlayerPrefsKey(self.mgr.DAILT_FIRST_OPEN)
    local l_firstOpenTime = PlayerPrefs.GetInt(l_firstOpenDailyKey, l_nowTime)
    PlayerPrefs.SetInt(l_firstOpenDailyKey, l_nowTime)
    if math.abs(l_firstOpenTime - l_nowTime) < 10 then
        --第一次打开日常播引导
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "DailyActiivityGuide" }, self:GetPanelName(), self.mgr.GetDailyPanelLayer() + 1)
    end
end
function DailyTaskCtrl:onNewDayComing()
    if self.ActivityPool == nil then
        return
    end
    self.currentWeekDay = Common.TimeMgr.GetNowWeekDay()
    self.ActivityPool:ShowTemplates({ Datas = self:GetActivityData(self.currentShowActivityType == self.ActivityType.Limit) })
end
-----------------------Optimize end------------------------
--lua custom scripts end
return DailyTaskCtrl