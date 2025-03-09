--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GMPayPanel"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GMPayCtrl = class("GMPayCtrl", super)
--lua class define end

--lua functions
function GMPayCtrl:ctor()

    super.ctor(self, CtrlNames.GMPay, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function GMPayCtrl:Init()

    self.panel = UI.GMPayPanel.Bind(self)
    super.Init(self)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    self.panel.Btn1:AddClick(function()

    end)

    self.panel.Btn2:AddClick(function()
        local l_number = tonumber(self.panel.Input2.Input.text)
        if not l_number or l_number <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips("请输入正确的数量")
            return
        end

        MgrMgr:GetMgr("GmMgr").SendCommand("present " .. l_number)
    end)

    self.panel.Btn3:AddClick(function()

        local l_value = self.panel.ShopDropdown.DropDown.value
        if not l_value then
            return
        end

        if self.shops and self.shops[l_value + 1] then
            MgrMgr:GetMgr("ShopMgr").RequestShopItem(self.shops[l_value + 1], true)
        end
    end)

    self.panel.Btn4:AddClick(function()
        game:GetPayMgr():FireEvent(game:GetPayMgr().EVENT_GET_REWARD_INFO, "PayGame")
        self.panel.RewardInfo1.gameObject:SetActive(true)
        self.panel.Mask.gameObject:SetActive(true)
        self:RefreshRewardInfo("PayGame")
    end)

    self.panel.Btn5:AddClick(function()
        game:GetPayMgr():FireEvent(game:GetPayMgr().EVENT_GET_REWARD_INFO, "PayGoods")
        self.panel.RewardInfo2.gameObject:SetActive(true)
        self.panel.Mask.gameObject:SetActive(true)
        self:RefreshRewardInfo("PayGoods")
    end)

    self.panel.ItemName2.LabText = ""
    self.panel.Input2.Input.onValueChanged:AddListener(function(value)
        self:UpdateContent(tonumber(self.panel.Input2.Input.text), self.panel.ItemName2)
    end)

    self.panel.Mask:AddClick(function()
        self.panel.Mask.gameObject:SetActive(false)
        self.panel.RewardInfo1.gameObject:SetActive(false)
        self.panel.RewardInfo2.gameObject:SetActive(false)
    end)

    self:UpdateEnv()
    self.panel.Btn6:AddClick(function()
        local l_old = game:GetPayMgr().LogEnabled
        game:GetPayMgr().LogEnabled = (not l_old)
        game:GetPayMgr():Init()
        self:UpdateEnv()
    end)

    self.panel.Btn7:AddClick(function()
        self:ShowPayParams()
    end)

    self.panel.Btn8:AddClick(function()
        MgrMgr:GetMgr("TimeLimitPayMgr").RequestNextTime()
    end)

    self.panel.Mask.gameObject:SetActive(false)
    self.panel.RewardInfo1.gameObject:SetActive(false)
    self.panel.RewardInfo2.gameObject:SetActive(false)
end --func end
--next--
function GMPayCtrl:Uninit()
    self.shops = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GMPayCtrl:OnActive()
    self:RefreshShops()
    self:RefreshDiamond()
end --func end
--next--
function GMPayCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function GMPayCtrl:Update()
    -- do nothing
end --func end

--next--
function GMPayCtrl:BindEvents()
    --道具变化
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemUpdate)

    local l_payMgr = game:GetPayMgr()
    self:BindEvent(l_payMgr.EventDispatcher, l_payMgr.ON_REWARD_INFO, function(self, name)
        if self.panel == nil then
            return
        end

        self:RefreshRewardInfo(name)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function GMPayCtrl:_onItemUpdate()
    if self.panel == nil then
        return
    end

    self:RefreshDiamond()
end

function GMPayCtrl:UpdateContent(id, lab)
    if not id then
        lab.LabText = ""
        return
    end

    local l_shop_row = TableUtil.GetShopCommoditTable().GetRowById(id)
    if not l_shop_row then
        lab.LabText = ""
        return
    end

    local l_item_row = TableUtil.GetItemTable().GetRowByItemID(l_shop_row.ItemId)
    lab.LabText = l_item_row.ItemName
end

function GMPayCtrl:RefreshDiamond()
    self.panel.Diamond.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103))
end

function GMPayCtrl:RefreshShops()
    self.shops = {}
    local l_shopnames = {}
    local table_insert = table.insert
    for i, v in ipairs(TableUtil.GetShopTable().GetTable()) do
        table_insert(l_shopnames, StringEx.Format("{0}({1})", v.ShopId, v.ShopName))
        table_insert(self.shops, v.ShopId)
    end

    self.panel.ShopDropdown.DropDown:ClearOptions()
    self.panel.ShopDropdown:SetDropdownOptions(l_shopnames)
end

function GMPayCtrl:RefreshRewardInfo(name)
    local l_com = name == "PayGame" and self.panel.RichTextAnnounce1 or self.panel.RichTextAnnounce2
    l_com.LabText = "无"
    local l_rewardinfo = game:GetPayMgr():GetRewardInfo(name)
    if not l_rewardinfo then
        return
    end

    local l_rewardText = ToString(l_rewardinfo)
    l_com.LabText = l_rewardText
end

function GMPayCtrl:test()

end

function GMPayCtrl:UpdateEnv()
    local l_enabled = game:GetPayMgr().LogEnabled
    if l_enabled then
        self.panel.TitleEnv.LabText = "当前环境:沙箱"
    else
        self.panel.TitleEnv.LabText = "当前环境:现网"
    end
end

function GMPayCtrl:ShowPayParams()

    local l_content

    local l_payParams = game:GetPayMgr():GetPayInitParams()
    if not l_payParams then
        l_content = "no params"
    else
        l_content = ""
        l_content = l_content .. "open_key:" .. l_payParams.open_key .. "\n"
        l_content = l_content .. "session_id:" .. l_payParams.session_id .. "\n"
        l_content = l_content .. "session_type:" .. l_payParams.session_type .. "\n"
        l_content = l_content .. "pf:" .. l_payParams.pf .. "\n"
        l_content = l_content .. "pf_key:" .. l_payParams.pf_key .. "\n"
        l_content = l_content .. "zoneId:" .. game:GetPayMgr():GetGateServerId() .. "\n"
    end

    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.MiddleRight,
        pos = {
            x = 0,
            y = 0,
        },
        width = 400,
    })
end

--lua custom scripts end
