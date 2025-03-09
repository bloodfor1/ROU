--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ForgePanel"
require "UI/Template/ForgeEquipTemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/ForgePropertyTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ForgeCtrl = class("ForgeCtrl", super)
--lua class define end

--lua functions
function ForgeCtrl:ctor()
    super.ctor(self, CtrlNames.Forge, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.IsGroup = true
end --func end
--next--
function ForgeCtrl:Init()
    self.panel = UI.ForgePanel.Bind(self)
    super.Init(self)

    self._forgeMgr = MgrMgr:GetMgr("ForgeMgr")
    self.currentEquipForgeData = nil
    self.currentEquipData = 0
    self.currentTipsData = nil
    self.currentEquipDatas = nil
    self._selectTypeDatas = {}
    self._equipModel = nil
    self._moduleForgeData = DataMgr:GetData("ForgeData")
    self:initialize()
end --func end
--next--
function ForgeCtrl:Uninit()
    self.equipTemplatePool = nil
    self.forgeMaterialTemplatePool = nil

    self.currentEquipDatas = nil
    self.currentEquipForgeData = nil
    self.currentEquipData = 0
    self.currentTipsData = nil
    self._forgeMgr = nil

    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function ForgeCtrl:OnActive()
    local l_beginnerGuideChecks = { "FoundryEquipment1" }
    if MGlobalConfig:GetInt("ForgeRookieRecommendGuide", 0) <= MPlayerInfo.Lv then
        l_beginnerGuideChecks = { "FoundryEquipment1", "FoundryEquipment2" }
    end

    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

    local isWeaponForge = self._forgeMgr.IsWeaponForge()
    self:_setForgeHint(isWeaponForge)
    self.panel.ShowEquipTypeTipsButton:SetActiveEx(isWeaponForge)
end --func end

--next--
function ForgeCtrl:OnDeActive()
    self._forgeMgr.CleanForgeData()
    if self._equipModel then
        self:DestroyUIModel(self._equipModel)
        self._equipModel = nil
    end

    local forgeSchoolRecommendMgr = MgrMgr:GetMgr("ForgeSchoolRecommendMgr")
    forgeSchoolRecommendMgr.ClearSelectedID()
end --func end
--next--
function ForgeCtrl:Update()
    -- do nothing
end --func end

--next--
function ForgeCtrl:BindEvents()
    --打造成功
    self:BindEvent(self._forgeMgr.EventDispatcher, self._forgeMgr.ForgeEquipSucceed,
    --equipData为服务端传过来的item
            function(selfa, itemData)
                self.currentTipsData = itemData
                self.equipTemplatePool:RefreshCells()
                self:showForgeMaterials(self.currentEquipForgeData)
            end, self)

    --当道具数据变化时更新红点和需要材料信息
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemUpdate)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.ForgeFiltrateSet, self.getLevelSelectButtons)
    self:BindEvent(self._forgeMgr.EventDispatcher, self._forgeMgr.ForgeTaskChangeEvent, self._showEquipTaskButton)
end --func end
--next--
--lua functions end

--lua custom scripts
function ForgeCtrl:_setForgeHint(isWeaponForge)
    if nil == isWeaponForge then
        return
    end

    local showHint, hintStr = self._forgeMgr.ShowHint(isWeaponForge)
    self.panel.Txt_ForgeLvHint.gameObject:SetActiveEx(showHint)
    self.panel.Txt_ForgeLvHint.LabText = hintStr
end

function ForgeCtrl:_onItemUpdate()
    if self._forgeMgr.CurrentSelectIndex == 0 then
        return
    end

    self.equipTemplatePool:RefreshCells()
    self:showForgeMaterials(self.currentEquipDatas[self._forgeMgr.CurrentSelectIndex])
end

function ForgeCtrl:initialize()

    self.equipTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ForgeEquipTemplate",
        TemplatePath = "UI/Prefabs/EquipItemPrefab",
        ScrollRect = self.panel.EquipItemScroll.LoopScroll
    })

    self.forgeMaterialTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.ForgeMaterialParent.transform
    })

    self._equipPropertiesTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ForgeEquipPropertyTemplate",
        TemplatePath = "UI/Prefabs/ForgeEquipPropertyPrefab",
        TemplateParent = self.panel.EquipPropertyParent.transform
    })

    self.panel.Btn_Tuijian:AddClick(self._onRecommendButtonClick)

    --点击打造按钮
    self.panel.ForgeEquipButton:AddClick(function()
        if self.currentEquipForgeData == nil then
            return
        end

        if MPlayerInfo.Lv < self.currentEquipForgeData.ForgeLevel then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("Forge_LevelNotEnough"), self.currentEquipForgeData.ForgeLevel))
            return
        end

        local l_forgeMaterials = self.currentEquipForgeData.ForgeMaterials
        local totalCost = 0
        for i = 1, l_forgeMaterials.Length do
            local forgeMaterial = l_forgeMaterials[i - 1]
            local id = forgeMaterial[0]
            local needCount = forgeMaterial[1]
            local currentCount = Data.BagModel:GetCoinOrPropNumById(id)
            totalCost = id == GameEnum.l_virProp.Coin101 and needCount or 0
            if currentCount < needCount and id ~= GameEnum.l_virProp.Coin101 then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(id, nil, nil, nil, true)
                return
            end
        end

        local id = self.currentEquipForgeData.Id
        local l_isHave = MgrMgr:GetMgr("BodyEquipMgr").IsEquipOnBodyOrBagWithId(self.currentEquipForgeData.Id)
        if l_isHave then
            CommonUI.Dialog.ShowYesNoDlg(
                    true, nil,
                    Lang("Forge_ForgeEquipTipsText"),
                    function()
                        self:_startForgeEquip(id,totalCost)
                    end, nil, nil, 4, "Forge_ForgeEquipIsHaveTipsShow")
        else
            self:_startForgeEquip(id,totalCost)
        end
    end)

    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Forge)
    end)

    self.panel.EquipReceiveTaskButton:AddClick(function()
        if self.currentEquipForgeData == nil then
            return
        end

        self._forgeMgr.RequestAddEquipTask(self.currentEquipForgeData.Id)

    end)
    self.panel.EquipCancelTaskButton:AddClick(function()
        if self.currentEquipForgeData == nil then
            return
        end
        self._forgeMgr.RequestDevEquipTask(self.currentEquipForgeData.Id)
    end)

    self.panel.ShowEquipTypeTipsButton:AddClick(function()
        if self.currentEquipForgeData == nil then
            return
        end

        local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(self.currentEquipForgeData.Id, true)
        if l_equipTableInfo == nil then
            return nil
        end

        UIMgr:ActiveUI(UI.CtrlNames.EquipTypeExplainTips, function(ctrl)
            ctrl:ShowExplainTips(l_equipTableInfo.WeaponId)
        end)
    end)

    self:_initLvRange()
    self:_initDropDownConfig()
    self:getLevelSelectButtons()
end

--- 初始化下拉列表的显示内容
function ForgeCtrl:_initDropDownConfig()
    local onDropDownValueChanged = function(idx)
        local luaIdx = idx + 1
        self:_onLevelSelectButtons(luaIdx)
    end

    local dropDownConfig = {}
    for i = 1, #self._selectTypeDatas do
        local singleConfig = self._selectTypeDatas[i]
        table.insert(dropDownConfig, singleConfig.name)
    end

    self.panel.Dropdown:SetDropdownOptions(dropDownConfig)
    self.panel.Dropdown.DropDown.onValueChanged:AddListener(onDropDownValueChanged)
end

function ForgeCtrl:_startForgeEquip(id,totalCost)
    --如果打造盾牌，并且装备双手武器
    if MgrMgr:GetMgr("EquipMgr").IsShieldWithId(id) then
        if MgrMgr:GetMgr("BodyEquipMgr").IsEquipUseTwoHandWeapon() then
            CommonUI.Dialog.ShowYesNoDlg(
                    true, nil,
                    Lang("Forge_ForgeShieldEquipTipsText"),
                    function()
                        self:_ForgeEquip(id,totalCost)
                    end)
            return
        end
    end

    --如果打造双手武器，并且装备盾牌
    if MgrMgr:GetMgr("EquipMgr").IsWeaponUseTwoHandWithId(id) then
        if MgrMgr:GetMgr("BodyEquipMgr").IsEquipShield() then
            CommonUI.Dialog.ShowYesNoDlg(
                    true, nil,
                    Lang("Forge_ForgeDoubleHandWeaponEquipTipsText"),
                    function()
                        self:_ForgeEquip(id,totalCost)
                    end)
            return
        end
    end

    self:_ForgeEquip(id,totalCost)
end

function ForgeCtrl:_ForgeEquip(id,totalCost,isNotCheck)

    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                self:_ForgeEquip(id,totalCost,true)
            end)
            return
        end
    end

    if MScene.SceneID == 24 then
        UIMgr:HideUI(UI.CtrlNames.EquipElevate)

        MCutSceneMgr:PlayImmById(2001, DirectorWrapMode.Hold, function()
            MgrMgr:GetMgr("ForgeMgr").RequestForgeEquip(id)
            MAudioMgr:Play(20)
            UIMgr:ShowUI(UI.CtrlNames.EquipElevate)
        end)
    else
        MgrMgr:GetMgr("ForgeMgr").RequestForgeEquip(id)
    end
end

--EquipItem
--根据条件显示装备
function ForgeCtrl:showEquipItems(levelRangeIndex)
    self._forgeMgr.CurrentSelectIndex = 0
    self.currentEquipDatas = self._forgeMgr.GetEquips(levelRangeIndex)
    local showIdx = nil
    if self._forgeMgr.NeedSelectEquipId then
        for i = 1, #self.currentEquipDatas do
            if self.currentEquipDatas[i].Id == self._forgeMgr.NeedSelectEquipId then
                showIdx = i
                break
            end
        end

        self._forgeMgr.NeedSelectEquipId = nil
    end

    if showIdx == nil then
        for i = 1, #self.currentEquipDatas do
            if self._forgeMgr.IsForgeMaterialsEnough(self.currentEquipDatas[i]) then
                showIdx = i
                break
            end
        end
    end

    if showIdx == nil then
        showIdx = 1
    end

    local showNoEquipPage = 0 == #self.currentEquipDatas
    self:_updateShowPage(showNoEquipPage)

    self.equipTemplatePool:ShowTemplates({
        Datas = self.currentEquipDatas,
        StartScrollIndex = showIdx,
        Method = function(itemSelf, dataConfig, showIdx)
            self:onEquipItemButton(showIdx, dataConfig)
        end
    })

    --- templatePool是异步创建的，所以可能调用的时候还没有创建出来
    --- 所以这里直接把数据设置进去作为默认选中状态
    self.equipTemplatePool:SelectTemplate(showIdx)
    local itemFirst = self.currentEquipDatas[showIdx]
    if itemFirst ~= nil then
        self:onEquipItemButton(showIdx, itemFirst)
    end
end

function ForgeCtrl:_updateShowPage(noEquip)
    self.panel.MainPanel.gameObject:SetActiveEx(not noEquip)
    self.panel.NoneEquipText.gameObject:SetActiveEx(noEquip)
end

--- 显示武器定位的提示
function ForgeCtrl:_showEquipTips(equipID)
    if nil == equipID then
        logError("[ForgeCtrl] invalid param")
        return
    end

    local singleEquipTable = TableUtil.GetEquipTable().GetRowById(equipID)
    local showEquipTable = nil ~= singleEquipTable
    self.panel.Txt_EquipTips.gameObject:SetActiveEx(showEquipTable)
    self.panel.Txt_EquipTips.LabText = tostring(singleEquipTable.Tips)
end

--点击装备
---@param templateConfig EquipForgeTable
function ForgeCtrl:onEquipItemButton(showIdx, templateConfig)
    if self._forgeMgr.CurrentSelectIndex == showIdx then
        return
    end

    self:_showEquipTips(templateConfig.Id)
    local l_lastIndex = self._forgeMgr.CurrentSelectIndex
    self._forgeMgr.CurrentSelectIndex = showIdx
    self.panel.EquipItemScroll.LoopScroll:RefreshCell(l_lastIndex - 1)
    self.panel.EquipShowPanel.gameObject:SetActiveEx(true)
    self.equipTemplatePool:SelectTemplate(showIdx)

    local equipForgeData = templateConfig
    self.currentEquipForgeData = equipForgeData
    self:_showEquipTaskButton()
    self.panel.EquipItemScroll.LoopScroll:RefreshCell(l_lastIndex - 1)
    self.panel.EquipShowPanel.gameObject:SetActiveEx(true)
    self.equipTemplatePool:SelectTemplate(showIdx)

    local equipForgeData = templateConfig
    self.currentEquipForgeData = equipForgeData
    self:_showEquipTaskButton()
    self.currentTipsData = Data.BagModel:CreateItemWithTid(equipForgeData.Id)
    self:showForgeMaterials(equipForgeData)
    self:_showProperties(equipForgeData.Id)

    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(equipForgeData.Id)
    self.panel.EquipName.LabText = itemTableInfo.ItemName
    self.panel.ForgeIcon:SetActiveEx(false)
    self.panel.ForgeModel:SetActiveEx(false)

    if self._forgeMgr.IsWeaponForge() then
        self.panel.ForgeModel:SetActiveEx(true)
        if self._equipModel then
            self:DestroyUIModel(self._equipModel)
            self.panel.ForgeModel:SetActiveEx(false)
        end

        local l_id = equipForgeData.Id
        local l_modelData = 
        {
            itemId = l_id,
            rawImage = self.panel.ForgeModel.RawImg
        }
        self._equipModel = self:CreateUIModelByItemId(l_modelData)
        self._equipModel:AddLoadModelCallback(function(m)
            self.panel.ForgeModel:SetActiveEx(true)
            local l_positionTableInfo = TableUtil.GetWeaponPositionTable().GetRowByEquipId(l_id)
            if l_positionTableInfo then
                m.Trans:SetLocalPos(l_positionTableInfo.PositionX, l_positionTableInfo.PositionY, l_positionTableInfo.PositionZ)
                m.UObj:SetRotEuler(l_positionTableInfo.RotateX, l_positionTableInfo.RotateY, l_positionTableInfo.RotateZ)
            end
        end)
    else
        self.panel.ForgeIcon:SetActiveEx(true)
        self.panel.ForgeIcon:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
    end
end

function ForgeCtrl:_showEquipTaskButton()
    if self.currentEquipForgeData == nil then
        return
    end

    self.panel.EquipReceiveTaskButton:SetActiveEx(false)
    self.panel.EquipCancelTaskButton:SetActiveEx(false)
    if MgrMgr:GetMgr("ForgeMgr").IsForgeTaskStart(self.currentEquipForgeData.Id) then
        self.panel.EquipCancelTaskButton:SetActiveEx(true)
    else
        self.panel.EquipReceiveTaskButton:SetActiveEx(true)
    end
end

--打造材料
function ForgeCtrl:showForgeMaterials(equipForgeData)
    local h = equipForgeData.ForgeMaterials
    local forgeMaterials = Common.Functions.VectorSequenceToTable(h)
    local forgeMaterialDatas = {}
    for i = 1, #forgeMaterials do
        local data = {}
        data.ID = forgeMaterials[i][1]
        data.IsShowCount = false
        data.IsShowRequire = true
        data.RequireCount = forgeMaterials[i][2]
        table.insert(forgeMaterialDatas, data)
    end

    local l_isRecommend = self._forgeMgr.IsRecommend(equipForgeData)
    local l_isForgeMaterialsEnough = self._forgeMgr.IsForgeMaterialsEnough(equipForgeData)
    self.panel.RedPrompt.gameObject:SetActiveEx(l_isRecommend and l_isForgeMaterialsEnough)
    self.forgeMaterialTemplatePool:ShowTemplates({ Datas = forgeMaterialDatas })
end

function ForgeCtrl:_showProperties(id)
    local l_datas = {}
    local strs = MgrMgr:GetMgr("ForgeMgr").GetForgeDisplayAttrs(id)
    for i = 1, #strs do
        local singleParam = { Text = strs[i] }
        table.insert(l_datas, singleParam)
    end

    self._equipPropertiesTemplatePool:ShowTemplates({ Datas = l_datas })
end

--- 初始化所有的等级配置
function ForgeCtrl:_initLvRange()
    local datas = self._forgeMgr.GetShowLevelRanges()
    local ranges = self._forgeMgr.GetForgeLevelShowSection()
    self._selectTypeDatas = {}
    local C_LV_STR = "Lv.{0}..-Lv.{1}"
    for i = 1, #datas do
        local startLv = tonumber(ranges[datas[i] - 2]) + 1
        local endLv = tonumber(ranges[datas[i] - 1])
        local name = StringEx.Format(C_LV_STR, startLv, endLv)
        local l_selectTypeData = {}
        l_selectTypeData.name = name
        local l_index = i
        l_selectTypeData.index = l_index
        table.insert(self._selectTypeDatas, l_selectTypeData)
    end
end

--选择按钮
function ForgeCtrl:getLevelSelectButtons()
    local datas = self._forgeMgr.GetShowLevelRanges()
    local ranges = self._forgeMgr.GetForgeLevelShowSection()
    local currentIndex = #datas
    for i = 1, #datas do
        if self._forgeMgr.GetCurrentShowLevel() <= tonumber(ranges[datas[i] - 1]) then
            currentIndex = i
            break
        end
    end

    if currentIndex > #self._selectTypeDatas then
        currentIndex = 1
    end

    --- 有个坑，dropdown当中如果值没有变化，赋值的时候是不会触发onValueChange的
    local csIdx = currentIndex - 1
    if self.panel.Dropdown.DropDown.value == csIdx then
        self:_onLevelSelectButtons(currentIndex)
        return
    end

    self.panel.Dropdown.DropDown.value = csIdx
end

function ForgeCtrl:_onLevelSelectButtons(index)
    local datas = self._forgeMgr.GetShowLevelRanges()
    self:showEquipItems(tonumber(datas[index]))
end

--- 点击推荐按钮出发
function ForgeCtrl._onRecommendButtonClick()
    UIMgr:ActiveUI(UI.CtrlNames.Forge_FactionRecommendation)
end

--lua custom scripts end
return ForgeCtrl