--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DicePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local c_defaultWaitTime = 3		-- 默认自动关闭时间 3s
--lua fields end

--lua class define
---@class DiceCtrl : UIBaseCtrl
DiceCtrl = class("DiceCtrl", super)
--lua class define end

--lua functions
function DiceCtrl:ctor()
	
	super.ctor(self, CtrlNames.Dice, UILayer.Tips, nil, ActiveType.Exclusive)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
end --func end
--next--
function DiceCtrl:Init()
	
	self.panel = UI.DicePanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function DiceCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function DiceCtrl:OnActive()

	-- 显示第五个Img
	self.l_atlas = self.uiPanelData.data.atlas
	self.l_imgList = self.uiPanelData.data.imgList
	self.l_desc = self.uiPanelData.desc
	self.l_cb = self.uiPanelData.closeCallBack

	self:_play()
	
end --func end
--next--
function DiceCtrl:OnDeActive()

	self.l_atlas = nil
	self.l_imgList = nil
	self.l_cb = nil
	self.l_timeWaitToExit = nil
	
end --func end
--next--
function DiceCtrl:Update()

	if self.l_timeWaitToExit then
		self.l_timeWaitToExit = self.l_timeWaitToExit - Time.deltaTime
		if self.l_timeWaitToExit <= 0 then
			if self.l_cb then
				self.l_cb()
			end
			UIMgr:DeActiveUI(UI.CtrlNames.Dice)
		end
	end

end --func end
--next--
function DiceCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function DiceCtrl:_play()
	self.panel.DiceFx:PlayDynamicEffect(1, {
		loadedCallback = function(go,fxId)
			self:SetResultDiceFace(go)
			self.l_timeWaitToExit =  self.uiPanelData.waitTime or c_defaultWaitTime
		end
	})
	--self.panel.DiceFx:PlayDynamicEffect(5)
	if self.l_desc then
		self.panel.Text.LabText = self.l_desc
		self.panel.Text.gameObject:SetActiveEx(true)
	else
		self.panel.Text.gameObject:SetActiveEx(false)
	end
end

function DiceCtrl:SetResultDiceFace(go)
	---@type MoonClient.MDiceBehaviour
	local com = go.Find("Main/Item_Scene_Shaizi"):GetComponent("MDiceBehaviour")

	for i = 1, 6 do
		com:SetDirSprite(MoonClient.DiceDirection.IntToEnum(i-1), self.l_imgList[i],self.l_atlas)
	end

end

--lua custom scripts end
return DiceCtrl