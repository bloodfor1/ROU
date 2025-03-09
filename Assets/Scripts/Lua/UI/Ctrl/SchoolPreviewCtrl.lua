--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SchoolPreviewPanel"

require "UI/Template/SchoolPreviewEquipItemTemplate"
require "UI/Template/SchoolPreviewCardItemPreview"
require "UI/Template/SchoolPreviewHeadItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SchoolPreviewCtrl = class("SchoolPreviewCtrl", super)
local maxShowCardCount = 3
--lua class define end

--lua functions
function SchoolPreviewCtrl:ctor()

    super.ctor(self, CtrlNames.SchoolPreview, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function SchoolPreviewCtrl:Init()

    self.panel = UI.SchoolPreviewPanel.Bind(self)
    super.Init(self)
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.SchoolPreview)
    end)
    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark)

end --func end
--next--
function SchoolPreviewCtrl:Uninit()

    self.SkillItemPool = nil
    self.EquipItemPool = nil
    self.CardItemPool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SchoolPreviewCtrl:OnActive()
    self.panel.equipJump.LabRayCastTarget = true
    self.panel.cardJump.LabRayCastTarget = true

end --func end
--next--
function SchoolPreviewCtrl:OnDeActive()


end --func end
--next--
function SchoolPreviewCtrl:Update()


end --func end



--next--
function SchoolPreviewCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function SchoolPreviewCtrl:InitWithRecommandId(recommandId)

    self.HeadItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SchoolPreviewHeadItemTemplate,
        TemplateParent = self.panel.CoreHeadContent.transform,
        TemplatePrefab = self.panel.HeadItem.LuaUIGroup.gameObject
    })
    self.EquipItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SchoolPreviewEquipItemTemplate,
        TemplateParent = self.panel.CoreEquipContent.transform,
        TemplatePrefab = self.panel.EquipItem.LuaUIGroup.gameObject
    })
     self.CardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SchoolPreviewCardItemPreview,
        TemplateParent = self.panel.CoreCardContent.transform,
        TemplatePrefab = self.panel.CardItem.LuaUIGroup.gameObject
     })


    local l_recommandData = TableUtil.GetSkillClassRecommandTable().GetRowById(recommandId)
    local l_headIds = l_recommandData.HeadWearIds
    local l_coreEquipIds = l_recommandData.EquipIds
    local l_coreCardIds = l_recommandData.CardIds

    self.recommandId = recommandId
    self:InitHeads(l_headIds)
    self:InitEquips(l_coreEquipIds)
    self:InitCards(l_coreCardIds)

end

function SchoolPreviewCtrl:InitHeads(headIds)
    local l_data = {}
    for i=0,headIds.Length-1 do
        table.insert(l_data, {
            id = headIds[i],
            parent = self
        })
    end
    self.HeadItemPool:ShowTemplates({Datas = l_data})
end

function SchoolPreviewCtrl:InitEquips(equipIds)
    local l_data = {}
    for i=0,equipIds.Length-1 do
        table.insert(l_data,
        {
            id = equipIds[i],
            parent = self
        })
    end
    self.EquipItemPool:ShowTemplates({Datas = l_data})
    self.panel.equipJump.LabText = StringEx.Format("<a href=equipJump>{0}</a>",
            GetColorText(Lang("SCHOOL_PREVIEW_EQUIP_JUMP_TEXT"), RoColorTag.Blue))
    self.panel.equipJump:GetRichText().onHrefDown:AddListener(function (hrefName, ed)
        MgrMgr:GetMgr("SystemFunctionEventMgr").OpenIllustrationByEquip(1, 1000)
    end)
end

function SchoolPreviewCtrl:InitCards(cardIds)
    local l_data = {}
    for i=0,cardIds.Length-1 do
        table.insert(l_data, { ID = cardIds[i], IsShowCount = false, parent = self})
        if i >= maxShowCardCount - 1 then break end
    end
    self.CardItemPool:ShowTemplates({Datas = l_data})
    self.panel.cardJump.LabText = StringEx.Format("<a href=cardJump>{0}</a>",
            GetColorText(Lang("SCHOOL_PREVIEW_CARD_JUMP_TEXT"), RoColorTag.Blue))
    self.panel.cardJump:GetRichText().onHrefDown:AddListener(function (hrefName, ed)
        MgrMgr:GetMgr("SystemFunctionEventMgr").OpenIllustrationByCardSelectInfo(100, self.recommandId)
    end)
 end
--lua custom scripts end

return SchoolPreviewCtrl