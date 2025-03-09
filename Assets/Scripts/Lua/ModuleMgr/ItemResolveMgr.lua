module("ModuleMgr.ItemResolveMgr", package.seeall)

local _itemResolveMgr = {}

function _itemResolveMgr:OnInit()
    self._itemCache = Data.ItemLocalDataCache.new(5)
    ---@type ItemData
    self._targetItem = nil
    ---@type ItemData[]
    self._awardItemList = {}
end

function _itemResolveMgr:OnReconnected()
    -- do nothing
end

function _itemResolveMgr:OnLogout()
    -- do nothing
end

function _itemResolveMgr:OnResolveConfig(msg)
    ---@type ResolveItemRes
    local l_info = ParseProtoBufToTable("ResolveItemRes", msg)
    if ErrorCode.ERR_SUCCESS ~= l_info.error_code then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.error_code)
    end
end

---@param itemData ItemData
function _itemResolveMgr:TryResolveItem(itemData)
    if nil == itemData then
        logError("[ItemResolve] invalid param")
        return
    end

    self._targetItem = itemData
    self:_genAwardData(itemData.TID)
    local str = Common.Utils.Lang("C_RESOLVE_ITEM_CONFIRM", itemData:GetName())
    CommonUI.Dialog.ShowYesNoDlg(true, nil, str, function()
        self:_showSecondConfirmation()
    end, function()
        self:_clearData()
    end, nil, 2, "CARD_RECOVE_TODAY_NO_SHOW")
end

function _itemResolveMgr:_showSecondConfirmation()
    local awardData = {}
    for i = 1, #self._awardItemList do
        local singleData = self._awardItemList[i]
        ---@type ItemTemplateParam
        local param = {
            PropInfo = singleData,
            -- IsShowTips = false,
        }
        table.insert(awardData, param)
    end

    CommonUI.Dialog.ShowCommonRewardDlg(Common.Utils.Lang("RECVOR_REWARD"), awardData, function()
        self:_onConfirmResolve()
    end, function()
        self:_clearData()
    end)
end

function _itemResolveMgr:_onConfirmResolve()
    local l_msgId = Network.Define.Rpc.ResolveItem
    ---@type ResolveItemArg
    local l_sendInfo = GetProtoBufSendTable("ResolveItemArg")
    table.insert(l_sendInfo.item_uid, tostring(self._targetItem.UID))
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    self._targetItem = nil
    self:_clearData()
end

function _itemResolveMgr:_genAwardData(tid)
    local config = TableUtil.GetItemResolveTable().GetRowByID(tid)
    if nil == config then
        logError("[ItemResolve] invalid tid : " .. tid)
        return
    end

    for i = 0, config.ResolveAmount.Length - 1 do
        local itemID = config.ResolveAmount[i][0]
        local itemCount = config.ResolveAmount[i][1]
        local singleData = self._itemCache:GetItemData(itemID)
        singleData.ItemCount = ToInt64(itemCount)
        table.insert(self._awardItemList, singleData)
    end
end

function _itemResolveMgr:_clearData()
    for i = 1, #self._awardItemList do
        local singleItem = self._awardItemList[i]
        self._itemCache:RecycleItemData(singleItem)
    end

    self._awardItemList = {}
end

MgrObj = _itemResolveMgr

function OnInit()
    MgrObj:OnInit()
end

function OnResolveRsp(msg)
    MgrObj:OnResolveConfig(msg)
end

return ModuleMgr.ItemResolveMgr