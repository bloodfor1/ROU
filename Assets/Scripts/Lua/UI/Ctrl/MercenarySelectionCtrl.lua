--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenarySelectionPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--self.MercenaryTabs = {}
--next--
--lua fields end

--lua class define
MercenarySelectionCtrl = class("MercenarySelectionCtrl", super)
--lua class define end

--lua functions
function MercenarySelectionCtrl:ctor()

    super.ctor(self, CtrlNames.MercenarySelection, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function MercenarySelectionCtrl:Init()

    self.panel = UI.MercenarySelectionPanel.Bind(self)
    super.Init(self)
    self.showDatas = {}
    self.mercenaryPool = nil
    self.panel.CloseBtn:AddClick(function()
        --chuzhan
        if self.mercenaryPool ~= nil then
            --MgrMgr:GetMgr("TeamMgr"):SelectTeamMercenarys()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.MercenarySelection)
    end)
end --func end
--next--
function MercenarySelectionCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MercenarySelectionCtrl:OnActive()
    local SelectionInfoUpdate = function()
        self:SetMercenaryInfo()
    end
    local SelectionNumUpdate = function()
        self:SetNum()
    end
end --func end
--next--
function MercenarySelectionCtrl:OnDeActive()

end --func end
--next--
function MercenarySelectionCtrl:Update()


end --func end

--next--
function MercenarySelectionCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_MERCENARY_SELECT, SelectionInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_MERCENARY_SELECT_NUM, SelectionNumUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts

function MercenarySelectionCtrl:SetNum()
    local l_cur = DataMgr:GetData("TeamData").GetCurMercenaryNum()
    local l_max = DataMgr:GetData("TeamData").GetMaxMercenaryNum()
    self.panel.MercenaryNum.LabText = "" .. l_cur .. "/" .. l_max
end

function MercenarySelectionCtrl:SetDatas(data)
    local l_datas = {}
    for _, v in pairs(data) do
        local l_temtab = {}
        l_temtab.ownerName = v.ownerName
        l_temtab.isChoose = v.inTeam
        l_temtab.lvl = v.lvl
        local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(v.Id)
        l_temtab.name = l_mercenaryRow.Name
        l_temtab.head = l_mercenaryRow.MercenaryIcon
        l_temtab.job = DataMgr:GetData("TeamData").GetProfessionImageById(l_mercenaryRow.Profession)
        l_temtab.ownerId = v.ownerId
        l_temtab.Id = v.Id
        table.insert(l_datas, l_temtab)
    end
    return l_datas
end

function MercenarySelectionCtrl:SetMercenaryInfo()
    --local data = MgrMgr:GetMgr("TeamMgr").myTeamAllMercenary
    --self.showDatas = self:SetDatas(data)
    --if not self.mercenaryPool then
    --    self.mercenaryPool = self:NewTemplatePool({
    --        TemplateClassName = "MercenarySelectTem",
    --        TemplatePrefab = self.panel.MercenarySelectTem.Prefab.gameObject,
    --        ScrollRect = self.panel.loopview.LoopScroll,
    --    })
    --end
    --
    --self.panel.MercenarySelectTem.Prefab.gameObject:SetActiveEx(false)
    --local l_cur = DataMgr:GetData("TeamData").GetCurMercenaryNum()
    --local l_max = DataMgr:GetData("TeamData").GetMaxMercenaryNum()
    --self.panel.MercenaryNum.LabText = "" .. l_cur .. "/" .. l_max
    --if self.mercenaryPool ~= nil then
    --    self.mercenaryPool:ShowTemplates({ Datas = self.showDatas })
    --end
end

--lua custom scripts end
return MercenarySelectionCtrl