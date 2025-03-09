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
---@class FarmPromptMonsterItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field icon MoonClient.MLuaUICom

---@class FarmPromptMonsterItem : BaseUITemplate
---@field Parameter FarmPromptMonsterItemParameter

FarmPromptMonsterItem = class("FarmPromptMonsterItem", super)
--lua class define end

--lua functions
function FarmPromptMonsterItem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function FarmPromptMonsterItem:OnDeActive()
	
	
end --func end
--next--
function FarmPromptMonsterItem:OnSetData(data)
	
	    local entitySdata = TableUtil.GetEntityTable().GetRowById(data.monsId)
	    if not entitySdata then
	        return logError("EntityTable 读取失败 Id = {0}", data.monsId)
	    end
	    local presentSdata = TableUtil.GetPresentTable().GetRowById(entitySdata.PresentID)
	    if not presentSdata then
	        return logError("PresentTable 读取失败 Id = {0}", entitySdata.PresentID)
	    end
	    self.Parameter.icon:SetSprite(tostring(presentSdata.Atlas), tostring(presentSdata.Icon))
	    self.Parameter.icon.Img.enabled = true
	    MLuaUIListener.Get(self.Parameter.icon.gameObject)
	    self.Parameter.icon.Listener.onClick = function(obj, eventData)
	        local clickWorldPos = MUIManager.UICamera:ScreenToWorldPoint(Vector3(eventData.position.x, eventData.position.y, 0))
	        MgrMgr:GetMgr("TipsMgr").ShowMonsterInfoTips(data.monsId, clickWorldPos, true, nil, nil)
	    end
	    local l_scrollViewObj=self.Parameter.icon.Transform.parent.parent.parent.gameObject
	    self.Parameter.icon.Listener.beginDrag =function(obj, eventData)
	        MLuaCommonHelper.ExecuteBeginDragEvent(l_scrollViewObj,eventData)
	    end
	    self.Parameter.icon.Listener.onDrag =function(obj, eventData)
	        MLuaCommonHelper.ExecuteDragEvent(l_scrollViewObj,eventData)
	    end
	    self.Parameter.icon.Listener.endDrag =function(obj, eventData)
	        MLuaCommonHelper.ExecuteEndDragEvent(l_scrollViewObj,eventData)
	    end
	
end --func end
--next--
function FarmPromptMonsterItem:BindEvents()
	
	
end --func end
--next--
function FarmPromptMonsterItem:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return FarmPromptMonsterItem