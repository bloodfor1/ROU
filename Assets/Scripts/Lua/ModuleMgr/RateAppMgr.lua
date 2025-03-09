--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.RateAppMgr", package.seeall)

--lua model end

local l_isRateDialogShowing = false
local l_isInDungeon = false
local l_lastRateId = nil
local l_lastRateMessage = nil
--lua custom scripts
function OnInit()
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    l_dungeonMgr.EventDispatcher:Add(l_dungeonMgr.EXIT_DUNGEON, function()
        l_isInDungeon = false
    end)
    l_dungeonMgr.EventDispatcher:Add(l_dungeonMgr.ENTER_DUNGEON, function()
        l_isInDungeon = true
    end)
end
function ShowRateDialog(rateId, message)
    --评价窗口
    local l_isRated = IsRated()
    --在副本中则先不弹出
    if l_isInDungeon and not l_isRated then
        l_isRateDialogShowing = true
        l_lastRateId = rateId
        l_lastRateMessage = message
    elseif not l_isRated then
        ActiveRateApp(rateId, message)
        l_isRateDialogShowing = true
        l_lastRateId = rateId
        l_lastRateMessage = message
    end
end

function OnRateDialogClose()
    l_isRateDialogShowing = false
    SetIsRated()
end

function OnEnterScene(sceneId)
    local l_isRated = IsRated()
    if l_isRateDialogShowing and not l_isInDungeon and not l_isRated then
        ActiveRateApp(l_lastRateId, l_lastRateMessage)
    end
end

function ActiveRateApp(rateId, RateMessage)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.RateApp) then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.RateApp, { rowId = rateId, specialMessage = RateMessage })
end

function IsRated()
    return UserDataManager.HasData("IsRated", MPlayerSetting.PLAYER_SETTING_GROUP)
end

function SetIsRated()
    UserDataManager.SetDataFromLua("IsRated", MPlayerSetting.PLAYER_SETTING_GROUP, true)
end


--lua custom scripts end
return ModuleMgr.RateAppMgr