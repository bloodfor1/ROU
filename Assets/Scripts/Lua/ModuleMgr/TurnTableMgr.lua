---@module TurnTableMgr
module("ModuleMgr.TurnTableMgr", package.seeall)

require "Common/Functions"

--------------------------------------------事件--Start----------------------------------
EventDispatcher = EventDispatcher.new()

ON_RANDOM_AWARD_START = "ON_RANDOM_AWARD_START"

--------------------------------------------事件--End----------------------------------

-- timer 用于终止任务
local rotateTimer

local l_data

--------------------------------------------生命周期--Start----------------------------------

function OnInit()

    l_data = DataMgr:GetData("TurnTableData")
end
--------------------------------------------生命周期--End----------------------------------

--------------------------------------------协议处理--Start----------------------------------

-- 消耗兑换券请求轮盘
function RequestQueryRandomAwardStart(itemId, awardId)

    local l_msgId = Network.Define.Rpc.QueryRandomAwardStart
    ---@type QueryRandomAwardStartArg
    local l_sendInfo = GetProtoBufSendTable("QueryRandomAwardStartArg")
    l_sendInfo.from_scene = RandomAwardSceneType.RandomAwardSceneTypeTickty
    l_sendInfo.item_id = itemId
    Network.Handler.SendRpc(l_msgId, l_sendInfo, {awardId = awardId, scene = RandomAwardSceneType.RandomAwardSceneTypeTickty})

    l_data.IsAction = true
end

-- 服务器响应兑换券结果
function OnQueryRandomAwardStart(msg, args, params)
    ---@type QueryRandomAwardStartRes
    local l_info = ParseProtoBufToTable("QueryRandomAwardStartRes", msg)
    if l_info.result ~= 0 then
        logError("OnQueryRandomAwardStart error: " .. tostring(l_info.result))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        l_data.CacheAwardResult = nil
        l_data.IsAction = false
        return
    end

    l_data.CacheAwardResult = {
        itemId = l_info.item_id,
        itemCount = l_info.item_count,
    }
    
    EventDispatcher:Dispatch(ON_RANDOM_AWARD_START, l_info.item_id, l_info.item_count)
end
--------------------------------------------协议处理--End----------------------------------


--------------------------------------------曲线相关--Start----------------------------------

-- 曲线
local function easeCurveFunc(t, b, c, d)

    local l_time = (t > d) and 1 or t / d
    logError("easeCurveFunc", t, l_time, c * l_time * l_time * l_time)
    return c * (l_time * l_time * l_time) + b
end

-- 计算目标角度值
local function getRealTargetAngle(targetAngle)

    local l_contantAngel, l_reduceAngle
    if targetAngle > 180 then
        l_contantAngel = 900
        l_reduceAngle = targetAngle + 180
    else
        l_contantAngel = 720
        l_reduceAngle = targetAngle + 360
    end

    return l_contantAngel, l_reduceAngle
end

-- 初始化直线部分的关键帧
local function generateCurveBaseFrames(contantAngel, speed)

    local l_frames = {}

    local l_constantAngleSplit = 90
    local l_splitContantCount = math.floor(contantAngel / l_constantAngleSplit)
    for i = 0, l_splitContantCount do
        local l_targetAngle = i * l_constantAngleSplit
        table.insert(l_frames, {
            time = l_targetAngle / speed,
            value = -l_targetAngle,
            inTangent = -speed,
            outTangent = -speed,
            tangentMode = 34,
        })
    end

    return l_frames
end

-- 插值计算慢慢减速的关键帧
function generateCurveLerpFrames(frames, value, time)

    table.insert(frames, {
        inTangent = 0,
        outTangent = 0,
        tangentMode = 136,
        value  = value,
        time = time,
    })
end

-- 转盘通用接口
function RotateTurnTable(targetAngle, callback, component)

    local l_curveData = {
        callback = callback,
        auto = true,
        weight = 0.5,
    }

    local l_contantSpeed = 540
    local l_reduceCostTime = 3
    local l_contantAngel, l_reduceAngle = getRealTargetAngle(targetAngle)
    local l_contantCostTime = l_contantAngel / l_contantSpeed
    l_curveData.frames = generateCurveBaseFrames(l_contantAngel, l_reduceAngle, l_contantSpeed)

    generateCurveLerpFrames(l_curveData.frames, -l_contantAngel - l_reduceAngle, l_reduceCostTime + l_contantCostTime)

    l_curveData.time = l_reduceCostTime + l_contantCostTime

    component:CreateAnimationCurve(l_curveData)

    return l_curveData.time
end

-- 旋转表现逻辑
function ActionRotate(params)

    local l_time = RotateTurnTable(params.targetAngle, params.callback, params.curveCom)

    ClearRotateTimer()
    -- 逻辑不依赖表现回调
    rotateTimer = Timer.New(function()
        OnRotateFinished()
    end, l_time + 0.1):Start()
end

--------------------------------------------曲线相关--End----------------------------------


-- 逻辑计时回调
function OnRotateFinished()
    rotateTimer = nil

    if l_data.CacheAwardResult then
        ShowRewardTips(l_data.CacheAwardResult)
    end

    l_data.CacheAwardResult = nil

    l_data.IsAction = false
end

-- 外部接口，打开界面
function OpenUI(award_id, item_id)

    UIMgr:ActiveUI(UI.CtrlNames.Turntable, {
        awardId = award_id,
        itemId = item_id,
    })
end

-- 客户端强制退出时，状态清理，并认为已经完成
function ForceQuit()
    
    ClearRotateTimer()

    OnRotateFinished()
end

-- 显示tips
function ShowRewardTips(tbl)

    MgrMgr:GetMgr("NoticeMgr").NoticeNormalTips(tbl.itemId, tbl.itemCount)

    for i, v in ipairs(l_data.PopCacheTips()) do
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(v)    
    end

    MgrMgr:GetMgr("PropMgr").CalculateItemChangeData({{item = {ItemID = tbl.itemId}}})
end

-- 清理timer
function ClearRotateTimer()

    if rotateTimer then
        rotateTimer:Stop()
        rotateTimer = nil
    end
end

-- 是否在Action
function IsAction()
    return l_data.IsAction
end

-- 缓存tips
function CacheTips(str)

    l_data.CacheTips(str)
end

return TurnTableMgr