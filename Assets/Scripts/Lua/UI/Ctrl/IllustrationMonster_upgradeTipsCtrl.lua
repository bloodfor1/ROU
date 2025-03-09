--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonster_upgradeTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class IllustrationMonster_upgradeTipsCtrl : UIBaseCtrl
IllustrationMonster_upgradeTipsCtrl = class("IllustrationMonster_upgradeTipsCtrl", super)
--lua class define end

--lua functions
function IllustrationMonster_upgradeTipsCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonster_upgradeTips, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.IllustrationMonster_upgradeTips
end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:Init()

    self.panel = UI.IllustrationMonster_upgradeTipsPanel.Bind(self)
    super.Init(self)
    self.RowTem = nil
end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.RowTem = nil
end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:OnActive()
    self.panel.LV.LabText = self.uiPanelData.LV
    if self.RowTem == nil then
        self.RowTem = self:NewTemplatePool({
            TemplateClassName = "MonsterBookAttrRewardLineTem",
            TemplatePath = "UI/Prefabs/MonsterBookAttrRewardLineTem",
            TemplateParent = self.panel.BonusPar.transform,
        })
    end
    local l_data = {}
    local TableRow = TableUtil.GetEntityHandBookLvTable().GetRowByLv(self.uiPanelData.LV)
    local Attrs =  Common.Functions.VectorSequenceToTable(TableRow.AddAttr)
    for k, v in ipairs(Attrs) do
        local attr = Data.ItemAttrData.new(GameEnum.EItemAttrType.Attr, v[2], v[3])
        local attrstr = MgrMgr:GetMgr("AttrDescUtil").GetAttrStr(attr)
        table.insert(l_data, { Name = attrstr.Desc })
    end
    self.RowTem:ShowTemplates({ Datas = l_data })
    self.panel.Tips:SetActiveEx(TableRow.Unlock)
end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:OnDeActive()


end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:Update()


end --func end
--next--
function IllustrationMonster_upgradeTipsCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return IllustrationMonster_upgradeTipsCtrl