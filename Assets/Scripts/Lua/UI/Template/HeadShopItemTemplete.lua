--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Common/Utils"
--lua requires end

--lua model
module("UITemplate", package.seeall)
--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--next--
--lua fields end

--lua class define
HeadShopItemTemplete = class("HeadShopItemTemplete", super)
--lua class define end

--lua functions
function HeadShopItemTemplete:Init()
    super.Init(self)


end --func end
--next--
function HeadShopItemTemplete:OnDeActive()


end --func end
--next--

--next--
function HeadShopItemTemplete:OnDestroy()


end --func end
--next--
function HeadShopItemTemplete:OnSetData(data)

    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.ID)
    self.Parameter.Image1:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
    self.Parameter.ItemName.LabText = itemTableInfo.ItemName
    self.Parameter.Lock.gameObject:SetActiveEx(data.locked)
    self.Parameter.Select.gameObject:SetActiveEx(MgrMgr:GetMgr("HeadShopMgr").SelectOrnamentId == data.ID)
    if data.locked or data.limited then
        self.Parameter.Mask.gameObject:SetActiveEx(true)
    else
        self.Parameter.Mask.gameObject:SetActiveEx(false)
    end
    if data.canBuyCount then
        local l_count = data.canBuyCount
        if l_count <= 0 then
            self.Parameter.Numer.LabText = Common.Utils.Lang("EXCHANGE_LIMITED")
        else
            self.Parameter.Numer.LabText = StringEx.Format("{0}:{1}", Common.Utils.Lang("SURPLUS"), tostring(l_count))
        end
    else
        self.Parameter.Line.gameObject:SetActiveEx(false)
        self.Parameter.ItemNum.gameObject:SetActiveEx(false)
    end
    if MgrProxy:GetGarderobeMgr().IsOwnByItemId(data.ID) then
        self.Parameter.Surplus.gameObject:SetActiveEx(true)
    else
        self.Parameter.Surplus.gameObject:SetActiveEx(false)
    end

    self.Parameter.ButtonItem:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(data.ID, self.ShowIndex)
        end
    end)

    self.Parameter.Icon:AddClick(function()
        local itemData = Data.BagModel:CreateItemWithTid(data.ID)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self:transform(), nil, nil, false, { relativePositionY = 28 })
    end)

    local l_flag = false
    if data.locked or data.limited or data.lack_res then
    else
        l_flag = true
    end

    self.Parameter.RedSignPrompt.gameObject:SetActiveEx(l_flag)
end --func end

--next--
--lua functions end

--lua custom scripts

function HeadShopItemTemplete:ShowFrame(flag)
    self.Parameter.Select.gameObject:SetActiveEx(flag)
end
--lua custom scripts end
return HeadShopItemTemplete