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
---@class ProbablityBlockTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_BlockTitle MoonClient.MLuaUICom
---@field RowParent MoonClient.MLuaUICom
---@field ProbabilityRowTem MoonClient.MLuaUIGroup

---@class ProbablityBlockTem : BaseUITemplate
---@field Parameter ProbablityBlockTemParameter

ProbablityBlockTem = class("ProbablityBlockTem", super)
--lua class define end

--lua functions
function ProbablityBlockTem:Init()

    super.Init(self)
    self.rowTemPool = nil
end --func end
--next--
function ProbablityBlockTem:BindEvents()


end --func end
--next--
function ProbablityBlockTem:OnDestroy()
    self.rowTemPool = nil

end --func end
--next--
function ProbablityBlockTem:OnDeActive()


end --func end
--next--
---@param data ProbabilityDetails[]
function ProbablityBlockTem:OnSetData(data)
    self.Parameter.Text_BlockTitle.LabText = data[1].TypeName
    if not self.rowTemPool then
        self.rowTemPool = self:NewTemplatePool({
			TemplateClassName = "ProbabilityRowTem",
            TemplatePrefab = self.Parameter.ProbabilityRowTem.gameObject,
            TemplateParent = self.Parameter.RowParent.transform
        })
    end
    self.rowTemPool:ShowTemplates({ Datas = data })
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ProbablityBlockTem