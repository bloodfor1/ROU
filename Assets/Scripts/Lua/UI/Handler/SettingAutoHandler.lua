--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SettingAutoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
SettingAutoHandler = class("SettingAutoHandler", super)
--lua class define end

--lua functions
function SettingAutoHandler:ctor()

    super.ctor(self, HandlerNames.SettingAuto, 0)

    self.addPickupSpeed = 0
    self.pressCountDown = 0
end --func end
--next--
function SettingAutoHandler:Init()

    self.panel = UI.SettingAutoPanel.Bind(self)
    super.Init(self)

    --解锁状态设置
    self:InitLockAndHelp()
    --技能设置
    self:InitSkillSetting()



    -- 挂机类型，1全自动，2半自动
    self.fightTypeTogs = {
        [MoonClient.EAutoFightType.FullAuto] = self.panel.FullyAutoTog,
        [MoonClient.EAutoFightType.SemiAuto] = self.panel.SemiAutoTog,
    }
    self.fightTypeTogs[MPlayerInfo.AutoFightType].Tog.isOn = true
    for type, tog in pairs(self.fightTypeTogs) do
        tog:OnToggleChanged(function(value)
            if value and MPlayerInfo.AutoFightType ~= type then
                MPlayerInfo.AutoFightType = type
                GlobalEventBus:Dispatch(EventConst.Names.UpdateAutoBattleState, MPlayerInfo.IsAutoBattle)
                if type == MoonClient.EAutoFightType.FullAuto then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("AUTO_BATTLE_TIPS_2"))
                elseif type == MoonClient.EAutoFightType.SemiAuto then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("AUTO_BATTLE_TIPS_3"))
                end

                self:RefreshRangeGray()
            end
        end)
    end

    --挂机范围类型，1自定义，2半屏，3全屏，4全图
    self.rangeTogs = {
        [MoonClient.EAutoFightRangeType.Custom] = self.panel.customTog,
        [MoonClient.EAutoFightRangeType.HalfScreen] = self.panel.halfScreenTog,
        [MoonClient.EAutoFightRangeType.FullScreen] = self.panel.fullScreenTog,
        [MoonClient.EAutoFightRangeType.FullMap] = self.panel.fullMapTog
    }
    self.rangeTogs[MPlayerInfo.AutoFightRangeType].Tog.isOn = true
    for type, tog in pairs(self.rangeTogs) do
        tog:OnToggleChanged(function(value)
            if value and MPlayerInfo.AutoFightRangeType ~= type then
                MPlayerInfo.AutoFightRangeType = type
                if type == MoonClient.EAutoFightRangeType.Custom then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("AUTO_BATTLE_TIPS_1"))
                elseif type == MoonClient.EAutoFightRangeType.HalfScreen then
                    self.isRangeSliderSilent = true
                    self.panel.RangeSlider.Slider.value = MGlobalConfig:GetSequenceOrVectorInt("AutoBattleRangeRadius")[1]
                    self.isRangeSliderSilent = false
                elseif type == MoonClient.EAutoFightRangeType.FullScreen then
                    self.isRangeSliderSilent = true
                    self.panel.RangeSlider.Slider.value = MGlobalConfig:GetSequenceOrVectorInt("AutoBattleRangeRadius")[2]
                    self.isRangeSliderSilent = false
                elseif type == MoonClient.EAutoFightRangeType.FullMap then

                end

                -- 切到全自动
                self.fightTypeTogs[MoonClient.EAutoFightType.FullAuto].Tog.isOn = true

                self:RefreshRangeGray()
            end
        end)
    end

    -- 挂机范围
    self.panel.NotMoveTip:SetActiveEx(MPlayerInfo.AutoFightRange == 0)
    self.panel.RangeSlider.Slider.minValue = 0
    self.panel.RangeSlider.Slider.maxValue = MGlobalConfig:GetSequenceOrVectorInt("AutoBattleRangeRadius")[2]
    self.panel.RangeSlider.Slider.value = MPlayerInfo.AutoFightRange
    self.panel.RangeNum.LabText = MPlayerInfo.AutoFightRange
    self.panel.RangeSlider:OnSliderChange(function(value)
        MPlayerInfo.AutoFightRange = value

        self.panel.RangeNum.LabText = MPlayerInfo.AutoFightRange

        if self.isRangePreview then
            MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerInfo.AutoFightRange, true)
        end

        if not self.isRangeSliderSilent then
            -- 切到自定义
            self.rangeTogs[MoonClient.EAutoFightRangeType.Custom].Tog.isOn = true
        end

        -- 切到全自动
        self.fightTypeTogs[MoonClient.EAutoFightType.FullAuto].Tog.isOn = true

        self.panel.NotMoveTip:SetActiveEx(value == 0)
    end)

    self.panel.UpDownArea.Listener.onDown = function(go, eventData)
        self.ctrlRef:SetAlpha(0.2)

        self.isRangePreview = true
        MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerInfo.AutoFightRange, true)
    end

    self.panel.UpDownArea.Listener.onUp = function(go, eventData)
        self.ctrlRef:SetAlpha(1)

        self.isRangePreview = false
        MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerInfo.AutoFightRange, false)
    end

    self.panel.UpDownArea.Listener:SetPassThroughGo(self.panel.RangeSlider.gameObject)

    self.panel.rangeTipText.LabText = Lang("SETTING_AUTO_RANGE_TIP")
    --杂物拾取设置
    self:InitPickUpSetting()

    self:RefreshRangeGray()

    self.panel.BtnDrinkMedicine:AddClick(function ()
        local tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenBag")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDev")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenPanel")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenTip")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        UIMgr:DeActiveUI(UI.CtrlNames.Setting)
        UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
        local l_beginnerGuideChecks = { "GetAutoDev" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.Main)
    end)

end --func end
--next--
function SettingAutoHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SettingAutoHandler:OnActive()
    --刷新布局
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Content.RectTransform)

end --func end
--next--
function SettingAutoHandler:OnDeActive()
    self:Save()
end --func end
--next--
function SettingAutoHandler:Update()
    if self.addPickupSpeed ~= 0 then
        if self.pressCountDown > 30 then
            self:SetPickUpPercent(MPlayerInfo.AutoPickUpPercent + self.addPickupSpeed)
        else
            self.pressCountDown = self.pressCountDown + 1
        end
    end

end --func end


--next--
function SettingAutoHandler:BindEvents()

    local l_slMgr = MgrMgr:GetMgr("SkillLearningMgr")
    self:BindEvent(l_slMgr.EventDispatcher, l_slMgr.ON_SKILL_SLOT_APPLY, self.FreshSkillSetting)

end --func end
--next--
--lua functions end

function SettingAutoHandler:InitLockAndHelp()

    local l_osMgr = MgrMgr:GetMgr("OpenSystemMgr")
    --技能
    if l_osMgr.IsSystemOpen(l_osMgr.eSystemId.AutoBattle) then
        self.panel.skillSetLock:SetActiveEx(false)
    else
        self.panel.skillSetLock:SetActiveEx(true)
        local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(l_osMgr.eSystemId.AutoBattle)
        self.panel.skillSetLockText.LabText = Lang("Main_NotOpenAutoBattleText", l_tableData.BaseLevel)
    end
    -- 自动战斗类型
    if l_osMgr.IsSystemOpen(l_osMgr.eSystemId.AutoFightType) then
        self.panel.autoStateLock:SetActiveEx(false)
    else
        local l_achievementLevel = l_osMgr.GetSystemAchievementLevel(l_osMgr.eSystemId.AutoFightType)
        self.panel.autoStateLock:SetActiveEx(true)
        self.panel.autoStateLockImg:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.autoStateLockText:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.autoStateLockText.LabText = l_osMgr.GetOpenSystemTipsInfo(l_osMgr.eSystemId.AutoFightType)
    end
    --范围
    if l_osMgr.IsSystemOpen(l_osMgr.eSystemId.AutoRangeSetting) then
        self.panel.rangeLock:SetActiveEx(false)
        self.panel.rangeHelpBtn:SetActiveEx(true)
        self.panel.rangeHelpBtn.Listener.onDown = function(go, eventData)
            self.panel.rangeTip:SetActiveEx(true)
        end
        self.panel.tipCloseBtn:AddClick(function()
            self.panel.rangeTip:SetActiveEx(false)
        end)
    else
        local l_achievementLevel = l_osMgr.GetSystemAchievementLevel(l_osMgr.eSystemId.AutoRangeSetting)
        self.panel.rangeLock:SetActiveEx(true)
        self.panel.rangeLockImg:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.rangeLockText:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.rangeLockText.LabText = l_osMgr.GetOpenSystemTipsInfo(l_osMgr.eSystemId.AutoRangeSetting)
        self.panel.rangeHelpBtn:SetActiveEx(false)
    end
    --拾取
    if l_osMgr.IsSystemOpen(l_osMgr.eSystemId.AutoPickSetting) then
        self.panel.pickLock:SetActiveEx(false)
        self.panel.pickHelpBtn:SetActiveEx(true)
        self.panel.pickHelpBtn.Listener.onDown = function(go, eventData)
            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("SETTING_AUTO_PICK_TIP"), eventData, Vector2(0.5, 1))
        end
    else
        local l_achievementLevel = l_osMgr.GetSystemAchievementLevel(l_osMgr.eSystemId.AutoPickSetting)
        self.panel.pickLock:SetActiveEx(true)
        self.panel.pickLockImg:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.pickLockText:AddClick(function()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, l_achievementLevel)
        end)
        self.panel.pickLockText.LabText = l_osMgr.GetOpenSystemTipsInfo(l_osMgr.eSystemId.AutoPickSetting)
        self.panel.pickHelpBtn:SetActiveEx(false)
    end

end

function SettingAutoHandler:InitSkillSetting()

    --前往设置
    self.panel.gotoSetBtn:AddClick(function()
        local l_functionId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Skill
        if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(l_functionId))
            return
        end
        local l_skillData =
        {
            openType = DataMgr:GetData("SkillData").OpenType.AutoSetting,
            settingTog = 2
        }
        UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
    end)
    self:FreshSkillSetting()

end

function SettingAutoHandler:FreshSkillSetting()

    --设置技能按钮
    for i = 1, MPlayerInfo.AutoSkillSlots.Length do
        local l_slot = MPlayerInfo.AutoSkillSlots[i - 1]
        if l_slot.id ~= 0 then
            self:SetSkillSlotInfo(i, l_slot.id, l_slot.lv)
        else
            self:SetSkillSlotDefault(i)
        end

    end

end

function SettingAutoHandler:SetSkillSlotDefault(index)

    self.panel.passiveImg[index]:SetActiveEx(false)
    self.panel.normalImg[index]:SetActiveEx(true)
    self.panel.SkillLvBg[index]:SetActiveEx(false)
    self.panel.skillBtn[index]:SetActiveEx(false)
    self.panel.skillName3[index]:SetActiveEx(true)
    self.panel.skillName3Text[index].LabText = Lang("NOT_SET")
    self.panel.skillName5[index]:SetActiveEx(false)

end

function SettingAutoHandler:SetSkillSlotInfo(index, skillId, skillLv)

    if not (index >= 1 and index <= 6) then
        return
    end
    local l_skillRootId = MPlayerInfo:GetRootSkillId(skillId)
    local l_skillInfo = TableUtil.GetSkillTable().GetRowById(l_skillRootId)
    local l_isPassive = l_skillInfo.SkillTypeIcon == 3
    local l_skillName = l_skillInfo.Name
    local l_maxLv = l_skillInfo.EffectIDs.Length
    self.panel.passiveImg[index]:SetActiveEx(l_isPassive)
    self.panel.normalImg[index]:SetActiveEx(not l_isPassive)
    self.panel.skillBtn[index]:SetActiveEx(true)
    self.panel.skillBtn[index]:SetSprite(l_skillInfo.Atlas, l_skillInfo.Icon)
    self.panel.skillBtn[index]:AddClick(function()
        MgrMgr:GetMgr("SkillLearningMgr").ShowSkillTip(l_skillRootId, self.panel.skillBtn[index].gameObject, skillLv)
    end, true)

    self.panel.skillName3[index]:SetActiveEx(#l_skillName / 3 <= 3)
    self.panel.skillName3Text[index].LabText = l_skillName
    self.panel.skillName5[index]:SetActiveEx(#l_skillName / 3 > 3)
    self.panel.skillName5Text[index].LabText = Common.Utils.GetCutOutText(l_skillName, 5)
    self.panel.SkillLvBg[index]:SetActiveEx(true)
    self.panel.skillLvText[index].LabText = StringEx.Format("{0}/{1}", skillLv, l_maxLv)

end


function SettingAutoHandler:Save()
    MgrMgr:GetMgr("FightAutoMgr").SaveAutoBattleInfo()
end


function SettingAutoHandler:InitPickUpSetting()

    self.panel.TogPickup:OnToggleChanged(function(on)
        MPlayerInfo.EnableAutoPickUp = on
    end)
    self.panel.TogPickup.Tog.isOn = MPlayerInfo.EnableAutoPickUp

    self.panel.SliderPickup:OnSliderChange(function(value)
        MPlayerInfo.AutoPickUpPercent = value
        self.panel.LabPickupPercent.LabText = Common.Utils.Lang("AUTO_PICK_UP_PERCENT", tostring(math.floor(value)) .. "%")
    end)
    self.panel.SliderPickup.Slider.minValue = 0
    self.panel.SliderPickup.Slider.maxValue = 100
    self.panel.SliderPickup.Slider.value = MPlayerInfo.AutoPickUpPercent
    self.panel.LabPickupPercent.LabText = Common.Utils.Lang("AUTO_PICK_UP_PERCENT", tostring(math.floor(MPlayerInfo.AutoPickUpPercent)) .. "%")

    self.panel.PickupAdd.Listener.onDown = function()
        self.addPickupSpeed = 1
    end
    self.panel.PickupAdd.Listener.onUp = function()
        self:SetPickUpPercent(MPlayerInfo.AutoPickUpPercent + self.addPickupSpeed)
        self.addPickupSpeed = 0
        self.pressCountDown = 0
    end
    self.panel.PickupSub.Listener.onDown = function()
        self.addPickupSpeed = -1
    end
    self.panel.PickupSub.Listener.onUp = function()
        self:SetPickUpPercent(MPlayerInfo.AutoPickUpPercent + self.addPickupSpeed)
        self.addPickupSpeed = 0
        self.pressCountDown = 0
    end

end


function SettingAutoHandler:SetPickUpPercent(value)

    MPlayerInfo.AutoPickUpPercent = value
    MPlayerInfo.AutoPickUpPercent = math.max(0, math.min(100, MPlayerInfo.AutoPickUpPercent))
    self.panel.SliderPickup.Slider.value = MPlayerInfo.AutoPickUpPercent

end

function SettingAutoHandler:RefreshRangeGray()
    local l_isTogGray = MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.SemiAuto
    for i = 1, #self.panel.Checkmark do
        self.panel.Checkmark[i]:SetGray(l_isTogGray)
    end
    for i = 1, #self.panel.TogText do
        self.panel.TogText[i]:SetGray(l_isTogGray)
    end
    local l_isSliderGray = MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.SemiAuto
            or MPlayerInfo.AutoFightRangeType == MoonClient.EAutoFightRangeType.FullMap
    self.panel.RangeText:SetGray(l_isSliderGray)
    self.panel.RangeNum:SetGray(l_isSliderGray)
    self.panel.RangeHandle:SetGray(l_isSliderGray)
    self.panel.RangeFill:SetGray(l_isSliderGray)
end


--lua custom scripts
--lua custom scripts end
return SettingAutoHandler