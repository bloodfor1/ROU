--this file is gen by script
--you can edit this file in custom part

require "ModuleMgr/CommonMsgProcessor"

--lua model
module("ModuleMgr.TotalRechargeAwardMgr", package.seeall)

--lua model end

--lua custom scripts
--- 事件
EventDispatcher = EventDispatcher.new()
Event = {
    GetAllInfo = "GetAllInfo",
    TotalRechargeUpdate = "TotalRechargeUpdate",-- 可以用来刷新下UI
    GotAward = "GotAward",
    ShowDetail = "ShowDetail",
    GetAwardDetail = "TotalRechargeAwardMgr.GetAwardDetail",
}

local RedPointCheckID = 260

---@class TotalRechargeAwardItem
---@field id number
---@field gift_id number
---@field condition number
---@field has_got boolean
---@field area number
---@field gift_award_id number

--- 模块专属数据
Datas = {
    m_show_num_limit = 5,-- 只显示未达成后面N项
    ---@type TotalRechargeAwardItem[]
    m_award_list = {},-- 进度奖励列表，过滤了地区的
    ---@type table<number, TotalRechargeAwardItem>
    m_award_map = {},
    ---@type table<number, AwardPreviewResult>
    m_award_detail_map = {},
    m_total_recharge = 0, -- 累计充值金额
    m_cur_area = 0,
    m_currency_symbol = "",

    Init = function(self)
        self.m_award_list = {}
        self.m_award_map = {}
        self.m_cur_area = MLuaCommonHelper.Enum2Int(MGameContext.CurrentChannel)
        self.m_total_recharge = 0
        self.m_show_num_limit = MGlobalConfig:GetInt("TotalRechargeAwardShowNumLimit", 5)
        -- self.m_show_num_limit = 3
        local signal_info = TableUtil.GetPaymentSignalTable().GetRowByArea(self.m_cur_area)
        self.m_currency_symbol = signal_info and signal_info.Signal or ""

        local rows = TableUtil.GetTotalRechargeTable().GetTable()
        for i,v in ipairs(rows) do
            local item = {
                id = v.Id,
                gift_id = v.FreeRebatePackage,
                condition = v.Base,
                area = v.Area,
                has_got = false,
            }
            local gift_info = TableUtil.GetGiftPackageTable().GetRowByMajorID(item.gift_id)
            item.gift_award_id = gift_info and gift_info.AwardID or nil
            self.m_award_map[item.id] = item
            if v.Area == self.m_cur_area then
                table.insert(self.m_award_list, item)
            end
        end
        table.sort(self.m_award_list, function (a,b)
            return a.condition < b.condition
        end)
    end,
    SetHasGot = function(self, id)
        local it = self.m_award_map[id]
        if it then
            it.has_got = true
        else
            logError("TotalRechargeAwardMgr.Datas.SetHasGot id invalid, id= "..tostring(id))
        end
    end,
    SetInfoForTest = function(self)

    end,
}

-- 协议
--- 获取领奖信息列表
--function SendGetAllInfo()
--    do
--        -- test
--        Datas:SetInfoForTest()
--        EventDispatcher:Dispatch(Event.GetAllInfo)
--        return
--    end
--
--    local msg_id = Network.Define.Rpc.GetPayAwardInfo
--    ---@type GetSpecialSupplyInfoArg
--    local msg = GetProtoBufSendTable("GetPayAwardInfoArg ")
--    Network.Handler.SendRpc(msg_id,msg)
--end

--function OnRecvGetAllInfo(pb_data)
--    ---@type GetPayAwardInfoRes
--    local msg = ParseProtoBufToTable("GetPayAwardInfoRes", pb_data)
--    if msg.error_code ~= 0 then
--        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.error_code))
--    else
--        for _,v in ipairs(msg.awardinfo) do
--            Datas:SetHasGot(v)
--        end
--        EventDispatcher:Dispatch(Event.GetAllInfo)
--    end
--end

function SendGetAward(id)
    local msg_id = Network.Define.Rpc.GetPayAward
    ---@type GetPayAwardArg
    local msg = GetProtoBufSendTable("GetPayAwardArg")
    msg.id = id
    msg.region = Datas.m_cur_area
    Network.Handler.SendRpc(msg_id,msg)
end

function OnRecvGetAward(pb_data, arg)
    ---@type GetPayAwardRes
    local msg = ParseProtoBufToTable("GetPayAwardRes", pb_data)
    if msg.error_code == 0 or msg.error_code == ErrorCode.ERR_REPEATED_GET_AWARD then
        local id = arg.id
        Datas:SetHasGot(id)
        EventDispatcher:Dispatch(Event.GotAward, id)
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(RedPointCheckID)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.error_code))
    end
end

--- 头大
function SendGetAwardDetail()
    local award_ids = {}
    for _,v in ipairs(Datas.m_award_list) do
        if v.gift_award_id then
            table.insert(award_ids, v.gift_award_id)
        end
    end
    award_ids = table.ro_unique(award_ids)
    -- award_ids = {3800140,3800250,3800150,3800130}
    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(award_ids, Event.GetAwardDetail)
end

---@param info AwardPreviewResult__Array
function OnGetAwardDetail(info)
    Datas.m_award_detail_map = {}
    if not info then return end
    for _,v in pairs(info) do
        Datas.m_award_detail_map[v.award_id] = v
    end
end


local function OnTotalRechargeUpdate(_, value)
    Datas.m_total_recharge = Common.Functions.ToInt64(value)/10000
    EventDispatcher:Dispatch(Event.TotalRechargeUpdate)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(RedPointCheckID)
end

local function OnPayAwardChange(id, value)
    Datas:SetHasGot(tonumber(id))
    -- 这个就不触发什么消息了
end

--- 生命周期函数
function OnInit()
    Datas:Init()
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data1 = {}
    table.insert(l_data1, {
        ModuleEnum = CommondataType.kCDT_VITALE_DATA,
        DetailDataEnum = CommondataId.kCDI_TOTAL_RECHARGE,
        Callback = OnTotalRechargeUpdate,
    })

    table.insert(l_data1, {
        ModuleEnum = CommondataType.kCDT_PAY_AWARD_RECORD,
        Callback = OnPayAwardChange,
    })
    l_commonData:Init(l_data1)

    --local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    --openSystemMgr.EventDispatcher:Add(openSystemMgr.OpenSystemUpdate, OnSystemUpdate)
end

function OnLogout()
    Datas:Init()
end

--function OnSelectRoleNtf()
--    -- 刚开始需要请求下信息，为后续的红点逻辑做准备
--    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
--    if openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.TotalRechargeAward) then
--        SendGetAllInfo()
--    end
--end

--function OnSystemUpdate(_, openIds)
--    if openIds then
--        ---@type ModuleMgr.OpenSystemMgr
--        local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
--        local my_id = openSystemMgr.eSystemId.TotalRechargeAward
--        for i, v in ipairs(openIds) do
--            if v.value == my_id then
--                if openSystemMgr.IsSystemOpen(my_id) then
--                    SendGetAllInfo()
--                end
--            end
--        end
--    end
--end

function IsSystemOpen()
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    return openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.TotalRechargeAward)
end

-- 功能总红点
function IsRedPointShow()
    if not IsSystemOpen() then
        return 0
    end
    for _,v in ipairs(Datas.m_award_list) do
        if not v.has_got and v.condition <= Datas.m_total_recharge then
            return 1
        end
    end
    return 0
end

--lua custom scripts end
return ModuleMgr.TotalRechargeAwardMgr