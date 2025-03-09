--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.DeadDlgData", package.seeall)

--lua model end

--lua functions
function Init()
    ResetAll()
    SetCountDownReviveDungeonsType()
end --func end
--next--
function Logout()
    ResetAll()

end --func end
--next--
--lua functions end

--lua custom scripts

DEAD_COOL_TIME_CHANGE = "DEAD_COOL_TIME_CHANGE"
DEAD_HATORID_CHANGE = "DEAD_HATORID_CHANGE"
DEAD_FABIDDEN_REVIVE = "DEAD_FABIDDEN_REVIVE"
CANT_REVIVE_TIPS = {
    CD = "REVIVE_IN_CD",
    NO_TIMES = "REVIVE_NO_TIMES_IN_DUNGEON",
    HATOR = "REVIVE_IN_WAR",
    SCENE_LIMIT = "REVIVE_SCENE_CANT",
}

local _txtKiller = ""
local _hatorId = 0
local _killerName = ""
local _coolDownTime = 0
local _forbiddenRevive = false
local CountDownReviveDungeonsType = {}
local reviveInSituTimes = 0

function SetCountDownReviveDungeonsType()
    local types = MGlobalConfig:GetSequenceOrVectorInt("CountDownReviveDungeonsType")
    for i = 0, types.Length - 1 do
        CountDownReviveDungeonsType[types[i]] = true
    end
end

function CheckIsCountDownReviveDungeonsType(dungeonsType)
    return CountDownReviveDungeonsType[dungeonsType]
end

function GetTxtKiller()
    return _txtKiller
end

function SetTxtKiller(txtKiller)
    if _txtKiller == txtKiller then
        return
    end
    _txtKiller = txtKiller
end

function SetReviveInSituNum(num)
    reviveInSituTimes = num
end

function GetReviveItemNum()
    local row = TableUtil.GetActivitySceneTable().GetRowByID(MScene.SceneID)
    local times = Common.Functions.VectorSequenceToTable(row.ReviveCost)
    for i = 1, #times do
        if times[i][1] <= reviveInSituTimes + 1 and reviveInSituTimes + 1 <= times[i][2] then
            return times[i][3]
        end
    end
    return 0
end

function ReviveInSituTimesMax()
    local row = TableUtil.GetActivitySceneTable().GetRowByID(MScene.SceneID)
    return reviveInSituTimes >= row.ReviveLimit
end

function GetHatorId()
    return _hatorId or 0
end

function SetHatorId(hatorId)
    _hatorId = tonumber(hatorId)
end

function GetKillerName()
    return _killerName or ""
end

function SetKillerName(name)
    _killerName = name
    local l_killerTxt = Common.Utils.Lang("DEAD_DLG_KILLER_UNKNOWN")
    SetTxtKiller(l_killerTxt)
end

function GetCoolDownTime()
    return _coolDownTime or 0
end

function SetCoolDownTime(time)
    _coolDownTime = time
end

function GetForbiddenFlag()
    return _forbiddenRevive
end

function SetForbiddenFlag(flag)
    _forbiddenRevive = flag
end

function ResetAll()
    _txtKiller = ""
    _hatorId = 0
    _killerName = ""
    _coolDownTime = 0
    _forbiddenRevive = false
    CountDownReviveDungeonsType = {}
end

--lua custom scripts end
return ModuleData.DeadDlgData