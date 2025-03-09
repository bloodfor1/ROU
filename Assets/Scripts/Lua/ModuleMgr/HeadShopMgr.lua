---@module ModuleMgr.HeadShopMgr
module("ModuleMgr.HeadShopMgr", package.seeall)

local table_insert = table.insert
local LimitMgr = MgrMgr:GetMgr("LimitMgr")

EventDispatcher = EventDispatcher.new()
ON_EXCHANGE_ORNAMENT = "ON_EXCHANGE_ORNAMENT"

local l_data

SelectOrnamentId = 0
local entityList = {}

function OnInit()
    l_data = DataMgr:GetData("HeadShopData")
    entityList = _getMonsterEntityIdList()
end

function OnLogout()
    entityList = {}
end

function OnReconnected()
    if UIMgr:IsActiveUI(UI.CtrlNames.HeadShop) then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.HeadShop)
        if l_ui then
            l_ui:OnReconnected()
        end
        return
    end
end

function GetOrnamentsByNpcId(id)

    local l_result = {}

    local l_tableData = TableUtil.GetOrnamentBarterTable().GetTable()
    for i, row in ipairs(l_tableData) do
        if row.NpcID == id then
            table_insert(l_result, row.OrnamentID)
        end
    end

    return l_result
end

function GetOrnamentDataByNpcId(id)
    local l_result = {}
    local l_tableData = TableUtil.GetOrnamentBarterTable().GetTable()

    for _, row in ipairs(l_tableData) do
        if row.NpcID == id then
            table_insert(l_result, row)
        end
    end

    return l_result
end

function _getMonsterEntityIdList()
    local npcIds = {}
    local result = TableUtil.GetOrnamentBarterTable().GetTable()
    if result ~= nil then
        for i, item in ipairs(result) do
            if item.EntityLimit[0] > 0 then
                table.insert(npcIds, item.EntityLimit[0])
            end
        end
    end
    return npcIds
end

function GetMonsterEntityIdsByNpcId(id)
    local npcIds = {}
    local result = GetOrnamentDataByNpcId(id)
    if result ~= nil then
        for i, item in ipairs(result) do
            if item.EntityLimit[0] > 0 then
                table.insert(npcIds, item.EntityLimit[0])
            end
        end
    end
    return npcIds
end

--totalCost isNotCheck 为快捷付费数据可不传
function RequestExchangeHeadGear(id,totalCost,isNotCheck)
    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                RequestExchangeHeadGear(id,totalCost,true)
            end)
            return
        end
    end
    local l_msgId = Network.Define.Rpc.ExchangeHeadGear
    ---@type ExchangeHeadGearArg
    local l_sendInfo = GetProtoBufSendTable("ExchangeHeadGearArg")
    l_sendInfo.item_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnExchangeHeadGear(msg)
    ---@type ExchangeHeadGearRes
    local l_info = ParseProtoBufToTable("ExchangeHeadGearRes", msg)
    local l_error = l_info.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    if l_errorNo ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)
    else
        EventDispatcher:Dispatch(ON_EXCHANGE_ORNAMENT)
    end

end

-- 检查头饰是否还未解锁
function IsLocked(id, need_infomation)
    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(id)
    if not l_row then
        logError(StringEx.Format("不可能存在的错误,之前筛选的表格数据找不到了 ornament_id:{0}", id))
        return true
    end

    local l_locked = CheckLimit(id)
    if not need_infomation then
        return l_locked
    end

    return l_locked, Common.Utils.Lang("BASE_LEVEL_LIMIT", l_row.LevelLimit)
end

local function checkLevelLimit(row)
    if row.LevelLimit > MPlayerInfo.Lv then
        return true
    end
    return false
end

local function checkEntityLimit(row)

    if row.EntityLimit[0] ~= nil and
            row.EntityLimit[1] ~= nil and
            row.EntityLimit[0] > 0 and
            row.EntityLimit[1] > 0 then
        if CheckEntityLimit(row.EntityLimit[0], row.EntityLimit[1]) then
            return true
        end
    end
    return false
end

local function checkCollectionScoreLimit(row)
    if row.CollectionScoreLimit > 0 then
        if not LimitMgr.CheckCollectionScoreLimit(row.CollectionScoreLimit) then
            return true
        end
    end

    return false
end

local function checkAchievementPointLimit(row)
    if row.AchievementPointLimit > 0 then
        if not LimitMgr.CheckAchievementPointLimit(row.AchievementPointLimit) then
            return true
        end
    end
    return false
end

local function checkAchievementLimit(row)
    if row.AchievementLimit > 0 then
        if not LimitMgr.CheckAchievementLimit(row.AchievementLimit) then
            return true
        end
    end

    return false
end

local function checkTaskLimit(row)
    if row.TaskLimit > 0 then
        if not LimitMgr.CheckTaskLimit(row.TaskLimit) then
            return true
        end
    end
    return false
end

local function checkAchievementLevelLimit(row)

    if row.AchievementLevelLimit > 0 then
        if not LimitMgr.CheckAchievementLevelLimit(row.AchievementLevelLimit) then
            return true
        end
    end
    return false
end

function CheckLimit(ornamentID)

    local l_tableData = TableUtil.GetOrnamentBarterTable().GetTable()
    for i, row in ipairs(l_tableData) do
        if row.OrnamentID == ornamentID then
            return checkLevelLimit(row) or
                    checkEntityLimit(row) or
                    checkCollectionScoreLimit(row) or
                    checkAchievementPointLimit(row) or
                    checkAchievementLimit(row) or
                    checkTaskLimit(row) or
                    checkAchievementLevelLimit(row)
        end
    end

    return false
end

function RequestAllLimitData()
    if entityList ~= nil and #entityList > 0 then
        local l_msgId = Network.Define.Rpc.RequestKillMonsterCount
        ---@type RequestKillMonsterCountArg
        local l_sendInfo = GetProtoBufSendTable("RequestKillMonsterCountArg")
        for i, v in ipairs(entityList) do
            local monsterId = l_sendInfo.monster_ids:add()
            monsterId.value = v
        end

        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

function RequestLimitData(npcId)
    local entityList = GetMonsterEntityIdsByNpcId(npcId)
    if entityList ~= nil and #entityList > 0 then
        local l_msgId = Network.Define.Rpc.RequestKillMonsterCount
        ---@type RequestKillMonsterCountArg
        local l_sendInfo = GetProtoBufSendTable("RequestKillMonsterCountArg")
        for i, v in ipairs(entityList) do
            local monsterId = l_sendInfo.monster_ids:add()
            monsterId.value = v
        end

        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

function OnRequestKillMonsterCount(msg)
    l_data.MonsterEntityCount = {}
    ---@type RequestKillMonsterCountRes
    local l_info = ParseProtoBufToTable("RequestKillMonsterCountRes", msg)
    for _, item in ipairs(l_info.monster_id_count) do
        l_data.MonsterEntityCount[item.key] = item.value
    end
end

function CheckEntityLimit(entityId, limitNum)
    local result = false
    if l_data.MonsterEntityCount[entityId] ~= nil and l_data.MonsterEntityCount[entityId] > limitNum then
        result = true
    end

    return result
end

local function getLevelLimitStr(row, data)

    if row.LevelLimit > 0 then
        local item = {}
        item.level = row.LevelLimit
        item.finish = (row.LevelLimit <= MPlayerInfo.Lv)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        item.limitType = LimitMgr.ELimitType.LEVEL_LIMIT
        local limitStr = tostring(row.LevelLimit)
        --GetColorText(tostring(row.LevelLimit),item.finish and RoColorTag.Green or RoColorTag.Red)
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("LEVEL_LIMIT"), row.LevelLimit, item.finish and row.LevelLimit or MPlayerInfo.Lv, row.LevelLimit),
                colorTag)
        table.insert(data, item)
    end
end

local function getEntityLimitStr(row, data)

    if row.EntityLimit[0] ~= nil and
            row.EntityLimit[1] ~= nil and
            row.EntityLimit[0] > 0 and
            row.EntityLimit[1] > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.ENTITY_LIMIT
        item.finish = CheckEntityLimit(row.EntityLimit[0], row.EntityLimit[1])
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        item.entityId = row.EntityLimit[0]
        if l_data.MonsterEntityCount[row.EntityLimit[0]] ~= nil then
            item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ENTITY_LIMIT"), item.finish and row.EntityLimit[1] or l_data.MonsterEntityCount[row.EntityLimit[0]], row.EntityLimit[1], Common.CommonUIFunc.GetMonsterName(row.EntityLimit[0])),
                    colorTag)
        end
        table.insert(data, item)

    end
end

local function getCollectionScoreLimitStr(row, data)

    if row.CollectionScoreLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.COLLECTION_LIMIT
        item.finish = LimitMgr.CheckCollectionScoreLimit(row.CollectionScoreLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local count = item.finish and row.CollectionScoreLimit or MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count
        local countStr = tostring(count)
        local scoreLimitStr = tostring(row.CollectionScoreLimit)
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("COLLECTION_LIMIT"), countStr, scoreLimitStr), colorTag)
        table.insert(data, item)
    end
end

local function getAchievementPointLimitStr(row, data)

    if row.AchievementPointLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENTPOINT_LIMIT
        local count = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint > row.AchievementPointLimit and row.AchievementPointLimit or MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint
        item.finish = LimitMgr.CheckAchievementPointLimit(row.AchievementPointLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local countStr = tostring(count)
        --GetColorText(tostring(count),item.finish and RoColorTag.Green or RoColorTag.Red) 
        local achievementPointLimitStr = tostring(row.AchievementPointLimit), item.finish
        --GetColorText(tostring(row.AchievementPointLimit),item.finish and RoColorTag.Green or RoColorTag.Green.Red)
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("Achievement_DescText"), countStr, achievementPointLimitStr), colorTag)
        table.insert(data, item)
    end
end

local function getAchievementLimitStr(row, data)

    if row.AchievementLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENT_LIMIT
        item.finish = LimitMgr.CheckAchievementLimit(row.AchievementLimit)
        item.AchievementId = row.AchievementLimit
        local achievementInfo = MgrMgr:GetMgr("AchievementMgr").GetAchievementTableInfoWithId(row.AchievementLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ACHIEVEMENT_LIMIT"), achievementInfo.Name), colorTag)
        table.insert(data, item)
    end
end

local function getTaskLimitLimitStr(row, data)

    if row.TaskLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.TASK_LIMIT

        item.finish = LimitMgr.CheckTaskLimit(row.TaskLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local task = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(row.TaskLimit)
        if task ~= nil then
            item.str = GetColorText(StringEx.Format(Common.Utils.Lang("TASK_LIMIT"), task.typeTitle, task.name), colorTag)
        else
            item.str = "<color=$$Red$$>" .. "Error" .. "</color>"
        end
        item.task = task
        table.insert(data, item)
    end
end

local function getAchievementLevelLimitStr(row, data)

    if row.AchievementLevelLimit > 0 then
        local item = {}
        item.finish = LimitMgr.CheckAchievementLevelLimit(row.AchievementLevelLimit)
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENTLEVEL_LIMIT
        item.limitLevel = row.AchievementLevelLimit
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local l_itemRow = TableUtil.GetAchievementBadgeTable().GetRowByLevel(row.AchievementLevelLimit)
        local achievementLevelLimitStr = l_itemRow and l_itemRow.Name or ""
        --GetColorText(tostring(row.AchievementLevelLimit), item.finish and RoColorTag.Green or RoColorTag.Red) 
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ACHIEVEMENTLEVEL_LIMIT"), achievementLevelLimitStr), colorTag)
        table.insert(data, item)
    end
end

function GetLimitStr(ornamentID)
    local data = {}
    local l_tableData = TableUtil.GetOrnamentBarterTable().GetTable()
    for i, row in ipairs(l_tableData) do
        if row.OrnamentID == ornamentID then
            getLevelLimitStr(row, data)
            getEntityLimitStr(row, data)
            getCollectionScoreLimitStr(row, data)
            getAchievementPointLimitStr(row, data)
            getAchievementLimitStr(row, data)
            getTaskLimitLimitStr(row, data)
            getAchievementLevelLimitStr(row, data)
            break
        end
    end
    return data
end

return HeadShopMgr