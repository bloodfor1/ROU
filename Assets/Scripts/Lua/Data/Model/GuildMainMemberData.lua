--- PB解析出来数据，只用于工会的头像显示
module("Data", package.seeall)

---@class GuildMainMemberData
GuildMainMemberData = class("GuildMainMemberData")
local C_DEFAULT_NAME = "NIL"

function GuildMainMemberData._newIndex(table, key, value)
    if nil == table[key] then
        error("[GuildMainMemberData] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

--- 这个类当中定义的都是头像需要的必要数据，非头像需要的不定义
function GuildMainMemberData:ctor()
    local metatable = getmetatable(self)
    metatable.__newindex = nil

    self.UID = 0
    self.Name = C_DEFAULT_NAME
    self.Profession = 1000
    self.Level = 0
    self.HeadIconID = 0
    self.Gender = true
    self.HairID = 0
    self.EyeID = 0
    self.EyeColorID = 0
    self.FashionID = 0
    self.HelmetID = 0
    self.FaceMaskID = 0
    self.MouthGearID = 0
    self.Frame = 0

    metatable.__newindex = self._newIndex
end

--- 接服务器数据的地方
---@param pbData RoleSmallPhotoData
function GuildMainMemberData:UpdateData(pbData)
    if nil == pbData then
        logError("[GuildMainMemberData] invalid param, pb data got nil")
        return
    end

    self.Name = pbData.name
    self.Level = pbData.base_level
    self.Profession = pbData.role_type
    self.Gender = pbData.sex_type
    self.HeadIconID = pbData.outlook.wear_head_portrait_id
    self.EyeID = pbData.outlook.eye.eye_id
    self.EyeColorID = pbData.outlook.eye.eye_style_id
    self.HairID = pbData.outlook.hair_id
    self.FashionID = pbData.outlook.wear_fashion
    self.Frame = self:_getValidFrame(pbData.outlook.portrait_frame)
    self.HelmetID = self:_getEquipIDByPriority(GameEnum.EEquipSlotType.HeadWear, pbData.equip_ids, pbData.outlook.wear_ornament)
    self.FaceMaskID = self:_getEquipIDByPriority(GameEnum.EEquipSlotType.FaceGear, pbData.equip_ids, pbData.outlook.wear_ornament)
    self.MouthGearID = self:_getEquipIDByPriority(GameEnum.EEquipSlotType.MouthGear, pbData.equip_ids, pbData.outlook.wear_ornament)
end

--- 获取角色头像ID，可能是默认的
function GuildMainMemberData:_getValidFrame(frameID)
    local default = MgrMgr:GetMgr("HeadFrameMgr").GetDefault()
    if nil == frameID or 0 >= frameID then
        return default
    end

    return frameID
end

--- 如果有启用饰品，直接用饰品
--- 如果没有启用饰品，直接用装备位
---@param lowPriorityIDs PBuint32[]
---@param highPriorityIDs PBuint32[]
function GuildMainMemberData:_getEquipIDByPriority(slot, lowPriorityIDs, highPriorityIDs)
    local highID = self:_getEquipIDBySlot(slot, highPriorityIDs)
    if 0 ~= highID then
        return highID
    end

    local lowID = self:_getEquipIDBySlot(slot, lowPriorityIDs)
    return lowID
end

--- 根据部位获取id数组中的ID，传出一个ID
---@param idArray PBuint32[]
function GuildMainMemberData:_getEquipIDBySlot(slot, idArray)
    if nil == idArray then
        return 0
    end

    for i = 1, #idArray do
        -- 有的ID可能直接为0，不处理
        if 0 ~= idArray[i].value then
            local equipConfig = TableUtil.GetEquipTable().GetRowById(idArray[i].value, false)
            if equipConfig.EquipId == slot then
                return idArray[i].value
            end
        end
    end

    return 0
end