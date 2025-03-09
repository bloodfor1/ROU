--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SettingSystemPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
SettingSystemHandler = class("SettingSystemHandler", super)
--lua class define end

--lua functions
function SettingSystemHandler:ctor()

    super.ctor(self, HandlerNames.SettingSystem, 0)
    self._hardwareQualityLevel = MQualityGradeSetting.GetHardwareLevel()
    self._hardwareModelGrade = MQualityGradeSetting.GetHardwareGradeModelGrade()
    -- 是否是刷新触发的画面质量变化
    self._isQualityClicked = false
end --func end
--next--
function SettingSystemHandler:Init()

    self.panel = UI.SettingSystemPanel.Bind(self)
    super.Init(self)
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")

    -- 画面显示设置
    self.panel.TogQualityVeryLow:OnToggleChanged(function(value) --流畅
        if value then
                self.lastQualityLevel = self.qualityLevel
                if self._isQualityClicked and (self.qualityLevel ~= 0) then
                    self:OnClickSetQualityLevel(0)
                    --影响同屏人数
                    self.panel.TogRole1.Tog.isOn = true
                else
                    self.qualityLevel = 0
                end
            end
    end)
    self.panel.TogQualityLow:OnToggleChanged(function(value) --普通
        if value then
                self.lastQualityLevel = self.qualityLevel
                if self._isQualityClicked and (self.qualityLevel ~= 1) then
                    self:OnClickSetQualityLevel(1)
                else
                    self.qualityLevel = 1
                end
        end
    end)
    self.panel.TogQualityMiddle:OnToggleChanged(function(value) --精细
        if value then
                self.lastQualityLevel = self.qualityLevel
                if self._isQualityClicked and (self.qualityLevel ~= 2) then
                    self:OnClickSetQualityLevel(2)
                else
                    self.qualityLevel = 2
                end
        end
    end)
    self.panel.TogQualityHigh:OnToggleChanged(function(value) --极致
        if value then
                self.lastQualityLevel = self.qualityLevel
                if self._isQualityClicked and (self.qualityLevel ~= 3) then
                    self:OnClickSetQualityLevel(3)
                else
                    self.qualityLevel = 3
                end
        end
    end)
    -- 同屏人数
    self.panel.TogRole1:OnToggleChanged(function(value) --10人
            if value then
                if self._isQualityClicked and (self.curModelNum ~= 0) then
                    self:OnClickModelDisplayCompeleteNum(0)
                else
                    self.curModelNum = 0
                end
            end
    end)
    self.panel.TogRole2:OnToggleChanged(function(value) --20人
            if value then
                if self._isQualityClicked and (self.curModelNum ~= 1) then
                    self:OnClickModelDisplayCompeleteNum(1)
                else
                    self.curModelNum = 1
                end
            end
    end)
    self.panel.TogRole3:OnToggleChanged(function(value) --30人
            if value then
                if self._isQualityClicked and (self.curModelNum ~= 2) then
                    self:OnClickModelDisplayCompeleteNum(2)
                else
                    self.curModelNum = 2
                end
            end
    end)
    self.panel.TogRole4:OnToggleChanged(function(value) --40人
            if value then
                if self._isQualityClicked and (self.curModelNum ~= 3) then
                    self:OnClickModelDisplayCompeleteNum(3)
                else
                    self.curModelNum = 3
                end
            end
    end)

    --游戏帧数
    --30帧
    self.panel.Frame30Tog:OnToggleChanged(function(value)
        if value and self._isQualityClicked then
            MPlayerSetting.TargetFrameRate = 30

            self:RefreshPowerSavingTog()
        end
    end)

    --60帧
    self.panel.Frame60Tog:OnToggleChanged(function(value)
        if value and self._isQualityClicked then
            if not self._isFrameTogDialogHide then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("HIGH_FRAME_RATE_SET"), function()
                    MPlayerSetting.TargetFrameRate = 60
                end, function()
                    self.panel.Frame30Tog.Tog.isOn = true
                end)
            else
                self.panel.Frame30Tog.Tog.isOn = true
            end

            self:RefreshPowerSavingTog()
        end
    end)

    -- 伤害数字显示
    self.panel.TogHitNum1:OnToggleChanged(function(value) --自己
        if value and self._isQualityClicked then
            MgrMgr:GetMgr("SettingMgr").RequestHitNumType(EHitNumType.Mine)
        end
    end)
    self.panel.TogHitNum2:OnToggleChanged(function(value) --自己和队友
        if value and self._isQualityClicked then
            MgrMgr:GetMgr("SettingMgr").RequestHitNumType(EHitNumType.Team)
        end
    end)
    self.panel.TogHitNum3:OnToggleChanged(function(value) --全部
        if value and self._isQualityClicked then
            MgrMgr:GetMgr("SettingMgr").RequestHitNumType(EHitNumType.All)
        end
    end)

    -- 佣兵显示
    self.mercenaryShowTogComs = {
        [EMercenaryShowType.Mine] = self.panel.MercenaryMine,
        [EMercenaryShowType.Team] = self.panel.MercenaryTeam,
        [EMercenaryShowType.All] = self.panel.MercenaryAll
    }
    self.mercenaryShowTogComs[MPlayerSetting.MercenaryShowType].Tog.isOn = true
    for type, togCom in pairs(self.mercenaryShowTogComs) do
        togCom:OnToggleChanged(function(value)
            if value then
                MPlayerSetting.MercenaryShowType = type
            end
        end)
    end

    -- 描边显示
    self.panel.TogOutlineHide:OnToggleChanged(function(value) --不显示
        if value and self._isQualityClicked then
            MPlayerSetting.IsShowOutline = false
        end
    end)
    self.panel.TogOutlineShow:OnToggleChanged(function(value) --显示
        if value and self._isQualityClicked then
            MPlayerSetting.IsShowOutline = true
        end
    end)

    -- 总音量
    self.panel.TogVolumeMain:OnToggleChanged(function(value)
        MPlayerSetting.soundVolumeData.SoundMainVolumeState = value
        self:SetVoiceState(1, value, true)
    end)
    -- 语音
    self.panel.TogVolumeChat:OnToggleChanged(function(value)
        if MPlayerSetting.soundVolumeData.SoundMainVolumeState then
            MPlayerSetting.soundVolumeData.SoundChatVolumeState = value
            self:SetVoiceState(2, value, true)
        end
    end)
    -- 音乐
    self.panel.TogVolumeBGM:OnToggleChanged(function(value)
        if MPlayerSetting.soundVolumeData.SoundMainVolumeState then
            MPlayerSetting.soundVolumeData.SoundBgmVolumeState = value
            self:SetVoiceState(3, value, true)
        end
    end)
    -- 音效
    self.panel.TogVolumeSE:OnToggleChanged(function(value)
        if MPlayerSetting.soundVolumeData.SoundMainVolumeState then
            MPlayerSetting.soundVolumeData.SoundSeVolumeState = value
            self:SetVoiceState(4, value, true)
        end
    end)
    -- 总音量滑动条
    self.panel.SliderVolumeMain:OnSliderChange(function(v)
        if MPlayerSetting.soundVolumeData.SoundMainVolumeState then
            MPlayerSetting.soundVolumeData.SoundMainVolume = v
            VideoPlayerMgr:SetVolume(v)
        end
    end)
    -- 语音滑动条
    self.panel.SliderVolumeChat:OnSliderChange(function(v)
        if MPlayerSetting.soundVolumeData.SoundChatVolumeState then
            MPlayerSetting.soundVolumeData.SoundChatVolume = v
            GlobalEventBus:Dispatch(EventConst.Names.ChatAudioChanged)
        end
    end)
    -- 音乐滑动条
    self.panel.SliderVolumeBGM:OnSliderChange(function(v)
        if MPlayerSetting.soundVolumeData.SoundBgmVolumeState then
            MPlayerSetting.soundVolumeData.SoundBgmVolume = v
        end
    end)
    -- 音效滑动条
    self.panel.SliderVolumeSE:OnSliderChange(function(v)
        if MPlayerSetting.soundVolumeData.SoundSeVolumeState then
            MPlayerSetting.soundVolumeData.SoundSeVolume = v
        end
    end)
    -- 伤害数字显示文字
    self.panel.TittleHitNum.LabText = Common.Utils.Lang("SETTING_HIT_NUM_TITLE")
    self.panel.LabelHitNum1.LabText = Common.Utils.Lang("SETTING_HIT_NUM_MINE")
    self.panel.LabelHitNum2.LabText = Common.Utils.Lang("SETTING_HIT_NUM_MINE_TEAM")
    self.panel.LabelHitNum3.LabText = Common.Utils.Lang("SETTING_HIT_NUM_ALL")

    local l_chatVoiceOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ChatVoice)
    self.panel.ChatVolume.gameObject:SetActiveEx(l_chatVoiceOpen)
end --func end

--刷新省电模式按钮状态
function SettingSystemHandler:RefreshPowerSavingTog()
    self.panel.Txt_Powersaving.Tog.onValueChanged:RemoveAllListeners()
    self.panel.Txt_Powersaving.Tog.isOn = self.panel.TogQualityVeryLow.Tog.isOn and self.panel.TogRole1.Tog.isOn and self.panel.Frame30Tog.Tog.isOn
    self.panel.Txt_Powersaving:OnToggleChanged(function(value)
        self:OnPowerSavingTogValueChanged(value)
    end)
end

function SettingSystemHandler:OnPowerSavingTogValueChanged(value)
    if value then
        self.panel.TogQualityVeryLow.Tog.isOn = true
        self.panel.TogRole1.Tog.isOn = true
        self.panel.Frame30Tog.Tog.isOn = true
    else
        self._recommendQualityTog.Tog.isOn = true
        self._recommendRoleTog.Tog.isOn = true
        self._isFrameTogDialogHide = true
        self._recommendFrameRateTog.Tog.isOn = true
        self._isFrameTogDialogHide = false

        if self.panel.TogQualityVeryLow.Tog.isOn and self.panel.TogRole1.Tog.isOn and self.panel.Frame30Tog.Tog.isOn then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_POWER_SAVING_MODE"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXIST_POWER_SAVING_MODE"))
        end
    end
end

function SettingSystemHandler:OnClickSetQualityLevel(level)
    if (level >= (self._hardwareQualityLevel + 1)) then
        -- 高一级的提示
            local l_strContext = Common.Utils.Lang("SETTINGS_QUALITY_WARNING")
        function OnConfirmCallBack()
            self:SetQualityLevel(level)
        end
        function OnCancelCallBack()
            self:SettingSystemRefresh()
        end
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_strContext, OnConfirmCallBack, OnCancelCallBack, 10)
    else
        self:SetQualityLevel(level)
    end
end

function SettingSystemHandler:SetQualityLevel(level)
    MQualityGradeSetting.SetCustomLevel(level)
    self.qualityLevel = level
    self:SettingSystemRefresh()
end

function SettingSystemHandler:OnClickModelDisplayCompeleteNum(displayLevel)
    if (displayLevel > (self._hardwareQualityLevel)) then
        -- 高两级的提示
        local l_strContext = Common.Utils.Lang("SETTING_MODEL_NUM_WARNING")
        function OnConfirmCallBack()
            self:SetModelDisplayCompeleteNum(displayLevel)
        end
        function OnCancelCallBack()
            self:SettingSystemRefresh()
        end
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_strContext, OnConfirmCallBack, OnCancelCallBack, 10)
    else
        self:SetModelDisplayCompeleteNum(displayLevel)
    end
end

function SettingSystemHandler:SetModelDisplayCompeleteNum(displayLevel)
    MQualityGradeSetting.SetCustomDisplayLevel(displayLevel)
    self.curModelNum = displayLevel
    self:SettingSystemRefresh()
end

function SettingSystemHandler:SetVoiceState(type, isOn, enabled)
    -- type 声音种类 1总音量 2语音 3音乐 4音效
    if type == 1 then
        self:SetSliderState(self.panel.SliderVolumeMain, isOn)
        self.panel.TogVolumeMain.Tog.isOn = isOn
        self.panel.SliderVolumeMain.Slider.enabled = isOn
        GlobalEventBus:Dispatch(EventConst.Names.ChatAudioChanged)
        if isOn then
            self:SetVoiceState(2, MPlayerSetting.soundVolumeData.SoundChatVolumeState, true)
            self:SetVoiceState(3, MPlayerSetting.soundVolumeData.SoundBgmVolumeState, true)
            self:SetVoiceState(4, MPlayerSetting.soundVolumeData.SoundSeVolumeState, true)
        else
            self:SetVoiceState(2, false, false)
            self:SetVoiceState(3, false, false)
            self:SetVoiceState(4, false, false)
        end
        MgrMgr:GetMgr("SettingMgr").SyncVideoVolume()
    elseif type == 2 then
        self:SetSliderState(self.panel.SliderVolumeChat, isOn)
        self.panel.TogVolumeChat.Tog.enabled = enabled
        self.panel.TogVolumeChat.Tog.isOn = isOn
        self.panel.SliderVolumeChat.Slider.enabled = isOn
        GlobalEventBus:Dispatch(EventConst.Names.ChatAudioChanged)
    elseif type == 3 then
        self:SetSliderState(self.panel.SliderVolumeBGM, isOn)
        self.panel.TogVolumeBGM.Tog.enabled = enabled
        self.panel.TogVolumeBGM.Tog.isOn = isOn
        self.panel.SliderVolumeBGM.Slider.enabled = isOn
    elseif type == 4 then
        self:SetSliderState(self.panel.SliderVolumeSE, isOn)
        self.panel.TogVolumeSE.Tog.enabled = enabled
        self.panel.TogVolumeSE.Tog.isOn = isOn
        self.panel.SliderVolumeSE.Slider.enabled = isOn
    end
end

function SettingSystemHandler:SetSliderState(Slider, isOn)
    -- 进度条常态和灰态 state 是否开启
    local l_sliderProgress = Slider.transform:Find("Fill Area/Fill"):GetComponent("Image")
    local l_sliderBar = Slider.transform:Find("Handle Slide Area/Handle"):GetComponent("Image")
    if isOn then
        local l_color = Color.New(1, 1, 1, 1) -- 正常
        l_sliderProgress.color = l_color
        l_sliderBar.color = l_color
    else
        local l_color = Color.New(0, 0, 0, 1) -- 灰态
        l_sliderProgress.color = l_color
        l_sliderBar.color = l_color
    end

end --func end
--next--
function SettingSystemHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SettingSystemHandler:OnActive()

    self._hardwareQualityLevel = MQualityGradeSetting.GetHardwareLevel()
    self._hardwareModelGrade = MQualityGradeSetting.GetHardwareGradeModelGrade()
    --设置推荐选项
    self._recommendQualityTog = self.panel.TogQualityVeryLow
    if self._hardwareQualityLevel == 0 then
        self._recommendQualityTog = self.panel.TogQualityVeryLow
    elseif self._hardwareQualityLevel == 1 then
        self._recommendQualityTog = self.panel.TogQualityLow
    elseif self._hardwareQualityLevel == 2 then
        self._recommendQualityTog = self.panel.TogQualityMiddle
    elseif self._hardwareQualityLevel >= 3 then
        self._recommendQualityTog = self.panel.TogQualityHigh
    end
    self._recommendRoleTog = self.panel.TogRole1
    if self._hardwareModelGrade <= 0 then
        self._recommendRoleTog = self.panel.TogRole1
    elseif self._hardwareModelGrade == 1 then
        self._recommendRoleTog = self.panel.TogRole2
    elseif self._hardwareModelGrade == 2 then
        self._recommendRoleTog = self.panel.TogRole3
    elseif self._hardwareModelGrade >= 3 then
        self._recommendRoleTog = self.panel.TogRole4
    end
    self._recommendFrameRateTog = self.panel.Frame30Tog
    if MGlobalConfig:GetInt("DefaultDisplayFramerate") == 2 then
        self._recommendFrameRateTog = self.panel.Frame60Tog
    else
        self._recommendFrameRateTog = self.panel.Frame30Tog
    end
    --推荐显示画质
    local fitQualityText = CommonUI.Quality.GetName(self._hardwareQualityLevel)
    self.panel.TextQualityState.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_FIT_QUALITY"), fitQualityText)
    --推荐显示人数
    if self._hardwareModelGrade > 3 then
        self._hardwareModelGrade = 3
    end
    self.panel.TextRoleState.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_FIT_MODEL_NUM"), MQualityGradeSetting.GetModelDisplayNum(self._hardwareModelGrade))
    --同屏人数
    self.panel.TogRoleText1.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_MODEL_NUM_POWER_SAVING"), MQualityGradeSetting.GetModelDisplayNum(0))
    self.panel.TogRoleText2.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_MODEL_NUM"), MQualityGradeSetting.GetModelDisplayNum(1))
    self.panel.TogRoleText3.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_MODEL_NUM"), MQualityGradeSetting.GetModelDisplayNum(2))
    self.panel.TogRoleText4.LabText = StringEx.Format(Common.Utils.Lang("SETTING_SYSTEM_MODEL_NUM"), MQualityGradeSetting.GetModelDisplayNum(3))
    -- 音量部分
    self:SetVoiceState(1, MPlayerSetting.soundVolumeData.SoundMainVolumeState, true)
    self.panel.SliderVolumeMain.Slider.value = MPlayerSetting.soundVolumeData.SoundMainVolume
    self.panel.SliderVolumeChat.Slider.value = MPlayerSetting.soundVolumeData.SoundChatVolume
    self.panel.SliderVolumeBGM.Slider.value = MPlayerSetting.soundVolumeData.SoundBgmVolume
    self.panel.SliderVolumeSE.Slider.value = MPlayerSetting.soundVolumeData.SoundSeVolume
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.SystemContent.RectTransform)
    self:SettingSystemRefresh()
end --func end
--next--
function SettingSystemHandler:OnDeActive()


end --func end
--next--
function SettingSystemHandler:Update()


end --func end

--next--
function SettingSystemHandler:BindEvents()

    --dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts
function SettingSystemHandler:SettingSystemRefresh()

    self._isQualityClicked = false
    if self.panel == nil then
        self._isQualityClicked = true
        return
    end
    -- 画面显示设置
    local l_curQualityLevel = MQualityGradeSetting.GetCurLevel()
    self.panel.TogQualityVeryLow.Tog.isOn = (0 == l_curQualityLevel)
    self.panel.TogQualityLow.Tog.isOn = (1 == l_curQualityLevel)
    self.panel.TogQualityMiddle.Tog.isOn = (2 == l_curQualityLevel)
    self.panel.TogQualityHigh.Tog.isOn = (3 <= l_curQualityLevel)

    -- 同屏人数
    local l_curModelNum = MQualityGradeSetting.GetModelDisplayCompeleteNum()
    self.panel.TogRole1.Tog.isOn = (10 == l_curModelNum)
    self.panel.TogRole2.Tog.isOn = (20 == l_curModelNum)
    self.panel.TogRole3.Tog.isOn = (30 == l_curModelNum)
    self.panel.TogRole4.Tog.isOn = (40 <= l_curModelNum)

    --帧率
    if MPlayerSetting.TargetFrameRate == 60 then
        self.panel.Frame60Tog.Tog.isOn = true
    else
        self.panel.Frame30Tog.Tog.isOn = true
    end

    -- 伤害数字显示
    local l_hitNumType = MPlayerSetting.HitNumType
    self.panel.TogHitNum1.Tog.isOn = (EHitNumType.Mine == l_hitNumType)
    self.panel.TogHitNum2.Tog.isOn = (EHitNumType.Team == l_hitNumType)
    self.panel.TogHitNum3.Tog.isOn = (EHitNumType.All == l_hitNumType)

    -- 描边显示
    local  l_isShowOutline = MPlayerSetting.IsShowOutline
    self.panel.TogOutlineHide.Tog.isOn = (false == l_isShowOutline)
    self.panel.TogOutlineShow.Tog.isOn = (true == l_isShowOutline)

    self._isQualityClicked = true

    self:RefreshPowerSavingTog()

end
--lua custom scripts end
