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
local Mgr = MgrProxy:GetGarderobeMgr()
--lua fields end

--lua class define
---@class GarderobeAwardCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtRewardFashionPoint MoonClient.MLuaUICom
---@field myloopscroll MoonClient.MLuaUICom
---@field IconContent3 MoonClient.MLuaUICom
---@field IconContent2 MoonClient.MLuaUICom
---@field IconContent1 MoonClient.MLuaUICom
---@field BtnRewardGeted MoonClient.MLuaUICom
---@field BtnAward MoonClient.MLuaUICom

---@class GarderobeAwardCellTemplate : BaseUITemplate
---@field Parameter GarderobeAwardCellTemplateParameter

GarderobeAwardCellTemplate = class("GarderobeAwardCellTemplate", super)
--lua class define end

--lua functions
function GarderobeAwardCellTemplate:Init()
	
	super.Init(self)
	self:Bind()
	    self.ItemPool = nil
	
end --func end
--next--
function GarderobeAwardCellTemplate:OnDestroy()
	
	
end --func end
--next--
function GarderobeAwardCellTemplate:OnDeActive()
	
	
end --func end
--next--
function GarderobeAwardCellTemplate:OnSetData(data)
	
	if data ~= nil then
		self.cellData = data
		self:RefreshCell()
	end
	
end --func end
--next--
function GarderobeAwardCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GarderobeAwardCellTemplate:OnActive()

end

--next--
function GarderobeAwardCellTemplate:BindEvents()
	if Mgr == null then Mgr = MgrProxy:GetGarderobeMgr() end
	self:BindEvent(Mgr.EventDispatcher,Mgr.ON_GARDEROBE_FASHION_AWARD_RES,function ()
        self:RefreshCell()
    end)
end --func end


function GarderobeAwardCellTemplate:Bind()
	self.Parameter.BtnRewardGeted.gameObject:SetActiveEx(false)
	self.Parameter.BtnAward:AddClick(function ()
		MgrProxy:GetGarderobeMgr().RequestFashionCountSendAward(self.cellData.garderobeRewardItem.ID)
	end)
end

-- 获取典藏值
function GarderobeAwardCellTemplate:GetGarderobePoint()
    if self.cellData then
        return self.cellData.garderobeRewardItem.Point
    end
    return 0
end

function GarderobeAwardCellTemplate:RefreshCell()
	local fashionCount = MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count
	self.Parameter.BtnAward:SetGray(true)
	self.Parameter.BtnAward.gameObject:SetActiveEx(false)
	self.Parameter.BtnRewardGeted.gameObject:SetActiveEx(false)

	local flag = false
	for _,item in ipairs(MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count_award) do
		if item.value == self.cellData.index then
			flag = true
			--break
		end
	end

	if flag then
		self.Parameter.BtnAward.gameObject:SetActiveEx(not flag)
		self.Parameter.BtnRewardGeted.gameObject:SetActiveEx(flag)
	else
		if self.cellData.garderobeRewardItem.Point <= fashionCount then
			self.Parameter.BtnAward:SetGray(false)
		else
			self.Parameter.BtnAward:SetGray(true)
		end
		self.Parameter.BtnAward.gameObject:SetActiveEx(not flag)
		self.Parameter.BtnRewardGeted.gameObject:SetActiveEx(flag)
	end
	
	local str = ""
	if fashionCount >= self.cellData.garderobeRewardItem.Point then
		str =  Common.Utils.Lang("FashionStr2","<color=#" .. RoColor.WordColor.Blue[1] .. ">" .. self.cellData.garderobeRewardItem.Point .. "</color>")
	else
		str =  Common.Utils.Lang("FashionStr2","<color=#" .. RoColor.WordColor.Red[1] .. ">" .. self.cellData.garderobeRewardItem.Point .. "</color>")
	end

	self.Parameter.TxtRewardFashionPoint.LabText = str
	self.Parameter.IconContent1.gameObject.transform.parent.gameObject:SetActiveEx(false)
	self.Parameter.IconContent2.gameObject.transform.parent.gameObject:SetActiveEx(false)
	self.Parameter.IconContent3.gameObject.transform.parent.gameObject:SetActiveEx(false)
    if not self.ItemPool then
        self.ItemPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.ItemTemplate,
            ScrollRect = self.Parameter.myloopscroll.LoopScroll,
        })
    end
    local l_datas = {}
    for i, v in ipairs(self.cellData.packRewardItem) do
        table.insert(l_datas, { ID = v.id, Count = v.num })
    end
    self.ItemPool:ShowTemplates({Datas = l_datas})
end
--lua custom scripts end
return GarderobeAwardCellTemplate