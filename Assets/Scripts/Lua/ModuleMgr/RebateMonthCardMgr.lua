--this file is gen by script
--you can edit this file in custom part

require "ModuleMgr/CommonMsgProcessor"

--lua model
---@module ModuleMgr.RebateMonthCardMgr
module("ModuleMgr.RebateMonthCardMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
--lua model end

--lua custom scripts
local MAGIC_NUM_INT32 = 4294967296
local myData = DataMgr:GetData("RebateMonthCardData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    game:GetPayMgr().EventDispatcher:Add(game:GetPayMgr().ON_SDK_PAY_SUCCESS, OnRebateCardSuccess, self)
    local l_commonData = Common.CommonMsgProcessor.new()

    myData.init()
    local l_data = {}
    --普通月卡购买信息
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_NORMAL_CARD_BUYINFO,
        Callback = OnSetNormalCardBuyInfo,
    })
    --超级月卡购买信息
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_SUPER_CARD_BUYINFO,
        Callback = OnSetSuperCardBuyInfo,
    })
    --普通月卡领奖信息
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_NORMAL_CARD_AWARD_INFO,
        Callback = OnSetNormalCardAwardInfo,
    })
    --超级月卡领奖信息
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_SUPER_CARD_AWARD_INFO,
        Callback = OnSetSuperCardAwardInfo,
    })
    l_commonData:Init(l_data)
end

function OnLogout()
    myData.logout()
end

function OnEnterScene(sceneId)
    --ShowExpirationTips()
end

function BuyRebateCard(productId)
    -----@type BuyRebateCardArg
    MgrMgr:GetMgr("GmMgr").SendCommand("testpay " .. productId)
    UIMgr:DeActiveUI(UI.CtrlNames.RebateMonthCard_tips)
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end

--正式支付接口
function BuyRebateCardByType(productType)
	if productType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.CommonMonthCard then		-- 普通充值
		local l_payMentId = game:GetPayMgr():GetRealProductId("CommonCardPay")
		if l_payMentId then
			game:GetPayMgr():Purchase(tostring(l_payMentId))
		end
	elseif productType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.SuperMonthCard then
		local l_payMentId = game:GetPayMgr():GetRealProductId("SuperCardPay")
		if l_payMentId then
			game:GetPayMgr():Purchase(tostring(l_payMentId))
		end
	end
end

--收到正式支付成功的回调
function OnRebateCardSuccess(data)
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end

--function OnBuyRebateCard(msg)
--    local l_info = ParseProtoBufToTable("BuyRebateCardRes", msg)
--    if l_info.error_code ~= 0 then
--        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
--    end
--
--end
---普通返利月卡购买信息设置
---@param value number 到期时间戳
function OnSetNormalCardBuyInfo(_, value)
    --- 高 32位 是购买时间，低32位是购买次数
    local top = math.modf(tonumber(tostring(value / MAGIC_NUM_INT32)))
    local buyCount = tonumber(tostring(value % MAGIC_NUM_INT32))
    myData.SetNormalBuyCount(buyCount)
    ---flag标记了是否是到期时间戳从有到无，用于标记过期
    local flag, endtime = myData.SetNormalEndTime(top)
    if flag then
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_NormalCard_Time, endtime)
        MgrMgr:GetMgr("MonthCardMgr").CheckNormalRebateExpired()
        MgrMgr:GetMgr("MonthCardMgr").ShowExpiredTips()
    else
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_NormalCard_Time, 0)
    end
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end
---超级返利月卡购买信息设置，同OnSetNormalCardBuyInfo
function OnSetSuperCardBuyInfo(_, value)
    local top = math.modf(tonumber(tostring(value / MAGIC_NUM_INT32)))
    local buyCount = tonumber(tostring(value % MAGIC_NUM_INT32))
    local flag, endtime = myData.SetSuperEndTime(top)
    myData.SetSuperBuyCount(buyCount)
    if flag then
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_SuperCard_Time, endtime)
        MgrMgr:GetMgr("MonthCardMgr").CheckSuperRebateExpired()
        MgrMgr:GetMgr("MonthCardMgr").ShowExpiredTips()
    else
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataClientUseId.kCDT_SuperCard_Time, 0)
    end
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end
---普通月卡领奖信息设置
function OnSetNormalCardAwardInfo(_, value)
    ---top 剩余领奖次数
    ---bottom 上次领奖时间戳
    local top = math.modf(tonumber(tostring(value / MAGIC_NUM_INT32)))
    local bottom = tonumber(tostring(value % MAGIC_NUM_INT32))

    myData.SetNormalRewardInfo(bottom, top)
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end
--- 超级月卡领奖信息设置，同上OnSetNormalCardAwardInfo
function OnSetSuperCardAwardInfo(_, value)
    local top = math.modf(tonumber(tostring(value / MAGIC_NUM_INT32)))
    local bottom = tonumber(tostring(value % MAGIC_NUM_INT32))
    myData.SetSuperRewardInfo(bottom, top)
    EventDispatcher:Dispatch(myData.REBATE_CARD_TYPE)
end

---用于弹出购买时的金币奖励SpecialTips
---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[MonthCard] invalid param")
        return
    end

    for k, v in pairs(itemUpdateDataList) do
        local compareData = v:GetItemCompareData()
        if v.Reason == ItemChangeReason.ITEM_REASON_ACT_MONTH_CARD then
            MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(compareData.id, compareData.count)
        end
    end
end


--lua custom scripts end
return ModuleMgr.RebateMonthCardMgr