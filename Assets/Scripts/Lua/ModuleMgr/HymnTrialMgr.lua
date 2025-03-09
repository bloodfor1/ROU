---
--- Created by cmd(TonyChen).
--- DateTime: 2018/6/28 16:48
---
---@module ModuleMgr.HymnTrialMgr
module("ModuleMgr.HymnTrialMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获取当前轮信息事件
ON_GET_CUR_TURN_INFO = "ON_GET_CUR_TURN_INFO"
--获取回合开始事件
ON_ROUND_START = "ON_ROUND_START"
--关闭场景交互新手引导
SceneObjControllerCloseGuideArrowEvent="SceneObjControllerCloseGuideArrowEvent"
--获取战斗开始事件
ON_FIGHT_START = "ON_FIGHT_START"
--获取回合结束事件
ON_ROUND_OVER = "ON_ROUND_OVER"
------------- END 事件相关  -----------------

local l_hymnAwardType = {
    HYMN_BOSS_AWARD = 60001,
    HYMN_ELITE_AWARD = 60002,
    HYMN_SPECIAL_AWARD = 60003,
    HYMN_TREASUREBOX_AWARD = 60004,
}

curRouletteLogData = {} --当前轮的结果
rouletteModelPath = "Prefabs/HymnTrial/HymnRoulette"  --转盘模型路径
isTurning = false  --是否正在旋转
--转盘元素展示的图片UV偏移
elementScale = {0.333333, 0.5}
elementOffset = {
    [8] = {x = 0.666666, y = 0},   -- 水
    [9] = {x = 0.666666, y = 0.5}, -- 风
    [10] = {x = 0, y = 0.5},       -- 地
    [11] = {x = 0.333333, y = 0},  -- 火
    [12] = {x = 0, y = 0},         -- 暗
}

--日志缓存清理
function InitLog()
    isTurning = false
    curRouletteLogData = {
        turnNum = 0,
        playerId = nil,
        innerEventId = 0,
        outerEventId = 0,
        monsterId = {},
        playerName = "",
        eventType = 0,  --事件类型
        runeText = "",  --暂时无用
        eventText = "",  --战斗时信息面板展示的文字 和 符文面板展示的文字
        prompt = "",  --事件提示
        logText = "",  --日志文本
        monsterNum = 0,
        weatherCode = {},  --天气码 包含 时间段 和 天气
        eventEndAngle = {},  --事件转盘最终停止角度 支持多个做随机处理
        numberAngle = 0,  --数量转盘旋转到的角度
        isPraise = false,  --是否需要展示点赞框
    }
end

--断线重连 
function OnReconnected(reconnectData)
    --在圣歌试炼副本中重连时重新请求当前轮信息
    if MPlayerInfo and MPlayerInfo.PlayerDungeonsInfo and MPlayerInfo.PlayerDungeonsInfo.DungeonID > 0 then
        if MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonHymn then
            ReqCurTurnInfo()
        end
    end
end

--登出时初始化相关信息
function OnLogout()
    InitLog()
end

--转到幸运事件时触发点赞
function ShowPraiseForLuckyEvent()
    --被点赞的人不是自己才显示
    if tostring(MPlayerInfo.UID) ~= tostring(curRouletteLogData.playerId) then

        local l_showTxt = StringEx.Format(Lang("PRAISE_FOR_LUCKY_EVENT"),
            curRouletteLogData.playerName, curRouletteLogData.eventText)
        local l_delayTime = MGlobalConfig:GetFloat("PraiseStayTime")

        CommonUI.Dialog.ShowPraiseDlg(tostring(curRouletteLogData.playerId), nil, l_showTxt, l_delayTime)
    end

end

--解析当前轮信息
function GetCurTurnMsgFromInfo(info)
    local l_rouletteLogData = {}
    --当前轮数据获取
    l_rouletteLogData.turnNum = info.round
    l_rouletteLogData.monsterNum = info.monster_num or 0
    --如果是第0轮表示刚开始 后面数据都为空不解析
    if l_rouletteLogData.turnNum == 0 then
        return l_rouletteLogData
    end

    if info.role_id and info.inner_evnet_id and info.outer_event_id and info.monster_id then
        l_rouletteLogData.playerId = info.role_id
        l_rouletteLogData.innerEventId = info.inner_evnet_id
        l_rouletteLogData.outerEventId = info.outer_event_id
        l_rouletteLogData.monsterId = info.monster_id
    else
        logError("服务器传回数据为空  圣歌试炼 ")
        return nil
    end

    local l_innerEventInfo = TableUtil.GetHSRandomEventTable().GetRowByEventID(l_rouletteLogData.innerEventId)
    local l_outerNumberInfo = TableUtil.GetHSMonsterNumTable().GetRowByEventID(l_rouletteLogData.outerEventId)

    if not l_innerEventInfo or not l_outerNumberInfo then
        logError("服务器传回数据有误  圣歌试炼 ")
        return nil
    end

    l_rouletteLogData.eventType = l_innerEventInfo.EventType
    l_rouletteLogData.runeText = l_innerEventInfo.Text
    l_rouletteLogData.eventText = l_innerEventInfo.EventDes
    l_rouletteLogData.prompt = l_innerEventInfo.Prompt
    l_rouletteLogData.logText = l_innerEventInfo.EventRecord
    l_rouletteLogData.weatherCode = l_innerEventInfo.TimeAndWeather
    l_rouletteLogData.eventEndAngle = l_innerEventInfo.TurnTableAngle
    l_rouletteLogData.numberAngle = l_outerNumberInfo.Angle
    l_rouletteLogData.isPraise = l_innerEventInfo.IsPraise

    return l_rouletteLogData
end

-------------------------------其他协议接收后的分支方法-----------------------------------------------
--接收奖励结果 判断展示结果的界面类型
--协议为ItemAwardNtf
--分支于MgrMgr:GetMgr("NoticeMgr").OnItemAwardNtf
function ShowEventAward(info)
    local l_titleArr = {
        [l_hymnAwardType.HYMN_BOSS_AWARD] = "HYMN_EVENT_AWARD_TIP_BOSS",
        [l_hymnAwardType.HYMN_ELITE_AWARD] = "HYMN_EVENT_AWARD_TIP_ELITE",
        [l_hymnAwardType.HYMN_SPECIAL_AWARD] = "HYMN_EVENT_AWARD_TIP_SPECIAL",
        [l_hymnAwardType.HYMN_TREASUREBOX_AWARD] = "HYMN_EVENT_AWARD_TIP_TREASUREBOX",
    }

    if #info.awards ~= 0 then --有内容则展示奖励信息
        for k,v in ipairs(info.awards) do
            if v.reason == nil then
                for i = 1,#v.items do
                    local l_opt = {
                        itemId = v.items[i].item_id,
                        itemOpts = {num=v.items[i].count, icon={size=18, width=1.4}},
                    }
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
                end
            else
                local l_titleKey = l_titleArr[v.reason]
                if l_titleKey then
                    for i = 1,#v.items do
                        local l_opt = {
                            itemId = v.items[i].item_id,
                            itemOpts = {num=v.items[i].count, icon={size=18, width=1.4}},
                            title = Common.Utils.Lang(l_titleKey),--标题
                            adapter = true, --是否要自适应
                        }
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
                    end
                end
            end
        end
    end
end
---------------------------END 其他协议接收后的分支方法-----------------------------------------

--------------------------以下是服务器交互RPC------------------------------------

--请求当前轮信息 退出再进时用
function ReqCurTurnInfo()
    local l_msgId = Network.Define.Rpc.HSQueryRoundInfo
    ---@type HSQueryRoundInfoArg
    local l_sendInfo = GetProtoBufSendTable("HSQueryRoundInfoArg")
    l_sendInfo.role_uuid = tostring(MPlayerInfo.UID)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收请求当前轮信息 退出再进时用
function OnReqCurTurnInfo(msg)
    ---@type HSQueryRoundInfoRes
    local l_info = ParseProtoBufToTable("HSQueryRoundInfoRes", msg)

    if l_info.result == 0 then  --这个result是错误码
        --判断获取的新的轮次信息是否小于原本的当前轮信息 如果小于则表示此数据有误不使用 直接return
        if l_info.info.round < curRouletteLogData.turnNum then
            return
        end
        curRouletteLogData = GetCurTurnMsgFromInfo(l_info.info)
        if curRouletteLogData ~= nil then
            EventDispatcher:Dispatch(ON_GET_CUR_TURN_INFO, l_info.monster_left_num)
        end
    end
end

--场景物件交互返回 暂时写在这里后续有需要请移到公用的地方
function OnEnterSceneWall(msg)
    ---@type EnterSceneWallRes
    local l_info = ParseProtoBufToTable("EnterSceneWallRes", msg)

    if l_info.result ~= 0 then  --这个result是错误码 这里只会返回非法操作 需要自己做区分
        --圣歌试炼相关报错
        if MPlayerInfo.PlayerDungeonsInfo.DungeonType == 7 then
            if MPlayerInfo.PlayerDungeonsInfo.LeftMonster > 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HYMN_FIGHTING_CAN_NOT_USE"))  --战斗中
            elseif isTurning then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HYMN_RUNNING_CAN_NOT_USE"))  --转盘转动中
            elseif curRouletteLogData.turnNum == 3 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HYMN_END_CAN_NOT_USE"))  --副本已结束
            end
        end
    end
end

--拾取BUFF的rpc回调 （请求再cs中进行）
function OnPickBuff(msg)
    ---@type PickUpBuffRes
    local l_info = ParseProtoBufToTable("PickUpBuffRes", msg)

    if l_info.code == 0 then
        --提示获取的BUFF
        local l_row = TableUtil.GetDoodadTable().GetRowByDoodadID(l_info.doodadid)
        if not l_row then
            logError("@chenyang get error doodadid = "..tostring(l_info.doodadid))
            return
        end
        if not string.ro_isEmpty(l_row.PickTips) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_row.PickTips)
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.code))
    end
end
------------------------------RPC  END------------------------------------------


---------------------------以下是服务器推送 PTC-----------------------------------

--每一轮开始的推送(拉杆结果)
function OnOneRoundStart(msg)
    ---@type HSDungeonsInfo
    local l_info = ParseProtoBufToTable("HSDungeonsInfo", msg)
    --设置正在旋转 防止用户关闭转盘界面再开关UI 导致重新显示拉杆提示
    isTurning = true
    --数据解析
    curRouletteLogData = GetCurTurnMsgFromInfo(l_info)
    if curRouletteLogData ~= nil then
        if curRouletteLogData.turnNum == 0 then
            logError("服务器传回数据错误  圣歌试炼 ")
            return
        end
        --展示转盘界面
        UIMgr:ActiveUI(UI.CtrlNames.HymnTrialRoulette)
        EventDispatcher:Dispatch(ON_ROUND_START)

        EventDispatcher:Dispatch(SceneObjControllerCloseGuideArrowEvent)
    end
end

--开始刷怪战斗的推送(强制关闭转盘界面)
function OnStartFight(msg)
    ---@type HSCloseRouletteData
    local l_info = ParseProtoBufToTable("HSCloseRouletteData", msg)
    --推送给UI
    isTurning = false
    UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialRoulette)
    EventDispatcher:Dispatch(ON_FIGHT_START)
end

--每一轮结束的推送
function OnOneRoundOver(msg)
    MPlayerInfo.PlayerDungeonsInfo.LeftMonster = 0
    EventDispatcher:Dispatch(ON_ROUND_OVER)
end

--点赞的推送
function OnPraiseShow(msg)
    ---@type PraiseData
    local l_info = ParseProtoBufToTable("PraiseData", msg)

    --被点赞的人不是自己才显示
    if tostring(MPlayerInfo.UID) ~= tostring(l_info.uuid) then

        local l_showTxt = StringEx.Format(Lang("PRAISE_FOR_CAPTAIN"), l_info.name)
        local l_delayTime = MGlobalConfig:GetFloat("PraiseStayTime")

        CommonUI.Dialog.ShowPraiseDlg(tostring(l_info.uuid), nil, l_showTxt, l_delayTime)
    end
end

------------------------------PTC  END------------------------------------------
