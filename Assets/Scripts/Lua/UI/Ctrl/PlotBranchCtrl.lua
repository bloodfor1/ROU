--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PlotBranchPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
PlotBranchCtrl = class("PlotBranchCtrl", super)
--lua class define end

--lua functions
function PlotBranchCtrl:ctor()

	super.ctor(self, CtrlNames.PlotBranch, UILayer.Function, nil, ActiveType.Standalone)
	self.dataCache ={}
	self.defaultTitle =  MGlobalConfig:GetString("InformalSelectWords")
end --func end
--next--
function PlotBranchCtrl:Init()

	self.panel = UI.PlotBranchPanel.Bind(self)
	super.Init(self)

end

--next--
function PlotBranchCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function PlotBranchCtrl:OnActive()
	self:UpdateSelection()
	local l_dlg_ui = UIMgr:GetUI(UI.CtrlNames.TalkDlg2)
    if l_dlg_ui ~= nil then
    	local l_titleInfo = l_dlg_ui.panel.talkContent.LabText
        self.panel.SelectInfo.LabText = l_titleInfo
    end
	MLuaClientHelper.PlayFxHelper(self.panel.AnimationObj.UObj)

end --func end
--next--
function PlotBranchCtrl:OnDeActive()

	if self.dataCache then
		for i, v in ipairs(self.dataCache) do
			if v.rewardEffectId then
				self:DestroyUIEffect(v.rewardEffectId)
			end
		end
	end
	self.dataCache = {}
end --func end
--next--
function PlotBranchCtrl:Update()


end --func end



--next--
function PlotBranchCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function PlotBranchCtrl:UpdateSelection()
	 for i=1,4 do
		local l_selection = self.panel["Select_0"..i]
		if l_selection ~= nil then
			if i <= #self.dataCache then
				-- l_selection.gameObject:SetActiveEx(true)
				self:ShowSelectionByIdx(i,self.dataCache[i])
			else
				self:ShowSelectionByIdx(i,nil)

				-- l_selection.gameObject:SetActiveEx(false)
			end
		end
    end
end

function PlotBranchCtrl:ShowSelectionByIdx(idx,data)
	-- local l_selection = self.panel["Select_0"..idx]
	-- if l_selection ~= nil then
	-- 	l_selection.gameObject:SetActiveEx(true)
	-- end
	local l_button = self.panel["SelectBtn_0"..idx]
	local l_buttonContent = self.panel["SelectContent_0"..idx]
	local l_contentTxt = self.defaultTitle
	if l_button ~= nil then
		l_button.Btn.interactable = false
	end

	local l_alpha = 1
	if data == nil then
		l_alpha = 0.6
	end
	l_button:GetComponent("CanvasGroup").alpha = l_alpha

	if data ~= nil then
		l_contentTxt = data.talkName
		l_button.Btn.interactable = true
		if l_button ~= nil then
			l_button:AddClick(function( ... )
				UIMgr:DeActiveUI(CtrlNames.PlotBranch)
				if data.callBack ~= nil then
					data.callBack()
				end
			end)
		end
	end

	if l_buttonContent ~= nil then
		l_buttonContent.LabText = l_contentTxt
	end

	local l_emoji = self.panel["Emoji_0"..idx]
	if l_emoji == nil then
		return
	end

	if data == nil then
		l_emoji.gameObject:SetActiveEx(false)
		return
	end

	if data.emojiId == nil or data.emojiId - 100 < 1 then
		-- logError("表情ID格式不对 @芳琳 检查")
		l_emoji.gameObject:SetActiveEx(false)
		return
	end

	l_emoji.gameObject:SetActiveEx(true)

	local l_emojiId = data.emojiId - 100
	local l_expressionInfo = TableUtil.GetShowExpressionTable().GetRowByID(l_emojiId) --任务及剧本表情ID配置会在表中将表情ID做+100 客户端做-100
	if l_expressionInfo == nil then
		logError("表情ID"..l_emojiId.." ShowExpressionTable 表中不存在 @芳琳 检查")
		return
	end
	-- l_emoji.gameObject:GetComponent("Image"):SetAnimation(l_expressionInfo.Atlas,l_expressionInfo.SpriteName,l_expressionInfo.SpriteNumber,l_expressionInfo.Interval)
    local l_fxId = l_expressionInfo.FxID

	if data.rewardEffectId then
		if data.rewardEffectId == l_fxId then
			-- 复用之前的
			return
		end
		self:DestroyUIEffect(data.rewardEffectId)
	end
	local l_fxData = {}
    l_fxData.rawImage = l_emoji.RawImg
    l_fxData.scaleFac = Vector3.New(3, 3, 3)
    data.rewardEffectId = self:CreateUIEffect(l_fxId, l_fxData)
    
end

--lua custom scripts end
