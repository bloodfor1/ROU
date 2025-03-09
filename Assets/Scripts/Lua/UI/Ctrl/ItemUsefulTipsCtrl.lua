--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ItemUsefulTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ItemUsefulTipsCtrl = class("ItemUsefulTipsCtrl", super)
--lua class define end

--lua functions
function ItemUsefulTipsCtrl:ctor()
    super.ctor(self, CtrlNames.ItemUsefulTips, UILayer.Tips, nil, ActiveType.Standalone)
end --func end
--next--
function ItemUsefulTipsCtrl:Init()
    self.panel = UI.ItemUsefulTipsPanel.Bind(self)
    super.Init(self)
    self.panel.CloseBtn.Listener.onClick = function(obj, data)
        UIMgr:DeActiveUI(UI.CtrlNames.ItemUsefulTips)
        MLuaClientHelper.ExecuteClickEvents(data.position, UI.CtrlNames.ItemUsefulTips)
    end

    self._equipForgePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.ContentEquip.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    self._equipExchangePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.ContentBarber.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    self._vehicleExchangePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.Contentvehicle.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
end --func end
--next--
function ItemUsefulTipsCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ItemUsefulTipsCtrl:OnActive()
    MgrMgr:GetMgr("ItemTipsMgr").SortCommonTipsAndItemUsefulPath()
end --func end
--next--
function ItemUsefulTipsCtrl:OnDeActive()
    self:DestoryModel()
end --func end
--next--
function ItemUsefulTipsCtrl:Update()
    self._equipForgePool:OnUpdate()
    self._equipExchangePool:OnUpdate()
    self._vehicleExchangePool:OnUpdate()
end --func end
--next--
function ItemUsefulTipsCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts
function ItemUsefulTipsCtrl:ShowMaterialUseFulPanel(ItemExchangeOrnamentInfo, ItemExchangeEquipInfo, ItemVehicleInfo, itemTableData)
    local picTxt = Common.CommonUIFunc.GetImageText(itemTableData.ItemIcon, itemTableData.ItemAtlas, nil, nil, nil)
    self.panel.TxtMaterialUseful.LabText = picTxt .. " " .. MgrMgr:GetMgr("EquipMgr").GetEquipNameWithColor(itemTableData.ItemID) .. Lang("MAT_USEFUL")
    self.panel.MaterialUsefulPanel:SetActiveEx(true)
    self.panel.ModelViewer:SetActiveEx(false)
    self.panel.VehicleViewer:SetActiveEx(false)
    self.itemExchangeOrnamentTable = {}
    ItemExchangeOrnamentInfo = ItemExchangeOrnamentInfo or {}
    for i = 1, #ItemExchangeOrnamentInfo do
        self.itemExchangeOrnamentTable[i] = {
            ID = ItemExchangeOrnamentInfo[i],
            IsShowCount = false,
            IsHave = self:_haveItemWithId(ItemExchangeOrnamentInfo[i]),
        }
    end

    self.itemExchangeEquipTable = {}
    ItemExchangeEquipInfo = ItemExchangeEquipInfo or {}
    for i = 1, #ItemExchangeEquipInfo do
        local l_equipItemData = TableUtil.GetItemTable().GetRowByItemID(ItemExchangeEquipInfo[i])
        local l_isSupport = self:_isProMatch(MPlayerInfo.ProID, ItemExchangeEquipInfo[i])--Common.CommonUIFunc.GetIsContainProfession(MPlayerInfo.ProID, l_equipItemData.Profession)
        local l_mSex = MPlayerInfo.IsMale and 0 or 1
        if l_isSupport and (itemTableData.SexLimit == 2 or l_equipItemData.SexLimit == l_mSex) then
            local singleData = {
                ID = ItemExchangeEquipInfo[i],
                IsShowCount = false,
                IsHave = self:_haveItemWithId(ItemExchangeEquipInfo[i]),
            }

            table.insert(self.itemExchangeEquipTable, singleData)
        end
    end

    self.itemExchangeVechicleTable = {}
    ItemVehicleInfo = ItemVehicleInfo or {}
    for i = 1, #ItemVehicleInfo do
        self.itemExchangeVechicleTable[i] = {
            ID = ItemVehicleInfo[i],
            IsShowCount = false,
            IsHave = self:_haveItemWithId(ItemVehicleInfo[i]),
        }
    end

    self._equipExchangePool:ShowTemplates({ Datas = self.itemExchangeOrnamentTable })
    self._equipForgePool:ShowTemplates({ Datas = self.itemExchangeEquipTable })
    self._vehicleExchangePool:ShowTemplates({ Datas = self.itemExchangeVechicleTable })
    
    self:SetToSingleShowMode(ItemExchangeOrnamentInfo, ItemExchangeEquipInfo , ItemVehicleInfo)
end

function ItemUsefulTipsCtrl:_haveItemWithId(propId)
    local types = {
        GameEnum.EBagContainerType.Bag,
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Wardrobe,
        GameEnum.EBagContainerType.Cart,
        GameEnum.EBagContainerType.WareHouse,
    }

    local count = Data.BagApi:GetItemCountByContListAndTid(types, propId)
    return 0 < count
end

function ItemUsefulTipsCtrl:_isProMatch(proID, itemID)
    local target = ItemProOffLineMap[itemID]
    if nil == target then
        return true
    end

    return nil ~= target[proID]
end

function ItemUsefulTipsCtrl:VechvleViewer(itemTableData)
    self.panel.MaterialUsefulPanel:SetActiveEx(false)
    self.panel.ModelViewer:SetActiveEx(false)
    self.panel.VehicleViewer:SetActiveEx(true)
    self.panel.Model_Obj:SetActiveEx(true)
    self.panel.Model_Character:SetActiveEx(false)
    self.panel.HideOtherAppearances:SetActiveEx(false)
    self.panel.TxtVehicleTitle.LabText = Lang("VEHICLE_VIEW")
    self:DestoryModel()
    self.model = Common.CommonUIFunc.CreateVechicleModel(itemTableData.ItemID, self.panel.Model_Obj, true, false, false)
    self:SaveModelData(self.model)
end

function ItemUsefulTipsCtrl:ModelViewer(itemTableData)
    self.panel.MaterialUsefulPanel:SetActiveEx(false)
    self.panel.ModelViewer:SetActiveEx(true)
    self.panel.VehicleViewer:SetActiveEx(false)
    self.panel.Model_Obj:SetActiveEx(false)
    self.panel.Model_Character:SetActiveEx(true)
    self.panel.HideOtherAppearances:SetActiveEx(true)
    self.panel.TxtModelTitle.LabText = Lang("MODEL_VIEW")
    self.panel.HideOtherAppearances:OnToggleChanged(function(value)
        if value then
            self:DestoryModel()
            self.model = Common.CommonUIFunc.CreatePlayerModel({itemTableData.ItemID}, {itemTableData}, self.panel.Model_Character, true, true, false, false)
            self:SaveModelData(self.model)
        else
            self:DestoryModel()
            self.model = Common.CommonUIFunc.CreatePlayerModel({itemTableData.ItemID}, {itemTableData}, self.panel.Model_Character, false, true, false, false)
            self:SaveModelData(self.model)
        end
    end)
    self.panel.HideOtherAppearances.Tog.isOn = false
end

function ItemUsefulTipsCtrl:SetSelfPos(pos)
    if self.panel.MaterialUsefulPanel ~= nil and pos ~= nil then
        self.panel.MaterialUsefulPanel.RectTransform.localPosition = pos
    end
    if self.panel.ModelViewer ~= nil and pos ~= nil then
        self.panel.ModelViewer.RectTransform:SetLocalPos(pos.x - 25, pos.y - 40, 0)
    end

    if self.panel.VehicleViewer ~= nil and pos ~= nil then
        self.panel.VehicleViewer.RectTransform:SetLocalPos(pos.x - 25, pos.y - 25, 0)
    end
end

function ItemUsefulTipsCtrl:SetToSingleShowMode(ItemExchangeOrnamentInfo, ItemExchangeEquipInfo, ItemVehicleInfo)
    self.panel.Group_Barber:SetActiveEx(table.maxn(ItemExchangeOrnamentInfo) ~= 0)
    self.panel.Group_Equip:SetActiveEx(table.maxn(ItemExchangeEquipInfo) ~= 0)
    self.panel.Group_Vehicle:SetActiveEx(table.maxn(ItemVehicleInfo) ~= 0)
end

function ItemUsefulTipsCtrl:DestoryModel()
    if self.model then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end

--返回只有一个Tips显示的时候的x和y坐标 宽度和高度用于道具获取途径位置设置
function ItemUsefulTipsCtrl:GetSelfTipsPosInfo()
    local trans = nil
    local rtTrans = nil
    local isMat = false --是否是材料用途
    if self.panel.MaterialUsefulPanel ~= nil and self.panel.MaterialUsefulPanel.gameObject.activeSelf then
        trans = self.panel.MaterialUsefulPanel.transform
        rtTrans = self.panel.MaterialUsefulPanel.RectTransform
        isMat = true
    end
    if self.panel.ModelViewer ~= nil and self.panel.ModelViewer.gameObject.activeSelf then
        trans = self.panel.ModelViewer.transform
        rtTrans = self.panel.ModelViewer.RectTransform
        isMat = false
    end

    if self.panel.VehicleViewer ~= nil and self.panel.ModelViewer.gameObject.activeSelf then
        trans = self.panel.VehicleViewer.transform
        rtTrans = self.panel.VehicleViewer.RectTransform
        isMat = false
    end
    if trans and rtTrans then
        LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
        return rtTrans.anchoredPosition.x, rtTrans.anchoredPosition.y, rtTrans.sizeDelta.x, rtTrans.sizeDelta.y, isMat
    end
    return 0, 0, 0, 0

end

--lua custom scripts end
return ItemUsefulTipsCtrl