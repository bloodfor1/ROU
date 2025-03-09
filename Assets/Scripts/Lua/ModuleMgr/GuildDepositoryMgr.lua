---
--- Created by cmd(TonyChen) detach from GuildMgr.  
--- DateTime: 2019/06/03 15:06
---
---@module ModuleMgr.GuildDepositoryMgr
module("ModuleMgr.GuildDepositoryMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--接收公会仓库数据事件
ON_GET_GUILD_DEPOSITORY_DATA = "ON_GET_GUILD_DEPOSITORY_DATA"
--设置关注、取消关注的事件
ON_MODIFY_ATTENTION_STATE = "ON_MODIFY_ATTENTION_STATE"
--拍卖出价事件
ON_SALE_BID = "ON_SALE_BID"
--接收公会拍卖纪录事件
ON_GET_SALE_RECORD_PUBLIC = "ON_GET_SALE_RECORD_PUBLIC"
--接收个人拍卖纪录事件
ON_GET_SALE_RECORD_PERSONAL = "ON_GET_SALE_RECORD_PERSONAL"
--倒计时时间修改事件
ON_TIME_COUNT_DOWN = "ON_TIME_COUNT_DOWN"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")
--是否正在打开
local l_isOpening = false
--距离下一次节点的倒计时时间
NextTime = 0
--倒计时计时器
local l_timer = nil 

--断线重连
function OnReconnected(reconnectData)
    ReqGetGuildDepositoryInfoBySystem()
end

--登出时初始化相关信息
function OnLogout()
    --清除信息
    ReleaseTimer()
    NextTime = 0
end

--系统层面获取仓库数据 红点等处理
function ReqGetGuildDepositoryInfoBySystem()
    --公会仓库等级判断
    local l_buildingLvCheck, l_limitBuildLevel = CheckBuildingLv()
    if not l_buildingLvCheck then 
        return
    end
    --加入公会时间判断
    local l_joinTimeCheck, l_limitJoinDay, l_deltaTimeTable = CheckJoinTime()
    if not l_joinTimeCheck then
        return
    end
    --符合条件则重连时请求公会仓库数据
    ReqGetGuildDepositoryInfo()
end

--打开公会仓库
function OpenGuildDepository()

    --弱网时点击无反应
    if (not l_guildData.selfGuildMsg.joinTime) or l_guildData.selfGuildMsg.joinTime == 0 then
        return
    end
    --公会仓库等级判断
    local l_buildingLvCheck, l_limitBuildLevel = CheckBuildingLv()
    if not l_buildingLvCheck then 
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DEPOSITORY_OPEN_LEVEL_LIMIT", l_limitBuildLevel))
        return
    end
    --加入公会时间判断
    local l_joinTimeCheck, l_limitJoinDay, l_deltaTimeTable = CheckJoinTime()
    if not l_joinTimeCheck then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DEPOSITORY_OPEN_JOIN_TIME_LIMIT",
                l_limitJoinDay, l_deltaTimeTable.day, l_deltaTimeTable.hour, l_deltaTimeTable.min))
        return
    end
    --设置打开标志 请求最新数据
    l_isOpening = true
    ReqGetGuildDepositoryInfo()
end

--获取公会仓库信息后的打开回调
function OnOpenGuildDepository()
    l_isOpening = false
    --如果正在拍卖进入拍卖的页签  否则进入仓库页前
    if IsSaling() then
        UIMgr:ActiveUI(UI.CtrlNames.GuildDepository, {
            selectHandlerName = UI.HandlerNames.GuildDepositorySale,
        })
    else
        UIMgr:ActiveUI(UI.CtrlNames.GuildDepository)
    end
end

--检查公会建筑等级是否满足
--返回值 是否成功 需求等级
function CheckBuildingLv()
    local l_guildBuildMgr = MgrMgr:GetMgr("GuildBuildMgr")
    local l_depositoryInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Hall)
    local l_limitBuildLevel = TableUtil.GetGuildSettingTable().GetRowBySetting("WarehouseLevelLimit").Value
    if not l_depositoryInfo or l_depositoryInfo.level < tonumber(l_limitBuildLevel) then
        return false, l_limitBuildLevel
    end
    return true, l_limitBuildLevel
end

--检查加入时间是否符合条件
--返回值 是否成功 需求加入时间 剩余时间的时分秒数据包
function CheckJoinTime()
    local l_joinedTime = Common.TimeMgr.GetNowTimestamp() - l_guildData.selfGuildMsg.joinTime
    local l_limitJoinDay = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("WarehouseTimeLimit").Value)
    local l_limitJoinTime = l_limitJoinDay * 86400
    if l_joinedTime < l_limitJoinTime then
        local l_deltaTime = l_limitJoinTime - l_joinedTime
        local l_deltaTimeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_deltaTime)
        return false, l_limitJoinDay, l_deltaTimeTable
    end
    return true, l_limitJoinDay
end

--是否正在拍卖
function IsSaling()
    local l_saleList = l_guildData.GetGuildDepositorySaleList()
    return l_saleList and #l_saleList > 0 or false
end

function CheckInSale()
    local l_saleList = l_guildData.GetGuildDepositorySaleList()
    return #l_saleList and #l_saleList or 0
end
--设置定时器
function SetCountDownTimer(nextTime)
    --更新倒计时时间
    NextTime = nextTime - Common.TimeMgr.GetNowTimestamp()
    NextTime = NextTime < 0 and 0 or NextTime
    --设置计时器
    if not l_timer then
        l_timer = Timer.New(function()
            --每秒倒计时减少 最少为0
            NextTime = NextTime - 1 < 0 and 0 or NextTime - 1
            --时间格式转化并推送给需要的界面 目前三个
            NextTime = NextTime < 0 and 0 or NextTime
            local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(NextTime)
            EventDispatcher:Dispatch(ON_TIME_COUNT_DOWN, l_timeTable)
            --倒计时结束处理
            if NextTime <= 0 and l_timer then
                --倒计时结束重新请求数据
                ReqGetGuildDepositoryInfo()
                l_timer:Stop()
                l_timer = nil
            end
        end, 1, -1, true)
        l_timer:Start()
    end
end

--释放定时器 界面关闭时调用
function ReleaseTimer()
    if l_timer then
        l_timer:Stop()
        l_timer = nil
    end
end

--更新拍卖物品出价
function UpdateSaleItemBid(itemUid, newPrice, oldPrice, operateTime)
    local l_saleList = l_guildData.GetGuildDepositorySaleList()
    if l_saleList and #l_saleList > 0 then
        for i = 1, #l_saleList do
            local l_temp = l_saleList[i]
            if l_temp.itemUid == itemUid then
                l_temp.selfPrice = newPrice
                --提示区分 与 操作时间赋值
                if newPrice == 0 then
                    --取消竞价完成
                    l_temp.lastCancelTime = tonumber(tostring(operateTime))
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANEL_GUILD_SALE_BID_SUCCESS"))
                elseif oldPrice == 0 then
                    --竞价完成
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COMPLETE_GUILD_SALE_BID"))
                else
                    --修改竞价完成 这里不用判断等于的情况 一开始就会过滤掉
                    l_temp.lastModifyTime = tonumber(tostring(operateTime))
                    if newPrice < oldPrice then
                        --降低竞价
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REDUCE_GUILD_SALE_BID_SUCCESS", tostring(oldPrice - newPrice)))
                    else
                        --提高竞价
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ADD_GUILD_SALE_BID_SUCCESS", tostring(newPrice - oldPrice)))
                    end
                end
                break
            end
        end
    end
end

--------------------------以下是服务器交互PRC------------------------------------------
--请求获取公会仓库数据（仓库已开放格子 仓库物品列表 拍卖列表 下次拍卖开始时间）
function ReqGetGuildDepositoryInfo()
    local l_msgId = Network.Define.Rpc.GetGuildRepoInfo
    ---@type GetGuildRepoInfoReq
    local l_sendInfo = GetProtoBufSendTable("GetGuildRepoInfoReq")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收公会仓库数据数据
function OnReqGetGuildDepositoryInfo(msg)
    ---@type GetGuildRepoInfoRsp
    local l_info = ParseProtoBufToTable("GetGuildRepoInfoRsp", msg)

    if l_info.errcode == 0 then
        --设置公会仓库数据
        l_guildData.SetGuildDepositoryInfo(l_info.guildrepo)
        --下一个时间节点的倒计时获取
        SetCountDownTimer(l_guildData.guildDepositoryInfo.nextTimeFrame)
        --信息推送
        EventDispatcher:Dispatch(ON_GET_GUILD_DEPOSITORY_DATA, l_info.guildrepo)
        --判断是否需要打开界面
        if l_isOpening then
            OnOpenGuildDepository()
        end
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GuildSale)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求关注一件物品
function ReqSetAttention(itemUuid, isAttention)
    local l_msgId = Network.Define.Rpc.GuildRepoSetAttention
    ---@type GuildRepoSetAttentionReq
    local l_sendInfo = GetProtoBufSendTable("GuildRepoSetAttentionReq")
    l_sendInfo.itemuuid = itemUuid
    l_sendInfo.isattention = isAttention
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收关注结果
function OnReqSetAttention(msg, arg)
    ---@type GuildRepoSetAttentionRsp
    local l_info = ParseProtoBufToTable("GuildRepoSetAttentionRsp", msg)

    if l_info.errcode == 0 then
        --设置关注
        l_guildData.SetGuildDepositoryItemAttention(arg.itemuuid, l_info.isattention)
        --通知界面刷新展示
        EventDispatcher:Dispatch(ON_MODIFY_ATTENTION_STATE, arg.itemuuid, l_info.isattention)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求删除一件物品
function ReqRemoveItem(itemUuid)
    local l_msgId = Network.Define.Rpc.GuildRepoRemoveItem
    ---@type GuildRepoRemoveItemReq
    local l_sendInfo = GetProtoBufSendTable("GuildRepoRemoveItemReq")
    l_sendInfo.itemuuid = tostring(itemUuid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收删除结果
function OnReqRemoveItem(msg)
    ---@type GuildRepoRemoveItemRsp
    local l_info = ParseProtoBufToTable("GuildRepoRemoveItemRsp", msg)
    if l_info.errcode == 0 then
        --刷新列表 重新请求新数据
        ReqGetGuildDepositoryInfo()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求竞价一件物品
function ReqBidItem(itemUuid, price)
    local l_msgId = Network.Define.Rpc.GuildAuctionSetPrice
    ---@type GuildAuctionSetPriceReq
    local l_sendInfo = GetProtoBufSendTable("GuildAuctionSetPriceReq")
    l_sendInfo.itemuuid = tostring(itemUuid)
    l_sendInfo.newoffer = price  --出价为0 表示取消竞价

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收竞价结果
function OnReqBidItem(msg)
    ---@type GuildAuctionSetPriceRsp
    local l_info = ParseProtoBufToTable("GuildAuctionSetPriceRsp", msg)
    if l_info.errcode == 0 then
        --更新出价数据
        UpdateSaleItemBid(l_info.itemuuid, l_info.newprice, l_info.oldprice, l_info.nextcdtime)
        --刷新列表
        EventDispatcher:Dispatch(ON_SALE_BID)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求公会的拍卖纪录
function ReqSaleRecordPublic()
    local l_msgId = Network.Define.Rpc.GetGuildAuctionPublicRecord
    ---@type GetGuildAuctionPublicRecordReq
    local l_sendInfo = GetProtoBufSendTable("GetGuildAuctionPublicRecordReq")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收公会的拍卖纪录
function OnReqSaleRecordPublic(msg)
    ---@type GetGuildAuctionPublicRecordRsp
    local l_info = ParseProtoBufToTable("GetGuildAuctionPublicRecordRsp", msg)

    if l_info.errcode == 0 then
        --通知列表展示
        EventDispatcher:Dispatch(ON_GET_SALE_RECORD_PUBLIC, l_info.records.publicrecords)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求个人的拍卖纪录
function ReqSaleRecordPersonal()
    local l_msgId = Network.Define.Rpc.GetGuildAuctionPersonalRecord
    ---@type GetGuildAuctionPersonalRecordReq
    local l_sendInfo = GetProtoBufSendTable("GetGuildAuctionPersonalRecordReq")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收个人的拍卖纪录
function OnReqSaleRecordPersonal(msg)
    ---@type GetGuildAuctionPersonalRecordRsp
    local l_info = ParseProtoBufToTable("GetGuildAuctionPersonalRecordRsp", msg)

    --通知列表展示
    EventDispatcher:Dispatch(ON_GET_SALE_RECORD_PERSONAL, l_info.personalrecords.records)
end

------------------------------PRC  END------------------------------------------

--公会个人拍卖纪录推送 （特殊情况会收到）
function OnGuildEnterNotify(msg)
    ---@type RoleGuildAuctionRecord
    local l_info = ParseProtoBufToTable("RoleGuildAuctionRecord", msg)
    --通知列表展示
    EventDispatcher:Dispatch(ON_GET_SALE_RECORD_PERSONAL, l_info.records)
end


---------------------------以下是单项协议 PTC------------------------------------



------------------------------PTC  END------------------------------------------
