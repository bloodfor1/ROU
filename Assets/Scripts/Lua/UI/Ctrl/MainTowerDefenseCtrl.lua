--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainTowerDefensePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MainTowerDefenseCtrl = class("MainTowerDefenseCtrl", super)
--lua class define end

--lua functions
function MainTowerDefenseCtrl:ctor()

    super.ctor(self, CtrlNames.MainTowerDefense, UILayer.Normal, nil, ActiveType.Normal)
    --self.overrideSortLayer = UILayerSort.Normal + 1

end --func end
--next--
function MainTowerDefenseCtrl:Init()

    self.panel = UI.MainTowerDefensePanel.Bind(self)
    super.Init(self)
    self._nextWaveTimeData = nil

    self._TdTreeLifeColorBoundaries = MGlobalConfig:GetSequenceOrVectorInt("TdTreeLifeColorBoundaries")

    self._lastAwardRate = 0
    self.endlessStartFxEffectId=0

    self._hideAnimationTemplates = {}
    self._animationMagic = 0

    self.panel.NextTipsTextAnimation.LabText = Lang("TD_TAP_TO_SKIP")

    local l_textShow = self.panel.NextTips.GradualChange:GetGradualChangeTextShow()
    l_textShow.ShowTextFormat = Lang("TD_NEXT_WAVE_IN_TIME")

    self._mgr = MgrMgr:GetMgr("TowerDefenseMgr")

    self._skillTemplatePool = self:NewTemplatePool(
            {
                TemplateClassName = "MainTowerDefenseSkillTemplate",
                TemplatePrefab = self.panel.MainTowerDefenseSkillPrefab.gameObject,
                TemplateParent = self.panel.QuickCommand.Transform,
            })

    self.panel.BtnExit:AddClick(function()

        if MgrMgr:GetMgr("TowerDefenseMgr").IsCanGetAward() then
            local l_tips = StringEx.Format(Lang("TD_QUIT_POPUP"), tostring(self:_getAwardRate()))

            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_tips, function()
                MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
            end, nil, nil, nil, nil, nil, CommonUI.Dialog.DialogTopic.DUNGEON_QUIT)
        else
            MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
        end
    end)

    self.panel.NextButton:AddClick(function()

        MgrMgr:GetMgr("TowerDefenseMgr").RequestTowerDefenseFastNextWave()

        self.panel.NextTips:SetActiveEx(false)
    end)

    local l_lastPassTime = -1
    self._timer = self:NewUITimer(function()

        self:_showTreeHP()

        local l_currentPassTime = MLuaCommonHelper.Long(MgrMgr:GetMgr("DungeonMgr").GetDungeonsPassTime())

        if l_lastPassTime ~= l_currentPassTime then

            l_lastPassTime = l_currentPassTime

            self.panel.TxtTime.LabText = ExtensionByQX.TimeHelper.SecondConvertTime(l_currentPassTime, "mm:ss")

            if self._nextWaveTimeData then

                local l_passTime = Common.TimeMgr.GetNowTimestamp() - MLuaCommonHelper.Long(self._nextWaveTimeData.now_time_stamp)

                local l_time = self._nextWaveTimeData.next_wave_left_time - l_passTime
                l_time = tonumber(l_time)

                self.panel.TurnTips:SetActiveEx(false)
                self.panel.NextTips:SetActiveEx(true)
                self.panel.NextTips.GradualChange:SetData(l_time)

                self.panel.NextTipsTextAnimation.FxAnim:PlayAll()
                self._nextWaveTimeData = nil


            end
        end

    end, 0.5, -1, true)

end --func end
--next--
function MainTowerDefenseCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self._mgr = nil

    if self._timer then
        self:StopUITimer(self._timer)
        self._timer = nil
    end
    self._skillTemplatePool = nil

end --func end
--next--
function MainTowerDefenseCtrl:OnActive()

    self.panel.TurnTips:SetActiveEx(false)
    self.panel.NextTips:SetActiveEx(false)
    self.panel.TxtTurn:SetActiveEx(false)

    if self._timer then
        self._timer:Start()
    end

    self:_showMainData()
    self:_showWaveBegin()

    self:_showAwardRateNumber()

    self:_showSkill()


end --func end
--next--
function MainTowerDefenseCtrl:OnDeActive()
    if self._timer then
        self:StopUITimer(self._timer)
        self._timer = nil
    end

end --func end
--next--
function MainTowerDefenseCtrl:Update()


end --func end

--next--
function MainTowerDefenseCtrl:BindEvents()
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveTowerDefenseMagicPowerNtfEvent, function()
        self:_showMainData()
    end)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.AnimationTemplateFinishEvent, self._onAnimationFinish)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveTowerDefenseSyncMonsterEvent, function()

    end)
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveTowerDefenseFastNextWaveEvent, function()

    end)
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveTowerDefenseWaveBeginEvent, function()
        self:_showWaveBegin()
    end)
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnEnterSummonCircleEvent, function()
        --self:_showSkill()
    end)
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnLeaveSummonCircleEvent, function()
        --self.panel.QuickCommand:SetActiveEx(false)
    end)
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnCommandSpiritEvent, function()
        --self:_showSkill()
    end)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveTowerDefenseEndlessStartNtfEvent, function()
        self:_showEndlessStart()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function MainTowerDefenseCtrl:_showMainData()

    local data = self._mgr.TowerDefenseMagicPowerData

    if data == nil then
        return
    end

    local l_tableInfo = TableUtil.GetTdTable().GetRowByID(MPlayerDungeonsInfo.DungeonID, true)
    if l_tableInfo == nil then
        return
    end

    if data.reason == self._mgr.EMagicChangeType.Drop then
        self:_showGetMagicAnimation(data.monster_pos, data.increase)
    elseif data.reason == self._mgr.EMagicChangeType.Skip then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("TowerDefense_MagicChangeOnSkipText"), data.increase))
    end

    local l_maxSummonCount = 0
    if l_tableInfo ~= nil then
        for i = 1, l_tableInfo.SummonCircleInfo.Length do
            l_maxSummonCount = l_maxSummonCount + l_tableInfo.SummonCircleInfo[i - 1][2]
        end
    end

    local l_currentSummonCount = self._mgr.GetSpiritSummonCount()

    self.panel.TxtNumber.LabText = tostring(l_currentSummonCount) .. "/" .. tostring(l_maxSummonCount)

    self.panel.TxtMana.LabText = tostring(self:_getShowMagic(data.magic_value))

    --self:_showSkill()
end

function MainTowerDefenseCtrl:_getShowMagic(currentMagic)
    return currentMagic - self._animationMagic
end

function MainTowerDefenseCtrl:_showWaveBegin()
    local l_data = self._mgr.CurrentWaveData

    if l_data == nil then
        return
    end

    if l_data.start_or_end then
        if l_data.can_fast_next_wave then
            if l_data.next_wave_left_time > 0 then
                self._nextWaveTimeData = l_data
            end
        else
            local l_wave = l_data.current_wave
            if l_wave == 0 then
                return
            end

            self.panel.TurnTips:SetActiveEx(true)
            self.panel.NextTips:SetActiveEx(false)
            --self.panel.TxtTurn:SetActiveEx(true)
            local l_maxWaveCount = self._mgr.GetMaxWaveCount()
            if l_maxWaveCount == l_wave then
                self.panel.TurnTipsText.LabText = StringEx.Format(Lang("TD_LAST_WAVE"))
            else
                self.panel.TurnTipsText.LabText = StringEx.Format(Lang("TD_WAVE"), l_wave)
            end

            local l_waveColorText = l_wave
            if l_wave > l_maxWaveCount then
                l_waveColorText = GetColorText(l_wave, RoColorTag.Yellow)
            end

            self.panel.TxtWaveCount.LabText = StringEx.Format(Lang("TD_WAVE_TEXT"), l_waveColorText .. "/" .. tostring(l_maxWaveCount))
            self.panel.TxtWaveCount:SetActiveEx(true)
        end
    end

    self:_showAwardRateNumber()

end

function MainTowerDefenseCtrl:_showSkill()

    self.panel.QuickCommand:SetActiveEx(true)
    local l_TableInfos = self._mgr.GetSkillTableInfoWithType(self._mgr.ESkillType.DungeonSkill)
    self._skillTemplatePool:ShowTemplates({
        Datas = l_TableInfos,
    })
end

function MainTowerDefenseCtrl:_showAwardRateNumber()

    local l_currentAwardRate = self:_getAwardRate()

    if l_currentAwardRate > self._lastAwardRate then
        self.panel.ShowAwardRateNumber.FxAnim:PlayAll()
    end

    self._lastAwardRate = l_currentAwardRate

    self.panel.ShowAwardRateNumber.LabText = tostring(l_currentAwardRate) .. "%"

end

function MainTowerDefenseCtrl:_getAwardRate()
    local l_data = self._mgr.CurrentWaveData
    if l_data == nil then
        return 0
    end

    local l_tableInfo = TableUtil.GetTdTable().GetRowByID(MPlayerDungeonsInfo.DungeonID, true)
    if l_tableInfo == nil then
        return 0
    end

    local l_finishWaveCount = self._mgr.GetNormalModeFinishWaveCount()

    if l_finishWaveCount == 0 then
        return 0
    end

    local l_waveData = self._mgr.GetWaveTableDataWithIndex(l_finishWaveCount)
    if l_waveData == nil then
        logError("没有在表里取到相应波数的奖励百分比，打完的波数：" .. tostring(l_finishWaveCount))
        return
    end

    return l_waveData.ItemDropPercentage

end

function MainTowerDefenseCtrl:_showTreeHP()
    local l_currentHP, l_maxHP = MgrMgr:GetMgr("TowerDefenseMgr").GetTreeRootHP()

    if l_maxHP <= 0 then
        return
    end

    self.panel.TxtHp.LabText = tostring(l_currentHP) .. "/" .. tostring(l_maxHP)

    local l_rate = l_currentHP / l_maxHP

    self.panel.SliderHp.Slider.value = l_rate

    l_rate = l_rate * 100

    if l_rate > self._TdTreeLifeColorBoundaries[0] then
        --绿
        self.panel.SliderHpImage.Img.color = Color.New(119 / 255.0, 236 / 255.0, 52 / 255.0, 176 / 255.0)
    elseif l_rate < self._TdTreeLifeColorBoundaries[1] then
        --红
        self.panel.SliderHpImage.Img.color = Color.New(236 / 255.0, 94 / 255.0, 52 / 255.0, 176 / 255.0)
    else
        --黄
        self.panel.SliderHpImage.Img.color = Color.New(236 / 255.0, 231 / 255.0, 52 / 255.0, 176 / 255.0)
    end
end

function MainTowerDefenseCtrl:_showGetMagicAnimation(originWorldPosition, manaCount)

    self._animationMagic = self._animationMagic + manaCount

    local l_targetPosition = CoordinateHelper.WorldPositionToLocalPosition(MScene.GameCamera.UCam, MUIManager.UICamera, originWorldPosition, self.panel.FromPosition.Transform)

    local l_currentTableInfo=self:_getMagicDropTable(manaCount)
    local l_count=math.random(l_currentTableInfo.ManaDropAmount[0],l_currentTableInfo.ManaDropAmount[1])

    if l_count>0 then
        local perManaCount=manaCount/l_count
        for i = 1, l_count do
            self:_showOneGetMagicAnimation(l_targetPosition.x, l_targetPosition.y, perManaCount)
        end
    end
end

local GetMagicAnimationPositionRandom=50

function MainTowerDefenseCtrl:_showOneGetMagicAnimation(positionX,positionY, manaCount)

    GetMagicAnimationPositionRandom=MgrMgr:GetMgr("TowerDefenseMgr").manaRandom

    positionX=math.random(positionX-GetMagicAnimationPositionRandom,positionX+GetMagicAnimationPositionRandom)
    positionY=math.random(positionY-GetMagicAnimationPositionRandom,positionY+GetMagicAnimationPositionRandom)

    local l_animationTemplate

    local l_hideTemplateCount = #self._hideAnimationTemplates
    if l_hideTemplateCount > 0 then
        l_animationTemplate = self._hideAnimationTemplates[l_hideTemplateCount]
        table.remove(self._hideAnimationTemplates, l_hideTemplateCount)
    else
        l_animationTemplate = self:NewTemplate("TowerDefenseAnimationTemplate", {
            TemplateParent = self.panel.AnimationParent.transform,
            TemplatePrefab = self.panel.TowerDefenseGetMagicAnimation.gameObject,
        })
    end

    local l_data={}
    l_data.PositionX=positionX
    l_data.PositionY=positionY
    l_data.MagicCount=manaCount

    l_animationTemplate:SetData(l_data)


end

function MainTowerDefenseCtrl:_getMagicDropTable(manaCount)
    local l_table = TableUtil.GetTdManaDropAmountTable().GetTable()
    local l_currentTableInfo
    for i = 1, #l_table do
        if manaCount >= l_table[i].MinMana then
            l_currentTableInfo=l_table[i]
        else
            break
        end
    end
    if l_currentTableInfo == nil then
        logError("没找到魔力掉落表数据")
        l_currentTableInfo=l_table[1]
    end
    return l_currentTableInfo
end

function MainTowerDefenseCtrl:_onAnimationFinish(template, manaCount)
    template:SetGameObjectActive(false)

    table.insert(self._hideAnimationTemplates, template)

    self._animationMagic = self._animationMagic - manaCount
end

function MainTowerDefenseCtrl:_showEndlessStart()
    self.panel.EndlessStartPanel:SetActiveEx(true)
    self:_createEndlessStartFx()
    local l_endlessStartTimer
    l_endlessStartTimer = self:NewUITimer(function()
        self.panel.EndlessStartPanel:SetActiveEx(false)
        self:_destroyEndlessStartFx()
        self:StopUITimer(l_endlessStartTimer)
    end, 3)
    l_endlessStartTimer:Start()
end

function MainTowerDefenseCtrl:_createEndlessStartFx()
    self:_destroyEndlessStartFx()
    if self.endlessStartFxEffectId == 0 then
        local l_fxData = {}
        l_fxData.scale = Vector3.New(3, 3, 1)
        l_fxData.rawImage = self.panel.EndlessStartEffectImage.RawImg
        l_fxData.destroyHandler = function ()
            self.endlessStartFxEffectId = 0
        end
        self.endlessStartFxEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_ui_warning",l_fxData)

    end
end

function MainTowerDefenseCtrl:_destroyEndlessStartFx()
    if self.endlessStartFxEffectId ~= 0 then
        self:DestroyUIEffect(self.endlessStartFxEffectId)
        self.endlessStartFxEffectId = 0
    end
end
--lua custom scripts end
return MainTowerDefenseCtrl