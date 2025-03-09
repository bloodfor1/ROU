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
---@class ForgeEquipTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UseLevel MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field ForgedSign MoonClient.MLuaUICom
---@field EquipPosition MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field EquipButton MoonClient.MLuaUICom

---@class ForgeEquipTemplate : BaseUITemplate
---@field Parameter ForgeEquipTemplateParameter

ForgeEquipTemplate = class("ForgeEquipTemplate", super)
--lua class define end

--lua functions
function ForgeEquipTemplate:OnSetData(data)
    self:showEquipItem(data)
end --func end
--next--
function ForgeEquipTemplate:Init()
    super.Init(self)
    self.Parameter.Recommend.gameObject:SetActiveEx(false)
    self._equipItemTemplate = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.Parameter.EquipIconBg.gameObject.transform,
    })
end --func end
--next--
function ForgeEquipTemplate:OnDeActive()

    -- do nothing

end --func end
--next--
function ForgeEquipTemplate:OnDestroy()

    -- do nothing

end --func end
--next--
function ForgeEquipTemplate:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
--equipForgeData为EquipForgeTable表数据
function ForgeEquipTemplate:showEquipItem(equipForgeData)
    self.data = equipForgeData
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(equipForgeData.Id)
    self._equipItemTemplate:SetData({
        ID = equipForgeData.Id,
        IsShowCount = false,
    })

    self.Parameter.EquipIcon:SetActiveEx(false)
    self.Parameter.Name.LabText = itemTableInfo.ItemName
    local l_useLevel = itemTableInfo.LevelLimit:get_Item(0)
    if l_useLevel <= 0 then
        l_useLevel = 1
    end

    self.Parameter.UseLevel.LabText = "Lv." .. tostring(l_useLevel)
    self.Parameter.GenreText.gameObject:SetActiveEx(false)
    self.Parameter.EquipPosition.gameObject:SetActiveEx(true)
    if MgrMgr:GetMgr("EquipMgr").IsWeapon(equipForgeData.Id) then
        local genreText = MgrMgr:GetMgr("EquipMgr").GetGenreText(equipForgeData.Id)
        self.Parameter.EquipPosition.gameObject:SetActiveEx(true)
        if genreText ~= nil then
            self.Parameter.EquipPosition.LabText = Common.Utils.Lang("Equip_Genre") .. "：" .. genreText
        else
            self.Parameter.EquipPosition.LabText = Lang("Equip_PositionText") .. "：" .. MgrMgr:GetMgr("EquipMgr").GetEquipTypeName(equipForgeData.Id)
        end
    else
        self.Parameter.EquipPosition.LabText = Lang("Equip_PositionText") .. "：" .. MgrMgr:GetMgr("EquipMgr").GetEquipTypeName(equipForgeData.Id)
        self.Parameter.EquipPosition.gameObject:SetActiveEx(true)
    end

    self.Parameter.ItemButton:AddClick(function()
        self:MethodCallback(equipForgeData, self.ShowIndex)
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
    end)

    self.Parameter.EquipButton:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(equipForgeData.Id, self.Parameter.EquipButton.transform)
    end)

    self:ShowRedSign()
    self:_setSelect(MgrMgr:GetMgr("ForgeMgr").CurrentSelectIndex == self.ShowIndex)
    if MgrMgr:GetMgr("ForgeMgr").IsCanForge(equipForgeData) then
        self.Parameter.Prefab.CanvasGroup.alpha = 1
    else
        self.Parameter.Prefab.CanvasGroup.alpha = 0.6
    end

    if MgrMgr:GetMgr("ForgeMgr").IsForged(equipForgeData.Id) then
        self.Parameter.ForgedSign:SetActiveEx(true)
    else
        self.Parameter.ForgedSign:SetActiveEx(false)
    end
end

--显示装备上的红点
function ForgeEquipTemplate:ShowRedSign()
    if self.data == nil then
        return
    end

    local l_forgeMgr = MgrMgr:GetMgr("ForgeMgr")
    local l_isRecommend = l_forgeMgr.IsRecommend(self.data)
    local isShow = l_forgeMgr.IsForgeMaterialsEnough(self.data)
    self.Parameter.ItemPrompt.gameObject:SetActiveEx(isShow and l_isRecommend)
end

function ForgeEquipTemplate:OnSelect()
    self:_setSelect(true)
end

function ForgeEquipTemplate:OnDeselect()
    self:_setSelect(false)
end

function ForgeEquipTemplate:_setSelect(isShow)
    self.Parameter.Selected.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return ForgeEquipTemplate