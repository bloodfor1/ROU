--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonsterBgPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
IllustrationMonsterBgCtrl = class("IllustrationMonsterBgCtrl", super)
--lua class define end

--lua functions
function IllustrationMonsterBgCtrl:ctor()
    super.ctor(self, CtrlNames.IllustrationMonsterBg, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function IllustrationMonsterBgCtrl:Init()
    self.panel = UI.IllustrationMonsterBgPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
    self.data = DataMgr:GetData("IllustrationMonsterData")
    self.lv = -1

    --- 左侧第二个页签当中的子页签，其实一开始不需要显示
    self.TypeTogTem = self:NewTemplatePool({
        TemplateClassName = "IllustrationMonsterTypeTogTem",
        TemplatePrefab = self.panel.IllustrationMonsterTypeTogTem.gameObject,
        TemplateParent = self.panel.TypeContent.Transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
        Method = function(elementType)
            self:SelectTypeTog(elementType)
        end
    })

    --- 左侧页签template，需要一开始就显示，刷新率可以为1
    self.TogTem = self:NewTemplatePool({
        TemplateClassName = "IllustrationMonsterBg_Tog_Tem",
        TemplatePrefab = self.panel.IllustrationMonsterBg_Tog_Tem.gameObject,
        TemplateParent = self.panel.Content.Transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
        Method = function(index)
            self:SelectTog(index)
        end
    })

    self._bookTemplate = self:NewTemplate("IllustrationMonsterTem", {
        TemplateParent = self.panel.TemParent.Transform,
        TemplatePath = "UI/Prefabs/IllustrationMonster",
        Method = function(data)
            self:SelectBook(data)
        end
    })

    self._rewardTemplate = self:NewTemplate("IllustrationMonster_ExploratoryRecordTem", {
        TemplateParent = self.panel.TemParent.Transform,
        TemplatePath = "UI/Prefabs/IllustrationMonster_ExploratoryRecord",
        Method = function(data)
            self:SelectMonster(data)
        end
    })

    self.panel.Btn_Back:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonsterBg)
    end)
    self.panel.Btn_Collection:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonster_StorageCabinet)
    end)
    self.panel.Rank:AddClick(function()
        local openData = {
            openType = 1,
            RankMainType = 1100,
        }
        UIMgr:ActiveUI(UI.CtrlNames.Rank, openData)
    end)
    self.panel.Btn_MainReward:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonster_RewardMain)
    end)
    self.panel.Shop:AddClickWithLuaSelf(function()
        Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterShop)
    end, self)
end --func end
--next--
function IllustrationMonsterBgCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.lv = -1
end --func end
--next--
function IllustrationMonsterBgCtrl:OnActive()
    self.panel.CollectRW:SetActiveEx(false)
    self.panel.LvlRW:SetActiveEx(false)
    self._bookTemplate:ActiveTemplate()
    self._rewardTemplate:DeActiveTemplate()
    local TogData = { Common.Utils.Lang("ILLUSTRATION_MONSTER_BOOK_NAME1"), Common.Utils.Lang("ILLUSTRATION_MONSTER_BOOK_NAME2") }
    self.TogTem:ShowTemplates({ Datas = TogData })
    self.TogTem:SelectTemplate(1)
    self._bookTemplate:SetData({})
    self:_refreshPoint(true)
    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.MonsterOpenType.ShowMvp then
            self._bookTemplate:AddLoadCallback(function()
                self._bookTemplate:ShowMVP()
            end)
        elseif self.uiPanelData.openType == self.data.MonsterOpenType.ShowMini then
            self._bookTemplate:AddLoadCallback(function()
                self._bookTemplate:ShowMini()
            end)
        elseif self.uiPanelData.openType == self.data.MonsterOpenType.SearchMonster then
            self._bookTemplate:AddLoadCallback(function()
                self._bookTemplate:SearchMonsterNameById(self.uiPanelData.EntityId)
            end)
        end
    end

    self.panel.Toggle_Normal_List_1:SetActiveEx(false)
end --func end
--next--
function IllustrationMonsterBgCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function IllustrationMonsterBgCtrl:Update()
    self._bookTemplate:OnCtrlUpdate()
    self._rewardTemplate:OnCtrlUpdate()
    self.TogTem:OnUpdate()
    self.TypeTogTem:OnUpdate()
end --func end
--next--
function IllustrationMonsterBgCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("GameEventMgr").l_eventDispatcher, MgrMgr:GetMgr("GameEventMgr").OnBagUpdate, self._refreshPoint)
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonsterBgCtrl:SelectTog(index)
    self.TogTem:SelectTemplate(index)
    if index == 1 then
        self._rewardTemplate:DeActiveTemplate()
        self._bookTemplate:ActiveTemplate()
        self._bookTemplate:SetData({})
        self.panel.Toggle_Normal_List_1:SetActiveEx(false)
    else
        self.TypeTogTem:ShowTemplates({ Datas = self.data.YUANSU_STR })
        self._bookTemplate:DeActiveTemplate()
        self._rewardTemplate:ActiveTemplate()
        self._rewardTemplate:SetData({})
        self.panel.Toggle_Normal_List_1:SetActiveEx(true)
        self:SelectTypeTog(1)
    end
end

function IllustrationMonsterBgCtrl:SelectTypeTog(elementType)
    if self.TypeTogTem then
        self.data.SetRewardBookSelectType(elementType)
        self.TypeTogTem:SelectTemplate(elementType)
        self.mgr.RefreshRewardBookPage()
    end
end

function IllustrationMonsterBgCtrl:SelectMonster(data)
    self:SelectTog(1)
    self._bookTemplate:AddLoadCallback(function()
        self._bookTemplate:OnSelectMonster(data)
    end)
end

function IllustrationMonsterBgCtrl:SelectBook(data)
    self:SelectTog(2)
    self._rewardTemplate:AddLoadCallback(function()
        self:SelectTypeTog(data.UnitAttrType + 1)
        self._rewardTemplate:OnSelectBook(data)
    end)
end
function IllustrationMonsterBgCtrl:_refreshPoint()
    local Count = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, 205)
    Count = tonumber(Count)
    local handBookLvTable = TableUtil.GetEntityHandBookLvTable().GetTable()
    local lastLv = self.lv
    self.lv = 0
    local SumPoint = 0
    if Count > handBookLvTable[#handBookLvTable].Point then
        self.lv = #handBookLvTable
        SumPoint = handBookLvTable[#handBookLvTable].Point
    elseif Count < handBookLvTable[1].Point then
        self.lv = 0
        SumPoint = handBookLvTable[1].Point
    else
        for i = 1, #handBookLvTable - 1 do
            if Count >= handBookLvTable[i].Point then
                self.lv = i
                SumPoint = handBookLvTable[i + 1].Point
            end
        end
    end

    self.panel.Slider.Slider.value = Count / SumPoint
    self.panel.Num.LabText = StringEx.Format("{0}/{1}", tostring(Count), tostring(SumPoint))
    self.panel.Text_Num.LabText = self.lv
    if not MgrMgr:GetMgr("BeginnerGuideMgr").CheckGuideMask(MGlobalConfig:GetInt("HandBookGuide")) and self.lv > 0 then
        self.panel.LvlRW:SetActiveEx(true)
        self.panel.Btn_MainReward:PlayDynamicEffect()
    else
        self.panel.LvlRW:SetActiveEx(false)
        self.panel.Btn_MainReward:StopDynamicEffect()
    end
end

--lua custom scripts end
return IllustrationMonsterBgCtrl