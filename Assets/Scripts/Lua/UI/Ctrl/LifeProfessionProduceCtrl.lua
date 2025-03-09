--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionProducePanel"
require "UI/Template/LifeProfessionProductTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
LifeProfessionProduceCtrl = class("LifeProfessionProduceCtrl", super)
local ClassID = MgrMgr:GetMgr("LifeProfessionMgr").ClassID
--lua class define end

--lua functions
function LifeProfessionProduceCtrl:ctor()

    super.ctor(self, CtrlNames.LifeProfessionProduce, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function LifeProfessionProduceCtrl:Init()

    self.panel = UI.LifeProfessionProducePanel.Bind(self)
    super.Init(self)
    self.lifeProMgr = MgrMgr:GetMgr("LifeProfessionMgr")
    self:initBaseInfo()
end --func end
--next--
function LifeProfessionProduceCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LifeProfessionProduceCtrl:OnActive()
    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("LifeProfessionData").EUIOpenType.LifeProfessionTips then
            self:initClassName(self.uiPanelData.classID, self.uiPanelData.triggerID)
        end
        self:setCurrentSelectRecipeData(self.uiPanelData.selectData)
    end
    self:refreshPanel()
end --func end
--next--
function LifeProfessionProduceCtrl:OnDeActive()
    self.InLifeProfessionCtrls = false
    self.currentSelectRecipeData = nil
    self.currentSelectSmeltRecipeData = nil
    self.currentSelectArmorRecipeData = nil
    self.currentSelectAccesRecipeData = nil
    self.TrigerID = nil
    self.costProp1ItemTem = nil
    self.costProp1Data = nil
    self.costProp2ItemTem = nil
    self.costProp2Data = nil
    self.costPropYuanQiItemTem = nil
    self.costPropYuanQiData = nil
end --func end
--next--
function LifeProfessionProduceCtrl:Update()


end --func end
--next--
function LifeProfessionProduceCtrl:BindEvents()
    self:BindEvent(self.lifeProMgr.EventDispatcher, self.lifeProMgr.EventType.OnItemChange, function()
        self:refreshCostProp(self.produceProductNum, self.currentSelectRecipeData)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--region init
--交互按钮触发
function LifeProfessionProduceCtrl:initBaseInfo()
    self.produceProductNum = 1
    self.singleProfessionProductPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.LifeProfessionProductTemplate,
        TemplatePrefab = self.panel.Template_LifeProfessionProduct.gameObject,
        ScrollRect = self.panel.Scroll_productList.LoopScroll
    })
    self.multiProfessionProductPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.LifeProfessionProductTemplate,
        TemplatePrefab = self.panel.Template_LifeProfessionProduct.gameObject,
        ScrollRect = self.panel.Scroll_multiProfessionProducts.LoopScroll
    })
    self.produceCostPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.Scroll_ProduceCost.LoopScroll
    })
    self.panel.TogEx_Weapon:OnToggleExChanged(function(value)
        if value then
            local l_isSystemOpen = self.lifeProMgr.CanOpenSystem(ClassID.Smelt)
            if not l_isSystemOpen then
                self.panel.TogEx_Armor.TogEx.isOn = true
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
                return
            end
            self.ClassName = ClassID.Smelt
            self:refreshPanel()
        end
    end, true)
    self.panel.TogEx_Armor:OnToggleExChanged(function(value)
        if value then
            local l_isSystemOpen = self.lifeProMgr.CanOpenSystem(ClassID.Armor)
            if not l_isSystemOpen then
                self.panel.TogEx_Weapon.TogEx.isOn = true
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
                return
            end
            self.ClassName = ClassID.Armor
            self:refreshPanel()
        end
    end, true)
    self.panel.TogEx_Weapon.TogEx.isOn = true

    self.currentChooseStar = 1
    self.panel.TogEx_Star1:OnToggleExChanged(function(value)
        if value then
            self.currentChooseStar = 1
            self:setCurrentSelectRecipeData(self:getCurrentSelectRecipeData())
        end
    end, true)
    self.panel.TogEx_Star2:OnToggleExChanged(function(value)
        if value then
            self.currentChooseStar = 2
            self:setCurrentSelectRecipeData(self:getCurrentSelectRecipeData())
        end
    end, true)
    self.panel.TogEx_Star3:OnToggleExChanged(function(value)
        if value then
            self.currentChooseStar = 3
            self:setCurrentSelectRecipeData(self:getCurrentSelectRecipeData())
        end
    end, true)
    self.panel.TogEx_Star1.TogEx.isOn = true

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.LifeProfessionProduce)
    end, true)
    self.panel.Btn_Produce:AddClick(function()
        self:onBtnProduce()
    end, true)
    self.panel.Btn_Goto:AddClick(function()
        local l_openUIData = {
            classID = self.ClassName,
        }
        self:Close()
        UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionMain, l_openUIData)
    end, true)
    self.panel.ConBtn_Add.ConBtn.OnContinuousButton = function()
        self:refreshProduceNum(self.produceProductNum + 1)
    end
    self.panel.ConBtn_Add.ConBtn.OnButtonDown = function()
        self:refreshProduceNum(self.produceProductNum + 1)
    end
    self.panel.ConBtn_Reduce.ConBtn.OnButtonDown = function()
        self:reduceProductNum()
    end
    self.panel.ConBtn_Reduce.ConBtn.OnContinuousButton = function()
        self:reduceProductNum()
    end
end

function LifeProfessionProduceCtrl:initClassName(class, TriggerID)

    self.TrigerID = TriggerID
    if self.InLifeProfessionCtrls then
        self.InLifeProfessionCtrls = false
    else
        self.ClassName = class
    end
    if class == ClassID.Smelt then
        self.panel.TogEx_Weapon.TogEx.isOn = true
    elseif class == ClassID.Armor then
        self.panel.TogEx_Armor.TogEx.isOn = true
    end
end
function LifeProfessionProduceCtrl:SetSelectData(class, selectData)
    self.SelectData = selectData
    self.ClassName = class
    self.InLifeProfessionCtrls = true
end

--endregion
--region usual
function LifeProfessionProduceCtrl:reduceProductNum()
    local l_produceNum = self.produceProductNum - 1
    if l_produceNum < 1 then
        l_produceNum = 1
        if l_produceNum == self.produceProductNum then
            return
        end
    end
    self:refreshProduceNum(l_produceNum)
end
function LifeProfessionProduceCtrl:getRecipeDatas(recipeDatas, recipeId)
    if recipeId ~= nil then

        local l_RecipeRows = self.lifeProMgr.GetRecipeRaws(self.ClassName)
        for i = 1, #l_RecipeRows do
            local l_RecipeData = l_RecipeRows[i]
            if l_RecipeData ~= nil then
                local l_lock = not self.lifeProMgr.CanRecipeActive(recipeId, l_RecipeData)
                local l_lockLv = self.lifeProMgr.CanRecipeLockLv(l_RecipeData)
                recipeDatas[#recipeDatas + 1] = {
                    data = l_RecipeData,
                    ctrl = self,
                    lock = l_lock,
                    lockLv = l_lockLv,
                    selectMethod = self.onSelectItem,
                }
            end
        end
        table.sort(recipeDatas, function(a, b)
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
        local l_currentSelectRecipeData = self:getCurrentSelectRecipeData()
        for i = 1, #recipeDatas do
            local l_tempRecipeData = recipeDatas[i].data
            if l_currentSelectRecipeData == nil then
                l_currentSelectRecipeData = l_tempRecipeData
            end
            if l_currentSelectRecipeData.ID == l_tempRecipeData.ID then
                self.currentSelectIndex = i
            end
        end
        self:setCurrentSelectRecipeData(l_currentSelectRecipeData)
    end
end
function LifeProfessionProduceCtrl:setCurrentSelectRecipeData(recipeData)
    if self.ClassName == ClassID.Smelt then
        self.currentSelectSmeltRecipeData = recipeData
    elseif self.ClassName == ClassID.Armor then
        self.currentSelectArmorRecipeData = recipeData
    elseif self.ClassName == ClassID.Acces then
        self.currentSelectAccesRecipeData = recipeData
    else
        self.currentSelectRecipeData = recipeData
    end
    local l_recipeData = self:getCurrentSelectRecipeData()
    if l_recipeData ~= nil then
        self.panel.Txt_produceProductName.LabText = l_recipeData.Name
        self.panel.Txt_FuncDesc.LabText = l_recipeData.Desc
        self.panel.Img_producePropIcon:SetSpriteAsync(l_recipeData.Atlas, l_recipeData.Icon, nil, true)
        self:refreshCostProp(self.produceProductNum, l_recipeData)
    end
end
function LifeProfessionProduceCtrl:getCurrentSelectRecipeData()
    if self.ClassName == ClassID.Smelt then
        return self.currentSelectSmeltRecipeData
    elseif self.ClassName == ClassID.Armor then
        return self.currentSelectArmorRecipeData
    elseif self.ClassName == ClassID.Acces then
        return self.currentSelectAccesRecipeData
    else
        if self.ClassName == ClassID.FoodFusion or self.ClassName == ClassID.MedicineFusion then
            return self.lifeProMgr.GetRecipeDataByStar(self.currentSelectRecipeData, self.currentChooseStar)
        end
        return self.currentSelectRecipeData
    end
end
---@param recipeTableData RecipeTable
function LifeProfessionProduceCtrl:onSelectItem(recipeTableData)
    if recipeTableData == nil then
        return
    end
    self:setCurrentSelectRecipeData(recipeTableData)
end
--endregion
--region refresh
function LifeProfessionProduceCtrl:refreshPanel()
    self:refreshBaseInfo()
    local l_data = {}
    self:getRecipeDatas(l_data, self.lifeProMgr.GetRowRecipeIDByLv(self.ClassName))
    if #l_data < 1 then
        return
    end
    if self.ClassName == ClassID.Smelt or self.ClassName == ClassID.Armor or self.ClassName == ClassID.Acces then
        self.panel.Panel_singleProfession:SetActiveEx(false)
        self.panel.Panel_multiProfession:SetActiveEx(true)
        self.multiProfessionProductPool:ShowTemplates({ Datas = l_data })
        self.multiProfessionProductPool:SelectTemplate(self.currentSelectIndex)
        self.panel.Obj_StarTog:SetActiveEx(false)
    else
        local l_showChooseStar = self.ClassName == ClassID.FoodFusion or self.ClassName == ClassID.MedicineFusion
        self.panel.Obj_StarTog:SetActiveEx(l_showChooseStar)
        self.panel.Panel_singleProfession:SetActiveEx(true)
        self.panel.Panel_multiProfession:SetActiveEx(false)
        self.singleProfessionProductPool:ShowTemplates({ Datas = l_data })
        self.singleProfessionProductPool:SelectTemplate(self.currentSelectIndex)
    end
    self:refreshProduceNum(self.produceProductNum)
end
function LifeProfessionProduceCtrl:refreshBaseInfo()
    local l_title
    local l_sprite
    local l_isFusionLifeProfession = false
    if self.ClassName == ClassID.Cook then
        l_title = Lang("LifeProfessionTips_CookTitle") --烹调
        l_sprite = "UI_LifeProfession_pengren.png"
    elseif self.ClassName == ClassID.Sweet then
        l_title = Lang("LifeProfessionTips_SweetTitle")
        l_sprite = "UI_LifeProfession_tianpin.png"
    elseif self.ClassName == ClassID.Drug then
        l_title = Lang("LifeProfessionTips_DrugTitle")
        l_sprite = "UI_LifeProfession_zhiyao.png"
    elseif self.ClassName == ClassID.FoodFusion then
        l_title = Lang("LifeProfession_FoodFusion")
        l_sprite = "UI_LifeProfession_zhiyao.png"
        l_isFusionLifeProfession = true
    elseif self.ClassName == ClassID.MedicineFusion then
        l_title = Lang("LifeProfession_MedicineFusion")
        l_sprite = "UI_LifeProfession_zhiyao.png"
        l_isFusionLifeProfession = true
    elseif self.ClassName == ClassID.Smelt or
            self.ClassName == ClassID.Armor or
            self.ClassName == ClassID.Acces then
        l_title = Lang("LifeProfessionTips_SmeltTitle")
        l_sprite = "UI_LifeProfession_yelian.png"
    else
        logError("异常的类型")
        return
    end
    self.panel.Txt_FuncName.LabText = l_title
    self.panel.Img_LifeProfessionBg:SetSpriteAsync("LifeProfession", l_sprite)
    self.panel.Txt_LvLabel.LabText = Common.Utils.Lang("LEVEL_LABEL", l_title)
    local l_lifeSkillLv = self.lifeProMgr.GetLv(self.ClassName)
    self.panel.Panel_ChanceInfo:SetActiveEx(not l_isFusionLifeProfession)
    self.panel.Txt_MustSuc:SetActiveEx(l_isFusionLifeProfession)
    local l_nextLevel, l_levelupNeedExp = self.lifeProMgr.GetNextLevelInfo(self.ClassName)
    if l_nextLevel == -1 then
        self.panel.Txt_SkillProgress.LabText = "MAX"
        self.panel.Slider_Exp.Slider.value = 1
    else
        local l_curExp = self.lifeProMgr.GetExp(self.ClassName)
        self.panel.Txt_SkillProgress.LabText = StringEx.Format("{0}/{1}", l_curExp, l_levelupNeedExp)
        self.panel.Slider_Exp.Slider.value = l_curExp / l_levelupNeedExp
    end

    self.panel.Txt_Lv.LabText = Common.Utils.Lang("Lv{0}", l_lifeSkillLv)

    local l_sucRate, l_bigSucRate, l_bigSucRewardMinRate, l_bigSucRewardMaxRate = self.lifeProMgr.GetLifeSkillRateInfoByLevel(self.ClassName, l_lifeSkillLv)

    if l_sucRate == nil then
        logError("current level rate Info is null!")
    else
        self.panel.Txt_SucRate.LabText = StringEx.Format("{0}%", l_sucRate)
        self.panel.Txt_BigSucRate.LabText = StringEx.Format("{0}%", l_bigSucRate)
        self.panel.Txt_BigSucRewardRate:SetActiveEx(l_bigSucRewardMinRate ~= -1)
        self.panel.Obj_ChengGongLv:SetActiveEx(l_bigSucRewardMinRate ~= -1)
        local l_sucRateTxt
        if l_bigSucRewardMinRate == l_bigSucRewardMaxRate then
            l_sucRateTxt = StringEx.Format("x {0}", l_bigSucRewardMaxRate)
        else
            l_sucRateTxt = StringEx.Format("x {0}~{1}", l_bigSucRewardMinRate, l_bigSucRewardMaxRate)
        end
        self.panel.Txt_BigSucRewardRate.LabText = l_sucRateTxt
    end
end
---@param recipeTableData RecipeTable
function LifeProfessionProduceCtrl:refreshCostProp(productNum, recipeTableData)
    local l_costPropDatas = self:getCostPropDatas(productNum, recipeTableData)
    if l_costPropDatas==nil then
        return
    end

    self.produceCostPool:ShowTemplates({Datas=l_costPropDatas})
end

function LifeProfessionProduceCtrl:getCostPropDatas(productNum, recipeTableData)
    if recipeTableData == nil then
        return
    end
    --材料列表
    local l_ingredients = Common.Functions.VectorSequenceToTable(recipeTableData.Ingredients)
    local l_costPropNum = #l_ingredients
    if l_costPropNum < 1 then
        return
    end
    local l_propDatas = {}
    for i = 1, l_costPropNum do
        local l_tempPropData = self:createCostPropTemplate(l_ingredients[i][1],l_ingredients[i][2],productNum)
        table.insert(l_propDatas,l_tempPropData)
    end
    local l_yuanqiPropData = self:createCostPropTemplate(MgrMgr:GetMgr("PropMgr").l_virProp.Yuanqi,
        recipeTableData.Stamina,productNum)
    table.insert(l_propDatas,l_yuanqiPropData)

    return l_propDatas
end
function LifeProfessionProduceCtrl:createCostPropTemplate(propID, costNumPerProduce, productNum)
    local l_tempPropData = {
        ID = propID,
        IsShowRequire = true,
        RequireCount = costNumPerProduce * productNum,
        IsShowCount = false,
    }
    return l_tempPropData
end
function LifeProfessionProduceCtrl:onBtnProduce()
    local l_currentSelectRecipeData = self:getCurrentSelectRecipeData()
    if l_currentSelectRecipeData == nil then
        return
    end

    local l_lifeSkillLv = self.lifeProMgr.GetLv(self.ClassName)
    local l_unlockLv = self.lifeProMgr.CanRecipeLockLv(l_currentSelectRecipeData)
    if l_unlockLv > l_lifeSkillLv then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PROP_LOCK_TIP"))
        return
    end

    --材料列表
    local l_ingredients = Common.Functions.VectorSequenceToTable(l_currentSelectRecipeData.Ingredients)
    local l_ingredientNum = #l_ingredients
    if l_ingredientNum < 1 then
        return
    end

    for i = 1, l_ingredientNum do
        local l_propID = l_ingredients[i][1]
        local l_needPropNum = l_ingredients[i][2]
        local l_hasPropNum = Data.BagModel:GetCoinOrPropNumById(l_propID)
        if l_needPropNum * self.produceProductNum > l_hasPropNum then
            if MgrMgr:GetMgr("PropMgr").IsVirtualCoin(l_propID) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COIN_NOT_ENOUGH"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
            end
            return
        end
    end

    local l_yuanqiPropHasNum = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Yuanqi)
    if l_yuanqiPropHasNum < l_currentSelectRecipeData.Stamina * self.produceProductNum then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VITALITY_NOT_ENOUGH"))
        return
    end

    self.lifeProMgr.SendYuanQiRequest(l_currentSelectRecipeData.ID, self.produceProductNum,
            tostring(MPlayerInfo.UID), tostring(self.TrigerID), l_currentSelectRecipeData.RecipeType)
end
function LifeProfessionProduceCtrl:refreshProduceNum(num)

    if num > self.lifeProMgr.GetMaxProduceNumPerTime() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MAX_PRODUCE_NUM_PER_TIME"))
        self.panel.ConBtn_Add.ConBtn:OnPointerUp(nil)
        return
    end
    self.produceProductNum = num
    self.panel.Txt_ProduceNum.LabText = self.produceProductNum
    self:refreshCostProp(self.produceProductNum, self:getCurrentSelectRecipeData())
end
--endregion
--lua custom scripts end
return LifeProfessionProduceCtrl