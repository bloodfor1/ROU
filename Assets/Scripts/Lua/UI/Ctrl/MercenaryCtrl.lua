--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenaryPanel"
require "UI/Template/MercenaryAttrCellTemplate"
require "UI/Template/MercenarySkillCellTemplate"
require "UI/Template/MercenaryIntroductionCellTemplate"
require "UI/Template/MercenaryTalentInfoTemplate"
require "UI/Template/MercenaryCellTemplate"
require "UI/Template/MercenaryEquipAttrTemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/MercenaryRecruitConditionTemplate"
require "UI/Template/MercenaryUpgradeItemTemplate"
require "mercenary_function"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MercenaryCtrl = class("MercenaryCtrl", super)
--lua class define end

--lua functions
function MercenaryCtrl:ctor()
    super.ctor(self, CtrlNames.Mercenary, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function MercenaryCtrl:Init()
    self.panel = UI.MercenaryPanel.Bind(self)
    super.Init(self)
    self.mercenaryMgr = MgrMgr:GetMgr("MercenaryMgr")
    --当前选中的佣兵
    self.selectedMercenaryCellTemplate = nil
    --佣兵信息
    self.informationCellTemplates = nil
    --当前已选中天赋信息
    self.selectedTalentInfo = nil
    self.selectedTalentInfoTemplate = nil
    self.selectedTalentCellTemplate = nil
    --当前装备选中位置
    self.curSelectedEquipPosition = 1
    self.attrTemplatePool = nil
    self.fixSkillTemplatePool = nil
    self.optionSkillTemplatePool = nil
    self.attrTemplatePool = nil
    self.talentInfoTemplatePool = nil
    self.informationCellTemplatePool = nil
    self.inFightTemplates = nil
    self.outFightTemplatePool = nil
    self.levelUpItemTemplatePool = nil
    self.recruitConditionTemplatePool = nil
    self.beforeEquipAttrTemplates = nil
    self.afterEquipAttrTemplates = nil
    --之前模型展示id
    self.lastModelMercenaryId = nil

    self.talentLvComs = nil

    self:InitPanel()
end --func end
--next--
function MercenaryCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function MercenaryCtrl:OnActive()
    --新手指引相关
    local l_beginnerGuideChecks = {}
    local l_num = self.mercenaryMgr.GetCurRecruitedNumber()
    local l_canTakeNum = self.mercenaryMgr.CanTakeMercenaryNumber()
    local l_fightNum = self.mercenaryMgr.FindFightMercenaryCount()
    if l_num == 1 then
        table.insert(l_beginnerGuideChecks, "MercenaryGuideFirst")
    elseif l_num > 1 and l_canTakeNum > 1 and l_fightNum < 2 then
        table.insert(l_beginnerGuideChecks, "MercenaryGuideSecond")
    end

    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    self.mercenaryMgr.CheckMercenaryTask()
end --func end
--next--
function MercenaryCtrl:OnDeActive()

    self.panel.MercenaryImg:ResetRawTex()
    if self.mercenaryModel then
        self:DestroyUIModel(self.mercenaryModel)
        self.mercenaryModel = nil
    end

    if self.redSignTimer then
        self:StopUITimer(self.redSignTimer)
        self.redSignTimer = nil
    end

    self:DestroyEffect()

end --func end
--next--
function MercenaryCtrl:Update()
    --刷新强化时间
    if self.selectedMercenaryCellTemplate and self.selectedTalentInfo then
        local l_talentGroupInfo = self.selectedMercenaryCellTemplate.mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel]
        if l_talentGroupInfo.strengthenTimeCountDown >= 0 then
            self.panel.TalentTimeText.LabText = Common.Functions.SecondsToTimeStr(l_talentGroupInfo.strengthenTimeCountDown)
        end
    end
end --func end

--next--
function MercenaryCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.RefreshLevelUpItems)
    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, self.RefreshCurrency)
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_EQUIP_UPGRADE, function()
        self:PlayEquipUpgradeEffect()
    end)
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_TALENT_UPGRADE, function()
        self:PlayTalentUpgradeEffect()
    end)
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_TALENT_STRENGTHEN, function()

    end)
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_EQUIP_ADVANCE, function()
        self:PlayEquipAdvanceEffect()
    end)
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_LEVEL_UP, function()
        --self:PlayLevelUpEffect()
    end)
    -- 解锁新技能
    self:BindEvent(self.mercenaryMgr.EventDispatcher, self.mercenaryMgr.ON_MERCENARY_NEW_SKILL, function(self, mercenaryId, skillId)
        local l_skillOpenCtrl = UIMgr:GetUI(UI.CtrlNames.SkillOpen)
        if l_skillOpenCtrl then
            l_skillOpenCtrl:ShowAnimation(skillId)
        else
            UIMgr:ActiveUI(UI.CtrlNames.SkillOpen, { skillId = skillId })
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--界面初始化
function MercenaryCtrl:InitPanel()
    -- GM指令
    if MGameContext.IsOpenGM then
        self.panel.GMAllEquipUpgradeBtn:SetActiveEx(true)
        self.panel.GMAllEquipUpgradeBtn:AddClick(function()
            --if not self.selectedMercenaryCellTemplate then
            --    return
            --end
            --local l_mercenaryId = self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("upgrademercenaryallequip"))
        end)
    else
        self.panel.GMAllEquipUpgradeBtn:SetActiveEx(false)
    end


    --红点注册
    self:NewRedSign({
        Key = eRedSignKey.MercenaryLevelUp,
        ClickButton = self.panel.UpgradeBtn,
    })
    self:NewRedSign({
        Key = eRedSignKey.MercenaryInformation,
        ClickTogEx = self.panel.InformationTog,
    })
    self:NewRedSign({
        Key = eRedSignKey.MercenaryEquipLevelUp,
        ClickTogEx = self.panel.EquipmentTog,
    })
    self:NewRedSign({
        Key = eRedSignKey.MercenaryTalent,
        ClickTogEx = self.panel.TalentTog,
    })


    --红点刷新
    self.mercenaryMgr.RefreshRedSign()
    self.redSignTimer = self:NewUITimer(function()
        self.mercenaryMgr.RefreshRedSign()
    end, 1, -1)
    self.redSignTimer:Start()

    self.panel.BtnBack:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Mercenary)
    end)

    -- 装备
    self.panel.EquipmentTog.TogEx:SetCheckMethodOnBtnOff(function()
        if self.selectedMercenaryCellTemplate and not self.selectedMercenaryCellTemplate.mercenaryInfo.isRecruited then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_NOT_RECRUIT"))
            return false
        end
        return true
    end)
    self.panel.EquipmentTog.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            self:RefreshPanelVisible()

            self:RefreshEquipment()
            self:RefreshCurrency()

            --红点处理
            if MgrMgr:GetMgr("RedSignMgr").IsRedSignShow(eRedSignKey.MercenaryEquipLevelUp) then
                self.mercenaryMgr.SetEquipRedSignClicked(self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id, true)
            end
        end
    end)
    -- 天赋
    self.panel.TalentTog.TogEx:SetCheckMethodOnBtnOff(function()
        if self.selectedMercenaryCellTemplate and not self.selectedMercenaryCellTemplate.mercenaryInfo.isRecruited then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_NOT_RECRUIT"))
            return false
        end
        return true
    end)
    self.panel.TalentTog.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            if self.selectedMercenaryCellTemplate and not self.selectedMercenaryCellTemplate.mercenaryInfo.isRecruited then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_NOT_RECRUIT"))
                self.panel.AttributeTog.TogEx.isOn = true
                return
            end

            self:RefreshPanelVisible()

            self:RefreshTalent()
            self:RefreshCurrency()
        end
    end)

    -- 属性
    self.panel.AttributeTog.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            self:RefreshPanelVisible()

            self:RefreshAttribute()
            self:RefreshCurrency()
        end
    end)
    -- 技能
    self.panel.SkillTog.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            self:RefreshPanelVisible()

            self:RefreshSkill()
            self:RefreshCurrency()
        end
    end)
    -- 介绍
    self.panel.IntroductionTog.TogEx.onValueChanged:AddListener(function(isOn)
        if isOn then
            self:RefreshPanelVisible()

            self:RefreshIntroduction()
            self:RefreshCurrency()
        end
    end)
    -- --初始化属性面板
    self.panel.UpgradeItemsBackBtn:AddClick(function()
        self.panel.UpgradeItems:SetActiveEx(false)
    end)
    self.panel.UpgradeBtn:AddClick(function()
        self:RefreshLevelUpItems()
        self.panel.UpgradeItems:SetActiveEx(true)

        --红点处理
        if MgrMgr:GetMgr("RedSignMgr").IsRedSignShow(eRedSignKey.MercenaryLevelUp) then
            self.mercenaryMgr.SetLevelUpRedSignClicked(self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id, true)
        end
    end)
    self.panel.AdvanceBtn:AddClick(function()
        local l_jobTable = TableUtil.GetMercenaryTable().GetRowById(tonumber(self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id) + 1, true)
        if self.selectedMercenaryCellTemplate.mercenaryInfo and l_jobTable then
            UIMgr:ActiveUI(UI.CtrlNames.MercenaryAdvanced, function(ctrl)
                ctrl:SetData(self.selectedMercenaryCellTemplate.mercenaryInfo)
            end)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Mercenary_Adv_Tips"))
        end

    end)


    --初始装备面板
    self.curSelectedEquipPosition = 1
    self.panel.EquipTog[1].Tog.isOn = true
    for i = 1, #self.panel.EquipTog do
        self.panel.EquipTog[i].Tog.onValueChanged:AddListener(function(isOn)
            if isOn then
                self.curSelectedEquipPosition = i
                self:RefreshEquipmentDetail()
            end
        end)
        self.panel.EquipImg[i]:AddClick(function()
            if i == 4 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_NO_OFFHAND"))
            end
        end)
    end
    --装备升级
    self.panel.EquipUpgradeBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_equipInfo = l_mercenaryInfo.equipInfoByPos[self.curSelectedEquipPosition]
        if l_equipInfo then
            if l_equipInfo.level >= l_mercenaryInfo.level then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_EQUIP_UPGRADE"))
                return
            end

            local l_cost = 0
            local l_costRow = TableUtil.GetMercenaryLevelTable().GetRowByJobLv(l_equipInfo.level)
            if l_costRow then
                l_cost = l_costRow.EquipExp
            end

            -- if l_cost > MLuaCommonHelper.Long2Int(MPlayerInfo.Coin101) then
            --     local itemData = Data.BagModel:CreateItemWithTid(GameEnum.l_virProp.Coin101)
            --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
            --     return
            -- end

            self.mercenaryMgr.EquipOperate(l_tableInfo.Id, l_equipInfo.tableInfo.ID, 1, 1 ,l_cost)
        end
    end)
    --装备进阶
    self.panel.EquipAdvanceBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_equipInfo = l_mercenaryInfo.equipInfoByPos[self.curSelectedEquipPosition]
        if l_equipInfo then
            self.mercenaryMgr.EquipOperate(l_tableInfo.Id, l_equipInfo.tableInfo.ID, 0, 2)
        end
    end)
    --一键升级
    self.panel.OnekeyUpgradeBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_equipInfo = l_mercenaryInfo.equipInfoByPos[self.curSelectedEquipPosition]
        if l_equipInfo then
            if l_equipInfo.level >= l_mercenaryInfo.level then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_EQUIP_UPGRADE"))
                return
            end

            local l_needAdvance = l_equipInfo.level == l_equipInfo.tableInfo.MaxLevel
            if l_needAdvance then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_EQUIP_NEED_ADCANCE"))
                return
            end

            local l_maxLevel = math.min(l_equipInfo.tableInfo.MaxLevel, l_mercenaryInfo.level)
            local l_levelCount = 0
            local l_totalCost = 0
            for i = l_equipInfo.level, l_maxLevel - 1 do
                local l_levelUpCost = 0
                local l_costRow = TableUtil.GetMercenaryLevelTable().GetRowByJobLv(i)
                if l_costRow then
                    l_levelUpCost = l_costRow.EquipExp
                end
                l_totalCost = l_totalCost + l_levelUpCost
                l_levelCount = l_levelCount + 1

                -- if l_totalCost + l_levelUpCost <= MLuaCommonHelper.Long2Int(MPlayerInfo.Coin101) then
                --     l_totalCost = l_totalCost + l_levelUpCost
                --     l_levelCount = l_levelCount + 1
                -- else
                --     break
                -- end
            end

            if l_levelCount == 0 then
                local itemData = Data.BagModel:CreateItemWithTid(GameEnum.l_virProp.Coin101)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
                return
            end
            CommonUI.Dialog.ShowYesNoDlg(true, nil, RoColor.FormatWord(Lang("MERCENARY_EQUIP_ONEKEY_UPGRADE", MNumberFormat.GetNumberFormat(l_totalCost), l_equipInfo.tableInfo.Name, l_equipInfo.level + l_levelCount)),
                    function()
                        self.mercenaryMgr.EquipOperate(l_tableInfo.Id, l_equipInfo.tableInfo.ID, l_levelCount,1,tonumber(l_totalCost))
                    end)
        end
    end)

    --初始天赋面板
    --天赋学习
    self.panel.TalentStudyBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end

        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_talentPointCost = self:GetCurTalentCost()
        if l_talentPointCost > Data.BagModel:GetBagItemCountByTid(self.mercenaryMgr.TalentItemId) then
            local itemData = Data.BagModel:CreateItemWithTid(self.mercenaryMgr.TalentItemId)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_POINT_NOT_ENOUGH"))
            return
        end

        self.mercenaryMgr.TalentOperate(l_tableInfo.Id, self.selectedTalentInfo.tableInfo.ID, 0, MercenaryTalentOperation.kMercenaryTalentOperationStudy)
    end)
    --天赋升级
    self.panel.TalentUpgradeBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate or not self.selectedTalentInfo then
            return
        end

        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_talentLevel = l_mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel].level
        local l_talentPointCost = self:GetCurTalentCost()
        if l_talentPointCost > Data.BagModel:GetBagItemCountByTid(self.mercenaryMgr.TalentItemId) then
            local itemData = Data.BagModel:CreateItemWithTid(self.mercenaryMgr.TalentItemId)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_POINT_NOT_ENOUGH"))
            return
        end

        self.mercenaryMgr.TalentOperate(l_tableInfo.Id, self.selectedTalentInfo.talentBaseId + l_talentLevel, 0, MercenaryTalentOperation.kMercenaryTalentOperationUpgrade)
    end)

    --天赋重置
    self.panel.TalentResetBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_talentGroupInfo = l_mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel]
        local l_effectTalent = l_mercenaryInfo.talentInfo[l_talentGroupInfo.selectedTalentBaseId]
        local l_isNeedReset = false
        for _, v in pairs(l_mercenaryInfo.talentGroupInfo) do
            if v.isStudied then
                l_isNeedReset = true
                break
            end
        end
        if not l_isNeedReset then
            return
        end

        local l_costs = MGlobalConfig:GetVectorSequence("TalentResetCost")
        local l_cost = 0
        for i = 0, l_costs.Length - 1 do
            if tonumber(l_costs[i][0]) == 101 then
                l_cost = tonumber(l_costs[i][1])
                break
            end
        end

        CommonUI.Dialog.ShowYesNoDlg(true, nil, RoColor.FormatWord(Lang("MERCENARY_TALENT_RESET", MNumberFormat.GetNumberFormat(l_cost))), function()
            if l_cost > MLuaCommonHelper.Long2Int(MPlayerInfo.Coin101) then
                local itemData = Data.BagModel:CreateItemWithTid(GameEnum.l_virProp.Coin101)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
                return
            end
            if l_talentGroupInfo.strengthenTimeCountDown > 0 then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MERCENARY_TALENT_STRENGTH_SWITCH", l_effectTalent.tableInfo.Name), function()
                    self.mercenaryMgr.TalentOperate(l_tableInfo.Id, 0, 0, MercenaryTalentOperation.kMercenaryTalentOperationReset)
                end)
            else
                self.mercenaryMgr.TalentOperate(l_tableInfo.Id, 0, 0, MercenaryTalentOperation.kMercenaryTalentOperationReset)
            end
        end)
    end)
    --天赋强化
    self.panel.TalentStrengthenBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo

        if MGlobalConfig:GetInt("TalentBreakLimitLevel") > MPlayerInfo.Lv then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_UNLOCK", MGlobalConfig:GetInt("TalentBreakLimitLevel")))
            return
        end

        local l_curStrengthenTalentInfo = nil
        for _, groupTalentInfo in pairs(l_mercenaryInfo.talentGroupInfo) do
            if groupTalentInfo.strengthenTimeCountDown > 0 then
                l_curStrengthenTalentInfo = l_mercenaryInfo.talentInfo[groupTalentInfo.selectedTalentBaseId]
                break
            end
        end
        local l_func = function()
            local l_talentPointCost = self:GetCurTalentCost()
            if l_talentPointCost > Data.BagModel:GetBagItemCountByTid(self.mercenaryMgr.TalentItemId) then
                local itemData = Data.BagModel:CreateItemWithTid(self.mercenaryMgr.TalentItemId)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_POINT_NOT_ENOUGH"))
                return
            end

            CommonUI.Dialog.ShowYesNoDlg(true, nil, RoColor.FormatWord(Lang("MERCENARY_STRENGTHEN_AFFIRM", l_talentPointCost, self.selectedTalentInfo.tableInfo.Name, MGlobalConfig:GetInt("TalentBreakDuration"))), function()
                self.mercenaryMgr.TalentOperate(l_tableInfo.Id, self.selectedTalentInfo.tableInfo.ID, 0, MercenaryTalentOperation.kMercenaryTalentOperationStrengthen)
            end)

        end
        if l_curStrengthenTalentInfo then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MERCENARY_STRENGTHENING_BREAK", l_curStrengthenTalentInfo.tableInfo.Name, self.selectedTalentInfo.tableInfo.Name), l_func)
        else
            l_func()
        end

    end)
    --天赋切换
    self.panel.TalentSwitchBtn:AddClick(function()
        if not self.selectedMercenaryCellTemplate or not self.selectedTalentInfo then
            return
        end
        local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
        local l_tableInfo = l_mercenaryInfo.tableInfo
        local l_talentGroupInfo = l_mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel]
        local l_talentLevel = l_talentGroupInfo.level
        local l_effectTalent = l_mercenaryInfo.talentInfo[l_talentGroupInfo.selectedTalentBaseId]

        if l_talentGroupInfo.strengthenTimeCountDown > 0 then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MERCENARY_TALENT_STRENGTH_SWITCH", l_effectTalent.tableInfo.Name),
                    function()
                        self.mercenaryMgr.SwitchTalent(l_tableInfo.Id, self.selectedTalentInfo.talentBaseId + l_talentLevel)
                    end)
        else
            self.mercenaryMgr.SwitchTalent(l_tableInfo.Id, self.selectedTalentInfo.talentBaseId + l_talentLevel)
        end
    end)

    local L_CONST_DEFAULT_WIDTH = 400

    --天赋点说明
    self.panel.MercenaryPointHelpBtn.Listener.onDown = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MERCENARY_POINT_HELP", MGlobalConfig:GetInt("TalentBreakDuration")), eventData, Vector2(1, 1), true, L_CONST_DEFAULT_WIDTH)
    end

    --佣兵升级说明
    self.panel.UpgradeHelpBtn.Listener.onDown = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MERCENARY_UPGRADE_HELP"), eventData, Vector2(1, 0), true, L_CONST_DEFAULT_WIDTH)
    end

    --可选技能说明
    self.panel.OptionSkillHelpBtn.Listener.onDown = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("MERCENARY_OPTION_SKILL_HELP"), eventData, Vector2(1, 1), true, L_CONST_DEFAULT_WIDTH)
    end

    -- 设置天赋卷轴icon
    local l_pointRow = TableUtil.GetItemTable().GetRowByItemID(self.mercenaryMgr.TalentItemId)
    if l_pointRow then
        self.panel.PointIcon:SetSprite(l_pointRow.ItemAtlas, l_pointRow.ItemIcon)
        self.panel.PointCostIcon:SetSprite(l_pointRow.ItemAtlas, l_pointRow.ItemIcon)
    end

    --初始化佣兵列表，处理默认选中逻辑，需要在刷新面板之前
    self:RefreshMercenaryList()

    --self:RefreshPanel()

    self:RefreshCurrency()

    -- 默认选中第一个
    self.panel.AttributeTog.TogEx.isOn = true

    -- 功能屏蔽处理
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isTalentOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.MercenaryTalent)
    self.panel.TalentTog:SetActiveEx(l_isTalentOpen)
end

--刷新钱币
function MercenaryCtrl:RefreshCurrency()
    self.panel.MercenaryPointHelpBtn:SetActiveEx(self.panel.TalentTog.TogEx.isOn)
    self.panel.CoinIcon:SetActiveEx(not self.panel.TalentTog.TogEx.isOn)
    self.panel.PointIcon:SetActiveEx(self.panel.TalentTog.TogEx.isOn)
    if self.panel.TalentTog.TogEx.isOn then
        local l_count = Data.BagModel:GetBagItemCountByTid(self.mercenaryMgr.TalentItemId)
        self.panel.CurrencyText.LabText = MNumberFormat.GetNumberFormat(tostring(l_count))
    else
        local l_count = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin101)
        self.panel.CurrencyText.LabText = MNumberFormat.GetNumberFormat(tostring(l_count))
    end
end

--刷新面板
function MercenaryCtrl:RefreshPanel()
    -- 属性
    if self.panel.AttributeTog.TogEx.isOn then
        self:RefreshAttribute()
    end
    -- 装备
    if self.panel.EquipmentTog.TogEx.isOn then
        self:RefreshEquipment()
    end
    -- 介绍
    if self.panel.IntroductionTog.TogEx.isOn then
        self:RefreshIntroduction()
    end
    -- 技能
    if self.panel.SkillTog.TogEx.isOn then
        self:RefreshSkill()
    end
    -- 天赋
    if self.panel.TalentTog.TogEx.isOn then
        self:RefreshTalent()
    end

    self:RefreshMercenaryInfo()
end

-- 控制子页面的显示隐藏
function MercenaryCtrl:RefreshPanelVisible()
    -- 属性
    self.panel.Attribute:SetActiveEx(self.panel.AttributeTog.TogEx.isOn)
    -- 装备
    self.panel.MerEquipment:SetActiveEx(self.panel.EquipmentTog.TogEx.isOn)
    -- 介绍
    self.panel.Introduction:SetActiveEx(self.panel.IntroductionTog.TogEx.isOn)
    -- 技能
    self.panel.Skill:SetActiveEx(self.panel.SkillTog.TogEx.isOn)
    -- 天赋
    self.panel.MerTalent:SetActiveEx(self.panel.TalentTog.TogEx.isOn)

    self:RefreshMercenaryInfo()

    --红点刷新
    self.mercenaryMgr.RefreshRedSign()
end

--刷新佣兵信息
function MercenaryCtrl:RefreshMercenaryInfo()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    self.panel.NameText.LabText = l_tableInfo.Name
    if l_mercenaryInfo.isRecruited then
        self.panel.MercenaryImg:SetRawTexAsync(l_tableInfo.Picture, nil, true)
    else
        self.panel.NotRecruitImg:SetRawTexAsync(l_tableInfo.Picture, nil, true)
    end

    self.panel.EquipPanel:SetActiveEx(l_mercenaryInfo.isRecruited and self.panel.EquipmentTog.TogEx.isOn)
    self.panel.MercenaryImg:SetActiveEx(l_mercenaryInfo.isRecruited and not self.panel.EquipmentTog.TogEx.isOn)
    self.panel.NotRecruitImg:SetActiveEx(not l_mercenaryInfo.isRecruited and not self.panel.EquipmentTog.TogEx.isOn)

    local l_jobRow = TableUtil.GetProfessionTable().GetRowById(l_tableInfo.Profession)
    if l_jobRow then
        self.panel.JobImg:SetSprite("Common", l_jobRow.ProfessionIcon)
    end
end

--刷新属性面板
function MercenaryCtrl:RefreshAttribute()
    if not self.panel.Attribute.gameObject.activeSelf then
        return
    end

    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    local l_attrData = {}
    for _, attr in pairs(l_mercenaryInfo.attrs) do
        table.insert(l_attrData, { attrInfo = attr, isRecruited = l_mercenaryInfo.isRecruited })
    end
    --属性显示排序
    table.sort(l_attrData, function(a, b)
        return a.attrInfo.tableInfo.ShortId < b.attrInfo.tableInfo.ShortId
    end)

    if not self.attrTemplatePool then
        self.attrTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenaryAttrCellTemplate,
            TemplatePath = "UI/Prefabs/MercenaryAttrCellTemplate",
            TemplateParent = self.panel.AttrContent.transform,
        })
    end
    self.attrTemplatePool:ShowTemplates({ Datas = l_attrData })

    --六维信息显示
    local l_setPolygon = self.panel.Liubianxing.gameObject:GetComponent("MUISetPolygon")
    local l_strValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_STR] or 0
    local l_vitValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_VIT] or 0
    local l_agiValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_AGI] or 0
    local l_intValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_INT] or 0
    local l_dexValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_DEX] or 0
    local l_lukValue = l_mercenaryInfo.sixAttrs[AttrType.ATTR_BASIC_LUK] or 0
    self.panel.StrText.LabText = l_strValue
    self.panel.VitText.LabText = l_vitValue
    self.panel.AgiText.LabText = l_agiValue
    self.panel.IntText.LabText = l_intValue
    self.panel.DexText.LabText = l_dexValue
    self.panel.LukText.LabText = l_lukValue

    l_setPolygon:SetValueByIndex(0, 0.4 + 0.6 * (l_strValue / 99.0))--str
    l_setPolygon:SetValueByIndex(5, 0.4 + 0.6 * (l_vitValue / 99.0))--vit
    l_setPolygon:SetValueByIndex(1, 0.4 + 0.6 * (l_agiValue / 99.0))--agi
    l_setPolygon:SetValueByIndex(3, 0.4 + 0.6 * (l_intValue / 99.0))--int
    l_setPolygon:SetValueByIndex(2, 0.4 + 0.6 * (l_dexValue / 99.0))--dex
    l_setPolygon:SetValueByIndex(4, 0.4 + 0.6 * (l_lukValue / 99.0))--luk

    if l_mercenaryInfo.isRecruited then
        self.panel.LevelText.LabText = "Lv." .. l_mercenaryInfo.level
        local l_expRow = TableUtil.GetMercenaryLevelTable().GetRowByJobLv(l_mercenaryInfo.level)
        if l_expRow then
            self.panel.LevelSlider.Slider.value = l_mercenaryInfo.exp / l_expRow.Exp
            self.panel.LevelSliderText.LabText = l_mercenaryInfo.exp .. "/" .. l_expRow.Exp
        end
    end
    -- 功能屏蔽处理
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isUpgradeOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.MercenaryUpgrade)
    self.panel.MercenaryLevel:SetActiveEx(l_mercenaryInfo.isRecruited and l_isUpgradeOpen)
    self.panel.RecruitCondition:SetActiveEx(not l_mercenaryInfo.isRecruited)
    --招募条件
    if not l_mercenaryInfo.isRecruited then
        local l_recruitData = {}
        for i = 0, l_mercenaryInfo.tableInfo.Unlock.Length - 1 do
            if l_mercenaryInfo.tableInfo.Unlock[i][0] == 1 then
                table.insert(l_recruitData, { lockLevel = l_mercenaryInfo.tableInfo.Unlock[i][1] })
            elseif l_mercenaryInfo.tableInfo.Unlock[i][0] == 2 then
                table.insert(l_recruitData, { achievementPoint = l_mercenaryInfo.tableInfo.Unlock[i][1] })
            elseif l_mercenaryInfo.tableInfo.Unlock[i][0] == 3 then
                table.insert(l_recruitData, { achievementId = l_mercenaryInfo.tableInfo.Unlock[i][1] })
            end
        end
        table.insert(l_recruitData, { taskId = l_mercenaryInfo.tableInfo.RecruitTask[0], finishTaskId = l_mercenaryInfo.tableInfo.RecruitTask[1] })
        if not self.recruitConditionTemplatePool then
            self.recruitConditionTemplatePool = self:NewTemplatePool({
                UITemplateClass = UITemplate.MercenaryRecruitConditionTemplate,
                TemplatePrefab = self.panel.MercenaryRecruitCondition.LuaUIGroup.gameObject,
                TemplateParent = self.panel.RecruitContent.transform,
            })
        end
        self.recruitConditionTemplatePool:ShowTemplates({ Datas = l_recruitData })

    end

end

--刷新升级物品
function MercenaryCtrl:RefreshLevelUpItems()
    local l_itemData = {}
    local l_items = MGlobalConfig:GetVectorSequence("LevelUpItemCost")
    local l_mercenaryId = 0
    if self.selectedMercenaryCellTemplate then
        l_mercenaryId = self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id
    end
    for i = 0, l_items.Length - 1 do
        local l_itemId = tonumber(l_items[i][0])
        local l_expAdd = tonumber(l_items[i][1])
        table.insert(l_itemData, { itemId = l_itemId, expAdd = l_expAdd, mercenaryId = l_mercenaryId })
    end

    if not self.levelUpItemTemplatePool then
        self.levelUpItemTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenaryUpgradeItemTemplate,
            TemplatePrefab = self.panel.MercenaryUpgradeItem.LuaUIGroup.gameObject,
            TemplateParent = self.panel.UpgradeItemsContent.transform
        })
    end
    self.levelUpItemTemplatePool:ShowTemplates({ Datas = l_itemData })
end

--刷新技能面板
function MercenaryCtrl:RefreshSkill()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    local l_fixSkill = {}
    local l_optionSkill = {}
    for _, v in pairs(l_mercenaryInfo.skillInfo) do
        if v.isOptionSkill then
            table.insert(l_optionSkill, v)
        else
            table.insert(l_fixSkill, v)
        end
    end

    table.sort(l_fixSkill, function(a, b)
        return a.index < b.index
    end)

    table.sort(l_optionSkill, function(a, b)
        return a.index < b.index
    end)

    --设置固定技能
    local l_fixSkillData = {}
    for i = 1, #l_fixSkill do
        table.insert(l_fixSkillData, { skillInfo = l_fixSkill[i], mercenaryInfo = l_mercenaryInfo })
    end
    if not self.fixSkillTemplatePool then
        self.fixSkillTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenarySkillCellTemplate,
            TemplatePath = "UI/Prefabs/MercenarySkillCellTemplate",
            TemplateParent = self.panel.FixSkillContent.transform,
        })
    end
    self.fixSkillTemplatePool:ShowTemplates({ Datas = l_fixSkillData })
    --设置可选技能
    local l_optionSkillData = {}
    for i = 1, #l_optionSkill do
        table.insert(l_optionSkillData, { skillInfo = l_optionSkill[i], mercenaryInfo = l_mercenaryInfo })
    end
    if not self.optionSkillTemplatePool then
        self.optionSkillTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenarySkillCellTemplate,
            TemplatePath = "UI/Prefabs/MercenarySkillCellTemplate",
            TemplateParent = self.panel.OptionSkillContent.transform,
        })
    end
    self.optionSkillTemplatePool:ShowTemplates({ Datas = l_optionSkillData })
end

--刷新介绍面板
function MercenaryCtrl:RefreshIntroduction()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    self.panel.StoryText.LabText = l_tableInfo.Desc

    local l_data = {}
    --流派
    table.insert(l_data, { des = Lang("GENRE", ""), schoolName = l_tableInfo.Schools, mercenaryInfo = l_mercenaryInfo })
    --姓名
    table.insert(l_data, { des = Lang("NAME", l_tableInfo.Name), isMale = l_tableInfo.Sex == 0, isFemale = l_tableInfo.Sex == 1, mercenaryInfo = l_mercenaryInfo })
    --职业
    local l_professionRow = TableUtil.GetProfessionTable().GetRowById(l_tableInfo.Profession)
    if l_professionRow then
        table.insert(l_data, { des = Lang("PROFESSION", l_professionRow.Name), mercenaryInfo = l_mercenaryInfo })
    end
    for i = 0, l_tableInfo.information.Length - 1 do
        table.insert(l_data, { des = l_tableInfo.information[i], mercenaryInfo = l_mercenaryInfo })
    end
    if not self.informationCellTemplatePool then
        self.informationCellTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenaryIntroductionCellTemplate,
            TemplatePrefab = self.panel.MercenaryIntroductionCell.LuaUIGroup.gameObject,
            TemplateParent = self.panel.IntroductionContent.transform,
        })
    end
    self.informationCellTemplatePool:ShowTemplates({ Datas = l_data })
end

--刷新装备面板
function MercenaryCtrl:RefreshEquipment()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    --设置佣兵模型
    local l_presentRow = TableUtil.GetPresentTable().GetRowById(l_tableInfo.PresentID)
    if l_presentRow and self.lastModelMercenaryId ~= l_tableInfo.Id then
        self.lastModelMercenaryId = l_tableInfo.Id
        if self.mercenaryModel then
            self:DestroyUIModel(self.mercenaryModel)
            self.mercenaryModel = nil
        end
        local l_modelData = {
            defaultEquipId = l_tableInfo.DefaultEquipID,
            presentId = l_tableInfo.PresentID,
            rawImage = self.panel.ModelImage.RawImg
        }
        self.mercenaryModel = self:CreateUIModelByDefaultEquipId(l_modelData)
    end

    --设置装备信息
    for i = 1, 6 do
        local l_equip = l_mercenaryInfo.equipInfoByPos[i]
        if l_equip then
            --self.panel.EquipTog[i].Tog.enabled = true
            self.panel.Img_Icon[i]:SetActiveEx(true)
            self.panel.EquipLevelText[i]:SetActiveEx(true)
            self.panel.EquipImg[i]:SetActiveEx(false)

            local l_needLevelUp = self.mercenaryMgr.CanOneEquipLevelUp(l_equip.tableInfo.ID, l_equip.level, l_mercenaryInfo.level)
            self.panel.EquipImg[i]:SetActiveEx(false)
            self.panel.Img_Icon[i]:SetSprite(l_equip.tableInfo.IconAtlas, l_equip.tableInfo.Icon, true)
            self.panel.EquipLevelText[i].LabText = l_equip.level
            self.panel.EquipLevelup[i]:SetActiveEx(l_needLevelUp)
        else
            if self.panel.EquipTog[i].Tog.isOn then
                self.panel.EquipTog[1].Tog.isOn = true
            end
            --self.panel.EquipTog[i].Tog.enabled = false
            self.panel.Img_Icon[i]:SetActiveEx(false)
            self.panel.EquipLevelText[i]:SetActiveEx(false)
            self.panel.EquipImg[i]:SetActiveEx(true)
            self.panel.EquipLevelup[i]:SetActiveEx(false)
        end
    end

    self:RefreshEquipmentDetail()
end


--刷新装备详细
function MercenaryCtrl:RefreshEquipmentDetail()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    local l_equipInfo = l_mercenaryInfo.equipInfoByPos[self.curSelectedEquipPosition]
    if l_equipInfo then
        self.panel.EquipNameText[1].LabText = string.format("Lv.%s %s", l_equipInfo.level, l_equipInfo.tableInfo.Name)
        self.panel.EquipPosText[1].LabText = l_equipInfo.tableInfo.PositionName
        self.panel.EquipIconImg[1]:SetSprite(l_equipInfo.tableInfo.IconAtlas, l_equipInfo.tableInfo.Icon, true)

        local l_needAdvance = l_equipInfo.level == l_equipInfo.tableInfo.MaxLevel
        self.panel.EquipUpgradeBtn:SetActiveEx(not l_needAdvance)
        --self.panel.OnekeyUpgradeBtn:SetActiveEx(not l_needAdvance)
        self.panel.EquipAdvanceBtn:SetActiveEx(l_needAdvance)

        self.panel.UpgradeArrow:SetActiveEx(not l_needAdvance)
        self.panel.AdvanceArrow:SetActiveEx(l_needAdvance)

        self.panel.EquipUpgradeBtns:SetActiveEx(true)
        self.panel.EquipUpgradeHighest:SetActiveEx(false)

        local l_beforeAttrData = {}
        local l_afterAttrData = {}
        self.panel.EquipDetail[2]:SetActiveEx(true)
        --保存数据用于前后数据对比使用
        local l_beforeAttrForCompare = {}
        for i = 1, #l_equipInfo.attrs do
            local l_beforeAttr = {}
            l_beforeAttr.attrId = l_equipInfo.attrs[i].attrId
            l_beforeAttr.value = l_equipInfo.attrs[i].baseValue + l_equipInfo.attrs[i].growth * (l_equipInfo.level - l_equipInfo.tableInfo.MinLevel)
            table.insert(l_beforeAttrData, l_beforeAttr)

            l_beforeAttrForCompare[l_beforeAttr.attrId] = l_beforeAttr.value
        end
        if l_needAdvance then
            if l_equipInfo.tableInfo.AdvancedID ~= 0 then
                self.panel.EquipUpgradeBtns:SetActiveEx(true)

                local l_advanceEquipRow = TableUtil.GetMercenaryEquipTable().GetRowByID(l_equipInfo.tableInfo.AdvancedID)
                if l_advanceEquipRow then
                    self.panel.EquipNameText[2].LabText = string.format("Lv.%s %s", l_equipInfo.level + 1, l_advanceEquipRow.Name)
                    self.panel.EquipIconImg[2]:SetSprite(l_advanceEquipRow.IconAtlas, l_advanceEquipRow.Icon, true)

                    local l_advanceEquipInfo = self.mercenaryMgr.GetEquipInfoFromTable(l_advanceEquipRow.ID)
                    for i = 1, #l_advanceEquipInfo.attrs do
                        local l_afterAttr = {}
                        l_afterAttr.attrId = l_advanceEquipInfo.attrs[i].attrId
                        l_afterAttr.value = l_advanceEquipInfo.attrs[i].baseValue
                        l_afterAttr.beforeValue = l_beforeAttrForCompare[l_afterAttr.attrId]
                        table.insert(l_afterAttrData, l_afterAttr)
                    end
                end
                self.panel.EquipZeny:SetActiveEx(true)
                local l_coin = 0
                local l_zeny = 0
                for i = 0, l_equipInfo.tableInfo.AdvancedCost.Length - 1 do
                    if l_equipInfo.tableInfo.AdvancedCost[i][0] == 101 then
                        l_coin = l_equipInfo.tableInfo.AdvancedCost[i][1]
                    elseif l_equipInfo.tableInfo.AdvancedCost[i][0] == 102 then
                        l_zeny = l_equipInfo.tableInfo.AdvancedCost[i][1]
                    end
                end
                self:SetEquipCost({ [101] = l_coin, [102] = l_zeny })
            else
                self.panel.EquipDetail[2]:SetActiveEx(false)
                self.panel.AdvanceArrow:SetActiveEx(false)

                self.panel.EquipUpgradeBtns:SetActiveEx(false)
                self.panel.EquipUpgradeHighest:SetActiveEx(true)
            end
        else
            self.panel.EquipNameText[2].LabText = string.format("Lv.%s %s", l_equipInfo.level + 1, l_equipInfo.tableInfo.Name)
            self.panel.EquipPosText[2].LabText = l_equipInfo.tableInfo.PositionName
            self.panel.EquipIconImg[2]:SetSprite(l_equipInfo.tableInfo.IconAtlas, l_equipInfo.tableInfo.Icon, true)
            for i = 1, #l_equipInfo.attrs do
                local l_afterAttr = {}
                l_afterAttr.attrId = l_equipInfo.attrs[i].attrId
                l_afterAttr.value = l_equipInfo.attrs[i].baseValue + l_equipInfo.attrs[i].growth * (l_equipInfo.level + 1 - l_equipInfo.tableInfo.MinLevel)
                l_afterAttr.beforeValue = l_beforeAttrForCompare[l_afterAttr.attrId]
                table.insert(l_afterAttrData, l_afterAttr)
            end
            self.panel.EquipZeny:SetActiveEx(false)
            local l_cost = 0
            local l_costRow = TableUtil.GetMercenaryLevelTable().GetRowByJobLv(l_equipInfo.level)
            if l_costRow then
                l_cost = l_costRow.EquipExp
            end
            self:SetEquipCost({ [101] = l_cost })
        end
        --特殊处理，删除id为10的属性
        for i = 1, #l_beforeAttrData do
            if l_beforeAttrData[i].attrId == 10 then
                table.remove(l_beforeAttrData, i)
                break
            end
        end
        for i = 1, #l_afterAttrData do
            if l_afterAttrData[i].attrId == 10 then
                table.remove(l_afterAttrData, i)
                break
            end
        end
        if not self.beforeEquipAttrTemplates then
            self.beforeEquipAttrTemplates = self:NewTemplatePool({
                UITemplateClass = UITemplate.MercenaryEquipAttrTemplate,
                TemplatePrefab = self.panel.MercenaryEquipAttr.LuaUIGroup.gameObject,
                TemplateParent = self.panel.EquipAttrContent[1].transform,
            })
        end
        self.beforeEquipAttrTemplates:ShowTemplates { Datas = l_beforeAttrData }
        if not self.afterEquipAttrTemplates then
            self.afterEquipAttrTemplates = self:NewTemplatePool({
                UITemplateClass = UITemplate.MercenaryEquipAttrTemplate,
                TemplatePrefab = self.panel.MercenaryEquipAttr.LuaUIGroup.gameObject,
                TemplateParent = self.panel.EquipAttrContent[2].transform,
            })
        end
        self.afterEquipAttrTemplates:ShowTemplates { Datas = l_afterAttrData }
    end

    --刷新布局
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Coins.RectTransform)
end


--设置装备消耗
function MercenaryCtrl:SetEquipCost(costs)
    if costs[101] then
        self.panel.EquipCoinText.LabText = costs[101]
        if costs[101] > MLuaCommonHelper.Long2Int(MPlayerInfo.Coin101) then
            self.panel.EquipCoinText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
        else
            self.panel.EquipCoinText.LabColor = RoColor.Hex2Color(RoColor.WordColor.None[1])
        end
    end
    if costs[102] then
        self.panel.EquipZenyText.LabText = costs[102]
        if costs[102] > MLuaCommonHelper.Long2Int(MPlayerInfo.Coin102) then
            self.panel.EquipZenyText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
        else
            self.panel.EquipZenyText.LabColor = RoColor.Hex2Color(RoColor.WordColor.None[1])
        end
    end
end


--刷新天赋面板
function MercenaryCtrl:RefreshTalent()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    local l_tableInfo = l_mercenaryInfo.tableInfo

    --同一个佣兵只刷数据，不清状态
    local l_onlyRefreshData = true
    if self.lastTalentRefreshMercenaryId ~= l_tableInfo.Id then
        self.lastTalentRefreshMercenaryId = l_tableInfo.Id
        l_onlyRefreshData = false
    end

    if not l_onlyRefreshData then
        self:ResetTalent()
    end

    local l_talentInfoByLevel = {}
    local l_talentInfoSorted = {}
    for _, v in pairs(l_mercenaryInfo.talentInfo) do
        if not l_talentInfoByLevel[v.lockLevel] then
            local l_talents = {}
            l_talentInfoByLevel[v.lockLevel] = l_talents
            table.insert(l_talentInfoSorted, { lockLevel = v.lockLevel, talents = l_talents })
        end
        table.insert(l_talentInfoByLevel[v.lockLevel], v)
    end
    table.sort(l_talentInfoSorted, function(a, b)
        return a.lockLevel < b.lockLevel
    end)

    local l_data = {}
    for i = 1, #l_talentInfoSorted do
        table.insert(l_data,
                { mercenaryInfo = l_mercenaryInfo,
                  talentInfo = l_talentInfoSorted[i],
                  groupInfo = l_mercenaryInfo.talentGroupInfo[l_talentInfoSorted[i].lockLevel],
                  parentCtrl = self,
                  onlyRefreshData = l_onlyRefreshData })
    end
    if not self.talentInfoTemplatePool then
        self.talentInfoTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenaryTalentInfoTemplate,
            TemplatePrefab = self.panel.MercenaryTalentInfo.LuaUIGroup.gameObject,
            TemplateParent = self.panel.TalentInfoContent.transform,
        })
    end
    self.talentInfoTemplatePool:ShowTemplates({ Datas = l_data })

    self:RefreshTalentDetail()
end

function MercenaryCtrl:HandleTalentInfoClicked(talentInfoTemplate)
    if self.selectedTalentInfoTemplate == talentInfoTemplate then
        self:ResetTalent()
        self:RefreshTalentDetail()
    elseif self.selectedTalentInfoTemplate then
        self.selectedTalentInfoTemplate:SetSelected(false)
        self.selectedTalentInfoTemplate = talentInfoTemplate
        self.selectedTalentInfoTemplate:SetSelected(true)
    else
        self.selectedTalentInfoTemplate = talentInfoTemplate
        self.selectedTalentInfoTemplate:SetSelected(true)
    end
end

function MercenaryCtrl:HandleTalentCellClicked(talentCellTemplate)
    if self.selectedTalentCellTemplate then
        self.selectedTalentCellTemplate:SetSelected(false)
    end
    self.selectedTalentCellTemplate = talentCellTemplate
    self.selectedTalentCellTemplate:SetSelected(true)
    self.selectedTalentInfo = talentCellTemplate.talent
    self:RefreshTalentDetail()
end

function MercenaryCtrl:ResetTalent()
    self.selectedTalentInfo = nil
    if self.selectedTalentCellTemplate then
        self.selectedTalentCellTemplate:SetSelected(false)
        self.selectedTalentCellTemplate = nil
    end
    if self.selectedTalentInfoTemplate then
        self.selectedTalentInfoTemplate:SetSelected(false)
        self.selectedTalentInfoTemplate = nil
    end
end

--刷新天赋详细
function MercenaryCtrl:RefreshTalentDetail()
    if not self.selectedMercenaryCellTemplate then
        return
    end
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    if self.selectedTalentInfo then
        self.panel.TalentDetail:SetActiveEx(true)
        self.panel.NoTalent:SetActiveEx(false)

        local l_talentGroupInfo = l_mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel]

        self.panel.TalentResetBtn:SetActiveEx(l_talentGroupInfo.isStudied)

        self.panel.TalentNameText.LabText = self.selectedTalentInfo.tableInfo.Name
        self.panel.TalentDesText.LabText = self.selectedTalentInfo.tableInfo.Description
        if self.selectedTalentInfo.tableInfo.Sign == 2 then
            self.panel.TalentLevelText.LabText = "Lv.Max"
        else
            self.panel.TalentLevelText.LabText = "Lv." .. l_talentGroupInfo.level
        end
        local l_isTalentGray = not l_talentGroupInfo.isStudied or l_talentGroupInfo.selectedTalentBaseId ~= self.selectedTalentInfo.talentBaseId
        self.panel.TalentImg:SetSprite(self.selectedTalentInfo.tableInfo.IconAtlas, self.selectedTalentInfo.tableInfo.Icon)
        self.panel.TalentImg:SetGray(l_isTalentGray)
        --设置等级图标
        self.panel.TalentLvMax:SetActiveEx(self.selectedTalentInfo.tableInfo.Sign == 2)
        self.panel.TalentLvMax:SetGray(l_isTalentGray)
        if not self.talentLvComs then
            self.talentLvComs = { self.panel.TalentLv1, self.panel.TalentLv2, self.panel.TalentLv3, self.panel.TalentLv4 }
        end
        local l_lvIndex = 0
        l_lvIndex = self.selectedTalentInfo.tableInfo.ID % 10
        for i, com in ipairs(self.talentLvComs) do
            com:SetActiveEx(i == l_lvIndex)
            com:SetGray(l_isTalentGray)
        end

        local l_isLocked = l_mercenaryInfo.level < self.selectedTalentInfo.lockLevel
        local l_isSelected = l_talentGroupInfo.selectedTalentBaseId == self.selectedTalentInfo.talentBaseId
        local l_isStrengthen = l_talentGroupInfo.strengthenTimeCountDown > 0
        self.panel.TalentSwitchBtn:SetActiveEx(not l_isSelected and l_talentGroupInfo.isStudied)

        self.panel.TalentLockText:SetActiveEx(l_isLocked)
        self.panel.TalentLockText.LabText = Lang("MERCENARY_LOCK_LEVEL", self.selectedTalentInfo.lockLevel)

        self.panel.TalentStudyBtn:SetActiveEx(not l_talentGroupInfo.isStudied and not l_isLocked)
        self.panel.TalentUpgradeBtn:SetActiveEx(l_talentGroupInfo.isStudied and self.selectedTalentInfo.tableInfo.Sign == 0 and l_isSelected)
        self.panel.TalentStrengthenBtn:SetActiveEx(self.selectedTalentInfo.tableInfo.Sign == 1 and l_isSelected)

        self.panel.TalentTime:SetActiveEx(l_isStrengthen and l_isSelected)

        self.panel.TalentCost:SetActiveEx(not (l_talentGroupInfo.isStudied and not l_isSelected) and not l_isStrengthen and not l_isLocked)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.TalentCost.RectTransform)
        local l_talentPointCost = self:GetCurTalentCost()
        self.panel.TalentCostText.LabText = l_talentPointCost

        --强化特效
        if l_isStrengthen and l_isSelected then
            self:PlayTalentStrengthenEffect()
        else
            self:DestroyTalentStrengthenEffect()
        end
    else
        self.panel.TalentDetail:SetActiveEx(false)
        self.panel.NoTalent:SetActiveEx(true)
    end
end

--获取当前天赋消耗
function MercenaryCtrl:GetCurTalentCost()
    local l_talentPointCost = 0
    local l_mercenaryInfo = self.selectedMercenaryCellTemplate.mercenaryInfo
    if l_mercenaryInfo and self.selectedTalentInfo then
        local l_talentGroupInfo = l_mercenaryInfo.talentGroupInfo[self.selectedTalentInfo.lockLevel]
        local l_talentTableInfoForCost = self.selectedTalentInfo.tableInfo
        if l_talentGroupInfo.isStudied and self.selectedTalentInfo.tableInfo.Sign ~= 2 then
            l_talentTableInfoForCost = TableUtil.GetMercenaryTalentTable().GetRowByID(self.selectedTalentInfo.tableInfo.ID + 1)
        end
        if l_talentTableInfoForCost then
            for i = 0, l_talentTableInfoForCost.Cost.Length - 1 do
                if l_talentTableInfoForCost.Cost[i][0] == self.mercenaryMgr.TalentItemId then
                    l_talentPointCost = l_talentTableInfoForCost.Cost[i][1]
                    break
                end
            end
        end
    end
    return l_talentPointCost
end

--刷新佣兵列表
function MercenaryCtrl:RefreshMercenaryList()
    local l_oldSelectedMercenaryId = nil
    if self.selectedMercenaryCellTemplate then
        l_oldSelectedMercenaryId = self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id
        self.selectedMercenaryCellTemplate:SetSelected(false)
    end

    local l_inFightInfoSorted = {}
    local l_outFightInfoSorted = {}

    for _, v in pairs(self.mercenaryMgr.GetAllMercenaryInfo()) do
        if v.outTime ~= 0 then
            table.insert(l_inFightInfoSorted, v)
        else
            table.insert(l_outFightInfoSorted, v)
        end
    end
    table.sort(l_inFightInfoSorted, function(a, b)
        return a.outTime < b.outTime
    end)
    table.sort(l_outFightInfoSorted, function(a, b)
        if a.isRecruited and not b.isRecruited then
            return true
        end
        if not a.isRecruited and b.isRecruited then
            return false
        end
        if a.level == b.level then
            return a.tableInfo.SortID < b.tableInfo.SortID
        else
            return a.level > b.level
        end
    end)

    local l_inFightData = {}
    for _, v in ipairs(l_inFightInfoSorted) do
        table.insert(l_inFightData, { mercenaryInfo = v, parentCtrl = self })
    end
    local l_mercenaryFightGrids = MgrMgr:GetMgr("MercenaryMgr").mMercenaryFightGrids
    for i = #l_inFightInfoSorted + 1, #l_mercenaryFightGrids do
        table.insert(l_inFightData, { isLocked = l_mercenaryFightGrids[i].isLocked, lockTask = l_mercenaryFightGrids[i].lockTask, isUnOpen = l_mercenaryFightGrids[i].isUnOpen })
    end
    if not self.inFightTemplates then
        self.inFightTemplates = {}
        for i = 1, 3 do
            self.inFightTemplates[i] = self:NewTemplate("MercenaryCellTemplate", {
                TemplatePrefab = self.panel.MercenaryCell.LuaUIGroup.gameObject,
                TemplateParent = self.panel.InFightPos[i].transform,
            })
        end
    end
    for i = 1, 3 do
        if l_inFightData[i] then
            self.inFightTemplates[i]:SetData(l_inFightData[i])
        end
    end

    local l_outFightData = {}
    for _, v in ipairs(l_outFightInfoSorted) do
        table.insert(l_outFightData, { mercenaryInfo = v, parentCtrl = self })
    end
    if not self.outFightTemplatePool then
        self.outFightTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.MercenaryCellTemplate,
            TemplatePrefab = self.panel.MercenaryCell.LuaUIGroup.gameObject,
            TemplateParent = self.panel.OutFightContent.gameObject.transform,
        })
    end
    self.outFightTemplatePool:ShowTemplates({ Datas = l_outFightData })

    self:SelectMercenary(l_oldSelectedMercenaryId)
end

--获取当前选中佣兵id
function MercenaryCtrl:GetSelectedMercenaryId()
    if self.selectedMercenaryCellTemplate then
        return self.selectedMercenaryCellTemplate.mercenaryInfo.tableInfo.Id
    end
    return 0
end

--选中佣兵
function MercenaryCtrl:SelectMercenary(mercenaryId)
    if self.selectedMercenaryCellTemplate then
        self.selectedMercenaryCellTemplate:SetSelected(false)
    end
    local l_findFunc = function(template)
        if not template.mercenaryInfo then
            return false
        end
        if not mercenaryId then
            return template.mercenaryInfo ~= nil
        end
        return math.modf(template.mercenaryInfo.tableInfo.Id / 10) == math.modf(mercenaryId / 10)
    end
    local l_inFound = nil
    for _, v in ipairs(self.inFightTemplates) do
        if l_findFunc(v) then
            l_inFound = v
            break
        end
    end
    local l_outFound = self.outFightTemplatePool:FindShowTem(l_findFunc)
    if l_inFound then
        self.selectedMercenaryCellTemplate = l_inFound
    elseif l_outFound then
        self.selectedMercenaryCellTemplate = l_outFound
    end
    if self.selectedMercenaryCellTemplate then
        self.selectedMercenaryCellTemplate:SetSelected(true)
    end

    self:RefreshPanel()
end

function MercenaryCtrl:OnMercenaryCellClicked(mercenaryCellTemplate)
    if self.selectedMercenaryCellTemplate == mercenaryCellTemplate then
        return
    end
    if self.selectedMercenaryCellTemplate then
        self.selectedMercenaryCellTemplate:SetSelected(false)
    end
    self.selectedMercenaryCellTemplate = mercenaryCellTemplate
    self.selectedMercenaryCellTemplate:SetSelected(true)
    if not self.selectedMercenaryCellTemplate.mercenaryInfo.isRecruited then
        if not self.panel.AttributeTog.TogEx.isOn then
            self.panel.AttributeTog.TogEx.isOn = true
        end
    end
    self:RefreshPanel()
end

--装备升级特效
function MercenaryCtrl:PlayEquipUpgradeEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.EquipEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1,1,1)
    if self.equipUpgradeEffectId then
        self:DestroyUIEffect(self.equipUpgradeEffectId)
    end
    self.equipUpgradeEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_XuanZhongXiaoGuo_01", l_fxData)

end

--天赋升级特效
function MercenaryCtrl:PlayTalentUpgradeEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.TalentEffect.RawImg
    l_fxData.scaleFac = Vector3.New(2.5, 2.5, 2.5)
    if self.talentUpgradeEffectId then
        self:DestroyUIEffect(self.talentUpgradeEffectId)
    end
    self.talentUpgradeEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuTiPaiDui_XuanZhongXiaoGuo_01", l_fxData)

end

--天赋强化特效
function MercenaryCtrl:PlayTalentStrengthenEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.TalentEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1.2, 1.2, 1.2)
    --和天赋升级公用一个id
    if self.talentUpgradeEffectId then
        self:DestroyUIEffect(self.talentUpgradeEffectId)
    end
    self.talentUpgradeEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_TianFuQiangHua_01", l_fxData)

end

function MercenaryCtrl:DestroyTalentStrengthenEffect()
    if self.talentUpgradeEffectId then
        self:DestroyUIEffect(self.talentUpgradeEffectId)
        self.talentUpgradeEffectId = nil
    end
end

--佣兵升级特效
function MercenaryCtrl:PlayLevelUpEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.LevelUpEffect.RawImg
    l_fxData.scaleFac = Vector3.New(2.5, 2.5, 2.5)
    if self.levelUpEffectId then
        self:DestroyUIEffect(self.levelUpEffectId)
    end
    self.levelUpEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_ShengJi_01", l_fxData)

end

--装备升阶特效
function MercenaryCtrl:PlayEquipAdvanceEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.EquipAdvanceEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    if self.equipAdvanceEffectId then
        self:DestroyUIEffect(self.equipAdvanceEffectId)
    end
    self.equipAdvanceEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_JinJieChengGong_01", l_fxData)

end

function MercenaryCtrl:DestroyEffect()
    if self.equipUpgradeEffectId then
        self:DestroyUIEffect(self.equipUpgradeEffectId)
        self.equipUpgradeEffectId = nil
    end
    if self.talentUpgradeEffectId then
        self:DestroyUIEffect(self.talentUpgradeEffectId)
        self.talentUpgradeEffectId = nil
    end
    if self.levelUpEffectId then
        self:DestroyUIEffect(self.levelUpEffectId)
        self.levelUpEffectId = nil
    end
    if self.equipAdvanceEffectId then
        self:DestroyUIEffect(self.equipAdvanceEffectId)
        self.equipAdvanceEffectId = nil
    end
end


--lua custom scripts end
return MercenaryCtrl