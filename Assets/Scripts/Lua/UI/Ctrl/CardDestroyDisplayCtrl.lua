--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CardDestroyDisplayPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class CardDestroyDisplayCtrl : UIBaseCtrl
CardDestroyDisplayCtrl = class("CardDestroyDisplayCtrl", super)
--lua class define end

--lua functions
function CardDestroyDisplayCtrl:ctor()

    super.ctor(self, CtrlNames.CardDestroyDisplay, UILayer.Function, nil, ActiveType.None)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.CardDestroyDisplay

end --func end
--next--
function CardDestroyDisplayCtrl:Init()

    self.panel = UI.CardDestroyDisplayPanel.Bind(self)
    super.Init(self)

    self.cardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "CardTemplate",
        ScrollRect = self.panel.CardScroll.LoopScroll
    })

end --func end
--next--
function CardDestroyDisplayCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CardDestroyDisplayCtrl:OnActive()
    if self.uiPanelData == nil then
        return
    end
    local l_cardIdTable = self.uiPanelData
    local l_dataTable = {}
    for i = 1, #l_cardIdTable do
        local cardTemplateData = {}
        local itemData = Data.BagApi:CreateLocalItemData(l_cardIdTable[i])
        cardTemplateData.ItemData = itemData
        table.insert(l_dataTable, cardTemplateData)
    end
    local additionalData = {}
    additionalData.IsShowEffect = true
    if #l_dataTable < 5 then
        MLuaCommonHelper.SetRectTransformPivot(self.panel.CardScroll.LoopScroll.content.gameObject, 0.5, 0.5)
    else
        MLuaCommonHelper.SetRectTransformPivot(self.panel.CardScroll.LoopScroll.content.gameObject, 0, 0.5)
    end
    self.cardTemplatePool:ShowTemplates({ Datas = l_dataTable, AdditionalData = additionalData })

end --func end
--next--
function CardDestroyDisplayCtrl:OnDeActive()


end --func end
--next--
function CardDestroyDisplayCtrl:Update()


end --func end
--next--
function CardDestroyDisplayCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CardDestroyDisplayCtrl