--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/NewPlotBranchPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
NewPlotBranchCtrl = class("NewPlotBranchCtrl", super)
--lua class define end

--lua functions
function NewPlotBranchCtrl:ctor()

	super.ctor(self, CtrlNames.NewPlotBranch, UILayer.Function, nil, ActiveType.Standalone)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark

end --func end
--next--
function NewPlotBranchCtrl:Init()

	self.panel = UI.NewPlotBranchPanel.Bind(self)
	super.Init(self)
	--self:SetBlockOpt(BlockColor.Dark)
	self.dataCache = {}
end --func end
--next--
function NewPlotBranchCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function NewPlotBranchCtrl:OnActive()

	self.dataCache = MgrMgr:GetMgr("NpcTalkDlgMgr").GetPlotCache()

	self:UpdateSelection()
end --func end
--next--
function NewPlotBranchCtrl:OnDeActive()
	if self.dataCache then
		for i, v in ipairs(self.dataCache) do
			if v.emojiEffectId then
				self:DestroyUIEffect(v.emojiEffectId)
			end
		end
	end
	self.dataCache = {}
	MgrMgr:GetMgr("NpcTalkDlgMgr").ClearPlotCache()
end --func end
--next--
function NewPlotBranchCtrl:Update()


end --func end





--next--
function NewPlotBranchCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function NewPlotBranchCtrl:UpdateSelection()
	if #self.dataCache == 0 then
		logError("PlotBranch Data is Empty")
		UIMgr:DeActiveUI(CtrlNames.NewPlotBranch)
		return
	end

	MgrMgr:GetMgr("NpcTalkDlgMgr").ClearSelect()

	for i=1,4 do
		if i <= #self.dataCache then
			self:ShowSelectionByIdx(i,self.dataCache[i])
		else
			self:ShowSelectionByIdx(i,nil)
		end
    end
end


function NewPlotBranchCtrl:ShowSelectionByIdx(idx,data)
	local l_selection = self.panel["Select_0"..idx]
	if l_selection == nil then
		return
	end
	if data == nil then
		l_selection.gameObject:SetActiveEx(false)
		return
	end
	l_selection.gameObject:SetActiveEx(true)
	l_selection:AddClick(function( ... )
		UIMgr:DeActiveUI(CtrlNames.NewPlotBranch)
		if data.callBack ~= nil then
			data.callBack()
		end
	end)

	local l_selectContent = self.panel["SelectContent_0"..idx]
	if l_selectContent ~= nil then
		l_selectContent.LabText = data.talkName
	end

	local l_emoji = self.panel["Emoji_0"..idx]
	if l_emoji == nil then
		return
	end

	if data.emojiId == nil or data.emojiId - 100 < 1 then
		l_emoji.gameObject:SetActiveEx(false)
		return
	end

	l_emoji.gameObject:SetActiveEx(true)

	local l_emojiId = data.emojiId - 100
	local l_expressionInfo = TableUtil.GetShowExpressionTable().GetRowByID(l_emojiId) --任务及剧本表情ID配置会在表中将表情ID做+100 客户端做-100
	if l_expressionInfo == nil then
		logError("表情ID"..l_emojiId.." ShowExpressionTable 表中不存在 @倩雯 检查")
		return
	end
    local l_fxId = l_expressionInfo.FxID
	if data.emojiEffectId then
		if data.emojiEffectId == l_fxId then
			-- 复用之前的
			return
		end
		self:DestroyUIEffect(data.emojiEffectId)
	end
	local l_fxData = {}
    l_fxData.rawImage = l_emoji.RawImg
    l_fxData.position = Vector3.New(0,0.15,0)
    l_fxData.scaleFac = Vector3.New(3, 3, 3)
    data.emojiEffectId = self:CreateUIEffect(l_fxId, l_fxData)
    
end

--lua custom scripts end
return NewPlotBranchCtrl