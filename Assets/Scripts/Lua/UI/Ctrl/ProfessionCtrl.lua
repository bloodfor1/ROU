--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ProfessionPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ProfessionCtrl = class("ProfessionCtrl", super)
--lua class define end

--lua functions
function ProfessionCtrl:ctor()

    super.ctor(self, CtrlNames.Profession, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function ProfessionCtrl:Init()

    self.panel = UI.ProfessionPanel.Bind(self)
	super.Init(self)
    self.professions = {}
    local proTable = TableUtil.GetProfessionTable().GetTable()
    for i = 1, table.maxn(proTable) do
        self.professions[i] = {}
        self.professions[i].id = proTable[i].Id
        self.professions[i].ui = self:CloneObj(self.panel.ButtonTpl.gameObject)
        self.professions[i].ui.transform:SetParent(self.panel.ButtonTpl.transform.parent)
        self.professions[i].ui.transform:SetLocalScaleOne()
        local nameText = MLuaClientHelper.GetOrCreateMLuaUICom(self.professions[i].ui.transform:Find("Text"))
        local btn = self.professions[i].ui:GetComponent("MLuaUICom")
        btn:AddClick(function ()
            MgrMgr:GetMgr("ProfessionMgr").RequestTransferProfession(self.professions[i].id)
        end)
        nameText.LabText = tostring(proTable[i].Name)
    end
    self.panel.ButtonTpl.gameObject:SetActiveEx(false)
    self.panel.ButtonOk:AddClick(function ()
        UIMgr:DeActiveUI("Profession")
    end)
end
--func end

--next--
function ProfessionCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ProfessionCtrl:OnActive()


end --func end
--next--
function ProfessionCtrl:OnDeActive()


end --func end
--next--
function ProfessionCtrl:Update()


end --func end

--next--
function ProfessionCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--lua custom scripts end