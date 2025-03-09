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
---@class CommonItemTipsButtonsTemplentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PriceIcon MoonClient.MLuaUICom
---@field Lab MoonClient.MLuaUICom
---@field btnTip2Txt MoonClient.MLuaUICom
---@field btnTip2Icon MoonClient.MLuaUICom
---@field btnTip2 MoonClient.MLuaUICom
---@field btnTip1Txt MoonClient.MLuaUICom
---@field btnTip1Icon MoonClient.MLuaUICom
---@field btnTip1 MoonClient.MLuaUICom
---@field BtnTip MoonClient.MLuaUICom
---@field BtnParent MoonClient.MLuaUICom
---@field btnPanel MoonClient.MLuaUICom

---@class CommonItemTipsButtonsTemplent : BaseUITemplate
---@field Parameter CommonItemTipsButtonsTemplentParameter

CommonItemTipsButtonsTemplent = class("CommonItemTipsButtonsTemplent", super)
--lua class define end

--lua functions
function CommonItemTipsButtonsTemplent:Init()

    super.Init(self)
    for k, v in pairs(self.Parameter) do
        self[k] = v
    end
    if self.tweenId and self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
    end
    self.isMoreBtnClick = 0         --以下两个参数用于创建更多按钮
    self.tweenId = 0
    self.btnGroup = {}
    self.parentPos = self.Parameter.BtnParent.transform.localPosition

end --func end
--next--
function CommonItemTipsButtonsTemplent:OnDestroy()

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    self.isMoreBtnClick = 0

end --func end
--next--
function CommonItemTipsButtonsTemplent:OnSetData(data)

    -- do nothing

end --func end
--next--
function CommonItemTipsButtonsTemplent:BindEvents()


end --func end
--next--
function CommonItemTipsButtonsTemplent:OnDeActive()


end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsButtonsTemplent.TemplatePath = "UI/Prefabs/CommonItemTips/CommonItemTipsButtonsComponent"

function CommonItemTipsButtonsTemplent:SetAsLastSibling()
    if self.Parameter.btnPanel then
        self.Parameter.btnPanel.Transform:SetAsLastSibling()
    end
end

---@param itemData ItemData
function CommonItemTipsButtonsTemplent:CreatePanelBtnByButtonDates(oneItem, buttonDatas, itemData, additionalData)
    if buttonDatas == nil or #buttonDatas <= 0 then
        oneItem.btnPanel:SetActiveEx(false)
        return
    end

    local l_isDestroy = MgrMgr:GetMgr("SkillDestroyEquipMgr").IsDestroyWithPropInfo(itemData)
    oneItem.btnTip2:SetGray(l_isDestroy)
    oneItem.btnTip1:SetGray(l_isDestroy)
    oneItem.btnPanel:SetActiveEx(#buttonDatas > 0)

    local l_layoutElement = self.Parameter.LuaUIGroup.gameObject:GetComponent("LayoutElement")

    if additionalData and additionalData.btnNotifyContent then
        self.Parameter.Lab.LabText = additionalData.btnNotifyContent
        self.Parameter.Lab.gameObject:SetActiveEx(true)
        l_layoutElement.preferredHeight = 70
    else
        self.Parameter.Lab.gameObject:SetActiveEx(false)
        l_layoutElement.preferredHeight = 56
    end

    if #buttonDatas == 1 then
        oneItem.btnTip2.gameObject:SetActiveEx(true)
        oneItem.btnTip1.gameObject:SetActiveEx(false)
        oneItem.btnTip2Txt.LabText = buttonDatas[1].name
        oneItem.btnTip2:AddClick(function()
            if l_isDestroy then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Tips_EquipDestroyTipsText"))
                return
            end

            buttonDatas[1].method()
        end)
        self:SellMoneyType(oneItem.btnTip2, buttonDatas[1])
        self:showRedSign(buttonDatas[1].isShowRed, oneItem.btnTip2.Transform)
        self:SetButtonCd(oneItem.btnTip2.gameObject, buttonDatas[1], itemData)
    elseif #buttonDatas == 2 then
        oneItem.btnTip1.gameObject:SetActiveEx(true)
        oneItem.btnTip2.gameObject:SetActiveEx(true)
        oneItem.btnTip1Txt.LabText = buttonDatas[2].name
        oneItem.btnTip1:AddClick(buttonDatas[2].method)
        oneItem.btnTip2Txt.LabText = buttonDatas[1].name
        oneItem.btnTip2:AddClick(function()
            if l_isDestroy then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Tips_EquipDestroyTipsText"))
                return
            end
            buttonDatas[1].method()
        end)
        self:showRedSign(buttonDatas[2].isShowRed, oneItem.btnTip1.Transform)
        self:showRedSign(buttonDatas[1].isShowRed, oneItem.btnTip2.Transform)
        self:SellMoneyType(oneItem.btnTip1, buttonDatas[2])
        self:SellMoneyType(oneItem.btnTip2, buttonDatas[1])
        self:SetButtonCd(oneItem.btnTip2.gameObject, buttonDatas[1], itemData)
        self:SetButtonCd(oneItem.btnTip1.gameObject, buttonDatas[2], itemData)
    elseif #buttonDatas > 2 then
        --创建更多的按钮
        oneItem.BtnParent.gameObject:SetActiveEx(false)
        oneItem.btnTip1.transform.gameObject:SetActiveEx(true)
        oneItem.btnTip2.transform.gameObject:SetActiveEx(true)
        oneItem.btnTip2Txt.LabText = buttonDatas[1].name
        oneItem.btnTip2:AddClick(function()
            if l_isDestroy then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Tips_EquipDestroyTipsText"))
                return
            end
            buttonDatas[1].method()
        end)
        self:SetButtonCd(oneItem.btnTip2.gameObject, buttonDatas[1], itemData)
        self:showRedSign(buttonDatas[1].isShowRed, oneItem.btnTip2.Transform)
        for i = 2, #buttonDatas do
            if buttonDatas[i].isShowRed then
                self:showRedSign(true, oneItem.btnTip1.Transform)
            end
        end
        oneItem.btnTip1Txt.LabText = Common.Utils.Lang("BUTTONS_MORE")
        oneItem.btnTip1Txt.transform:SetLocalPos(0, 0, 0)
        oneItem.btnTip1Icon:SetActiveEx(false)
        oneItem.btnTip2Icon:SetActiveEx(false)
        oneItem.btnTip1:AddClick(function()

            if l_isDestroy then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Tips_EquipDestroyTipsText"))
                return
            end

            if self.tweenId > 0 then
                MUITweenHelper.KillTween(self.tweenId)
                self.tweenId = 0
            end

            local l_pos = oneItem.BtnParent.transform.localPosition
            local l_x = oneItem.BtnParent.transform.localPosition.x
            local l_y = oneItem.BtnParent.transform.localPosition.y
            if self.isMoreBtnClick < 1 then
                l_y = l_y + self.btnParentOffestY
                self.isMoreBtnClick = 1
                self:showRedSign(false, oneItem.btnTip1.Transform)
            else
                l_y = l_y - self.btnParentOffestY
                self.isMoreBtnClick = 0
                for i = 2, #buttonDatas do
                    if buttonDatas[i].isShowRed then
                        self:showRedSign(true, oneItem.btnTip1.Transform)
                    end
                end
            end
            self.tweenId = MUITweenHelper.TweenPos(oneItem.BtnParent.gameObject, l_pos, Vector3.New(l_x, l_y, 0), 0.2)
        end)

        self.btnGroup = self.btnGroup or {}
        for i = 2, #buttonDatas do
            local l_go = self:CloneObj(oneItem.BtnTip.gameObject)
            l_go.gameObject:SetActiveEx(true)
            local l_comp = l_go:GetComponent("MLuaUICom")
            local l_text = MLuaClientHelper.GetOrCreateMLuaUICom(l_go.transform:Find("Text"))
            l_text.LabText = buttonDatas[i].name
            l_go.transform:SetParent(oneItem.BtnParent.transform)
            l_go.transform:SetLocalScaleOne()
            l_comp:AddClick(buttonDatas[i].method)
            self:showRedSign(buttonDatas[i].isShowRed, l_comp.Transform)
            self:SellMoneyType(l_go, buttonDatas[i])
            table.insert(self.btnGroup, l_go)
        end

        local l_x = oneItem.BtnParent.transform.localPosition.x
        local l_y = oneItem.BtnParent.transform.localPosition.y
        self.btnParentOffestY = (#buttonDatas - 1) * 80
        l_y = l_y - self.btnParentOffestY
        MLuaCommonHelper.SetLocalPos(oneItem.BtnParent.gameObject, l_x, l_y, 0)
        oneItem.BtnParent.gameObject:SetActiveEx(true)
    end
end

---@return ItemData
function CommonItemTipsButtonsTemplent:_getItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

---@param itemData ItemData
function CommonItemTipsButtonsTemplent:SetButtonCd(buttonObj, buttonData, itemData)
    if nil ~= buttonData.checkShowCdMethod then
        local result = buttonData.checkShowCdMethod(buttonData.checkShowCdMethodSelf)
        if not result then
            return
        end
    end

    if buttonData.isUseCd ~= nil and buttonData.isUseCd then
        local l_info = itemData
        if l_info == nil then
            return
        end

        -- todo 这里有一个问题，使用道具失败了CD也会转
        local l_cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(l_info.TID)
        local l_tableCd = MgrMgr:GetMgr("ItemCdMgr").GetItemTotalCd(l_info.TID, true)
        local cdRefresh = buttonObj:GetComponent("MUICdButton")
        local cdValue = l_cd > 0 and l_cd or l_tableCd
        cdRefresh:SetCd(cdValue)
        cdRefresh:SetCdText(buttonObj.transform:Find("Text"):GetComponent("Text"))
        cdRefresh.cdAction = function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_IN_CD"))
        end

        cdRefresh.finishAction = function()
            cdRefresh:SetCd(l_tableCd)
        end

        if l_cd > 0 then
            cdRefresh:SetCdState(true)
        end
    end
end

function CommonItemTipsButtonsTemplent:showRedSign(isShow, transform)
    local l_RedPrompt = transform:Find("RedPrompt")
    l_RedPrompt.gameObject:SetActiveEx(isShow)
end

--设置出售按钮货币
function CommonItemTipsButtonsTemplent:SellMoneyType(btn, btnData)
    local l_trans = btn.transform:Find("PriceIcon")
    local l_text = btn.transform:Find("Text").transform
    l_text:SetLocalPos(0, 0, 0)
    if btnData.isStall then
        l_text:SetLocalPos(16, 0, 0)
        l_trans.gameObject:SetActiveEx(true)
        l_trans:GetComponent("MLuaUICom"):SetSprite("Icon_ItemConsumables01", "UI_icon_item_Zeng.png")
    end
    if btnData.isTrade then
        l_text:SetLocalPos(16, 0, 0)
        l_trans.gameObject:SetActiveEx(true)
        l_trans:GetComponent("MLuaUICom"):SetSprite("Icon_ItemConsumables01", "UI_icon_item_huobi02.png")
    end
    if btnData.isBlackShop then
        l_text:SetLocalPos(16, 0, 0)
        l_trans.gameObject:SetActiveEx(true)
        l_trans:GetComponent("MLuaUICom"):SetSprite("Icon_ItemConsumables01", "UI_icon_item_huobi02.png")
    end
end

function CommonItemTipsButtonsTemplent:ResetSetComponent()
    self.Parameter.btnTip2Txt.LabText = "ResetTem"
    self.Parameter.btnTip1Txt.LabText = "ResetTem"
    self.Parameter.btnTip1Icon.gameObject:SetActiveEx(false)
    self.Parameter.btnTip2Icon.gameObject:SetActiveEx(false)
    self.Parameter.btnTip1.gameObject:SetActiveEx(false)
    self.Parameter.btnTip2.gameObject:SetActiveEx(false)
    self.Parameter.btnTip2Txt.transform:SetLocalPos(0, 0, 0)
    self.Parameter.btnTip1Txt.transform:SetLocalPos(0, 0, 0)
    if self.parentPos then
        self.Parameter.BtnParent.transform.localPosition = self.parentPos
    end
    local cdRefresh1 = self.Parameter.btnTip1:GetComponent("MUICdButton")
    local cdRefresh2 = self.Parameter.btnTip2:GetComponent("MUICdButton")
    if cdRefresh1 then
        cdRefresh1:ResetCdButton()
    end
    if cdRefresh2 then
        cdRefresh2:ResetCdButton()
    end
    for i = 1, #self.btnGroup do
        if self.btnGroup[i] then
            MResLoader:DestroyObj(self.btnGroup[i])
        end
    end
end

function CommonItemTipsButtonsTemplent:ctor(itemData)
    itemData.Data = {}
    super.ctor(self, itemData)
end
--lua custom scripts end
return CommonItemTipsButtonsTemplent