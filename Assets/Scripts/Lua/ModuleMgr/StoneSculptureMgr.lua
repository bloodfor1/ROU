---@module ModuleMgr.StoneSculptureMgr
module("ModuleMgr.StoneSculptureMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
Event = {
    StoneData = "StoneData", --原石信息
    HelperData = "HelperData", --帮助者名单
}

StoneData = {}  --原石进度
chooseId = {}   --已选中的晶石分配
chooseNum = 0   --已选中的晶石分配数量
StoneHelpData = {}  --原石帮助信息
ProgressMax = 0 --雕刻上限
RawGemstoneID = 0 --原石ID
UnitySculptureID = 0 --组织团结力ID  这个值好像没用了 cmd注 
RawGemstoneTimeCd = 60000 --原石链接有效时间
StoneCarveHelpLimitDay = 15  --记录别人帮助自己雕琢纪念原石次数的天数上限
StoneCarveGoodManTime = 5  --玩家互帮互助（笑脸）出现的次数下限
PerfectStoneNum = 0  --纪念原石雕琢成精致的纪念币的次数
StoneHelpOtherCount = 0  --纪念原石每日每人帮助别人雕琢次数上限
StoneGiftPerNum = 0     --每个精致纪念币可获得的纪念晶石奖励数量

DetailIsNow = true      --当前记录是否是本次记录
StoneGiftNowChoose = 0  --当前玩家已经选择的晶石分配个数
local l_guildData = DataMgr:GetData("GuildData")

function OnInit()

    ProgressMax = MGlobalConfig:GetInt("SouvenirStoneCarveSuccessTime")
    PerfectStoneNum = MGlobalConfig:GetInt("SouvenirStoneSublimationTime")
    RawGemstoneTimeCd = 999999 * 60--MGlobalConfig:GetFloat("SouvenirStoneTimeCd") * 60     目前不再有CD，需求有可能会改
    StoneCarveHelpLimitDay = MGlobalConfig:GetInt("SouvenirStoneCarveHelpLimitDay")
    StoneCarveGoodManTime = MGlobalConfig:GetInt("SouvenirStoneCarveGoodManTime")
    StoneHelpOtherCount = MGlobalConfig:GetInt("SouvenirStoneCarveTimeHelpOher")
    local l_tb = MGlobalConfig:GetSequenceOrVectorInt("SouvenirStoneSparIDAndNum")
    if l_tb and l_tb[1] then
        StoneGiftPerNum = l_tb[1]
    end

end
---------------------------------function

--帮助雕刻
function TryHelp(rid)
    local l_openData = {
        type = l_guildData.EUIOpenType.GuildStone,
        roleId = rid
    }

    UIMgr:DeActiveUI(UI.CtrlNames.GuildStoneDetail)
    UIMgr:ActiveUI(UI.CtrlNames.GuildStone, l_openData)
end

---------------------------------协议
--请求-获取公会原石数据
function SendGetCobblestoneInfo(rid)

    local l_msgId = Network.Define.Rpc.GetCobblestoneInfo
    ---@type GetCobblestoneInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetCobblestoneInfoArg")
    l_sendInfo.role_id = rid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnGetCobblestoneInfo(msg, arg)

    ---@type GetCobblestoneInfoRes
    local l_resInfo = ParseProtoBufToTable("GetCobblestoneInfoRes", msg)
    if l_resInfo.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error))
        StoneData.roleId = -1
        EventDispatcher:Dispatch(Event.StoneData)           --请求数据失败就关掉UI
        return
    end
    StoneData.curInfo = l_resInfo.carve_info.cur_carve_info         --当前被帮助记录
    StoneData.allInfo = l_resInfo.carve_info.his_carve_info         --总共被帮助记录
    StoneData.roleId = arg.role_id                                  --当前原石归属
    StoneData.price = l_resInfo.carve_info.souvenir_crystal_num                --可分配的纪念晶石个数
    StoneData.coin = l_resInfo.carve_info.souvenir_coin_num                    --纪念币个数
    StoneData.love = l_resInfo.carve_info.helpe_other_times                    --帮助他人次数
    StoneData.hasCarved = l_resInfo.can_still_carve                        --这个原石是否已经消耗本次雕琢
    StoneData.hasGiftNormal = l_resInfo.carve_info.is_stone_award_received            --纪念币奖励是否已经领取
    StoneData.hasGiftPerfect = l_resInfo.carve_info.is_souvenir_stone_award_received  --精致纪念币奖励是否已经领取
    StoneData.cd = l_resInfo.carve_info.to_tomorrow_five_time
    StoneData.show = l_resInfo.carve_info.show_roles

    StoneData.count = 0
    for i = 1, #StoneData.curInfo do
        StoneData.count = StoneData.count + #StoneData.curInfo[i].carve_time        --当前原石进度
    end
    if StoneData.count > ProgressMax then
        StoneData.count = ProgressMax
        logError("服务器发送的原石数据错误！，雕刻次数超过配置")
    end
    EventDispatcher:Dispatch(Event.StoneData)

end

--请求-雕刻原石
function SendCarveStone(rid)

    local l_msgId = Network.Define.Rpc.CarveStone
    ---@type CarveStoneArg
    local l_sendInfo = GetProtoBufSendTable("CarveStoneArg")
    l_sendInfo.be_helped_role_id = rid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnCarveStone(msg, arg)

    ---@type CarveStoneRes
    local l_resInfo = ParseProtoBufToTable("CarveStoneRes", msg)
    if l_resInfo.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error))
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Stone_CarveHint"))--"雕刻成功"
    SendGetCobblestoneInfo(arg.be_helped_role_id)

end

--请求-公会原石雕刻求助
function SendAskForCarveStone()

    local l_msgId = Network.Define.Rpc.AskForCarveStone
    ---@type AskForCarveStoneArg
    local l_sendInfo = GetProtoBufSendTable("AskForCarveStoneArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnAskForCarveStone(msg)

    ---@type AskForCarveStoneRes
    local l_resInfo = ParseProtoBufToTable("AskForCarveStoneRes", msg)
    if l_resInfo.error and l_resInfo.error.errorno ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error.errorno))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Stone_HelpHint"))--发送成功

    UIMgr:DeActiveUI(UI.CtrlNames.GuildStone)
    UIMgr:DeActiveUI(UI.CtrlNames.Guild)
    local l_openParam = {
        changeToChannel = DataMgr:GetData("ChatData").EChannel.GuildChat,
        needChangeToCurrentChannel = true
    }
    UIMgr:ActiveUI(UI.CtrlNames.Chat, l_openParam)

end

--请求-公会原石雕刻求助特定某个玩家
function SendAskForPersonalCarveStone(roleId)

    local l_msgId = Network.Define.Rpc.AskForPersonalCarveStone
    ---@type AskForPersonalCarveStoneArg
    local l_sendInfo = GetProtoBufSendTable("AskForPersonalCarveStoneArg")
    l_sendInfo.role_id = roleId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnAskForPersonalCarveStone(msg, arg)

    ---@type AskForPersonalCarveStoneRes
    local l_resInfo = ParseProtoBufToTable("AskForPersonalCarveStoneRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Stone_HelpHint"))--发送成功
    SendGetCobblestoneInfo(MPlayerInfo.UID)
    local l_guildId = DataMgr:GetData("GuildData").selfGuildMsg.id
    local l_time = RawGemstoneTimeCd + MServerTimeMgr.UtcSeconds
    local l_st = Lang("Stone_HelpTag")          --"帮助雕刻"
    local l_linkSt, l_linkPack = MgrMgr:GetMgr("LinkInputMgr").GetStonSculpturePack(nil, l_guildId, 0, l_time, MPlayerInfo.UID, l_st)
    local l_chatMgr = MgrMgr:GetMgr("FriendMgr")
    l_chatMgr.RequestSendPrivateChatMsg(
            arg.role_id, Lang("Stone_HelpChat_Solo") .. l_linkSt, l_linkPack, true--帮我雕琢一下纪念原石吧
    )


end

--请求公会晶石分配信息
function GetGuildStoneHelper()

    local l_msgId = Network.Define.Rpc.GetGuildStoneHelper
    ---@type GetGuildStoneHelperArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildStoneHelperArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnGetGuildStoneHelper(msg)

    ---@type GetGuildStoneHelperRes
    local l_resInfo = ParseProtoBufToTable("GetGuildStoneHelperRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
        return
    end
    StoneHelpData.helper = l_resInfo.helpers
    StoneHelpData.giftNum = l_resInfo.rest_souvenir_crystal_num
    EventDispatcher:Dispatch(Event.HelperData)

end

--请求-制作原石
function SendMakeStone()

    local l_msgId = Network.Define.Rpc.MakeStone
    ---@type MakeStoneArg
    local l_sendInfo = GetProtoBufSendTable("MakeStoneArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnMakeStone(msg)

    ---@type MakeStoneRes
    local l_resInfo = ParseProtoBufToTable("MakeStoneRes", msg)
    if l_resInfo.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error))
        return
    end
    SendGetCobblestoneInfo(MPlayerInfo.UID)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STONE_PASS", 1))

end

--请求-制作精致原石
function SendMakeSouvenirStone()

    local l_msgId = Network.Define.Rpc.MakeSouvenirStone
    ---@type MakeSouvenirStoneARG
    local l_sendInfo = GetProtoBufSendTable("MakeSouvenirStoneARG")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnMakeSouvenirStone(msg)

    ---@type MakeSouvenirStoneRes
    local l_resInfo = ParseProtoBufToTable("MakeSouvenirStoneRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
        return
    end
    SendGetCobblestoneInfo(MPlayerInfo.UID)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PERFECT_STONE_PASS", 1, StoneGiftPerNum))
    --获得了{0}个精致的纪念币、纪念纹章和{1}个纪念晶石，去纪念币界面分配吧
    GetGuildStoneHelper()

end

--收到公会其他人的雕刻求助
function OnCobbleStoneHelp(msg)

    ---@type CobbleStoneHelpData
    local l_resInfo = ParseProtoBufToTable("CobbleStoneHelpData", msg)
    local l_guildId = DataMgr:GetData("GuildData").selfGuildMsg.id
    local l_rid = l_resInfo.role_id
    local l_time = RawGemstoneTimeCd + MServerTimeMgr.UtcSeconds
    local l_st = Lang("Stone_HelpTag")          --"帮助雕刻"
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_linkSt, l_linkPack = MgrMgr:GetMgr("LinkInputMgr").GetStonSculpturePack(nil, l_guildId, 0, l_time, l_rid, l_st)
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    l_chatMgr.DoHandleMsgNtf(
            l_rid, l_chatDataMgr.EChannel.GuildChat, Lang("Stone_HelpChat") .. l_linkSt, --我有一个神秘原石，请大家帮我雕琢一下
            "StoneLink", nil, true, { MsgParam = l_linkPack }
    )

end

--收到公会其他人帮我雕刻成功
function OnCobblleStoneCarvedNtf(msg)

    ---@type CobblleStoneCarvedNtfData
    local l_resInfo = ParseProtoBufToTable("CobblleStoneCarvedNtfData", msg)
    if tostring(MPlayerInfo.UID) ~= tostring(l_resInfo.carver_uid) then
        SendGetCobblestoneInfo(MPlayerInfo.UID)            --如果是自己雕刻自己的原石就没必要再请求一次了
    end

    --自己雕刻不显示提示
    if tostring(MPlayerInfo.UID) ~= tostring(l_resInfo.carver_uid) then
        local l_mgr = MgrMgr:GetMgr("ChatMgr")
        local l_chatDataMgr = DataMgr:GetData("ChatData")
        l_mgr.BoardCastMsg({
            channel = l_chatDataMgr.EChannel.GuildChat,
            lineType = l_chatDataMgr.EChatPrefabType.Hint,
            content = StringEx.Format(Lang("Stone_Help_Hint"), l_resInfo.carver_name), --{0}帮你雕琢了原石
        })
    end

end

--公会晶石
function AssignSouvenirCrystal(roleIdList)

    local l_msgId = Network.Define.Rpc.AssignSouvenirCrystal
    ---@type AssignSouvenirCrystalArg
    local l_sendInfo = GetProtoBufSendTable("AssignSouvenirCrystalArg")
    for i = 1, #roleIdList do
        l_sendInfo.role_list[i] = roleIdList[i]
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnAssignSouvenirCrystal(msg)

    ---@type AssignSouvenirCrystalRes
    local l_resInfo = ParseProtoBufToTable("AssignSouvenirCrystalRes", msg)
    local l_isSuccess = true
    GetGuildStoneHelper()           --重新请求一次公会晶石信息
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
        l_isSuccess = false
    end
    if l_resInfo.role_not_same_guild and #l_resInfo.role_not_same_guild > 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GuildStone_Share_NotGuildPeople"))
        l_isSuccess = false
    end
    if l_isSuccess then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GIFTSTONE_SUCCESS"))
    end

end

return StoneSculptureMgr