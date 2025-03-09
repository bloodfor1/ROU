--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HuntDayPointPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class HuntDayPointCtrl : UIBaseCtrl
HuntDayPointCtrl = class("HuntDayPointCtrl", super)
--lua class define end

--lua functions
function HuntDayPointCtrl:ctor()

    super.ctor(self, CtrlNames.HuntDayPoint, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function HuntDayPointCtrl:Init()

    self.panel = UI.HuntDayPointPanel.Bind(self)
    super.Init(self)
    self.panel.Btn_wenhao:AddClickWithLuaSelf(self.ShowHelpPanel, self)
end --func end
--next--
function HuntDayPointCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HuntDayPointCtrl:OnActive()

    self:RefreshPoint()
end --func end
--next--
function HuntDayPointCtrl:OnDeActive()


end --func end
--next--
function HuntDayPointCtrl:Update()


end --func end
--next--
function HuntDayPointCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("FestivalMgr").EventDispatcher, MgrMgr:GetMgr("FestivalMgr").Event.PointRefresh, self.RefreshPoint)
end --func end
--next--
--lua functions end

--lua custom scripts
function HuntDayPointCtrl:RefreshPoint()
    local festivalData = DataMgr:GetData("FestivalData").GetDataByType(EnmBackstageDetailType.EnmBackstageDetailTypeHuntField)
    if festivalData == nil then
        self.panel.PointNum.LabText = ""
        self.panel.ChipNum.LabText = ""
        return
    end

    self.panel.PointNum.LabText = Lang("HUNT_DAY_POINT") .. self:GetStr(1, festivalData)
    self.panel.ChipNum.LabText = Lang("HUNT_DAY_CHIP") .. self:GetStr(2, festivalData)
end

function HuntDayPointCtrl:GetStr(index, festivalData)
    local itemID = festivalData.score_limit_list[index].item_id
    local type = festivalData.score_limit_list[index].commondata_type
    local limit = festivalData.score_limit_list[index].everyday_limit
    local num = MgrMgr:GetMgr("FestivalMgr").GetCommonDataValue(type, itemID)
    local str = tostring(num)
    if limit and limit ~= 0 then
        str = str .. "/" .. tostring(limit)
    end
    return str
end

function HuntDayPointCtrl:ShowHelpPanel()
    local tipsInfos = MGlobalConfig:GetVectorSequence("HuntingGroundHint")
    local str = ""
    for i = 0, tipsInfos.Length - 1 do
        if i== tipsInfos.Length - 1 then
            str = str .. "\n"
        end
        local tipsInfo = tipsInfos[i]
        if tipsInfo.Length == 1 then
            str = str .. Lang(tipsInfo[0]) .. "\n"
        else
            local Items = {}
            MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardPackId(tonumber(tipsInfo[1]), Items)
            local num801 = 0
            local num802 = 0
            for k, v in pairs(Items) do
                if v.item_id == 801 then
                    num801 = v.count
                elseif v.item_id == 802 then
                    num802 = v.count
                end
            end
            str = str .. Lang(tipsInfo[0], num801, num802) .. "\n"
        end
    end
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = str,
        alignment = UnityEngine.TextAnchor.UpperCenter,
        pos = {
            x = 318,
            y = 334,
        },
        width = 400,
    })
end
--lua custom scripts end
return HuntDayPointCtrl