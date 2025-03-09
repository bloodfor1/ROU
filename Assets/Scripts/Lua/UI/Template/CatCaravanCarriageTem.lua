--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
--lua fields end

--lua class define
---@class CatCaravanCarriageTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Num MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Complete MoonClient.MLuaUICom
---@field Color MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Anim MoonClient.MLuaUICom

---@class CatCaravanCarriageTem : BaseUITemplate
---@field Parameter CatCaravanCarriageTemParameter

CatCaravanCarriageTem = class("CatCaravanCarriageTem", super)
--lua class define end

--lua functions
function CatCaravanCarriageTem:Init()
    super.Init(self)
end --func end
--next--
function CatCaravanCarriageTem:OnDestroy()
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, self)
end --func end
--next--
function CatCaravanCarriageTem:OnSetData(data)
    self.data = data
    self.netData = data.data
    self.tData = data.tData
    self.index = data.index
    self.isFull = self.netData.is_full
    self.Parameter.Icon:SetActiveEx(not self.isFull)
    self.Parameter.Num:SetActiveEx(not self.isFull)
    self.Parameter.Complete:SetActiveEx(self.isFull)
    self.Parameter.Color:SetActiveEx(not self.isFull)
    self.Parameter.LuaUIGroup.gameObject:SetRectTransformPos(0, 0)
    self.Parameter.Btn.Btn.enabled = not self.isFull
    if not self.isFull then
        local l_recycleRow = TableUtil.GetRecycleTable().GetRowByID(self.netData.item_id)
        if l_recycleRow ~= nil then
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_recycleRow.ItemID)
            if l_itemRow ~= nil then
                self.Parameter.Icon:SetSprite(l_itemRow.ItemAtlas, l_itemRow.ItemIcon, true)
            end
            self.Parameter.Btn:AddClick(function()
                if self.isFull then
                    return
                end
                if self.Parameter.Btn == nil then
                    return
                end
                local Pos = self.Parameter.Btn.transform.position
                UIMgr:ActiveUI(UI.CtrlNames.CatCaravanTips, function(ctrl)
                    ctrl:SetData(self.tData, self.netData, Pos)
                end)
            end, true)

            --数量
            local l_total = MgrMgr:GetMgr("CatCaravanMgr").GetCoinOrPropNumWithoutMultiTalentsEquip(l_recycleRow.ItemID)
            local l_color = (l_total >= self.netData.item_count) and RoColorTag.Green or RoColorTag.None
            self.Parameter.Num.LabText = GetColorText("X" .. self.netData.item_count, l_color)

            --道具改变事件
            gameEventMgr.Register(gameEventMgr.OnBagUpdate, self._onItemChange, self)
        end
    end

    if self.isFull then
        self.Parameter.Anim.SpineAnim.Loop = false
        self.Parameter.Anim.SpineAnim.TimeScale = 100
        self.Parameter.Anim.SpineAnim.AnimationName = "IDLE_02"
    else
        self.Parameter.Anim.SpineAnim.AnimationName = "IDLE_01"
    end
end --func end
--next--
function CatCaravanCarriageTem:OnDeActive()
    -- do nothing
end --func end
--lua functions end

--lua custom scripts
---@param itemInfo ItemUpdateData[]
function CatCaravanCarriageTem:_onItemChange(itemInfo)
    if nil == itemInfo then
        logError("CatCaravanCarriageTemplate: invalid param")
        return
    end

    if self.netData == nil then
        return
    end

    local l_recycleRow = TableUtil.GetRecycleTable().GetRowByID(self.netData.item_id)
    local l_change = false
    for i = 1, #itemInfo do
        local singleCompareInfo = itemInfo[i]:GetItemCompareData()
        if l_recycleRow.ItemID == singleCompareInfo.id then
            l_change = true
            break
        end
    end

    if l_change then
        self:ResetData()
    end
end

function CatCaravanCarriageTem:ResetData()
    if self.data == nil then
        return
    end

    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, self)
    local l_oldFull = self.isFull
    self:SetData(self.data)

    --或装满播动画
    if not l_oldFull and self.isFull then
        self.Parameter.Anim.SpineAnim.Loop = false
        self.Parameter.Anim.SpineAnim.TimeScale = 1
        self.Parameter.Anim.SpineAnim.AnimationName = "IDLE_02"
    end
end

--lua custom scripts end
return CatCaravanCarriageTem