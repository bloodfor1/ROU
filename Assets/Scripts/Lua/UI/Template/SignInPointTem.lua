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
---@class SignInPointTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Up MoonClient.MLuaUICom
---@field Tag MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class SignInPointTem : BaseUITemplate
---@field Parameter SignInPointTemParameter

SignInPointTem = class("SignInPointTem", super)
--lua class define end

--lua functions
function SignInPointTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SignInPointTem:OnDestroy()
	
	    self.Data = nil
	
end --func end
--next--
function SignInPointTem:OnDeActive()
	
	
end --func end
--next--
function SignInPointTem:OnSetData(data)
	
	    self.Data = data
	        self:gameObject():SetRectTransformPos(data.Pos.x,data.Pos.y)-- Vector3.New(0,-0.208071,0)
	    self.Mgr = MgrMgr:GetMgr("SignInMgr")
	    local row = TableUtil.GetMouthAttendanceTable().GetRowByDay(data.Index)
	    if row == nil then
	        logError(StringEx.Format("MouthAttendanceTable 缺损数据 => day={0}",data.Index))
	        return
	    end
	    self.Parameter.Btn:AddClick(function()
	        MgrMgr:GetMgr("SignInMgr").TryGetSign(data.Index,data.ItemInfos)
	    end,true)
	    --天数
	    self.Parameter.Desc.LabText = row.DateDisplay or ""
	    self.Parameter.Desc.transform.parent.gameObject:SetActiveEx(not string.ro_isEmpty(row.DateDisplay))
	    --道具
	    self.Parameter.Item:SetActiveEx(false)
		self.Parameter.Item.transform:SetLocalScale(0.5,0.5,0.5)
		self.Parameter.ItemCount:SetActiveEx(false)
	    if row.AwardType == 3 then
	        self.Parameter.Item:SetActiveEx(true)
	        self.Parameter.Item:SetSprite("Welfare","UI_Welfare_Icon_Shaizi.png", true)
	    elseif data.ItemInfos and #data.ItemInfos>0 then
	        self.Parameter.Item:SetActiveEx(true)
	        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(data.ItemInfos[1].id)
	        self.Parameter.Item:SetSprite(l_itemRow.ItemAtlas, l_itemRow.ItemIcon, true)
	            if data.ItemInfos[1].count > 1 then
	                self.Parameter.ItemCount:SetActiveEx(true)
	                self.Parameter.ItemCount.LabText =MNumberFormat.GetNumberFormat(data.ItemInfos[1].count) 
	            end
	    end
	    --领取完成
	    self.Parameter.Tag:SetActiveEx(self.Mgr.CurIndex >= data.Index)
	    --canvas
	    self.Parameter.Up.gameObject:SetRectTransformPos(-2,-1)
	
end --func end
--next--
function SignInPointTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SignInPointTem