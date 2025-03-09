--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-11 16:12:48
--

---@module ModuleMgr.WabaoAwardMgr
module("ModuleMgr.WabaoAwardMgr", package.seeall)

--------------------------------------------事件--Start----------------------------------
EventDispatcher = EventDispatcher.new()

ON_RANDOM_AWARD_PREVIEW_EVENT = "ON_RANDOM_AWARD_PREVIEW_EVENT"
ON_SHOW_CACHE_REWARD_TIP_FINISH = "ON_SHOW_CACHE_REWARD_TIP_FINISH"
--------------------------------------------事件--End----------------------------------


local l_data


function OnInit()

    l_data = DataMgr:GetData("WabaoAwardData")

    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:Add(ON_RANDOM_AWARD_PREVIEW_EVENT, OnAwardPreview, MgrMgr:GetMgr("WabaoAwardMgr"))
end

function OnUnInit()
    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:RemoveObjectAllFunc(ON_RANDOM_AWARD_PREVIEW_EVENT, MgrMgr:GetMgr("WabaoAwardMgr"))
end

-- 恶魔宝藏宝箱展示
local function showTreasureBox(tmpInfo)

    local l_itemId = tmpInfo.itemId
    UIMgr:ActiveUI(UI.CtrlNames.EmoTreasureBox, 
    {
        itemId = l_itemId,
        callback = function() ShowRewardTips(tmpInfo) end,
    })   
end

-- 奖励预览
local function previewAward(tmpInfo)

    -- 缓存转盘基本信息
    l_data.CacheAwardResult = tmpInfo
    l_data.CacheAwardResult.awardId = tmpInfo.awardId
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(tmpInfo.awardId, ON_RANDOM_AWARD_PREVIEW_EVENT)
end

-- 处理表现
local function processAwardLevel(tmpInfo)

    switch(tmpInfo.awardLevel) {
        [l_data.EWabaoAwardLevel.High] = function()
            previewAward(tmpInfo)
        end,
        [l_data.EWabaoAwardLevel.Middle] = function()
            showTreasureBox(tmpInfo)
        end,
        [l_data.EWabaoAwardLevel.Normal] = function()
            ShowRewardTips(tmpInfo)
        end,
        default = function()
            logError("processAwardLevel error, level:", level)
        end,
    }
end

-- 挖宝轮盘
function OnQueryRandomAwardByWabao(msg)
    ---@type WaBaoAwardIdNtfData
    local l_info = ParseProtoBufToTable("WaBaoAwardIdNtfData", msg)
    -- if l_info.result ~= 0 then
    --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    --     l_data.CacheAwardResult = nil
    --     return
    -- end

    local l_tmp = {
        itemId = l_info.item_id,
        itemCount = l_info.item_count,
        awardLevel = l_info.award_level or l_data.EWabaoAwardLevel.Normal,
        costResource = not l_info.is_free,
        awardId = l_info.award_id
    }
    log(l_tmp.awardLevel, l_tmp.costResource, l_tmp.itemId, l_tmp.itemCount)
    l_data.CacheAwardResult = nil
    -- l_tmp.awardLevel = 1
    processAwardLevel(l_tmp)
end

-- 奖励预览结果
function GetWabaoRewardsPreview()

    if not CacheAwardResult then
        return
    end

    return CacheAwardResult.item_list
end

-- 挖宝开始通知
function OnWaBaoStartNotify()

    l_data.IsAction = true
end

-- 增加容错判断,没有随机到道具的情况
local function checkNoneAward(info)

    for i, v in ipairs(info.award_list) do
        if v.item_id == 0 then
            logError(StringEx.Format("转盘awardid没有随机到奖励 @数值"))
            break
        end
    end
end


-- 奖励预览通知返回的数据处理
function OnAwardPreview(_, info, _, award_id)

    if info == nil then
        return
    end

    checkNoneAward(info)

    -- 检查本地数据
    if not l_data.CacheAwardResult then
        logError("OnAwardPreview fail, 本地没有转盘数据")
        return
    end

    l_data.HandleWabaoPreview(info)

    local l_itemList = table.ro_deepCopy(l_data.CacheAwardResult.item_list)
    local l_itemId = l_data.CacheAwardResult.itemId
    UIMgr:ActiveUI(UI.CtrlNames.EmoTreasureTurn, {
        itemList = l_itemList,
        itemId = l_itemId,
    })    
end

-- 旋转表现逻辑
function ActionRotate(params)

    local l_time = MgrMgr:GetMgr("TurnTableMgr").RotateTurnTable(params.targetAngle, params.callback, params.curveCom)

    ClearRotateTimer()
    -- 逻辑不依赖表现回调
    rotateTimer = Timer.New(function()
        ForceQuit()
    end, l_time + 0.1):Start()
end

-- 强制退出
function ForceQuit()

    if l_data.CacheAwardResult then
        ShowRewardTips(l_data.CacheAwardResult)
        l_data.CacheAwardResult = nil
    end

    ClearRotateTimer()
end


-- 清理timer
function ClearRotateTimer()
    if rotateTimer then
        rotateTimer:Stop()
        rotateTimer = nil
    end
end

-- 显示tips
function ShowRewardTips(tbl)
 
    local l_normalTips, l_maxTips, l_extra
    if tbl.awardLevel ~= nil then
        l_normalTips, l_maxTips, l_extra = GetWabaoNotifyTips(tbl.awardLevel, tbl.costResource)
    end

    local l_opt = {
        title = l_normalTips,
        itemId = tonumber(tbl.itemId),
        itemOpts = {num = tbl.itemCount, icon = {size = 18, width = 1.4}},
        addin = l_extra,
    }
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)

    MgrMgr:GetMgr("PropMgr").CalculateItemChangeData({{item = {ItemID = tbl.itemId}}})

    if l_maxTips and string.len(l_maxTips) > 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_maxTips)
    end

    l_data.IsAction = false

    for i, v in ipairs(l_data.PopCacheTips()) do
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(v)    
    end

    EventDispatcher:Dispatch(ON_SHOW_CACHE_REWARD_TIP_FINISH)
end


-- 获取挖宝提示
function GetWabaoNotifyTips(level, costResource)
    
    local l_curTime, l_maxTime = MgrMgr:GetMgr("DelegateModuleMgr").GetDelegateTimesInfo(GameEnum.Delegate.activity_Evil)
    
    local extra = ""
    if not costResource then
        extra = Lang("WabaoNotifyCountFormat", l_curTime, l_maxTime)
    end

    local l_maxTips = ""
    if l_curTime >= l_maxTime and (not costResource) then
        l_maxTips = Common.Utils.Lang("QUERY_WABAO_LIMITED")
    end

    local l_tips = Common.Utils.Lang("QUERY_WABAO_TIPS" .. tostring(level))

    return l_tips, l_maxTips, extra
end

-- 是否在Action
function IsAction()
    return l_data.IsAction
end

-- 缓存tips
function CacheTips(str)

    l_data.CacheTips(str)
end

return ModuleMgr.WabaoAwardMgr