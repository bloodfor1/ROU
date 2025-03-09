---@module ModuleMgr.PostCardMgr
module("ModuleMgr.PostCardMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

-- 信息刷新
POST_CARD_INFO_UPDATE = "POST_CARD_INFO_UPDATE"
-- 奖励预览
POST_CARD_AWARD_PREVIEW = "POST_CARD_AWARD_PREVIEW"
-- 通知奖励预览消息刷新
ON_POST_CARD_AWARD_PREVIEW_UPDATE = "ON_POST_CARD_AWARD_PREVIEW_UPDATE"
-- 页面模板配置
DisplayPosConfig = {
    [1] = {-250, 137, 250, 137, -250, -116, 250, -116},
    [2] = {-250, 137, 250, 137, -250, -116, 250, -116},
    [3] = {-250, 137, 250, 137, -250, -116, 250, -116},
    [4] = {-250, 137, 250, 137, -250, -116, 250, -116},
}

local l_cachedAwardPreviewInfo
local l_cachedPostCardInfo

-- 获取任务状态以及时间
function GetTaskState(taskId)

    local l_finish = MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(taskId)
    if not l_finish then
        return false
    end

    return true, MgrMgr:GetMgr("TaskMgr").GetTaskFinishedTime(taskId)
end

-- 获取领奖状态
function GetAwardState(id)

    if not l_cachedPostCardInfo then
        return false
    end

    for i, v in ipairs(l_cachedPostCardInfo) do
        if v.target_id == id then
            return v.is_take
        end
    end

    return false
end

-----------------------------------------------------------------------------奖励预览相关
-- 监听奖励预览消息
function BindingAwardPreviewListener()

    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:Add(POST_CARD_AWARD_PREVIEW, OnAwardPreview, MgrMgr:GetMgr("PostCardMgr"))
    l_cachedAwardPreviewInfo = {}
end

-- 清理绑定
function ClearAwardPreviewLister()

    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:RemoveObjectAllFunc(POST_CARD_AWARD_PREVIEW, MgrMgr:GetMgr("PostCardMgr"))
    l_cachedAwardPreviewInfo = {}
end

-- 处理收到的奖励预览消息并予以缓存
function OnAwardPreview(_, awardInfo, _, awardId)

    if not awardInfo or not awardId then
        return
    end

    l_cachedAwardPreviewInfo = l_cachedAwardPreviewInfo or {}

    l_cachedAwardPreviewInfo[awardId] = awardInfo

    EventDispatcher:Dispatch(ON_POST_CARD_AWARD_PREVIEW_UPDATE)
end

-- 获取奖励预览消息
function GetAwardPreviewInfo(awardId)

    if l_cachedAwardPreviewInfo[awardId] then
        return l_cachedAwardPreviewInfo[awardId]
    end

    -- 若本地无缓存，向服务器请求新的
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(awardId, POST_CARD_AWARD_PREVIEW)
end

----------------------------------------------------------------------------end


function RequestPostCardInfo()
    local l_msgId = Network.Define.Rpc.GetPostcardDisplay
    ---@type GetPostcardDisplayArg
    local l_sendInfo = GetProtoBufSendTable("GetPostcardDisplayArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnPostCardInfo(msg)
    ---@type GetPostcardDisplayRes
    local l_info = ParseProtoBufToTable("GetPostcardDisplayRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_cachedPostCardInfo = l_info.postcard_display.postcard

    EventDispatcher:Dispatch(POST_CARD_INFO_UPDATE)
    --MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.BeginnerBook)
end

function RequestRewardPostCard(id)
    local l_msgId = Network.Define.Rpc.UpdatePostcardDisplay
    ---@type UpdatePostcardDisplayArg
    local l_sendInfo = GetProtoBufSendTable("UpdatePostcardDisplayArg")
    l_sendInfo.target_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRewardPostCard(msg)
    ---@type UpdatePostcardDisplayRes
    local l_info = ParseProtoBufToTable("UpdatePostcardDisplayRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    RequestPostCardInfo()
end

function ClearCachedPostCardData()

    l_cachedPostCardInfo = nil
end

function HasPostCardData()

    return l_cachedPostCardInfo ~= nil
end

function CheckRedSignMethod()
    
    if not l_cachedPostCardInfo then
        return 0
    end

    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BeginnerBook) then
        return 0
    end

    for i, v in ipairs(l_cachedPostCardInfo) do
        if not v.is_take and GetTaskState(v.target_id) then
            return 1
        end
    end

    return 0
end

-- local l_self
-- function OnInit()
--     l_self = MgrMgr:GetMgr("PostCardMgr")
--     GlobalEventBus:Add(EventConst.Names.UpdateTaskDetail, function()
--         MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.BeginnerBook)
--     end, l_self)
-- end

-- function Uninit()
--     if l_self then
--         GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.OnTaskFinishNotify, l_self)
--         l_self = nil
--     end
-- end

function OnSelectRoleNtf()
    RequestPostCardInfo()
end