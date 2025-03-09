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
---@class RankFigureTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Num MoonClient.MLuaUICom
---@field figureIcon MoonClient.MLuaUICom
---@field Bg_BangWai MoonClient.MLuaUICom

---@class RankFigureTem : BaseUITemplate
---@field Parameter RankFigureTemParameter

RankFigureTem = class("RankFigureTem", super)
--lua class define end

--lua functions
function RankFigureTem:Init()

    super.Init(self)

end --func end
--next--
function RankFigureTem:BindEvents()


end --func end
--next--
function RankFigureTem:OnDestroy()


end --func end
--next--
function RankFigureTem:OnDeActive()


end --func end
--next--

function RankFigureTem:OnSetData(data)
    self.Parameter.Text_Num.LabText = data.value
    self.Parameter.Text_Num.LabColor = data.color
    MLuaCommonHelper.SetRectTransformWidth(self:gameObject(), data.columnWidth)
    if tonumber(data.value) <= 3 and tonumber(data.value) ~= -1 then
        self.Parameter.figureIcon:SetActiveEx(true)
        self.Parameter.figureIcon:SetSprite("CommonIcon", "UI_CommonIcon_Icon_Rank_0" .. data.value .. ".png", true)
        self.Parameter.figureIcon.Img:SetNativeSize()--todo 0.7
        self.Parameter.figureIcon.gameObject.transform:SetLocalScale(0.7, 0.7, 1)
        self.Parameter.Bg_BangWai:SetActiveEx(false)
        self.Parameter.Text_Num:SetActiveEx(false)
    elseif tonumber(data.value) == -1 then
        self.Parameter.figureIcon:SetActiveEx(false)
        self.Parameter.Text_Num:SetActiveEx(true)
        self.Parameter.Text_Num.LabText = Common.Utils.Lang("OUT_RANK")
        self.Parameter.Bg_BangWai:SetActiveEx(false)
    else
        self.Parameter.Text_Num:SetActiveEx(true)
        self.Parameter.figureIcon:SetActiveEx(false)
        self.Parameter.Bg_BangWai:SetActiveEx(false)
    end

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RankFigureTem