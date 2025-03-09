--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.FestivalData", package.seeall)
--lua model end

--lua functions
Festival = {}
FestivalFa = {}
--------测试用假数据
FakeData =
{
    system_id = 8001, actual_time = { second = 1603082000, first = 1602882000 }, tips_atlas_name = '', icon_name_1 = 'UI_Festival_01_BtnImage01.png',
    target = '1=12001', atlas_name = 'Festival_01', button_txt = 'QW', act_times = 3, acitive_text = 'BAOZANGLIREN', endTime = 2000000000,
    id = 1003, atlas_name_four = 'Festival_01', icon_name_3 = 'UI_Festival_01_lihui.png', total_act_times = 0, act_name = 'BZLR', play_time_key = 77309412330,
    sort = 100, act_desc = '', show_type = 0, icon_name_4 = 'UI_Festival_TreasureHunterBG.png', day_times = { [1] = { second = 75600, first = 64800 } },
    award_id = 4600010, icon_name_2 = 'UI_Festival_01_Title.png', activity_form = 1
}
FakeDataA =
{
    system_id = 12001, actual_time = { second = 16031820001, first = 1602882000 }, tips_atlas_name = '', icon_name_1 = 'UI_Festival_01_BtnImage01.png',
    target = '1=12001', atlas_name = 'Festival_01', button_txt = 'QAAAW', act_times = 3, acitive_text = 'BAOZANGLIREN', endTime = 2000000000,
    id = 1007, atlas_name_four = 'Festival_01', icon_name_3 = 'UI_Festival_01_lihui.png', total_act_times = 0, act_name = 'BZLRA', play_time_key = 77309412330,
    sort = 99, act_desc = '', show_type = 0, icon_name_4 = 'UI_Festival_TreasureHunterBG.png', day_times = { [1] = { second = 75600, first = 64800 } },
    award_id = 4600010, icon_name_2 = 'UI_Festival_01_Title.png', activity_form = 1
}
----------------
local l_systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
nowChoose = 0
ActivityForm =
{
    [1] = Lang("TowerDefenseSinglePlayer"),
    [2] = Lang("TowerDefenseDoublePlayer"),
    [3] = Lang("ThreePeopleUp"),
    [4] = Lang("FivePeople"),
    [5] = Lang("NO_TIMES_LIMIT"),
}
ActivityRedSign =
{
    [l_systemMgr.eSystemId.ActivityCheckIn] = {
        [1] = eRedSignKey.ActivityCheckInPoint2,             --最内跳转红点
        [2] = eRedSignKey.ActivityCheckInPoint1,             --左侧template红点
    },

    [l_systemMgr.eSystemId.BingoActivity] = {
        [1] = eRedSignKey.BingoPoint2,             --最内跳转红点
        [2] = eRedSignKey.BingoPoint1,             --左侧template红点
    },
    [l_systemMgr.eSystemId.ActivityNewKing] = {
        [1] = eRedSignKey.NewKingPoint1,
        [2] = eRedSignKey.NewKingPoint2,
    }
}
EOpenType =
{
    OpenSystem = 1,
    URL = 2
}

function Init()

end --func end
--next--
function Logout()

    Festival = {}
    FestivalFa = {}

end --func end
--next--
--lua functions end

--lua custom scripts
function UpdateFatherInfo(info)
    FestivalFa = {
        name = info.act_name,
        atlas = info.atlas_name,
        icon = info.icon_name,
    }
end

function UpdateTestInfo()

    Festival = {}
    table.insert(Festival, FakeData)
    table.insert(Festival, FakeDataA)
    table.sort(Festival, function(a, b) return a.sort < b.sort end)

end

function UpdateInfo(info)

    Festival = {}
    for i = 1, #info do
        info[i].display_data.id = info[i].act_uid
        info[i].display_data.endTime = info[i].display_end_stamp
        info[i].display_data.play_time_key = info[i].today_play_times_key

        info[i].display_data.actType = info[i].act_type
        info[i].display_data.fatherId = info[i].father_id
        info[i].display_data.startTimeStamp = info[i].cur_or_next_act_time.first
        info[i].display_data.endTimeStamp = info[i].cur_or_next_act_time.second
        info[i].display_data.awardInfos = {}
        for j  = 1, #info[i].gift_id do
            table.insert(info[i].display_data.awardInfos, {
                awardId = info[i].gift_id[j].first,
                param = info[i].gift_id[j].second,
                isReceived = false,
            })
        end
        info[i].display_data.delayTime = info[i].delay_time * 3600
        table.insert(Festival, info[i].display_data)
    end
    table.sort(Festival, function(a, b) return a.sort < b.sort end)

end

--将过期活动移除
function UpdateFestival()

    local temp = {}
    for i = 1, #Festival do
        if Festival[i].endTime >= Common.TimeMgr.GetNowTimestamp() then
            table.insert(temp, Festival[i])
        end
    end
    Festival = temp

end


function GetIdByType(type)
    for i = 1, #Festival do
        if Festival[i].actType == type then
            return Festival[i].id
        end
    end
    return 0
end
---@return BackstageActClientData
function GetDataByType(type)
    for i = 1, #Festival do
        if Festival[i].actType == type then
            return Festival[i]
        end
    end
    return nil
end


function GetDataById(actId)
    for i = 1, #Festival do
        if Festival[i].id == actId then
            return Festival[i]
        end
    end
    return nil
end


-- 活动是否预开启
function IsActivityPreStart(actId)
    local l_nowTime = MServerTimeMgr.UtcSeconds_u
    for i = 1, #Festival do
        if Festival[i].id == actId then
            return l_nowTime < Festival[i].startTimeStamp
        end
    end
    return false
end

-- 活动是否进行中
function IsActivityGoing(actId)
    local l_nowTime = MServerTimeMgr.UtcSeconds_u
    for i = 1, #Festival do
        if Festival[i].id == actId then
            return l_nowTime >= Festival[i].startTimeStamp and l_nowTime <= Festival[i].endTimeStamp
        end
    end
    return false
end

-- 活动是否结束
function IsActivityEnd(actId)
    local l_nowTime = MServerTimeMgr.UtcSeconds_u
    for i = 1, #Festival do
        if Festival[i].id == actId then
            return l_nowTime > Festival[i].endTimeStamp
        end
    end
    return true
end

-- 活动是否显示
function IsActivityShowByType(actType)
    local l_nowTime = MServerTimeMgr.UtcSeconds_u
    for i = 1, #Festival do
        if Festival[i].actType == actType then
            return l_nowTime < Festival[i].endTimeStamp + Festival[i].delayTime
        end
    end
    return false
end

--lua custom scripts end
return ModuleData.FestivalData