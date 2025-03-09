--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TalkDlg2Panel = {}

--lua model end

--lua functions
---@class TalkDlg2Panel.TalkDlgBtnTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Raycast MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnTpl MoonClient.MLuaUICom
---@field Animation MoonClient.MLuaUICom

---@class TalkDlg2Panel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskSelectList MoonClient.MLuaUICom
---@field talkName MoonClient.MLuaUICom
---@field talkContent MoonClient.MLuaUICom
---@field SelectList MoonClient.MLuaUICom
---@field RoleImg MoonClient.MLuaUICom
---@field Raycast MoonClient.MLuaUICom
---@field playerTalkName MoonClient.MLuaUICom
---@field NormalSelectList MoonClient.MLuaUICom
---@field ImgUp MoonClient.MLuaUICom
---@field ImgDown MoonClient.MLuaUICom
---@field ImagePlayer MoonClient.MLuaUICom
---@field ImageNpc MoonClient.MLuaUICom
---@field Fx MoonClient.MLuaUICom
---@field FuncSelectList MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field btnClick MoonClient.MLuaUICom
---@field Btn_next MoonClient.MLuaUICom
---@field Anchor MoonClient.MLuaUICom
---@field TalkDlgBtnTemplate TalkDlg2Panel.TalkDlgBtnTemplate

---@return TalkDlg2Panel
---@param ctrl UIBase
function TalkDlg2Panel.Bind(ctrl)
	
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
return UI.TalkDlg2Panel