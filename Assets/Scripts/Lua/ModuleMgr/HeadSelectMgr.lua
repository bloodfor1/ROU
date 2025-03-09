require "Data/Model/BagModel"

---@module ModuleMgr.HeadSelectMgr
module("ModuleMgr.HeadSelectMgr", package.seeall)

CurSelectedHead = {}
CurSelectedHead.id = 0
CurSelectedHead.uid = 0
CurSelectedHead.selected = nil
CurUID = 0
HeadInfo = {}
TempHeadInfo = {}
EventDispatcher = EventDispatcher.new()

ON_SELECT_HEAD_ITEM = "ON_SELECT_HEAD_ITEM"
UPDATE_HEAD_SELF = "UPDATE_HEAD_SELF"
UPDATE_HEAD_TARGET = "UPDATE_HEAD_TARGET"

function OnInit()
    HeadInfo = {}
    ---@type ProfilePhotoTable[]
    local l_rows = TableUtil.GetProfilePhotoTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        local l_index = #HeadInfo + 1
        HeadInfo[l_index] = {}
        HeadInfo[l_index].tableInfo = l_row
    end
end

---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    local l_curHead = info.fashion.wear_head_portraut_uid or 0
    CurUID = l_curHead
    _refreshHeadIcon()
end

--- 角色数据同步是背包数据先同步，角色数据后同步的；所以在角色数据同步的时候要更新数据
function _refreshHeadIcon()
    local icons = _getAllIcons()
    if 0 == #icons then
        return
    end

    for i = 1, #icons do
        local singleIcon = icons[i]
        if tostring(singleIcon.UID) == tostring(CurUID) then
            MPlayerInfo.HeadID = singleIcon.TID
            if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
                MEntityMgr.PlayerEntity.AttrComp:SetHead(singleIcon.TID)
            end

            return
        end
    end
end

--- 获取所有的玩家头像
---@return ItemData[]
function _getAllIcons()
    local containerTypes = { GameEnum.EBagContainerType.HeadIcon }
    local ret = Data.BagApi:GetItemsByTypesAndConds(containerTypes, nil)
    return ret
end

---@return ItemData[]
function HeadInfoList(propIdList)
    local l_table = _getAllIcons()
    if 0 >= #l_table then
        return {}
    end

    local l_result = {}
    for i = 1, #l_table do
        local l_id = l_table[i].TID
        if propIdList[l_id] then
            table.insert(l_result, l_table[i])
        end
    end

    return l_result
end

function InitMgrNetData()
    CurSelectedHead = {
        id = 0,
        uid = 0,
        selected = nil
    }

    if #HeadInfo > 0 then
        for i = 1, #HeadInfo do
            local l_id = HeadInfo[i].tableInfo.ProfilePhotoID
            HeadInfo[i].target = nil
            HeadInfo[i].have = 0

            -- 这是一个hashMap，只需要key
            local l_result = HeadInfoList({ [l_id] = 1 })
            for ii = 1, #l_result do
                local l_temp = l_result[ii]
                if l_temp.ItemCount > 0 then
                    HeadInfo[i].target = l_temp
                    HeadInfo[i].have = l_temp.ItemCount
                    break
                end
            end
        end

        table.sort(HeadInfo, function(x, y)
            return x.tableInfo.SortID < y.tableInfo.SortID
        end)
        table.sort(HeadInfo, function(x, y)
            return x.have > y.have
        end)

        for i = 1, #HeadInfo + 1 do
            TempHeadInfo[i] = {}
            if i == 1 then
                TempHeadInfo[i].tableInfo = "default"
                TempHeadInfo[i].target = nil
                TempHeadInfo[i].have = 1
            end

            if i > 1 then
                TempHeadInfo[i].tableInfo = HeadInfo[i - 1].tableInfo
                TempHeadInfo[i].target = HeadInfo[i - 1].target
                TempHeadInfo[i].have = HeadInfo[i - 1].have
            end
        end
    end
end

function UpdateHead(uid)
    if MPlayerInfo.UID == uid then
        EventDispatcher:Dispatch(UPDATE_HEAD_SELF, uid)
    else
        EventDispatcher:Dispatch(UPDATE_HEAD_TARGET, uid)
    end
end

function SendWearHeadPortraitReq(id, uid)
    local l_msgId = Network.Define.Rpc.WearHeadPortrait
    ---@type WearHeadPortraitArs
    local l_sendInfo = GetProtoBufSendTable("WearHeadPortraitArs")
    l_sendInfo.head_portrait_uid = uid
    local l_headId = MEntityMgr.PlayerEntity.AttrComp.EquipData.HeadID
    l_sendInfo.is_on = l_headId == 0 or l_headId ~= id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnWearHeadPortraitRsp(msg, arg)
    ---@type WearHeadPortraitRes
    local l_info = ParseProtoBufToTable("WearHeadPortraitRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    else
        if arg.is_on then
            CurUID = arg.head_portrait_uid
            UpdateHead(CurUID)
        else
            CurUID = 0
        end
    end

    DataMgr:GetData("SelectRoleData").UpdateHeadInfo(CurUID)
end

function GetDefaultEquipData(id)
    local l_roleEquipData = MEntityMgr.PlayerEntity.AttrComp.EquipData
    local l_equipData = MoonClient.MEquipData.New()
    l_equipData.IsMale = MPlayerInfo.IsMale
    l_equipData.ProfessionID = MPlayerInfo.ProID
    l_equipData.OrnamentHeadItemID = l_roleEquipData.OrnamentHeadItemID or 0
    l_equipData.OrnamentMouthItemID = l_roleEquipData.OrnamentMouthItemID or 0
    l_equipData.OrnamentFaceItemID = l_roleEquipData.OrnamentFaceItemID or 0
    l_equipData.OrnamentHeadFromBagItemID = l_roleEquipData.OrnamentHeadFromBagItemID or 0
    l_equipData.OrnamentFaceFromBagItemID = l_roleEquipData.OrnamentFaceFromBagItemID or 0
    l_equipData.OrnamentMouthFromBagItemID = l_roleEquipData.OrnamentMouthFromBagItemID or 0
    l_equipData.FashionItemID = l_roleEquipData.FashionItemID or 0
    l_equipData.FashionFromBagItemID = l_roleEquipData.FashionFromBagItemID or 0
    l_equipData.HairStyleID = l_roleEquipData.HairStyleID or 0
    l_equipData.HeadID = id and id or 0
    return l_equipData
end


-- 打开头像界面并选中特定头像
function OpenHeadUI(photoId)
    UIMgr:ActiveUI(UI.CtrlNames.Personal, {photoId = photoId})
end

return ModuleMgr.HeadSelectMgr