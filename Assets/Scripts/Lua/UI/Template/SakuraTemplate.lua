--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class SakuraTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleIcon MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field ShopTime MoonClient.MLuaUICom
---@field RankButton MoonClient.MLuaUICom
---@field ModelTxt MoonClient.MLuaUICom[]
---@field ModelName MoonClient.MLuaUICom[]
---@field ModelContent MoonClient.MLuaUICom
---@field Layer3Pic1 MoonClient.MLuaUICom
---@field Layer1Pic1 MoonClient.MLuaUICom
---@field ItemTemplate MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom[]
---@field Describe MoonClient.MLuaUICom
---@field CountTip2 MoonClient.MLuaUICom
---@field CountTip1 MoonClient.MLuaUICom
---@field CountTip MoonClient.MLuaUICom
---@field CountText3 MoonClient.MLuaUICom[]
---@field CountText2 MoonClient.MLuaUICom[]
---@field CountText1 MoonClient.MLuaUICom[]
---@field CountButton MoonClient.MLuaUICom[]
---@field BtnTxt MoonClient.MLuaUICom
---@field BtnGo MoonClient.MLuaUICom

---@class SakuraTemplate : BaseUITemplate
---@field Parameter SakuraTemplateParameter

SakuraTemplate = class("SakuraTemplate", super)
--lua class define end

--lua functions
function SakuraTemplate:Init()
	
    super.Init(self)
    self.fData = DataMgr:GetData("FestivalData")
    self.mgr = MgrMgr:GetMgr("FestivalMgr")
    --活动奖励列表项的池创建
    self.awardTemplate = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.Parameter.ItemTemplate.LoopScroll
    })
	
end --func end
--next--
function SakuraTemplate:BindEvents()
	
    local awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self:BindEvent(awardPreviewMgr.EventDispatcher, self.mgr.Event.OnGetAwardPreview, self.OnGetAwardPreview)
	
end --func end
--next--
function SakuraTemplate:OnDestroy()
	
	
end --func end
--next--
function SakuraTemplate:OnDeActive()
	
	
end --func end
--next--
function SakuraTemplate:OnSetData(data)

    self.scorePanel = {}
    self.moneyPanel = {}
    self.scoreID = 1
    self.moneyID = 1

    self.Parameter.TitleIcon:SetSpriteAsync(data.atlas_name, data.icon_name_2, function()
        self.Parameter.TitleIcon.Img:SetNativeSize()
    end)
    self.Parameter.Layer1Pic1:SetRawTex("Festival/" .. data.icon_name_4, false)
    self.Parameter.Layer1Pic1.RawImg:SetNativeSize()
    self.Parameter.Layer3Pic1:SetSpriteAsync(data.atlas_name, data.icon_name_3, function()
        self.Parameter.Layer3Pic1.Img:SetNativeSize()
    end)
    self.Parameter.Describe.LabText = data.acitive_text
    self.Parameter.Time.LabText = self:GetActivityTime(data)
    self.Parameter.BtnTxt.LabText = data.button_txt
    for i = 1, #self.Parameter.Item do
        self.Parameter.Item[i]:SetActiveEx(true)
    end
    if data.activity_form then
        self.Parameter.ModelName[1].LabText = Lang("MODEL")
        self.Parameter.ModelTxt[1].LabText = self.fData.ActivityForm[data.activity_form]
    else
        self.Parameter.Item[1]:SetActiveEx(false)
    end
    if data.act_times ~= 0 then
        self.Parameter.ModelName[2].LabText = Lang("COUNT_LIMIT")
        self.Parameter.ModelTxt[2].LabText = tostring(self.mgr.GetCommonDataValue(CommondataType.kCDT_BACKSTAGE_ACT, data.play_time_key))
                .. "/" .. tostring(data.act_times)
    else
        self.Parameter.Item[2]:SetActiveEx(false)
    end
    if data.system_id ~= 0 then
        local l_data = TableUtil.GetOpenSystemTable().GetRowById(data.system_id)
        if l_data and l_data.BaseLevel > 0 then
            self.Parameter.ModelName[3].LabText = Lang("LEVEL2")
            self.Parameter.ModelTxt[3].LabText = tostring(l_data.BaseLevel)
        else
            self.Parameter.Item[3]:SetActiveEx(false)
        end
    else
        self.Parameter.Item[3]:SetActiveEx(false)
    end
    self:GetPreviewAwards(data.award_id)
    local l_openType = string.ro_split(data.target, "=")
    local l_isOpen = self.mgr.CheckActivityOpen(data.actual_time.first, data.actual_time.second, data.day_times) or
            self.mgr.CheckActivityOpen(data.fetch_award_time.first, data.fetch_award_time.second, {})
    self.Parameter.BtnGo:SetGray(not l_isOpen)
    self.Parameter.BtnGo:AddClick(function()
        if not l_isOpen then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_BOLI_NOT_OPEN"))
            return
        end
        game:ShowMainPanel()
        l_openType[1] = tonumber(l_openType[1])
        if l_openType and l_openType[1] == self.fData.EOpenType.OpenSystem then
            Common.CommonUIFunc.InvokeFunctionByFuncId(tonumber(l_openType[2]), nil, true)
        elseif l_openType[1] == self.fData.EOpenType.URL then
            Application.OpenURL(l_openType[2])
        end
    end)
    if self.RedSignProcessor ~= nil then
        self:UninitRedSign(self.RedSignProcessor)
        self.RedSignProcessor = nil
    end
    if self.RedSignProcessor == nil and self.fData.ActivityRedSign[data.system_id] then
        self.RedSignProcessor = self:NewRedSign({
            Key = self.fData.ActivityRedSign[data.system_id][2],
            ClickButton = self.Parameter.BtnGo
        })
    end
    self:InitRank(data.score_limit_list, data.rank_main_id)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SakuraTemplate:GetActivityTime(data)

    local str = self.mgr.GetYMD(data.actual_time.first) .. " - " .. self.mgr.GetYMD(data.actual_time.second)
    if data.day_times and #data.day_times > 0 then
        str = str .. "\n" .. Lang("EVERYDAY")
        for i = 1, #data.day_times do
            local OneDay = 86400
            str = str .. self.mgr.GetHMS(data.day_times[i].first) .. " - "
            if data.day_times[i].second > OneDay then
                str = str .. Lang("TOMORROW") .. self.mgr.GetHMS(data.day_times[i].second - OneDay)
            else
                str = str .. self.mgr.GetHMS(data.day_times[i].second)
            end
            if i ~= #data.day_times then
                str = str .. ", "
            end
        end
    end
    if data.fetch_award_time.second > 100 then
        str = str .. "\n" .. Lang("ActivityHuntingShopTimeLimit") .. self.mgr.GetYMD(data.fetch_award_time.second)
    end
    return str

end

--奖励预览显示
function SakuraTemplate:GetPreviewAwards(packId)

    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(packId, self.mgr.Event.OnGetAwardPreview)

end

function SakuraTemplate:OnGetAwardPreview(awardList)

    local l_costDatas = {}
    if awardList then
        for i, v in ipairs(awardList.award_list) do
            local data = {
                ID = v.item_id,
                Count = v.count,
                IsShowCount = false
            }
            table.insert(l_costDatas, data)
        end
    end
    self.awardTemplate:ShowTemplates({ Datas = l_costDatas })

end

function SakuraTemplate:InitRank(rankData, rankID)

    self.Parameter.RankButton:SetActiveEx(false)
    self.Parameter.CountTip:SetActiveEx(false)
    if rankID > 0 then
        self.Parameter.RankButton:SetActiveEx(true)
        self.Parameter.RankButton:AddClick(function()
            local openData = {
                openType = 1,
                RankMainType = rankID,
            }
            UIMgr:ActiveUI(UI.CtrlNames.Rank, openData)
        end, true)
    end

    local l_rankType =
    {
        Score = 1,
        Money = 2,
    }
    if rankData then
        self.Parameter.CountTip:SetActiveEx(true)
        for k, v in pairs(rankData) do
            if v.item_type == l_rankType.Score then
                table.insert(self.scorePanel, v)
            elseif v.item_type == l_rankType.Money then
                table.insert(self.moneyPanel, v)
            end
        end
        local l_scoreLen, l_moneyLen = #self.scorePanel, #self.moneyPanel
        self.Parameter.CountButton[1]:SetActiveEx(l_scoreLen > 1)
        self.Parameter.CountButton[2]:SetActiveEx(l_moneyLen > 1)
        self.Parameter.CountButton[1]:AddClick(function()
            self.scoreID = self.scoreID + 1
            if l_scoreLen > 0 and self.scoreID > l_scoreLen then
                self.scoreID = 1
            end
            if l_scoreLen > 0 then
               self:RefreshRank()
            end
        end, true)
        self.Parameter.CountButton[2]:AddClick(function()
            self.moneyID = self.moneyID + 1
            if l_moneyLen > 0 and self.moneyID > l_moneyLen then
                self.moneyID = 1
            end
            if l_moneyLen > 0 then
                self:RefreshRank()
            end
        end, true)
        self:RefreshRank()
    end

end

function SakuraTemplate:RefreshRank()

    local l_scoreLen, l_moneyLen = #self.scorePanel, #self.moneyPanel
    self.Parameter.CountTip1:SetActiveEx(l_scoreLen > 0)
    self.Parameter.CountTip2:SetActiveEx(l_moneyLen > 0)

    if l_scoreLen > 0 then
        local l_info = self.scorePanel[self.scoreID]
        self.Parameter.CountTip:SetActiveEx(true)
        self.Parameter.CountText3[1].LabText = l_info.local_today .. ": " ..
                tostring(self.mgr.GetCommonDataValue(l_info.commondata_type, l_info.item_id))
        self.Parameter.CountText2[1].LabText = l_info.local_total .. ": " ..
                tostring(self.mgr.GetCommonDataValue(CommondataType.kCDT_BACKSTAGE_TOTAL_SCORE, l_info.item_id))
        self.Parameter.CountText1[1]:SetActiveEx(l_info.everyday_limit > 0)
        self.Parameter.CountText1[1].LabText = l_info.local_limit .. ": " .. l_info.everyday_limit
    end
    if l_moneyLen > 0 then
        local l_info = self.moneyPanel[self.moneyID]
        self.Parameter.CountTip:SetActiveEx(true)
        self.Parameter.CountText3[2].LabText = l_info.local_today .. ": " ..
                tostring(self.mgr.GetCommonDataValue(l_info.commondata_type, l_info.item_id))
        self.Parameter.CountText2[2].LabText = l_info.local_total .. ": " ..
                tostring(self.mgr.GetCommonDataValue(CommondataType.kCDT_BACKSTAGE_TOTAL_SCORE, l_info.item_id))
        self.Parameter.CountText1[2]:SetActiveEx(l_info.everyday_limit > 0)
        self.Parameter.CountText1[2].LabText = l_info.local_limit .. ": " .. l_info.everyday_limit
    end

end
--lua custom scripts end
return SakuraTemplate