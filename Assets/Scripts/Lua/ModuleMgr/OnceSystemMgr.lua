-- 一次管理系统
---@module ModuleMgr.OnceSystemMgr
module("ModuleMgr.OnceSystemMgr", package.seeall)

-- 客户端一次系统，服务器相当于客户端的一个远端的存储
EClientOnceType = {
    ThemeDungeonOpen = {
        Start = 1,
        End = 1000
    },
    ThemeChallengeFirst = {
        Start = 1001,
        End = 1001
    },
    -- 道具是否被看见过
    PotionSettingItem = {
        Start = 1002,
        End = 1002
    },
    -- 第一次打开自动战斗面板
    FightAutoCtrlFirst = {
        Start = 1003,
        End = 1003
    },
    -- 祈福入口是否被打开过
    BlessBtnClicked = {
        Start = 1004,
        End = 1004
    },

    -- 佣兵升级红点
    MercenaryLevelUpRedSign = {
        Start = 1005,
        End = 2005
    },

    -- 佣兵装备红点
    MercenaryEquipRedSign = {
        Start = 2006,
        End = 3006
    },

    -- 佣兵天赋红点
    MercenaryTalentRedSign = {
        Start = 3007,
        End = 3007 + 99999,
    },

    --- 第一次获得一些道具
    --- 这里填的Key是道具ID
    ItemAcquire = {
        Start = 100000000 + 0,
        End = 100000000 + 99999999,
    },

    RedSign = {
        Start = 200000000 + 0,
        End = 200000000 + 99999999,
    }
}

EventDispatcher = EventDispatcher.new()
allClientOnce = {}

function OnClientOnceCommonData(count, valueInt64)
    -- 转化为二进制字符串
    local l_binStr = System.Convert.ToString(valueInt64, 2)
    for i = 0, 63 do
        local l_isOne = i < #l_binStr and l_binStr:sub(#l_binStr-i, #l_binStr-i) == '1'
        allClientOnce[count * 64 + i] = l_isOne
    end

    MgrMgr:GetMgr("GameEventMgr").RaiseEvent(MgrMgr:GetMgr("GameEventMgr").OnOnceDataUpdate, nil)
end

function OnInit()
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_CLIENT_ONCE,
        Callback = OnClientOnceCommonData,
    })

    l_commonData:Init(l_data)
end

function OnLogout()
    allClientOnce = {}
end

function SetOnceState(clientOnceType, id, flag)
    id = id or 0
    local l_key = clientOnceType.Start + id
    if l_key > clientOnceType.End then
        logError("SetOnceState id不在合法范围内!")
        return
    end
    allClientOnce[l_key] = allClientOnce[l_key] or false
    if allClientOnce[l_key] ~= flag then
        allClientOnce[l_key] = flag

        ---@type SetOnceDataArg
        local l_sendInfo = GetProtoBufSendTable("SetOnceDataArg")
        l_sendInfo.key = l_key
        l_sendInfo.flag = flag
        Network.Handler.SendRpc(Network.Define.Rpc.SetOnceData, l_sendInfo)
    end
end

function GetOnceState(clientOnceType, id)
    id = id or 0
    local l_key = clientOnceType.Start + id
    if l_key > clientOnceType.End then
        logError("SetOnceState id不在合法范围内!")
        return
    end
    return not not allClientOnce[l_key]
end

-- 获取同时设置
function GetAndSetState(clientOnceType, id, flag)
    id = id or 0
    local l_oldFlag = GetOnceState(clientOnceType, id)
    if l_oldFlag ~= flag then
        SetOnceState(clientOnceType, id, flag)
    end
    return l_oldFlag
end

------------------------------协议处理

function OnSetOnceData(msg)
    ---@type SetOnceDataRes
    local l_info = ParseProtoBufToTable("SetOnceDataRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    MgrMgr:GetMgr("GameEventMgr").RaiseEvent(MgrMgr:GetMgr("GameEventMgr").OnOnceDataUpdate, nil)
end

return ModuleMgr.OnceSystemMgr