--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.RoleNurturanceData
module("ModuleData.RoleNurturanceData", package.seeall)

--lua model end
LEVEL_UP = "LEVEL_UP"

REFRESH_TYPE = {
    EnterScene = 1,
    LevelUp = 2,
    Death = 3,
    Capra = 4
}

local l_CurrentNeedRows = {}
---@type NurturanceRowData[]
local l_NurturanceData = {}
local l_HaveZeroValue = false
local IsFirstTips = false
local l_NurturanceType = 0
local l_NurturanceIndex = {}
local l_DeathGuideIndex = {}
IsActiveByDeath = false
BtnActive = false

IsNutranceOpen = false
--lua functions
function Init()
    ClearAll()
end --func end
--next--
function Logout()
    ClearAll()
end --func end
--next--
--lua functions end

--lua custom scripts
function GetCurrentNeedRows(lvl)
    l_CurrentNeedRows = {}
    ---@type RoleNurturanceTable[]
    local l_tbl = TableUtil.GetRoleNurturanceTable().GetTable()
    for _, v in pairs(l_tbl) do
        local lvLimits = Common.Functions.SequenceToTable(v.Level)
        if lvl >= lvLimits[1] and lvl < lvLimits[2] then
            table.insert(l_CurrentNeedRows, { RowId = v.Id, RowInfo = v })
        end
    end
    ---@class RoleNurturanceNeedRow[]
    ---@field RowId number
    ---@field RowInfo RoleNurturanceTable
    return l_CurrentNeedRows
end

function GetNurturanceData()
    return l_NurturanceData
end

function ClearNurturanceData()
    l_NurturanceData = {}
end

function AddNurturanceData(data)
    table.insert(l_NurturanceData, data)
end

function SortNurturanceData()
    table.sort(l_NurturanceData, function(a, b)
        return a.SortScore > b.SortScore
    end)
end

function SetHaveZeroValue(flag)
    l_HaveZeroValue = flag
end

function GetHaveZeroValue()
    return l_HaveZeroValue
end

function GetFirstFlag()
    return IsFirstTips
end

function SetFirstFlag(flag)
    IsFirstTips = flag
end

--function SetSortScore(index, sortscore,pre)
--    l_NurturanceData[index].SortScore = sortscore
--    l_NurturanceData[index].pre = pre
--end

function ResetRoleNurturanceIndex()
    l_NurturanceIndex = {}
end

function ResetDeathGuide()
    l_DeathGuideIndex = {}
end

function AddRoleNurturanceIndex(Index)
    table.insert(l_NurturanceIndex, Index)
end

function GetRoleNurturanceIndex()
    return l_NurturanceIndex
end

function AddDeathGuide(index)
    table.insert(l_DeathGuideIndex, index)
end

function GetDeathGuide()
    return l_DeathGuideIndex
end

function GetNurturanceType()
    return l_NurturanceType
end

function GetTypeIndex()
    if IsActiveByDeath then
        return 1
    else
        return 0
    end
end

function SetNurturanceType(type)
    l_NurturanceType = type
end

function ClearAll()
    l_CurrentNeedRows = {}
    l_NurturanceData = {}
    l_NurturanceIndex = {}
    l_DeathGuideIndex = {}
    l_HaveZeroValue = false
    l_NurturanceType = 0
    BtnActive = false
end

--lua custom scripts end
return ModuleData.RoleNurturanceData