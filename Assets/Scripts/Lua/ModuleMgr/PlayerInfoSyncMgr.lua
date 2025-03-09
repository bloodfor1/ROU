---@module ModuleMgr.PlayerInfoSyncMgr
module("ModuleMgr.PlayerInfoSyncMgr", package.seeall)

--- 这个管理器收到背包同步消息是在角色同步之前的
local playerSyncMgr = {}

function playerSyncMgr:OnBagSync()
    local E_BAG_CONTAINER_TYPE = GameEnum.EBagContainerType
    local mainWeapon = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
    local helmet = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.Helmet)
    local face = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.FaceGear)
    local mouth = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.MouthGear)
    local back = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.BackGear)
    local fashion = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.Fashion)
    local frame = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.PlayerCustom, GameEnum.ECustomContSvrSlot.HeadFrame)
    local backUpWeapon = Data.BagApi:GetItemByTypeSlot(E_BAG_CONTAINER_TYPE.Equip, GameEnum.EEquipSlotIdxType.BackupWeapon)
    local mainWeaponID = self:_getItemTid(mainWeapon)
    local helmetID = self:_getItemTid(helmet)
    local faceID = self:_getItemTid(face)
    local mouthID = self:_getItemTid(mouth)
    local backID = self:_getItemTid(back)
    local fashionID = self:_getItemTid(fashion)
    local frameID = self:_getItemTid(frame)
    local backUpWeaponID = self:_getItemTid(backUpWeapon)
    MPlayerInfo.WeaponFromBag = mainWeaponID
    MPlayerInfo.WeaponExFromBag = backUpWeaponID
    MPlayerInfo.OrnamentHeadFromBag = helmetID
    MPlayerInfo.OrnamentFaceFromBag = faceID
    MPlayerInfo.OrnamentMouthFromBag = mouthID
    MPlayerInfo.OrnamentBackFromBag = backID
    MPlayerInfo.FashionFromBag = fashionID
    MPlayerInfo.FrameID = frameID
end

--- 这个消息是在onSelectRoleNtf之后的
---@param roleAllInfo RoleAllInfo
function playerSyncMgr:OnPlayerInfoSync(roleAllInfo)
    if nil == roleAllInfo then
        logError("[PlayerSync] role all info got nil")
        return
    end

    local hairID = roleAllInfo.fashion.current_hair_id
    local eyeID = roleAllInfo.fashion.eye.eye_id
    local eyeColorID = roleAllInfo.fashion.eye.eye_style_id
    MPlayerInfo.EyeID = eyeID
    MPlayerInfo.EyeColorID = eyeColorID
    MPlayerInfo.HairStyle = hairID
    local C_PLAYER_INFO_KEY_GEAR_MAP = {
        [GameEnum.EEquipGearType.Head] = "OrnamentHead",
        [GameEnum.EEquipGearType.Face] = "OrnamentFace",
        [GameEnum.EEquipGearType.Mouth] = "OrnamentMouth",
        [GameEnum.EEquipGearType.Back] = "OrnamentBack",
        [GameEnum.EEquipGearType.Tail] = "OrnamentTail",
    }

    for i = 1, #roleAllInfo.fashion.wear_ornament_ids do
        local singleID = roleAllInfo.fashion.wear_ornament_ids[i].value
        local config = TableUtil.GetOrnamentTable().GetRowByOrnamentID(singleID, true)
        if nil ~= config and nil ~= C_PLAYER_INFO_KEY_GEAR_MAP[config.OrnamentType] then
            local key = C_PLAYER_INFO_KEY_GEAR_MAP[config.OrnamentType]
            MPlayerInfo[key] = singleID
        end
    end

    local headIcon = Data.BagApi:GetItemByUID(roleAllInfo.fashion.wear_head_portraut_uid)
    local fashionItem = Data.BagApi:GetItemByUID(roleAllInfo.fashion.wear_fashion_uid)
    local headIconID = self:_getItemTid(headIcon)
    local fashionID = self:_getItemTid(fashionItem)
    MPlayerInfo.Fashion = fashionID
    MPlayerInfo.HeadID = headIconID
end

---@param itemData ItemData
function playerSyncMgr:_getItemTid(itemData)
    if nil == itemData then
        return 0
    end

    return itemData.TID
end

MgrObj = playerSyncMgr

function OnInit()
    local gameEventMgr = MgrProxy:GetGameEventMgr()
    gameEventMgr.Register(gameEventMgr.OnBagSync, MgrObj.OnBagSync, MgrObj)
    gameEventMgr.Register(gameEventMgr.OnPlayerDataSync, MgrObj.OnPlayerInfoSync, MgrObj)
end

function OnLogout()
    -- do nothing
end

function OnReconnected()
    -- do nothing
end