--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonsterTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
IllustrationMonsterTipsCtrl = class("IllustrationMonsterTipsCtrl", super)
--lua class define end

--lua functions
function IllustrationMonsterTipsCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonsterTips, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function IllustrationMonsterTipsCtrl:Init()

    self.panel = UI.IllustrationMonsterTipsPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function IllustrationMonsterTipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function IllustrationMonsterTipsCtrl:OnActive()

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonsterTips)
    end)
    if not self.items then
        self.items = {}
    end
    local l_count = #self.items
    if l_count > 0 then
        for i = 1, l_count do
            MResLoader:DestroyObj(self.items[i].go)
        end
    end
    self.items = {}
    local l_upTable, l_downTable = DataMgr:GetData("IllustrationMonsterData").GetLvRateTable()
    local l_p = self.panel.AboveContent.gameObject.transform
    for k, v in pairs(l_upTable) do
        self:CreateItem(v, l_p)
    end
    l_p = self.panel.BelowContent.gameObject.transform
    for k, v in pairs(l_downTable) do
        self:CreateItem(v, l_p)
    end

end --func end
--next--
function IllustrationMonsterTipsCtrl:OnDeActive()
    if self.items then
        local l_count = #self.items
        if l_count > 0 then
            for i = 1, l_count do
                MResLoader:DestroyObj(self.items[i].go)
            end
        end
    end
end --func end
--next--
function IllustrationMonsterTipsCtrl:Update()


end --func end





--next--
function IllustrationMonsterTipsCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function IllustrationMonsterTipsCtrl:CreateItem(info, parent)
    local l_tp = self.panel.Item.gameObject
    local l_index = #self.items + 1
    self.items[l_index] = {}
    local l_temp = self:CloneObj(l_tp)
    l_temp.transform:SetParent(parent)
    l_temp.transform:SetLocalPosZero()
    l_temp:SetLocalScaleToOther(l_tp)
    self.items[l_index].go = l_temp
    self.items[l_index].go:SetActiveEx(true)
    self.items[l_index].lvLab = l_temp.transform:Find("LvNumber"):GetComponent("MLuaUICom")
    self.items[l_index].expLab = l_temp.transform:Find("ExpNumber"):GetComponent("MLuaUICom")
    self.items[l_index].entityLab = l_temp.transform:Find("EntityNumber"):GetComponent("MLuaUICom")
    if info.vMax>=9999 then
        self.items[l_index].lvLab.LabText = tostring(info.vMin) .. "+"
    else
        self.items[l_index].lvLab.LabText = tostring(info.vMin) .. "-" .. tostring(info.vMax)
    end
    self.items[l_index].expLab.LabText = info.vStr
    self.items[l_index].entityLab.LabText = info.dropStr
end
--lua custom scripts end
return IllustrationMonsterTipsCtrl