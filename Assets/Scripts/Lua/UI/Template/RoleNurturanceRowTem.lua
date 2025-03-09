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
---@class RoleNurturanceRowTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SliderValue MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field InfoText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field GMBtn MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field Btn_Go MoonClient.MLuaUICom
---@field Btn_Click MoonClient.MLuaUICom

---@class RoleNurturanceRowTem : BaseUITemplate
---@field Parameter RoleNurturanceRowTemParameter

RoleNurturanceRowTem = class("RoleNurturanceRowTem", super)
--lua class define end

--lua functions
function RoleNurturanceRowTem:Init()

    super.Init(self)
    self.Parameter.Btn_Click:AddClick(function()
        self.Parameter.Progress:SetActiveEx(not self.Parameter.Progress.UObj.activeSelf)
    end)
    self.Parameter.GMBtn:AddClick(function()
        self.Parameter.SliderValue:SetActiveEx(not self.Parameter.SliderValue.UObj.activeSelf)
    end)

end --func end
--next--
function RoleNurturanceRowTem:BindEvents()


end --func end
--next--
function RoleNurturanceRowTem:OnDestroy()


end --func end
--next--
function RoleNurturanceRowTem:OnDeActive()


end --func end
--next--
---@param data NurturanceRowData
function RoleNurturanceRowTem:OnSetData(data)
    self.Parameter.Slider.Slider.value = data.SliderValue
    self.Parameter.Name.LabText = data.RowInfo.SystemName
    self.Parameter.Describe.LabText = data.RowInfo.Describe
    self.Parameter.Icon:SetSprite(data.RowInfo.Atlas, data.RowInfo.Icon)
    self.Parameter.Recommend:SetActiveEx(self.ShowIndex <= 3)
    self.Parameter.Btn_Go:AddClick(function()
        MgrMgr:GetMgr("RoleNurturanceMgr").ClickGoto(data.RowInfo.SystemId)
    end)
    self.Parameter.Progress:SetActiveEx(false)
    self.Parameter.SliderValue:SetActiveEx(false)
    self.Parameter.GMBtn:SetActiveEx(MGameContext.IsOpenGM)
    self.Parameter.SliderValue.LabText = StringEx.Format("{0}/{1}", data.CurrentScore, data.Score)
    self.Parameter.InfoText:SetActiveEx(false)
    --self.Parameter.InfoText.LabText = Common.Utils.Lang("ROLE_NURTURANCE_VALUE_INFO_0")
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RoleNurturanceRowTem