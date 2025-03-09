---
--- Created by cmd(TonyChen) detach from GuildMgr. 
--- DateTime: 2019/02/25 19:22
---
---@module GuildSDKMgr
module("ModuleMgr.GuildSDKMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--公会群状态展示事件
ON_SHOW_GUILD_GROUP_STATUS = "ON_SHOW_GUILD_GROUP_STATUS"
--从后台切回游戏事件
ON_GET_BACK_GAME_TO_REFRESH = "ON_GET_BACK_GAME_TO_REFRESH"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")

function OnInit()
    --公会绑群SDK回调
    GlobalEventBus:Add(EventConst.Names.WXQueryGroupStatusEvent, OnGetGuildGroupStatus_WX)
    GlobalEventBus:Add(EventConst.Names.QQQueryGroupStatusEvent, OnReqGuildGroupBindInfo_QQ)
    GlobalEventBus:Add(EventConst.Names.QQQueryGroupInfoEvent, OnReqCheckGuildGroupSelfState_QQ)
    GlobalEventBus:Add(EventConst.Names.GuildGroupCreatEvent, OnReqCreateGuildGroup)
    GlobalEventBus:Add(EventConst.Names.GuildGroupJoinEvent, OnReqJoinGuildGroup)
    GlobalEventBus:Add(EventConst.Names.GuildGroupUnbindEvent, OnReqUnbindGuildGroup)
    GlobalEventBus:Add(EventConst.Names.GuildGroupRemindLeaderEvent, OnReqRemindChairmanCreateGroup)
    --后台返回的回调
    GlobalEventBus:Add(EventConst.Names.GetBackGame, OnGetBackGame)
end

function OnUnInit()
    --公会绑群SDK回调
    GlobalEventBus:Remove(EventConst.Names.WXQueryGroupStatusEvent, OnGetGuildGroupStatus_WX)
    GlobalEventBus:Remove(EventConst.Names.QQQueryGroupStatusEvent, OnReqGuildGroupBindInfo_QQ)
    GlobalEventBus:Remove(EventConst.Names.QQQueryGroupInfoEvent, OnReqCheckGuildGroupSelfState_QQ)
    GlobalEventBus:Remove(EventConst.Names.GuildGroupCreatEvent, OnReqCreateGuildGroup)
    GlobalEventBus:Remove(EventConst.Names.GuildGroupJoinEvent, OnReqJoinGuildGroup)
    GlobalEventBus:Remove(EventConst.Names.GuildGroupUnbindEvent, OnReqUnbindGuildGroup)
    GlobalEventBus:Remove(EventConst.Names.GuildGroupRemindLeaderEvent, OnReqRemindChairmanCreateGroup)
    --后台返回的回调
    GlobalEventBus:Remove(EventConst.Names.GetBackGame, OnGetBackGame)
end



--从后台切回游戏的回调
function OnGetBackGame()
    --logGreen("get back mgr")
    EventDispatcher:Dispatch(ON_GET_BACK_GAME_TO_REFRESH)
end


----------------------- RPC ------------------------------


--请求绑定QQ群
function ReqBindQQGroup()
    local l_msgId = Network.Define.Rpc.GuildBinding
    ---@type GuildBindingArg
    local l_sendInfo = GetProtoBufSendTable("GuildBindingArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收是否可以绑定QQ群的结果
function OnReqBindQQGroup(msg)
    ---@type GuildBindingRes
    local l_info = ParseProtoBufToTable("GuildBindingRes", msg)

    if l_info.result == 0 then
        ReqCreateGuildGroup_QQ()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--请求提醒会长绑定公会群
function ReqRemindChairmanToBindGroup()
    local l_msgId = Network.Define.Rpc.GuildBindingRemind
    ---@type GuildBindingRemindArg
    local l_sendInfo = GetProtoBufSendTable("GuildBindingRemindArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取请求提醒会长绑定公会群的回调
function OnReqRemindChairmanToBindGroup(msg)
    ---@type GuildBindingRemindRes
    local l_info = ParseProtoBufToTable("GuildBindingRemindRes", msg)

    if l_info.result == 0 then
        ReqRemindChairmanCreateGroup(l_info.chairman_account, tostring(l_info.chairman_uid))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

------------------ end RPC-------------------------------

----------------------- PTC ------------------------------

function OnSelectRoleNtf(info)

    OnReqServerInfo(info.brief)
end

--接收服务器的相关数据  --暂时是固定值selectRole返回数据
function OnReqServerInfo(roleBrief)
    l_guildData.zoneId = tostring(roleBrief.server_id)
    --logGreen("l_guildData.zoneId  "..tostring(l_guildData.zoneId).."      --Guild Group Msg")
    l_guildData.areaId = "1"
    if l_guildData.zoneId == "8002" then 
        l_guildData.areaId = "992" 
    elseif l_guildData.zoneId == "8004" then 
        l_guildData.areaId = "994" 
    end
end

--通知服务器绑群成功
function NoticeGroupBindSuccess()
    local l_msgId = Network.Define.Ptc.GuildBindingNtf
    ---@type GuildBindingData
    local l_sendInfo = GetProtoBufSendTable("GuildBindingData")

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

------------------  end PTC -------------------------------

------------------------------------以下是SDK请求--------------------------------------------------
--请求公会群绑定信息
function ReqGuildGroupBindInfo()
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_Weixin then
            --微信平台
            --logGreen("enter ReqGuildGroupBindInfo WX  --Guild Group Msg")
            l_guildData.WXCallBackType = 0
            MLogin.WXQueryGroupStatus(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                type = 0
            }))

        elseif l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台
            MLogin.QQQueryGroupStatus(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                zoneid = l_guildData.zoneId
            }))
        end
    end
end

--请求确认自己是否加入公会群
function ReqCheckGuildGroupSelfState()
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_Weixin then
            --微信平台
            --logGreen("enter ReqCheckGuildGroupSelfState WX  --Guild Group Msg")
            l_guildData.WXCallBackType = 1
            MLogin.WXQueryGroupStatus(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                type = 1
            }))

        elseif l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台
            MLogin.QQQueryGroupInfo(CJson.encode({groupid = l_guildData.guildGroupId_QQ}))
        end
    end
end

--请求创建公会群
function ReqCreateGuildGroup()
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_Weixin then
            --微信平台
            --logGreen("enter ReqCreateGuildGroup WX  --Guild Group Msg")
            MLogin.WXCreatGroup(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                chatroomname = l_guildData.selfGuildMsg.name,
                chatroomnickname = MPlayerInfo.Name
            }))

        elseif l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台
            ReqBindQQGroup()  --QQ先请求服务器 判断今天是否可以绑群
        end
    end
end

--请求创建公会群 QQ
function ReqCreateGuildGroup_QQ()
    
    --logGreen("enter ReqCreateGuildGroup QQ  --Guild Group Msg")
    local l_args = {}
    table.insert(l_args, tostring(l_guildData.selfGuildMsg.id))  -- unionId
    table.insert(l_args, l_guildData.selfGuildMsg.name)  -- unionName
    table.insert(l_args, l_guildData.zoneId)  -- l_guildData.zoneId
    table.insert(l_args, MPlayerInfo.UID:tostring())  -- roleId
    table.insert(l_args, l_guildData.areaId)  -- areaId
    table.insert(l_args, "")  -- partition
    local l_argsStr = table.concat(l_args, "|")
    MLogin.QQCreatGroup(CJson.encode({argsstr = l_argsStr}))
        
end

--请求加入公会群
function ReqJoinGuildGroup()
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_Weixin then
            --微信平台
            --logGreen("enter ReqJoinGuildGroup WX  --Guild Group Msg")
            MLogin.WXJoinGroup(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                chatroomnickname = MPlayerInfo.Name
            }))
        elseif l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台
            --logGreen("enter ReqJoinGuildGroup QQ  --Guild Group Msg")
            local l_args = {}
            table.insert(l_args, l_guildData.guildGroupId_QQ)  -- groupId
            table.insert(l_args, tostring(l_guildData.selfGuildMsg.id))  -- unionId
            table.insert(l_args, l_guildData.zoneId)  -- l_guildData.zoneId
            table.insert(l_args, MPlayerInfo.UID:tostring())  -- roleId
            table.insert(l_args, l_guildData.areaId)  -- areaId
            table.insert(l_args, "")  -- partition
            local l_argsStr = table.concat(l_args, "|")
            MLogin.QQJoinGroup(CJson.encode({argsstr = l_argsStr}))
        end
    end
end

--请求解绑公会群
function ReqUnbindGuildGroup()
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_Weixin then
            --微信平台
            --logGreen("enter ReqUnbindGuildGroup WX  --Guild Group Msg")
            MLogin.WXUnbindGroup(CJson.encode({unionid = tostring(l_guildData.selfGuildMsg.id)}))
        elseif l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台
            --logGreen("enter ReqUnbindGuildGroup QQ  --Guild Group Msg")
            MLogin.QQUnbindGroup(CJson.encode({
                unionid = tostring(l_guildData.selfGuildMsg.id),
                unionname = l_guildData.selfGuildMsg.name,
                zoneid = l_guildData.zoneId,
                areaid = l_areaId
            }))
        end
    end
end

--请求提醒会长创建公会群
--leaderOpenId  会长的OpenId
--leaderRoleId  会长的RoleId
function ReqRemindChairmanCreateGroup(leaderOpenId, leaderRoleId)
    local l_loginret = MLogin.GetLoginData()
    if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
        if l_loginret.platform == EPlatform.ePlatform_QQ then
            --QQ平台  只有QQ可以提醒
            local l_args = {}
            table.insert(l_args, tostring(l_guildData.selfGuildMsg.id))  -- unionId
            table.insert(l_args, l_guildData.zoneId)  -- l_guildData.zoneId
            table.insert(l_args, MPlayerInfo.UID:tostring())  -- roleId
            table.insert(l_args, MPlayerInfo.Name)  -- roleName
            table.insert(l_args, leaderOpenId)  -- leaderOpenId
            table.insert(l_args, leaderRoleId)  -- leaderRoleId
            table.insert(l_args, l_guildData.areaId)  -- areaId
            local l_argsStr = table.concat(l_args, "|")
            MLogin.QQRemindGuildLeader(CJson.encode({argsstr = l_argsStr}))
        end
    end
end


------------------------------------以下是回调--------------------------------------------------

--获取微信公会群信息的回调 
--是否存在公会群 和 是否加入都是这个回调 靠标识符 l_guildData.WXCallBackType 区分）
--l_guildData.WXCallBackType  0 请求是否创建  1请求是否加入  
function OnGetGuildGroupStatus_WX(groupRet)
    --logGreen("get wx state back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnGetGuildGroupStatus_WX Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")
    --微信通过mWXGroupInfo.status来判断，0为未建群、未加群  1为已绑群，已加群
    if l_guildData.WXCallBackType == 0 then
        --是否已创建的回调
        if groupRet.mWXGroupInfo.status == 0 then
            --未绑定
            l_guildData.selfGuildMsg.guildGroupBindState = false
            EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
        else
            --已绑定
            l_guildData.selfGuildMsg.guildGroupBindState = true
            if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
                --会长的话 肯定在群里不需要判定是否已加入
                EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
            else
                --非会长继续请求是否加入
                ReqCheckGuildGroupSelfState()
            end
        end
    else
        --是否已加入的回调
        if groupRet.mWXGroupInfo.status == 0 then
            --未加群
            l_guildData.selfGuildMsg.isJoinedGroup = false
        else
            --已加群
            l_guildData.selfGuildMsg.isJoinedGroup = true
        end
        EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
    end

end

--请求公会群绑定信息回调  QQ
function OnReqGuildGroupBindInfo_QQ(groupRet)
    --logGreen("get qq group state back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqGuildGroupBindInfo_QQ Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    --QQ判断是否有建群 通过结构体中的 qqGroup列表的内容数量判定 有的话取第一个
    l_guildData.selfGuildMsg.guildGroupBindState = false
    l_guildData.guildGroupId_QQ = 0
    EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)

    --logGreen("groupRet.mQQGroupInfoV2._relation  "..tostring(groupRet.mQQGroupInfoV2._relation))
    --logGreen("groupRet.mQQGroupInfoV2._qqGroups[0]._groupId = "..tostring(groupRet.mQQGroupInfoV2._qqGroups[0]._groupId))
    if groupRet.mQQGroupInfoV2._qqGroups[0]._groupId == "" then
        l_guildData.selfGuildMsg.guildGroupBindState = false
        l_guildData.guildGroupId_QQ = 0
        EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
    else
        l_guildData.selfGuildMsg.guildGroupBindState = true
        l_guildData.guildGroupId_QQ = groupRet.mQQGroupInfoV2._qqGroups[0]._groupId
        if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
            --会长的话 肯定在群里不需要判定是否已加入
            EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
        else
            --非会长继续请求是否加入
            ReqCheckGuildGroupSelfState()
        end
    end

end

--请求确认自己是否加入公会群回调  QQ
function OnReqCheckGuildGroupSelfState_QQ(groupRet)
    --logGreen("get qq self state back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqCheckGuildGroupSelfState_QQ Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    --groupRet.mQQGroupInfoV2._relation 1:群主，2:管理员，3:普通成员，4:非成员
    if groupRet.mQQGroupInfoV2._relation == 4 then 
        l_guildData.selfGuildMsg.isJoinedGroup = false
    else
        l_guildData.selfGuildMsg.isJoinedGroup = true
    end

    EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
end

--请求创建公会群回调
function OnReqCreateGuildGroup(groupRet)
    --logGreen("get create back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqCreateGuildGroup Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    if groupRet.errorCode == 0 then
        --成功
        l_guildData.selfGuildMsg.guildGroupBindState = true
        EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CREATE_GUILD_GROUP_SUCCESS"))
        --通知服务器记录绑群时间
        NoticeGroupBindSuccess()
    else
        --失败
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CREATE_FAILED_LATER_TRY"))
    end
end

--请求加入公会群回调
function OnReqJoinGuildGroup(groupRet)
    --logGreen("get join back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqJoinGuildGroup Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    if groupRet.errorCode == 0 then
        --成功
        l_guildData.selfGuildMsg.isJoinedGroup = true
        EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JOIN_GUILD_GROUP_SUCCESS"))
    else
        --失败
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JOIN_FAILED_LATER_TRY"))
    end
end

--请求解绑公会群回调
function OnReqUnbindGuildGroup(groupRet)
    --判断接口是否调用成功
    --logGreen("get unbind back  --Guild Group Msg")
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqUnbindGuildGroup Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    if groupRet.errorCode == 0 then
        --成功
        l_guildData.selfGuildMsg.guildGroupBindState = false
        l_guildData.selfGuildMsg.isJoinedGroup = false
        EventDispatcher:Dispatch(ON_SHOW_GUILD_GROUP_STATUS)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("UNBIND_SUCCESS"))
    else
        --失败
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("UNBIND_FAILED_LATER_TRY"))
    end
end

--请求提醒会长创建公会群回调
function OnReqRemindChairmanCreateGroup(groupRet)
    --logGreen("get remind back  --Guild Group Msg")
    --判断接口是否调用成功
    if groupRet.flag ~= EFlag.eFlag_Succ then
        logError("OnReqRemindChairmanCreateGroup Failed @TonyChen @hanzhenjie ---------------------------------")
        logError(groupRet)
        return
    end
    --logGreen("flag success  --Guild Group Msg")

    if groupRet.errorCode == 0 then
        --成功
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REMIND_GUILD_CHAIRMAN_SUCCESS"))
    else
        --失败
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TODAY_ALREADY_REMIND"))
    end
end


