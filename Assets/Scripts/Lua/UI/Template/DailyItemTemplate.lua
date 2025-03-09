--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class DailyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field tip MoonClient.MLuaUICom
---@field RecommandFx MoonClient.MLuaUICom
---@field Recommand1 MoonClient.MLuaUICom
---@field Recommand_other MoonClient.MLuaUICom
---@field Recommand MoonClient.MLuaUICom
---@field NormalIcon MoonClient.MLuaUICom
---@field NameWrap MoonClient.MLuaUICom
---@field NameBag MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field name MoonClient.MLuaUICom
---@field lvCondition MoonClient.MLuaUICom
---@field InfoFinish MoonClient.MLuaUICom
---@field iconBtn MoonClient.MLuaUICom
---@field force MoonClient.MLuaUICom
---@field finishMask MoonClient.MLuaUICom
---@field DailyItem MoonClient.MLuaUICom
---@field costObj MoonClient.MLuaUICom
---@field cost MoonClient.MLuaUICom
---@field CheckMask MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom

---@class DailyItemTemplate : BaseUITemplate
---@field Parameter DailyItemTemplateParameter

DailyItemTemplate = class("DailyItemTemplate", super)
--lua class define end

--lua functions
function DailyItemTemplate:Init()

    super.Init(self)
    self.mgr = MgrMgr:GetMgr("DelegateModuleMgr")
    self.recommendFx = nil
    self.Parameter.RecommandFx:SetActiveEx(false)
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.RecommandFx.RawImg
    l_fxData.scaleFac = Vector3.New(30, 30, 30)
    l_fxData.loadedCallback = function()
        self.Parameter.RecommandFx.gameObject:SetActiveEx(true)
    end
    l_fxData.destroyHandler = function()
        self.recommendFx = nil
        self.Parameter.RecommandFx.gameObject:SetActiveEx(false)
    end
    self.recommendFx = self:CreateUIEffect(l_recommandFxPath, l_fxData)


end --func end
--next--
function DailyItemTemplate:OnDestroy()


end --func end
--next--
function DailyItemTemplate:OnDeActive()


end --func end
--next--
function DailyItemTemplate:OnSetData(data)
    local sdata = TableUtil.GetEntrustActivitiesTable().GetRowByMajorID(data.id)
    if not sdata then
        logError("find entrust activity sdata fail @戴瑞轩", data.id)
        return
    end
    local isFinish = data.isFinish > 0
    local baseLv = self.mgr.GetDelegateJoinBaseLv(data)
    local isOpen = MPlayerInfo.Lv >= baseLv
    local isNormal = sdata.ActivityType == 1
    local cost = 0
    local l_costs = Common.Functions.VectorSequenceToTable(sdata.Cost)
    if #l_costs > 0 then
        cost = l_costs[1][2]
    end
    self.Parameter.NameBag:SetActiveEx(true)
    if not isFinish then
        self.Parameter.Recommand:SetActiveEx(sdata.RecommendationLabel == self.mgr.EDelegateRecommendLevel.Lv2)
        self.Parameter.Recommand_other:SetActiveEx(sdata.RecommendationLabel == self.mgr.EDelegateRecommendLevel.Lv1)
    else
        self.Parameter.Recommand:SetActiveEx(false)
        self.Parameter.Recommand_other:SetActiveEx(false)
    end
    self.Parameter.finishMask:SetActiveEx(isFinish)
    self.Parameter.force:SetActiveEx(not isNormal)
    self.Parameter.NormalIcon:SetActiveEx(isNormal)
    self.Parameter.CheckMask:SetActiveEx(false)
    self.Parameter.name.LabText = sdata.ActivityName
    self.Parameter.Name.LabText = sdata.ActivityName
    self.Parameter.lvCondition:SetActiveEx(not isOpen)
    if isNormal then
        self.Parameter.NormalIcon:SetSpriteAsync(sdata.AtlasHeraldry, sdata.HeraldryIcon)
    else
        self.Parameter.force:SetSpriteAsync(sdata.AtlasHeraldry, sdata.HeraldryIcon)
    end
    if not isFinish then
        if not isOpen then
            self.Parameter.lvCondition.LabText = "Lv." .. tostring(baseLv) --Lang("DELEGATE_TASK_TIP1", baseLv)
        end
        
        if cost > 0 then
            self.Parameter.cost.LabText = Lang("DELEGATE_TASK_COST", cost)
        end
        self.Parameter.lvCondition:SetActiveEx(MPlayerInfo.Lv < baseLv)
        self.Parameter.cost:SetActiveEx(cost > 0)
        self.Parameter.costObj:SetActiveEx(cost > 0)
    else
        self.Parameter.lvCondition:SetActiveEx(false)
        self.Parameter.cost:SetActiveEx(false)
        self.Parameter.costObj:SetActiveEx(false)
    end
    self.Parameter.DailyItem:AddClick(function()
        self.MethodCallback(self.ShowIndex, data, self)
    end)
    self.Parameter.tip:SetActiveEx(false)
    self.Parameter.tip:SetActiveEx(true)
    self.Parameter.iconBtn:AddClick(function()
        local propInfo = Data.BagModel:CreateItemWithTid(GameEnum.l_virProp.Certificates)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, self:transform(), nil, { IsShowCloseButton = false })
    end)

    local l_count = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Certificates)
    self.Parameter.cost.LabColor = cost > l_count and Color.red or Color.black
end --func end
--next--
function DailyItemTemplate:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts
l_recommandFxPath = "Effects/Prefabs/Creature/Ui/Fx_ui_weituo_xx"

function DailyItemTemplate:OnSelect()
    self.Parameter.CheckMask:SetActiveEx(true)
    self.Parameter.name:SetActiveEx(false)
end

function DailyItemTemplate:OnDeselect()
    self.Parameter.CheckMask:SetActiveEx(false)
    self.Parameter.name:SetActiveEx(true)
end

function DailyItemTemplate:Uninit()
    if self.recommendFx ~= nil then
        self:DestroyUIEffect(self.recommendFx)
        self.recommendFx = nil
    end
    super.Uninit(self)

end --func end
--lua custom scripts end
return DailyItemTemplate