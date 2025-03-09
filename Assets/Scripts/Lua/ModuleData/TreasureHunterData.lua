--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.TreasureHunterData
module("ModuleData.TreasureHunterData", package.seeall)

--lua model end

--lua functions
function Init()

    ResetAll()
end --func end
--next--
function Logout()

    ResetAll()
end --func end
--next--
--lua functions end

--lua custom scripts
local l_surveyBtnCdStamp = -1
local l_surveyorInfos = {}
local l_chestInfos = {}
local l_selectEntityUid = -1
local l_rewardName = {}

END_UPDATE_CD = "END_UPDATE_CD"
IS_HELP = "IS_HELP"

HelpType = {
    Friend = 1,
    Guild = 2,
}

---@class SurveyHunter_SelectPanelInfo
---@field uid uint64
---@field finish_time uint64
---@field total_time number
---@field total_depth number
---@field current_depth number
---@field current_leftTime number
---@field treasure_award_id number
---@field pos Vec3
---@field scene_line number
---@field role_id int64
---@field role_name string
---@field canHelp boolean
local l_selectPanelInfo = {}


function ResetAll()
    ResetSurveyBtnCdStamp()
    ResetSurveyorInfos()
    ResetChestInfos()
    ResetSelectEntityUid()
    ResetSelectPanelInfo()
    ResetAwardName()
end

function GetSurveyBtnCdStamp()
    return l_surveyBtnCdStamp
end

function SetSurveyBtnCdStamp(stamp)
    if stamp and Common.TimeMgr.GetNowTimestamp() < stamp then
        l_surveyBtnCdStamp = stamp
        return true
    else
        ResetSurveyBtnCdStamp()
        return false
    end
end

function ResetSurveyBtnCdStamp()
    l_surveyBtnCdStamp = -1
end

function GetSurveyorInfos()
    return l_surveyorInfos
end

function ResetSurveyorInfos()
    l_surveyorInfos = {}
end

function GetChestInfos()
    return l_chestInfos
end

function ResetChestInfos()
    l_chestInfos = {}
end

---@param info TreasureChestInfo[]
function AddEntityInfos(info)

    if not info then
        return
    end

    if l_surveyorInfos == nil then
        ResetSurveyorInfos()
    end

    if l_chestInfos == nil then
        ResetChestInfos()
    end

    for k, v in ipairs(info) do
        if v.type == 1 then
            l_chestInfos[v.uid] = v
        else
            l_surveyorInfos[v.uid] = v
        end
    end

end

function GetSelectEntityUid()
    return l_selectEntityUid
end

function SetSelectEntityUid(uid)
    if uid then
        l_selectEntityUid = uid
        l_selectPanelInfo.uid = uid
    else
        ResetSelectEntityUid()
    end
end

function ResetSelectEntityUid()
    l_selectEntityUid = -1
end

function GetSelectPanelInfo()
    return l_selectPanelInfo
end

---@param info GetTreasurePanelInfoRes
function SetSelectPanelInfo(info)
    ResetSelectPanelInfo()
    l_selectPanelInfo.uid = l_selectEntityUid
    l_selectPanelInfo.current_depth = info.current_depth
    l_selectPanelInfo.total_depth = info.total_depth
    l_selectPanelInfo.finish_time = info.finish_time
    l_selectPanelInfo.total_time = info.total_time
    l_selectPanelInfo.treasure_award_id = info.treasure_award_id
    l_selectPanelInfo.pos = info.pos
    l_selectPanelInfo.scene_line = info.scene_line
    l_selectPanelInfo.role_name = info.role_name
    l_selectPanelInfo.role_id = info.role_id
    l_selectPanelInfo.canHelp = not info.is_help
end

function SetEntityPosInfo(pos)
    l_selectPanelInfo.pos = pos
end

function RrefreshCurrentLeftTime(value)
    l_selectPanelInfo.current_leftTime = value
    l_selectPanelInfo.current_depth = value/60
end

function ResetSelectPanelInfo()
    l_selectPanelInfo = {
        uid = -1,
        finish_time = -1,
        total_depth = -1,
        total_time = -1,
        current_depth = -1
    }
end

function ResetAwardName()
    l_rewardName = {}
    local VectorSequenceToTable = Common.Functions.VectorSequenceToTable(MGlobalConfig:GetVectorSequence("TreasurecollectionOtherCollectedAwardID"))
    local rewardName = Common.Functions.VectorSequenceToTable(MGlobalConfig:GetVectorSequence("TreasurecollectionAwardTypeName"))
    for i = 1, #VectorSequenceToTable do
        l_rewardName[tonumber(VectorSequenceToTable[i][2])] = Common.Utils.Lang(rewardName[i][1])
    end
end

function GetAwardName(id)
    return l_rewardName[id]
end

--lua custom scripts end
return ModuleData.TreasureHunterData