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
local l_themePartyMgr = nil
maxNumItemSize = 6
--lua fields end

--lua class define
---@class PartyLotteryItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PartyLotteryItem MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field TittleObj MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom

---@class PartyLotteryItem : BaseUITemplate
---@field Parameter PartyLotteryItemParameter

PartyLotteryItem = class("PartyLotteryItem", super)
--lua class define end

--lua functions
function PartyLotteryItem:Init()
	
	    super.Init(self)
	l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
	self:InitItemSlot()
	
end --func end
--next--
function PartyLotteryItem:OnDestroy()
	
	
end --func end
--next--
function PartyLotteryItem:OnDeActive()
	
	self:UnLoadTemPlent()
	
end --func end
--next--
function PartyLotteryItem:OnSetData(data)
	
	
end --func end
--next--
function PartyLotteryItem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
PartyLotteryItem.TemplatePath="UI/Prefabs/PartyLotteryItem"

function PartyLotteryItem:InitItemSlot( ... )
	self.numberScrollItems = {}
	for i=1,l_themePartyMgr.l_maxSize do
		self.numberScrollItems[i] = self:NewTemplate("NumberScrollItem",{TemplateParent=self.Parameter.ItemParent.transform})
	end
end

function PartyLotteryItem:ShowTemplentByNumAndTitle(title,finNumber,finScale)
	self.Parameter.Title.LabText = title
	if finScale then
		self:transform():SetLocalScale(finScale,finScale,finScale)
	else
		self:transform():SetLocalScale(1,1,1)
	end
	self:SetItemSlotByNumber(finNumber)
end

function PartyLotteryItem:ShowTitleByState(state)
	--self.Parameter.TittleObj.gameObject:SetActiveEx(state)
	self.Parameter.TittleObj.gameObject:SetActiveEx(false)
end

local OneItemSize = 86
local OneCircleSize = 10
local l_animationTime = MgrMgr:GetMgr("ThemePartyMgr").l_animationTime
local l_oneItemDelayTime = MgrMgr:GetMgr("ThemePartyMgr").l_oneItemDelayTime
local l_basicCicleNum = 20

function PartyLotteryItem:SetItemSlotByNumber(num)
	for i=1,maxNumItemSize do
		local showNum = tonumber(string.sub(tostring(num),i,i))
		if showNum ~= nil then
			self.numberScrollItems[i]:AddLoadCallback(function (tmp)
				local totalTime = l_animationTime +(i-1)*l_oneItemDelayTime
				tmp:InitNum(0)
				tmp:SetIsShowSprite(true)
				local finishFunc = function ( ... )
					if i == maxNumItemSize then
						MgrMgr:GetMgr("ThemePartyMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("ThemePartyMgr").ON_FINISH_NUMBER_SCROLLANIM)
					end
				end
				tmp:SetTween(totalTime,-OneItemSize*(l_basicCicleNum+(10-showNum+1)),finishFunc)
				tmp:DoPlay()
			end)
		end
	end
end

function PartyLotteryItem:Update()
	if self:IsInited() then
		for i=1,maxNumItemSize do
			if self.numberScrollItems[i]:IsInited() then
				self.numberScrollItems[i]:Update()
			end
		end
	end
end

function PartyLotteryItem:UnLoadTemPlent()
	if self.numberScrollItems then
		for i = 1, #self.numberScrollItems do
			if self.numberScrollItems[i] then
				self.numberScrollItems[i]:DoKill()
				self:UninitTemplate(self.numberScrollItems[i])
				self.numberScrollItems[i] = nil
			end
		end
		self.numberScrollItems = nil
	end
end
--lua custom scripts end
return PartyLotteryItem