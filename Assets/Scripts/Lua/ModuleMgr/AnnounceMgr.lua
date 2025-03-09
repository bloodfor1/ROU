module("ModuleMgr.AnnounceMgr", package.seeall)

-- 事件注册
EventDispatcher = EventDispatcher.new()
CheckAnnounceEvent = "CheckAnnounceEvent"

local m_isShow = true
local m_isSend = false

-- 公告类型
AnnouceType = {
    FrontLoading = "1", --前置公告
}

function GetAnnounceData(state)
    -- 构成URL
    local str_sign, str_time, l_url = Common.CommonUIFunc.GetHttpSignAndTimeAndUrl()

    local str_url = l_url .. "/notice"
    --如果正在请求公告 不再重新请求
    if m_isSend then
        return
    end
    m_isSend = true
    -- 发送URL
    -- https://ro-client-api.huanle.com/notice?type=1&language=en&channel_code=1&gateserver_id=2&group_id=59&timestamp={{timestamp}}&sign={{md5sign}}
    local url = StringEx.Format("{0}?type={1}&channel_code={2}&language={3}",
            str_url, AnnouceType.FrontLoading, MoonCommonLib.MPlatformConfigManager.GetLocal().channel, GameEnum.GameLanguage2TechnologyCenter[tostring(MGameContext.CurrentLanguage)])
    MAnnounce.GetAnncounceData(CJson.encode({url = url, timestamp = str_time, sign = str_sign, timeout = 5000}), function(res, str)
        m_isSend = false
        if res == HttpResult.OK then
            log(str)
            local data = CJson.decode(str)
            if UIMgr:IsActiveUI(UI.CtrlNames.Announce) then
                EventDispatcher:Dispatch(CheckAnnounceEvent, state, data)
            else
                UIMgr:ActiveUI(UI.CtrlNames.Announce, { state = state, data = data })
            end
        else
            logError("GetAnncounceData Fail HttpResult = " .. tostring(res) .. " state = " .. state)
        end
    end)

end

function SetIsShow(state)
    m_isShow = state
end

function GetIsShow()
    return m_isShow
end

