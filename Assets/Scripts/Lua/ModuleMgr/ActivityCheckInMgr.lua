--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.ActivityCheckInMgr", package.seeall)

--lua model end

--lua custom scripts
-- 调试用日志函数，发布时记得置空
local log = function(msg)
    -- msg = "ActivityCheckInMgr: ".. tostring(msg)
    -- logGreen(msg)
    -- logWarn(msg)
end
local logPB = function(msg)
    -- msg = "ActivityCheckIn: ".. ToString(msg)
    -- logGreen(msg)
end

local l_last_time_server_info_refresh = 0

--- 事件
EventDispatcher = EventDispatcher.new()
Event = {
    GetAllInfo = "GetAllInfo",
    ActivityEnded = "ActivityEnded",
    ChooseAward = "ChooseAward",
    SetDice = "SetDice",
    RandomDice = "RandomDice",
}

--- UI上用的图集配置
ImgNames = {
    Atlas = "ActivityCheckIn",
    Dice = {
        "UI_ActivityCheckIn_Dice01.png",
        "UI_ActivityCheckIn_Dice02.png",
        "UI_ActivityCheckIn_Dice03.png",
        "UI_ActivityCheckIn_Dice04.png",
        "UI_ActivityCheckIn_Dice05.png",
        "UI_ActivityCheckIn_Dice06.png",
    },
    DiceResult = {
        "UI_ActivityCheckIn_Dice1.png",
        "UI_ActivityCheckIn_Dice2.png",
        "UI_ActivityCheckIn_Dice3.png",
        "UI_ActivityCheckIn_Dice4.png",
        "UI_ActivityCheckIn_Dice5.png",
        "UI_ActivityCheckIn_Dice6.png",
    },
    --Dice1 = "UI_ActivityCheckIn_Dice01.png",
    --Dice2 = "UI_ActivityCheckIn_Dice02.png",
    --Dice3 = "UI_ActivityCheckIn_Dice03.png",
    --Dice4 = "UI_ActivityCheckIn_Dice04.png",
    --Dice5 = "UI_ActivityCheckIn_Dice05.png",
    --Dice6 = "UI_ActivityCheckIn_Dice06.png",
    DiceGreyMark = "UI_ActivityCheckIn_Dice07.png",
    DiceActiveMark = "UI_ActivityCheckIn_Dice08.png",
    PointGrey = "UI_ActivityCheckIn_Pic06.png",
    PointActive = "UI_ActivityCheckIn_Pic07.png",
}

--- 模块专属数据
Datas = {
    -- 来自配置的数据，一次初始化，不再改变。
    ---@type ItemTable
    m_cost_item = nil,
    ---@type ItemTable
    m_cost_reset_dice_item = nil,
    m_cost_item_imgae_txt = "",
    m_cost_txt_reset_dice = "",
    m_SignInUpdateInfoInterval = 60, -- 更新信息间隔
    ---@type number[]
    m_dice_time_list = nil,-- 6个时间点
    m_SignInQuickMakeNode = 0, -- 可以提前定制色子的时间节点
    m_SignInReDiceTime = 0,-- 重投色子的次数
    ---@type number[]
    m_SignInQuickMakePrice = nil, -- 提前定制价格
    ---@type number[]
    m_SignInReDicePrice = nil,-- 重投色子价格
    m_SignInSelectItemCD = 0,
    m_SignInShipGoneCD = 2.5,-- 开船spine播放后延时多久限制UI
    -- 来自协议的数据
    m_err_code = -1,-- 获取信息的错误码，用来判断活动是否已经结束了
    m_online_time = 0,
    m_choose_item_idx = -1,
    ---@type SupplyItemInfo__Array @所有item列表
    m_item_list = {},-- 这个应该固定7项
    ---@type number__Array @骰子值的列表，初值是-1
    m_dice_list = {},-- 6个数字，为0时没有设置
    m_can_recv_awards = false,
    -- m_is_default_award = false,
    m_awards_multiple = 0,
    m_use_dice_count = 0,
    m_can_redice = false,-- 是否可以投筛子，应该是冗余的数据
    m_tomorrow_timestamp = 0,-- 下一天开始的时间戳
    m_act_start_time = 0,
    m_act_end_time = 0,
    m_default_dice = false,
    -- 计算出来的额外数据
    m_next_dice_idx = 0, -- 下一个需要定制的色子
    m_max_multiple = 0, -- 最好的奖励倍数
    -- 提供些函数
    Init = function(self)
        self.m_dice_time_list = {}
        local rows = TableUtil.GetActivityTimeScheduleDiceTable().GetTable()
        for i, v in ipairs(rows) do
            table.insert(self.m_dice_time_list, v.TimeSchedule);
        end
        self:Clear()
        local function format(itemId, count)
            local icon = GetItemIconText(itemId)
            if MgrMgr:GetMgr("PropMgr").IsCoin(itemId) then
                return icon.. MNumberFormat.GetNumberFormat(count)
            else
                return icon .. tostring(count)
            end
        end
        -- log(table.concat(self.m_dice_time_list,", "))
        self.m_SignInUpdateInfoInterval = MGlobalConfig:GetFloat("SignInUpdateInfoInterval", 60)
        self.m_SignInQuickMakeNode = MGlobalConfig:GetFloat("SignInQuickMakeNode", 0)
        self.m_SignInReDiceTime = MGlobalConfig:GetFloat("SignInReDiceTime", 0)
        self.m_SignInQuickMakePrice = MGlobalConfig:GetSequenceOrVectorInt("SignInQuickMakePrice")
        self.m_cost_reset_dice_item = TableUtil.GetItemTable().GetRowByItemID(self.m_SignInQuickMakePrice[0])
        self.m_cost_txt_reset_dice = format(self.m_SignInQuickMakePrice[0], self.m_SignInQuickMakePrice[1])
        self.m_SignInReDicePrice = MGlobalConfig:GetSequenceOrVectorInt("SignInReDicePrice")
        self.m_cost_item = TableUtil.GetItemTable().GetRowByItemID(self.m_SignInReDicePrice[0])
        self.m_cost_item_imgae_txt = format(self.m_SignInReDicePrice[0], self.m_SignInReDicePrice[1])
        self.m_SignInSelectItemCD = MGlobalConfig:GetFloat("SignInSelectItemCD", 0)
        self.m_SignInShipGoneCD = MGlobalConfig:GetFloat("SignInShipGoneCD", 2.5)
    end,
    Clear = function(self)
        self.m_item_list = {}
        self.m_dice_list = {}
        self.m_err_code = -1
    end,
    Check = function(self)
        -- 校验数据
        if #self.m_dice_time_list ~= 6 or #self.m_dice_list ~= 6 then
            logError("节日活动色子配置必须是6条，策划查下")
            return false
        end
        if #self.m_item_list ~= 7 then
            logError("节日活动奖励个数必须是7个，策划和服务器看下")
            return false
        end

        -- 计算一些数据
        self.m_next_dice_idx = 0
        self.m_max_multiple = 0
        for i = 1, 6 do
            if self.m_dice_list[i] > 0 then
                self.m_next_dice_idx = i
                self.m_max_multiple = math.max(self.m_max_multiple, self.m_dice_list[i])
            else
                break
            end
        end
        return true
    end,
    SetInfoForTest = function(self)
        -- 伪造假数据，方便客户端测试
        self.m_online_time = 90*60
        self.m_choose_item_idx = 0
        self.m_item_list = {
            {item_id = 3020001,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020002,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020003,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020004,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020005,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020006,item_cd_end_time = 0,item_count = 2,bind = 1},
            {item_id = 3020007,item_cd_end_time = 0,item_count = 2,bind = 1},
        }
        self.m_dice_list = {1,0,0,0,0,0}
        self.m_can_recv_awards = false
        self.m_awards_multiple = 0
        self.m_use_dice_count = 0
        self.m_can_redice = false
        self.m_tomorrow_timestamp = GetTimestamp() + 120
        self.m_act_start_time = GetTimestamp() - 86400*3
        self.m_act_end_time = GetTimestamp() + 86400
    end,
    SetDiceNum = function(self, stage, value)
        self.m_dice_list[stage+1] = value
        self.m_next_dice_idx = stage + 1
        self.m_max_multiple = math.max(self.m_max_multiple, value)
    end,
    HasDiceCanSet = function(self)
        if self.m_next_dice_idx < 6 then
            local x = self.m_dice_time_list[self.m_next_dice_idx+1]
            return x*60 <= self.m_online_time
        else
            return false
        end
    end,
}

--- 工具函数
function GetTimestamp()
    -- return os.time()
    return MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
end

--[[额外判断活动是否结束，主要根据服务器数据判断时间区，结束标记
    1. 服务器返回错误码 ERR_ACTIVITY_NOT_OPEN
    2. 明天活动结束，今天已经领奖了
  ]]
function IsSystemOpenExtraCheck()
    if Datas.m_err_code < 0 then
        return true -- 还没获得服务器数据，就当开启着
    end
    if Datas.m_err_code == 0 then
        -- 最后一天，奖励已经领完了，返回false，活动结束
        return Datas.m_can_recv_awards or Datas.m_act_end_time > Datas.m_tomorrow_timestamp
    else
        return false -- 不管什么错误，都当活动已经结束了
    end
end

--- 协议
-- 获取签到活动奖励数据
function SendGetSpecialSupplyInfo()
    --do
    --    -- test
    --    Datas:SetInfoForTest()
    --    Datas:Check()
    --    EventDispatcher:Dispatch(Event.GetAllInfo)
    --    return
    --end

    local msg_id = Network.Define.Rpc.GetSpecialSupplyInfo
    ---@type GetSpecialSupplyInfoArg
    local msg = GetProtoBufSendTable("GetSpecialSupplyInfoArg")
    Network.Handler.SendRpc(msg_id,msg)
end
function OnRecvGetSpecialSupplyInfo(pb_data)
    ---@type GetSpecialSupplyInfoRes
    local msg = ParseProtoBufToTable("GetSpecialSupplyInfoRes", pb_data)
    logPB(msg)
    l_last_time_server_info_refresh = Common.TimeMgr.GetUtcTimeByTimeTable()
    Datas.m_err_code = msg.result
    if msg.result == 0 then
        Datas.m_online_time = MLuaCommonHelper.Long2Int(msg.online_time)
        Datas.m_choose_item_idx = msg.choose_item_index
        Datas.m_item_list = msg.item_list or {}
        Datas.m_dice_list = msg.dice_list or {}
        Datas.m_awards_multiple = msg.awards_multiple
        Datas.m_use_dice_count = msg.use_dice_count
        -- 客户端服务器的逻辑不太一致，需要修正下数据
        Datas.m_can_redice = msg.can_redice and Datas.m_choose_item_idx >= 0 -- 肯定得选了奖励
        Datas.m_can_recv_awards = msg.can_recv_awards or Datas.m_can_redice
        Datas.m_tomorrow_timestamp = MLuaCommonHelper.Long2Int(msg.next_recv_awards_time)
        Datas.m_act_start_time = MLuaCommonHelper.Long2Int(msg.act_start_time)
        Datas.m_act_end_time = MLuaCommonHelper.Long2Int(msg.act_end_time)
        Datas.m_default_dice = msg.default_dice
        -- 校验下数据
        local valid = Datas:Check()

        -- 如果UI没有打开，则没有任何响应
        if valid then
            local ActivityCheckRedDot = 200
            MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(ActivityCheckRedDot)
            EventDispatcher:Dispatch(Event.GetAllInfo)
        end
    else
        -- 活动未开启的错误是正常的
        if msg.result == ErrorCode.ERR_ACTIVITY_NOT_OPEN then
            EventDispatcher:Dispatch(Event.ActivityEnded)
        else
            logError("获取签到活动奖励数据出错: "..tostring(msg.result) .." " .. Common.Functions.GetErrorCodeStr(msg.result))
        end
    end
end
-- 选择奖励
function SendChooseSpecilSupplyAwards(idx)
    local msg_id = Network.Define.Rpc.ChooseSpecilSupplyAwards
    ---@type ChooseSpecilSupplyAwardsArg
    local msg = GetProtoBufSendTable("ChooseSpecilSupplyAwardsArg")
    msg.item_index = idx
    Network.Handler.SendRpc(msg_id,msg)
end
function OnRecvChooseSpecialSupplyAwards(pb_data)
    ---@type ChooseSpecilSupplyAwardsRes
    local msg = ParseProtoBufToTable("ChooseSpecilSupplyAwardsRes", pb_data)
    logPB(msg)
    if msg.result == 0 then
        Datas.m_choose_item_idx = msg.item_index
        EventDispatcher:Dispatch(Event.ChooseAward, msg.item_index)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.result))
    end
end
-- 定制色子
function SendSetSpecialSupplyDice(stage)
    local msg_id = Network.Define.Rpc.SetSpecialSupplyDice
    ---@type SetSpecialSupplyDiceArg
    local msg = GetProtoBufSendTable("SetSpecialSupplyDiceArg")
    msg.stage = stage
    Network.Handler.SendRpc(msg_id,msg)
end
function OnRecvSetSpecialSupplyDice(pb_data)
    ---@type SetSpecialSupplyDiceRes
    local msg = ParseProtoBufToTable("SetSpecialSupplyDiceRes", pb_data)
    if msg.result == ErrorCode.ERR_IN_PAYING then
        -- 避免报错日志，注册个空回调
        game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.SetSpecialSupplyDice, function () end)
        return
    end
    if msg.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(msg.result)
    end
end
function OnPtcSetSpecialSupplyDice(pb_data)
    ---@type SetSpecialSupplyDiceRes
    local msg = ParseProtoBufToTable("SetSpecialSupplyDiceRes", pb_data)
    logPB(msg)
    if msg.result == 0 then
        Datas:SetDiceNum(msg.stage, msg.value)
        EventDispatcher:Dispatch(Event.SetDice, msg.stage, msg.value)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ActivityCheckIn_SetDice_Result", msg.value))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.result))
    end
end
-- 领取奖励
function SendRecvSpecialSupplyAwards()
    local msg_id = Network.Define.Rpc.RecvSpecialSupplyAwards
    ---@type RecvSpecialSupplyAwardsArg
    local msg = GetProtoBufSendTable("RecvSpecialSupplyAwardsArg")
    Network.Handler.SendRpc(msg_id,msg)
end
function OnRecvRecvSpecialSupplyAwards(pb_data)
    ---@type RecvSpecialSupplyAwardsRes
    local msg = ParseProtoBufToTable("RecvSpecialSupplyAwardsRes", pb_data)
    logPB(msg)
    if msg.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.result))
    end
    -- 重新请求下完成数据，刷新UI
    SendGetSpecialSupplyInfo()
end
-- 投色子
function SencRandomDiceValue()
    local msg_id = Network.Define.Rpc.RandomDiceValue
    ---@type RandomDiceValueArg
    local msg = GetProtoBufSendTable("RandomDiceValueArg")
    msg.use_dice_count = Datas.m_use_dice_count + 1
    Network.Handler.SendRpc(msg_id,msg)
end
function OnRecvRandomDiceValue(pb_data)
    ---@type RandomDiceValueRes
    local msg = ParseProtoBufToTable("RandomDiceValueRes", pb_data)
    if msg.result == ErrorCode.ERR_IN_PAYING then
        -- 避免报错日志，注册个空回调
        game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.RandomDiceValue, function () end)
        return
    end
    if msg.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(msg.result)
        EventDispatcher:Dispatch(Event.RandomDice, msg.result)
    end
end
function OnPtcRandomDiceValue(pb_data)
    ---@type RandomDiceValueRes
    local msg = ParseProtoBufToTable("RandomDiceValueRes", pb_data)
    logPB(msg)
    Datas.m_use_dice_count = msg.use_dice_count
    if msg.result == 0 then
        Datas.m_awards_multiple = msg.awards_multiple
        Datas.m_can_redice = msg.can_redice
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(msg.result))
    end
    EventDispatcher:Dispatch(Event.RandomDice, msg.result)
end

function test(x,y)
    SendGetSpecialSupplyInfo()
    --Datas:SetInfoForTest()
    --Datas.m_awards_multiple = y
    --EventDispatcher:Dispatch(Event.RandomDice, x)
end

--- 生命周期
function OnInit()
    log("OnInit")
    Datas:Init()
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    openSystemMgr.EventDispatcher:Add(openSystemMgr.OpenSystemUpdate, OnSystemUpdate)
end

function OnLogout()
    log("OnLogout")
    Datas:Clear()
end

function OnSelectRoleNtf()
    log("OnSelectRoleNtf")
    -- 刚开始需要请求下信息，为后续的红点逻辑做准备
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.ActivityCheckIn) then
        SendGetSpecialSupplyInfo()
    end
end

function OnSystemUpdate(_, openIds)
    if openIds then
        ---@type ModuleMgr.OpenSystemMgr
        local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
        local my_id = openSystemMgr.eSystemId.ActivityCheckIn
        for i, v in ipairs(openIds) do
            if v.value == my_id then
                if openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.ActivityCheckIn) then
                    SendGetSpecialSupplyInfo()
                end
            end
        end
    end
end

local function _IsRedPointShow()
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.ActivityCheckIn) then
        return false
    end
    -- 触发刷新逻辑
    local now = Common.TimeMgr.GetUtcTimeByTimeTable()
    if l_last_time_server_info_refresh + Datas.m_SignInUpdateInfoInterval < now then
        -- 刷新一次数据，
        SendGetSpecialSupplyInfo()
    end
    
    if Datas.m_err_code == 0 then
        return (Datas.m_choose_item_idx < 0 and Datas.m_act_end_time > Datas.m_tomorrow_timestamp) -- 没选奖励，活动也没结束
                -- or (Datas.m_can_recv_awards and Datas.m_awards_multiple > 0) -- 可以领奖
                or (not Datas.m_can_recv_awards and Datas:HasDiceCanSet()) -- 可以设置色子
                or Datas.m_can_recv_awards -- 可以投色子或者领奖
    end
    
    return false
end

-- 功能总红点
function IsRedPointShow()
    return _IsRedPointShow() and 1 or 0
end

--- 活动开启的判断有些坑
function IsActivityOpen()
    ---@type ModuleMgr.OpenSystemMgr
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(openSystemMgr.eSystemId.ActivityCheckIn) then
        return false
    end
    if not IsSystemOpenExtraCheck() then
        -- 一言难尽。最好是活动开启时，服务通知下
        -- MgrMgr:GetMgr("ActivityCheckInMgr").SendGetSpecialSupplyInfo() --强制刷新下
        return false
    end
    return true
end

--lua custom scripts end
return ModuleMgr.ActivityCheckInMgr