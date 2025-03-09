--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local EffType = GameEnum.EffType
--lua fields end

--lua class define
---@class SkillLearningSkillBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtSkillName5 MoonClient.MLuaUICom
---@field TxtSkillName3 MoonClient.MLuaUICom
---@field TxtSkillLv MoonClient.MLuaUICom
---@field SkillName5 MoonClient.MLuaUICom
---@field SkillName3 MoonClient.MLuaUICom
---@field SkillLvBg MoonClient.MLuaUICom
---@field PlusTxt MoonClient.MLuaUICom
---@field PlusLab MoonClient.MLuaUICom
---@field learnEff MoonClient.MLuaUICom
---@field ImgBG2 MoonClient.MLuaUICom
---@field ImgBG MoonClient.MLuaUICom
---@field BtnSelectSkill MoonClient.MLuaUICom
---@field BtnReduceSkillPoint MoonClient.MLuaUICom
---@field BtnPlusSkillPoint MoonClient.MLuaUICom

---@class SkillLearningSkillBtnTemplate : BaseUITemplate
---@field Parameter SkillLearningSkillBtnTemplateParameter

SkillLearningSkillBtnTemplate = class("SkillLearningSkillBtnTemplate", super)
--lua class define end

--lua functions
function SkillLearningSkillBtnTemplate:Init()
	
    super.Init(self)
    self.upGradeCD = 0
    self.data = DataMgr:GetData("SkillData")
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
	
end --func end
--next--
function SkillLearningSkillBtnTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillLearningSkillBtnTemplate:OnSetData(data)
	
    self.upGrade = 0
    self.professionPanel = data.professionPanel
    self.skillLearningCtrl = data.skillLearningCtrl
    self.skillId = data.skillId
    self.row = data.row
    self.line = data.line
    self.isLearn = data.isLearn
    self.skillRootId = MPlayerInfo:GetRootSkillId(self.skillId)
    self.skillInfo = self.data.GetDataFromTable("SkillTable", self.skillRootId)
    self.isPassive = self.skillInfo.SkillTypeIcon == 3
    self.maxLv = self.skillInfo.EffectIDs.Length
    self:InitBtnState()
	
end --func end
--next--
function SkillLearningSkillBtnTemplate:OnDestroy()
	
    self.data = nil
    self.mgr = nil
	
end --func end
--next--
function SkillLearningSkillBtnTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SkillLearningSkillBtnTemplate:InitBtnState()

    local l_skillInfo = self.skillInfo
    local l_atlas = l_skillInfo.Atlas
    local l_icon = l_skillInfo.Icon

    self.Parameter.ImgBG.gameObject:SetActiveEx(self.isPassive)
    self.Parameter.ImgBG2.gameObject:SetActiveEx(not self.isPassive)
    self.Parameter.SkillLvBg.gameObject:SetActiveEx(self:NeedSkillPointToLearn(self.skillId))
    local l_btnSkillIcon = self.Parameter.BtnSelectSkill
    l_btnSkillIcon:SetSprite(l_atlas, l_icon)

    l_btnSkillIcon:AddClick(function()
        self:OnClickSkillButton(self.skillRootId)
    end)
    l_btnSkillIcon.Listener.onDown = function()
        l_btnSkillIcon.gameObject:SetLocalScale(0.9, 0.9, 0.9)
    end
    l_btnSkillIcon.Listener.onUp = function()
        l_btnSkillIcon.gameObject:SetLocalScaleOne()
    end

    --技能点分配监听（支持长按）
    local l_reduceBtn = self.Parameter.BtnReduceSkillPoint
    local l_plusBtn = self.Parameter.BtnPlusSkillPoint
    l_reduceBtn.Listener.onDown = (function() self.upGrade = -1 end)
    l_reduceBtn.Listener.onUp = (function() self.upGradeCD = 0 self.upGrade = 0 end)
    l_reduceBtn.Listener.onFocusOut = (function() self.upGradeCD = 0 self.upGrade = 0 end)
    l_plusBtn.Listener.onDown = (function() self.upGrade = 1 end)
    l_plusBtn.Listener.onUp = (function() self.upGradeCD = 0 self.upGrade = 0 end)
    l_plusBtn.Listener.onFocusOut = (function() self.upGradeCD = 0 self.upGrade = 0 end)
    self:UpdateAll()
    self:UpdateSkillLearningBtn()

end

function SkillLearningSkillBtnTemplate:Update()

    if self.upGrade ~= 0 then
        self:UpdateSkillLearningBtn()
    end
    if self.upGradeCD > 0 then
        self.upGradeCD = self.upGradeCD - 1
    end

end

function SkillLearningSkillBtnTemplate:UpdateAll()

    self:UpdateBtnState()
    self:UpdateSkillActive()

end

--更新文字
function SkillLearningSkillBtnTemplate:UpdateBtnState()

    local l_currentLv = MPlayerInfo:GetCurrentSkillInfo(self.skillRootId, not self.isLearn).lv
    local l_skillInfo = self.skillInfo
    local l_skillName = l_skillInfo.Name
    self.Parameter.SkillName3.gameObject:SetActiveEx(#l_skillName/3 <= 3)
    self.Parameter.TxtSkillName3.LabText = l_skillName
    self.Parameter.SkillName5.gameObject:SetActiveEx(#l_skillName/3 > 3)
    self.Parameter.TxtSkillName5.LabText = l_skillName

    local l_addedPoint = self.data.AddedSkillPoint[self.skillRootId]
    local l_maxSkillLv = self.maxLv
    if self.isLearn then
        if self.data.AddedSkillPoint[self.skillRootId] and self.data.AddedSkillPoint[self.skillRootId] ~= 0 then
            self.Parameter.TxtSkillLv.LabText = StringEx.Format("{0}/{1}", l_currentLv + l_addedPoint, l_maxSkillLv)
            self.Parameter.PlusLab:SetActiveEx(true)
            self.Parameter.PlusTxt.LabText = StringEx.Format("+{0}", l_addedPoint)
        else
            self.Parameter.PlusLab:SetActiveEx(false)
            self.Parameter.TxtSkillLv.LabText = StringEx.Format( "{0}/{1}", l_currentLv, l_maxSkillLv)
        end
    else
        self.Parameter.TxtSkillLv.LabText = StringEx.Format( "{0}", l_currentLv)
        self.Parameter.PlusLab:SetActiveEx(false)
    end

end

function SkillLearningSkillBtnTemplate:UpdateSkillActive()

    local l_btnSkillIcon = self.Parameter.BtnSelectSkill
    if self.isLearn then
        if self:IsSkillActive(self.skillInfo) then
            l_btnSkillIcon:SetGray(false)
        else
            l_btnSkillIcon:SetGray(true)
            self.skillLearningCtrl:ReturnSkillPoint(self.skillRootId)
            self:UpdateBtnState(0)
        end
    else
        l_btnSkillIcon:SetGray(false)
    end

end

function SkillLearningSkillBtnTemplate:UpdateSkillLearningBtn()

    local l_id = self.skillRootId
    local l_reduceBtn = self.Parameter.BtnReduceSkillPoint
    local l_plusBtn = self.Parameter.BtnPlusSkillPoint
    local l_addedLv = self.data.AddedSkillPoint[l_id] or 0

    if self:CanLearn(self.skillInfo) then
        --减号
        if l_addedLv ~= 0 then
            l_reduceBtn.gameObject:SetActiveEx(true)
            if self.upGrade == -1 and self.upGradeCD == 0 then
                self.upGradeCD = 12
                -- 变身期间不能加点
                if MEntityMgr.PlayerEntity.IsTransfigured then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_SKILL_POINT"))
                    return
                end

                if self.data.AddedSkillPoint[l_id] then
                    local currentAddLv = self.data.AddedSkillPoint[l_id]
                    self.data.AddedSkillPoint[l_id] = currentAddLv - 1
                    if self.data.AddedSkillPoint[l_id] < 0 then
                        self.data.AddedSkillPoint[l_id] = nil
                    else
                        self.data.SetRemainingPoint(self.data.GetRemainingPoint() + 1)
                        self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
                    end
                end

                --如果下一个职业依赖的点数在点完之后不足以开放，则提示玩家
                --是否需要进行检查
                local l_currentProType = self.skillLearningCtrl.currentProType
                local l_needCheckProType = {}
                if self.data.ProfessionList.MAX_TYPE ~= l_currentProType then
                    local l_professionList = MPlayerInfo.ProfessionIdList
                    local l_nextType = l_currentProType + 1
                    for type = l_nextType, l_professionList.Count - 1 do
                        if not self.data.IsProfessionPointFull(type) and self.data.GetAddedProfessionSkillPointNumberByProType(type) > 0 then
                            l_needCheckProType[type] = true
                        end
                    end
                end

                --进行检查是否有职业从可点到不可点
                if self.data.ProfessionList.MAX_TYPE ~= l_currentProType then
                    local l_professionList = MPlayerInfo.ProfessionIdList
                    local l_chaneType
                    local l_hasChange = false
                    for type = l_currentProType + 1, l_professionList.Count - 1 do
                        if not self.data.IsProfessionPointFull(type) and l_needCheckProType[type] then
                            l_chaneType = type
                            l_hasChange = true
                            break
                        end
                    end
                    if l_hasChange then
                        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("COMFIRM_REDUCE_POINT_POINT_NOT_ENOUGH"), function()
                            if l_chaneType then
                                self.skillLearningCtrl:UpdateSkillState(l_chaneType)
                            end
                            self:OnMinusSkill()
                        end, function()
                            if not self.data.AddedSkillPoint[l_id] then
                                self.data.AddedSkillPoint[l_id] = 0
                            end
                            self.data.AddedSkillPoint[l_id] = self.data.AddedSkillPoint[l_id] + 1
                            l_reduceBtn.gameObject:SetActiveEx(true)
                            self.data.SetRemainingPoint(self.data.GetRemainingPoint() - 1)
                            self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
                        end)
                        return
                    end
                end
                MgrMgr:GetMgr("SkillLearningMgr").SkillRecommendId = 0
                self:OnMinusSkill()
            end
        else
            l_reduceBtn.gameObject:SetActiveEx(false)
            if self.upGrade == -1 then
                self.upGrade = 0
            end
        end

        --加号
        if MLuaCommonHelper.Long2Int(self.data.GetRemainingPoint()) > 0 then
            local l_currentLv = MPlayerInfo:GetCurrentSkillInfo(l_id).lv
            local l_addPoint = self.data.AddedSkillPoint[l_id] or 0
            local l_maxLv = self.maxLv
            if l_currentLv + l_addPoint < l_maxLv then
                l_plusBtn.gameObject:SetActiveEx(true)
                if self.upGrade == 1 and self.upGradeCD == 0 then
                    self.upGradeCD = 12
                    -- 变身期间不能加点
                    if MEntityMgr.PlayerEntity.IsTransfigured then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRANSFIGURE_CAN_NOT_ADD_SKILL_POINT"))
                        return
                    end
                    if self.data.AddedSkillPoint[l_id] ~= nil then
                        if l_addPoint + l_currentLv < l_maxLv then
                            local temp = self.data.AddedSkillPoint[l_id] + 1
                            self.data.AddedSkillPoint[l_id] = temp
                            self.data.SetRemainingPoint(self.data.GetRemainingPoint() - 1)
                            self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
                        end
                    else
                        if l_currentLv == self.maxLv then
                            return
                        end
                        self.data.SetRemainingPoint(self.data.GetRemainingPoint() - 1)
                        self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())
                        self.data.AddedSkillPoint[l_id] = 1
                    end
                    MgrMgr:GetMgr("SkillLearningMgr").SkillRecommendId = 0
                    self.professionPanel:UpdateAllBtn()
                    self:UpdateSkillSaver()
                    self:UpdateProfessionPoint()
                    self:ShowEff(EffType.PlusSkill)
                    MAudioMgr:Play("event:/UI/SkillPanelAddPoint")
                end
            else
                l_plusBtn.gameObject:SetActiveEx(false)
                if self.upGrade == 1 then
                    self.upGrade = 0
                end
            end
        else
            l_plusBtn.gameObject:SetActiveEx(false)
            if self.upGrade == 1 then
                self.upGrade = 0
            end
        end
    else
        l_reduceBtn.gameObject:SetActiveEx(false)
        l_plusBtn.gameObject:SetActiveEx(false)
        self.upGrade = 0
    end

end

function SkillLearningSkillBtnTemplate:OnMinusSkill()

    self.professionPanel:UpdateAllBtn()
    self:UpdateSkillSaver()
    self:UpdateProfessionPoint()
    self:ShowEff(EffType.MinusSkill)

    self.data.SetRemainingPoint(self.data.GetTotalSkillPointByLevel() - self.data.GetPreProfessionPointSum(self.data.ProfessionList.MAX_TYPE))
    self.mgr.EventDispatcher:Dispatch(self.mgr.EventType.RemainingPointChange, self.data.GetRemainingPoint())

end

function SkillLearningSkillBtnTemplate:ShowEff(type)

    local str = ""
    if type == EffType.MinusSkill then
        str = self.isPassive and "Effects/Prefabs/Creature/Ui/Fx_Ui_Lv_Passive_Down" or "Effects/Prefabs/Creature/Ui/Fx_Ui_Lv_Down"
    elseif type == EffType.PlusSkill then
        str = self.isPassive and "Effects/Prefabs/Creature/Ui/Fx_Ui_Lv_Passive_Up" or "Effects/Prefabs/Creature/Ui/Fx_Ui_Lv_Up"
    elseif type == EffType.ApplySkill then
        str = "Effects/Prefabs/Creature/Ui/Fx_Ui_Lv_Confirm"
    end
    if not IsEmptyOrNil(str) then
        local obj = self:CloneObj(self.Parameter.learnEff.gameObject)
        obj.transform:SetParent(self.Parameter.learnEff.transform.parent, false)
        obj.transform.position = self.Parameter.learnEff.transform.position
        obj.transform.localScale = self.Parameter.learnEff.transform.localScale
        local rawImg = obj:GetComponent("RawImage")
        self:CreateUIEffect(str, {
            rawImage = rawImg,
            ScaleFac = Vector3.New(1, 1, 1)
        })
    end

end

function SkillLearningSkillBtnTemplate:ShowApplyEff()
    self:ShowEff(EffType.ApplySkill)
end

function SkillLearningSkillBtnTemplate:OnClickSkillButton(rootId)
    self.skillLearningCtrl:OnClickSkillButton(rootId, self.Parameter.LuaUIGroup.gameObject, not self.isLearn, { self.row, self.line })
end

function SkillLearningSkillBtnTemplate:NeedSkillPointToLearn(skillId)

    if (not self.isLearn) or skillId == self.data.SkillQueueId then
        return false
    else
        return self.data.NeedSkillPointToLearn(skillId)
    end

end

function SkillLearningSkillBtnTemplate:CanLearn(skillInfo)

    if not self.data.IsProfessionPointFull(self.professionPanel.proType) then
        return false
    end
    return self.isLearn and self.skillLearningCtrl:CanLearn(skillInfo)

end

function SkillLearningSkillBtnTemplate:IsSkillActive(skillInfo)

    if not self.data.IsProfessionPointFull(self.professionPanel.proType) then
        return false
    end
    return self.data.IsSkillActive(skillInfo)

end

function SkillLearningSkillBtnTemplate:UpdateSkillSaver()
    self.skillLearningCtrl:UpdateSkillSaver()
end

function SkillLearningSkillBtnTemplate:UpdateProfessionPoint()
    self.skillLearningCtrl:UpdateProSkillPoint()
end

function SkillLearningSkillBtnTemplate:GetSkillId()
    return self.skillId
end

--新手指引点击事件
function SkillLearningSkillBtnTemplate:SetGuideClickEvent(guideClickEvent)

    self.Parameter.BtnPlusSkillPoint.Listener.onDown = (function() 
        self.upGrade = 1 
        guideClickEvent()
    end)

end

--新手指引点击事件移除
function SkillLearningSkillBtnTemplate:RemoveGuideClickEvent()

    self.Parameter.BtnPlusSkillPoint.Listener.onDown = (function() self.upGrade = 1 end)

end
--lua custom scripts end
return SkillLearningSkillBtnTemplate