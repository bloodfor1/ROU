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
---@class GiftBagItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field selected MoonClient.MLuaUICom
---@field received MoonClient.MLuaUICom
---@field ready MoonClient.MLuaUICom
---@field lvTxt MoonClient.MLuaUICom
---@field lock MoonClient.MLuaUICom
---@field icon MoonClient.MLuaUICom
---@field boxMask MoonClient.MLuaUICom
---@field box MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom

---@class GiftBagItemTemplate : BaseUITemplate
---@field Parameter GiftBagItemTemplateParameter

GiftBagItemTemplate = class("GiftBagItemTemplate", super)
--lua class define end

--lua functions
function GiftBagItemTemplate:Init()
	
	    super.Init(self)
	    self.status = GameEnum.RewardGiftStatus.Lock
	    self.data = nil
	    self.mgr = MgrMgr:GetMgr("LevelRewardMgr")
	
end --func end
--next--
function GiftBagItemTemplate:OnDestroy()
	
	    MLuaUIListener.Destroy(self:gameObject())
	    self.status = GameEnum.RewardGiftStatus.Lock
	    self.data = nil
	
end --func end
--next--
function GiftBagItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GiftBagItemTemplate:OnSetData(data)
	    self.data = data
	    local lv = data.sdata.Base
	    local status = self:GetGiftStatus(data)
	    self.Parameter.box:SetActiveEx(status == GameEnum.RewardGiftStatus.CanTake or status == GameEnum.RewardGiftStatus.Lock)
	    self.Parameter.ready:SetActiveEx(status == GameEnum.RewardGiftStatus.CanTake)
	    self.Parameter.boxMask:SetActiveEx(status == GameEnum.RewardGiftStatus.Lock)
	    self.Parameter.lock:SetActiveEx(status == GameEnum.RewardGiftStatus.Lock)
	    self.Parameter.received:SetActiveEx(status == GameEnum.RewardGiftStatus.Taked)
	    self.Parameter.selected:SetActiveEx((data.ctrl and data.ctrl.lastChooseItem == self) and true or false)
	    if status == GameEnum.RewardGiftStatus.Lock then
	        self.Parameter.icon:SetActiveEx(false)
	    elseif status == GameEnum.RewardGiftStatus.CanTake then
	        self.Parameter.icon:SetActiveEx(false)
	    elseif status == GameEnum.RewardGiftStatus.CanBuy then
	        self.Parameter.icon:SetActiveEx(true)
	    elseif status == GameEnum.RewardGiftStatus.Taked then
	        self.Parameter.icon:SetActiveEx(true)
	    end
	    self.Parameter.lvTxt.LabText = Lang("REVEL_REWARD_LEVEL", lv)
	    self.Parameter.bg:AddClick(function()
	        if status == GameEnum.RewardGiftStatus.Lock then
	            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LEVEL_REWARD_CAN_NOT_TAKE"))
	        end
	        if data.ctrl then
	            data.ctrl:ChooseItem(self)
	        end
	    end)
	    self.Parameter.ready:AddClick(function()
	        if data.ctrl then
	            data.ctrl:ChooseItem(self)
	            self.mgr.ReceiveLevelGift(data.sdata.Id, 0)
	        end
	    end)
	    self.status = status
	    --if data.ctrl then
	    --    data.ctrl:RefreshBags(self)
	    --end
	end --func end
	function GiftBagItemTemplate:Select(flag)
	    self.Parameter.selected:SetActiveEx(flag)
	end
	function GiftBagItemTemplate:GetGiftStatus(data)
	    local status = GameEnum.RewardGiftStatus.Lock
	    if MPlayerInfo.Lv >= data.sdata.Base then
	        local freePackage = data.sdata.FreeBasePackage
	        local salePackage = data.sdata.SaleBasePackage
	        local isGetFree, isBuySale = true, true
	        if freePackage.Count > 0 then
	            isGetFree = data[0] == 1
	        end
	        if salePackage.Count > 0 then
	            isBuySale = data[1] == 1
	        end
	        if freePackage.Count > 0 and salePackage.Count > 0 then
	            if isGetFree and isBuySale then
	                status = GameEnum.RewardGiftStatus.Taked
	            elseif isGetFree then
	                status = GameEnum.RewardGiftStatus.CanBuy
	            else
	                status = GameEnum.RewardGiftStatus.CanTake
	            end
	        elseif freePackage.Count > 0 then
	            if isGetFree then
	                status = GameEnum.RewardGiftStatus.Taked
	            else
	                status = GameEnum.RewardGiftStatus.CanTake
	            end
	        else
	            if isBuySale then
	                status = GameEnum.RewardGiftStatus.Taked
	            else
	                status = GameEnum.RewardGiftStatus.CanBuy
	            end
	        end
	    end
	    return status
	end
	function GiftBagItemTemplate:GetCurrentStatus()
	    return self.status
	end
	function GiftBagItemTemplate:GetId()
	    return self.data.sdata.Id
	end --func end
	function GiftBagItemTemplate:GetCost()
	    local ret = 0
	    if self.data.sdata.SaleBasePackagePrice.Count > 0 then
	        ret = self.data.sdata.SaleBasePackagePrice[0][1]
	    end
	    return ret
	end
	function GiftBagItemTemplate:GetLv()
	    return self.data.sdata.Base
	end
	function GiftBagItemTemplate:GetCostId()
	    local ret = 0
	    if self.data.sdata.SaleBasePackagePrice.Count > 0 then
	        ret = self.data.sdata.SaleBasePackagePrice[0][0]
	    end
	    return ret
	
end --func end
--next--
function GiftBagItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GiftBagItemTemplate:ctor(templateData)
    super.ctor(self, templateData)

    self.data = templateData.Data
end
--lua custom scripts end
return GiftBagItemTemplate