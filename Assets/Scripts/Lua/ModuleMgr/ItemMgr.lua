---@module ModuleMgr.ItemMgr
module("ModuleMgr.ItemMgr", package.seeall)

-------------------道具数据请求-----------------
RequestData = {}  --请求数据
CacheData = {}    --缓存数据

--通过服务器数据那道具数据:在请求中的角色不过重复请求
--uid：道具uid (uint64)
--rid: 角色uid (uint64)
function GetItemByUniqueId(uid, func)
    local l_funcType = type(func)
    if l_funcType ~= "function" then
        logError("回调func的类型非法 => func Type=" .. l_funcType)
        return
    end

    --自己发的道具则显示包里的道具信息
    local selfItemInfo = GetSelfItemInfo(uid)
    if selfItemInfo then
        func(selfItemInfo, 0)
        return
    end

    local l_uidSt = uid
    local l_key = l_uidSt
    local l_funcArray = RequestData[l_key] or {}
    RequestData[l_key] = l_funcArray
    l_funcArray[#l_funcArray + 1] = func
    if #l_funcArray <= 1 then
        local l_msgId = Network.Define.Rpc.GetItemByUid
        ---@type GetItemByUidArg
        local l_sendInfo = GetProtoBufSendTable("GetItemByUidArg")
        l_sendInfo.item_uid = l_uidSt
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

--接收道具信息
function OnGetItemByUid(msg, arg)
    ---@type GetItemByUidRes
    local l_resInfo = ParseProtoBufToTable("GetItemByUidRes", msg)
    local l_error = l_resInfo.result or 0
    local l_item = l_resInfo.ro_item_content
    local l_funcArray = nil
    ---@type ItemData
    local l_itemInfo = nil
    if ErrorCode.ERR_SUCCESS == l_error then
        l_itemInfo = Data.BagApi:CreateFromRoItemData(l_item)
        local l_key = l_itemInfo.UID
        l_funcArray = RequestData[l_key] or {}
        RequestData[l_key] = nil
    else
        logError("l_resInfo.result=" .. tostring(l_resInfo.result))
        return
    end

    for i = 1, #l_funcArray do
        local l_func = l_funcArray[i]
        l_func(l_itemInfo, l_error)
    end
end

---@return ItemData
function _getItemsByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag
    }

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--获取自身的装备信息
function GetSelfItemInfo(uid)
    return _getItemsByUID(uid)
end

--[Comment]
--获取物品的标题格式化文本信息
--@param table opts 配置选项{level, num, name, color, prefix, suffix, icon={size, width, anim}}
--@return 示例：<color="xxx">[物品名]</color> x num
GetItemText = function(id, opts)
    opts = type(opts) == "table" and opts or {}
    id = tonumber(id)
    if id == nil then
        logError("[GetItemText]id is not a valid number:{0}", tostring(id))
        return ""
    end
    local l_item = TableUtil.GetItemTable().GetRowByItemID(id)
    if l_item == nil then
        return ""
    end
    local l_itemName = opts.name and opts.name or l_item.ItemName
    opts.level = tonumber(opts.level) or 0
    if opts.level > 0 then
        l_itemName = l_itemName .. "+" .. tostring(opts.level)
    end

    if opts.prefix then
        l_itemName = tostring(opts.prefix) .. l_itemName
    end
    if opts.suffix then
        l_itemName = l_itemName .. tostring(opts.suffix)
    end

    --color
    if not opts.color then
        if not opts.rm_color then
            -- 只给有品质的道具 添加品质色
            if l_item.ItemQuality ~= 0 then
                l_itemName = GetColorText(l_itemName, RoQuality.GetColorTag(l_item.ItemQuality))
            end
        end
    end

    --num
    -- todo 这个地方的num可能是int64，也可能是number，也有可能是string，所以这里统一处理成int64
    opts.num = ToInt64(opts.num)
    if opts.num > 0 then
        if MgrMgr:GetMgr("PropMgr").IsCoin(id) then
            l_itemName = l_itemName .. " x " .. MNumberFormat.GetNumberFormat(tostring(opts.num))
        else
            l_itemName = l_itemName .. " x " .. tostring(opts.num)
        end
    end

    --color
    if opts.color then
        l_itemName = GetColorText(l_itemName, opts.color)
    end
    if opts.icon then
        local l_icon = GetImageText(l_item.ItemIcon, l_item.ItemAtlas, opts.icon.size, opts.icon.width, opts.icon.anim)
        opts.icon.before = opts.icon.before or true
        if opts.icon.before then
            l_itemName = l_icon .. l_itemName
        else
            l_itemName = l_itemName .. l_icon
        end
    end

    return l_itemName
end

--[Comment]
--根据itemId生成物品icon文本信息
--@return <quad xxxxxx />
function GetItemIconText(itemId, size, width, anim)
    itemId = tonumber(itemId)
    if itemId == nil then
        logError("[GetItemIconText]itemId is not a valid number:{0}", tostring(itemId))
        return ""
    end

    local l_item = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if l_item == nil then
        return ""
    end

    return GetImageText(l_item.ItemIcon, l_item.ItemAtlas, size, width, anim)
end

-- 检测货币
function CheckMoney(itemId, cost)
    local l_enough = false
    if itemId == MgrMgr:GetMgr("PropMgr").l_virProp.Coin101 then
        l_enough = MPlayerInfo.Coin101 >= cost
        if not l_enough then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
        end
    elseif itemId == MgrMgr:GetMgr("PropMgr").l_virProp.Coin102 then
        l_enough = MPlayerInfo.Coin102 >= cost
        if not l_enough then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ZENY_NOT_ENOUGH"))
        end
    elseif itemId == MgrMgr:GetMgr("PropMgr").l_virProp.Coin103 or itemId == MgrMgr:GetMgr("PropMgr").l_virProp.Coin104 then
        l_enough = Data.BagModel:GetCoinOrPropNumById(103) >= cost
        if not l_enough then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
        end
    end
    return l_enough
end

-- 设置物品图标
function SetItemSprite(iconImg, itemId)
    local l_row = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if iconImg and l_row then
        iconImg:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
    end
end

function GetIconRichImage(itemId)
    local l_iconStr = ""
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if l_itemRow then
        l_iconStr = Lang("RICH_IMAGE", l_itemRow.ItemIcon, l_itemRow.ItemAtlas, 20, 1)
    end
    return l_iconStr
end

return ModuleMgr.ItemMgr