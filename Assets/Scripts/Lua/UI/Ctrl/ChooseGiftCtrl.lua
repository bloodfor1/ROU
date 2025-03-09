--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChooseGiftPanel"
require "UI/Template/ChooseGiftItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ChooseGiftCtrl = class("ChooseGiftCtrl", super)
--lua class define end

--lua functions
function ChooseGiftCtrl:ctor()

    super.ctor(self, CtrlNames.ChooseGift, UILayer.Function, nil, ActiveType.Standalone)
    self.overrideSortLayer = UILayerSort.Function + 4

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark


end --func end
--next--

SINGLE_TITLE_FX = "Effects/Prefabs/Creature/Ui/Fx_ui_gongxihuode_ziti"

function ChooseGiftCtrl:Init()
    self.panel = UI.ChooseGiftPanel.Bind(self)
    super.Init(self)
    self.propMgr = MgrMgr:GetMgr("PropMgr")
    self.giftItemLeftPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ChooseGiftItemTemplate,
        ScrollRect = self.panel.loopScroll.LoopScroll,
        TemplatePrefab = self.panel.ChooseGiftItemTemplate.LuaUIGroup.gameObject,

        Method = function()
            self.panel.BtnStorage:SetGray(false)
        end
    })

    self.giftItemMiddlePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ChooseGiftItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.ChooseGiftItemTemplate.LuaUIGroup.gameObject,

        Method = function()
            self.panel.BtnStorage:SetGray(false)
        end
    })

end --func end
--next--
function ChooseGiftCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.giftItemLeftPool = nil
    self.giftItemMiddlePool = nil

end --func end
--next--
function ChooseGiftCtrl:OnActive()
    self.panel.ChooseGiftItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    MgrMgr:GetMgr("PropMgr").SetGiftIsAllUse(true)

    if UIMgr:IsActiveUI(UI.CtrlNames.CommonItemTips) then
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    end
    self:CreateTitleFx()
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)
end --func end
--next--
function ChooseGiftCtrl:OnDeActive()

    self.allUseCount = nil
    self:CleanUpValues()
    self:DestroyTitleFx()
end --func end
--next--
function ChooseGiftCtrl:Update()
    -- do nothing
end --func end
--next--
function ChooseGiftCtrl:BindEvents()
    --dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
--选中的组件
local clickItemCell

function ChooseGiftCtrl:_getFirstItemUID(tid)
    local items = self:_getBagItemByTID(tid)
    if nil == items then
        return nil
    end

    if 0 == #items then
        return nil
    end

    return items[1].UID
end

---@return ItemData[]
function ChooseGiftCtrl:_getBagItemByTID(tid)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

function ChooseGiftCtrl:ShowChooseItems(itemFunctionData, itemUid, count)
    self.itemUid = itemUid
    self.count = count or Data.BagModel:GetBagItemCountByTid(itemFunctionData.ItemId)
    -- 第一次保存总的数量
    if not self.allUseCount then
        self.allUseCount = self.count
    end

    --选好按钮
    self.panel.BtnStorage:SetGray(true)
    self.panel.BtnStorage:AddClick(function()
        local selectData = {}
        if self.panel.loopScroll.gameObject.activeSelf then
            selectData = self.giftItemLeftPool:GetCurrentSelectTemplateData()
        else
            selectData = self.giftItemMiddlePool:GetCurrentSelectTemplateData()
        end
        local clickItemRewardId = selectData and selectData.awardId
        if clickItemRewardId then
            itemUid = itemUid or self:_getFirstItemUID(itemFunctionData.ItemId)
            MgrMgr:GetMgr("PropMgr").RequestChooseGift(itemUid, clickItemRewardId, selectData.idx, 1, itemFunctionData.ItemId)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_GIFT_SET_NO"))
        end
    end)

    --清除数据
    self.giftItemLeftPool:CancelSelectTemplate()
    self.giftItemMiddlePool:CancelSelectTemplate()
    local showItemTable = MgrMgr:GetMgr("PropMgr").GetGiftItemsToChoose(itemFunctionData)
    if table.maxn(showItemTable) > 5 then
        array.each(showItemTable, function(v)
            v.pool = self.giftItemLeftPool
            v.ctrl = self
        end)
        self.giftItemLeftPool:ShowTemplates({ Datas = showItemTable })
        self.panel.loopScroll.gameObject:SetActiveEx(true)
        self.panel.ItemScroll.gameObject:SetActiveEx(false)
    else
        array.each(showItemTable, function(v)
            v.pool = self.giftItemMiddlePool
            v.ctrl = self
        end)
        self.giftItemMiddlePool:ShowTemplates({ Datas = showItemTable })
        self.panel.loopScroll.gameObject:SetActiveEx(false)
        self.panel.ItemScroll.gameObject:SetActiveEx(true)
    end

    local type = GameEnum.ChooseGiftType.Normal
    if #showItemTable > 0 then
        type = showItemTable[1].type
    end

    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemFunctionData.ItemId)
    self.panel.CloseText:SetActiveEx(false)
    --self:SetBlockOpt(BlockColor.Dark, function()
    --end)
    if l_itemRow.QuickUse == 2 then
        self.panel.BtnClose.gameObject:SetActiveEx(false)
    else
        self.panel.BtnClose.gameObject:SetActiveEx(true)
    end

    self.panel.CountText.LabText = StringEx.Format(Common.Utils.Lang("CHOOSE_GIFT_ITEM_COUNT"), tostring(self.count), tostring(self.allUseCount))
end

function ChooseGiftCtrl:CleanUpValues()
    clickItemCell = nil
    clickItemRewardId = nil
end

function ChooseGiftCtrl:OnClickBlock()
end

function ChooseGiftCtrl:SelectItem(data)
    if not self.panel then
        return
    end
end

function ChooseGiftCtrl:CreateTitleFx()
    self:DestroyTitleFx()
    if self.titleFxId == 0 or self.titleFxId == nil then
        local l_fxData = {}
        l_fxData.rawImage = self.panel.Raw_EffBg.RawImg
        l_fxData.destroyHandler = function()
            self.titleFxId = 0
        end
        l_fxData.loadedCallback = function(go)
            go.transform:SetLocalPos(0, 0.62, 0)
            go.transform:SetLocalScale(1.1, 1.1, 1.1)
        end
        self.titleFxId = self:CreateUIEffect(SINGLE_TITLE_FX, l_fxData)

    end
end

function ChooseGiftCtrl:DestroyTitleFx(...)
    if self.titleFxId and self.titleFxId ~= 0 then
        self:DestroyUIEffect(self.titleFxId)
        self.titleFxId = 0
    end
end
--lua custom scripts end

return ChooseGiftCtrl

