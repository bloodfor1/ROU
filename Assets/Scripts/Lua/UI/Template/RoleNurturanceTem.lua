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
---@class RoleNurturanceTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ViewList MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field RoleNurturanceRowTem MoonClient.MLuaUIGroup

---@class RoleNurturanceTem : BaseUITemplate
---@field Parameter RoleNurturanceTemParameter

RoleNurturanceTem = class("RoleNurturanceTem", super)
--lua class define end

--lua functions
function RoleNurturanceTem:Init()

    super.Init(self)
    self.RoleNurturanceRowTem = nil
    self.data = DataMgr:GetData("RoleNurturanceData")
    self.mgr = MgrMgr:GetMgr("RoleNurturanceMgr")

end --func end
--next--
function RoleNurturanceTem:BindEvents()


end --func end
--next--
function RoleNurturanceTem:OnDestroy()


end --func end
--next--
function RoleNurturanceTem:OnDeActive()


end --func end
--next--
---@param data NurturanceRowData
function RoleNurturanceTem:OnSetData(data)
    if self.RoleNurturanceRowTem == nil then
        self.RoleNurturanceRowTem = self:NewTemplatePool({
            TemplateClassName = "RoleNurturanceRowTem",
            TemplatePrefab = self.Parameter.RoleNurturanceRowTem.gameObject,
            ScrollRect = self.Parameter.ViewList.LoopScroll,
        })
    end
    local RoleNurturanceData = self.mgr.RefreshData(DataMgr:GetData("RoleNurturanceData").REFRESH_TYPE.Capra)
    local l_data = {}
    for k, v in pairs(RoleNurturanceData) do
        if not v.RowInfo.DisplayInRecommend then
            table.insert(l_data, v)
        end
    end
    self.RoleNurturanceRowTem:ShowTemplates({ Datas = l_data })

end --func end
--next--
--lua functions end

--lua custom scripts
RoleNurturanceTem.TemplatePath = "UI/Prefabs/RoleNurturanceTem"
--lua custom scripts end
return RoleNurturanceTem