--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RankPanel = {}

--lua model end

--lua functions
---@class RankPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_FuncName MoonClient.MLuaUICom
---@field TogGroup_TimeStampParent MoonClient.MLuaUICom
---@field Title_Bg MoonClient.MLuaUICom
---@field Text_ShowFriend MoonClient.MLuaUICom
---@field ScrollRect_RankDetail MoonClient.MLuaUICom
---@field RefreshTips MoonClient.MLuaUICom
---@field RankRowScroll MoonClient.MLuaUICom
---@field RankNode MoonClient.MLuaUICom
---@field Obj_ShowFriend MoonClient.MLuaUICom
---@field Obj_RankDetail MoonClient.MLuaUICom
---@field Obj_Rank_List_Bg MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field MyRowBg MoonClient.MLuaUICom
---@field MyRow MoonClient.MLuaUICom
---@field Img_AlphaBg MoonClient.MLuaUICom
---@field Icon_Choice MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_ShowReward MoonClient.MLuaUICom
---@field Btn_Choice MoonClient.MLuaUICom
---@field RankTimeStampTem MoonClient.MLuaUIGroup
---@field RankDetailTem MoonClient.MLuaUIGroup
---@field RankNameTextTem MoonClient.MLuaUIGroup
---@field RankRowTem MoonClient.MLuaUIGroup

---@return RankPanel
---@param ctrl UIBase
function RankPanel.Bind(ctrl)
	
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
return UI.RankPanel