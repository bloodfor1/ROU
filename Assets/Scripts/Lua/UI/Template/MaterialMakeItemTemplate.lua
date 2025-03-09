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
---@class MaterialMakeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockText MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field MaterialIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field CanMakeFlag MoonClient.MLuaUICom

---@class MaterialMakeItemTemplate : BaseUITemplate
---@field Parameter MaterialMakeItemTemplateParameter

MaterialMakeItemTemplate = class("MaterialMakeItemTemplate", super)
--lua class define end

--lua functions
function MaterialMakeItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MaterialMakeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function MaterialMakeItemTemplate:OnSetData(data)
	
	    self.data = data
	    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(data.ID)
	    self.Parameter.MaterialIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon, true)
	    self.Parameter.Name.LabText = l_itemData.ItemName
	    --解锁条件显示
	    if MgrMgr:GetMgr("MaterialMakeMgr").CheckIsUnlock(data.Unlock) then
	        self.Parameter.UnlockText.UObj:SetActiveEx(false)
	    else
	        self.Parameter.UnlockText.UObj:SetActiveEx(true)
	        local l_skillData = TableUtil.GetSkillTable().GetRowById(data.Unlock:get_Item(0))
	        self.Parameter.UnlockText.LabText = StringEx.Format(Lang("LIMIT_SKILL_LEVEL_UNLOCK"), l_skillData.Name, data.Unlock:get_Item(1))
	    end
	    --可制造标志显示控制
	    self.Parameter.CanMakeFlag.UObj:SetActiveEx(MgrMgr:GetMgr("MaterialMakeMgr").CheckCanMake(data.Cost, 1))
	    --点击事件
	    self.Parameter.ItemButton:AddClick(function()
	        self:MethodCallback(self)
	    end)
	
end --func end
--next--
function MaterialMakeItemTemplate:BindEvents()
	
	
end --func end
--next--
function MaterialMakeItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function MaterialMakeItemTemplate:SetSelect(isSelected)
    self.Parameter.Selected.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return MaterialMakeItemTemplate