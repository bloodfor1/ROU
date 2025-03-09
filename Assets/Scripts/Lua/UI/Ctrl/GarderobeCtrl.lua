--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GarderobePanel"
require "UI/Template/GardrobeCellTemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/GardrobeStoreCellTemplate"
require "UI/Template/GarderobeAwardCellTemplate"
require "UI/Template/GardrobeLeftInfoItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GarderobeCtrl = class("GarderobeCtrl", super)

local TipsStateEnum = {
    Expand = 1,
    Narrow = 2
}

---@type ModuleMgr.GarderobeMgr
local Mgr = MgrMgr:GetMgr("GarderobeMgr")
local LimitMgr = MgrMgr:GetMgr("LimitMgr")
local attr = nil
local model = nil
local EOrnamentType = Mgr.EOrnamentType
local colorScroll
local hairScroll
local colorIndex = 1
local hairColorIndex = 0
local curItemInfo = nil
local placeTogState = nil
local uiPlaceTogState = EOrnamentType.Head
local lastClickIndex = -1
local tipsState = TipsStateEnum.Narrow
local conditionGOTable = {}
local currentSelectIndex = 1
--fx
local l_fx = nil
local FxID = 121006
--npc
local eyeFuncId = 1040
local hairFuncId = 1050
--achievementId
local achievementId = 60000401

--fashion anim
local FASHION_ANIM_STATE = {
    IDLE = 0,
    SHOW = 1,
}
local l_animState = FASHION_ANIM_STATE.IDLE
local l_interval = 7
local l_remainTime = l_interval

--- 在选择头发和眼睛的时候会出现这个状态，这个时候是要显示一个额外的GM按钮
local C_GM_FACE_STATE = {
    [Mgr.EGarderobeType.Eye] = 1,
    [Mgr.EGarderobeType.Hair] = 1,
}

local FindObjectInChild = function(...)
    return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end
--lua class define end

--lua functions
function GarderobeCtrl:ctor()
    super.ctor(self, CtrlNames.Garderobe, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
end --func end
--next--
function GarderobeCtrl:Init()
    Mgr.GetGarderobeAwardData()
    self.panel = UI.GarderobePanel.Bind(self)
    super.Init(self)
    self:Bind()
    self:InitView()
    self:InitModel()
    curItemInfo = nil

    --红点
    self.RedSignProcessor=self:NewRedSign({
        Key=eRedSignKey.FashionAward,
        ClickTog=self.panel.BtnCollection
    })

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.FashionAward)
end --func end
--next--
function GarderobeCtrl:Uninit()
    lastClickIndex = -1
    currentSelectIndex = 1
    placeTogState = nil
    uiPlaceTogState = EOrnamentType.Head
    self.gardrobeStoreTemplatePool = nil
    self.gardrobeTemplatePool = nil
    self.gardrobeTemplateInfoPool = nil

    if model ~= nil then
        self:DestroyUIModel(model)
        model = nil
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GarderobeCtrl:OnActive()
    MgrMgr:GetMgr("HeadShopMgr").RequestAllLimitData(self.npc_id)
    Mgr.UISelectItem.ItemID = nil
    Mgr.UISelectItem.Index = nil
    self.panel.SwitchTog.gameObject:GetComponent("UIToggleEx").isOn = false
    tipsState = TipsStateEnum.Narrow

    self.panel.Information.gameObject:SetActiveEx(false)
    self.panel.CollectionInfo.gameObject:SetActiveEx(false)

    self.panel.BtnCollection.gameObject:SetActiveEx(false)
    self:RefreshLeftPanel()
    self:RefreshView()
    self:RefreshToggleGroup()
    local l_beginnerGuideChecks = { "DressUp" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())

    --【【915版本计划内功能】【衣橱】暂时屏蔽滑动条】 https://www.tapd.cn/20332331/prong/stories/view/1120332331001039751
    self.panel.Scrollbar.gameObject:SetActiveEx(false)

    if self.uiPanelData then
        if self.uiPanelData.gardeorbeAwardId then
            self:OpenRewardPanelByGarderobePoint(self.uiPanelData.gardeorbeAwardId)
        end
        if self.uiPanelData.ornamentID then
            self:OnCellBeDisplayed(self.uiPanelData.ornamentID)
        end
    end
    self:CreateEffectLeftDown()
    self:CreateEffectCollection()
    self:CreateEffectLight()

    self.panel.ShareButton.gameObject:SetActiveEx(MgrMgr:GetMgr("ShareMgr").CanShare_merge())

end --func end
--next--
function GarderobeCtrl:OnDeActive()
    Mgr.ClearUISelectItem()
    self:ClearFx()
    Mgr.SetCanStoreFilter(false)
    Mgr.SetCanStrengthFilter(false)
    Mgr.SetSearchFilter(false)
    self:DestoryEffectLeftDown()
    self:DestoryEffectCollection()
    self:DestoryEffectLight()

end --func end
--next--
function GarderobeCtrl:Update()
    l_remainTime = l_remainTime - UnityEngine.Time.deltaTime
    if l_animState == FASHION_ANIM_STATE.IDLE then
        if l_remainTime <= 0 then
            self:EnterShowState()
        end
    elseif l_animState == FASHION_ANIM_STATE.SHOW then
        if l_remainTime <= 0 then
            self:EnterIdleState()
        end
    end

    self.gardrobeTemplatePool:OnUpdate()
end --func end
--next--
function GarderobeCtrl:OnReconnected()
    super.OnReconnected(self)
    self:RefreshView()
end --func end

--next--
function GarderobeCtrl:BindEvents()
    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_WEAR_ORNAMENT, function(self, itemId, isPutOn)
        self:RefreshLeftPanel()
        Mgr.SetAttrOrnament(attr, itemId, isPutOn)
        if model ~= nil then
            if isPutOn then
                self:PlayFx(FxID, EModelBone.ERoot)
            end

            model:RefreshEquipData(attr.EquipData)
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_WEAR_FASHION, function(self, uid, isPutOn)
        self:RefreshLeftPanel()
        if model ~= nil then
            if isPutOn then
                self:PlayFx(FxID, EModelBone.ERoot)
            end

            Mgr.SetAttrFashion(attr, uid, isPutOn)
            model:RefreshEquipData(attr.EquipData)

            self:RefreshAnim()
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_ADD_ITEM, function()
        self:RefreshToggleGroup()
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_NEW_ITEM_CLICK, function()
        self:RefreshToggleGroup()
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_STORE_REFRESH, function()
        self:RefreshTips()
        self:RefreshCollectionView()
        self:RefreshPanelView()
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_STORE_ADD, function()
        if curItemInfo ~= nil and curItemInfo.itemRow ~= nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FashionText4", GetColorText(curItemInfo.itemRow.ItemName, RoColorTag.Blue)))
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_AWARD_RES, function()
        self:RefreshCollectionView()
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_STORE_REMOVE, function()
        if curItemInfo ~= nil and curItemInfo.itemRow ~= nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FashionText3", GetColorText(curItemInfo.itemRow.ItemName, RoColorTag.Blue)))
        end
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_GARDEROBE_FASHION_AWARD_RES, function()
        self:RefreshCollectionView()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function GarderobeCtrl:Bind()
    colorScroll = self.panel.Colors:GetComponent("UIBarberScroll")
    colorScroll.OnValueChanged = function(idx)
        colorIndex = idx + 1
        self:RefreshColor()
    end

    colorScroll.CurrentIndex = MPlayerInfo.EyeColorID - 1
    colorIndex = MPlayerInfo.EyeColorID

    hairScroll = self.panel.HeadColors:GetComponent("UIBarberScroll")
    hairScroll.OnValueChanged = function(idx)
        hairColorIndex = idx + 1
        self:RefreshColor()
    end

    local curStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(MPlayerInfo.HairStyle)
    hairScroll.CurrentIndex = curStyleRow.Colour - 1
    hairColorIndex = curStyleRow.Colour

    self.panel.TxtCollectionInfo.LabText = Common.Utils.Lang("GarderobeStr1")
    self.panel.TxtCollectionInfo:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(achievementId)
        self:ShowCollectionInfo(false)
    end)

    self.panel.BtnCollectionBlank:AddClick(function()
        self:ShowCollectionInfo(false)
    end)

    self.panel.BtnCollection:AddClick(function()
        local isActive = self.panel.ImgEffectCollection.gameObject.activeSelf
        if isActive == true then
            local tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GarderobeFashionCountGuide1")
            MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = true
            MgrMgr:GetMgr("BeginnerGuideMgr").ReqFinishOneGuide(tuid.Condition[0][0])
            self.panel.ImgEffectCollection.gameObject:SetActiveEx(false)
        end
        self:ShowCollectionInfo(not isActive)
    end)

    self.panel.BtQuit:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Garderobe)
    end)

    self.panel.BtnFashionApply:AddClick(function()
        if curItemInfo ~= nil then
            local itemId = curItemInfo.itemRow.ItemID
            local uid = Mgr.GetFashionUidByItemID(itemId)
            Mgr.RequestWearFashion(uid, itemId, true)
        end
    end)

    self.panel.BtnApply:AddClick(function()
        if curItemInfo.garderobeType == Mgr.EGarderobeType.Fashion then
            if curItemInfo ~= nil then
                local itemId = curItemInfo.itemRow.ItemID
                local uid = Mgr.GetFashionUidByItemID(itemId)
                Mgr.RequestWearFashion(uid, itemId, true)
            end
        else
            if curItemInfo ~= nil then
                local itemId = curItemInfo.itemRow.ItemID
                Mgr.RequestWearOrnament(itemId, true)
            end
        end
    end)

    self.panel.BtnCancel:AddClick(function()
        if curItemInfo ~= nil then
            local itemId = curItemInfo.itemRow.ItemID
            if curItemInfo.garderobeType == Mgr.EGarderobeType.Fashion then
                local uid = Mgr.GetFashionUidByItemID(itemId)
                Mgr.RequestWearFashion(uid, itemId, false)
            else
                Mgr.RequestWearOrnament(itemId, false)
            end
            --curItemInfo = nil
            self.panel.Information.gameObject:SetActiveEx(false)
        end
    end)

    self.panel.BtnGet:AddClick(function()
        if curItemInfo == nil then
            return
        end

        local itemId = curItemInfo.itemRow.ItemID
        if curItemInfo ~= nil then
            if Common.CommonUIFunc.isItemHaveExport(itemId) then
                UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function()
                    local ui = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
                    if ui then
                        ui:InitItemAchievePanelByItemId(itemId)
                    end
                end)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_EXPORT_PATH"))
            end
        end
    end)

    self.panel.BtnGetOld:AddClick(function()
        if curItemInfo == nil then
            return
        end

        local itemId = curItemInfo.itemRow.ItemID
        if curItemInfo ~= nil then
            if Common.CommonUIFunc.isItemHaveExport(itemId) then
                UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function()
                    local ui = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
                    if ui then
                        ui:InitItemAchievePanelByItemId(itemId)
                    end
                end)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_EXPORT_PATH"))
            end
        end
    end)

    self.panel.BtnStore:AddClick(function()
        local data = Mgr.GetPropInfoFromAllStored(curItemInfo.itemRow.ItemID)
        if #data > 0 then
            if #data == 1 then
                self:StoreItem(data[1])
            else
                self.panel.PanelFashionStore.gameObject:SetActiveEx(true)
                self.gardrobeStoreTemplatePool:ShowTemplates({
                    Datas = data,
                    Method = function(propInfo)
                        self:OnStoreCellClicked(propInfo)
                    end
                })
            end
        end
    end)

    self.panel.BtnOut:AddClick(function()
        local data = Mgr.GetItemFromFashionStore(curItemInfo.itemRow.ItemID)
        if data ~= nil then
            Mgr.RequestStoreBag(data.UID)
        end
    end)

    self.panel.TogHead.gameObject:GetComponent("UIToggleEx").isOn = true
    self.panel.TogHead:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Head
            self:RefreshView()
        end
    end)

    self.panel.TogFace:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Face
            self:RefreshView()
        end
    end)

    self.panel.TogMouth:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Mouth
            self:RefreshView()
        end
    end)

    self.panel.TogBack:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Back
            self:RefreshView()
        end
    end)

    self.panel.TogFashion:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Fashion
            self:RefreshView()
        end
    end)

    self.panel.TogHair:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Hair
            self:RefreshView()
        end
    end)

    self.panel.TogEye:OnToggleExChanged(function(value)
        if value then
            uiPlaceTogState = EOrnamentType.Eye
            self:RefreshView()
        end
    end)

    self.panel.TogStore:OnToggleChanged(function(value)
        Mgr.SetCanStoreFilter(value)
        self:RefreshScrollView()
    end)

    self.panel.TogStrength:OnToggleChanged(function(value)
        Mgr.SetCanStrengthFilter(value)
        self:RefreshScrollView()
    end)

    self.panel.SwitchTog:OnToggleExChanged(function(value)
        if value then
            tipsState = TipsStateEnum.Expand
        else
            tipsState = TipsStateEnum.Narrow
        end
        self:RefreshTips()
    end)

    self.panel.RewardClosePanel:AddClick(function()
        self.panel.PanelReward.gameObject:SetActiveEx(false)
    end)

    self.panel.RewardCloseButton:AddClick(function()
        self.panel.PanelReward.gameObject:SetActiveEx(false)
    end)

    self.panel.BtnGotoEye:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("GOTO_EYESHOP"), function()
            if curItemInfo == nil then return end
            local cNpcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(hairFuncId)
            if table.maxn(cNpcTb) > 0 then
                for x = 1, table.maxn(cNpcTb) do
                    local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(cNpcTb[x])
                    local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(hairFuncId)
                    MTransferMgr:GotoPosition(sceneIdTb[1], posTb[1], function()
                        Mgr.EnableJumpToEyeShop(true)
                        Mgr.JumpToEyeColorIndex = colorIndex
                        Mgr.JumpToEyeId = curItemInfo.row.EyeID
                        method()
                    end)
                    UIMgr:DeActiveUI(UI.CtrlNames.Garderobe)
                    return
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_NPCHERE"))
            end
        end, function()
        end)
    end)

    self.panel.ClosePanel:AddClick(function()
        self.gardrobeStoreTemplatePool:DeActiveAll()
        self.panel.PanelFashionStore.gameObject:SetActiveEx(false)
    end)

    self.panel.BtnRecover:AddClick(function()
        self:RecoverModel()
    end)

    self.panel.BtnGotoHair:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("GOTO_HAIRSHOP"), function()
            if curItemInfo == nil or curItemInfo.styleRow == nil or curItemInfo.styleRow[hairColorIndex] == nil then
                return
            end
            local cNpcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(eyeFuncId)
            if table.maxn(cNpcTb) > 0 then
                for x = 1, table.maxn(cNpcTb) do
                    local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(cNpcTb[x])
                    local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(eyeFuncId)
                    MTransferMgr:GotoPosition(sceneIdTb[1], posTb[1], function()
                        Mgr.EnableJumpToBarberShop(true)
                        Mgr.JumpToBarberStyleId = curItemInfo.styleRow[hairColorIndex].BarberStyleID
                        method()
                    end)
                    UIMgr:DeActiveUI(UI.CtrlNames.Garderobe)
                    return
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_NPCHERE"))
            end
        end, function()
        end)
    end)

    self.panel.SearchInput:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        self.panel.SearchInput.Input.text = value
        self:Search()
        self.panel.BtnSearchCancel.gameObject:SetActiveEx(self.panel.SearchInput.Input.text ~= "")

    end, false)

    self.panel.BtnSearch:AddClick(function()
        self:Search()
    end)

    self.panel.BtnLock:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(true)
        self:RefreshLimitView()
    end)

    self.panel.Btn_LockSure:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    end)

    self.panel.ExplainClosePanel:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    end)

    self.panel.btnMark2.Listener.onClick = function(go, eventData)
        local l_infoText = Lang("FASHION_MARK2")
        local pos = Vector2.New(eventData.position.x, eventData.position.y)
        eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, Vector2(0, 0))
    end

    self.panel.BtnMark1.Listener.onClick = function(go, eventData)
        local l_infoText = Lang("FASHION_MARK1")
        local pos = Vector2.New(eventData.position.x, eventData.position.y)
        eventData.position = pos
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, Vector2(0, 0))
    end

    self.panel.BtnGM:AddClick(function()
        if curItemInfo and curItemInfo.itemRow then
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 1", curItemInfo.itemRow.ItemID))
        end
    end)

    self.panel.BtnSearchCancel:AddClick(function()
        self.panel.SearchInput.Input.text = ""
        self.panel.BtnSearchCancel.gameObject:SetActiveEx(false)
    end)

    self.panel.ShareButton:AddClick(self.OpenShareNormal)
end
function GarderobeCtrl:OpenShareNormal()
    MgrMgr:GetMgr("ShareMgr").OpenShareUI(MgrMgr:GetMgr("ShareMgr").ShareID.GarderobeShare,attr,MgrMgr:GetMgr("ShareMgr").ShareID.GarderobeShare,nil)
end
function GarderobeCtrl:Search()
    Mgr.SetSearchFilter(true)

    Mgr.SearchText = self.panel.SearchInput.Input.text
    Mgr.SearchText = string.gsub(Mgr.SearchText, "%%", "#")
    self:RefreshScrollView()
end

function GarderobeCtrl:RefreshLimitView()
    local l_str_tbl = MgrMgr:GetMgr("HeadShopMgr").GetLimitStr(curItemInfo.itemRow.ItemID)
    for i = 1, DataMgr:GetData("HeadShopData").MaxLimitCondition do
        if l_str_tbl[i] ~= nil then
            self:ProcessLimitGO(conditionGOTable[i].gameObject, l_str_tbl[i])
        else
            conditionGOTable[i].gameObject:SetActiveEx(false)
        end
    end
end

function GarderobeCtrl:ProcessLimitGO(gameObject, item)
    gameObject:SetActiveEx(true)
    local text = FindObjectInChild(gameObject, "Condition")
    MLuaClientHelper.GetOrCreateMLuaUICom(text).LabText = item.str
    local lockImg = FindObjectInChild(gameObject, "Lock")
    local goBtn = FindObjectInChild(gameObject, "Go")
    goBtn:SetActiveEx(not item.finish)
    lockImg:SetActiveEx(not item.finish)
    goBtn:GetComponent("MLuaUICom"):AddClick(function()
        if item.limitType == LimitMgr.ELimitType.LEVEL_LIMIT then
            UIMgr:ActiveUI(UI.CtrlNames.ExpAchieveTips, function(ctrl)
                ctrl:ShowExpAchieve(item.level)
            end)
        elseif item.limitType == LimitMgr.ELimitType.ENTITY_LIMIT then
            if item.entityId ~= nil then
                Common.CommonUIFunc.ShowMonsterTipsById(item.entityId)
            end
        elseif item.limitType == LimitMgr.ELimitType.COLLECTION_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("COLLECTION_LIMITStr"))
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENTPOINT_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENT_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(item.AchievementId)
        elseif item.limitType == LimitMgr.ELimitType.TASK_LIMIT then
            if item.task ~= nil then
                if item.task.minBaseLevel > 0 then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TASK_LIMITStr"), item.task.minBaseLevel, item.task.typeTitle, item.task.name))
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TASK_LIMIT"), item.task.typeTitle, item.task.name))
                end
            end
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENTLEVEL_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
        end
    end)
end

function GarderobeCtrl:InitView()
    self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    self.panel.BtnGM.gameObject:SetActiveEx(MGameContext.IsOpenGM)
    self.panel.BtnSearchCancel.gameObject:SetActiveEx(false)
    self.panel.PanelReward.gameObject:SetActiveEx(false)
    self.panel.PanelFashionStore.gameObject:SetActiveEx(false)
    self.panel.GardrobeCell.gameObject:SetActiveEx(false)
    self.panel.ImgEffectCollection.gameObject:SetActiveEx(false)
    self.panel.EffectJiaXing.gameObject:SetActiveEx(false)

    self.panel.GardrobeScroll.LoopScroll.OnEndDragCallback = function()
        -- do nothing
    end

    conditionGOTable = {}
    table.insert(conditionGOTable, self.panel.Condition1)
    table.insert(conditionGOTable, self.panel.Condition2)
    table.insert(conditionGOTable, self.panel.Condition3)
    table.insert(conditionGOTable, self.panel.Condition4)
    table.insert(conditionGOTable, self.panel.Condition5)
    table.insert(conditionGOTable, self.panel.Condition6)

    self.gardrobeStoreTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GardrobeStoreCellTemplate,
        TemplatePrefab = self.panel.GardrobeStoreCell.gameObject,
        ScrollRect = self.panel.GarderobeStoreScroll.LoopScroll,
    })

    self.gardrobeTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GardrobeCellTemplate,
        TemplatePrefab = self.panel.GardrobeCell.gameObject,
        ScrollRect = self.panel.GardrobeScroll.LoopScroll,
        SetCountPerFrame = 5,
        CreateObjPerFrame = 3,
    })

    self.gardrobeTemplateInfoPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GardrobeLeftInfoItemTemplate,
        TemplatePrefab = self.panel.GardrobeLeftInfoItemPrefab.gameObject,
        ScrollRect = self.panel.InfoScroll.LoopScroll,
    })

    self.garderobeRewardTemplateInfoPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GarderobeAwardCellTemplate,
        TemplatePrefab = self.panel.GarderobeAwardCell.gameObject,
        ScrollRect = self.panel.GarderobeAwardScrollView.LoopScroll,
    })

    Mgr:ReProcessWeight()
end

function GarderobeCtrl:InitModel()
    -- 试穿模型
    attr = Mgr.GetRoleAttr()
    self.panel.ModelImage.gameObject:SetActiveEx(false)

    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImage.RawImg
    l_fxData.attr = attr
    l_fxData.useShadow = true
    l_fxData.enablePostEffect = true
    l_fxData.isCameraPosRotCustom = true
    l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
    l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
    l_fxData.defaultAnim = Mgr.GetRoleAnim(attr)
    l_fxData.width = 1024*1.5
    l_fxData.height = 1024*1.5

    model = self:CreateUIModel(l_fxData)
    model.LocalPosition = Vector3.New(0.3, 0.0, 0.0)
    model.Scale = Vector3.New(0.9, 0.9, 0.9)
    model:AddLoadModelCallback(function(m)
        self.panel.ModelImage.gameObject:SetActiveEx(true)
    end)
    local listener = self.panel.ModelTouchArea:GetComponent("MLuaUIListener")
    listener.onDrag = function(uobj, event)
        if model and model.Trans then
            model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
        end
    end

end

function GarderobeCtrl:RecoverModel()
    if model ~= nil then
        self:DestroyUIModel(model)
        attr = Mgr.GetRoleAttr()
        local l_fxData = {}
        l_fxData.rawImage = self.panel.ModelImage.RawImg
        l_fxData.attr = attr
        l_fxData.useShadow = true
        l_fxData.enablePostEffect = true
        l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
        l_fxData.isCameraPosRotCustom = true
        l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
        l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
        model = self:CreateUIModel(l_fxData)

        model.LocalPosition = Vector3.New(0.3, 0.0, 0.0)
        model.Scale = Vector3.New(0.9, 0.9, 0.9)

        model:AddLoadModelCallback(function(m)
            self.panel.ModelImage.gameObject:SetActiveEx(true)
        end)

    end
end

function GarderobeCtrl:CleanScroll()
    self.gardrobeTemplatePool:DeActiveAll()
end

function GarderobeCtrl:RefreshView()
    self:ClearClickedCell()
    placeTogState = uiPlaceTogState
    self:RefreshLeftPanel()
    self:RefreshScrollView()
    self:RefreshPanelView()
end

function GarderobeCtrl:RefreshToggleGroup()
    local function setToggleRedSign(isShow, toggleType)
        local targetGO = nil
        if toggleType == EOrnamentType.Head then
            targetGO = self.panel.TogHead.gameObject
        elseif toggleType == EOrnamentType.Face then
            targetGO = self.panel.TogFace.gameObject
        elseif toggleType == EOrnamentType.Mouth then
            targetGO = self.panel.TogMouth.gameObject
        elseif toggleType == EOrnamentType.Back or toggleType == EOrnamentType.Tail then
            targetGO = self.panel.TogBack.gameObject
        elseif toggleType == EOrnamentType.Fashion then
            targetGO = self.panel.TogFashion.gameObject
        end

        local redIcon = FindObjectInChild(targetGO, "IconHot")
        if redIcon ~= nil and redIcon.activeSelf ~= isShow then
            redIcon:SetActiveEx(isShow)
        end
    end

    setToggleRedSign(false, EOrnamentType.Head)
    setToggleRedSign(false, EOrnamentType.Face)
    setToggleRedSign(false, EOrnamentType.Mouth)
    setToggleRedSign(false, EOrnamentType.Back)
    setToggleRedSign(false, EOrnamentType.Fashion)

    if Mgr.NewItemId ~= nil and #Mgr.NewItemId > 0 then
        for _, itemId in ipairs(Mgr.NewItemId) do
            local ornamentType = Mgr.GetOrnamentTypeById(itemId)
            if ornamentType ~= nil then
                setToggleRedSign(true, ornamentType)
            else
                logError("ornamentType is nil key is " .. tostring(itemId))
            end
        end
    end
end

function GarderobeCtrl:RefreshPanelView()
    if placeTogState == EOrnamentType.Eye then
        self.panel.EyeColorInfo.gameObject:SetActiveEx(true)
        self.panel.HeadColorInfo.gameObject:SetActiveEx(false)
    elseif placeTogState == EOrnamentType.Hair then
        self.panel.EyeColorInfo.gameObject:SetActiveEx(false)
        self.panel.HeadColorInfo.gameObject:SetActiveEx(true)
    end

    local count = Mgr.FashionRecord.fashion_count
    if count ~= nil then
        local Table = TableUtil.GetGarderobeAwardTable().GetTable()
        local NextGarderobeAwardRow = {}
        local NextLevel = 0
        local CurGarderobeAwardRow = {}
        local CurLevel = 0
        local flag = false
        for i = 1, #Table do
            if Table[i].Point <= count then
                CurLevel = Table[i].ID
                CurGarderobeAwardRow = Table[i]
            else
                NextLevel = Table[i].ID
                NextGarderobeAwardRow = Table[i]
                flag = true
                break
            end
        end
        if flag == false then
            NextLevel = CurLevel
            NextGarderobeAwardRow = CurGarderobeAwardRow
        end
        self.panel.FashionPointTxt.LabText = CurLevel
        self.panel.FashionPointTxt.LabColor = CommonUI.Color.Hex2Color(CurGarderobeAwardRow.NumberColor)
        self.panel.BtnCollection:SetSpriteAsync(CurGarderobeAwardRow.Atlas, CurGarderobeAwardRow.Icon,function ()
            self.panel.BtnCollection:SetActiveEx(true)
        end, true)
        self.panel.ImgCollectionFill.Img.fillAmount = (count - CurGarderobeAwardRow.Point) / (NextGarderobeAwardRow.Point - CurGarderobeAwardRow.Point)
        self.panel.ImgCollectionFill.Img.color = CommonUI.Color.Hex2Color(CurGarderobeAwardRow.Color)
    end
end

function GarderobeCtrl:RefreshScrollView()
    local function isSameType(type1, type2)
        if type1 == nil or type2 == nil then
            return false
        end

        if type1 <= EOrnamentType.Tail and type2 >= EOrnamentType.Head then
            return true
        else
            return false
        end
    end

    if self.gardrobeTemplatePool == nil then
        logError("GarderobeCtrl:RefreshScrollView gardrobeTemplatePool is nil")
    end

    if not isSameType(placeTogState, uiPlaceTogState) then
        self:CleanScroll()
    end

    local data = nil

    self.panel.ImageFilter.gameObject:SetActiveEx(false)
    if placeTogState == EOrnamentType.Back then
        self.panel.ImageFilter.gameObject:SetActiveEx(true)
        data = Mgr.GetOrnamentByTypeData({ EOrnamentType.Back, EOrnamentType.Tail })
        self:SetRightScrollViewPos(0)
    elseif placeTogState == EOrnamentType.Fashion then
        self.panel.ImageFilter.gameObject:SetActiveEx(true)
        data = Mgr.GetFashionData()
        self:SetRightScrollViewPos(0)
    elseif placeTogState >= EOrnamentType.Head and placeTogState <= EOrnamentType.Tail then
        self.panel.ImageFilter.gameObject:SetActiveEx(true)
        data = Mgr.GetOrnamentByTypeData({ placeTogState })
        self:SetRightScrollViewPos(0)
    elseif placeTogState == EOrnamentType.Hair then
        data = Mgr.GetHairData()
        self:SetRightScrollViewPos(1)
    elseif placeTogState == EOrnamentType.Eye then
        data = Mgr.GetEyeData()
        self:SetRightScrollViewPos(1)
    end

    if placeTogState == EOrnamentType.Fashion then
        self:ClearClickedCell()
        self.gardrobeTemplatePool:ShowTemplates({
            Datas = data,
            Method = function(index, itemInfo)
                self:OnCellClicked(index, itemInfo)
            end
        })
    elseif placeTogState >= EOrnamentType.Head and placeTogState <= EOrnamentType.Tail then
        self:ClearClickedCell()
        self.gardrobeTemplatePool:ShowTemplates({
            Datas = data,
            Method = function(index, itemInfo)
                self:OnCellClicked(index, itemInfo)
            end,
            StartScrollIndex = currentSelectIndex,
        })
    elseif placeTogState == EOrnamentType.Hair then
        self:ClearClickedCell()
        self.gardrobeTemplatePool:ShowTemplates({
            Datas = data,
            Method = function(index, itemInfo)
                self:OnCellClicked(index, itemInfo)
            end
        })
    elseif placeTogState == EOrnamentType.Eye then
        self:ClearClickedCell()
        self.gardrobeTemplatePool:ShowTemplates({
            Datas = data,
            Method = function(index, itemInfo)
                self:OnCellClicked(index, itemInfo)
            end
        })
    end

    self.panel.TextSearch.gameObject:SetActiveEx(#data == 0)
end
-- 引导
function GarderobeCtrl:_checkGuild()
    if Mgr.Callfashionlevelbyfashioncount(Mgr.FashionRecord.fashion_count) >= 1 then
        local tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GarderobeFashionCountGuide1")
        local l_isCheck = MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]]
        if l_isCheck == false then
            return true
        end
    end
    return false
end
function GarderobeCtrl:ClearClickedCell()
    if lastClickIndex ~= -1 then
        self.gardrobeTemplatePool:CancelSelectTemplate(lastClickIndex)
    end
    lastClickIndex = -1
end

---@param itemData ItemData
function GarderobeCtrl:StoreItem(itemData)
    local l_isTalentEquip, l_name = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(itemData.UID)
    if l_isTalentEquip then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("FashionTxt5"), l_name))
        return
    end
    if Mgr.IsExisInEquip(itemData.TID) then
        local point = Mgr.GetFashionPoint(itemData.TID)
        CommonUI.Dialog.ShowYesNoDlg(true, nil,
                Common.Utils.Lang("FashionEquipWarnning",
                        GetColorText(curItemInfo.itemRow.ItemName, RoColorTag.Blue),
                        GetColorText(tostring(point), RoColorTag.Green)),
                function()
                    Mgr.RequestStoreFashion(itemData.UID, itemData.TID, function()
                        self:PlayEffectJiaXing()
                    end)
                end)
    elseif Mgr._itemEnchanced(itemData) then
        local allData = {}
        local tempData = {}
        tempData.PropInfo = itemData
        tempData.IsShowCount = false
        table.insert(allData, tempData)
        CommonUI.Dialog.ShowConsumeDlg(Common.Utils.Lang("TIP"), Common.Utils.Lang("FashionTxt1", GetColorText(curItemInfo.itemRow.ItemName, RoColorTag.Blue)), function()
            Mgr.RequestStoreFashion(itemData.UID, itemData.TID, function()
                self:PlayEffectJiaXing()
            end)
        end, nil, allData)
    else
        Mgr.RequestStoreFashion(itemData.UID, itemData.TID, function()
            self:PlayEffectJiaXing()
        end)
    end
end

function GarderobeCtrl:PlayEffectJiaXing()
    if nil == self.panel then
        return
    end
    --一帧内同时setactive true false 组件接收不到enable disable事件
    if self.panel.EffectJiaXing.gameObject.activeSelf then
        return
    end
    if self.effectJiaXingTimer ~= nil then
        self:StopUITimer(self.effectJiaXingTimer)
        self.effectJiaXingTimer = nil
    end
    self.effectJiaXingTimer = self:NewUITimer(function()
        if self.panel ~= nil then
            self.panel.EffectJiaXing.gameObject:SetActiveEx(true)
            self.effectJiaXingTimer = nil
        end
    end, 0.01)
    self.effectJiaXingTimer:Start()
end

function GarderobeCtrl:OnStoreCellClicked(propInfo)
    self:StoreItem(propInfo)
    self.panel.PanelFashionStore.gameObject:SetActiveEx(false)
end

function GarderobeCtrl:EnterIdleState()
    --logGreen("EnterIdleState")
    l_animState = FASHION_ANIM_STATE.IDLE

    local animPath = attr.CommonIdleAnimPath
    if attr.EquipData ~= nil and attr.EquipData.FashionItemID > 0 then
        local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(attr.EquipData.FashionItemID, true)
        if fashionRow ~= nil and fashionRow.IdleAnim ~= nil then
            if fashionRow.IdleAnim[0] ~= nil then
                animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim[0])
            end
        end
    end

    l_remainTime = l_interval
    if model ~= nil then
        model.Ator:OverrideAnim("Idle", animPath)
        model.Ator:Play("Idle")
    end
end

function GarderobeCtrl:EnterShowState()
    --logGreen("EnterShowState")
    l_animState = FASHION_ANIM_STATE.SHOW
    l_remainTime = l_interval
    local animPath = attr.CommonIdleAnimPath
    if attr.EquipData ~= nil and attr.EquipData.FashionItemID > 0 then
        local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(attr.EquipData.FashionItemID, true)
        if fashionRow ~= nil and fashionRow.IdleAnim ~= nil then
            if #fashionRow.IdleAnim > 1 then
                animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim[1])
            else
                return
            end
        end
    end

    if model ~= nil then
        local animInfo = model.Ator:OverrideAnim("Idle", animPath)
        if animInfo ~= nil  then
            model.Ator:Play("Idle")
            l_remainTime = animInfo.Length
        end
    end
end

function GarderobeCtrl:RefreshAnim()
    self:EnterIdleState()
end

function GarderobeCtrl:OnCellClicked(index, itemInfo)
    if lastClickIndex == index then
        local active = self.panel.Information.gameObject.activeSelf
        self.panel.Information.gameObject:SetActiveEx(not active)
    end

    if itemInfo == nil then
        logError("ItemInfo is nil")
        return
    end
    self:ClearClickedCell()

    --获取cell
    self.gardrobeTemplatePool:SelectTemplate(index)
    if itemInfo.itemRow ~= nil then
        Mgr.UISelectItem.ItemID = itemInfo.itemRow.ItemID
    end

    Mgr.UISelectItem.Index = index

    lastClickIndex = index

    if itemInfo.garderobeType == Mgr.EGarderobeType.Ornament then
        if curItemInfo == itemInfo then
            if not Mgr.IsWearByItemId(curItemInfo.itemRow.ItemID) then
                if placeTogState == EOrnamentType.Back then
                    attr:SetOrnamentByIntType(EOrnamentType.Back, Mgr.GetOrnamentByType(EOrnamentType.Back))
                    attr:SetOrnamentByIntType(EOrnamentType.Tail, Mgr.GetOrnamentByType(EOrnamentType.Tail))
                else
                    attr:SetOrnamentByIntType(placeTogState, Mgr.GetOrnamentByType(placeTogState))
                end
            end
            curItemInfo = nil
        else
            curItemInfo = itemInfo
            if placeTogState == EOrnamentType.Back then
                attr:SetOrnamentByIntType(EOrnamentType.Back, 0)
                attr:SetOrnamentByIntType(EOrnamentType.Tail, 0)
            end
            attr:SetOrnament(itemInfo.itemRow.ItemID)
        end

        if model ~= nil then
            model:RefreshEquipData(attr.EquipData)
        end
    elseif itemInfo.garderobeType == Mgr.EGarderobeType.Fashion then
        if curItemInfo == itemInfo then
            curItemInfo = nil
            attr:SetFashion(Mgr.FashionRecord.wear_fashion or 0)
        else
            curItemInfo = itemInfo
            attr:SetFashion(itemInfo.itemRow.ItemID)
        end

        if model ~= nil then
            model:RefreshEquipData(attr.EquipData)
            self:RefreshAnim()
        end
    elseif itemInfo.garderobeType == Mgr.EGarderobeType.Eye then
        if curItemInfo == itemInfo then
            curItemInfo = nil
            attr:SetEye(MPlayerInfo.EyeID)
        else
            curItemInfo = itemInfo
            attr:SetEye(curItemInfo.row.EyeID)
        end

        if model ~= nil then
            model:RefreshEquipData(attr.EquipData)
        end
    elseif itemInfo.garderobeType == Mgr.EGarderobeType.Hair then
        if curItemInfo == itemInfo then
            curItemInfo = nil
            attr:SetHair(MPlayerInfo.HairStyle)
        else
            curItemInfo = itemInfo
            attr:SetHair(itemInfo.styleRow[hairColorIndex].BarberStyleID)
        end

        if model ~= nil then
            model:RefreshEquipData(attr.EquipData)
        end
    end

    Mgr.UISelectItem.Attr = attr
    self:RefreshLeftPanel()
    Mgr.EventDispatcher:Dispatch(Mgr.ON_GARDEROBE_ITEM_CLICK)

    if itemInfo.garderobeType == Mgr.EGarderobeType.Ornament then
        if table.ro_contains(Mgr.NewItemId, itemInfo.itemRow.ItemID) then
            self:RefreshToggleGroup()
        end
    end
end

function GarderobeCtrl:GetItemPropertyStr(itemId)
    local str = ""
    local strTable = MgrMgr:GetMgr("ForgeMgr").GetForgeDisplayAttrs(itemId)
    if strTable ~= nil then
        for i, v in ipairs(strTable) do
            if i > 1 then
                str = str .. "\n"
            end

            str = str .. v
        end
    end

    return str
end

function GarderobeCtrl:RefreshLeftPanel()
    self.panel.ImgEffectCollection.gameObject:SetActiveEx(self:_checkGuild())
    if curItemInfo == nil then
        self.panel.LeftPanel.gameObject:SetActiveEx(false)
        return
    else
        if curItemInfo.itemRow == nil then
            self.panel.LeftPanel.gameObject:SetActiveEx(true)
        else
            self.panel.ItemName2.LabText = Common.Utils.Lang("FashionTxt2", GetColorText(curItemInfo.itemRow.ItemName, RoColorTag.Blue))
            self.panel.LeftPanel.gameObject:SetActiveEx(true)
        end
    end

    local onGmClick = function()
        self:_onClickGmGet()
    end

    local showGM = MGameContext.IsOpenGM and nil ~= C_GM_FACE_STATE[curItemInfo.garderobeType]
    self.panel.Btn_GM_GET.gameObject:SetActiveEx(showGM)
    self.panel.Btn_GM_GET:AddClick(onGmClick)
    self:RefreshTips()
end

--- GM命令获取对应的发型和眼睛，包括颜色
function GarderobeCtrl:_onClickGmGet()
    if nil == curItemInfo then
        logError("[Wardrobe] param got nil")
        return
    end

    if Mgr.EGarderobeType.Hair == curItemInfo.garderobeType then
        local hairID = curItemInfo.styleRow[hairColorIndex].BarberStyleID
        MgrProxy:GetWardrobeGmMgr().ReqGmChangeHair(hairID)
    elseif Mgr.EGarderobeType.Eye == curItemInfo.garderobeType then
        local eyeColorIdx = colorIndex
        local eyeID = curItemInfo.row.EyeID
        local msg = {
            eye_id = eyeID,
            eye_style_id = eyeColorIdx,
        }

        MgrProxy:GetWardrobeGmMgr().ReqGmChangeEye(msg)
    else
        logError("[Wardrobe] invalid state: " .. tostring(curItemInfo.garderobeType))
        return
    end
end

function GarderobeCtrl:RefreshTips()
    if curItemInfo == nil then
        return
    end

    self.panel.Information.gameObject:SetActiveEx(true)

    self.panel.SwitchTog.gameObject:SetActiveEx(false)
    if curItemInfo.garderobeType == Mgr.EGarderobeType.Eye or
            curItemInfo.garderobeType == Mgr.EGarderobeType.Hair then
        self.panel.CollectionPoint.gameObject:SetActiveEx(false)
        self.panel.PropertyInfo.gameObject:SetActiveEx(false)
        self.panel.FormulaInfo.gameObject:SetActiveEx(false)
    end

    self.panel.TxtInfo.gameObject:SetActiveEx(false)
    self.panel.PanelLock.gameObject:SetActiveEx(false)
    if curItemInfo.garderobeType == Mgr.EGarderobeType.Eye
        or curItemInfo.garderobeType == Mgr.EGarderobeType.Hair then
        local l_name = curItemInfo.garderobeType == Mgr.EGarderobeType.Eye and curItemInfo.row.EyeName or curItemInfo.row.BarberName
        self.panel.TxtName_EyeHair.LabText = "[" .. l_name .. "]"
        self.panel.TxtName_EyeHair.gameObject:SetActiveEx(true)
        self.panel.TxtName_Ornament.gameObject:SetActiveEx(false)
        self.panel.ColourContent.gameObject:SetActiveEx(true)
    else
        local limit = MgrMgr:GetMgr("HeadShopMgr").CheckLimit(curItemInfo.itemRow.ItemID)
        self.panel.PanelLock.gameObject:SetActiveEx(limit)


        local str = self:GetItemPropertyStr(curItemInfo.itemRow.ItemID)
        if str == "" then
            self.panel.PropertyInfo.gameObject:SetActiveEx(false)
        else
            self.panel.PropertyInfo.gameObject:SetActiveEx(true)
            str = string.gsub(str, "[ \n]+$", "") .. "\n"
            self.panel.PropertyTxt.LabText = str
            Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.PropertyTxt)
        end

        self.panel.CollectionPoint:SetGray(not Mgr.IsStoreFashion(curItemInfo.itemRow.ItemID) and not Mgr.IsExisInEquip(curItemInfo.itemRow.ItemID))
        self.panel.CollectionPoint.gameObject:SetActiveEx(true)

        self.panel.TxtName_Ornament.LabText = "[" .. curItemInfo.itemRow.ItemName .. "]"
        self.panel.TxtName_EyeHair.gameObject:SetActiveEx(false)
        self.panel.TxtName_Ornament.gameObject:SetActiveEx(true)
        self.panel.TxtInfoFashion.LabText = Mgr.GetFashionPoint(curItemInfo.itemRow.ItemID)
        self.panel.ColourContent.gameObject:SetActiveEx(false)

        local itemCost = Mgr.GetOrnamentBarterItemByItemId(curItemInfo.itemRow.ItemID)
        local InfoDatas = {}
        for _, itemData in ipairs(itemCost) do
            local data = {}
            data.ID = itemData.ItemId
            data.IsShowCount = false
            data.IsShowRequire = true
            data.RequireCount = itemData.Count
            data.IsLock = limit
            data.IsGray = limit
            table.insert(InfoDatas, data)
        end

        self.gardrobeTemplateInfoPool:ShowTemplates({
            Datas = InfoDatas
        })

        local tipShow = (#InfoDatas > 0)
        self.panel.FormulaInfo.gameObject:SetActiveEx(tipShow)
    end

    self:RefreshTipsBtn()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Information.RectTransform)
end

function GarderobeCtrl:RefreshTipsBtn()
    if curItemInfo == nil then
        self.panel.Information.gameObject:SetActiveEx(false)
        return
    end

    self.panel.ImgApply.gameObject:SetActiveEx(false)
    self.panel.BtnApply.gameObject:SetActiveEx(false)
    self.panel.BtnFashionApply.gameObject:SetActiveEx(false)
    self.panel.BtnCancel.gameObject:SetActiveEx(false)
    self.panel.BtnGet.gameObject:SetActiveEx(false)
    self.panel.BtnGetOld.gameObject:SetActiveEx(false)
    self.panel.BtnStore.gameObject:SetActiveEx(false)
    self.panel.BtnMark1.gameObject:SetActiveEx(false)
    self.panel.BtnOut.gameObject:SetActiveEx(false)
    self.panel.TxtEquiping.gameObject:SetActiveEx(false)

    if curItemInfo.garderobeType == Mgr.EGarderobeType.Ornament
            or curItemInfo.garderobeType == Mgr.EGarderobeType.Fashion then
        self.panel.ImgApply.gameObject:SetActiveEx(Mgr.IsExisInEquip(curItemInfo.itemRow.ItemID))
        self.panel.BtnGotoHair.gameObject:SetActiveEx(false)
        self.panel.BtnGotoEye.gameObject:SetActiveEx(false)
        local status = Mgr.GetFashionStatus(curItemInfo.itemRow.ItemID)
        --logError("status : "..status.." curItemInfo.garderobeType : "..curItemInfo.garderobeType)
        if curItemInfo.garderobeType == Mgr.EGarderobeType.Ornament
                or curItemInfo.garderobeType == Mgr.EGarderobeType.Fashion  then
            if status == Mgr.EFashionStatusForUI.NotExist then
                self.panel.BtnGetOld.gameObject:SetActiveEx(true)
            elseif status == Mgr.EFashionStatusForUI.GoStore then
                self.panel.BtnGet.gameObject:SetActiveEx(true)
                self.panel.BtnStore.gameObject:SetActiveEx(true)
                self.panel.BtnMark1.gameObject:SetActiveEx(true)
            elseif status == Mgr.EFashionStatusForUI.Equiping then
                self.panel.BtnGet.gameObject:SetActiveEx(true)
                self.panel.TxtEquiping.gameObject:SetActiveEx(true)
            elseif status == Mgr.EFashionStatusForUI.Storing then
                if Mgr.IsOwnByItemId(curItemInfo.itemRow.ItemID) then
                    if Mgr.IsWearByItemId(curItemInfo.itemRow.ItemID) then
                        self.panel.BtnGet.gameObject:SetActiveEx(true)
                        self.panel.BtnCancel.gameObject:SetActiveEx(true)
                    else
                        self.panel.BtnGet.gameObject:SetActiveEx(true)
                        self.panel.BtnApply.gameObject:SetActiveEx(true)
                        self.panel.BtnOut.gameObject:SetActiveEx(true)
                    end
                else
                    self.panel.BtnApply.gameObject:SetActiveEx(true)
                    self.panel.BtnOut.gameObject:SetActiveEx(true)
                end
            end
        --else
        --    if status == Mgr.EFashionStatusForUI.NotExist then
        --        self.panel.BtnGetOld.gameObject:SetActiveEx(true)
        --    elseif status == Mgr.EFashionStatusForUI.Storing then
        --        if Mgr.IsWearByItemId(curItemInfo.itemRow.ItemID) then
        --            self.panel.BtnGet.gameObject:SetActiveEx(true)
        --            self.panel.BtnCancel.gameObject:SetActiveEx(true)
        --        else
        --            self.panel.BtnGet.gameObject:SetActiveEx(true)
        --            self.panel.BtnFashionApply.gameObject:SetActiveEx(true)
        --        end
        --    end
        end

    elseif curItemInfo.garderobeType == Mgr.EGarderobeType.Eye
            or curItemInfo.garderobeType == Mgr.EGarderobeType.Hair then
        self.panel.BtnApply.gameObject:SetActiveEx(false)
        self.panel.BtnCancel.gameObject:SetActiveEx(false)
        self.panel.BtnGet.gameObject:SetActiveEx(false)

        if curItemInfo.garderobeType == Mgr.EGarderobeType.Eye then
            self.panel.BtnGotoHair.gameObject:SetActiveEx(false)
            self.panel.BtnGotoEye.gameObject:SetActiveEx(true)
        elseif curItemInfo.garderobeType == Mgr.EGarderobeType.Hair then
            self.panel.BtnGotoHair.gameObject:SetActiveEx(true)
            self.panel.BtnGotoEye.gameObject:SetActiveEx(false)
        end
    end

end

function GarderobeCtrl:RefreshColor()
    if curItemInfo ~= nil then
        if placeTogState == EOrnamentType.Eye then
            self.panel.EyeColorInfo.gameObject:SetActiveEx(true)
            self.panel.HeadColorInfo.gameObject:SetActiveEx(false)
            attr:SetEyeColor(colorIndex)
            if model ~= nil then
                model:RefreshEquipData(attr.EquipData)
            end
        elseif placeTogState == EOrnamentType.Hair then
            self.panel.EyeColorInfo.gameObject:SetActiveEx(false)
            self.panel.HeadColorInfo.gameObject:SetActiveEx(true)

            if attr.EquipData.HairStyleID then
                local l_item = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(attr.EquipData.HairStyleID, true)
                if l_item then
                    local allStyle = TableUtil.GetBarberStyleTable().GetTable()
                    local idToStyleRows = {}
                    for _, row in ipairs(allStyle) do
                        if row and row.BarberID == l_item.BarberID then
                            idToStyleRows[row.Colour] = row
                        end
                    end
                    if idToStyleRows[hairColorIndex] then
                        attr:SetHair(idToStyleRows[hairColorIndex].BarberStyleID)
                    end
                end
            end

            if model ~= nil then
                model:RefreshEquipData(attr.EquipData)
            end
        end
    end
end

function GarderobeCtrl:ShowCollectionInfo(isShow)
    --self.panel.TxtGarderobeRewardFashion.LabText = Mgr.FashionRecord.fashion_count
    --
    --self.garderobeRewardTemplateInfoPool:ShowTemplates({
    --    Datas = Mgr.GetGarderobeAwardData(),
    --})
    --self.panel.PanelReward.gameObject:SetActiveEx(isShow)
    local l_functionId =MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GarderobeAward
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(l_functionId))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.GarderobeFashion, function(ctrl)
        ctrl:SetFashionNumber(Mgr.FashionRecord.fashion_count)
    end)
end

function GarderobeCtrl:ShowCollectionInfoByGardeorbeAwardId(gardeorbeAwardId)
    local l_functionId =MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GarderobeAward
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(l_functionId))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.GarderobeFashion, function(ctrl)
        ctrl:SelectAttrById(gardeorbeAwardId)
    end)
end

-- 通过典藏值打开奖励面板
function GarderobeCtrl:OpenRewardPanelByGarderobePoint(gardeorbeAwardId)
    self:ShowCollectionInfoByGardeorbeAwardId(gardeorbeAwardId)
    local l_item = self.garderobeRewardTemplateInfoPool:FindShowTem(function(item)
        return item:GetGarderobePoint() == gardeorbePoint
    end)
    if l_item then
        self.garderobeRewardTemplateInfoPool:ScrollToCell(l_item.ShowIndex, 2000)
    end
end

function GarderobeCtrl:RefreshCollectionView()
    self.panel.TxtCollection1.LabText = 0
    self.panel.TxtCollection2.LabText = 0
    self.panel.TxtCollection3.LabText = 0

    self.panel.ImgEffectCollection.gameObject:SetActiveEx(self:_checkGuild())

    self.panel.TxtCollection4.LabText = Mgr.GetFashionCount()
    self.panel.FashionPointTxt2.LabText = Mgr.FashionRecord.fashion_count

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.FashionAward)
end

function GarderobeCtrl:PlayFx(id, boneParent)
    self:ClearFx()
    local fxData = MFxMgr:GetDataFromPool()
    fxData.layer = model.Layer
    fxData.loadedCallback = function()
        MUIModelManagerEx:RefreshModel(model)
    end

    l_fx = model:CreateFx(id, boneParent, fxData)
    self:SaveEffetcData(l_fx)
    MFxMgr:ReturnDataToPool(fxData)
end

function GarderobeCtrl:ClearFx()
    if l_fx ~= nil then
        self:DestroyUIEffect(l_fx)
        l_fx = nil
    end
end

function GarderobeCtrl:OnCellBeDisplayed(ornamentID)
    local index, itemInfo = Mgr.GetIndexAndOrnamentTypeByItemID(ornamentID)
    if index ~= -1 and itemInfo ~= nil then
        currentSelectIndex = index
        if itemInfo.row.OrnamentType == EOrnamentType.Head then
            self.panel.TogHead.gameObject:GetComponent("UIToggleEx").isOn = false
            self.panel.TogHead.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Face then
            self.panel.TogFace.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Mouth then
            self.panel.TogMouth.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Back or itemInfo.row.OrnamentType == EOrnamentType.Tail then
            self.panel.TogBack.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Fashion then
            self.panel.TogFashion.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Hair then
            self.panel.TogHair.gameObject:GetComponent("UIToggleEx").isOn = true
        elseif itemInfo.row.OrnamentType == EOrnamentType.Eye then
            self.panel.TogEye.gameObject:GetComponent("UIToggleEx").isOn = true
        end

        self:OnCellClicked(index, itemInfo)
    end
end

function GarderobeCtrl:SetRightScrollViewPos(state)
    -- 0表示 （可收纳、已强化）显示， scrollview下移
    -- 1表示（可收纳、已强化）不显示， scrollview上移
    -- https://www.tapd.cn/20332331/prong/stories/view/1120332331001055829
    if state == 0 then
        self.panel.GardrobeScroll.gameObject:SetRectTransformPosY(150)
        self.panel.GardrobeScroll.gameObject:SetRectTransformHeight(400)
    elseif state == 1 then
        self.panel.GardrobeScroll.gameObject:SetRectTransformPosY(200)
        self.panel.GardrobeScroll.gameObject:SetRectTransformHeight(480)
    end
end

-- 设置典藏值奖励光效
function GarderobeCtrl:CreateEffectCollection()
    if self.effectCollectionID then
        return
    end
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ImgEffectCollection.RawImg
    l_fxData.loadedCallback = function(go)
        go.transform:SetLocalScale(6, 6, 6)
        self.panel.ImgEffectCollection.gameObject:SetActiveEx(self:_checkGuild())
    end
    self.effectCollectionID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YiChu2", l_fxData)

end

-- 销毁典藏值奖励光效
function GarderobeCtrl:DestoryEffectCollection()
    if self.effectCollectionID and self.effectCollectionID ~= 0 then
        self:DestroyUIEffect(self.effectCollectionID)
        self.effectCollectionID = nil
    end
end

-- 设置全屏光效
function GarderobeCtrl:CreateEffectLight()
    if self.effectLightID then
        return
    end
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ImgEffectLight.RawImg
    l_fxData.loadedCallback = function(go)
        go.transform:SetLocalScale(2, 2, 2)
    end
    self.effectLightID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YiChu", l_fxData)

end

-- 销毁全屏光效
function GarderobeCtrl:DestoryEffectLight()
    if self.effectLightID and self.effectLightID ~= 0 then
        self:DestroyUIEffect(self.effectLightID)
        self.effectLightID = nil
    end
end

-- 设置左下角环绕光效
function GarderobeCtrl:CreateEffectLeftDown()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ImgEffectLeftDown.RawImg
    l_fxData.loadedCallback = function(go)
        go.transform:SetLocalScale(6, 6, 6)
    end
    self.effectLeftDownID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge2", l_fxData)

end

-- 销毁左下角环绕光效
function GarderobeCtrl:DestoryEffectLeftDown()
    if self.effectLeftDownID and self.effectLeftDownID ~= 0 then
        self:DestroyUIEffect(self.effectLeftDownID)
        self.effectLeftDownID = nil
    end
end

return GarderobeCtrl
--lua custom scripts end
