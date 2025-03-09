---@module ModuleMgr.AchievementMgr
module("ModuleMgr.AchievementMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
OnButtonEvent = "OnButtonEvent"
OnDetailsButtonEvent = "OnDetailsButtonEvent"
OnAchievementChangeEvent = "OnAchievementChangeEvent"
GetAllRateEvent = "GetAllRateEvent"
AchievementGetFinishRateInfoEvent = "AchievementGetFinishRateInfoEvent"
AchievementGetBadgeRateInfoEvent = "AchievementGetBadgeRateInfoEvent"
AchievementGetItemRewardEvent = "AchievementGetItemRewardEvent"
AchievementGetPointRewardEvent = "AchievementGetPointRewardEvent"
AchievementGetBadgeRewardEvent = "AchievementGetBadgeRewardEvent"
AchievementShowGetPanelFinishEvent = "AchievementShowGetPanelFinishEvent"
AchievementShowItemDetailsEvent = "AchievementShowItemDetailsEvent"
GetAchievementAwardEvent = "GetAchievementAwardEvent"
GetAchievementBatchPreviewAwardEvent = "GetAchievementBatchPreviewAwardEvent"
GetAchievementPointAwardEvent = "GetAchievementPointAwardEvent"

--总览按钮
PandectIndex = MGlobalConfig:GetInt("AchieveIndexPandect")
--进行中按钮
GoingIndex = MGlobalConfig:GetInt("AchieveIndexUnderway")
--将要完成按钮
ReadyFinish = MGlobalConfig:GetInt("AchieveIndexAlmostFinish")
--已完成按钮
Finish = MGlobalConfig:GetInt("AchieveIndexRecentFinish")
--搜索按钮
SearchIndex = MGlobalConfig:GetInt("AchieveIndexSearch")
--已完成进度
ReadyFinishProgress = 0.5
--搜索最大显示个数
SearchItemMaxCount = 9

CurrentSelectItemIndex = 0

--每条成就的全服占比
AchievementRates = {}
--成就点数已领奖的id
AchievementPointRewardedIds = {}
--成就徽章已领奖的id
AchievementBadgeRewardedIds = {}
--成就的奖励数据
AchievementAwardDatas = {}

SearchTexts = {}
--总成就点数
TotalAchievementPoint = 0
--成就等级
BadgeLevel = 0
--所有的成就数据
Achievements = {}

--当前需要显示的成就id
CurrentShowAchievementId = nil
--当前需要显示的成就奖杯的等级
CurrentShowBadgeLevel = nil

AchievementGetCacheAchievementDatas = {}
AchievementGetCacheLevel = 0

local _needSegmentationAchievementId=MGlobalConfig:GetSequenceOrVectorInt("CurrencySegmentationAchi")

-- 性别枚举
local l_eGenderType = {
    None = -1,
    Default = 0,
    Male = 1,
    Female = 2
}

local getTableInfo = {}

function getTableInfo:GetDetailTableInfo()
    if self.achievementDetailTableInfo == nil then
        self.achievementDetailTableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(self.achievementid)
    end
    if self.achievementDetailTableInfo == nil then
        logError("AchievementDetailTable表数据为空，id：" .. tostring(self.achievementid))
    end
    return self.achievementDetailTableInfo
end

function getTableInfo:GetIndexTableInfo()
    if self.achievementIndexTableInfo == nil then

        local l_detailTableInfo = self.GetDetailTableInfo()
        self.achievementIndexTableInfo = TableUtil.GetAchievementIndexTable().GetRowByIndex(l_detailTableInfo.Index)
        if self.achievementIndexTableInfo == nil then
            logError("AchievementIndexTable表数据为空，id：" .. tostring(l_detailTableInfo.Index))
        end
    end

    return self.achievementIndexTableInfo
end

local achievementMetatable = { __index = getTableInfo }

--搜索成就
function GetAchievementWithSearch(searchText)
    local l_achievements = {}
    local l_detailTableInfo
    for i = 1, #Achievements do
        if IsAchievementCanShow(Achievements[i]) then
            l_detailTableInfo = Achievements[i]:GetDetailTableInfo()
            if MLuaCommonHelper.IsStringContain(l_detailTableInfo.Name, searchText) then
                table.insert(l_achievements, Achievements[i])
            elseif MLuaCommonHelper.IsStringContain(l_detailTableInfo.Desc, searchText) then
                table.insert(l_achievements, Achievements[i])
            end
        end
    end
    return l_achievements
end

function IsAchievementCanShow(achievement)
    local l_detailTableInfo = achievement:GetDetailTableInfo()
    if l_detailTableInfo.HideType == 2 then
        return false
    end

    if l_detailTableInfo.HideType == 1 then
        if not IsFinish(achievement) then
            return false
        end
    end
    return true
end

-- 过滤成就奖励
--AchievementBadgeTable的SystemId字段
function FiltrateAwardIDList(systemId)
    if nil == systemId then
        logError("[Achievement] id table is nil")
        return {}
    end

    local l_achieveTable = TableUtil.GetPrivilegeSystemDesTable()
    local l_playerGender = MPlayerInfo.IsMale and 1 or 2
    local l_ret = {}
    for i = 1, systemId.Length do
        local l_id = systemId[i-1]
        local l_isAdd = true
        local l_config = l_achieveTable.GetRowById(l_id, false)
        if nil == l_config then
            logError("[Achievement] PrivilegeSystemDesTable id: " .. tostring(l_id) .. " is nil")
            l_isAdd = false
        else
            if l_eGenderType.Default == l_config.Gender then
                l_isAdd = true
            elseif l_eGenderType.Male == l_config.Gender or l_eGenderType.Female == l_config.Gender then
                l_isAdd = l_playerGender == l_config.Gender
            end
        end

        if l_isAdd then
            table.insert(l_ret, l_id)
        end
    end

    return l_ret
end

--获取所有完成的成就数据（同一个组的只取最后一个完成的）
function GetAllFinishAchievements()

    local l_currentDatas = {}

    local l_groups = {}

    for i = 1, #Achievements do
        --取到所有完成的
        if IsFinish(Achievements[i]) then

            --相同Group的放在一起
            local l_groupId = Achievements[i]:GetDetailTableInfo().Group
            if l_groupId ~= 0 then
                if l_groups[l_groupId] == nil then
                    l_groups[l_groupId] = {}
                end
                table.insert(l_groups[l_groupId], Achievements[i])
            else
                --没有Group的直接添加
                table.insert(l_currentDatas, Achievements[i])
            end
        end
    end

    local l_achievementInGroup
    --对有Group的成就数据取id最大的
    for l_groupId, l_groupAchievements in pairs(l_groups) do
        l_achievementInGroup = GetMaxIdAchievement(l_groupAchievements)
        if l_achievementInGroup then
            table.insert(l_currentDatas, l_achievementInGroup)
        end
    end

    return l_currentDatas
end

--取成就数据里面id最大的
function GetMaxIdAchievement(achievements)

    if achievements == nil then
        return nil
    end

    local l_maxIdIndex = 0
    local l_maxId = 0

    local l_currentId
    for i = 1, #achievements do
        l_currentId = achievements[i]:GetDetailTableInfo().ID
        if l_currentId > l_maxId then
            l_maxId = l_currentId
            l_maxIdIndex = i
        end
    end

    if l_maxIdIndex < 1 then
        return nil
    end

    return achievements[l_maxIdIndex]

end
--根据成就的主index组，取成就的数据
function GetAchievementWithMainIndex(index)
    local l_achievements = {}

    if index == SearchIndex then
        return l_achievements
    end

    table.ro_insertRange(l_achievements, GetAchievementWithIndex(index))

    local l_table = TableUtil.GetAchievementIndexTable().GetTable()
    for i = 1, #l_table do
        if l_table[i].Type == index then
            table.ro_insertRange(l_achievements, GetAchievementWithIndex(l_table[i].Index))
        end
    end

    return l_achievements
end

--根据成就id取成就表数据
function GetAchievementTableInfoWithId(id)
    local l_achievement = GetAchievementWithId(id)
    if l_achievement == nil then
        return nil
    end

    return l_achievement:GetDetailTableInfo()
end

--根据成就的index组，取成就的数据
function GetAchievementWithIndex(index)
    local l_achievements = {}

    if index == GoingIndex then
        for i = 1, #Achievements do
            if not IsFinish(Achievements[i]) then
                if Achievements[i].isfocus then
                    table.insert(l_achievements, Achievements[i])
                elseif GetProgress(Achievements[i]) > 0 then
                    table.insert(l_achievements, Achievements[i])
                end
            end
        end

        table.sort(l_achievements, function(a, b)
            if a.isfocus ~= b.isfocus then
                return a.isfocus
            end
            return isTimeGreaterThan(a.updatetime, b.updatetime)
        end)
    elseif index == ReadyFinish then
        for i = 1, #Achievements do
            if not IsFinish(Achievements[i]) then
                if Achievements[i].isfocus then
                    table.insert(l_achievements, Achievements[i])
                else
                    if GetProgress(Achievements[i]) > ReadyFinishProgress then
                        table.insert(l_achievements, Achievements[i])
                    end
                end
            end
        end

        table.sort(l_achievements, function(a, b)

            if a.isfocus ~= b.isfocus then
                return a.isfocus
            end

            if a.isfocus then
                return isTimeGreaterThan(a.updatetime, b.updatetime)
            else
                local l_progressA = GetProgress(a)
                local l_progressB = GetProgress(b)
                return l_progressA > l_progressB
            end

        end)
    elseif index == Finish then
        for i = 1, #Achievements do
            if IsFinish(Achievements[i]) then
                table.insert(l_achievements, Achievements[i])
            end
        end

        table.sort(l_achievements, function(a, b)
            return isTimeGreaterThan(a.finishtime, b.finishtime)
        end)

        --for i = 1, #l_achievements do
        --    local l_tableInfo= l_achievements[i]:GetDetailTableInfo()
        --    logGreen("l_tableInfo.Name:",l_tableInfo.Name,"  :",l_achievements[i].finishtime)
        --end

    else
        local l_tableInfo
        for i = 1, #Achievements do
            l_tableInfo = Achievements[i]:GetDetailTableInfo()
            --取此类型的成就
            if l_tableInfo.Index == index then
                table.insert(l_achievements, Achievements[i])
            end
        end

        table.sort(l_achievements, function(a, b)

            if a == nil or b == nil then
                return false
            end

            if a == b then
                return false
            end

            local l_isCanAwardA = IsAchievementCanAward(a)
            local l_isCanAwardB = IsAchievementCanAward(b)
            if l_isCanAwardA and l_isCanAwardB then
                return a.finishtime > b.finishtime
            end

            if l_isCanAwardB then
                return false
            end

            if l_isCanAwardA == false and l_isCanAwardB == false then
                return a.achievementid < b.achievementid
            end

            return true

        end)

        --table.sort(l_achievements,function(a,b)
        --    return a.achievementid<b.achievementid
        --end)
    end

    return l_achievements
end

function isTimeGreaterThan(a, b)
    if a == nil or a == 0 then
        return false
    end
    if b == nil or b == 0 then
        return true
    end
    return a > b
end

--根据成就id，取成就数据
function GetAchievementWithId(id)
    for i = 1, #Achievements do
        if Achievements[i].achievementid == id then
            return Achievements[i]
        end
    end

    return nil
end

--根据成就id，取成就的进度数据
function GetAchievementProgressCountWithId(id)
    local l_achievement = GetAchievementWithId(id)
    return GetAchievementProgressCountWithData(l_achievement)
end

function GetAchievementProgressCountWithData(achievement)

    if achievement == nil then
        return 0, 0
    end
    local l_stepCount = #achievement.steps
    if l_stepCount == 0 then
        logError("服务端没有发进度数据")
        return 0, 0
    end

    if l_stepCount == 1 then
        return achievement.steps[1].step, achievement.steps[1].maxstep
    end
    return 0, 0
end

--得到同一组的成就
function GetAchievementWithGroup(group)
    local l_achievements = {}
    for i = 1, #Achievements do
        if Achievements[i]:GetDetailTableInfo() == nil then
            return
        end
        if Achievements[i]:GetDetailTableInfo().Group == group then
            table.insert(l_achievements, Achievements[i])
        end
    end

    table.sort(l_achievements, function(a, b)
        return a:GetDetailTableInfo().ID < b:GetDetailTableInfo().ID
    end)

    return l_achievements
end

--成就是否正在进行
--对于服务端来说一组成就是全部一起进行的
function IsAchievementInProgress(achievement)

    --先判断是否完成
    if IsFinish(achievement) then
        return false
    end

    local l_achievementTableInfo = achievement:GetDetailTableInfo()
    if l_achievementTableInfo == nil then
        return false
    end
    local l_achievementId = l_achievementTableInfo.ID

    --取出来这一组成就
    local l_achievementGroups = GetAchievementWithGroup(l_achievementTableInfo.Group)

    --取出来当前成就在这一组成就中的位置
    local l_index = nil
    for i = 1, #l_achievementGroups do
        if l_achievementGroups[i]:GetDetailTableInfo().ID == l_achievementId then
            l_index = i
            break
        end
    end

    if l_index == nil then
        return false
    end

    --如果是第一个，则这个就是正在进行中
    if l_index == 1 then
        return true
    end

    --判断此成就之前的成就是否完成
    --如果前面的成就是完成的，则这个就是正在进行中
    if IsFinish(l_achievementGroups[l_index - 1]) then
        return true
    end

    return false

end

--成就是否已领奖
function IsAchievementAwardedWithId(id)
    local l_achievement = GetAchievementWithId(id)
    if l_achievement == nil then
        return false
    end
    return l_achievement.is_get_reward
end

--成就是否包含可领奖的项
function IsAchievementHaveAward(achievement)
    local l_tableInfo = achievement:GetDetailTableInfo()
    if l_tableInfo.Award == 0 and l_tableInfo.Title == 0 and l_tableInfo.StickersID == 0 then
        return false
    end
    return true
end

--根据成就id，取成就是否完成
function IsFinishWithId(id)
    local l_achievement = GetAchievementWithId(id)
    if l_achievement == nil then
        return false
    end
    return IsFinish(l_achievement)
end

--成就是否完成
function IsFinish(achievement)
    if achievement.finishtime == nil then
        return false
    end
    local l_isFinished = MLuaCommonHelper.Long(0) == MLuaCommonHelper.Long(achievement.finishtime)
    return not l_isFinished
end

--得到成就的进度（float类型）
function GetProgress(achievement)
    local l_stepCount = #achievement.steps
    if l_stepCount == 0 then
        return 0
    end
    if l_stepCount == 1 then
        if achievement.steps[1].step >= achievement.steps[1].maxstep then
            return 1
        else
            return achievement.steps[1].step / achievement.steps[1].maxstep
        end
    else
        local l_finishCount = 0
        for i = 1, l_stepCount do
            if achievement.steps[i].step >= achievement.steps[i].maxstep then
                l_finishCount = l_finishCount + 1
            end
        end
        if l_finishCount >= l_stepCount then
            return 1
        else
            return l_finishCount / l_stepCount
        end
    end
end

--根据成就id获取当前进度（steps数据）
function GetAchievementStepsWithId(id)
    local l_achievement = GetAchievementWithId(id)
    if l_achievement == nil then
        return {}
    end

    return l_achievement.steps
end

--得到成就总的成就点数据（两个，当前的和总的）
function GetAchievementTotalPointProgress(achievements)
    local l_totalFinishGrade = 0
    local l_totalCurrentGrade = 0

    local l_tableInfo
    for i = 1, #achievements do
        l_tableInfo = achievements[i]:GetDetailTableInfo()
        l_totalFinishGrade = l_totalFinishGrade + l_tableInfo.Point
        if IsFinish(achievements[i]) then
            l_totalCurrentGrade = l_totalCurrentGrade + l_tableInfo.Point
        end
    end
    return l_totalCurrentGrade, l_totalFinishGrade
end

--存下来搜索的文字
function SetSearchText(text)
    for i = 1, #SearchTexts do
        if SearchTexts[i] == text then
            return
        end
    end
    table.insert(SearchTexts, text)
    if #SearchTexts > SearchItemMaxCount then
        table.remove(SearchTexts, 1)
    end
end

--根据成就点，得到奖杯的表数据
function GetBadgeTableInfo(point)
    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()

    local l_currentTableInfo
    for i = 1, #l_table do
        if l_table[i].Point > point then
            l_currentTableInfo = l_table[i]
            break
        end
    end

    if l_currentTableInfo == nil then
        logError("没有取到比当前point大的表数据：" .. tostring(point))
        l_currentTableInfo = l_table[#l_table]
    end
    return l_currentTableInfo
end

--设置成就奖励
--result是AwardPreviewResult类型
--award_list是AwardContent类型
function SetAchievementAwardDatas(result)
    if result == nil then
        return
    end
    for i = 1, #result do
        AchievementAwardDatas[result[i].award_id] = result[i].award_list
    end
end
--得到成就奖励
--id是奖励id
function GetAchievementAwardDatas(id)
    return AchievementAwardDatas[id]
end

--得到成就的全服占比
function GetAchievementRate(id)
    if AchievementRates[id] then
        return AchievementRates[id]
    end
    return 0
end

--得到可领奖的成就数据（只取第一个）
function GetCanAwardAchievement()
    for i = 1, #Achievements do
        if IsAchievementCanAward(Achievements[i]) then
            return Achievements[i]
        end
    end
    return nil
end

--是否包含可领奖的成就
function IsHaveCanAwardAchievementSelf()
    return IsHaveCanAwardAchievement(Achievements)
end
function IsHaveCanAwardAchievement(achievements)
    for i = 1, #achievements do
        if IsAchievementCanAward(achievements[i]) then
            return true
        end
    end
    return false
end
--成就是否可领奖
function IsAchievementCanAward(achievement)
    if IsFinish(achievement) then
        if achievement.is_get_reward == false then
            if IsAchievementHaveAward(achievement) then
                return true
            end
        end
    end
    return false
end

--得到成就的百分比文字样式
function GetRateText(rate)
    if rate < 0.01 then
        return "<1%"
    end
    if rate > 0.99 then
        return ">99%"
    end
    return ((rate - rate % 0.01) * 100) .. "%"
end

--得到所有的成就表的Index
function GetAchievementButtonId()
    local l_table = TableUtil.GetAchievementIndexTable().GetTable()
    local l_id = {}
    for i = 1, #l_table do
        if l_table[i].Type == 0 then
            table.insert(l_id, l_table[i].Index)
        end
    end

    return l_id
end

IsShowBadgePanel = false

--打开成就界面
function OnAchievementButton()
    if IsHaveBadgeAward() then
        local l_badgeCanRewardTableData = GetFirstBadgeCanRewardTableData()
        local l_level
        if l_badgeCanRewardTableData then
            l_level = l_badgeCanRewardTableData.Level
        end
        OpenAchievementPanel(nil, true, l_level)
        return
    end
    local l_canAwardAchievement = GetCanAwardAchievement()
    if l_canAwardAchievement then
        OpenAchievementPanel(l_canAwardAchievement.achievementid)
    else
        OpenAchievementPanel(nil, true)
    end
end

function OpenAchievementPanel(achievementId, isShowBadgePanel, level)

    local l_functionId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Achievement
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
        local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(l_functionId)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("Achievement_NotOpenAchievementText"), l_tableData.BaseLevel))
        return
    end

    CurrentShowAchievementId = achievementId
    IsShowBadgePanel = isShowBadgePanel
    CurrentShowBadgeLevel = level
    UIMgr:ActiveUI(UI.CtrlNames.AchievementBg)
end

--得到成就主按钮的index
function GetShowAchievementMainButtonIndex()
    local l_mainButtonIndex = PandectIndex
    local l_achievementIndexTableInfo = GetAchievementIndexTableInfoWithId(CurrentShowAchievementId)
    if l_achievementIndexTableInfo then
        if l_achievementIndexTableInfo.Type == 0 then
            l_mainButtonIndex = l_achievementIndexTableInfo.Index
        else
            l_mainButtonIndex = l_achievementIndexTableInfo.Type
        end
    end
    return l_mainButtonIndex
end

function GetShowAchievementDetailsButtonIndex()
    local l_achievementIndexTableInfo = GetAchievementIndexTableInfoWithId(CurrentShowAchievementId)
    if l_achievementIndexTableInfo == nil then
        return nil
    end
    if l_achievementIndexTableInfo.Type == 0 then
        return nil
    end
    return l_achievementIndexTableInfo.Type
end

function GetAchievementIndexTableInfoWithId(id)
    if id == nil then
        return nil
    end
    local l_achievementData = GetAchievementWithId(id)
    if l_achievementData == nil then
        return nil
    end
    local l_achievementDataIndex = l_achievementData:GetDetailTableInfo().Index
    return TableUtil.GetAchievementIndexTable().GetRowByIndex(l_achievementDataIndex)
end

--红点检测方法
function CheckRedSignMethod()
    if IsHaveCanAwardAchievement(Achievements) then
        return 1
    end
    if IsHaveBadgeAward() then
        return 1
    end
    return 0
end

--是否有可领奖的成就奖杯奖励
function IsHaveBadgeAward()
    if BadgeLevel == 0 then
        return false
    end

    local l_totalLevel = 0
    for i = 1, #AchievementBadgeRewardedIds do
        l_totalLevel = l_totalLevel + AchievementBadgeRewardedIds[i]
    end

    if l_totalLevel == (((1 + BadgeLevel) * BadgeLevel) / 2) then
        return false
    end

    return true

end

--是否有可领奖的成就点数奖励
function IsHavePointAward()
    local l_table = TableUtil.GetAchievementPointsAwardTable().GetTable()
    for i = 1, #l_table do
        if l_table[i].Point <= TotalAchievementPoint then
            if not IsAchievementPointRewarded(l_table[i].Id) then
                return true
            end
        end
    end
    return false
end

--成就点数是否领奖
function IsAchievementPointRewarded(id)
    return table.ro_contains(AchievementPointRewardedIds, id)
end

--成就徽章是否领奖
function IsAchievementBadgeRewarded(level)
    return table.ro_contains(AchievementBadgeRewardedIds, level)
end

--成就奖杯可以领奖
function IsAchievementBadgeCanReward(badgeTableInfo)
    if not IsBadgeComplete(badgeTableInfo) then
        return false
    end
    if IsAchievementBadgeRewarded(badgeTableInfo.Level) then
        return false
    end
    if badgeTableInfo.AwardId == 0 then
        return false
    end
    return true

end

--得到第一个可领奖的成就奖杯的表数据
function GetFirstBadgeCanRewardTableData()
    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()
    for i = 2, #l_table do
        if MgrMgr:GetMgr("AchievementMgr").IsAchievementBadgeCanReward(l_table[i]) then
            return l_table[i]
        end
    end
    return nil
end

--奖杯是否已完成
function IsBadgeComplete(badgeTableInfo)
    if badgeTableInfo.Level > BadgeLevel then
        return false
    end
    return true
end

--显示成就的星星的逻辑
function ShowAchievementBadgeStar(starParent, badgeTableInfo)
    local l_starParentTransform = starParent.Transform
    --先全隐藏
    for i = 0, l_starParentTransform.childCount - 1 do
        local l_child = l_starParentTransform:GetChild(i)
        l_child.gameObject:SetActiveEx(false)
    end

    --类型是0不显示星星
    if badgeTableInfo.StarType == 0 then
        return
    end

    --打开相应类型的星星
    local l_star = l_starParentTransform:Find("Star" .. badgeTableInfo.StarType)
    l_star.gameObject:SetActiveEx(true)

    local l_lightStar
    --有个需求，如果要显示的星星的等级是比现在的等级高的，所有星星都不亮
    if badgeTableInfo.Level > BadgeLevel then
        for i = 1, badgeTableInfo.StarType do
            l_lightStar = l_star:Find("star" .. i)
            if l_lightStar ~= nil then
                l_lightStar.gameObject:SetActiveEx(false)
            end
        end
    else
        --根据表里配的LightNumber显示相应的星星
        for i = 1, badgeTableInfo.StarType do
            l_lightStar = l_star:Find("star" .. i)
            if l_lightStar ~= nil then
                if i <= badgeTableInfo.LightNumber then
                    l_lightStar.gameObject:SetActiveEx(true)
                else
                    l_lightStar.gameObject:SetActiveEx(false)
                end
            end
        end
    end
end

function GetAchievementDetailsWithTableInfo(tableInfo)
    local l_des1 = ""
    local l_des2 = ""

    if tableInfo.Target.Length > 0 then
        local l_target = tableInfo.Target[0]
        if l_target.Length > 1 then
            l_des1 = tostring(l_target[1])
        end
        if l_target.Length > 2 then
            l_des2 = tostring(l_target[2])
        end
    end

    return StringEx.Format(tableInfo.Desc, l_des1, l_des2)
end

function NeedSegmentationAchievementId(achievementId)
    if _needSegmentationAchievementId == nil then
        return false
    end
    for i = 1, _needSegmentationAchievementId.Length do
        if _needSegmentationAchievementId[i-1]==achievementId then
            return true
        end
    end
    return false
end

local romanString = {
    [1] = "I",
    [4] = "IV",
    [5] = "V",
    [9] = "IX",
    [10] = "X",
    [40] = "XL",
    [50] = "L",
    [90] = "XC",
    [100] = "C",
    [400] = "CD",
    [500] = "D",
    [900] = "CM",
    [1000] = "M",
}

local numbers = { 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 }

--整形转成罗马数字的字符串
function IntToRomanNumeral(number)

    if number <= 0 then
        return tostring(number)
    end

    local resultString = {}
    local index = 13

    local indexNumber
    while true do
        indexNumber = numbers[index]
        if number >= indexNumber then
            table.insert(resultString, romanString[indexNumber])
            number = number - indexNumber
        else
            index = index - 1
        end
        if number <= 0 then
            break
        end
    end

    return table.concat(resultString, "")

end

--创建成就数据
function createAchievementWithData(data)
    local l_achievement = {}
    l_achievement.achievementid = data.achievementid
    l_achievement.steps = data.steps
    l_achievement.isfocus = data.isfocus
    l_achievement.finishtime = MLuaCommonHelper.Long(data.finishtime)
    l_achievement.updatetime = MLuaCommonHelper.Long(data.updatetime)
    l_achievement.is_get_reward = data.is_get_reward
    setmetatable(l_achievement, achievementMetatable)

    return l_achievement
end

--当服务端没有传这个成就数据时客户端自己填充一个
function createAchievement(id)

    local l_tableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(id)
    if l_tableInfo == nil then
        return nil
    end

    local l_achievement = {}
    l_achievement.achievementid = id
    l_achievement.steps = {}
    l_achievement.isfocus = false
    l_achievement.finishtime = MLuaCommonHelper.Long(0)
    l_achievement.updatetime = MLuaCommonHelper.Long(0)
    l_achievement.is_get_reward = false
    setmetatable(l_achievement, achievementMetatable)

    for i = 1, l_tableInfo.Target.Length do
        local l_strp = {}
        l_strp.step = 0

        l_strp.maxstep = l_tableInfo.Target[i - 1][1]
        table.insert(l_achievement.steps, l_strp)
    end

    if #l_achievement.steps == 0 then
        logError("AchievementDetailTable没有填Target数据，id：" .. tostring(id))
        local l_strp = {}
        l_strp.step = 0
        l_strp.maxstep = 99999
        table.insert(l_achievement.steps, l_strp)
    end

    return l_achievement
end

--刷新成就数据
function _refreshAchievementData(currentAchievementData, serverAchievementData)
    if currentAchievementData == nil or serverAchievementData == nil then
        return
    end
    currentAchievementData.steps = serverAchievementData.steps
    currentAchievementData.finishtime = MLuaCommonHelper.Long(serverAchievementData.finishtime)
    currentAchievementData.isfocus = serverAchievementData.isfocus
    currentAchievementData.updatetime = MLuaCommonHelper.Long(serverAchievementData.updatetime)
    currentAchievementData.is_get_reward = serverAchievementData.is_get_reward
end

--添加成就数据
function _addAchievementData(serverAchievementData)

    if serverAchievementData == nil then
        logError("服务端传的成就数据是空的")
        return nil
    end

    local l_achievementDetailTableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(serverAchievementData.achievementid)
    if l_achievementDetailTableInfo == nil then
        return nil
    end

    --if l_achievementDetailTableInfo.HideType == 2 then
    --    return nil
    --end

    --if l_achievementDetailTableInfo.HideType == 1 then
    --    if not IsFinish(serverAchievementData) then
    --        return nil
    --    end
    --end

    local l_achievementData = createAchievementWithData(serverAchievementData)
    table.insert(Achievements, l_achievementData)

    return l_achievementData
end

--聊天相关

--获取成就的广播频道
function GetChatChannelWithAchievementId(id)

    local l_achievementDetailTableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(id)
    local l_channel = Common.Functions.VectorToTable(l_achievementDetailTableInfo.BroadCast)
    if table.ro_contains(l_channel, DataMgr:GetData("ChatData").EChannel.GuildChat) then
        if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
            table.ro_removeValue(l_channel, DataMgr:GetData("ChatData").EChannel.GuildChat)
        end
    end
    return l_channel
end

--分享成就，显示在聊天界面
function ShareAchievement(Text, TextParam, position)

    local l_names = {}
    local l_callBacks = {}
    local l_Text = Text
    local l_TextParam = TextParam
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    for i, l_channel in pairs(l_chatDataMgr.EChannel) do
        if l_channel ~= l_chatDataMgr.EChannel.WorldChat and l_channel ~= l_chatDataMgr.EChannel.WatchChat then
            if l_chatMgr.CanSendMsg(l_channel, false, nil, true) then
                local l_name = l_chatDataMgr.GetChannelName(l_channel)
                if l_name ~= nil then
                    table.insert(l_names, l_name)
                    local l_callBack = function()
                        local l_isSendSucceed = l_chatMgr.SendChatMsg(MPlayerInfo.UID, l_Text, l_channel, l_TextParam)
                        if l_isSendSucceed then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
                        end
                    end
                    table.insert(l_callBacks, l_callBack)
                end

            end
        end

    end

    if #l_names > 0 then

        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = l_names,
            callbackTb = l_callBacks,
            dataopenPos = position,
            dataAnchorMaxPos = nil,
            dataAnchorMinPos = nil
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
        --UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, function()
        --    local l_ui = UIMgr:GetUI(UI.CtrlNames.TeamQuickFunc)
        --    if l_ui then
        --        l_ui:SetQuickPanelByNameAndFunc(l_names, l_callBacks, position)
        --    end
        --end)
    end

end

--协议相关
function OnSelectRoleNtf(info)

    ReceiveAchievementData(info.achievementrecord)
end

--收到服务器发过来的成就数据
function ReceiveAchievementData(data)

    if data == nil then
        logError("服务器发的成就数据为空")
        return
    end

    Achievements = {}

    TotalAchievementPoint = data.achievementpoint
    BadgeLevel = data.badgelevel

    if data.point_reward_list then
        for i = 1, #data.point_reward_list do
            table.insert(AchievementPointRewardedIds, data.point_reward_list[i].value)
        end
    end

    if data.badge_level_reward_list then
        for i = 1, #data.badge_level_reward_list do
            table.insert(AchievementBadgeRewardedIds, data.badge_level_reward_list[i].value)
        end
    end

    local l_serverAchievementData
    for i = 1, #data.achievements do
        l_serverAchievementData = data.achievements[i]
        _addAchievementData(l_serverAchievementData)
    end

    local l_table = TableUtil.GetAchievementDetailTable().GetTable()
    local l_tableIds = {}
    for i = 1, #l_table do
        --if l_table[i].HideType ~= 1 and l_table[i].HideType ~= 2 then
        --    table.insert(l_tableIds, l_table[i].ID)
        --end
        table.insert(l_tableIds, l_table[i].ID)
    end

    -- 去重处理
    for i = 1, #Achievements do
        table.ro_removeValue(l_tableIds, Achievements[i].achievementid)
    end

    for i = 1, #l_tableIds do
        local l_achievement = createAchievement(l_tableIds[i])
        if l_achievement then
            table.insert(Achievements, l_achievement)
        end
    end
end

--收到成就数据改变
function ReceiveSingleAchievementNotify(msg)
    ---@type SingleAchievementNotify
    local l_info = ParseProtoBufToTable("SingleAchievementNotify", msg)

    if l_info.totalachievementpoint and l_info.totalachievementpoint>0 then
        TotalAchievementPoint = l_info.totalachievementpoint
    end

    local l_lastBadgeLevel = BadgeLevel
    BadgeLevel = l_info.badgelevel

    if l_info.point_reward_list then
        for i = 1, #l_info.point_reward_list do
            table.insert(AchievementPointRewardedIds, l_info.point_reward_list[i].value)
        end
    end

    local l_isNeedShowRed = false
    local l_serverAchievementDatas = l_info.changed

    -- 缓存一下系统解锁的mgr
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_achievementSystemId = l_openSystemMgr.eSystemId.Achievement
    local l_isAchievementOpen = l_openSystemMgr.IsSystemOpen(l_achievementSystemId)

    for i = 1, #l_serverAchievementDatas do
        local l_isFinished = false
        local l_currentAchievement = GetAchievementWithId(l_serverAchievementDatas[i].achievementid)
        if l_currentAchievement == nil then
            l_currentAchievement = _addAchievementData(l_serverAchievementDatas[i])
        else
            if IsFinish(l_currentAchievement) then
                l_isFinished = true
            end
            if l_currentAchievement.isfocus ~= l_serverAchievementDatas[i].isfocus then
                if l_serverAchievementDatas[i].isfocus then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Achievement_FocusTipsText"))
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Achievement_NotFocusTipsText"))
                end
            end
            _refreshAchievementData(l_currentAchievement, l_serverAchievementDatas[i])
        end

        if l_currentAchievement then
            if l_isAchievementOpen then
                if not l_isFinished then
                    if IsFinish(l_serverAchievementDatas[i]) and IsAchievementCanShow(l_currentAchievement) then
                        local l_msg = Common.Utils.Lang("Achievement_GetAchievementText")
                        local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetAchievementDPack(l_msg, l_currentAchievement.achievementid, tostring(MPlayerInfo.UID), tostring(l_currentAchievement.finishtime))
                        MgrMgr:GetMgr("ChatMgr").SendSystemInfo(DataMgr:GetData("ChatData").EChannelSys.System, l_msg, {
                            MsgParam = l_msgParam
                        })
                        table.insert(AchievementGetCacheAchievementDatas, l_currentAchievement)
                        if l_isNeedShowRed == false then
                            if IsAchievementHaveAward(l_currentAchievement) then
                                l_isNeedShowRed = true
                            end
                        end
                    end
                end
            end
        end
    end

    -- 如果成就系统没有解锁就直接返回
    if not l_isAchievementOpen then
        return
    end

    -- 控制UI和红点显示
    if BadgeLevel > l_lastBadgeLevel then
        AchievementGetCacheLevel = BadgeLevel
        l_isNeedShowRed = true

        -- SDK打点
        MgrMgr:GetMgr("AdjustTrackerMgr").AchievementBadgeLevelEvent(BadgeLevel)
    end
    if AchievementGetCacheLevel > 0 then
        UIMgr:ActiveUI(UI.CtrlNames.Achievementget)
    else
        if 0 < #AchievementGetCacheAchievementDatas then
            UIMgr:ActiveUI(UI.CtrlNames.Achievementget)
        end
    end
    if l_isNeedShowRed then
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Achievement)
    end
    EventDispatcher:Dispatch(OnAchievementChangeEvent)
end

--设置成就关注
function RequestSetAchievementFocus(id, isfocus)
    local l_msgId = Network.Define.Ptc.SetAchievementFocus
    ---@type SetAchievementFocus
    local l_sendInfo = GetProtoBufSendTable("SetAchievementFocus")

    l_sendInfo.id = id
    l_sendInfo.isfocus = isfocus

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--得到所有进度
function RequestAchievementGetInfo()
    local l_msgId = Network.Define.Rpc.AchievementGetInfo
    ---@type AchievementGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveAchievementGetInfo(msg)
    ---@type AchievementGetInfoRes
    local l_info = ParseProtoBufToTable("AchievementGetInfoRes", msg)

    if #l_info.achievement_list ~= #l_info.achievement_rate_list then
        return
    end

    for i = 1, #l_info.achievement_list do
        AchievementRates[l_info.achievement_list[i].value] = l_info.achievement_rate_list[i].value
    end

    EventDispatcher:Dispatch(GetAllRateEvent)
end

--得到单个成就进度
function RequestAchievementGetFinishRateInfo(id)

    local l_msgId = Network.Define.Rpc.AchievementGetFinishRateInfo
    ---@type AchievementGetFinishRateInfoArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetFinishRateInfoArg")
    l_sendInfo.achievement_id = id

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveAchievementGetFinishRateInfo(msg)
    ---@type AchievementGetFinishRateInfoRes
    local l_info = ParseProtoBufToTable("AchievementGetFinishRateInfoRes", msg)

    EventDispatcher:Dispatch(AchievementGetFinishRateInfoEvent, l_info.rate)
end

--得到成就勋章进度
function RequestAchievementGetBadgeRateInfo(level, index)

    local l_msgId = Network.Define.Rpc.AchievementGetBadgeRateInfo
    ---@type AchievementGetBadgeRateInfoArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetBadgeRateInfoArg")
    l_sendInfo.badge_level = level

    Network.Handler.SendRpc(l_msgId, l_sendInfo, index)
end
function ReceiveAchievementGetBadgeRateInfo(msg, m, index)
    ---@type AchievementGetBadgeRateInfoRes
    local l_info = ParseProtoBufToTable("AchievementGetBadgeRateInfoRes", msg)

    EventDispatcher:Dispatch(AchievementGetBadgeRateInfoEvent, l_info.rate, index)
end

--单个成就领奖
function RequestAchievementGetItemReward(id)

    local l_msgId = Network.Define.Rpc.AchievementGetItemReward
    ---@type AchievementGetItemRewardArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetItemRewardArg")
    l_sendInfo.item_id = id

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveAchievementGetItemReward(msg, data)
    ---@type AchievementGetItemRewardRes
    local l_info = ParseProtoBufToTable("AchievementGetItemRewardRes", msg)

    if l_info.error_code == 0 then
        EventDispatcher:Dispatch(AchievementGetItemRewardEvent)
        local l_tableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(data.item_id)
        if l_tableInfo.ShowPopup == 1 then
            if l_tableInfo.Award ~= 0 then
                UIMgr:ActiveUI(UI.CtrlNames.AchievementGetBadgeAward, function(ctrl)
                    ctrl:GetAchievementAwardFinish(l_tableInfo)
                end)
            end
        end

        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Achievement)

    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

end

--成就点数领奖
function RequestAchievementGetPointReward(id)

    local l_msgId = Network.Define.Rpc.AchievementGetPointReward
    ---@type AchievementGetPointRewardArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetPointRewardArg")
    l_sendInfo.id = id

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveAchievementGetPointReward(msg)
    ---@type AchievementGetPointRewardRes
    local l_info = ParseProtoBufToTable("AchievementGetPointRewardRes", msg)

    if l_info.error_code ~=0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Achievement)
    EventDispatcher:Dispatch(AchievementGetPointRewardEvent)
end

--成就徽章领奖
function RequestAchievementGetBadgeReward(level)
    local l_msgId = Network.Define.Rpc.AchievementGetBadgeReward
    ---@type AchievementGetBadgeRewardArg
    local l_sendInfo = GetProtoBufSendTable("AchievementGetBadgeRewardArg")
    l_sendInfo.badge_level = level
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveAchievementGetBadgeReward(msg, data)
    ---@type AchievementGetBadgeRewardRes
    local l_info = ParseProtoBufToTable("AchievementGetBadgeRewardRes", msg)

    if l_info.error_code ~=0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    local badgeLv = data.badge_level
    table.insert(AchievementBadgeRewardedIds, badgeLv)
    UIMgr:ActiveUI(UI.CtrlNames.AchievementGetBadgeAward, function(ctrl)
        ctrl:GetBadgeAwardFinish(badgeLv)
    end)

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Achievement)
    EventDispatcher:Dispatch(AchievementGetBadgeRewardEvent)
end

--得到单个成就进度
function RequestAchieveInfo()

    local l_msgId = Network.Define.Ptc.RequestAchieveInfo
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendPtc(l_msgId,l_sendInfo)
end

--客户端完成成就，发给服务端
function ClientFinishAchievement(achievementId, achievementType)
    if not IsFinishWithId(achievementId) then
        local l_msgId = Network.Define.Rpc.FinishClientAchievement
        ---@type FinishClientAchievementArg
        local l_sendInfo = GetProtoBufSendTable("FinishClientAchievementArg")
        l_sendInfo.type = achievementType
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

function OnLogout()
    CurrentSelectItemIndex = 0

    AchievementRates = {}
    AchievementPointRewardedIds = {}
    AchievementBadgeRewardedIds = {}
    AchievementAwardDatas = {}

    SearchTexts = {}
    TotalAchievementPoint = 0
    BadgeLevel = 0
    Achievements = {}

    CurrentShowAchievementId = nil

    AchievementGetCacheAchievementDatas = {}
    AchievementGetCacheLevel = 0
end

return AchievementMgr

