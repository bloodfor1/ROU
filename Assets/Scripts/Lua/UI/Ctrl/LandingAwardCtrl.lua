--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LandingAwardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local string_format = StringEx.Format

local l_using_pool = true

local l_special_day = {
    [2] = true,
    [5] = true,
    [7] = true,
}

--lua class define
local super = UI.UIBaseCtrl
LandingAwardCtrl = class("LandingAwardCtrl", super)
--lua class define end

--lua functions
function LandingAwardCtrl:ctor()

    super.ctor(self, CtrlNames.LandingAward, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true

end --func end
--next--
function LandingAwardCtrl:Init()

    self.panel = UI.LandingAwardPanel.Bind(self)
    super.Init(self)

    self.panel.BtnClose:AddClick(function()
        self:CloseUI()
    end)
    --领奖按钮是否准备就绪 应对弱网
    self.getAwardReady = true

    --特效列表申明
    self.effect = {}

    MgrMgr:GetMgr("LandingAwardMgr").RequestGetLandingAwardInfo()
    self.roundSpineTimer = nil
end --func end
--next--
function LandingAwardCtrl:Uninit()

    --特效清理
    if self.effect == nil then
        return
    end
    for k, v in pairs(self.effect) do
        self:DestroyUIEffect(v)
        self.effect[k] = nil
    end

    if self.roundSpineTimer then
        self:StopUITimer(self.roundSpineTimer)
        self.roundSpineTimer = nil
    end

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LandingAwardCtrl:OnActive()
    self:SetupSpineTimer()
    self:CustomRefresh()
end --func end
--next--
function LandingAwardCtrl:OnDeActive()

    self.getAwardReady = true

end --func end
--next--
function LandingAwardCtrl:Update()


end --func end

--next--
function LandingAwardCtrl:BindEvents()
    --dont override this function
    self:BindEvent(MgrMgr:GetMgr("LandingAwardMgr").EventDispatcher,MgrMgr:GetMgr("LandingAwardMgr").ON_LANDING_AWARD_INFO_UPDATE, function ()
        self:CustomRefresh()
        self.getAwardReady = true
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function LandingAwardCtrl:CloseUI()

    UIMgr:DeActiveUI(CtrlNames.LandingAward)
end

function LandingAwardCtrl:ForceCloseUI(error)

    logError(error)

    self:CloseUI()
end

function LandingAwardCtrl:CustomRefresh()

    local l_configs = MgrMgr:GetMgr("LandingAwardMgr").GetLandingAwardConfig()
    if not l_configs then
        return self:ForceCloseUI("七日奖励无数据")
    end

    local l_can_take_day = MgrMgr:GetMgr("LandingAwardMgr").GetCanTakeAwardDay()
    local l_max_award_count = MgrMgr:GetMgr("LandingAwardMgr").GetTotalAwardCount()
    if l_can_take_day < 0 then
        return self:ForceCloseUI(string_format("七日奖励当前已领取索引不合法 当前:{0}", l_can_take_day))
    end

    if l_can_take_day > l_max_award_count then
        LogWarning(string_format("七日奖励当前索引超越总共天数，这里强制修正 当前:{0} 总数:{1}", l_can_take_day, l_max_award_count))
        l_can_take_day = l_max_award_count
    end
    -- logError("l_can_take_day:" .. l_can_take_day .. " l_max_award_count:" .. l_max_award_count)
    local l_dayDatas = {}
    local l_day = 1
    for l_day, v in ipairs(l_configs) do
        if l_day > l_max_award_count then
            break
        end
        local l_available = MgrMgr:GetMgr("LandingAwardMgr").IsLandingAwardAvailable(l_day)
        local l_dayData = {
            day = l_day,
            canTake = (l_can_take_day >= l_day) and l_available,
            hasTake = (l_can_take_day >= l_day) and (not l_available),
        }
        table.insert(l_dayDatas, l_dayData)
    end
    --数据展示
    self:ShowDayAwardDatas(l_dayDatas)
end

--展示每日奖励
--dayAwardDatas  每日奖励数据
function LandingAwardCtrl:ShowDayAwardDatas(dayAwardDatas)
    for i = 1, #dayAwardDatas do
        if i > 8 then
            return
        end  --只有8个 超过不管
        local l_data = dayAwardDatas[i]
        --物品的配置数据和Item表数据获取
        local l_dayConfig = SevenDayAward.GetAwardConfigByDay(l_data.day)
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_dayConfig.itemID)
        local l_effectStr = ""
        if l_itemData then
            --背景样式展示控制
            if l_dayConfig.BgType == DataMgr:GetData("LandingAwardData").BG_TYPE.WHITE then
                self.panel.LandAwardSelectBtn[i]:SetSprite("Welfare", "UI_Welfare_Card-01.png")
                l_effectStr = "Effects/Prefabs/Creature/Ui/Fx_Ui_TiShi_01"
            else
                self.panel.LandAwardSelectBtn[i]:SetSprite("Welfare", "UI_Welfare_Card-02.png")
                l_effectStr = "Effects/Prefabs/Creature/Ui/Fx_Ui_258DengLuJiangLi"
            end
            --物品图标
            self.panel.ItemIcon[i]:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon, true)
            --物品名称
            if string.len(l_dayConfig.itemDesc) > 0 then
                self.panel.ItemName[i].UObj:SetActiveEx(true)
                self.panel.ItemName[i].LabText = Lang(l_dayConfig.itemDesc)
            else
                self.panel.ItemName[i].UObj:SetActiveEx(false)
            end
            --数量
            self.panel.CountNum[i].UObj:SetActiveEx(l_dayConfig.itemCount > 1)
            self.panel.CountNum[i].LabText = tostring(l_dayConfig.itemCount)
            --是否已领取标志
            self.panel.IsGet[i].UObj:SetActiveEx(l_data.hasTake)

            --可领取的特效控制
            if l_data.canTake then
                --可领取 且 原本无特效才刷新特效展示
                if not self.effect[i] then
                    self.panel.EffectView[i].UObj:SetActiveEx(false)
                    local l_fxData = {}
                    l_fxData.rawImage = self.panel.EffectView[i].RawImg
                    l_fxData.position = Vector3.New(0, 0, 0)
                    if l_dayConfig.BgType == DataMgr:GetData("LandingAwardData").BG_TYPE.WHITE then
                        l_fxData.scaleFac = Vector3.New(1.75, 1.75, 1.75)
                    else
                        l_fxData.scaleFac = Vector3.New(1.25, 1.25, 1.25)
                    end
                    l_fxData.speed = 1.5
                    l_fxData.loadedCallback = function(a)
                        self.panel.EffectView[i].UObj:SetActiveEx(true)
                    end
                    l_fxData.destroyHandler = function()
                        self.effect[i] = nil
                    end
                    self.effect[i] = self:CreateUIEffect(l_effectStr, l_fxData)
                end
            else
                self.panel.EffectView[i].UObj:SetActiveEx(false)
                if self.effect[i] then
                    self:DestroyUIEffect(self.effect[i])
                    self.effect[i] = nil
                end
            end


            --点击事件
            self.panel.BtnGetAward[i]:AddClick(function()
                --已领取状态点击无反应 可领取点击领取 不可领取点击提示领取时间
                if l_data.hasTake then
                    return
                elseif l_data.canTake then
                    if self.getAwardReady then
                        --按钮就绪时才可点击 弱网策略
                        MgrMgr:GetMgr("LandingAwardMgr").RequestGetLandingAward(l_data.day)
                        self.getAwardReady = false
                    end
                else
                    --提示几日可领取
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LANDING_AWARD_FORMAT", l_data.day))
                    --展示物品详细数据
                    local isItemBind = l_dayConfig.itemBind and l_dayConfig.itemBind == 1
                    local itemData = Data.BagModel:CreateItemWithTid(l_dayConfig.itemID)
                    itemData.IsBind = isItemBind
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self.panel.LandAwardSelectBtn[i].Transform)
                end
            end)
        end
    end
end

--喵喵随机对话框
function LandingAwardCtrl:SetupSpineTimer()

    if self.roundSpineTimer then
        self:StopUITimer(self.roundSpineTimer)
        self.roundSpineTimer = nil
    end
    local l_spine = self.panel.SkeletonGraphic.transform:GetComponent("SkeletonGraphic")

    local l_curIsIdle = true
    l_spine.startingAnimation = "IDLE"
    local l_startIntervalTime = Time.realtimeSinceStartup
    local l_startDurationTime = Time.realtimeSinceStartup
    local l_NumMax = MGlobalConfig:GetInt("LandingAwardDialogueNumMax")
    local l_Duration = MGlobalConfig:GetInt("LandingAwardDialogueDuration")
    local l_TimeInterval = MGlobalConfig:GetInt("LandingAwardDialogueTimeInterval")
    self.panel.Container:SetActiveEx(false);
    self.roundSpineTimer = self:NewUITimer(function()

        if l_curIsIdle and (Time.realtimeSinceStartup - l_startIntervalTime) >= l_TimeInterval then
            l_startIntervalTime = Time.realtimeSinceStartup
            l_startDurationTime = Time.realtimeSinceStartup
            local temNum = math.random(l_NumMax);
            self.panel.Container:SetActiveEx(true);
            self.panel.DiaText.LabText = Common.Utils.Lang("LandAward_Text_" .. temNum);
        end

        if l_curIsIdle and l_startDurationTime ~= -1 and (Time.realtimeSinceStartup - l_startDurationTime) >= l_Duration then
            l_startDurationTime = -1
            self.panel.Container:SetActiveEx(false);
        end


    end, 0.033, -1, true)
    self.roundSpineTimer:Start()
end

--lua custom scripts end
return LandingAwardCtrl