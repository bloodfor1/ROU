declareGlobal("CatTradeActivity",{})
require("role_script_manager")
require("Table/RecycleTable")
require("Table/ServerLvTable")

CatTradeActivity.SystemId = 5131
CatTradeActivity.RefreshType = 2
CatTradeActivity.RedPointId = 30
CatTradeActivity.SellGoodsRewardId = 402

function CatTradeActivity.GenerateCatTradeSeatInfo(total_value, total_seat, level)
    local rand_item = CatTradeConfMgr:Instance():GetOneRandItemInfo(total_value, total_seat, level)
    if rand_item.first <= 0 then
        ScriptTool:PrintError("get rand item failed item_id is "..tostring(rand_item.first))
        return
    end
    if rand_item.second <= 0 then
        ScriptTool:PrintError("get rand item failed item_count is "..tostring(rand_item.second))
        return
    end
    local item_conf_info = Table.RecycleTable.GetRowByID(rand_item.first)
    if not item_conf_info then
        ScriptTool:PrintError("get item conf failed item_id is "..tostring(rand_item.first))
        return
    end
    if item_conf_info.Type == 2 then
        local need_zeny = ShopManager:Instance():GetItemNeedZeny(item_conf_info.ItemID)
        if need_zeny < 0 then
            ScriptTool:PrintError("get shop item price failed item_id is "..tostring(rand_item.first))
            return
        end
    end
    local seat_info = RoleCatTradeTrainSeatInfo:new()
    seat_info.item_id = rand_item.first
    seat_info.item_count = rand_item.second
    seat_info.is_full = false
    seat_info.price = item_conf_info.Reputation * seat_info.item_count
    local price = 0
    if item_conf_info.Type == 1 then
        price = StallManager:Instance():GetPrevPrice(item_conf_info.ItemID)
    elseif item_conf_info.Type == 2 then
        price = ShopManager:Instance():GetItemNeedZeny(item_conf_info.ItemID)
    end
    if price > 0 then
        seat_info.price = price * item_conf_info.Reputation * seat_info.item_count
    end
    ItemDemandManager:Instance():OnAddItemDemand(item_conf_info.ItemID, seat_info.item_count)
    return seat_info,price*seat_info.item_count
end

--刷新出一批箱子出来
function CatTradeActivity.RefreshTrade(role_script_info)
    local info = role_script_info.cat_trade_info
    info:ClearTrainList()
    info.is_get_reward = false
    info.is_modify = true
    local train_count = CatTradeConfMgr:Instance():GetTrainCount()
    if train_count <= 0 then
        ScriptTool:PrintError('cat trade train_count is less then 0 role:'..tostring(role_script_info.role:GetID())..' train_count:'..tostring(train_count))
        return
    end
    local seat_array = {}
    --计算随机出今日货船上的箱子数total_box；
    local total_seat = 0
    for i = 1, train_count do
        seat_array[i] = CatTradeConfMgr:Instance():GetTrainRandSeatCount()
        total_seat = total_seat + seat_array[i]
    end
    if total_seat <= 0 then
        ScriptTool:PrintError('cat trade total_seat is less then 0 role'..tostring(role_script_info.role:GetID()))
        return
    end
    --按照新增的规则，计算当日需要回收的铜币总量total_value（玩家Base等级，服务器等级，玩家勋章平均等级，服务器勋章平均等级）
    local server_level = ServerLevelManager:Instance():GetServerLevelToday()

    local role_medal_module = GetModule_RoleMedal_:Get(role_script_info.role)
    local medal_server_level = role_medal_module:GetServerMedalLevel()
    local role_general_medal_level = role_medal_module:GetSumMedalLevel(true)
    local role_super_medal_level = role_medal_module:GetSumMedalLevel(false)
    local total_value = DynamicRecycle.DailyCatCaravanExpect(role_script_info.role:GetLevel(), server_level, role_general_medal_level, role_super_medal_level, medal_server_level)
    --先随机种类限制
    CatTradeConfMgr:Instance():UpdateItemLimit(total_value, total_seat, false)
    local level = math.min(role_script_info.role:GetLevel(), ServerLevelManager:Instance():GetServerLevelToday())
    local temp_value = total_value
    local temp_seat = total_seat
    local seat_info_list = {}
    local seat_index = 0;
    for i = 1, train_count do
        local train_info = RoleCatTradeTrainInfo:new()
        local seat_count = seat_array[i]
        for j = 1, seat_count do
            local expect_price = 0;
            if temp_seat <= 0 then
                ScriptTool:PrintError('temp_seat less then 0 role'..tostring(role_script_info.role:GetID()))
            else
                expect_price = math.floor(temp_value / temp_seat)
            end
            local seat_info,price = CatTradeActivity.GenerateCatTradeSeatInfo(temp_value, temp_seat, level)
            if not seat_info then
                ScriptTool:PrintError("generate seat_info failed")
                temp_value = temp_value - expect_price
            else
                train_info.seat_list:push_back(seat_info)
                seat_index = seat_index + 1
                seat_info_list[seat_index] = seat_info
                temp_value = temp_value - price
                ScriptTool:PrintInfo("random item,temp_value"..tostring(temp_value)..",temp_seat="..tostring(temp_seat-1)..",id="..tostring(seat_info.item_id)..",item_count"..tostring(seat_info.item_count)..", price="..tostring(price))
            end
            if temp_value <= 0 then
                temp_value = 1
            end
            temp_seat = temp_seat - 1
        end
        info.train_list:push_back(train_info)
    end

    --顺序打乱
    for i = 1, seat_index do
        local index = math.random(i, seat_index)
        if i ~= index then
            seat_info_list[i], seat_info_list[index] = seat_info_list[index], seat_info_list[i]
        end
    end

    --重新赋值
    seat_index = 0
    for i = 1, train_count do
        local train_info = info.train_list[i - 1]
        for j = 1, train_info.seat_list:size() do
            seat_index = seat_index + 1
            train_info.seat_list[j-1] = seat_info_list[seat_index]
        end
    end
end

function CatTradeActivity.CheckRefreshTrade(role_script_info)
    local info = role_script_info.cat_trade_info
    if info.train_list:size() <= 0 then
        CatTradeActivity.RefreshTrade(role_script_info)
    end
end

function CatTradeActivity.Load(role_all_info, role_script_info)
    if not role_all_info:has_cat_trade_info() then
        return true
    end
    local pb_info = role_all_info:cat_trade_info()
    local info = role_script_info.cat_trade_info
    for i = 1, pb_info:train_list_size() do
        local pb_train_info = pb_info:train_list(i - 1)
        local train_info = RoleCatTradeTrainInfo:new()
        for j = 1, pb_train_info:seat_list_size() do
            local pb_seat_info = pb_train_info:seat_list(j - 1)
            local seat_info = RoleCatTradeTrainSeatInfo:new()
            seat_info.item_id = pb_seat_info:item_id()
            seat_info.item_count = pb_seat_info:item_count()
            seat_info.is_full = pb_seat_info:is_full()
            seat_info.price = pb_seat_info:price()
            train_info.seat_list:push_back(seat_info)
        end
        info.train_list:push_back(train_info)
    end
    info.is_get_reward = pb_info:is_get_reward()
    return true
end

function CatTradeActivity.SaveToPb(pb_info, info)
    pb_info:Clear()
    for i = 1, info.train_list:size() do
        local pb_train_info = pb_info:add_train_list()
        local train_info = info.train_list[i - 1]
        for j = 1, train_info.seat_list:size() do
            local pb_seat_info = pb_train_info:add_seat_list()
            local seat_info = train_info.seat_list[j - 1]
            pb_seat_info:set_item_id(seat_info.item_id)
            pb_seat_info:set_item_count(seat_info.item_count)
            pb_seat_info:set_is_full(seat_info.is_full)
            pb_seat_info:set_price(seat_info.price)
        end
    end
    pb_info:set_is_get_reward(info.is_get_reward)
end

function CatTradeActivity.Save(role_all_info, role_script_info, changed)
    local info = role_script_info.cat_trade_info
    if not info.is_modify then
        return
    end
    info.is_modify = false
    local pb_info = role_all_info:mutable_cat_trade_info()
    CatTradeActivity.SaveToPb(pb_info, info)
    changed:push_back(tolua.cast(pb_info, "google::protobuf::MessageLite"))
end

function CatTradeActivity.SaveByTime(role_all_info, role_script_info, modify_time)
    if not role_script_info.role:CheckSaveModuleByTargetTime(KKSG.kRoleModuleTypeCatTrade, modify_time) then
        return
    end
    CatTradeActivity.SaveToPb(role_all_info.mutable_cat_trade_info(), role_script_info.cat_trade_info)
end

function CatTradeActivity.Refresh(role_all_info, role_script_info, mark)
    if not GameTime.IsTimeNeedRefresh(mark, CatTradeActivity.RefreshType) then
        return
    end
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        return
    end
    if not role_script_info.cat_trade_info.is_get_reward and CatTradeActivity.CheckFinished(role_script_info) then
        role_script_info.role:SendRedPointNotify(CatTradeActivity.RedPointId, 0)
    end
    CatTradeActivity.RefreshTrade(role_script_info)
end

function CatTradeActivity.IsSystemOpen(role_script_info)
    if not role_script_info.role:IsSystemOpen(CatTradeActivity.SystemId) then
        return false
    end
    return true
end

function CatTradeActivity.CheckFinished(role_script_info)
    local info = role_script_info.cat_trade_info
    for i = 1, info.train_list:size() do
        local train_info = info.train_list[i - 1]
        for j = 1, train_info.seat_list:size() do
            local seat_info = train_info.seat_list[j - 1]
            if not seat_info.is_full then
                return false
            end
        end
    end
    return true
end

function CatTradeActivity.AfterLogin(role_all_info, role_script_info)
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        return
    end
    CatTradeActivity.CheckRefreshTrade(role_script_info)
    if not role_script_info.cat_trade_info.is_get_reward and CatTradeActivity.CheckFinished(role_script_info) then
        role_script_info.role:SendRedPointNotify(CatTradeActivity.RedPointId, 1)
    end
end

function CatTradeActivity.GetInfo(role_script_info, arg, res)
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    CatTradeActivity.CheckRefreshTrade(role_script_info)
    local is_trade_full = true
    local info = role_script_info.cat_trade_info
    for i = 1, info.train_list:size() do
        local pb_train_info = res:add_train_list()
        local train_info = info.train_list[i - 1]
        pb_train_info:set_id(i)
        local is_train_full = true
        for j = 1, train_info.seat_list:size() do
            local pb_seat_info = pb_train_info:add_seat_list()
            local seat_info = train_info.seat_list[j - 1]
            pb_seat_info:set_id(j)
            pb_seat_info:set_item_id(seat_info.item_id)
            pb_seat_info:set_item_count(seat_info.item_count)
            pb_seat_info:set_is_full(seat_info.is_full)
            pb_seat_info:set_price(seat_info.price)
            if not seat_info.is_full then
                is_train_full = false
            end
        end
        pb_train_info:set_is_full(is_train_full)
        if not is_train_full then
            is_trade_full = false
        end
    end
    if is_trade_full then
        res:set_status(1)
    end
    if info.is_get_reward then
        res:set_status(2)
    end
    res:set_error_code(KKSG.ERR_SUCCESS)
end

function CatTradeActivity.GetReward(role_script_info, arg, res)
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    CatTradeActivity.CheckRefreshTrade(role_script_info)
    local info = role_script_info.cat_trade_info
    if info.is_get_reward then
        ScriptTool:PrintError('cat trade reward is get role:'..tostring(role_script_info.role:GetID()))
        res:set_error_code(KKSG.ERR_CAT_TRADE_REWARD_IS_GET)
        return
    end
    if not CatTradeActivity.CheckFinished(role_script_info) then
        ScriptTool:PrintError('cat trade is not finished role:'..tostring(role_script_info.role:GetID()))
        res:set_error_code(KKSG.ERR_CAT_TRADE_IS_NOT_FULL)
        return
    end
	local reason = ChangeReason:new_local(KKSG.ITEM_REASON_CAT_TRADE_REWARD);
    AwardLogic:SendAward(role_script_info.role, CatTradeConfMgr:Instance():GetCatTradeReward(), reason)
    info.is_get_reward = true
    info.is_modify = true
    res:set_error_code(KKSG.ERR_SUCCESS)
    role_script_info.role:SendRedPointNotify(CatTradeActivity.RedPointId, 0)
end

function CatTradeActivity.SellGoods(role_script_info, arg, res)
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    CatTradeActivity.CheckRefreshTrade(role_script_info)
    local info = role_script_info.cat_trade_info
    local train_id = arg:train_id()
    if train_id <= 0 or train_id > info.train_list:size() then
        ScriptTool:PrintError('cat trade train id is error role:'..tostring(role_script_info.role:GetID())
            ..' train_count:'..tostring(info.train_list:size())..' req:'..tostring(train_id))
        res:set_error_code(KKSG.ERR_CAT_TRAIN_ID_INVALID)
        return
    end
    local train_info = info.train_list[train_id - 1]
    local seat_id = arg:train_seat_id()
    if seat_id <= 0 or seat_id > train_info.seat_list:size() then
        ScriptTool:PrintError('cat trade seat id is error role:'..tostring(role_script_info.role:GetID())
            ..' train_count:'..tostring(info.train_list:size())..' seat_count:'..tostring(train_info.seat_list:size())..' req:'..tostring(seat_id))
        res:set_error_code(KKSG.ERR_CAT_SEAT_ID_INVALID)
        return
    end
    local seat_info = train_info.seat_list[seat_id - 1]
    if seat_info.is_full then
        ScriptTool:PrintError('cat trade seat is full role:'..tostring(role_script_info.role:GetID())
            ..' train:'..tostring(train_id)..' seat:'..tostring(seat_id))
        res:set_error_code(KKSG.ERR_CAT_SEAT_IS_FULL)
        return
    end
    if arg:item_list_size() ~= arg:item_count_list_size() then
        ScriptTool:PrintError('cat trade item count error role:'..tostring(role_script_info.role:GetID())
            .."count:"..tostring(arg:item_list_size()).." !=:"..tostring(arg:item_count_list_size()))
        res:set_error_code(KKSG.ERR_INVALID_REQUEST)
        return
    end
    local item_info = Table.RecycleTable.GetRowByID(seat_info.item_id)
    if not item_info then
        ScriptTool:PrintError('cat trade item get error role:'..tostring(role_script_info.role:GetID())
            ..' item:'..tostring(seat_info.item_id))
        res:set_error_code(KKSG.ERR_UNKNOWN)
        return
    end
    local total_count = 0
    local cost_items = std.vector_ItemDesc_:new_local()
    for i = 1, arg:item_list_size() do
        local count = arg:item_count_list(i - 1):value()
        if count <= 0 then
            ScriptTool:PrintError('cat trade item count is less then 0 role:'..tostring(role_script_info.role:GetID()))
            res:set_error_code(KKSG.ERR_INVALID_REQUEST)
            return
        end
        total_count = total_count + count
        local cost_item = ItemDesc:new_local()
        cost_item.item_id = item_info.ItemID
        cost_item.item_count = count
        cost_item.item_uid = arg:item_list(i - 1):value()
        cost_items:push_back(cost_item)
    end
    if total_count ~= seat_info.item_count then
        res:set_error_code(KKSG.ERR_INVALID_REQUEST)
        ScriptTool:PrintError('cat trade item count is less then need count role:'..tostring(role_script_info.role:GetID())
            ..'count:'..tostring(total_count)..' need count:'..tostring(seat_info.item_count))
        return
    end
    local error_code = ItemTransition:TakeItemByUidAndCheck(role_script_info.role, cost_items, KKSG.ITEM_REASON_CAT_TRADE_SELL_GOODS)
    if error_code ~= KKSG.ERR_SUCCESS then
        ScriptTool:PrintError('take item failed role:'..tostring(role_script_info.role:GetID()))
        res:set_error_code(error_code)
        return
    end
    local reward_item = ItemDesc:new_local()
    reward_item.item_id = CatTradeActivity.SellGoodsRewardId
    reward_item.item_count = seat_info.price
    ItemTransition:GiveItem(role_script_info.role, reward_item, KKSG.ITEM_REASON_CAT_TRADE_SELL_GOODS)
    seat_info.is_full = true
    info.is_modify = true
    res:set_error_code(KKSG.ERR_SUCCESS)
    ScriptTool:OnSellGoods(role_script_info.role, train_id, seat_info)
    ItemDemandManager:Instance():OnDelItemDemand(item_info.ItemID, seat_info.item_count)
    local is_train_full = true	
    for j = 1, train_info.seat_list:size() do
        local seat_info = train_info.seat_list[j - 1]
        if not seat_info.is_full then
            is_train_full = false
            break
        end
    end
    if is_train_full then
        ScriptTool:OnCatTradeTrainFinish(role_script_info.role)
        if CatTradeActivity.CheckFinished(role_script_info) then
            role_script_info.role:SendRedPointNotify(CatTradeActivity.RedPointId, 1)
            ScriptTool:OnCatTradeFinish(role_script_info.role)
        end
    end
end

-- gm 填满内容
function CatTradeActivity.GMFill(role_script_info)
    if not CatTradeActivity.IsSystemOpen(role_script_info) then
        res:set_error_code(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
    CatTradeActivity.CheckRefreshTrade(role_script_info)
    local reward_item = ItemDesc:new_local()
    reward_item.item_id = CatTradeActivity.SellGoodsRewardId
    reward_item.item_count = 0
    local info = role_script_info.cat_trade_info
    for i = 1, info.train_list:size() do
        local train_info = info.train_list[i - 1]
        for j = 1, train_info.seat_list:size() do
            local seat_info = train_info.seat_list[j - 1]
            if not seat_info.is_full then
                reward_item.item_count = reward_item.item_count + seat_info.price
            end
            seat_info.is_full = true
        end
    end
    info.is_modify = true
    ItemTransition:GiveItem(role_script_info.role, reward_item, KKSG.ITEM_REASON_CAT_TRADE_SELL_GOODS)
    ScriptTool:OnCatTradeTrainFinish(role_script_info.role)
    if CatTradeActivity.CheckFinished(role_script_info) then
        role_script_info.role:SendRedPointNotify(CatTradeActivity.RedPointId, 1)
        ScriptTool:OnCatTradeFinish(role_script_info.role)
    end
end

table.insert(RoleScriptManager.RegisterHandlers, CatTradeActivity)
