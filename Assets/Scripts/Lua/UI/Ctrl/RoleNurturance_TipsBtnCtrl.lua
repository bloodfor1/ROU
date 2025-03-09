--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RoleNurturance_TipsBtnPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
RoleNurturance_TipsBtnCtrl = class("RoleNurturance_TipsBtnCtrl", super)
--lua class define end

--lua functions
function RoleNurturance_TipsBtnCtrl:ctor()

    super.ctor(self, CtrlNames.RoleNurturance_TipsBtn, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function RoleNurturance_TipsBtnCtrl:Init()

    self.panel = UI.RoleNurturance_TipsBtnPanel.Bind(self)
    super.Init(self)
    self.EffectId = nil
    self.CdTime = 0
    self.StartTime = 0
    self.panel.Btn_Nurturance:AddClick(function()
        DataMgr:GetData("RoleNurturanceData").SetFirstFlag(false)
        self.panel.NurturanceEffect:SetActiveEx(false)
        ---@type NurturanceRowData[]
        local NurturanceRowsInfo = MgrMgr:GetMgr("RoleNurturanceMgr").RefreshData(nil, true)
        local l_name = {}
        local l_callBack = {}
        local l_systems = {}
        local count = MGlobalConfig:GetSequenceOrVectorInt("RecommendWay")[DataMgr:GetData("RoleNurturanceData").GetTypeIndex()]
        local RecommendCondition = MGlobalConfig:GetVectorSequence("DevelopRecommendCondition")
        local index = DataMgr:GetData("RoleNurturanceData").GetTypeIndex()
        local indexTable = {}
        if index == 0 then
            indexTable = DataMgr:GetData("RoleNurturanceData").GetRoleNurturanceIndex()
        else
            indexTable = DataMgr:GetData("RoleNurturanceData").GetDeathGuide()
        end
        local RecommendConditionPre = tonumber(RecommendCondition[index][1] / 10000)
        for i = 1, count do
            local l_data = {}
            if #NurturanceRowsInfo < i then
                return
            end
            if i > #indexTable then
                break
            end
            table.insert(l_name, NurturanceRowsInfo[indexTable[i]].RowInfo.GuideName)
            table.insert(l_systems, NurturanceRowsInfo[indexTable[i]].RowInfo.SystemId)
            table.insert(l_callBack, function()
                Common.CommonUIFunc.InvokeFunctionByFuncId(NurturanceRowsInfo[indexTable[i]].RowInfo.SystemId)
                MgrMgr:GetMgr("RoleNurturanceMgr").ClickSystemTlog(2, l_systems, NurturanceRowsInfo[indexTable[i]].RowInfo.SystemId)
            end)
        end
        MgrMgr:GetMgr("RoleNurturanceMgr").ClickSystemTlog(1, l_systems)
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = l_name,
            callbackTb = l_callBack,
            dataopenPos = Vector2.New(264, -130),
            dataAnchorMaxPos = Vector2.New(0, 1),
            dataAnchorMinPos = Vector2.New(0, 1)
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end)


    -- 祈福经验
    self:_openExpButton()
    --self.panel.Btn_Exp:SetActiveEx(MPlayerInfo.Lv >= MGlobalConfig:GetInt("PrayExpLimitLevel"))
    self.panel.Btn_Exp:AddClick(function()
        local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
        l_onceSystemMgr.SetOnceState(l_onceSystemMgr.EClientOnceType.BlessBtnClicked, nil, true)
        self:RefreshBlessInfo()
        MgrMgr:GetMgr("BattleStatisticsMgr").OpenBlessedExperiencePanel()
        --UIMgr:ActiveUI(UI.CtrlNames.BlessedExperience_Panel)
    end)

    ---- 养成推荐特效
    --self.nurturanceEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Btn_Nurturance_01", {
    --    rawImage = self.panel.NurturanceEffect.RawImg,
    --    scaleFac = Vector3.New(2.82, 2.82, 2.82)
    --})
    ---- 祈福经验特效
    --self.blessEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_QuZhu_01", {
    --    rawImage = self.panel.ExpEffect.RawImg,
    --    scaleFac = Vector3.New(1.2, 1.2, 1.2),
    --    loadedCallback = function()
    --        self:RefreshBlessInfo()
    --    end
    --})
    ---- 祈福经验引导特效
    --self.blessFirstEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Btn_Nurturance_01", {
    --    rawImage = self.panel.ExpFirstEffect.RawImg,
    --    scaleFac = Vector3.New(2.82, 2.82, 2.82),
    --    loadedCallback = function()
    --        self:RefreshBlessInfo()
    --    end
    --})

    self:RefreshBlessInfo()
end --func end
--next--
function RoleNurturance_TipsBtnCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RoleNurturance_TipsBtnCtrl:OnActive()
    if DataMgr:GetData("RoleNurturanceData").IsNutranceOpen then
        self:ActiveNurturanceBtn()
        DataMgr:GetData("RoleNurturanceData").IsNutranceOpen = false
    end
end --func end
--next--
function RoleNurturance_TipsBtnCtrl:OnDeActive()

end --func end
--next--
function RoleNurturance_TipsBtnCtrl:Update()
    if self.StartTime ~= 0 and Common.TimeMgr.GetNowTimestamp() - self.StartTime >= self.CdTime then
        self:DeActiveNurturanceBtn()
    end
end --func end
--next--
function RoleNurturance_TipsBtnCtrl:OnShow()
    self:RefreshRoleNurturanceBtn()
end --func end
--next--
function RoleNurturance_TipsBtnCtrl:OnHide()

end --func end
--next--
function RoleNurturance_TipsBtnCtrl:BindEvents()
    local roleNurturanceMgr = MgrMgr:GetMgr("RoleNurturanceMgr")
    self:BindEvent(roleNurturanceMgr.EventDispatcher, roleNurturanceMgr.OnRefreshDataEvent, self.RefreshRoleNurturanceBtn)
    self:BindEvent(Data.PlayerInfoModel.BASELV, Data.onDataChange, function()
        -- 祈福经验
        self:_openExpButton()
    end)

    local l_gameEventMgr = MgrProxy:GetGameEventMgr()
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnBlessExpChanged, function()
        self:RefreshBlessInfo()
    end)
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnExtraFightTimeChanged, function()
        self:RefreshBlessInfo()
    end)

    local l_autoFightItemMgr = MgrMgr:GetMgr("AutoFightItemMgr")
    self:BindEvent(l_autoFightItemMgr.EventDispatcher, l_autoFightItemMgr.EventType.GuaJiJiaSuRefresh, function()
        self:RefreshBlessInfo()
    end)

    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openSysMgr.EventDispatcher,l_openSysMgr.OpenSystemUpdate, self._openExpButton)
end --func end
--next--
--lua functions end

--lua custom scripts
function RoleNurturance_TipsBtnCtrl:_openExpButton()
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.BlessedExperience) then
        self.panel.Btn_Exp:SetActiveEx(false)
        return
    end
    self.panel.Btn_Exp:SetActiveEx(MPlayerInfo.Lv >= MGlobalConfig:GetInt("PrayExpLimitLevel"))
end

function RoleNurturance_TipsBtnCtrl:ActiveNurturanceBtn()
    self.panel.Btn_Nurturance:SetActiveEx(true)
    self.StartTime = PlayerPrefs.GetInt("NurturanceBtnTimeStamp")
    self.CdTime = MGlobalConfig:GetSequenceOrVectorInt("DisappearTime")[DataMgr:GetData("RoleNurturanceData").GetTypeIndex()]
    self.panel.NurturanceEffect:SetActiveEx(DataMgr:GetData("RoleNurturanceData").GetFirstFlag())
end

function RoleNurturance_TipsBtnCtrl:DeActiveNurturanceBtn()
    self.panel.Btn_Nurturance:SetActiveEx(false)
    DataMgr:GetData("RoleNurturanceData").IsActiveByDeath = false
    PlayerPrefs.SetInt("NurturanceBtnTimeStamp", 0)
end

function RoleNurturance_TipsBtnCtrl:GetExpBtnPosition()
    return self.panel.Btn_Exp.transform.position
end

function RoleNurturance_TipsBtnCtrl:RefreshBlessInfo()
    local l_state, l_stateText, l_timeText = MgrMgr:GetMgr("BattleStatisticsMgr").GetBattleStateByTime(MPlayerInfo.ExtraFightTime / (60 * 1000))
    self.panel.Healthy:SetActiveEx(l_state == GameEnum.EBattleHealthy.Healthy)
    self.panel.Tiredout:SetActiveEx(l_state ~= GameEnum.EBattleHealthy.Healthy)

    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    local l_isClicked = l_onceSystemMgr.GetOnceState(l_onceSystemMgr.EClientOnceType.BlessBtnClicked)
    self.panel.ExpEffect:SetActiveEx(MPlayerInfo.BlessExp > 0 and l_isClicked)
    self.panel.ExpFirstEffect:SetActiveEx(not l_isClicked)

    -- 加速buff
    local l_factor = MgrMgr:GetMgr("AutoFightItemMgr").GetJiaJiJiaSuFactor()
    self.panel.Factor:SetActiveEx(l_factor ~= 0)
    self.panel.FactorText.LabText = l_factor
end

function RoleNurturance_TipsBtnCtrl:RefreshRoleNurturanceBtn()
    local l_data = DataMgr:GetData("RoleNurturanceData")
    local l_mgr = MgrMgr:GetMgr("RoleNurturanceMgr")
    l_mgr.RefreshData(l_data.GetNurturanceType(), true)
    if l_data.BtnActive then
        if not TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).IsStaticScene then
            self:DeActiveNurturanceBtn()
            return
        end
        self:ActiveNurturanceBtn()
    else
        self:DeActiveNurturanceBtn()
    end
end

--lua custom scripts end
return RoleNurturance_TipsBtnCtrl