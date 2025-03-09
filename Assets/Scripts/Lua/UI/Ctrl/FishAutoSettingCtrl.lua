--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FishAutoSettingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FishAutoSettingCtrl = class("FishAutoSettingCtrl", super)
--lua class define end

local l_costNum = 1  --消耗物品数量
local l_isAutoContuine = false  --是否自动继续
local l_costItemId = 3100006  --自动钓鱼消耗物品Id
local l_buffRemainTime = 0  --自动钓鱼BUFF剩余时间
local l_canAutoFishTime = 0  --预计可钓鱼时间

--lua functions
function FishAutoSettingCtrl:ctor()

    super.ctor(self, CtrlNames.FishAutoSetting, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function FishAutoSettingCtrl:Init()

    self.panel = UI.FishAutoSettingPanel.Bind(self)
    super.Init(self)

    --初始化数据
    l_costItemId = MGlobalConfig:GetInt("AutoFishingItemID")
    l_costNum = 1
    l_canAutoFishTime = 0
    if MEntityMgr.PlayerEntity.IsAutoFishing then
        l_costNum = 0
    end
    l_isAutoContuine = false
    self.panel.TogAutoContuine.Tog.isOn = l_isAutoContuine

    self.timer = nil  --自动钓鱼BUFF计时器

    --物品消耗展示
    self.costItem = self:NewTemplate("ItemTemplate", { IsActive = true, TemplateParent = self.panel.CostItem.transform })
    self.costItem:SetData({
        ID = l_costItemId,
        IsShowCount = false,
        IsShowRequire = true,
        RequireCount = l_costNum,
    })

    --防弱网初始化时关闭预设上的文字显示
    self.panel.TimeCanFishTip.UObj:SetActiveEx(false)

    --自动钓鱼剩余Buff时间获取
    self:GetAutoFishBuffTime()
    --时间选择组件设置
    self:TimeSelectSet()
    --按钮点击事件
    self:ButtonClickEventInit()
end --func end
--next--
function FishAutoSettingCtrl:Uninit()

    self.costItem = nil

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    l_costNum = 1
    l_isAutoContuine = true
    l_canAutoFishTime = 0

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FishAutoSettingCtrl:OnActive()

    MgrMgr:GetMgr("FishMgr").ReqGetAutoFishInfo()

end --func end
--next--
function FishAutoSettingCtrl:OnDeActive()


end --func end
--next--
function FishAutoSettingCtrl:Update()

end --func end

--next--
function FishAutoSettingCtrl:BindEvents()
    --拉杆提示展示事件绑定
    self:BindEvent(MgrMgr:GetMgr("FishMgr").EventDispatcher, MgrMgr:GetMgr("FishMgr").ON_GET_AUTO_FISHING_INFO, function(self, noBaitfishTime, isAutoContuine)
        --是否自动续时间设置
        l_isAutoContuine = isAutoContuine
        self.panel.TogAutoContuine.Tog.isOn = l_isAutoContuine
        --可钓鱼时间获取
        self:GetCanFishTime(noBaitfishTime)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--按钮点击事件设置
function FishAutoSettingCtrl:ButtonClickEventInit()
    --确认按钮点击
    self.panel.BtnSure:AddClick(function()
        --判断消耗材料是否足够
        if Data.BagModel:GetBagItemCountByTid(l_costItemId) < l_costNum then
            local l_costItemInfo = TableUtil.GetItemTable().GetRowByItemID(l_costItemId)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_costItemId, nil, nil, nil, true)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("MATERIAL_NOT_ENOUGH"), l_costItemInfo.ItemName))
            return
        end
        --如果设置自动钓鱼时间 比 可钓鱼时间长 展示二次确认
        local l_afterAddBuffTime = math.ceil(MEntityMgr.PlayerEntity.AutoFishLeftTime) + l_costNum * MGlobalConfig:GetFloat("AutoFishingTimeOptionStep") * 60
        if l_afterAddBuffTime > l_canAutoFishTime then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("ENSURE_ENTER_AUTO_FISH", self:GetTimeStr(l_afterAddBuffTime), self:GetTimeStr(l_canAutoFishTime)),
                    function()
                        MgrMgr:GetMgr("FishMgr").ReqFish(FishingType.FISHING_TYPE_AUTO_FISH, l_costNum, l_isAutoContuine)
                        UIMgr:DeActiveUI(UI.CtrlNames.FishAutoSetting)
                    end)
            return
        end
        MgrMgr:GetMgr("FishMgr").ReqFish(FishingType.FISHING_TYPE_AUTO_FISH, l_costNum, l_isAutoContuine)
        UIMgr:DeActiveUI(UI.CtrlNames.FishAutoSetting)
    end)
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FishAutoSetting)
    end)
    --勾选按钮点击
    self.panel.BtnTog:AddClick(function()
        l_isAutoContuine = not l_isAutoContuine
        self.panel.TogAutoContuine.Tog.isOn = l_isAutoContuine
    end)
end

--获取可钓鱼时间
--noBaitfishTime   剩余无鱼饵可钓鱼次数
function FishAutoSettingCtrl:GetCanFishTime(noBaitfishTime)
    local l_baitNum = Data.BagModel:GetBagItemCountByTid(MGlobalConfig:GetInt("FishingBaitItemID"))  --获取剩余鱼饵数量
    local l_maxOnceFishTime = MGlobalConfig:GetFloat("AutoFishingCycleTimeMax")
    local l_minOnceFishTime = MGlobalConfig:GetFloat("AutoFishingCycleTimeMin")
    l_canAutoFishTime = (l_baitNum + noBaitfishTime) * (l_maxOnceFishTime + l_minOnceFishTime) / 2
    self.panel.TimeCanFishTip.LabText = Lang("AUTO_FISHING_ESTIMATE_TIME", self:GetTimeStr(l_canAutoFishTime))
    self.panel.TimeCanFishTip.UObj:SetActiveEx(true)
end

--自动钓鱼剩余Buff时间获取
function FishAutoSettingCtrl:GetAutoFishBuffTime()
    l_buffRemainTime = math.ceil(MEntityMgr.PlayerEntity.AutoFishLeftTime)
    --如果没有时间则不显示整行内容
    if l_buffRemainTime == 0 then
        self.panel.TimeRemainText.UObj:SetActiveEx(false)
        self.panel.TimeRemainTip.UObj:SetActiveEx(false)
        return
    end
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    --界面初始化值设置
    self.panel.TimeRemainText.UObj:SetActiveEx(true)
    self.panel.TimeRemainTip.UObj:SetActiveEx(true)
    self.panel.TimeRemainText.LabText = self:GetTimeStr(l_buffRemainTime)
    if l_buffRemainTime >= 0 then
        --计时器设置
        self.timer = self:NewUITimer(function()
            l_buffRemainTime = l_buffRemainTime - 1
            if l_buffRemainTime <= 0 and self.timer then
                if MgrMgr:GetMgr("FishMgr").g_isAutoContuine then
                    --如果自动加时间 则追加倒计时
                    l_buffRemainTime = tonumber(TableUtil.GetGlobalTable().GetRowByName("AutoFishingTimeOptionStep").Value) * 60
                else
                    --如果不自动加时间 则关闭计时器和显示
                    l_buffRemainTime = 0
                    self:StopUITimer(self.timer)
                    self.timer = nil
                    self.panel.TimeRemainText.UObj:SetActiveEx(false)
                    self.panel.TimeRemainTip.UObj:SetActiveEx(false)
                end
            end
            self.panel.TimeRemainText.LabText = self:GetTimeStr(l_buffRemainTime)
        end, 1, -1, true)
        self.timer:Start()
    end
end

--时间选择组件设置
function FishAutoSettingCtrl:TimeSelectSet()
    local l_timeSelectMax = MGlobalConfig:GetFloat("AutoFishingTimeOptionMax") / 10
    local l_timeSelectMin = MGlobalConfig:GetFloat("AutoFishingTimeOptionMin1") / 10
    if MEntityMgr.PlayerEntity.IsAutoFishing then
        l_timeSelectMin = MGlobalConfig:GetFloat("AutoFishingTimeOptionMin2") / 10
    end
    --下拉列表数据设置
    local l_times = {}
    for i = l_timeSelectMin, l_timeSelectMax do
        local l_str = Lang("EXPEL_MONSTER_LEFT_TIME", tostring(i * 10))
        table.insert(l_times, l_str)
    end
    --下拉列表数据绑定
    self.panel.TimeSelect.DropDown:ClearOptions()
    self.panel.TimeSelect:SetDropdownOptions(l_times)
    --下拉列表选择事件
    self.panel.TimeSelect.DropDown.onValueChanged:AddListener(function(index)
        l_costNum = index + 1
        if MEntityMgr.PlayerEntity.IsAutoFishing then
            l_costNum = index
        end
        self.costItem:SetData({
            ID = l_costItemId,
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = l_costNum,
        })
    end)
end

--获取时间的字符串类型
function FishAutoSettingCtrl:GetTimeStr(time)
    local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(tonumber(time))
    l_hour = l_day * 24 + l_hour
    if l_hour == 0 then
        if l_minuite == 0 then
            return Lang("TIMESHOW_S", l_second)
        end
        return Lang("TIMESHOW_M_S", l_minuite, l_second)
    end
    return Lang("TIMESHOW_H_M_S", l_hour, l_minuite, l_second)
end
--lua custom scripts end
