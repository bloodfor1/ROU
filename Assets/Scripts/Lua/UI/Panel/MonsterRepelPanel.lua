--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MonsterRepelPanel = {}

--lua model end

--lua functions
---@class MonsterRepelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tmp_expelTitle MoonClient.MLuaUICom
---@field RepelBG MoonClient.MLuaUICom
---@field questionButton MoonClient.MLuaUICom
---@field openBlessBtn MoonClient.MLuaUICom
---@field maxBlessingTimetTxt MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field expelLeftTimeTip MoonClient.MLuaUICom
---@field expelLeftTime MoonClient.MLuaUICom
---@field expelContext MoonClient.MLuaUICom
---@field closeButton MoonClient.MLuaUICom
---@field closeBlessBtn MoonClient.MLuaUICom
---@field BuffUpIcon MoonClient.MLuaUICom
---@field BuffUpBtn MoonClient.MLuaUICom
---@field BuffTime MoonClient.MLuaUICom
---@field BuffName MoonClient.MLuaUICom
---@field BuffInfoBackBtn MoonClient.MLuaUICom
---@field BuffInfo MoonClient.MLuaUICom
---@field BuffIcon MoonClient.MLuaUICom
---@field BuffDes MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom
---@field AutoBackTog MoonClient.MLuaUICom

---@return MonsterRepelPanel
---@param ctrl UIBase
function MonsterRepelPanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.MonsterRepelPanel