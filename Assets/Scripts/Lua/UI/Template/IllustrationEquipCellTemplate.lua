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
---@class IllustrationEquipCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Bg MoonClient.MLuaUICom
---@field SelectPanel MoonClient.MLuaUICom
---@field EquipImage MoonClient.MLuaUICom
---@field TypeIcon MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom
---@field EquipButton MoonClient.MLuaUICom

---@class IllustrationEquipCellTemplate : BaseUITemplate
---@field Parameter IllustrationEquipCellTemplateParameter

IllustrationEquipCellTemplate = class("IllustrationEquipCellTemplate", super)
--lua class define end

--lua functions
function IllustrationEquipCellTemplate:Init()
    super.Init(self)
end --func end
--next--
function IllustrationEquipCellTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function IllustrationEquipCellTemplate:OnSetData(data)
    self:ShowEquipCellInfo(data)
end --func end
--next--
function IllustrationEquipCellTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function IllustrationEquipCellTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationEquipCellTemplate:ShowEquipCellInfo(equipData)

    local itemSdata = TableUtil.GetItemTable().GetRowByItemID(equipData.Id)
    if not itemSdata then
        return
    end

    local l_mgr = MgrMgr:GetMgr("IllustrationMgr")
    self.Parameter.Bg:SetSpriteAsync(Data.BagModel.getItemBgAtlas(), Data.BagModel:getItemBgById(itemSdata.ItemID))
    --图片
    self.Parameter.EquipImage:SetSprite(equipData.ItemAtlas, equipData.ItemIcon, true)
    --点击状态
    local clickState = not l_mgr.SelectEquipId and (equipData.tableIndex == MgrMgr:GetMgr("IllustrationMgr").GetEquipListTemplateIndex()) and (self.ShowIndex == MgrMgr:GetMgr("IllustrationMgr").GetEquipCellTemplateIndex())
    self:SetEquipSelectState(clickState)
    --点击事件
    self.Parameter.EquipButton:AddClick(function()
        --改变选中状态
        self:_showSelectEquip(equipData)
    end)

    self.Parameter.TypeIcon:SetActiveEx(false)
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Suit) and equipData.SuitID and equipData.SuitID > 0 then
        self.Parameter.TypeIcon:SetSpriteAsync("FontSprite", "UI_Common_Taozhuangbiaoshi.png")
        self.Parameter.TypeIcon:SetActiveEx(true)
    else
        self.Parameter.TypeIcon:SetActiveEx(false)
    end

    --稀有度
    self.Parameter.Rare:SetActiveEx(false)
    local l_selectEquipId = l_mgr.SelectEquipId
    if l_selectEquipId then
        if equipData.Id == l_selectEquipId then
            l_mgr.SelectEquipId = nil
            l_mgr.SelectTableData = nil
            self:SetEquipSelectState(true)
            MgrMgr:GetMgr("IllustrationMgr").SetEquipListTemplateIndex(equipData.tableIndex)
            MgrMgr:GetMgr("IllustrationMgr").SetEquipCellTemplateIndex(self.ShowIndex)
        end
    end
end

function IllustrationEquipCellTemplate:_showSelectEquip(equipData)
    MgrMgr:GetMgr("IllustrationMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("IllustrationMgr").ILLUSTRATION_SELECT_EQUIP, equipData)
    self:SetEquipSelectState(true)
    --记录位置
    MgrMgr:GetMgr("IllustrationMgr").SetEquipListTemplateIndex(equipData.tableIndex)
    MgrMgr:GetMgr("IllustrationMgr").SetEquipCellTemplateIndex(self.ShowIndex)
end

function IllustrationEquipCellTemplate:SetEquipSelectState(isSelect)
    self.Parameter.SelectPanel.gameObject:SetActiveEx(isSelect)
end
--lua custom scripts end
return IllustrationEquipCellTemplate