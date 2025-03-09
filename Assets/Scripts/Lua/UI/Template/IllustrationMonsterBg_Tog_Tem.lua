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
---@class IllustrationMonsterBg_Tog_TemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogL MoonClient.MLuaUICom
---@field Text_On MoonClient.MLuaUICom
---@field Text_Off MoonClient.MLuaUICom
---@field Templent MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field OFF MoonClient.MLuaUICom

---@class IllustrationMonsterBg_Tog_Tem : BaseUITemplate
---@field Parameter IllustrationMonsterBg_Tog_TemParameter

IllustrationMonsterBg_Tog_Tem = class("IllustrationMonsterBg_Tog_Tem", super)
--lua class define end

--lua functions
function IllustrationMonsterBg_Tog_Tem:Init()
    super.Init(self)
    self.Parameter.OFF:AddClickWithLuaSelf(self._onClick, self)
end --func end
--next--
function IllustrationMonsterBg_Tog_Tem:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("IllustrationMonsterMgr").EventDispatcher, DataMgr:GetData("IllustrationMonsterData").ILLUSTRATION_MONSTER_REWARD, self.RefreshRedSign)
end --func end
--next--
function IllustrationMonsterBg_Tog_Tem:OnDestroy()


end --func end
--next--
function IllustrationMonsterBg_Tog_Tem:OnDeActive()


end --func end
--next--
function IllustrationMonsterBg_Tog_Tem:OnSetData(data)
    self.Parameter.Text_On.LabText = data
    self.Parameter.Text_Off.LabText = data
    self.Parameter.OFF:SetActiveEx(true)
    self.Parameter.ON:SetActiveEx(false)
    self.Parameter.RedSign:SetActiveEx(false)
    if self.ShowIndex == 2 then
        self.Parameter.RedSign:SetActiveEx(MgrMgr:GetMgr("IllustrationMonsterMgr").CheckHandBookRedsign() == 1)
    end
end --func end
--next--
--lua functions end

--lua custom scripts

function IllustrationMonsterBg_Tog_Tem:_onClick()
    self.MethodCallback(self.ShowIndex)
end

function IllustrationMonsterBg_Tog_Tem:OnSelect()
    self.Parameter.ON:SetActiveEx(true)
    self.Parameter.OFF:SetActiveEx(false)
end
function IllustrationMonsterBg_Tog_Tem:OnDeselect()
    self.Parameter.ON:SetActiveEx(false)
    self.Parameter.OFF:SetActiveEx(true)
end

---@param param MonsterBookUpdateParam
function IllustrationMonsterBg_Tog_Tem:RefreshRedSign(param)
    if self.ShowIndex ~= 2 then
        return
    end

    local showRed = MgrMgr:GetMgr("IllustrationMonsterMgr").CheckHandBookRedsign() == 1
    self.Parameter.RedSign:SetActiveEx(showRed)
end
--lua custom scripts end
return IllustrationMonsterBg_Tog_Tem