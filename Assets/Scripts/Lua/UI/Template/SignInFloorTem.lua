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
---@class SignInFloorTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StartImg MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field EndImg MoonClient.MLuaUICom

---@class SignInFloorTem : BaseUITemplate
---@field Parameter SignInFloorTemParameter

SignInFloorTem = class("SignInFloorTem", super)
--lua class define end

--lua functions
function SignInFloorTem:Init()

    super.Init(self)

end --func end
--next--
function SignInFloorTem:OnDestroy()


end --func end
--next--
function SignInFloorTem:OnDeActive()


end --func end
--next--
function SignInFloorTem:OnSetData(data)
    self:transform():SetLocalPosZero()
    if data.isStart then
        self.Parameter.Floor:SetSprite("Welfare", "UI_Welfare_Button_Zhengchang.png")
        self.Parameter.StartImg:SetActiveEx(true)
        self.Parameter.EndImg:SetActiveEx(false)
    end

    if data.isEnd then
        self.Parameter.Floor:SetSprite("Welfare", "UI_Welfare_Button_Zhengchang.png")
        self.Parameter.StartImg:SetActiveEx(false)
        self.Parameter.EndImg:SetActiveEx(true)
    end

    if data.index then
        self.Parameter.StartImg:SetActiveEx(false)
        self.Parameter.EndImg:SetActiveEx(false)
        local row = TableUtil.GetMouthAttendanceTable().GetRowByDay(data.index)
        if row == nil then
            logError(StringEx.Format("MouthAttendanceTable 缺损数据 => day={0}", data.index))
            return
        end

        if row.AwardType == 1 then
            self.Parameter.Floor:SetSprite("Welfare", "UI_Welfare_Button_Jingxi.png")
        elseif row.AwardType == 2 then
            self.Parameter.Floor:SetSprite("Welfare", "UI_Welfare_Button_Teshu.png")
        else
            self.Parameter.Floor:SetSprite("Welfare", "UI_Welfare_Button_Zhengchang.png")
        end
    end

end --func end
--next--
function SignInFloorTem:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SignInFloorTem