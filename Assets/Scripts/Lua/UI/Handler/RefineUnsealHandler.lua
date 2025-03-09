--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/RefineUnsealPanel"
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
RefineUnsealHandler = class("RefineUnsealHandler", super)
local l_mgr = MgrMgr:GetMgr("RefineTransferMgr")
--lua class define end

--lua functions
function RefineUnsealHandler:ctor()
    super.ctor(self, HandlerNames.RefineUnseal, 0)
end --func end
--next--
function RefineUnsealHandler:Init()
    self.panel = UI.RefineUnsealPanel.Bind(self)
    super.Init(self)
    self.panel.ShowExplainPanelButton:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Lang("REFINE_TRANSFER_SEAL_DESC"),
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 366,
                y = 29,
            },
            width = 400,
        })
    end)

    self.panel.NoneInfoButton:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Lang("REFINE_UNSEAL_DESC"),
            alignment = UnityEngine.TextAnchor.LowerRight,
            pos = {
                x = 383,
                y = 242,
            },
            width = 340,
        })
    end)

    self.unsealPanelInit = nil
    self.current_exp = nil
    self.total_exp = nil
    self.unsealCostItems = {}
    self.item_add_exp = 0
    self.fxs = {}
    self.isHasEquips = false
end --func end
--next--
function RefineUnsealHandler:Uninit()
    self.unsealPanelInit = nil
    self.unsealEquipItem = nil
    self.current_exp = nil
    self.total_exp = nil
    if self.unsealCostItems then
        self.unsealCostItems = nil
    end

    self.newEquipItemsPool = nil
    self:CloseTimer()
    self.item_add_exp = nil
    if self.fxs then
        for k, v in pairs(self.fxs) do
            self:DestroyUIEffect(v)
        end
        self.fxs = nil
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RefineUnsealHandler:OnActive()
    self:CustomRefresh()
end --func end
--next--
function RefineUnsealHandler:OnDeActive()
    -- do nothing
end --func end
--next--
function RefineUnsealHandler:Update()
    -- do nothing
end --func end

--next--
function RefineUnsealHandler:OnShow()
    -- do nothing
end --func end
--next--
function RefineUnsealHandler:OnHide()
    l_mgr.SelectBlockEquip = nil
    self:CustomRefresh()
end --func end
--next--
function RefineUnsealHandler:BindEvents()
    --点击装备显示装备信息
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, function(self, item)
        if self:IsShowing() then
            self:OnEquipItemButton(item)
            self.isHasEquips = true
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isHasEquips)
        self.isHasEquips = isHasEquips
        self:_showNonSelectPanel()
    end)

    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_UNSEAL_SUCCESS_EVENT, self.OnUnsealSuccess)

end --func end
--next--
--lua functions end

--lua custom scripts
function RefineUnsealHandler:_setSelectEquipData(flag)
    if flag == nil then
        flag = true
    end

    local l_template = self:GetSelectEquipTemplate()
    if l_template then
        l_template:SetData({
            SelectEquipMgrName = "RefineUnsealMgr",
            IsDefaultNotSelectedEquip = true,
            IsSelectSameEquip = flag,
            NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
        })
    end
end

function RefineUnsealHandler:SetSelectEquipDataOnHandlerSwitch()
    local l_template = self:GetSelectEquipTemplate()
    if l_template then
        l_template:SetData({
            SelectEquipMgrName = "RefineUnsealMgr",
            IsDefaultNotSelectedEquip = true,
            NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
        })
    end
end

function RefineUnsealHandler:CustomRefresh(flag)
    self:CloseTimer()
    self:RefreshUnsealPanel(flag)
end

function RefineUnsealHandler:OnEquipItemButton(item)
    if item then
        l_mgr.SelectBlockEquip = item.UID
    else
        l_mgr.SelectBlockEquip = nil
    end

    self:CustomRefresh()
end

function RefineUnsealHandler:GetTotalUnblockNeedExo(refine_level, seal_level)
    local l_total_exp = 0
    for i = refine_level - seal_level, refine_level - 1 do
        local l_row = TableUtil.GetRefineTransfer().GetRowByRefineLv(i)
        if not l_row then
            return 0, 1
        end
        l_total_exp = l_total_exp + l_row.Experience
    end

    return l_total_exp
end

function RefineUnsealHandler:InitUnsealPanel()
    self.unsealEquipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.UnsealEquipItemParent.Transform })
    self.panel.RepairEquipButton:AddClick(function()
        self:RequestUnseal()
    end)

    self.panel.SealRemoveEquipButton:AddClick(function()
        if l_mgr.SelectBlockEquip ~= nil then
            l_mgr.SelectBlockEquip = nil
            MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid()
            local l_selectEquipTemplate = self:GetSelectEquipTemplate()
            if l_selectEquipTemplate then
                l_datas = l_selectEquipTemplate:CancelSelectTemplate()
            end
        end

        self:_setSelectEquipData()
        self:CustomRefresh()
    end)
end

function RefineUnsealHandler:RefreshUnsealPanel(flag)
    if not self.unsealPanelInit then
        self:InitUnsealPanel()
        self.unsealPanelInit = true
    end

    self:RefreshBlockHoles()
    if l_mgr.SelectBlockEquip then
        self:RefreshUnsealDetail(flag)
        self.panel.UnsealDetail.gameObject:SetActiveEx(true)
        self.panel.Info.LabText = Lang("REFINE_CANT_TRANSFER_UNSEAL")
        self.panel.Info.gameObject:SetActiveEx(true)
    else
        self.panel.UnsealDetail.gameObject:SetActiveEx(false)
        self.panel.RefineName.LabText = ""
        self.panel.Info.gameObject:SetActiveEx(false)
    end
end

function RefineUnsealHandler:RefreshBlockHoles()
    local l_block_euqip = l_mgr.GetEquipByUid(l_mgr.SelectBlockEquip)
    if l_block_euqip then
        self.unsealEquipItem:SetData({ PropInfo = l_block_euqip, IsShowCount = false, IsShowTips = true })
        self.panel.SealRemoveEquipButton.gameObject:SetActiveEx(true)
        self.panel.UnsealSelectEquipButton.gameObject:SetActiveEx(false)
    else
        self.panel.SealRemoveEquipButton.gameObject:SetActiveEx(false)
        self.panel.UnsealSelectEquipButton.gameObject:SetActiveEx(true)
        self.unsealEquipItem:SetGameObjectActive(false)
        self.panel.NoneText.LabText = Lang("REFINE_UNSEAL_NONE")
    end

    self:_showNonSelectPanel()
end

function RefineUnsealHandler:_showNonSelectPanel()
    local l_needShow
    if l_mgr.SelectBlockEquip then
        l_needShow = false
    else
        l_needShow = true
    end
    if not self.isHasEquips then
        l_needShow = false
    end
    self.panel.NonSelectPanel.gameObject:SetActiveEx(l_needShow)
end

function RefineUnsealHandler:RefreshUnsealDetail(flag)
    ---@type ItemData
    local l_equip = l_mgr.GetEquipByUid(l_mgr.SelectBlockEquip)
    if not l_equip then
        logError("RefreshTransferDetail fail, UnExpected error")
        return
    end

    local l_can_unseal, l_error = l_mgr.CheckCanUnseal(l_equip)
    if not l_can_unseal then
        logError("RefreshUnsealDetail fail", l_error)
        return
    end

    local l_refine_level = l_mgr.SafeGetEquipRefineLevel(l_equip)
    local l_seal_level, l_cur_exp = l_mgr.SafeGetEquipSealInfo(l_equip)

    local l_row = TableUtil.GetRefineTransfer().GetRowByRefineLv(1)
    if not l_row then
        logError("RefreshUnsealDetail fail, cannot find config", l_refine_level)
        return
    end

    local l_item_row = l_equip.ItemConfig
    if not l_item_row then
        logError("RefreshUnsealDetail fail, cannot find item", l_equip.TID)
        return
    end

    self.panel.RefineName.LabText = string.format("%s+%d", l_item_row.ItemName, l_refine_level)
    local l_old_exp = self.current_exp or 0
    self.current_exp = l_cur_exp
    self.total_exp = self:GetTotalUnblockNeedExo(l_refine_level, l_seal_level)
    self:UpdateUnsealProcess(l_old_exp, self.current_exp, flag)
    local l_costs, l_add_exp = self:GetUnsealCost(l_row.SealConsume)
    self.item_add_exp = l_add_exp
    for i, v in ipairs(l_costs) do
        if not self.unsealCostItems[i] then
            self.unsealCostItems[i] = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.UnsealItemParent.transform })
            self.unsealCostItems[i]:transform():SetAsLastSibling()
            MLuaCommonHelper.SetLocalPos(self.unsealCostItems[i]:gameObject(), -150, 41, 0)
        end

        local l_cur_count = Data.BagModel:GetBagItemCountByTid(v.item)
        local l_item_info = Data.BagModel:CreateItemWithTid(v.item)
        l_item_info.ItemCount = l_cur_count

        ---@type ItemTemplateParam
        local itemTemplateParam = {
            PropInfo = l_item_info,
            IsShowCount = false,
            IsShowRequire = true,
            IsShowTips = true,
            RequireCount = v.count,
        }

        self.unsealCostItems[i]:SetData(itemTemplateParam)
        break
    end
end

function RefineUnsealHandler:GetUnsealCost(cost)
    local l_result = {}
    local l_exp
    for i = 0, cost.Length - 1 do
        local l_cost = cost[i]
        table.insert(l_result, {
            item = l_cost[0],
            count = l_cost[1],
        })

        if not l_exp then
            l_exp = l_cost[2]
        end
    end
    return l_result, l_exp
end

function RefineUnsealHandler:RequestUnseal()
    if not l_mgr.SelectBlockEquip then
        logError("RequestUnseal fail, UnExpected error")
        return
    end

    local l_row = TableUtil.GetRefineTransfer().GetRowByRefineLv(1)
    if not l_row then
        logError("RequestUnseal fail, cannot find config")
        return
    end

    local l_costs, l_add_exp = self:GetUnsealCost(l_row.SealConsume)
    local l_cur_count

    for i, v in ipairs(l_costs) do
        l_cur_count = tonumber(Data.BagModel:GetCoinOrPropNumById(v.item))
        if l_cur_count < v.count then
            log("RequestUnseal fail, need more item", v.item, l_cur_count, v.count)
            local itemData = Data.BagModel:CreateItemWithTid(v.item)
            itemData.ItemCount = ToInt64(1)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData)
            return
        end
        break
    end

    local l_remain_exp = self.total_exp - self.current_exp
    if l_remain_exp <= 0 then
        logError("RequestUnseal fail, need exp lessthan 0", self.current_exp, self.total_exp)
        return
    end

    local l_count = math.ceil(l_remain_exp / l_add_exp)
    if l_count > l_cur_count then
        l_count = l_cur_count
    end

    local l_exp = l_add_exp * l_count
    l_mgr.RequestUnlockEquip(l_mgr.SelectBlockEquip, l_count, Lang("REFINE_TRANSFER_EXP_FORMAT", l_exp))
end

function RefineUnsealHandler:CloseTimer()
    if self.delay_timer then
        self:StopUITimer(self.delay_timer)
        self.delay_timer = nil
    end

    if self.co_process then
        coroutine.stop(self.co_process)
        self.co_process = nil
    end
end

function RefineUnsealHandler:OnUnsealSuccess(flag)
    self:CloseTimer()
    if flag then
        self:UpdateUnsealProcess(self.current_exp, self.total_exp, true, function()
            local l_key = "unblock"
            self:CreateFx(l_key, "Effects/Prefabs/Creature/Ui/Fx_Ui_ZhuangBeiJieFeng_PoBing_01", self.panel.RawImageSeal.RawImg)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFINE_UNSEAL_SUCCESS"))

            self.delay_timer = self:NewUITimer(function()
                l_mgr.BroadcastChangeSelectHole(true)
                self:CustomRefresh()
                self:DestroyFxByKey(l_key, self.panel.RawImageSeal.RawImg)
            end, 1.4)

            self.delay_timer:Start()
            self:_setSelectEquipData(flag)
            MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid()
            local l_selectEquipTemplate = self:GetSelectEquipTemplate()
            if l_selectEquipTemplate then
                l_datas = l_selectEquipTemplate:CancelSelectTemplate()
            end
        end)
    else
        self:CustomRefresh(true)
    end
end

function RefineUnsealHandler:GetProgress(exp)

    if self.total_exp <= 0 or exp >= self.total_exp then
        return 1
    else
        return exp / self.total_exp
    end
end

function RefineUnsealHandler:UpdateUnsealProcess(current, target, show_progress, callback)

    if show_progress then
        local l_total_exp = self.total_exp
        self.panel.RepairLevel.LabText = Lang("REFINE_UNSEAL_EXP_FORMAT", current, self.total_exp)
        self.panel.Slider.Slider.value = self:GetProgress(current)
        local l_start_time = Time.time
        self.co_process = coroutine.start(function()
            repeat
                coroutine.step(1)
                local l_offset = (Time.time - l_start_time) * 120
                local l_target = current + l_offset
                if l_target > target then
                    l_target = target
                end
                self.panel.RepairLevel.LabText = Lang("REFINE_UNSEAL_EXP_FORMAT", l_target, l_total_exp)
                self.panel.Slider.Slider.value = self:GetProgress(l_target)
                if l_target >= target then
                    break
                end
            until false

            if callback then
                callback()
            end
        end)
    else
        self.panel.RepairLevel.LabText = Lang("REFINE_UNSEAL_EXP_FORMAT", target, self.total_exp)
        self.panel.Slider.Slider.value = self:GetProgress(target)
        if callback then
            callback()
        end
    end
end

function RefineUnsealHandler:CreateFx(key, path, parent)
    self:DestroyFxByKey(key, parent)
    local l_origin_data = {}
    l_origin_data.rawImage = parent
    l_origin_data.loadedCallback = function()
        parent.gameObject:SetActiveEx(true)
    end

    self.fxs[key] = self:CreateUIEffect(path, l_origin_data)
end

function RefineUnsealHandler:DestroyFxByKey(key, parent)
    if self.fxs[key] then
        self:DestroyUIEffect(self.fxs[key])
    end

    parent.gameObject:SetActiveEx(false)
end

function RefineUnsealHandler:GetSelectEquipTemplate()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipAssistantBG)
    if l_equipBG then
        return l_equipBG:GetSelectEquipTemplate()
    end
end

--lua custom scripts end
return RefineUnsealHandler