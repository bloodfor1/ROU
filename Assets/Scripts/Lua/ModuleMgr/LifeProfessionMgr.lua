require "TableEx/OffLineRecipeUnlockLvMap"

--生活信息
---@module ModuleMgr.LifeProfessionMgr
module("ModuleMgr.LifeProfessionMgr", package.seeall)

--region 变量
--生活技能数据获取
local l_lifeData = DataMgr:GetData("LifeProfessionData")

local BagModel = Data.BagModel
local _self = MgrMgr:GetMgr("LifeProfessionMgr")
local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local l_openID = MgrMgr:GetMgr("OpenSystemMgr").eSystemId
local l_isAutoCollectState = false
local l_removeSceneUIMaskTimer = nil --移除场景UI屏蔽效果

EProduceResult = {
    SUCCESS = 0,
    BIG_SUCCESS = 1,
    FAIL = 2,
}
m_specialFmodInstance = nil
ELevelUpConditionType = {
    Price = 1,
    Task = 2,
    RoleLevel = 3,
}
ClassName = {
    Natural = Lang("LifeProfession_Natural"), --自然之路
    Cuisine = Lang("LifeProfession_Cuisine"), --技艺之途
    Pharmacy = Lang("LifeProfession_Pharmacy"), --雅致之道

    Gather = Lang("LifeProfession_Gather"), --采集
    Mining = Lang("LifeProfession_Mining"), --挖矿
    Fish = Lang("LifeProfession_Fish"), --钓鱼

    Cook = Lang("LifeProfession_Cook"), --烹饪
    Drug = Lang("LifeProfession_Drug"), --制药
    Sweet = Lang("LifeProfession_Sweet"), --甜品
    Smelt = Lang("LifeProfession_Smelt"), --冶炼-武器
    Armor = Lang("LifeProfession_Armor"), --冶炼-防具
    Acces = Lang("LifeProfession_Acces"), --冶炼-饰品
    FoodFusion = Lang("LifeProfession_FoodFusion"), --烹饪组合
    MedicineFusion = Lang("LifeProfession_MedicineFusion"), --制药组合
}

SystemId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId

ClassID = {
    Natural = 1,
    Cuisine = 2,
    Pharmacy = 3,

    Gather = SystemId.LifeProfessionGather,
    Mining = SystemId.LifeProfessionMining,
    Fish = SystemId.LifeProfessionFish,

    Cook = SystemId.LifeProfessionCook,
    Drug = SystemId.LifeProfessionDrug,
    Sweet = SystemId.LifeProfessionSweet,
    Smelt = SystemId.LifeProfessionSmelt,
    Armor = SystemId.LifeProfessionArmor,
    Acces = SystemId.LifeProfessionAcces,
    FoodFusion = SystemId.LifeProfessionFoodFusion,
    MedicineFusion = SystemId.LifeProfessionMedicineFusion,
}

MaxLv = 1         --最高等级

Data = {
    CookLv = 1, --烹饪等级
    DrugLv = 1, --制药等级
    SweetLv = 1, --甜品等级
    SmeltLv = 1, --冶炼武器等级
    ArmorLv = 1, --冶炼防具等级
    AccesLv = 1, --冶炼饰品等级
    FoodFusionLv = 1, --烹饪组合等级
    MedicineFusionLv = 1, --制药组合等级

    CookExp = 0, --烹饪经验
    DrugExp = 0, --制药经验
    SweetExp = 0, --甜品经验
    SmeltExp = 0, --冶炼武器经验
    ArmorExp = 0, --冶炼防具经验
    AccesExp = 0, --冶炼饰品经验
    FoodFusionExp = 0, --烹饪组合经验
    MedicineFusionExp = 0, --制药组合经验
}

checkOpenIds = {
    l_openID.LifeProfession,
    l_openID.LifeProfessionGather,
    l_openID.LifeProfessionMining,
    l_openID.LifeProfessionFish,
    l_openID.LifeProfessionCook,
    l_openID.LifeProfessionDrug,
    l_openID.LifeProfessionSweet,
    l_openID.LifeProfessionSmelt,
}

EventDispatcher = EventDispatcher.new()
EventType = {
    Anim = 1,
    AnimStop = 2,
    Reward = 3,
    DataChange = 4,
    CollectOver = 5,
    OnGetCollectEndTime = 6,
    AutoCollectStateChanged = 7,
    ChooseLifeProfession = 8,
    OnItemChange = 9,
    LifeSkillLvUp = 10, --生活职业升级
}
local l_currentAutoCollectType = LifeSkillType.LIFE_SKILL_TYPE_GARDEN
RecipeLinkData = nil --构建食谱关联数据
--endregion

--region ----------------------生命周期-----------------------
function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)

    --构建食谱关联
    RecipeLinkData = {}
    local l_rows = TableUtil.GetRecipeTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        local l_typeData = RecipeLinkData[l_row.RecipeType]
        if l_typeData == nil then
            l_typeData = {}
            RecipeLinkData[l_row.RecipeType] = l_typeData
        end
        if l_row.BaseRecipe ~= nil and l_row.BaseRecipe ~= 0 then
            local l_data = l_typeData[l_row.BaseRecipe]
            if l_data == nil then
                l_data = {}
                l_typeData[l_row.BaseRecipe] = l_data
            end
            l_data[#l_data + 1] = l_row
        end
    end

    --最高等级
    local l_rows = TableUtil.GetCraftingSkillTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if l_row.SkillLv > MaxLv then
            MaxLv = l_row.SkillLv
        end
    end

    OpenSystemMgr.EventDispatcher:Add(OpenSystemMgr.OpenSystemUpdate, OnFuncOpen)
end

function OnUnInit()
    OpenSystemMgr.EventDispatcher:RemoveObjectAllFunc(OpenSystemMgr.OpenSystemUpdate)
end

function OnLogout()
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.LifeProfession)
    if l_ctrl ~= nil then
        l_ctrl:OnLogout()
    end
    StopSpecial()
    setAutoCollectState(false)
end

function OnFuncOpen(openIds)
    if openIds then
        for i, v in ipairs(openIds) do
            if array.contains(checkOpenIds, v.value) then
                MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.LifeProfession)
                UserDataManager.SetDataFromLua("LifeProfessionRedRot", MPlayerSetting.PLAYER_SETTING_GROUP, "true")
                break
            end
        end
    end
end
--endregion

--region 公开方法
function GetClassID(className)
    if className == ClassName.Gather then
        --采集
        return ClassID.Gather
    elseif className == ClassName.Mining then
        --挖矿
        return ClassID.Mining
    elseif className == ClassName.Fish then
        --钓鱼
        return ClassID.Fish
    elseif className == ClassName.Cook then
        --厨师
        return ClassID.Cook
    elseif className == ClassName.Drug then
        --制药
        return ClassID.Drug
    elseif className == ClassName.Sweet then
        --甜品
        return ClassID.Sweet
    elseif className == ClassName.Smelt then
        --冶炼武器
        return ClassID.Smelt
    elseif className == ClassName.Armor then
        --冶炼防具
        return ClassID.Armor
    elseif className == ClassName.Acces then
        --冶炼饰品
        return ClassID.Acces
    elseif className == ClassName.FoodFusion then
        --烹饪组合
        return ClassID.FoodFusion
    elseif className == ClassName.MedicineFusion then
        --制药组合
        return ClassID.MedicineFusion
    elseif className == ClassName.Natural then
        --自然之路
        return ClassID.Natural
    elseif className == ClassName.Cuisine then
        --技艺之路
        return ClassID.Cuisine
    elseif className == ClassName.Pharmacy then
        --雅致之路
        return ClassID.Pharmacy
    end
end

function GetClassName(classID)
    if classID == ClassID.Gather then
        --采集
        return ClassName.Gather
    elseif classID == ClassID.Mining then
        --挖矿
        return ClassName.Mining
    elseif classID == ClassID.Fish then
        --钓鱼
        return ClassName.Fish
    elseif classID == ClassID.Cook then
        --厨师
        return ClassName.Cook
    elseif classID == ClassID.Drug then
        --制药
        return ClassName.Drug
    elseif classID == ClassID.Sweet then
        --甜品
        return ClassName.Sweet
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return ClassName.Smelt
    elseif classID == ClassID.Armor then
        --冶炼防具
        return ClassName.Armor
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return ClassName.Acces
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        return ClassName.FoodFusion
    elseif classID == ClassID.MedicineFusion then
        --烹饪组合
        return ClassName.MedicineFusion
    elseif classID == ClassID.Natural then
        --自然之路
        return ClassName.Natural
    elseif classID == ClassID.Cuisine then
        --技艺之路
        return ClassName.Cuisine
    elseif classID == ClassID.Pharmacy then
        --雅致之路
        return ClassName.Pharmacy
    end
end
function GetLifeSkillTypeByClassID(classID)
    local l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_NONE
    if classID == ClassID.Cook then
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_FOOD
    elseif classID == ClassID.Drug then
        --制药
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_MEDICINE
    elseif classID == ClassID.Sweet then
        --甜品
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_DESSERT
    elseif classID == ClassID.Smelt then
        --冶炼
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_SMELT_WEAPON
    elseif classID == ClassID.Armor then
        --冶炼
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_SMELT_DEFEND
    elseif classID == ClassID.Acces then
        --冶炼
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_SMELT_ACC
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_FOOD_FUSION
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        l_lifeSkillType = LifeSkillType.LIFE_SKILL_TYPE_MEDICINE_FUSION
    end
    return l_lifeSkillType
end
--职业等级
function GetLv(classID)
    if classID == ClassID.Cook then
        --厨师
        return Data.CookLv
    elseif classID == ClassID.Drug then
        --制药
        return Data.DrugLv
    elseif classID == ClassID.Sweet then
        --甜品
        return Data.SweetLv
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return Data.SmeltLv
    elseif classID == ClassID.Armor then
        --冶炼防具
        return Data.ArmorLv
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return Data.AccesLv
    elseif classID == ClassID.FoodFusion then
        --冶炼饰品
        return Data.FoodFusionLv
    elseif classID == ClassID.MedicineFusion then
        --冶炼饰品
        return Data.MedicineFusionLv
    end

    return 0
end
--职业经验
function GetExp(classID)
    if classID == ClassID.Cook then
        --厨师
        return Data.CookExp
    elseif classID == ClassID.Drug then
        --制药
        return Data.DrugExp
    elseif classID == ClassID.Sweet then
        --甜品
        return Data.SweetExp
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return Data.SmeltExp
    elseif classID == ClassID.Armor then
        --冶炼防具
        return Data.ArmorExp
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return Data.AccesExp
    elseif classID == ClassID.FoodFusion then
        --冶炼饰品
        return Data.FoodFusionExp
    elseif classID == ClassID.MedicineFusion then
        --冶炼饰品
        return Data.MedicineFusionExp
    end

    return 0
end
--职业等级
function GetLifeSkillRateInfoByLevel(classID, level)
    local l_craftingSkillItem = TableUtil.GetCraftingSkillTable().GetRowBySkillLv(level, true)
    if MLuaCommonHelper.IsNull(l_craftingSkillItem) then
        return
    end

    local l_rateTable = nil
    if classID == ClassID.Cook then
        --厨师
        l_rateTable = l_craftingSkillItem.FoodRates
    elseif classID == ClassID.Drug then
        --制药
        l_rateTable = l_craftingSkillItem.MedicineRates
    elseif classID == ClassID.Sweet then
        --甜品
        l_rateTable = l_craftingSkillItem.DessertRates
    elseif classID == ClassID.Smelt then
        --冶炼武器
        l_rateTable = l_craftingSkillItem.SmeltWepRates
    elseif classID == ClassID.Armor then
        --冶炼防具
        l_rateTable = l_craftingSkillItem.SmeltArmorRates
    elseif classID == ClassID.Acces then
        --冶炼饰品
        l_rateTable = l_craftingSkillItem.SmeltAccsRates
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        l_rateTable = l_craftingSkillItem.FoodFusionRates
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        l_rateTable = l_craftingSkillItem.MedicineFusionRates
    end

    if l_rateTable ~= nil and l_rateTable[0] ~= nil then
        local l_sucRate = l_rateTable[0][0] / 100
        local l_bigSucRate = l_rateTable[0][1] / 100
        local l_bigSucRewardMinRate = -1
        local l_bigSucRewardMaxRate = -1
        for i = 1, l_rateTable.Count - 1 do
            local l_bigRewardRateData = l_rateTable[i]
            if l_bigRewardRateData[0] > l_bigSucRewardMaxRate or l_bigSucRewardMaxRate == -1 then
                l_bigSucRewardMaxRate = l_bigRewardRateData[0]
            end
            if l_bigRewardRateData[0] < l_bigSucRewardMinRate or l_bigSucRewardMinRate == -1 then
                l_bigSucRewardMinRate = l_bigRewardRateData[0]
            end
        end
        if l_bigSucRewardMinRate ~= -1 then
            l_bigSucRewardMinRate = l_bigSucRewardMinRate / 10000
        end
        if l_bigSucRewardMaxRate ~= -1 then
            l_bigSucRewardMaxRate = l_bigSucRewardMaxRate / 10000
        end
        return l_sucRate, l_bigSucRate, l_bigSucRewardMinRate, l_bigSucRewardMaxRate
    end
    return nil
end
function GetNextLevelInfo(classID)
    local l_skillLevel = GetLv(classID)
    local l_maxLevel = GetMaxLevelByClassID(classID)
    if l_skillLevel >= l_maxLevel then
        return -1
    end
    local l_nextLevel = l_skillLevel + 1
    local l_levelUpNeedTotalExp = 0
    local l_addExpPerReq = 0 --每次使用道具升级增加的经验
    local l_conditions = GetLifeSkillLevelUpConditionByLevel(classID, l_nextLevel)
    if l_conditions ~= nil then
        for i = 1, #l_conditions do
            local l_tempConditionInfo = l_conditions[i]
            if l_tempConditionInfo.type == ELevelUpConditionType.Price then
                ---@type CraftingSkillLvUpPriceTable
                local l_levelUpPriceItem = TableUtil.GetCraftingSkillLvUpPriceTable().GetRowByID(l_tempConditionInfo.param, true)
                if not MLuaCommonHelper.IsNull(l_levelUpPriceItem) then
                    l_levelUpNeedTotalExp = l_levelUpPriceItem.LvUpExp
                    l_addExpPerReq = l_levelUpPriceItem.ExpIncrement
                else
                    l_levelUpNeedTotalExp = 1000
                    logError("CraftingSkillLvUpPriceTable key is not exist:" .. tostring(l_tempConditionInfo.param))
                end
            end
        end
    else
        --已达最大等级
        l_nextLevel = -1
    end
    return l_nextLevel, l_levelUpNeedTotalExp, l_addExpPerReq
end
function GetMaxLevelByClassID(classID)
    local l_maxLevelData = MGlobalConfig:GetSequenceOrVectorInt("CraftingSkillLevelCaps")
    if classID == ClassID.MedicineFusion or classID == ClassID.FoodFusion then
        return l_maxLevelData[1]
    end
    return l_maxLevelData[0]
end
function GetLevelUpLifeSkillParamByType(classID, level, type)
    local l_conditions = GetLifeSkillLevelUpConditionByLevel(classID, level)
    if l_conditions ~= nil then
        for i = 1, #l_conditions do
            local l_tempCondition = l_conditions[i]
            if l_tempCondition.type == type then
                return l_tempCondition.param
            end
        end
    end
    return -1
end
function GetLifeSkillLevelUpConditionByLevel(classID, level)
    local l_craftingSkillItem = TableUtil.GetCraftingSkillTable().GetRowBySkillLv(level, true)
    if MLuaCommonHelper.IsNull(l_craftingSkillItem) then
        return
    end

    local l_levelUpConditionTable = nil
    if classID == ClassID.Cook then
        --厨师
        l_levelUpConditionTable = l_craftingSkillItem.FoodLvUpCond
    elseif classID == ClassID.Drug then
        --制药
        l_levelUpConditionTable = l_craftingSkillItem.MedicineLvUpCond
    elseif classID == ClassID.Sweet then
        --甜品
        l_levelUpConditionTable = l_craftingSkillItem.DessertLvUpCond
    elseif classID == ClassID.Smelt then
        --冶炼武器
        l_levelUpConditionTable = l_craftingSkillItem.SmeltWepLvUpCond
    elseif classID == ClassID.Armor then
        --冶炼防具
        l_levelUpConditionTable = l_craftingSkillItem.SmeltArmorLvUpCond
    elseif classID == ClassID.Acces then
        --冶炼饰品
        l_levelUpConditionTable = l_craftingSkillItem.SmeltAccsLvUpCond
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        l_levelUpConditionTable = l_craftingSkillItem.FoodFusionLvUpCond
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        l_levelUpConditionTable = l_craftingSkillItem.MedicineFusionLvUpCond
    end
    if l_levelUpConditionTable ~= nil and l_levelUpConditionTable[0] ~= nil then
        local l_unlockConditons = {}
        for i = 0, l_levelUpConditionTable.Count - 1 do
            local l_tempConditionInfo = l_levelUpConditionTable[i]
            table.insert(l_unlockConditons, {
                type = l_tempConditionInfo[0],
                param = l_tempConditionInfo[1]
            })
        end
        return l_unlockConditons
    end
    return nil
end
--职业名
function GetCareerName(classID)
    if classID == ClassID.Gather then
        --采集
        return Lang("LifeProfession_Career_Gather")
    elseif classID == ClassID.Mining then
        --挖矿
        return Lang("LifeProfession_Career_Mining")
    elseif classID == ClassID.Fish then
        --钓鱼
        return Lang("LifeProfession_Career_Fish")
    elseif classID == ClassID.Cook then
        --厨师
        return Lang("LifeProfession_Career_Cook")
    elseif classID == ClassID.Drug then
        --制药
        return Lang("LifeProfession_Career_Drug")
    elseif classID == ClassID.Sweet then
        --甜品
        return Lang("LifeProfession_Career_Sweet")
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return Lang("LifeProfession_Career_Smelt")
    elseif classID == ClassID.Armor then
        --冶炼防具
        return Lang("LifeProfession_Career_Armor")
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return Lang("LifeProfession_Career_Acces")
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        return Lang("LifeProfession_Career_FoodFusion")
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        return Lang("LifeProfession_Career_MedicineFusion")
    end
    return GetClassName(classID)
end
--
function GetRowByLv(classID)
    if classID == ClassID.Cook then
        --厨师
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.CookLv)
    elseif classID == ClassID.Drug then
        --制药
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.DrugLv)
    elseif classID == ClassID.Sweet then
        --甜品
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.SweetLv)
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.SmeltLv)
    elseif classID == ClassID.Armor then
        --冶炼防具
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.ArmorLv)
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.AccesLv)
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.FoodFusionLv)
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        return TableUtil.GetCraftingSkillTable().GetRowBySkillLv(Data.MedicineFusionLv)
    end

end

function GetRowRecipeIDByLv(classID)
    local l_craData = GetRowByLv(classID)
    if l_craData == nil then
        return nil
    end
    if IsLifeSkillLock(classID) then
        return nil
    end
    if classID == ClassID.Cook then
        --厨师
        return l_craData.FoodRecipeId
    elseif classID == ClassID.Drug then
        --制药
        return l_craData.MedicineRecipeId
    elseif classID == ClassID.Sweet then
        --甜品
        return l_craData.DessertRecipeId
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return l_craData.SmeltWepRecipeId
    elseif classID == ClassID.Armor then
        --冶炼防具
        return l_craData.SmeltArmorRecipeId
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return l_craData.SmeltAccsRecipeId
    elseif classID == ClassID.FoodFusion then
        --烹饪组合
        return l_craData.FoodFusionRecipeId
    elseif classID == ClassID.MedicineFusion then
        --制药组合
        return l_craData.MedicineFusionRecipeId
    end
    return nil
end
---@Description:获取指定星级食谱数据
---@param recipeItem RecipeTable
---@return RecipeTable
function GetRecipeDataByStar(recipeItem, star)
    if recipeItem == nil then
        return
    end
    if RecipeLinkData ~= nil then
        local l_recipeDatas = RecipeLinkData[recipeItem.RecipeType]
        if l_recipeDatas ~= nil then
            local l_recipeStarDatas = l_recipeDatas[recipeItem.BaseRecipe]
            if l_recipeStarDatas ~= nil then
                for i = 1, #l_recipeStarDatas do
                    ---@type RecipeTable
                    local l_recipeData = l_recipeStarDatas[i]
                    if l_recipeData.Stars == star then
                        return l_recipeData
                    end
                end
            end
        end
    end
    return recipeItem
end

function GetProfessionIconByID(classID)
    local l_atlas = "LifeProfession"
    local l_picName
    if classID == ClassID.Gather then
        l_atlas = "Common"
        l_picName = "UI_LifeProfession_caiji.png"
    elseif classID == ClassID.Mining then
        l_atlas = "Common"
        l_picName = "UI_LifeProfession_caikuang.png"
    elseif classID == ClassID.Fish then
        l_atlas = "Common"
        l_picName = "UI_LifeProfession_diaoyu.png"
    elseif classID == ClassID.Cook then
        l_picName = "LifeProFession_Img_PengRen.png"
    elseif classID == ClassID.Drug then
        l_picName = "LifeProFession_Img_ZhiYao.png"
    elseif classID == ClassID.Sweet then
        --l_picName="UI_LifeProfession_caiji.png"
    elseif classID == ClassID.Smelt then
        l_picName = "LifeProFession_Img_WuQi.png"
    elseif classID == ClassID.Armor then
        l_picName = "LifeProFession_Img_FangJu.png"
    elseif classID == ClassID.Acces then
        --l_picName="UI_LifeProfession_caiji.png"
    elseif classID == ClassID.FoodFusion then
        l_picName = "LifeProFession_Img_ZuHePengen.png"
    elseif classID == ClassID.MedicineFusion then
        l_picName = "LifeProFession_Img_ZuHeZhiYao.png"
    end
    return l_atlas, l_picName
end
function GetProfessionDescByClassID(classID)
    local l_desc
    if classID == ClassID.Gather then
        l_desc = Lang("LifeProfession_GatheringDesc")
    elseif classID == ClassID.Mining then
        l_desc = Lang("LifeProfession_MiningDesc")
    elseif classID == ClassID.Fish then
        l_desc = Lang("LifeProfession_FishingDesc")
    elseif classID == ClassID.Cook then
        l_desc = Lang("LifeProfession_FoodDesc")
    elseif classID == ClassID.Drug then
        l_desc = Lang("LifeProfession_MedicineDesc")
    elseif classID == ClassID.Sweet then

    elseif classID == ClassID.Smelt then
        l_desc = Lang("LifeProfession_WepDesc")
    elseif classID == ClassID.Armor then
        l_desc = Lang("LifeProfession_ArmorDesc")
    elseif classID == ClassID.Acces then

    elseif classID == ClassID.FoodFusion then
        l_desc = Lang("LifeProfession_FoodFusionDesc")
    elseif classID == ClassID.MedicineFusion then
        l_desc = Lang("LIfeProfession_MedicineFusionDesc")
    end
    if l_desc == nil then
        l_desc = "desc not exsit"
    end
    return l_desc
end
function GetAutoCollectState()
    return l_isAutoCollectState
end

function QuitAutoCollect()
    if not GetAutoCollectState() then
        return
    end
    ReqBreakOffAutoCollect()
end

function CanOpenSystem(classID)
    if classID == ClassID.Gather then
        --采集
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionGather)
    elseif classID == ClassID.Mining then
        --挖矿
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionMining)
    elseif classID == ClassID.Fish then
        --钓鱼
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionFish)
    elseif classID == ClassID.Cook then
        --厨师
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionCook)
    elseif classID == ClassID.Drug then
        --制药
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionDrug)
    elseif classID == ClassID.Sweet then
        --甜品
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionSweet)
    elseif classID == ClassID.Smelt then
        --冶炼武器
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionSmelt)
    elseif classID == ClassID.Armor then
        --冶炼防具
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionArmor)
    elseif classID == ClassID.Acces then
        --冶炼饰品
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionAcces)
    elseif classID == ClassID.FoodFusion then
        --冶炼饰品
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionFoodFusion)
    elseif classID == ClassID.MedicineFusion then
        --冶炼饰品
        return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(SystemId.LifeProfessionMedicineFusion)
    end
end

function IsLifeSkillLock(classID)
    local l_skillLevel = GetLv(classID)
    if l_skillLevel > 1 then
        return false
    end
    local l_conditions = GetLifeSkillLevelUpConditionByLevel(classID, 1)
    if l_conditions ~= nil then
        local l_canUnlock = true
        for i = 1, #l_conditions do
            local l_tempLevelUpCondition = l_conditions[i]
            if l_tempLevelUpCondition.type == ELevelUpConditionType.Task then
                --任务解锁
                local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
                local l_taskFInished = l_taskMgr.CheckTaskFinished(l_tempLevelUpCondition.param)
                if not l_taskFInished then
                    l_canUnlock = false
                    break
                end
            elseif l_tempLevelUpCondition.type == ELevelUpConditionType.RoleLevel then
                --角色base等级解锁
                if MPlayerInfo.Lv < l_tempLevelUpCondition.param then
                    l_canUnlock = false
                    break
                end
            end
        end
        return not l_canUnlock
    end

    return false
end

function CanVersionActive(classID)
    local l_row = GetOpenSystemData(classID)
    return l_row ~= nil and l_row.IsOpen == 1
end

function CanGetUnlockLifeSkillTask(taskID)
    local l_acceptTaskLimits = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptLifeSkillLimited(taskID)
    for i = 1, #l_acceptTaskLimits do
        local l_limit = l_acceptTaskLimits[i]
        local l_currentLevel = GetLv(l_limit.ID)
        if l_currentLevel < l_limit.level then
            return false
        end
    end
    return true
end

function CanGetUnlockLifeSkillTaskByClassID(classID)
    local l_skillLevel = GetLv(classID)
    if l_skillLevel > 1 then
        return true
    end
    local l_unlockConditions = GetLifeSkillLevelUpConditionByLevel(classID, 1)
    if l_unlockConditions ~= nil then
        for i = 1, #l_unlockConditions do
            local l_tempUnlockCondition = l_unlockConditions[i]
            if l_tempUnlockCondition.type == ELevelUpConditionType.Task then
                --任务解锁
                return CanGetUnlockLifeSkillTask(l_tempUnlockCondition.param)
            end
        end
    end
    return true
end
function GetOpenSystemData(classID)
    return TableUtil.GetOpenSystemTable().GetRowById(classID)
end
--获取食谱
function GetRecipeRaws(classID)
    local l_datas = {}
    local l_RecipeId = GetRowRecipeIDByLv(classID)
    if RecipeLinkData[classID] == nil then
        return l_datas
    end
    for baseID, l_rows in pairs(RecipeLinkData[classID]) do
        local l_use = nil
        local l_rowCount = #l_rows
        for j = 1, l_rowCount do
            if CanRecipeActive(l_RecipeId, l_rows[j]) then
                l_use = l_rows[j]
                break
            end
        end
        if l_use ~= nil then
            l_datas[#l_datas + 1] = l_use
        else
            l_datas[#l_datas + 1] = l_rows[1]
        end
    end
    return l_datas
end
--食谱是否解锁
function CanRecipeActive(recipeId, row)
    if recipeId == nil then
        return false
    end
    for i = 0, recipeId.Length - 1 do
        if row.ID == recipeId[i] then
            return true
        end
    end
    return false
end
--获取解锁等级
---@param row RecipeTable
function CanRecipeLockLv(row)
    local ret = RecipeUnlockLvMap[row.ID]
    if nil == ret then
        logError("[life profession, id: ]")
        return 0
    end

    return ret
end

--点击交互按钮打开界面
function ClickWindowBtn(eventName, TriggerID)
    local classID = nil
    if eventName == "ENUM_UI_ON_COOKING_SINGLE" then
        classID = ClassID.Cook
    elseif eventName == "ENUM_UI_ON_DRUG" then
        classID = ClassID.Drug
    elseif eventName == "ENUM_UI_ON_SWEET" then
        classID = ClassID.Sweet
    elseif eventName == "ENUM_UI_ON_SMELT" then
        classID = ClassID.Smelt
    elseif eventName == "ENUM_UI_ON_FOODFUSION" then
        classID = ClassID.FoodFusion
    elseif eventName == "ENUM_UI_ON_MEDICINEFUSION" then
        classID = ClassID.MedicineFusion
    else
        return
    end
    if IsLifeSkillLock(classID) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLock"))
        return
    elseif not CanOpenSystem(classID) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
        return
    end
    local l_openUIData = {
        type = l_lifeData.EUIOpenType.LifeProfessionTips,
        classID = classID,
        triggerID = TriggerID,
    }
    UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionProduce, l_openUIData)
end
-- 业务逻辑修改，每个采集动作对应自身的Audio, 挪到 MCollectComponent 上
function CollectStart()
    ----播放采集声音
    --if not m_specialFmodInstance then
    --    m_specialFmodInstance = MAudioMgr:StartFModInstance("event:/UI/Skills/Picking")
    --end
end

function CollectEnd()
    --停止播放采集声音
    --if m_specialFmodInstance then
    --    MAudioMgr:StopFModInstance(m_specialFmodInstance)
    --    m_specialFmodInstance = nil
    --end
end
function GetAutoCollectTip()
    if l_currentAutoCollectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
        return Lang("AUTO_COLLECT_MINING_TIP")
    end
    return Lang("AUTO_COLLECT_TIP")
end
function getAutoStopCollectTip()
    if l_currentAutoCollectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
        return Lang("STOP_COLLECT_MINING_TIP")
    end
    return Lang("STOP_COLLECT_TIP")
end
function ShowLifePropNotEnoughTips(propId)
    if MgrMgr:GetMgr("PropMgr").IsVirtualCoin(propId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COIN_NOT_ENOUGH"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
    end
end
--endregion

--region 私有方法
function setAutoCollectState(state, collectType)
    if l_isAutoCollectState and not state then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(getAutoStopCollectTip())
    end
    l_isAutoCollectState = state
    if state then
        l_currentAutoCollectType = collectType
    end

    EventDispatcher:Dispatch(EventType.AutoCollectStateChanged)
    if state then
        local l_battleUseCollectType = MoonClient.MCollectionType.LifeSkillGarden
        if collectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
            l_battleUseCollectType = MoonClient.MCollectionType.LifeSkillMining
        end
        MEventMgr:LuaFireEvent(MEventType.MEvent_AutoCollect, MEntityMgr.PlayerEntity,
                MPlayerSetting.AutoCollectScope, MEntityMgr.PlayerEntity.Position, l_battleUseCollectType)
    else
        MEventMgr:LuaFireEvent(MEventType.MEvent_EndAutoCollect, MEntityMgr.PlayerEntity)
    end
end
--endregion

--region 协议
--请求合成操作
function SendYuanQiRequest(recipe_id, count, entity_id, wall_id, mType)
    local l_lifeSkillType = GetLifeSkillTypeByClassID(mType)
    if l_lifeSkillType == LifeSkillType.LIFE_SKILL_TYPE_NONE then
        return
    end
    --发送协议
    local l_msgId = Network.Define.Rpc.YuanQiRequest
    ---@type YuanQiRequestArg
    local l_sendInfo = GetProtoBufSendTable("YuanQiRequestArg")
    l_sendInfo.type = l_lifeSkillType
    l_sendInfo.recipe_id = recipe_id
    l_sendInfo.count = count
    l_sendInfo.entity_id = entity_id
    l_sendInfo.wall_id = wall_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--接收合成操作返回
function OnYuanQiRequest(msg, arg)
    local l_argInfo = arg
    ---@type YuanQiRequestRes
    local l_resInfo = ParseProtoBufToTable("YuanQiRequestRes", msg)

    if l_resInfo.result ~= 0 then
        if l_resInfo.result == ErrorCode.ERR_COLLECTION_SYSTEM_NOT_OPEN then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLock"))--技能未解锁
        elseif l_resInfo.result == ErrorCode.ERR_IS_IN_VEHICLE then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILL_IN_BATTLE_VEHICLE"))--骑乘坐骑不能使用
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))--场景物件交互互斥的属性
        end
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.LifeProfessionProduce)
    local l_ActionID = 0
    local l_soundPath = nil
    if l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_FOOD then
        --厨师
        l_ActionID = ClassID.Cook
        l_soundPath = "event:/UI/Skills/Cooking"
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_MEDICINE then
        --制药
        l_ActionID = ClassID.Drug
        l_soundPath = "event:/UI/Skills/Alchemy"
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_DESSERT then
        --甜品
        l_ActionID = ClassID.Sweet
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT then
        --冶炼武器
        l_ActionID = ClassID.Smelt
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_WEAPON then
        --冶炼武器
        l_ActionID = ClassID.Smelt
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_DEFEND then
        --冶炼防具
        l_ActionID = ClassID.Armor
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_ACC then
        --冶炼饰品
        l_ActionID = ClassID.Acces
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_FOOD_FUSION then
        --食品组合
        l_ActionID = ClassID.FoodFusion
    elseif l_argInfo.type == LifeSkillType.LIFE_SKILL_TYPE_MEDICINE_FUSION then
        --制药组合
        l_ActionID = ClassID.MedicineFusion
    end
    local l_actData = TableUtil.GetAnimationTable().GetRowByID(l_ActionID)
    if l_actData == nil then
        logError("制作动作缺损 => type=" .. tostring(l_argInfo.type))
        return
    end
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.LIFE_PROFESSION, false)
    startRemoveSceneUIMaskTimer()
    if l_actData.MaxTime <= 0 then
        MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, MEntityMgr.PlayerEntity)
    else
        --MEventMgr:LuaFireEvent(MEventType.MEvent_Special, MEntityMgr.PlayerEntity, ROGameLibs.kEntitySpecialType_Action, l_ActionID)--1005

        StopSpecial()

        --播放生活技能声音
        if not m_specialFmodInstance and l_soundPath then
            m_specialFmodInstance = MAudioMgr:StartFModInstance(l_soundPath)
        end
        WaitTimer = Timer.New(function(b)
            StopSpecial()
        end, l_actData.MaxTime)
        WaitTimer:Start()
        EventDispatcher:Dispatch(EventType.Anim, l_actData)
    end
end
---@Description:场景交互UI屏蔽后需等待生产结果返回才会解除屏蔽，
---如果没出错返回就会卡死，所以此处加入容错机制，避免卡死
function startRemoveSceneUIMaskTimer()
    stopRemoveSceneUIMaskTimer()
    l_removeSceneUIMaskTimer = Timer.New(function()
        MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.LIFE_PROFESSION, true)
    end, 10, 1, true)
    l_removeSceneUIMaskTimer:Start()
end
function stopRemoveSceneUIMaskTimer()
    if l_removeSceneUIMaskTimer ~= nil then
        l_removeSceneUIMaskTimer:Stop()
        l_removeSceneUIMaskTimer = nil
    end
end
---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[LifeProfessionMgr]")
        return
    end
    EventDispatcher:Dispatch(EventType.OnItemChange)
end
--region new temp===================================================
--采集返回消息
function OnCollectRequest(msgType, errorID, colID)
    local l_data = TableUtil.GetCollectTable().GetRowById(tonumber(colID))
    if l_data == nil then
        return
    end

    if errorID == 0 then
        EventDispatcher:Dispatch(EventType.CollectOver, l_data.Type)
    elseif errorID == ErrorCode.ERR_COLLECTION_SYSTEM_NOT_OPEN then
        if l_data.Type == ClassID.Gather then
            --采集
            local l_acceptTaskLevel = getCollectTaskOpenLevel(l_data.Type)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLockGather", l_acceptTaskLevel, Lang("LifeProfession_Gather")))
            return
        elseif l_data.Type == ClassID.Mining then
            --挖矿
            local l_acceptTaskLevel = getCollectTaskOpenLevel(l_data.Type)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLockGather", l_acceptTaskLevel, Lang("LifeProfession_Mining")))
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLock"))

    elseif errorID == ErrorCode.ERR_LIFE_SKILL_NO_LEFT_TIME then
        if l_data.Type == ClassID.Gather then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_Gather_Rest"))
        elseif l_data.Type == ClassID.Mining then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_Mine_Rest"))
        end
    end
end
function getCollectTaskOpenLevel(systemId)
    l_openData = TableUtil.GetOpenSystemTable().GetRowById(systemId)
    if l_openData == nil then
        return 1
    end
    local l_acceptId = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptBaseLv(l_openData.TaskId[0])
    if l_acceptId < 0 then
        return 1
    end
    return l_acceptId
end
---@param lifeSkillType LifeSkillType
function CanCollect(lifeSkillType,showTips)

    local l_classID = 0
    if lifeSkillType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
        l_classID = ClassID.Mining
    elseif lifeSkillType == LifeSkillType.LIFE_SKILL_TYPE_GARDEN then
        l_classID = ClassID.Gather
    else
        logError("未识别的生活职业，接口只处理采集和挖矿")
    end
    local l_isSysOpen = CanOpenSystem(l_classID)
    if not l_isSysOpen and showTips then
        local l_acceptTaskLevel = getCollectTaskOpenLevel(l_classID)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LifeProfession_SkillLockGather", l_acceptTaskLevel, Lang("LifeProfession_Gather")))

    end
    return l_isSysOpen
end


function OnLifeSkillNtf(msg)
    ---@type LifeSkillRecord
    local l_resInfo = ParseProtoBufToTable("LifeSkillRecord", msg)
    OnLifeSkillInfo(l_resInfo.info)
end

function OnAutoCollectEndNtf(msg)
    ---@type AutoCollectData
    local l_resInfo = ParseProtoBufToTable("AutoCollectData", msg)
    setAutoCollectState(false, l_resInfo.collect_type)
end
function OnUpdateLifeSkillAward(msg)
    ---@type LifeSkillAward
    local l_resInfo = ParseProtoBufToTable("LifeSkillAward", msg)
    local l_resultDatas = {}
    local l_failResultData = nil
    local l_sucResultData = nil
    local l_bigSucResultData = nil
    local l_rewardFromClassID = 0
    for i = 1, #l_resInfo.item do
        ---@type ItemAndReason
        local l_item = l_resInfo.item[i]
        local l_classID, l_produceResult = getRewardInfoByItemReason(l_item.reason)
        if l_classID > 0 then
            l_rewardFromClassID = l_classID
            local l_tempResultData = nil
            if l_produceResult == EProduceResult.BIG_SUCCESS then
                if l_bigSucResultData == nil then
                    l_bigSucResultData = {
                        produceCount = 0,
                        propID = 0,
                        propNum = 0,
                        produceResult = EProduceResult.BIG_SUCCESS
                    }
                end
                l_tempResultData = l_bigSucResultData
            elseif l_produceResult == EProduceResult.SUCCESS then
                if l_sucResultData == nil then
                    l_sucResultData = {
                        produceCount = 0,
                        propID = 0,
                        propNum = 0,
                        produceResult = EProduceResult.SUCCESS
                    }
                end
                l_tempResultData = l_sucResultData
            else
                if l_failResultData == nil then
                    l_failResultData = {
                        produceCount = 0,
                        propID = 0,
                        propNum = 0,
                        produceResult = EProduceResult.FAIL
                    }
                end
                l_tempResultData = l_failResultData
            end
            l_tempResultData.propNum = l_tempResultData.propNum + l_item.item_count
            l_tempResultData.propID = l_item.item_id
            l_tempResultData.produceCount = l_tempResultData.produceCount + 1
        end
    end
    if l_bigSucResultData ~= nil then
        table.insert(l_resultDatas, l_bigSucResultData)
    end
    if l_sucResultData ~= nil then
        table.insert(l_resultDatas, l_sucResultData)
    end
    if l_failResultData ~= nil then
        table.insert(l_resultDatas, l_failResultData)
    end
    stopRemoveSceneUIMaskTimer()
    UIMgr:ActiveUI(UI.CtrlNames.LifeProduceResult, {
        classID = l_rewardFromClassID,
        rewardDatas = l_resultDatas,
    })

end

function OnLifeSkillInfo(infos)
    if infos == nil or #infos <= 0 then
        return
    end

    for i = 1, #infos do
        local l_info = infos[i]
        local l_type = nil
        local l_tempLevel = 1
        local l_tempExp = l_info.exp
        if l_info.level >= 1 then
            l_tempLevel = l_info.level
        end
        if l_info.type == LifeSkillType.LIFE_SKILL_TYPE_FOOD then
            l_type = ClassID.Cook
            Data.CookLv = l_tempLevel
            Data.CookExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_MEDICINE then
            l_type = ClassID.Drug
            Data.DrugLv = l_tempLevel
            Data.DrugExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_DESSERT then
            l_type = ClassID.Sweet
            Data.SweetLv = l_tempLevel
            Data.SweetExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_WEAPON then
            l_type = ClassID.Smelt
            Data.SmeltLv = l_tempLevel
            Data.SmeltExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_DEFEND then
            l_type = ClassID.Armor
            Data.ArmorLv = l_tempLevel
            Data.ArmorExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_SMELT_ACC then
            l_type = ClassID.Acces
            Data.AccesLv = l_tempLevel
            Data.AccesExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_FOOD_FUSION then
            l_type = ClassID.Acces
            Data.FoodFusionLv = l_tempLevel
            Data.FoodFusionExp = l_tempExp
        elseif l_info.type == LifeSkillType.LIFE_SKILL_TYPE_MEDICINE_FUSION then
            l_type = ClassID.Acces
            Data.MedicineFusionLv = l_tempLevel
            Data.MedicineFusionExp = l_tempExp
        else
        end
    end

    EventDispatcher:Dispatch(EventType.DataChange, Data)
end

function ReqAutoCollect(needPropNum, collectType, autoContinue, addRemainTime)
    if needPropNum > 0 then
        local l_costItemId = 0
        if collectType == LifeSkillType.LIFE_SKILL_TYPE_MINING then
            l_costItemId = MGlobalConfig:GetInt("AutoMiningItemID")
        elseif collectType == LifeSkillType.LIFE_SKILL_TYPE_GARDEN then
            l_costItemId = MGlobalConfig:GetInt("AutoGatheringItemID")
        end
        local l_costItem = TableUtil.GetItemTable().GetRowByItemID(l_costItemId)
        if MLuaCommonHelper.IsNull(l_costItem) then
            logError("自动采集消耗的道具ID不存在：" .. tostring(l_costItemId))
            return
        end
        local l_hasPropNum = BagModel:GetBagItemCountByTid(l_costItemId)
        if l_hasPropNum < needPropNum then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
            return
        end
    end

    local l_msgId = Network.Define.Rpc.AutoCollect
    ---@type AutoCollectArg
    local l_sendInfo = GetProtoBufSendTable("AutoCollectArg")
    l_sendInfo.add_time = addRemainTime
    l_sendInfo.collect_type = collectType
    l_sendInfo.is_continue = autoContinue
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnReqAutoCollect(msg, arg)
    ---@type AutoCollectRes
    local l_resInfo = ParseProtoBufToTable("AutoCollectRes", msg)
    if l_resInfo.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        setAutoCollectState(true, arg.collect_type)
    end
end
function ReqGetAutoCollectEndTime(lifeCollectType, fromSceneUI)
    local l_msgId = Network.Define.Rpc.GetAutoCollectEndTime
    ---@type GetAutoCollectEndTimeArg
    local l_sendInfo = GetProtoBufSendTable("GetAutoCollectEndTimeArg")
    l_sendInfo.collect_type = lifeCollectType
    Network.Handler.SendRpc(l_msgId, l_sendInfo, fromSceneUI)
end
function OnGetAutoCollectEndTime(msg, arg, fromSceneUI)
    ---@type GetAutoCollectEndTimeRes
    local l_resInfo = ParseProtoBufToTable("GetAutoCollectEndTimeRes", msg)
    if fromSceneUI then
        if l_resInfo.end_time ~= nil and (l_resInfo.end_time - Common.TimeMgr.GetNowTimestamp() > 0) then
            ReqAutoCollect(0, arg.collect_type, false, 0)
        else
            UIMgr:ActiveUI(UI.CtrlNames.CollectAutoSetting, arg.collect_type)
        end
    end
    EventDispatcher:Dispatch(EventType.OnGetCollectEndTime, l_resInfo.end_time)
end

function ReqLifeSkillUpgrade(classID, costType)
    local l_lifeSkillType = GetLifeSkillTypeByClassID(classID)
    if l_lifeSkillType == LifeSkillType.LIFE_SKILL_TYPE_NONE then
        logError("ReqLifeSkillUpgrade error:None skill type!")
        return
    end
    local l_msgId = Network.Define.Rpc.LifeSkillUpgrade
    ---@type LifeSkillUpgradeArg
    local l_sendInfo = GetProtoBufSendTable("LifeSkillUpgradeArg")
    l_sendInfo.type = l_lifeSkillType
    l_sendInfo.cost_type = costType
    Network.Handler.SendRpc(l_msgId, l_sendInfo, classID)
end
function OnLifeSkillUpgrade(msg, arg, customData)
    ---@type LifeSkillUpgradeRes
    local l_resInfo = ParseProtoBufToTable("LifeSkillUpgradeRes", msg)
    if l_resInfo.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_resInfo.result)
    else
        if l_resInfo.level > 0 then
            EventDispatcher:Dispatch(EventType.LifeSkillLvUp, customData, l_resInfo.level)
        end
    end
end
function ReqBreakOffAutoCollect()
    local l_msgId = Network.Define.Rpc.BreakOffAutoCollect
    ---@type BreakOffAutoCollectArg
    local l_sendInfo = GetProtoBufSendTable("BreakOffAutoCollectArg")
    l_sendInfo.collect_type = l_currentAutoCollectType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnBreakOffAutoCollect(msg)
    ---@type BreakOffAutoCollectRes
    local l_resInfo = ParseProtoBufToTable("BreakOffAutoCollectRes", msg)
    if l_resInfo.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        setAutoCollectState(false)
    end
end
--endregion new temp end
--endregion

function PlaySpecialSound()

end

function StopSpecial()
    --停止生活技能声音
    if m_specialFmodInstance then
        MAudioMgr:StopFModInstance(m_specialFmodInstance)
        m_specialFmodInstance = nil
    end
    if WaitTimer ~= nil then
        WaitTimer:Stop()
        WaitTimer = nil
        MEntityMgr.PlayerEntity:StopState()
        EventDispatcher:Dispatch(EventType.AnimStop)
    end
end

function getRewardInfoByItemReason(itemReason)
    local l_classID = -1
    local l_produceResult = EProduceResult.FAIL
    --成功系列
    if itemReason == ItemChangeReason.ITEM_REASON_COLLECT_FOOD then
        l_classID = ClassID.Cook
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_MEDICINE then
        l_classID = ClassID.Drug
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_DESSERT then
        l_classID = ClassID.Sweet
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT then
        l_classID = ClassID.Smelt
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_WEAPON then
        l_classID = ClassID.Smelt
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_DEFEND then
        l_classID = ClassID.Armor
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_ACC then
        l_classID = ClassID.Acces
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_FOOD_FUSION then
        l_classID = ClassID.FoodFusion
        l_produceResult = EProduceResult.SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_MEDICINE_FUSION then
        l_classID = ClassID.MedicineFusion
        l_produceResult = EProduceResult.SUCCESS
        --大成功系列
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_FOOD_BIG_SUCCESS then
        l_classID = ClassID.Cook
        l_produceResult = EProduceResult.BIG_SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_MEDICINE_BIG_SUCCESS then
        l_classID = ClassID.Drug
        l_produceResult = EProduceResult.BIG_SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_DESSERT_BIG_SUCCESS then
        l_classID = ClassID.Sweet
        l_produceResult = EProduceResult.BIG_SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_WEAPON_BIG_SUCCESS then
        l_classID = ClassID.Smelt
        l_produceResult = EProduceResult.BIG_SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_DEFEND_BIG_SUCCESS then
        l_classID = ClassID.Armor
        l_produceResult = EProduceResult.BIG_SUCCESS
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_ACC_BIG_SUCCESS then
        l_classID = ClassID.Acces
        l_produceResult = EProduceResult.BIG_SUCCESS
        --失败系列
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_FOOD_FAILURE then
        l_classID = ClassID.Cook
        l_produceResult = EProduceResult.FAIL
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_MEDICINE_FAILURE then
        l_classID = ClassID.Drug
        l_produceResult = EProduceResult.FAIL
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_DESSERT_FAILURE then
        l_classID = ClassID.Sweet
        l_produceResult = EProduceResult.FAIL
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_WEAPON_FAILURE then
        l_classID = ClassID.Smelt
        l_produceResult = EProduceResult.FAIL
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_DEFEND_FAILURE then
        l_classID = ClassID.Armor
        l_produceResult = EProduceResult.FAIL
    elseif itemReason == ItemChangeReason.ITEM_REASON_COLLECT_SMELT_ACC_FAILURE then
        l_classID = ClassID.Acces
        l_produceResult = EProduceResult.FAIL
    end
    return l_classID, l_produceResult
end

--技能等级/经验改变
--==============================--
--@Description: 生活技能红点检查方法
--@Date: 2018/8/8
--@Param: [args]
--@Return:
--==============================--
function CheckOpenProfession()
    return 0
end

function OnSelectRoleNtf(roleAllInfo)
    if not rawget(roleAllInfo, "lifeskill") then
        return
    end
    if roleAllInfo.lifeskill == nil then
        return
    end
    OnLifeSkillInfo(roleAllInfo.lifeskill.info)
end

function OpenLifeProfessionWnd(classID, itemID)
    local l_openUIData = {
        classID = classID,
        itemID = itemID,
    }

    UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionMain, l_openUIData)
end

return ModuleMgr.LifeProfessionMgr
