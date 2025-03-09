--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonster_RewardMainPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class IllustrationMonster_RewardMainCtrl : UIBaseCtrl
IllustrationMonster_RewardMainCtrl = class("IllustrationMonster_RewardMainCtrl", super)
--lua class define end

--lua functions
function IllustrationMonster_RewardMainCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonster_RewardMain, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function IllustrationMonster_RewardMainCtrl:Init()

    self.panel = UI.IllustrationMonster_RewardMainPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
    self.data = DataMgr:GetData("IllustrationMonsterData")
    self.RowTem = nil
    self.RewardTem = nil
    self.lvIndex = 0
    self.RightTemData = {}
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonster_RewardMain)
    end)
    self.panel.Btn_Left:AddClickWithLuaSelf(self.GoLeftOne, self)
    self.panel.Btn_Right:AddClickWithLuaSelf(self.GoRightOne, self)
    self.panel.LoopHor.LoopScroll.OnEndDragCallback = function()
        self:CheckLRBtnShow()
    end

end --func end
--next--
function IllustrationMonster_RewardMainCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.RowTem = nil
    self.RewardTem = nil
    self.lvIndex = 0
    self.RightTemData = {}
    self.mgr = nil
    self.data = nil
end --func end
--next--
function IllustrationMonster_RewardMainCtrl:OnActive()
    self:SetLeftPanel()
    self:SetRightPanel()
    if self.mgr.GetHandBookLvl() >= 1 then
        local l_beginnerGuideChecks = { "EntityHandBookGuide1" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end
end --func end
--next--
function IllustrationMonster_RewardMainCtrl:OnDeActive()


end --func end
--next--
function IllustrationMonster_RewardMainCtrl:Update()


end --func end
--next--
function IllustrationMonster_RewardMainCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

function IllustrationMonster_RewardMainCtrl:SetRightPanel()
    local tableData = TableUtil.GetEntityHandBookLvTable().GetTable()
    self.RightTemData = {}
    local MyLvl = self.mgr.GetHandBookLvl()
    for k, v in pairs(tableData) do
        ---@class MonsterBookRewardRowData
        local oneLua = {}
        oneLua.Acquired = MyLvl >= v.Lv
        if MyLvl == v.Lv then
            self.lvIndex = #self.RightTemData + 1
        end
        oneLua.Lv = v.Lv
        oneLua.HaveUnlock = v.Unlock
        oneLua.Attrs = Common.Functions.VectorSequenceToTable(v.AddAttr)
        table.insert(self.RightTemData, oneLua)
    end
    if self.RewardTem == nil then
        self.RewardTem = self:NewTemplatePool({
            TemplateClassName = "MonsterBookMainRewardTem",
            TemplatePrefab = self.panel.MonsterBookMainRewardTem.gameObject,
            ScrollRect = self.panel.LoopHor.LoopScroll,
        })
    end
    self.RewardTem:ShowTemplates({ Datas = self.RightTemData, StartScrollIndex = self.lvIndex })
end

function IllustrationMonster_RewardMainCtrl:SetLeftPanel()
    local lv = self.mgr.GetHandBookLvl()
    local AddAttrs = {}
    self.panel.Lvl.LabText = lv
    local tableData = TableUtil.GetEntityHandBookLvTable().GetTable()
    for _, data in pairs(tableData) do
        if lv >= data.Lv then
            local Attrs = Common.Functions.VectorSequenceToTable(data.AddAttr)
            for k, v in pairs(Attrs) do
                if AddAttrs[v[2]] == nil then
                    AddAttrs[v[2]] = 0
                end
                AddAttrs[v[2]] = AddAttrs[v[2]] + v[3]
            end
        end
    end
    local l_data = {}
    for k, v in pairs(AddAttrs) do
        local attr = Data.ItemAttrData.new(GameEnum.EItemAttrType.Attr, k, v)
        local attrstr = MgrMgr:GetMgr("AttrDescUtil").GetAttrStr(attr)
        table.insert(l_data, { Name = attrstr.Desc })
    end
    if self.RowTem == nil then
        self.RowTem = self:NewTemplatePool({
            TemplateClassName = "MonsterBookAttrRewardLineTem",
            TemplatePrefab = self.panel.MonsterBookAttrRewardLineTem.gameObject,
            ScrollRect = self.panel.MainLoop.LoopScroll,
        })
    end
    self.panel.Empty:SetActiveEx(not l_data or #l_data == 0)
    self.RowTem:ShowTemplates({ Datas = l_data })
end

function IllustrationMonster_RewardMainCtrl:GoLeftOne()
    local lvIndex = self.panel.LoopHor.LoopScroll:GetShowCellStartIndex()
    lvIndex = lvIndex - 1
    lvIndex = lvIndex <= 0 and 0 or lvIndex
    self.panel.LoopHor.LoopScroll:ScrollToCell(lvIndex)
    self:CheckLRBtnShow()
end

function IllustrationMonster_RewardMainCtrl:GoRightOne()
    local lvIndex = self.panel.LoopHor.LoopScroll:GetShowCellStartIndex()
    local isEnd = self.panel.LoopHor.LoopScroll:GetShowCellEndIndex() == #self.RightTemData - 1
    lvIndex = isEnd and lvIndex or lvIndex + 1
    self.panel.LoopHor.LoopScroll:ScrollToCell(lvIndex)
    self:CheckLRBtnShow()
end

function IllustrationMonster_RewardMainCtrl:CheckLRBtnShow()
    self.panel.Btn_Left:SetActiveEx(self.panel.LoopHor.LoopScroll:GetShowCellStartIndex() > 0)
    self.panel.Btn_Right:SetActiveEx(self.panel.LoopHor.LoopScroll:GetShowCellEndIndex() < #self.RightTemData - 1)
end

--lua custom scripts end
return IllustrationMonster_RewardMainCtrl