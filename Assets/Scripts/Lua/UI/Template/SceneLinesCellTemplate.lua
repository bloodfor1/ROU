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
---@class SceneLinesCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field thisCell MoonClient.MLuaUICom
---@field CellText MoonClient.MLuaUICom
---@field CellOutline MoonClient.MLuaUICom
---@field CellBg MoonClient.MLuaUICom

---@class SceneLinesCellTemplate : BaseUITemplate
---@field Parameter SceneLinesCellTemplateParameter

SceneLinesCellTemplate = class("SceneLinesCellTemplate", super)
--lua class define end

--lua functions
function SceneLinesCellTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function SceneLinesCellTemplate:BindEvents()
	
	
end --func end
--next--
function SceneLinesCellTemplate:OnDestroy()
	
	
end --func end
--next--
function SceneLinesCellTemplate:OnDeActive()
	
	
end --func end
--next--
function SceneLinesCellTemplate:OnSetData(data)
	-- 分线拥挤
	if data.status then
		self.Parameter.CellText.LabText = "<color=#FF4F4FFF>" .. Lang("LineShowFormat", data.line).. "</color>"
	else
		self.Parameter.CellText.LabText = Lang("LineShowFormat", data.line)
	end
	-- 将玩家所在的分线进行框选并且不可点击
	self.Parameter.CellOutline:SetActiveEx(data.isNowLine)
	self.Parameter.CellBg.Img.raycastTarget = not data.isNowLine
	self.Parameter.CellOutline.Img.raycastTarget = not data.isNowLine
	if not data.isNowLine then
		self.Parameter.thisCell:AddClick(function()
			--玩家处于不可切线状态
			if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_P_ChangeLine) then
				return
			end
			-- 分线拥挤，玩家无法加入该分线
			if data.status then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LineFullState"))
				-- 玩家尝试加入失败，请求获取新的分线信息
				GlobalEventBus:Dispatch(EventConst.Names.GetStaticSceneLine)
				return
			end
			local l_msgId = Network.Define.Rpc.ChangeSceneLine
			---@type ChangeSceneLineArg
			local l_sendInfo = GetProtoBufSendTable("ChangeSceneLineArg")
			l_sendInfo.scene_id = MScene.SceneID
			l_sendInfo.line = data.line
			Network.Handler.SendRpc(l_msgId, l_sendInfo)
			-- 修改为在SettingMgr.OnChangeLineRes中处理信息面板
			--GlobalEventBus:Dispatch(EventConst.Names.UpdateSceneLinesPanel, false)
		end)
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SceneLinesCellTemplate