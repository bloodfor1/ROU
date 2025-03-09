--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Common/TimeMgr"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local l_commonTexPath = "Postcard/"
local CAN_TAKE_FX_LOCATION = "Effects/Prefabs/Creature/Ui/Fx_Ui_QiRiDengLu_01"
--lua fields end

--lua class define
---@class PostCardDisplayTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnknownDesc MoonClient.MLuaUICom
---@field Unknown MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Task MoonClient.MLuaUICom
---@field Postcard MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field ImageRT MoonClient.MLuaUICom
---@field card MoonClient.MLuaUICom

---@class PostCardDisplayTemplate : BaseUITemplate
---@field Parameter PostCardDisplayTemplateParameter

PostCardDisplayTemplate = class("PostCardDisplayTemplate", super)
--lua class define end

--lua functions
function PostCardDisplayTemplate:Init()
	
	    super.Init(self)
	self.rewardEffectId = 0
	
end --func end
--next--
function PostCardDisplayTemplate:OnDestroy()
	
	self:SetCanAwardFx(false)
	self.Parameter.card:ResetRawTex()
	
end --func end
--next--
function PostCardDisplayTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function PostCardDisplayTemplate:OnDeActive()
	
	
end --func end
--next--
function PostCardDisplayTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function PostCardDisplayTemplate:CustomSetData(data)
	
	local l_row = TableUtil.GetPostcardDisplayTable().GetRow(data.id)
	local l_taskId = l_row.Target[data.index]
	local l_resPath = l_row[StringEx.Format("Res{0}", (data.index + 1))]

	local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(l_taskId)
	if not l_taskInfo then
		logError("找不到该任务配置 任务ID:", l_taskId)
		return
	end

	local l_taskState, l_time = MgrMgr:GetMgr("PostCardMgr").GetTaskState(l_taskId)
	local l_awardState = MgrMgr:GetMgr("PostCardMgr").GetAwardState(l_taskId)
	self:SetCanAwardFx(l_taskState and (not l_awardState))
	if l_taskState then
		
		self.Parameter.Lock.gameObject:SetActiveEx(false)
		if l_awardState then
			self.Parameter.Mask.gameObject:SetActiveEx(false)
			self.Parameter.card:SetRawTexAsync(StringEx.Format("{0}{1}", l_commonTexPath, l_resPath))
			self.Parameter.card:SetRawImgEnable(true)
			self.Parameter.Task.LabText = l_taskInfo.name
			local l_timeTable = Common.TimeMgr.GetTimeTable(l_time)
			self.Parameter.Time.LabText = StringEx.Format("{0}/{1}/{2}", l_timeTable.year, l_timeTable.month, l_timeTable.day)
			self.Parameter.ImageRT.gameObject:SetActiveEx(false)
		else
			self.Parameter.card:SetRawImgEnable(false)
			self.Parameter.Mask.gameObject:SetActiveEx(true)
			self.Parameter.Task.LabText = ""
			self.Parameter.Time.LabText = ""
			self.Parameter.UnknownDesc.LabText = l_taskInfo.name
			self.Parameter.ImageRT.gameObject:SetActiveEx(true)
		end
		
		self.Parameter.card.gameObject:SetActiveEx(true)
	else
		self.Parameter.Task.LabText = ""
		self.Parameter.Time.LabText = ""
		self.Parameter.UnknownDesc.LabText = l_taskInfo.name
		self.Parameter.Lock.gameObject:SetActiveEx(true)
		self.Parameter.Mask.gameObject:SetActiveEx(true)
		self.Parameter.card.gameObject:SetActiveEx(false)
		self.Parameter.ImageRT.gameObject:SetActiveEx(false)
	end

	-- click
	self.Parameter.Postcard:AddClick(function()
		self.MethodCallback(data.globalIndex)
	end)
end

function PostCardDisplayTemplate:SetCanAwardFx(flag)
	if flag then
		if self.rewardEffectId == 0 then
			local l_fxData = {}
			l_fxData.rawImage = self.Parameter.ImageRT.RawImg
			l_fxData.position = Vector3.New(1.83, -0.6, 0)
			l_fxData.rotation = Quaternion.Euler(0, 0, 90)
			l_fxData.scaleFac = Vector3.New(1.5, 1.1, 1)
			l_fxData.speed = 1.5
			l_fxData.destroyHandler = function ()
			    self.rewardEffectId = 0
			end
			self.rewardEffectId = self:CreateUIEffect(CAN_TAKE_FX_LOCATION, l_fxData)
			
		end
	else
		if self.rewardEffectId ~= 0 then
			self:DestroyUIEffect(self.rewardEffectId)
            self.rewardEffectId = 0
		end
	end
end
--lua custom scripts end
return PostCardDisplayTemplate