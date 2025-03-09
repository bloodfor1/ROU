--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ItemAchievePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ItemAchieveCtrl : UIBaseCtrl
ItemAchieveCtrl = class("ItemAchieveCtrl", super)
--lua class define end

--lua functions
function ItemAchieveCtrl:ctor()
    super.ctor(self, CtrlNames.ItemAchieve, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.ItemAchieve
end --func end
--next--
function ItemAchieveCtrl:Init()
    self.panel = UI.ItemAchievePanel.Bind(self)
    super.Init(self)
    self:_initData()
end --func end
--next--
function ItemAchieveCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ItemAchieveCtrl:OnActive()
    ---@type EnchantInheritNewEquipPanelData
    local panelData = self.uiPanelData
    self:_onSetData(panelData)
end --func end
--next--
function ItemAchieveCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function ItemAchieveCtrl:Update()
    -- do nothing
end --func end
--next--
function ItemAchieveCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

---@param data EnchantInheritNewEquipPanelData
function ItemAchieveCtrl:_onSetData(data)
    if nil == data then
        logError("[ItemAchieveCtrl] invalid data")
        return
    end

    self._onClose = data.OnClose
    self._onCloseSelf = data.OnCloseSelf
    local itemList = data.ItemList
    local l_wrapData = {}
    for i = 1, #itemList do
        l_wrapData[i] = { propInfo = itemList[i], cbData = { cb = self._closeAfterSelected, cbSelf = self } }
    end

    local l_templateParam = { Datas = l_wrapData }
    self.itemPool:ShowTemplates(l_templateParam)
end

function ItemAchieveCtrl:_initData()
    local l_itemTemplatePoolConfig = {
        TemplateClassName = "AchieveTpl",
        TemplatePrefab = self.panel.AchieveTpl.gameObject,
        ScrollRect = self.panel.AchievePanelLayout.LoopScroll,
    }

    self.itemPool = self:NewTemplatePool(l_itemTemplatePoolConfig)
end

--- 选中之后触发的回调
---@param itemData ItemData
function ItemAchieveCtrl:_closeAfterSelected(itemData)
    self._onClose(self._onCloseSelf, itemData)
    UIMgr:DeActiveUI(self.name)
end

function ItemAchieveCtrl:_onDestroy()
    self.itemPool = nil
    self.cb = nil
    self.onSelectCbSelf = nil
end

--lua custom scripts end
return ItemAchieveCtrl