--lua model
module("ModuleData.SkillData", package.seeall)
--lua model end
--lua custom scripts

--URL：config\Table\CSV\SkillTipsLinkTable.csv
skillTipsLinkTable = {}
--URL：config\Table\CSV\elementAttr.csv
elementAttrTable = {}
--URL：config\Table\CSV\skillTable.csv
skillTable = {}
--URL：config\Table\CSV\PassivitySkillEffectTable.csv
passivityEffectTable = {}
--URL：config\Table\CSV\SkillEffectTable.csv
effectTable = {}
--URL：config\Table\CSV\ProfessionTable.csv
professionTable = {}
--URL：config\Table\CSV\AutoAddSkillPointTable.csv
autoAddSkillPointTable = {}
--URL：config\Table\CSV\AutoAddSkilPointDetailTable.csv
autoAddSkilPointDetailTable = {}
--URL：config\Table\CSV\ProfessionPreviewTable.csv
professionPreviewTable = {}
--URL：config\Table\CSV\TaskTable\TaskChangeJobTable.csv
taskChangeJobTable = {}
--URL：config\Table\CSV\BuffTable\BuffTable.csv
buffTable = {}
--URL：config\Table\CSV\AttrDecision.csv
attrDecisionTable = {}
--URL：config\Table\CSV\SkillClassRecommandTable.csv
skillClassRecommandTable = {}

--保存技能时，玩家当前所选择的技能等级
chooseLv = 1
remainingPoint = 0
useMaxLevel = false

--UI打开执行方法
OpenType =
{
    --SkillLearningCtrl
    --RecommandAddSkillPoint = 1,
    OpenProfessionalSchools = 2,
    SetTargetSkillId = 3,
    AutoSetting = 4,
    OpenSkillSetting = 5,
    ResetSkills = 6,
    DirectOpenPreview = 7,
    --SkillAttrCtrl
    ShowSkillInfo = 8,
    --SkillLevelUpgradingCtrl
    SetLevelUpdateData = 9,
    --SkillPointTipCtrl
    SetSkillTip = 10,
    DropSkillTip = 11,
    ShowSkillTip = 12,
    --SkillPreviewCtrl
    SetSkillPreviewInfo = 13
}

OpenTog =
{
    SKILL_POINT_PANEL = 1,
    SKILL_BUTTON_SETTING = 2,
    SKILL_PREVIEW = 3,
    SKILL_JOBADDTION = 4,
    SKILL_QUEUE_SETTING = 5
}
--技能提示显示类型
SkillTipState =
{
    INACTIVE_STATE = 1,
    ACTIVE_ZERO_LV_STATE = 2,
    ACTIVE_STATE = 3,
    MAX_LV_STATE = 4,
    SELECT_LV_STATE = 5,
    SELECT_SHOW_SLOT = 6,
    BUFF_SKILL = 7,
    SPECIAL_SKILL = 8
}

ProfessionList =
{
    BASE_SKILL = 0,          --1000：初心者
    PRO_ONE = 1,             --x000：一转
    PRO_TWO = 2,             --xx01：二转
    PRO_THREE = 3,           --xx02：二转进阶
    PRO_FOUR = 4,            --未开放
    MAX_TYPE = 4
}

SkillQueueId = MGlobalConfig:GetInt("QueueSkillId")         --玩家技能队列ID
SkillPlans = {}              --玩家技能加点方案
PlanNames = {}               --玩家技能加点方案名，下标对应技能加点方案
OpenPlanIds = {}             --玩家已经开启的技能页（无序）
JobAwardHasBeenTaked = {}    --玩家已经领取的职业奖励
ProfessionSkillListTable = {}
SavedSkillIds = {}
AddedSkillPoint = {}         --玩家加点列表

CurrentMaxProType = 3                                   --当前玩家最高转职等级
SlotCount = MGlobalConfig:GetInt("MaxSlotNum")          --玩家的单页技能槽数量
JobAwardData = array.group(TableUtil.GetJobAwardTable().GetTable(), "ProfessionID")            --玩家职业奖励数据
--玩家允许转职基础等级
BaseChangeLevel = string.ro_split(TableUtil.GetGlobalTable().GetRowByName("BaseChangeLevel").Value, "|")
--玩家允许转职职业等级
JobChangeLevel = string.ro_split(TableUtil.GetGlobalTable().GetRowByName("JobChangeLevel").Value, "|")
--------------------------------------------------- ↓↓↓ 生命周期 ↓↓↓ ----------------------------------------------------

function Init()

    ReadTable()

end

function Logout()

    UnInit()

end

--------------------------------------------------- ↑↑↑ 生命周期 ↑↑↑ ----------------------------------------------------

--------------------------------------------------- ↓↓↓ 内部方法 ↓↓↓ ----------------------------------------------------

function ReadTable()

    skillTipsLinkTable = TableUtil.GetSkillTipsLinkTable()
    elementAttrTable = TableUtil.GetElementAttr()
    attrDecisionTable = TableUtil.GetAttrDecision()
    skillTable = TableUtil.GetSkillTable()
    passivityEffectTable = TableUtil.GetPassivitySkillEffectTable()
    effectTable = TableUtil.GetSkillEffectTable()
    professionTable = TableUtil.GetProfessionTable()
    professionPreviewTable = TableUtil.GetProfessionPreviewTable()
    autoAddSkillPointTable = TableUtil.GetAutoAddSkillPointTable()
    autoAddSkilPointDetailTable = TableUtil.GetAutoAddSkilPointDetailTable()
    taskChangeJobTable = TableUtil.GetTaskChangeJobTable()
    buffTable = TableUtil.GetBuffTable()
    skillClassRecommandTable = TableUtil.GetSkillClassRecommandTable()
    qteSkillTable = TableUtil.GetQTESkillTable()

end

--初始化职业奖励已领取情况
function InitJobAwardTaked(info)

    JobAwardHasBeenTaked = {}
    if not info then return end
    for i, v in ipairs(info) do
        if not JobAwardHasBeenTaked[v.profession_id] then
            JobAwardHasBeenTaked[v.profession_id] = {}
        end
        table.insert(JobAwardHasBeenTaked[v.profession_id], v.level)
    end

end

--初始化技能方案
function InitSkillPlan(info)

    SkillPlans = {}
    OpenPlanIds = {}
    PlanNames = {}
    if not info then return end
    for i, v in ipairs(info) do
        table.insert(SkillPlans, v)
        table.insert(OpenPlanIds, i)
        table.insert(PlanNames, v.name)
    end

end

--更新职业奖励已领取情况
function AddJobAwardTaked(val)
    JobAwardHasBeenTaked[val] = {}
end

--更新技能方案
function UpdateSkillPlan(index, val)
    SkillPlans[index] = val
end

--更新技能方案名字
function UpdateSkillPlanName(index, val)
    PlanNames[index] = val
end

--添加技能方案页
function AddSkillPlanId(val)
    table.insert(OpenPlanIds, val)
end

--获取职业等级奖励状态
function GetJobAwardItemStatus(proId, jobLv, realJobLv)

    local proIds = GetProfessionIdList()
    if JobAwardHasBeenTaked[proId] and array.indexof(JobAwardHasBeenTaked[proId], jobLv) > 0 then
        return GameEnum.JobAwardItemStatus.Taked
    end
    local _, idx = array.find(proIds, function(v) return v == proId end)
    if idx then
        if idx < #proIds then
            return GameEnum.JobAwardItemStatus.CanTake
        elseif idx == #proIds then
            local playerJobLv = MPlayerInfo.JobLv
            if playerJobLv >= realJobLv then
                return GameEnum.JobAwardItemStatus.CanTake
            else
                return GameEnum.JobAwardItemStatus.Lock
            end
        end
    else
        return GameEnum.JobAwardItemStatus.Lock
    end

end

function UnInit()

    chooseLv = nil
    remainingPoint = nil
    useMaxLevel = nil

    SkillPlans = {}
    OpenPlanIds = {}
    PlanNames = {}
    JobAwardHasBeenTaked = {}

end

--------------------------------------------------- ↑↑↑ 内部方法 ↑↑↑ ----------------------------------------------------

--------------------------------------------------- ↓↓↓ 外部接口 ↓↓↓ ----------------------------------------------------

-------------------------- ↓↓↓ 玩家职业并查集 ↓↓↓ --------------------------

ProUnion = {}
function UnionClear()
    ProUnion = {}
end

function UnionFind(node)
    if ProUnion[node] == nil then
        return node
    end
    ProUnion[node] = UnionFind(ProUnion[node])
    return ProUnion[node]
end

function UnionConnect(son, father)
    if son == father then
        logError("请勿将相同元素加入同一个并查集")
        return
    end
    ProUnion[son] = father
end

-------------------------- ↑↑↑ 玩家职业并查集 ↑↑↑ --------------------------

--获得已经加完点后的技能点数，第二个参数为true则只会返回当前UI界面的额外加点数
function GetAddedSkillPoint(skillId, isNotCount)

    local l_oldLv = MPlayerInfo:GetCurrentSkillInfo(skillId).lv
    local l_addLv = AddedSkillPoint[skillId] or 0
    if isNotCount then
        return l_addLv
    end
    return l_oldLv + l_addLv

end

--返回玩家已学习的固定技能列表
function FixSkillList()

    local fixedSkillList  = {}
    local l_csList = MPlayerInfo.FixedSkillIdList
    for i = 0, l_csList.Count-1 do
        fixedSkillList[i + 1] = l_csList:get_Item(i)
    end
    return fixedSkillList

end

--当前技能所需要的前置任务
function GetRequiredTask(skillId)

    local openSkillTable = TableUtil.GetOpenSkillTable().GetTable()
    local needTaskId
    for k, v in pairs(openSkillTable) do
        local skillIds = v.SkillIds
        for i = 0, skillIds.Length - 1 do
            if skillIds[i] == skillId then
                needTaskId = v.TaskId
                break
            end
        end
        if needTaskId ~= nil then
            break
        end
    end
    return needTaskId

end

--是否处于激活状态
function IsSkillActive(skillInfo)

    --前置技能点是否加满
    local l_proType = GetSkillProType(MPlayerInfo:GetRootSkillId(skillInfo.Id))
    if not IsProfessionPointFull(l_proType) then
        return false
    end

    --前置技能是否满足条件
    local preSkillRequired = skillInfo.PreSkillRequired
    if preSkillRequired.Count > 0 then
        local index = 0
        while preSkillRequired.Count > index do
            local preSkillId = preSkillRequired:get_Item(index, 0)
            local preSkillRequiredLv = preSkillRequired:get_Item(index, 1)
            local currentLv = MPlayerInfo:GetCurrentSkillInfo(preSkillId).lv + (AddedSkillPoint[preSkillId] or 0)
            if currentLv < preSkillRequiredLv then
                return false
            end
            index = index + 1
        end
    end

    --TODO，这里调用了任务管理器中的CheckTaskFinished方法，但事实上这个方法应该在Data中，需要任务系统重构完成之后修改
    local needTaskId = GetRequiredTask(skillInfo.Id)
    if needTaskId ~= nil then
        if not MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(needTaskId) then
            return false
        end
    end
    return true

end

--根据职业类型获取BaseLevel、JobLevel
function GetNeedBaseAndJobLvByProType(proType)

    local jobLv = -1
    local skillPointLv
    if proType > CurrentMaxProType then
        logError(StringEx.Format("invalid proType:{0} ", proType))
        return -1, jobLv
    end
    skillPointLv = string.ro_split(TableUtil.GetGlobalTable().GetRowByName("SkillPointDisplay").Value, "|")
    if proType > 0 and proType < CurrentMaxProType + 1 then
        jobLv = tonumber(skillPointLv[proType + 1])
    else
        jobLv = 0
    end
    return tonumber(BaseChangeLevel[proType]) or 0, jobLv

end

--获取所有职业信息
function GetProfessionInfo()

    local l_professionTable = {}
    l_professionTable[ProfessionList.BASE_SKILL] =
    {
        id = ProfessionList.BASE_SKILL,
        proId = MPlayerInfo.BaseProId
    }
    l_professionTable[ProfessionList.PRO_ONE] =
    {
        id = ProfessionList.PRO_ONE,
        proId = MPlayerInfo.ProOneId
    }
    l_professionTable[ProfessionList.PRO_TWO] =
    {
        id = ProfessionList.PRO_TWO,
        proId = MPlayerInfo.ProTwoId
    }
    l_professionTable[ProfessionList.PRO_THREE] =
    {
        id = ProfessionList.PRO_THREE,
        proId = MPlayerInfo.ProThreeId
    }
    l_professionTable[ProfessionList.PRO_FOUR] =
    {
        id = ProfessionList.PRO_FOUR,
        proId = MPlayerInfo.ProFourId
    }
    return l_professionTable

end

function GetSkillProType(skillId)

    local l_proTypeList = GetProfessionInfo()
    for k, v in pairs(l_proTypeList) do
        if v.proId == 0 then
            break
        end
        if ProfessionSkillListTable[v.proId] == nil then
            local l_professionRow = GetDataFromTable("ProfessionTable", v.proId)
            local l_skillIdsVectorSeq = l_professionRow.SkillIds
            local l_skillIdList = Common.Functions.VectorSequenceToTable(l_skillIdsVectorSeq)
            ProfessionSkillListTable[v.proId] = l_skillIdList
        end
        for k1, v1 in pairs(ProfessionSkillListTable[v.proId]) do
            if v1[1] == skillId then
                return k
            end
        end
    end
    return 0

end

function GetRootSkillIdByPath(skillId, professionList)

    if not professionList then
        professionList = Common.Functions.ListToTable(MPlayerInfo.ProfessionIdList)
    end
    local l_realProfessionRow, l_index, l_rootSkills, l_result
    for i, v in ipairs(professionList) do
        l_realProfessionRow = GetDataFromTable("ProfessionTable", v)
        l_index = 0
        l_rootSkills = l_realProfessionRow.RootTransfromSkills
        while l_index < l_rootSkills.Count do
            if l_rootSkills:get_Item(l_index, 1) == skillId then
                l_result = l_rootSkills:get_Item(l_index, 0)
                return l_result
            end
            l_index = l_index + 1
        end
    end
    return skillId

end

--获得转职列表
function GetNextProfessionList(professionId)

    local l_professionTable = professionTable.GetTable()
    local l_result = {}
    for k, v in pairs(l_professionTable) do
        if v.ParentProfession == professionId then
            l_result[#l_result + 1] = v.Id
        end
    end
    return l_result

end

--获取某职业的技能点数信息
function GetAddedProfessionSkillPointNumber(professionId)

    local l_tableRow = GetDataFromTable("ProfessionTable", professionId)
    if l_tableRow == nil then
        logError("invalid professonID, id = "..professionId)
        return 0
    end
    local l_proSkills = l_tableRow.SkillIds
    local l_addedSum = 0
    for i = 0, l_proSkills.Length - 1 do
        local l_currentSkillId = l_proSkills[i][0]
        if NeedSkillPointToLearn(l_currentSkillId) then
            l_addedSum = l_addedSum + GetAddedSkillPoint(l_currentSkillId)
        end
    end
    return l_addedSum

end

function GetAddedProfessionSkillPointNumberByProType(proType)

    local l_professionTable = GetProfessionInfo()
    local l_professionId = l_professionTable[proType].proId
    return GetAddedProfessionSkillPointNumber(l_professionId)

end

--获得所有前置职业的点数之和
function GetPreProfessionPointSum(professionType)

    local l_professionTable = GetProfessionInfo()
    local l_pointSum = 0

    --计算技能点数之和
    for i = 1, professionType - 1 do
        if l_professionTable[i].proId ~= 0 then
            l_pointSum = l_pointSum + GetAddedProfessionSkillPointNumber(l_professionTable[i].proId)
        end
    end

    return l_pointSum

end

--获得需要的技能点数
function GetRequiredSkillPoint(professionType)

    local l_professionTable = GetProfessionInfo()
    local l_professionId = l_professionTable[professionType].proId
    local l_professionInfo = GetDataFromTable("ProfessionTable", l_professionId)
    if l_professionInfo == nil then
        return 0
    end
    return l_professionInfo.SkillPointRequired

end

--是否用完了当前职业获得的所有技能点数
function IsUseUpAllCurrentProfessionSkillPoint(proType)

    local l_proId = GetProfessionId(proType)
    if l_proId == 0 then return 0 end

    local l_learnedSkillPoint = GetAddedProfessionSkillPointNumber(l_proId)
    local _, needSkillPoint = GetNeedBaseAndJobLvByProType(proType)
    if l_learnedSkillPoint < needSkillPoint then
        return -1
    elseif l_learnedSkillPoint > needSkillPoint then
        return 1
    end
    return 0

end

--判断前置技能点是否已经点满
function IsProfessionPointFull(professionType)

    --二转之前无门槛
    if professionType < ProfessionList.PRO_TWO then
        return true
    end
    return GetPreProfessionPointSum(professionType) >= GetRequiredSkillPoint(professionType)

end

--获取所有技能点
function GetTotalSkillPointByLevel(lv)

    local skillPoint = 0
    lv = lv or MPlayerInfo.JobLv
    if lv < 10 then
        skillPoint = 0
    else
        skillPoint = lv - 10
    end
    return skillPoint

end

--获取剩余技能点
function GetSkillLeftPoint()

    local skillList = MPlayerInfo.SkillList
    local leftSkillPoint = GetTotalSkillPointByLevel()

    local index = 0
    while index < skillList.Count do
        if NeedSkillPointToLearn(skillList[index].id) then
            leftSkillPoint = leftSkillPoint - skillList[index].lv
        end
        index = index + 1
    end
    return leftSkillPoint

end

--根据当前的职业获取开放的技能
function GetOpenSkillIdsByProType()

    local curProType, curProId = CurrentProTypeAndId()
    local proInfos = FormatProInfos()
    local autoSkillQueue = {}
    local professionSdata, len, skillId
    for i, v in ipairs(proInfos) do
        if v.proId > 0 then
            professionSdata = GetDataFromTable("ProfessionTable", v.proId)
            if not professionSdata then
                logError("read professionSdata fail with proId = ", v.proId)
            end
            len = professionSdata.SkillIds:size()
            for k = 0, len - 1 do
                skillId = professionSdata.SkillIds[k][0]
                if not autoSkillQueue[skillId] then autoSkillQueue[skillId] = true end
            end
        else
            break
        end
    end
    return autoSkillQueue

end

--根据职业id获取职业技能集合
function GetProfessionSkillsByProId(proId)

    local ret = {}
    local professionSdata = GetDataFromTable("ProfessionTable", proId)
    if not professionSdata then
        logError("read professionSdata fail with proId = ", proId)
    end
    local len = professionSdata.SkillIds:size()
    for k = 0, len - 1 do
        skillId = professionSdata.SkillIds[k][0]
        if not ret[skillId] then ret[skillId] = true end
    end
    return ret

end

--当前职业加点是否和推荐一致
function IsSameWithAutoSkillQueue(proId, autoSkillQueue)

    local ret = true
    local proSkills = GetProfessionSkillsByProId(proId)
    local l_skillId, l_skillLv, learnSkillLv
    local autoSkills = {}
    for i = 0, autoSkillQueue.Count - 1 do
        l_skillId, l_skillLv = autoSkillQueue:get_Item(i, 0), autoSkillQueue:get_Item(i, 1)
        autoSkills[l_skillId] = l_skillLv
    end
    for skillId, _ in pairs(proSkills) do
        learnSkillLv = MPlayerInfo:GetCurrentSkillInfo(skillId).lv
        if learnSkillLv > 0 then
            if not autoSkills[skillId] or autoSkills[skillId] ~= learnSkillLv then
                ret = false
                break
            end
        else
            if autoSkills[skillId] then
                ret = false
                break
            end
        end
    end
    return ret

end

--判断是否是法师第一个远程技能
function MageFirstFarSkill(skillId)

    if skillId == 400010 or skillId == 400005 or skillId == 400001 or
        skillId == 400003 or skillId == 300001 then
        return true
    end
    return false

end

--判断是否骑士学习了骑术
function KnightFirstRiding(skillId)
    return skillId == 210106
end

--获取当前职业职业等级奖励
function GetProfessionJobAwards(proId)

    if not proId then
        _, proId = CurrentProTypeAndId()
    end
    return JobAwardData[proId]

end

--获取当前职业对应等级奖励
function GetJobAwardByProAndLevel(proId, level)

    if not proId then
        _, proId = CurrentProTypeAndId()
    end
    if JobAwardData[proId] then
        for i, v in ipairs(JobAwardData[proId]) do
            if v.NeedJobLvl == level then
                return v
            end
        end
    end

end

--排序规则
function CompareSkill(skillId1, skillId2)

    local skillInfo1 = GetDataFromTable("SkillTable", skillId1)
    local skillInfo2 = GetDataFromTable("SkillTable", skillId2)
    local pos1 = skillInfo1.SkillPanelPos
    local sum1 = pos1:get_Item(0) * 10 + pos1:get_Item(1)
    local pos2 = skillInfo2.SkillPanelPos
    local sum2 = pos2:get_Item(0) * 10 + pos2:get_Item(1)
    if sum1 > sum2 then
        return 1
    elseif sum1 == sum2 then
        return 0
    else
        return -1
    end

end

--技能排序
function SortSkill(table)

    for i = 1, #table do
        for j = 1, #table do
            if CompareSkill(table[i], table[j]) < 0 then
                local temp = table[i]
                table[i] = table[j]
                table[j] = temp
            end
        end
    end
    return table

end

--获取技能最大等级，必须传入skillInfo，skillInfo可以通过GetTipSkillInfo方法获得
function GetMaxLv(skillInfo)
    return skillInfo.EffectIDs.Length
end

--考虑职业继承，获取根技能ID
function GetRootSkillId(rawId)
    return MPlayerInfo:GetRootSkillId(rawId)
end

--当前技能是否满级，必须传入skillInfo，skillInfo可以通过GetTipSkillInfo方法获得
function IsLvMax(skillInfo) --, skillInfo.InfoSource:ToInt() == 1

    if MPlayerInfo:GetCurrentSkillInfo(skillInfo.Id).lv == GetMaxLv(skillInfo) then
        return true
    end
    return false

end

--获取职业对应的SkillId，需传入技能ID，可选传入职业List
function GetProfessionSkillId(rawId, professionList)

    if not professionList then
        professionList = Common.Functions.ListToTable(MPlayerInfo.ProfessionIdList)
    end
    local realProfessionRow, index, RootSkills, result
    result = rawId
    for i, v in ipairs(professionList) do
        realProfessionRow = GetDataFromTable("ProfessionTable", v)
        index = 0
        RootSkills = realProfessionRow.RootTransfromSkills
        while index < RootSkills.Count do
            if RootSkills:get_Item(index, 0) == rawId then
                result = RootSkills:get_Item(index, 1)
            end
            index = index + 1
        end
    end
    return result

end

--获得基础技能Id
function GetBaseProId()
    return MPlayerInfo.BaseProId
end

function GetProOneId()
    return MPlayerInfo.ProOneId
end

function GetProTwoId()
    return MPlayerInfo.ProTwoId
end

function GetProThreeId()
    return MPlayerInfo.ProThreeId
end

function GetProFourId()
    return MPlayerInfo.ProFourId
end

--是否是初始技能
function IsFixed(skillId)
    return MPlayerInfo:IsFixedSkill(skillId)
end

--是否是需解锁的技能（装死、紧急治疗）
function IsUnlockFixed(skillId)
    return MPlayerInfo:IsFixedUnlockSkill(skillId)
end

--该技能是否需要前置技能
function IfNeedTask(skillId)
    return MPlayerInfo:NeedTaskFinish(skillId)
end

--是否需要点数才能学习（并且只有一级）
function NeedSkillPointToLearn(skillId)
    if skillId == SkillQueueId then
        return false
    end
    return MPlayerInfo:NeedSkillPointToLearn(skillId)
end
--获取职业Id
function GetProfessionId(proType)

    local proId = 0
    if proType == ProfessionList.BASE_SKILL then
        proId = GetBaseProId()
    elseif proType == ProfessionList.PRO_ONE then
        proId = GetProOneId()
    elseif proType == ProfessionList.PRO_TWO then
        proId = GetProTwoId()
    elseif proType == ProfessionList.PRO_THREE then
        proId = GetProThreeId()
    elseif proType == ProfessionList.PRO_FOUR then
        proId = GetProFourId()
    end
    return proId

end

--获取当前玩家准备保存的技能等级
function GetChooseLv()
    return chooseLv
end

--更新当前玩家准备保存的技能等级
function SetChooseLv(level)
    chooseLv = level
end

--获取当前玩家的剩余技能点
function GetRemainingPoint()
    return remainingPoint
end

function SetRemainingPoint(RemainingPoint)
    remainingPoint = RemainingPoint
end

--获取当前玩家是否默认配备最高级技能
function GetUseMaxLevel()
    return useMaxLevel
end

function SetUseMaxLevel(UseMaxLevel)
    useMaxLevel = UseMaxLevel
end --func end

--技能方案开启数量
function GetSkillPlanOpenCount()
    return #SkillPlans
end

--某个技能方案是否开启
function IsSkillPlanOpen(index)
    return SkillPlans[index] ~= nil
end

--返回指定技能方案
function GetCurSkillPlan(index)
    return SkillPlans[index]
end

--返回指定技能方案名字
function GetCurSkillPlanName(index)
    return PlanNames[index]
end

--判断当前技能页是否开启
function IsPageOpen(index)
    return array.contains(OpenPlanIds, index)
end

--获取表中的数据，表的名字/搜索主键，只支持ID/是否不需要判空
function GetDataFromTable(tableName, ID, isNeedJudge)

    local _val
    if tableName == "SkillTable" and skillTable ~= nil then
        _val = skillTable.GetRowById(ID, true)
    elseif tableName == "ElementAttr" and elementAttrTable ~= nil then
        _val = elementAttrTable.GetRowByAttrId(ID, true)
    elseif tableName == "AttrDecision" and attrDecisionTable ~= nil then
        _val = attrDecisionTable.GetRowById(ID, true)
    elseif tableName == "SkillTipsLinkTable" and skillTipsLinkTable ~= nil then
        _val = skillTipsLinkTable.GetRowByID(ID, true)
    elseif tableName == "PassivitySkillEffectTable" and passivityEffectTable ~= nil then
        _val = passivityEffectTable.GetRowById(ID, true)
    elseif tableName == "SkillEffectTable" and effectTable ~= nil then
        _val = effectTable.GetRowById(ID, true)
    elseif tableName == "AutoAddSkillPointTable" and autoAddSkillPointTable ~= nil then
        _val = autoAddSkillPointTable.GetRowByProfessionId(ID, true)
    elseif tableName == "AutoAddSkilPointDetailTable" and autoAddSkilPointDetailTable ~= nil then
        _val = autoAddSkilPointDetailTable.GetRowByID(ID, true)
    elseif tableName == "ProfessionTable" and professionTable ~= nil then
        _val = professionTable.GetRowById(ID, true)
    elseif tableName == "ProfessionPreviewTable" and professionPreviewTable ~= nil then
        _val = professionPreviewTable.GetRowByProfessionId(ID, true)
    elseif tableName == "TaskChangeJobTable" and taskChangeJobTable ~= nil then
        _val = taskChangeJobTable.GetRowByTargetJobId(ID, true)
    elseif tableName == "BuffTable" and buffTable ~= nil then
        _val = buffTable.GetRowById(ID, true)
    elseif tableName == "SkillClassRecommandTable" and skillClassRecommandTable ~= nil then
        _val = skillClassRecommandTable.GetRowById(ID, true)
    end

    if _val == nil and (not isNeedJudge) then
        logError("{0}中找不到数据：ID为：{1}", tableName, ID)
    end
    return _val

end

function GetTipSkillInfo(skillId, customLv)

    local skillInfo = {}
    local MskillInfo
    if customLv == nil then
        MskillInfo = MPlayerInfo:GetCurrentSkillInfo(skillId)
        if MskillInfo.id == 0 then
            MskillInfo = MskillInfo.New()
            MskillInfo.id = skillId
            MskillInfo.lv = 1
        end
        skillInfo.id = MskillInfo.id
        skillInfo.lv = MskillInfo.lv
        skillInfo.effectId = MskillInfo.currentSkillEffectId
        skillInfo.detail = GetDataFromTable("SkillTable", skillId)
        if skillInfo.detail.SkillTypeIcon ~= 3 then
            skillInfo.effectDetail = GetDataFromTable("SkillEffectTable", skillInfo.effectId)
        else
            skillInfo.effectDetail = GetDataFromTable("PassivitySkillEffectTable", skillInfo.effectId)
        end
    else
        skillInfo.id = skillId
        if customLv == 0 then customLv = 1 end
        skillInfo.lv = customLv
        skillInfo.detail = GetDataFromTable("SkillTable", skillId)
        skillInfo.effectId = skillInfo.detail.EffectIDs[customLv - 1]
        if skillInfo.effectId == nil then
            logError("数据出错：EffectIDs不存在，不存在等级为{0}的技能{1}", customLv - 1, skillId)
            return
        end
        if skillInfo.detail.SkillTypeIcon ~= 3 then
            skillInfo.effectDetail = GetDataFromTable("SkillEffectTable", skillInfo.effectId)
        else
            skillInfo.effectDetail = GetDataFromTable("PassivitySkillEffectTable", skillInfo.effectId)
        end
    end

    local l_maxLv = GetMaxLv(skillInfo.detail)
    skillInfo.isMax = skillInfo.lv == l_maxLv
    if not skillInfo.detail then
        logError("read skilltable fail with id = ", skillId)
    end
    if not skillInfo.effectDetail then
        logError("read skilleffect fail with effectId = ", skillInfo.effectId)
    end
    return skillInfo

end

--是否可以设置自动战斗
function IsHasAI(skillId)

    local l_skillData = GetDataFromTable("SkillTable", skillId, true)
    if skillId == 0 or l_skillData == nil then
        return false
    end
    return not string.ro_isEmpty(l_skillData.AITreeName)

end

function GetSkillIntroduce(skillId, customLv)

    local skillInfo = GetTipSkillInfo(skillId, customLv)
    local detail, effectDetail = skillInfo.detail, skillInfo.effectDetail
    local skillDesc = detail.SkillDesc
    local skillDescArgs = Common.Functions.VectorToTable(effectDetail.SkillDescRep)
    local count, maxArgIdx = 0, 0
    for v in string.gmatch(skillDesc, "{(%d+)}") do
        count = count + 1
        v = tonumber(v)
        if v > maxArgIdx then maxArgIdx = v end
    end
    if #skillDescArgs < count then
        logYellow(StringEx.Format([[技能描述匹配参数与描述字符串需要参数数量不一致, 请相关策划检查 skillId = {0}
            skillEffectId = {1}]], tostring(skillInfo.id), tostring(effectDetail.Id)))
        return skillDesc or ""
    elseif #skillDescArgs > 0 and (#skillDescArgs - 1 ~= maxArgIdx) then
        logYellow(StringEx.Format([[技能描述匹配参数与描述字符串下标匹配不上, 注意c#下标从0开始, 请相关策划检查 skillId = {0}
            skillEffectId = {1}]], tostring(skillInfo.id), tostring(effectDetail.Id)))
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

--获取下一个可以领职业奖励的等级
function GetNextStageJobLv()

    local _, proId = CurrentProTypeAndId()
    local next = -1
    local playerJobLv = MPlayerInfo.JobLv
    local jobAwards = GetProfessionJobAwards(proId)

    for i, v in ipairs(jobAwards) do
        local jobLv = 0
        local proSdata = GetDataFromTable("ProfessionTable", v.ProfessionID)
        if proSdata then
            jobLv = (JobChangeLevel[proSdata.ProfessionType] or 0) + (v.NeedJobLvl or 0)
        end
        if jobLv > playerJobLv then
            next = jobLv
            break
        end
    end
    return next

end

--获取职业id获取专职需要的base等级和job等级
function GetBaseAndJobLvByProId(proId)

    local l_baseLv, l_jobLv = -1, -1
    if proId > 0 then
        local professionSdata = GetDataFromTable("ProfessionTable", proId)
        if not professionSdata then logError("invalid professionId = ", proId)
            return l_baseLv, l_jobLv
        end
        l_baseLv, l_jobLv = professionSdata.BaseLvRequired, professionSdata.JobLvRequired
    end
    return l_baseLv, l_jobLv

end

--获取主角职业类型
function CurrentProTypeAndId()

    local l_proInfos = FormatProInfos()
    local l_proType, l_proId = ProfessionList.BASE_SKILL, GetBaseProId()
    for i, v in ipairs(l_proInfos) do
        if v.proId > 0 then
            l_proType, l_proId = v.type, v.proId
        else
            break
        end
    end
    return l_proType, l_proId

end

function FormatProInfos()

    return
    {
        { type = ProfessionList.PRO_ONE, proId = GetProOneId() },
        { type = ProfessionList.PRO_TWO, proId = GetProTwoId() },
        { type = ProfessionList.PRO_THREE, proId = GetProThreeId() },
        { type = ProfessionList.PRO_FOUR, proId = GetProFourId() },
    }

end

--获取技能槽中的技能数量
function GetSlotSkillCount()

    local ret = 0
    for i = 0, MPlayerInfo.MainUISkillSlots.Length - 1 do
        local v = MPlayerInfo.MainUISkillSlots[i]
        if v.id > 0 then
            ret = ret + 1
        end
    end
    return ret

end

function GetProfessionIdList()

    local l_list = {}
    local l_csList = MPlayerInfo.ProfessionIdList
    for i = 0, l_csList.Count - 1 do
        l_list[i + 1] = l_csList[i]
    end
    return l_list

end

--获取通用技能
function GetCommonSkillIds()

    local ret = {}
    local proId = GetBaseProId()
    local professionRow = GetDataFromTable("ProfessionTable", proId)
    if professionRow then
        local skillIdsVectorSeq = professionRow.SkillIds
        local skillProList = Common.Functions.VectorSequenceToTable(skillIdsVectorSeq)
        local skillLearnList = {}
        for i = 0, MPlayerInfo.SkillList.Count - 1 do
            local skillInfo = MPlayerInfo.SkillList[i]
            table.insert(skillLearnList, { rootSkillId = MPlayerInfo:GetRootSkillId(skillInfo.id), skillId = skillInfo.id })
        end
        for i, v in ipairs(skillProList) do
            local rootSkillId = MPlayerInfo:GetRootSkillId(v[1])
            local findv = array.find(skillLearnList, function(v) return v.rootSkillId == rootSkillId end)
            if findv then
                table.insert(ret, findv.skillId)
            end
        end
    end
    return ret

end

function HasSaveToSlot(skillId)
    return SavedSkillIds[skillId]
end

function UpdateFirstSaveSKill(skillIds)

    for i, v in ipairs(skillIds) do
        if not SavedSkillIds[v] then
            SavedSkillIds[v] = Common.Serialization.LoadData("SAVE_SLOT", MPlayerInfo.UID:tostring()) ~= nil
            if not SavedSkillIds[v] then
                Common.Serialization.StoreData("SAVE_SLOT", tostring(skillId), MPlayerInfo.UID:tostring())
                SavedSkillIds[v] = true
            end
        end
    end

end

function IsBeginner()

    local curPro = CurrentProTypeAndId()
    return curPro == ProfessionList.BASE_SKILL

end

--获取已经学习的技能
function GetLearnSkillIds()

    local skillIdList = {}
    local iter = MPlayerInfo.SkillDict:GetEnumerator()
    local k, v
    while iter:MoveNext() do
        k, v = iter.Current.Key, iter.Current.Value
        table.insert(skillIdList, k)
    end
    local fixedList = Common.Functions.ListToTable(MPlayerInfo.FixedSkillIdList)
    local fixedlockList = Common.Functions.ListToTable(MPlayerInfo.FixedUnlockSkillIdList)
    local ret = {}
    if IsBeginner() then
        ret = skillIdList
    else
        for i, skillId in ipairs(skillIdList) do
            local rawId = MPlayerInfo:GetRootSkillId(skillId)
            if not array.contains(fixedList, rawId) and not array.contains(fixedlockList, rawId) then
                table.insert(ret, skillId)
            else
                array.addUnique(ret, GetProfessionSkillId(rawId))
            end
        end
    end
    return ret

end

--获取本地的学习的技能信息
function GetLocalSkillPlanLearnSkillInfos(skillPlan, planId)

    local ret = {}
    local plan = skillPlan
    local fixedList = Common.Functions.ListToTable(MPlayerInfo.FixedSkillIdList)
    if plan then
        if planId == CurPlanId then
            local skillIds = GetLearnSkillIds()
            for i, v in ipairs(skillIds) do
                table.insert(ret, { skillId = v, skillLv = MPlayerInfo:GetCurrentSkillInfo(v).lv })
            end
        else
            local allSkills = plan.skills
            --遍历ProfessionSkill
            if allSkills then
                for i,v in ipairs(allSkills) do
                    local skillList = v.skill
                    for _, skill_v in ipairs(skillList) do
                        if skill_v.skill_level > 0 then
                            local rawId = MPlayerInfo:GetRootSkillId(skill_v.skill_id)
                            local professionSkillId = GetProfessionSkillId(rawId)
                            if not array.contains(fixedList, rawId) then
                                table.insert(ret, { skillId = skill_v.skill_id, skillLv = skill_v.skill_level })
                            elseif not array.find(ret, function(t) return t.skillId == professionSkillId end) then
                                table.insert(ret, { skillId = professionSkillId, skillLv = skill_v.skill_level })
                            end
                        end
                    end
                end
            end
        end
    end
    return ret

end

--本地方案已加的点、未加的点
function GetLocalSKillPlanSkillPointInfo(planId)

    local added, left = 0, 0
    local skillPlan = GetCurSkillPlan(planId)
    if not skillPlan then
        return added, left
    end
    local all = GetTotalSkillPointByLevel()
    left = all
    local skillInfos = GetLocalSkillPlanLearnSkillInfos(skillPlan, planId)
    for i, v in ipairs(skillInfos) do
        if NeedSkillPointToLearn(v.skillId) then
            left = left - v.skillLv
        end
    end
    return all - left, left

end

--获取buff技能数组
function GetBuffSkillIds()

    local ret = {}
    if MPlayerInfo.BuffSkillDict then
        local it = MPlayerInfo.BuffSkillDict:GetEnumerator()
        while it:MoveNext() do
            table.insert(ret, it.Current.Key)
        end
    end
    return ret

end

--是否QTE技能
function IsQTE(skillId)

    local l_Table = qteSkillTable.GetTable()
    for k, v in pairs(l_Table) do
        local l_group = Common.Functions.VectorSequenceToTable(v.SkillGroup)
        for i = 1, #l_group do
            if l_group[i][1] == skillId then
                return true
            end
        end
    end
    return false

end
--------------------------------------------------- ↑↑↑ 外部接口 ↑↑↑ ----------------------------------------------------
return SkillData