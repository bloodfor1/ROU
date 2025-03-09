--this file is gen by script
--you can edit this file in custom part
require "ModuleMgr/CommonMsgProcessor"

--lua model
module("ModuleMgr.MonthCardMgr", package.seeall)

--lua model end

--lua custom scripts
EventDispatcher = EventDispatcher.new()

ON_GET_ITEM_REWARD = "ON_GET_ITEM_REWARD"

ON_GET_MONTH_CARD_TEXT = "ON_GET_MONTH_CARD_TEXT"
-- 请求限定礼包内容  
ON_GEI_AWARD_LIMIT = "ON_GEI_AWARD_LIMIT"
--月卡购买成功    
ON_BUY_MONTHCARD_SUCCESS = "ON_BUY_MONTHCARD_SUCCESS"
--限定礼包购买成功 刷新界面
ON_REFRESH_AWARD_PANEL = "ON_REFRESH_AWARD_PANEL"
--收获限定礼包
ON_GET_AWARD_LIMIT = "ON_REFRESH_AWARD_PANEL"
--领取免费小礼物
ON_GET_SMALL_GIFT = "ON_GET_SMALL_GIFT"

local MAGIC_NUM_INT32 = 4294967296

local l_monthCardData = DataMgr:GetData("MonthCardData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
---@type MonthCardExpiredTipsInfo[]
local expiredTipsQue = {}

function OnInit()
    ClearExpiredQue()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:Add(ON_GET_ITEM_REWARD, OnGetMonthCardRewardTxt, self)

    game:GetPayMgr().EventDispatcher:Add(game:GetPayMgr().ON_SDK_PAY_SUCCESS, OnPayMonthCardSuccess, self)

    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    --是否首充
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_VITALE_DATA,
        DetailDataEnum = CommondataId.kCDI_RECHARGE_COUNT,
        Callback = OnSetFirstChargeState,
    })

    --领取赠送小礼包的时间
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_PICK_SMALL_GIFT_PACK_TIME,
        Callback = OnSetPickSmallGift,
    })

    --月卡过期确认
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_MONTH_CARD_EXPIRE_CONFIRM,
        Callback = OnSetMonthCardExpireConfirm,
    })

    --本次月卡激活时间
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_MONTH_CARD,
        DetailDataEnum = 0,
        Callback = OnSetMonthCardActiveTime,
    })

    --本次月卡持续时间
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_MONTH_CARD,
        DetailDataEnum = 1,
        Callback = OnSetMonthCardExistTime,
    })

    l_commonData:Init(l_data)
end

---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    CheckVipExpired()
    CheckNormalRebateExpired()
    CheckSuperRebateExpired()
end

function OnLogout()
    ClearExpiredQue()
end

function OnUnInit()
    ClearExpiredQue()
    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:RemoveObjectAllFunc(ON_GET_ITEM_REWARD, MgrMgr:GetMgr("AwardPreviewMgr"))
end

---显示到期提醒框
---@param markIsFirstFunc function 关闭界面时执行的函数，需自己实现关闭界面的方法，详细使用见本脚本
---@param btnText string 按钮文字
---@param contentText string 说明文字
---@param gotoUIName string 点击前往的界面名字
---@param expiredTime number 到期时间戳
---@param cardType number 月卡类型
function AddExpiredTips(markIsFirstFunc, btnText, contentText, gotoUIName, expiredTime, cardType)
    ---@module MonthCardExpiredTipsInfo
    local l_data = {
        MarkIsFirstFunc = markIsFirstFunc,
        BtnText = btnText,
        ContentText = contentText,
        GotoUIName = gotoUIName,
        ExpiredTime = expiredTime,
        CardType = cardType
    }
    for k, v in pairs(expiredTipsQue) do
        if v.CardType == cardType then
            ShowExpiredTips()
            return
        end
    end
    table.insert(expiredTipsQue, l_data)
    table.sort(expiredTipsQue, function(a, b)
        return a.ExpiredTime > b.ExpiredTime
    end)
end

function PopExpiredTips()
    if #expiredTipsQue > 0 then
        table.remove(expiredTipsQue, 1)
    end
    ShowExpiredTips()
end

function ShowExpiredTips()
    if #expiredTipsQue == 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.MonthCard_TipsPanel)
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.MonthCard_TipsPanel, expiredTipsQue[1])
end

function ClearExpiredQue()
    if #expiredTipsQue ~= 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.MonthCard_TipsPanel)
    end
    expiredTipsQue = {}
end

--是否首充设置
function OnSetFirstChargeState(_, value)
    value = tonumber(value)
    l_monthCardData.l_IsFirstCharge = value > 0
    EventDispatcher:Dispatch(ON_BUY_MONTHCARD_SUCCESS)
end

--领取赠送小礼包的时间
function OnSetPickSmallGift(_, value)
    value = tonumber(value)
    --logError("l_monthCardData.l_PickSmallGiftTime   "..value)
    l_monthCardData.l_PickSmallGiftTime = value
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MonthCard)
    EventDispatcher:Dispatch(ON_GET_SMALL_GIFT)
end

-- 设置月卡的过期确认
function OnSetMonthCardExpireConfirm(_, value)
    local time = tonumber(tostring(value % MAGIC_NUM_INT32))
    local flag, endtime = l_monthCardData.SetExpiredTime(time)
    --抛出事件 刷新界面
    EventDispatcher:Dispatch(ON_BUY_MONTHCARD_SUCCESS)
    --打开月卡过期确认
    if flag then
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_VipCard_Expire, endtime)
        CheckVipExpired()
        ShowExpiredTips()
    end
end

-- 本次月卡激活时间
function OnSetMonthCardActiveTime(_, value)
    value = tonumber(value)
    -- logError("--->>>>>",StringEx.Format("OnSetMonthCardActiveTime {0},{1}", _, value))
    l_monthCardData.l_MonthCardActiveTime = value
    EventDispatcher:Dispatch(ON_BUY_MONTHCARD_SUCCESS)
end

-- 本次月卡持续时间
function OnSetMonthCardExistTime(_, value)
    value = tonumber(value)
    -- logError("--->>>>>",StringEx.Format("OnSetMonthCardExistTime {0},{1}", _, value))
    l_monthCardData.l_MonthCardExistTime = value
end

------------------------------------以下为协议------------------------------------------

--月卡购买 暂时没有用到
function QueryCanBuyMonthCard(isRenew)
    local l_msgId = Network.Define.Rpc.QueryCanBuyMonthCard
    local l_sendInfo = GetProtoBufSendTable("QueryCanBuyMonthCardArg")
    l_sendInfo.is_renew = isRenew
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnQueryCanBuyMonthCard(msg)
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--月卡购买
function TestBuyMonthCard()
    -- local l_msgId = Network.Define.Rpc.BuyMonthCard
    -- local l_sendInfo = GetProtoBufSendTable("NullArg")
    -- Network.Handler.SendRpc(l_msgId, l_sendInfo)
    local l_payMentId = game:GetPayMgr():GetRealProductId("MonthCardPay")
    if l_payMentId then
        game:GetPayMgr():Purchase(tostring(l_payMentId))
    end
end

function OnTestBuyMonthCard(msg)
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--收到正式支付成功的回调
function OnPayMonthCardSuccess(data)
    EventDispatcher:Dispatch(ON_BUY_MONTHCARD_SUCCESS)
end

--限定礼包购买
function RequestBuyQualifiedPack(packId)
    local l_msgId = Network.Define.Rpc.RequestBuyQualifiedPack
    local l_sendInfo = GetProtoBufSendTable("RequestBuyQualifiedPackArg")
    l_sendInfo.pack_id = packId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestBuyQualifiedPack(msg)
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_IN_PAYING then
            game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.RequestBuyQualifiedPack, function()
                EventDispatcher:Dispatch(ON_REFRESH_AWARD_PANEL)
            end)
            return
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
            return
        end
    end
    EventDispatcher:Dispatch(ON_REFRESH_AWARD_PANEL)
end

--免费小礼包领取
function RequestPickFreeGiftPack()
    local l_msgId = Network.Define.Rpc.RequestPickFreeGiftPack
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestPickFreeGiftPack(msg)
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--过期确认
function RequestMonthCardExpireConfirm()
    local l_msgId = Network.Define.Rpc.MonthCardExpireConfirm
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnMonthCardExpireConfirm(msg)
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

---获取奖励预览的文本
function GetMonthCardRewardTxt()
    local awardId = tonumber(TableUtil.GetGlobalTable().GetRowByName("MonthCardAwardId").Value)
    if awardId then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(awardId, ON_GET_ITEM_REWARD)
    end
end

function OnGetMonthCardRewardTxt(...)
    l_monthCardData.l_monthCardRewardStr = ""
    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
    local l_previewnum = l_awardPreviewRes.preview_num
    l_monthCardData.l_MonthCardItemData = {} --存储奖励的道具

    if l_awardList then
        for i = 1, #l_awardList do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_awardList[i].item_id)
            if l_itemRow then
                l_monthCardData.l_monthCardRewardStr = l_monthCardData.l_monthCardRewardStr .. Common.CommonUIFunc.GetItemHrefText(l_itemRow) .. "*" .. l_awardList[i].count .. (i == #l_awardList and "" or ",")
            end
            l_monthCardData.l_MonthCardItemData[i] = {
                ID = l_awardList[i].item_id,
                Count = l_awardList[i].count,
            }
        end
    end
    SetMonthCardDes()
end

--获取月卡描述
function SetMonthCardDes()
    local l_Table = TableUtil.GetMonthCardTable().GetTable()
    local l_finDex = ""
    local l_finTable = table.sort(l_Table, function(a, b)
        return a.SortId < b.SortId
    end)
    for k, v in pairs(l_Table) do
        local l_txt = ""
        if v.GlobleValue ~= "" then
            if v.GlobleValue == "MonthCardAwardId" then
                l_txt = StringEx.Format(v.MonthCardDes, l_monthCardRewardStr) .. "\n"
            elseif v.GlobleValue == "MonthCardBlessedExperienceTime" then
                l_txt = StringEx.Format(v.MonthCardDes, tonumber(TableUtil.GetGlobalTable().GetRowByName(v.GlobleValue).Value) * 24) .. "\n"
            else
                l_txt = StringEx.Format(v.MonthCardDes, TableUtil.GetGlobalTable().GetRowByName(v.GlobleValue).Value) .. "\n"
            end
        else
            l_txt = v.MonthCardDes .. "\n"
        end
        if v.SortId ~= 0 then
            l_finDex = l_finDex .. v.SortId .. "." .. l_txt
        end
    end
    l_monthCardData.l_finalShowMonCardStr = l_finDex
    EventDispatcher:Dispatch(ON_GET_MONTH_CARD_TEXT)
end

function GetMonthCardStr()
    return l_monthCardData.l_finalShowMonCardStr
end

------------------------------以下为限定礼包------------------------
function GetAwardLimitIds()
    local l_Table = TableUtil.GetGiftPackageTable().GetTable()
    local l_awardLimitDatas = {}
    for k, v in pairs(l_Table) do
        if v.Tab == 11204 then
            table.insert(l_awardLimitDatas, v)
        end
    end
    return l_awardLimitDatas
end

function GetAwardLimit(awardId)
    if awardId then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(awardId, ON_GEI_AWARD_LIMIT)
    end
end

--获取是否是首充
function GetIsFirstCharge()
    return l_monthCardData.l_IsFirstCharge
end

--获取是否买了月卡
function GetIsBuyMonthCard()
    local l_finTime = l_monthCardData.l_MonthCardActiveTime + l_monthCardData.l_MonthCardExistTime
    return l_monthCardData.l_MonthCardExistTime > 0 and (l_finTime - Common.TimeMgr.GetNowTimestamp()) > 0
end

--是否可以领取了小礼物
function GetIsCanGetSmallGift()
    --当前时间减去上次领取时间大于配置时间 那么可以领取
    local l_cdSec = MGlobalConfig:GetInt("MonthCardFreeAwardIdCD") * 24 * 60 * 60
    return (Common.TimeMgr.GetNowTimestamp() - l_monthCardData.l_PickSmallGiftTime >= l_cdSec)
end

function GetMonthCardLeftTime()
    local l_finTime = l_monthCardData.l_MonthCardActiveTime + l_monthCardData.l_MonthCardExistTime
    local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_finTime - Common.TimeMgr.GetNowTimestamp())
    if l_timeTable.day >= 1 then
        return Lang("MONTH_TIME_DAY", l_timeTable.day)
    elseif l_timeTable.day < 1 and l_timeTable.hour > 1 and l_timeTable.hour < 24 then
        return Lang("MONTH_TIME_HOUR_MINUTE", l_timeTable.hour, l_timeTable.min)
    elseif l_timeTable.day < 1 and l_timeTable.hour < 1 then
        return Lang("MONTH_TIME_MINUTE_SEC", l_timeTable.min, l_timeTable.sec)
    end

    --月卡过期 抛出事件刷新
    EventDispatcher:Dispatch(ON_BUY_MONTHCARD_SUCCESS)
    return Common.TimeMgr.GetLeftTimeStrEx(l_finTime - Common.TimeMgr.GetNowTimestamp())
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[MonthCard] invalid param")
        return
    end

    local noCloseBtnItems = {}
    local normalItems = {}
    local C_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_MONTH_CARD] = noCloseBtnItems,
        [ItemChangeReason.ITEM_REASON_BUY_GIFT_PACK] = normalItems,
    }

    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local singleCompareData = singleUpdateData:GetItemCompareData()
        local targetTable = C_REASON_MAP[singleUpdateData.Reason]
        if nil ~= targetTable then
            local singleData = {
                ID = singleCompareData.id,
                Count = singleCompareData.count,
            }

            table.insert(targetTable, singleData)
        end
    end

    if 0 < #noCloseBtnItems then
        MgrMgr:GetMgr("TipsMgr").ShowSpecialStrTips(GetMonthCardStr(), function()
            MgrMgr:GetMgr("TipsMgr").ShowSpecialAwardListTips(noCloseBtnItems, nil, false)
        end, false)
    end

    if 0 < #normalItems then
        MgrMgr:GetMgr("TipsMgr").ShowSpecialAwardListTips(normalItems)
    end
end

function CheckRedSignMethod()
    if GetIsCanGetSmallGift() then
        return 1
    end
    return 0
end

--获取月卡特权标签的Tips文本内容
function GetMonthCardEntrustTicketRaiseTips()
    local l_num = TableUtil.GetGlobalTable().GetRowByName("MonthCardEntrustTicketRaise").Value
    local l_Str = Lang("TIPS_MONTH_CARD_ENTRUST", l_num)
    return l_Str
end

function CheckVipExpired()
    local vip = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataClientUseId.kCDT_VipCard_Expire)
    if vip > 0 then
        local markFunc = function()
            MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_VipCard_Expire, 0)
        end
        AddExpiredTips(markFunc, Common.Utils.Lang("GET_PRIVILEGE"), Common.Utils.Lang("CARD_EXPIRED_CONTEXT_PRIVILEGE"), UI.CtrlNames.MonthCard, vip, l_monthCardData.MonthCardType.Vip)
    end
end

function CheckNormalRebateExpired()
    local normalRebate = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataClientUseId.kCDT_NormalCard_Time)
    if normalRebate > 0 then
        local markFunc = function()
            MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_NormalCard_Time, 0)
        end
        AddExpiredTips(markFunc, Common.Utils.Lang("GOTO_OPEN"), Common.Utils.Lang("CARD_EXPIRED_CONTEXT_REBATE_NORMAL"), UI.CtrlNames.RebateMonthCard, normalRebate, l_monthCardData.MonthCardType.NormalRebate)
    end
end

function CheckSuperRebateExpired()
    local superRebate = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataClientUseId.kCDT_SuperCard_Time)
    if superRebate > 0 then
        local markFunc = function()
            MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_SuperCard_Time, 0)
        end
        AddExpiredTips(markFunc, Common.Utils.Lang("GOTO_OPEN"), Common.Utils.Lang("CARD_EXPIRED_CONTEXT_REBATE_SUPER"), UI.CtrlNames.RebateMonthCard, superRebate, l_monthCardData.MonthCardType.SuperRebate)
    end
end

--lua custom scripts end
return ModuleMgr.MonthCardMgr