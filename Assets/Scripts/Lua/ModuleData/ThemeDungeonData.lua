--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-09 10:52:23
--
---@class DungeonResultData
---@field ID
---@field Count
---@field IsAssist
---@field IsShowName
---@field CustomName

---@module ThemeDungeonData
module("ModuleData.ThemeDungeonData", package.seeall)

local C_REASON_ASSIST_MAP = {
    [ItemChangeReason.ITEM_REASON_DUNGEONS_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_HYMN_TRIAL] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_TOWER_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_BATTLE_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_THEME_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_PLATFORM_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_HERO_CHALLENGE_RESULT] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_TOWER_DEFENSE_DUNGEON] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_GUILD_HUNT_DUNGEONS] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_MAZE_DUNGEONS] = { isAssist = false, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_ASSIST] = { isAssist = true, isAssistSpecial = false },
    [ItemChangeReason.ITEM_REASON_ASSIST_SPECIAL] = { isAssist = false, isAssistSpecial = true },
    [ItemChangeReason.ITEM_REASON_ASSIST_HUILIU] = { isAssist = true, isAssistSpecial = true },
    [ItemChangeReason.ITEM_REASON_ASSIST_MENGXIN] = { isAssist = true, isAssistSpecial = true },
    [ItemChangeReason.ITEM_REASON_ASSIST_XIAOHAO] = { isAssist = true, isAssistSpecial = true },
}

local C_CUSTOM_NAME_MAP = {
    [ItemChangeReason.ITEM_REASON_ASSIST_MENGXIN] = { str = Common.Utils.Lang("ASSIST_NEWBEE"), idx = 0 },
    [ItemChangeReason.ITEM_REASON_ASSIST_HUILIU] = { str = Common.Utils.Lang("ASSIST_BACK"), idx = 1 },
    [ItemChangeReason.ITEM_REASON_ASSIST_XIAOHAO] = { str = Common.Utils.Lang("ASSIST_LOWLEVEL"), idx = 2 },
}

local C_CUSTOM_NAME = "NIL"

ThemeDungeonNPCId = 3410            -- 主题副本的入口书籍
ThemeDungeonBoxId = 3550            -- 主题副本猫头鹰

-- 主题副本入口镜头配置
CamConfig = {
    [1] = { 61.28, 18.9, 74.9 },
    [2] = { 13.365, -1.716, 0 },
    [3] = { 61.2, 18.22, 78.8 },
    [4] = { 16.74, -1.855, 0 },
    [5] = { 61.097, 17.077, 81.147 },
    [6] = { 11.96, -1.855, 0 },
}

CachedDungeonWeekAward = nil        -- 缓存周奖励
---通用结算奖励，从dungeonResult协议中获取奖励
DungeonRewardItem = {}              -- 副本结算奖励
DungeonExtraRewardItem = {}              -- 副本结算额外奖励
---特殊结算奖励，通过道具更新系统及邮件系统获取的奖励
DungeonRewardFromPropUpdate = {}     --背包系统道具更新检测到的奖励
CachedRewardItemFromMail = {}       -- 背包满时邮件获取物品

IsThemeDungeonReward = false        -- 是否是主题副本的奖励
IsAssistReward = false        -- 是否是助战奖励
DungeonCostTimeStr = nil            -- 副本结算耗时文本
DungeonResultInfo = {}              -- 副本结算信息
ThumbQueue = {}                     -- 点赞消息队列
SinglePlayerDungeon = false         -- 是否是单人副本
local teamInfo = nil
local sceneRoleInfo = {}
local l_assistAwardPercent = nil

-- 当前挑战主题id，-1表示未开启
curThemeId = -1
-- 挑战副本上一次刷新时间
lastRefreshTime = 0
-- 挑战副本下次刷新时间
nextRefreshTime = 0
-- 挑战副本词缀
dungeonAffix = {}
-- 已通关副本
passedDungeons = {}
-- 上周可领取的奖励id
lastWeekAwardId = 0
-- 上一次挑战副本打开的时间戳
lastOpenStamp = 0

function Init()

end

function Logout()
    curThemeId = -1
    lastRefreshTime = 0
    nextRefreshTime = 0
    dungeonAffix = {}
    passedDungeons = {}
    lastWeekAwardId = 0
    lastOpenStamp = 0
end

-- 选角协议数据处理
function OnSelectRoleNtf(msg)
    lastWeekAwardId = msg.dungeons.theme_dungeons.award_last_week

    for i, v in ipairs(msg.dungeons.theme_dungeons.dungeons) do
        passedDungeons[v.dungeons_id] = true
    end
    for i, v in ipairs(msg.dungeons.themestory_dungeons.dungeon_list) do
        passedDungeons[v.dungeons_id] = true
    end

end

function RefreshDungeonRewardItem()
    DungeonRewardItem = {}
    DungeonExtraRewardItem = {}
end

function RefreshAllDungeonRewardItem()
    DungeonRewardItem = {}
    DungeonExtraRewardItem = {}
    DungeonRewardFromPropUpdate = {}
end

-- 是否是刷新周期内第一次打开
function CheckNewTask()
    local l_isNew = not (tonumber(lastOpenStamp) > tonumber(lastRefreshTime) and tonumber(lastOpenStamp) < tonumber(nextRefreshTime))
    if l_isNew then
        UIMgr:ActiveUI(UI.CtrlNames.Theme_NewTask, { themeDungeonId = curThemeId })
        -- 通知服务器打开的时间
        ---@type SetThemeStampArg
        local l_sendInfo = GetProtoBufSendTable("SetThemeStampArg")
        Network.Handler.SendRpc(Network.Define.Rpc.SetThemeStamp, l_sendInfo)
    end
end

function SetDungeonPassed(dungeonId)
    passedDungeons[dungeonId] = true
end

function GetDayPassCountAndLimit()
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    return l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.ThemeDungeon, "1"), l_limitBuyMgr.GetLimitByKey(l_limitBuyMgr.g_limitType.ThemeDungeon, "1")
end

function GetWeekPassCountAndLimit()
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    return l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.ThemeDungeon, "2"), l_limitBuyMgr.GetLimitByKey(l_limitBuyMgr.g_limitType.ThemeDungeon, "2")
end

function GetWeekAwardCountAndLimit()
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    return l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.ThemeDungeon, "2"), MGlobalConfig:GetInt("GreatSecretWeekActivityLimit")
end

function attrEnumToKey(attrID)
    local l_key
    if attrID == DungeonsBattleAttr.DUNGEONS_BATTLE_TAKEN then
        l_key = "isTaken"
    elseif attrID == DungeonsBattleAttr.DUNGEONS_BATTLE_DAMAGE then
        l_key = "isDamage"
    elseif attrID == DungeonsBattleAttr.DUNGEONS_BATTLE_HEAL then
        l_key = "isHeal"
    elseif attrID == DungeonsBattleAttr.DUNGEONS_BATTLE_FATAL_HIT then
        l_key = "isHit"
    end
    return l_key
end

function markDungeonResultAttrs(roleId, attr)

    --每个玩家拥有的战斗属性 可多种
    DungeonResultInfo[roleId] = {}
    DungeonResultInfo[roleId].professionID = attr.profession
    DungeonResultInfo[roleId].isTaken = 0
    DungeonResultInfo[roleId].isDamage = 0
    DungeonResultInfo[roleId].isHeal = 0
    DungeonResultInfo[roleId].isHit = 0
    for j = 1, #attr.attr_id do
        local attrID = tonumber(attr.attr_id[j].value)
        local l_key = attrEnumToKey(attrID)
        if l_key then
            DungeonResultInfo[roleId][l_key] = 1
        end
    end
    --初始化点赞队列
    ThumbQueue[roleId] = {}
    ThumbQueue[roleId].index = 0
    DumpSceneRoleInfo(roleId)
end

-- 副本结算
function OnDungeonsResult(info, dungeonType)

    local min, sec = math.modf(info.pass_time / 60)
    sec = info.pass_time - (min * 60)
    DungeonCostTimeStr = StringEx.Format("{0}'{1}", min, sec)
    ThumbQueue = {}
    DungeonResultInfo = {}
    --结算玩家副本战斗属性 同一个玩家有多种战斗属性
    for i = 1, table.maxn(info.attrs) do
        local roleId = info.attrs[i].role_id
        if roleId and roleId ~= 0 then
            markDungeonResultAttrs(roleId, info.attrs[i])
        end
    end

    -- 主题副本
    if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        if dungeonType == 2 then
            if info.theme_record then
                DayPassCount = info.theme_record.day_count or 0
                WeekPassCount = info.theme_record.week_count or 0
            end
        end
    end
end

-- 珲春道具信息
function OnItemChange(info)
    CachedDungeonWeekAward = info
end

-- 标志是否为主题副本奖励
function SetIsThemeDungeonReward(state)

    IsThemeDungeonReward = state
end

-- 标志是否为助战奖励
function SetIsAssistReward(state)
    IsAssistReward = state
end


-- 缓存邮件奖励
function SetRewardItemsMail(rewadItems)
    if IsThemeDungeonReward then
        CachedRewardItemFromMail = rewadItems
    end
end

-- 清理缓存
function ClearRewardItemsMail()
    CachedRewardItemFromMail = {}
end

-- 获取缓存的奖励
function GetAllRewardItems()
    local l_dungeonsType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    --非结算协议奖励数据，走背包更新逻辑
    if l_dungeonsType == l_dungeonMgr.DungeonType.DungeonGuildHunt then
        return getRewardFromPropUpdate()
    end
    return DungeonRewardItem
end

function getRewardFromPropUpdate()
    for i = 1, #CachedRewardItemFromMail do
        local l_mailRewardData = CachedRewardItemFromMail[i]
        local l_newRewardData = createDungeonResultDatas(l_mailRewardData.id,l_mailRewardData.count,
            0)
        table.insert(DungeonRewardFromPropUpdate,l_newRewardData)
    end
    return mergeAwardItems(DungeonRewardFromPropUpdate)
end

-- 获取缓存的额外奖励
function GetExtraRewardItems()
    return DungeonExtraRewardItem
end

-- 预存当前的组队信息
function DumpTeamInfo()
    teamInfo = nil
    sceneRoleInfo = {}
    teamInfo = DataMgr:GetData("TeamData").myTeamInfo
end

-- 根据roleid获取角色名
function GetRoleNameById(roleId)
    local data = teamInfo
    if data then
        for k, v in pairs(data.memberList) do
            if tostring(v.roleId) == tostring(roleId) then
                return tostring(v.roleName)
            end
        end
    end
    if sceneRoleInfo == nil then
        return ""
    end
    local l_targetInfo = sceneRoleInfo[roleId]
    if l_targetInfo then
        return l_targetInfo.Name
    end
    return ""
end

-- 珲春角色装备信息
function DumpSceneRoleInfo(roleId)
    local l_role = MEntityMgr:GetRole(roleId, true)
    if l_role then
        local l_attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(),
                l_role.AttrRole.Name,
                l_role.AttrRole.ProfessionID,
                l_role.AttrRole.IsMale,
                nil)
        l_attr.EquipData:Copy(l_role.AttrRole.EquipData)
        sceneRoleInfo[roleId] = l_attr
    else
        logError("错误日志：没有找到指定的roleId对应的数据", roleId)
    end
end

-- 返回角色信息和组队信息
function GetSceneRoleInfoAndTeamInfo()
    return sceneRoleInfo, teamInfo
end

---@param itemDatas ItemUpdateData[]
function UpdateRewardItemFromPropUpdate(itemUpdateDatas)
    if itemUpdateDatas==nil or #itemUpdateDatas<1 then
        return
    end

    for i = 1, #itemUpdateDatas do
        local l_singleItemUpdateData = itemUpdateDatas[i]
        ---@type ItemUpdateCompareData
        local l_compareData = l_singleItemUpdateData:GetItemCompareData()
        if l_compareData.count>0 then
            local l_newRewardInfo = createDungeonResultDatas(l_compareData.id,l_compareData.count,
                    l_singleItemUpdateData.reason)
            table.insert(DungeonRewardFromPropUpdate,l_newRewardInfo)
        end
    end
end

---@param info AwardsInfo[]
---@param extraResultInfo AwardsInfo[]
function UpdateRewardItem(info,extraResultInfo)
    local itemShowParamList = tidyRewardItemInfo(info)
    table.ro_insertRange(DungeonRewardItem, itemShowParamList)
    local extraItemShowParamList = tidyRewardItemInfo(extraResultInfo)
    table.ro_insertRange(DungeonExtraRewardItem, extraItemShowParamList)
end

---@param info AwardsInfo[]
---@return DungeonResultData[]
function tidyRewardItemInfo(info)
    local l_awardInfos = changeAwardInfoStruct(info)
    local itemShowParamList = mergeAwardItems(l_awardInfos)
    return itemShowParamList
end

---@param list AwardsInfo[]
---@return DungeonResultData[]
function changeAwardInfoStruct(list)
    local l_awardInfos = {}

    local isAssist = false
    for i = 1, #list do
        ---@type AwardsInfo
        local singleData = list[i]
        local l_newRewardInfo = createDungeonResultDatas(singleData.item_id,singleData.item_count,
                singleData.reason)
        table.insert(l_awardInfos, l_newRewardInfo)
    end

    ----副本奖励,助战,助战黑盒
    SetIsAssistReward(isAssist)
    return l_awardInfos
end

function getAwardPercentData()
    if l_assistAwardPercent == nil then
        l_assistAwardPercent = MGlobalConfig:GetSequenceOrVectorInt("AssistAwardPercent")
    end
    return l_assistAwardPercent
end

---@return DungeonResultData[]
function createDungeonResultDatas(itemID,itemCount,itemChangeReason)
    local l_matchResult = C_REASON_ASSIST_MAP[itemChangeReason]
    local l_assistState = false
    if nil ~= l_matchResult then
        l_assistState = l_matchResult.isAssist or l_matchResult.isAssistSpecial
        if l_assistState then
            isAssist = true
        end
    end

    local l_customName = C_CUSTOM_NAME
    local l_targetData = C_CUSTOM_NAME_MAP[itemChangeReason]
    local l_tagValues = getAwardPercentData()
    if nil ~= l_targetData then
        l_customName = StringEx.Format(l_targetData.str, l_tagValues[l_targetData.idx])
    end
    local l_resultData = createResultOriginData(itemID, itemCount, l_assistState, l_customName ~= C_CUSTOM_NAME,
            l_customName)

    return l_resultData
end

function createResultOriginData(itemID,itemCount,isAssist,showName,customName)
    local l_resultData = {
        ID = itemID,
        Count = itemCount,
        IsAssist = isAssist,
        IsShowName = showName,
        CustomName = customName,
    }

    return l_resultData
end
-- 合并相同物品项
---@return DungeonResultData[]
function mergeAwardItems(repeatedAwardItems)
    local l_unRepeatedAwardInfos = {}
    for k, v in ipairs(repeatedAwardItems) do
        local l_tempAwardData = l_unRepeatedAwardInfos[v.ID]
        if not l_tempAwardData then
            l_tempAwardData = createResultOriginData(v.ID,0,v.IsAssist,v.IsShowName
                ,v.CustomName)
        end
        l_tempAwardData.Count = l_tempAwardData.Count + v.Count
        l_unRepeatedAwardInfos[v.ID] = l_tempAwardData
    end
    local l_awardInfoList = {}
    for i, v in pairs(l_unRepeatedAwardInfos) do
        table.insert(l_awardInfoList,v)
    end
    return l_awardInfoList
end
return ModuleData.ThemeDungeonData