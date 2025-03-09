--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PropIconPanel"

require "UI/Template/ItemTemplate"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
PropIconCtrl = class("PropIconCtrl", super)
--lua class define end

--lua functions
function PropIconCtrl:ctor()

    super.ctor(self, CtrlNames.PropIcon, UILayer.Tips, nil, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.taskTarget = nil
end --func end
--next--
function PropIconCtrl:Init()
    self.panel = UI.PropIconPanel.Bind(self)
    super.Init(self)

    self.mgr = MgrProxy:GetQuickUseMgr()
    self.item = self:NewTemplate("ItemTemplate")
end --func end
--next--
function PropIconCtrl:Uninit()

    self.item = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function PropIconCtrl:OnActive()
    if self.uiPanelData == nil then
        return
    end

    if self.uiPanelData.ShowQuickUseType == self.mgr.EShowQuickUseType.ShowQuickUse then
        self:ShowQuickUse(self.uiPanelData.MethodData)
    elseif self.uiPanelData.ShowQuickUseType == self.mgr.EShowQuickUseType.SetPropInfo then
        self:SetPropInfo(self.uiPanelData.MethodData)
    elseif self.uiPanelData.ShowQuickUseType == self.mgr.EShowQuickUseType.SetFunction then
        self:SetFunctionId(self.uiPanelData.MethodData)
        self:ShowPhotoGuide()
    elseif self.uiPanelData.ShowQuickUseType == self.mgr.EShowQuickUseType.SetFakeItem then
        self:SetFakeItemData(self.uiPanelData.MethodData)
    end

end --func end
--next--
function PropIconCtrl:OnDeActive()

    self.closeCondition = nil
    self.callBack = nil
    self.taskTarget = nil

end --func end
--next--
function PropIconCtrl:Update()
    if self.closeCondition then
        if not self.closeCondition() then
            UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
        end
    end
end --func end

--next--
function PropIconCtrl:BindEvents()
    --新手指引
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").PROP_ICON_GUIDE_EVENT, function(self, guideStepInfo)
        self:ShowBeginnerGuide(guideStepInfo)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--- GuildMgr引用，用于判断道具ID，发送捐赠道具请求
local l_guildMgr = MgrMgr:GetMgr("GuildMgr")
--local l_crystalItemID = MGlobalConfig:GetInt("CrystalItemID")  --公会之心ID获取
--local l_unitySculptureID = MGlobalConfig:GetInt("UnitySculptureID")  --纪念纹章ID获取
--local l_certificateItemID = MGlobalConfig:GetInt("CertificateItemID")  --时空之证ID获取

function PropIconCtrl:ShowQuickUse(propInfo)
    if propInfo == nil then
        return
    end
    self.closeCondition = nil
    self.callBack = nil
    self.isTask = false

    if not IsStartShow then
        self:AddButton()
    end
    self.IsStartShow = true
    --local propInfo = self.mgr.QuickUseItems[#self.mgr.QuickUseItems]
    self:SetData(propInfo)
end

---@param itemData ItemData
function PropIconCtrl:SetData(itemData)
    self.taskTarget = nil
    self.propInfo = itemData

    local l_itemTableInfo = itemData.ItemConfig
    if l_itemTableInfo == nil then
        return
    end

    self.count = itemData.ItemCount
    self.item:SetGameObjectActive(true)
    self.panel.SystemOpen.UObj:SetActiveEx(false)

    local l_itemName = l_itemTableInfo.ItemName
    if 1 >= itemData.ItemCount and 0 < itemData.ItemCount then
        self.panel.ItemOnePanel.gameObject:SetActiveEx(true)
        self.panel.ItemMorePanel.gameObject:SetActiveEx(false)
        self.TextBtnUse = self.panel.TextBtnUse
        self.panel.ItemName.gameObject:SetActiveEx(true)
        self.panel.ItemName.LabText = l_itemName
        self.item:SetData({ PropInfo = self.propInfo, IsShowCount = false, IsShowName = false, NameColor = Color.New(1, 1, 1, 1), ItemParent = self.panel.ItemParent.transform })
    else
        self.panel.ItemOnePanel.gameObject:SetActiveEx(false)
        self.panel.ItemMorePanel.gameObject:SetActiveEx(true)
        self.TextBtnUse = self.panel.TextBtnUseMore
        self.panel.CountInput.InputNumber.MaxValue = itemData.ItemCount
        self.panel.CountInput.InputNumber.MinValue = 1
        self.panel.CountInput.InputNumber:SetValue(itemData.ItemCount)

        self.panel.ItemNameMore.LabText = l_itemName
        self.item:SetData({ PropInfo = self.propInfo, IsShowName = false, NameColor = Color.New(1, 1, 1, 1), ItemParent = self.panel.ItemParentMore.transform })
    end

    if l_guildMgr.IsGuildItem(itemData.TID) then
        self.TextBtnUse.LabText = Common.Utils.Lang("GIVE")
    else
        if itemData.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
            self.TextBtnUse.LabText = Common.Utils.Lang("EQUIP_WEAR")
        else
            self.TextBtnUse.LabText = Common.Utils.Lang("Use")
        end
    end
end

function PropIconCtrl:CloseQuickUse()
    if not self.isTask then
        UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
    end
end

function PropIconCtrl:AddButton()
    self.panel.BtnUse:AddClick(function()
        self:UseCheck()
    end)
    self.panel.BtnClose:AddClick(function()
        self:OnCloseButton()
    end)
    self.panel.BtnUseMore:AddClick(function()
        self:UseCheck()
    end)
    self.panel.BtnCloseMore:AddClick(function()
        self:OnCloseButton()
    end)
    self.panel.CountInput.InputNumber.OnValueChange = (function(value)
        self.count = MLuaCommonHelper.Long2Int(value)
    end
    )
end

function PropIconCtrl:UseCheck()
    if self.propInfo.ItemFunctionConfig ~= nil and self.propInfo.ItemFunctionConfig.Payment == 1 and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Refund_Instructions_Payment_Items"), function()
            self:UseItem()
        end)
    else
        self:UseItem()
    end
end

function PropIconCtrl:UseItem()
    if l_guildMgr.IsGuildItem(self.propInfo.TID) then
        l_guildMgr.ContributeGuildItem(self.propInfo.UID, self.propInfo.TID, self.count)
    else
        if self.propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
            local equipPosition = MgrProxy:GetQuickUseMgr().GetSuitEquipPosition(self.propInfo)
            Data.BagApi:ReqSwapItem(self.propInfo.UID, GameEnum.EBagContainerType.Equip, equipPosition, 1)
        else
            MgrMgr:GetMgr("PropMgr").SetGiftIsAllUse(false)
            MgrMgr:GetMgr("PropMgr").RequestUseItem(self.propInfo.UID, self.count, self.propInfo.TID)
        end
    end

    self:OnCloseButton()
end

function PropIconCtrl:OnCloseButton()
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    self.mgr:Pop()
    local quickUseCount = #self.mgr.QuickUseItems
    if quickUseCount > 0 then
        self:ShowQuickUse(self.mgr.QuickUseItems[quickUseCount])
    else
        UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
    end
end

--任务相关的
function PropIconCtrl:SetPropInfo(info)
    self.isTask = true
    self.propInfo = Data.BagModel:CreateItemWithTid(info.itemId)
    self.itemId = info.itemId
    self.itemNum = info.itemNum
    self.callBack = info.callBack
    self.btnName = info.btnName
    self.closeCondition = info.closeCondition
    self.taskTarget = info.taskTarget
    self:RefreshItemInfo()
end

function PropIconCtrl:SetFakeItemData(info)
    self.isTask = true
    self.itemNum = info.itemNum
    self.callBack = info.callBack
    self.btnName = info.btnName
    self.closeCondition = info.closeCondition
    self.taskTarget = info.taskTarget
    self:RefreshFakeItemInfo(info)
end

function PropIconCtrl:GetTaskTarget(...)
    if not self.isTask then
        return nil
    end
    return self.taskTarget
end

function PropIconCtrl:RefreshFakeItemInfo(info)
    self.panel.TextBtnUse.LabText = self.btnName
    if self.callBack then
        self.panel.BtnUse:AddClick(function()
            self:OnClickFakeItem(info.itemId, self.callBack)
        end)
    end
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
    end)

    self.panel.ItemOnePanel.gameObject:SetActiveEx(true)
    self.panel.ItemMorePanel.gameObject:SetActiveEx(false)
    self.item:SetGameObjectActive(true)
    self.panel.SystemOpen.UObj:SetActiveEx(false)
    self.panel.ItemName:SetActiveEx(true)
    self.panel.ItemName.LabText = info.itemName
    self.item:ShowTaskItem({ ItemAtlas = info.ItemAtlas, ItemIcon = info.ItemIcon, ItemParent = self.panel.ItemParent.transform })
end


--判断任务道具会不会产生状态互斥 比如使用道具会播放担任动作
function PropIconCtrl:OnClickFakeItem(itemId, callBack)
    
    if itemId then
        --判断是否存在对应任务道具使用数据
        local l_row = TableUtil.GetTaskItemUseTable().GetRowByUseItem(itemId)
        if not l_row then
            return
        end

        if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_F_SingleAction) then
            return
        end

        MTransferMgr:Interrupt()
        --存在动作则播放  
        --cmd 20200606增加判断 不知道下面这个协议具体干啥的 
        --任务假道具使用本身有调用动作的逻辑 这一步估计是特判还没注释 不敢去掉暂作保留
        if l_row.ItemAction ~= 0 then
            MgrMgr:GetMgr("SyncTakePhotoStatusMgr").BroadacstAction(l_row.ItemAction)
        end

        callBack()
    end

end

function PropIconCtrl:RefreshItemInfo()
    self.panel.TextBtnUse.LabText = self.btnName
    if self.callBack then
        self.panel.BtnUse:AddClick(function()
            self:OnClickItem(self.itemId, self.callBack)
        end)
    end
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
    end)

    self.panel.ItemOnePanel.gameObject:SetActiveEx(true)
    self.panel.ItemMorePanel.gameObject:SetActiveEx(false)
    self.item:SetGameObjectActive(true)
    self.panel.SystemOpen.UObj:SetActiveEx(false)

    self.item:SetData({ PropInfo = self.propInfo, IsShowName = false, NameColor = Color.New(1, 1, 1, 1), ItemParent = self.panel.ItemParent.transform, IsShowCount = false })

    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(self.propInfo.TID)
    if l_itemTableInfo == nil then
        return
    end
    self.panel.ItemName.gameObject:SetActiveEx(true)
    self.panel.ItemName.LabText = l_itemTableInfo.ItemName
end

--判断任务道具会不会产生状态互斥 比如使用道具会播放担任动作
function PropIconCtrl:OnClickItem(itemId, callBack)
    local state, rowData = self:CheckIsActionItem(itemId)

    if not state then
        return
    end

    if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_F_SingleAction) then
        return
    end

    MTransferMgr:Interrupt()
    MgrMgr:GetMgr("SyncTakePhotoStatusMgr").BroadacstAction(rowData.ItemAction)

    callBack()
end

--返回一个道具会不会播放动作
function PropIconCtrl:CheckIsActionItem(itemId)
    if itemId ~= nil then
        local l_row = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
        if l_row then
            if l_row.ItemAction == 0 then
                return false, nil
            else
                return true, l_row
            end
        else
            return false, nil
        end
    end
    return false, nil
end

function PropIconCtrl:SetFunctionId(functionInfo)
    local l_systemInfo = TableUtil.GetOpenSystemTable().GetRowById(functionInfo.functionId)
    if l_systemInfo == nil then
        logError("system " .. functionInfo.functionId .. " not exists in OpenSystemTable!")
        return
    end
    self.isTask = true
    self.taskTarget = functionInfo.taskTarget
    self.closeCondition = functionInfo.closeCondition
    self.panel.TextBtnUse.LabText = l_systemInfo.Title
    self.panel.SystemOpen.UObj:SetActiveEx(true)
    self.panel.ItemOnePanel.gameObject:SetActiveEx(true)
    self.panel.ItemMorePanel.gameObject:SetActiveEx(false)
    self.panel.ItemName.gameObject:SetActiveEx(false)
    self.panel.SystemIcon:SetSpriteAsync(l_systemInfo.SystemAtlas, l_systemInfo.SystemIcon)
    self.item:SetGameObjectActive(false)
    self.panel.BtnUse:AddClick(function()
        local l_systemFunction = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(functionInfo.functionId)
        if l_systemFunction ~= nil then
            l_systemFunction(functionInfo.param)
            UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
        end
    end)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
    end)
end

--展示拍照指引
function PropIconCtrl:ShowPhotoGuide()
    local l_beginnerGuideChecks = { "UseCamera" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
end

--快捷物品使用界面的使用按钮的新手指引
function PropIconCtrl:ShowBeginnerGuide(guideStepInfo)
    local l_aimBtn
    if (not self.propInfo) or (1 >= self.propInfo.ItemCount and 0 < self.propInfo.ItemCount) then
        l_aimBtn = self.panel.BtnUse
    else
        l_aimBtn = self.panel.BtnUseMore
    end

    MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimBtn.transform.position,
            l_aimBtn.transform, guideStepInfo)

    l_aimBtn:AddClick(function()
        MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
    end, false)
end
--lua custom scripts end
