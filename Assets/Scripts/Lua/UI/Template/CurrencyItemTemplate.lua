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
---@class CurrencyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Count MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field AddButton MoonClient.MLuaUICom

---@class CurrencyItemTemplate : BaseUITemplate
---@field Parameter CurrencyItemTemplateParameter

CurrencyItemTemplate = class("CurrencyItemTemplate", super)
--lua class define end

--lua functions
function CurrencyItemTemplate:Init()

    super.Init(self)
    self.data = nil
    self.Parameter.AddButton:AddClick(function()
        if self.data == nil then
            return
        end
        if self.data == MgrMgr:GetMgr("PropMgr").l_virProp.Coin103 or self.data == MgrMgr:GetMgr("PropMgr").l_virProp.Coin104 then
			local l_opened = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MallFeeding)
            if not l_opened then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
                return
            end
            UIMgr:ActiveUI(UI.CtrlNames.Mall, {
                Tab = MgrMgr:GetMgr("MallMgr").MallTable.Pay,
            })
            return
        elseif self.data == MgrMgr:GetMgr("PropMgr").l_virProp.Coin102 then
            self:_showCurrencyExch(MgrMgr:GetMgr("CurrencyMgr").eCurrentCointType.Coin102)
        elseif self.data == MgrMgr:GetMgr("PropMgr").l_virProp.Coin101 then
            self:_showCurrencyExch(MgrMgr:GetMgr("CurrencyMgr").eCurrentCointType.Coin101)
        else
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.data, nil, nil, nil, true)
        end
    end)

end --func end
--next--
function CurrencyItemTemplate:BindEvents()
    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, function()
        if self.data == nil then
            return
        end

        self.Parameter.Count.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(self.data))
    end)
end --func end
--next--
function CurrencyItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function CurrencyItemTemplate:OnSetData(data)
    self.data = data
    self.Parameter.Count.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(self.data))
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(self.data)
    self.Parameter.CoinIcon:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
end --func end
--next--
function CurrencyItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function CurrencyItemTemplate:_showCurrencyExch(type)
    MgrMgr:GetMgr("CurrencyMgr").CurrentCointType = type
    UIMgr:ActiveUI(UI.CtrlNames.CurrencyExch, function(ctrl)
        ctrl:ShowCurrencyExch()
    end)
end

--lua custom scripts end
return CurrencyItemTemplate