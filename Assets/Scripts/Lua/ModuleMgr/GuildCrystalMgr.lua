---
--- Created by cmd(TonyChen) detach from GuildMgr.  
--- DateTime: 2019/02/23 17:08
---
---@module ModuleMgr.GuildCrystalMgr
module("ModuleMgr.GuildCrystalMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--公会华丽水晶信息获取事件
ON_GET_GUILD_CRYSTAL_INFO = "ON_GET_GUILD_CRYSTAL_INFO"
--公会华丽水晶标签页切换
ON_SWITCH_CRYSTAL_HANDLER = "ON_SWITCH_CRYSTAL_HANDLER"
--公会华丽水晶界面水晶点击选择事件
ON_SELECT_CRYSTAL = "ON_SELECT_CRYSTAL"
--公会华丽水晶界面取消选中事件
ON_CANCEL_SELECT_CRYSTAL = "ON_CANCEL_SELECT_CRYSTAL"
--公会华丽水晶祈福事件
ON_GUILD_CRYSTAL_PARY = "ON_GUILD_CRYSTAL_PARY"
--公会华丽水晶充能事件
ON_GUILD_CRYSTAL_CHARGE = "ON_GUILD_CRYSTAL_CHARGE"
--公会华丽水晶快速升级时间
ON_GUILD_CRYSTAL_QUICK_UPDATE = "ON_GUILD_CRYSTAL_QUICK_UPDATE"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")

--公会水晶祈福消耗类型记录（需求是每次登录才会重置）0普通消耗 1公会贡献消耗
guildCrystalPrayCostType = 0
--当前选中的标签页编号 0祈福 1研究
curShowHandlerId = 0  

--登出时初始化相关信息
function OnLogout()
    guildCrystalPrayCostType = 0
end

--切换华丽水晶标签页
--handlerId 标签页编号 0祈福 1研究
function SwitchCrystalHandler(handlerId)
    curShowHandlerId = handlerId
    EventDispatcher:Dispatch(ON_SWITCH_CRYSTAL_HANDLER)
end


--水晶选中效果
--crystalId  水晶ID 大于0则为选中一个水晶 否则则表示取消选中
function SelectOneCrystal(crystalId)
    if crystalId > 0 then
        EventDispatcher:Dispatch(ON_SELECT_CRYSTAL, crystalId)
    else
        EventDispatcher:Dispatch(ON_CANCEL_SELECT_CRYSTAL)
    end
end

function GetCrystalBuffTimerTime(time)
    local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(time)
    --秒数不为0 则补1分钟
    if l_second > 0 then l_minuite = l_minuite + 1 end
    if l_minuite >= 60 then
        l_minuite = 0
        l_hour = l_hour + 1
    end
    if l_hour >= 24 then
        l_hour = 0
        l_day = l_day + 1
    end
    return l_day, l_hour, l_minuite
end



--------------------------以下是服务器交互PRC------------------------------------------
--请求获取公会华丽水晶信息
function ReqGetGuildCrystalInfo()
    local l_msgId = Network.Define.Rpc.GuildCrystalGetInfo
    ---@type GuildCrystalGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器传回的华丽水晶信息
function OnReqGetGuildCrystalInfo(msg)
    ---@type GuildCrystalGetInfoRes
    local l_info = ParseProtoBufToTable("GuildCrystalGetInfoRes", msg)

    if l_info.error_code == 0 then
        --华丽水晶数据设置
        l_guildData.SetGuildCrystalInfo(l_info.all_info)
        --通知界面
        EventDispatcher:Dispatch(ON_GET_GUILD_CRYSTAL_INFO)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求研究华丽水晶
function ReqGuildCrystalStudy(crystalId)
    local l_msgId = Network.Define.Rpc.GuildCrystalLearn
    ---@type GuildCrystalLearnArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalLearnArg")
    l_sendInfo.id = crystalId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的请求研究华丽水晶结果
function OnReqGuildCrystalStudy(msg, arg)
    ---@type GuildCrystalLearnRes
    local l_info = ParseProtoBufToTable("GuildCrystalLearnRes", msg)

    if l_info.error_code == 0 then
        local l_row = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(arg.id)
        if l_row then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SET_STUDY_SUCCESS", Lang(l_row.CrystalName)))
        end
        ReqGetGuildCrystalInfo()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求华丽水晶快速升级
function ReqGuildCrystalQuickUpgrade(crystalId)
    local l_msgId = Network.Define.Rpc.GuildCrystalQuickUpgrade
    ---@type GuildCrystalQuickUpgradeArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalQuickUpgradeArg")
    l_sendInfo.id = crystalId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的请求华丽水晶快速升级结果
function OnReqGuildCrystalQuickUpgrade(msg)
    ---@type GuildCrystalQuickUpgradeRes
    local l_info = ParseProtoBufToTable("GuildCrystalQuickUpgradeRes", msg)

    if l_info.error_code == 0 then
        OnUpgradeSuccess()
    else
        if l_info.error_code == ErrorCode.ERR_IN_PAYING then
            game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.GuildCrystalQuickUpgrade, OnUpgradeSuccess)
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        EventDispatcher:Dispatch(ON_GUILD_CRYSTAL_QUICK_UPDATE)
    end
end

function OnUpgradeSuccess()

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("QUICK_UPGRADE_SUCCESS"))
    ReqGetGuildCrystalInfo()
    EventDispatcher:Dispatch(ON_GUILD_CRYSTAL_QUICK_UPDATE)
end

--请求华丽水晶祈福
--crystalId  水晶ID 为0表示不指定
function ReqGuildCrystalPray(crystalId)
    local l_msgId = Network.Define.Rpc.GuildCrystalPray
    ---@type GuildCrystalPrayArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalPrayArg")
    l_sendInfo.id = crystalId
    l_sendInfo.cost_type = guildCrystalPrayCostType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的请求华丽水晶祈福结果
function OnReqGuildCrystalPray(msg)
    ---@type GuildCrystalPrayRes
    local l_info = ParseProtoBufToTable("GuildCrystalPrayRes", msg)

    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PRAY_SUCCESS"))
        l_guildData.guildCrystalInfo.buffAttrList = l_info.attr_list
        l_guildData.guildCrystalInfo.buffLeftTime = l_info.buff_left_time
        EventDispatcher:Dispatch(ON_GUILD_CRYSTAL_PARY, true)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        EventDispatcher:Dispatch(ON_GUILD_CRYSTAL_PARY, false)
    end
end

--请求华丽水晶充能
--chargeType 充能类型 0免费充能  1付费充能
function ReqGuildCrystalCharge(chargeType)
    local l_msgId = Network.Define.Rpc.GuildCrystalGiveEnergy
    ---@type GuildCrystalGiveEnergyArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalGiveEnergyArg")
    l_sendInfo.type = chargeType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的请求华丽水晶充能结果
function OnReqGuildCrystalCharge(msg)
    ---@type GuildCrystalGiveEnergyRes
    local l_info = ParseProtoBufToTable("GuildCrystalGiveEnergyRes", msg)

    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHARGE_SUCCESS"))
        ReqGetGuildCrystalInfo()
        EventDispatcher:Dispatch(ON_GUILD_CRYSTAL_CHARGE)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求确认华丽水晶充能公告是否有效
--announceId 充能公告的UID
function ReqCheckCrystalChargeAnnounce(announceId)
    local l_msgId = Network.Define.Rpc.GuildCrystalCheckAnnounce
    ---@type GuildCrystalCheckAnnounceArg
    local l_sendInfo = GetProtoBufSendTable("GuildCrystalCheckAnnounceArg")
    l_sendInfo.announce_id = announceId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器发回的请求华丽水晶充能结果
function OnReqCheckCrystalChargeAnnounce(msg)
    ---@type GuildCrystalCheckAnnounceRes
    local l_info = ParseProtoBufToTable("GuildCrystalCheckAnnounceRes", msg)

    if l_info.error_code == 0 then
        --有效的话直接前往华丽水晶
        MgrMgr:GetMgr("GuildMgr").GuildFindPath_FuncId(DataMgr:GetData("GuildData").EGuildFunction.GuildCrystal)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------

--公会水晶升级推送
function OnGuildCrystalUpgradeNotify(msg)
    ---@type GuildCrystalAllInfo
    local l_info = ParseProtoBufToTable("GuildCrystalAllInfo", msg)

    --华丽水晶数据设置
    l_guildData.SetGuildCrystalInfo(l_info)
    --通知界面
    EventDispatcher:Dispatch(ON_GET_GUILD_CRYSTAL_INFO)

end

------------------------------PTC  END------------------------------------------



-------------  红点相关  -----------------
--公会华丽水晶1级提示红点
function CheckOneLvRedSignMethod()
    --获取华丽水晶等级
    local l_guildCrystalInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal)
    local l_guildCrystalLv = l_guildCrystalInfo and l_guildCrystalInfo.level or 0
    if l_guildCrystalLv == 1 then
        --获取记录的点击过的华丽水晶1级红点的公会的ID
        local l_recordGuildId = UserDataManager.GetStringDataOrDef(l_guildData.GUILD_CRYSTAL_ONE_LEVEL_RED, MPlayerSetting.PLAYER_SETTING_GROUP, "")
        if tostring(l_guildData.selfGuildMsg.id) ~= l_recordGuildId then
            return 1
        end
    end
    return 0
end
------------- END 红点相关  -----------------