--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
OccupationPanel = {}

--lua model end

--lua functions
---@class OccupationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleProfessionText MoonClient.MLuaUICom
---@field TextTask MoonClient.MLuaUICom
---@field TextLevel MoonClient.MLuaUICom
---@field TaskCheck MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom[]
---@field proTreeScrollView MoonClient.MLuaUICom
---@field ProfessionNum MoonClient.MLuaUICom[]
---@field ProfessionItem MoonClient.MLuaUICom[]
---@field Open MoonClient.MLuaUICom[]
---@field NotFinishTask MoonClient.MLuaUICom
---@field NotFinishLv MoonClient.MLuaUICom
---@field NotExist MoonClient.MLuaUICom
---@field NameE MoonClient.MLuaUICom[]
---@field NameC MoonClient.MLuaUICom[]
---@field Name MoonClient.MLuaUICom[]
---@field ModelImage MoonClient.MLuaUICom[]
---@field LevelCheck MoonClient.MLuaUICom
---@field Letter MoonClient.MLuaUICom[]
---@field ImageUp MoonClient.MLuaUICom
---@field ImageDown MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom[]
---@field HeadDummy MoonClient.MLuaUICom[]
---@field FinishTask MoonClient.MLuaUICom
---@field FinishLv MoonClient.MLuaUICom
---@field ExistAttr MoonClient.MLuaUICom
---@field Close MoonClient.MLuaUICom[]
---@field ChangeNeedJobLv MoonClient.MLuaUICom
---@field ChangeNeedBaseLv MoonClient.MLuaUICom
---@field ButtonTask MoonClient.MLuaUICom
---@field ButtonLevel MoonClient.MLuaUICom
---@field BtnShowProfession MoonClient.MLuaUICom
---@field BgBeforDontExist MoonClient.MLuaUICom
---@field BgBefor MoonClient.MLuaUICom
---@field BgAfterDontExist MoonClient.MLuaUICom
---@field BgAfter MoonClient.MLuaUICom
---@field Attr_8 MoonClient.MLuaUICom
---@field Attr_7 MoonClient.MLuaUICom
---@field Attr_6 MoonClient.MLuaUICom
---@field Attr_5 MoonClient.MLuaUICom
---@field Attr_4 MoonClient.MLuaUICom
---@field Attr_3 MoonClient.MLuaUICom
---@field Attr_2 MoonClient.MLuaUICom
---@field Attr_1 MoonClient.MLuaUICom

---@return OccupationPanel
---@param ctrl UIBase
function OccupationPanel.Bind(ctrl)
	
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
return UI.OccupationPanel