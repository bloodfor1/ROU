--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LakeListPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
LakeListCtrl = class("LakeListCtrl", super)
local l_themePartyMgr = nil
--lua class define end

--lua functions
function LakeListCtrl:ctor()

    super.ctor(self, CtrlNames.LakeList, UILayer.Function, nil, ActiveType.Normal)
    l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.LakeList
    self.overrideSortLayer = UILayerSort.Normal + 2
end --func end
--next--
function LakeListCtrl:Init()

    self.panel = UI.LakeListPanel.Bind(self)
    super.Init(self)

    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.LakeList)
    end)

    self.panel.BtnRefresh:AddClick(function()
        --刷新
        l_themePartyMgr.ThemePartyGetNearbyPerson(true)
    end)

    self.panel.TogLake.TogEx.onValueChanged:AddListener(function(state)
        --打开界面获取点赞列表
        if state then
            l_themePartyMgr.l_curToggleState = l_themePartyMgr.l_lakeState.Lake
            l_themePartyMgr.ThemePartyGetLoveInfo()
        end
    end)
    self.panel.TogNearBy.TogEx.onValueChanged:AddListener(function(state)
        --打开界面获取附近列表
        if state then
            l_themePartyMgr.l_curToggleState = l_themePartyMgr.l_lakeState.NearBy
            l_themePartyMgr.ThemePartyGetNearbyPerson(false)
            self.panel.BtnRefresh:SetActiveEx(l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.NearBy)
        end
    end)
    self.ContentData = {}
    self:InintContent()
end --func end
--next--
function LakeListCtrl:Uninit()
    self.lakeListTemplatePool = nil
    self.ContentData = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function LakeListCtrl:OnActive()
    if l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.Lake then
        self.panel.TogLake.TogEx.isOn = true
    end
    if l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.NearBy then
        self.panel.TogNearBy.TogEx.isOn = true
    end
end --func end
--next--
function LakeListCtrl:OnDeActive()
    self:DestoryModel()
end --func end
--next--
function LakeListCtrl:Update()
    if self.panel.BtnRefreshtxt then
        if l_themePartyMgr.l_nearByLeftTime > 0 then
            self.panel.BtnRefreshtxt.LabText = Common.Functions.SecondsToTimeStr(l_themePartyMgr.l_nearByLeftTime)
        else
            self.panel.BtnRefreshtxt.LabText = Lang("UPDATE_LAKE")
        end
    end
end --func end

--next--
function LakeListCtrl:BindEvents()
    self:BindEvent(l_themePartyMgr.EventDispatcher, l_themePartyMgr.ON_GET_LAKE, function()
        if self.panel.TogLake.TogEx.isOn then
            self:SetContenData(l_themePartyMgr.l_lakeDataList)
        end
        if self.panel.TogNearBy.TogEx.isOn then
            self:SetContenData(l_themePartyMgr.l_nearByDataList)
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function LakeListCtrl:InintContent()
    self.lakeListTemplatePool=self:NewTemplatePool({
        TemplateClassName="LakeTpl",
        TemplatePrefab=self.panel.LakeTpl.gameObject,
        TemplateParent=self.panel.Content.transform,
    })
end

function LakeListCtrl:SetContenData(data)
    if data then
        self.ContentData = data
        self.panel.NoLake:SetActiveEx(table.maxn(self.ContentData) <= 0)
        self.panel.NoModel:SetActiveEx(table.maxn(self.ContentData) <= 0)
        self.panel.ModelImage:SetActiveEx(not (table.maxn(self.ContentData) <= 0))
        self.lakeListTemplatePool:ShowTemplates({
            Datas=self.ContentData,
            Method = function(data)
                self:ShowModelPanel(data)
            end,
        })
        if #self.ContentData > 0 then
            self:ShowModelPanel(self.ContentData[1])
        end
    end
    self.panel.BtnRefresh:SetActiveEx(l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.NearBy)
    self.panel.No_Text.LabText = l_themePartyMgr.l_curToggleState == l_themePartyMgr.l_lakeState.Lake and Lang("No_Lake") or Lang("No_NEARBY")
end

function LakeListCtrl:ShowModelPanel(data)
    if data == nil then return end
    self:DestoryModel()
    self.panel.FashionNum.LabText = data.outlook.fashion_count
    self.model = Common.CommonUIFunc.CreateModelEntity(data, self.panel.ModelImage, false, true)
    self:SaveModelData(self.model)
end

function LakeListCtrl:DestoryModel()
    if self.model then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end

--lua custom scripts end
return LakeListCtrl