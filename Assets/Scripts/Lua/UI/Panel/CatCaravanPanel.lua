--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CatCaravanPanel = {}

--lua model end

--lua functions
---@class CatCaravanPanel.TrainPrefab.CarriagePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Num MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Complete MoonClient.MLuaUICom
---@field Color MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Anim MoonClient.MLuaUICom

---@class CatCaravanPanel.TrainPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field OarAnim MoonClient.MLuaUICom
---@field NoneRt MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field FxRt_Yan MoonClient.MLuaUICom
---@field FxRt_Shui MoonClient.MLuaUICom
---@field CatAnim MoonClient.MLuaUICom
---@field Box MoonClient.MLuaUICom
---@field Boat MoonClient.MLuaUICom
---@field bg3 MoonClient.MLuaUICom
---@field bg2 MoonClient.MLuaUICom
---@field bg1 MoonClient.MLuaUICom
---@field CarriagePrefab CatCaravanPanel.TrainPrefab.CarriagePrefab

---@class CatCaravanPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Trains MoonClient.MLuaUICom
---@field PromptIcon MoonClient.MLuaUICom
---@field PromptBtn MoonClient.MLuaUICom
---@field Prompt MoonClient.MLuaUICom
---@field Monthlycard MoonClient.MLuaUICom
---@field MedalBtn MoonClient.MLuaUICom
---@field GMBtn2 MoonClient.MLuaUICom
---@field GMBtn1 MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Btn_Month MoonClient.MLuaUICom
---@field AllNoneTxt MoonClient.MLuaUICom
---@field AllNoneRt MoonClient.MLuaUICom
---@field AllNone MoonClient.MLuaUICom
---@field TrainPrefab CatCaravanPanel.TrainPrefab

---@return CatCaravanPanel
---@param ctrl UIBase
function CatCaravanPanel.Bind(ctrl)
	
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
return UI.CatCaravanPanel