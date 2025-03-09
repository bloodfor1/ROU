--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicRecoveMachinePanel"
require "UI/Template/ItemTemplate"
require "UI/Template/MagicRecoveTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("MagicRecoveMachineMgr")
--next--
--lua fields end

--lua class define
MagicRecoveMachineCtrl = class("MagicRecoveMachineCtrl", super)
--lua class define end

--lua functions
function MagicRecoveMachineCtrl:ctor()

    super.ctor(self, CtrlNames.MagicRecoveMachine, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function MagicRecoveMachineCtrl:Init()

    self.panel = UI.MagicRecoveMachinePanel.Bind(self)
    super.Init(self)
    self.selectItemCount = 0          -- 当前选择需要分解的item个数
    self.itemData = {}                -- 分解成功之后可以获得的item数据
    self.recoveItemGO = {}            -- 当前待分解的gameobject
    self.CurrentArrowIndex = 0        -- 当前选择的页签
    self.IsOpenYesNoDlg = false       -- 是否打开了今天不在提示对话框
    self.txtZenyCount = 0
    -- 展示可以分解的item
    self.showItemsTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MagicRecoveTemplate,
        TemplatePrefab = self.panel.ItemShowPrefab.gameObject,
        ScrollRect = self.panel.ScrollViewItem.LoopScroll
    })
    -- 展示分解成功之后可以获得的item
    self.ItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate
    })
    -- 关闭界面
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MagicRecoveMachine)
    end)

    self.panel.TxtArrow.LabText = Common.Utils.Lang("AllText")

    -- 下拉框点击
    self.panel.BtnArrow:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
            ctrl:ShowSelectBox(Mgr.GetCurrentArrowNames(), function(buttonData)
                self.CurrentArrowIndex = buttonData.index
                self.panel.TxtArrow.LabText = buttonData.name
                self:RefreshPanel()
            end)
        end)
    end)
    -- 规则
    self.panel.PanelHelp.gameObject:SetActiveEx(false)
    self.panel.BtnHelp:AddClick(function()
        self.panel.PanelHelp.gameObject:SetActiveEx(true)
    end)
    self.panel.BtnCloseHelp:AddClick(function()
        self.panel.PanelHelp.gameObject:SetActiveEx(false)
    end)
    -- 一键选入|取出
    self.panel.BtnSelect:AddClick(function()
        if self.panel.TxtSelect.LabText == Common.Utils.Lang("MagicRecoveMachineSelect") then
            self:OnSelectItemsOnceClick("select")
            self.panel.TxtSelect.LabText = Common.Utils.Lang("MagicRecoveMachineRemove")
        elseif self.panel.TxtSelect.LabText == Common.Utils.Lang("MagicRecoveMachineRemove") then
            self:OnSelectItemsOnceClick("remove")
            self.panel.TxtSelect.LabText = Common.Utils.Lang("MagicRecoveMachineSelect")
        end
    end)

    local l_RecoveFunc = function()
        -- 分解的Item不足
        if self.selectItemCount < Mgr.GetResolveNumberMin() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MagicRecoveMachineMinLimit"), Mgr.GetResolveNumberMin(), Mgr.GetCurrentRecoveDescription()))
            return
        end
        if Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.HeadWear then
            local l_Data = {}
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid then
                    table.insert(l_Data, { uid = self.recoveItemGO[i].uid, propId = self.recoveItemGO[i].TID, count = 1 })
                end
            end
            if #l_Data == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MagicMachineSelectRecoveItemTips", Mgr.GetCurrentRecoveDescription()))
            else
                local l_str = Common.Utils.Lang("RECOVEHEAD_PROMT", #l_Data)
                self.IsOpenYesNoDlg = true
                CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
                    self.IsOpenYesNoDlg = false
                    Mgr.ReqRecoveItem(l_Data)
                end, nil, nil, 2, "HEAD_RECOVE_TODAY_NO_SHOW")
            end
        elseif Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Card then
            local l_CardCount = 0
            -- 紫色卡片个数
            local l_PurpleCount = 0
            local l_Data = {}
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid then
                    if self.recoveItemGO[i].quality == 3 then
                        l_PurpleCount = l_PurpleCount + 1
                    end
                    l_CardCount = l_CardCount + 1
                    table.insert(l_Data, { uid = self.recoveItemGO[i].uid, propId = self.recoveItemGO[i].TID, count = 1 })
                end

            end
            if #l_Data == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MagicMachineSelectRecoveItemTips", Mgr.GetCurrentRecoveDescription()))
            else
                local l_str = ""
                -- 有紫卡
                if l_PurpleCount > 0 then
                    l_str = Common.Utils.Lang("RECOVE_PROMT_PURPLE", l_CardCount, l_PurpleCount)
                    self.IsOpenYesNoDlg = true
                    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
                        self.IsOpenYesNoDlg = false
                        Mgr.ReqRecoveItem(l_Data)
                    end)
                else
                    --今日不再提示框
                    l_str = Common.Utils.Lang("RECOVE_PROMT", l_CardCount)
                    self.IsOpenYesNoDlg = true
                    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
                        self.IsOpenYesNoDlg = false
                        Mgr.ReqRecoveItem(l_Data)
                    end, nil, nil, 2, "CARD_RECOVE_TODAY_NO_SHOW")
                end
            end
        elseif Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Equip then
            local l_Data = {}
            local hasEnhancedEquip = false
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid then
                    table.insert(l_Data, { uid = self.recoveItemGO[i].uid, propId = self.recoveItemGO[i].TID, count = 1 })
                end

                if self.recoveItemGO[i].enhanced then
                    hasEnhancedEquip = true
                end
            end

            if #l_Data == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips("MagicMachineSelectRecoveItemTips", Mgr.GetCurrentRecoveDescription())
            else
                local l_str = ""
                if not hasEnhancedEquip then
                    l_str = StringEx.Format(Common.Utils.Lang("RECOVE_PROMT_EQUIP"), #l_Data)
                else
                    l_str = Common.Utils.Lang("C_ENHANCED_EQUIP_RESOLVE")
                end

                self.IsOpenYesNoDlg = true
                CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
                    self.IsOpenYesNoDlg = false
                    Mgr.ReqRecoveItem(l_Data)
                end, nil, nil, 2, "EQUIP_RECOVE_TODAY_NO_SHOW")
            end
        end
    end

    --分解
    self.panel.BtnRecove:AddClick(function()
        -- 铜币不足
        local l_expendZeny = self.txtZenyCount
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,l_expendZeny)
        if l_needNum > 0 then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                l_RecoveFunc()
            end)
            return
        end
        l_RecoveFunc()
    end)

end --func end
--next--
function MagicRecoveMachineCtrl:Uninit()
    self.txtZenyCount = 0
    for i = #self.recoveItemGO, 1, -1 do
        MResLoader:DestroyObj(self.recoveItemGO[i].go.gameObject)
    end
    self.showItemsTemplatePool = nil
    self.ItemTemplatePool = nil
    if self.IsOpenYesNoDlg then
        self.IsOpenYesNoDlg = false
        CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.NORMAL)
    end
    super.Uninit(self)
    self.panel = nil
    Mgr.Uninit()

end --func end
--next--
function MagicRecoveMachineCtrl:OnActive()
    self:initGOData()
    self:RefreshPanel()
end --func end
--next--
function MagicRecoveMachineCtrl:OnDeActive()
end --func end
--next--
function MagicRecoveMachineCtrl:Update()


end --func end

--next--
function MagicRecoveMachineCtrl:BindEvents()
    self:BindEvent(Mgr.EventDispatcher, Mgr.OnRecoveItemSuccess, function(self, data)
        self:OnRecoveItemSuccess(data)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
-- 初始化go表现的数据
function MagicRecoveMachineCtrl:initGOData()
    -- 当前的标题
    self.panel.TxtTitle.LabText = Common.Utils.Lang("MagicRecoveMachineTitle", Mgr.GetCurrentRecoveDescription())
    -- 当前左侧没有item时 提示文字
    self.panel.TxtNoItem.LabText = Common.Utils.Lang("NoRecoveShowItemTxt", Mgr.GetCurrentRecoveDescription())
    -- 当前右侧标题 提示文字
    self.panel.TxtRightTitle.LabText = Common.Utils.Lang("BeRecoveItemTxt", Mgr.GetCurrentRecoveDescription())
    -- 当前右侧标题下方 提示文字
    self.panel.TxtHelp.LabText = Common.Utils.Lang("MagicRecoveCountMax", Mgr.GetResolveNumberMax())
    -- 当前右中 提示文字
    self.panel.TxtNoSelectTips.LabText = Common.Utils.Lang("MagicMachineSelectRecoveItemTips", Mgr.GetCurrentRecoveDescription())
    if Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.HeadWear
            or Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Equip then
        self.panel.PanelHeadAndEquip.gameObject:SetActiveEx(true)
        for i = 1, Mgr.GetResolveNumberMax() do
            local l_GO = self:CloneObj(self.panel.ItemHeadAndEquip.gameObject).gameObject:GetComponent("MLuaUICom")
            l_GO.gameObject:SetActiveEx(true)
            l_GO.transform:SetParent(self.panel.PanelHeadAndEquip.transform)
            l_GO.transform:SetLocalScaleOne()
            local l_objData = {}
            l_objData.enhanced = nil
            l_objData.uid = nil
            l_objData.propId = nil
            l_objData.quality = nil
            l_objData.go = l_GO
            l_objData.icon = l_GO.transform:Find("Img_Icon"):GetComponent("MLuaUICom")
            l_objData.icon.gameObject:SetActiveEx(false)
            table.insert(self.recoveItemGO, l_objData)
        end
    elseif Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Card then
        self.panel.PanelCard.gameObject:SetActiveEx(true)
        for i = 1, Mgr.GetResolveNumberMax() do
            local l_GO = self:CloneObj(self.panel.ItemCard.gameObject).gameObject:GetComponent("MLuaUICom")
            l_GO.transform:SetParent(self.panel.PanelCard.transform)
            l_GO.transform:SetLocalScaleOne()
            local l_objData = {}
            l_objData.uid = nil
            l_objData.enhanced = nil
            l_objData.propId = nil
            l_objData.quality = nil
            l_objData.go = l_GO
            l_objData.icon = l_GO.transform:Find("Mask/Img_Card"):GetComponent("MLuaUICom")
            l_objData.iconBg = l_GO.transform:Find("Bg_Card"):GetComponent("MLuaUICom")
            l_objData.go.gameObject:SetActiveEx(false)
            table.insert(self.recoveItemGO, l_objData)
        end
    end
    self.panel.TxtHelpMessage.LabText = Mgr.GetCurrentTxtHelpMessage()
end

-- 数据改变刷新整个panel
function MagicRecoveMachineCtrl:RefreshPanel()
    local l_ShowItemData = Mgr.GetCurrentShowItemsDataByArrow(self.CurrentArrowIndex, true)
    self.panel.ScrollViewItem.gameObject:SetActiveEx(#l_ShowItemData > 0)
    self.panel.Imgtips.gameObject:SetActiveEx(#l_ShowItemData > 0)
    self.panel.PanelNoItem.gameObject:SetActiveEx(#l_ShowItemData == 0)
    self.panel.PanelRight.gameObject:SetActiveEx(#l_ShowItemData > 0)
    self.panel.BtnSelect.gameObject:SetActiveEx(#l_ShowItemData > 0)
    self.showItemsTemplatePool:ShowTemplates({ Datas = l_ShowItemData, Method = function(item)
        if not item.data.select then
            if self.selectItemCount + 1 > Mgr.GetResolveNumberMax() then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Recove_MaxLimit", Mgr.GetResolveNumberMax()))
            else
                self:RefreshSelectItem(item.data, "select")
            end
        else
            self:RefreshSelectItem(item.data, "remove")
        end
        item.Parameter.Checkmark.gameObject:SetActiveEx(item.data.select)
    end })
    self.itemData = {}
    self.selectItemCount = 0
    self.panel.TxtSelect.LabText = Common.Utils.Lang("MagicRecoveMachineSelect")
    self.txtZenyCount = 0
    self.panel.TxtZeny.LabText = 0 -- 花费的zeny币默认为0
    for i = 1, #self.recoveItemGO do
        self.recoveItemGO[i].uid = nil
        self.recoveItemGO[i].propId = nil
        self.recoveItemGO[i].quality = nil
        self.recoveItemGO[i].icon.gameObject:SetActiveEx(false)
    end
    self.panel.PanelSelect.gameObject:SetActiveEx(#self.itemData > 0)
    self.panel.TxtNoSelectTips.gameObject:SetActiveEx(#self.itemData == 0)
    self.ItemTemplatePool:ShowTemplates({ Datas = self.itemData, Parent = self.panel.PanelGet.transform })
end

-- 处理需要分解的item
function MagicRecoveMachineCtrl:RefreshSelectItem(data, clickType)
    data.select = not data.select
    local l_Data = Mgr.GetCurrentTableRowData(data.bagdata.TID)
    if clickType == "select" then
        -- 刷新右边选择的GO
        if Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.HeadWear
                or Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Equip then
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid == nil then
                    self.recoveItemGO[i].enhanced = data.bagdata:EquipEnhanced()
                    self.recoveItemGO[i].uid = data.bagdata.UID
                    self.recoveItemGO[i].propId = data.bagdata.TID
                    self.recoveItemGO[i].quality = data.bagdata.ItemConfig.ItemQuality
                    self.recoveItemGO[i].icon.gameObject:SetActiveEx(true)
                    self.recoveItemGO[i].icon:SetSprite(data.bagdata.ItemConfig.ItemAtlas, data.bagdata.ItemConfig.ItemIcon, true)
                    break
                end
            end
        elseif Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Card then
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid == nil then
                    self.recoveItemGO[i].enhanced = data.bagdata:EquipEnhanced()
                    self.recoveItemGO[i].uid = data.bagdata.UID
                    self.recoveItemGO[i].propId = data.bagdata.TID
                    self.recoveItemGO[i].quality = data.bagdata.ItemConfig.ItemQuality
                    self.recoveItemGO[i].go.gameObject:SetActiveEx(true)
                    self.recoveItemGO[i].icon:SetRawTex(l_Data.CardTexture)
                    self.recoveItemGO[i].icon.gameObject:SetActiveEx(true)
                    local l_bgAtlas, l_bgIcon = Data.BagModel:getCardTextureBgInfo(data.bagdata.TID)
                    self.recoveItemGO[i].iconBg:SetSprite(l_bgAtlas, l_bgIcon)
                    break
                end
            end
        end
        self:CalcSelectRecoveMaterials(data)
    elseif clickType == "remove" then
        if Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.HeadWear
                or Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Equip then
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid == data.bagdata.UID then
                    self.recoveItemGO[i].enhanced = nil
                    self.recoveItemGO[i].uid = nil
                    self.recoveItemGO[i].propId = nil
                    self.recoveItemGO[i].icon.gameObject:SetActiveEx(false)
                    break
                end
            end
        elseif Mgr.CurrentMachineType == Mgr.EMagicRecoveMachineType.Card then
            for i = 1, #self.recoveItemGO do
                if self.recoveItemGO[i].uid == data.bagdata.UID then
                    self.recoveItemGO[i].enhanced = nil
                    self.recoveItemGO[i].uid = nil
                    self.recoveItemGO[i].propId = nil
                    self.recoveItemGO[i].go.gameObject:SetActiveEx(false)
                    break
                end
            end
        end
        self:CalcRemoveRecoveMaterials(data)
    end
    local l_expendZeny = self.txtZenyCount
    if MPlayerInfo.Coin101 >= MLuaCommonHelper.Long(l_expendZeny) then
        self.panel.TxtZeny.LabColor = Color.New(52 / 255, 52 / 255, 52 / 255, 1)
    else
        self.panel.TxtZeny.LabColor = Color.New(255 / 255, 79 / 255, 79 / 255, 1)
    end
    if #self.itemData > 0 then
        if not self.panel.PanelSelect.gameObject.activeSelf then
            self.panel.PanelSelect.gameObject:SetActiveEx(true)
            self.panel.TxtNoSelectTips.gameObject:SetActiveEx(false)
        end
    else
        if self.panel.PanelSelect.gameObject.activeSelf then
            self.panel.PanelSelect.gameObject:SetActiveEx(false)
            self.panel.TxtNoSelectTips.gameObject:SetActiveEx(true)
        end
    end
    self.ItemTemplatePool:ShowTemplates({ Datas = self.itemData, Parent = self.panel.PanelGet.transform })
end

-- 选中item 计算分解材料数据
function MagicRecoveMachineCtrl:CalcSelectRecoveMaterials(data)
    -- 需要测试 两种装备情况 两种卡片情况
    local l_IsHave = false
    for j = 1, #self.itemData do
        if self.itemData[j].ID == data.tabledata.ResolveAmountID then
            l_IsHave = true
            self.itemData[j].Count = self.itemData[j].Count + data.tabledata.ResolveAmountCount
            break
        end
    end
    if not l_IsHave then
        local l_TmpData = {}
        l_TmpData.ID = data.tabledata.ResolveAmountID
        l_TmpData.IsShowCount = true
        l_TmpData.IsShowRequire = false
        l_TmpData.Count = data.tabledata.ResolveAmountCount
        l_TmpData.CountHaveMax = "+?"
        table.insert(self.itemData, l_TmpData)
    end
    local l_ItemData = TableUtil.GetItemTable().GetRowByItemID(data.tabledata.ExpendZenyID)
    if l_ItemData then
        self.panel.ImgSpendIcon:SetSprite(l_ItemData.ItemAtlas, l_ItemData.ItemIcon)
    end
    self.selectItemCount = self.selectItemCount + 1
    self.txtZenyCount = self.txtZenyCount + data.tabledata.ExpendZenyCount
    self:SetZenyTextContent(data.tabledata.ExpendZenyID)
end

-- 去除item 计算分解材料数据
function MagicRecoveMachineCtrl:CalcRemoveRecoveMaterials(data)
    for j = 1, #self.itemData do
        if self.itemData[j].ID == data.tabledata.ResolveAmountID then
            self.itemData[j].Count = self.itemData[j].Count - data.tabledata.ResolveAmountCount
            if self.itemData[j].Count == 0 then
                table.remove(self.itemData, j)
            end
            break
        end
    end
    self.selectItemCount = self.selectItemCount - 1
    self.txtZenyCount = self.txtZenyCount - data.tabledata.ExpendZenyCount
    self:SetZenyTextContent(data.tabledata.ExpendZenyID)
end

function MagicRecoveMachineCtrl:SetZenyTextContent(id)
    
    if MgrMgr:GetMgr("PropMgr").IsCoin(id) then
        self.panel.TxtZeny.LabText = MNumberFormat.GetNumberFormat(self.txtZenyCount)
    else
        self.panel.TxtZeny.LabText = self.txtZenyCount
    end
end

-- 一键选入 一键移除
function MagicRecoveMachineCtrl:OnSelectItemsOnceClick(clickType)
    if clickType == "select" then
        -- 清除所有选择的item
        for i = 1, #self.showItemsTemplatePool.Datas do
            if self.showItemsTemplatePool.Datas[i].select then
                self:RefreshSelectItem(self.showItemsTemplatePool.Datas[i], "remove")
                self.panel.ScrollViewItem.LoopScroll:RefreshCell(i - 1)
            end
        end
        -- 添加最大分解数量
        for i = 1, math.min(#self.showItemsTemplatePool.Datas, Mgr.GetResolveNumberMax()) do
            if not self.showItemsTemplatePool.Datas[i].select then
                self:RefreshSelectItem(self.showItemsTemplatePool.Datas[i], "select")
                self.panel.ScrollViewItem.LoopScroll:RefreshCell(i - 1)
            end
        end
    elseif clickType == "remove" then
        -- 清除所有选择的item
        for i = 1, #self.showItemsTemplatePool.Datas do
            if self.showItemsTemplatePool.Datas[i].select then
                self:RefreshSelectItem(self.showItemsTemplatePool.Datas[i], "remove")
                self.panel.ScrollViewItem.LoopScroll:RefreshCell(i - 1)
            end
        end
    end
end

-- 分解成功
function MagicRecoveMachineCtrl:OnRecoveItemSuccess(data)
    self.panel.Panel.gameObject:SetActiveEx(false)
    local l_RewardDatas = {}
    for k, v in ipairs(data) do
        table.insert(l_RewardDatas, { ID = MLuaCommonHelper.Long2Int(v.key), IsShowCount = true, IsShowRequire = false, IsShowName = true, Count = v.value })
    end
    CommonUI.Dialog.ShowCommonRewardDlg(Common.Utils.Lang("RECVOR_REWARD"), l_RewardDatas, function()
        self.panel.Panel.gameObject:SetActiveEx(true)
        self:RefreshPanel()
    end, function()
        UIMgr:DeActiveUI(UI.CtrlNames.MagicRecoveMachine)
    end)
end

--lua custom scripts end
return MagicRecoveMachineCtrl