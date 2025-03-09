--死亡引导
module("ModuleMgr.DeathGuideMgr", package.seeall)

l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
l_isDataInit = false
l_deathGuideMinLevel = 0    --显示死亡引导的最小等级
l_deathGuideMaxLevel = 0    --显示死亡引导的最大等级
l_specialSceneType = {}     --特殊死亡场景类型
l_specialSceneIdTable = {}  --特殊不显示死亡引导的Id的Table
l_deathGuidMaxNum = 0       --UI显示的最大数目
l_specialJudgeMent = {}     --特殊场景的特殊显示方式
l_costSortNum = 0           --性价比区间拆分个数
l_costSortTable = {}        --性价比数据Table
l_systemLibrary = {}        --功能库
l_systemLibraryFunc = {}    --功能库函数
l_roleRe = {}               --角色加点判定
l_skillRe = {}              --技能加点判定
l_refineRe = {}             --装备精炼判定
l_enchantRe = {}            --装备附魔判定
l_CardRe = {}               --装备插卡判定
l_onReviveFunc = nil

function InitDeathMgrData(...)
    --最大最小等级
    local levelData = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting("Level").Value, "=")
    l_deathGuideMinLevel = tonumber(levelData[1])
    l_deathGuideMaxLevel = tonumber(levelData[2])
    --特殊死亡场景类型
    local specData = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting("SpecialSceneType").Value, "|")
    for i = 1, #specData do
        table.insert(l_specialSceneType, tonumber(specData[i]))
    end

    --特殊死亡场景Id
    local specIdData = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting("SpecialSceneId").Value, "|")
    for i = 1, #specIdData do
        table.insert(l_specialSceneIdTable, tonumber(specIdData[i]))
    end

    --最大显示UI数量
    l_deathGuidMaxNum = tonumber(TableUtil.GetDeathGuideTable().GetRowBySetting("ShowNumber").Value)

    --性价比排序
    l_costSortNum = tonumber(TableUtil.GetDeathGuideTable().GetRowBySetting("CostSortNumber").Value)
    for i = 1, l_costSortNum do
        local costData = TableUtil.GetDeathGuideTable().GetRowBySetting("CostSortId" .. i).Value
        SetCostData(costData)
    end

    --功能库赋值
    local tempSysLibary = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting("SystemLibrary").Value, "|")
    for i = 1, #tempSysLibary do
        l_systemLibrary[tonumber(tempSysLibary[i])] = {}
    end

    --特殊场景 特殊显示复制
    local tempSpecialJudgeMent = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting("SpecialJudgement").Value, "|")
    for i = 1, #tempSpecialJudgeMent do
        local nowData = string.ro_split(tempSpecialJudgeMent[i], "=")
        if #nowData >= 2 then
            for i = 1, #nowData do
                l_specialJudgeMent[tonumber(nowData[1])] = tonumber(nowData[2])
            end
        else
            logError("配置数据有问题@周阳 SpecialJudgement")
        end
    end
    SetReData(l_roleRe, "role")
    SetReData(l_skillRe, "Skill")
    SetReData(l_refineRe, "Refine")
    SetReData(l_enchantRe, "Enchant")
    SetReData(l_CardRe, "EquipCard")
    --初始化推荐函数
    SetRecommendShowFunc()
end

function SetRecommendShowFunc(...)
    --武器锻造
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.forgeWeapon] = function()
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.forgeWeapon) and not MgrMgr:GetMgr("ForgeMgr").IsBodyEquipMaxLevelWithForge()
    end
    --人物属性
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.MainRoleInfo] = function()
        local l_mRolePoint = MgrMgr:GetMgr("RoleInfoMgr").PlayerAttr.totalQualityPoint
        local l_roleFlag = false;
        for _, v in pairs(l_roleRe) do
            if MPlayerInfo.Lv >= v.min and MPlayerInfo.Lv < v.max and l_mRolePoint ~= nil and l_mRolePoint >= v.point then
                l_roleFlag = true;
            end
        end
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.MainRoleInfo) and l_roleFlag
    end
    --人物技能
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.Skill] = function()
        local leftPoint = DataMgr:GetData("SkillData").GetSkillLeftPoint()
        local l_skillFlag = false;
        for _, v in pairs(l_skillRe) do
            if MPlayerInfo.Lv >= v.min and MPlayerInfo.Lv < v.max and leftPoint ~= nil and leftPoint >= v.point then
                l_skillFlag = true;
            end
        end
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Skill) and l_skillFlag
    end
    --装备精炼
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.Refine] = function()
        local l_refineLevel = -1;
        for _, v in pairs(l_refineRe) do
            if MPlayerInfo.Lv >= v.min and MPlayerInfo.Lv < v.max then
                l_refineLevel = v.point
            end
        end
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Refine) and not MgrMgr:GetMgr("RefineMgr").IsBodyEquipRefineLevelWithAllCanRefinePosition(l_refineLevel)
    end
    --装备附魔
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.Enchant] = function()
        local l_t_enchantNum = 0
        for _, v in pairs(l_enchantRe) do
            if MPlayerInfo.Lv >= v.min and MPlayerInfo.Lv < v.max then
                l_t_enchantNum = v.point
            end
        end
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Enchant) and MgrMgr:GetMgr("EnchantMgr").GetAllEnchantBuffCount() < l_t_enchantNum
    end
    --勋章
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.Medal] = function()
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Medal) and MgrMgr:GetMgr("MedalMgr").GetIsRecommendMedal()
    end
    --插卡
    l_systemLibraryFunc[l_openSystemMgr.eSystemId.EquipCard] = function()
        local l_t_cardNum = 0
        for _, v in pairs(l_CardRe) do
            if MPlayerInfo.Lv >= v.min and MPlayerInfo.Lv < v.max then
                l_t_cardNum = v.point
            end
        end
        return l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.EquipCard) and MgrMgr:GetMgr("EquipMakeHoleMgr").GetAllInsertedCardNum() < l_t_cardNum
    end
end

--结构是
--1是等级={排序Num=功能Id}
--[1] = {[1]=101,[2]=201}
function SetCostData(tableData)
    local nowData = string.ro_split(tableData, "=")
    if #nowData > 2 then
        for i = tonumber(nowData[1]), nowData[2] do
            l_costSortTable[i] = {}
            for z = 3, #nowData do
                l_costSortTable[i][z - 2] = tonumber(nowData[z])
            end
        end
    else
        logError("配置数据有问题@周阳")
    end
end

--主要接口 做是否需要显示希望引导的逻辑判断
function IsShowDeathGuild(...)
    local isInLevel = false --在等级区间里面
    local isShowLog = false --调试用 默认为False
    local isSpecialScene = false --是否是特殊场景的判断
    local isNoDeathGuildScene = false   --是否是不需要显示死亡引导的场景

    if MPlayerInfo.Lv >= l_deathGuideMinLevel and MPlayerInfo.Lv <= l_deathGuideMaxLevel then
        isInLevel = true
    else
        return false
    end

    --不显示死亡引导的场景判断
    for i = 1, #l_specialSceneType do
        local sceneInfo = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
        if sceneInfo and l_specialSceneType[i] == tonumber(sceneInfo.SceneType) then

            isNoDeathGuildScene = true
            break
        end
    end

    if isInLevel then
        --特殊场景不显示死亡引导
        for k, v in pairs(l_specialSceneIdTable) do
            if v == MScene.SceneID then
                return false
            end
        end

        ----特殊场景 特殊显示判断
        --for k, v in pairs(l_specialJudgeMent) do
        --    if k == MScene.SceneID then
        --        ----如果当前功能已经满级 则不推荐
        --        --local isRec = true
        --        --if l_systemLibraryFunc[v] and not l_systemLibraryFunc[v]() then
        --        --    isRec = false
        --        --end
        --        return isRec, GetLevelRecommend()
        --    end
        --end

        if isNoDeathGuildScene then
            --特殊场景触发
            return false
        else
            --常规场景死亡 等级满足常规触发
            return true, GetLevelRecommend()
        end
    end

    return false
end

--获取当前等级的推荐
function GetLevelRecommend()
    local funcTb = {}
    local addNum = 0
    MgrMgr:GetMgr("RoleNurturanceMgr").RefreshData()
    ---@type NurturanceRowData[]
    local sortTable = DataMgr:GetData("RoleNurturanceData").GetNurturanceData()
    for i = 1, #sortTable do
        if addNum < l_deathGuidMaxNum then
            addNum = addNum + 1
            table.insert(funcTb, sortTable[i].SystemID)
        end
    end
    return funcTb
end

function OnEnterScene(sceneId)
    if l_onReviveFunc then
        l_onReviveFunc()
        l_onReviveFunc = nil
    end
end

--是否在复活后立刻执行回调
function OnReviveDoFunc()
    local sceneInfo = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    if sceneInfo ~= nil then
        if sceneInfo.ReviveType == 1 or sceneInfo.ReviveType == 2 or sceneInfo.ReviveType == 3 then
            return true
        else
            --玩家处于普隆德拉 直接执行
            if sceneInfo.ReviveType == 4 and MScene.SceneID == MgrMgr:GetMgr("KplFunctionMgr").l_reviveSceneId then
                return true
            else
                return false
            end
        end
    end
    return false
end

function SetReData(l_tab, l_tit)
    local l_temStr = string.ro_split(TableUtil.GetDeathGuideTable().GetRowBySetting(l_tit).Value, "|")
    for i = 1, #l_temStr do
        local l_nowData = string.ro_split(l_temStr[i], "=")
        if #l_nowData >= 3 then
            local tmpt = {}
            tmpt.min = tonumber(l_nowData[1])
            tmpt.max = tonumber(l_nowData[2])
            if tmpt.max == -1 then
                tmpt.max = 999
            end
            tmpt.point = tonumber(l_nowData[3])
            table.insert(l_tab, tmpt)
        else
            logError("配置数据有问题@周阳 " .. l_tit)
        end
    end
end

--Require之后立刻初始化数据
InitDeathMgrData()

return ModuleMgr.DeathGuideMgr
