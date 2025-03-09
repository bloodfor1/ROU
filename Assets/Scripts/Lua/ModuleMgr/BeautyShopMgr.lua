---
--- Created by hu.
--- DateTime: 2018/1/30 16:52
---
---@module BeautyShopMgr
module("ModuleMgr.BeautyShopMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
CHANGE_EYE_SUCCESS = "CHANGE_EYE_SUCCESS"
ON_INIT_SLIDER_VALUE = "ON_INIT_SLIDER_VALUE"

local LimitMgr = MgrMgr:GetMgr("LimitMgr")

MaxLimitCondition = 1
g_eyeInfo = {}

function SynEyeInfo()
    g_eyeInfo = {}
    g_eyeInfo.eyeID = MPlayerInfo.EyeID
    g_eyeInfo.eyeColorID = MPlayerInfo.EyeColorID
    if g_eyeInfo.eyeColorID < 1 then
        g_eyeInfo.eyeColorID = MEntityMgr.PlayerEntity.AttrComp.DefaultEquip.EyeColor
    end

    g_eyeInfo.eyeRowData = GetEyeDataById(g_eyeInfo.eyeID)
    g_eyeInfo.eyeColorRowData = GetEyeColorDataById(g_eyeInfo.eyeColorID)
end

-- message: FashionRecord
function OnSelectRoleNtf(info)
    local pbFashionRecord = info.fashion
    local l_eye_id = pbFashionRecord.eye.eye_id
    local l_eye_style_id = pbFashionRecord.eye.eye_style_id

    g_eyeInfo.own_hairs = pbFashionRecord.own_hairs
    g_eyeInfo.own_eyes = pbFashionRecord.own_eyes

    if l_eye_id ~= nil then
        if l_eye_id > 0 then
            MPlayerInfo.EyeID = l_eye_id
            if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
                MEntityMgr.PlayerEntity.AttrComp:SetEye(l_eye_id)
            end
        end
    end

    if l_eye_style_id ~= nil then
        if l_eye_style_id > 0 then
            MPlayerInfo.EyeColorID = l_eye_style_id
            if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
                MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_eye_style_id)
            end
        end
    end
end
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    OnSelectRoleNtf(l_roleAllInfo)
end
-- message: UnLockEyesArg
function RequestUnlockEye(id)
    local l_msgId = Network.Define.Rpc.UnlockEye
    ---@type UnLockEyesArg
    local l_sendInfo = GetProtoBufSendTable("UnLockEyesArg")
    l_sendInfo.eyes_id  = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- message: UnLockEyesRes
function OnUnlockEye(msg)
    ---@type UnLockEyesRes
    local l_info = ParseProtoBufToTable("UnLockEyesRes", msg)
    if l_info.result ~= 0 then
        logWarn("OnUnlockEye error: " .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    --logError("OnUnlockEye error: " .. l_info.result)
    local l_ui = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.BeautyShop) then
        l_ui = UIMgr:GetUI(UI.CtrlNames.BeautyShop)
    end
    if l_ui ~= nil then
        l_ui:OnUnlockEye()
    end
end

---更改眼睛req
-- msg.totalCost msg.isNotCheck 为快捷付费数据可不传
function ChangeEyeReq(msg)
    if msg.totalCost and msg.totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,msg.totalCost)
        if l_needNum > 0 and not msg.isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                local l_newMsg = 
                {
                    totalCost = msg.totalCost,
                    eye_id = msg.eye_id,
                    eye_style_id = msg.eye_style_id,
                    isNotCheck = true
                }
                ChangeEyeReq(l_newMsg)
            end)
            return
        end
    end
    local l_msgId = Network.Define.Rpc.ChangeEye
    ---@type ChangeEyeArg
    local l_sendInfo = GetProtoBufSendTable("ChangeEyeArg")
    l_sendInfo.eye_id = msg.eye_id
    l_sendInfo.eye_style_id = msg.eye_style_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

---更改眼睛rsp
function ChangeEyeRsp(msg)
    ---@type ChangeEyeRes
    local l_info = ParseProtoBufToTable("ChangeEyeRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    if l_info.eye_id ~= nil then
        if l_info.eye_id > 0 then
            MPlayerInfo.EyeID = l_info.eye_id
            if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
                MEntityMgr.PlayerEntity.AttrComp:SetEye(l_info.eye_id)
            end
        end
    end

    if l_info.eye_style_id ~= nil then
        if l_info.eye_style_id > 0 then
            MPlayerInfo.EyeColorID = l_info.eye_style_id
            if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
                MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_info.eye_style_id)
            end
        end
    end

    SynEyeInfo()
    EventDispatcher:Dispatch(CHANGE_EYE_SUCCESS)
end

---============================================================================

function GetEyeDataById(id)
    local l_data = TableUtil.GetEyeTable().GetRowByEyeID(id)
    return l_data
end

function GetEyeColorDataById(id)
    local l_data = TableUtil.GetEyeStyleTable().GetRowByEyeStyleID(id)
    return l_data
end

function GetAllEyeData()
    local l_eyeData = TableUtil.GetEyeTable().GetTable()
    local l_info = {}
    local l_index = 1
    for k, v in pairs(l_eyeData) do
        l_info[l_index] = v
        l_index = l_index + 1
    end
    table.sort(l_info, function(x, y)
        return x.SortID > y.SortID
    end)
    return l_info
end

---====================

m_sliderValue = -1

function OnInitSlider(table, value)
    m_sliderValue = value
    EventDispatcher:Dispatch(ON_INIT_SLIDER_VALUE)
end

function AddDragListener(btn, callback, endCallBack)
    local l_listener = MUIEventListener.Get(btn)
    l_listener.onDrag = function(go, data)
        callback(data)
    end
    l_listener.onDragEnd = function(go, data)
        endCallBack(data)
    end
end
local CHANGE_ROTATION = 1

--[[
界面转动模型
--]]
function UpdatePlayerRotation(dis)
    local y = MEntityMgr.PlayerEntity.Rotation.eulerAngles.y
    MEntityMgr.PlayerEntity.Rotation = Quaternion.Euler(0, y + dis * CHANGE_ROTATION, 0)
end

function CheckLimit(eyeId)
    local result = true

    local eyeIdRow = GetEyeDataById(eyeId)
    if eyeIdRow ~= nil then
        local eyeIdRowUseItemSeq = Common.Functions.SequenceToTable(eyeIdRow.UseItem)
        if eyeIdRow.UseItem ~= nil and eyeIdRowUseItemSeq[1] ~= 0 then
            if not LimitMgr.CheckUseItemLimitIneye(eyeIdRow.EyeID) then
                result = false
            end
        end
    end

    return result
end

function GetLimitStr(eyeId)
    local data = {}
    local l_eyeRow = TableUtil.GetEyeTable().GetRowByEyeID(eyeId)

    local eyeRowUseItemSeq = Common.Functions.SequenceToTable(l_eyeRow.UseItem)
    if l_eyeRow.UseItem ~= nil and eyeRowUseItemSeq[1] ~= 0 then --道具解锁区别于其他条件解锁
        local item = {}
        item.limitType = LimitMgr.ELimitType.UESITEM_LIMIT
        item.finish = LimitMgr.CheckUseItemLimitIneye(l_eyeRow.EyeID)
        item.UseItemSeq = eyeRowUseItemSeq
        table.insert(data, item)
        return data
    end
    return data
end