--this file is gen by script
--you can edit this file in custom part

--lua model
---@module ModuleMgr.IllustrationMonsterMgr
module("ModuleMgr.IllustrationMonsterMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

--lua model end

--lua custom scripts

---@type table<number, MonsterRedSignData>
MonsterDataCache = {}

--- 单个数据当中是否有红点，只维护单个魔物红点是否被点亮
---@type table<number, MonsterRedSignData>
RedSignSingleHash = {}

--- 整组数据中是否有红点，这边是记录组红点点亮类型的表，如果单个魔物亮了，值为0，其他情况为组等级
---@type table<number, table<number, number>>
RedSignGroupHash = {}

--- 2020.6.1从IllustrationMgr挪出代码，若有问题无法在本脚本当前代码中获得答案请Blame原写法
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local l_data = DataMgr:GetData("IllustrationMonsterData")
local handBookLvTable = nil

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    handBookLvTable = TableUtil.GetEntityHandBookLvTable().GetTable()
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[IllustrationMonster] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local itemUpdateData = itemUpdateDataList[i]:GetItemCompareData()
        if itemUpdateData.id == 205 then
            ---检测魔物研究进度点是否有变化
            local nowCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, 205)
            local oldCount = nowCount - itemUpdateData.count
            local oldLvl = GetLvlByCoinCount(oldCount)
            local newLvl = GetLvlByCoinCount(nowCount)
            if newLvl > oldLvl then
                UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonster_upgradeTips, { LV = newLvl })
            end
        end
    end
end

--登录获取魔物图鉴信息
---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    --魔物信息
    local firstKillTable = info.illustration.monster.first_kill
    local alreadyKillTable = info.illustration.monster.already_kill
    local singleInfoTable = info.illustration.single_info
    local groupInfoTable = info.illustration.group_info
    --魔物状态记录
    for k, v in ipairs(firstKillTable) do
        l_data.SetMonsterStateTable(v.value, l_data.ILLUSTRATION_STATE.First)
    end
    for k, v in ipairs(alreadyKillTable) do
        l_data.SetMonsterStateTable(v.value, l_data.ILLUSTRATION_STATE.Already)
    end
    for k, v in ipairs(singleInfoTable) do
        l_data.SetMonsterKillNum(v.monster_id, v.killed_num)
        l_data.SetMonsterReward(v.monster_id, v.research_sign)
    end
    for k, v in ipairs(groupInfoTable) do
        l_data.UpdateGroupRewardInfo(v.element_id, v.group_id, v.research_sign)
    end

    l_data.SetRewardMainInfo(info.illustration.research_info.research_sign)
    l_data.InitMonsterHandBook()
    l_data.InitSpriteNames()
    _syncAllMonsterInfo()
end

---更新杀怪数
function UpdateMonsterKilledNumNtf(msg)
    ---@type UpdateMonsterKilledNumData
    local l_info = ParseProtoBufToTable("UpdateMonsterKilledNumData", msg)
    for k, v in ipairs(l_info.monster_num) do
        local lastlvl = l_data.GetMonsterRewardLevelById(v.key)
        l_data.SetMonsterKillNum(v.key, v.value)
        --- 如果杀怪数在（本次游戏登陆中）大于目标等级数弹出tips
        local nowlvl = l_data.GetMonsterRewardLevelById(v.key)
        if nowlvl > lastlvl then
            local l_openData = {
                id = v.key,
                Lvl = nowlvl
            }

            _onSingleMonsterNumChanged(v.key)
            ---红点检测
            MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MonsterHandBook)
            UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonster_Tips, l_openData)
        end
    end

    EventDispatcher:Dispatch(l_data.ILLUSTRATION_MONSTER_KILL)
end

--收取首杀魔物
function ResponseFirstKillMonster(msg)
    ---@type FirstKillMonsterInfo
    local l_info = ParseProtoBufToTable("FirstKillMonsterInfo", msg)
    l_data.SetMonsterStateTable(l_info.id, l_data.ILLUSTRATION_STATE.First)
end

--请求解锁魔物图鉴
function RequestUnLockRoleIllustration(type, id)
    local l_msgId = Network.Define.Rpc.UnLockRoleIllutration
    ---@type UnLockRoleIllutrationArg
    local l_sendInfo = GetProtoBufSendTable("UnLockRoleIllutrationArg")
    l_sendInfo.type = type
    l_sendInfo.id = id

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--返回解锁魔物图鉴
function ResponseUnLockRoleIllutration(msg, arg)
    ---@type UnLockRoleIllutrationRes
    local l_info = ParseProtoBufToTable("UnLockRoleIllutrationRes", msg)

    if l_info.result == 0 then
        l_data.SetMonsterStateTable(l_info.id, l_data.ILLUSTRATION_STATE.Already)
        EventDispatcher:Dispatch(l_data.ILLUSTRATION_UNLOCK_MONSTER, l_info.id)
    end
end

--请求获取魔物奖励
function GetMonsterAward(type, level, param1, param2)
    local l_msgId = Network.Define.Rpc.GetMonsterAward
    ---@type GetMonsterAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetMonsterAwardArg")
    l_sendInfo.op_type = type
    l_sendInfo.param1 = param1 or 0
    l_sendInfo.param2 = param2 or 0
    l_sendInfo.level = level
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--返回获取魔物奖励
---@param arg GetMonsterAwardArg
function OnGetMonsterAward(msg, arg)
    ---@type GetMonsterAwardRes
    local l_info = ParseProtoBufToTable("GetMonsterAwardRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        ---@type MonsterBookUpdateParam
        local msgParam = {
            Type = GameEnum.EMonsterBookAwardType.None,
            MonsterType = 0,
            MonsterGroup = 0,
            MonsterID = 0
        }

        if arg.op_type == MonsterAwardType.MONSTER_AWARD_SINGLE then
            msgParam.Type = GameEnum.EMonsterBookAwardType.SingleMonster
            msgParam.MonsterID = arg.param1
            local targetData = _tryGetMonsterConfigFromCache(msgParam.MonsterID)
            msgParam.MonsterGroup = targetData.Group
            msgParam.MonsterType = targetData.Type
            l_data.SetMonsterReward(arg.param1, l_info.research_sign)
        elseif arg.op_type == MonsterAwardType.MONSTER_AWARD_GROUP then
            msgParam.Type = GameEnum.EMonsterBookAwardType.GroupMonster
            msgParam.MonsterType = arg.param1
            msgParam.MonsterGroup = arg.param2
            l_data.UpdateGroupRewardInfo(arg.param1, arg.param2, l_info.research_sign)
        elseif arg.op_type == MonsterAwardType.MONSTER_AWARD_RSEARCH then
            l_data.SetRewardMainInfo(l_info.total_research_sign)
        end

        _onGetReward(msgParam)
        EventDispatcher:Dispatch(l_data.ILLUSTRATION_MONSTER_REWARD, msgParam)
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MonsterHandBook)
    end
end
---刷新魔物研究界面
function RefreshRewardBookPage()
    EventDispatcher:Dispatch(l_data.REWARD_BOOK_PAGE_REFRESH)
end
---获取当前魔物研究等级
function GetHandBookLvl()
    local Count = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, 205)
    local lvl = 0
    if Count > handBookLvTable[#handBookLvTable].Point then
        return #handBookLvTable
    else
        for i = 1, #handBookLvTable - 1 do
            if Count < handBookLvTable[i].Point then
                return i - 1
            end
        end
    end
    return 0
end
---根据魔物研究点数量计算等级
function GetLvlByCoinCount(Count)
    if Count > handBookLvTable[#handBookLvTable].Point then
        return #handBookLvTable
    else
        for i = 1, #handBookLvTable - 1 do
            if Count < handBookLvTable[i].Point then
                return i - 1
            end
        end
    end
    return 0
end

function CheckSingle(id)
    return nil ~= RedSignSingleHash[id]
end

--- 元素中有组奖励或单个奖励未领取
function CheckNeedShowElementTogRedSign(element)
    local targetGroup = RedSignGroupHash[element]
    if nil == targetGroup then
        return false
    end

    for k, v in pairs(targetGroup) do
        return true
    end

    return false
end

--- 检查单个红点是否满足条件
function CheckLineRedSign(element, group, lv)
    local elementGroup = RedSignGroupHash[element]
    if nil == elementGroup then
        return false
    end

    local value = RedSignGroupHash[element][group]
    if nil == value then
        return false
    end

    local ret = _checkSingleGroupAwardStatus(element, group, lv)
    return ret
end

--- 大红点检测是，这个对应是最外层的页签，只要有一个就会点亮
function CheckHandBookRedsign()
    for k, v in pairs(RedSignGroupHash) do
        for innerKey, innerValue in pairs(v) do
            return 1
        end
    end

    return 0
end

function _checkGroupRedSign(type, groupID)
    local group = RedSignGroupHash[type]
    if nil == group then
        return false
    end

    local ret = nil ~= group[groupID]
    return ret
end

--- 检查单个魔物相关的红点
function _checkSingleRed(id)
    local ret = nil ~= RedSignSingleHash[id]
    return ret
end

---@param param MonsterBookUpdateParam
function _onGetReward(param)
    if nil == param then
        return
    end

    if GameEnum.EMonsterBookAwardType.SingleMonster == param.Type then
        if nil == RedSignSingleHash[param.MonsterID] then
            logError("[MonsterBook] invalid id: " .. tostring(param.MonsterID))
            return
        end

        local currentLv = l_data.GetMonsterRewardNowPickLvl(param.MonsterID)
        local expectedLv = RedSignSingleHash[param.MonsterID].CanGetLv
        if expectedLv >= currentLv then
            return
        end

        RedSignSingleHash[param.MonsterID] = nil
        _tryRemoveGroup(param.MonsterType, param.MonsterGroup, false)
    elseif GameEnum.EMonsterBookAwardType.GroupMonster == param.Type then
        local currentLv = RedSignGroupHash[param.MonsterType][param.MonsterGroup]
        if _checkSingleGroupAwardStatus(param.MonsterType, param.MonsterGroup, currentLv) then
            return
        end

        _tryRemoveGroup(param.MonsterType, param.MonsterGroup, true)
    else
        logError("[MonsterBook] invalid type: " .. ToString(param))
    end
end

function _tryRemoveGroup(type, group, groupRemove)
    local groupTab = RedSignGroupHash[type]
    if nil == groupTab then
        logError("[MonsterBook] invalid type: " .. tostring(type))
        return
    end

    local targetValue = groupTab[group]
    if nil == targetValue then
        return
    end

    if not groupRemove and 0 < targetValue then
        return
    end

    RedSignGroupHash[type][group] = nil
    for k, v in pairs(RedSignSingleHash) do
        if v.Type == type and v.Group == group then
            RedSignGroupHash[type][group] = 0
            return
        end
    end
end

function _onSingleMonsterNumChanged(id)
    local targetMonsterSetting = _tryGetMonsterConfigFromCache(id)
    local allData = l_data.GetAllRewardMonster()
    local monsterType = targetMonsterSetting.Type
    local monsterGroup = targetMonsterSetting.Group
    local groupTable = allData[monsterType][monsterGroup]
    _updateSingleIdData(groupTable)
end

--- 同步所有的红点数据
function _syncAllMonsterInfo()
    RedSignSingleHash = {}
    RedSignGroupHash = {}
    for element, elementTable in pairs(l_data.GetAllRewardMonster()) do
        if nil == RedSignGroupHash[element] then
            RedSignGroupHash[element] = {}
        end

        for group, groupTable in pairs(elementTable) do
            _updateSingleIdData(groupTable)
        end
    end
end

function _updateSingleIdData(groupTable)
    local minLvl = 32
    local monsterType = nil
    local monsterGroup = nil
    for _, v in pairs(groupTable) do
        if v.Id and v.Id ~= 0 then
            local lvl = GetMonsterRewardLevelById(v.Id)
            local targetData = _tryGetMonsterConfigFromCache(v.Id)
            monsterType = targetData.Type
            monsterGroup = targetData.Group
            if lvl and lvl >= l_data.GetMonsterRewardNowPickLvl(v.Id) then
                RedSignSingleHash[v.Id] = {
                    Type = targetData.Type,
                    Group = targetData.Group,
                    CanGetLv = lvl
                }

                RedSignGroupHash[monsterType][monsterGroup] = 0
            else
                RedSignSingleHash[v.Id] = nil
            end

            if lvl then
                minLvl = minLvl < lvl and minLvl or lvl
            end
        end
    end

    if _checkHaveGroupRewardCanPick(monsterType, monsterGroup, minLvl) then
        RedSignGroupHash[monsterType][monsterGroup] = minLvl
    end
end

---有组奖励未领取
function _checkHaveGroupRewardCanPick(element, group, lv)
    local l_infos = l_data.GetAllRewardMonster()
    for k, v in pairs(l_infos[element][group]) do
        if v.Id == nil then
            return false
        end
    end

    if #l_infos[element][group] < 5 then
        return false
    end

    local ret = _checkSingleGroupAwardStatus(element, group, lv)
    return ret
end

function _checkSingleGroupAwardStatus(element, group, lv)
    local num2 = l_data.GetRewardGroupInfo(element, group)
    if num2 == 0 then
        return lv > 0
    end

    num2 = math.modf(num2 / 2)
    for i = 1, lv do
        if num2 % 2 == 0 then
            return true
        end
        num2 = math.modf(num2 / 2)
    end

    return false
end

---@return MonsterRedSignData
function _tryGetMonsterConfigFromCache(id)
    local targetData = MonsterDataCache[id]
    if nil ~= targetData then
        return targetData
    end

    local config = TableUtil.GetEntityHandBookTable().GetRowByID(id)
    local entityConfig = TableUtil.GetEntityTable().GetRowById(id)
    monsterType = entityConfig.UnitAttrType
    monsterGroup = config.Group
    ---@type MonsterRedSignData
    local ret = {
        Type = monsterType,
        Group = monsterGroup
    }

    MonsterDataCache[id] = ret
    return ret
end

--lua custom scripts end
return ModuleMgr.IllustrationMonsterMgr