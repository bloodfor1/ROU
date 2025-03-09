--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicExtractMachinePanel"
require "UI/Template/MagicExtractTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("MagicExtractMachineMgr")
--next--
--lua fields end

--lua class define
MagicExtractMachineCtrl = class("MagicExtractMachineCtrl", super)
--lua class define end

--lua functions
function MagicExtractMachineCtrl:ctor()

    super.ctor(self, CtrlNames.MagicExtractMachine, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function MagicExtractMachineCtrl:Init()

    self.panel = UI.MagicExtractMachinePanel.Bind(self)
    super.Init(self)
    self.CurrentArrowIndex = 0
    self.ExtractItemCount = 0        -- 抽取次数
    self.ShowItemDatas = {}            -- 抽取数据
    self.NeedRevertMaskFlag = false    --
    self.IsmaterialEnough = false    -- 当前抽取材料是否足够
    self.isReqExtractItem = false       -- 当前是否正在请求抽卡
    self.CurrentAwardItem = {}        -- 当前的获奖item
    -- 展示可以抽取的item
    self.showItemsTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MagicExtractTemplate,
        TemplatePrefab = self.panel.ItemShowPrefab.LuaUIGroup.gameObject,
        ScrollRect = self.panel.ScrollViewItem.LoopScroll
    })
    -- 关闭界面
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MagicExtractMachine)
    end)
    -- 跳过动作
    self.panel.BtnBox:AddClick(function()
        if self.timer ~= nil then
            self:StopUITimer(self.timer)
            self.timer = nil
        end
        self.panel.BtnBox.gameObject:SetActiveEx(false)
        MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, MEntityMgr.PlayerEntity)
        self:ShowSpecialTips(self.CurrentAwardItem)
    end)
    -- 下拉框点击
    self.panel.TxtArrow.LabText = Lang("AllText")
    self.panel.BtnArrow:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
            ctrl:ShowSelectBox(Mgr.GetCurrentArrowNames(), function(buttonData)
                self.CurrentArrowIndex = buttonData.index
                self.panel.TxtArrow.LabText = buttonData.name
                self:RefreshPanel()
            end)
        end)
    end)
    -- 抽卡相关
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        self.panel.TabCard.gameObject:SetActiveEx(true)
        self.panel.TogCardGray.TogEx.isOn = Mgr.CurrentExtractCardType == Mgr.EExtractCardType.ACard
        self.panel.TogCardBlue.TogEx.isOn = Mgr.CurrentExtractCardType == Mgr.EExtractCardType.BCCard
        -- 抽紫卡
        self.panel.TogCardGray:OnToggleExChanged(function(value)
            if value then
                Mgr.CurrentExtractCardType = Mgr.EExtractCardType.ACard
                Mgr.CurrentExtractCardAwardType = Mgr.CardAAwardID
                self:RefreshPanel()
                self:IsMaterialEnough()
            end
        end)
        -- 抽蓝绿卡
        self.panel.TogCardBlue:OnToggleExChanged(function(value)
            if value then
                Mgr.CurrentExtractCardType = Mgr.EExtractCardType.BCCard
                Mgr.CurrentExtractCardAwardType = Mgr.CardBCAwardID
                self:RefreshPanel()
                self:IsMaterialEnough()
            end
        end)
    end
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        -- 抽装备相关
        --【【成长线复盘专项】装备稀有抽取屏蔽】 https://www.tapd.cn/20332331/prong/stories/view/1120332331001057897
        self.panel.TabEquip.gameObject:SetActiveEx(false)
        Mgr.CurrentExtractEquipType = Mgr.EExtractEquipType.BCEquip
        Mgr.CurrentExtractEquipAwardType = Mgr.EquipBCAwardID
        --self.panel.TabEquip.gameObject:SetActiveEx(Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip)
        --self.panel.TogEquipRare.TogEx.isOn = Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.AEquip
        --self.panel.TogEquipNormal.TogEx.isOn = Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.BCEquip
        ---- 抽稀有装备
        --self.panel.TogEquipRare:OnToggleExChanged(function(value)
        --    if value then
        --        Mgr.CurrentExtractEquipType = Mgr.EExtractEquipType.AEquip
        --        Mgr.CurrentExtractEquipAwardType = Mgr.EquipAAwardID
        --        self:RefreshPanel()
        --        self:IsMaterialEnough()
        --    end
        --end)
        ---- 抽正常装备
        --self.panel.TogEquipNormal:OnToggleExChanged(function(value)
        --    if value then
        --        Mgr.CurrentExtractEquipType = Mgr.EExtractEquipType.BCEquip
        --        Mgr.CurrentExtractEquipAwardType = Mgr.EquipBCAwardID
        --        self:RefreshPanel()
        --        self:IsMaterialEnough()
        --    end
        --end)
    end
    -- 规则
    self.panel.PanelHelp.gameObject:SetActiveEx(false)
    self.panel.BtnHelp:AddClick(function()
        self.panel.PanelHelp.gameObject:SetActiveEx(true)
    end)
    self.panel.BtnCloseHelp:AddClick(function()
        self.panel.PanelHelp.gameObject:SetActiveEx(false)
    end)
    -- 抽取
    self.panel.BtnExtract:AddClick(function()
        if self.ExtractItemCount + 1 > Mgr.GetExtractNumberMax() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_EXTRACT_TIME_NOT_ENOUGH"))
            return
        end
        if not self.IsmaterialEnough then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
            local propInfo
            if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
                propInfo = Data.BagModel:CreateItemWithTid(tonumber(Mgr.OrnamentExpendBCAmount[0][0]))
            elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
                if Mgr.CurrentExtractCardType == Mgr.EExtractCardType.ACard then
                    propInfo = Data.BagModel:CreateItemWithTid(tonumber(Mgr.ExpendAAmount[0][0]))
                elseif Mgr.CurrentExtractCardType == Mgr.EExtractCardType.BCCard then
                    propInfo = Data.BagModel:CreateItemWithTid(tonumber(Mgr.ExpendBCAmount[0][0]))
                end
            elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
                if Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.AEquip then
                    propInfo = Data.BagModel:CreateItemWithTid(tonumber(Mgr.EquipExpendAAmount[0][0]))
                elseif Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.BCEquip then
                    propInfo = Data.BagModel:CreateItemWithTid(tonumber(Mgr.EquipExpendBCAmount[0][0]))
                end
            end
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
            return
        end
        if not self.isReqExtractItem then
            self.isReqExtractItem = true
            Mgr.ReqExtractItem()
        end
    end)
    -- 聚焦npc
    self.FocusNpcId = -1
    for i, v in ipairs(Mgr.GetCurrentNPCIdTbl()) do
        local l_npc = MNpcMgr:FindNpcInViewport(v)
        if l_npc then
            self.FocusNpcId = v
            break
        end
    end

end --func end
--next--
function MagicExtractMachineCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.NeedRevertMaskFlag = false
    self.materialIsEnough = false
    self.CurrentAwardItem = {}
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    Mgr.Uninit()

end --func end
--next--
function MagicExtractMachineCtrl:OnActive()
    if self.uiPanelData then
        self:OnExtractPreview(self.uiPanelData)
    end
    MPlayerInfo:FocusToRefine(self.FocusNpcId, -2, 1.7, 2, 8, 135, 5)
    self:initGOData()
end --func end
--next--
function MagicExtractMachineCtrl:OnDeActive()

end --func end
--next--
function MagicExtractMachineCtrl:DeActive(isPlayTween)
    if self.NeedRevertMaskFlag then
        -- 动画没有正常播完 执行特殊处理
        MPlayerInfo:OpenCameraMask(MLayer.MASK_PLAYER)
        MPlayerInfo:FocusToRefine(self.FocusNpcId, -2, 1.7, 2, 8, 135, 5)
        self:RecoverView(self.CurrentAwardItem)
        self.NeedRevertMaskFlag = false
    end
    MPlayerInfo:FocusToMyPlayer()
    super.DeActive(self, isPlayTween)
end --func end
--next--
function MagicExtractMachineCtrl:Update()


end --func end

--next--
function MagicExtractMachineCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher, MgrMgr:GetMgr("LimitBuyMgr").LIMIT_BUY_COUNT_UPDATE, self.OnLimitChange)
    --抽取成功
    self:BindEvent(Mgr.EventDispatcher, Mgr.ExtractSuccess, function(self, data)
        self:ExtractSuccess(data)
    end)
    self:BindEvent(Mgr.EventDispatcher, Mgr.OnExtractPreviewEvent, self.OnExtractPreview)
end --func end
--next--
--lua functions end

--lua custom scripts
-- 初始化go表现的数据
function MagicExtractMachineCtrl:initGOData()
    self.panel.TxtTitle.LabText = Mgr.GetCurrentExtractDescription()
    self.panel.TxtPreview.LabText = Common.Utils.Lang("MagicMachinePreview", Mgr.GetCurrentExtractDescription())
end
-- 预览回调触发
function MagicExtractMachineCtrl:OnExtractPreview(data)
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
        self.panel.Btn_Probabilty.gameObject:GetComponent("UIBtnProbability"):SetBtnID(MGlobalConfig:GetInt("HeadMachine"))
        self.ExtractItemCount = data.use_times
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        self.panel.Btn_Probabilty.gameObject:GetComponent("UIBtnProbability"):SetBtnID(MGlobalConfig:GetInt("CardMachine"))
        self.ExtractItemCount = data.card_times
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        self.panel.Btn_Probabilty.gameObject:GetComponent("UIBtnProbability"):SetBtnID(MGlobalConfig:GetInt("EquipMachine"))
        self.ExtractItemCount = data.use_times
    end
    self.ShowItemDatas = Mgr.GetAllExtractShowItemsData()
    self:RefreshPanel()
    self:IsMaterialEnough()
end
-- 刷新抽取数据
function MagicExtractMachineCtrl:RefreshPanel()
    self.panel.TxtRemainTimes.LabText = StringEx.Format(Common.Utils.Lang("Extract_Times"), Mgr.GetExtractNumberMax() - self.ExtractItemCount, Mgr.GetExtractNumberMax())
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
        -- 设置预览数据
        self.panel.PanelNoItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCHeadWear[self.CurrentArrowIndex] == 0)
        self.panel.ScrollViewItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCHeadWear[self.CurrentArrowIndex] > 0)
        self.showItemsTemplatePool:ShowTemplates({ Datas = self.ShowItemDatas.BCHeadWear[self.CurrentArrowIndex] })
        -- 设置icon 描述 等
        self.panel.TextMessage.LabText = Common.Utils.Lang("Extract_Head_Help")
        self.panel.TxtPriceCount.LabText = Mgr.OrnamentExpendBCAmount[0][1]
        local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(Mgr.OrnamentExpendBCAmount[0][0]))
        self.panel.IconPrice:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
        self.panel.ImgCoin:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        local l_itemInfo = nil
        if Mgr.CurrentExtractCardType == Mgr.EExtractCardType.ACard then
            -- 设置预览数据
            self.panel.PanelNoItem.gameObject:SetActiveEx(#self.ShowItemDatas.ACard[self.CurrentArrowIndex] == 0)
            self.panel.ScrollViewItem.gameObject:SetActiveEx(#self.ShowItemDatas.ACard[self.CurrentArrowIndex] > 0)
            self.showItemsTemplatePool:ShowTemplates({ Datas = self.ShowItemDatas.ACard[self.CurrentArrowIndex] })
            -- 设置icon 描述 等
            self.panel.TextMessage.LabText = Common.Utils.Lang("Purple_Help")
            self.panel.TxtPriceCount.LabText = Mgr.ExpendAAmount[0][1]
            l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(Mgr.ExpendAAmount[0][0]))
        elseif Mgr.CurrentExtractCardType == Mgr.EExtractCardType.BCCard then
            -- 设置预览数据
            self.panel.PanelNoItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCCard[self.CurrentArrowIndex] == 0)
            self.panel.ScrollViewItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCCard[self.CurrentArrowIndex] > 0)
            self.showItemsTemplatePool:ShowTemplates({ Datas = self.ShowItemDatas.BCCard[self.CurrentArrowIndex] })
            -- 设置icon 描述 等
            self.panel.TextMessage.LabText = Common.Utils.Lang("BlueGreen_Help")
            self.panel.TxtPriceCount.LabText = Mgr.ExpendBCAmount[0][1]
            l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(Mgr.ExpendBCAmount[0][0]))
        end
        self.panel.IconPrice:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
        self.panel.ImgCoin:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        local l_itemInfo = nil
        if Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.AEquip then
            -- 设置预览数据
            self.panel.PanelNoItem.gameObject:SetActiveEx(#self.ShowItemDatas.AEquip[self.CurrentArrowIndex] == 0)
            self.panel.ScrollViewItem.gameObject:SetActiveEx(#self.ShowItemDatas.AEquip[self.CurrentArrowIndex] > 0)
            self.showItemsTemplatePool:ShowTemplates({ Datas = self.ShowItemDatas.AEquip[self.CurrentArrowIndex] })
            -- 设置icon 描述 等
            self.panel.TextMessage.LabText = Common.Utils.Lang("MagicAEquipExtractTips")
            self.panel.TxtPriceCount.LabText = Mgr.EquipExpendAAmount[0][1]
            l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(Mgr.EquipExpendAAmount[0][0]))
        elseif Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.BCEquip then
            -- 设置预览数据
            self.panel.PanelNoItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCEquip[self.CurrentArrowIndex] == 0)
            self.panel.ScrollViewItem.gameObject:SetActiveEx(#self.ShowItemDatas.BCEquip[self.CurrentArrowIndex] > 0)
            self.showItemsTemplatePool:ShowTemplates({ Datas = self.ShowItemDatas.BCEquip[self.CurrentArrowIndex] })
            -- 设置icon 描述 等
            self.panel.TextMessage.LabText = Common.Utils.Lang("MagicBCEquipExtractTips")
            self.panel.TxtPriceCount.LabText = Mgr.EquipExpendBCAmount[0][1]
            l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(Mgr.EquipExpendBCAmount[0][0]))
        end
        self.panel.IconPrice:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
        self.panel.ImgCoin:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)
    end
end
--抽取成功
function MagicExtractMachineCtrl:ExtractSuccess(data)
    self.isReqExtractItem = false
    -- 播放动作TODO
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
        local l_cameraPos = MGlobalConfig:GetSequenceOrVectorFloat("ToushijiCameraLens")
        MPlayerInfo:FocusToRefine(self.FocusNpcId, l_cameraPos[0], l_cameraPos[1], l_cameraPos[2], 1.2, 135, 5)
        MPlayerInfo:CloseCameraMask(MLayer.MASK_PLAYER)
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Special", "NPC_M_ChouKaJi_02_ChouKa")
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        local l_cameraPos = MGlobalConfig:GetSequenceOrVectorFloat("KapianjiCameraLens")
        MPlayerInfo:FocusToRefine(self.FocusNpcId, l_cameraPos[0], l_cameraPos[1], l_cameraPos[2], 1.2, 135, 5)
        MPlayerInfo:CloseCameraMask(MLayer.MASK_PLAYER)
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Special", "NPC_M_ChouKaJi_01_Start")
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        local l_cameraPos = MGlobalConfig:GetSequenceOrVectorFloat("ToushijiCameraLens")
        MPlayerInfo:FocusToRefine(self.FocusNpcId, l_cameraPos[0], l_cameraPos[1], l_cameraPos[2], 1.2, 135, 5)
        MPlayerInfo:CloseCameraMask(MLayer.MASK_PLAYER)
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Special", "NPC_M_ChouKaJi_04_Start")
    end
    self.CurrentAwardItem = data
    self.NeedRevertMaskFlag = true
    self.panel.Panel.gameObject:SetActiveEx(false)
    self.panel.BtnBox.gameObject:SetActiveEx(true)
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    self.timer = self:NewUITimer(function()
        self:ShowSpecialTips(data)
    end, 4.5, 0, true)
    self.timer:Start()
end
--展示头饰
function MagicExtractMachineCtrl:ShowSpecialTips(data)
    local endFunc = function()
        MPlayerInfo:OpenCameraMask(MLayer.MASK_PLAYER)
        self.NeedRevertMaskFlag = false
        MPlayerInfo:FocusToRefine(self.FocusNpcId, -2, 1.7, 2, 8, 135, 5)
        self.panel.Panel.gameObject:SetActiveEx(true)
        self.panel.BtnBox.gameObject:SetActiveEx(false)
        self:IsMaterialEnough()
    end
    self:RecoverView(data, endFunc)
end
function MagicExtractMachineCtrl:RecoverView(data, callback)
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Idle", "NPC_M_ChouKaJi_02_Idle")
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Idle", "NPC_M_ChouKaJi_01_Idle")
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        MLuaClientHelper.PlayAnimation(self.FocusNpcId, "Idle", "NPC_M_ChouKaJi_04_Idle")
    end
    if data and data.item_id then
        local l_ItemData = TableUtil.GetItemTable().GetRowByItemID(data.item_id, true)
        -- item不属于装备、卡片、时装、头饰图纸，则没有动画，直接飘字提示
        if l_ItemData then
            if l_ItemData.TypeTab ~= Data.BagModel.PropType.Weapon
                    and l_ItemData.TypeTab ~= Data.BagModel.PropType.BluePrint
                    and l_ItemData.TypeTab ~= Data.BagModel.PropType.Card then
                local l_opt = {
                    itemId = data.item_id,
                    itemOpts = { num = data.item_num, icon = { size = 18, width = 1.4 } },
                }
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
                if callback then
                    callback()
                end
                return
            end
        end
        MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(data.item_id, data.item_num, function()
            if callback then
                callback()
            end
            UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
        end)
    end
end
--材料判断是否足够
function MagicExtractMachineCtrl:IsMaterialEnough()
    local l_count = 0
    local l_currentCount = 0
    if Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.HeadWear then
        l_count = tonumber(Mgr.OrnamentExpendBCAmount[0][1])
        l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(Mgr.OrnamentExpendBCAmount[0][0]))
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Card then
        if Mgr.CurrentExtractCardType == Mgr.EExtractCardType.ACard then
            l_count = tonumber(Mgr.ExpendAAmount[0][1])
            l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(Mgr.ExpendAAmount[0][0]))
        elseif Mgr.CurrentExtractCardType == Mgr.EExtractCardType.BCCard then
            l_count = tonumber(Mgr.ExpendBCAmount[0][1])
            l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(Mgr.ExpendBCAmount[0][0]))
        end
    elseif Mgr.CurrentMachineType == Mgr.EMagicExtractMachineType.Equip then
        if Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.AEquip then
            l_count = tonumber(Mgr.EquipExpendAAmount[0][1])
            l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(Mgr.EquipExpendAAmount[0][0]))
        elseif Mgr.CurrentExtractEquipType == Mgr.EExtractEquipType.BCEquip then
            l_count = tonumber(Mgr.EquipExpendBCAmount[0][1])
            l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(Mgr.EquipExpendBCAmount[0][0]))
        end
    end

    self.panel.TxtCoin.LabText = tostring(l_currentCount)
    self.IsmaterialEnough = l_currentCount >= l_count
    if self.IsmaterialEnough then
        self.panel.TxtPriceCount.LabColor = Color.New(255 / 255, 231 / 255, 136 / 255, 1)
    else
        self.panel.TxtPriceCount.LabColor = Color.New(163 / 255, 43 / 255, 43 / 255, 1)
    end
end
function MagicExtractMachineCtrl:OnLimitChange(limitType)
    local l_limitType = MgrMgr:GetMgr("LimitBuyMgr").g_limitType
    if limitType == l_limitType.EXTRACT_CARD or limitType == l_limitType.DELEGATE or limitType == l_limitType.EXTRACT_EQUIP then
        Mgr.ReqExtractPreview()
    end
end
--lua custom scripts end
return MagicExtractMachineCtrl