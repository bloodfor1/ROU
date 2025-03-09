--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/ItemCdPartTemplate"

require "Data/Model/BagModel"

--lua requires end

--lua modelItemButton
module("UITemplate", package.seeall)
--lua model end

--lua class define
local super = UITemplate.ItemTemplate
RunningBusinessPotTemplate = class("RunningBusinessPotTemplate", super)
--lua class define end
local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
local l_data = DataMgr:GetData("MerchantData")
--lua functions
function RunningBusinessPotTemplate:Init()
    super.Init(self)
	--全部逻辑写在init里
	self:init()
end --func end
--next--
function RunningBusinessPotTemplate:OnSetData(data)
	--选择data
    self.ShowData = data
    -- 道具基本信息
    self.baseDataInfo.PropInfo = data

    -- 道具数量显示
    if data then
        if data.ItemCount == 1 then
            self.baseDataInfo.IsShowCount = false
        else
            self.baseDataInfo.IsShowCount = true
        end
    end

    -- 显示道具
    super.OnSetData(self, self.baseDataInfo)

    -- cd模块显示
    if not self.cdPart then
        self.cdPart = self:NewTemplate("ItemCdPartTemplate", {
            TemplateParent = self:transform(),
            Data=data,
        })
    else
        self.cdPart:SetData(data)
    end

    -- 无数据就显示为默认的
    if data == nil or self.ShowIndex > l_data.MerchantBusinessBagCount then
        if data ~= nil then
            self:ClearTemplate()
        end
        if self.ShowIndex > l_data.MerchantBusinessBagCount then
            self.Parameter.ItemButton:SetSprite(Data.BagModel:getItemBgAtlas(), l_data.MerchantBusinessLockedBagIcon)
        else
            self.Parameter.ItemButton:SetSprite(Data.BagModel:getItemBgAtlas(), Data.BagModel:getItemBg())
        end
        self:SetActiveEx(self.Parameter.ItemButton, true)
        self.cdPart:SetImgCd(false)
        return
    end

    self:FreshSelect()
    
    self:RefreshMerchantItemState()
    
    if l_merchantMgr.g_tmpShowIndex == self.ShowIndex then
        self:OnButtonClick()
        l_merchantMgr.g_tmpShowIndex = nil
    end
end --func end
--next--
function RunningBusinessPotTemplate:OnDestroy()
	super.OnDestroy(self)
end --func end
--next--
--lua functions end

--lua custom scripts
RunningBusinessPotTemplate.TemplatePath = "UI/Prefabs/ItemPrefab"

function RunningBusinessPotTemplate:init()
	super.Init(self)
    
    self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.RunningBusiness)

    self.baseDataInfo = {}
    self.baseDataInfo.ButtonMethod = function() 
        self:OnButtonClick()
    end
end

function RunningBusinessPotTemplate:SetActiveEx(uicom, isActive)
	if uicom.gameObject.activeSelf ~= isActive then
		uicom.gameObject:SetActiveEx(isActive)
	end
end

function RunningBusinessPotTemplate:FreshSelect()
	if self.cdPart then
		if self.ShowIndex == l_data.MerchantPotLastPoint then
			self:SetActiveEx(self.cdPart.Parameter.ImgSelect, true)
		else
			self:SetActiveEx(self.cdPart.Parameter.ImgSelect, false)
		end
	end
end

function RunningBusinessPotTemplate:OnButtonClick()
    -- 更新选中态
    local l_t = l_data.MerchantPotLastPoint
    l_data.MerchantPotLastPoint = self.ShowIndex
    
    if l_t and l_t ~= self.ShowIndex then
        local l_it = self.bagCtrl.bagTemplatePool:GetItem(l_t)
        if l_it ~= nil then
            l_it:FreshSelect()
        end
    end
    self:FreshSelect()
    
    --tips
    if self.ShowData == nil then
        MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
    else
        local l_weaponStatus = nil
        local l_extraData = nil
        if l_data.MerchantShowBagType == l_data.EMerchantBagType.Shop then
            l_weaponStatus = Data.BagModel.WeaponStatus.TO_MERCHANT

            local l_price =  l_data.GetSellPriceByPropId(self.ShowData.TID)
            if l_price <= 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_SELL_LIMIT"))
                MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
                return
            end
            if l_data.MerchantShopType == l_data.EMerchantShopType.Sell then
                
                l_extraData = {
                    price = l_price,
                    recyleItem = GameEnum.l_virProp.MerchantCoin,
                    maxValue = self.ShowData.ItemCount,
                }
            else
                l_weaponStatus = Data.BagModel.WeaponStatus.TO_MERCHANT_SELL
                l_extraData = {
                    showIndex = self.ShowIndex,
                    price = l_price,
                    recyleItem = GameEnum.l_virProp.MerchantCoin,
                    maxValue = self.ShowData.ItemCount,
                }
            end
        end
        
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(self.ShowData, self.Parameter.LuaUIGroup.transform, l_weaponStatus, l_extraData, false)
    end
end

function RunningBusinessPotTemplate:RefreshMerchantItemState()

    local l_cdVisible = false
    if l_data.MerchantShowBagType == l_data.EMerchantBagType.Shop and l_data.MerchantShopType == l_data.EMerchantShopType.Sell then
        -- 如果商店无价格之类的
        local l_price = l_data.GetShopItemSellPrice(self.ShowData.TID)
        if l_price <= 0 then
            l_cdVisible = true
        end
    end
    self.cdPart:SetImgCd(l_cdVisible)
end

--lua custom scripts end
return RunningBusinessPotTemplate