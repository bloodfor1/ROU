--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CardUnsealPanel"
require "UI/Template/UnsealCardCell"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CardUnsealCtrl = class("CardUnsealCtrl", super)
--lua class define end

--lua functions
function CardUnsealCtrl:ctor()

    super.ctor(self, CtrlNames.CardUnseal, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function CardUnsealCtrl:Init()

    self.sealCardMgr = MgrMgr:GetMgr("SealCardMgr")

    self.panel = UI.CardUnsealPanel.Bind(self)
    super.Init(self)

    self.attrCloneItems = {}

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CardUnseal)
    end)

    self.panel.EquipTog.Tog.isOn = false
    self.panel.EquipTog.Tog.onValueChanged:AddListener(function(isOn)
        self:RefreshLeftCards()
        self.cardPool:SelectTemplate(1)
        self:RefreshDetail()
    end)

    self.panel.CardAttr:SetActiveEx(false)
    self.panel.CardImg:AddClick(function()
        self.panel.CardAttr:SetActiveEx(true)
    end)

    self.panel.CardAttr:AddClick(function()
        self.panel.CardAttr:SetActiveEx(false)
    end)

    -- 卡片解封
    self.panel.UnsealBtn:AddClick(function()
        local l_templateData = self.cardPool:GetCurrentSelectTemplateData()
        if l_templateData then
            local l_itemData = l_templateData.itemData
            --如果材料不足
            local l_cardRow = TableUtil.GetEquipCardSeal().GetRowBySealCardId(l_itemData.TID)
            local l_needItemId
            if l_cardRow then
                local l_costs = Common.Functions.VectorSequenceToTable(l_cardRow.ItemCost)
                for i, v in ipairs(l_costs) do
                    local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
                    if l_count < v[2] then
                        l_needItemId = v[1]
                        break
                    end
                end
            end
            if l_needItemId then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_needItemId, self.panel.UnsealBtn.transform, nil, nil, true, { relativePositionY = 40 })
                return
            end
            local l_cardName = l_itemData.ItemConfig.ItemName
            local l_equipName = l_templateData.equipItemData and l_templateData.equipItemData.ItemConfig.ItemName or ""
            local l_uid = l_templateData.equipItemData and l_templateData.equipItemData.UID or l_itemData.UID
            self.sealCardMgr.EquipCardUnSeal(l_uid, l_templateData.isEquip, l_templateData.pos, { cardId = l_itemData.TID, cardName = l_cardName, equipName = l_equipName })
        end
    end)

    self.cardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.UnsealCardCell,
        ScrollRect = self.panel.CardScrollRect.LoopScroll,
        TemplatePrefab = self.panel.UnsealCardCell.LuaUIGroup.gameObject,
        Method = function(index, cardId)
            self.cardPool:SelectTemplate(index)
            self:RefreshDetail()
        end
    })

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.ItemScrollRect.LoopScroll,
    })

    self.panel.CardAttrText.gameObject:SetActiveEx(false)

    self:RefreshLeftCards()

    -- 默认选中第一个
    self.cardPool:SelectTemplate(1)
    self:RefreshDetail()
end --func end
--next--
function CardUnsealCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CardUnsealCtrl:OnActive()
    MgrMgr:GetMgr("NpcFuncMgr").FocusToNpcByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UnsealCard)

    if self.uiPanelData and self.uiPanelData.cardId then
        self:SelectCard(self.uiPanelData.cardId)
    end

    -- 新手引导
    local l_cardItems = self.sealCardMgr.GetSealCardItems(self.panel.EquipTog.Tog.isOn)
    if #l_cardItems ~= 0 then
        local l_beginnerGuideChecks = { "FoundryCard" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end
end --func end
--next--
function CardUnsealCtrl:OnDeActive()
    self.panel.CardImg:ResetRawTex()

    MPlayerInfo:FocusToMyPlayer()

end --func end
--next--
function CardUnsealCtrl:Update()


end --func end
--next--
function CardUnsealCtrl:BindEvents()
    self:BindEvent(self.sealCardMgr.EventDispatcher, self.sealCardMgr.EventType.UnsealCardSucceed, function()
        --self:RefreshLeftCards()
        --self:RefreshDetail()
        -- 删除左侧的选中并重新选中
        local l_curIndex = self.cardPool.CurrentSelectIndex
        self.cardPool:RemoveTemplateByIndex(l_curIndex)
        local l_endIndex = self.cardPool:GetCellEndIndex()
        if l_curIndex > l_endIndex then
            l_curIndex = l_endIndex
        end
        self.cardPool:SelectTemplate(l_curIndex)
        self:RefreshDetail()
    end)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, function()
        self:RefreshDetail()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

function CardUnsealCtrl:RefreshLeftCards()
    local l_cardItems = self.sealCardMgr.GetSealCardItems(self.panel.EquipTog.Tog.isOn)
    self.cardPool:ShowTemplates({ Datas = l_cardItems })
    local l_isEmpty = #l_cardItems == 0
    self.panel.CardScrollRect:SetActiveEx(not l_isEmpty)
    self.panel.LeftEmpty:SetActiveEx(l_isEmpty)

    self:RefreshDetail()
end

function CardUnsealCtrl:RefreshDetail()
    local l_templateData = self.cardPool:GetCurrentSelectTemplateData()
    if l_templateData then
        local l_itemData = l_templateData.itemData

        local l_cardSealRow = TableUtil.GetEquipCardSeal().GetRowBySealCardId(l_itemData.TID)
        if l_cardSealRow then
            local l_cardRow = TableUtil.GetEquipCardTable().GetRowByID(l_cardSealRow.CardId)
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_cardSealRow.CardId)
            if l_cardRow and l_itemRow then
                -- 名称
                self.panel.CardName.LabText = l_itemRow.ItemName
                self.panel.AttrCardName.LabText = l_itemRow.ItemName

                -- 设置品质颜色
                -- local l_color = RoColor.Hex2Color(RoQuality.GetColorHex(l_itemRow.ItemQuality))
                -- self.panel.CardNameBg.Img.color = l_color
                -- self.panel.CardAttrBg.Img.color = l_color
                -- self.panel.AttrCardNameBg.Img.color = l_color

                local l_c1, l_c2 = Data.BagModel:getCardTextureBgColor(l_itemData.TID)
                self.panel.CardAttrBg.Img.color = l_c1
                self.panel.AttrCardNameBg.Img.color = l_c2
                local l_bgAtlas, l_bgIcon = Data.BagModel:getCardTextureBgInfo(l_itemData.TID)
                self.panel.Card_Bg:SetSprite(l_bgAtlas, l_bgIcon)

                -- 属性
                for _, v in ipairs(self.attrCloneItems) do
                    v:SetActiveEx(false)
                end
                for i = 0, l_cardRow.CardAttributes.Length - 1 do
                    if not self.attrCloneItems[i + 1] then
                        self.attrCloneItems[i + 1] = MResLoader:CloneObj(self.panel.CardAttrText.gameObject, false)
                    end
                    self.attrCloneItems[i + 1].gameObject:SetActiveEx(true)
                    local l_text = self.attrCloneItems[i + 1]:GetComponent("MLuaUICom")
                    l_text.transform:SetParent(self.panel.CardAttrText.transform.parent)
                    l_text.transform:SetLocalScaleOne()
                    local attr = {}
                    attr.type = l_cardRow.CardAttributes[i][0]
                    attr.id = l_cardRow.CardAttributes[i][1]
                    attr.val = l_cardRow.CardAttributes[i][2]
                    l_text.LabText = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
                    Common.CommonUIFunc.CalculateLowLevelTipsInfo(l_text, nil, Vector2.New(0.5, 0.5))
                end

                -- 图片
                self.panel.CardImg:SetRawTexAsync(l_cardRow.CardTexture)
            end

            -- 消耗
            local l_costDatas = {}
            local l_costs = Common.Functions.VectorSequenceToTable(l_cardSealRow.ItemCost)
            for i, v in ipairs(l_costs) do
                local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
                table.insert(l_costDatas, { ID = v[1], Count = l_count, IsShowRequire = true,
                                            RequireCount = v[2], IsShowCount = false, })
            end

            self.itemPool:ShowTemplates({ Datas = l_costDatas })
        end
    end

    local l_isEmpty = not l_templateData
    self.panel.Detail:SetActiveEx(not l_isEmpty)
    self.panel.RightEmpty:SetActiveEx(l_isEmpty)
end

function CardUnsealCtrl:SelectCard(cardId)
    self.cardPool:ScrollAndSelectIndexByDataCondition(function(data)
        return data.itemData.TID == cardId
    end, 2000)

    self:RefreshDetail()
end

--lua custom scripts end
return CardUnsealCtrl