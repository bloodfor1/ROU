---@module ModuleMgr.RedSignCheckMgr
module("ModuleMgr.RedSignCheckMgr", package.seeall)

eRedSignCheckType =
{
    LoopCheck = 1,              --持续检测
    OnItemChangeCheck = 2,      --收到ItemChange协议的时候检测
    OnGoodsOrCoinChangeCheck = 3,
    OnBaseLevelChange = 4,
    OnTransferProfession = 5,
    TimeLoopCheck = 6,          --对应TimeCheck字段
}

EventType =
{
    RedSignStateChanged=1,  --红点状态变更
}

local _timer, _nowTime
local _checkKeys = {}                   --红点检测触发器，key是检测类型ID，value是检测方法id
local _openSystemKeys = {}              --需要功能开启判断的红点，key是功能id，value是检测方法id
local loopCheckAddInterval, timeCheckAddInterval = 10, 1
local timeForLoopCheck, timeForTimeCheck = 0, 0
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

EventDispatcher = EventDispatcher.new()
--注册检测方法
function RegisterCheckMethods()

    local l_redTable = TableUtil.GetRedDotCheckTable().GetTable()
    for i = 1, #l_redTable do
        if (not string.ro_isEmpty(l_redTable[i].MgrName)) and (not string.ro_isEmpty(l_redTable[i].CheckMethodName)) then
            AddCheckMethod(l_redTable[i].ID, MgrMgr:GetMgr(l_redTable[i].MgrName)[l_redTable[i].CheckMethodName], l_redTable[i].CheckMethodType)
        end
        if l_redTable[i].OpenSystemID ~= 0 then
            if _openSystemKeys[l_redTable[i].OpenSystemID] == nil then
                _openSystemKeys[l_redTable[i].OpenSystemID] = {}
            end
            table.insert(_openSystemKeys[l_redTable[i].OpenSystemID], l_redTable[i].ID)
        end
    end

end

function AddCheckMethod(key, method, checkType)

    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    redSignMgr.AddCheckMethod(key, method)
    local l_redTable = TableUtil.GetRedDotCheckTable().GetRowByID(key)
    local l_timeCheck = Common.Functions.VectorSequenceToTable(l_redTable.TimeCheck)
    if l_timeCheck and #l_timeCheck > 0 then
        if _checkKeys[eRedSignCheckType.TimeLoopCheck] == nil then
            _checkKeys[eRedSignCheckType.TimeLoopCheck] = {}
        end
        table.insert(_checkKeys[eRedSignCheckType.TimeLoopCheck], key)
    end
    if checkType ~= nil and checkType ~= 0 then
        if _checkKeys[checkType] == nil then
            _checkKeys[checkType] = {}
        end
        table.insert(_checkKeys[checkType], key)
    end

end

---@param checkData ItemUpdateData[]
function _updateRedSignWithCheckType(checkType, checkData)

    if _checkKeys[checkType] == nil or #_checkKeys[checkType] == 0 then
        return
    end
    local l_CheckKeys = _checkKeys[checkType]
    local l_CheckCount = #l_CheckKeys
    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    for i = 1, l_CheckCount do
        redSignMgr.UpdateRedSign(l_CheckKeys[i], checkData)
    end

end

--数据走服务器直接改红点的显示
function ReceiveRedPointNotify(msg)

    ---@type ModuleMgr.RedSignMgr
    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    ---@type RedPointNotify
    local l_info = ParseProtoBufToTable("RedPointNotify", msg)
    for i = 1, #l_info.notify do
        local l_redData = l_info.notify[i]
        --logGreen("服务器发的id：" .. tostring(l_redData.moduleid) .. "   count：" .. tostring(l_redData.count))
        redSignMgr.DirectUpdateRedSign(l_redData.moduleid, l_redData.count)
    end
    EventDispatcher:Dispatch(EventType.RedSignStateChanged)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)

    if nil == itemUpdateDataList then
        logError("[RedSignCheckMgr] invalid param")
        return
    end

    local propMgr = MgrMgr:GetMgr("PropMgr")
    for i = 1, #itemUpdateDataList do
        local singleUpdateInfo = itemUpdateDataList[i]
        local changeData = singleUpdateInfo:GetItemCompareData()
        if propMgr.IsCoin(changeData.id) then
            OnGoodsOrCoinChange()
        else
            local targetItem = singleUpdateInfo:GetNewOrOldItem()
            if nil == targetItem then
                logError("[RedSignCheckMgr] invalid param")
                return
            end
            if GameEnum.EItemType.Equip == targetItem.ItemConfig.TypeTab then
                OnGoodsOrCoinChange()
            end
        end
    end

end

function OnGoodsOrCoinChange()
    _updateRedSignWithCheckType(eRedSignCheckType.OnGoodsOrCoinChangeCheck)
end

function _onBaseLevelChange()
    _updateRedSignWithCheckType(eRedSignCheckType.OnBaseLevelChange)
end

function OnTransferProfession()
    _updateRedSignWithCheckType(eRedSignCheckType.OnTransferProfession)
end

--MgrMgr
function OnUpdate()

    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    if _checkKeys[eRedSignCheckType.LoopCheck] ~= nil and #_checkKeys[eRedSignCheckType.LoopCheck] > 0 then
        local l_loopCheckKeys = _checkKeys[eRedSignCheckType.LoopCheck]
        local l_loopCheckCount = #l_loopCheckKeys
        timeForLoopCheck = timeForLoopCheck + Time.deltaTime
        if timeForLoopCheck > loopCheckAddInterval then
            --当其他所有需要更新的红点都更新完后，才会添加持续更新的红点系统
            if redSignMgr.GetNeedUpdateCount() == 0 then
                for i = 1, l_loopCheckCount do
                    redSignMgr.UpdateRedSign(l_loopCheckKeys[i])
                end
                timeForLoopCheck = 0
            end
        end
    end

    if _checkKeys[eRedSignCheckType.TimeLoopCheck] ~= nil and #_checkKeys[eRedSignCheckType.TimeLoopCheck] > 0 then
        local l_timeCheckKeys = _checkKeys[eRedSignCheckType.TimeLoopCheck]
        local l_timeCheckCount = #l_timeCheckKeys
        timeForTimeCheck = timeForTimeCheck + Time.deltaTime
        if timeForTimeCheck > timeCheckAddInterval then
            for i = 1, l_timeCheckCount do
                local l_key = l_timeCheckKeys[i]
                local l_redTable = TableUtil.GetRedDotCheckTable().GetRowByID(l_key)
                local l_timeCheck = Common.Functions.VectorSequenceToTable(l_redTable.TimeCheck)
                for j, v in ipairs(l_timeCheck) do
                    if v[2] ~= 0 and _nowTime ~= nil and _nowTime >= v[1] * 60 and  _nowTime < v[3] * 60 and (_nowTime - (v[1] * 60)) % v[2] == 0 then
                        redSignMgr.UpdateRedSign(l_key)
                    end
                end
            end
            timeForTimeCheck = 0
        end
    end

end

function _updateTime()

    if (_nowTime == nil) or _nowTime % 15 == 0 then
        local l_timeTable = Common.TimeMgr.GetNowTimeTable()
        _nowTime = l_timeTable.hour * 3600 + l_timeTable.min * 60 + l_timeTable.sec
    else
        _nowTime =  _nowTime + 1
    end

end

function OnInit()

    _timer = Timer.New(_updateTime, 1, -1, true)
    _timer:Start()

    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnPlayerDataSync, RegisterCheckMethods)
    Data.PlayerInfoModel.BASELV:Add(Data.onDataChange, _onBaseLevelChange, ModuleMgr.RedSignCheckMgr)
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:Add(MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate,
        function(_, systemIds)
            OpenSystemRedSignUpdate(systemIds)
        end, ModuleMgr.RedSignCheckMgr)

end

function OpenSystemRedSignUpdate(systemIds)

    if systemIds == nil then
        return
    end
    local l_redSignIds
    for i = 1, #systemIds do
        l_redSignIds = _openSystemKeys[systemIds[i].value]
        if l_redSignIds then
            for j = 1, #l_redSignIds do
                MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(l_redSignIds[j])
            end
        end
    end

end

function OnUninit()

    Data.PlayerInfoModel.BASELV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.RedSignCheckMgr)
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:RemoveObjectAllFunc(
            MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate, ModuleMgr.RedSignCheckMgr)
    if _timer then
        _timer:Stop()
        _timer = nil
    end
    _nowTime = nil

end

function OnLogout()
    _checkKeys = {}
end

return RedSignCheckMgr