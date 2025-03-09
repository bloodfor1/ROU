---
--- Created by cmd(TonyChen) detach from GuildMgr. 
--- DateTime: 2019/03/02 12:18
---
---@module ModuleMgr.GuildWelfareMgr
module("ModuleMgr.GuildWelfareMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--公会福利领取分红
ON_GUILD_GET_WELFARE_AWARD = "ON_GUILD_GET_WELFARE_AWARD"
--公会福利分红状态
ON_GUILD_GET_WELFARE_AWARD_STATE = "ON_GUILD_GET_WELFARE_AWARD_STATE"
--公会礼盒信息获取事件
ON_GET_GUILD_GIFT_INFO = "ON_GET_GUILD_GIFT_INFO"
--公会礼盒发放成功事件
ON_GRANT_GIFT_SUCCESSFULLY = "ON_GRANT_GIFT_SUCCESSFULLY"
--公会礼盒发放失败事件
ON_GRANT_GIFT_FAILED = "ON_GRANT_GIFT_FAILED"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")


--公会福利用红点确认方法
function CheckWelfareRedSignMethod()
    if not l_guildData.guildWelfareIsClick then
        if l_guildData.guildWelfareState == l_guildData.EWelfareStateType.CanGet then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

--------------------------以下是服务器交互PRC------------------------------------------

--请求获取福利分红
function ReqGetWelfare()
    local l_msgId = Network.Define.Rpc.GuildGetWelfare
    ---@type GuildGetWelfareArg
    local l_sendInfo = GetProtoBufSendTable("GuildGetWelfareArg")
    l_sendInfo.role_uid = tostring(MPlayerInfo.UID)

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收获取福利分红
function OnReqGetWelfare(msg)
    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    ---@type GuildGetWelfareRes
    local l_info = ParseProtoBufToTable("GuildGetWelfareRes", msg)

    if l_info.error_code == 0 then
        if not l_info.is_award then
            --可领取
            l_guildData.guildWelfareState = l_guildData.EWelfareStateType.CanGet
        else
            --已领取
            l_guildData.guildWelfareState = l_guildData.EWelfareStateType.IsGeted
        end
    else
        --不可领取
        l_guildData.guildWelfareState = l_guildData.EWelfareStateType.Disable
    end

    redSignMgr.UpdateRedSign(eRedSignKey.GuildWelfare)

    if l_guildData.guildWelfareClick then
        l_guildData.guildWelfareClick = false
        if l_info.error_code == 0 then
            local l_openData = {
                type = l_guildData.EUIOpenType.GuildWelfareReceive,
                data = {isGet = l_info.is_award, zeny = l_info.welfare}
            }
            UIMgr:ActiveUI(UI.CtrlNames.GuildWelfareReceive, l_openData)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        end
    else
        EventDispatcher:Dispatch(ON_GUILD_GET_WELFARE_AWARD_STATE)
    end
end

--请求领取福利分红
function ReqGetWelfareAward()
    local l_msgId = Network.Define.Rpc.GuildWelfareAward
    ---@type GuildWelfareAwardArg
    local l_sendInfo = GetProtoBufSendTable("GuildWelfareAwardArg")
    l_sendInfo.role_uid = tostring(MPlayerInfo.UID)

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取领取福利分红
function OnReqGetWelfareAward(msg)
    ---@type GuildWelfareAwardRes
    local l_info = ParseProtoBufToTable("GuildWelfareAwardRes", msg)

    if l_info.error_code == 0 then
        --刷新按钮
        l_guildData.guildWelfareState = l_guildData.EWelfareStateType.IsGeted
        EventDispatcher:Dispatch(ON_GUILD_GET_WELFARE_AWARD, l_info.is_award)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求公会礼盒信息
function ReqGuildGiftInfo(callback)
    local l_msgId = Network.Define.Rpc.GuildGiftGetInfo
    ---@type GuildGiftGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("GuildGiftGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, callback)
end

--接受服务器发回的公会礼盒信息
function OnReqGuildGiftInfo(msg)
    ---@type GuildGiftGetInfoRes
    local l_info = ParseProtoBufToTable("GuildGiftGetInfoRes", msg)

    if l_info.error_code == 0 then
        l_guildData.SetGuildGiftInfo(l_info)
        EventDispatcher:Dispatch(ON_GET_GUILD_GIFT_INFO)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求公会礼盒发放
function ReqGuildGiftGrant()
    local l_msgId = Network.Define.Rpc.GuildGiftHandOut
    ---@type GuildGiftHandOutArg
    local l_sendInfo = GetProtoBufSendTable("GuildGiftHandOutArg")
    for k,v in pairs(l_guildData.guildGiftSendMemberIds) do
        local oneItem = l_sendInfo.role_list:add()
        oneItem.value = k
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的公会礼盒发放结果
function OnReqGuildGiftGrant(msg)
    ---@type GuildGiftHandOutRes
    local l_info = ParseProtoBufToTable("GuildGiftHandOutRes", msg)

    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GRANT_SUCCESS"))
        ReqGuildGiftInfo()
        EventDispatcher:Dispatch(ON_GRANT_GIFT_SUCCESSFULLY)
        --MgrMgr:GetMgr("GuildMgr").ReqGuildMemberList()  --发送完后不再刷新列表 防止列表重置回顶部 原代码暂时保留 cmd 20200402
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        EventDispatcher:Dispatch(ON_GRANT_GIFT_FAILED)
    end
end

------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------



------------------------------PTC  END------------------------------------------

