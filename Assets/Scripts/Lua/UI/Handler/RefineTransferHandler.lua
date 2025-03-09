--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/RefineTransferPanel"
require "UI/Template/ItemTemplate"
require "UI/Template/RefineTransferItemTemplate"
require "coroutine"
require "UI/Template/EquipElevateEffectTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
RefineTransferHandler = class("RefineTransferHandler", super)

local l_mgr = MgrMgr:GetMgr("RefineTransferMgr")
--lua class define end

--lua functions
function RefineTransferHandler:ctor()
    super.ctor(self, HandlerNames.RefineTransfer, 0)
end --func end
--next--
function RefineTransferHandler:Init()
    self.panel = UI.RefineTransferPanel.Bind(self)
    super.Init(self)
    self.panel.ShowExplainPanelButton:AddClick(function()
        local l_content
        l_content = Lang("REFINE_TRANSFER_PERFECT_DESC")
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 366,
                y = 29,
            },
            width = 400,
        })
    end)

    self.panel.NoneInfoButton:AddClick(function()
        local l_content
        l_content = Lang("REFINE_TRANSFER_DESC")
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.LowerRight,
            pos = {
                x = 300,
                y = 60,
            },
            width = 340,
        })
    end)

    self.transferPanelInit = nil
    self.newEquipItem = nil
    self.oriEquipItem = nil
    self.trasferCostItems = {}
    self.perfectTogSelected = false
    self.lastOpTime = nil
end --func end
--next--
function RefineTransferHandler:Uninit()
    self.transferPanelInit = nil
    self.lastOpTime = nil
    self.newEquipItem = nil
    self.oriEquipItem = nil

    if self.trasferCostItems then
        self.trasferCostItems = nil
    end

    self.perfectTogSelected = nil
    self.newEquipItemsPool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RefineTransferHandler:OnActive()
    self:CustomRefresh()
end --func end
--next--
function RefineTransferHandler:OnDeActive()
    l_mgr.SelectOldEquip = nil
    l_mgr.SelectNewEquip = nil
end --func end
--next--
function RefineTransferHandler:Update()
    -- do nothing
end --func end

--next--
function RefineTransferHandler:OnShow()
    self:CustomRefresh()
end --func end
--next--
function RefineTransferHandler:OnHide()
    self:CustomRefresh()
end --func end
--next--
function RefineTransferHandler:BindEvents()
    --点击装备显示装备信息
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, function(self, item)
        if self:IsShowing() then
            self:OnEquipItemButton(item)
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isShow)
        if l_mgr.SelectOldEquip and l_mgr.SelectNewEquip then
            self.panel.NonSelectPanel.gameObject:SetActiveEx(false)
        else
            self.panel.NonSelectPanel.gameObject:SetActiveEx(isShow)
        end

        self.panel.TransferPanel.gameObject:SetActiveEx(isShow)
    end)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._refreshPageOnItemChange)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_TRANSFER_SUCCESS_EVENT, self.OnTransferSuccess)
end --func end

--next--
--lua functions end

--lua custom scripts

--- 屏蔽掉升级导致的道具变化
function RefineTransferHandler:_refreshPageOnItemChange()
    if self.lastOpTime and (Time.realtimeSinceStartup - self.lastOpTime) < 2 then
        return
    end

    self:CustomRefresh()
end

function RefineTransferHandler:_setSelectEquipData(flag)
    if flag == nil then
        flag = true
    end

    local l_template = self:GetSelectEquipTemplate()
    if not l_template then
        logError("[RefineTransfer] equip template is nil")
        return
    end

    local l_paramConfig = {
        SelectEquipMgrName = "RefineTransferMgr",
        IsSelectSameEquip = flag,
        IsDefaultNotSelectedEquip = true,
        NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
    }

    l_template:SetData(l_paramConfig)
end

function RefineTransferHandler:SetSelectEquipDataOnHandlerSwitch()
    local l_template = self:GetSelectEquipTemplate()
    if l_template then
        l_template:SetData({
            SelectEquipMgrName = "RefineTransferMgr",
            IsDefaultNotSelectedEquip = true,
            NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
        })
    end
end

function RefineTransferHandler:InitTransferPanel()
    self.panel.IconButtonLeft:AddClick(function()
        if not l_mgr.SelectOldEquip then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFINE_TRANSFER_NOTIFY_ADD"))
        end
    end)

    self.panel.IconButtonRight:AddClick(function()
        if nil == l_mgr.SelectOldEquip then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFINE_TRANSFER_NOTIFY_ADD"))
            return
        end

        self:OpenNewEquipPanel()
    end)

    self.panel.LeftRemoveEquipButton:AddClick(function()
        if l_mgr.SelectOldEquip ~= nil then
            l_mgr.SelectOldEquip = nil
            MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid()
            local l_selectEquipTemplate = self:GetSelectEquipTemplate()
            if l_selectEquipTemplate then
                l_datas = l_selectEquipTemplate:CancelSelectTemplate()
            end
        end

        self:CustomRefresh()
    end)

    self.panel.RightRemoveEquipButton:AddClick(function()
        if l_mgr.SelectNewEquip ~= nil then
            l_mgr.SelectNewEquip = nil
        end

        self:_setSelectEquipData()
        self:CustomRefresh()
    end)

    self.panel.Toggle1.TogEx.onValueChanged:AddListener(function(value)
        if value and self.perfectTogSelected then
            self:CustomRefresh()
        end
    end)

    self.panel.Toggle2.TogEx.onValueChanged:AddListener(function(value)
        if value and not self.perfectTogSelected then
            self:CustomRefresh()
        end
    end)

    self.panel.RefineEquipButton:AddClick(function()
        self:RequestRefineTransferEquip()
    end)

    self.oriEquipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.LeftEquipItemParent.transform })
    self.newEquipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.RightEquipItemParent.transform })
    self.panel.BtnMaterialChooseClose:AddClick(function()
        self.panel.MaterialChoosePanel.gameObject:SetActiveEx(false)
    end)

    self.newEquipItemsPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.RefineTransferItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.RefineTransferItem.gameObject,
    })
end

function RefineTransferHandler:RefreshTransferPanel()
    if not self.transferPanelInit then
        self:InitTransferPanel()
        self.transferPanelInit = true
    end

    self:RefreshHoles()
    if l_mgr.SelectOldEquip and l_mgr.SelectNewEquip then
        self:RefreshTransferDetail()
        self.panel.NonSelectPanel.gameObject:SetActiveEx(false)
        self.panel.Info.gameObject:SetActiveEx(true)
    else
        local selectEquipTemp = self:GetSelectEquipTemplate()
        local count = 0
        if nil ~= selectEquipTemp then
            count = selectEquipTemp:GetDisplayItemCount()
        end

        self.panel.NonSelectPanel.gameObject:SetActiveEx(0 < count)
        self.panel.Img_Bg02.gameObject:SetActiveEx(false)
        self.panel.Info.gameObject:SetActiveEx(false)
        self.panel.TransferDetail.gameObject:SetActiveEx(false)
        self.panel.Info.gameObject:SetActiveEx(false)
        self.panel.NoneText.LabText = Lang("REFINE_TRANSFER_NONE")
    end

    if not self.panel.TransferPanel.gameObject.activeSelf then
        self.panel.TransferPanel.gameObject:SetActiveEx(true)
        MLuaClientHelper.PlayFxHelper(self.panel.transferholo1.gameObject)
        MLuaClientHelper.PlayFxHelper(self.panel.transferholo2.gameObject)
    end

    self.panel.MaterialChoosePanel.gameObject:SetActiveEx(false)
end

function RefineTransferHandler:CustomRefresh(flag)
    self:RefreshTransferPanel()
end

function RefineTransferHandler:RefreshHoles()
    -- hole1
    local l_old_equip = l_mgr.GetEquipByUid(l_mgr.SelectOldEquip)
    if l_old_equip then
        self.oriEquipItem:SetData({ PropInfo = l_old_equip, IsShowCount = false, IsShowTips = true })
        self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(true)
        self.panel.LeftSelectEquipButton.gameObject:SetActiveEx(false)
    else
        self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(false)
        self.panel.LeftSelectEquipButton.gameObject:SetActiveEx(true)
        self.oriEquipItem:SetGameObjectActive(false)
    end

    -- hole2
    local l_new_equip = l_mgr.GetEquipByUid(l_mgr.SelectNewEquip)
    if l_new_equip then
        self.newEquipItem:SetData({ PropInfo = l_new_equip, IsShowCount = false, IsShowTips = true })
        self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(true)
        self.panel.RightSelectEquipButton.gameObject:SetActiveEx(false)
    else
        self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(false)
        self.panel.RightSelectEquipButton.gameObject:SetActiveEx(true)
        self.newEquipItem:SetGameObjectActive(false)
    end
end

function RefineTransferHandler:RefreshTransferDetail()
    local l_old_equip = l_mgr.GetEquipByUid(l_mgr.SelectOldEquip)
    local l_new_equip = l_mgr.GetEquipByUid(l_mgr.SelectNewEquip)
    if not l_old_equip or not l_new_equip then
        logError("RefreshTransferDetail UnExpected error")
        return
    end

    local l_refine_level = l_mgr.SafeGetEquipRefineLevel(l_old_equip)
    local l_row = TableUtil.GetRefineTransfer().GetRowByRefineLv(l_refine_level)
    if not l_row then
        logError("RefreshTransferDetail cannot find config", l_refine_level)
        return
    end

    self.panel.MaxPropertyCount.LabText = StringEx.Format("+{0}", l_refine_level)
    local l_equip_type = self:SafeGetEquipType(l_old_equip)
    if not l_equip_type then
        logError("RefreshTransferDetail cannot get euqip type")
        return
    end

    local l_costs
    if l_equip_type == Data.BagModel.PropType.Weapon then
        l_costs = self:TransferRowCostToTable(l_row.WeaponConsume)
    else
        l_costs = self:TransferRowCostToTable(l_row.OtherConsume)
    end

    local l_seal_level, _, l_perfect_cost = l_mgr.GetSealLevel(l_mgr.SelectOldEquip, l_mgr.SelectNewEquip)
    if l_seal_level > 0 and l_perfect_cost then
        self.perfectTogSelected = self.panel.Toggle2.TogEx.isOn

        if self.perfectTogSelected then
            local l_item_id, l_count = next(l_perfect_cost)
            if l_item_id and l_count then
                table.insert(l_costs, {
                    item = l_item_id,
                    count = l_count
                })
            end
            local l_item = TableUtil.GetItemTable().GetRowByItemID(l_item_id)
            self.panel.Info.LabText = Lang("REFINE_TRANSFER_PERFECT", l_item.ItemName)
        else
            self.panel.Info.LabText = Lang("REFINE_TRANSFER_NO_PERFECT")
        end
        self.panel.TogGrp.gameObject:SetActiveEx(true)
    else
        self.perfectTogSelected = true
        self.panel.Info.LabText = Lang("REFINE_TRANSFER_NO_CHANGE")
        self.panel.TogGrp.gameObject:SetActiveEx(false)
    end

    for i, v in ipairs(l_costs) do
        if not self.trasferCostItems[i] then
            self.trasferCostItems[i] = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.RefineTransferItemParent.transform })
            self.trasferCostItems[i]:transform():SetAsLastSibling()
        end
        local l_cur_count = Data.BagModel:GetBagItemCountByTid(v.item)
        local l_item_info = Data.BagModel:CreateItemWithTid(v.item)
        l_item_info.ItemCount = l_cur_count
        self.trasferCostItems[i]:SetData({ PropInfo = l_item_info,
                                           IsShowCount = false,
                                           IsShowRequire = true,
                                           RequireCount = v.count,
                                           IsShowTips = true })
    end

    for i = #l_costs + 1, #self.trasferCostItems do
        self.trasferCostItems[i]:SetGameObjectActive(false)
    end

    self.panel.TransferDetail.gameObject:SetActiveEx(true)
    self.panel.Img_Bg02.gameObject:SetActiveEx(true)
end

function RefineTransferHandler:OnEquipItemButton(item)
    if item then
        l_mgr.SelectOldEquip = item.UID
    else
        l_mgr.SelectOldEquip = nil
    end

    self:CustomRefresh()
end

function RefineTransferHandler:RequestRefineTransferEquip()
    if not l_mgr.SelectOldEquip or not l_mgr.SelectNewEquip then
        logError("RequestRefineTransferEquip UnExpected error")
        return
    end

    if not self.trasferCostItems then
        logError("RequestRefineTransferEquip UnExpected error")
        return
    end

    for i, v in ipairs(self.trasferCostItems) do
        if v:IsActive() then
            local l_requireCount = v.costPart and v.costPart.requireCount or 0
            local l_cur_count = Data.BagModel:GetCoinOrPropNumById(v.propInfo.TID)
            if l_cur_count < l_requireCount then
                local itemData = Data.BagModel:CreateItemWithTid(v.propInfo.TID)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, v:transform())
                return
            end
        end
    end

    local function _request()
        l_mgr.RequestRefineTransferEquip(self.perfectTogSelected)
        local l_npc_entity = MNpcMgr:FindNpcInViewport(MgrMgr:GetMgr("NpcMgr").CurrentNpcId)
        if l_npc_entity then
            MgrMgr:GetMgr("TransmissionMgr").ShowEffectWithPlayerEntity(l_npc_entity, 120016)
        end

        self.lastOpTime = Time.realtimeSinceStartup
    end

    if not self.perfectTogSelected then

        local l_seal_level, l_error = l_mgr.GetSealLevel(l_mgr.SelectOldEquip, l_mgr.SelectNewEquip)
        if l_error > 0 then
            logError("GetSealLevel fail", l_error)
        end

        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("REFINE_TRANSFER_REDUCE_DESC", l_seal_level), function()
            _request()
        end, nil, -1, 0, nil, function(ctrl)
            ctrl:SetAlignmentHorizontal(UnityEngine.TextAnchor.MiddleLeft)
        end)
    else
        _request()
    end

end

function RefineTransferHandler:OnTransferSuccess()
    l_mgr.SelectOldEquip = nil
    l_mgr.SelectNewEquip = nil
    self:_setSelectEquipData(false)
    self:CustomRefresh()
end

function RefineTransferHandler:OpenNewEquipPanel()
    ---@type ItemData[]
    local l_datas = {}
    local l_selectEquipTemplate = self:GetSelectEquipTemplate()
    if l_selectEquipTemplate then
        l_datas = l_selectEquipTemplate:GetCurrentShowEquips()
    end

    ---@type RefineTransTargetData[]
    local l_result = {}
    for i, v in ipairs(l_datas) do
        local oldEquip = l_mgr.GetEquipByUid(l_mgr.SelectOldEquip)
        local currentTID = 0
        if nil ~= oldEquip then
            currentTID = oldEquip.TID
        end

        if l_mgr.NewEquipCanBeTransfer(v, oldEquip) then
            ---@type RefineTransTargetData
            local targetDataWrap = {
                targetItem = v,
                currentSelectTid = currentTID
            }

            table.insert(l_result, targetDataWrap)
        end
    end

    if #l_result <= 0 then
        self.panel.NoneEquipText.gameObject:SetActiveEx(true)
    else
        self.panel.NoneEquipText.gameObject:SetActiveEx(false)
    end

    self.newEquipItemsPool:ShowTemplates({ Datas = l_result, Method = function(data)
        l_mgr.SelectNewEquip = data.UID
        self.panel.MaterialChoosePanel.gameObject:SetActiveEx(false)
        self:_setSelectEquipData()
        self:CustomRefresh()
    end })

    self.panel.MaterialChoosePanel.gameObject:SetActiveEx(true)
end

---@param itemData ItemData
function RefineTransferHandler:SafeGetEquipType(itemData)
    if not itemData then
        return false
    end

    local l_row = itemData.EquipConfig
    if not l_row then
        return false
    end

    return l_row.EquipId
end

function RefineTransferHandler:TransferRowCostToTable(cost)
    local l_result = {}
    for i = 0, cost.Length - 1 do
        if type(cost[i]) ~= "number" then
            local item = cost[i][0]
            local count = cost[i][1]
            if item and count and count > 0 then
                table.insert(l_result, {
                    item = item,
                    count = count,
                })
            end
        end
    end

    return l_result
end

function RefineTransferHandler:GetSelectEquipTemplate()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipAssistantBG)
    if l_equipBG then
        return l_equipBG:GetSelectEquipTemplate()
    end
end

--lua custom scripts end
return RefineTransferHandler
