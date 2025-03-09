module("UI.RolePanel", package.seeall)
function Bind(ctrl)
    --dont override this function
    ---@type MoonClient.MLuaUIPanel
    local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
    ctrl:OnBindPanel(panelRef)
    return BindMLuaPanel(panelRef)
end
