--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HeadShopPanel"

require "UI/Template/HeadShopItemTemplete"
require "UI/Template/ItemTemplate"

require "Common/Utils"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
local lastClickIndex = 1
HeadShopCtrl = class("HeadShopCtrl", super)
--lua class define end

local table_insert = table.insert

local l_limitType = 8
local l_modelPlayer
local l_modelItem

local LimitMgr = MgrMgr:GetMgr("LimitMgr")
local HeadShopMgr = MgrMgr:GetMgr("HeadShopMgr")
local l_cachedNpcOrnaments = nil
local conditionGOTable = {}
local FindObjectInChild = function(...)
    return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end

--lua functions
function HeadShopCtrl:ctor()

    super.ctor(self, CtrlNames.HeadShop, UILayer.Function, nil, ActiveType.Exclusive)
    self.forceCustomHideUI = { CtrlNames.Activity }
end --func end
--next--
function HeadShopCtrl:Init()

    self.panel = UI.HeadShopPanel.Bind(self)
    super.Init(self)

    conditionGOTable = {}
    self.panel.BtClose:AddClick(self.CloseUI)
    table.insert(conditionGOTable, self.panel.Condition1)
    table.insert(conditionGOTable, self.panel.Condition2)
    table.insert(conditionGOTable, self.panel.Condition3)
    table.insert(conditionGOTable, self.panel.Condition4)
    table.insert(conditionGOTable, self.panel.Condition5)
    table.insert(conditionGOTable, self.panel.Condition6)

    self.panel.BtOp:AddClick(function()
        self:OnExchange()
    end)

    self.panel.Collider:AddClick(function()
        -- do nothing
    end)

    local l_headshopItem = self.panel.HeadShopItem.gameObject
    l_headshopItem:SetActiveEx(false)

    self.ornamentPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.HeadShopItemTemplete,
        --TemplateParent = self.panel.Content.transform,
        ScrollRect = self.panel.HeadScrollView.LoopScroll,
        TemplatePrefab = l_headshopItem
    })

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.CostPanel.LoopScroll,
    })

    self:SetBubbleContent("")
    self.playerLevel = MPlayerInfo.Lv

    self.ornamentsConfig = nil
    self.ornamentDatas = nil
    self.npcId = nil
    HeadShopMgr.SelectOrnamentId = 0

    self.hasInitDraglistenner = nil
    self.isShowOverview = nil

    self.firstRefresh = true

    self.activeState = nil

    self.initData = false

    self:HideOverview()
    l_attr = nil
end --func end
--next--
function HeadShopCtrl:Uninit()
    self.ornamentsConfig = nil
    self.ornamentDatas = nil
    self.npcId = nil
    HeadShopMgr.SelectOrnamentId = 0

    self.initData = false

    self.hasInitDraglistenner = nil

    self.isShowOverview = nil

    self.activeState = nil

    self.ornamentPool = nil

    self.itemPool = nil

    if l_modelPlayer then
        self:DestroyUIModel(l_modelPlayer)
        l_modelPlayer = nil
    end

    if l_modelItem then
        self:DestroyUIModel(l_modelItem)
        l_modelItem = nil
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end

    if self.delayTimer then
        self:StopUITimer(self.delayTimer)
        self.delayTimer = nil
    end

    l_cachedNpcOrnaments = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HeadShopCtrl:OnActive()

    if not self.initData then
        self.initData = true
        self:InitShopData()
    end

    self:FocusToNpc()
    MgrMgr:GetMgr("HeadShopMgr").RequestLimitData(self.npc_id)
    self.activeState = true

    self:HeadShopPanelRefresh()
end --func end

function HeadShopCtrl:OnShow()

    self:RefreshInfomation()

    self:UpdateNpcOrnament()
end


--next--
function HeadShopCtrl:OnDeActive()

    MPlayerInfo:FocusToMyPlayer()
    self:ResetNpcOrnament()

    self.activeState = false
end --func end
--next--
function HeadShopCtrl:Update()

    local l_activeState = false
    for i, v in ipairs(self.forceCustomHideUI) do
        if UIMgr:IsActiveUI(v) then
            l_activeState = true
            break
        end
    end

    if self.activeState == l_activeState then
        if self.activeState then
            self:CustomHideUI()
        else
            self:CustomShowUI()
        end

        self.activeState = not self.activeState
    end
end --func end


--next--
function HeadShopCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("HeadShopMgr").EventDispatcher, MgrMgr:GetMgr("HeadShopMgr").ON_EXCHANGE_ORNAMENT, function()
        self:HeadShopPanelRefresh()
    end)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher,MgrProxy:GetGameEventMgr().OnDailyTaskClose,self._onDailyTaskClose,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function HeadShopCtrl:HeadShopPanelRefresh()

    if not self.ornamentDatas then
        return
    end

    self:RefreshShop()

    self:RefreshInfomation()

    self:UpdateNpcOrnament()
end

function HeadShopCtrl:CloseUI()

    UIMgr:DeActiveUI(UI.CtrlNames.HeadShop)
end

function HeadShopCtrl:ClearClickedCell()
    if lastClickIndex ~= -1 then
        local itemLastClick = self.ornamentPool:GetItem(lastClickIndex)
        if itemLastClick ~= nil then
            itemLastClick:ShowFrame(false)
        end
    end
end

function HeadShopCtrl:SelectOrnament(id, index)
    if HeadShopMgr.SelectOrnamentId == id then
        return
    end

    self:ClearClickedCell()
    local item = self.ornamentPool:GetItem(index)
    item:ShowFrame(true)
    HeadShopMgr.SelectOrnamentId = id
    self:RefreshInfomation()
    self:UpdateNpcOrnament()
    lastClickIndex = index
end

function HeadShopCtrl:OnExchange()

    if HeadShopMgr.SelectOrnamentId <= 0 then
        return
    end

    local l_locked = MgrMgr:GetMgr("HeadShopMgr").IsLocked(HeadShopMgr.SelectOrnamentId)
    if l_locked then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HEAD_SHOP_LOCKED"))
        return
    end

    local l_limited = self:IsLimited(HeadShopMgr.SelectOrnamentId)
    if l_limited then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HEAD_SHOP_LIMITED"))
        return
    end

    local l_resLack, l_lackItem, l_lakeNum, l_needCoin = self:IsResourceNotEnough(HeadShopMgr.SelectOrnamentId)
    if l_resLack and l_lackItem and l_lackItem ~= GameEnum.l_virProp.Coin101 and l_lackItem ~= GameEnum.l_virProp.Coin102 then
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_lackItem)
        if not l_itemRow then
            logError(StringEx.Format("头饰id对应的消耗材料不存在@韩艺鸣 id:{0}", l_lackItem))
            return
        end

        log(StringEx.Format("缺少道具 id:{0} 道具名:{1}", l_lackItem, l_itemRow.ItemName))
        local locItem = Data.BagModel:CreateItemWithTid(l_lackItem)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(locItem, self.panel.Anchor.transform, nil, nil, true, { relativePositionY = 28 })
        return
    end

    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(HeadShopMgr.SelectOrnamentId)
    if not l_row then
        logError(StringEx.Format("头饰配置不存在 {0}", HeadShopMgr.SelectOrnamentId))
        return
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil,
            Common.Utils.Lang("CONFIRM_EXCHANGE", l_row.OrnamentName),
            function()
                if l_lackItem and (l_lackItem == GameEnum.l_virProp.Coin101 or l_lackItem == GameEnum.l_virProp.Coin102) then
                    MgrMgr:GetMgr("HeadShopMgr").RequestExchangeHeadGear(HeadShopMgr.SelectOrnamentId,l_needCoin)
                else
                    MgrMgr:GetMgr("HeadShopMgr").RequestExchangeHeadGear(HeadShopMgr.SelectOrnamentId)
                end
            end)
end

function HeadShopCtrl:RefreshShop()
    local startIndex = 1
    lastClickIndex = startIndex
    for i, data in ipairs(self.ornamentDatas) do
        local l_limited = self:IsLimited(data.ID)
        local l_locked = MgrMgr:GetMgr("HeadShopMgr").IsLocked(data.ID)
        local l_lackRes = self:IsResourceNotEnough(data.ID)

        local l_limitCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemLimitCount(l_limitType, data.ID)
        local l_canBuyCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(l_limitType, data.ID)

        if not HeadShopMgr.SelectOrnamentId or HeadShopMgr.SelectOrnamentId <= 0 then
            HeadShopMgr.SelectOrnamentId = data.ID
        end
        if HeadShopMgr.SelectOrnamentId == data.ID then
            lastClickIndex = i
        end
        data.locked = l_locked
        data.limited = l_limited
        data.lack_res = l_lackRes
        if l_limitCount ~= -1 then
            data.canBuyCount = l_canBuyCount
        else
            data.canBuyCount = nil
        end

        data.index = i
    end

    if not self.hasInitDraglistenner then
        self.hasInitDraglistenner = true

        self:InitDragListener()
    end


    self.ornamentPool:ShowTemplates({ Datas = self.ornamentDatas,
                                      StartScrollIndex = startIndex,
                                      Method = function(id, index)
                                          self:SelectOrnament(id, index)
                                      end })
end

--local item = {}
-- item["limitType"] = ELimitType.ACHIEVEMENT_LIMIT
-- item.str = ""
function HeadShopCtrl:ProcessLimitGO(gameObject, item)
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
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, item.limitLevel)
        end
    end)
end

function HeadShopCtrl:RefreshInfomation()
    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(HeadShopMgr.SelectOrnamentId)
    if not l_row then
        logError(StringEx.Format("找不到头饰ID,理论上不可能 ID:{0}", tostring(HeadShopMgr.SelectOrnamentId)))
        return
    end

    if self.firstRefresh then
        self.firstRefresh = false
    else
        self:SetBubbleContent(l_row.NpcDialog)
    end

    local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(HeadShopMgr.SelectOrnamentId)
    if not l_itemInfo then
        logError(StringEx.Format("改头饰对应道具找不到@韩艺鸣 ID:{0}", HeadShopMgr.SelectOrnamentId))
        return
    end
    self.panel.ModelName.LabText = l_itemInfo.ItemName
    -- 刷新头饰显示
    self.panel.RefineName.LabText = l_itemInfo.ItemName

    self:RefreshItemModel()


    -- 刷新限制条件显示
    local l_limited, l_limitedInfo = self:IsLimited(HeadShopMgr.SelectOrnamentId, true)
    local l_locked, l_lockedInfo = MgrMgr:GetMgr("HeadShopMgr").IsLocked(HeadShopMgr.SelectOrnamentId, true)
    -- logError(tostring(l_limitedInfo) .. tostring(l_lockedInfo))
    if l_locked then
        local l_str_tbl = MgrMgr:GetMgr("HeadShopMgr").GetLimitStr(HeadShopMgr.SelectOrnamentId)

        if #l_str_tbl > DataMgr:GetData("HeadShopData").MaxLimitCondition and #l_str_tbl < 1 then
            logError("Condition OverFlow")
            self.panel.Unlocked.gameObject:SetActiveEx(false)
        else
            self.panel.Unlocked.gameObject:SetActiveEx(true)
            for i = 1, DataMgr:GetData("HeadShopData").MaxLimitCondition do
                -- logError(type(l_str_tbl[i]))
                if l_str_tbl[i] ~= nil then
                    self:ProcessLimitGO(conditionGOTable[i].gameObject, l_str_tbl[i])
                else
                    conditionGOTable[i].gameObject:SetActiveEx(false)
                end
            end
        end
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Unlocked.RectTransform)
        -- logError(#l_str_tbl)
        -- if #l_str_tbl > 0 then
        --     local data = {}
        --     for _,item in ipairs(l_str_tbl) do
        --         table.insert(data,item.str)
        --     end
        --     self.panel.UnlockedText.LabText = table.concat(data, '\n')
        -- end


    else
        -- if l_limitedInfo then
        --  self.panel.UnlockedText.LabText = l_limitedInfo
        --  self.panel.Unlocked.gameObject:SetActiveEx(true)
        -- else
        self.panel.Unlocked.gameObject:SetActiveEx(false)
        -- end
    end

    -- 刷新资源消耗
    local l_lackRes = false
    local l_cost_datas = {}
    local l_costs = Common.Functions.VectorSequenceToTable(l_row.ItemCost)
    for i, v in ipairs(l_costs) do
        local l_curCount = Data.BagModel:GetCoinOrPropNumById(v[1])
        table_insert(l_cost_datas, {
            ID = v[1],
            Count = l_curCount,
            IsShowRequire = true,
            RequireCount = v[2],
            IsShowCount = false,
        })
        -- logError(StringEx.Format("test {0} {1} {2}", l_curCount, v[2], tostring(l_lackRes)))
        if l_curCount < v[2] then
            l_lackRes = true
        end
    end

    self.itemPool:ShowTemplates({ Datas = l_cost_datas })
    if l_limited or l_locked then
        self.panel.BtOp.gameObject:SetActiveEx(false)
        self.panel.LimitStr.gameObject:SetActiveEx(true)
    else
        self.panel.BtOp.gameObject:SetActiveEx(true)
        self.panel.LimitStr.gameObject:SetActiveEx(false)
    end

    if self.isShowOverview then
        self:RefreshPlayerModel()
    end
end

function HeadShopCtrl:ShowOverview()
    self.panel.PlayerPreview.gameObject:SetActiveEx(true)
    self:RefreshPlayerModel()

    self.isShowOverview = true
end

function HeadShopCtrl:HideOverview()
    self.panel.PlayerPreview.gameObject:SetActiveEx(false)

    self.isShowOverview = nil

    if l_modelPlayer then
        self:DestroyUIModel(l_modelPlayer)
        l_modelPlayer = nil
    end
end

-- 设置玩家模型
function HeadShopCtrl:RefreshPlayerModel()

    local l_attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), "HeadShopCtrl", MPlayerInfo.ProID, MPlayerInfo.IsMale, nil)
    l_attr:SetHair(MPlayerInfo.HairStyle)
    l_attr:SetFashion(MPlayerInfo.Fashion)
    l_attr:SetOrnament(HeadShopMgr.SelectOrnamentId)-- MPlayerInfo.OrnamentHead)
    l_attr:SetOrnament(MPlayerInfo.OrnamentFace)
    l_attr:SetOrnament(MPlayerInfo.OrnamentMouth)
    l_attr:SetOrnament(MPlayerInfo.OrnamentBack)
    l_attr:SetOrnament(MPlayerInfo.OrnamentTail)
    l_attr:SetEyeColor(MPlayerInfo.EyeColorID)
    l_attr:SetEye(MPlayerInfo.EyeID)
    l_attr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    -- l_attr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    l_attr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)

    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImage.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)

    l_modelPlayer = self:CreateUIModel(l_fxData)
    l_modelPlayer:AddLoadModelCallback(function(m)
        self.panel.ModelImage.gameObject:SetActiveEx(true)
    end)
    local listener = self.panel.ModelTouchArea:GetComponent("MLuaUIListener")
    listener.onDrag = function(uobj, event)
        l_modelPlayer.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
    end

end

-- 检查资源是否足够兑换
-- true 道具id 缺失数量
-- false
function HeadShopCtrl:IsResourceNotEnough(id)
    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(id)
    if not l_row then
        logError(StringEx.Format("不可能存在的错误,之前筛选的表格数据找不到了 ornament_id:{0}", id))
        return true
    end

    local l_costs = Common.Functions.VectorSequenceToTable(l_row.ItemCost)
    for i, v in ipairs(l_costs) do
        local l_curCount = Data.BagModel:GetCoinOrPropNumById(v[1])
        local l_needCount = v[2]
        if l_needCount > l_curCount then
            return true, v[1], (l_needCount - l_curCount),l_needCount
        end
    end

    return false
end

-- 检查头饰是否已达到兑换上限
function HeadShopCtrl:IsLimited(id, need_infomation)
    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(id)
    if not l_row then
        logError(StringEx.Format("不可能存在的错误,之前筛选的表格数据找不到了 ornament_id:{0}", id))
        return
    end

    local l_limited = true

    local l_limitCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemLimitCount(l_limitType, id)
    local l_buyCount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(l_limitType, id)
    -- log(StringEx.Format("{0} {1}", l_limitCount, l_buyCount))
    -- -1 代表不限制(通用逻辑)
    if l_limitCount == -1 then
        return false
    elseif l_buyCount > 0 then
        l_limited = false
    end

    if not need_infomation then
        return l_limited
    end

    if l_limited then
        return l_limited, Common.Utils.Lang("UPPER_LIMIT_EXCHANGE")
    else
        return l_limited, Common.Utils.Lang("REMAINDER_EXCHANGE", l_buyCount, l_limitCount)
    end
end

function HeadShopCtrl:InitDragListener()
    --如果数量大于4，设置可拖动并且显示箭头
    if #self.ornamentDatas > 4 then
        self.panel.HeadScrollView.LoopScroll.enabled = true
    else
        self.panel.HeadScrollView.LoopScroll.enabled = false
        self.panel.ArrowRight.gameObject:SetActiveEx(false)
        self.panel.ArrowLeft.gameObject:SetActiveEx(false)
    end
end

function HeadShopCtrl:GetPosByType(itemType)
    if itemType == 7 then
        return 0.9
    elseif itemType == 8 then
        return 1.25
    elseif itemType == 9 then
        return 1.7
    elseif itemType == 10 then
        return 1.25
    end
    return 0.5
end

function HeadShopCtrl:RefreshItemModel()
    local item_id = HeadShopMgr.SelectOrnamentId

    if l_modelItem then
        self:DestroyUIModel(l_modelItem)
        l_modelItem = nil
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end

    if self.delayTimer then
        self:StopUITimer(self.delayTimer)
        self.delayTimer = nil
    end

    self.panel.ItemlImage.gameObject:SetActiveEx(false)
    local l_modelData = {
        itemId = item_id,
        rawImage = self.panel.ItemlImage.RawImg
    }
    l_modelItem = self:CreateUIModelByItemId(l_modelData)
    l_modelItem:AddLoadModelCallback(function(m)

        local l_posY = 0.9
        local l_equipRow = TableUtil.GetEquipTable().GetRowById(item_id)
        if l_equipRow then
            l_posY = self:GetPosByType(l_equipRow.EquipId)
            if l_equipRow.EquipId >= 7 and l_equipRow.EquipId <= 10 then
                self:ShowHeadModel(l_modelItem, l_posY)
            else
                self:ShowDefault(l_modelItem)
            end
        else
            self:ShowHeadModel(l_modelItem, l_posY)
        end

        self.tween = l_modelItem.Trans:DOLocalRotate(Vector3.New(l_modelItem.Trans.localEulerAngles.x, 360, 0), 4)
        self.tween:SetLoops(-1, DG.Tweening.LoopType.Incremental)
        self.tween:SetEase(DG.Tweening.Ease.Linear)

        local l_locked = MgrMgr:GetMgr("HeadShopMgr").IsLocked(HeadShopMgr.SelectOrnamentId)
        if l_locked then
            self.tween:Pause()
        end

        self.delayTimer = self:NewUITimer(function()
            self.panel.ItemlImage.gameObject:SetActiveEx(true)
            self.delayTimer = nil
        end, 0.01)
        self.delayTimer:Start()
    end)
end

function HeadShopCtrl:SetBubbleContent(content)
    if content and string.len(content) > 0 then
        self.panel.TextMessage.LabText = content
        self.panel.Bubble.gameObject:SetActiveEx(true)
    else
        self.panel.Bubble.gameObject:SetActiveEx(false)
    end
end

function HeadShopCtrl:InitShopData()

    self.npcId = self.uiPanelData.npcId
    HeadShopMgr.SelectOrnamentId = self.uiPanelData.ornamentId

    if not self.npcId then
        logError("获取npcid失败,不是通过对话框打开的可能会导致这个问题")
        -- force quit?
        self:CloseUI()
        return
    end

    -- 获取npc头饰商店配置
    local l_ornaments = MgrMgr:GetMgr("HeadShopMgr").GetOrnamentsByNpcId(self.npcId)
    local l_ornamentCount = #l_ornaments
    if l_ornamentCount <= 0 then
        logError(StringEx.Format("对应npc找不到头饰兑换配置@韩艺鸣 npc_id:{0}", self.npcId))
        -- force quit?
        self:CloseUI()
        return
    end

    self.ornamentsConfig = l_ornaments

    self.ornamentDatas = {}
    for i, ornament_id in ipairs(self.ornamentsConfig) do
        local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(ornament_id)
        if not l_row then
            logError(StringEx.Format("不可能存在的错误,之前筛选的表格数据找不到了 ornament_id:{0}", ornament_id))
            return
        end

        local l_limited = self:IsLimited(ornament_id)
        local l_locked = MgrMgr:GetMgr("HeadShopMgr").IsLocked(ornament_id)
        local l_lackRes = self:IsResourceNotEnough(ornament_id)

        -- 排序优先级为 不受任何限制的 > 材料不足的 > 还未解锁的 > 已经兑换完不可再兑换的
        local l_sort_id = 0
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(ornament_id)
        if not l_itemRow then
            logError(StringEx.Format("找不到头饰对应的道具配置@韩艺鸣  道具ID:{0}", ornament_id))
        else
            l_sort_id = l_itemRow.SortID
        end

        -- 给与满足条件的头饰更大的权值，用于排序
        if not l_limited then
            l_sort_id = l_sort_id + 100000000
            if not l_locked then
                l_sort_id = l_sort_id + 1000000000
                if not l_lackRes then
                    l_sort_id = l_sort_id + 10000000000
                end
            end
        end

        local l_data = {
            ID = ornament_id,
            sortID = l_sort_id,
            ctrl = self,
        }

        table_insert(self.ornamentDatas, l_data)
    end

    table.sort(self.ornamentDatas, function(m, n)
        return m.sortID > n.sortID
    end)
end

function HeadShopCtrl:CustomHideUI()
    -- body
    self.canvas.enabled = false

    MPlayerInfo:FocusToMyPlayer()
end

function HeadShopCtrl:CustomShowUI()
    -- body
    self.canvas.enabled = true

    self:FocusToNpc()
end

function HeadShopCtrl:FocusToNpc()

    if not self.npcId then
        return
    end

    -- Focus对应npc，相对于对话框需要左移一点，旋转一点
    -- MPlayerInfo:FocusToNpc(self.npcId, 1, 4, 135, 5)
    local l_npcEntity = MNpcMgr:FindNpcInViewport(self.npcId)
    if l_npcEntity then
        local l_rightVec = l_npcEntity.Model.Rotation * Vector3.right
        local l_temp2 = -0.2
        MPlayerInfo:FocusToOrnamentBarter(self.npcId, l_rightVec.x * l_temp2, 1, l_rightVec.z * l_temp2, 4, 10, 5)
    else
        logError(StringEx.Format("找不到场景中的npc npc_id:{0}", self.npcId))
        return
    end

    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

--设置坐骑的缩放
function HeadShopCtrl:SetModleSize(objTrans)
    local bundSize = nil
    local bounds = nil
    if objTrans.gameObject:GetComponent("Renderer") then
        bundSize = objTrans.gameObject:GetComponent("Renderer").bounds.size
        bounds = objTrans.gameObject:GetComponent("Renderer").bounds
    else
        bundSize = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds.size
        bounds = objTrans:GetChild(0).gameObject:GetComponent("Renderer").bounds
    end

    if bundSize == nil then
        logError("Check Object Renderer Compent")
        return
    end

    local maxSize = math.max(bundSize.x, bundSize.y, bundSize.z)
    local StandScale = 1.3 / maxSize
    objTrans:SetLocalScale(StandScale, StandScale, StandScale)
    objTrans:SetLocalPos(0, StandScale / 2 + 0.2, 0)
end

function HeadShopCtrl:ShowHeadModel(l_modelItem, l_posY)

    l_modelItem.Trans:SetLocalRotEuler(-90, -180, 0)
    l_modelItem.Trans:SetLocalPos(0, l_posY, 0)
    l_modelItem.Trans:SetLocalScale(1.7, 1.7, 1.7)
end

function HeadShopCtrl:ShowDefault(l_modelItem)

    l_modelItem.Trans:SetLocalRotEuler(0, -180, 0)
    self:SetModleSize(l_modelItem.Trans)
end

function HeadShopCtrl:ResetNpcOrnament()
    local l_npcEntity = MNpcMgr:FindNpcInViewport(self.npcId)
    if not l_npcEntity then
        logError("UpdateNpcOrnament fail, cannot find npc", self.npcId)
        return
    end

    if not l_cachedNpcOrnaments then
        local l_equip = l_npcEntity.AttrComp.EquipData
        l_cachedNpcOrnaments = { l_equip.OrnamentHeadItemID, l_equip.OrnamentFaceItemID, l_equip.OrnamentMouthItemID, l_equip.OrnamentBackItemID, l_equip.OrnamentTailItemID }
    end

    for i = 1, 5 do
        if l_cachedNpcOrnaments[i] then
            l_npcEntity.AttrComp:SetOrnamentByIntType(i, l_cachedNpcOrnaments[i])
        end
    end
end

function HeadShopCtrl:UpdateNpcOrnament()

    local l_npcEntity = MNpcMgr:FindNpcInViewport(self.npcId)
    if not l_npcEntity then
        logError("UpdateNpcOrnament fail, cannot find npc", self.npcId)
        return
    end

    if not HeadShopMgr.SelectOrnamentId then
        logError("UpdateNpcOrnament fail, HeadShopMgr.SelectOrnamentId is nil")
        return
    end

    self:ResetNpcOrnament()

    local l_equipRow = TableUtil.GetEquipTable().GetRowById(HeadShopMgr.SelectOrnamentId)
    if not l_equipRow or l_equipRow.EquipId > 10 or l_equipRow.EquipId < 7 then
        return
    end

    l_npcEntity.AttrComp:SetOrnament(HeadShopMgr.SelectOrnamentId)
end

function HeadShopCtrl:OnReconnected()
    self:FocusToNpc()
    MgrMgr:GetMgr("HeadShopMgr").RequestLimitData(self.npc_id)
    self.activeState = true

    self:HeadShopPanelRefresh()
end

function HeadShopCtrl:_onDailyTaskClose()
    self:FocusToNpc()
end
--lua custom scripts end
return HeadShopCtrl