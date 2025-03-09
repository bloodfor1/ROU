--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class BodyEquipTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogShoe MoonClient.MLuaUICom
---@field TogRide MoonClient.MLuaUICom
---@field TogOrnaR MoonClient.MLuaUICom
---@field TogOrnaL MoonClient.MLuaUICom
---@field TogMouth MoonClient.MLuaUICom
---@field TogMainWeap MoonClient.MLuaUICom
---@field TogHead MoonClient.MLuaUICom
---@field TogFashion MoonClient.MLuaUICom
---@field TogFace MoonClient.MLuaUICom
---@field TogCloth MoonClient.MLuaUICom
---@field TogCloak MoonClient.MLuaUICom
---@field TogBattleVehicle MoonClient.MLuaUICom
---@field TogBattleBird MoonClient.MLuaUICom
---@field TogBarrow MoonClient.MLuaUICom
---@field TogBack MoonClient.MLuaUICom
---@field TogAssist MoonClient.MLuaUICom
---@field TestButton MoonClient.MLuaUICom
---@field PanelWeapon MoonClient.MLuaUICom
---@field MultiTalentsSelectButtonParent MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field ImgShoeOrg MoonClient.MLuaUICom
---@field ImgShoe MoonClient.MLuaUICom
---@field ImgRideOrg MoonClient.MLuaUICom
---@field ImgRide MoonClient.MLuaUICom
---@field ImgOrnaROrg MoonClient.MLuaUICom
---@field ImgOrnaR MoonClient.MLuaUICom
---@field ImgOrnaLOrg MoonClient.MLuaUICom
---@field ImgOrnaL MoonClient.MLuaUICom
---@field ImgMouthOrg MoonClient.MLuaUICom
---@field ImgMouth MoonClient.MLuaUICom
---@field ImgMainWeapOrg MoonClient.MLuaUICom
---@field ImgMainWeap MoonClient.MLuaUICom
---@field ImgHeadOrg MoonClient.MLuaUICom
---@field ImgHead MoonClient.MLuaUICom
---@field ImgFashionOrg MoonClient.MLuaUICom
---@field ImgFashion MoonClient.MLuaUICom
---@field ImgFaceOrg MoonClient.MLuaUICom
---@field ImgFace MoonClient.MLuaUICom
---@field ImgClothOrg MoonClient.MLuaUICom
---@field ImgCloth MoonClient.MLuaUICom
---@field ImgCloakOrg MoonClient.MLuaUICom
---@field ImgCloak MoonClient.MLuaUICom
---@field ImgBattleVehicleOrg MoonClient.MLuaUICom
---@field ImgBattleVehicle MoonClient.MLuaUICom
---@field ImgBattleBirdOrg MoonClient.MLuaUICom
---@field ImgBattleBird MoonClient.MLuaUICom
---@field ImgBarrowOrg MoonClient.MLuaUICom
---@field ImgBarrow MoonClient.MLuaUICom
---@field ImgBackOrg MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field ImgAssistOrg MoonClient.MLuaUICom
---@field ImgAssist MoonClient.MLuaUICom
---@field AssistMask MoonClient.MLuaUICom

---@class BodyEquipTemplate : BaseUITemplate
---@field Parameter BodyEquipTemplateParameter

BodyEquipTemplate = class("BodyEquipTemplate", super)
--lua class define end

--lua functions
function BodyEquipTemplate:Init()
    super.Init(self)
    self.Parameter.AssistMask:SetActiveEx(false)
    self._weaponImg = {}
    self._weaponImgOrg = {}
    self._model = nil

    --- 会引起模型刷新的槽位类型
    self.C_VALID_MODEL_UPDATE_SLOT_TYPE = {
        [GameEnum.EEquipSlotIdxType.MainWeapon] = 1,
        [GameEnum.EEquipSlotIdxType.Helmet] = 1,
        [GameEnum.EEquipSlotIdxType.MouthGear] = 1,
        [GameEnum.EEquipSlotIdxType.FaceGear] = 1,
        [GameEnum.EEquipSlotIdxType.BackGear] = 1,
    }

    --装备
    self._weaponImg[Data.BagModel.WeapType.Head] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgHead.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Mouth] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgMouth.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.MainWeapon] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgMainWeap.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Cloak] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgCloak.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.OrnaL] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgOrnaL.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Face] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgFace.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Cloth] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgCloth.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Assist] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgAssist.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Shoe] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgShoe.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.OrnaR] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgOrnaR.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Back] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgBack.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Ride] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgRide.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.TROLLEY] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgBarrow.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.BattleHorse] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgBattleVehicle.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.BattleBird] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgBattleBird.Transform, IsActive = false })
    self._weaponImg[Data.BagModel.WeapType.Fashion] = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ImgFashion.Transform, IsActive = false })
    self._weaponImgOrg[Data.BagModel.WeapType.Head] = self.Parameter.ImgHeadOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Mouth] = self.Parameter.ImgMouthOrg
    self._weaponImgOrg[Data.BagModel.WeapType.MainWeapon] = self.Parameter.ImgMainWeapOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Cloak] = self.Parameter.ImgCloakOrg
    self._weaponImgOrg[Data.BagModel.WeapType.OrnaL] = self.Parameter.ImgOrnaLOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Face] = self.Parameter.ImgFaceOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Cloth] = self.Parameter.ImgClothOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Assist] = self.Parameter.ImgAssistOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Shoe] = self.Parameter.ImgShoeOrg
    self._weaponImgOrg[Data.BagModel.WeapType.OrnaR] = self.Parameter.ImgOrnaROrg
    self._weaponImgOrg[Data.BagModel.WeapType.Back] = self.Parameter.ImgBackOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Ride] = self.Parameter.ImgRideOrg
    self._weaponImgOrg[Data.BagModel.WeapType.TROLLEY] = self.Parameter.ImgBarrowOrg
    self._weaponImgOrg[Data.BagModel.WeapType.BattleHorse] = self.Parameter.ImgBattleVehicleOrg
    self._weaponImgOrg[Data.BagModel.WeapType.BattleBird] = self.Parameter.ImgBattleBirdOrg
    self._weaponImgOrg[Data.BagModel.WeapType.Fashion] = self.Parameter.ImgFashionOrg

    self._specialTogs = {}
    --几种根据职业特性显示的Tog定义
    self._specialTogs[Data.BagModel.WeapType.Ride] = self.Parameter.TogRide
    self._specialTogs[Data.BagModel.WeapType.TROLLEY] = self.Parameter.TogBarrow
    self._specialTogs[Data.BagModel.WeapType.BattleHorse] = self.Parameter.TogBattleVehicle
    self._specialTogs[Data.BagModel.WeapType.BattleBird] = self.Parameter.TogBattleBird

    local openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    local functionId=openSystemMgr.eSystemId.EquipMultiTalent
    if self._multiTalentsSelectTemplate == nil then
        if openSystemMgr.IsSystemOpen(functionId) then
            self._multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate", {
                TemplateParent = self.Parameter.MultiTalentsSelectButtonParent.transform
            })
        end
    end
    if self._multiTalentsSelectTemplate then
        self._multiTalentsSelectTemplate:SetData(functionId, { IsOnlyShowSelect = true })
    end
    self.Parameter.TestButton:AddClick(function()
        self:FreshWeapon()
        self:InitShowRole()
        self:InitSpecialProfessionSlot()
    end)
    self:InitShowRole()
    self:InitSpecialProfessionSlot()
    self:FreshWeapon()

end --func end
--next--
function BodyEquipTemplate:BindEvents()
    local bagUpdateMsg = MgrProxy:GetGameEventMgr().OnBagUpdate
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, bagUpdateMsg, self.FreshBodyTemplate, self)
end --func end
--next--
function BodyEquipTemplate:OnDestroy()
    if self._model ~= nil then
        self:DestroyUIModel(self._model)
        self._model = nil
    end
    self._multiTalentsSelectTemplate=nil
end --func end
--next--
function BodyEquipTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function BodyEquipTemplate:OnSetData(data)
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function BodyEquipTemplate:ctor(itemData)
    if itemData == nil then
        itemData = {}
    end
    itemData.TemplatePath = "UI/Prefabs/BodyEquipPrefab"
    super.ctor(self, itemData)
end

---@param itemUpdateDataList ItemUpdateData[]
function BodyEquipTemplate:FreshBodyTemplate(itemUpdateDataList)
    local refreshModel = false
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        if GameEnum.EBagContainerType.Equip == singleUpdateData.OldContType and self:_isItemRefreshModelType(singleUpdateData.OldItem) then
            refreshModel = true
            break
        end

        if GameEnum.EBagContainerType.Equip == singleUpdateData.NewContType and self:_isItemRefreshModelType(singleUpdateData.NewItem) then
            refreshModel = true
            break
        end
    end

    if not refreshModel then
        return
    end

    self:FreshWeapon()
    self:InitShowRole()
    self:InitSpecialProfessionSlot()
end

---@param itemData ItemData
function BodyEquipTemplate:_isItemRefreshModelType(itemData)
    if nil == itemData then
        logError("[BagCtrl] invalid param")
        return false
    end

    local itemSlot = Data.BagTypeClientSvrMap:GetClientEquipSlot(itemData.SvrSlot)
    if nil ~= self.C_VALID_MODEL_UPDATE_SLOT_TYPE[itemSlot] then
        return true
    end

    return false
end

function BodyEquipTemplate:InitShowRole()
    if self._model ~= nil then
        self:DestroyUIModel(self._model)
        self._model = nil
    end

    -- 试穿模型
    local attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), "BodyEquipTemplate", MPlayerInfo.ProID, MPlayerInfo.IsMale, nil)
    attr:SetHair(MPlayerInfo.HairStyle)
    attr:SetFashion(MPlayerInfo.Fashion)
    attr:SetOrnament(MPlayerInfo.OrnamentHead)
    attr:SetOrnament(MPlayerInfo.OrnamentFace)
    attr:SetOrnament(MPlayerInfo.OrnamentMouth)
    attr:SetOrnament(MPlayerInfo.OrnamentBack)
    attr:SetOrnament(MPlayerInfo.OrnamentTail)
    attr:SetEyeColor(MPlayerInfo.EyeColorID)
    attr:SetEye(MPlayerInfo.EyeID)
    attr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    attr:SetWeaponEx(MPlayerInfo.WeaponExFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
    attr:SetFashion(MPlayerInfo.FashionFromBag, true)

    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.ModelImage.RawImg
    l_fxData.attr = attr
    l_fxData.useShadow = false
    l_fxData.width = 768
    l_fxData.height = 768
    l_fxData.defaultAnim = self:GetAnimationByWeapon(MPlayerInfo.WeaponFromBag, attr)
    self._model = self:CreateUIModel(l_fxData)
    self._model:AddLoadModelCallback(function(m)
        self.Parameter.ModelImage.gameObject:SetActiveEx(true)
    end)


end

--根据装备的武器切换待机动画
function BodyEquipTemplate:GetAnimationByWeapon(equipId, attr)
    local l_pro = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProID)
    local l_PresentId = 0
    if MPlayerInfo.IsMale then
        l_PresentId = l_pro.PresentM
    else
        l_PresentId = l_pro.PresentF
    end
    local l_PresentTable = TableUtil.GetPresentTable().GetRowById(l_PresentId)
    if not l_PresentTable then
        logError("l_PresentTable is nil")
        return
    end

    local l_idleAnimPath = nil
    if MPlayerInfo.ProID == 1000 then
        l_idleAnimPath = l_PresentTable.IdleAnim
    else
        -- 不是初心者的话用战斗待机
        local l_equip = TableUtil.GetEquipTable().GetRowById(equipId, true)
        local l_weaponId = 0
        if l_equip then
            l_weaponId = l_equip.WeaponId
            for i = 0, l_PresentTable.IdleFAnim.Length - 1 do
                if tonumber(l_PresentTable.IdleFAnim:get_Item(i, 0)) == l_weaponId then
                    l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(i, 1)
                    break
                end
            end
            --没有动画用默认的
            if not l_idleAnimPath then
                l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(0, 1)
            end
        else
            --身上没有装备则显示时装动画
            l_idleAnimPath = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
            return l_idleAnimPath
        end
    end

    local l_clipPath = MAnimationMgr:GetClipPath(l_idleAnimPath)
    return l_clipPath
end

--根据职业来显示特性格子 如骑士的大嘴鸟格子 等
function BodyEquipTemplate:InitSpecialProfessionSlot()
    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    if l_professionTableInfo == nil then
        logError("ProfessionTable表没有配，id：" .. tostring(MPlayerInfo.ProfessionId))
        return false
    end
    for k, v in pairs(self._specialTogs) do
        v.gameObject:SetActiveEx(false)
    end
    local showSkillSlots = string.ro_split(l_professionTableInfo.BagShowSkillSlot, "|")
    for i = 1, table.maxn(showSkillSlots) do
        if self._specialTogs[tonumber(showSkillSlots[i])] then
            if tonumber(showSkillSlots[i]) == Data.BagModel.WeapType.Ride then
                local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
                --载具的Toggle 判断下载具功能有没有开启
                local l_isOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.VehicleAbility)
                self._specialTogs[tonumber(showSkillSlots[i])]:SetActiveEx(l_isOpen)
            else
                self._specialTogs[tonumber(showSkillSlots[i])]:SetActiveEx(true)
            end
        end
    end
end

function BodyEquipTemplate:FreshWeapon()
    local l_typeTable = Data.BagModel.WeapType

    for k, v in pairs(l_typeTable) do
        local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, v + 1)

        if l_info ~= nil then
            self:ShowWeapon(v, l_info)
        else
            self:HideWeapon(v)
        end
    end

    self:showAssistWithMainWeapon()
end

function BodyEquipTemplate:ShowWeapon(pos, propInfo)
    self._weaponImg[pos]:SetData({ PropInfo = propInfo, IsShowCount = false })
    self._weaponImg[pos]:SetGameObjectActive(true)
    self._weaponImgOrg[pos].gameObject:SetActiveEx(false)
    self._weaponImg[pos].TemplateParent.gameObject:SetActiveEx(true)
end

function BodyEquipTemplate:HideWeapon(pos)
    self._weaponImg[pos]:SetGameObjectActive(false)
    self._weaponImg[pos].TemplateParent.gameObject:SetActiveEx(false)
    self._weaponImgOrg[pos].gameObject:SetActiveEx(true)
end

function BodyEquipTemplate:showAssistWithMainWeapon()
    local mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, Data.BagModel.WeapType.MainWeapon + 1)
    if mainWeapon ~= nil then

        local l_HoldingMode = MgrMgr:GetMgr("EquipMgr").GetEquipHoldingModeById(mainWeapon.TID)
        if l_HoldingMode == MgrMgr:GetMgr("EquipMgr").HoldingModeDouble or l_HoldingMode == MgrMgr:GetMgr("EquipMgr").HoldingModeDoubleHand then

            self:ShowWeapon(Data.BagModel.WeapType.Assist, mainWeapon)
            self.Parameter.AssistMask:SetActiveEx(true)
        end

    end
end
--lua custom scripts end
return BodyEquipTemplate