--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ItemAchievePanel = {}

--lua model end

--lua functions
---@class ItemAchievePanel.AchieveTpl
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field Title_01 MoonClient.MLuaUICom
---@field Text_Attr_2 MoonClient.MLuaUICom
---@field Text_Attr_1 MoonClient.MLuaUICom
---@field Text_Attr_0 MoonClient.MLuaUICom
---@field ShowSkillButton_1 MoonClient.MLuaUICom
---@field ShowSkillButton_0 MoonClient.MLuaUICom
---@field ShowSkillButton MoonClient.MLuaUICom
---@field QualityGood_2 MoonClient.MLuaUICom
---@field QualityGood_1 MoonClient.MLuaUICom
---@field QualityGood_0 MoonClient.MLuaUICom
---@field LvImage MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IconBg MoonClient.MLuaUICom
---@field EffectImageBuff_2 MoonClient.MLuaUICom
---@field EffectImageBuff_1 MoonClient.MLuaUICom
---@field EffectImageBuff_0 MoonClient.MLuaUICom
---@field BuffName_2 MoonClient.MLuaUICom
---@field BuffName_1 MoonClient.MLuaUICom
---@field BuffName_0 MoonClient.MLuaUICom
---@field Btn_Confirm MoonClient.MLuaUICom
---@field Attr_Wrap_2 MoonClient.MLuaUICom
---@field Attr_Wrap_1 MoonClient.MLuaUICom
---@field Attr_Wrap_0 MoonClient.MLuaUICom

---@class ItemAchievePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ObjContent MoonClient.MLuaUICom
---@field ItemAchievePanel MoonClient.MLuaUICom
---@field AchievePanelLayout MoonClient.MLuaUICom
---@field AchieveTpl ItemAchievePanel.AchieveTpl

---@return ItemAchievePanel
---@param ctrl UIBase
function ItemAchievePanel.Bind(ctrl)

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
return UI.ItemAchievePanel