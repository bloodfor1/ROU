--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FunctionOpenPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FunctionOpenCtrl = class("FunctionOpenCtrl", super)
--lua class define end

local l_buttonOffset = 0
local l_standardButton = "standardButton"
local l_btnSwitchUI = "SpecialButtonContainer/BtnSwitchUI"
local l_openSystemMgr = nil

--lua functions
function FunctionOpenCtrl:ctor()

	super.ctor(self, CtrlNames.FunctionOpen, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function FunctionOpenCtrl:Init()
	self.panel = UI.FunctionOpenPanel.Bind(self)
	super.Init(self)
	self.openTable=nil
	self._fxId1=0

	self.panel.FxImage:SetActiveEx(false)

	l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
	l_openSystemMgr.IsOnOpenPanel=true

	local openSystemId = l_openSystemMgr.CacheOpenSystem[1]
	self.openTable= TableUtil.GetOpenSystemTable().GetRowById(openSystemId)

	if self.openTable==nil then
		logError("OpenSystemTable表没配，id："..tostring(openSystemId))
		return
	end
	if self.openTable.SystemIcon and not string.ro_isEmpty(self.openTable.SystemIcon) then
		local l_atlas,l_atlasIcon = Common.CommonUIFunc.GetMainPanelAtlasAndIconByFuncId(openSystemId)
		self.panel.FunctionIcon:SetSpriteAsync(l_atlas,l_atlasIcon)
	end
	
	self.panel.FunctionName.LabText=self.openTable.Title

    self.panel.BGAlphaGroup.FxAnim:PlayAll()
    self.panel.FunctionName.FxAnim:PlayAll()
    self.panel.BgAnimation:PlayDynamicEffect()
    self.panel.ImageAnimation:PlayDynamicEffect(1)

	local tweenScaleFirst= self.panel.FunctionIcon.UObj:GetComponent("DOTweenAnimation")

	--先执行第一个tween，放大
	tweenScaleFirst.tween.onComplete = function()

		self:onTweenFirstComplete(openSystemId)
	end
end --func end
--next--
function FunctionOpenCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

	--UIMgr:RemoveNormalActiveName(UI.CtrlNames.FunctionOpen)


end --func end
--next--
function FunctionOpenCtrl:OnActive()


end --func end
--next--
function FunctionOpenCtrl:OnDeActive()
	if self._fxId1 > 0 then
		self:DestroyUIEffect(self._fxId1)
	end

end --func end
--next--
function FunctionOpenCtrl:Update()


end --func end



--next--
function FunctionOpenCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function FunctionOpenCtrl:onTweenFirstComplete(openSystemId)

	if self.panel==nil then
		return
	end

	self:_showFx()

	local l_isDoButtonMove=false
	local l_buttonTransform

	local l_mainCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.Main)
	if l_mainCtrl == nil then 
		return 
	end
	local l_mainPanel=l_mainCtrl.uObj.transform
	local l_ignoreSystemPos=false;
	if l_openSystemMgr.IsOpenTypeContain(self.openTable,{1}) then
		local l_buttonRootPath=l_openSystemMgr.ButtonRoot[self.openTable.SystemPlace]
		local l_buttonRoot=l_mainPanel:Find(l_buttonRootPath)
		local l_grid=l_buttonRoot:GetComponent("MLuaUICom").Grid
		l_grid.enabled=false
		local l_buttonOffsetStyle = Vector2.New(1, 0)
		l_buttonOffset=l_grid.cellSize.x

		if self.openTable.SystemPlace==3 or self.openTable.SystemPlace==4 then
			l_buttonOffsetStyle=Vector2.New(0, 1)
			l_buttonOffset=l_grid.cellSize.y
		end

		local l_standardPath=l_buttonRootPath.."/"..l_standardButton
		local l_standardPosition=l_mainPanel:Find(l_standardPath).anchoredPosition

		local l_buttons=l_openSystemMgr.GetOpenedButton({self.openTable.SystemPlace},0)


		l_buttonTransform=self:GetButton(openSystemId)

		local l_currentIndex=MLuaCommonHelper.GetTransformActiveIndex(l_buttonTransform:transform())
		local l_positionOffset
		if #l_buttons>=l_currentIndex then
			l_positionOffset=l_standardPosition-l_buttonOffsetStyle*l_buttonOffset*(l_currentIndex)
		else
			l_positionOffset=l_standardPosition-l_buttonOffsetStyle*l_buttonOffset*(#l_buttons+1)
		end

		l_buttonTransform:transform().anchoredPosition=l_positionOffset
		l_isDoButtonMove=true
	elseif l_openSystemMgr.IsOpenTypeContain(self.openTable,{4}) then
		l_buttonTransform=self:GetButton(openSystemId)
		l_isDoButtonMove=false;
		l_ignoreSystemPos=true;
	else
		local l_parentId=self.openTable.ParentID
		if l_parentId~=0 then
			self.openTable=TableUtil.GetOpenSystemTable().GetRowById(l_parentId)
			if self.openTable==nil then
				logError("OpenSystemTable表没配，id："..tostring(l_parentId))
				return
			end
		end
	end


	local l_tweenTargetTransform=nil
	if l_ignoreSystemPos then
		l_tweenTargetTransform=l_buttonTransform:transform()
	elseif self.openTable.SystemPlace~=0 then
		local l_targetPath
		if (self.openTable.SystemPlace==3 or self.openTable.SystemPlace==4) and MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
			l_targetPath=l_btnSwitchUI
		else
			l_targetPath=l_openSystemMgr.GetButtonPath(self.openTable.Id)
		end
		l_tweenTargetTransform=l_mainPanel:Find(l_targetPath)
	end

	--移动动画的目标
	local l_tweenMove= self.panel.TweenMove.UObj:GetComponent("DOTweenAnimation")
	l_tweenMove.endValueTransform=l_tweenTargetTransform
	l_tweenMove:CreateTween()
	l_tweenMove:DORestart()
	self:TweenMoveOnPlay(l_tweenMove,l_isDoButtonMove,l_buttonTransform)
	self.panel.SkipButton:AddClick(function()
		if self.panel==nil then
			return
		end
		l_tweenMove.delay=0
		l_tweenMove:DOKill()
		l_tweenMove:CreateTween()
		l_tweenMove:DORestart()
		self:TweenMoveOnPlay(l_tweenMove,l_isDoButtonMove,l_buttonTransform)
		self.panel.SkipButton.gameObject:SetActiveEx(false)
	end)

end

function FunctionOpenCtrl:_showFx()
	if self._fxId1 > 0 then
		self:DestroyUIEffect(self._fxId1)
	end

	local l_fxData = {}
	l_fxData.rawImage = self.panel.FxImage.RawImg
	l_fxData.destroyHandler = function()
		self._fxId1 = 0
	end

	l_fxData.scaleFac = Vector3.New(4.316494, 3.736306, 4.316494)
	self._fxId1 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/fx_ui_gnkq", l_fxData)
	
end

function FunctionOpenCtrl:GetButton(openSystemId)
	local buttonTransform=nil;
	if openSystemId==104 then --照相
		local mainChatCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.MainChat)
		buttonTransform = mainChatCtrl and mainChatCtrl:GetButton(openSystemId)
	else
		local mainCtrl = UIMgr:GetOrInitUI(UI.CtrlNames.Main)
		buttonTransform = mainCtrl and mainCtrl:GetButton(openSystemId)
	end
	return buttonTransform;
end
--TweenMove播放的时候执行
function FunctionOpenCtrl:TweenMoveOnPlay(tweenMove,isDoButtonMove,buttonTransform)
	tweenMove.tween.onPlay = function()

		if self.panel==nil then
			return
		end

		self.panel.SkipButton.gameObject:SetActiveEx(false)
		if isDoButtonMove then
			local tweenButtons=l_openSystemMgr.GetOpenedButton({self.openTable.SystemPlace},self.openTable.SortID)

			if self.openTable.SystemPlace==1 or self.openTable.SystemPlace==2 then
				for i = 1, #tweenButtons do
					tweenButtons[i]:transform():DOAnchorPosX(tweenButtons[i]:transform().anchoredPosition.x-l_buttonOffset, 0.9)
				end
			else
				for i = 1, #tweenButtons do
					tweenButtons[i]:transform():DOAnchorPosY(tweenButtons[i]:transform().anchoredPosition.y-l_buttonOffset, 0.9)
				end
			end
		end

		--self.panel.BG.gameObject:SetActiveEx(false)
		if self.openTable.SystemPlace==0 then
			if buttonTransform~=nil then
				buttonTransform:ShowButton(true)
			end
			self:_closePanel()
		else
			--执行TweenScale
			local tweenScaleLast= self.panel.TweenScale.UObj:GetComponent("DOTweenAnimation")
			tweenScaleLast:CreateTween()
			tweenScaleLast:DORestart()
			tweenScaleLast.tween.onComplete = function()
				if buttonTransform~=nil then
					buttonTransform:ShowButton(true)

				end
				self:_closePanel()
			end
		end

	end

end

function FunctionOpenCtrl:_closePanel()
	UIMgr:DeActiveUI(UI.CtrlNames.FunctionOpen)

	local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
	if l_openSystemMgr then
		if #l_openSystemMgr.CacheOpenSystem>0 then
			local l_id = table.remove(l_openSystemMgr.CacheOpenSystem, 1)
			l_openSystemMgr.IsOnOpenPanel = false
			l_openSystemMgr.ShowOpenFinish(l_id)
		end
	end
end


return FunctionOpenCtrl

--lua custom scripts end
