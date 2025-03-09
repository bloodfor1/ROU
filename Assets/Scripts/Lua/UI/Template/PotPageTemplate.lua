--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class PotPageTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtPotPageName MoonClient.MLuaUICom
---@field PrefabPotPage MoonClient.MLuaUICom
---@field BtnPotPage MoonClient.MLuaUICom
---@field BtnPotLock MoonClient.MLuaUICom

---@class PotPageTemplate : BaseUITemplate
---@field Parameter PotPageTemplateParameter

PotPageTemplate = class("PotPageTemplate", super)
--lua class define end

--lua functions
function PotPageTemplate:Init()

    super.Init(self)
    --数据初始化
    self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.Bag)
    self.bagPanel = self.bagCtrl.panel
    --加监听
    self.Parameter.BtnPotLock:AddClick(function()
        --消耗
        local l_consume = Data.BagModel:getPotPageUnlockItemlist()
        local l_consumeDatas = {}
        local l_data = {}
        l_data.ID = tonumber(l_consume[1].id)
        l_data.IsShowCount = false
        l_data.IsShowRequire = true
        l_data.RequireCount = tonumber(l_consume[1].needCount)
        table.insert(l_consumeDatas, l_data)
        CommonUI.Dialog.ShowConsumeDlg("", Data.BagModel:getPotPageUnlockTipsInfo(),
                function()
                    MgrMgr:GetMgr("PropMgr").RequestUnlockBlank(BagType.WAREHOUSE)
                end, nil, l_consumeDatas)
        self.bagCtrl:HidePotPage()
    end
    )
    self.Parameter.BtnPotPage:AddClick(function()
        Data.BagModel:mdPotId(self.ShowIndex)
        self.bagCtrl:ChangePotPage()
        self.bagPanel.TxtNowPgName.LabText = Data.BagModel:getPotName(self.ShowIndex)
        self.bagCtrl:HidePotPage()
    end
    )

end --func end
--next--
function PotPageTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function PotPageTemplate:OnSetData(data)

    --锁
    if Data.BagModel:PotPageIsLock(self.ShowIndex) == true then
        self:SetActiveEx(self.Parameter.BtnPotLock, true)
        self:SetActiveEx(self.Parameter.BtnPotPage, false)
    else
        self:SetActiveEx(self.Parameter.BtnPotLock, false)
        self:SetActiveEx(self.Parameter.BtnPotPage, true)
        self.Parameter.TxtPotPageName.LabText = Data.BagModel:getPotName(self.ShowIndex)
    end

end --func end
--next--
function PotPageTemplate:OnDestroy()


end --func end
--next--
function PotPageTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function PotPageTemplate:SetActiveEx(uicom, isActive)
    if uicom.gameObject.activeSelf ~= isActive then
        uicom.gameObject:SetActiveEx(isActive)
    end
end
--lua custom scripts end
return PotPageTemplate