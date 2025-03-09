--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/Template/ItemTemplate"
require "UI/BaseUITemplate"
require "Data/Model/BagModel"
require "UI/Template/ItemCdPartTemplate"
--lua requires end

--lua modelItemButton
module("UITemplate", package.seeall)
--lua model end

--lua fields
local super = UITemplate.ItemTemplate
--lua fields end

--lua class define
ItemPotTemplate = class("ItemPotTemplate", super)
--lua class define end

--lua functions
function ItemPotTemplate:Init()
    super.Init(self)
    --全部逻辑写在init里
    self:init()

    --- 是不是拖拽过程，鼠标抬起的触发顺序是onPressUp, OnClick, OnDragEnd
    --- 所以开始拖拽的时候进行一个记录，onDragEnd的时候重置这个记录，这样保证没有触发过拖拽
    self._dragging = false
end --func end
--next--
---@param data ItemData
function ItemPotTemplate:OnSetData(data)
    --选择data
    self.ShowData = data
    self.baseDataInfo.PropInfo = data
    self.baseDataInfo.IsShowTips = false

    --数量
    if data then
        self.baseDataInfo.IsShowCount = data.ItemCount > 1
    end

    super.OnSetData(self, self.baseDataInfo)

    --item显示
    if not self.cdPart then
        self.cdPart = self:NewTemplate("ItemCdPartTemplate", {
            TemplateParent = self:transform(),
            Data=data,
        })
    else
        self.cdPart:SetData(data)
    end

    if data == nil then
        self.Parameter.ItemButton:SetSprite(Data.BagModel:getItemBgAtlas(), Data.BagModel:getItemBg())
        self:SetActiveEx(self.Parameter.ItemButton, true)
        return
    end

    --选中框
    self:FreshSelect()
end --func end
--next--
function ItemPotTemplate:OnDestroy()
    super.OnDestroy(self)
    self.Parameter.ItemButton.Listener:Release()
    MLuaUIListener.Destroy(self.Parameter.ItemButton.gameObject)
end --func end
--next--
--lua functions end

--lua custom scripts
ItemPotTemplate.TemplatePath = "UI/Prefabs/ItemPrefab"

function ItemPotTemplate:init()
    super.Init(self)

    --数据初始化
    self.baseDataInfo = {}
    self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.Bag)
    if nil == self.bagCtrl then
        return
    end

    self.bagPanel = self.bagCtrl.panel

    --加监听
    MLuaUIListener.Get(self.Parameter.ItemButton.gameObject)
    self.Parameter.ItemButton.Listener:SetActionBeginDrag(self._onStartDrag, self)
    self.Parameter.ItemButton.Listener:SetActionEndDrag(self._onEndDrag, self)
    self.Parameter.ItemButton.Listener:SetActionOnDrag(self._onDrag, self)
    self.Parameter.ItemButton.Listener:SetActionButtonUp(self._onPressUp, self)
    self.Parameter.ItemButton.Listener:SetActionButtonDown(self._onPressDown, self)
    self.Parameter.ItemButton.Listener:SetActionClick(self._onClick, self)
end

function ItemPotTemplate:_onClick(go, eventData)
    self.bagCtrl:InitPotLong()

    --tips
    if self.ShowData == nil then
        MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
    else
        self.bagCtrl:ShowPotPropTip(self.ShowData)
    end

    --双击
    if self.ShowData ~= nil then
        self.bagCtrl:Pot2doEnter(self.ShowIndex)
    end
end

function ItemPotTemplate:_onExit(go, eventData)
    --长按
    self.bagCtrl:PotExit()
end

function ItemPotTemplate:_onPressDown(go, eventData)
    --长按
    self.bagCtrl:InitPotLong()
    if self.ShowData ~= nil then
        self.bagCtrl:PotLongPointEnter(eventData, self.ShowIndex)
    end
end

function ItemPotTemplate:_onPressUp(go, eventData)
    if self._dragging then
        return
    end

    --处理选中框
    local l_t = self.bagCtrl.potLastPoint
    self.bagCtrl.potLastPoint = self.ShowIndex
    if l_t ~= self.ShowIndex then
        self.bagCtrl.potTemplatePool:RefreshCells()
    end

    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
end

function ItemPotTemplate:_onDrag(go, eventData)
    self.bagCtrl:PotDragItem(eventData)
end

function ItemPotTemplate:_onStartDrag(go, eventData)
    self._dragging = true
    self.bagPanel.ScrollPot.LoopScroll:OnBeginDrag(eventData)
end

function ItemPotTemplate:_onEndDrag(go, eventData)
    self._dragging = false
    self.bagCtrl:PotLongPointQuit(eventData)
    self.bagCtrl:InitPotLong()
    self.bagPanel.ScrollPot.LoopScroll:OnEndDrag(eventData)
end

function ItemPotTemplate:SetActiveEx(uicom, isActive)
    if uicom.gameObject.activeSelf ~= isActive then
        uicom.gameObject:SetActiveEx(isActive)
    end
end

function ItemPotTemplate:FreshSelect()
    if nil == self.bagCtrl then
        self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.Bag)
        return
    end

    if nil == self.bagCtrl then
        return
    end

    if self.cdPart then
        if self.ShowIndex == self.bagCtrl.potLastPoint then
            self:SetActiveEx(self.cdPart.Parameter.ImgSelect, true)
        else
            self:SetActiveEx(self.cdPart.Parameter.ImgSelect, false)
        end
    end
end

--lua custom scripts end

return ItemPotTemplate