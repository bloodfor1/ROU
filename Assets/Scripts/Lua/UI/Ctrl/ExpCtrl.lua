--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ExpPanel"
require "Data/Model/PlayerInfoModel"



--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ExpCtrl = class("ExpCtrl", super)
local l_go = nil
local l_ed = nil
local l_pos = nil
--lua class define end

--lua functions
function ExpCtrl:ctor()

	super.ctor(self, CtrlNames.Exp, UILayer.Normal, UITweenType.Up, ActiveType.Normal)

    self.cacheGrade = EUICacheLv.VeryLow
    self.isShowTip = false
    self.lastEd = nil
    self.overrideSortLayer = UILayerSort.Normal + 5

end --func end
--next--
function ExpCtrl:Init()

	self.panel = UI.ExpPanel.Bind(self)
	super.Init(self)

    if MGameContext.IsOpenGM then
        self.panel.BaseExpTitle.LongBtn.onLongClick = function ()
            MUIManager:CrossFadeOut(0.1)
        end
        self.panel.JobExpTitle.LongBtn.onLongClick = function ()
            MUIManager:CrossFadeIn(0.1)
        end
    end

end --func end
--next--
function ExpCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ExpCtrl:OnActive()
	MLuaUIListener.Get(self.panel.ExpBg.UObj)
	MLuaUIListener.Get(self.panel.JobBg.UObj)

    self.panel.ExpBg.Img.raycastTarget = true
    self.panel.JobBg.Img.raycastTarget = true

    self.panel.ExpBg.Listener.onDown = function(go, ed)
        l_go = go
        l_ed = ed
        l_pos = Vector2(0,0)
        MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()
    end
    self.panel.ExpBg.Listener.onUp = function(go, ed)
        self:HideTip()
    end

    self.panel.JobBg.Listener.onDown = function(go, ed)
        l_go = go
        l_ed = ed
        l_pos = Vector2(1,0)
        MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()
    end
    self.panel.JobBg.Listener.onUp = function(go, ed)
        self:HideTip()
    end

    self:InitSlider()
end --func end

function ExpCtrl:InitSlider()
    self.panel.sldBaseExp.Slider.value = Data.PlayerInfoModel:getBaseExpData() or 0
    self.panel.sldBaseExpBless.Slider.value = Data.PlayerInfoModel:getBaseExpBlessData() or 0
    self.panel.sldJobExp.Slider.value = Data.PlayerInfoModel:getJobExpData() or 0
    self.panel.sldJobExpBless.Slider.value = Data.PlayerInfoModel:getJobExpBlessData() or 0
end

function ExpCtrl:ShowTip(go, ed, pivot)
    local l_data = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData
    --服务器等级数据获取
    local serverBaseLimit = nil
    if l_data.serverlevel ~= nil then
        serverBaseLimit = self:GetBaseLevelUpperLimitByServerLevel(l_data.serverlevel)
    end
    --当前等级大于服务器等级 maxExp 显示--
    --log((serverBaseLimit ~= nil and MPlayerInfo.Lv >= serverBaseLimit))
    local isLimitLevel = serverBaseLimit ~= nil and MPlayerInfo.Lv >= serverBaseLimit
    local maxExp = isLimitLevel and "--" or TableUtil.GetBaseLvTable().GetRowByBaseLv(MPlayerInfo.Lv).Exp
    local maxJobExp = TableUtil.GetJobLvTable().GetRowByJobLv(MPlayerInfo.JobLv).Exp
    local extraFightTime = math.ceil(MPlayerInfo.ExtraFightTime/(60 * 1000))
    local tip = ""
    if MPlayerInfo.BlessExp and MPlayerInfo.BlessExp > MLuaCommonHelper.Long(0) then
        tip = tip .. Lang("EXP_QUESTION_TIP_BASE", math.ceil(Common.Utils.Long2Num(MPlayerInfo.Exp)), maxExp, MPlayerInfo.BlessExp) .. "\n"
    else
        tip = tip .. Lang("EXP_QUESTION_TIP_BASE_NOBLESS", math.ceil(Common.Utils.Long2Num(MPlayerInfo.Exp)), maxExp) .. "\n"
    end
    if isLimitLevel then
        tip = tip .. GetColorText(Lang("FULL_LEVEL_TIPS"), RoColorTag.Yellow) .. "\n"
    end
    if MPlayerInfo.BlessJobExp and MPlayerInfo.BlessJobExp > MLuaCommonHelper.Long(0) then
        tip = tip .. Lang("EXP_QUESTION_TIP_JOB", math.ceil(Common.Utils.Long2Num(MPlayerInfo.JobExp)), maxJobExp, MPlayerInfo.BlessJobExp) .. "\n"
    else
        tip = tip .. Lang("EXP_QUESTION_TIP_JOB_NOBLESS", math.ceil(Common.Utils.Long2Num(MPlayerInfo.JobExp)), maxJobExp) .. "\n"
    end
    tip = tip .. Lang("EXP_QUESTION_TIP_FIGHTTIME", extraFightTime, MgrMgr:GetMgr("DailyTaskMgr").GetStatusTip(extraFightTime))
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(tip, ed, pivot)
    self.isShowTip = true
    self.lastEd = ed
end

function ExpCtrl:HideTip()
    MgrMgr:GetMgr("TipsMgr").HideQuestionTip()
    self.isShowTip = false
    self.lastEd = nil
end
--next--
function ExpCtrl:OnDeActive()
    l_go = nil
    l_ed = nil
    l_pos = nil
end --func end
--next--
function ExpCtrl:Update()


end --func end


--next--
function ExpCtrl:BindEvents()
	--dont override this function
    self:BindEvent(MgrMgr:GetMgr("RoleInfoMgr").EventDispatcher,MgrMgr:GetMgr("RoleInfoMgr").ON_SERVER_LEVEL_UPDATE,function()
        if l_go and l_ed and l_pos and self:IsShowing() then
            self:ShowTip(l_go,l_ed,l_pos)
        end
    end)
    local l_func = function (sliderCom,num)
        local res = tonumber(num)
        if res == nil or sliderCom == nil then
            return
        end
        if res ~= sliderCom.Slider.value then
            sliderCom.Slider.value = res
        end
    end
    self:BindEvent(Data.PlayerInfoModel.BASEEXPDATA,Data.onDataChange,function (self,number)
        l_func(self.panel.sldBaseExp,number)
    end)
    self:BindEvent(Data.PlayerInfoModel.BASEEXPBLESSDATA,Data.onDataChange,function (self,number)
        l_func(self.panel.sldBaseExpBless,number)
    end)
    self:BindEvent(Data.PlayerInfoModel.JOBEXPDATA,Data.onDataChange,function (self,number)
        l_func(self.panel.sldJobExp,number)
    end)
    self:BindEvent(Data.PlayerInfoModel.JOBEXPBLESSDATA,Data.onDataChange,function (self,number)
        l_func(self.panel.sldJobExpBless,number)
    end)
end --func end

--获取配置表里的base等级上限
function ExpCtrl:GetBaseLevelUpperLimitByServerLevel(serverLv)
    local l_rows = TableUtil.GetServerLevelTable().GetTable()
    local l_rowCount = #l_rows
    for i=1,l_rowCount do
        local l_row = l_rows[i]
        if l_row.ServeLevel == serverLv then
            return l_row.BaseLevelUpperLimit
        end
    end
    return 0
end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end

return ExpCtrl