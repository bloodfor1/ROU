--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CurrencyPanel"

require "Data/Model/PlayerInfoModel"

require "UI/Template/CurrencyItemTemplate"
require "UI/Template/CreditsItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CurrencyCtrl = class("CurrencyCtrl", super)
--lua class define end
eCurrencyType = {
    Coin103 = 1,
    Coin102 = 2,
    Coin101 = 4,
}
--lua functions
function CurrencyCtrl:ctor()

    super.ctor(self, CtrlNames.Currency, UILayer.Function, UITweenType.Down, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.overrideSortLayer = UILayerSort.Function + 2

end --func end
--next--
function CurrencyCtrl:Init()
    self.panel = UI.CurrencyPanel.Bind(self)
    super.Init(self)

    self.currencyDisplay=nil

    self.panel.CurrencyItemPrefab.gameObject:SetActiveEx(false)
    self.panel.CreditsItemPrefab.gameObject:SetActiveEx(false)

    self.currencyItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CurrencyItemTemplate,
        TemplateParent = self.panel.CurrencyItemParent.transform,
        TemplatePrefab = self.panel.CurrencyItemPrefab.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    self.creditsItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CreditsItemTemplate,
        TemplateParent = self.panel.CreditsItemParent.transform,
        TemplatePrefab = self.panel.CreditsItemPrefab.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
        Method = function(id)
            self:showCreditsDetails(id)
        end
    })

    self.panel.ShowCreditsButton:AddClick(function()
        local l_datas = {}
        table.insert(l_datas, MgrMgr:GetMgr("PropMgr").l_virProp.GuildContribution)
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ArenaShop) then
            table.insert(l_datas, MgrMgr:GetMgr("PropMgr").l_virProp.ArenaCoin)
        end
        table.insert(l_datas, MgrMgr:GetMgr("PropMgr").l_virProp.AssistCoin)
        --策划需求 暂时注释掉魔物硬币商店
        --table.insert(l_datas, MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin)
        self.creditsItemTemplatePool:ShowTemplates({
            Datas = l_datas
        })
        self.panel.CreditsPanel:SetActiveEx(true)

        --新手指引 协同之证
        if MPlayerInfo.AssistCoin > 0 then
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "AssistGuild2" }, self:GetPanelName(), self.overrideSortLayer + 1)
        end
    end, true)

    self.panel.CreditsPanelCloseButton:AddClick(function()
        self.panel.CreditsPanel:SetActiveEx(false)
        self.panel.CreditsDetailsPanel:SetActiveEx(false)
    end, true)

end --func end
--next--
function CurrencyCtrl:Uninit()

    self.currencyItemTemplatePool = nil
    self.creditsItemTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CurrencyCtrl:OnActive()
    self.currencyDisplay=nil
end --func end
function CurrencyCtrl:OnShow()
    if self.uiPanelData then
        if self.uiPanelData.CurrencyDisplay then
            self.currencyDisplay=self.uiPanelData.CurrencyDisplay
        end
    end
    if self.currencyDisplay==nil then
        self.currencyDisplay=MgrMgr:GetMgr("CurrencyMgr").CurrencyDisplay
    end
    self:CurrencyPanelRefresh()
end
--next--
function CurrencyCtrl:OnDeActive()
    UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
    --self:SetOffset()
end --func end
--next--
function CurrencyCtrl:Update()
    self.currencyItemTemplatePool:OnUpdate()
    self.creditsItemTemplatePool:OnUpdate()
end --func end
--next--
function CurrencyCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemUpdateDataList ItemUpdateData[]
function CurrencyCtrl:_onItemUpdate(itemUpdateDataList)
    if self.panel == nil or self.ItemPool == nil or self.SelectPool == nil then
        return
    end

    if nil == itemUpdateDataList then
        logError("[CurrencyCtrl] invalid param")
        return
    end

    if 0 < #itemUpdateDataList then
        self.currencyItemTemplatePool:ShowTemplates({
            Datas = self.currencyDisplay,
        })
    end
end

function CurrencyCtrl:CurrencyPanelRefresh()
    local l_mgr = MgrMgr:GetMgr("CurrencyMgr")
    self.panel.CreditsPanel:SetActiveEx(false)
    self.panel.CreditsDetailsPanel:SetActiveEx(false)
    self.currencyItemTemplatePool:ShowTemplates({
        Datas = self.currencyDisplay,
    })

    self:SetOffset(l_mgr.PositionX, l_mgr.PositionY)
    MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay()
end

function CurrencyCtrl:showCreditsDetails(id)
    self.panel.CreditsDetailsPanel:SetActiveEx(true)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(id)
    self.panel.Content.RectTransform.anchoredPosition = Vector2.New(0,0)
    self.panel.Details.LabText = itemTableInfo.ItemDescription
end

function CurrencyCtrl:SetOffset(posX, posY)
    self.panel.Main.gameObject:SetRectTransformPos(posX or 0, posY or 0)
end

return CurrencyCtrl
--lua custom scripts end
