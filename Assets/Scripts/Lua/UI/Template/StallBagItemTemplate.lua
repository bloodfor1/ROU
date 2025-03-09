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
---@class StallBagItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field ItemNumber MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class StallBagItemTemplate : BaseUITemplate
---@field Parameter StallBagItemTemplateParameter

StallBagItemTemplate = class("StallBagItemTemplate", super)
--lua class define end

--lua functions
function StallBagItemTemplate:Init()
	
	    super.Init(self)
	    self:SetSelected(false)
	    self.Parameter.ItemButton:AddClick(function ()
	        self:OnItemClicked()
	    end)
	
end --func end
--next--
function StallBagItemTemplate:OnDestroy()
	
	    self.itemTemplate = nil
	
end --func end
--next--
function StallBagItemTemplate:OnDeActive()
	
	
end --func end
--next--
function StallBagItemTemplate:OnSetData(data)
    if not data then
        self.Parameter.ItemIcon.gameObject:SetActiveEx(false)
        self.Parameter.ItemCount.gameObject:SetActiveEx(false)
        return
    end
    self.isFastMounting = data.isFastMounting
    ---@type ItemData
    self.itemData = data.itemData
    self.Parameter.ItemIcon.gameObject:SetActiveEx(true)
    self.Parameter.ItemCount.gameObject:SetActiveEx(true)
    if not self.itemTemplate then
        self.itemTemplate = self:NewTemplate("ItemTemplate",{
            TemplateParent = self.Parameter.ItemIcon.gameObject.transform,
        })
    end
    local l_serverLevel = self:GetItemServerLevelLimit()
    self.itemTemplate:SetData({ ID = self.itemData.TID, Count = self.itemData.ItemCount, IsGray = self.itemData.IsBind or MPlayerInfo.ServerLevel < l_serverLevel, IsShowTips = false })
    --设置选中状态, 由于控件会复用, 需要根据数据刷新状态
    self:SetSelected(self.isItemSelected and not self.itemData.IsBind)

end --func end
--next--
function StallBagItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function StallBagItemTemplate:SetSelected(isSelected)
    if self.isSelected == isSelected then return end

    self.isSelected = isSelected
    if self.itemData then
        self.isItemSelected = isSelected
    end

    self.Parameter.Selected.gameObject:SetActiveEx(isSelected)
end

function StallBagItemTemplate:IsSelected()
    return self.isSelected
end

function StallBagItemTemplate:OnItemClicked()
    if not self.itemData or not self:CheckValid() then return end

    local l_stallMgr = MgrMgr:GetMgr("StallMgr")
    --是否来自快速上架界面
    if self.isFastMounting then
        l_stallMgr.EventDispatcher:Dispatch(l_stallMgr.ON_FAST_SELL_ITEM_CLICKED, self)
    else
        l_stallMgr.EventDispatcher:Dispatch(l_stallMgr.ON_CLICK_SELL_SELECT_ITEM, self)
    end

end

function StallBagItemTemplate:GetItemServerLevelLimit()
    if not self.itemData then return 0 end
    local l_target = MgrMgr:GetMgr("StallMgr").g_tableItemInfo[self.itemData.TID]
    if not l_target then
        logError("item not find@李韬,id:" .. tostring(self.itemData.TID))
        return -1
    end
    return l_target.info.ServerLevelLimit
end

function StallBagItemTemplate:CheckValid()
    if self.itemData.IsBind then
        --是绑定提示
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BIND_NOT_STALL"))
        return false
    end
    local l_serverLevel = self:GetItemServerLevelLimit()
    if l_serverLevel == -1 then return false end
    if MPlayerInfo.ServerLevel < l_serverLevel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("STALL_SERVER_LIMIT_SELL"),
                l_serverLevel))
        return false
    end
    return true
end
--lua custom scripts end
return StallBagItemTemplate