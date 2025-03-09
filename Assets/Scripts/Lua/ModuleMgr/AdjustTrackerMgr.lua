---@module ModuleMgr.AdjustTrackerMgr
module("ModuleMgr.AdjustTrackerMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
AdjustTrackerIsOn = MDevice.EnableSDKInterface("AdjustTracker")

------------------------------生命周期------------------------------
function OnInit()
end

function Uninit()

end

local baseLevelToEventType = {
    [10] = GameEnum.AdjustTrackerEvent.BaseLv10,
    [20] = GameEnum.AdjustTrackerEvent.BaseLv20,
    [30] = GameEnum.AdjustTrackerEvent.BaseLv30,
    [40] = GameEnum.AdjustTrackerEvent.BaseLv40,
    [50] = GameEnum.AdjustTrackerEvent.BaseLv50,
    [60] = GameEnum.AdjustTrackerEvent.BaseLv60,
    [70] = GameEnum.AdjustTrackerEvent.BaseLv70,
    [80] = GameEnum.AdjustTrackerEvent.BaseLv80,
    [90] = GameEnum.AdjustTrackerEvent.BaseLv90,
}
function BaseLevelEvent(baseLevel)
    if baseLevelToEventType[baseLevel] then
        --logError(baseLevel .. "-" .. baseLevelToEventType[baseLevel])
        TrackEvent(baseLevelToEventType[baseLevel])
    end
end

local jobLevelToEventType = {
    -- 1转
    [1] = {
        [10] = GameEnum.AdjustTrackerEvent.FirstJobLv10,
        [20] = GameEnum.AdjustTrackerEvent.FirstJobLv20,
        [30] = GameEnum.AdjustTrackerEvent.FirstJobLv30,
        [40] = GameEnum.AdjustTrackerEvent.FirstJobLv40,
    },
    -- 2转
    [2] = {
        [10] = GameEnum.AdjustTrackerEvent.SecondJobLv10,
        [20] = GameEnum.AdjustTrackerEvent.SecondJobLv20,
        [30] = GameEnum.AdjustTrackerEvent.SecondJobLv30,
        [40] = GameEnum.AdjustTrackerEvent.SecondJobLv40,
    },
    -- 3转
    [3] = {
        [10] = GameEnum.AdjustTrackerEvent.ThirdJobLv10,
        [20] = GameEnum.AdjustTrackerEvent.ThirdJobLv20,
        [30] = GameEnum.AdjustTrackerEvent.ThirdJobLv30,
        [40] = GameEnum.AdjustTrackerEvent.ThirdJobLv40,
    }
}
function JobLevelEvent(jobLevel)
    local cShowLv,cProNum = Common.CommonUIFunc.GetShowJobLevelAndProByLv(jobLevel, MPlayerInfo.ProfessionId)
    if jobLevelToEventType[cProNum] and jobLevelToEventType[cProNum][cShowLv] then
        --logError(jobLevel .. "-" .. jobLevelToEventType[cProNum][cShowLv])
        TrackEvent(jobLevelToEventType[cProNum][cShowLv])
    end
end

local achievementBadgeLevelToEventType = {
    [3] = GameEnum.AdjustTrackerEvent.AchivementNovice3star,
    [5] = GameEnum.AdjustTrackerEvent.AchivementNovice5star,
    [8] = GameEnum.AdjustTrackerEvent.Achivementpioneer3star,
    [10] = GameEnum.AdjustTrackerEvent.Achivementpioneer5star,
    [13] = GameEnum.AdjustTrackerEvent.Achivementchallenger3star,
    [15] = GameEnum.AdjustTrackerEvent.Achivementchallenger5star,
    [18] = GameEnum.AdjustTrackerEvent.AchivementTraveler3star,
    [21] = GameEnum.AdjustTrackerEvent.AchivementTraveler5star,
    [23] = GameEnum.AdjustTrackerEvent.AchivementAdventurer3star,
    [25] = GameEnum.AdjustTrackerEvent.AchivementAdventurer5star,
}
function AchievementBadgeLevelEvent(badgeLevel)
    if achievementBadgeLevelToEventType[badgeLevel] then
        --logError(badgeLevel .. "-" .. achievementBadgeLevelToEventType[badgeLevel])
        TrackEvent(achievementBadgeLevelToEventType[badgeLevel])
    end
end

function LoginEvent(loginType)
    if loginType == GameEnum.EJoyyouLoginType.Google then
        TrackEvent(GameEnum.AdjustTrackerEvent.GoogleLogin)
    elseif loginType == GameEnum.EJoyyouLoginType.Facebook then
        TrackEvent(GameEnum.AdjustTrackerEvent.FacebookLogin)
    elseif loginType == GameEnum.EJoyyouLoginType.Apple then
        TrackEvent(GameEnum.AdjustTrackerEvent.AppStoreLogin)
    end
end

function PurchaseCompleteEvent(mall_id)
    -- @马哥
    if mall_id == 201 or mall_id == 202 then
        TrackEvent(GameEnum.AdjustTrackerEvent.GeneralStorePurchaseComplete)
    elseif mall_id == 301 then
        TrackEvent(GameEnum.AdjustTrackerEvent.MysteryShopPurchaseComplete)
    end
end

-- adjust数据追踪 看到无视
function TrackEvent(event)
    if AdjustTrackerIsOn then
        MTracker.TrackEvent(CJson.encode({tracker_event = event}))
    end
end

return ModuleMgr.AdjustTrackerMgr