module("UI.UIRootPanel", package.seeall)
function Bind(uobj)
    local l_panel = {}
    l_panel.PanelRef = uobj:GetComponent("MLuaUIPanel")
    return l_panel
end
