-- 服务器一次管理系统
---@module ModuleMgr.ServerOnceSystemMgr
module("ModuleMgr.ServerOnceSystemMgr", package.seeall)

EServerOnceType = {
    AutoRecallOnBlessOut = 1,       -- 祝福时间消耗完毕自动回城
    AutoRecallOnFive = 2,           -- 每日五点自动回城的勾选项
}

EventDispatcher = EventDispatcher.new()

allServerOnce = {}

function OnServerOnceCommonData(count, valueInt64)
    -- 转化为二进制字符串
    local l_binStr = System.Convert.ToString(valueInt64, 2)
    for i = 0, 63 do
        local l_isOne = i < #l_binStr and l_binStr:sub(#l_binStr-i, #l_binStr-i) == '1'
        allServerOnce[count * 64 + i] = l_isOne
    end
end

function OnInit()
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_SERVER_ONCE,
        Callback = OnServerOnceCommonData,
    })

    l_commonData:Init(l_data)
end

function OnLogout()
    allServerOnce = {}
end

function GetServerOnceState(serverOnceType)
    return not not allServerOnce[serverOnceType]
end


return ModuleMgr.ServerOnceSystemMgr