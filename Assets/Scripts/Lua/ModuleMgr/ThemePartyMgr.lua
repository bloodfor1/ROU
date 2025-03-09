---@module ModuleMgr.ThemePartyMgr
module("ModuleMgr.ThemePartyMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获取玩家主题舞会信息
ON_GET_THEM_PARTYACTIVITY_INFO = "ON_GET_THEM_PARTYACTIVITY_INFO"
--设置自定义组合事件
ON_SAVE_DANCE_SETUP_INFO = "ON_SAVE_DANCE_SETUP_INFO"
--设置自定义组合失败事件
ON_SAVE_DANCE_SETUP_INFO_FAILED = "ON_SAVE_DANCE_SETUP_INFO_FAILED"
--刷新点赞事件
ON_GET_LAKE = "ON_GET_LAKE"
--获取获奖列表
ON_GET_PRIZE_MEMBER = "ON_GET_PRIZE_MEMBER"
--收到背景音乐变更
ON_GET_THEM_PARTY_MUSIC_CHANGE = "ON_GET_THEM_PARTY_MUSIC_CHANGE"
--收到跳舞正确信息变更
ON_DANCE_ACTION_CHANGE = "ON_DANCE_ACTION_CHANGE"
--收到跳舞正确信息变更
ON_GET_LOTTERY_LEFT_TIME = "ON_GET_LOTTERY_LEFT_TIME"
--结束动画播放事件
ON_FINISH_NUMBER_SCROLLANIM = "ON_FINISH_NUMBER_SCROLLANIM"
--跳舞被打断结束服务器反馈
ON_DANCE_STOPED = "ON_DANCE_STOPED"
------------- END 事件相关  -----------------

l_lakeState = {
    Lake = 1,
    NearBy = 2,
}

l_themePartyClientState = nil --当前舞会状态
l_themePartyEnumClientState = nil --当前舞会的枚举状态
l_totalTime = 0               --当前模块总时间
l_time = 0                    --当前剩余时间
l_lucky_no = 0                --邀请码
l_love_num = 0                --点赞数字
l_themePartyDanceCustomDataInfo = {} --自定义数据 目前只能有5个数据
l_customIsLoop = false        --用户自定义是否循环
l_index = 0                  --当前跳舞跳到了什么位置
l_beforDanceRightIndex = -1  --记录上一次动作跳对了几个
l_wrongDanceShowTime = 1     --跳错了 延迟展示错误按钮时间
l_danceActionLength = 0      --当前跳舞总共长度
l_completeFirstRightDance = false  --是否成功第一次跳完了这一轮动作 用于跳舞进度的显示
l_isClickDanceBtn = false    --是否点击过了 跳舞按钮

l_nearByLeftTime = 0         --记录当前刷新时间
l_nearByLeftRefresh = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartyNearByRefreshTime").Value)      --保存附近的人的刷新时间
l_lakeDataList = {}          --保存向服务器请求的点赞列表
l_nearByDataList = {}        --保存向服务器请求的附近的人列表
l_curToggleState = l_lakeState.Lake
l_isClickRefresh = false     --是否点击了刷新

l_prizeMemberList = {}       --保存获奖列表信息
l_musicIndex = nil           --保存音乐的引用
l_nowMusicDuration = 0       --保存当前音乐的播放进度
l_musicPlayNumber = 0        --保存当前音乐播放到了第几首
l_musicTotalNumber = 4       --保存正常舞会一共需要多少歌曲
l_themePartySceneId = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartySceneId").Value) --保存场景Id

l_mainUiSceneId = 1          --主UI的UIId
l_danceUiId = 20             --跳舞UI的UIId
l_danceActionTb = nil        --保存舞蹈需要跳对几个的数据
l_danceMaxActionNum = -1     --最大跳对舞蹈个个数 用于界面显示

l_maxSize = 6                --Slot的最大值
l_animationTime = 3                                                                                            --动画基础时间
l_oneItemDelayTime = 1                                                                                         --每一个格子的DelayTime
l_animationTotalTime = l_animationTime + l_oneItemDelayTime * (l_maxSize - 1)                                      --动画总时间 需要和配置同步
l_titalCountDownTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartyLotteryCountdown").Value) + l_animationTotalTime --倒计时提前总时间
l_countDownTime = l_titalCountDownTime - l_animationTime - l_oneItemDelayTime * l_maxSize
l_customMaxSize = 5   --自定义Slot的大小

l_nowLotteryRankTitle = nil --保存当前揭晓几等奖
l_nowLotteryIsShow = false --几等奖的奖励显示是否显示过了
l_groupId = 0 --保存当前曲目的跳舞GriupId
l_showGroupIdTips = "" --保存Tips显示的内容

----未开始抽奖的时候上方的倒计时参数
l_countDownTotalNum = 0  --总倒计时时间
l_nowCount = 0 --当前走了多少时间
l_countDownTxt = ""
l_countFinFun = nil
l_showDanceGroupListTime = 90 --显示跳舞序列的倒计时的剩余时间 总时间150s 60s后显示提示 所以为90
l_musicTotalTime = "02:30"

--进入抽奖模块后右侧的倒计时显示
l_lotteryPredictLeftTime = 0
l_lotteryPredictType = nil
l_lotteryKeepTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartyLotteryKeepTime").Value) --保留时间

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    MgrMgr:GetMgr("ThemePartyMgr").GetThemePartyActivityInfo()
end

--Update
function OnUpdate()
    --如果倒计时没有结束 但是 界面被关掉了 那么再次打开
    if l_nowCount < l_countDownTotalNum and not UIMgr:GetUI("TimeCountDown") then
        if l_themePartySceneId == tonumber(MScene.SceneID) then
            UIMgr:ActiveUI(UI.CtrlNames.TimeCountDown, function(ctrl)
                ctrl:ShowTimeCountDown(l_countDownTxt, l_countDownTotalNum - l_nowCount, l_countFinFun)
            end)
        else
            l_countDownTotalNum = 0
            l_nowCount = 0
            l_countDownTxt = ""
            l_countFinFun = nil
        end
    end

    if l_nearByLeftTime > 0 then
        l_nearByLeftTime = l_nearByLeftTime - Time.deltaTime
    else
        l_nearByLeftTime = 0
    end
end

--收到初始化跳舞信息数据服务器数据
function OnReconnected(reconnectData)
    --短线重连 重新请求一波基础信息
    if l_themePartySceneId == tonumber(MScene.SceneID) then
        Timer.New(function()
            MgrMgr:GetMgr("ThemePartyMgr").GetThemePartyActivityInfo()
        end, 0.01):Start()
    end
    if reconnectData and reconnectData.game_role_info then
        SetCustomDanceActionInfo(reconnectData.game_role_info.dance_info)
    end
end

--收到初始化跳舞信息数据服务器数据
function OnLuaDoEnterScene(roleAllData)
    l_isClickDanceBtn = false
    if roleAllData and roleAllData.game_role_info then
        SetCustomDanceActionInfo(roleAllData.game_role_info.dance_info)
    end
end

function OnEnterScene(sceneId)
    if l_themePartySceneId == sceneId and l_themePartyEnumClientState
            and l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance then
        if l_musicIndex == nil then
            return
        end
        local newIndex = GetDanceBGMIndex(l_musicIndex)
        if newIndex == nil then
            return
        end
        local l_row = TableUtil.GetThemePartyBGMTable().GetRowById(newIndex, true)
        if l_row == nil then
            return
        end
        MAudioMgr:PlayBGM(l_row.BGMEvent)
    end

    if l_themePartySceneId == sceneId and MEntityMgr.PlayerEntity.IsDancing then
        l_isClickDanceBtn = true
    end

    --请求基础信息
    if l_themePartySceneId == sceneId then
        MgrMgr:GetMgr("ThemePartyMgr").GetThemePartyActivityInfo()
    end

    MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
end

--获取主题派对邀请函
function GetThemePartyInvitation(...)
    local l_msgId = Network.Define.Rpc.GetThemePartyInvitation
    ---@type GetThemePartyInvitationArg
    local l_sendInfo = GetProtoBufSendTable("GetThemePartyInvitationArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器反馈获取主题派对邀请函
function OnGetThemePartyInvitation(msg)
    ---@type GetThemePartyInvitationRes
    local l_info = ParseProtoBufToTable("GetThemePartyInvitationRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_lucky_no = l_info.lucky_no
        UIMgr:ActiveUI(UI.CtrlNames.PartyInvitation)
    end
end

--获取主题派对的基本信息
function GetThemePartyActivityInfo(...)
    local l_msgId = Network.Define.Rpc.GetThemePartyActivityInfo
    ---@type GetThemePartyActivityInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetThemePartyActivityInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器反馈获取主题派对的基本信息
function OnGetThemePartyActivityInfo(msg)
    ---@type GetThemePartyActivityInfoRes
    local l_info = ParseProtoBufToTable("GetThemePartyActivityInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        OnUIChange(l_info.current_state)
        l_themePartyEnumClientState = l_info.current_state
        l_themePartyClientState = SetStateStrByState(l_info.current_state)
        l_totalTime = l_info.time
        l_time = Common.TimeMgr.GetNowTimestamp() + l_info.remain_time
        l_lucky_no = l_info.lucky_no
        l_love_num = l_info.love_num
        EventDispatcher:Dispatch(ON_GET_THEM_PARTYACTIVITY_INFO)
        MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
    end
end

function OnUIChange(state)
    if l_themePartySceneId == tonumber(MScene.SceneID) then
        if state == ThemePartyClientState.kPartyStateReady or
                state == ThemePartyClientState.kPartyStateDance or
                state == ThemePartyClientState.kPartyStateWarmmingUp or
                state == ThemePartyClientState.kPartyStateLottery then
            MgrMgr:GetMgr("SceneEnterMgr").ResetSceneUIWithId(l_danceUiId)
        else
            MgrMgr:GetMgr("SceneEnterMgr").ResetSceneUIWithId(l_mainUiSceneId, { UI.CtrlNames.HorseLamp })
        end
    end
end

function SetStateStrByState(state)

    if state == nil or state == ThemePartyClientState.kPartyStateNone then
        return Lang("K_PartyStateNone")
    end
    if state == ThemePartyClientState.kPartyStateReady then
        return Lang("K_PartyStateReady")
    end
    if state == ThemePartyClientState.kPartyStateWarmmingUp then
        return Lang("K_PartyStateWarmmingUp")
    end
    if state == ThemePartyClientState.kPartyStateDance then
        return Lang("K_PartyStateDance")
    end
    if state == ThemePartyClientState.kPartyStateLottery then
        RequestLotteryDrawInfo() --进入抽奖状态 请求剩余时间信息
        return Lang("K_PartyStateLottery")
    end
    if state == ThemePartyClientState.kPartyStateKick then
        return "kPartyStateKick"
    end

    return "NIL STATE @XH"
end

function GetPanelShowTitle()
    local state = l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance
    if state then
        return l_themePartyClientState .. "(" .. l_musicPlayNumber .. "/" .. l_musicTotalNumber .. ")" or Lang("MAIN_PARTY_NAME")
    else
        return l_themePartyClientState or Lang("MAIN_PARTY_NAME")
    end
end

--收到跳舞状态的同步
function OnDanceActionNtf(msg)
    ---@type DanceActionInfo
    local l_info = ParseProtoBufToTable("DanceActionInfo", msg)
    SetDanceActionState(l_info)
end

--之傲返回的 设置跳舞状态的逻辑
function SetDanceActionState(danceActionInfo)
    if danceActionInfo.is_stop then
        EventDispatcher:Dispatch(ON_DANCE_STOPED)
        l_isClickDanceBtn = false
    end

    --通过歌曲剩余时间 来判定切歌了 
    local l_decNumber = (l_nowMusicDuration - Common.TimeMgr.GetNowTimestamp())
    if l_decNumber == 0 then
        l_isClickDanceBtn = false
    end

    if l_isClickDanceBtn then
        --如果服务器反馈跳舞正确的记录的个数=0 则说明跳错了
        if danceActionInfo.index == 0 then
            l_beforDanceRightIndex = l_index
        end
        l_isClickDanceBtn = false
    else
        l_beforDanceRightIndex = -1
    end

    l_index = danceActionInfo.index
    l_danceActionLength = danceActionInfo.length
    EventDispatcher:Dispatch(ON_DANCE_ACTION_CHANGE)
    --logError(l_index,l_danceActionLength)
end

--重置设置跳舞状态的标志位 这三个参数用于 跳舞之后 设置界面的正确和失败的显示
function ResetDanceActionFlags()
    l_index = 0                 --记录服务器返回的跳舞跳对的个数
    l_beforDanceRightIndex = -1 --用来记录上次跳舞，跳对的正确个数
    --l_isClickDanceBtn = false   --用来记录是否点击了跳舞按钮 会在跳舞失败 本轮全部正确后重置
end

--设置信息的逻辑
function SetCustomDanceActionInfo(danceActionInfo)
    l_themePartyDanceCustomDataInfo = {}--danceActionInfo.loop_action_list
    for i = 1, l_customMaxSize do
        if danceActionInfo.loop_action_list[i] == nil or danceActionInfo.loop_action_list[i].value == nil then
            l_themePartyDanceCustomDataInfo[i] = 0
        else
            l_themePartyDanceCustomDataInfo[i] = danceActionInfo.loop_action_list[i].value
        end
    end
    SetDanceActionState(danceActionInfo)
    --一些信息的设置
    local totalMusicTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("DanceBgmLastTime").Value)
    l_customIsLoop = danceActionInfo.is_loop
    l_musicIndex = danceActionInfo.bgm_index
    l_nowMusicDuration = Common.TimeMgr.GetNowTimestamp() + (totalMusicTime - danceActionInfo.bgm_duration)
    l_musicPlayNumber = danceActionInfo.nth_bgm
    l_groupId = SetGroupIdex(danceActionInfo.dance_action_group_index)
end

function GetDanceBGMIndex(beforIndex)
    local l_data = TableUtil.GetDanceBGMTable().GetRowById(tonumber(beforIndex), true)
    return l_data and l_data.BGMId or nil
end

function IsDanceCustomDataInfoListEmpty(...)
    for k, v in pairs(l_themePartyDanceCustomDataInfo) do
        if v ~= 0 then
            return false
        end
    end
    return true
end

function GetTempPartyDanceCustomDataInfo()
    local tempTable = {}
    for i = 1, #l_themePartyDanceCustomDataInfo do
        tempTable[i] = l_themePartyDanceCustomDataInfo[i]
    end
    return tempTable
end

function EnterToThemePartyScene()
    --[[
    if l_themePartyEnumClientState == nil or l_themePartyEnumClientState == PbcMgr.get_enumc_unclassified_pb().kPartyStateNone then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_INTO_DANCEPARTY"))
        return
    end
    ]]--
    local l_themePartySceneId = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartySceneId").Value)
    if l_themePartySceneId ~= tonumber(MScene.SceneID) then
        --MgrMgr:GetMgr("SceneEnterMgr").RequestEnterScene(l_themePartySceneId)
        MTransferMgr:GotoScene(l_themePartySceneId)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_IN_THEMEPARTY"))
    end
end

--服务器同步主题舞会的状态和剩余时间信息
function OnThemePartyStateNtf(msg)
    ---@type ThemePartyStateData
    local l_info = ParseProtoBufToTable("ThemePartyStateData", msg)
    OnUIChange(l_info.current_state)
    --进入抽奖阶段 切回原来场景的背景音乐
    if l_info.current_state == ThemePartyClientState.kPartyStateLottery then
        ResumePlayBGM()
    end
    l_themePartyEnumClientState = l_info.current_state
    l_themePartyClientState = SetStateStrByState(l_info.current_state)
    l_time = Common.TimeMgr.GetNowTimestamp() + l_info.remain_time
    l_completeFirstRightDance = not l_info.current_state == ThemePartyClientState.kPartyStateDance
    EventDispatcher:Dispatch(ON_GET_THEM_PARTYACTIVITY_INFO)

    --开关选择箭矢
    MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
end

--请求剩余时间抽奖时间
function RequestLotteryDrawInfo()
    local l_msgId = Network.Define.Rpc.RequestLotteryDrawInfo
    ---@type RequestLotteryDrawInfoArg
    local l_sendInfo = GetProtoBufSendTable("RequestLotteryDrawInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--请求剩余时间抽奖时间反馈
function OnRequestLotteryDrawInfo(msg)
    ---@type RequestLotteryDrawInfoRes
    local l_info = ParseProtoBufToTable("RequestLotteryDrawInfoRes", msg)
    if l_info.error_code ~= 0 then
    else
        l_lotteryPredictLeftTime = Common.TimeMgr.GetNowTimestamp() + tonumber(l_info.rest_time / 1000) + l_countDownTime + 2 --为什么加2 让时间尽可能匹配
        l_lotteryPredictType = l_info.type == nil and ThemePartyLotteryType.kLotteryTypeThirdPrize or l_info.type
        EventDispatcher:Dispatch(ON_GET_LOTTERY_LEFT_TIME)
    end
end
------------------------------------点赞相关处理-------------------
--点赞
function IsShowLakeBtn()
    if l_themePartyEnumClientState == nil or l_themePartyEnumClientState == ThemePartyClientState.kPartyStateNone then
        return false
    end
    local l_themePartySceneId = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("PartySceneId").Value)
    if l_themePartySceneId ~= tonumber(MScene.SceneID) then
        return false
    end
    return true
end

function ThemePartySendLove(uid)
    local l_msgId = Network.Define.Rpc.ThemePartySendLove
    ---@type ThemePartySendLoveArg
    local l_sendInfo = GetProtoBufSendTable("ThemePartySendLoveArg")
    l_sendInfo.to_uid = tostring(uid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器反馈点赞
function OnThemePartySendLove(msg)
    ---@type ThemePartySendLoveRes
    local l_info = ParseProtoBufToTable("ThemePartySendLoveRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_SUCCESS"))--给我点赞了
end

--服务器同步主题舞会点赞相关
function OnThemePartyLoveNtf(msg)
    ---@type ThemePartyLoveNtfData
    local l_info = ParseProtoBufToTable("ThemePartyLoveNtfData", msg)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_FOR_ME", l_info.from_name))--给我点赞了
    l_love_num = l_info.love_num
    EventDispatcher:Dispatch(ON_GET_THEM_PARTYACTIVITY_INFO)
end

--获取点赞列表
function ThemePartyGetLoveInfo()
    local l_msgId = Network.Define.Rpc.ThemePartyGetLoveInfo
    ---@type ThemePartyGetLoveInfoArg
    local l_sendInfo = GetProtoBufSendTable("ThemePartyGetLoveInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器反馈获取点赞列表
function OnThemePartyGetLoveInfo(msg)
    ---@type ThemePartyGetLoveInfoRes
    local l_info = ParseProtoBufToTable("ThemePartyGetLoveInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_lakeDataList = l_info.member_list or {}
        EventDispatcher:Dispatch(ON_GET_LAKE)
    end
end

--获取周边的人的信息
function ThemePartyGetNearbyPerson(isRefresh)
    if l_nearByLeftTime > 0 and not isRefresh then
        EventDispatcher:Dispatch(ON_GET_LAKE)
        return
    end
    if l_nearByLeftTime > 0 and isRefresh then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DO_NOT_REFRESH", math.ceil(l_nearByLeftTime)))
        return
    end
    local l_msgId = Network.Define.Rpc.ThemePartyGetNearbyPerson
    ---@type ThemePartyGetLoveInfoArg
    local l_sendInfo = GetProtoBufSendTable("ThemePartyGetLoveInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    l_isClickRefresh = isRefresh
end

function OnThemePartyGetNearbyPerson(msg)
    ---@type ThemePartyGetLoveInfoRes
    local l_info = ParseProtoBufToTable("ThemePartyGetLoveInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_nearByDataList = l_info.member_list or {}
        if l_isClickRefresh then
            l_nearByLeftTime = l_nearByLeftRefresh
        end
        table.sort(l_nearByDataList, function(a, b)
            return a.outlook.fashion_count > b.outlook.fashion_count
        end)
        EventDispatcher:Dispatch(ON_GET_LAKE)
    end
end

------------------------------------点赞相关处理-------------------

--服务器同步抽奖
function OnThemePartyLotteryDrawNtf(msg)
    ---@type ThemePartyLotteryDrawData
    local l_info = ParseProtoBufToTable("ThemePartyLotteryDrawData", msg)
    if l_info.lottery_type == nil then
        l_info.lottery_type = ThemePartyLotteryType.kLotteryTypeThirdPrize
    end
    ShowGetRewardPanel(l_info)
end

function ShowGetRewardPanel(l_info)

    local infotableData, awardtableData, rankNum, rankTitle = GetPrizeTableDataByType(l_info.lottery_type)

    local activeFunc = function()
        UIMgr:ActiveUI(UI.CtrlNames.PartyLottery, function(ctrl)
            ctrl:CreateLotteryTemplent(rankTitle, l_info.lucky_numbers, rankNum)
        end)
    end
    local activeLuckyLottery = function()
        local l_finLuckyNum = nil
        for i = 1, #l_info.lucky_numbers do
            l_finLuckyNum = l_info.lucky_numbers[i].value
        end
        UIMgr:ActiveUI(UI.CtrlNames.PartyLucky, function(ctrl)
            ctrl:ShowPanelByData(rankTitle, l_finLuckyNum, l_info.group_members)
        end)
    end

    --倒计时方法
    local countDownFunc = function(countText, totalTime, finFunc)
        if l_themePartySceneId == tonumber(MScene.SceneID) then
            UIMgr:ActiveUI(UI.CtrlNames.TimeCountDown, function(ctrl)
                ctrl:ShowTimeCountDown(countText, totalTime, finFunc)
            end)
        end
    end

    l_nowLotteryRankTitle = rankTitle
    l_nowLotteryIsShow = false

    --前三名处理
    if l_info.lottery_type == ThemePartyLotteryType.kLotteryTypeFirstPrize
            or l_info.lottery_type == ThemePartyLotteryType.kLotteryTypeSecondPrize
            or l_info.lottery_type == ThemePartyLotteryType.kLotteryTypeThirdPrize then
        local text = Lang("SHOW_GETLOTTERY_COUNT_DOWNTEXT", "{0}", rankTitle)
        --logError("l_countDownTime  "..l_countDownTime)
        countDownFunc(text, l_countDownTime, activeFunc)
    end
    --幸运奖处理
    if l_info.lottery_type == ThemePartyLotteryType.kLotteryTypeLuckyPrize then
        local text = Lang("SHOW_GETLOTTERY_COUNT_DOWNTEXT", "{0}", rankTitle)
        countDownFunc(text, l_countDownTime, activeLuckyLottery)
        return
    end
end

--外部接口 打开幸运之星界面
function OpenPartyLuckStar()
    local l_action = function(memberData)
        if memberData then
            local luckyStarNum = 0
            for key, value in pairs(memberData) do
                luckyStarNum = luckyStarNum + #value.members
            end
            if luckyStarNum > 0 then
                UIMgr:ActiveUI(UI.CtrlNames.PartyLuckStar)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DELEGATE_EMBLEM_NO_LUCKY_STAR"))
            end
        end
    end
    ThemePartyGetPrizeMember(l_action)
end

--获取排行榜列表
function ThemePartyGetPrizeMember(onGetFunc)
    local l_msgId = Network.Define.Rpc.ThemePartyGetPrizeMember
    ---@type ThemePartyGetPrizeMemberArg
    local l_sendInfo = GetProtoBufSendTable("ThemePartyGetPrizeMemberArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, onGetFunc)
end

--服务器获取排行榜列表
function OnThemePartyGetPrizeMember(msg, _, onGetFunc)
    ---@type ThemePartyGetPrizeMemberRes
    local l_info = ParseProtoBufToTable("ThemePartyGetPrizeMemberRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        ReSetPrizeMemberList(l_info.lottery_type_members or {})
        EventDispatcher:Dispatch(ON_GET_PRIZE_MEMBER)
        if onGetFunc then
            onGetFunc(l_info.lottery_type_members)
        end
    end
end

--对服务器传过来的数据进行重置
function ReSetPrizeMemberList(prizeList)
    --构造新的数据结构 插入到列表中
    local addNewDataToList = function(lottery_type, lottery_rank, is_create, is_createnooneGet, member, lucky_no, maxPeopleGet, startTime, lable, awardInfo)
        local oneData = {}
        oneData.lottery_type = lottery_type
        oneData.lottery_rank = lottery_rank
        oneData.is_create = is_create
        oneData.is_createnooneGet = is_createnooneGet
        oneData.member = member
        oneData.lucky_no = lucky_no
        oneData.maxPeopleGet = tonumber(maxPeopleGet) --最多获奖人数
        oneData.startTime = startTime
        oneData.lable = lable
        oneData.awardInfo = awardInfo
        table.insert(l_prizeMemberList, oneData)
    end

    l_prizeMemberList = {}
    for i, v in ipairs(prizeList) do
        --小红潜规则 如果为nil 则是三等奖
        if v.lottery_type == nil then
            v.lottery_type = ThemePartyLotteryType.kLotteryTypeThirdPrize
        end
        --logError(v.lottery_type, tostring(v.is_create))
        local infotableData, awardtableData, rankNum = GetPrizeTableDataByType(v.lottery_type)
        if v.is_create then
            --如果已经揭晓 取服务器数据  已经揭晓 存在有人获得 和 没人获得两种情况
            for i = 1, tonumber(infotableData[1]) do
                local membersData = v.members[i]
                addNewDataToList(v.lottery_type,
                        rankNum,
                        v.is_create,
                        membersData == nil, --已经产生但是没人领取
                        membersData and membersData.member or nil,
                        membersData and membersData.lucky_no or 0,
                        tonumber(infotableData[1]),
                        string.sub(infotableData[2], 1, 2) .. ":" .. string.sub(infotableData[2], 3, 4),
                        infotableData[3],
                        awardtableData[1])
            end
        else
            for i = 1, tonumber(infotableData[1]) do
                addNewDataToList(v.lottery_type,
                        rankNum,
                        v.is_create,
                        false,
                        nil,
                        0,
                        tonumber(infotableData[1]),
                        string.sub(infotableData[2], 1, 2) .. ":" .. string.sub(infotableData[2], 3, 4),
                        infotableData[3],
                        awardtableData[1])
            end
        end
    end
    SortTablePrizeMemberList()
end

function SortTablePrizeMemberList()
    table.sort(l_prizeMemberList, function(x, y)
        if x.lottery_rank < y.lottery_rank then
            return true
        end
        return false
    end)
end

function GetPrizeTableDataByType(lottery_type)
    local tableData = nil
    local tableAwardData = nil
    local returnTableData = nil
    local returntableAwardData = {}
    local rankNum = 0
    local showRankPanelTitle = ""
    if lottery_type == ThemePartyLotteryType.kLotteryTypeFirstPrize then
        tableData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyFirstPrizeInfo").Value
        tableAwardData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyFirstPrizeAward").Value
        rankNum = 1
        showRankPanelTitle = Lang("DANCE_FIRST")
    end
    if lottery_type == ThemePartyLotteryType.kLotteryTypeSecondPrize then
        tableData = TableUtil.GetThemePartyTable().GetRowBySetting("PartySecondPrizeInfo").Value
        tableAwardData = TableUtil.GetThemePartyTable().GetRowBySetting("PartySecondPrizeAward").Value
        rankNum = 2
        showRankPanelTitle = Lang("DANCE_SECOND")
    end
    if lottery_type == ThemePartyLotteryType.kLotteryTypeThirdPrize then
        tableData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyThirdPrizeInfo").Value
        tableAwardData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyThirdPrizeAward").Value
        rankNum = 3
        showRankPanelTitle = Lang("DANCE_THIRD")
    end
    if lottery_type == ThemePartyLotteryType.kLotteryTypeLuckyPrize then
        tableData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyLuckyPrizeInfo").Value
        tableAwardData = TableUtil.GetThemePartyTable().GetRowBySetting("PartyLuckyPrizeAward").Value
        rankNum = 0
        showRankPanelTitle = Lang("DANCE_LUCKY")
    end

    returnTableData = string.ro_split(tableData, '|')
    returnTableData[3] = Lang(returnTableData[3])
    local tempAward = string.ro_split(tableAwardData, '|')
    for i = 1, #tempAward do
        table.insert(returntableAwardData, string.ro_split(tempAward[i], '='))
    end
    return returnTableData, returntableAwardData, rankNum, showRankPanelTitle
end

----------------------之傲的协议
--保存自定义舞蹈序列 SaveData是一个简单的table{0,0,0,0,0}
function SetLoopDanceGroup(saveData, isLoop)
    local l_msgId = Network.Define.Rpc.SetLoopDanceGroup
    ---@type DanceGroupInfo
    local l_sendInfo = GetProtoBufSendTable("DanceGroupInfo")
    if saveData == nil then
        saveData = GetTempPartyDanceCustomDataInfo()
    end
    for i = 1, #saveData do
        local cData = l_sendInfo.action_list:add()
        cData.value = saveData[i]
    end
    l_sendInfo.is_loop = isLoop
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器返回保存自定义舞蹈序列
function OnSetLoopDanceGroup(msg)
    ---@type SetLoopDanceRes
    local l_info = ParseProtoBufToTable("SetLoopDanceRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        EventDispatcher:Dispatch(ON_SAVE_DANCE_SETUP_INFO_FAILED)
    else
        --设置序列
        l_themePartyDanceCustomDataInfo = {}
        for i = 1, l_customMaxSize do
            if l_info.loop_info.action_list[i] == nil or l_info.loop_info.action_list[i].value == nil then
                l_themePartyDanceCustomDataInfo[i] = 0
            else
                l_themePartyDanceCustomDataInfo[i] = l_info.loop_info.action_list[i].value
            end
        end
        l_customIsLoop = l_info.loop_info.is_loop
        EventDispatcher:Dispatch(ON_SAVE_DANCE_SETUP_INFO)
    end
end

--发起播放舞蹈动作的请求
function DoDanceReq(danceId)
    if danceId then
        MTransferMgr:Interrupt()
        MEntityMgr.PlayerEntity:UpdateMove()

        local l_msgId = Network.Define.Ptc.DanceReq
        ---@type DanceArgs
        local l_sendInfo = GetProtoBufSendTable("DanceArgs")
        l_sendInfo.dance_id = danceId
        if l_themePartyEnumClientState == ThemePartyClientState.kPartyStateDance then
            l_isClickDanceBtn = true
        end
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end
end

function OnSwichSceneBgmNtf(msg)
    local totalMusicTime = tonumber(TableUtil.GetThemePartyTable().GetRowBySetting("DanceBgmLastTime").Value)
    ---@type SwichSceneBGMData
    local l_info = ParseProtoBufToTable("SwichSceneBGMData", msg)
    if l_musicIndex ~= l_info.bgm_index then
        l_completeFirstRightDance = false
    end
    l_isClickDanceBtn = false
    l_musicIndex = l_info.bgm_index
    l_nowMusicDuration = Common.TimeMgr.GetNowTimestamp() + (totalMusicTime - l_info.duration)
    l_musicPlayNumber = l_info.nth_bgm
    SetGroupIdex(l_info.dance_action_group_id)
    --logError("l_nowMusicDuration  "..l_nowMusicDuration,l_info.bgm_index,l_musicPlayNumber,l_groupId)
    EventDispatcher:Dispatch(ON_GET_THEM_PARTY_MUSIC_CHANGE)
    EventDispatcher:Dispatch(ON_DANCE_ACTION_CHANGE)
end

function SetGroupIdex(trgetGroupId)
    --logError("trgetGroupId   "..trgetGroupId)
    l_groupId = trgetGroupId
    l_showGroupIdTips = ""
    if l_groupId == nil then
        return
    end
    local danceGriupTableData = TableUtil.GetDanceActionGroupTable().GetRowById(l_groupId, true)
    if danceGriupTableData then
        local l_data = Common.Functions.VectorToTable(danceGriupTableData.AnimationTableId)
        local l_str = Lang("FINISH_DANCE_ACTION")
        local l_strBack = ""
        for i = 1, table.maxn(l_data) do
            l_strBack = l_strBack .. l_data[i] .. (i == table.maxn(l_data) and "" or "-")
        end
        l_showGroupIdTips = l_str .. l_strBack
    end
end
----------------------之傲的协议

function ResumePlayBGM(...)
    local l_audioPath = "BGM/" .. TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).BGM
    MAudioMgr:PlayBGM(l_audioPath)
end

-------------------------------道具信息变更提示---------------------------------

---@param updateItemList ItemUpdateData[]
function _onItemUpdate(updateItemList)
    if nil == updateItemList then
        logError("[ThemePartyMgr] invalid param")
        return
    end

    for i = 1, #updateItemList do
        local singleUpdateData = updateItemList[i]
        local singleReason = singleUpdateData.Reason
        if ItemChangeReason.ITEM_REASON_THEME_PARTY_EXP == singleReason then
            if nil ~= singleUpdateData.NewItem then
                if GameEnum.l_virProp.jobExp == singleUpdateData.NewItem.TID or GameEnum.l_virProp.exp == singleUpdateData.NewItem.TID then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GET_THEME_PARTYEXP"))
                    return
                end
            end
            --舞会幸运之星
        elseif ItemChangeReason.ITEM_REASON_THEME_PARTY_LOTTERY == singleReason then
            if l_nowLotteryRankTitle and not l_nowLotteryIsShow then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GET_THEMEPARTY_REWARD", l_nowLotteryRankTitle))
                l_nowLotteryIsShow = true
            end

            if nil ~= singleUpdateData.NewItem then
                _showSpecialTipsOnGain(
                        Lang("DANCE_LUCKY_STAR"),
                        Lang("DANCE_LUCKY_STAR_GET", l_nowLotteryRankTitle),
                        Lang("BTN_SHARE"),
                        Lang("DLG_BTN_YES"),
                        _onGainLottery,
                        _defaultFunc,
                        singleUpdateData.NewItem
                )
            end
            --舞娘的特殊奖励
        elseif ItemChangeReason.ITEM_REASON_THEME_PARTY_DANCE == singleReason then
            if nil ~= singleUpdateData.NewItem then
                _showSpecialTipsOnGain(
                        Lang("DANCE_SPECIAL_PRICE"),
                        Lang("DANCE_SPECIAL_PRICE_GET"),
                        Lang("BTN_SHARE"),
                        Lang("DLG_BTN_YES"),
                        _onGain,
                        _defaultFunc,
                        singleUpdateData.NewItem
                )
            end
        else
            -- do nothing
        end
    end
end

---@param func1 function<ItemData>
---@param itemData ItemData
function _showSpecialTipsOnGain(str1, str2, str3, str4, func1, func2, itemData)
    local param = { { ID = itemData.TID } }
    local innerFunc = function()
        func1(itemData)
    end

    MgrMgr:GetMgr("TipsMgr").ShowGetSpecialItemTips(str1, str2, str3, str4, innerFunc, func2, param)
end

---@param v ItemData
function _onGain(v)
    if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHARE_TO_GUILT_FAILED"))
        return
    end
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_linkSt, l_linkParams = MgrMgr:GetMgr("LinkInputMgr").GetItemPack(nil, v.TID, 0, v.UID, 1, false)
    -- l_chatMgr.DoHandleMsgNtf(
    --         MPlayerInfo.UID,
    --         l_chatDataMgr.EChannel.GuildChat,
    --         Lang("DANCE_GIFT", l_linkSt),
    --         "ItemInfoLink", nil, true,
    --         { MsgParam = l_linkParams }
    -- )
    l_chatMgr.SendChatMsg(MPlayerInfo.UID, Lang("DANCE_GIFT", l_linkSt), l_chatDataMgr.EChannel.GuildChat,l_linkParams)
    local l_changeToChannel = DataMgr:GetData("ChatData").EChannel.GuildChat
    UIMgr:ActiveUI(UI.CtrlNames.Chat, { changeToChannel = l_changeToChannel, needChangeToCurrentChannel = true })
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ShareSucceedText"))
end

function _onGainLottery(v)
    if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHARE_TO_GUILT_FAILED"))
        return
    end
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_linkSt, l_linkParams = MgrMgr:GetMgr("LinkInputMgr").GetItemPack(nil, v.TID, 0, v.UID, 1, false)
    -- l_chatMgr.DoHandleMsgNtf(
    --         MPlayerInfo.UID,
    --         l_chatDataMgr.EChannel.GuildChat,
    --         Lang("LOTTERY_GIFT", l_nowLotteryRankTitle , l_linkSt),
    --         "ItemInfoLink", nil, true,
    --         { MsgParam = l_linkParams }
    -- )
    l_chatMgr.SendChatMsg(MPlayerInfo.UID,Lang("LOTTERY_GIFT", l_nowLotteryRankTitle, l_linkSt), l_chatDataMgr.EChannel.GuildChat,l_linkParams)
    local l_changeToChannel = DataMgr:GetData("ChatData").EChannel.GuildChat
    UIMgr:ActiveUI(UI.CtrlNames.Chat, { changeToChannel = l_changeToChannel , needChangeToCurrentChannel = true})
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ShareSucceedText"))
end

function _defaultFunc()
    -- do nothing
end

---------------------------------------------------------------------------------------------
function GetDanceActionData(...)
    if l_danceActionTb == nil then
        l_danceActionTb = {}
        tableData = string.ro_split(TableUtil.GetThemePartyTable().GetRowBySetting("DancActionNum").Value, '|')
        for i = 2, #tableData do
            table.insert(l_danceActionTb, tonumber(tableData[i]))
        end
        table.sort(l_danceActionTb, function(a, b)
            return a > b
        end)
        l_danceMaxActionNum = l_danceActionTb[1] or -1
    end
    return l_danceActionTb, l_danceMaxActionNum
end

function GetTotalMeadlNum()
    tableData = string.ro_split(TableUtil.GetThemePartyTable().GetRowBySetting("MedalAllType").Value, '|')
    local num = 0
    for i = 1, #tableData do
        local coninNum = Data.BagModel:GetCoinOrPropNumById(tonumber(tableData[i]))
        num = num + coninNum
    end

    return num
end

function GetExchangeMedalNum()
    local rate = string.ro_split(TableUtil.GetThemePartyTable().GetRowBySetting("MedalChangeCoinRate").Value, '=')
    if #rate == 2 then
        return GetTotalMeadlNum() / tonumber(rate[2])
    end
    return GetTotalMeadlNum() / 1
end

--兑换主题币
function ExchangeThemeCoin(...)
    if GetTotalMeadlNum() <= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_PARTY_NOT_ENOUGH"))
        return
    end
    
    tableData = string.ro_split(TableUtil.GetThemePartyTable().GetRowBySetting("MedalAllType").Value, '|')
    local ItemData = {}
    for i = 1, #tableData do
        local cData = {}
        cData.item_id = tonumber(tableData[i])
        cData.item_count = Data.BagModel:GetCoinOrPropNumById(tonumber(tableData[i]))
        cData.is_bind = false
        table.insert(ItemData, cData)
    end

    MgrMgr:GetMgr("PropMgr").BarterItem(ItemData)
end

function CheckIsInThemeParty()
    if l_themePartyEnumClientState == nil or
            l_themePartyEnumClientState == ThemePartyClientState.kPartyStateNone then
        return false
    end

    return true
end

function DuringThemePartyScene()
    return l_themePartySceneId == tonumber(MScene.SceneID) and CheckIsInThemeParty()
end

return ModuleMgr.ThemePartyMgr