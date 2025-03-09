--==============================--
--@Description:添加具有生命周期的标记  1 本地记录 2 游戏 3 副本
--@Date: 2019/7/3
--@Param: [args]
--@Return:
--==============================--

module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
AddFlagValCommand = class("AddFlagValCommand", super)

local VarType = {
    Localization = 1,
    Game = 2,
    Dungeon = 3,
}

local GameFlagVars = {}
local DungeonFlagVars = {}

function AddFlagValCommand:ctor()

    super.ctor(self)

    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    l_dungeonMgr.EventDispatcher:Add(l_dungeonMgr.ENTER_DUNGEON, function() DungeonFlagVars = {} end, self)
    l_dungeonMgr.EventDispatcher:Add(l_dungeonMgr.EXIT_DUNGEON, function() DungeonFlagVars = {} end, self)
end

function AddFlagValCommand:HandleCommand(command, block, args)
    local flagKey = args[0].Value
    local flagVal = tonumber(args[1].Value)
    local flagType = tonumber(args[2].Value)

    local isAccumulate = false
    if args.Count > 3 then
        isAccumulate = tonumber(args[3].Value) == 1
    end

    if flagType == VarType.Localization then
        if isAccumulate then
            local val = Common.Serialization.LoadData(flagKey, MPlayerInfo.UID:tostring())
            if not Common.Utils.IsEmptyOrNil(val) then
                flagVal = flagVal + tonumber(val)
            end
        end
        Common.Serialization.StoreData(flagKey, flagVal, MPlayerInfo.UID:tostring())
    elseif flagType == VarType.Game then
        if isAccumulate and GameFlagVars[flagKey] then
            GameFlagVars[flagKey] = GameFlagVars[flagKey] + flagVal
        else
            GameFlagVars[flagKey] = flagVal
        end
    elseif flagType == VarType.Dungeon then
        if isAccumulate and DungeonFlagVars[flagKey] then
            DungeonFlagVars[flagKey] = DungeonFlagVars[flagKey] + flagVal
        else
            DungeonFlagVars[flagKey] = flagVal
        end
    end

    command:FinishCommand()
end

function AddFlagValCommand:CheckCommand(argStrArray)
    if argStrArray.Length ~= 3 then
        logError("addflagvar 参数格式错误")
        return false
    end
    return true
end

-- 获取标记变量值
function AddFlagValCommand:GetFlagVal(flagKey, flagType)
    local ret = ""
    if IsEmptyOrNil(flagKey) then return ret end

    flagType = flagType or VarType.Localization
    if flagType == VarType.Localization then
        ret = Common.Serialization.LoadData(flagKey, MPlayerInfo.UID:tostring())
    elseif flagType == VarType.Game then
        ret = GameFlagVars[flagKey]
    elseif flagType == VarType.Dungeon then
        ret = DungeonFlagVars[flagKey]
    end

    return ret or ""
end

return AddFlagValCommand