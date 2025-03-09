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
---@class ServerItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field ServerItem MoonClient.MLuaUICom
---@field Img_Recommend MoonClient.MLuaUICom
---@field Img_New MoonClient.MLuaUICom
---@field Img MoonClient.MLuaUICom

---@class ServerItemTemplate : BaseUITemplate
---@field Parameter ServerItemTemplateParameter

ServerItemTemplate = class("ServerItemTemplate", super)
--lua class define end

--lua functions
function ServerItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ServerItemTemplate:OnDestroy()
	
	
end --func end
--next--
function ServerItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ServerItemTemplate:OnSetData(data)
	
	self.Parameter.ServerItem:AddClick(function()
		game:GetAuthMgr().EventDispatcher:Dispatch(EventConst.Names.UI_SET_TARGET_SERVER, data)
		UIMgr:DeActiveUI(UI.CtrlNames.SelectServer)
	end)
	self.Parameter.Text.LabText = data.servername
	self.Parameter.Img:SetSprite("CommonIcon", GameEnum.EGameServerState2Sprites[data.state])
	-- 若一个服务器同时配了【新服】和【推荐】标签，则显示【新服】标签
	if Common.Bit32.And(data.flag, GameEnum.EGameServerFlag.New) > 0 then
		self.Parameter.Img_New.gameObject:SetActiveEx(true)
		self.Parameter.Img_Recommend.gameObject:SetActiveEx(false)
	elseif Common.Bit32.And(data.flag, GameEnum.EGameServerFlag.Recommend) > 0 then
		self.Parameter.Img_New.gameObject:SetActiveEx(false)
		self.Parameter.Img_Recommend.gameObject:SetActiveEx(true)
	else
		self.Parameter.Img_New.gameObject:SetActiveEx(false)
		self.Parameter.Img_Recommend.gameObject:SetActiveEx(false)
	end
	
end --func end
--next--
function ServerItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ServerItemTemplate