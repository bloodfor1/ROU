--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BlackCurtainPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
BlackCurtainCtrl = class("BlackCurtainCtrl", super)
--lua class define end

EBlackCurtainStatus =
{
	NONE = 0,
	NEXT_LINE = 1,
	NEXT_PARAGRAPH = 2
}

--lua functions
function BlackCurtainCtrl:ctor()

	super.ctor(self, CtrlNames.BlackCurtain, UILayer.Top, nil, ActiveType.Exclusive)
	self.paragraph = nil
	self.actionQueneTimer = nil
	self.fxActionQueneTimer = nil
	self.fadeAction = nil
	self.fxId = 0
	self.fxStartId = 0
	self.currentLineNum = 0
	self.linesCache = {}
	self.status = EBlackCurtainStatus.NONE
	self.isDefault = true
end --func end
--next--
function BlackCurtainCtrl:Init()

	self.panel = UI.BlackCurtainPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function BlackCurtainCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BlackCurtainCtrl:OnActive()
	self:RefreshBlackCurtain()
end --func end

function BlackCurtainCtrl:DeActive(isPlayTween)
	super.DeActive(self,isPlayTween)
    MgrMgr:GetMgr("BlackCurtainMgr").PlayCompleted()
    self:ClearCache()
end 

--next--
function BlackCurtainCtrl:OnDeActive()
	self:StopFadeAction()
	self:StopActionQuene()
	self:StopFxActionQuene()

	MAudioMgr:StopCV()

	if not self.isDefault then
		self:DestroyFx()
	end
    --MScene.GameCamera.CameraEnabled = true
	self.isDefault = true
end --func end
--next--
function BlackCurtainCtrl:Update()


end --func end




--next--
function BlackCurtainCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function BlackCurtainCtrl:RefreshBlackCurtain()
	self:StopFadeAction()
	self:StopActionQuene()
	self:StopFxActionQuene()
	if not self.isDefault then
		self:DestroyFx()
	end

	self.isDefault = MgrMgr:GetMgr("BlackCurtainMgr").GetCurrentId() == -1
    self.panel.BG.CanvasGroup.alpha = 0
    self.panel.DefaultBG.gameObject:SetActiveEx(self.isDefault)
	if self.isDefault then
		self.panel.ContentBG.CanvasGroup.alpha = 0
		self.panel.BG:AddClick(function( ... )
			return
		end)
	else
		self.panel.ContentBG.CanvasGroup.alpha = 1
		self.status = EBlackCurtainStatus.NONE
		self.panel.BG:AddClick(function( ... )
			if self.status == EBlackCurtainStatus.NONE then
				return
			end
			if self.status == EBlackCurtainStatus.NEXT_LINE then
				-- self:ShowAllLines()
				self:ShowNextLine()
				return
			end
			if self.status == EBlackCurtainStatus.NEXT_PARAGRAPH then
				self:ShowNextParagraph()
			end
		end)
	end
	self:FadeIn()
end

function BlackCurtainCtrl:FadeIn()
	local l_timeData = MgrMgr:GetMgr("BlackCurtainMgr").GetTimeData()
	local _afterFadeIn = function()
		--MScene.GameCamera.CameraEnabled = false
		self.panel.BG.CanvasGroup.alpha = 1

		MgrMgr:GetMgr("BlackCurtainMgr").CheckShowCompleted()
		if self.isDefault then
			self.actionQueneTimer = self:NewUITimer(function()
				self:FadeOut()
			end, l_timeData.show)
			self.actionQueneTimer:Start()
		else
			self:ShowNextParagraph()
		end
	end
	if l_timeData.fadeIn <= 0 then
		_afterFadeIn()
	else
		self.fadeAction = self.panel.BG.CanvasGroup:DOFade(1,l_timeData.fadeIn)
		self.actionQueneTimer = self:NewUITimer(function()
			_afterFadeIn()
		end, l_timeData.fadeIn)
		self.actionQueneTimer:Start()
	end
end

function BlackCurtainCtrl:ShowFx( ... )
	self:ShowStartFx()
	self.fxActionQueneTimer = self:NewUITimer(function()
		self:ShowLoopFx()
		self.fxActionQueneTimer = nil
	end, 0.3)
	self.fxActionQueneTimer:Start()
end

function BlackCurtainCtrl:HideFx()
	self:StopFxActionQuene()
	self.panel.Tip:SetActiveEx(false)
	self.panel.TipStart:SetActiveEx(false)
end

function BlackCurtainCtrl:ShowStartFx( ... )
	self:DestroyStartFx()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.TipStart.gameObject:GetComponent("RawImage")
    l_fxData.destroyHandler = function ( ... )
        self.fxStartId = 0
    end
    self.fxStartId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_HuDie_Start",l_fxData)
    
    --self.panel.TipStart:SetActiveEx(true)
end

function BlackCurtainCtrl:DestroyStartFx( ... )
    if self.fxStartId ~= 0 then
        self:DestroyUIEffect(self.fxStartId)
        self.fxStartId = 0
    end
end

function BlackCurtainCtrl:ShowLoopFx( ... )
    if self.fxId == 0 then
		self:CreateFx()
	else
		self.panel.Tip:SetActiveEx(true)
    end
end

function BlackCurtainCtrl:CreateFx( ... )
    local l_fxData = {}
    l_fxData.rawImage = self.panel.Tip.gameObject:GetComponent("RawImage")
    l_fxData.destroyHandler = function ( ... )
        self.fxId = 0
    end
    self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_HuDie_Loop",l_fxData)
    
end

function BlackCurtainCtrl:DestroyFx( ... )
    if self.fxId ~= 0 then
        self:DestroyUIEffect(self.fxId)
        self.fxId = 0
    end

    self:DestroyStartFx()
end

function BlackCurtainCtrl:ShowNextParagraph( ... )
	self:StopFadeAction()
	self:StopActionQuene()
	self:HideFx()
	local l_bcMgr = MgrMgr:GetMgr("BlackCurtainMgr")
	local l_nextParagraph = l_bcMgr.GetNextParagraph()
	if l_nextParagraph== nil then
		self.paragraph = nil
		self:FadeOut()
		return
	end
	self.paragraph = l_nextParagraph
	self:CreateParagraph()
end

function BlackCurtainCtrl:WaitingForNextParagraph( ... )
	self.status = EBlackCurtainStatus.NEXT_PARAGRAPH
	self:ShowFx()
	if self.paragraph.time == 0 then
		return
	end
	self.actionQueneTimer = self:NewUITimer(function()
		self.actionQueneTimer = nil
		self:ShowNextParagraph()
	end, self.paragraph.time)
	self.actionQueneTimer:Start()
end

function BlackCurtainCtrl:CreateParagraph()

	if #self.linesCache < #self.paragraph.content then
		local l_newCount = #self.paragraph.content - #self.linesCache
		for i=1,l_newCount do
			local l_newLine = self:CreateNewLine()
			table.insert(self.linesCache,l_newLine)
		end
	end

	for i=1,#self.linesCache do
		local l_oneLine = self.linesCache[i]
		local l_oneLineData = self.paragraph.content[i]
		l_oneLine.gameObject:SetActiveEx(l_oneLineData ~= nil)
		if l_oneLineData ~= nil then
			l_oneLine.LabText = l_oneLineData.content
			l_oneLine.CanvasGroup.alpha = 0
		end
	end

	self.currentLineNum = 0
	self:ShowNextLine()
end

function BlackCurtainCtrl:ShowNextLine()
	self.status = EBlackCurtainStatus.NEXT_LINE
	self:StopFadeAction()
	self:StopActionQuene()
	self.currentLineNum = self.currentLineNum + 1
	if self.currentLineNum > #self.paragraph.content then
		self:WaitingForNextParagraph()
		return
	end
	local l_oneLineData = self.paragraph.content[self.currentLineNum]
	local l_oneLine = self.linesCache[self.currentLineNum]
	local l_lineTime = l_oneLineData.time
	MAudioMgr:StopCV()
	if l_oneLineData.cv ~= nil and l_oneLineData.cv > 0 then
		MAudioMgr:PlayCV(l_oneLineData.cv)
		local l_row = TableUtil.GetAudioStoryTable().GetRowById(l_oneLineData.cv)
		if l_row then
			l_lineTime = l_row.Length
		end
	end
	self.fadeAction = l_oneLine.CanvasGroup:DOFade(1,l_lineTime)
	self.actionQueneTimer = self:NewUITimer(function()
		self.actionQueneTimer = nil
		l_oneLine.CanvasGroup.alpha = 1
		self:ShowNextLine()
	end, l_lineTime + 0.5)
	self.actionQueneTimer:Start()
end

function BlackCurtainCtrl:ShowAllLines( ... )
	self:StopFadeAction()
	self:StopActionQuene()
	MAudioMgr:StopCV()
	for i=1,#self.paragraph.content do
		if self.linesCache[i] ~= nil then
			self.linesCache[i].CanvasGroup.alpha = 1
		end
	end
	self.currentLineNum = #self.paragraph.content
	self:WaitingForNextParagraph()
end


function BlackCurtainCtrl:CreateNewLine()
	local l_newLine = self:CloneObj(self.panel.LineText.gameObject, true)
    l_newLine.transform:SetParent(self.panel.Contents.transform)
    l_newLine.transform:SetLocalScaleOne()
    return l_newLine:GetComponent("MLuaUICom")
end

function BlackCurtainCtrl:DestroyLine(go)

	MResLoader:DestroyObj(go, true)
end

function BlackCurtainCtrl:StopFadeAction( ... )
    if self.fadeAction ~= nil then
		self.fadeAction:Kill(true)
        self.fadeAction = nil
    end
end

function BlackCurtainCtrl:StopActionQuene( ... )
	if self.actionQueneTimer ~= nil then
		self:StopUITimer(self.actionQueneTimer)
		self.actionQueneTimer = nil
	end
end

function BlackCurtainCtrl:StopFxActionQuene( ... )
	if self.fxActionQueneTimer ~= nil then
		self:StopUITimer(self.fxActionQueneTimer)
		self.fxActionQueneTimer = nil
	end
end

function BlackCurtainCtrl:FadeOut( ... )
    --MScene.GameCamera.CameraEnabled = true
	self:ClearCache()
	if self.isDefault then
		self:FadeOutAction()
		return
	end
	self:StopFadeAction()
	self:StopActionQuene()
	self:ContentFadeOut()
end

function BlackCurtainCtrl:ClearCache()
	self.currentLineNum = 0
	self.paragraph = nil

	if self.linesCache then
		for i, v in ipairs(self.linesCache) do
			self:DestroyLine(v.gameObject)
		end
	end

	self.linesCache = {}
	self.status = EBlackCurtainStatus.NONE
end

function BlackCurtainCtrl:ContentFadeOut( ... )
	MgrMgr:GetMgr("BlackCurtainMgr").CheckFadeOut()
	self.fadeAction = self.panel.ContentBG.CanvasGroup:DOFade(0,1.5)
	self.actionQueneTimer = self:NewUITimer(function()
		self:FadeOutAction()
	end, 1.5)
	self.actionQueneTimer:Start()
end

function BlackCurtainCtrl:FadeOutAction( ... )
	local l_timeData = MgrMgr:GetMgr("BlackCurtainMgr").GetTimeData()

	self.fadeAction = self.panel.BG.CanvasGroup:DOFade(0,l_timeData.fadeOut)
	self.actionQueneTimer = self:NewUITimer(function()
		UIMgr:DeActiveUI(self.name)
	end, l_timeData.fadeOut)
	self.actionQueneTimer:Start()
end
--lua custom scripts end
return BlackCurtainCtrl