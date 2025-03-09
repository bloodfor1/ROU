--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/WelfarePanel"
require "Common/ModelScenario"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
WelfareCtrl = class("WelfareCtrl", super)
--lua class define end

--lua functions
function WelfareCtrl:ctor()

    super.ctor(self, CtrlNames.Welfare, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
end --func end
--next--
function WelfareCtrl:Init()

    self.panel = UI.WelfarePanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Welfare)
    end, true)

    self.Btns = {}
    self.panel.Btn:SetActiveEx(false)

    --目前美术给的ui不需要显示模型
    -- self:ShowModel(true)
    -- self.ScenarioA = UI.ModelScenario.new()
    -- self.ScenarioA:Init(1238,self.panel.ModelPoint.transform) --1239
    -- self.ScenarioB = UI.ModelScenario.new()
    -- self.ScenarioB:Init(1239,self.panel.ModelPoint.transform) --1239
end --func end
--next--
function WelfareCtrl:Uninit()

    self:ShowModel(false)
    super.Uninit(self)
    self.panel = nil

    self.Btns = nil

    if self.ScenarioA ~= nil then
        self.ScenarioA:Uninit()
        self.ScenarioA = nil
    end
    if self.ScenarioB ~= nil then
        self.ScenarioB:Uninit()
        self.ScenarioB = nil
    end
end --func end
--next--
function WelfareCtrl:OnActive()
    --MgrMgr:GetMgr("GiftPackageMgr").RequestTimeGiftInfo()

    self:RefreshWelfareBtns()
end --func end
--next--
function WelfareCtrl:OnDeActive()


end --func end
--next--
function WelfareCtrl:Update()


end --func end

--next--
function WelfareCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("TimeLimitPayMgr").EventDispatcher, MgrMgr:GetMgr("TimeLimitPayMgr").ON_ACTIVITY_CHANGE, self.RefreshWelfareBtns)

    local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
    --[[self:BindEvent(l_giftPackageMgr.EventDispatcher, l_giftPackageMgr.EventType.TimeGiftInfoRefresh, function()
        self:RefreshWelfareBtns()
    end)]]

    self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher, MgrMgr:GetMgr("LimitBuyMgr").LIMIT_BUY_COUNT_UPDATE, function(_, type, id)
        self:RefreshWelfareBtns()
    end)

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.CloseSystemEvent, self._onSystemClose)

    local l_roleTagMgr = MgrMgr:GetMgr("RoleTagMgr")
    self:BindEvent(l_roleTagMgr.EventDispatcher, l_roleTagMgr.RoleTagChangeEvent, self._roleTagChangeEvent)
end --func end
--next--
--lua functions end

--lua custom scripts
function WelfareCtrl:ShowModel(b)
    if self.NpcA ~= nil and not b then
        self:DestroyUIModel(self.NpcA);
        self.NpcA = nil
    end
    if self.NpcB ~= nil and not b then
        self:DestroyUIModel(self.NpcB);
        self.NpcB = nil
    end

    if self.NpcA == nil and b then
        self.panel.NpcRT_A:SetActiveEx(false)
        local l_fxData = {}
        l_fxData.rawImage = self.panel.NpcRT_A.RawImg
        l_fxData.attr = MAttrMgr:InitNpcAttr(0, "", 1238) --1239
        l_fxData.useShadow = true
        l_fxData.defaultAnim = MAnimationMgr:GetClipPath("Merchant_F_Zuo")
        self.NpcA = self:CreateUIModel(l_fxData)
        self.NpcA:AddLoadModelCallback(function(m)
            self.panel.NpcRT_A:SetActiveEx(true)
            self.NpcA.Trans:SetPos(-0.19, 0.19, 0.62)
            self.NpcA.Trans:SetLocalScale(1.5, 1.5, 1.5)
            self.NpcA.UObj:SetRotEuler(0, 116.6, 0)
        end)

    end

    if self.NpcB == nil and b then
        self.panel.NpcRT_B:SetActiveEx(false)
        local l_fxData = {}
        l_fxData.rawImage = self.panel.NpcRT_B.RawImg
        l_fxData.attr = MAttrMgr:InitNpcAttr(0, "", 1239)
        l_fxData.useShadow = true
        l_fxData.defaultAnim = MAnimationMgr:GetClipPath("Swordman_M_Zuo")
        self.NpcB = self:CreateUIModel(l_fxData)
        self.NpcB:AddLoadModelCallback(function(m)
            self.panel.NpcRT_B:SetActiveEx(true)
            self.NpcB.Trans:SetPos(0, 0, 0.33)
            self.NpcB.Trans:SetLocalScale(1.5, 1.5, 1.5)
            self.NpcB.UObj:SetRotEuler(0, -69.70001, 0)
        end)

    end
end

function WelfareCtrl:ShowEmoji()

end

function WelfareCtrl:RefreshWelfareBtns()
    local l_allRows = TableUtil.GetWelfareFunctionTable().GetTable()
    table.sort(l_allRows, function(a, b)
        return b.SortId > a.SortId
    end)

    local l_redKeys = {
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.SignIn] = eRedSignKey.SignIn,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LandingAward] = eRedSignKey.LandingAward,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LevelReward] = eRedSignKey.LevelReward,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonthCard] = eRedSignKey.MonthCardBtn,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Return] = eRedSignKey.Return,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TimeLimitPay] = eRedSignKey.WelfareTimeLimitPay,
        [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.NewPlayer] = eRedSignKey.NewPlayer,
    }
    --清理原本按钮上的点击事件和红点
    for i = 1, #self.Btns do
        local l_btnObj = self.Btns[i]
        l_btnObj.btn.onClick:RemoveAllListeners()
        if l_btnObj.RedSignProcessor then

            self:UninitRedSign(l_btnObj.RedSignProcessor)
            l_btnObj.RedSignProcessor = nil
        end
        l_btnObj.com:SetActiveEx(false)
    end

    self.panel.Xin:SetActiveEx(false)

    local l_activeI = 1
    for i = 1, #l_allRows do
        local l_row = l_allRows[i]
        local notSpecialHide = l_row.Id ~= ModuleMgr.OpenSystemMgr.eSystemId.Return or MPlayerInfo.ShownTagId == ROLE_TAG.RoleTagRegress
        if ModuleMgr.OpenSystemMgr.IsSystemOpen(l_row.Id, true) and notSpecialHide then
            if not self.Btns[l_activeI] then
                self.Btns[l_activeI] = self:CreateBtn()
            end
            self.Btns[l_activeI].com:SetActiveEx(true)
            local l_btnObj = self.Btns[l_activeI]
            l_activeI = l_activeI + 1

            l_btnObj.redPoint:SetActiveEx(false)
            l_btnObj.text.LabText = string.gsub(l_row.Name, "\\n", "\n")
            l_btnObj.btn.enabled = true
            l_btnObj.btn.onClick:AddListener(function()
                local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_row.Id)
                if method ~= nil then
                    method()
                end
            end)

            if l_redKeys[l_row.Id] ~= nil then
                if l_btnObj.RedSignProcessor == nil then
                    l_btnObj.RedSignProcessor = self:NewRedSign({
                        Key = l_redKeys[l_row.Id],
                        ClickButton = l_btnObj.com,
                    })
                end
            end

            --30日签到
            -- 【【韩国公测OBT_cp_develop】【UI新风格替换】RO悦礼界面隐藏❤图标】
            -- https://www.tapd.cn/20332331/prong/stories/view/1120332331001069521
            --if l_row.Id == ModuleMgr.OpenSystemMgr.eSystemId.SignIn then
            --    self.panel.Xin:SetActiveEx(true)
            --    self.panel.Xin.transform:SetParent(l_btnObj.btn.transform)
            --    self.panel.Xin.transform:SetLocalScaleOne()
            --    self.panel.Xin.gameObject:SetRectTransformPos(8.4, 56.1)
            --end

            --底板
            l_btnObj.com:SetSprite("Welfare", "UI_WelfareSignIn_Button_Deng.png")
        end
    end
    -- 前6个会显示空白页
    for i = l_activeI, 6 do
        if not self.Btns[i] then
            self.Btns[i] = self:CreateBtn()
        end
        self.Btns[i].com:SetActiveEx(true)
        local l_btnObj = self.Btns[i]
        l_btnObj.text.LabText = ""
        l_btnObj.btn.onClick:RemoveAllListeners()
        l_btnObj.btn.enabled = false
        l_btnObj.com:SetSprite("Welfare", "UI_WelfareSignIn_Button_Deng01.png")
    end
end

function WelfareCtrl:CreateBtn()
    local l_btn = {}
    l_btn.obj = self:CloneObj(self.panel.Btn.gameObject)
    local l_btnTrans = l_btn.obj.transform
    l_btnTrans:SetParent(self.panel.Btn.transform.parent, false)
    l_btn.com = l_btnTrans:GetComponent("MLuaUICom")
    l_btn.btn = l_btnTrans:GetComponent("Button")
    l_btn.text = MLuaClientHelper.GetOrCreateMLuaUICom(l_btnTrans:Find("Text").gameObject)
    l_btn.redPoint = l_btnTrans:Find("RedPoint"):GetComponent("MLuaUICom")
    l_btn.redPoint:SetActiveEx(false)
    return l_btn
end

--todo
function WelfareCtrl:_onSystemClose(systemId)
    --logGreen("_onSystemClose:"..tostring(systemId))
end

function WelfareCtrl:_roleTagChangeEvent()
    self:RefreshWelfareBtns()
end

--lua custom scripts end
return WelfareCtrl