--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SystemInfoPanel"
require "UI/Template/SceneLinesCellTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
--next--
--lua fields end
---@class SystemInfoCtrl : UIBaseCtrl
--lua class define
SystemInfoCtrl = class("SystemInfoCtrl", super)
--lua class define end

--lua functions
function SystemInfoCtrl:ctor()
    super.ctor(self, CtrlNames.SystemInfo, UILayer.Normal, nil, ActiveType.Normal)
    -- 将SystemInfoPanel调整到Normal层UI的最高层
    self.overrideSortLayer = UILayerSort.Function - 1
end --func end
--next--
function SystemInfoCtrl:Init()

    self.panel = UI.SystemInfoPanel.Bind(self)
    super.Init(self)
    self.lastUpdateTime = -100
    self.panel.QualityLab.LabText = self:GetQualityStr()
    self.panel.SceneLinesUI:SetActiveEx(false)

    self:SetSceneLineNameText()
    self.panel.SceneLineBtn:AddClick(function()
        self:GetStaticSceneLine()
    end)

    self.linesPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SceneLinesCellTemplate,
        ScrollRect = self.panel.Scroll.LoopScroll,
        TemplatePrefab = self.panel.SceneLinesCell.gameObject
    })
    self.panel.SceneLinesCell.gameObject:SetActiveEx(false)

end --func end
--next--
function SystemInfoCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.lastUpdateTime = nil

end --func end
--next--
function SystemInfoCtrl:OnActive()
    self:SetSceneLineBtnState()
end --func end
--next--
function SystemInfoCtrl:OnDeActive()
    -- 若隐去界面时分线面板处于显示状态则将其隐藏
    if self.panel.SceneLinesUI.gameObject.activeSelf then
        self.panel.SceneLinesUI.gameObject:SetActiveEx(false)
    end
end --func end
--next--
function SystemInfoCtrl:Update()

    if Time.realtimeSinceStartup - self.lastUpdateTime > 5 then
        self:UpdateNetState()                            --更新当前网络状态
        self.panel.SysTimeLab.LabText = MServerTimeMgr:GetCurrentDeviceTimeStr()           --更新时间
        self.panel.BatterySlider.Slider.value = Application.isMobilePlatform and SystemInfo.batteryLevel or 1;        --更新电池用量
        self.panel.Charging:SetActiveEx(SystemInfo.batteryStatus == UnityEngine.BatteryStatus.Charging);
        self.lastUpdateTime = Time.realtimeSinceStartup
    end
    self:UpdateSceneLine()

end --func end
--next--
function SystemInfoCtrl:Show(withTween)

    if not super.Show(self, withTween) then
        return
    end

end --func end
--next--
function SystemInfoCtrl:Hide(withTween)

    if not super.Hide(self, withTween) then
        return
    end

end --func end
--next--
function SystemInfoCtrl:BindEvents()

    self:BindEvent(GlobalEventBus, EventConst.Names.QualityLevelChange, function(self)
        if self.panel ~= nil then
            self.panel.QualityLab.LabText = self:GetQualityStr()
        end
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.SceneLineChange, function(self, line)
        if self.panel ~= nil then
            self:SetSceneLineNameText(line)
        end
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.UpdateSceneLinesPanel, function(self, active, linesData)
        if self.panel ~= nil then
            self:SetupSceneLinesPanel(active, linesData)
        end
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.GetStaticSceneLine, function(self)
        if self.panel ~= nil then
            self:GetStaticSceneLine()
        end
    end)
    self:BindEvent(l_themePartyMgr.EventDispatcher, l_themePartyMgr.ON_GET_THEM_PARTYACTIVITY_INFO, function()
        self:SetSceneLineBtnState()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function SystemInfoCtrl:UpdateNetState()

    state = MServerTimeMgr.singleton.NetworkState
    connectType = Application.internetReachability
    if connectType == NetworkReachability.NotReachable then
        --无网络
        self.panel.NetNone:SetActiveEx(true)
        self.panel.NetWifi:SetActiveEx(false)
        self.panel.NetMobile:SetActiveEx(false)
    elseif connectType == NetworkReachability.ReachableViaLocalAreaNetwork then
        --wifi
        self.panel.NetNone:SetActiveEx(false)
        self.panel.NetWifi:SetActiveEx(true)
        self.panel.NetMobile:SetActiveEx(false)
        self.panel.WifiSignal[1]:SetActiveEx(true)
        self.panel.WifiSignal[2]:SetActiveEx(self:Turn(state) <= self:Turn(NetWorkState.SLOW))
        self.panel.WifiSignal[3]:SetActiveEx(self:Turn(state) <= self:Turn(NetWorkState.NORMAL))
        self.panel.WifiSignal[1].Img.color = Color.New(1, 0.3125, 0.3125)
        if self:Turn(state) < self:Turn(NetWorkState.VERY_SLOW) then
            self.panel.WifiSignal[1].Img.color = Color.white
        end
    elseif connectType == NetworkReachability.ReachableViaCarrierDataNetwork then
        --mobile
        self.panel.NetNone:SetActiveEx(false)
        self.panel.NetWifi:SetActiveEx(false)
        self.panel.NetMobile:SetActiveEx(true)
        self.panel.MobileSignal[1]:SetActiveEx(true)
        self.panel.MobileSignal[2]:SetActiveEx(self:Turn(state) <= self:Turn(NetWorkState.SLOW))
        self.panel.MobileSignal[3]:SetActiveEx(self:Turn(state) <= self:Turn(NetWorkState.NORMAL))
        self.panel.MobileSignal[4]:SetActiveEx(self:Turn(state) <= self:Turn(NetWorkState.FAST))
        self.panel.MobileSignal[1].Img.color = Color.New(1, 0.3125, 0.3125)
        if self:Turn(state) < self:Turn(NetWorkState.VERY_SLOW) then
            self.panel.MobileSignal[1].Img.color = Color.white
        end
    end

end

function SystemInfoCtrl:Turn(state)

    state = tostring(state)
    if state == "FAST" then
        return 1
    elseif state == "NORMAL" then
        return 101
    elseif state == "SLOW" then
        return 251
    elseif state == "VERY_SLOW" then
        return 501
    end
    return 0

end

--获取当前画质
function SystemInfoCtrl:GetQualityStr()

    local l_data = MQualityGradeSetting.GetCurGradeType()
    if l_data == MoonSerializable.QualityGradeType.High or l_data == MoonSerializable.QualityGradeType.VeryHigh then
        return Lang("SETTING_QUALITY_HIGH")
    elseif l_data == MoonSerializable.QualityGradeType.Middle then
        return Lang("SETTING_QUALITY_MIDDLE")
    elseif l_data == MoonSerializable.QualityGradeType.Low then
        return Lang("SETTING_QUALITY_LOW")
    else
        return Lang("SETTING_QUALITY_VERYLOW")
    end

end

--- 为切换分线的按钮文本赋值
--- @param line number 给定分线，若为空使用MScene.SceneLine
function SystemInfoCtrl:SetSceneLineNameText(line)

    if not line then
        line = MScene.SceneLine
    end
    self.panel.SceneLineNameText.LabText = Lang("LineShowFormat", line)
end

--- 每次OnActive()调用，判断分线按钮状态
function SystemInfoCtrl:SetSceneLineBtnState()
    local l_data = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    ---因--bug=1087178 --user=曾祥硕 【KR.DEV.OBT分支】【... https://www.tapd.cn/20332331/s/1814090
    ---临时解决方案，策划将场景类型配置为PVP类型，此处特判场景ID
    -- 舞会期间关闭分线
    if l_data.IsStaticScene and not StageMgr:IsStage(MStageEnum.RingPre)
            -- 擂台等候区 关闭分线
            and not MgrMgr:GetMgr("ThemePartyMgr").DuringThemePartyScene()
            and MScene.SceneID ~= MGlobalConfig:GetInt("HuntingGroundSceneID")
    then
        --logYellow("[SystemInfoCtrl] isStaticScene ShowBtn")
        self.panel.SceneLineBtn:SetActiveEx(true)
    else
        --logYellow("[[SystemInfoCtrl] isNotStaticScene HideBtn")
        self.panel.SceneLineBtn:SetActiveEx(false)
    end
end

function SystemInfoCtrl:GetStaticSceneLine()

    local l_msgId = Network.Define.Rpc.GetStaticSceneLine
    ---@type StaticSceneLineArg
    local l_sendInfo = GetProtoBufSendTable("StaticSceneLineArg")
    l_sendInfo.scene_id = MScene.SceneID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function SystemInfoCtrl:UpdateSceneLine()

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Content.transform)
    if MoonClient.MRaycastTouchUtils.IsNoTouchedForLua(self.panel.Bg.UObj, true, UnityEngine.TouchPhase.Began)
            and MoonClient.MRaycastTouchUtils.IsNoTouchedForLua(self.panel.SceneLineBtn.UObj, true, UnityEngine.TouchPhase.Began) then
        self:SetupSceneLinesPanel(false)
    end

end

---@public
---显示/隐藏线路面板，若显示则同时更新可切线路信息
---MScene.SceneLineDatas格式没有导入所以以参数形式传入可切线路数据
---@param active boolean 为true显示线路面板
---@param linesDataList SceneLineData[] 线路信息列表。线路号SceneLineData.line，是否拥挤为SceneLineData.status
function SystemInfoCtrl:SetupSceneLinesPanel(active, linesDataList)
    self.panel.SceneLinesUI:SetActiveEx(active)
    -- 隐藏面板时不更新面板信息
    if not active then
        return
    end

    if #linesDataList ~= MScene.SceneLineCount then
        logError("[SystemInfoCtrl.SetupSceneLinesPanel] 传入线路个数错误，隐藏界面")
        self.panel.SceneLinesUI:SetActiveEx(false)
    elseif nil == linesDataList then
        logError("[SystemInfoCtrl.SetupSceneLinesPanel] 线路信息列表为空，隐藏界面")
        self.panel.SceneLinesUI:SetActiveEx(false)
    end

    local l_data = {}
    for i = 1, #linesDataList do
        local lineData = linesDataList[i]
        -- lineData.isCrowd属性废弃，直接用linesDataList[i]中的status
        -- 转换类型，0（number）被判断为true
        lineData.status = lineData.status ~= 0
        lineData.isNowLine = lineData.line == MScene.SceneLine
        table.insert(l_data, lineData)
    end
    self.linesPool:ShowTemplates({ Datas = l_data })
    local l_rtTrans = self.panel.Content.Transform
    LayoutRebuilder.ForceRebuildLayoutImmediate(l_rtTrans)
    local l_height = math.min(590, self.panel.Content.RectTransform.rect.height + 19)
    local l_width = MScene.SceneLineCount == 1 and 145.5 or 277

    self.panel.Bg.RectTransform.sizeDelta = Vector2(l_width, l_height);
    if 590 > self.panel.Content.RectTransform.rect.height + 19 then
        self.panel.Scroll.LoopScroll.enabled = false
    else
        self.panel.Scroll.LoopScroll.enabled = true
    end

end
--lua custom scripts end
return SystemInfoCtrl