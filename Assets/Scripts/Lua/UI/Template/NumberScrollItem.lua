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
local numberImageTb = 
{
[0] = "ui_Party_Number_0.png",
[1] = "ui_Party_Number_1.png",
[2] = "ui_Party_Number_2.png",
[3] = "ui_Party_Number_3.png",
[4] = "ui_Party_Number_4.png",
[5] = "ui_Party_Number_5.png",
[6] = "ui_Party_Number_6.png",
[7] = "ui_Party_Number_7.png",
[8] = "ui_Party_Number_8.png",
[9] = "ui_Party_Number_9.png",
}
--lua fields end

--lua class define
---@class NumberScrollItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field NumberScrollItem MoonClient.MLuaUICom
---@field NumTemPlent MoonClient.MLuaUICom
---@field Image_BeforDec MoonClient.MLuaUICom
---@field Image_Befor MoonClient.MLuaUICom
---@field Image_Now MoonClient.MLuaUICom
---@field Image_Next MoonClient.MLuaUICom
---@field Image_NextAdd MoonClient.MLuaUICom

---@class NumberScrollItem : BaseUITemplate
---@field Parameter NumberScrollItemParameter

NumberScrollItem = class("NumberScrollItem", super)
--lua class define end

--lua functions
function NumberScrollItem:Init()
	
	super.Init(self)
	self.usePool = false
	self.isSetSprite = false
	--记录初始化偏移位置
	self.parentFirstPos = self.Parameter.NumTemPlent.transform.anchoredPosition.y
	--每一个数字的最大间隔
	self.oneItemMaxHeight = 86
	--保存Dotween引用
	self.tweenAnim = self.Parameter.NumTemPlent.gameObject:GetComponent("DOTweenAnimation")
	self.index = 0
	--初始化数据结构
	self:SetItemPos(
					{obj = self.Parameter.Image_BeforDec,index = 8},
					{obj = self.Parameter.Image_Befor,index = 9},
					{obj = self.Parameter.Image_Now,index = 0},
					{obj = self.Parameter.Image_Next,index = 1},
					{obj = self.Parameter.Image_NextAdd,index = 2})
	--记录初始化位置记录
	self.initPosTb = 
	{
		NumTemPlentPos = self.Parameter.NumTemPlent.transform.anchoredPosition,
		BeforDecPos = self.Parameter.Image_BeforDec.transform.anchoredPosition,
		BeforPos = self.Parameter.Image_Befor.transform.anchoredPosition,
		NowPos = self.Parameter.Image_Now.transform.anchoredPosition,
		NextPos = self.Parameter.Image_Next.transform.anchoredPosition,
		NextAddPos = self.Parameter.Image_NextAdd.transform.anchoredPosition
	}
	
end --func end
--next--
function NumberScrollItem:OnDestroy()
	
	
end --func end
--next--
function NumberScrollItem:OnDeActive()
	
	self:ReSetScrollPos()
	self.isSetSprite = true
	
end --func end
--next--
function NumberScrollItem:OnSetData(data)
	
	
end --func end
--next--
function NumberScrollItem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
NumberScrollItem.TemplatePath="UI/Prefabs/NumberScrollItem"

function NumberScrollItem:Update()
	if self.now == nil or self.befor== nil or self.next== nil or self.nextAdd== nil or self.beforDec==nil then return end
	local nowPos = self.Parameter.NumTemPlent.transform.anchoredPosition.y 
	local resetPos = self.parentFirstPos
	local isUp = false
	local isDown = false
	isUp = (nowPos - resetPos) >= self.oneItemMaxHeight
	isDown =(nowPos - resetPos) <= -self.oneItemMaxHeight
	if isUp then
		self.index = self.index + 1 
		self.parentFirstPos = self.oneItemMaxHeight * self.index --indexself.Parameter.NumTemPlent.transform.anchoredPosition.y 
		self.beforDec.obj.transform.anchoredPosition =  Vector3.New(self.beforDec.obj.transform.anchoredPosition.x, self.nextAdd.obj.transform.anchoredPosition.y - self.oneItemMaxHeight, self.beforDec.obj.transform.anchoredPosition.z)
		local setNewIndex = self:GetRealInex(isUp,isDown,self.nextAdd.index)
		local beforDec = {obj=self.beforDec.obj,index=setNewIndex}
		local befor = {obj=self.befor.obj,index=self.befor.index}
		local now = {obj=self.now.obj,index=self.now.index}
		local next = {obj=self.next.obj,index=self.next.index}
		local nextAdd = {obj=self.nextAdd.obj,index=self.nextAdd.index}
		self:SetItemPos(befor,now,next,nextAdd,beforDec)
	end

	if isDown then
		self.index = self.index - 1 
		self.parentFirstPos = self.oneItemMaxHeight * self.index --indexself.Parameter.NumTemPlent.transform.anchoredPosition.y 
		self.nextAdd.obj.transform.anchoredPosition =  Vector3.New(self.nextAdd.obj.transform.anchoredPosition.x, self.beforDec.obj.transform.anchoredPosition.y + self.oneItemMaxHeight, self.nextAdd.obj.transform.anchoredPosition.z)
		local setNewIndex = self:GetRealInex(isUp,isDown,self.beforDec.index)
		local beforDec = {obj=self.beforDec.obj,index=self.beforDec.index}
		local befor = {obj=self.befor.obj,index=self.befor.index}
		local now = {obj=self.now.obj,index=self.now.index}
		local next = {obj=self.next.obj,index=self.next.index}
		local nextAdd = {obj = self.nextAdd.obj,index = setNewIndex}
		self:SetItemPos(nextAdd,beforDec,befor,now,next)
	end
end

function NumberScrollItem:InitNum( nowIndex )
	self:SetItemPos(
					{obj = self.Parameter.Image_BeforDec,index = nowIndex-2<0 and 9 or nowIndex-2},
					{obj = self.Parameter.Image_Befor,index = nowIndex-1<0 and 0 or nowIndex-1},
					{obj = self.Parameter.Image_Now,index = nowIndex},
					{obj = self.Parameter.Image_Next,index = nowIndex+1>=10 and 0 or nowIndex+1},
					{obj = self.Parameter.Image_NextAdd,index = nowIndex+2>=10 and 1 or nowIndex+2})
end

function NumberScrollItem:InitNyNumGroup( GroupBumber )
	local group = {}
	for i=1,5 do
		local cNum = tonumber(string.sub(tostring(GroupBumber),i,i))
		table.insert(group,tonumber(cNum))
	end
	self:SetItemPos(
					{obj = self.Parameter.Image_BeforDec,index = group[1]},
					{obj = self.Parameter.Image_Befor,index = group[2]},
					{obj = self.Parameter.Image_Now,index = group[3]},
					{obj = self.Parameter.Image_Next,index = group[4]},
					{obj = self.Parameter.Image_NextAdd,index = group[5]},true)
end

function NumberScrollItem:SetTween(duration,endValue,finishFunc)
	if self.tweenAnim then
		self.tweenAnim.duration = duration
		self.tweenAnim.endValueV3 = Vector3.New(0,endValue,0)
		self.tweenAnim:CreateTween()
		self.tweenAnim.tween.onComplete = function()
			self.Parameter.NumTemPlent.gameObject:SetRectTransformPos(0,endValue)
			if finishFunc then finishFunc() end
		end
	end
end

function NumberScrollItem:DoPlay()
	if self.tweenAnim then
		self.tweenAnim:DOPlay()
	end
end

function NumberScrollItem:DoKill()
	if self.tweenAnim then
		self.tweenAnim:DOKill()
	end
end

function NumberScrollItem:SetIsShowSprite(state)
	self.isSetSprite = state
end

-- 数据结构是这个形式 {obj = Mobj,index = 当前位置信息},
function NumberScrollItem:SetItemPos(beforDec,befor,now,next,nextAdd,setSp)
	self.beforDec = beforDec
	self.befor = befor
	self.now = now
	self.next = next
	self.nextAdd = nextAdd
	if self.isSetSprite or setSp then
		self.beforDec.obj:SetSprite("Party",numberImageTb[beforDec.index])
		self.befor.obj:SetSprite("Party",numberImageTb[befor.index])
		self.now.obj:SetSprite("Party",numberImageTb[now.index])
		self.next.obj:SetSprite("Party",numberImageTb[next.index])
		self.nextAdd.obj:SetSprite("Party",numberImageTb[nextAdd.index])
	end
end

function NumberScrollItem:GetRealInex( isUp,isDown,index )
	if isDown then
		if index - 1 < 0 then 
			return 9 
		else
			return index - 1
		end
	end

	if isUp then
		if index + 1 >= 10 then 
			return 0 
		else
			return index + 1
		end
	end
end

function NumberScrollItem:ReSetScrollPos( ... )
	self.Parameter.NumTemPlent.transform.anchoredPosition = self.initPosTb.NumTemPlentPos
	self.Parameter.Image_BeforDec.transform.anchoredPosition = self.initPosTb.BeforDecPos
	self.Parameter.Image_Befor.transform.anchoredPosition = self.initPosTb.BeforPos
	self.Parameter.Image_Now.transform.anchoredPosition = self.initPosTb.NowPos
	self.Parameter.Image_Next.transform.anchoredPosition = self.initPosTb.NextPos
	self.Parameter.Image_NextAdd.transform.anchoredPosition = self.initPosTb.NextAddPos
	if self.tweenAnim then
		self.tweenAnim:DORewind()
	end
end
--lua custom scripts end
return NumberScrollItem