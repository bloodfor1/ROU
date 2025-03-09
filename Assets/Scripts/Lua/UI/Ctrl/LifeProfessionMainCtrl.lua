--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionMainPanel"
require "UI/Template/LifeDirectoryTemplate"
require "UI/Template/SkillProductTemplate"
require "UI/Template/CostPropTemplate"
require "UI/Template/GatherPropInfoTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
LifeProfessionMainCtrl = class("LifeProfessionMainCtrl", super)
--lua class define end

--lua functions
function LifeProfessionMainCtrl:ctor()

    super.ctor(self, CtrlNames.LifeProfessionMain, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function LifeProfessionMainCtrl:Init()
    ---@type LifeProfessionMainPanel
    self.panel = UI.LifeProfessionMainPanel.Bind(self)
    super.Init(self)
    self.lifeProMgr = MgrMgr:GetMgr("LifeProfessionMgr")
    self:initBaseInfo()
    self:initLifeProfessionDirectoryInfo()
    self:initLifeSkillInfo()
    self:initLifeNaturalInfo()
end --func end
--next--
function LifeProfessionMainCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.lifeSkillProductPool = nil
    self.directoryPool = nil
    self.lifeSkillCostPropItem1 = nil
    self.lifeSkillCostPropItem2 = nil
end --func end
--next--
function LifeProfessionMainCtrl:OnActive()
    if self.uiPanelData ~= nil then
        self:directShowLifeSkill(self.uiPanelData.classID)
    end
    self:refreshShowDirectoryInfo()
    self:refreshSelectPanel()
end --func end
--next--
function LifeProfessionMainCtrl:OnDeActive()
    self:destroyEffect()
    self:closeTween()
end --func end
--next--
function LifeProfessionMainCtrl:Update()
    if nil ~= self.directoryPool then
        self.directoryPool:OnUpdate()
    end

    if nil ~= self.lifeProfessionGatherPropPool then
        self.lifeProfessionGatherPropPool:OnUpdate()
    end

    if nil ~= self.lifeSkillProductPool then
        self.lifeSkillProductPool:OnUpdate()
    end

    if nil ~= self.lifeSkillProductCostPool then
        self.lifeSkillProductCostPool:OnUpdate()
    end
end --func end
--next--
function LifeProfessionMainCtrl:BindEvents()
    self:BindEvent(self.lifeProMgr.EventDispatcher, self.lifeProMgr.EventType.DataChange, function()
        local l_openSysItem = TableUtil.GetOpenSystemTable().GetRowById(self.currentSelectDirectoryClassID)
        if MLuaCommonHelper.IsNull(l_openSysItem) then
            return
        end
        self:refreshLifeSkillDetailInfo(l_openSysItem, true)
    end)
    self:BindEvent(self.lifeProMgr.EventDispatcher, self.lifeProMgr.EventType.LifeSkillLvUp, function(_, classID, level)
        self:showLvUpEffect(classID, level)
        self:refreshSkillProductInfo()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--region init
function LifeProfessionMainCtrl:initLifeProfessionDirectoryInfo()

    local ClassID = self.lifeProMgr.ClassID
    --自然之路
    self.naturalDirectory = {
        classId = ClassID.Natural,
        directoryObj = self.panel.Panel_NaturalLetter.UObj,
        directoryRectT = self.panel.Panel_NaturalLetter.RectTransform,
        openPosTrans = self.panel.Panel_NaturalLetter.Transform:Find("Img_OpenPos"),
        subDirectory = {},
    }
    --技艺之路
    self.skillDirectory = {
        classId = ClassID.Cuisine,
        directoryObj = self.panel.Panel_SkillLetter.UObj,
        directoryRectT = self.panel.Panel_SkillLetter.RectTransform,
        openPosTrans = self.panel.Panel_SkillLetter.Transform:Find("Img_OpenPos"),
        subDirectory = {},
    }
    self.currentSelectDirectoryClassID = 0

    self:addSubDirectoryData(self.naturalDirectory.subDirectory, ClassID.Gather, false)
    self:addSubDirectoryData(self.naturalDirectory.subDirectory, ClassID.Mining, false)
    self:addSubDirectoryData(self.naturalDirectory.subDirectory, ClassID.Fish, false)
    local l_lastSelectDirectoryId = self.lifeProMgr.GetLastShowDirectoryClassID()
    local l_hasFindLastChooseDirectoryInNaturalDirectory = self:sortAndChooseOneDirectory(self.naturalDirectory.subDirectory, false, l_lastSelectDirectoryId)

    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Cook, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Drug, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Sweet, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Smelt, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Armor, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.Acces, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.FoodFusion, false)
    self:addSubDirectoryData(self.skillDirectory.subDirectory, ClassID.MedicineFusion, false)
    self:sortAndChooseOneDirectory(self.skillDirectory.subDirectory, l_hasFindLastChooseDirectoryInNaturalDirectory, l_lastSelectDirectoryId)

    if l_hasFindLastChooseDirectoryInNaturalDirectory then
        self.currentShowDirectory = self.naturalDirectory
        self.currentHideDirectory = self.skillDirectory
        local l_tempAnchorePos = self.panel.Panel_NaturalLetter.RectTransform.anchoredPosition
        self.panel.Panel_NaturalLetter.RectTransform.anchoredPosition = self.panel.Panel_SkillLetter.RectTransform.anchoredPosition
        self.panel.Panel_SkillLetter.RectTransform.anchoredPosition = l_tempAnchorePos
    else
        self.currentShowDirectory = self.skillDirectory
        self.currentHideDirectory = self.naturalDirectory
    end
    self.currentShowDirectory.directoryRectT:SetAsFirstSibling()
    self.directAnimTime = 0.1

    if not MLuaCommonHelper.IsNull(self.currentHideDirectory.openPosTrans) then
        self.currentHideDirectory.openPosTrans.localEulerAngles = Vector3.zero
    end
    if not MLuaCommonHelper.IsNull(self.currentShowDirectory.openPosTrans) then
        self.currentShowDirectory.openPosTrans.localEulerAngles = Vector3.New(0, 180, 0)
    end
    self.panel.Panel_LetterPaper.Transform:SetParent(self.panel.Panel_OutLetterPos.Transform)
    self.panel.Panel_LetterPaper.Transform.position = self.panel.Obj_LetterOutPos.Transform.position
    self.isPlayingLetterAnim = false

    self.panel.Panel_OutLetterPos:SetMaskState(false)
    self.panel.Panel_NaturalLetter:AddClick(function()
        if self.currentHideDirectory ~= self.naturalDirectory or self.isPlayingLetterAnim then
            return
        end
        self.isPlayingLetterAnim = true
        self.panel.Img_NaturalGo:SetActiveEx(false)
        self:playOperateLetterAnim(false, self.playAdjustDirectoryPosAnim)
    end, true)
    self.panel.Panel_SkillLetter:AddClick(function()
        if self.currentHideDirectory ~= self.skillDirectory or self.isPlayingLetterAnim then
            return
        end
        self.isPlayingLetterAnim = true
        self.panel.Img_SkillGo:SetActiveEx(false)
        self:playOperateLetterAnim(false, self.playAdjustDirectoryPosAnim)
    end, true)
    self.directoryPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.LifeDirectoryTemplate,
        TemplatePrefab = self.panel.Template_LifeDirectory.gameObject,
        ScrollRect = self.panel.Scroll_LifeDirectory.LoopScroll,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
end
function LifeProfessionMainCtrl:initBaseInfo()
    self.tweenIdTable = {}
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.LifeProfessionMain)
    end, true)
    self.panel.Btn_Empty:AddClick(function()
        self:tryToUnlockCurrentDirectory(true)
    end, true)
    self.panel.Btn_Help:AddClick(function()
        local l_content = Lang("LIFE_PROFESSION_INTRODUCE")
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.UpperLeft,
            pivot = Vector2.New(0, 1),
            anchoreMin = Vector2.New(0.5, 0.5),
            anchoreMax = Vector2.New(0.5, 0.5),
            downwardAdapt = true,
            relativeLeftPos = {
                canOffset = false,
                screenPos = MUIManager.UICamera:WorldToScreenPoint(self.panel.Btn_Help.Transform.position)
            },
            width = 450,
        })
    end, true)
end
function LifeProfessionMainCtrl:initLifeNaturalInfo()
    self.lifeProfessionGatherPropPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GatherPropInfoTemplate,
        TemplatePrefab = self.panel.Template_GatherPropInfo.gameObject,
        ScrollRect = self.panel.Scroll_LifeProfessionSite.LoopScroll,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
end
function LifeProfessionMainCtrl:initLifeSkillInfo()
    self.panel.Btn_Go:AddClick(function()
        self:OnBtnGo()
    end, true)
    self.panel.Btn_LevelUp:AddClick(function()
        self:onBtnLevelupClick()
    end, true)
    self.panel.Btn_Unlock:AddClick(function()
        self:tryToGetTask()
    end, true)
    self.lifeSkillProductPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SkillProductTemplate,
        TemplatePrefab = self.panel.Template_SkillProduct.gameObject,
        ScrollRect = self.panel.Scroll_SkillProduct.LoopScroll,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
    self.lifeSkillProductCostPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CostPropTemplate,
        TemplatePrefab = self.panel.Template_CostProp.gameObject,
        ScrollRect = self.panel.Scroll_CostProp.LoopScroll,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
    self.panel.Btn_TipBg.Listener.onClick = function(g, e)
        self:SetPassThroughFunc(true, self.panel.Btn_TipBg.UObj, true, 1, true)
        self.panel.Panel_SkillProductTip:SetActiveEx(false)
    end

end
--endregion init

--region usual
function LifeProfessionMainCtrl:sortAndChooseOneDirectory(subDirectory, hasFindLastDirectory, lastChooseDirectoryClassID)
    table.sort(subDirectory, function(a, b)
        if self.lifeProMgr.CanOpenSystem(a.classID) and
                not self.lifeProMgr.CanOpenSystem(b.classID) then
            return true
        elseif self.lifeProMgr.CanOpenSystem(a.classID) ==
                self.lifeProMgr.CanOpenSystem(b.classID) then
            if a.classID < b.classID then
                return true
            end
        end
        return false
    end)
    local l_findLastChooseDirectory = false
    if not hasFindLastDirectory then
        for i = 1, #subDirectory do
            --查找是否存在上次选中的目录，并置选中状态
            local l_tempSubDirectory = subDirectory[i]
            if l_tempSubDirectory.classID == lastChooseDirectoryClassID then
                l_tempSubDirectory.isChoose = true
                l_findLastChooseDirectory = true
                self.currentSelectDirectoryClassID = lastChooseDirectoryClassID
                break
            end
        end
    end

    if not l_findLastChooseDirectory then
        --当前子目录集不存在上次选中的子目录，则当前子目录集选中当前子目录集的第一个
        local l_firstSubDirectory = subDirectory[1]
        if l_firstSubDirectory ~= nil then
            l_firstSubDirectory.isChoose = true
            if not hasFindLastDirectory then
                self.currentSelectDirectoryClassID = l_firstSubDirectory.classID
            end
        end
    end
    return l_findLastChooseDirectory
end
function LifeProfessionMainCtrl:addSubDirectoryData(targetTable, classID, isChoose)
    if not self.lifeProMgr.CanVersionActive(classID) then
        return
    end
    table.insert(targetTable, {
        classID = classID,
        isChoose = isChoose,
        OnSelectMethod = self.OnSelectMethod,
    })
end
function LifeProfessionMainCtrl:OnSelectMethod(selectClassID)
    self.currentSelectDirectoryClassID = selectClassID
    self.lifeProMgr.SetLastShowDirectoryClassID(selectClassID)
    for i = 1, #self.currentShowDirectory.subDirectory do
        local l_subDirectory = self.currentShowDirectory.subDirectory[i]
        l_subDirectory.isChoose = l_subDirectory.classID == selectClassID
    end
    self:refreshSelectPanel()
end
function LifeProfessionMainCtrl:onAdjustDirectoryComplete()
    local l_tempDirectory = self.currentShowDirectory
    self.currentShowDirectory = self.currentHideDirectory
    self.currentHideDirectory = l_tempDirectory
    self:refreshShowDirectoryInfo()
end
function LifeProfessionMainCtrl:onBtnLevelupClick()
    local l_lifeSkillLv = self.lifeProMgr.GetLv(self.currentSelectDirectoryClassID)
    local l_levelUpPriceConditionParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            l_lifeSkillLv + 1, self.lifeProMgr.ELevelUpConditionType.Price)
    if l_levelUpPriceConditionParam == -1 then
        return
    end

    local l_levelUpRoleBaseLevelConditionParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            l_lifeSkillLv + 1, self.lifeProMgr.ELevelUpConditionType.RoleLevel)
    if l_levelUpRoleBaseLevelConditionParam ~= -1 and MPlayerInfo.Lv < l_levelUpRoleBaseLevelConditionParam then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLAYER_BASE_LEVEL_NOT_ENOUGH_TIP"))
        return
    end

    ---@type CraftingSkillLvUpPriceTable
    local l_levelUpPriceItem = TableUtil.GetCraftingSkillLvUpPriceTable().GetRowByID(l_levelUpPriceConditionParam)
    if MLuaCommonHelper.IsNull(l_levelUpPriceItem) then
        return
    end

    local l_normalPriceItemId = l_levelUpPriceItem.NormalPriceMain[0]
    local l_normalPriceMainPropHasCount = Data.BagModel:GetCoinOrPropNumById(l_normalPriceItemId)
    if l_normalPriceItemId~=0 and l_normalPriceMainPropHasCount < l_levelUpPriceItem.NormalPriceMain[1] then
        self.lifeProMgr.ShowLifePropNotEnoughTips(l_normalPriceItemId)
        return
    end

    local l_normalPriceSubItemId = l_levelUpPriceItem.NormalPriceSub[0]
    local l_normalPriceSubPropHasCount = Data.BagModel:GetCoinOrPropNumById(l_normalPriceSubItemId)
    if l_normalPriceSubItemId~=0 and l_normalPriceSubPropHasCount < l_levelUpPriceItem.NormalPriceSub[1] then
        self:showReplaceCostPropDialog(l_levelUpPriceItem.AlternativePrice[0], l_levelUpPriceItem.AlternativePrice[1],
                l_normalPriceSubItemId, l_levelUpPriceItem.NormalPriceSub[1])
        return
    end

    self.lifeProMgr.ReqLifeSkillUpgrade(self.currentSelectDirectoryClassID, 1)
end
function LifeProfessionMainCtrl:showReplaceCostPropDialog(propID, needPropNum, replacePropID, replacePropNum)
    local l_hasPropCount = Data.BagModel:GetCoinOrPropNumById(propID)
    if l_hasPropCount < needPropNum then
        self.lifeProMgr.ShowLifePropNotEnoughTips(propID)
        return
    end

    local l_replacePropItem = TableUtil.GetItemTable().GetRowByItemID(replacePropID)
    local l_usePropItem = TableUtil.GetItemTable().GetRowByItemID(propID)
    if MLuaCommonHelper.IsNull(l_usePropItem) or MLuaCommonHelper.IsNull(l_replacePropItem) then
        return
    end

    local l_usePropText = GetImageText(l_usePropItem.ItemIcon, l_usePropItem.ItemAtlas, 20, 26, false)
    local l_replacePropText = GetImageText(l_replacePropItem.ItemIcon, l_replacePropItem.ItemAtlas, 20, 26, false)
    local l_content = Lang("USE_ALTERNATIVE_PRICE_TIPS", l_usePropText, needPropNum, l_replacePropText, replacePropNum)
    local l_dialogExtraData = {
        imgClickInfos = {
            {
                imgName = l_usePropItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    self:setRichTextPropImgClickEvent(propID, ed)
                end,
            },
            {
                imgName = l_replacePropItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    self:setRichTextPropImgClickEvent(replacePropID, ed)
                end,
            },
        }
    }

    CommonUI.Dialog.ShowYesNoDlg(true, Lang("LEVEL_REWARD_PROP_NOT_ENOUGTH", l_replacePropItem.ItemName),
            l_content, function()
                self.lifeProMgr.ReqLifeSkillUpgrade(self.currentSelectDirectoryClassID, 2)
            end, nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft, l_dialogExtraData)
end
function LifeProfessionMainCtrl:setRichTextPropImgClickEvent(propId, eventData)
    local l_extraData = {
        relativeScreenPosition = eventData.position,
        bottomAlign = true
    }
    local l_itemData = Data.BagModel:CreateItemWithTid(propId)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, false, l_extraData)
end
function LifeProfessionMainCtrl:OnBtnGo()
    local l_npcType = nil
    local l_npcPoint = nil
    local ClassID = self.lifeProMgr.ClassID
    if self.currentSelectDirectoryClassID == ClassID.Cook then
        l_npcType = 2
    elseif self.currentSelectDirectoryClassID == ClassID.Drug then
        l_npcType = 9
    elseif self.currentSelectDirectoryClassID == ClassID.Sweet then
        l_npcType = 10
    elseif self.currentSelectDirectoryClassID == ClassID.Smelt then
        l_npcType = 11
    elseif self.currentSelectDirectoryClassID == ClassID.Armor then
        l_npcType = 11
    elseif self.currentSelectDirectoryClassID == ClassID.Acces then
        l_npcType = 11
    elseif self.currentSelectDirectoryClassID == ClassID.FoodFusion then
        l_npcType = 12
    elseif self.currentSelectDirectoryClassID == ClassID.MedicineFusion then
        l_npcType = 13
    else
        return
    end
    local l_npcCount = MSceneMgr.AllLifeProfessionWallData.data.Length
    for i = 0, l_npcCount - 1 do
        local l_point = MSceneMgr.AllLifeProfessionWallData.data:GetValue(i)
        if l_point.type == l_npcType then
            l_npcPoint = l_point
            break
        end
    end
    if l_npcPoint ~= nil then
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionMain)
        MTransferMgr:GotoPosition(l_npcPoint.sceneID, l_npcPoint.pos, function()
            if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_D_SceneInteraction) then
                return
            end
            MSceneWallTriggerMgr:SelectSceneObjHudByTriggerId(l_npcPoint.triggerID)
        end, nil, 360)
    else
        logError("找不到对应交互物件")
    end

end
function LifeProfessionMainCtrl:showLvUpEffect(classID, level)
    local l_fxData = {}
    l_fxData.rawImage = self.panel.Raw_LevelUp.RawImg
    l_fxData.destroyHandler = function()
        self.levelupEffectID = 0
    end
    l_fxData.position = Vector3.New(0, 0.25, 0)
    self:destroyEffect()
    self.levelupEffectID = self:CreateUIEffect(StringEx.Format("Effects/Prefabs/Creature/Ui/FX_ui_levelup"), l_fxData)

end
function LifeProfessionMainCtrl:destroyEffect()
    if self.levelupEffectID ~= nil and self.levelupEffectID > 0 then
        self:DestroyUIEffect(self.levelupEffectID)
        self.levelupEffectID = 0
    end
end
function LifeProfessionMainCtrl:closeTween()
    for k, v in pairs(self.tweenIdTable) do
        MUITweenHelper.KillTween(k)
    end
    self.tweenIdTable = {}
end
function LifeProfessionMainCtrl:tryToGetTask()
    local l_unlockParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            1, self.lifeProMgr.ELevelUpConditionType.Task)
    if l_unlockParam == -1 then
        return
    end
    local l_canGetTask = self.lifeProMgr.CanGetUnlockLifeSkillTask(l_unlockParam)
    if not l_canGetTask then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_ACCEPT_LIMITED"))
        return
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if l_taskMgr.CheckTaskTaked(l_unlockParam) then
        l_taskMgr.OnQuickTaskClickWithTaskId(l_unlockParam)
    else
        l_taskMgr.NavToTaskAcceptNpc(l_unlockParam)
    end
    UIMgr:DeActiveUI(UI.CtrlNames.LifeProfessionMain)
end
function LifeProfessionMainCtrl:isNeedChangeDirectory(classID)
    for i = 1, #self.currentShowDirectory.subDirectory do
        local l_subDirectory = self.currentShowDirectory.subDirectory[i]
        if l_subDirectory.classID == classID then
            return false
        end
    end
    return true
end
function LifeProfessionMainCtrl:updateShowDirectoryChooseState()
    for i = 1, #self.currentShowDirectory.subDirectory do
        local l_subDirectory = self.currentShowDirectory.subDirectory[i]
        l_subDirectory.isChoose = l_subDirectory.classID == self.currentSelectDirectoryClassID
    end
end
function LifeProfessionMainCtrl:switchShowDirectory()
    local l_tempDirectory = self.currentShowDirectory
    self.currentShowDirectory = self.currentHideDirectory
    self.currentHideDirectory = l_tempDirectory

    self.currentHideDirectory.directoryRectT:SetAsFirstSibling()

    local l_tempAnchorePos = self.currentShowDirectory.directoryRectT.anchoredPosition
    self.currentShowDirectory.directoryRectT.anchoredPosition = self.currentHideDirectory.directoryRectT.anchoredPosition
    self.currentHideDirectory.directoryRectT.anchoredPosition = l_tempAnchorePos

    if not MLuaCommonHelper.IsNull(self.currentHideDirectory.openPosTrans) then
        self.currentHideDirectory.openPosTrans.localEulerAngles = Vector3.zero
    end
    if not MLuaCommonHelper.IsNull(self.currentShowDirectory.openPosTrans) then
        self.currentShowDirectory.openPosTrans.localEulerAngles = Vector3.New(0, 180, 0)
    end
end
function LifeProfessionMainCtrl:directShowLifeSkill(classID)
    if self:isNeedChangeDirectory(classID) then
        self:switchShowDirectory()
    end
    self.currentSelectDirectoryClassID = classID
    self:updateShowDirectoryChooseState()
end

function LifeProfessionMainCtrl:setLifeSkillProgressBar(currentValue,nextAddExpValue)
    self.panel.Slider_SkillProgress.Slider.value = currentValue
    if nextAddExpValue<currentValue then
        nextAddExpValue = 1
    end

    self.panel.Slider_SkillProgressBg.Slider.value = nextAddExpValue
end
--endregion usual

--region 动画
function LifeProfessionMainCtrl:playOperateLetterAnim(isOpen, completeCallBack)
    local l_moveOutScreenPos = MLuaCommonHelper.LocalPositionToScreenPos(self.panel.Obj_LetterPoppedUpPos.Transform.localPosition,
            MUIManager.UICamera, self.panel.Obj_LetterPoppedUpPos.Transform)
    local l_moveOutAnchorePos
    if isOpen then
        _, l_moveOutAnchorePos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Panel_InLetterPos.RectTransform,
                l_moveOutScreenPos, MUIManager.UICamera, nil)
    else
        _, l_moveOutAnchorePos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Panel_OutLetterPos.RectTransform,
                l_moveOutScreenPos, MUIManager.UICamera, nil)
    end

    local l_moveObj = self.panel.Panel_LetterPaper.UObj
    local l_sourceParent = self.panel.Panel_OutLetterPos.Transform
    local l_targetParent = self.panel.Panel_InLetterPos.Transform
    local l_targetPos = self.panel.Obj_LetterSourcePos.RectTransform.anchoredPosition3D
    local l_targetLetterAngle = Vector3.New(0, 0, 0)
    if isOpen then
        l_targetPos = self.panel.Obj_LetterOutPos.RectTransform.anchoredPosition3D
        l_sourceParent = self.panel.Panel_InLetterPos.Transform
        l_targetParent = self.panel.Panel_OutLetterPos.Transform
        l_targetLetterAngle.y = 180
    end
    l_moveObj.transform:SetParent(l_sourceParent)
    local l_animTime = self.directAnimTime
    if isOpen then
        l_animTime = l_animTime * 2
    end
    local l_tweenID
    l_tweenID = MUITweenHelper.TweenAnchoredPos(l_moveObj, self.panel.Panel_LetterPaper.RectTransform.anchoredPosition3D, l_moveOutAnchorePos, l_animTime, function()
        if not self:IsActive() then
            return
        end
        l_moveObj.transform:SetParent(l_targetParent.transform)
        self.panel.Panel_OutLetterPos:SetMaskState(not isOpen)
        local l_tweenID1 = MUITweenHelper.TweenPos(l_moveObj, self.panel.Panel_LetterPaper.RectTransform.anchoredPosition3D, l_targetPos, l_animTime,
                function()
                    if not self:IsActive() then
                        return
                    end
                    self.currentShowDirectory.openPosTrans.localEulerAngles = l_targetLetterAngle
                    if completeCallBack then
                        completeCallBack(self)
                    end
                    if isOpen then
                        self.isPlayingLetterAnim = false
                        self.panel.Img_SkillGo:SetActiveEx(true)
                        self.panel.Img_NaturalGo:SetActiveEx(true)
                    end
                end)
        self.tweenIdTable[l_tweenID1] = true
    end)
    self.tweenIdTable[l_tweenID] = true
end
function LifeProfessionMainCtrl:playAdjustDirectoryPosAnim()
    local l_tweenID = MUITweenHelper.TweenAnchoredPos(self.currentShowDirectory.directoryObj, self.currentShowDirectory.directoryRectT.anchoredPosition3D,
            self.currentHideDirectory.directoryRectT.anchoredPosition3D, self.directAnimTime, function()
                if not self:IsActive() then
                    return
                end
                self.currentShowDirectory.directoryObj.transform:SetAsFirstSibling()
            end)
    self.tweenIdTable[l_tweenID] = true
    local l_beziarRefPos = (self.currentHideDirectory.directoryRectT.anchoredPosition + self.currentShowDirectory.directoryRectT.anchoredPosition) / 2
    l_beziarRefPos.x = l_beziarRefPos.x + 300
    local l_bezialTweenID = MUITweenHelper.TweenBeziarMoveAnim(self.currentHideDirectory.directoryRectT,
            self.currentHideDirectory.directoryRectT.anchoredPosition, self.currentShowDirectory.directoryRectT.anchoredPosition,
            l_beziarRefPos, self.directAnimTime * 1500, DG.Tweening.Ease.InQuad, function()
                if self:IsActive() then
                    self:playOperateLetterAnim(true)
                    self:onAdjustDirectoryComplete()
                    self.currentShowDirectory.openPosTrans.localEulerAngles = Vector3.New(0, 180, 0)
                end
            end)
    self.tweenIdTable[l_bezialTweenID] = true
end
--endregion

--region refresh
function LifeProfessionMainCtrl:refreshShowDirectoryInfo()
    if self.currentShowDirectory == self.skillDirectory then
        self.panel.Txt_CurrentDirectoryName.LabText = Common.Utils.Lang("LifeProfession_Cuisine")
    else
        self.panel.Txt_CurrentDirectoryName.LabText = Common.Utils.Lang("LifeProfession_Natural")
    end
    if self.directoryPool == nil then
        return
    end
    self.directoryPool:CancelSelectTemplate()
    self.directoryPool:ShowTemplates({ Datas = self.currentShowDirectory.subDirectory })
    self:refreshSelectPanel()
end
function LifeProfessionMainCtrl:tryToUnlockCurrentDirectory(isShowDialog)
    local l_data = self.lifeProMgr.GetOpenSystemData(self.currentSelectDirectoryClassID)
    if l_data == nil then
        logError("OpenSystemTable没有相关系统信息 => " .. self.currentSelectDirectoryClassID)
        return false
    end
    if MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(l_data.TaskId[0]) then
        if isShowDialog then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
        end
        return false
    end
    if not isShowDialog then
        return true
    end
    local l_txt = ""
    if self.currentShowDirectory.classId == self.lifeProMgr.ClassID.Natural then
        l_txt = Lang("LifeProfession_LockHint_Natural")--"完成相关任务可解锁自然之路"
    elseif self.currentShowDirectory.classId == self.lifeProMgr.ClassID.Cuisine then
        l_txt = Lang("LifeProfession_LockHint_Cuisine")--"完成相关任务可解锁技艺之途"
    elseif self.currentShowDirectory.classId == self.lifeProMgr.ClassID.Pharmacy then
        l_txt = Lang("LifeProfession_LockHint_Pharmacy")--"完成相关任务可解锁雅致之道"
    end
    local l_txtConfirm = Lang("LifeProfession_LockHint_Go")--"前往"
    local l_txtCancel = Lang("DLG_BTN_NO")--"取消"
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_txt, l_txtConfirm, l_txtCancel,
            function()
                UIMgr:DeActiveUI(UI.CtrlNames.LifeProfessionMain)
                game:ShowMainPanel()
                MgrMgr:GetMgr("TaskMgr").OnQuickTaskClickWithTaskId(l_data.TaskId[0])
            end)
    return true
end
function LifeProfessionMainCtrl:refreshSelectPanel()
    local l_isDirectoryLock = not self.lifeProMgr.CanOpenSystem(self.currentSelectDirectoryClassID)
    if l_isDirectoryLock then
        if self:tryToUnlockCurrentDirectory(false) then
            self.panel.Panel_Skill:SetActiveEx(false)
            self.panel.Panel_Natural:SetActiveEx(false)
            self.panel.Panel_Empty:SetActiveEx(true)
            return
        end
    end
    self.panel.Panel_Empty:SetActiveEx(false)
    if self.currentShowDirectory == self.skillDirectory then
        self.panel.Panel_Skill:SetActiveEx(true)
        self.panel.Panel_Natural:SetActiveEx(false)
        self:refreshSkillPanel()
    else
        self.panel.Panel_Skill:SetActiveEx(false)
        self.panel.Panel_Natural:SetActiveEx(true)
        self:refreshNaturalPanel()
    end
end
function LifeProfessionMainCtrl:refreshNaturalPanel()
    local l_gatDatas = TableUtil.GetGatheringTable().GetTable()
    local l_gatType = 0
    local ClassID = self.lifeProMgr.ClassID
    local l_isSystemOpen = false
    ---@type ModuleMgr.OpenSystemMgr
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")

    if self.currentSelectDirectoryClassID == ClassID.Gather then
        --采集
        l_gatType = 1
        l_isSystemOpen = l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.LifeProfessionGather)
    elseif self.currentSelectDirectoryClassID == ClassID.Mining then
        --挖矿
        l_gatType = 2
        l_isSystemOpen = l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.LifeProfessionMining)
    elseif self.currentSelectDirectoryClassID == ClassID.Fish then
        --钓鱼
        l_gatType = 3
        l_isSystemOpen = l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.LifeProfessionFish)
    end
    self.panel.Panel_Empty:SetActiveEx(not l_isSystemOpen)
    self.panel.Panel_Natural:SetActiveEx(l_isSystemOpen)
    if not l_isSystemOpen then
        return
    end
    local l_datas = {}
    for i = 1, #l_gatDatas do
        local l_tempGatData = l_gatDatas[i]
        if l_tempGatData.SupportNav and l_tempGatData.Type == l_gatType then
            table.insert(l_datas, {
                ID = l_tempGatData.ID,
                IsShowCount = false,
                gatherData = l_tempGatData,
            })
        end
    end

    table.sort(l_datas, function(a, b)
        local l_aLengt = math.min(1, string.len(a.gatherData.DescShort))
        local l_bLenght = math.min(1, string.len(b.gatherData.DescShort))
        if l_aLengt > l_bLenght then
            return true
        elseif l_aLengt == l_bLenght then
            return a.gatherData.ID < b.gatherData.ID
        else
            return false
        end
    end)
    self.lifeProfessionGatherPropPool:ShowTemplates({ Datas = l_datas })
end
function LifeProfessionMainCtrl:refreshSkillPanel()
    local l_openSysItem = TableUtil.GetOpenSystemTable().GetRowById(self.currentSelectDirectoryClassID)
    if MLuaCommonHelper.IsNull(l_openSysItem) then
        return
    end
    self.panel.Txt_SkillTitle.LabText = l_openSysItem.Title
    self.panel.Txt_SkillTitleDesc.LabText = self.lifeProMgr.GetProfessionDescByClassID(self.currentSelectDirectoryClassID)
    local l_isLock = self.lifeProMgr.IsLifeSkillLock(self.currentSelectDirectoryClassID)
    if not l_isLock then
        local l_systemOpen = self.lifeProMgr.CanOpenSystem(self.currentSelectDirectoryClassID)
        self.panel.Panel_Empty:SetActiveEx(not l_systemOpen)
        self.panel.Panel_Skill:SetActiveEx(l_systemOpen)
        if not l_systemOpen then
            return
        end
    end
    self:refreshSkillProductInfo()
    local l_isLock = self.lifeProMgr.IsLifeSkillLock(self.currentSelectDirectoryClassID)
    self.panel.Panel_LevelUp:SetActiveEx(not l_isLock)
    self.panel.Panel_UnlockShow:SetActiveEx(l_isLock)
    if l_isLock then
        self:refreshLifeSkillLockInfo()
    else
        self:refreshLifeSkillDetailInfo(l_openSysItem)
    end
end

function LifeProfessionMainCtrl:refreshLifeSkillLockInfo()
    local l_unlockParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            1, self.lifeProMgr.ELevelUpConditionType.Task)
    if l_unlockParam == -1 then
        return
    end
    local l_canGetTask = self.lifeProMgr.CanGetUnlockLifeSkillTask(l_unlockParam)
    self.panel.Btn_Unlock:SetGray(not l_canGetTask)
    local l_acceptTaskLimits = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptLifeSkillLimited(l_unlockParam)
    self.panel.Obj_UnlockCondition:SetActiveEx(false)
    self.panel.Obj_UnlockCondition1:SetActiveEx(false)
    self.panel.Obj_UnlockCondition2:SetActiveEx(false)
    local l_tempTaskLimit = l_acceptTaskLimits[1]
    if l_tempTaskLimit ~= nil then
        self.panel.Obj_UnlockCondition:SetActiveEx(true)
        self.panel.Txt_LevelName.LabText = self.lifeProMgr.GetClassName(l_tempTaskLimit.ID)
        self.panel.Txt_Level.LabText = Lang("LifeProfession_LvUpRequirement", l_tempTaskLimit.level)
    end
    l_tempTaskLimit = l_acceptTaskLimits[2]
    if l_tempTaskLimit ~= nil then
        self.panel.Obj_UnlockCondition1:SetActiveEx(true)
        self.panel.Txt_LevelName1.LabText = self.lifeProMgr.GetClassName(l_tempTaskLimit.ID)
        self.panel.Txt_Level1.LabText = Lang("LifeProfession_LvUpRequirement", l_tempTaskLimit.level)
    end
    l_tempTaskLimit = l_acceptTaskLimits[3]
    if l_tempTaskLimit ~= nil then
        self.panel.Obj_UnlockCondition2:SetActiveEx(true)
        self.panel.Txt_LevelName2.LabText = self.lifeProMgr.GetClassName(l_tempTaskLimit.ID)
        self.panel.Txt_Level2.LabText = Lang("LifeProfession_LvUpRequirement", l_tempTaskLimit.level)
    end
end
---@param fromDataChange boolean @descripe 来自数据变化导致的属性
function LifeProfessionMainCtrl:refreshLifeSkillDetailInfo(openSystemItem, fromDataChange)
    local l_lifeSkillLv = self.lifeProMgr.GetLv(self.currentSelectDirectoryClassID)
    local l_levelUpRoleBaseLevelConditionParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            l_lifeSkillLv + 1, self.lifeProMgr.ELevelUpConditionType.RoleLevel)
    if l_levelUpRoleBaseLevelConditionParam ~= -1 and MPlayerInfo.Lv < l_levelUpRoleBaseLevelConditionParam then
        self.panel.Img_LevelUpLevelLimit:SetActiveEx(true)
        self.panel.Panel_SkillDetailInfo:SetActiveEx(false)
        self.panel.Txt_LevelUpLevelLimit.LabText = Lang("NEED_BASE_LEVEL_TIPS", l_levelUpRoleBaseLevelConditionParam)
    else
        self.panel.Panel_SkillDetailInfo:SetActiveEx(true)
        self.panel.Img_LevelUpLevelLimit:SetActiveEx(false)
    end
    self.panel.Txt_LifeSkillLevelDesc.LabText = Lang("LEVEL_LABEL", openSystemItem.Title)
    self.curLifeSkillLv = l_lifeSkillLv

    self:refreshLifeSkillChanceInfo()

    local l_priceParam = self.lifeProMgr.GetLevelUpLifeSkillParamByType(self.currentSelectDirectoryClassID,
            self.curLifeSkillLv + 1, self.lifeProMgr.ELevelUpConditionType.Price)
    self:refreshLifeSkillLevelUpCostProp(l_priceParam)
end
function LifeProfessionMainCtrl:refreshLifeSkillChanceInfo()
    local l_nextLevel, l_levelupNeedExp, l_addExpPerReq = self.lifeProMgr.GetNextLevelInfo(self.currentSelectDirectoryClassID)
    local l_isMaxLevel = l_nextLevel == -1

    local l_sucRate, l_bigSucRate, l_bigSucRewardMinRate, l_bigSucRewardMaxRate = self.lifeProMgr.GetLifeSkillRateInfoByLevel(
            self.currentSelectDirectoryClassID, self.curLifeSkillLv)
    if l_sucRate == nil then
        logWarn("curent level rate Info is null!")
        return
    end
    if l_isMaxLevel then
        self.panel.Txt_SkillProgress.LabText = "MAX"
        self:setLifeSkillProgressBar(1, 1)
        self.panel.Btn_LevelUp:SetActiveEx(false)
        self.panel.Txt_LifeSkillLevelRight.LabText = Lang("Level", self.curLifeSkillLv)
        self.panel.Txt_SucChanceSingle.LabText = StringEx.Format("{0}%", l_sucRate)
        self.panel.Txt_BigSucChanceSingle.LabText = StringEx.Format("{0}%", l_bigSucRate)
        self.panel.Txt_SucChanceSingle:SetActiveEx(true)
        self.panel.Txt_BigSucChanceSingle:SetActiveEx(true)
        self.panel.Txt_BigSucRewardSingle:SetActiveEx(l_bigSucRewardMinRate ~= -1)
        self.panel.Txt_SucChanceLeft:SetActiveEx(false)
        self.panel.Txt_BigSucChanceLeft:SetActiveEx(false)
        self.panel.Txt_BigSucRewardLeft:SetActiveEx(false)
        self.panel.Txt_SucChanceRight:SetActiveEx(false)
        self.panel.Txt_BigSucChanceRight:SetActiveEx(false)
        self.panel.Txt_BigSucRewardRight:SetActiveEx(false)
        self.panel.Txt_LifeSkillLevelLeft:SetActiveEx(false)
        self.panel.Obj_ChengGongLv:SetActiveEx(l_bigSucRewardMinRate ~= -1)
        if l_bigSucRewardMinRate == l_bigSucRewardMaxRate then
            self.panel.Txt_BigSucRewardSingle.LabText = StringEx.Format("x{0}", l_bigSucRewardMinRate)
        else
            self.panel.Txt_BigSucRewardSingle.LabText = StringEx.Format("x{0}~{1}", l_bigSucRewardMinRate, l_bigSucRewardMaxRate)
        end
    else
        self.curExp = self.lifeProMgr.GetExp(self.currentSelectDirectoryClassID)
        self.panel.Txt_SkillProgress.LabText = StringEx.Format("{0}/{1}", self.curExp, l_levelupNeedExp)
        self:setLifeSkillProgressBar(self.curExp / l_levelupNeedExp, (self.curExp + l_addExpPerReq) / l_levelupNeedExp)
        self.panel.Btn_LevelUp:SetActiveEx(true)
        self.panel.Txt_SucChanceLeft.LabText = StringEx.Format("{0}%", l_sucRate)
        self.panel.Txt_BigSucChanceLeft.LabText = StringEx.Format("{0}%", l_bigSucRate)
        self.panel.Txt_BigSucRewardLeft:SetActiveEx(l_bigSucRewardMinRate ~= -1)
        self.panel.Txt_SucChanceLeft:SetActiveEx(true)
        self.panel.Txt_BigSucChanceLeft:SetActiveEx(true)

        if l_bigSucRewardMinRate == l_bigSucRewardMaxRate then
            self.panel.Txt_BigSucRewardLeft.LabText = StringEx.Format("x {0}", l_bigSucRewardMinRate)
        else
            self.panel.Txt_BigSucRewardLeft.LabText = StringEx.Format("x {0}~{1}", l_bigSucRewardMinRate, l_bigSucRewardMaxRate)
        end
        self.panel.Txt_LifeSkillLevelLeft:SetActiveEx(true)
        self.panel.Txt_LifeSkillLevelRight.LabText = Lang("Level", self.curLifeSkillLv + 1)
        self.panel.Txt_LifeSkillLevelLeft.LabText = Lang("Level", self.curLifeSkillLv)
        local l_nextSucRate, l_nextBigSucRate, l_nextBigSucRewardMinRate, l_nextBigSucRewardMaxRate = self.lifeProMgr.GetLifeSkillRateInfoByLevel(self.currentSelectDirectoryClassID, self.curLifeSkillLv + 1)
        if l_nextSucRate ~= nil and l_nextLevel > 1 then
            local l_bigRewardRateChanged = l_bigSucRewardMinRate ~= l_nextBigSucRewardMinRate
                    or l_bigSucRewardMaxRate ~= l_nextBigSucRewardMaxRate

            self.panel.Txt_SucChanceSingle:SetActiveEx(l_nextSucRate == l_sucRate)
            self.panel.Txt_BigSucChanceSingle:SetActiveEx(l_nextBigSucRate == l_bigSucRate)
            self.panel.Txt_BigSucRewardSingle:SetActiveEx(l_nextBigSucRewardMinRate ~= -1 and not l_bigRewardRateChanged)
            self.panel.Txt_SucChanceRight:SetActiveEx(l_nextSucRate ~= l_sucRate)
            self.panel.Txt_BigSucChanceRight:SetActiveEx(l_nextBigSucRate ~= l_bigSucRate)
            self.panel.Txt_BigSucRewardRight:SetActiveEx(l_nextBigSucRewardMinRate ~= -1 and l_bigRewardRateChanged)

            self.panel.Txt_SucChanceRight.LabText = StringEx.Format("{0}%", l_nextSucRate)
            self.panel.Txt_SucChanceSingle.LabText = self.panel.Txt_SucChanceRight.LabText
            self.panel.Txt_BigSucChanceRight.LabText = StringEx.Format("{0}%", l_nextBigSucRate)
            self.panel.Txt_BigSucChanceSingle.LabText = self.panel.Txt_BigSucChanceRight.LabText

            self.panel.Obj_ChengGongLv:SetActiveEx(l_nextBigSucRewardMinRate ~= -1)
            if l_nextBigSucRewardMinRate == l_nextBigSucRewardMaxRate then
                self.panel.Txt_BigSucRewardRight.LabText = StringEx.Format("x {0}", l_nextBigSucRewardMinRate)
            else
                self.panel.Txt_BigSucRewardRight.LabText = StringEx.Format("x {0}~{1}", l_nextBigSucRewardMinRate, l_nextBigSucRewardMaxRate)
            end
            self.panel.Txt_BigSucRewardSingle.LabText = self.panel.Txt_BigSucRewardRight.LabText
        end
    end
end
function LifeProfessionMainCtrl:refreshSkillProductInfo()
    local l_RecipeId = self.lifeProMgr.GetRowRecipeIDByLv(self.currentSelectDirectoryClassID)
    local l_RecipeRows = self.lifeProMgr.GetRecipeRaws(self.currentSelectDirectoryClassID)
    local l_recipeDatas = {}
    for i = 1, #l_RecipeRows do
        local l_tempRecipeRow = l_RecipeRows[i]
        local l_lock = not self.lifeProMgr.CanRecipeActive(l_RecipeId, l_tempRecipeRow)
        local l_lockLv = self.lifeProMgr.CanRecipeLockLv(l_tempRecipeRow)
        local l_d = {
            data = l_tempRecipeRow,
            lock = l_lock,
            lockLv = l_lockLv,
            onClick = function(clickPos, recipeItem)
                self:refreshSkillProductTips(clickPos, recipeItem)
            end
        }
        table.insert(l_recipeDatas, l_d)
    end

    table.sort(l_recipeDatas, function(a, b)
        if not a.lock and b.lock then
            return true
        elseif a.lock == b.lock then
            if a.lockLv < b.lockLv then
                return true
            elseif a.lockLv == b.lockLv then
                if a.data.ID < b.data.ID then
                    return true
                end
            end
        end
        return false
    end)
    self.lifeSkillProductPool:ShowTemplates({ Datas = l_recipeDatas })

end
function LifeProfessionMainCtrl:refreshLifeSkillLevelUpCostProp(levelUpPriceParam)
    if levelUpPriceParam == -1 then
        self.panel.Panel_CostProp:SetActiveEx(false)
        return
    end
    ---@type CraftingSkillLvUpPriceTable
    local l_levelUpPriceItem = TableUtil.GetCraftingSkillLvUpPriceTable().GetRowByID(levelUpPriceParam)
    if MLuaCommonHelper.IsNull(l_levelUpPriceItem) then
        self.panel.Panel_CostProp:SetActiveEx(false)
        return
    end

    self.panel.Panel_CostProp:SetActiveEx(true)

    self.lifeSkillCostPropItem1 = self:refreshLevelUpCostProp(l_levelUpPriceItem.NormalPriceMain[0],l_levelUpPriceItem.NormalPriceMain[1],
            self.lifeSkillCostPropItem1,self.panel.Img_CostProp1.Transform)
    self.lifeSkillCostPropItem2 = self:refreshLevelUpCostProp(l_levelUpPriceItem.NormalPriceSub[0],l_levelUpPriceItem.NormalPriceSub[1],
        self.lifeSkillCostPropItem2,self.panel.Img_CostProp2.Transform)
end

---@param costPropTem BaseUITemplate
---@param parentTransform UnityEngine.Transform 
function LifeProfessionMainCtrl:refreshLevelUpCostProp(propId,requireCount,costPropTem,parentTransform)
    if propId == 0 then
        parentTransform.gameObject:SetActiveEx(false)
        return costPropTem
    end

    local l_priceData = {
        ID = propId,
        IsShowRequire = true,
        RequireCount = requireCount,
        IsShowCount = false,
    }
    parentTransform.gameObject:SetActiveEx(true)
    if MLuaCommonHelper.IsNull(costPropTem) then
        costPropTem = self:NewTemplate("ItemTemplate", {
            TemplateParent = parentTransform,
            Data = l_priceData
        })
    else
        costPropTem:SetData(l_priceData)
    end
    return costPropTem
end
---@param recipeItem RecipeTable
function LifeProfessionMainCtrl:refreshSkillProductTips(clickPos, recipeItem)
    if MLuaCommonHelper.IsNull(recipeItem) then
        return
    end
    self.panel.Panel_SkillProductTip:SetActiveEx(true)
    local _, l_localAnchorePos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Panel_SkillProductTip.RectTransform,
            clickPos, MUIManager.UICamera, nil)
    l_localAnchorePos.x = l_localAnchorePos.x - self.panel.Obj_SkillProductTip.RectTransform.rect.width / 2
    l_localAnchorePos.y = l_localAnchorePos.y - self.panel.Obj_SkillProductTip.RectTransform.rect.height / 2
    self.panel.Obj_SkillProductTip.RectTransform.anchoredPosition = l_localAnchorePos

    self.panel.Txt_SkillProductName.LabText = recipeItem.Name
    self.panel.Txt_SkillProductDesc.LabText = recipeItem.DescShort
    self.panel.Img_SkillProductIcon:SetSpriteAsync(recipeItem.Atlas, recipeItem.Icon, nil, true)

    --材料列表
    local l_ingredients = Common.Functions.VectorSequenceToTable(recipeItem.Ingredients)
    local l_datas = {}
    for i = 1, #l_ingredients do
        l_datas[#l_datas + 1] = {
            ID = l_ingredients[i][1],
            IsShowRequire = true,
            RequireCount = l_ingredients[i][2],
            IsShowCount = false,
        }
    end
    --元气值消耗
    if recipeItem.Stamina then
        l_datas[#l_datas + 1] = {
            ID = MgrMgr:GetMgr("PropMgr").l_virProp.Yuanqi,
            IsShowRequire = true,
            RequireCount = recipeItem.Stamina,
            IsShowCount = false,
        }
    end
    self.lifeSkillProductCostPool:ShowTemplates({ Datas = l_datas })
end
--endregion refresh
--lua custom scripts end
return LifeProfessionMainCtrl