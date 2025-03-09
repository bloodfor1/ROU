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
---@class IllustrationMonsterTypeTogTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogL MoonClient.MLuaUICom
---@field Text_On MoonClient.MLuaUICom
---@field Text_Off MoonClient.MLuaUICom
---@field Templent MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field OFF MoonClient.MLuaUICom

---@class IllustrationMonsterTypeTogTem : BaseUITemplate
---@field Parameter IllustrationMonsterTypeTogTemParameter

IllustrationMonsterTypeTogTem = class("IllustrationMonsterTypeTogTem", super)
--lua class define end

--lua functions
function IllustrationMonsterTypeTogTem:Init()

    super.Init(self)
    self.Parameter.OFF:AddClick(function()
        self.MethodCallback(self.ShowIndex)
    end)

end --func end
--next--
function IllustrationMonsterTypeTogTem:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("IllustrationMonsterMgr").EventDispatcher, DataMgr:GetData("IllustrationMonsterData").ILLUSTRATION_MONSTER_REWARD, self.RefreshRedSign)

end --func end
--next--
function IllustrationMonsterTypeTogTem:OnDestroy()


end --func end
--next--
function IllustrationMonsterTypeTogTem:OnDeActive()


end --func end
--next--
function IllustrationMonsterTypeTogTem:OnSetData(data)

    self.Parameter.ON:SetActiveEx(false)
    self.Parameter.OFF:SetActiveEx(true)
    self.Parameter.Text_Off.LabText = data
    self.Parameter.Text_On.LabText = data
    self.Parameter.RedSign:SetActiveEx(MgrMgr:GetMgr("IllustrationMonsterMgr").CheckNeedShowElementTogRedSign(self.ShowIndex - 1))
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonsterTypeTogTem:OnSelect()
    self.Parameter.ON:SetActiveEx(true)
    self.Parameter.OFF:SetActiveEx(false)
end

function IllustrationMonsterTypeTogTem:OnDeselect()
    self.Parameter.ON:SetActiveEx(false)
    self.Parameter.OFF:SetActiveEx(true)
end

---@param param MonsterBookUpdateParam
function IllustrationMonsterTypeTogTem:RefreshRedSign(param)
    if (self.ShowIndex - 1) ~= param.MonsterType then
        return
    end

    local showRed = MgrMgr:GetMgr("IllustrationMonsterMgr").CheckNeedShowElementTogRedSign(self.ShowIndex - 1)
    self.Parameter.RedSign:SetActiveEx(showRed)
end

--lua custom scripts end
return IllustrationMonsterTypeTogTem