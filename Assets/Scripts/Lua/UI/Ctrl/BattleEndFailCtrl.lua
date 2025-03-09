--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleEndFailPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class BattleEndFailCtrl : UIBaseCtrl
BattleEndFailCtrl = class("BattleEndFailCtrl", super)
--lua class define end

--lua functions
function BattleEndFailCtrl:ctor()
    super.ctor(self, CtrlNames.BattleEndFail, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function BattleEndFailCtrl:Init()
    self.panel = UI.BattleEndFailPanel.Bind(self)
    super.Init(self)
    self._onExitFunc = nil
    self._onExitFuncSelf = nil
    ---@type ItemData[]
    self._itemDataList = nil
    self._playerWin = false
    self._passTime = 0
    self._countDown = Common.CommonCountDownUtil.new()
    self._canSkip = false
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function BattleEndFailCtrl:Uninit()
    self:_destroyEffect()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function BattleEndFailCtrl:OnActive()
    ---@type CountDownUtilParam
    local param = {
        totalTime = 5,
        clearCallback = self._tryInvokeOnExit,
        clearCallbackSelf = self,
    }

    self._countDown:Init(param)
    self._countDown:Start()
    self:_showPanel()
    if self._canSkip then
        self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
            self:_tryInvokeOnExit()
        end)
    else
        self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
            -- do nothing
        end)
    end
end --func end
--next--
function BattleEndFailCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function BattleEndFailCtrl:Update()
    self._countDown:OnUpdate()
end --func end
--next--
function BattleEndFailCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

function BattleEndFailCtrl:_initConfig()
    self._rewardItemTemplatePoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.AwardContent.transform,
    }
end

function BattleEndFailCtrl:_initWidgets()
    self._itemTemplatePool = self:NewTemplatePool(self._rewardItemTemplatePoolConfig)
    self.panel.VictoryPanel:SetActiveEx(true)
    self.panel.AssistTxt:SetActiveEx(false)
    self.panel.TimeLab:SetActiveEx(true)
    self.panel.Panel_TimeTip:SetActiveEx(true)
end

function BattleEndFailCtrl:_showPanel()
    self:_parseUIParam()
    MAudioMgr:Play("event:/UI/Victory")
    self.panel.WidgetFail:SetActiveEx(not self._playerWin)
    self.panel.WidgetWin:SetActiveEx(self._playerWin)
    self.panel.VictoryPanel.FxAnim:PlayAll()
    self.panel.fx1.FxAnim:PlayAll()
    self.panel.fx2.FxAnim:PlayAll()
    self:_showEffects()
    self:_showAwardList(self._itemDataList)
    self.panel.TimeLab.LabText = self:_getTimeStr(self._passTime)
end

--- 获取结算界面显示时间
---@return string
function BattleEndFailCtrl:_getTimeStr(time)
    local min, sec = math.modf(time / 60)
    sec = time - (min * 60)
    local ret = StringEx.Format("{0}'{1}", min, sec)
    return ret
end

function BattleEndFailCtrl:_showEffects()
    if self.fx1 ~= nil then
        self:DestroyUIEffect(self.fx1)
        self.fx1 = nil
    end

    local l_fxData1 = {}
    l_fxData1.rawImage = self.panel.Effect.RawImg
    self.fx1 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_JieSuanBoLi_02", l_fxData1)

    if self.fx2 ~= nil then
        self:DestroyUIEffect(self.fx2)
        self.fx2 = nil
    end

    local l_fxData2 = {}
    l_fxData2.rawImage = self.panel.Effect2.RawImg
    self.fx2 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_JieSuanBoLi_03", l_fxData2)
end

--- 显示获取奖励的列表
---@param itemDataList ItemData[]
function BattleEndFailCtrl:_showAwardList(itemDataList)
    if nil == itemDataList then
        logError("[BattleEndFail] invalid data")
        return
    end

    local paramList = {}
    for i = 1, #itemDataList do
        local singleItem = itemDataList[i]
        ---@type ItemTemplateParam
        local singleParam = { PropInfo = singleItem }
        table.insert(paramList, singleParam)
    end

    self._itemTemplatePool:ShowTemplates({ Datas = paramList })
end

--- 解析参数，目前这个界面的参数比较有限
function BattleEndFailCtrl:_parseUIParam()
    ---@type ResultPanelData
    local data = self.uiPanelData
    self._onExitFunc = data.OnClick
    self._onExitFuncSelf = data.OnClickSelf
    self._itemDataList = data.ItemDataList
    self._playerWin = data.Win
    self._passTime = data.PassTime
    self._canSkip = data.CanClickSkip
end

function BattleEndFailCtrl:_tryInvokeOnExit()
    UIMgr:DeActiveUI(self.name)
    if nil == self._onExitFunc then
        return
    end

    self._onExitFunc(self._onExitFuncSelf)
end

function BattleEndFailCtrl:_destroyEffect()
    if nil ~= self.fx1 then
        self:DestroyUIEffect(self.fx1)
        self.fx1 = nil
    end

    if nil ~= self.fx2 then
        self:DestroyUIEffect(self.fx2)
        self.fx2 = nil
    end
end

--lua custom scripts end
return BattleEndFailCtrl