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
---@class VehicleItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemCount MoonClient.MLuaUICom
---@field Img_Selected MoonClient.MLuaUICom
---@field Img_Mask MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field But_Bg MoonClient.MLuaUICom

---@class VehicleItemTemplate : BaseUITemplate
---@field Parameter VehicleItemTemplateParameter

VehicleItemTemplate = class("VehicleItemTemplate", super)
--lua class define end

--lua functions
function VehicleItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function VehicleItemTemplate:OnDestroy()
	
	
end --func end
--next--
function VehicleItemTemplate:OnDeActive()
	
	
end --func end
--next--
function VehicleItemTemplate:OnSetData(data)
	
	    if data == nil then
	        return
	    end
	    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(data.itemId)
	    if l_itemData == nil then
	        return
	    end
	    self:Refresh(data)
	    local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
	    self.Parameter.But_Bg.ConBtn.OnButtonDown = function()
			if not self:IsPropEnough(data.itemId) then
	            return
	        end
	        l_vehicleInfoMgr.SendUpgradeVehicleMsg(data.itemId, 1)
	    end
	    self.Parameter.But_Bg.ConBtn.OnContinuousButton = function()
	        if not self:IsPropEnough(data.itemId) then
	            return
	        end
	        l_vehicleInfoMgr.SendUpgradeVehicleMsg(data.itemId, 1)
	    end
	    self.Parameter.But_Bg.ConBtn.OnButtonUp = function()
			if self.needShowFetchPanel then
				local itemData = Data.BagModel:CreateItemWithTid(data.itemId)
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
			end
			self.needShowFetchPanel = false
	    end
	    self.Parameter.Img_Icon:AddClick(function()
	        local l_extraData = { relativePositionY = -self.Parameter.Img_Icon.RectTransform.rect.size.y / 2, bottomAlign = true }
	        local itemData = Data.BagModel:CreateItemWithTid(data.itemId)
	        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self.Parameter.Img_Icon.Transform, nil, nil, false, l_extraData)
	    end)
	    self.Parameter.Img_Icon:SetSpriteAsync(l_itemData.ItemAtlas, l_itemData.ItemIcon)
	    self.Parameter.GenreText.LabText = string.format(Lang("ADD_EXP_DESC"), data.addExp)
	
end --func end
--next--
function VehicleItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function VehicleItemTemplate:OnSelect()
    self.Parameter.Img_Selected:SetActiveEx(true)
end

function VehicleItemTemplate:OnDeselect()
    self.Parameter.Img_Selected:SetActiveEx(false)
end

function VehicleItemTemplate:IsPropEnough(itemId)
	if self.needShowFetchPanel then
		return
	end
    local l_propNum = Data.BagModel:GetBagItemCountByTid(itemId)

    if l_propNum < 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LACK_VEHICLE_LVUP_PROP"))
		self.needShowFetchPanel = true
        return false
    end

    return true
end
function VehicleItemTemplate:Refresh(data)
    if data == nil then
        return
    end
    local l_propNum = Data.BagModel:GetBagItemCountByTid(data.itemId)
    self.Parameter.ItemCount:SetActiveEx(l_propNum > 0)
    self.Parameter.ItemCount.LabText = tostring(l_propNum)

    local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
    local l_isSuperExpProp = l_vehicleInfoMgr.GetSuperExpPropId() == data.itemId
    if l_isSuperExpProp then
        --特殊材料
        local l_propNum = Data.BagModel:GetBagItemCountByTid(data.itemId)
        self:SetGameObjectActive(l_propNum > 0)
    end

    local l_remainCount, _ = l_vehicleInfoMgr.GetVehicleLvUpItemUseNum()
    self.Parameter.Img_Mask:SetActiveEx(l_remainCount < 1 and (not l_isSuperExpProp))
end
--lua custom scripts end
return VehicleItemTemplate