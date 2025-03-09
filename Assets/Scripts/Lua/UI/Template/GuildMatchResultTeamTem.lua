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
--next--
--lua fields end

--lua class define
---@class GuildMatchResultTeamTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field winText MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field ScoreNum MoonClient.MLuaUICom
---@field loseText MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@class GuildMatchResultTeamTem : BaseUITemplate
---@field Parameter GuildMatchResultTeamTemParameter

GuildMatchResultTeamTem = class("GuildMatchResultTeamTem", super)
--lua class define end

--lua functions
function GuildMatchResultTeamTem:Init()

    super.Init(self)

end --func end
--next--
function GuildMatchResultTeamTem:BindEvents()


end --func end
--next--
function GuildMatchResultTeamTem:OnDestroy()


end --func end
--next--
function GuildMatchResultTeamTem:OnDeActive()


end --func end
--next--
function GuildMatchResultTeamTem:OnSetData(data)
    if data.BGType == "Blue" then
        self.Parameter.Bg:SetSprite("main", "UI_Main_Bg_Mvp_01.png")
    else
        self.Parameter.Bg:SetSprite("main", "UI_Main_Bg_Mvp_02.png")
    end
    self.Parameter.winText.UObj:SetActiveEx(true)
    if data.isWin == DungeonsResultStatus.kResultVictory then
        self.Parameter.winText.LabText = Common.Utils.Lang("RESULT_WIN")
    elseif data.isWin == DungeonsResultStatus.kResultDraw then
        self.Parameter.winText.LabText = Common.Utils.Lang("RESULT_DRAW")
    else
        self.Parameter.winText.LabText = Common.Utils.Lang("RESULT_LOSE")
    end
    self.Parameter.Bg.UObj:SetActiveEx(data.isWin == DungeonsResultStatus.kResultVictory)
    self.Parameter.loseText.UObj:SetActiveEx(not data.isWin)
    self.Parameter.TxtName.LabText = data.MvpName
    self.Parameter.ScoreNum.LabText = tostring(data.Score)

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildMatchResultTeamTem