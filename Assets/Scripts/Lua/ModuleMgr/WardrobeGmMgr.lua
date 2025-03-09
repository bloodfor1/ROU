--- 这个文件当中的内容是衣橱当中想要直接获取美瞳和美发的GM按钮点击对应的方法
---@module ModuleMgr.WardrobeGmMgr
module("ModuleMgr.WardrobeGmMgr", package.seeall)

---@type ModuleMgr.GmMgr
local gmMgr = MgrMgr:GetMgr("GmMgr")
local C_STR_GM_CMD_ADD_MONEY = "addmoney {0} {1}"
local C_STR_GM_CMD_ADD_ITEM = "{0} {1}"
local C_COIN_HASH_MAP = {
    [GameEnum.l_virProp.Coin104] = 1,
    [GameEnum.l_virProp.Coin103] = 1,
    [GameEnum.l_virProp.Coin101] = 1,
    [GameEnum.l_virProp.Coin102] = 1,
    [GameEnum.l_virProp.Prestige] = 1,
}

--- 通过GM指令直接修改头发
function ReqGmChangeHair(id)
    if nil == id then
        logError("[Wardrobe] hair id got nil")
        return
    end

    --- 检查是否有需要添加的道具或者货币
    --- 如果有就直接添加
    local matMap = _checkHairMat(id)
    _sendItemAddCommand(matMap)

    --- 请求获取
    local l_msgId = Network.Define.Rpc.ChangeHair
    ---@type UseItemArg
    local l_sendInfo = GetProtoBufSendTable("UseItemArg")
    l_sendInfo.hair_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--- 通过GM指令直接修改眼睛
function ReqGmChangeEye(msg)
    if nil == msg then
        logError("[Wardrobe] msg got nil")
        return
    end

    --- 检查是否有需要添加的道具或者货币
    --- 如果有就直接添加
    local matMap = _checkEyeMat(msg.eye_id, msg.eye_style_id)
    _sendItemAddCommand(matMap)

    --- 请求获取
    local l_msgId = Network.Define.Rpc.ChangeEye
    ---@type ChangeEyeArg
    local l_sendInfo = GetProtoBufSendTable("ChangeEyeArg")
    l_sendInfo.eye_id = msg.eye_id
    l_sendInfo.eye_style_id = msg.eye_style_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

---@param matMap table<number, number>
function _sendItemAddCommand(matMap)
    if GameEnum.ELuaBaseType.Table ~= type(matMap) then
        logError("[Wardrobe] invalid param")
        return
    end

    for itemTID, needCount in pairs(matMap) do
        local formatStr = C_STR_GM_CMD_ADD_ITEM
        if nil ~= C_COIN_HASH_MAP[itemTID] then
            formatStr = C_STR_GM_CMD_ADD_MONEY
        end

        local gmCmd = StringEx.Format(formatStr, itemTID, needCount)
        gmMgr.SendCommand(gmCmd)
    end
end

--- 返回美瞳材料ID和需要数量
---@return table<number, number>
function _checkEyeMat(eyeID, eyeStyleID)
    if GameEnum.ELuaBaseType.Number ~= type(eyeID)
            or GameEnum.ELuaBaseType.Number ~= type(eyeStyleID)
    then
        logError("[Wardrobe] invalid param type: " .. type(eyeID) .. " " .. type(eyeStyleID))
        return nil
    end

    local eyeConfig = TableUtil.GetEyeTable().GetRowByEyeID(eyeID, false)
    local eyeStyleConfig = TableUtil.GetEyeStyleTable().GetRowByEyeStyleID(eyeStyleID, false)
    if nil == eyeConfig or nil == eyeStyleConfig then
        logError("[Wardrobe] config not found, eye id: " .. tostring(eyeID) .. " eye style id: " .. tostring(eyeStyleID))
        return {}
    end

    local ret = {}

    --- 获取材料数量
    for i = 0, eyeStyleConfig.ItemCost.Length - 1, 1 do
        local itemID = tonumber(eyeStyleConfig.ItemCost[i][0])
        local itemCount = tonumber(eyeStyleConfig.ItemCost[i][1])
        ret[itemID] = itemCount
    end

    --- 获取染色价格
    local dyeItemID = tonumber(eyeStyleConfig.MoneyCost[0])
    local dyeItemCount = tonumber(eyeStyleConfig.MoneyCost[1])
    if nil ~= ret[dyeItemID] then
        ret[dyeItemID] = ret[dyeItemID] + dyeItemCount
    else
        ret[dyeItemID] = dyeItemCount
    end

    --- 获取眼睛本身价格
    local itemID = tonumber(eyeConfig.EyePrice[0])
    local itemCount = tonumber(eyeConfig.EyePrice[1])
    if nil ~= ret[itemID] then
        ret[itemID] = ret[itemID] + itemCount
    else
        ret[itemID] = itemCount
    end

    return ret
end

--- 返回发型材料ID和需要数量
---@return table<number, number>
function _checkHairMat(hairID)
    if GameEnum.ELuaBaseType.Number ~= type(hairID) then
        logError("[Wardrobe] invalid param type: " .. type(hairID))
        return nil
    end

    local hairStyleConfig = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(hairID, false)
    local hairConfig = TableUtil.GetBarberTable().GetRowByBarberID(hairStyleConfig.BarberID, false)
    if nil == hairConfig or nil == hairStyleConfig then
        logError("[Wardrobe] hair config not found, id: " .. tostring(hairID))
        return {}
    end

    local ret = {}
    for i = 0, hairStyleConfig.ItemCost.Length - 1, 1 do
        local itemID = hairStyleConfig.ItemCost[i][0]
        local itemCount = hairStyleConfig.ItemCost[i][1]
        ret[itemID] = itemCount
    end

    --- 获取染色价格
    local dyeItemID = tonumber(hairStyleConfig.MoneyCost[0])
    local dyeItemCount = tonumber(hairStyleConfig.MoneyCost[1])
    if nil ~= ret[dyeItemID] then
        ret[dyeItemID] = ret[dyeItemID] + dyeItemCount
    else
        ret[dyeItemID] = dyeItemCount
    end

    --- 获取眼睛本身价格
    local itemID = tonumber(hairConfig.BarberPrice[0])
    local itemCount = tonumber(hairConfig.BarberPrice[1])
    if nil ~= ret[itemID] then
        ret[itemID] = ret[itemID] + itemCount
    else
        ret[itemID] = itemCount
    end

    return ret
end