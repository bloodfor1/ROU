--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"

require "UI/Panel/SkillPointTipPanel"

--lua requires end

--lua model
module("UI", package.seeall)

local SKILL_BUTTON_SETTING = 2
local fixedTimeColor = RoColorTag.Green
local varTimeColor = RoColorTag.Yellow
local conditionSuccColor = RoColorTag.Green
local conditionFailColor = RoColorTag.Red
local currentState
local skillInfo
local SkillType =
{
    [0] = Common.Utils.Lang("SKILL_PHYSICS"), --"物理"
    [1] = Common.Utils.Lang("SKILL_MAGIC"),   --"法术"
    [2] = Common.Utils.Lang("SKILL_SUPPORT"), --"支援"
    [3] = Common.Utils.Lang("SKILL_PASSIVE"), --"被动"
}
local SCROLL_CONTENT_MAX_SIZE = 350
local SKILL_POINT_SIZE = 500
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SkillPointTipCtrl = class("SkillPointTipCtrl", super)
--lua class define end

--lua functions
function SkillPointTipCtrl:ctor()

    super.ctor(self, CtrlNames.SkillPointTip, UILayer.Tips, nil, ActiveType.Standalone)

    self.IsCloseOnSwitchScene = true
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.SkillPointTip

end --func end
--next--
function SkillPointTipCtrl:Init()

    self.panel = UI.SkillPointTipPanel.Bind(self)
    super.Init(self)
    self.data = DataMgr:GetData("SkillData")
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    currentState = self.data.SkillTipState.INACTIVE_STATE

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    UIMgr:DeActiveUI(self.name)
    --end)

end --func end
--next--
function SkillPointTipCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SkillPointTipCtrl:OnActive()

    if not self.panel then return end

    self.panel.TogAttackWhenSelect.Tog.isOn = MPlayerSetting.IfAttckWhenSelect
    self.panel.TogAttackWhenSelect:OnToggleChanged(function(on)
        MPlayerSetting.IfAttckWhenSelect = on
    end)
    self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.SetSkillTip then
            self:SetSkillTip(self.uiPanelData.id, self.uiPanelData.isBuff, self.uiPanelData.pos, self.uiPanelData.currentPanel)
        end
        if self.uiPanelData.openType == self.data.OpenType.DropSkillTip then
            self:DropSkillTip(self.uiPanelData.lv, self.uiPanelData.idx, self.uiPanelData.skillId, self.uiPanelData.toIdx)
        end
        if self.uiPanelData.openType == self.data.OpenType.ShowSkillTip then
            self:ShowSkillTip(self.uiPanelData.lv, self.uiPanelData.obj, self.uiPanelData.id, self.uiPanelData.alpha)
        end
    end

end --func end
--next--
function SkillPointTipCtrl:OnDeActive()

    self.autoAdd = false
    self.autoSub = false

end --func end
--next--
function SkillPointTipCtrl:Update()

    if self.autoAdd then
        self.autoAddTime = self.autoAddTime + 1
        if self.autoAddTime % 10 == 0 then
            local maxLv = MPlayerInfo:GetCurrentSkillInfo(self:GetSkillInfo().id).lv
            local currentLv = self.data.GetChooseLv()
            if currentLv + 1 <= maxLv then
                self.data.SetChooseLv(currentLv + 1)
                self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())
            else
                self.autoAdd = false
                self.autoAddTime = 0
            end
        end
    end

    if self.autoSub then
        self.autoSubTime = self.autoSubTime + 1
        if self.autoSubTime % 10 == 0 then
            local currentLv = self.data.GetChooseLv()
            if currentLv - 1 > 0 then
                self.data.SetChooseLv(currentLv - 1)
                self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())
            else
                self.autoSub = false
                self.autoSubTime = 0
            end
        end
    end

end --func end
--next--
function SkillPointTipCtrl:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_SKILL_INFO_UPDATE, self.OnSkillInfoUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
function SkillPointTipCtrl:DropSkillTip(lv, idx, skillId, toIdx)

    self.uObj:SetActiveEx(false)
    self.data.SetChooseLv(lv)
    self:InitWithSkillId(skillId, self.data.SkillTipState.SELECT_LV_STATE,
    function()
        lv = self.data.GetChooseLv()
        UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
        local l_ui = UIMgr:GetUI(UI.CtrlNames.SkillLearning)
        if l_ui then
            l_ui:DropSkillInSlot(idx, toIdx, skillId, lv)
        end
    end,
    function()
        UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    end, false, lv)
    self.uObj:SetActiveEx(true)
    self:AutoSize()

end

function SkillPointTipCtrl:ShowSkillTip(lv, obj, id, alpha)

    if id and id == 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
        return
    end
    
    self.uObj:SetActiveEx(false)
    if id == self.data.SkillQueueId then
        self:InitWithSkillId(tonumber(id), self.data.SkillTipState.SPECIAL_SKILL, nil, nil, false)
    else
        self:InitWithSkillId(tonumber(id), self.data.SkillTipState.SELECT_SHOW_SLOT, nil, nil, false, lv)
    end
    self.uObj:SetActiveEx(true)
    self.panel.SkillPointTipPanel.gameObject:GetComponent("Image").color = Color.New(1, 1, 1, alpha)
    self:AutoSize()
    local width = self:GetLayoutSize().x
    local height = self:GetHeight()
    local canDrop, delta, anchor = Common.Utils.GetUIProperPosInScreen(width, height, obj.transform.position)
    if canDrop then
        self:SetProperPos(obj, delta, anchor)
    end

end

function SkillPointTipCtrl:SetSkillTip(id, isBuff, pos, currentPanel)

    local l_skillInfo = self.uiPanelData.skillInfo
    if not self.isActive then return end
    self.uObj:SetActiveEx(false)
    local isActive = self.data.IsSkillActive(l_skillInfo)
    local l_isCanNotLearn = not self.data.NeedSkillPointToLearn(id)
    local l_skillId = l_skillInfo.Id
    local l_addedSkillPoint = self.data.GetAddedSkillPoint(l_skillId)
    if isBuff then
        isActive = true
    end
    if currentPanel ~= SKILL_BUTTON_SETTING then
        if id == self.data.SkillQueueId then
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.SPECIAL_SKILL, nil, nil, false)
        elseif self.isBuff then
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.BUFF_SKILL, nil, nil, false)
        elseif isActive ~= true then
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.INACTIVE_STATE, nil, nil, l_isCanNotLearn)
        elseif self.data.IsLvMax(l_skillInfo) then
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.MAX_LV_STATE, nil, nil, l_isCanNotLearn, l_addedSkillPoint)
        elseif l_addedSkillPoint == 0 then
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.ACTIVE_ZERO_LV_STATE, nil, nil, l_isCanNotLearn, l_addedSkillPoint)
        else
            self:InitWithSkillId(l_skillId, self.data.SkillTipState.ACTIVE_STATE, nil, nil, l_isCanNotLearn, l_addedSkillPoint)
        end
    else
        self:InitWithSkillId(l_skillInfo.Id, self.data.SkillTipState.SELECT_SHOW_SLOT, nil, nil, l_isCanNotLearn)
    end
    pos = pos or Common.Functions.SequenceToTable(l_skillInfo.SkillPanelPos)
    if pos[2] < 3 then
        self.uObj:SetLocalPos(-202 + 162 * pos[2], 0, 0)
    else
        self.uObj:SetLocalPos(134 - 162 * (5 - pos[2]), 0, 0)
    end
    self.uObj:SetActiveEx(true)
    self:AutoSize()

end

--使用技能Id进行初始化
function SkillPointTipCtrl:InitWithSkillId(skillId, state, onConfirm, onCancel, isfixed, customLv)

    if self.panel == nil or skillId == nil then
        return
    end
    currentState = state
    if state == self.data.SkillTipState.SPECIAL_SKILL then
        self:InitQueneState()
    else
        skillInfo = self:GetSkillInfoTable(skillId, customLv)
        if state == self.data.SkillTipState.SELECT_SHOW_SLOT then
            self:InitShowSlotState(skillInfo)
        else
            if isfixed then
                self:InitFixedSkillState(skillInfo)
            else
                if state == self.data.SkillTipState.BUFF_SKILL then
                    self:InitBuffState(skillInfo)
                elseif state == self.data.SkillTipState.INACTIVE_STATE then
                    self:InitInactiveState(skillInfo)
                elseif state == self.data.SkillTipState.ACTIVE_ZERO_LV_STATE
                        or state == self.data.SkillTipState.ACTIVE_STATE
                        or state == self.data.SkillTipState.MAX_LV_STATE then
                    if customLv == 0 then
                        self:InitZeroLevelState(skillInfo)
                    elseif skillInfo.isMax then
                        self:InitMaxLevelState(skillInfo)
                    else
                        self:InitActiveState(skillInfo)
                    end
                elseif state == self.data.SkillTipState.SELECT_LV_STATE then
                    self:InitSelectLevelState(skillInfo, onConfirm, onCancel, customLv)
                end
            end
        end
        if MEntityMgr.PlayerEntity and MPlayerInfo:GetRootSkillId(MEntityMgr.PlayerEntity.AttrRole.CommonAttackSkillID) == skillId then
            self.panel.AttackWhenSelectPanel.gameObject:SetActiveEx(true)
        else
            self.panel.AttackWhenSelectPanel.gameObject:SetActiveEx(false)
        end
        local isEmpty = IsEmptyOrNil(skillInfo.detail.SkillDescAdd)
        self.panel.skillSpecialDes:SetActiveEx(not isEmpty)
        if not isEmpty then
            self.panel.skillSpecialDes.LabText = skillInfo.detail.SkillDescAdd
        end
        self:ShowSkillFuncIdBySkillInfo(skillId, skillInfo, customLv, state)
    end

end

--显示技能的FuncId面板
function SkillPointTipCtrl:ShowSkillFuncIdBySkillInfo(skillId, skillTableInfo, customLv, state)

    self.panel.SkillFuncId.gameObject:SetActiveEx(false)

    --配置判定
    if skillTableInfo == nil then
        logError("SkillTableData is Nil Id = "..skillId)
        return
    end

    --等级判定
    if customLv == 0 then
        --return
    end

    --技能状态判定
    if state == self.data.SkillTipState.INACTIVE_STATE then
        --return
    end

    local SkillTipsLinkData = self.data.GetDataFromTable("SkillTipsLinkTable", skillId, true)
    if SkillTipsLinkData then
        self.panel.SkillFuncId.gameObject:SetActiveEx(true)
        self.panel.SkillFuncLabel.LabText = SkillTipsLinkData.Name
        self.panel.SkillFuncId:AddClick(function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(SkillTipsLinkData.FunctionId, nil, true)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end

end

function SkillPointTipCtrl:GetSkillInfoTable(skillId, customLv)

    return self.data.GetTipSkillInfo(skillId, customLv)

end

function SkillPointTipCtrl:InitBuffState(skillInfo)

    self:InitZeroLevelState(skillInfo)

end

--初始化未激活的状态
function SkillPointTipCtrl:InitInactiveState(skillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    --关闭下一级描述
    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    --需要的条件
    self.panel.txtRequireLabel:SetActiveEx(true)
    self:SetRequireTip(self:GetSkillRequireText(skillInfo))

    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

end

--初始化激活状态
function SkillPointTipCtrl:InitActiveState(skillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(true)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(true)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(true)
    self.panel.txtRequireLabel:SetActiveEx(false)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

    self:InitNextSkill(skillInfo)

end

--初始化零级状态
function SkillPointTipCtrl:InitZeroLevelState(skillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)
    self.panel.txtSkillIntroduce.gameObject:SetActiveEx(true)
    self.panel.txtCurrentDetailInfo.gameObject:SetActiveEx(true)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    self.panel.txtRequireLabel:SetActiveEx(false)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

end

--初始化满级状态
function SkillPointTipCtrl:InitMaxLevelState(skillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    self.panel.txtRequireLabel:SetActiveEx(true)

    local str = GetColorText(Lang("SKILL_POINT_TIP_MAX_LEVEL"), RoColorTag.Gray)
    self:SetRequireTip(str)

    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

end

--初始化选择等级状态
function SkillPointTipCtrl:InitSelectLevelState(skillInfo, onConfirm, onCancel, customLv)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    self.panel.txtRequireLabel:SetActiveEx(false)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(true)
    self.panel.btnClosePanel.gameObject:SetActiveEx(true)

    local playerSkillLv = customLv or MPlayerInfo:GetCurrentSkillInfo(skillInfo.id).lv
    self.data.SetChooseLv(playerSkillLv)
    self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())

    self.panel.btnAddLevel:AddClick(function()
        local maxLv = MPlayerInfo:GetCurrentSkillInfo(skillInfo.id).lv
        local currentLv = self.data.GetChooseLv()
        if currentLv < maxLv then
            self.data.SetChooseLv(currentLv + 1)
            self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())
        end

        local newSkillInfo = self:GetSkillInfoTable(skillInfo.id, self.data.GetChooseLv())
        self:InitTop(newSkillInfo)
        self:InitCrrentSkill(newSkillInfo)
        self.panel.txtCurrentLV.LabText = "Lv."..tostring(newSkillInfo.lv)
    end)
    self.panel.btnSubtractionLevel:AddClick(function()
        local currentLv = self.data.GetChooseLv()
        if currentLv > 1 then
            self.data.SetChooseLv(currentLv - 1)
            self.panel.txtCurrentLV.LabText = "Lv."..tostring(self.data.GetChooseLv())
        end

        local newSkillInfo = self:GetSkillInfoTable(skillInfo.id, self.data.GetChooseLv())
        self:InitTop(newSkillInfo)
        self:InitCrrentSkill(newSkillInfo)
        self.panel.txtCurrentLV.LabText = "Lv."..tostring(newSkillInfo.lv)
    end)
    self.panel.txtCurrentLV.LabText = "Lv."..tostring(playerSkillLv)

    self.panel.btnAddLevel.Listener.onDown = function()
        self.autoSub = false
        self.autoAdd = true
        self.autoAddTime = 0
    end
    self.panel.btnSubtractionLevel.Listener.onDown = function()
        self.autoAdd = false
        self.autoSub = true
        self.autoSubTime = 0
    end

    self.panel.btnAddLevel.Listener.onUp = function()
        self.autoAdd = false
    end
    self.panel.btnSubtractionLevel.Listener.onUp = function()
        self.autoSub = false
    end

    self.panel.BtnConfirm:AddClick(onConfirm)
    self.panel.BtnCancel:AddClick(onCancel)

    --新手指引相关
    local l_beginnerGuideChecks = {"SkillLevel"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

end

function SkillPointTipCtrl:InitFixedSkillState(SkillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    self.panel.txtRequireLabel:SetActiveEx(true)
    local l_condition = self:GetSkillRequireText(skillInfo)
    if string.ro_isEmpty(l_condition) then
        l_condition = Lang("SKILL_POINT_TIP_CANNOT_LEVEL_UP")
    else
        l_condition = StringEx.Format("{0}\n{1}", l_condition, Lang("SKILL_POINT_TIP_CANNOT_LEVEL_UP"))
    end
    local str = GetColorText(l_condition, RoColorTag.Red)
    self:SetRequireTip(str)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

end

function SkillPointTipCtrl:SetRequireTip(content)

    local lines = string.ro_split(content, '\n')
    self.panel.txtRequireLabel.LabText = content
    --local size = self.panel.txtRequireLabel.RectTransform.sizeDelta
    self.panel.txtRequireLabel.LayoutEle.preferredHeight = 30 * #lines

end

--初始化Slot状态
function SkillPointTipCtrl:InitShowSlotState(skillInfo)

    self:InitTop(skillInfo)
    self:InitCrrentSkill(skillInfo)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)

    self.panel.txtRequireLabel:SetActiveEx(false)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

end

function SkillPointTipCtrl:InitTop(skillInfo)

    local detail = skillInfo.detail
    --名称
    self.panel.txtSkillName.LabText = detail.Name .. " Lv." .. skillInfo.lv
    --Icon
    self.panel.imgSkillIcon:SetSpriteAsync(detail.Atlas, detail.Icon)
    --第一个属性
    self.panel.txtSkillTypeName.LabText = SkillType[skillInfo.detail.SkillTypeIcon]
    --第二个属性
    if detail.SkillTypeIcon == 3 then
        self.panel.imgSkillAttr.gameObject:SetActiveEx(false)
        return
    end
    self.panel.imgSkillAttr.gameObject:SetActiveEx(true)
    local skillAttrId = skillInfo.detail.SkillAttr
    local skillAttr = self.data.GetDataFromTable("ElementAttr", skillAttrId)
    self.panel.txtSkillAttr.LabText = skillAttr.ColourText
    self.panel.imgSkillAttr.Img.color = RoColor.Hex2Color(RoBgColor[skillAttr.Colour])
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.txtSkillAttr, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.txtSkillTypeName, nil, Vector2.New(1, 1))

end

--初始化当前技能描述
function SkillPointTipCtrl:InitCrrentSkill(skillInfo)

    self.panel.txtSkillIntroduce.gameObject:SetActiveEx(true)
    self.panel.txtCurrentDetailInfo.gameObject:SetActiveEx(true)
    self.panel.txtSkillIntroduce.LabText = self:GetSkillIntroduce(skillInfo.detail, skillInfo.effectDetail)
    self.panel.txtCurrentDetailInfo.LabText = self:GetSkillDetail(skillInfo.detail, skillInfo.effectDetail)
    self.panel.AutoBan:SetActiveEx(false)
    local l_skillData = self.data.GetDataFromTable("SkillTable", skillInfo.id)
    if l_skillData.AITreeName == "" and (not l_skillData.IsPassive) then
        self.panel.AutoBan:SetActiveEx(true)
    end
    self.panel.txtCurrentDetailInfo:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        local str = ""
        if hrefName == "fixedSingTime" then
            str = Lang("SKILL_LEARNING_FIXTIME_TIP")
        elseif hrefName == "varSingTime" then
            str = Lang("SKILL_LEARNING_VARTIME_TIP")
        end
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(str, ed)
    end)
    self.panel.txtCurrentDetailInfo:GetRichText().onHrefUp:AddListener(function(hrefName, ed)
        MgrMgr:GetMgr("TipsMgr").HideQuestionTip()
    end)

end

--初始化下一级的技能描述
function SkillPointTipCtrl:InitNextSkill(skillInfo)

    local nextEffectDetail
    if currentState == self.data.SkillTipState.ACTIVE_ZERO_LV_STATE then
        if skillInfo.detail.SkillTypeIcon == 3 then
            nextEffectDetail = self.data.GetDataFromTable("PassivitySkillEffectTable", skillInfo.effectId)
        else
            nextEffectDetail = self.data.GetDataFromTable("SkillEffectTable", skillInfo.effectId)
        end
    else
        if skillInfo.detail.SkillTypeIcon == 3 then
            nextEffectDetail = self.data.GetDataFromTable("PassivitySkillEffectTable", skillInfo.effectId + 1)
        else
            nextEffectDetail = self.data.GetDataFromTable("SkillEffectTable", skillInfo.effectId + 1)
        end
    end
    self.panel.txtNextLvSkillIntroduce.LabText = self:GetSkillIntroduce(skillInfo.detail, nextEffectDetail)
    self.panel.txtNextDetailInfo.LabText = self:GetSkillDetail(skillInfo.detail, nextEffectDetail)
    self.panel.txtNextDetailInfo:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        local str = ""
        if hrefName == "fixedSingTime" then
            str = Lang("SKILL_LEARNING_FIXTIME_TIP")
        elseif hrefName == "varSingTime" then
            str = Lang("SKILL_LEARNING_VARTIME_TIP")
        end
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(str, ed)
    end)
    self.panel.txtNextDetailInfo:GetRichText().onHrefUp:AddListener(function(hrefName, ed)
        MgrMgr:GetMgr("TipsMgr").HideQuestionTip()
    end)

end

function SkillPointTipCtrl:GetSkillIntroduce(skillInfo, effectDetail)

    local skillDesc = skillInfo.SkillDesc
    local skillDescArgs = Common.Functions.VectorToTable(effectDetail.SkillDescRep)
    local count, maxArgIdx = 0, 0
    for v in string.gmatch(skillDesc, "{(%d+)}") do
        count = count + 1
        v = tonumber(v)
        if v > maxArgIdx then maxArgIdx = v end
    end
    if #skillDescArgs < count then
        logYellow(StringEx.Format("技能描述匹配参数与描述字符串需要参数数量不一致, 请相关策划检查 skillId = {0} skillEffectId = {1}", tostring(skillInfo.Id), tostring(effectDetail.Id)))
        return skillDesc or ""
    elseif #skillDescArgs > 0 and (#skillDescArgs - 1 ~= maxArgIdx) then
        logYellow(StringEx.Format("技能描述匹配参数与描述字符串下标匹配不上, 注意c#下标从0开始, 请相关策划检查 skillId = {0} skillEffectId = {1}", tostring(skillInfo.Id), tostring(effectDetail.Id)))
        return skillDesc or ""
    end
    if skillDesc ~= nil and skillDescArgs ~= nil then
        local resultErrorCode, _ = pcall(function()
            skillDesc = StringEx.Format(skillDesc, skillDescArgs)
        end)
        if resultErrorCode == false then
            logError(StringEx.Format([[技能描述匹配参数与描述字符串无法匹配, 请检查 skillId = {0}
            skillEffectId = {1}, desc = {2}]], tostring(skillInfo.id), tostring(effectDetail.Id), skillDesc))
            logError(ToString(skillDescArgs))
        end
    end
    return skillDesc

end

--获得技能细节
function SkillPointTipCtrl:GetSkillDetail(skillInfo, effectDetail)

    local result = ""
    if skillInfo.SkillTypeIcon == 3 then
        --被动技能不存在相关描述
        result = result..""
    else
        --主动技能
        local fixedSingTime, varSingTime, groupCd = Fight.FightAttr.GetSingingTimeByAttr(effectDetail)
        local cdTime = effectDetail.PVECoolTime--冷却时间
        local SceneTable = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
        if SceneTable ~= nil and SceneTable.SceneType == 5 then
            cdTime = effectDetail.PVPCoolTime
        end
        local singTime = tonumber(StringEx.Format("{0:F2}", fixedSingTime))
                + tonumber(StringEx.Format("{0:F2}", varSingTime))
        local spSpend = 0
        local hpSpend = 0
        if effectDetail.SkillCost:get_Item(0) == AttrType.ATTR_BASIC_SP then
            spSpend = effectDetail.SkillCost:get_Item(1)--消耗sp
        elseif effectDetail.SkillCost:get_Item(0) == AttrType.ATTR_BASIC_HP then
            hpSpend = effectDetail.SkillCost:get_Item(1)--消耗sp
        end

        local costDesc = string.ro_trim(effectDetail.CostDesc)--特殊消耗

        if singTime - 0.01 < 0 then
            result = StringEx.Format("{0}{1}: {2}\n", result, Lang("SKILLTIP_SINGING_TIME"), Lang("NONE"))
        else
            result = result..Lang("SKILLTIP_SINGING_TIME").."："..StringEx.Format("{0}", singTime)
            result = result.."s (<a href=fixedSingTime>"..GetColorText(StringEx.Format("{0:F2}s", fixedSingTime), fixedTimeColor) .. "</a>"
            result = result.."+".."<a href=varSingTime>" .. GetColorText(StringEx.Format("{0:F2}s", varSingTime), varTimeColor) .. "</a>"
            result = result..")\n"
        end

        if cdTime - 0.01 < 0 then
            result = result..Lang("SKILLTIP_COLDDOWN_TIME").."："..Lang("NONE").."\n"
        else
            result = result..Lang("SKILLTIP_COLDDOWN_TIME").."："..StringEx.Format("{0:F1}", cdTime).."s\n"
        end

        if spSpend - 0.01 < 0 then
            result = result..Lang("SKILLTIP_SP_CAST").."："..Lang("NONE").."\n"
        else
            result = result..Lang("SKILLTIP_SP_CAST").."："..spSpend.."\n"
        end

        if hpSpend - 0.01 > 0 then
            result = result..Lang("SKILLTIP_HP_CAST").."："..hpSpend.."\n"
        end

        if groupCd < 0.01 then
            result = result..Lang("SKILLTIP_GROUP_CD_CAST").."："..Lang("NONE").."\n"
        elseif skillInfo.IsAffectedASPD == 1 then
            result = result..Lang("SKILLTIP_GROUP_CD_CAST").."："..Lang("EFFECT_BY_ASPD") .. "\n" ..
                "<color=#f29c38>" .. "（" .. Lang("ASPD_DESCRIBE_TOGCD") .. "）" .. "</color>" .. "\n"
        else
            result = result..Lang("SKILLTIP_GROUP_CD_CAST").."："..StringEx.Format("{0:F1}s", groupCd).."\n"
        end

        if #costDesc > 0 then
            result = result..Lang("SKILLTIP_SPECIAL_CAST")..costDesc.."\n"
        end
        if string.sub(result, #result) == '\n' then
            result = string.sub(result, 0, #result - 1)
        end

    end
    return result

end

--获得技能的需求条件
function SkillPointTipCtrl:GetSkillRequireText(skillInfo)

    local result = ""
    local requiredPreSkill = skillInfo.detail.PreSkillRequired
    local count = requiredPreSkill.Count
    --local capacity = requiredPreSkill.Capacity
    local isPass = false

    local function _getRequireColor(ispass)
       return ispass and conditionSuccColor or conditionFailColor
    end

    -- 等级条件
    if count > 0 then
        result = ""
        local skillCount = 0
        for i = 0, count - 1 do
            local preSkillId = requiredPreSkill:get_Item(i, 0)
            local preSkillLv = requiredPreSkill:get_Item(i, 1)
            local preSkillName = self.data.GetDataFromTable("SkillTable", preSkillId).Name
            if skillCount > 0 then
                result = StringEx.Format("{0}\n", result)
            end

            local l_professionName
            local skillProfessionList = self.data.GetProfessionIdList()
            for _, id in pairs(skillProfessionList) do
                local professionRow = self.data.GetDataFromTable("ProfessionTable", id)
                local proCount = professionRow.SkillIds.Length
                for i = 0, proCount - 1 do
                    if professionRow.SkillIds[i][0] == preSkillId then
                        l_professionName = professionRow.Name
                        break
                    end
                end
            end
            isPass = MPlayerInfo:GetCurrentSkillInfo(preSkillId).lv >= preSkillLv
            result = result .. GetColorText(Lang("SKILLTIP_REQUIRED_SKILL", l_professionName, preSkillName, preSkillLv),
                _getRequireColor(isPass)).."\n"
        end
    end

    -- 前置任务
    local needTaskId = self.data.GetRequiredTask(skillInfo.detail.Id)
    local finish = MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(needTaskId)
    if not finish then
        if needTaskId then
            local requiredTask = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(needTaskId)
            if requiredTask == nil then
                result = StringEx.Format("{0}{1}\n", result, Lang("SKILLTIP_REQUIRED_TASK", "unknow task"))
            else
                local requiredTaskName = requiredTask.name
                result = StringEx.Format("{0}{1}\n", result, Lang("SKILLTIP_REQUIRED_TASK", requiredTaskName))
            end
        end
    else
        result = ""
    end

    local l_skillLearningCtrl = UIMgr:GetUI(UI.CtrlNames.SkillLearning)
    if l_skillLearningCtrl ~= nil and not self.data.IsProfessionPointFull(l_skillLearningCtrl.currentProType) then
        local l_needSkillPoint = l_skillLearningCtrl.professionRow.SkillPointRequired
        result = StringEx.Format("{0}{1}\n", result, Lang("SKILL_TIP_NEED_PROFESSION_SKILL_POINT_FULL", l_needSkillPoint))
    end
    return result

end

function SkillPointTipCtrl:GetSkillInfo()

    return skillInfo

end

----------------Tip-----------------------
----------------事件处理-------------------

function SkillPointTipCtrl:OnSkillInfoUpdate(skillId, customLv)

    skillInfo = self:GetSkillInfoTable(skillId, customLv)
    if customLv == 0 then
        currentState = self.data.SkillTipState.ACTIVE_ZERO_LV_STATE
        self:InitZeroLevelState(skillInfo)
    elseif skillInfo.isMax then
        currentState = self.data.SkillTipState.MAX_LV_STATE
        self:InitMaxLevelState(skillInfo)
    else
        currentState = self.data.SkillTipState.ACTIVE_STATE
        self:InitActiveState(skillInfo)
    end

end


function SkillPointTipCtrl:AutoSize()

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.content.RectTransform)
    local height = self.panel.content.RectTransform.sizeDelta.y
    if height >= SCROLL_CONTENT_MAX_SIZE then
        self.panel.scroll.LayoutEle.preferredHeight = SCROLL_CONTENT_MAX_SIZE
        self.panel.SkillPointTipPanel.LayoutEle.preferredHeight = SKILL_POINT_SIZE
    else
        self.panel.scroll.LayoutEle.preferredHeight = height + 10
        local height = height + 10 + SKILL_POINT_SIZE - SCROLL_CONTENT_MAX_SIZE
        if self.panel.txtRequireLabel.gameObject.activeSelf then
            height = height + self.panel.txtRequireLabel.LayoutEle.preferredHeight
        end
        if self.panel.SelectLvPanel.gameObject.activeSelf then
            height = height + self.panel.SelectLvPanel.LayoutEle.minHeight
        end
        self.panel.SkillPointTipPanel.LayoutEle.preferredHeight = height
    end

end

function SkillPointTipCtrl:GetLayoutSize()

    local ret = Vector2.zero
    if self.panel then
        ret = self.panel.Layout.RectTransform.rect.size
    end
    return ret

end

function SkillPointTipCtrl:GetHeight()

    return self.panel.SkillPointTipPanel.LayoutEle.preferredHeight

end

function SkillPointTipCtrl:SetProperPos(obj, delta, anchor)

    self.panel.Layout.RectTransform.anchorMin = anchor
    self.panel.Layout.RectTransform.anchorMax = anchor
    self.panel.Layout.RectTransform.pivot = anchor
    self.panel.Layout.UObj:SetPos(obj.transform.position.x + delta.x, obj.transform.position.y, 0)

end

--特殊技能：技能队列描述
function SkillPointTipCtrl:InitQueneState()

    local l_info = {}
    l_info.detail = self.data.GetDataFromTable("SkillTable", self.data.SkillQueueId)
    l_info.lv = 1
    self:InitTop(l_info)

    self.panel.txtSkillIntroduce.gameObject:SetActiveEx(true)
    self.panel.txtCurrentDetailInfo.gameObject:SetActiveEx(false)
    self.panel.txtSkillIntroduce.LabText = l_info.detail.SkillDesc
    self.panel.skillSpecialDes.LabText = l_info.detail.SkillDescAdd
    self.panel.AutoBan:SetActiveEx(false)

    self.panel.txtNextLvSkillTip.gameObject:SetActiveEx(false)
    self.panel.txtNextLvSkillIntroduce.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtNextDetailInfo.transform.parent.gameObject:SetActiveEx(false)
    self.panel.txtRequireLabel:SetActiveEx(true)
    local l_condition = self:GetSkillRequireText(l_info)
    if string.ro_isEmpty(l_condition) then
        l_condition = Lang("SKILL_POINT_TIP_CANNOT_LEVEL_UP")
    else
        l_condition = StringEx.Format("{0}\n{1}", l_condition, Lang("SKILL_POINT_TIP_CANNOT_LEVEL_UP"))
    end
    local str = GetColorText(l_condition, RoColorTag.Red)
    self:SetRequireTip(str)
    self.panel.SelectLvPanel.gameObject:SetActiveEx(false)

    local SkillTipsLinkData = self.data.GetDataFromTable("SkillTipsLinkTable", self.data.SkillQueueId, true)
    if SkillTipsLinkData then
        self.panel.SkillFuncId.gameObject:SetActiveEx(true)
        self.panel.SkillFuncLabel.LabText = SkillTipsLinkData.Name
        self.panel.SkillFuncId:AddClick(function()
            local l_skillLearningCtrl = UIMgr:GetUI(UI.CtrlNames.SkillLearning)
            if l_skillLearningCtrl ~= nil then
                l_skillLearningCtrl:TurnTogOn(4)
            end
        end)
    end

end
----------------事件处理-------------------
--lua custom scripts end
return SkillPointTipCtrl
