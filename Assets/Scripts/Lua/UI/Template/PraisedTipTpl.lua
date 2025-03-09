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
---@class PraisedTipTplParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PraiseTipText MoonClient.MLuaUICom
---@field PraisedTipTpl MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom

---@class PraisedTipTpl : BaseUITemplate
---@field Parameter PraisedTipTplParameter

PraisedTipTpl = class("PraisedTipTpl", super)
--lua class define end

--lua functions
function PraisedTipTpl:Init()

    super.Init(self)
    self._head = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function PraisedTipTpl:BindEvents()
    -- do nothing
end --func end
--next--
function PraisedTipTpl:OnDestroy()
    -- do nothing
end --func end
--next--
function PraisedTipTpl:OnDeActive()
    -- do nothing
end --func end
--next--
function PraisedTipTpl:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function PraisedTipTpl:GetLocalPos()
    return self.Parameter.PraisedTipTpl.transform.localPosition
end

function PraisedTipTpl:UpdateLocalPos(pos)
    self.Parameter.PraisedTipTpl.transform.localPosition = pos
end

function PraisedTipTpl:InitPos(initPos)
    MLuaCommonHelper.SetLocalPos(self.Parameter.PraisedTipTpl.transform, initPos)
    MLuaCommonHelper.SetLocalScaleOne(self.Parameter.PraisedTipTpl.transform)
    MLuaCommonHelper.SetRotEulerZero(self.Parameter.PraisedTipTpl.transform)
end

function PraisedTipTpl:_onSetData(id)
    if nil == id then
        logError("[PraiseTips] invalid param")
        return
    end

    local entity = MEntityMgr:GetEntity(id, true)
    if nil == entity then
        return
    end

    self.Parameter.PraiseTipText.LabText = Common.Utils.Lang("THEME_THUMB_YOU", entity.Name)
    ---@type HeadTemplateParam
    local param = {
        Entity = entity
    }

    self._head:SetData(param)
end
--lua custom scripts end
return PraisedTipTpl