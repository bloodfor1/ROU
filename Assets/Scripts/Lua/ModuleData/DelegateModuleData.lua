--lua model
---@module ModuleData.DelegateModuleData
module("ModuleData.DelegateModuleData", package.seeall)
--lua model end

---@class DelegateRewardDict 委托奖励（转盘抽奖）结果，开始抽奖后由服务器通知，转盘停转后清空
---@field id number 奖励道具id
---@field num number 奖励道具数量

---@type ClientDelegationData[] 委托数据
delegates = {}
---@type ClientDelegationData[] 过期委托
expiredDelegates = {}
--- 上次领奖时间
lastAwardTime = -1
--- 委托信息上次刷新时间
lastRefreshTime = -1
--- 玩家今日消耗的委托券数量
certificatesCost = 0
--- 玩家委托券上限
maxCertificates = 0
--- 转盘抽奖需要消耗的委托券数量
rewardBoxLimit = 0
--- 纹章页签下的纹章道具id列表
crestMedalIds = Common.Functions.VectorToTable(MGlobalConfig:GetSequenceOrVectorInt("PowerHeraldry"))
--- 最大等级差(显示委托)
maxLevelDifference = MGlobalConfig:GetInt("MaxLevelDifference")
--entrustBoxThreshold = MGlobalConfig:GetInt("EntrustBoxThreshold") or 10 -- 领取委托证明宝箱时委托证明的剩余数量阈值
--- 与委托关联的NPC数据
taskNpcInfo = {}
--- 纹章道具id->道具数量的映射
medals = {}
--- 所有委托活动类型对应的功能ID【集合】
focusOpenSystemIds = {}
--- 剩余幸运转盘次数
leftAwardTimes = 0
--costDelegation = 0

---@type DelegateRewardDict
DelegateWheelReward = {}

--- 委托状态
EDelegateStatus = {
    --- 等待接取
    DelegateStatusWaiting = 0,
    --- 仅接取但不能领奖
    DelegateStatusAccepted = 1,
    --- 完美接取且能领奖
    DelegateStatusPerfected = 2,
    --- 已放弃
    DelegateStatusAbandoned = 3,
    --- 已完成
    DelegateStatusFinished = 4,
    --- 未知
    Unknown = 6,
}

local l_sortKey = "DELEGATE_DAY_SORT"


function Init( ... )
    InitCertificates()
    InitOpenSystemIds()
end

function InitCertificates( ... )
    ReadLimitFromTable()
end

function InitOpenSystemIds()
    focusOpenSystemIds = {}
    local l_entrustActivityTable = TableUtil.GetEntrustActivitiesTable().GetTable()
    for i, v in ipairs(l_entrustActivityTable) do
        if v.SystemID > 0 then
            array.addUnique(focusOpenSystemIds, v.SystemID)
        end
    end
end

---@author edwardchen
---@date 2020/8/18 15:03
--- 从EntrustLevelTable中读出玩家等级对应的委托券上限及抽奖开销
function ReadLimitFromTable()
    local l_entrustUpperLimit, l_entrustRewardBoxLimit = 0, 0
    if not MPlayerInfo then
        logError("[DelegateModuleData.ReadLimitFromTable] 玩家信息不存在")
    else
        local l_entrustLvTable = TableUtil.GetEntrustLevelTable().GetTable()
        if not l_entrustLvTable then
            logError("[DelegateModuleData.ReadLimitFromTable] EntrustLevelTable读取失败")
        else
            for i = #l_entrustLvTable, 1, -1 do
                local l_rowData = l_entrustLvTable[i]
                if MPlayerInfo.Lv >= l_rowData.BaseLevel then
                    l_entrustUpperLimit = l_rowData.EntrustUpperLimit
                    l_entrustRewardBoxLimit = l_rowData.RewardBoxLimit
                    break
                end
            end
        end
    end
    maxCertificates = l_entrustUpperLimit
    rewardBoxLimit = l_entrustRewardBoxLimit
    --[[ 早先版本
    if not MPlayerInfo then return l_entrustUpperLimit, l_entrustRewardBoxLimit end
    local l_entrustLvTable = TableUtil.GetEntrustLevelTable().GetTable()
    if not l_entrustLvTable then return l_entrustUpperLimit, l_entrustRewardBoxLimit end
    for i = #l_entrustLvTable, 1, -1 do
        local l_rowData = l_entrustLvTable[i]
        if MPlayerInfo.Lv >= l_rowData.BaseLevel then
            l_entrustUpperLimit = l_rowData.EntrustUpperLimit
            l_entrustRewardBoxLimit = l_rowData.RewardBoxLimit
            break
        end
    end
    return l_entrustUpperLimit, l_entrustRewardBoxLimit
    ]]--
end


function ProcessDelegates(datas)
    local l_ret = {}
    local l_sData
    for i, v in ipairs(datas) do
        l_sData = TableUtil.GetEntrustActivitiesTable().GetRowByMajorID(v.id)
        if l_sData then
            local l_cost = Common.Functions.VectorSequenceToTable(l_sData.Cost)
            local l_c = 0
            if #l_cost > 0 then
                l_c = l_cost[1][2]
            end
            
            ---@class ClientDelegationData
            local l_data = {
                id = v.id,
                isFinish = 0,
                isRecommand = l_sData.RecommendationLabel,
                isCasual = l_sData.ActivityType == GameEnum.DelegateType.Normal and 1 or 0,
                lv = 0,
                cost = l_c,
                finish_times = v.finish_times,
                max_times = 1,
                monthCardFlag = false,   --月卡标志
                systemId = l_sData.SystemID,
                taskId = v.task_id,
                status = v.status,
                dungeonId = l_sData.DungeonID,
                cost_delegate = v.cost_delegation,
                isNormal = IsNormalDelegate(l_sData.EntrustType),
                sdata = l_sData,
            }
            l_data.max_times, l_data.monthCardFlag = GetDelegateMaxTimes(l_sData)
            l_data.isFinish = CheckDelegateFinish(l_data) and 1 or 0
            l_data.lv = GetDelegateJoinBaseLv(l_data)
            table.insert(l_ret, l_data)
        end
    end
    return l_ret
end

function GetDelegateDatas()
    SortDelegates(delegates)
    local l_ret = {}
    local playerLv = MPlayerInfo.Lv
    for i = 1, #delegates do
        if delegates[i].systemId ~= 0 and delegates[i].lv - maxLevelDifference <= playerLv then
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(delegates[i].systemId) then
                delegates[i].isFinish = IsDelegateFinish(delegates[i].id) and 1 or 0
                table.insert(l_ret, delegates[i])
            end
        end
    end
    SortDelegates(l_ret)
    return l_ret
end

function SortDelegates(datas)
    local l_dateStr = tostring(Common.TimeMgr.GetDayTimestamp())
    local l_dateStrSave = UserDataManager.GetStringDataOrDef(l_sortKey, MPlayerSetting.PLAYER_SETTING_GROUP, "")
    local l_todayHasSort = l_dateStrSave == l_dateStr
    local l_coin = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Certificates)
    local playerLv = MPlayerInfo.Lv
    table.sort(datas, function(a, b)
        if a.isFinish < b.isFinish then return true end
        if a.isFinish > b.isFinish then return false end
        if a.cost>l_coin or b.cost>l_coin then
            if a.cost < b.cost then return true end
            if a.cost > b.cost then return false end
        end
        if a.lv > playerLv or b.lv > playerLv then
            if a.lv < b.lv then return true end
            if a.lv > b.lv then return false end
        end
        if a.isRecommand < b.isRecommand then return false end
        if a.isRecommand > b.isRecommand then return true end
        if a.isNormal and not b.isNormal then return true end
        if not a.isNormal and b.isNormal then return false end
        if a.isCasual < b.isCasual then return false end
        if a.isCasual > b.isCasual then return true end
        return a.id < b.id
    end)
    if not l_todayHasSort then
        UserDataManager.SetDataFromLua(l_sortKey, MPlayerSetting.PLAYER_SETTING_GROUP, l_dateStr)
    end
end

function IsNormalDelegate(type)
   return tostring(type) == tostring(101) or tostring(type) == tostring(102)
end

function OnSelectRoleNtf(info)
    lastAwardTime = tonumber(info.last_award_time)
    lastRefreshTime = tonumber(info.last_refresh_time) or 0
    delegates = ProcessDelegates(info.delegations)
    leftAwardTimes = tonumber(info.left_award_times) or 0
    certificatesCost = tonumber(info.cost_delegation) or 0
    expiredDelegates = ProcessDelegates(info.expired_delegations)
    InitCertificates()
end

function OnDelegationRefresh(info)
    delegates = ProcessDelegates(info.delegations)
    leftAwardTimes = tonumber(info.left_award_times) or 0
    certificatesCost = tonumber(info.cost_delegation) or 0
    local l_last_award_time = tonumber(info.left_award_times) or 0
    if l_last_award_time > 0 then
        lastAwardTime = l_last_award_time
    end
end

function OnDelegationUpdate(info)
    local l_changeDelegates = ProcessDelegates(info.delegations)
    leftAwardTimes = tonumber(info.left_award_times) or 0
    certificatesCost = tonumber(info.cost_delegation) or 0
    local l_change = false
    for i, l_changeDelegate in ipairs(l_changeDelegates) do
        local l_delegate, l_idx = array.find(delegates, function(v) return v.id == l_changeDelegate.id end)
        if l_delegate then
            delegates[l_idx] = l_changeDelegate
            l_change = true
        else
            table.insert(delegates, l_changeDelegate)
            l_change = true
        end
    end
    
    local l_needTip = false  --是否需要提示
    if l_change then
        --如果委托数据有变化 且 只有猫手商队 则无需提示  猫手有自己的一套逻辑
        if #l_changeDelegates == 1 and l_changeDelegates[1].id == GameEnum.Delegate.activity_CatTeam then
            l_needTip = false
        else
            l_needTip = true
        end
    end
    
    return l_change, l_needTip
end

--获取委托最大次数
--configData  委托对应GetEntrustActivitiesTable表的配置数据
--return  number  --最大次数
--        bool    --是否需要月卡标志
function GetDelegateMaxTimes(configData)
    --判空容错
    if not configData then
        return 1, false
    end
    --获取默认配置值
    local l_maxTimes = configData.ActivityTime or 1
    local l_monthCardFlag = false
    --月卡特判-----------------------------------------
    if MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard() then
        local l_systemId = configData.SystemID
        --月卡会员猫手次数读Global表  
        if l_systemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.CatCaravan then
            l_maxTimes = MGlobalConfig:GetInt("MaoshouUpActiveTimes") or 1
            l_monthCardFlag = true
        end
    end
    --end 月卡特判--------------------------------------
    return l_maxTimes, l_monthCardFlag
end

--确认委托是否完成
--data  委托数据
function CheckDelegateFinish(data)
    if data then
        return data.finish_times >= data.max_times
    end
    return false
end

--根据委托ID获取委托是否完成
--id  委托id
function IsDelegateFinish(id)

    local l_delegateData = array.find(delegates, function(v) return v.id == id end)
    return CheckDelegateFinish(l_delegateData)
    
end

function GetFinishTime(id)
    local l_ret = 0
    local l_delegate = array.find(delegates, function(v) return v.id == id end)
    if l_delegate then
        l_ret = l_delegate.finish_times
    end
    
    return l_ret
end

function GetDelegateJoinBaseLv(data)
    local l_ret = 0
    local l_delegateSdata = data.sdata
    if l_delegateSdata then
        if l_delegateSdata.ActivityType == GameEnum.DelegateType.Task then
            l_ret = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptBaseLv(data.taskId)
            if l_ret == -1 then
                l_ret  = 0
            end
        else
            l_ret = MgrMgr:GetMgr("OpenSystemMgr").GetSystemOpenBaseLv(l_delegateSdata.SystemID)
        end
    end
    return l_ret
end

--更新所有委托次数相关数据 （主要用于月卡开启后事件）
function UpdateDelegateTimes()
    if not delegates then
        return
    end

    for k,v in pairs(delegates) do
        v.max_times, v.monthCardFlag = GetDelegateMaxTimes(v.sdata)
        v.isFinish = CheckDelegateFinish(v) and 1 or 0
    end
end