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
---@class ChooseGiftItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field tog MoonClient.MLuaUICom
---@field SelectBtn MoonClient.MLuaUICom
---@field rawImage MoonClient.MLuaUICom
---@field giftSelect MoonClient.MLuaUICom
---@field giftNum MoonClient.MLuaUICom
---@field giftName MoonClient.MLuaUICom
---@field giftImage MoonClient.MLuaUICom
---@field giftBG MoonClient.MLuaUICom

---@class ChooseGiftItemTemplate : BaseUITemplate
---@field Parameter ChooseGiftItemTemplateParameter

ChooseGiftItemTemplate = class("ChooseGiftItemTemplate", super)
--lua class define end

--lua functions
function ChooseGiftItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChooseGiftItemTemplate:OnDestroy()
	
	    self:Clear()
	
end --func end
--next--
function ChooseGiftItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ChooseGiftItemTemplate:OnSetData(data)
	
	    self:Clear()
	    local itemData = TableUtil.GetItemTable().GetRowByItemID(data.id)
	    if not itemData then return end
	    self.Parameter.rawImage:SetActiveEx(false)
	    self.Parameter.giftBG:SetActiveEx(true)
	        self.Parameter.rawImage:AddClick(function()
	            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemData.ItemID, self.Parameter.rawImage.transform, Data.BagModel.WeaponStatus.CHOOSE_GIFT)
	        end)
	    self.Parameter.giftBG:AddClick(function()
	        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemData.ItemID, self.Parameter.giftBG.transform, Data.BagModel.WeaponStatus.CHOOSE_GIFT)
	    end)
	    self.Parameter.SelectBtn:AddClick(function()
	        self:OnClick(data)
	    end)
	    if self.modelObj then
	        self:DestroyUIModel(self.modelObj)
	        self.modelObj = nil
	    end
	    if data.type == GameEnum.ChooseGiftType.HeadWear then  --头饰
	        self.Parameter.rawImage:SetActiveEx(true)
	        self.Parameter.giftImage:SetActiveEx(false)
	            self.Parameter.giftBG:SetActiveEx(false)
	        local equipData = TableUtil.GetEquipTable().GetRowById(data.id)
			if equipData then
				local l_modelData = 
				{
					itemId = data.id,
					rawImage = self.Parameter.rawImage.RawImg
				}
	            self.modelObj = self:CreateUIModelByItemId(l_modelData)
	            self.modelObj:AddLoadModelCallback(function(m)
	                if equipData then
	                    if equipData.EquipId == 7
	                            or equipData.EquipId == 8
	                            or equipData.EquipId == 9
	                            or equipData.EquipId == 10 then
	                        self.modelObj.Trans:SetLocalRotEuler(-90,-180,0)
                            self.modelObj.Trans:SetLocalScale(2, 2, 2)
	                        self.modelObj.Trans:SetLocalPos(0,self:SetPosByType(equipData.EquipId),0)
	                    else
	                        self.modelObj.Trans:SetLocalRotEuler(0,-180,0)
	                    end
	                    self.tween = self.modelObj.Trans:DOLocalRotate(
	                            Vector3.New(self.modelObj.Trans.localEulerAngles.x,360,0), 4)
	                    self.tween:SetLoops(-1,DG.Tweening.LoopType.Incremental)
	                    self.tween:SetEase(DG.Tweening.Ease.Linear)
	                end
	                self.Parameter.rawImage:SetActiveEx(true)
	            end)
	        end
	    elseif data.type == GameEnum.ChooseGiftType.Vehicle then  --载具
	        self.Parameter.rawImage:SetActiveEx(true)
	        self.Parameter.giftImage:SetActiveEx(false)
	            self.Parameter.giftBG:SetActiveEx(false)
	        local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(data.id)
			if l_vehicle then
				local l_modelData = 
				{
					prefabPath = string.format("Prefabs/%s", l_vehicle.Actor),
					rawImage = self.Parameter.rawImage.RawImg,
					defaultAnim = string.format("Anims/Mount/%s/%s_Idle", l_vehicle.Actor, l_vehicle.Actor),
				}
	            self.modelObj = self:CreateUIModelByPrefabPath(l_modelData)
	            self.modelObj:AddLoadModelCallback(function(m)
	                self.modelObj.Trans:SetLocalScale(1, 1, 1)
	                self.modelObj.Position = Vector3.New(0, 0.4, 0)
	                self.modelObj.Trans:SetLocalRotEuler(0,-180,0)
	                self.Parameter.rawImage:SetActiveEx(true)
	            end)
	        end
	    else
	        self.Parameter.giftBG.Img.raycastTarget = true
	        self.Parameter.rawImage:SetActiveEx(false)
	        self.Parameter.giftImage:SetActiveEx(true)
	            self.Parameter.giftBG:SetActiveEx(true)
	        self.Parameter.giftImage:SetSpriteAsync(itemData.ItemAtlas, itemData.ItemIcon, nil, true)
	    end
	    local bgIcon = Data.BagModel:getItemBigBg(itemData.ItemQuality)
	    self.Parameter.giftBG:SetSpriteAsync("Common", bgIcon)
	    self.Parameter.giftName.LabText = itemData.ItemName
	    self.Parameter.giftNum:SetActiveEx(data.num > 1)
	    self.Parameter.giftNum.LabText = data.num
	    self.Parameter.tog.Tog.isOn = false
	    --刷新布局
	    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.tog.RectTransform)
	
end --func end
--next--
function ChooseGiftItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ChooseGiftItemTemplate:OnClick(data)
    local pool = data.pool
    if pool then
        local selectData = pool:GetCurrentSelectTemplateData()
        if not selectData or selectData ~= data then
            pool:CancelSelectTemplate()
            data.pool:SelectTemplate(self.ShowIndex)
        end
        if data.ctrl then
            data.ctrl:SelectItem(data)
        end
    end
end

function ChooseGiftItemTemplate:OnSelect()
    self.Parameter.giftSelect:SetActiveEx(true)
    self.Parameter.tog.Tog.isOn = true

    self.MethodCallback()
end

function ChooseGiftItemTemplate:OnDeselect()
    self.Parameter.giftSelect:SetActiveEx(false)
    self.Parameter.tog.Tog.isOn = false
end

function ChooseGiftItemTemplate:SetPosByType(itemType)
    if itemType == 7 then
        return 0.75
    elseif itemType == 8 then
        return 0.9
    elseif itemType == 9 then
        return 1.15
    elseif itemType == 10 then
        return 0.9
    end
    return 0.5
end

function ChooseGiftItemTemplate:Clear()
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    if self.modelObj then
        self:DestroyUIModel(self.modelObj)
        self.modelObj = nil
    end
end
--lua custom scripts end
return ChooseGiftItemTemplate