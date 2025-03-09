--- 因为现在很多代码是通过调用cs的变量来保存数据的
--- 所以在更新的时候需要带着这些数据以并更新
---@module ModuleMgr.VirtualItemMgr
module("ModuleMgr.VirtualItemMgr", package.seeall)

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local delegateMgr = MgrMgr:GetMgr("DelegateModuleMgr")
local virtualItemType = GameEnum.l_virProp

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onVirtualItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnBagEarlyUpdate, _onVirtualItemUpdate)
end

function _onVirtualItemUpdate()
    local targetItems = _getVirtualItems()
    for i = 1, #targetItems do
        local singleItem = targetItems[i]
        local singleItemTid = singleItem.TID
        local singleItemCount = singleItem.ItemCount
        _updateVirtualItemCountCs(singleItemTid, singleItemCount)
    end

    _updateItemOnSecondCheck()

    --Data.PlayerInfoModel:setBaseExpBlessData(MPlayerInfo.BlessExpRate)
    --Data.PlayerInfoModel:setJobExpBlessData(MPlayerInfo.BlessJobExpRate)
    Data.PlayerInfoModel:setBaseExpData(MPlayerInfo.ExpRate)
    Data.PlayerInfoModel:setJobExpData(MPlayerInfo.JobExpRate)
    Data.PlayerInfoModel:DispatchCoinChange()
end

--- 服务器如果道具数据为零了会直接干掉实例数据，所以可能一个分数没有了，但是没更新
function _updateItemOnSecondCheck()
    for enumName, id in pairs(virtualItemType) do
        local count = _getVirtualItemCountByID(id)
        _updateVirtualItemCountCs(id, count)
    end
end

--- cs当中的变量全是long
function _updateVirtualItemCountCs(id, value)
    if nil == id or nil == value then
        logError("[VirtualItemMgr] invalid param")
        return
    end

    if id == virtualItemType.exp then
        MPlayerInfo.Exp = value
        --MPlayerInfo.BlessExp = value
    elseif id == virtualItemType.jobExp then
        MPlayerInfo.JobExp = value
        --MPlayerInfo.BlessJobExp = value
    elseif id == virtualItemType.Coin104 then
        MPlayerInfo.Coin104 = value
    elseif id == virtualItemType.Coin103 then
        MPlayerInfo.Coin103 = value
    elseif id == virtualItemType.Coin101 then
        MPlayerInfo.Coin101 = value
    elseif id == virtualItemType.Coin102 then
        MPlayerInfo.Coin102 = value
    elseif id == virtualItemType.Yuanqi then
        MPlayerInfo.Yuanqi = value
    elseif id == virtualItemType.BoliPoint then
        MPlayerInfo.BoliPoint = value
    elseif id == virtualItemType.GuildContribution then
        MPlayerInfo.GuildContribution = value
    elseif id == virtualItemType.ArenaCoin then
        MPlayerInfo.ArenaCoin = value
    elseif id == virtualItemType.Prestige then
        MPlayerInfo.Prestige = value
    elseif id == virtualItemType.AssistCoin then
        MPlayerInfo.AssistCoin = value
    elseif id == virtualItemType.MonsterCoin then
        MPlayerInfo.MonsterCoin = value
    elseif id == virtualItemType.Certificates then
        MPlayerInfo.CertificatesCount = value
    elseif id == virtualItemType.Debris then
        MPlayerInfo.Debris = value
    elseif delegateMgr.IsMedal(id) then
        delegateMgr.SetMedal(id, value)
    elseif id == virtualItemType.MerchantCoin then
        MPlayerInfo.MerchantCoin = value
    else
        -- 为了配合原来客户端的一些代码处理，这部分保留，如果进入到了这个说明是新添加的虚拟道具类型
        -- logError("[VirtualItemMgr] unknown virtual item id: " .. tostring(id))
    end
end

---@return int64
function _getVirtualItemCountByID(id)
    local types = { GameEnum.EBagContainerType.VirtualItem }
    local count = Data.BagApi:GetItemCountByContListAndTid(types, id)
    return count
end

---@return ItemData[]
function _getVirtualItems()
    local types = { GameEnum.EBagContainerType.VirtualItem }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

return ModuleMgr.VirtualItemMgr