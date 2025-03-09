--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CookingSinglePanel"
require "Data/Model/BagModel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CookingSingleCtrl = class("CookingSingleCtrl", super)
--lua class define end
ANI_TIME = 8
ANI_QTE_TIME = 4
ACTION_ID_PENREN = 1005
COOKING_SINGLE_REWARD_FX = "Effects/Prefabs/Creature/Ui/Fx_Ui_HuoQu_01"

--lua functions
function CookingSingleCtrl:ctor()
    super.ctor(self, CtrlNames.CookingSingle, UILayer.Function, UITweenType.Left, ActiveType.Exclusive)
end --func end
--next--
function CookingSingleCtrl:Init()

    self.recipesCache = {}
    self.ingredientsCache = {}
    self.cookingRepice = nil
    self.cookingCount = 1
    self.cookingAniTimer = nil
    self.rewardEffectId = 0
    -- self.isCooking = false
    self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingQTEType.NONE
    self.panel = UI.CookingSinglePanel.Bind(self)
    super.Init(self)
    self.panel.Cooking.UObj:SetActiveEx(false)
    self.panel.Reward.UObj:SetActiveEx(false)
    self.panel.QTE_Result.UObj:SetActiveEx(false)
    self:CreateRewardFx()
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CookingSingle)
    end)

    self.panel.BtnCloseCooking:AddClick(function()
        self.panel.Cooking.UObj:SetActiveEx(false)
    end)

    self.panel.InputCount.InputNumber.OnValueChange = (function(value)
        self.cookingCount = value
        if self.cookingCount < self.panel.InputCount.InputNumber.MinValue then
            self.cookingCount = self.panel.InputCount.InputNumber.MinValue
        end
        if self.cookingCount > self.panel.InputCount.InputNumber.MaxValue then
            self.cookingCount = self.panel.InputCount.InputNumber.MaxValue
        end
        self.panel.TargetCount.LabText = tostring(self.cookingCount)
        self:UpdateIngredientList()
    end
    )

    self.panel.BtnCooking:AddClick(function(...)
        MgrMgr:GetMgr("CookingSingleMgr").RequsetSingleCookingStart(self.cookingRepice, self.cookingCount)
    end)

    self.panel.BgMask:AddClick(function(...)
        self:ClickOnCooking()
    end)

    self.panel.BtnRewardClose:AddClick(function(...)

        self:ResetPanel()
    end)
    self:UpdateRepices()

end --func end
--next--
function CookingSingleCtrl:Uninit()
    self:DestroyRewardFx()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CookingSingleCtrl:OnActive()
    --MSceneWallTriggerMgr.TriggerHudEnabled = false
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.COOKING, false)
    if MgrMgr:GetMgr("CookingSingleMgr").selectTaskRecipe ~= nil then
        self:SelectRepiceById(MgrMgr:GetMgr("CookingSingleMgr").selectTaskRecipe)
    end
end --func end
--next--
function CookingSingleCtrl:OnDeActive()
    if self.recipesCache ~= nil then
        self:ClearCache(self.recipesCache)
        self.recipesCache = nil
    end
    if self.ingredientsCache ~= nil then
        self:ClearCache(self.ingredientsCache)
        self.ingredientsCache = nil
    end
    --MSceneWallTriggerMgr.TriggerHudEnabled = true
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.COOKING, true)
    game:ShowMainPanel()
end --func end
--next--
function CookingSingleCtrl:Update()

end --func end



--next--
function CookingSingleCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function CookingSingleCtrl:ResetPanel()
    MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, MEntityMgr.PlayerEntity)
    MgrMgr:GetMgr("CookingSingleMgr").ResetData()
    self.cookingRepice = nil
    self.cookingCount = 1
    -- self.isCooking = false
    self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingQTEType.NONE
    self.panel.Recipes.UObj:SetActiveEx(true)
    self.panel.ButtonClose.UObj:SetActiveEx(true)
    self.panel.Reward.UObj:SetActiveEx(false)
    self.panel.Selected.UObj:SetActiveEx(false)
    self.panel.Selected.transform:SetParent(self.panel.Recipes.transform)
    self:DestroyRewardFx()
    self:UpdateRepices()
end

function CookingSingleCtrl:CreateRewardFx(...)
    if self.rewardEffectId == 0 then
        local l_fxData = {}
        l_fxData.rawImage = self.panel.RewardEffect.gameObject:GetComponent("RawImage");
        l_fxData.destroyHandler = function(...)
            self.rewardEffectId = 0
        end
        self.rewardEffectId = self:CreateUIEffect(COOKING_SINGLE_REWARD_FX, l_fxData)

    end
end

function CookingSingleCtrl:DestroyRewardFx(...)
    if self.rewardEffectId ~= 0 then
        self:DestroyUIEffect(self.rewardEffectId)
        self.rewardEffectId = 0
    end
end

--- ��ȡ�����еĵ���
---@return ItemData[]
function CookingSingleCtrl:_getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

function CookingSingleCtrl:UpdateRepices()
    self:ClearCache(self.recipesCache)
    local props = self:_getItemsInBag()
    for i = 1, table.maxn(props) do
        ---@type ItemData 
        local l_propInfo = props[i]

        if l_propInfo ~= nil and l_propInfo.ItemConfig.TypeTab == 8 then
            local l_RecipeItem = self:CloneObj(self.panel.RecipeItem.gameObject, true)
            l_RecipeItem.transform:SetParent(self.panel.RecipeList.transform)
            MLuaCommonHelper.SetLocalScale(l_RecipeItem, 1, 1, 1)
            MLuaCommonHelper.SetLocalRot(l_RecipeItem, 0, 0, 0, 1)
            MLuaCommonHelper.SetLocalPos(l_RecipeItem, 0, 0, 0)
            local l_recipeCell = {
                view = l_RecipeItem,
                data = l_propInfo
            }
            self:UpdateRepiceCell(l_recipeCell)
            table.insert(self.recipesCache, l_recipeCell)
        end
    end

    if #self.recipesCache == 0 then
        self.panel.RecipeEmpty.UObj:SetActiveEx(true)
        self.panel.Cooking.UObj:SetActiveEx(false)
        self.panel.RecipeEmpty:AddClick(function(...)
            UIMgr:DeActiveUI(self.name)
            MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
            MgrMgr:GetMgr("ActionTargetMgr").MoveToTalkWithNpc(7, 1034)
        end)
    else
        self.panel.RecipeEmpty.UObj:SetActiveEx(false)
    end

end

function CookingSingleCtrl:SelectRepiceById(repiceId)
    for i = 1, table.maxn(self.recipesCache) do
        if self.recipesCache[i].data.TID == repiceId then
            self:SelectRepice(self.recipesCache[i])
            MgrMgr:GetMgr("CookingSingleMgr").selectTaskRecipe = nil
            return
        end
    end
end

function CookingSingleCtrl:UpdateRepiceCell(recipeCell)
    recipeCell.view.transform:Find("Image/RecipeIcon"):GetComponent("MLuaUICom"):SetSprite(recipeCell.data.ItemData.ItemAtlas, recipeCell.data.ItemData.ItemIcon)
    recipeCell.view.transform:Find("Image/RecipeCount"):GetComponent("MLuaUICom").LabText = recipeCell.data.ItemCount
    recipeCell.view.transform:Find("RecipeName"):GetComponent("MLuaUICom").LabText = recipeItemTableData.ItemName
    recipeCell.view.transform:GetComponent("MLuaUICom"):AddClick(
            function(...)
                self:SelectRepice(recipeCell)
            end
    )

end

function CookingSingleCtrl:SelectRepice(recipeCell)
    self.panel.Selected.UObj:SetActiveEx(true)
    self.panel.Selected.transform:SetParent(recipeCell.view.transform)
    self.panel.Selected.transform:SetLocalScaleOne()
    self.panel.Selected.transform:SetLocalPosZero()
    self.panel.Selected.transform.localRotation = Vector3.New(0, 0, 0)
    self:ShowCooking(recipeCell.data)
end

function CookingSingleCtrl:ShowCooking(recipeData)
    self:ClearCache(self.ingredientsCache)

    if recipeData == nil then
        return
    end
    self.panel.Cooking.UObj:SetActiveEx(true)
    local recipeItemTableData = TableUtil.GetItemTable().GetRowByItemID(recipeData.TID)
    local recipeTableData = TableUtil.GetRecipeTable().GetRowByID(recipeData.TID)
    if recipeTableData == nil then
        logError("RecipeTable error")
        return
    end
    local cookingTargetTableData = TableUtil.GetItemTable().GetRowByItemID(recipeTableData.ResultID)
    self.panel.TargetIcon:GetComponent("MLuaUICom"):SetSprite(cookingTargetTableData.ItemAtlas, cookingTargetTableData.ItemIcon, true)
    self.panel.CookingName.LabText = cookingTargetTableData.ItemName
    self.panel.CookingDesc.LabText = cookingTargetTableData.ItemDescription

    self.cookingCount = 1
    self.panel.TargetCount.LabText = self.cookingCount

    local l_ingredients = Common.Functions.VectorSequenceToTable(recipeTableData.Ingredients)
    for i = 1, table.maxn(l_ingredients) do
        local l_ingredientData = l_ingredients[i]
        local l_ingredientItem = self:CloneObj(self.panel.IngredientItem.gameObject, true)
        l_ingredientItem.transform:SetParent(self.panel.IngredientsList.transform)
        l_ingredientItem.transform:SetLocalScaleOne()
        l_ingredientItem.transform:SetLocalPosZero()
        l_ingredientItem.transform.localRotation = Vector3.New(0, 0, 0)
        local l_needCntOne = l_ingredientData[2]
        local l_hasCnt = Data.BagModel:GetCoinOrPropNumById(l_ingredientData[1])
        local l_maxCount = l_hasCnt / l_needCntOne

        if self.panel.InputCount.InputNumber.MaxValue > l_maxCount then
            self.panel.InputCount.InputNumber.MaxValue = l_maxCount
        end

        local l_ingredientCell = {
            view = l_ingredientItem,
            ingredientData = l_ingredientData,
            itemData = TableUtil.GetItemTable().GetRowByItemID(l_ingredientData[1]),
            needCount = l_ingredientData[2] * self.cookingCount,
            hasCount = Data.BagModel:GetCoinOrPropNumById(l_ingredientData[1])
        }

        self:UpdateIngredientCell(l_ingredientCell)
        table.insert(self.ingredientsCache, l_ingredientCell)
    end

    if self.panel.InputCount.InputNumber.MaxValue < self.panel.InputCount.InputNumber.MinValue then
        self.panel.InputCount.InputNumber.MaxValue = self.panel.InputCount.InputNumber.MinValue
    end

    self.cookingRepice = recipeData.TID
end

function CookingSingleCtrl:ClearCache(list)
    for i = table.maxn(list), 1, -1 do
        local child = list[i].view
        if child.gameObject.activeSelf then
            MResLoader:DestroyObj(child.gameObject)
            table.remove(list, i)
        end
    end
end

function CookingSingleCtrl:ChangeCookingCount(val)
    self.cookingCount = self.cookingCount + val
    if self.cookingCount < 1 then
        self.cookingCount = 1
    end
    self.panel.TargetCount.LabText = self.cookingCount
    self:UpdateIngredientList()
end

function CookingSingleCtrl:UpdateIngredientList(...)
    for i = 1, table.maxn(self.ingredientsCache) do
        local l_ingredientCell = self.ingredientsCache[i]
        local l_needCntOne = l_ingredientCell.ingredientData[2]
        local l_hasCnt = Data.BagModel:GetCoinOrPropNumById(l_ingredientCell.ingredientData[1])
        local l_maxCount = l_hasCnt / l_needCntOne
        if self.panel.InputCount.InputNumber.MaxValue > l_maxCount then
            self.panel.InputCount.InputNumber.MaxValue = l_maxCount
        end

        l_ingredientCell.needCount = l_ingredientCell.ingredientData[2] * self.cookingCount
        l_ingredientCell.hasCount = Data.BagModel:GetCoinOrPropNumById(l_ingredientCell.ingredientData[1])
        self:UpdateIngredientCell(self.ingredientsCache[i])
    end
    
    if self.panel.InputCount.InputNumber.MaxValue < self.panel.InputCount.InputNumber.MinValue then
        self.panel.InputCount.InputNumber.MaxValue = self.panel.InputCount.InputNumber.MinValue
    end
end

function CookingSingleCtrl:UpdateIngredientCell(ingredientCell)
    ingredientCell.view.transform:Find("IngredientIcon"):GetComponent("MLuaUICom"):SetSprite(ingredientCell.itemData.ItemAtlas, ingredientCell.itemData.ItemIcon)
    local color = RoColorTag.Green
    if ingredientCell.needCount > ingredientCell.hasCount then
        color = RoColorTag.Red
    end

    local cntStr = GetColorText(tostring(ingredientCell.hasCount) .. "/" .. tostring(ingredientCell.needCount), color)
    ingredientCell.view.transform:Find("IngredientCount"):GetComponent("MLuaUICom").LabText = cntStr
    ingredientCell.view.transform:GetComponent("MLuaUICom"):AddClick(function(...)
        local isShowAchieve = false
        if ingredientCell.hasCount > ingredientCell.needCount then
            isShowAchieve = false
        else
            isShowAchieve = true
        end

        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(ingredientCell.itemData.ItemID, ingredientCell.view.transform, nil, nil, isShowAchieve)
    end)
end

function CookingSingleCtrl:CookingStart()
    self:ShowUI(false)
    -- self.isCooking = true
    self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.BEGIN
    -- logGreen("cooking BEGIN:"..self.state)

    MEventMgr:LuaFireEvent(MEventType.MEvent_Special, MEntityMgr.PlayerEntity,
            ROGameLibs.kEntitySpecialType_Action, ACTION_ID_PENREN)
    MgrMgr:GetMgr("CookingSingleMgr").PlayAudioWithTiming(MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.BEGIN)

    if MgrMgr:GetMgr("CookingSingleMgr").qte == MgrMgr:GetMgr("CookingSingleMgr").CookingQTEType.NONE then
        self.cookingAniTimer = self:NewUITimer(function()
            self:CookingFinish()
        end, ANI_TIME)
        self.cookingAniTimer:Start()
    else
        self.cookingAniTimer = self:NewUITimer(function()
            self:ToCookingQTE()
        end, ANI_QTE_TIME)
        self.cookingAniTimer:Start()
    end
end

function CookingSingleCtrl:ShowUI(val)
    self.panel.Cooking.UObj:SetActiveEx(val)
    self.panel.Recipes.UObj:SetActiveEx(val)
    self.panel.ButtonClose.UObj:SetActiveEx(val)
end

function CookingSingleCtrl:ClickOnCooking()
    -- logGreen("state:"..self.state)
    if self.state == MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.NONE then
        -- logGreen(" no cooking ")
        UIMgr:DeActiveUI(UI.CtrlNames.CookingSingle)
        return
    elseif self.state == MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.BEGIN then
        -- logGreen("cooking ")
        if self.cookingAniTimer ~= nil then
            self:StopUITimer(self.cookingAniTimer)
            self.cookingAniTimer = nil
        end
        if MgrMgr:GetMgr("CookingSingleMgr").qte == MgrMgr:GetMgr("CookingSingleMgr").CookingQTEType.NONE then
            self:CookingFinish()
        else
            self:ToCookingQTE()
        end
        return
    elseif self.state == MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_BEGIN then
        -- logGreen("qte ")
        return
    end
end

function CookingSingleCtrl:CookingFinish()
    MEntityMgr.PlayerEntity.Machine:ForceToDefault()
    MgrMgr:GetMgr("CookingSingleMgr").RequsetSingleCookingFinish(true)
end

function CookingSingleCtrl:CookingFinishSuccess(rewardID, rewardCnt)
    self:ShowUI(false)
    if MgrMgr:GetMgr("CookingSingleMgr").qte == MgrMgr:GetMgr("CookingSingleMgr").CookingQTEType.NONE then
        self:ShowReward(rewardID, rewardCnt)
    else
        local l_result = nil
        if MgrMgr:GetMgr("CookingSingleMgr").qteSuccess then
            l_result = self.panel.QTE_Result
            self.panel.QTE_Failed.UObj:SetActiveEx(false)
            self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_SUCCESS
            MgrMgr:GetMgr("CookingSingleMgr").PlayAudioWithTiming(MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_SUCCESS)
        else
            l_result = self.panel.QTE_Failed
            self.panel.QTE_Result.UObj:SetActiveEx(false)
            self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_FAILED
            MgrMgr:GetMgr("CookingSingleMgr").PlayAudioWithTiming(MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_FAILED)
        end
        l_result.UObj:SetActiveEx(true)

        local l_timer = self:NewUITimer(function()
            l_result.UObj:SetActiveEx(false)
            self:ShowReward(rewardID, rewardCnt)
        end, 2)
        l_timer:Start()
    end
end

function CookingSingleCtrl:ShowReward(rewardID, rewardCnt)
    MgrMgr:GetMgr("CookingSingleMgr").ResumePlayBGM()
    self.panel.Reward.UObj:SetActiveEx(true)
    self:CreateRewardFx()
    local item = TableUtil.GetItemTable().GetRowByItemID(rewardID)
    self.panel.RewardIcon.transform:GetComponent("MLuaUICom"):SetSprite(item.ItemAtlas, item.ItemIcon, true)
    local cntStr = item.ItemName .. " X " .. rewardCnt
    self.panel.RewardName.LabText = cntStr
end

function CookingSingleCtrl:ToCookingQTE()
    self.state = MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_BEGIN

    local l_qteType = MgrMgr:GetMgr("CookingSingleMgr").CookingQTE[MgrMgr:GetMgr("CookingSingleMgr").qte]

    if l_qteType == nil then
        return
    end
    UIMgr:ActiveUI(l_qteType)

end

--lua custom scripts end
