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
---@class RegionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RewardBtn MoonClient.MLuaUICom
---@field RegionTipsButton MoonClient.MLuaUICom
---@field RegionText MoonClient.MLuaUICom
---@field RegionRecordText MoonClient.MLuaUICom
---@field RegionLockText MoonClient.MLuaUICom
---@field Region MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field RecordInfo MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Items MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field DropdownBtn MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field PollyHead MoonClient.MLuaUIGroup

---@class RegionTemplate : BaseUITemplate
---@field Parameter RegionTemplateParameter

RegionTemplate = class("RegionTemplate", super)
--lua class define end

--lua functions
function RegionTemplate:Init()
	
	super.Init(self)
	self.isShow = true
	self._pollyTemplatePool = self:NewTemplatePool({
	        TemplateClassName = "PollyHeadTemplate",
	        TemplateParent = self.Parameter.Items.transform,
	        TemplatePrefab = self.Parameter.PollyHead.gameObject,
	        Method = function(index,typeId,polly)
	            self:onSelectOne(index,typeId,polly)
	        end
	    })
	self.data = nil
	
end --func end
--next--
function RegionTemplate:BindEvents()
	
    self:BindEvent(GlobalEventBus,EventConst.Names.OnDiscoverPollyToRegion,
        function(self, regionId)
	        if self.data == nil or regionId == 0 then
	        	return
	        end
	        self.isShow = self.data.regionId == regionId
			local l_pollys = {}
			for k,v in pairs(self.data.unlockPolly) do
				table.insert(l_pollys,v)
			end
			table.sort(l_pollys,function(a,b)
				return a.time < b.time
			end)
	        self:SwitchShowRegion(l_pollys)
        end)

    self:BindEvent(GlobalEventBus,EventConst.Names.OnModifyPollyRegionAward,
        function(self, regionId)
	        if self.data == nil or regionId == 0 or self.data.regionId ~= regionId then
	        	return
	        end
    		local l_hasCanGetAward = false
			for k,v in pairs(self.data.awards) do
				if v.finish and not v.gotAward and not l_hasCanGetAward then
					l_hasCanGetAward = true
					break
				end
			end
			self.Parameter.RedSign:SetActiveEx(l_hasCanGetAward)
        end)

	
end --func end
--next--
function RegionTemplate:OnDestroy()
	
	
end --func end
--next--
function RegionTemplate:OnDeActive()
	
	
end --func end
--next--
function RegionTemplate:OnSetData(data)
	
	self.data = data
	local l_playerLv = MPlayerInfo.Lv
	local l_lv = data.level
	local l_pollys = {}
	for k,v in pairs(data.unlockPolly) do
		table.insert(l_pollys,v)
	end
	table.sort(l_pollys,function(a,b)
		return a.time < b.time
	end)
	local l_count = #l_pollys
	self.Parameter.RegionText.LabText = string.format("[%s]",tostring(data.name))
	self.Parameter.RegionTipsButton:SetActiveEx(false)
	self.Parameter.RegionText:AddClick(function ( ... )
		 local l_regionTableData = TableUtil.GetRegionTable().GetRowByRegionId(data.regionId)
		 if l_regionTableData == nil then
		 	return
		 end
      	local l_pointEventData = {}
        l_pointEventData.position = Input.mousePosition
        MgrMgr:GetMgr("TipsMgr").ShowMarkTips(data.name, tostring(l_regionTableData.Description), l_pointEventData, anchorePos or Vector2(-0.5, 0.5), MUIManager.UICamera, true)
	end)
	local l_unlock = l_playerLv >= l_lv
	self.Parameter.Lock.gameObject:SetActiveEx(not l_unlock)
	self.Parameter.DropdownBtn.gameObject:SetActiveEx(l_unlock)
	self.Parameter.RecordInfo.gameObject:SetActiveEx(l_unlock)
	if l_unlock then
		self.Parameter.Count.LabText = tostring(l_count) 
		if l_count == 0 then
			self.isShow = false
		end
		self:SwitchShowRegion(l_pollys)
		self.Parameter.DropdownBtn:AddClick(function()
			self.isShow = not self.isShow
			self:SwitchShowRegion(l_pollys)
		end)
		local l_awards = {}
		local l_hasCanGetAward = false
		for k,v in pairs(data.awards) do
			if v.finish and not v.gotAward and not l_hasCanGetAward then
				l_hasCanGetAward = true
			end
			table.insert(l_awards,v)
		end
		table.sort(l_awards, function( a,b )
			return a.count < b.count
		end)
		self.Parameter.RewardBtn:AddClick(function( ... )
			UIMgr:ActiveUI(UI.CtrlNames.PollyReward,{awardData = l_awards})
		end)
		self.Parameter.RedSign:SetActiveEx(l_hasCanGetAward)
	else
		self.Parameter.Items.gameObject:SetActiveEx(false)
		self.Parameter.Empty.gameObject:SetActiveEx(false)
		self.Parameter.RegionLockText.LabText = StringEx.Format(Common.Utils.Lang("POLLY_REGION_UNLOCK_LEVEL_TIP"),l_lv) 	
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RegionTemplate:SwitchShowRegion(pollys)
	local l_count = #pollys

	if self.isShow then
		local l_empty = l_count == 0
		self.Parameter.Items.gameObject:SetActiveEx(not l_empty)
		self.Parameter.Empty.gameObject:SetActiveEx(l_empty)
		if not l_empty then
			self:UpdatePolly(pollys)
		end
		MLuaCommonHelper.SetLocalRotEuler(self.Parameter.DropdownBtn.UObj, 0,0,0)	
	else
		self.Parameter.Items.gameObject:SetActiveEx(false)
		self.Parameter.Empty.gameObject:SetActiveEx(false)
		MLuaCommonHelper.SetLocalRotEuler(self.Parameter.DropdownBtn.UObj,0,0,180)	
	end
end

function RegionTemplate:UpdatePolly( pollys )
	self.Parameter.Count.LabText = tostring(#pollys) 

	self._pollyTemplatePool:ShowTemplates({
        Datas = pollys
    })

end

function RegionTemplate:onSelectOne(index,typeId,polly)
	self.MethodCallback(polly)
   	-- self._pollyTemplatePool:SelectTemplate(index)
   	if typeId == 0 then
   		return
   	end
   	if UIMgr:IsActiveUI(UI.CtrlNames.Polly) then
        local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Polly)
        l_ctrl:SelectOneHandler(UI.HandlerNames.PollyMyNote,function(handler)
        	handler:SelectOneType(typeId)
        end)
    end
end --func end
--lua custom scripts end
return RegionTemplate