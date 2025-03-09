--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillLearningPanel"
require "UI/Template/ProfessionSkillClassTemplate"
require "UI/Template/SkillLearningProfessionSkillPanelTemplate"
require "UI/Template/JobAdditionTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SkillLearningCtrl = class("SkillLearningCtrl", super)
local logFlag = false
local ManTrsOpenSystemId = 1070
--local LeaveStateEnum = MoonClient.LeaveStateEnum
local l_eventSystem
local l_pointEventData
local l_pointRes
local l_dragOut = false
local l_dragStartPos = Vector2.zero
local l_dragItem
local SKILL_LINE_HEIGHT = 170 * 0.88
--local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
local l_slotCount = 6
local l_queueCount = 6          --技能队列最大容纳数量
--local firstChange = true
--上次的TmpTable状态
local lastSlotTmpTable = {}
local lastAutoSlotTmpTable = {}
local l_helpNum = 0
local l_hurtNum = 0
local l_commonNum = 0
local l_slotTmpTable = {}--手动槽temp
local l_slotAutoTmpTable = {}--自动槽temp
local l_slotQueueTable = {}--技能队列temp
local l_skillRowNum = 5
local l_startY = -85
local l_helpOffset = 110
local SLOT_GROUP_ONE = 0
local SLOT_GROUP_TWO = 1
local SLOT_GROUP_AUTO = 2
local l_currentSlotGroup = SLOT_GROUP_ONE
local l_manualSlotGroup

local queueUseColor = Color.New(102/255, 175/255, 255/255, 1)
local queueNowColor = Color.New(255/255, 196/255, 109/255, 1)
local queueUnUseColor = Color.New(212/255, 218/255, 241/255, 150/255)
--lua class define end

--lua functions
function SkillLearningCtrl:ctor()

    super.ctor(self, CtrlNames.SkillLearning, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.isPreviewPanel = false
    self.cacheAddedSkillPoint = {}
    self.maxProId = -1
    self.recommentSchoolId = 0
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    self.data = DataMgr:GetData("SkillData")
    --self.weakMgr = MgrMgr:GetMgr("WeakGuideMgr")
    l_slotCount = self.data.SlotCount
    self.toggleList = {}

end --func end

function SkillLearningCtrl:Init()

    self.panel = UI.SkillLearningPanel.Bind(self)
    super.Init(self)

    -- 关闭按钮
    self.panel.BtnClose:AddClick(function()
        if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING or self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
            self:SaveSkillSlot()
        end
        self:OnClose()
    end)
    --技能按钮字典 key：SkillId  value：SkillLearningSkillBtnTemplate 新手指引用
    self.skillBtnDic = {}
    self.saveCD = 0
    self.skillAddPointTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SkillLearningProfessionSkillPanelTemplate,
        TemplateParent = self.panel.SkillAddPointContent.transform,
        TemplatePrefab = self.panel.AddSkillPointPanel.LuaUIGroup.gameObject
    })
    self.skillPreviewPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ProfessionSkillClassTemplate,
        ScrollRect = self.panel.SkillLeaningPreviewPanel.RightPreview.SkillParent.LoopScroll,
        TemplatePrefab = self.panel.SkillLeaningPreviewPanel.RightPreview.ProfessionSkillClass.Prefab.gameObject
    })
    self.panel.SkillLeaningPreviewPanel.RightPreview.ProfessionSkillClass.Prefab:SetActiveEx(false)

    if not self.multiTalentsSelectTemplate then
        self.multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate",
        {
            TemplateParent = self.panel.AttrParent.transform
        })
    end
    self.multiTalentsSelectTemplate:SetData(
        MgrMgr:GetMgr("OpenSystemMgr").eSystemId.SkillMultiTalent,
        {
            DetailsAnchor = Vector2.New(1, 1)
        })

    -- 固定技能
    self.fixedSkillList = self.data.FixSkillList()
    self.maxProId = -1
    self.recommentSchoolId = 0
    local Vector3Type = System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule")
    self.vectorArray1 = System.Array.CreateInstance(Vector3Type, 4)
    self.vectorArray2 = System.Array.CreateInstance(Vector3Type, 4)
    self.redSign = {}

    --打开键位设置
    self.panel.BtnResetSkillPoint:AddClick(function()
        self:ResetSkills()
    end)

    -- 职业toggle
    self:InitProfessionToggle()

    -- 面板toggle
    self:InitSkillPanelToggle()

    --面板技能
    local proType, proId = self.data.CurrentProTypeAndId()
    self:InitAddPointPanel(proType, proId)

    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    l_pointRes = RaycastResultList.New()

    --默认选中第一个页签
    self:TurnTogOn(1)
    self.panel.TogUseMaxLevel.Tog.isOn = self.data.GetUseMaxLevel()
    self.panel.TogQueueMaxLevel.Tog.isOn = self.data.GetUseMaxLevel()
    local ui = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
    if ui then
        l_currentSlotGroup = ui.SlotPage or SLOT_GROUP_ONE
    end

end --func end

--next--
function SkillLearningCtrl:Uninit()

    self.skillAddPointTemplatePool = nil
    self.skillPreviewPool = nil
    self.multiTalentsSelectTemplate = nil
    self.redSign = {}
    self.maxProId = -1
    self.recommentSchoolId = 0
    self.vectorArray1 = nil
    self.vectorArray2 = nil
    self.jobAwardPart = nil
    l_currentSlotGroup = nil
    l_eventSystem = nil
    l_pointRes = nil
    l_pointEventData = nil
    l_manualSlotGroup = nil
    self.skillBtnDic = nil
    --self.weakMgr.RemoveEvent(self.weakMgr.eSignEventName.LearnNewSkill, self)

    super.Uninit(self)
    self.panel = nil

end --func end

--next--
function SkillLearningCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.OpenProfessionalSchools then
            UIMgr:ActiveUI(UI.CtrlNames.ProfessionalSchools, function(ctrl)
                local proType, proId = self.data.CurrentProTypeAndId()
                ctrl:InitWithProfessionId(proId)
            end)
        end
        if self.uiPanelData.openType == self.data.OpenType.SetTargetSkillId then
            self:SetTargetSkillId(self.uiPanelData.targetId)
        end
        if self.uiPanelData.openType == self.data.OpenType.AutoSetting then
            self:TurnTogOn(self.uiPanelData.settingTog)               --打开技能设置页签
            self:TurnSlotTogOn(self.uiPanelData.settingTog)           --选中自动技能设置
        end
        if self.uiPanelData.openType == self.data.OpenType.OpenSkillSetting then
            self:TurnTogOn(2)
            MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.LearnNewSkill, false)
        end
        if self.uiPanelData.openType == self.data.OpenType.ResetSkills then
            self:ResetSkills()
        end
        if self.uiPanelData.openType == self.data.OpenType.DirectOpenPreview then
            self:DirectOpenPreview()
        end
    end

end --func end

--next--
function SkillLearningCtrl:OnDeActive()

    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    self:CancelSkillPoint()
    if self.skillClassTemplateList then
        for _, v in ipairs(self.skillClassTemplateList) do
            self:UninitTemplate(v)
        end
        self.skillClassTemplateList = nil
    end
    self.cacheAddedSkillPoint = self.data.AddedSkillPoint
    self.currentPanel = self:IsReactive() and self.currentPanel or nil
    if l_manualSlotGroup then
        local ui = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
        if ui then
            ui:SetSlotPage(l_manualSlotGroup)
        end
    end
    l_currentSlotGroup = nil
    l_slotTmpTable = {}
    l_slotAutoTmpTable = {}
    self.directOpenPreview = false
    self.isPreviewPanel = false

end --func end

--next--
function SkillLearningCtrl:Update()

    local isAllAddFinish = true
    if self.skillAddPointTemplatePool then
        for k, v in pairs(self.skillAddPointTemplatePool.Items) do
            v:Update()
            isAllAddFinish = isAllAddFinish and v.addFinish
        end
    end
    if isAllAddFinish and self.skillAddPointTemplatePool then
        for k, v in pairs(self.skillAddPointTemplatePool.Items) do
            v:ConnectSkillBtns()
            v.addFinish = false
        end
    end

    if self.skillBtnTempTable then
        for k, v in pairs(self.skillBtnTempTable) do
            v:Update()
        end
    end
    if self.saveCD > 0 then
        self.saveCD = self.saveCD - UnityEngine.Time.deltaTime
    end

end --func end
--next--
function SkillLearningCtrl:BindEvents()

    --添加监听事件
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SKILL_POINT_APPLY, self.OnSkillPointApply)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SKILL_SLOT_APPLY, self.OnSkillSlotApply)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SKILL_ENTERSCENE, self.OnEnterStage)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SKILL_RESET, self.OnResetSkill)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.EventType.RemainingPointChange, function(self, val)
        self.panel.TxtRemainingPoint.LabText = val
    end)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.EventType.UseMaxLevel, function(self, val)
        self.panel.TogUseMaxLevel.Tog.isOn = val
        self.panel.TogQueueMaxLevel.Tog.isOn = val
    end)
    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    self:BindEvent(multiMgr.EventDispatcher, multiMgr.ReceiveChangeMultiTalentEvent, self.OnSkillPlanChange)
    --新手指引
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").SKILL_ADD_BUTTON_GUIDE_EVENT,function(self, guideStepInfo)
        self:ShowBeginnerGuide_SkillAdd(guideStepInfo)
    end)
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").OX_BUTTON_GUIDE_EVENT,function(self, guideStepInfo)
        self:ShowBeginnerGuide_OX(guideStepInfo)
    end)

end --func end
--next--
function SkillLearningCtrl:OnHide()

    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)

end
--lua functions end

--lua custom scripts
---------------------------Common Funciton----------------------------------

--切换页签
function SkillLearningCtrl:TurnTogOn(index)

    if not (index >= 1 and index <= 4) then return end
    self.panel.ToggleTpl[index].TogEx.isOn = true

end

function SkillLearningCtrl:ExChangePanel(panelType)

    if self.currentPanel == panelType then
        return
    end
    self.currentPanel = panelType

    self.panel.JobChoose:SetActiveEx(false)
    self:SetSkillPointPanelState(self.panel.SkillPointPanel.UObj, self.currentPanel == self.data.OpenTog.SKILL_POINT_PANEL)
    self.panel.ButtonSettingPanel.gameObject:SetActiveEx(self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING)
    self.panel.SkillQueue.gameObject:SetActiveEx(self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING)
    self:SetAddtionPartVisible(self.currentPanel == self.data.OpenTog.SKILL_JOBADDTION)
    self:UpdateSkillSaver()

    self:SaveSkillSlot()
    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self.panel.BtnRecommendSkillPoint.gameObject:SetActiveEx(false)
        self.panel.BtnResetSkillPoint.gameObject:SetActiveEx(false)
        self:InitSlot()
        self:InitButtonSetting(self.currentProType)
        self.panel.TxtSaverTip.LabText = Lang("SKILLEARNING_CLICK_O_COMFIRM_BUTTONSETTING")
        self:SwitchSlotGroup(l_currentSlotGroup)
    elseif self.currentPanel == self.data.OpenTog.SKILL_POINT_PANEL then
        self.panel.BtnRecommendSkillPoint.gameObject:SetActiveEx(true)
        self.panel.BtnResetSkillPoint.gameObject:SetActiveEx(true)
        self:UpdatePanel(self.currentPanel)
        self.panel.TxtSaverTip.LabText = Lang("SKILLEARNING_CLICK_O_COMFIRM_ADDPOINT")
    elseif self.currentPanel == self.data.OpenTog.SKILL_JOBADDTION then
        if self.jobAwardPart then
            self.jobAwardPart:AddLoadCallback(function (tmp)
                tmp:JobAdditionRefresh()
            end)
        end
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
        local l_systemOpen = l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.QueueSkillFuncId)
        self.panel.BtnRecommendSkillPoint.gameObject:SetActiveEx(false)
        self.panel.BtnResetSkillPoint.gameObject:SetActiveEx(false)
        self.panel.QueueSettingSkillScroll:SetActiveEx(l_systemOpen)
        self.panel.QueueBG1:SetActiveEx(l_systemOpen)
        self.panel.QueueBG2:SetActiveEx(l_systemOpen)
        self.panel.QueueNoOpen:SetActiveEx(not l_systemOpen)
        if l_systemOpen then
            self:InitSlot()
            self:InitQueueSetting()
            self:UpdateQueueSlots()
            self:SkillQueueUIUpdate()
        else
            local l_level = TableUtil.GetOpenSystemTable().GetRowById(l_openSysMgr.eSystemId.QueueSkillFuncId)
            if l_level and l_level.AchievementLevel then
                local l_ach = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_level.AchievementLevel)
                self.panel.NoOpenHint.LabText = Lang("OPEN_SYSTEM_LIMIT_ACHIEVEMENT", l_ach.Name)
            end
        end
    end
    -- 打开设置界面重置有新技能标记
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then self.mgr.ResetHasNewSkillFlag() end
    if self.currentPanel ~= self.data.OpenTog.SKILL_POINT_PANEL then self.directOpenPreview = false end

end

function SkillLearningCtrl:OnClose()

    if self.panel.SkillPointSaverPanel.gameObject.activeSelf then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SKILLLEARNING_SKILL_TIP_SAVE_BEFORE_QUIT"), nil, function()
            UIMgr:DeActiveUI(UI.CtrlNames.SkillLearning)
        end)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.SkillLearning)
    end

end

--初始化选择职业的Toggle
function SkillLearningCtrl:InitProfessionToggle()

    local l_data = self.data.GetDataFromTable("ProfessionTable", MPlayerInfo.ProID)
    local l_toggleList = {}
    l_toggleList[self.data.ProfessionList.BASE_SKILL] =
    {
        tog = self.panel.ToggleBaseSkill,
        openFunc = function() return true end,
        name = Lang("SKILL_LEARNING_BASE_PRO"),
    }
    l_toggleList[self.data.ProfessionList.PRO_ONE] =
    {
        tog = self.panel.ToggleProfessionOne,
        openFunc = function() return self.data.GetProOneId() ~= 0 end,
        lastPro = self.data.ProfessionList.BASE_SKILL,
    }
    l_toggleList[self.data.ProfessionList.PRO_TWO] =
    {
        tog = self.panel.ToggleProfessionTwo,
        openFunc = function() return self.data.GetProTwoId() ~= 0 end,
        lastPro = self.data.ProfessionList.PRO_ONE,
        preview = l_data.ProfessionPreSwitch == 1 and self.data.OpenTog.SKILL_PREVIEW or nil,
        redSignKey = eRedSignKey.RedSignPro1
    }
    l_toggleList[self.data.ProfessionList.PRO_THREE] =
    {
        tog = self.panel.ToggleProfessionThree,
        openFunc = function() return self.data.GetProThreeId() ~= 0 end,
        lastPro = self.data.ProfessionList.PRO_TWO,
        preview = l_data.ProfessionPreSwitch == 1 and self.data.OpenTog.SKILL_PREVIEW or nil,
        redSignKey = eRedSignKey.RedSignPro2
    }
    l_toggleList[self.data.ProfessionList.PRO_FOUR] =
    {
        tog = self.panel.ToggleProfessionFour,
        openFunc = function() return self.data.GetProFourId() ~= 0 end,
        lastPro = self.data.ProfessionList.PRO_THREE,
        preview = l_data.ProfessionPreSwitch == 1 and self.data.OpenTog.SKILL_PREVIEW or nil
    }
    self.toggleList = l_toggleList

    local isOpen = false
    for id, v in pairs(l_toggleList) do
        local l_openFunc = l_toggleList[id].openFunc
        local l_tog = l_toggleList[id].tog
        isOpen = l_openFunc()
        if isOpen or (v.preview and v.lastPro and l_toggleList[v.lastPro].openFunc()) then
            l_tog:SetActiveEx(true)
            if v.redSignKey ~= nil then
                local redSign = self:NewRedSign({
                    Key = v.redSignKey,
                    ClickTogEx = l_tog
                })
                table.insert(self.redSign, redSign)
            end
            l_tog.TogEx.onValueChanged:AddListener(function(on)
                if on then
                    self.panel.JobChoose:SetActiveEx(false)
                    self.currentProType = id
                    if v.openFunc() then
                        self.isPreviewPanel = false
                        self:UpdatePanel(self.currentPanel)
                        if self.currentPanel == self.data.OpenTog.SKILL_POINT_PANEL and not self.data.IsProfessionPointFull(id) then
                            CommonUI.Dialog.ShowOKDlg(true, nil, Lang("SKILLLEARNING_NEED_PROFESSION_SKILL_POINT",
                                self.professionRow.SkillPointRequired), nil, 0, 1, "SKILLLEARNING_NEED_PROFESSION_SKILL_POINT")
                        end
                    else
                        self.isPreviewPanel = true
                        self:UpdatePanel(v.preview)
                    end
                end
            end)
            if isOpen then
                self.maxProId = id
            end
            local l_lock = l_tog.transform:Find("Lock")
            if l_lock then
                l_lock.gameObject:SetActiveEx(not isOpen)
            end
        else
            l_tog:SetActiveEx(false)
        end
    end

end

function SkillLearningCtrl:InitSkillPanelToggle()

    -- 技能
    self.panel.ToggleTpl[1].TogEx.onValueChanged:AddListener(function(value)
        if value then
            self:ExChangePanel(self.data.OpenTog.SKILL_POINT_PANEL)
            --打开基础技能页
            self:SetCurrentProfessionTog()
            --新手指引相关
            local l_beginnerGuideChecks = {"SkillUI"}
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
        end
    end)

    -- 设置
    self.panel.ToggleTpl[2].TogEx.onValueChanged:AddListener(function(value)
        if value then
            self:ExChangePanel(self.data.OpenTog.SKILL_BUTTON_SETTING)
            --新手指引相关
            if self.guideArrow then
                --先关闭前一个指引
                MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
                for _,addBtn in pairs(self.skillBtnDic) do
                    addBtn:RemoveGuideClickEvent()
                end
            end
            local l_beginnerGuideChecks = {"SkillSetting"}
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
        end
    end)

    --技能队列
    self.panel.ToggleTpl[4].TogEx.onValueChanged:AddListener(function(value)
        if value then
            self:ExChangePanel(self.data.OpenTog.SKILL_QUEUE_SETTING)
        end
    end)

    -- 等级加成
    self.panel.ToggleTpl[3].TogEx.onValueChanged:AddListener(function(value)
        if value then
            if self.data:IsBeginner() then
                return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JOBADDTION_OPEN_TIP"))
            end
            self:AddJobAwardPart()
            self:ExChangePanel(self.data.OpenTog.SKILL_JOBADDTION)
        end
    end)

    local redSignKeys =
    {
        eRedSignKey.SkillLearningSkill,
        eRedSignKey.SkillLearningSetting,
        eRedSignKey.SkillLearningJobAward,
    }
    for i = 1, 3, 1 do
        local redSign = self:NewRedSign({
            Key = redSignKeys[i],
            RedSignParent = self.panel.ToggleTpl[i].transform:Find("RedSignParent"),
            ClickTogEx = self.panel.ToggleTpl[i],
        })
        table.insert(self.redSign, redSign)
    end

end



function SkillLearningCtrl:UpdatePanel(currentPanel)

    self:UpdateTopInfo(self.currentProType)
    self:SetSkillPointPanelState(self.panel.SkillPointPanel.UObj, currentPanel == self.data.OpenTog.SKILL_POINT_PANEL or currentPanel == self.data.OpenTog.SKILL_PREVIEW)
    self:SetSkillPointPanelState(self.panel.ProfessionScrollView.UObj, currentPanel == self.data.OpenTog.SKILL_POINT_PANEL)
    self.panel.TopButtonPanel:SetActiveEx(currentPanel == self.data.OpenTog.SKILL_POINT_PANEL)
    self.panel.SkillLeaningPreviewPanel.LuaUIGroup.gameObject:SetActiveEx(currentPanel == self.data.OpenTog.SKILL_PREVIEW)
    self.panel.ButtonSettingPanel.gameObject:SetActiveEx(currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING)

    if not self.isPreviewPanel then
        if currentPanel == self.data.OpenTog.SKILL_POINT_PANEL then
            self:UpdateSkillState(self.currentProType, true)
        elseif currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
            self:InitButtonSetting(self.currentProType)
        end
    else
        self:InitProfessionPreview(self.currentProType)
    end

end

--==============================--
--@Descriptions: 技能面板顶部信息
--@Date: 2018/10/31
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:UpdateTopInfo(proType)

    self.panel.SkillPoint:SetActiveEx(proType ~= self.data.ProfessionList.BASE_SKILL)
    self.panel.EmptyPoint:SetActiveEx(proType == self.data.ProfessionList.BASE_SKILL)
    self.panel.TopButtonPanel.gameObject:SetActiveEx(not self.isPreviewPanel)
    if not self.isPreviewPanel then
        self.proId = self.data.GetProfessionId(proType)
        self.professionRow = self.data.GetDataFromTable("ProfessionTable", self.proId)--当前页面职业
        self.realProfessionRow = self.data.GetDataFromTable("ProfessionTable", MPlayerInfo.ProID)--实际职业

        self.panel.TxtProfessionName.LabText = self.professionRow.SkillTabName
        self.panel.TxtProfessionEnglishName.LabText = string.upper(self.professionRow.EnglishName)
        self.panel.ImgProfessionIcon:SetSprite("CommonIcon", self.professionRow.SkillTabIcon, true)
        self.currentProType = proType
        self.skillIdList = Common.Functions.VectorSequenceToTable(self.professionRow.SkillIds)

        local curProType, curProId = self.data.CurrentProTypeAndId()
        if curProType >= self.data.ProfessionList.PRO_TWO then
            self.panel.BtnRecommendSkillPointText.LabText = Lang("SKILLLEARNING_RECOMMAND_SKILL_CLASS")
            self.panel.BtnRecommendSkillPoint:AddClick(function()
                UIMgr:ActiveUI(UI.CtrlNames.ProfessionalSchools, function(ctrl)
                    ctrl:InitWithProfessionId(curProId)
                end)
            end)
        else
            self.panel.BtnRecommendSkillPointText.LabText = Lang("SKILLLEARNING_RECOMMAND_ADD_POINT")
            self.panel.BtnRecommendSkillPoint:AddClick(function()
                --非OX新手指引 点这个按钮强关
                local l_guideData = DataMgr:GetData("BeginnerGuideData")
                if l_guideData.GetCurGuideId() ~= l_guideData.SKILL_ADD_POINT_CHECK_GUIDE_ID then
                    MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
                end
                --推荐加点
                self:RecommandAddSkillPoint()
            end)
        end
    end

end

--设置当前的职业Toggle
function SkillLearningCtrl:SetCurrentProfessionTog()

    if self.directOpenPreview then
        self:SetProTog(self.data.ProfessionList.PRO_TWO)
        return
    end

    local l_professionInfo = self.data.GetProfessionInfo()
    for i = self.data.ProfessionList.PRO_FOUR, self.data.ProfessionList.PRO_ONE, -1 do
        local l_currentInfo = l_professionInfo[i]
        local l_currentProId = l_currentInfo.proId
        local l_currentTog = self.toggleList[i]
        if l_currentProId ~= 0 and MPlayerInfo.ProID >= l_currentProId and self.data.IsProfessionPointFull(i) then
            l_currentTog.tog.TogEx.isOn = true
            self.currentProType = i
            return
        end
    end

    self.panel.ToggleBaseSkill.TogEx.isOn = true
    self.currentProType = self.data.ProfessionList.BASE_SKILL

end

function SkillLearningCtrl:SetTargetSkillId(skillId)

    local l_professionInfo = self.data.GetProfessionInfo()
    for i = self.data.ProfessionList.PRO_FOUR, self.data.ProfessionList.PRO_ONE, -1 do
        local l_currentInfo = l_professionInfo[i]
        local l_currentProId = l_currentInfo.proId
        local l_currentTog = self.toggleList[i]

        if l_currentProId ~= 0 then
            local l_proSkills = self.data.GetProfessionSkillsByProId(l_currentProId)
            for proskillId, v in pairs(l_proSkills) do
                if self.data.GetRootSkillId(proskillId) == self.data.GetRootSkillId(skillId) then
                    l_currentTog.tog.TogEx.isOn = true
                    self.currentProType = i
                    return
                end
            end
        end

    end

    self.panel.ToggleBaseSkill.TogEx.isOn = true
    self.currentProType = self.data.ProfessionList.BASE_SKILL

end

--==============================--
--@Description: 设置指定职业页签
--@Date: 2018/8/12
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:SetProTog(proType)

    if self.toggleList[proType] and self.toggleList[proType].openFunc then
        self.toggleList[proType].tog.TogEx.isOn = true
        self.currentProType = proType
    end

end

function SkillLearningCtrl:OnSkillPointApply(upgradeData)

    if self.skillAddPointTemplatePool then
        for k, v in pairs(self.skillAddPointTemplatePool.Items) do
            v:ShowApplyEff()
        end
    end
    self.data.AddedSkillPoint = {}
    self.cacheAddedSkillPoint = {}
    self:UpdateSkillState(self.currentProType)
    self:UpdateSkillSaver()

end

function SkillLearningCtrl:OnShowSkill()

    --if self.blockObj then self.blockObj:SetActiveEx(true) end
    self.panel.Bg:SetActiveEx(true)
    self:SetSkillPointPanelState(self.panel.SkillPointPanel.UObj, true)
    self.panel.BtnClose:SetActiveEx(true)

end

---------------------------SkillPoint---------------------------------------
-- 加点界面
function SkillLearningCtrl:InitAddPointPanel(proType, proId)

    self.proId = proId
    self.currentProType = proType
    --重置剩余点数
    self:ResetRealLeftSkillPoint(self.proId)

    -- TODO 双天赋
    local skillTalentIsOpen = MgrMgr:GetMgr("MultiTalentMgr").IsMultiTalentMgrOpen(GameEnum.MultiTaltentType.Skill)
    self.panel.SkillPlan:SetActiveEx(skillTalentIsOpen)

    self.data.AddedSkillPoint = table.ro_deepCopy(self.cacheAddedSkillPoint)
    self.skillBtnTempTable = {}
    local l_datas = {}
    local l_professionIdList = MPlayerInfo.ProfessionIdList
    for i = 0, l_professionIdList.Count - 1 do
        table.insert(l_datas,
        {
            skillLearningCtrl = self,
            proId = l_professionIdList[i],
            proType = i,
        })
    end
    self.skillAddPointTemplatePool:ShowTemplates({ Datas = l_datas })

    local scrollRect = self.panel.ProfessionScrollView.gameObject:GetComponent("ScrollRectWithCallback")
    scrollRect.OnBeginDragCallback = function()
        self.addpointPanelDraging = true
        self.proTypeBeforeDrag = self.currentProType
    end

    scrollRect.OnEndDragCallback = function()
        local l_proType = self:GetMoveToNextAddPointPanelType(self.panel.ProfessionScrollView.transform.localPosition.y)
        if self.proTypeBeforeDrag ~= l_proType then
            self.toggleList[l_proType].tog.TogEx.isOn = true
            local l_target = self:GetAddPointPanelPos(l_proType)
            self.panel.SkillAddPointContent.transform:DOLocalMoveY(l_target, 0.5)
        end
        self.addpointPanelDraging = false
    end

    local onArrowUp = function()
        local targetProType = self.data.ProfessionList.BASE_SKILL
        local l_target = self:GetAddPointPanelPos(targetProType)
        self.panel.SkillAddPointContent.transform:DOLocalMoveY(l_target, 0.5):OnComplete(function()
            self.toggleList[targetProType].tog.TogEx.isOn = true
        end)
    end

    local onArrowDown = function()
        if self.maxProId < 0 then return end
        local targetProType = self.maxProId
        local l_target = self:GetAddPointPanelPos(targetProType)
        self.panel.SkillAddPointContent.transform:DOLocalMoveY(l_target, 0.5):OnComplete(function()
            self.toggleList[targetProType].tog.TogEx.isOn = true
        end)
    end

    self.panel.ProfessionScrollView:SetScrollRectGameObjListener(self.panel.AddPointArrowUp.gameObject,
        self.panel.AddPointArrowDown.gameObject, onArrowUp, onArrowDown)
    self.panel.SkillAddPointContent.gameObject:SetLocalPosY(self:GetAddPointPanelPos(proType))

end

function SkillLearningCtrl:GetAddPointPanelHeight(proType)

    local l_professionId = self.data.GetProfessionId(proType)
    local l_lineNum = self.data.GetDataFromTable("ProfessionTable", l_professionId).SkillLineNum
    return SKILL_LINE_HEIGHT * l_lineNum

end

function SkillLearningCtrl:GetAddPointPanelPos(proType)

    local result = 0
    for i = self.data.ProfessionList.BASE_SKILL, proType - 1 do
        result = result + self:GetAddPointPanelHeight(i)
    end
    return result

end

function SkillLearningCtrl:GetMoveToNextAddPointPanelType()

    local l_contentY = self.panel.SkillAddPointContent.transform.localPosition.y
    local l_currentProType = self.currentProType
    local l_updis = l_contentY - (self:GetAddPointPanelPos(l_currentProType));
    local l_downdis = l_contentY - (self:GetAddPointPanelPos(l_currentProType) + self:GetAddPointPanelHeight(l_currentProType)) + 500;
    --logGreen("l_updis", l_updis, "l_downdis", l_downdis)

    if l_updis < 0 and math.abs(l_updis) > 100 then
        l_currentProType = l_currentProType - 1
    end
    if l_downdis > 0 and math.abs(l_downdis) > 100 then
        l_currentProType = l_currentProType + 1
    end
    --logGreen("l_currentProType", l_currentProType)
    return l_currentProType

end

--更新目前的技能状态
function SkillLearningCtrl:UpdateSkillState(proType, moveToCurrent)

    if not self.panel then return end
    if moveToCurrent and not self.addpointPanelDraging then
        local l_target = self:GetAddPointPanelPos(proType)
        self.panel.SkillAddPointContent.transform:DOLocalMoveY(l_target, 0.5)
    end
    if self.skillAddPointTemplatePool then
        for k, v in pairs(self.skillAddPointTemplatePool.Items) do
            v:UpdateAllBtn()
        end
    end

    -- 技能点
    self.panel.TxtCurrentSkillPoint.transform.parent.gameObject:SetActiveEx(proType ~= self.data.ProfessionList.BASE_SKILL)
    --应用加点
    self.panel.BtnApplySkillPoint:AddClick(function()
        -- 变身期间不能加点
        if MEntityMgr.PlayerEntity.IsTransfigured then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_SKILL_POINT"))
            return
        end
        if self.saveCD > 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FAIL_ENTER_FB_REQUEST_TOO_FAST"))
            return
        end
        self.saveCD = 1
        self:ApplySkillPoint()
    end)

    --取消加点
    self.panel.BtnCancelSkillPoint:AddClick(function()
        self:CancelSkillPoint()
        UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    end)

    self.panel.BtnCloseTip:SetActiveEx(false)
    self:UpdateSkillSaver()
    self:UpdateProSkillPoint(self.proId)
    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)

end

function SkillLearningCtrl:ApplySkillPoint()

    if self.proId == 0 or self.data.AddedSkillPoint == {} then
        return
    end
    self.mgr.SetSkillPoint(self.proId, self.data.AddedSkillPoint)

end

function SkillLearningCtrl:CancelSkillPoint()

    for id, point in pairs(self.data.AddedSkillPoint) do
        self.data.AddedSkillPoint[id] = nil
    end
    self.data.AddedSkillPoint = {}
    self:ResetRealLeftSkillPoint(self.proId)
    self:UpdateSkillState(self.currentProType)

end

function SkillLearningCtrl:ReturnSkillPoint(skillId)

    local addPoint = self.data.AddedSkillPoint[skillId]
    if addPoint ~= nil then
        local currentRemainPoint = self.data.GetRemainingPoint() + (self.data.AddedSkillPoint[skillId] or 0)
        self.data.GetRemainingPoint(currentRemainPoint)
        self.data.AddedSkillPoint[skillId] = nil
    end

end

function SkillLearningCtrl:OutputPreSkillRequired(PreSkillRequired)

    local function logSequence(tself)
        local temp = {}
        temp[#temp + 1] = 'sequence('
        for i = 0, tself:Size() - 1 do
            if i ~= 0 then
                temp[#temp + 1] = ', '
            end
            temp[#temp + 1] = tostring(tself[i])
        end
        temp[#temp + 1] = ')'
        return table.concat(temp, '')
    end
    local l_temp = {}
    l_temp[#l_temp + 1] = 'vector('
    for i = 0, PreSkillRequired.vector:size()-1 do
        if i ~= 0 then
            l_temp[#l_temp + 1] = ', '
        end

        l_temp[#l_temp + 1] = logSequence(PreSkillRequired.vector[i]) -- todo log sequence, vector
    end
    l_temp[#l_temp + 1] = ')'
    return table.concat(l_temp, '')

end

--推荐加点
function SkillLearningCtrl:RecommandAddSkillPoint(proDetailId)

    -- 变身期间不能加点
    if MEntityMgr.PlayerEntity.IsTransfigured then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_SKILL_POINT"))
        return
    end

    if MPlayerInfo.ProID == 1000 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SKILLLEARNING_AUTOSKILLPOINT_NEED_PROONE"))
        return
    end

    if self.data.GetRemainingPoint() <= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_RECOMMAND_NO_POINTS"))
        return
    end

    self:CancelSkillPoint()

    local l_detailId = 0
    if proDetailId == nil then
        local l_parentPro = self.data.GetProOneId()
        local l_row = self.data.GetDataFromTable("AutoAddSkillPointTable", l_parentPro)
        l_detailId = l_row.ProDetailId[0]
    else
        l_detailId = proDetailId
    end
    self.mgr.SkillRecommendId = l_detailId
    local l_detailRow = self.data.GetDataFromTable("AutoAddSkilPointDetailTable", l_detailId)
    if not l_detailRow then
        return
    end
    local openSkills = self.data.GetOpenSkillIdsByProType()
    local recommandLvs = {}
    local l_addSkillQueue = l_detailRow.AddSkillQueue
    local costPoint = 0
    for i = 0, l_addSkillQueue.Count - 1 do
        --检查剩余点数
        if self.data.GetRemainingPoint() <= 0 then
            break
        end
        local l_skillId = l_addSkillQueue:get_Item(i, 0)
        local l_skillLv = l_addSkillQueue:get_Item(i, 1)
        if openSkills[l_skillId] then
            local skillId = self.data.GetRootSkillId(l_skillId)
            local skillInfo = self.data.GetDataFromTable("SkillTable", skillId)
            local oldLv = recommandLvs[skillId] or MPlayerInfo:GetCurrentSkillInfo(skillId).lv
            local maxSkillLv = self.data.GetMaxLv(skillInfo)
            local recommandLv = math.min(l_skillLv, maxSkillLv)
            if oldLv < recommandLv then
                if self.data.IsSkillActive(skillInfo) then
                    costPoint = 0
                    if self.data.GetRemainingPoint() > recommandLv - oldLv then
                        costPoint = recommandLv - oldLv
                    else
                        costPoint = self.data.GetRemainingPoint()
                    end
                    if not self.data.AddedSkillPoint[skillId] then
                        self.data.AddedSkillPoint[skillId] = costPoint
                    else
                        self.data.AddedSkillPoint[skillId] = self.data.AddedSkillPoint[skillId] + costPoint
                    end
                    self.data.SetRemainingPoint(self.data.GetRemainingPoint() - costPoint)
                    self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
                    local currentLvAfterChange = oldLv + costPoint
                    recommandLvs[skillId] = currentLvAfterChange
                    --logError(StringEx.Format("skillId = {0} name = {1} oldLv = {2} currentLvAfterChange = {3} ", skillId, skillInfo.Name, oldLv, currentLvAfterChange))
                    self.mgr.EventDispatcher:Dispatch(self.mgr.ON_SKILL_INFO_UPDATE, skillId, currentLvAfterChange)
                else
                    if logFlag then
                        logError(StringEx.Format("proDetailId:{0} l_detailId:{1} 技能推荐加点 前置条件不满足 skillId:{2} recommandLv = {3} preRequire = {4}",
                        proDetailId, l_detailId, skillId, l_skillLv, self:OutputPreSkillRequired(skillInfo.PreSkillRequired)))
                    end
                end
            end
        end
    end

    MAudioMgr:Play("event:/UI/SkillPanelAddPoint")
    -- 定位推荐职业页签
    local curProType, curProId = self.data.CurrentProTypeAndId()
    local proId, proSkills
    local destProType = curProType
    for i = 1, curProType do
        proId = self.data.GetProfessionId(i)
        if not self.data.IsSameWithAutoSkillQueue(proId, l_addSkillQueue) then
            destProType = i
            break
        end
    end
    --self:SetProTog(destProType)
    self:UpdateSkillState(destProType)
    self:ShowEff(recommandLvs, GameEnum.EffType.PlusSkill)

end

function SkillLearningCtrl:ShowEff(recommandLvs, effType)

    if self.skillAddPointTemplatePool then
        for k, v in pairs(self.skillAddPointTemplatePool.Items) do
            v:ShowEffBatch(recommandLvs, effType)
        end
    end

end

--重置技能
function SkillLearningCtrl:ResetSkills()

    if not self.mgr.CanResetSkills() then
        return
    end

    local limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local leftAttrCount = limitBuyMgr.GetItemCanBuyCount(limitBuyMgr.g_limitType.SKILL_RESET, '0')
    if leftAttrCount > 0 then
        local l_txt = Lang("ATTR_LIMIT_WORDS",leftAttrCount)
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            self.mgr.SendSkillReset()
        end)
    else
        --重置技能消耗
        local l_consume = MGlobalConfig:GetVectorSequence("ResetSkillPointCost")
        local l_consumeDatas = {}
        for i = 0, l_consume.Length - 1 do
            local l_data = {}
            l_data.ID = tonumber(l_consume[i][0])
            l_data.IsShowCount = false
            l_data.IsShowRequire = true
            l_data.RequireCount = tonumber(l_consume[i][1])
            table.insert(l_consumeDatas,l_data)
        end
        CommonUI.Dialog.ShowConsumeDlg("", Lang("SKILLLEARNING_RESET_SKILL_NEED_ITEM"),
            function()
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SKILLLEARNING_CONFIRM_RESET_SKILL"), function()
                    self.mgr.SendSkillReset()
                end)
            end,
        nil, l_consumeDatas)
    end

end

--更新保存条
function SkillLearningCtrl:UpdateSkillSaver()

    if not self.currentPanel or self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:SetSavePanelState(false)
    else
        local isClose = self.data.AddedSkillPoint == nil
        if not isClose then
            isClose = true
            for k, v in pairs(self.data.AddedSkillPoint) do
                if v > 0 then
                    isClose = false
                    break
                end
            end
        end
        self:SetSavePanelState(not isClose)
    end

end

function SkillLearningCtrl:HasAddedPoint()

    local isClose = self.data.AddedSkillPoint == nil
    if not isClose then
        isClose = true
        for k, v in pairs(self.data.AddedSkillPoint) do
            if v > 0 then
                isClose = false
            end
        end
    end
    return not isClose

end

--传入的是根节点
function SkillLearningCtrl:OnClickSkillButton(id, obj, isBuff, pos)

    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    --打开tip
    local l_skillData =
    {
        openType = DataMgr:GetData("SkillData").OpenType.SetSkillTip,
        skillInfo = self.data.GetDataFromTable("SkillTable", id),
        id = id,
        isBuff = isBuff,
        pos = pos,
        currentPanel = self.currentPanel
    }
    UIMgr:ActiveUI(UI.CtrlNames.SkillPointTip, l_skillData)

end

--重置当前剩余技能点
function SkillLearningCtrl:ResetRealLeftSkillPoint(proId)

    if not self.panel then return end
    local leftSkillPoint = self.data.GetSkillLeftPoint()
    for k, v in pairs(self.data.AddedSkillPoint) do
        leftSkillPoint = leftSkillPoint - v
    end

    self.data.SetRemainingPoint(leftSkillPoint)
    self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
    self.panel.TxtRemainingPoint.LabText = leftSkillPoint
    self.currentLeftSkillPoint = leftSkillPoint
    self:UpdateProSkillPoint(proId)

end

--更新职业技能点
function SkillLearningCtrl:UpdateProSkillPoint(proId)

    if self.isPreviewPanel then return end
    proId = proId or self.proId

    local learnedSkillPoint = self.data.GetAddedProfessionSkillPointNumber(proId)
    local _, needJob = self.data.GetNeedBaseAndJobLvByProType(self.currentProType)

    if self.data.IsUseUpAllCurrentProfessionSkillPoint(self.currentProType) > 0 then
        self.panel.TxtCurrentSkillPoint.LabText = StringEx.Format("{0}/{1}", GetColorText(learnedSkillPoint, RoColorTag.Yellow), needJob)
    else
        self.panel.TxtCurrentSkillPoint.LabText = StringEx.Format("{0}/{1}", learnedSkillPoint, needJob)
    end

end

--可以学习
function SkillLearningCtrl:CanLearn(skillInfo)

    local skillId = skillInfo.Id
    --是否是自带技能
    if not self.data.NeedSkillPointToLearn(skillId) then
        return false
    end
    --前置技能是否满足条件
    if not self.data.IsSkillActive(skillInfo) then
        return false
    end
    if self.isPreviewPanel then
        return false
    end
    if self.data.IsLvMax(skillInfo) then
        return false
    end
    return true

end

---------------------------SkillPoint---------------------------------------
---------------------------SkillSlot----------------------------------------
function SkillLearningCtrl:AddSkillBtn(skillId, isBuff)

    local id = skillId
    local helpSkillNum = 0
    --local id = self.data.GetRootSkillId(rawid)
    local skillInfo = self.data.GetDataFromTable("SkillTable", id)
    if skillId == self.data.SkillQueueId then               --技能队列技能特判
        skillInfo.lv = 1
        self:AddCommonBtn(skillInfo, isBuff)
    end
    if skillInfo.SkillTypeIcon ~= 3 then
        local skillTypeIcon = skillInfo.SkillTypeIcon
        local playerSkillInfo = MPlayerInfo:GetCurrentSkillInfo(id, isBuff)
        skillInfo.lv = playerSkillInfo.lv
        local isFixed = self.data.IsFixed(id)
        local isUnlockFixed = self.data.IsUnlockFixed(id)
        if skillInfo.lv > 0 or isFixed or isUnlockFixed then
            if isBuff or isFixed or isUnlockFixed then
                self:AddCommonBtn(skillInfo, isBuff)
            elseif skillTypeIcon == 0 or skillTypeIcon == 1 then
                self:AddHurtBtn(skillInfo, isBuff)
            elseif skillTypeIcon == 2 then
                self:AddHelpBtn(skillInfo, isBuff)
                helpSkillNum = helpSkillNum + 1
            end
        end
    end
    return helpSkillNum

end

function SkillLearningCtrl:InitQueueSetting()

    l_helpNum = 0

    --销毁原有按钮
    local destroyTable = {}
    local commonSkillsTrans = self.panel.QueueHelpSkillsParent.gameObject.transform
    for i = 0, commonSkillsTrans.childCount - 1 do
        local currentBtn = commonSkillsTrans:GetChild(i).gameObject
        destroyTable[#destroyTable + 1] = currentBtn
    end
    for i, v in ipairs(destroyTable) do
        MResLoader:DestroyObj(v)
    end

    --添加按钮
    local skillList = self.data.GetLearnSkillIds()
    local helpSkillNum = 0
    for i, v in ipairs(skillList) do
        helpSkillNum = helpSkillNum + self:AddSkillBtn(v, false)
    end
    self.panel.QueueNone:SetActiveEx(helpSkillNum == 0)

    local l_skillRow = self.data.GetDataFromTable("SkillTable", self.data.SkillQueueId)
    local l_atlas = l_skillRow.Atlas
    local l_icon = l_skillRow.Icon
    self.panel.MainQueueIcon:SetSpriteAsync(l_atlas, l_icon)
    --更新是否使用最高等级
    self.panel.TogQueueMaxLevel:OnToggleChanged(function(on)
        self.data.SetUseMaxLevel(on)
        self.panel.TogUseMaxLevel.Tog.isOn = self.panel.TogQueueMaxLevel.Tog.isOn
        local useMaxLevelKey = "SkillSlotUseMaxLevel"..MEntityMgr.PlayerEntity.UID:tostring()
        PlayerPrefs.SetInt(useMaxLevelKey, on and 1 or 0)
    end)

end
--初始化ButtonSetting
function SkillLearningCtrl:InitButtonSetting(proType)

    l_hurtNum, l_commonNum, l_helpNum = 0, 0, 0

    --销毁原有按钮
    local destroyTable = {}
    local commonSkillsTrans = self.panel.CommonSkillsParent.gameObject.transform
    for i = 0, commonSkillsTrans.childCount - 1 do
        local currentBtn = commonSkillsTrans:GetChild(i).gameObject
        destroyTable[#destroyTable + 1] = currentBtn
    end

    local hurtSkillsTrans = self.panel.HurtSkillsParent.gameObject.transform
    for i = 0, hurtSkillsTrans.childCount - 1 do
        local currentBtn = hurtSkillsTrans:GetChild(i).gameObject
        destroyTable[#destroyTable + 1] = currentBtn
    end

    local helpeSkillsTrans = self.panel.HelpSkillsParent.gameObject.transform
    for i = 0, helpeSkillsTrans.childCount - 1 do
        local currentBtn = helpeSkillsTrans:GetChild(i).gameObject
        destroyTable[#destroyTable + 1] = currentBtn
    end
    for i, v in ipairs(destroyTable) do
        MResLoader:DestroyObj(v)
    end

    self.panel.BaseSkillTxt.LabText = Lang("SKILL_LEARNING_TEXT1")
    self.panel.LearnSkillTxt.LabText = Lang("SKILL_LEARNING_TEXT2")
    self.panel.HelpSkillTxt.LabText = Lang("SKILL_LEARNING_TEXT3")
    self.panel.DoubleDiskBtns.UObj:SetActiveEx(MPlayerSetting.SkillCtrlType == ESkillControllerType.DoubleDisk)
    self.panel.ClassicsBtns.UObj:SetActiveEx(MPlayerSetting.SkillCtrlType == ESkillControllerType.Classic)

    --添加按钮
    local skillList = self.data.GetLearnSkillIds()
    for i, v in ipairs(skillList) do
        self:AddSkillBtn(v, false)
    end
    local buffSkillIds = self.data.GetBuffSkillIds()
    for i, v in ipairs(buffSkillIds) do
        self:AddSkillBtn(v, true)
    end
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.QueueSkillFuncId) then
        self:AddSkillBtn(self.data.SkillQueueId)
    end
    self:UpdateShowSlotSkillContentSize()
    self.panel.SlotHurt.gameObject:SetActiveEx(false)

    --切换页面按钮
    self:GetSwitchBtn():AddClick(function()
        self:OnSwapSlot()
    end)

    self.panel.TogManSlot.TogEx.onValueChanged:AddListener(function(on)
        if on then
            if l_currentSlotGroup == SLOT_GROUP_AUTO then
                l_currentSlotGroup = l_manualSlotGroup
            end
            self:SwitchSlotGroup(l_currentSlotGroup)
        end
    end)

    self.panel.TogAutoSlot.TogEx.onValueChanged:AddListener(function(on)
        if on then
            self:SwitchSlotGroup(SLOT_GROUP_AUTO)
        end
    end)

    l_currentSlotGroup = l_currentSlotGroup or SLOT_GROUP_ONE
    if l_currentSlotGroup == SLOT_GROUP_AUTO then
        self.panel.TogAutoSlot.TogEx.isOn = true
    else
        self.panel.TogManSlot.TogEx.isOn = true
    end

    --更新是否使用最高等级
    self.panel.TogUseMaxLevel:OnToggleChanged(function(on)
        self.data.SetUseMaxLevel(on)
        self.panel.TogQueueMaxLevel.Tog.isOn = self.panel.TogUseMaxLevel.Tog.isOn
        local useMaxLevelKey = "SkillSlotUseMaxLevel"..MEntityMgr.PlayerEntity.UID:tostring()
        PlayerPrefs.SetInt(useMaxLevelKey, on and 1 or 0)
    end)

end

function SkillLearningCtrl:OnSwapSlot()

    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(ManTrsOpenSystemId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(ManTrsOpenSystemId))
        return
    end

    if l_currentSlotGroup == SLOT_GROUP_ONE then
        self:SwitchSlotGroup(SLOT_GROUP_TWO)
    else
        self:SwitchSlotGroup(SLOT_GROUP_ONE)
    end

end

function SkillLearningCtrl:ApplySkillSlot()

    local addSkillSlots, autoSkillSlots, queueSkillSlots = {}, {}, {}
    for j = 1, MPlayerInfo.SkillSlots.Length do
        if self.data.GetRootSkillId(l_slotTmpTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.SkillSlots[j - 1].id)
                or l_slotTmpTable[j].lv ~= MPlayerInfo.SkillSlots[j - 1].lv then
            addSkillSlots[j] =  l_slotTmpTable[j]
        end
    end
    for j = 1, MPlayerInfo.AutoSkillSlots.Length do
        if self.data.GetRootSkillId(l_slotAutoTmpTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.AutoSkillSlots[j - 1].id)
            or l_slotAutoTmpTable[j].lv ~= MPlayerInfo.AutoSkillSlots[j - 1].lv then
            autoSkillSlots[j] = l_slotAutoTmpTable[j]
        end
    end
    for j = 1, MPlayerInfo.QueueSkillSlot.Length do
        if self.data.GetRootSkillId(l_slotQueueTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.QueueSkillSlot[j - 1].id)
                or l_slotQueueTable[j].lv ~= MPlayerInfo.QueueSkillSlot[j - 1].lv then
            queueSkillSlots[j] = l_slotQueueTable[j]
        end
    end

    for i, v in pairs(addSkillSlots) do
        addSkillSlots[i].id = self.data.GetProfessionSkillId(v.id)
    end
    for i, v in pairs(autoSkillSlots) do
        autoSkillSlots[i].id = self.data.GetProfessionSkillId(v.id)
    end
    for i, v in pairs(queueSkillSlots) do
        queueSkillSlots[i].id = self.data.GetProfessionSkillId(v.id)
    end
    self.mgr.SetSkillSlot(addSkillSlots, autoSkillSlots, queueSkillSlots)

end

function SkillLearningCtrl:CreateBtn(skillInfo, isBuff, parent, dragParent)

    local l_go
    l_go = self:CloneObj(self.panel.SlotHurt.gameObject)
    l_go.transform:SetParent(parent)
    l_go:SetActiveEx(true)
    l_go.transform.localScale = self.panel.SlotHurt.gameObject.transform.localScale

    --设置名字
    local skillName = skillInfo.Name
    local skillId = skillInfo.Id
    l_go.transform:Find("Bg_zikuang3"):Find("Text"):GetComponent("MLuaUICom").LabText = skillName
    l_go.transform:Find("Bg_zikuang5"):Find("Text"):GetComponent("MLuaUICom").LabText = skillName
    if #skillName / 3 > 3 then
        l_go.transform:Find("Bg_zikuang3").gameObject:SetActiveEx(false)
        l_go.transform:Find("Bg_zikuang5").gameObject:SetActiveEx(true)
    else
        l_go.transform:Find("Bg_zikuang3").gameObject:SetActiveEx(true)
        l_go.transform:Find("Bg_zikuang5").gameObject:SetActiveEx(false)
    end
    --设置等级
    if (not self.data.NeedSkillPointToLearn(skillInfo.Id)) or skillInfo.Id == self.data.SkillQueueId then
        l_go.transform:Find("Image").gameObject:SetActiveEx(false)
    else
        l_go.transform:Find("Image").gameObject:SetActiveEx(true)
        if isBuff then
            l_go.transform:Find("Image/LvText"):GetComponent("MLuaUICom").LabText = skillInfo.lv
        else
            l_go.transform:Find("Image/LvText"):GetComponent("MLuaUICom").LabText = skillInfo.lv .. "/" .. skillInfo.EffectIDs.Length
        end
    end

    local l_atlas = skillInfo.Atlas
    local l_icon = skillInfo.Icon
    local l_imgCom = l_go.transform:Find("SKILLICON").gameObject:GetComponent("MLuaUICom")
    local l_drgCom = l_imgCom:GetComponent("UIDragDropItem")
    l_imgCom:SetSpriteAsync(l_atlas,l_icon)
    l_drgCom.ignoreDrop = true
    l_drgCom._cloneOnDrag = true
    l_drgCom.interactable = true
    l_drgCom.dragDropRoot = dragParent
    l_drgCom.onBeginDrag = function(go, ed)
        l_dragOut = true
        l_dragStartPos = ed.position
        l_dragItem = l_drgCom
        self.isBuffSlot = isBuff
    end
    l_drgCom.onEndDrag = function(go, ed)
        l_dragOut = false
        self.isBuffSlot = false
        self:OnEndDrag(go, ed, nil, skillId, skillInfo.lv)
    end
    l_go:GetComponent("MLuaUICom").Listener.onDown = function()
        l_imgCom.gameObject:SetLocalScale(0.9, 0.9, 0.9)
    end
    l_go:GetComponent("MLuaUICom").Listener.onUp = function()
        l_imgCom.gameObject.transform:SetLocalScaleOne()
    end
    l_go:GetComponent("MLuaUICom").Listener.onClick = function()
        self.currentPressSlot = l_go
        self.curretnPressSlotSkillId = skillId
        local lv = MPlayerInfo:GetCurrentSkillInfo(self.curretnPressSlotSkillId).lv
        self.mgr.ShowSkillTip(self.curretnPressSlotSkillId, self.currentPressSlot, lv)
    end
    return l_go

end

--添加伤害类技能
function SkillLearningCtrl:AddCommonBtn(skillInfo, isBuff)

    l_commonNum = l_commonNum + 1
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:CreateBtn(skillInfo, isBuff, self.panel.CommonSkillsParent.gameObject.transform, self.panel.ButtonSettingPanel.transform)
    end

end

--添加伤害类技能
function SkillLearningCtrl:AddHurtBtn(skillInfo, isBuff)

    l_hurtNum = l_hurtNum + 1
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:CreateBtn(skillInfo, isBuff, self.panel.HurtSkillsParent.gameObject.transform, self.panel.ButtonSettingPanel.transform)
    end

end

--添加支援类技能
function SkillLearningCtrl:AddHelpBtn(skillInfo, isBuff)

    l_helpNum = l_helpNum + 1
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:CreateBtn(skillInfo, isBuff, self.panel.HelpSkillsParent.gameObject.transform, self.panel.ButtonSettingPanel.transform)
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        self:CreateBtn(skillInfo, isBuff, self.panel.QueueHelpSkillsParent.gameObject.transform, self.panel.SkillQueue.transform)
    end

end

function SkillLearningCtrl:UpdateShowSlotSkillContentSize()

    local l_pos = self.panel.CommonParts.gameObject.transform.localPosition
    local commonLine = math.max(1, math.ceil(l_commonNum / l_skillRowNum))
    local hurtLine = math.max(1, math.ceil(l_hurtNum / l_skillRowNum))
    local helpLine = math.max(1, math.ceil(l_helpNum / l_skillRowNum))
    local offset = l_helpOffset * commonLine
    l_pos.y = l_startY - offset
    MLuaCommonHelper.SetLocalPos(self.panel.HurtParts.gameObject, l_pos)
    offset = offset + l_helpOffset * hurtLine
    l_pos.y = l_startY * 2 - offset
    MLuaCommonHelper.SetLocalPos(self.panel.HelpParts.gameObject, l_pos)

    local allLine = hurtLine + helpLine + commonLine
    if allLine > 3 then
        self.panel.ShowSlotSkillContent:SetHeight(570 + math.abs(l_startY / 2) + (allLine - 3) * l_helpOffset)
    else
        self.panel.ShowSlotSkillContent:SetHeight(570)
    end
    self.panel.SettingSkillScroll:SetScrollRectGameObjListener(self.panel.ImgUp.gameObject, self.panel.ImgDown.gameObject, nil, nil)
    self.panel.ImgUp:SetActiveEx(allLine > 3)
    self.panel.ImgDown:SetActiveEx(allLine > 3)

end

function SkillLearningCtrl:GetSlot(i)

    if self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        return self.panel.QueuePanelSlot[i]
    elseif MPlayerSetting.SkillCtrlType == ESkillControllerType.Classic then
        return self.panel.ClassicsPanelSlot[i]
    else
        return self.panel.PanelSlot[i]
    end

end

function SkillLearningCtrl:GetSlotTxtLv(i)

    if self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        return self.panel.QueueTxtSlotLv[i]
    elseif MPlayerSetting.SkillCtrlType == ESkillControllerType.Classic then
        return self.panel.ClassicsTxtSlotLv[i]
    else
        return self.panel.TxtSlotLv[i]
    end

end

function SkillLearningCtrl:GetSwitchBtn()

    if MPlayerSetting.SkillCtrlType == ESkillControllerType.Classic then
        return self.panel.ClassicsBtnManTrs
    else
        return self.panel.BtnManTrs
    end

end

--初始化技能槽
--==============================--
--@Description:
--@Date: 2018/11/24
--@Param: [args]
--@Return: 一次交换 两次onleave ==> ondrop
--@ 外部拖入 一次 onleave ==> ondrop
--==============================--
function SkillLearningCtrl:InitSlot()

    for i = 1, l_slotCount do
        self:GetSlotTxtLv(i).gameObject:SetActiveEx(false)
        --人物身上的先设进去
        for j = 1, MPlayerInfo.SkillSlots.Length do
            l_slotTmpTable[j] = MPlayerInfo.SkillSlots[j - 1]
        end

        for j = 1, MPlayerInfo.AutoSkillSlots.Length do
            l_slotAutoTmpTable[j] = MPlayerInfo.AutoSkillSlots[j - 1]
        end
    end

    for i = 1, l_queueCount do
        self:GetSlotTxtLv(i).gameObject:SetActiveEx(false)
        for j = 1, MPlayerInfo.QueueSkillSlot.Length do
            l_slotQueueTable[j] = MPlayerInfo.QueueSkillSlot[j - 1]
        end
    end

end
--==============================--
--@Description: 是否空槽
--@Date: 2018/8/14
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:IsEmptySlot(slotType)

    local ret = true
    if slotType == SLOT_GROUP_AUTO then
        for i, v in ipairs(l_slotAutoTmpTable) do
            if v.id ~= 0 then
                ret = false
                break
            end
        end
    else
        local v
        for i = 1, l_slotCount do
            v = l_slotTmpTable[i + slotType * l_slotCount]
            if v.id ~= 0 then
                ret = false
                break
            end
        end
    end
    return ret

end

--==============================--
--@Description: 根据插槽类型和id找slot
--@Date: 2018/8/13
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:FindSkillInfoBySlotGroupTypeAndSkillId(groupType, skillId, isOld)

    local skillInfo, idx
    local tmpTable = isOld and lastSlotTmpTable or l_slotTmpTable
    local autoTable = isOld and lastAutoSlotTmpTable or l_slotAutoTmpTable
    if groupType == SLOT_GROUP_AUTO then
        for k, v in pairs(autoTable) do
            if self.data.GetRootSkillId(v.id) == self.data.GetRootSkillId(skillId) then
                skillInfo = v
                idx = k
                break
            end
        end
    else
        local startIdx, endIdx = 1 + l_slotCount * groupType, l_slotCount * (groupType + 1)
        for i = startIdx, endIdx do
            if self.data.GetRootSkillId(tmpTable[i].id) == self.data.GetRootSkillId(skillId) then
                skillInfo = tmpTable[i]
                idx = i
                break
            end
        end
    end
    return skillInfo, idx

end

function SkillLearningCtrl:GetSlotInfoByIdx(idx)

    if l_currentSlotGroup == SLOT_GROUP_AUTO then
        return l_slotAutoTmpTable[idx]
    else
        return l_slotTmpTable[idx + l_currentSlotGroup * self.data.SlotCount]
    end

end

--==============================--
--@Description: 保存插槽
--@Date: 2018/8/13
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:SaveSkillSlot()

    if not next(l_slotTmpTable) then return end

    local shouldSave = false
    for j = 1, MPlayerInfo.SkillSlots.Length do
        if self.data.GetRootSkillId(l_slotTmpTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.SkillSlots[j - 1].id)
            or l_slotTmpTable[j].lv ~= MPlayerInfo.SkillSlots[j - 1].lv then
            shouldSave = true
            break
        end
    end

    for j = 1, MPlayerInfo.AutoSkillSlots.Length do
        if self.data.GetRootSkillId(l_slotAutoTmpTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.AutoSkillSlots[j - 1].id)
            or l_slotAutoTmpTable[j].lv ~= MPlayerInfo.AutoSkillSlots[j - 1].lv then
            shouldSave = true
            break
        end
    end

    for j = 1, MPlayerInfo.QueueSkillSlot.Length do
        if self.data.GetRootSkillId(l_slotQueueTable[j].id) ~= self.data.GetRootSkillId(MPlayerInfo.QueueSkillSlot[j - 1].id)
                or l_slotQueueTable[j].lv ~= MPlayerInfo.QueueSkillSlot[j - 1].lv then
            shouldSave = true
            break
        end
    end

    if shouldSave then
        self:ApplySkillSlot()
    end

end


function SkillLearningCtrl:BeforeSlotLeaveContainer()

    if l_currentSlotGroup ~= SLOT_GROUP_AUTO then
        for k, v in ipairs(l_slotTmpTable) do
            lastSlotTmpTable[k] = v
        end
    else
        for k, v in ipairs(l_slotAutoTmpTable) do
            lastAutoSlotTmpTable[k] = v
        end
    end

end

--切换技能槽, 1 手动技能槽, 2 自动技能槽
function SkillLearningCtrl:TurnSlotTogOn(togType)

    if togType == 1 then
        self.panel.TogManSlot.TogEx.isOn = true
    else
        self.panel.TogAutoSlot.TogEx.isOn = true
    end

end

--切换技能槽页面的时候进行更新
function SkillLearningCtrl:SwitchSlotGroup(groupType)

    l_currentSlotGroup = groupType
    if l_currentSlotGroup ~= SLOT_GROUP_AUTO then l_manualSlotGroup = l_currentSlotGroup end
    self:GetSwitchBtn().gameObject:SetActiveEx(groupType ~= SLOT_GROUP_AUTO)
    self:UpdateSlots()

end

--==============================--
--@Description:刷新当前选择的技能槽
--@Date: 2019/2/25
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:UpdateSlots()

    local currentId, currentLv
    for i = 1, l_slotCount do
        currentId, currentLv = nil, nil
        if l_currentSlotGroup ~= SLOT_GROUP_AUTO then
            currentId = l_slotTmpTable[i + l_slotCount * l_currentSlotGroup].id
            currentLv = l_slotTmpTable[i + l_slotCount * l_currentSlotGroup].lv
        else
            currentId = l_slotAutoTmpTable[i].id
            currentLv = l_slotAutoTmpTable[i].lv
        end
        self:SetSkillSlot(i, currentId, currentLv)
    end

end

--刷新技能队列槽
function SkillLearningCtrl:UpdateQueueSlots()

    local currentId, currentLv
    for i = 1, l_queueCount do
        currentId, currentLv = nil, nil
        currentId = l_slotQueueTable[i].id
        currentLv = l_slotQueueTable[i].lv
        self:SetSkillSlot(i, currentId, currentLv)
    end
    self:SkillQueueUIUpdate()

end
--==============================--
--@Description: 重置自动按键配置
--@Date: 2018/8/14
--@Param: [args]
--@Return:
--==============================--
function SkillLearningCtrl:ResetAutoSkillSlot()

    if lastAutoSlotTmpTable then
        for k, v in pairs(lastAutoSlotTmpTable) do
            l_slotAutoTmpTable[k] = v
        end
        self:SwitchSlotGroup(l_currentSlotGroup)
    end

end

--设置技能槽
function SkillLearningCtrl:SetSkillSlot(slotIndex, skillId, lv)

    local slotIcon
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        slotIcon = MPlayerSetting.IsClassic and self.panel.ClassicSlotIcons[slotIndex] or self.panel.DoubleSlotIcons[slotIndex]
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        slotIcon = self.panel.QueueSlotIcons[slotIndex]
    end
    --QueueSlotIcons
    slotIcon.transform:SetLocalScaleOne()
    slotIcon.transform:SetLocalPosZero()

    local dropItem = slotIcon:GetComponent("UIDragDropItem")
    dropItem.ignoreDrop = true
    dropItem._cloneOnDrag = false
    dropItem.interactable = true
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        dropItem.dragDropRoot = self.panel.ButtonSettingPanel.transform
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        dropItem.dragDropRoot = self.panel.SkillQueue.transform
    end

    local uiCom = slotIcon:GetComponent("MLuaUICom")
    if skillId > 0 then
        local l_skillRow = self.data.GetDataFromTable("SkillTable", skillId)
        local l_atlas = l_skillRow.Atlas
        local l_icon = l_skillRow.Icon
        uiCom.Img.enabled = true
        uiCom:SetSpriteAsync(l_atlas, l_icon)

        dropItem.onBeginDrag = function()
            slotIcon.transform:SetLocalScale(0.9, 0.9, 0.9)
        end
        dropItem.onEndDrag = function(go, ed)
            slotIcon.transform:SetLocalScaleOne()
            self:OnEndDrag(go, ed, slotIndex)
        end
    else
        uiCom.Img.enabled = false
        dropItem.onBeginDrag = nil
        dropItem.onEndDrag = nil
    end

    local lvText = self:GetSlot(slotIndex).transform:Find("Text")
    if skillId == 0 or (not self.data.NeedSkillPointToLearn(skillId)) or skillId == self.data.SkillQueueId then
        lvText.gameObject:SetActiveEx(false)
    else
        lvText.gameObject:SetActiveEx(true)
        lvText:GetComponent("MLuaUICom").LabText = lv
    end
    lvText:SetAsLastSibling()

    dropItem:InitItem(false, false, self.data.GetRootSkillId(skillId))
    return dropItem

end

function SkillLearningCtrl:OnEndDrag(go, ed, idx, skillId, lv)

    local toIdx, exChangeSlots
    for i = 1, self.data.SlotCount do
        local slot = self:GetSlot(i)
        local rectTrans = slot:GetComponent("RectTransform")
        if RectTransformUtility.RectangleContainsScreenPoint(rectTrans, ed.position, ed.pressEventCamera) then
            toIdx = i
            break
        end
    end
    local isOut = skillId ~= nil
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        exChangeSlots = l_currentSlotGroup == SLOT_GROUP_AUTO and l_slotAutoTmpTable or l_slotTmpTable
        if idx then
            if l_currentSlotGroup ~= SLOT_GROUP_AUTO then
                idx = idx + l_currentSlotGroup * self.data.SlotCount
            end
            skillId = exChangeSlots[idx].id
            lv = exChangeSlots[idx].lv
        end
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        exChangeSlots = l_slotQueueTable
        if idx then
            skillId = exChangeSlots[idx].id
            lv = exChangeSlots[idx].lv
        end
    end

    --正在替换中的技能不让操作
    if MPlayerInfo:IsSkillReplaced(skillId, lv) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SKILL_IN_OPERATION"))
        return
    end
    --技能队列不能设置自动战斗
    if exChangeSlots == l_slotAutoTmpTable and skillId == self.data.SkillQueueId then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("QUEUESKILL_NO_DRAG"))
        return
    end
    if exChangeSlots == l_slotAutoTmpTable and (not self.data.IsHasAI(skillId)) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_AI_SKILL"))
        return
    end
    --QTE技能不能放入技能队列
    if exChangeSlots == l_slotQueueTable and self.data.IsQTE(skillId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("QTE_NO_DRAG"))
        return
    end
    if skillId == 0 then
        return
    end
    local l_skillTableData = self.data.GetDataFromTable("SkillTable", skillId)
    if toIdx then
        --玩家自己选择需要使用的技能，如果是Fix技能不需要显示，如果只是交换也不需要显示
        if not self.data.GetUseMaxLevel() and isOut and self.data.NeedSkillPointToLearn(skillId) then
            UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
            --外部拖入
            local l_skillData =
            {
                openType = DataMgr:GetData("SkillData").OpenType.DropSkillTip,
                lv = lv,
                idx = idx,
                skillId = skillId,
                toIdx = toIdx
            }
            UIMgr:ActiveUI(UI.CtrlNames.SkillPointTip, l_skillData)
        else
            if l_currentSlotGroup == SLOT_GROUP_AUTO and skillId and skillId == 600004 then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SKILL_DROP_TIP"),
                    function() self:DropSkillInSlot(idx, toIdx, skillId, lv) end, nil)
                return
            elseif l_currentSlotGroup == SLOT_GROUP_AUTO and l_skillTableData.IsAoe and not self.data.HasSaveToSlot(skillId) then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SKILL_FIRST_SAVE_AOE"),
                    function() self:DropSkillInSlot(idx, toIdx, skillId, lv) end, nil, nil, 4, "SKILL_FIRST_SAVE_AOE")
                return
            else
                self:DropSkillInSlot(idx, toIdx, skillId, lv)
            end
        end
    else
        --移除
        if l_currentSlotGroup == SLOT_GROUP_AUTO and idx then
            if self:GetCurrentSlotSkillCount() == 1 then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("SKILLLEARNING_TIP_SLOT_SHOULD_NOT_EMPTY"),
                    function() self:ResetAutoSkillSlot() end, function() self:ResetAutoSkillSlot() end)
                return
            elseif MPlayerInfo:GetRootSkillId(skillId) == 100001 then
                --判断是否移除攻击
                CommonUI.Dialog.ShowYesNoDlg(true, nil,
                    Lang("SKILLLEARNING_CONFIRM_SLOT_REMOVE_ATTACK"),
                    function()
                        if idx and skillId > 0 then
                            exChangeSlots[idx] = MoonClient.MSkillInfo.New()
                        end
                        if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
                            self:UpdateSlots()
                        elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
                            self:UpdateQueueSlots()
                        end
                    end,
                    function() self:ResetAutoSkillSlot() end)
                return
            end
        end
        if idx and skillId > 0 then
            exChangeSlots[idx] = MoonClient.MSkillInfo.New()
            end
        end
        if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
            self:UpdateSlots()
        elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
            self:UpdateQueueSlots()
    end

end

function SkillLearningCtrl:GetCurrentSlotSkillCount()

    local count = 0
    local slots
    local start, endIdx = 0, 0
    if l_currentSlotGroup == SLOT_GROUP_AUTO then
        slots = l_slotAutoTmpTable
        start, endIdx = 1, self.data.SlotCount
    else
        slots = l_slotTmpTable
        start, endIdx = 1 + l_currentSlotGroup * self.data.SlotCount, (l_currentSlotGroup + 1) * self.data.SlotCount
    end
    for i = start, endIdx do
        local slot = slots[i]
        if slot.id > 0 then
            count = count + 1
        end
    end
    return count

end

function SkillLearningCtrl:DropSkillInSlot(fromIdx, toIdx, skillId, lv)

    if fromIdx == toIdx then
        return
    end

    local fromSlotInfo, toSlotInfo, exChangeSlots
    local delta = 0
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        if l_currentSlotGroup == SLOT_GROUP_AUTO then
            if fromIdx then
                fromSlotInfo = l_slotAutoTmpTable[fromIdx]
            end
            toSlotInfo = l_slotAutoTmpTable[toIdx]
            exChangeSlots = l_slotAutoTmpTable
        else
            delta = l_currentSlotGroup * self.data.SlotCount
            if fromIdx then
                fromSlotInfo = l_slotTmpTable[fromIdx]
            end
            toIdx = toIdx + delta
            toSlotInfo = l_slotTmpTable[toIdx]
            --正在替换中的技能不让操作
            if MPlayerInfo:IsSkillReplaced(toSlotInfo.id, toSlotInfo.lv) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SKILL_IN_OPERATION"))
                return
            end
            exChangeSlots = l_slotTmpTable
        end
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        if fromIdx then
            fromSlotInfo = l_slotQueueTable[fromIdx]
        end
        toSlotInfo = l_slotQueueTable[toIdx]
        exChangeSlots = l_slotQueueTable
    end

    --玩家在Drop技能的时候掉出游戏
    if exChangeSlots == nil then
        return
    end
    if not fromSlotInfo then
        for i = 1 + delta, self.data.SlotCount + delta do
            if self.data.GetRootSkillId(exChangeSlots[i].id) == self.data.GetRootSkillId(skillId) then
                exChangeSlots[i] = MoonClient.MSkillInfo.New()
                break
            end
        end
        exChangeSlots[toIdx] = MoonClient.MSkillInfo.New()
        exChangeSlots[toIdx].id = skillId
        exChangeSlots[toIdx].lv = lv
        self.data.UpdateFirstSaveSKill({skillId})
    else
        if fromIdx then
            exChangeSlots[fromIdx] = toSlotInfo
        end
        exChangeSlots[toIdx] = fromSlotInfo
    end
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:UpdateSlots()
    elseif self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        self:UpdateQueueSlots()
    end

end


function SkillLearningCtrl:OnSkillSlotApply()

    --人物身上的先设进去
    for j = 1, MPlayerInfo.SkillSlots.Length do
        l_slotTmpTable[j] = MPlayerInfo.SkillSlots[j - 1]
    end

    for j = 1, MPlayerInfo.AutoSkillSlots.Length do
        l_slotAutoTmpTable[j] = MPlayerInfo.AutoSkillSlots[j - 1]
    end

    for j = 1, MPlayerInfo.QueueSkillSlot.Length do
        l_slotQueueTable[j] = MPlayerInfo.QueueSkillSlot[j - 1]
    end

    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:InitButtonSetting(self.currentProType)
    end
    if self.currentPanel == self.data.OpenTog.SKILL_QUEUE_SETTING then
        self:InitQueueSetting()
    end

end

---------------------------SkillSlot----------------------------------------
---------------------------ProfessionPreview-----------------------------------------

function SkillLearningCtrl:InitProfessionPreview(currentProType)

    local l_nextProIdList = self.data.GetNextProfessionList(MPlayerInfo.ProID)
    if #l_nextProIdList > 0 then
        if #l_nextProIdList == 1 then
            self:GetProfessionPreview(l_nextProIdList[1], currentProType)
        else
            --选职业UI打开
            self:InitProfessionChoose(l_nextProIdList, currentProType)
        end
    end

end

function SkillLearningCtrl:InitProfessionChoose(proList, currentProType)

    self.panel.JobChoose:SetActiveEx(true)
    self.panel.LeftJobChooseBtn:AddClick(function()
        self:GetProfessionPreview(proList[1], currentProType)
    end, true)
    self.panel.RightJobChooseBtn:AddClick(function()
        self:GetProfessionPreview(proList[2], currentProType)
    end, true)

    local l_previewData = self.data.GetDataFromTable("ProfessionPreviewTable", proList[1])
    local l_preview = self.data.GetDataFromTable("ProfessionTable", proList[1])
    self.panel.LeftJobName.LabText = l_preview.Name
    self.panel.LeftJobImage:SetSprite("Common", l_preview.ProfessionIcon)
    self.panel.LeftJobText.LabText = l_previewData.ProfessionDesc
    self.panel.LeftJobPic:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
    self.panel.LeftJobShadow:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
    l_previewData = self.data.GetDataFromTable("ProfessionPreviewTable", proList[2])
    l_preview = self.data.GetDataFromTable("ProfessionTable", proList[2])
    self.panel.RightJobName.LabText = l_preview.Name
    self.panel.RightJobImage:SetSprite("Common", l_preview.ProfessionIcon)
    self.panel.RightJobText.LabText = l_previewData.ProfessionDesc
    self.panel.RightJobPic:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)
    self.panel.RightJobShadow:SetRawTex(MPlayerInfo.IsMale and l_preview.ChooseJobPic[0] or l_preview.ChooseJobPic[1], true)

end

function SkillLearningCtrl:GetProfessionPreview(proID, currentProType)

    self.panel.JobChoose:SetActiveEx(false)
    local l_panelInfo =
    {
        proType = currentProType,
        proId = proID,
        panel = self.panel.SkillLeaningPreviewPanel,
        proData = self.data.GetDataFromTable("ProfessionTable", proID),
        previewData = self.data.GetDataFromTable("ProfessionPreviewTable", proID),
    }
    if l_panelInfo.previewData ~= nil then
        self:InitLeftPreview(l_panelInfo)
        self:InitRightPreview(l_panelInfo)
    else
        logError("无法从表：ProfessionPreviewTable中读取数据，原因：数据缺失")
    end

end

function SkillLearningCtrl:InitLeftPreview(panelInfo)

    local l_proData = panelInfo.proData
    local l_previewData = panelInfo.previewData
    local l_panel = panelInfo.panel.LeftPreview

    --Painting
    l_panel.ProfessionPainting:SetRawTex(StringEx.Format("Painting/{0}",l_previewData.ProfessionPainting), true)
    --Icon
    l_panel.PreviewProIcon:SetSprite("CommonIcon", l_proData.SkillTabIcon, true)
    l_panel.ProviewProName.LabText = l_proData.SkillTabName
    l_panel.ProviewProEnglishName.LabText = l_proData.EnglishName

    local l_attrNames = {"Str", "Vit", "Agi", "Int", "Dex", "Luk"}
    for k, v in ipairs(l_attrNames) do
        if l_panel[v .. "NameText"] then
            l_panel[v .. "NameText"].LabText = Lang("PROFESSION_PREVIEW_ATTR_" .. v)
        end
        if l_panel[v .. "Text"] then
            l_panel[v .. "Text"].LabText = l_previewData.ProfessionGain[k-1]
        end
    end

    local l_attrPolygon = l_panel.AttrPolygon.gameObject:GetComponent("MUISetPolygon")
    local l_attrData = l_previewData.AttrPolygon
    l_attrPolygon:SetValueByIndex(0, l_attrData[0] / 10.0)--str
    l_attrPolygon:SetValueByIndex(5, l_attrData[1] / 10.0)--vit
    l_attrPolygon:SetValueByIndex(1, l_attrData[2] / 10.0)--agi
    l_attrPolygon:SetValueByIndex(3, l_attrData[3] / 10.0)--int
    l_attrPolygon:SetValueByIndex(2, l_attrData[4] / 10.0)--dex
    l_attrPolygon:SetValueByIndex(4, l_attrData[5] / 10.0)--luk

end

function SkillLearningCtrl:InitRightPreview(panelInfo)

    local l_proType = panelInfo.proType
    local l_previewData = panelInfo.previewData
    local l_proId = panelInfo.proId
    local l_panel = panelInfo.panel.RightPreview

    --职业介绍
    l_panel.PreviewProIntroduce.LabText = l_previewData.ProfessionDesc

    --流派预览
    self.skillClassTemplateList = self.skillClassTemplateList or {}
    for _, v in ipairs(self.skillClassTemplateList) do
        self:UninitTemplate(v)
    end
    self.skillClassTemplateList = {}

    local l_templateObj = l_panel.ProfessionSkillClass
    l_templateObj.LuaUIGroup.gameObject:SetActiveEx(false)
    local l_skillClassCount = l_previewData.SkillClass.Length
    local l_skillPreviewData = {}
    for i = 0, l_skillClassCount - 1 do
        local l_skillClassName = l_previewData.SkillClass[i]
        local l_skillClassSkillIds = {}
        l_skillClassSkillIds[1] = l_previewData.SkillClassPreview:get_Item(i, 0)
        l_skillClassSkillIds[2] = l_previewData.SkillClassPreview:get_Item(i, 1)
        table.insert(l_skillPreviewData, {
            skillClassName = l_skillClassName,
            skillClassSkillIds = l_skillClassSkillIds
        })
    end
    self.skillPreviewPool:ShowTemplates({ Datas = l_skillPreviewData })

    --[[l_panel.Empty:SetActiveEx(l_skillClassCount < 3)
    if l_skillClassCount < 3 then
        l_panel.Empty.transform:SetAsLastSibling()
    end]]

    --前往转职按钮
    local l_currentProName = self.data.GetDataFromTable("ProfessionTable", MPlayerInfo.ProID).Name
    local l_baseLv, l_jobLv = self.data.GetNeedBaseAndJobLvByProType(l_proType)
    local realJobLv, _ = Common.CommonUIFunc.GetShowJobLevelAndProByLv(MPlayerInfo.JobLv, MEntityMgr.PlayerEntity.AttrRole.ProfessionID)
    local l_canGotoNext = realJobLv >= l_jobLv and MPlayerInfo.Lv >= l_baseLv
    local passColor, failColor = RoColorTag.Green, RoColorTag.Red

    l_panel.FinishLv.gameObject:SetActiveEx(l_canGotoNext)
    l_panel.NotFinishLv.gameObject:SetActiveEx(not l_canGotoNext)
    l_panel.ButtonLevel.gameObject:SetActiveEx(not l_canGotoNext)
    local baseLvColor = MPlayerInfo.Lv >= l_baseLv and passColor or failColor
    local jobLvColor = realJobLv >= l_jobLv and passColor or failColor
    local str1 = GetColorText(l_baseLv, baseLvColor)
    local str2 = GetColorText(l_jobLv, jobLvColor)
    l_panel.TextLevel.LabText = Lang("SKILLLEARNING_JOBLV_ENOUGH_TOGOTO_NEXT_NEW", str1, l_currentProName, str2)
    local hlayoutTrans = l_panel.TextLevel.transform.parent:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(hlayoutTrans)
    l_panel.ButtonLevel:AddClick(function()
        if not l_canGotoNext then
            local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
            if openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.Delegate) then
                MgrMgr:GetMgr("SystemFunctionEventMgr").DelegateEvent()
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_DELEGATE_OPEN_TIP"))
            end
        end
    end)

    ----任务判定
    local taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_targetProfessionRow = self.data.GetDataFromTable("TaskChangeJobTable", l_proId)
    if l_targetProfessionRow then
        local l_finish = taskMgr.CheckTaskFinished(l_targetProfessionRow.LimitTaskId)
        l_panel.FinishTask.gameObject:SetActiveEx(l_finish)
        l_panel.NotFinishTask.gameObject:SetActiveEx(not l_finish)
        l_panel.ButtonTask.gameObject:SetActiveEx(not l_finish)
        l_panel.TextTask.LabText = Lang("SKILLLEARNING_TRANSFER_TASK_NAME",
            GetColorText(taskMgr.GetTaskNameByTaskId(l_targetProfessionRow.LimitTaskId), RoColorTag.Yellow))
        hlayoutTrans = l_panel.TextTask.transform.parent:GetComponent("RectTransform")
        LayoutRebuilder.ForceRebuildLayoutImmediate(hlayoutTrans)
        l_panel.ButtonTask:AddClick(function()
            if l_baseLv > MPlayerInfo.Lv or l_jobLv > MPlayerInfo.JobLv then
                return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_LEVEL_NOT_REACH"))
            end
            if not l_finish then
                if l_targetProfessionRow then
                    taskMgr.OnQuickTaskClickWithTaskId(l_targetProfessionRow.FirstLimitTaskId)
                else
                    logError("TaskChangeJobTable未找到proId：", l_proId, l_targetProfessionRow.FirstLimitTaskId)
                end
            end
        end)
    end

end

function SkillLearningCtrl:OnEnterStage()

    if l_dragItem and self.panel then
        local moveObj = l_dragItem:GetMoveObject()
        if not MLuaCommonHelper.IsNull(moveObj) then
            local canvas = self.panel.PanelRef:GetComponent("Canvas")
            local screenPos = canvas.worldCamera:WorldToScreenPoint(moveObj.transform.position)
            local point = Vector2(screenPos.x, screenPos.y)
            MLuaClientHelper.ExcuteEndDragEvent(point, l_dragItem.gameObject)
        end
    end

end

function SkillLearningCtrl:OnResetSkill()

    self:ResetRealLeftSkillPoint(self.proId)
    self:UpdatePanel(self.currentPanel)
    if self.currentPanel == self.data.OpenTog.SKILL_BUTTON_SETTING then
        self:OnSkillSlotApply()
    end
    if self.currentPanel == self.data.OpenTog.SKILL_POINT_PANEL and self.toggleList[self.data.ProfessionList.PRO_ONE].openFunc() then
        self.toggleList[self.data.ProfessionList.PRO_ONE].tog.TogEx.isOn = true
    end

end
---------------------------ProfessionPreview-----------------------------------------
--lua custom scripts end

function SkillLearningCtrl:DirectOpenPreview()
    self.directOpenPreview = true
end

function SkillLearningCtrl:AddJobAwardPart()

    if not self.jobAwardPart then
        self.jobAwardPart = self:NewTemplate("JobAdditionTemplate",
        {
            TemplatePath = "UI/Prefabs/JobAddition",
            TemplateParent = self.uObj.transform,
        })
    end

end

function SkillLearningCtrl:SetAddtionPartVisible(flag)

    if self.jobAwardPart then
        if flag then
            self.jobAwardPart:ActiveTemplate()
            else
            self.jobAwardPart:DeActiveTemplate()
        end
    end

end

function SkillLearningCtrl:OnSkillPlanChange()

    self.data.AddedSkillPoint = {}
    self.cacheAddedSkillPoint = {}
    self:OnResetSkill()
    self:UpdateSkillState(self.currentProType)
    self:UpdateSkillSaver()

end

function SkillLearningCtrl:SkillQueueUIUpdate()

    for i = 1, l_queueCount do
        if l_slotQueueTable[i].id ~= 0 then
            self.panel.Queue[i].Img.color = queueUseColor
            self.panel.Queue[i].gameObject.transform:SetLocalScale(0.5, 0.5, 1)
        else
            self.panel.Queue[i].Img.color = queueUnUseColor
            self.panel.Queue[i].gameObject.transform:SetLocalScale(0.5, 0.5, 1)
        end
    end

end
---------------------------新手指引相关----------------------------------

--技能加点界面的技能加点按钮的新手指引
function SkillLearningCtrl:ShowBeginnerGuide_SkillAdd(guideStepInfo)

    --查找对应的技能按钮template
    local l_skillBtnTemp = self.skillBtnDic[guideStepInfo.ValueId]
    if l_skillBtnTemp ~= nil then
        MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_skillBtnTemp.uTrans.position, 
            l_skillBtnTemp.uTrans, guideStepInfo)

        --点任意技能的+号 都要关闭指引
        for k, v in pairs(self.skillBtnDic) do
            v:SetGuideClickEvent(function()
                MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
                for _, addBtn in pairs(self.skillBtnDic) do
                    addBtn:RemoveGuideClickEvent()
                end
            end)
        end
    end

end

--设置技能加点面板(SkillPointPanel或ProfessionScrollView)状态
function SkillLearningCtrl:SetSkillPointPanelState(panelObj, setState)

    --与原状态不符才做修改
    if panelObj.activeSelf ~= setState then
        panelObj:SetActiveEx(setState)
        if setState and self.guideArrow ~= nil then
            --如果是激活 并且 有新手指引箭头  刷新特效播放
            self.guideArrow:RefreshEffect()
        end
    end

end


--技能加点界面的OX按钮的新手指引
function SkillLearningCtrl:ShowBeginnerGuide_OX(guideStepInfo)

    if self.panel.SkillPointSaverPanel.UObj.activeSelf then
        local l_guideMgr = MgrMgr:GetMgr("BeginnerGuideMgr")
        --OX按钮类型需要单独重新设置当前步骤
        DataMgr:GetData("BeginnerGuideData").SetCurGuideId(guideStepInfo.ID)

        local l_aimBtn = self.panel.BtnApplySkillPoint
        l_guideMgr.SetGuideArrowForLuaBtn(self, l_aimBtn.transform.position, 
            l_aimBtn.transform, guideStepInfo)
        l_aimBtn:AddClick(function()
            l_guideMgr.LuaBtnGuideClickEvent(self)
        end, false)
    end

end

--设置OX按钮面板状态
function SkillLearningCtrl:SetSavePanelState(setState)

    --与原状态不符才做修改
    if self.panel.SkillPointSaverPanel.UObj.activeSelf ~= setState then
        self.panel.SkillPointSaverPanel.UObj:SetActiveEx(setState)
        if setState then
            --开启时触发新手指引检测
            local l_beginnerGuideChecks = {"SkillPointConfirm"}
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks)
        else
            --关闭时检测是否需要关闭新手指引 只是面板关闭不认为完成指引 只是清除原纪录
            if self.guideArrow ~= nil then
                self:UninitTemplate(self.guideArrow)
                self.guideArrow = nil
                DataMgr:GetData("BeginnerGuideData").SetCurGuideId(nil)
            end
        end
    end

end

--------------------------END 新手指引相关------------------------------
return SkillLearningCtrl