--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehicleShopPanel"
require "UI/Template/VehicleShopItemTemplete"
require "UI/Template/ItemTemplate"
require "Common/Utils"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local selectClick = 1
--next--
--lua fields end

--lua class define
VehicleShopCtrl = class("VehicleShopCtrl", super)
--lua class define end

--lua functions
function VehicleShopCtrl:ctor()

    super.ctor(self, CtrlNames.VehicleShop, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function VehicleShopCtrl:Init()

    self.panel = UI.VehicleShopPanel.Bind(self)
    super.Init(self)

    self.Mgr = MgrMgr:GetMgr("VehicleInfoMgr")
    self.isHaveData = false
    self.vehicleConfig = nil
    self.vehicleDatas = nil
    self.nowSelectID = nil
    self.nowModel = nil
    self.npcID = nil
    self.vehiclePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.VehicleShopItemTemplete,
        ScrollRect = self.panel.HeadScrollView.LoopScroll,
        TemplatePrefab = self.panel.VehicleShopItem.gameObject
    })
    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.CostPanel.LoopScroll,
    })
    self.panel.VehicleShopItem.gameObject:SetActiveEx(false)

    self.panel.BtOp:AddClick(function()
        self:OnExchange()
    end)
    self.panel.BtClose:AddClick(self.CloseUI)

end --func end
--next--
function VehicleShopCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.Mgr = nil
    self.isHaveData = false
    self.vehicleConfig = nil
    self.vehicleDatas = nil
    self.nowSelectID = nil
    if self.nowModel then
        self:DestroyUIModel(self.nowModel)
        self.nowModel = nil
    end
    self.npcID = nil
    self.vehiclePool = nil
    self.itemPool = nil

end --func end
--next--
function VehicleShopCtrl:OnActive()

    self:FocusToNpc()
    if not self.isHaveDate then
        isHaveData = true
        self:InitShopData()
    end
    self:RefreshShop()
    self:RefreshInfomation()

end --func end
--next--
function VehicleShopCtrl:OnDeActive()

    MPlayerInfo:FocusToMyPlayer()

end --func end
--next--
function VehicleShopCtrl:Update()

end --func end

--next--
function VehicleShopCtrl:BindEvents()

    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.ExchangeSpecialVehicle, self.RefreshAll)

end --func end

--next--
--lua functions end

--lua custom scripts
function VehicleShopCtrl:RefreshAll()

    self:RefreshShop()
    self:RefreshInfomation()

end

function VehicleShopCtrl:SetDefaultItem(param)

    if param ~= nil then
        self.nowSelectID = param.itemId
    end

end

function VehicleShopCtrl:CloseUI()

    UIMgr:DeActiveUI(UI.CtrlNames.VehicleShop)

end

--判断当前载具是否已经拥有且时限为永久
function VehicleShopCtrl:IsOwnPermanent(id)

    return self.Mgr.IsPermentVehicle(id)

end

--判断当前载具是否拥有足够的材料合成
function VehicleShopCtrl:IsEnoughResources(id)
    local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(id)
    if not l_vehicle then
        logError(StringEx.Format("找不到数据@周阳", id))
        return
    end

    local l_costs = Common.Functions.VectorSequenceToTable(l_vehicle.ItemCost)
    for i, v in ipairs(l_costs) do
        local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
        if l_count < v[2] then
            return false, v[1], v[2] - l_count
        end
    end

    return true
end

--玩家选中当前ID载具
function VehicleShopCtrl:VehicleSelect(id, index)

    if not index then
        for k, v in pairs(self.vehiclePool.Items) do
            if v.data.ID == id then
                index = v.ShowIndex
            end
        end
    end
    if not index then
        logError("找不到当前ID的载具")
        return
    end
    if (selectClick == index) then
        return
    end
    --local l_lastSelectItem = self.vehiclePool:GetItem(selectClick)
    --if l_lastSelectItem then
    --    l_lastSelectItem:ShowFrame(false)
    --end
    selectClick = index
    self.nowSelectID = id
    --l_lastSelectItem = self.vehiclePool:GetItem(selectClick)
    --if l_lastSelectItem then
    --    l_lastSelectItem:ShowFrame(true)
    --end
    self.vehiclePool:SelectTemplate(selectClick)
    self:RefreshInfomation()

end

--模型展示
function VehicleShopCtrl:RefreshModel()

    if self.nowModel then
        self:DestroyUIModel(self.nowModel)
        self.nowModel = nil
    end
    vehicleItem = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
    self.nowModel = self.Mgr.CreateModel(vehicleItem.ID, nil, nil,
            self.panel.ItemlImage, self.panel.Img_TouchArea)
    self:SaveModelData(self.nowModel)
end

--刷新展示面板
function VehicleShopCtrl:RefreshInfomation()

    local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
    if not l_vehicle then
        logError(StringEx.Format("找不到数据：@周阳", self.nowSelectID))
        return
    end
    local l_vehicleInfo = TableUtil.GetItemTable().GetRowByItemID(self.nowSelectID)
    if not l_vehicleInfo then
        logError(StringEx.Format("找不到对应载具@周阳 ID:{0}", self.nowSelectID))
        return
    end
    self.panel.ModelName.LabText = l_vehicleInfo.ItemName
    self.panel.RefineName.LabText = l_vehicleInfo.ItemName
    self:RefreshModel()

    local l_isFullRes = true
    local l_costDatas = {}
    local l_costs = Common.Functions.VectorSequenceToTable(l_vehicle.ItemCost)
    for i, v in ipairs(l_costs) do
        local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
        table.insert(l_costDatas, { ID = v[1], Count = l_count, IsShowRequire = true,
                                    RequireCount = v[2], IsShowCount = false, })
        if l_count < v[2] then
            l_isFullRes = false
        end
    end

    self.itemPool:ShowTemplates({ Datas = l_costDatas })
    if self:IsOwnPermanent(self.nowSelectID) then
        self.panel.BtOp.gameObject:SetActiveEx(false)
        self.panel.LimitStr.gameObject:SetActiveEx(true)
    else
        self.panel.BtOp.gameObject:SetActiveEx(true)
        self.panel.LimitStr.gameObject:SetActiveEx(false)
    end
end

--刷新合成列表
function VehicleShopCtrl:RefreshShop()

    local l_select = 1
    for i, data in ipairs(self.vehicleDatas) do
        data.isSelect = false
        if not self.nowSelectID then
            self.nowSelectID = data.ID
        end
        if self.nowSelectID == data.ID then
            l_select = i
            data.isSelect = true
        end
        data.isFullRes = self:IsEnoughResources(data.ID)
        data.isOwnF = self:IsOwnPermanent(data.ID)
    end

    selectClick = l_select
    self.vehiclePool:ShowTemplates({ Datas = self.vehicleDatas,
                                     StartScrollIndex = l_select,
                                     Method = function(id, index)
                                         self:VehicleSelect(id, index)
                                     end })
    self.vehiclePool:SelectTemplate(selectClick)

end

--读取载具信息并按照{载具未拥有永久且有足够的材料合成 > 载具未拥有永久 > 载具已拥有永久}的规则排序
function VehicleShopCtrl:InitShopData()

    local l_vehicle = TableUtil.GetVehicleTable().GetTable()
    if #l_vehicle <= 0 then
        logError(StringEx.Format("找不到数据：@周阳"))
        self:CloseUI()
    end

    self.vehicleDatas = {}
    self.vehicleConfig = l_vehicle
    for i, v in ipairs(self.vehicleConfig) do
        local l_costs = Common.Functions.VectorSequenceToTable(v.ItemCost)
        if #l_costs ~= 0 then
            local l_vehicleID = v.ID
            local l_isOwnP = self:IsOwnPermanent(l_vehicleID)
            local l_isFullRes = self:IsEnoughResources(l_vehicleID)
            local l_sortVal = l_vehicleID
            if l_isOwnP then
                l_sortVal = l_sortVal - 100000000
            end
            if l_isFullRes then
                l_sortVal = l_sortVal + 10000000
            end
            local l_data = { ID = l_vehicleID, sortVal = l_sortVal }
            table.insert(self.vehicleDatas, l_data)
        end
    end
    table.sort(self.vehicleDatas, function(m, n)
        return m.sortVal > n.sortVal
    end)

end

--载具合成请求
function VehicleShopCtrl:OnExchange()

    if not self.nowSelectID then
        return
    end

    --如果材料不足
    local l_needRes, l_needItem = self:IsEnoughResources(self.nowSelectID)
    if not l_needRes then
        local l_item = TableUtil.GetItemTable().GetRowByItemID(l_needItem)
        if not l_item then
            logError(StringEx.Format("载具id对应的消耗材料不存在@周阳 id:{0}", l_needItem))
            return
        end

        local itemData = Data.BagModel:CreateItemWithTid(l_needItem)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self.panel.Anchor.transform, nil, nil, true, { relativePositionY = 28 })
        return
    end

    local l_row = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
    if not l_row then
        logError(StringEx.Format("载具配置不存在@周阳{0}", self.nowSelectID))
        return
    end
    CommonUI.Dialog.ShowYesNoDlg(true, nil,
            Common.Utils.Lang("CONFIRM_EXCHANGE", l_row.Name),
            function()
                self.Mgr.SendExchangeSpecialVehicleMsg(self.nowSelectID)
            end)

end

--更新视角
function VehicleShopCtrl:FocusToNpc()

    local l_npcData
    if not self.npcID then
        local l_npc = Common.CommonUIFunc.GetNpcIdTbByFuncId(
                MgrMgr:GetMgr("OpenSystemMgr").eSystemId.VehicleBarber)
        if not l_npc then
            logError("获取npcid失败")
            -- force quit?
            self:CloseUI()
            return
        end
        l_npcData = l_npc
    end

    -- Focus对应npc，相对于对话框需要左移一点，旋转一点
    -- MPlayerInfo:FocusToNpc(self.npcID, 1, 4, 135, 5)
    for i, v in ipairs(l_npcData) do
        local l_npcEntity = MNpcMgr:FindNpcInViewport(v)
        if l_npcEntity ~= nil then
            local l_rightVec = l_npcEntity.Model.Rotation * Vector3.right
            local l_temp2 = -0.2
            self.npcID = v
            MPlayerInfo:FocusToOrnamentBarter(self.npcID, l_rightVec.x * l_temp2, 1, l_rightVec.z * l_temp2, 4, 10, 5)
            break
        end
    end
    if not self.npcID then
        logError(StringEx.Format("找不到场景中的npc npcID:{0}", self.npcID))
        return
    end
    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end

end
--lua custom scripts end

return VehicleShopCtrl