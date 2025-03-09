--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/EquipCardForgePanel"
require "UI/Template/RefineEquipTemplate"
require "UI/Template/EquipCardPropertyTemplate"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
EquipCardForgeHandler = class("EquipCardForgeHandler", super)

--装备操作类型
EquipCardType = {
    InsetCard = 0, --插卡
    NoneHole = 1, --未打洞
    RemoveCard = 3, --拆卡
}
--lua class define end

--lua functions
function EquipCardForgeHandler:ctor()

    super.ctor(self, HandlerNames.EquipCardForge, 0)

end --func end
--next--
function EquipCardForgeHandler:Init()
    self.panel = UI.EquipCardForgePanel.Bind(self)
    super.Init(self)

    self.panel.ShowDetailsButton.Listener:SetActionClick(self._onShowDetailsButton, self)

    --插卡属性显示列表
    self.currentAttrItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.EquipCardPropertyTemplate,
        TemplateParent = self.panel.CurrentAttrParent.transform,
        TemplatePrefab = self.panel.AttrPrefab.gameObject
    })

    --卡片列表
    self.cardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "CardForgeUseCardTemplate",
        TemplatePrefab = self.panel.CardItemPrefab.gameObject,
        ScrollRect = self.panel.ScrollRect.LoopScroll
    })

    self.panel.CardItemPrefab.gameObject:SetActiveEx(false)
    self.panel.EquipShowPanel:SetActiveEx(false)
    self.panel.CardUI.gameObject:SetActiveEx(false)

    --选择装备信息
    self.panel.CurrentEquipItemParent.gameObject:SetActiveEx(true)
    self.equipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.CurrentEquipItemParent.transform })

    --按钮事件 插卡 改造 打洞 拆卡
    self.panel.EquipButton:AddClick(function()
        if self.equipCardType == EquipCardType.InsetCard then
            self:GetCardInBagWithPosition()
        elseif self.equipCardType == EquipCardType.NoneHole then
            -- do nothing
        end
    end)

    self.panel.RemoveCardButton:AddClick(function()
        self:RemoveCard()
    end)

    self.panel.ButtonClose:AddClick(function()
        self.panel.CardUI.gameObject:SetActiveEx(false)
    end)

    --卡片图鉴
    self.panel.MapBtn:AddClick(function()
        MgrMgr:GetMgr("SystemFunctionEventMgr").OpenIllustrationByCardSelectInfo(100, self.classRecommandId)
    end)
end --func end
--next--
function EquipCardForgeHandler:Uninit()
    self.currentCardID = 0
    self.isActiveCount = 0
    MgrMgr:GetMgr("EquipCardForgeHandlerMgr").g_currentSelectUID = 0
    self.equipTextID = nil
    self.currentAttr = nil
    self.currentEquipData = nil
    self.currentEquipConsumeTable = nil
    self.positionInfo = nil
    self.equipItem = nil
    self.cardTemplatePool = nil
    self.currentAttrItemPool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EquipCardForgeHandler:OnActive()
    self.equipCardType = -1
    self.currentCardID = 0
    self.currentAttr = nil
    self.currentEquipConsumeTable = nil
    self.classRecommandId = 0
    self.currentEquipIndex = 0
    self.selectAndEquipIndex = {}
    self.isOnlyShowBody = false
    --卡片图鉴推荐流派
    --初心者没有图鉴
    if MPlayerInfo.ProfessionId > 1000 then
        local l_row = TableUtil.GetAutoAddSkillPointTable().GetRowByProfessionId(MPlayerInfo.ProfessionId)
        if not l_row then
            logError("AutoAddSkillPointTable error")
        end
        local l_detailId = l_row.ProDetailId[0]
        local l_detailRow = TableUtil.GetAutoAddSkilPointDetailTable().GetRowByID(l_detailId)
        if not l_detailRow then
            logError("AutoAddSkilPointDetailTable error")
        end

        self.classRecommandId = l_detailRow.ClassRecommandId
    end

    self.panel.MapBtn.gameObject:SetActiveEx(self.classRecommandId > 0)
    --当前选择的装备
    self.currentEquipData = nil
end --func end
--next--
function EquipCardForgeHandler:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipCardForgeHandler:Update()
    -- do nothing
end --func end

--next--
function EquipCardForgeHandler:OnShow()
    self:_setSelectEquipData()
end --func end
--next--
function EquipCardForgeHandler:BindEvents()
    --装备属性改变回调   --itemData 为服务端传过来的item
    self:BindEvent(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher, MgrMgr:GetMgr("EquipCardForgeHandlerMgr").ReceiveEquipCardRemoveEvent, function(self, itemData)
        self:OnEquipItemButton(self.currentEquipData)
        self:_setSelectEquipData()
    end)

    --插卡
    self:BindEvent(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher, MgrMgr:GetMgr("EquipCardForgeHandlerMgr").InsertCard, function(self, ID)
        --使用卡片插卡
        self.panel.CardUI.gameObject:SetActiveEx(false)
        self:InsertCard(ID)
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isShow)
        self.panel.EquipShowPanel.gameObject:SetActiveEx(isShow)
    end)

    --选择装备插卡属性
    self:BindEvent(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher, MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardPropertyClick, function(self, item)
        self:_onCardPropertyTemplate(item.data)
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent,
            function(self, data)
                if self:IsShowing() then
                    self:OnEquipItemButton(data)
                end
            end)
    --dont override this function
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipCardForgeHandler:OnReconnected()
    if self.currentEquipData == nil then
        return
    end

    super.OnReconnected(self)
    self:OnEquipItemButton(self.currentEquipData)
end

--点击选择装备
---@param data ItemData
function EquipCardForgeHandler:OnEquipItemButton(data)
    self.currentEquipData = data
    if self.currentEquipData == nil then
        self.panel.EquipShowPanel:SetActiveEx(false)
        return
    end

    self.panel.Txt_InsertCardEquipName.LabText = self.currentEquipData.EquipConfig.Name
    MgrMgr:GetMgr("EquipCardForgeHandlerMgr").g_currentSelectUID = data.UID
    self.panel.EquipShowPanel.gameObject:SetActiveEx(true)
    self.panel.NoSelectEquip.gameObject:SetActiveEx(false)

    --设置装备图标
    self.equipItem:SetData({ PropInfo = self.currentEquipData, IsShowCount = false, IsShowTips = true })
    local l_equipTable = TableUtil.GetEquipTable().GetRowById(self.currentEquipData.TID)
    if l_equipTable == nil then
        logError("EquipTable not have ID" .. tostring(self.currentEquipData.TID))
        return
    end

    self.equipTextID = l_equipTable.EquipText
    self.currentEquipConsumeTable = MgrMgr:GetMgr("EquipMgr").GetEquipConsumeTableId(data.ItemConfig.TypeTab, data:GetEquipTableLv())
    --显示装备插卡属性信息
    self:ShowEquipInfo(self.currentEquipData)
end

--实例化属性数据
---@return CardHoleConfig
function EquipCardForgeHandler:GetAttrData(l_index)
    ---@class CardHoleConfig
    local l_data = {
        localID = l_index,
        cardID = 0,
        isOpenHole = 0,
        holeTableId = 0,
        attr = nil,
        equipText = self.equipTextID,
    }

    return l_data
end

--显示装备插卡属性
---@param equipData ItemData
function EquipCardForgeHandler:ShowEquipInfo(equipData)
    if equipData == nil then
        return
    end

    local l_maxHoleCount = #equipData.AttrSet[GameEnum.EItemAttrModuleType.Hole]
    ---@type CardHoleConfig[]
    local l_holeDatas = {}
    for i = 1, l_maxHoleCount do
        -- 如果没打洞，就跳过去

        -- 如果没插卡
        local l_data = self:GetAttrData(i)
        if 0 < #equipData.AttrSet[GameEnum.EItemAttrModuleType.Hole][i] then
            -- 如果插卡了
            l_data.holeTableId = equipData.AttrSet[GameEnum.EItemAttrModuleType.Hole][i][1].TableID
            l_data.isOpenHole = 1
            if 0 < #equipData.AttrSet[GameEnum.EItemAttrModuleType.Card][i] then
                l_data.cardID = equipData.AttrSet[GameEnum.EItemAttrModuleType.Card][i][1].AttrID
            else
                l_data.attr = equipData.AttrSet[GameEnum.EItemAttrModuleType.Hole][i]
            end
        end

        table.insert(l_holeDatas, l_data)
    end

    local l_selectIndex = 0
    if MgrMgr:GetMgr("EquipCardForgeHandlerMgr").IsSelectEquipWithCard() then
        for i = 1, #l_holeDatas do
            if l_holeDatas[i].cardID ~= 0 then
                l_selectIndex = i
                break
            end
        end

        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").RemoveGotoCardData()
    end

    local l_currentSelectHoleData = nil
    if l_selectIndex == nil or l_selectIndex == 0 then
        for i = 1, #l_holeDatas do
            if l_holeDatas[i].isOpenHole == 1 and l_holeDatas[i].cardID == 0 then
                l_currentSelectHoleData = l_holeDatas[i]
                break
            end
        end

        if l_currentSelectHoleData == nil then
            l_currentSelectHoleData = l_holeDatas[1]
        end
    else
        l_currentSelectHoleData = l_holeDatas[l_selectIndex]
    end

    self.currentAttrItemPool:ShowTemplates({ Datas = l_holeDatas })
    self:_onCardPropertyTemplate(l_currentSelectHoleData)
end

--插卡操作
function EquipCardForgeHandler:InsertCard(ID)
    if self.currentEquipData == nil then
        return
    end

    self.currentCardID = ID
    MgrMgr:GetMgr("EquipCardForgeHandlerMgr").RequestEquipCardInsert(self.currentEquipData.UID, self.currentCardID, self.currentPropertyLocalID)
end

--拆卡操作
function EquipCardForgeHandler:RemoveCard()
    local l_currentEquipData = self.currentEquipData
    if l_currentEquipData == nil then
        return
    end
    local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(self.currentCardID)
    local l_consume = self:GetConsume()
    local l_consumeDatas = {}
    for i = 0, l_consume.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_consume[i][0])
        l_data.IsShowCount = false
        l_data.IsShowRequire = true
        l_data.RequireCount = tonumber(l_consume[i][1])
        table.insert(l_consumeDatas, l_data)
    end

    local itemData = Data.BagApi:CreateLocalItemData(self.currentCardID)
    if itemData == nil then
        return
    end
    if itemData:GetExistTime() > 0 then
        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").RequestEquipCardRemove(l_currentEquipData.UID, self.currentPropertyLocalID, l_consumeDatas)
    else
        CommonUI.Dialog.ShowConsumeDlg("", StringEx.Format(Common.Utils.Lang("EquipCard_RemoveCardText"), l_cardInfo.CardName),
                function()
                    MgrMgr:GetMgr("EquipCardForgeHandlerMgr").RequestEquipCardRemove(l_currentEquipData.UID, self.currentPropertyLocalID, l_consumeDatas)
                end, nil, l_consumeDatas)
    end

end



--选择装备插卡属性
--设置按钮和文字
function EquipCardForgeHandler:SelectEquipCardAttr()
    self.panel.EquipButton:SetActiveEx(false)
    self.panel.RemoveCardButton:SetActiveEx(false)
    self.panel.NoneHoleMask:SetActiveEx(false)
    if self.equipCardType == EquipCardType.InsetCard then
        self.panel.EquipButton:SetActiveEx(true)
    elseif self.equipCardType == EquipCardType.NoneHole then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("EquipCard_SelectNoMakeHoleText"),
                function()
                    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipBG)
                    if l_equipBG then
                        l_equipBG:ShowMakeHole()
                    end
                end
        )
    else
        self.panel.RemoveCardButton:SetActiveEx(true)
    end
end

--判断消耗品够不够
function EquipCardForgeHandler:MaterialIsEnough(consume)
    local l_materialIsEnough = true
    local l_notEnoughId = 0
    for i = 0, consume.Count - 1 do
        local l_consumeItemId = consume:get_Item(i, 0)
        local l_requireCount = consume:get_Item(i, 1)
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_consumeItemId)
        if l_currentCount < l_requireCount then
            l_materialIsEnough = false
            l_notEnoughId = l_consumeItemId
            break
        end
    end

    return l_materialIsEnough, l_notEnoughId
end
--根据操作得到消耗品
function EquipCardForgeHandler:GetConsume()
    if self.currentEquipConsumeTable == nil then
        return
    end

    local l_consume = nil
    if self.equipCardType == EquipCardType.InsetCard then
        l_consume = self.currentEquipConsumeTable.PlugCardConsume
    else
        l_consume = self.currentEquipConsumeTable.DismantleCardConsume
    end

    if not self.panel.EquipButton.gameObject.activeSelf then
        self.panel.EquipButton.gameObject:SetActiveEx(true)
    end

    return l_consume
end

--根据部位得到背包里所有卡片
function EquipCardForgeHandler:GetCardInBagWithPosition()
    local l_currentEquipCards = MgrMgr:GetMgr("EquipCardForgeHandlerMgr").GetCardsWithEquipId(self.currentEquipData.TID)
    if #l_currentEquipCards == 0 then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("NO_CARD_FOR_THE_POSITION"),
                function()
                    local l_equipTable = self.currentEquipData.EquipConfig
                    if l_equipTable == nil then
                        return
                    end

                    MgrMgr:GetMgr("SystemFunctionEventMgr").OpenCardIllustrationByEquipmentPart(l_equipTable.EquipId + 1)
                end
        )
        return
    end

    local C_DEFAULT_CARD_COUNT = 6
    local l_cards = {}
    table.ro_insertRange(l_cards, l_currentEquipCards)

    --不满6个补足
    local l_count = #l_cards
    if l_count < C_DEFAULT_CARD_COUNT then
        for i = 1, C_DEFAULT_CARD_COUNT - l_count do
            local l_cardInfo = {}
            l_cardInfo.ItemData = nil
            l_cardInfo.Recommended = false
            table.insert(l_cards, l_cardInfo)
        end
    end

    --首尾留张空卡片
    local l_cardInfo = {}
    l_cardInfo.ItemData = nil
    l_cardInfo.Recommended = false
    table.insert(l_cards, l_cardInfo)

    CommonUI.Dialog.ShowYesNoDlg(
            true, nil,
            Lang("EquipCard_InsertCardTipsText"),
            function()
                if nil == self.panel then
                    return
                end

                self.panel.CardUI.gameObject:SetActiveEx(true)
                self.panel.BtnNext.gameObject:SetActiveEx(#l_cards > C_DEFAULT_CARD_COUNT)
                self.cardTemplatePool:ShowTemplates({ Datas = l_cards })
            end
    , nil, nil, GameEnum.EDialogToggleType.NoHintCurRole, "OnInsetCardButton")
end

---@param data CardHoleConfig
function EquipCardForgeHandler:_onCardPropertyTemplate(data)
    if data then
        self.currentAttrItemPool:SelectTemplate(data.localID)
        self.currentPropertyLocalID = data.localID
        --未打洞
        if data.isOpenHole == 0 and data.attr == nil then
            self.equipCardType = EquipCardType.NoneHole
            --未插卡的
        elseif data.cardID == 0 and data.isOpenHole == 1 then
            self.equipCardType = EquipCardType.InsetCard
            --已插卡的
        elseif data.cardID > 0 then
            self.currentCardID = data.cardID
            self.equipCardType = EquipCardType.RemoveCard
        end
        self:SelectEquipCardAttr()
    else
        self.currentAttrItemPool:SelectTemplate(0)
        self.panel.EquipButton:SetActiveEx(false)
        self.panel.RemoveCardButton:SetActiveEx(false)
        self.panel.NoneHoleMask:SetActiveEx(false)
    end
end

function EquipCardForgeHandler:_onShowDetailsButton(go, eventData)
    local l_anchor = Vector2.New(0.5, 1)
    local pos = Vector2.New(eventData.position.x, eventData.position.y + 160)
    eventData.position = pos
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("Mosaic_Card"), eventData, l_anchor)
end

function EquipCardForgeHandler:_setSelectEquipData()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipBG)
    if l_equipBG then
        local l_template = l_equipBG:GetSelectEquipTemplate()
        if l_template then
            l_template:SetData({
                SelectEquipMgrName = "EquipCardForgeHandlerMgr",
                IsSelectSameEquip = true,
                NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
            })
        end
    end
end
return EquipCardForgeHandler
--lua custom scripts end
