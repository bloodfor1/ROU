---
--- Created by cmd(TonyChen).
--- DateTime: 2018/7/27 19:42
---
---@module ModuleMgr.RedEnvelopeMgr
module("ModuleMgr.RedEnvelopeMgr", package.seeall)


-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--选择红包等级ID后事件
ON_SELECT_REDENVELOPE_LEVEL_ID = "ON_SELECT_REDENVELOPE_LEVEL_ID"
--发送红包成功后事件
ON_SEND_SUCCESS = "ON_SEND_SUCCESS"
--打开红包后事件
ON_OPEN_REDENVELOPE = "ON_OPEN_REDENVELOPE"
------------- END 事件相关  -----------------
--红包获取记录特殊标记枚举
ESpecialFlagType = {
    None = 0,       --无
    Best = 1,       --手气最佳
    Fastest = 2,    --手速最快
    Fast = 3,       --手速不错
}

--红包枚举
RED_TYPE = {
    LUCKY = RedEnvelopeType.RED_ENVELOPE_ORDINARY,
    PASSWORD = RedEnvelopeType.RED_ENVELOPE_PASSWORD,
}

--红包界面展示类型
ERedEnvelopeShowMode = {
    Send = 1,    --发送界面
    Unlock = 2,   --口令红包解锁界面
    Get = 3,     --获取界面
    Sending = 4,  --发送中(特效播放时)
}

--是否正在进行红包的屏蔽字检测(防弱网连点)
IsBlockTextChecking = false
--是否可发送发红包请求(防弱网连点)
CanReqSendRed = true
--是否可以打开红包(防止动画期间连点)
CanOpenRed = true
--手速不错的获取数量
local l_fastNum = MGlobalConfig:GetInt("RedPacketFastBoyOrGirl") or 0

--登出时初始化公会相关信息
function OnLogout()


end

function OnReconnected(reconnectData)
    --断线重连重置标志
    IsBlockTextChecking = false
    CanReqSendRed = true
    CanOpenRed = true
end

--选择红包等级ID
function SelectRedEnvelopeLevelType(redLevelId)
    EventDispatcher:Dispatch(ON_SELECT_REDENVELOPE_LEVEL_ID, redLevelId)
end

--展示发送红包界面
--redType  红包类型 枚举
--isGuild  是否是公会红包
function ShowRedEnvelope_Send(redType, isGuild)
    --公会成员数量获取
    local l_guildMemberNum = isGuild and DataMgr:GetData("GuildData").GetGuildMemberNum() or nil

    UIMgr:ActiveUI(UI.CtrlNames.RedEnvelope, {
        showMode = ERedEnvelopeShowMode.Send,   --展示类型
        redType = redType,      --红包类型
        guildMemberNum = l_guildMemberNum  --公会成员数量
    })
end

--展示口令红包解锁界面
--redId  红包ID
--pwd  红包口令或寄语
function ShowRedEnvelope_Unlock(redId, pwd)
    UIMgr:ActiveUI(UI.CtrlNames.RedEnvelope, {
        showMode = ERedEnvelopeShowMode.Unlock,   --展示类型
        redId = redId,      --红包ID
        pwd = pwd       --红包口令
    })
end

--展示红包获取记录界面
--redEnvelopeInfo  红包信息
--recordList  领取记录列表
function ShowRedEnvelope_Get(redEnvelopeInfo, recordList)

    local l_recordList = {}  --处理后的记录列表
    local l_selfGetRecord = nil   --自己的记录
    local l_bestRecord = nil  --最好记录

    for i = 1, #recordList do
        local l_temp = {
            roleId = recordList[i].role_id,
            roleName = recordList[i].role_name,
            itemId = recordList[i].items[1].item_id,
            itemNum = recordList[i].items[1].item_count,
            memberInfo = recordList[i].member_base_info,
            specialFlagType = ESpecialFlagType.None
        }
        --手速相关标记判断
        if i == 1 then
            --手速最佳判断
            l_temp.specialFlagType = ESpecialFlagType.Fastest
        elseif i <= l_fastNum then
            --手速不错判断
            l_temp.specialFlagType = ESpecialFlagType.Fast
        end
        --找到最佳记录
        if not l_bestRecord or l_temp.itemNum > l_bestRecord.itemNum then
            l_bestRecord = l_temp
        end
        --找到自己记录
        if not l_selfGetRecord and tostring(MPlayerInfo.UID) == tostring(l_temp.roleId) then
            l_selfGetRecord = l_temp
        end
        --加入列表
        table.insert(l_recordList, l_temp)
    end
    --最佳记录的最佳值修改 要求红包抢完才显示
    if #recordList == redEnvelopeInfo.red_envelope_total_num and l_bestRecord then
        l_bestRecord.specialFlagType = ESpecialFlagType.Best
    end
    --界面展示
    UIMgr:ActiveUI(UI.CtrlNames.RedEnvelope, {
        showMode = ERedEnvelopeShowMode.Get,   --展示类型
        redType = redEnvelopeInfo.red_envelope_type,      --红包类型
        words = redEnvelopeInfo.words,    --寄语或口令
        selfGetRecord = l_selfGetRecord,  --自己的获取记录
        recordList = l_recordList       --获取记录列表
    })
end


-----------------------------内部工具方法---------------------------------------



-----------------------------END 内部工具方法--------------------------------------------



-------------------------------其他协议接收后的分支方法-----------------------------------------------



---------------------------END 其他协议接收后的分支方法-----------------------------------------


--------------------------以下是服务器交互PRC------------------------------------------
--请求发送红包
--redType  红包类型 枚举
--msg  红包口令或寄语
--redLevelId  红包等级ID
--redNum  红包数量
function ReqSendRedEnvelope(redType, msg, redLevelId, redNum)
    --防连点检测 单次红包发送后 需要等服务器结果才能发下一次
    if not CanReqSendRed then return end
    CanReqSendRed = false

    local l_msgId = Network.Define.Rpc.SendGuildRedEnvelope
    ---@type SendGuildRedEnvelopeArg
    local l_sendInfo = GetProtoBufSendTable("SendGuildRedEnvelopeArg")

    l_sendInfo.red_envelope_type = redType
    l_sendInfo.words = msg
    l_sendInfo.diamond_reward_id = redLevelId
    l_sendInfo.number = redNum

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收发送红包的结果
function OnReqSendRedEnvelope(msg)
    ---@type SendGuildRedEnvelopeRes
    local l_info = ParseProtoBufToTable("SendGuildRedEnvelopeRes", msg)
    
    if l_info.error_code == ErrorCode.ERR_IN_PAYING then
        game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.SendGuildRedEnvelope, OnSendRedEnvelopeSuccess)
    elseif l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        CanReqSendRed = true  --重置可发送红包请求标志
    end
end

--红包发送成功事件
function OnSendRedEnvelopeSuccess()
    CanReqSendRed = true  --重置可发送红包请求标志
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SEND_SUCCESS"))
    --通知界面发送成功 展示发送特效
    EventDispatcher:Dispatch(ON_SEND_SUCCESS)
end

--请求确认红包状态
--redId  红包ID
function ReqCheckRedEnvelopeState(redIds)
    local l_msgId = Network.Define.Rpc.GetGuildRedEnvelopeInfo
    ---@type GetGuildRedEnvelopeInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildRedEnvelopeInfoArg")
    
    --这边做成列表形式以便以后扩展
    for i = 1, #redIds do
        l_sendInfo.guild_red_envelope_id:add().value = redIds[i]
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收红包状态
function OnReqCheckRedEnvelopeState(msg)
    ---@type GetGuildRedEnvelopeInfoRes
    local l_info = ParseProtoBufToTable("GetGuildRedEnvelopeInfoRes", msg)

    if l_info.error_code == 0 then
        --这边做成列表形式以便以后扩展
        for i = 1, #l_info.guild_red_envelope_info do
            local l_red = l_info.guild_red_envelope_info[i]
            if l_red.is_finished or l_red.is_received then
                --红包如果已经领完 则请求领取结果
                ReqGetRedEnvelopeResultRecord(l_red.guild_red_envelope_id)
                --通知聊天框修改數據
                DataMgr:GetData("ChatData").ModificationChat(function(chatMsg)
                    if chatMsg.RedEnvelope and tostring(chatMsg.RedEnvelope.redId) == tostring(l_red.guild_red_envelope_id) then
                        chatMsg.RedEnvelope.isRecived = true
                        return true
                    end
                end)
            elseif not l_red.is_received then
                --红包没有被领完并且自己没领过 
                --口令红包展示解锁界面 手气红包直接请求领取
                if l_red.red_envelope_type == RED_TYPE.PASSWORD then
                    ShowRedEnvelope_Unlock(l_red.guild_red_envelope_id, l_red.words)
                else
                    ReqGetRedEnvelope(l_red.guild_red_envelope_id)
                end
            end
            break
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        UIMgr:DeActiveUI(UI.CtrlNames.RedEnvelope)
    end
end

--请求抢红包
--redId  红包ID
--pwassword  口令
function ReqGetRedEnvelope(redId, pwassword)
    --防连点检测
    if not CanOpenRed then return end
    CanOpenRed = false

    local l_msgId = Network.Define.Rpc.GrabGuildRedEnvelope
    ---@type GrabGuildRedEnvelopeArg
    local l_sendInfo = GetProtoBufSendTable("GrabGuildRedEnvelopeArg")
    
    l_sendInfo.guild_red_envelope_id = redId
    l_sendInfo.guild_red_envelope_password = pwassword or ""

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收请求抢红包的结果
function OnReqGetRedEnvelope(msg)
    ---@type GrabGuildRedEnvelopeRes
    local l_info = ParseProtoBufToTable("GrabGuildRedEnvelopeRes", msg)
    CanOpenRed = true  --重置可打开红包标志
    if l_info.error_code == 0 then
        --展示抢红包结果界面
        ShowRedEnvelope_Get(l_info.grab_guild_red_envelope_info, l_info.grab_guild_red_envelope_list)
        --事件通知公会内红包列表刷新
        EventDispatcher:Dispatch(ON_OPEN_REDENVELOPE, l_info.grab_guild_red_envelope_info)
        --通知聊天框修改數據
        DataMgr:GetData("ChatData").ModificationChat(function(chatMsg)
            if chatMsg.RedEnvelope and tostring(chatMsg.RedEnvelope.redId) == tostring(l_info.grab_guild_red_envelope_info.guild_red_envelope_id) then
                chatMsg.RedEnvelope.isRecived = true
                return true
            end
        end)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求获取红包的获取结果记录
--redId  红包ID
function ReqGetRedEnvelopeResultRecord(redId)
    --防连点检测
    if not CanOpenRed then return end
    CanOpenRed = false
    
    local l_msgId = Network.Define.Rpc.GetGuildRedEnvelopeResult
    ---@type GetGuildRedEnvelopeResultArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildRedEnvelopeResultArg")
    l_sendInfo.red_envelope_id = redId

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收红包的获取结果记录
function OnReqGetRedEnvelopeResultRecord(msg)
    ---@type GetGuildRedEnvelopeResultRes
    local l_info = ParseProtoBufToTable("GetGuildRedEnvelopeResultRes", msg)
    CanOpenRed = true  --重置可打开红包标志
    if l_info.error_code == 0 then
        ShowRedEnvelope_Get(l_info.guild_red_envelope_info, l_info.grab_guild_red_envelope_result)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

------------------------------PRC  END------------------------------------------

---------------------------以下是服务器推送 PTC------------------------------------
--接收红包的推送
function OnSendRedEnvelopeNtf(redEnvelopeInfo,playerInfo)
    -----@type GuildRedEnvelopeInfo
    --local l_info = ParseProtoBufToTable("GuildRedEnvelopeInfo", msg)

    local l_info = redEnvelopeInfo

    -- 调试用 暂时保留
    -- logGreen("l_info.guild_red_envelope_id  "..tostring(l_info.guild_red_envelope_id))
    -- logGreen("l_info.sender_role_id  "..tostring(l_info.sender_role_id))
    -- logGreen("l_info.sender_role_name  "..tostring(l_info.sender_role_name))
    -- logGreen("l_info.red_envelope_type  "..tostring(l_info.red_envelope_type))
    -- logGreen("l_info.red_envelope_total_num  "..tostring(l_info.red_envelope_total_num))
    -- logGreen("l_info.is_received  "..tostring(l_info.is_received))
    -- logGreen("l_info.is_finished  "..tostring(l_info.is_finished))
    -- logGreen("l_info.words  "..tostring(l_info.words))

    --数据结构体
    local l_redInfo = {
        senderId = l_info.sender_role_id,  --发送者的UID
        redId = l_info.guild_red_envelope_id,  --红包ID
        redType = l_info.red_envelope_type,  --红包类型  这个是枚举 在最上面申明
        isRecived = l_info.is_received or false,  --是否已经被自己领取
        redMsg = l_info.words or "",  --红包寄语/红包口令（具体是什么根据类型来定）
    }
    --简易对话框的文字获取
    local l_redTypeName = ""
    if l_redInfo.redType == RED_TYPE.PASSWORD then
        l_redTypeName = Lang("PASSWORD_RED_ENVELOPE")
    elseif l_redInfo.redType == RED_TYPE.LUCKY then
        l_redTypeName = Lang("LUCK_RED_ENVELOPE")
    end
    local l_msgContent = Lang("SOMEONE_SEND_A_RED_ENVELOPE", l_info.sender_role_name or "", l_redTypeName)
    --判断自己还是别人显示聊天框内的显示
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr=DataMgr:GetData("ChatData")
    if tostring(MPlayerInfo.UID) == tostring(l_info.sender_role_id) then
        --自己
        l_chatMgr.BoardCastMsg({
            channel = l_chatDataMgr.EChannel.GuildChat,
            lineType = l_chatDataMgr.EChatPrefabType.RedEnvelopeSelf,
            content = l_msgContent,
            showInMainChat = true,
            RedEnvelope = l_redInfo,
        })
    elseif playerInfo then
        --别人
        l_chatMgr.BoardCastMsg({
            channel = l_chatDataMgr.EChannel.GuildChat,
            lineType = l_chatDataMgr.EChatPrefabType.RedEnvelopeOther,
            content = l_msgContent,
            showInMainChat = true,
            playerInfo = playerInfo,
            RedEnvelope = l_redInfo,
        })
    else
        --别人
        MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(l_info.sender_role_id, function(obj)
            OnSendRedEnvelopeNtf(redEnvelopeInfo,obj)
        end)
    end

end

--接收某人成功领取口令红包后聊天消息
function OnSendRenEnvelopePasswordNtf(msg)
    ---@type RedEnvelopePassword
    local l_info = ParseProtoBufToTable("RedEnvelopePassword", msg)

    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr=DataMgr:GetData("ChatData")
    if tostring(MPlayerInfo.UID) == tostring(l_info.role_id) then
        --自己
        l_chatMgr.BoardCastMsg({
            channel = l_chatDataMgr.EChannel.GuildChat,
            lineType = l_chatDataMgr.EChatPrefabType.Self,
            content = l_info.password,
            showInMainChat = true,
        })
    else
        --别人
        MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(l_info.role_id, function(obj)
            l_chatMgr.BoardCastMsg({
                channel = l_chatDataMgr.EChannel.GuildChat,
                lineType = l_chatDataMgr.EChatPrefabType.Other,
                content = l_info.password,
                showInMainChat = true,
                playerInfo = obj,
            })
        end)
    end

end

return RedEnvelopeMgr

------------------------------PTC  END------------------------------------------

