--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PotionSettingPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
PotionSettingCtrl = class("PotionSettingCtrl", super)
--lua class define end

--lua functions
function PotionSettingCtrl:ctor()
	
	super.ctor(self, CtrlNames.PotionSetting, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function PotionSettingCtrl:Init()
	
	self.panel = UI.PotionSettingPanel.Bind(self)
	super.Init(self)

    self.addHpSpeed = 0
    self.addMpSpeed = 0
    self.ItemTempTable = {}
    self.SelectItemTempTable = {}
    self.pressCountDown = 0
    --当前选择的ItemSelectTemplate
    self.currentSelectedItemTemplate = nil

    -- 修改需要，现在操作即时生效
    -- 缓存数据，保存不即时生效
    self.dataForSave = {
        AutoDragHpPercent = MPlayerInfo.AutoDragHpPercent,
        AutoDragMpPercent = MPlayerInfo.AutoDragMpPercent,
        EnableAutoHpDrag = MPlayerInfo.EnableAutoHpDrag,
        EnableAutoMpDrag = MPlayerInfo.EnableAutoMpDrag,
        AutoHpDragItemList = {},    -- MPlayerInfo.AutoHpDragItemList
        AutoMpDragItemList = {},    -- MPlayerInfo.AutoMpDragItemList
    }
    for i = 0, MPlayerInfo.AutoHpDragItemList.Length-1 do
        self.dataForSave.AutoHpDragItemList[i] = MPlayerInfo.AutoHpDragItemList[i]
    end
    for i = 0, MPlayerInfo.AutoMpDragItemList.Length-1 do
        self.dataForSave.AutoMpDragItemList[i] = MPlayerInfo.AutoMpDragItemList[i]
    end

    --self.panel.BackBtn:AddClick(function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.PotionSetting)
    --end)

    --self.panel.CloseBtn:AddClick(function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.PotionSetting)
    --end)

    self.panel.SaveBtn:AddClick(function()
        self:Save()
        UIMgr:DeActiveUI(UI.CtrlNames.PotionSetting)
    end)

    --药品设置
    self:InitHpSetting()
    self:InitMpSetting()
    self.panel.potionCloseBtn:AddClick(function()
        self:CloseSelectItem()
    end)
    self.panel.potionCloseBtn:SetActiveEx(false)
	
end --func end
--next--
function PotionSettingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PotionSettingCtrl:OnActive()
    -- 新手引导
    local l_beginnerGuideChecks = {"GetAutoDevOpenPanel"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks)
end --func end
--next--
function PotionSettingCtrl:OnDeActive()
	
end --func end
--next--
function PotionSettingCtrl:Update()
    if self.addHpSpeed ~= 0 then
        if self.pressCountDown > 30 then
            self:SetHpPercent(self.dataForSave.AutoDragHpPercent + self.addHpSpeed)
        else
            self.pressCountDown = self.pressCountDown + 1
        end
    end

    if self.addMpSpeed ~= 0 then
        if self.pressCountDown > 30 then
            self:SetMpPercent(self.dataForSave.AutoDragMpPercent + self.addMpSpeed)
        else
            self.pressCountDown = self.pressCountDown + 1
        end
    end
	
end --func end
--next--
function PotionSettingCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function PotionSettingCtrl:InitHpSetting()

    self.panel.TogHpUse:OnToggleChanged(function(on)
        self.dataForSave.EnableAutoHpDrag = on

        self:Save()
    end)
    self.panel.TogHpUse.Tog.isOn = self.dataForSave.EnableAutoHpDrag

    self.panel.SliderHpUse:OnSliderChange(function(value)
        self.dataForSave.AutoDragHpPercent = value
        self.panel.LabHpPercent.LabText = Common.Utils.Lang("AUTO_DRAG_HP_PERCENT", tostring(math.floor(value)) .. "%")

        self:Save()
    end)
    self.panel.SliderHpUse.Slider.value = self.dataForSave.AutoDragHpPercent
    self.panel.LabHpPercent.LabText = Common.Utils.Lang("AUTO_DRAG_HP_PERCENT", tostring(math.floor(self.dataForSave.AutoDragHpPercent)) .. "%")

    self.panel.HpUseAdd.Listener.onDown = function()
        self.addHpSpeed = 1
    end

    self.panel.HpUseAdd.Listener.onUp = function()
        self:SetHpPercent(self.dataForSave.AutoDragHpPercent + self.addHpSpeed)
        self.addHpSpeed = 0
        self.pressCountDown = 0
    end

    self.panel.HpUseSub.Listener.onDown = function()
        self.addHpSpeed = -1
    end

    self.panel.HpUseSub.Listener.onUp = function()
        self:SetHpPercent(self.dataForSave.AutoDragHpPercent + self.addHpSpeed)
        self.addHpSpeed = 0
        self.pressCountDown = 0
    end
    local l_hpDragNum = MGlobalConfig:GetInt("AutoRecoveryHPNumber")
    local l_hpDragSelectList = MGlobalConfig:GetSequenceOrVectorInt("AutoRecoveryHPGoods")
    for i = 0, l_hpDragNum - 1 do
        local l_id = i
        local l_itemInstance = self:NewTemplate("ItemSelectTemplate", {
            Data = {
                --当前按钮的物品Id
                itemId = self.dataForSave.AutoHpDragItemList[l_id],
                --可用的物品
                itemList = l_hpDragSelectList,
                --父界面
                parent = self,
                --修改数值回调
                callback = function(value)
                    self.dataForSave.AutoHpDragItemList[l_id] = value
                end,
                --已经选择的物品组
                selectedGroup = self.dataForSave.AutoHpDragItemList
            },
            TemplateParent = self.panel.FightAutoHpItems.transform,
            TemplatePrefab = self.panel.ItemSelectTemplate.gameObject,
            IsActive = true
        })
        self.ItemTempTable[#self.ItemTempTable + 1] = l_itemInstance
    end

end


function PotionSettingCtrl:InitMpSetting()

    self.panel.TogMpUse:OnToggleChanged(function(on)
        self.dataForSave.EnableAutoMpDrag = on

        self:Save()
    end)
    self.panel.TogMpUse.Tog.isOn = self.dataForSave.EnableAutoMpDrag

    self.panel.SliderMpUse:OnSliderChange(function(value)
        self.dataForSave.AutoDragMpPercent = value
        self.panel.LabMpPercent.LabText = Common.Utils.Lang("AUTO_DRAG_MP_PERCENT", tostring(math.floor(value)) .. "%")

        self:Save()
    end)
    self.panel.SliderMpUse.Slider.value = self.dataForSave.AutoDragMpPercent
    self.panel.LabMpPercent.LabText = Common.Utils.Lang("AUTO_DRAG_MP_PERCENT", tostring(math.floor(self.dataForSave.AutoDragMpPercent)) .. "%")

    self.panel.MpUseAdd.Listener.onDown = function()
        self.addMpSpeed = 1
    end

    self.panel.MpUseAdd.Listener.onUp = function()
        self:SetMpPercent(self.dataForSave.AutoDragMpPercent + self.addMpSpeed)
        self.addMpSpeed = 0
        self.pressCountDown = 0
    end

    self.panel.MpUseSub.Listener.onDown = function()
        self.addMpSpeed = -1
    end

    self.panel.MpUseSub.Listener.onUp = function()
        self:SetMpPercent(self.dataForSave.AutoDragMpPercent + self.addMpSpeed)
        self.addMpSpeed = 0
        self.pressCountDown = 0
    end

    local l_spDragNum = MGlobalConfig:GetInt("AutoRecoverySPNumber")
    local l_spDragSelectList = MGlobalConfig:GetSequenceOrVectorInt("AutoRecoverySPGoods")
    for i = 0, l_spDragNum - 1 do
        local l_id = i
        local l_itemInstance = self:NewTemplate("ItemSelectTemplate", {
            Data = {
                --当前按钮的物品Id
                itemId = self.dataForSave.AutoMpDragItemList[l_id],
                --可用的物品
                itemList = l_spDragSelectList,
                --父界面
                parent = self,
                --修改数值回调
                callback = function(value)
                    self.dataForSave.AutoMpDragItemList[l_id] = value
                end,
                --已经选择的物品组
                selectedGroup = self.dataForSave.AutoMpDragItemList
            },
            TemplateParent = self.panel.FightAutoMpItems.transform,
            TemplatePrefab = self.panel.ItemSelectTemplate.gameObject,
            IsActive = true
        })
        self.ItemTempTable[#self.ItemTempTable + 1] = l_itemInstance
    end

end

function PotionSettingCtrl:OpenSelectItem(currentSelectedTemp)

    if self.panel.FightAutoSelectItemPanel.gameObject.activeSelf then
        self:CloseSelectItem()
    end
    --如果是本身, 则不再打开
    if self.currentSelectedItemTemplate == currentSelectedTemp then
        return
    end
    self.currentSelectedItemTemplate = currentSelectedTemp
    self.panel.FightAutoSelectItemPanel.gameObject:SetActiveEx(true)
    self.panel.potionCloseBtn:SetActiveEx(true)

    self.panel.SelectBoard.gameObject:SetActiveEx(true)
    self.panel.SelectBoard.transform:SetParent(currentSelectedTemp.Parameter.LuaUIGroup.transform)
    -- 放在倒数第二个
    self.panel.SelectBoard.transform:SetSiblingIndex(self.panel.SelectBoard.transform.parent.childCount-2)
    self.panel.SelectBoard.gameObject:SetLocalPos(0, 0, 0)

    for i = 0, currentSelectedTemp.itemList.Length - 1 do

        local l_id = i
        local v = currentSelectedTemp.itemList[l_id]

        --选择的物品组中是否包含
        local l_contained = false
        --for j = 0, currentSelectedTemp.selectedGroup.Length-1 do
        --    local selected = currentSelectedTemp.selectedGroup[j]
        --    if v == selected then
        --        l_contained = true
        --    end
        --end

        --是本物体
        local l_selected = currentSelectedTemp.itemId == v

        local l_levelLimit = TableUtil.GetItemTable().GetRowByItemID(tonumber(v)).LevelLimit
        local l_minLevel = l_levelLimit[0]
        if l_minLevel == -1 then
            l_minLevel = -1
        end
        local l_maxLevel = l_levelLimit[1]
        if l_maxLevel == -1 then
            l_maxLevel = 999
        end
        local l_levelOK = MPlayerInfo.Lv >= l_minLevel and MPlayerInfo.Lv <= l_maxLevel

        if l_selected or not l_contained and l_levelOK then
            local l_instance = self:NewTemplate("AutoBattleDargItemTemplate", {
                Data = {
                    itemId = v,
                    isSelected = l_selected,
                    parent = self,
                    onSelect = function(itemId)
                        --去掉同一个id的物品
                        for _, v in ipairs(self.ItemTempTable) do
                            if v.itemId == itemId then
                                v:RemoveItem()
                                break
                            end
                        end
                        currentSelectedTemp:SetItemId(itemId)
                        --for i=0,MPlayerInfo.AutoHpDragItemList.Length-1 do
                        --    logGreen("MPlayerInfo.AutoHpDragItemList["..i.."]:", MPlayerInfo.AutoHpDragItemList[i])
                        --end
                    end
                },
                TemplateParent = self.panel.SelectItemContent.transform,
                TemplatePrefab = self.panel.AutoBattleDargItemTemplate.gameObject,
                IsActive = true,
            })
            self.SelectItemTempTable[#self.SelectItemTempTable + 1] = l_instance
        end

    end

    --设置大小位置
    local l_oldSize = self.panel.SelectDragItemScrollView.RectTransform.sizeDelta
    --刷新大小
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.SelectItemContent.RectTransform)
    local l_itemRect = currentSelectedTemp.Parameter.LuaUIGroup.RectTransform
    local l_screenPos = MUIManager.UICamera:WorldToScreenPoint(l_itemRect.position)
    local _, l_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.SelectDragItemScrollView.RectTransform.parent, l_screenPos, MUIManager.UICamera, nil)
    l_pos.x = l_pos.x + self.panel.SelectDragItemScrollView.RectTransform.rect.width / 2 + 50
    l_pos.y = 0
    self.panel.SelectDragItemScrollView.RectTransform.anchoredPosition = l_pos

end

function PotionSettingCtrl:CloseSelectItem()

    self.panel.FightAutoSelectItemPanel.gameObject:SetActiveEx(false)
    self.panel.potionCloseBtn:SetActiveEx(false)
    self.panel.SelectBoard.gameObject:SetActiveEx(false)
    for i, v in pairs(self.SelectItemTempTable) do
        self:UninitTemplate(v)
    end
    self.SelectItemTempTable = {}
    self.currentSelectedItemTemplate = nil

end


function PotionSettingCtrl:SetHpPercent(value)

    self.dataForSave.AutoDragHpPercent = value
    self.dataForSave.AutoDragHpPercent = math.max(0, math.min(100, self.dataForSave.AutoDragHpPercent))
    self.panel.SliderHpUse.Slider.value = self.dataForSave.AutoDragHpPercent

    self:Save()
end

function PotionSettingCtrl:SetMpPercent(value)

    self.dataForSave.AutoDragMpPercent = value
    self.dataForSave.AutoDragMpPercent = math.max(0, math.min(100, self.dataForSave.AutoDragMpPercent))
    self.panel.SliderMpUse.Slider.value = self.dataForSave.AutoDragMpPercent

    self:Save()

end

function PotionSettingCtrl:Save()
    MPlayerInfo.AutoDragHpPercent = self.dataForSave.AutoDragHpPercent
    MPlayerInfo.AutoDragMpPercent = self.dataForSave.AutoDragMpPercent
    MPlayerInfo.EnableAutoHpDrag = self.dataForSave.EnableAutoHpDrag
    MPlayerInfo.EnableAutoMpDrag = self.dataForSave.EnableAutoMpDrag
    for i = 0, MPlayerInfo.AutoHpDragItemList.Length-1 do
        MPlayerInfo.AutoHpDragItemList[i] = self.dataForSave.AutoHpDragItemList[i]
    end
    for i = 0, MPlayerInfo.AutoMpDragItemList.Length-1 do
        MPlayerInfo.AutoMpDragItemList[i] = self.dataForSave.AutoMpDragItemList[i]
    end


    MgrMgr:GetMgr("FightAutoMgr").SaveAutoBattleInfo()
end

--lua custom scripts end
return PotionSettingCtrl