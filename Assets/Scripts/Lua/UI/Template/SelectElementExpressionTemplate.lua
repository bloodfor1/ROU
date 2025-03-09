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
local l_fx_scale = 1
--lua fields end

--lua class define
---@class SelectElementExpressionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgHeadExpression MoonClient.MLuaUICom
---@field BtnExpressionInstance MoonClient.MLuaUICom

---@class SelectElementExpressionTemplate : BaseUITemplate
---@field Parameter SelectElementExpressionTemplateParameter

SelectElementExpressionTemplate = class("SelectElementExpressionTemplate", super)
--lua class define end

--lua functions
function SelectElementExpressionTemplate:Init()
	
	    super.Init(self)
	self.rewardFx = nil
	    l_fx_scale = MGlobalConfig:GetFloat("ExpressionListScale", 1)
	
end --func end
--next--
function SelectElementExpressionTemplate:OnDeActive()
	
	if self.rewardFx then
		self:DestroyUIEffect(self.rewardFx)
		self.rewardFx = nil
	end
	
end --func end
--next--
function SelectElementExpressionTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function SelectElementExpressionTemplate:BindEvents()
	
	
end --func end
--next--
function SelectElementExpressionTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectElementExpressionTemplate:CustomSetData(row)

	MLuaCommonHelper.SetLocalScale(self.Parameter.LuaUIGroup.gameObject, 0.9, 0.9, 1)

	local l_fxId = row.FxID
	local l_fxData = {}
    l_fxData.rawImage = self.Parameter.ImgHeadExpression.RawImg
    l_fxData.scaleFac = Vector3.New(l_fx_scale, l_fx_scale, l_fx_scale)
    l_fxData.playTime = -1
    local l_zero_rotation = Quaternion.Euler(0, 0, 0)
    l_fxData.rotation = l_zero_rotation

    local l_com_face_ctrl = nil
    l_fxData.loadedCallback = function(go)
    	l_com_face_ctrl = go:GetComponent("FaceToCameraObjPrepareData")
    	if l_com_face_ctrl then
    		l_com_face_ctrl:CustomActive(false)
            local l_objs = l_com_face_ctrl.FaceToCameraObjs
            for i = 0, l_objs.Length - 1 do
                l_objs[i].transform.localRotation = l_zero_rotation
            end
    	end
    end

    l_fxData.destroyHandler = function()
    	if l_com_face_ctrl then
    		l_com_face_ctrl:CustomActive(true)
    	end
    end

    if self.rewardFx then
        self:DestroyUIEffect(self.rewardFx)
        self.rewardFx = nil
    end

    self.rewardFx = self:CreateUIEffect(l_fxId, l_fxData)
    

	self.Parameter.BtnExpressionInstance:AddClick(function()
		if self.MethodCallback then
			self.MethodCallback(row)
		end
	end)
end
--lua custom scripts end
return SelectElementExpressionTemplate