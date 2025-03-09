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
---@class GuildDepositorySelectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IsLock MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class GuildDepositorySelectTemplate : BaseUITemplate
---@field Parameter GuildDepositorySelectTemplateParameter

GuildDepositorySelectTemplate = class("GuildDepositorySelectTemplate", super)
--lua class define end

--lua functions
function GuildDepositorySelectTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildDepositorySelectTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildDepositorySelectTemplate:OnDeActive()
	
	    self.data = nil
	
end --func end
--next--
function GuildDepositorySelectTemplate:OnSetData(data)
	
	    self.data = data
	    self.Parameter.IsLock.UObj:SetActiveEx(data.isLock)
	    self.Parameter.Name.LabText = Lang("GUILD_DEPOSITORY_PAGE", data.index)
	    self.Parameter.BtnSelect:AddClick(function ()
	        if not data.isLock then
	            self:MethodCallback()
	        else
	            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DEPOSITORY_UNLOCK_TIP"))
	        end
	    end)
	
end --func end
--next--
function GuildDepositorySelectTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildDepositorySelectTemplate