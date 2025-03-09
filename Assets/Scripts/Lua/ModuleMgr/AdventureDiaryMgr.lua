---
--- Created by cmd(TonyChen).
--- DateTime: 2019/3/19 17:37
---
module("ModuleMgr.AdventureDiaryMgr", package.seeall)


-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获取冒险日记单个子任务或小章节奖励后的事件
ON_GET_ADVENTURE_DIARY_AWARD = "ON_GET_ADVENTURE_DIARY_AWARD"
--获取冒险日记最终总章节奖励后的事件
ON_GET_ADVENTURE_DIARY_FINAL_AWARD = "ON_GET_ADVENTURE_DIARY_FINAL_AWARD"
------------- END 事件相关  -----------------

--冒险日记数据类获取
local l_adventureData = DataMgr:GetData("AdventureDiaryData")

--断线重连
function OnReconnected(reconnectData)
    
end

--登出时初始化相关信息
function OnLogout()
    
end

function OnInit()
    --任务完成事件监听
    GlobalEventBus:Add(EventConst.Names.OnTaskFinishNotify, function(object, taskId)
        --如果完成的任务属于冒险日记 则展示提示并更新红点
        if l_adventureData.missionFinishCheckTaskIdList and l_adventureData.missionFinishCheckTaskIdList[taskId] then
            --获取finishTaskId对应的冒险日记章子任务信息 
            local l_missionInfo = l_adventureData.GetMissionInfoByFinishTaskId(taskId)
            --获取不到对应子任务信息 不弹出提示和更新红点
            if l_missionInfo then
                --完成提示推送
                UIMgr:ActiveUI(UI.CtrlNames.AdventureDiaryAchieveTip, {missionInfo = l_missionInfo})
                --红点更新
                MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.AdventureDiary)
            end
        end
    end, MgrMgr:GetMgr("AdventureDiaryMgr"))
end

function Uninit()

    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.OnTaskFinishNotify, MgrMgr:GetMgr("AdventureDiaryMgr"))

end

--红点检测
function CheckRedSignMethod()
    --子任务红点判断
    local l_showRedSign = l_adventureData.UpdateAdventureData()
    --总奖励红点判断
    l_showRedSign = l_showRedSign or 
        (l_adventureData.chapterAwardIdCount ~= 0 and 
            l_adventureData.chapterAwardIdFinishCount == l_adventureData.chapterAwardIdCount and 
            not l_adventureData.GetIsChapterAwardGeted())
    --单章节奖励红点判断
    if not l_showRedSign then
        for k,v in pairs(l_adventureData.adventureDiaryInfo) do
            local l_canGet = l_adventureData.CheckSectionCanGetAward(v)
            local l_isGeted = l_adventureData.CheckSectionIsGetAward(v)
            if l_canGet and (not l_isGeted) then
                l_showRedSign = true
                break
            end
        end
    end

    if l_showRedSign then
        return 1 
    end

    return 0
end

------------------------CS调用的事件方法------------------------------------




---------------------------END CS调用的事件方法--------------------------------


-------------------------------其他协议接收后的分支方法-----------------------------------------------
--角色进入游戏时 冒险日记相关数据获取
--info.postcard_display  冒险日记奖励获取状况信息
function OnSelectRoleNtf(info)
    l_adventureData.SetAdventureDiaryInfo(info.postcard_display)
end


---------------------------END 其他协议接收后的分支方法-----------------------------------------


--------------------------以下是服务器交互PRC------------------------------------------

--请求获取子任务奖励的获取记录
function ReqMissionAwardGetRecord()

    local l_msgId = Network.Define.Rpc.GetPostcardDisplay
    ---@type GetPostcardDisplayArg
    local l_sendInfo = GetProtoBufSendTable("GetPostcardDisplayArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--接收请求获取子任务奖励的获取记录
function OnReqMissionAwardGetRecord(msg)
    ---@type GetPostcardDisplayRes
    local l_info = ParseProtoBufToTable("GetPostcardDisplayRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_adventureData.getedAwardMissionIds = l_info.table_ids or {}
        l_adventureData.getedAwardSectionIds = l_info.chapter_ids or {}
    end
end

--请求子任务完成奖励
function ReqGetMissionAward(missionId)

    local l_msgId = Network.Define.Rpc.UpdatePostcardDisplay
    ---@type UpdatePostcardDisplayArg
    local l_sendInfo = GetProtoBufSendTable("UpdatePostcardDisplayArg")

    l_sendInfo.table_id = missionId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--接收请求子任务完成奖励结果
function OnReqGetMissionAward(msg, arg)
    ---@type UpdatePostcardDisplayRes
    local l_info = ParseProtoBufToTable("UpdatePostcardDisplayRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_AWARD_SUCCESS"))
        --更新数据缓存 （特殊情况下会出现 界面被关闭缓存被清理 这时候不需要更新缓存）
        if l_adventureData.adventureDiaryInfo then
            local l_missionRow = TableUtil.GetPostcardDisplayTable().GetRowByID(arg.table_id)
            local l_chapterData = l_adventureData.adventureDiaryInfo[l_missionRow.Chapter]
            for i,v in ipairs(l_chapterData.missionInfos) do
                if v.missionData.ID == l_missionRow.ID then
                    v.isGetAward = true
                    EventDispatcher:Dispatch(ON_GET_ADVENTURE_DIARY_AWARD)
                    local l_openData = {
                        type = l_adventureData.EUIOpenType.AdventureDiaryTask,
                        missionInfo = v,
                        isNeedAnim = true,
                        isShowing = UIMgr:IsActiveUI(UI.CtrlNames.AdventureDiaryTask)
                    }
                    UIMgr:ActiveUI(UI.CtrlNames.AdventureDiaryTask, l_openData)
                    break
                end
            end 
        end
        --请求新的奖励获取数据
        ReqMissionAwardGetRecord()
    end

end

--请求获取单个章节奖励宝箱
function ReqGetSectionAward(sectionId)

    local l_msgId = Network.Define.Rpc.GetPostcardOneChapterAward
    ---@type PostcardOneChapterAwardArg
    local l_sendInfo = GetProtoBufSendTable("PostcardOneChapterAwardArg")
    l_sendInfo.chapter_id = sectionId

    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--接收请求获取单个章节奖励宝箱的结果
function OnReqGetSectionAward(msg, arg)

    ---@type PostcardOneChapterAwardRes 
    local l_info = ParseProtoBufToTable("PostcardOneChapterAwardRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_AWARD_SUCCESS"))
        --缓存先行记录已领取 并推送刷新事件  放弱网延迟
        table.insert(l_adventureData.getedAwardSectionIds, arg.chapter_id)
        EventDispatcher:Dispatch(ON_GET_ADVENTURE_DIARY_AWARD)
        --请求新的奖励获取数据
        ReqMissionAwardGetRecord()
    end

end

--请求获取总章节奖励宝箱
function ReqGetChapterAward()

    local l_msgId = Network.Define.Rpc.UpdatePostcardChapterAward
    ---@type UpdatePostcardChapterAwardArg
    local l_sendInfo = GetProtoBufSendTable("UpdatePostcardChapterAwardArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--接收请求获取总章节奖励宝箱的结果
function OnReqGetChapterAward(msg)
    ---@type UpdatePostcardChapterAwardRes
    local l_info = ParseProtoBufToTable("UpdatePostcardChapterAwardRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_adventureData.isGetChapterAward = 1  --更新记录
        EventDispatcher:Dispatch(ON_GET_ADVENTURE_DIARY_FINAL_AWARD)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_AWARD_SUCCESS"))
    end

end


------------------------------PRC  END------------------------------------------

---------------------------以下是服务器推送 PTC------------------------------------



------------------------------PTC  END------------------------------------------

