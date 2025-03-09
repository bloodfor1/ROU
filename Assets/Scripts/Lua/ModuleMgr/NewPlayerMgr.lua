--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.NewPlayerMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
DeadTime = 0
Gift =
{
    now = 0,
    next = 0
}
EventType =
{
    MainInfo = "MainInfo"
}
--lua model end
function OnInit()

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    l_openSystemMgr.EventDispatcher:Add(l_openSystemMgr.OpenSystemUpdate, function(openId)
        CheckGuide(openId)
    end, l_openSystemMg)

end

function UnInit()

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    l_openSystemMgr.EventDispatcher:RemoveObjectAllFunc(l_openSystemMgr.OpenSystemUpdate, l_openSystemMg)

end
--lua custom scripts
function CheckGuide(openIds)

    if openIds and #openIds > 0 then
        local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
        for i = 1, #openIds do
            if openIds[i].value == l_openSystemMgr.eSystemId.NewPlayer then
                MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"AwardGuid"})
            end
        end
    end

end

function GetLeftTime()

    if DeadTime <= 0 then
        return 0
    end
    local result = DeadTime - Common.TimeMgr.GetNowTimestamp()
    if result < 0 then
        result = 0
    end
    return result

end

function GetFormatTime(leftTime)

    local day, t1 = math.modf(leftTime / 86400)
    local hour, t2 = math.modf(t1 * 24)
    local min = math.modf(t2 * 60)
    return StringEx.Format(Lang("Return_Time_Left"), day, hour, min)

end

function OnQueryMengXinLevelGiftInfo(msg)

    ---@type MengXinLevelGiftsData
    local l_info = ParseProtoBufToTable("MengXinLevelGiftsData", msg)
    Gift.now = l_info.gift_id
    DeadTime = l_info.close_time
    EventDispatcher:Dispatch(EventType.MainInfo)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.NewPlayer)

end

function GetMengXinLevelGift(giftID)

    local msgId = Network.Define.Rpc.GetMengXinLevelGift
    ---@type GetMengXinLevelGiftArg
    local sendInfo = GetProtoBufSendTable("GetMengXinLevelGiftArg")
    sendInfo.gift_id = giftID
    Network.Handler.SendRpc(msgId, sendInfo)

end

function OnGetMengXinLevelGift(msg)

    ---@type GetMengXinLevelGiftRes
    local l_info = ParseProtoBufToTable("GetMengXinLevelGiftRes", msg)
    local l_errorCode = l_info.result
    if l_errorCode ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_errorCode)
    end

end

function CheckRedSignMethod()

    if Gift.now == nil or Gift.now == 0 then
        return 0
    end
    return 1

end
--lua custom scripts end
return ModuleMgr.NewPlayerMgr