--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RefinePanel"
require "UI/Template/RefineEquipTemplate"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
local C_FULL_RATE = 0.01
RefineCtrl = class("RefineCtrl", super)
--lua class define end

--lua functions
function RefineCtrl:ctor()
    super.ctor(self, CtrlNames.Refine, UILayer.Function, nil, ActiveType.Exclusive)
    self.IsGroup = true
end --func end
--next--
function RefineCtrl:Init()
    self.panel = UI.RefinePanel.Bind(self)
    super.Init(self)
    self.showButtonTimer = 0
    self.isShowButton = true
    ---@type ItemData
    self.currentEquipData = nil
    self.currentEquipRefineTableInfo = nil
    self.currentBlessingIndex = 0
    self._isRequestEquipRepair = false
    self._isRequestEquipRefine = false
    self.l_RefineProbabilityShow = MGlobalConfig:GetVectorSequence("RefineProbabilityShow")
    self.l_RefineCD = MGlobalConfig:GetFloat("RefineCD")

    self._animationTableInfo = TableUtil.GetAnimationTable().GetRowByID(3000)
    self._animationTime = self._animationTableInfo.MaxTime
    self._refineEffectId = 100096
    self._showAnimationTimer = 0
    self._isShowAnimation = false

    self._isSafeRefine = false

    self:_initTemplateConfig()
    self:_initWidgets()

    self.panel.RemoveEquipButton:SetActiveEx(false)
    self.panel.RefineMask:SetActiveEx(false)
    self:initialize()
    self:showRefine()
    self._selectEquipTemplate = self:NewTemplate("SelectEquipTemplate", {
        TemplateParent = self.panel.SelectEquipParent.Transform,
    })
end --func end
--next--
function RefineCtrl:Uninit()
    self.MaterialPropInfoID = nil
    self.currentEquipData = nil
    self.currentEquipRefineTableInfo = nil
    self.l_RefineProbabilityShow = nil
    self.itemPool = nil
    self.blessingItem = nil
    self.equipItem = nil
    self._selectEquipTemplate = nil
    self.showButtonTimer = 0
    self.isShowButton = true
    MPlayerInfo:FocusToMyPlayer()
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function RefineCtrl:OnActive()
    self._isShowAnimation = false
    self._showAnimationTimer = 0
    self._isRequestEquipRepair = false
    self._isRequestEquipRefine = false
    self._selectEquipTemplate:SetData({
        SelectEquipMgrName = "RefineMgr",
        NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position,
        ShowHeight = 524
    })
    self.panel.TextExplain.LabText = Common.Utils.Lang("REFINE_SAFE_EXPLAIN")
    MEventMgr:LuaFireEvent(MEventType.MEvent_HideTargetFx, MEntityMgr.PlayerEntity)
    MVirtualTab:Clear()
    MPlayerInfo:FocusToOrnamentBarter(MgrMgr:GetMgr("NpcMgr").CurrentNpcId, -5.1, 4.4, 0.8, 2.1, 11, 31)
    self.showButtonTimer = 0
    self.isShowButton = true
    --新手指引相关
    local l_beginnerGuideChecks = { "Refine" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
end --func end
--next--
function RefineCtrl:OnDeActive()
    MEventMgr:LuaFireEvent(MEventType.MEvent_ShowTargetFx, MEntityMgr.PlayerEntity)
end --func end

function RefineCtrl:OnShow()
    self.panel.SelectEquipParent:SetActiveEx(true)
end

function RefineCtrl:OnHide()
    self.panel.SelectEquipParent:SetActiveEx(false)
end

--next--
function RefineCtrl:Update()
    if self.isShowButton == nil then
        return
    end

    if not self.isShowButton then
        self.showButtonTimer = self.showButtonTimer + Time.deltaTime
        if self.showButtonTimer > self.l_RefineCD then
            self.isShowButton = true
            self.panel.RefineEquipButton.Btn.enabled = true
            self.panel.RefineEquipButton:SetGray(false)
            self.showButtonTimer = 0
        end
    end

    if self._isShowAnimation then
        self._showAnimationTimer = self._showAnimationTimer + Time.deltaTime
        if self._showAnimationTimer > self._animationTime then
            self:_onAnimationFinish()
            self._showAnimationTimer = 0
        end
    end
end --func end

--next--
function RefineCtrl:OnReconnected()
    super.OnReconnected(self)
    self._selectEquipTemplate:OnReconnected()
    local l_npcEntity = MNpcMgr:FindNpcInViewport(MgrMgr:GetMgr("NpcMgr").CurrentNpcId)
    if l_npcEntity then
        l_npcEntity.Model.Layer = MLayer.ID_NPC_DEPTH
    end

    self._isRequestEquipRepair = false
    self._isRequestEquipRefine = false
end --func end
--next--
function RefineCtrl:BindEvents()
    --点击装备显示装备信息
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, self.OnEquipItemButton)
    --当道具数据变化时更新红点和需要材料信息
    self:BindEvent(MgrMgr:GetMgr("GameEventMgr").l_eventDispatcher, MgrMgr:GetMgr("GameEventMgr").OnBagUpdate, self._refreshPage)
    self:BindEvent(MgrMgr:GetMgr("GameEventMgr").l_eventDispatcher, MgrMgr:GetMgr("GameEventMgr").OnRefineReconnected, self.OnReconnected)
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isShow)
        self.panel.MainPanel.gameObject:SetActiveEx(isShow)
    end)
    self:BindEvent(MgrMgr:GetMgr("RefineMgr").EventDispatcher, MgrMgr:GetMgr("RefineMgr").ReceiveEquipRepairEvent, function(self, data)
        self._isRequestEquipRepair = false
    end)
    self:BindEvent(MgrMgr:GetMgr("RefineMgr").EventDispatcher, MgrMgr:GetMgr("RefineMgr").ReceiveEquipRefineUpgradeEvent, function(self, data)
        self._isRequestEquipRefine = false
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function RefineCtrl:_initTemplateConfig()
    self._currentAttrsConfig = {
        TemplateClassName = "RefineAttr",
        TemplateParent = self.panel.DummyCurrentAttr.transform,
        TemplatePath = "UI/Prefabs/RefineAttr",
    }

    self._nextLvAttrsConfig = {
        TemplateClassName = "RefineAttr",
        TemplateParent = self.panel.DummyCurrentNextAttr.transform,
        TemplatePath = "UI/Prefabs/RefineAttr",
    }
end

function RefineCtrl:_initWidgets()
    self._currentAttrs = self:NewTemplatePool(self._currentAttrsConfig)
    self._nextLvAttrs = self:NewTemplatePool(self._nextLvAttrsConfig)
end

function RefineCtrl:_refreshPage()
    if nil == self.currentEquipData then
        return
    end

    self:showEquipDetails(self.currentEquipData)
    self._selectEquipTemplate:RefreshSelectEquip()
    self:showSuccessRate(self.currentEquipData.RefineAdditionalRate)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.RefinePanel.transform)
end

function RefineCtrl:initialize()
    --关闭整个界面
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Refine)
    end)

    self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    self.panel.ShowExplainPanelButton:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(true)
    end)

    self.panel.CloseExplainPanelButton:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    end)

    --关闭选择祝福道具面板
    self.panel.BlessingPanelCloseButton:AddClick(function()
        self.panel.BlessingPanel.gameObject:SetActiveEx(false)
    end)

    local l_refineFunc = nil
    l_refineFunc = function(isNotCheck)
        local l_isMatEnough, l_totalCost = self:isMaterialsEnough()
        if l_isMatEnough then
            if not self:IsSeal() then
                return
            end

            --以下处理货币的快捷兑换
            if l_totalCost and l_totalCost > 0 then
                local _, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101, l_totalCost)
                if l_needNum > 0 and not isNotCheck then
                    MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101, l_needNum, function()
                        l_refineFunc(true)
                    end)
                    return
                end
            end

            --不安全精炼并且成功率不是百分百
            if (not self._isSafeRefine) and not self:_isCurLevelSafe() then
                local l_dateStrSave = UserDataManager.GetStringDataOrDef("Refine_FirstRefine", MPlayerSetting.PLAYER_SETTING_GROUP, "")
                if string.ro_isEmpty(tostring(l_dateStrSave)) then
                    CommonUI.Dialog.ShowYesNoDlg(
                            true, nil,
                            Lang("Refine_DetermineText"),
                            function()
                                self:_refineEquip()
                                UserDataManager.SetDataFromLua("Refine_FirstRefine", MPlayerSetting.PLAYER_SETTING_GROUP, "Refine_FirstRefine")
                            end
                    )
                else
                    self:_refineEquip()
                end
            else
                self:_refineEquip()
            end
        else
            if self.MaterialPropInfoID ~= nil then
                local itemData = Data.BagModel:CreateItemWithTid(self.MaterialPropInfoID)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            end
        end
    end

    --点击精炼
    self.panel.RefineEquipButton:AddClick(function()
        l_refineFunc()
    end)

    --点击修复
    self.panel.RepairEquipButton:AddClick(function()
        local l_restoreConsume = self.currentEquipRefineTableInfo.RestoreConsume
        for i = 1, l_restoreConsume.Length do
            local l_ID = l_restoreConsume[i - 1][0]
            local l_RequireCount = l_restoreConsume[i - 1][1]
            local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_ID)
            if l_currentCount < l_RequireCount then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_ID, nil, nil, nil, true)
                return
            end
        end

        if self._isRequestEquipRepair or self._isRequestEquipRefine then
            return
        end

        self._isRequestEquipRepair = true
        MgrMgr:GetMgr("RefineMgr").RequestEquipRepair(self.currentEquipData.UID)
    end)

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })

    self.equipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.CurrentEquipItemParent.transform })

    --祝福石相关的
    self.blessingItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.BlessingItemParent.transform })

    self.panel.BlessingItemParent.gameObject:SetActiveEx(false)

    self.panel.CommonRefineButtonOff:AddClick(function()
        self._isSafeRefine = false
        self:showBlessing()
    end)

    self.panel.SafeRefineButtonOff:AddClick(function()
        self._isSafeRefine = true
        self:showBlessing()
    end)
end

function RefineCtrl:showBlessing()
    if self.currentEquipData == nil then
        return
    end

    self.panel.CommonRefineButtonOn:SetActiveEx(false)
    self.panel.CommonRefineButtonOff:SetActiveEx(false)
    self.panel.SafeRefineButtonOn:SetActiveEx(false)
    self.panel.SafeRefineButtonOff:SetActiveEx(false)

    if self._isSafeRefine then
        if self:_isCurLevelSafe() then
            self:removeBlessingItem()
        else
            self:onSelectBlessingItem(1)

            self.panel.CommonRefineButtonOff:SetActiveEx(true)
            self.panel.SafeRefineButtonOn:SetActiveEx(true)
        end
    else
        self:removeBlessingItem()
        if not self:_isCurLevelSafe() then
            self.panel.CommonRefineButtonOn:SetActiveEx(true)
            self.panel.SafeRefineButtonOff:SetActiveEx(true)
        end
        self:showSuccessRate(self.currentEquipData.RefineAdditionalRate)
    end
end

function RefineCtrl:removeBlessingItem()
    self.panel.BlessingItemParent.gameObject:SetActiveEx(false)
    self.currentBlessingIndex = 0
    self.panel.RefineEquipButtonText.LabText = Common.Utils.Lang("EQUIP_REFINING")
    self._isSafeRefine = false
end


--显示成功率
function RefineCtrl:showSuccessRate(serverSuccessRate)
    if self.currentEquipRefineTableInfo == nil then
        return
    end

    local configShowRate = self.currentEquipRefineTableInfo.ShowRate * C_FULL_RATE
    local additionalRate = serverSuccessRate
    local l_rateText = tostring(configShowRate) .. "%"
    if (additionalRate > 0) and (self._isSafeRefine == false) then
        l_rateText = l_rateText .. " + " .. tostring(additionalRate) .. "%"
    end

    self.panel.SuccessRate.LabText = StringEx.Format(Common.Utils.Lang("Refine_SuccessRateText"), l_rateText)
    if self.currentEquipRefineTableInfo.FailureResultRate[2] <= 0 then
        self.panel.Buttons.gameObject:SetActiveEx(false)
        self.panel.RefinePropertyPanel.gameObject:SetRectTransformPosY(-38)
        self:removeBlessingItem()
    else
        self.panel.Buttons.gameObject:SetActiveEx(true)
        self.panel.RefinePropertyPanel.gameObject:SetRectTransformPosY(0)
    end
end

function RefineCtrl:_refineEquip()
    if self._isRequestEquipRepair or self._isRequestEquipRefine then
        return
    end

    self._isRequestEquipRefine = true
    local l_npcEntity = MNpcMgr:FindNpcInViewport(MgrMgr:GetMgr("NpcMgr").CurrentNpcId)
    if l_npcEntity then
        MEventMgr:LuaFireEvent(MEventType.MEvent_Special, l_npcEntity, ROGameLibs.kEntitySpecialType_Action, self._animationTableInfo.ID)
        MgrMgr:GetMgr("TransmissionMgr").ShowEffectWithPlayerEntity(l_npcEntity, self._refineEffectId, MLayer.ID_NPC_DEPTH)
    end

    self.panel.RefineMask:SetActiveEx(true)
    self._isShowAnimation = true
    self.isShowButton = false
    self.panel.RefineEquipButton.Btn.enabled = false
    self.panel.RefineEquipButton:SetGray(true)
end

function RefineCtrl:_onAnimationFinish()
    MgrMgr:GetMgr("RefineMgr").RequestEquipRefineUpgrade(self.currentEquipData.UID, self.currentBlessingIndex)
    self._isShowAnimation = false
    self.panel.RefineMask:SetActiveEx(false)
end

function RefineCtrl:showRefine()
    self:onCancelSelectEquip()
end
--当没选择装备时很多东西会隐藏
function RefineCtrl:onCancelSelectEquip()
    self.panel.LevelMaxPanel:SetActiveEx(false)
    self.panel.RefinePanel:SetActiveEx(false)
    self.panel.RepairPanel:SetActiveEx(false)
    self.panel.RefineName.transform.parent.gameObject:SetActiveEx(false)
    self.panel.SelectEquipButton:SetActiveEx(true)
    self.equipItem:SetGameObjectActive(false)
    self.panel.NonSelectPanel:SetActiveEx(true)
end

--点击选择装备后的显示
function RefineCtrl:OnEquipItemButton(data)
    if self.currentEquipData == data then
        return
    end

    self.currentEquipData = data
    self.panel.RefineName.transform.parent.gameObject:SetActiveEx(true)
    self.panel.SelectEquipButton.gameObject:SetActiveEx(false)
    self.panel.NonSelectPanel.gameObject:SetActiveEx(false)
    self:showEquipDetails(self.currentEquipData)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.RefinePanel.transform)
end

---@param equipData ItemData
function RefineCtrl:showEquipDetails(equipData)
    if equipData == nil then
        return
    end

    local isDisrepair = equipData.Damaged
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(equipData.TID)
    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(equipData.TID)
    local refineMaxLevel = equipTableInfo.RefineMaxLv
    local currentRefineLevel = equipData.RefineLv
    local nextRefineLevel = currentRefineLevel + 1
    if nextRefineLevel > refineMaxLevel then
        nextRefineLevel = refineMaxLevel
    end

    self.currentEquipRefineTableInfo = MgrMgr:GetMgr("RefineMgr").GetEquipRefineTable(equipTableInfo.RefineBaseAttributes, currentRefineLevel)
    if self.currentEquipRefineTableInfo == nil then
        return
    end

    self.equipItem:SetData({ PropInfo = equipData, IsShowCount = false, IsShowTips = true })
    local l_nameText = itemTableInfo.ItemName
    if currentRefineLevel > 0 then
        l_nameText = l_nameText .. "+" .. tostring(currentRefineLevel)
    end

    self.panel.RefineName.LabText = l_nameText
    local l_currentAttr = self.currentEquipRefineTableInfo.RefineAttr[0]
    local attrInfo = TableUtil.GetAttrDecision().GetRowById(l_currentAttr[1])
    local showType = attrInfo.TipParaEnum
    local propertyName = StringEx.Format(attrInfo.TipTemplate, "") .. "："
    local currentCount
    if showType == MgrMgr:GetMgr("ItemPropertiesMgr").AttrShowTypePercent then
        currentCount = MgrMgr:GetMgr("ItemPropertiesMgr").GetPercentFormat(l_currentAttr[2] * currentRefineLevel)
    else
        currentCount = l_currentAttr[2]
    end

    --需修复
    if isDisrepair then
        self.panel.LevelMaxPanel.gameObject:SetActiveEx(false)
        self.panel.RefinePanel.gameObject:SetActiveEx(false)
        self.panel.RepairPanel.gameObject:SetActiveEx(true)
        self.panel.RepairLevel.LabText = StringEx.Format(Common.Utils.Lang("Refine_LevelDamaged"), currentRefineLevel)
        self.panel.RepairPropertyName.LabText = propertyName
        self.panel.RepairPropertyCount.LabText = tostring(currentCount)
        local s = self.currentEquipRefineTableInfo.RestoreConsume
        local restoreConsume = Common.Functions.VectorSequenceToTable(s)
        local itemDatas = {}
        for i = 1, #restoreConsume do
            local data = {}
            data.ID = restoreConsume[i][1]
            data.IsShowCount = false
            data.IsShowRequire = true
            data.RequireCount = restoreConsume[i][2]
            table.insert(itemDatas, data)
        end

        self.itemPool:ShowTemplates({ Datas = itemDatas, Parent = self.panel.RepairItemParent.transform })
    else
        self.panel.RepairPanel.gameObject:SetActiveEx(false)

        --精炼等级最大时
        if currentRefineLevel >= refineMaxLevel then
            self.panel.LevelMaxPanel.gameObject:SetActiveEx(true)
            self.panel.RefinePanel.gameObject:SetActiveEx(false)
            self.panel.MaxLevelText:SetActiveEx(true)
            self.panel.NextMaxLevelText:SetActiveEx(false)
            local l_equipConsumeTable = TableUtil.GetEquipConsumeTable().GetTable()
            for i = 1, #l_equipConsumeTable do
                if l_equipConsumeTable[i].TypeTab == itemTableInfo.TypeTab then
                    local l_nextRefineMaxLevel = 0
                    if l_nextRefineMaxLevel > refineMaxLevel then
                        self.panel.NextMaxLevelText.LabText = StringEx.Format(
                                Common.Utils.Lang("Refine_NextMaxLevelText"),
                                l_equipConsumeTable[i].EquipLevel, l_nextRefineMaxLevel)
                        self.panel.MaxLevelText:SetActiveEx(false)
                        self.panel.NextMaxLevelText:SetActiveEx(true)
                        break
                    end
                end
            end

            local data = MgrMgr:GetMgr("RefineMgr").GetAttrDescByRefineConfig(self.currentEquipRefineTableInfo)
            self:_refreshMaxAttrs(data)
            --可精炼
        else
            self.panel.LevelMaxPanel.gameObject:SetActiveEx(false)
            self.panel.RefinePanel.gameObject:SetActiveEx(true)

            local l_nextRefineTableInfo = MgrMgr:GetMgr("RefineMgr").GetEquipRefineTable(equipTableInfo.RefineBaseAttributes, nextRefineLevel)
            local l_nextAttr = l_nextRefineTableInfo.RefineAttr[0]
            local nextCount
            if showType == MgrMgr:GetMgr("ItemPropertiesMgr").AttrShowTypePercent then
                nextCount = MgrMgr:GetMgr("ItemPropertiesMgr").GetPercentFormat(l_nextAttr[2] * nextRefineLevel)
            else
                nextCount = l_nextAttr[2]
            end

            self:_showRefineCompareAttrs()

            local s = self.currentEquipRefineTableInfo.RefineConsume
            local refineConsume = Common.Functions.VectorSequenceToTable(s)
            local itemDatas = {}
            for i = 1, #refineConsume do
                local data = {}
                data.ID = refineConsume[i][1]
                data.IsShowCount = false
                data.IsShowRequire = true
                data.RequireCount = refineConsume[i][2]
                table.insert(itemDatas, data)
            end

            self.itemPool:ShowTemplates({ Datas = itemDatas, Parent = self.panel.RefineItemParent.transform })
            self.panel.BlessingItemParent.transform:SetSiblingIndex(100)
            self:onSelectBlessingItem(self.currentBlessingIndex)

            --被删掉的紫色：B270E0
            local safeLevelTxt = MgrMgr:GetMgr("RefineMgr").GetSafeTxtLevel(currentRefineLevel)
            if safeLevelTxt > 0 then
                self.panel.SafeText:SetActiveEx(true)
                self.panel.Txt_SafeHintNormal.LabText = Common.Utils.Lang("Refine_Safe_Tip", safeLevelTxt, safeLevelTxt)
            else
                self.panel.SafeText:SetActiveEx(false)
            end

            self:showBlessing()
        end
    end
end

---@param attrList RefineAttrParam[]
function RefineCtrl:_refreshMaxAttrs(attrList)
    self.panel.MaxPropertyName_0.gameObject:SetActiveEx(false)
    self.panel.MaxPropertyName_1.gameObject:SetActiveEx(false)
    self.panel.MaxPropertyName_2.gameObject:SetActiveEx(false)
    if nil == attrList then
        return
    end

    for i = 1, #attrList do
        local singleData = attrList[i]
        local singleName = self:_getMaxAttrNameByIdx(i)
        local singleNum = self:_getMaxAttrNumByIdx(i)
        if nil ~= singleName and nil ~= singleNum then
            singleName.gameObject:SetActiveEx(true)
            singleName.LabText = singleData.name
            singleNum.LabText = "+" .. tostring(singleData.value)
        end
    end
end

function RefineCtrl:_getMaxAttrNameByIdx(idx)
    if 1 == idx then
        return self.panel.MaxPropertyName_0
    elseif 2 == idx then
        return self.panel.MaxPropertyName_1
    elseif 3 == idx then
        return self.panel.MaxPropertyName_2
    else
        return nil
    end
end

function RefineCtrl:_getMaxAttrNumByIdx(idx)
    if 1 == idx then
        return self.panel.MaxPropertyCount_0
    elseif 2 == idx then
        return self.panel.MaxPropertyCount_1
    elseif 3 == idx then
        return self.panel.MaxPropertyCount_2
    else
        return nil
    end
end

function RefineCtrl:getRefineMaxLevel(equipConsumeTableinfo, equipId)
    if equipConsumeTableinfo == nil then
        return 0
    else
        local l_RefineMaxLv = equipConsumeTableinfo.RefineMaxLv
        for i = 1, l_RefineMaxLv.Length do
            if l_RefineMaxLv[i - 1][0] == equipId then
                return l_RefineMaxLv[i - 1][1]
            end
        end
    end

    return 0
end

--- 显示精炼的属性对比
function RefineCtrl:_showRefineCompareAttrs()
    if nil == self.currentEquipData then
        return
    end

    local currentAttrs, nextLvAttrs = MgrMgr:GetMgr("RefineMgr").GenItemRefineCompareData(self.currentEquipData)
    self._currentAttrs:ShowTemplates({ Datas = currentAttrs })
    self._nextLvAttrs:ShowTemplates({ Datas = nextLvAttrs })
end

function RefineCtrl:onSelectBlessingItem(index)
    self.currentBlessingIndex = index
    if nil ~= self.currentEquipData.RefineAdditionalRate then
        self:showSuccessRate(self.currentEquipData.RefineAdditionalRate)
    end

    if index == 0 then
        return
    end

    self.panel.RefineEquipButtonText.LabText = Common.Utils.Lang("Refine_BlessRefineText")
    self.panel.BlessingPanel.gameObject:SetActiveEx(false)
    if self.currentEquipRefineTableInfo ~= nil then
        local blessingTableData
        if index == 1 then
            blessingTableData = self.currentEquipRefineTableInfo.RollBack
        else
            blessingTableData = self.currentEquipRefineTableInfo.Beecham
        end
        local blessingData = Common.Functions.VectorSequenceToTable(blessingTableData)[1]
        self.blessingItem:SetData({ ID = blessingData[1], IsShowCount = false, IsShowRequire = true, RequireCount = blessingData[2] })
    end

    self.panel.BlessingItemParent.gameObject:SetActiveEx(true)
end

function RefineCtrl:isMaterialsEnough()
    if self.currentEquipRefineTableInfo == nil then
        return false
    end

    local s = self.currentEquipRefineTableInfo.RefineConsume
    local l_refineConsume = Common.Functions.VectorSequenceToTable(s)
    local l_titalCoinCount = 0
    for i = 1, #l_refineConsume do
        local l_id = l_refineConsume[i][1]
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_id)
        local l_requireCount = l_refineConsume[i][2]
        if l_currentCount < l_requireCount and l_id ~= GameEnum.l_virProp.Coin101 then
            self.MaterialPropInfoID = l_id
            return false
        end
        if l_currentCount < l_requireCount and l_id == GameEnum.l_virProp.Coin101 then
            l_titalCoinCount = l_requireCount
        end
    end

    local l_blessingTableData
    if self.currentBlessingIndex == 1 then
        l_blessingTableData = self.currentEquipRefineTableInfo.RollBack
    elseif self.currentBlessingIndex == 2 then
        l_blessingTableData = self.currentEquipRefineTableInfo.Beecham
    end

    if l_blessingTableData ~= nil then
        local l_blessingData = Common.Functions.VectorSequenceToTable(l_blessingTableData)[1]
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_blessingData[1])
        local l_requireCount = l_blessingData[2]
        if l_currentCount < l_requireCount and l_blessingData[1] ~= GameEnum.l_virProp.Coin101 then
            self.MaterialPropInfoID = l_blessingData[1]
            return false
        end
        if l_currentCount < l_requireCount and l_id == GameEnum.l_virProp.Coin101 then
            l_titalCoinCount = l_requireCount
        end
    end

    return true, l_titalCoinCount
end

-- 当前装备是否被封印
function RefineCtrl:IsSeal()
    local l_seal = self:_IsSeal()
    if not l_seal then
        return true
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil,
            Lang("REFINE_UNSEAL_CANNOT_REFINE"),
            function()
                MgrMgr:GetMgr("ShowEquipPanleMgr").OpenRefineUnsealPanle()
            end)

    return false
end

function RefineCtrl:_IsSeal()
    if self.currentEquipData == nil then
        return false
    end

    return self.currentEquipData.RefineSealLv > 0
end

function RefineCtrl:_showPropertyTips()
    if self.currentEquipRefineTableInfo == nil then
        return
    end

    local l_pointEventData = {}
    l_pointEventData.position = Input.mousePosition
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.currentEquipRefineTableInfo.AttrTips, l_pointEventData, Vector2(0.5, 0), false, nil, MUIManager.UICamera, true)
end

function RefineCtrl:_isCurLevelSafe()
    if self.currentEquipRefineTableInfo then
        return self.currentEquipRefineTableInfo.FailureResultRate[2] == 0
    end
    return false
end

return RefineCtrl
--lua custom scripts end
