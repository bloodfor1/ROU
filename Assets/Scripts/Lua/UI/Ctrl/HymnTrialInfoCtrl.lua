--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HymnTrialInfoPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HymnTrialInfoCtrl = class("HymnTrialInfoCtrl", super)
--lua class define end

local l_hymnTipPullEffectPath = "Effects/Prefabs/Scene/Fx_Scene_Dungeon_JiaoHu"  --拉杆提示的场景特效路径
local l_hymnSceneEffectPath = "Effects/Prefabs/Scene/Fx_Scene_ShengGeShiLian_01"  --拉杆时场景特效路径
local l_rouletteModel = nil  --转盘模型 预加载用
local l_maxTurnNum = 3 --最大回合数
local l_monsterLastNum = 0 --剩余怪物数量  突然不做这个需求了 先留着

--lua functions
function HymnTrialInfoCtrl:ctor()

    super.ctor(self, CtrlNames.HymnTrialInfo, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function HymnTrialInfoCtrl:Init()

    self.panel = UI.HymnTrialInfoPanel.Bind(self)
    super.Init(self)

    --管理类获取
    self.hymnMgr = MgrMgr:GetMgr("HymnTrialMgr")
    self.dungeonMgr = MgrMgr:GetMgr("DungeonMgr")

    l_maxTurnNum = MGlobalConfig:GetInt("EnterRoundTimes")

    --特效申明
    self.hymnTipPullEffect = nil  --拉杆提示的场景特效
    self.hymnSceneEffect = nil    --拉杆时场景特效

    --拉杆提示MessageTable表ID获取
    local l_pullTipsID = MGlobalConfig:GetInt("SwitchTurnTablePromptID")
    self.msgRow_pullTips = TableUtil.GetMessageTable().GetRowByID(l_pullTipsID)
    --转盘结束后随机到的事件类型提示MessageTable表ID获取
    local l_promptTipsID = MGlobalConfig:GetInt("EventPromptID")
    self.msgRow_promptTips = TableUtil.GetMessageTable().GetRowByID(l_promptTipsID)

    self.hymnMgr.ReqCurTurnInfo()    --请求当前轮的信息

end --func end
--next--
function HymnTrialInfoCtrl:Uninit()

    --关闭拉杆提示场景特效与文字
    self:ClosePullTips()  

    --转盘模型销毁
    if l_rouletteModel ~=nil then
        self:DestroyUIModel(l_rouletteModel)
        l_rouletteModel = nil
    end

    --关闭场景特效
    if self.hymnSceneEffect ~= nil then
        self:DestroyUIEffect(self.hymnSceneEffect)
        self.hymnSceneEffect = nil
    end

    self.msgRow_pullTips = nil
    self.msgRow_promptTips = nil

    self.hymnMgr = nil
    self.dungeonMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HymnTrialInfoCtrl:OnActive()

end --func end
--next--
function HymnTrialInfoCtrl:OnDeActive()

end --func end




-- 显示
function HymnTrialInfoCtrl:OnShow()

    self.hymnMgr.ReqCurTurnInfo()  --请求当前轮的信息

end
--next--
function HymnTrialInfoCtrl:Update()


end --func end



--next--
function HymnTrialInfoCtrl:BindEvents()

    --更新剩余怪物数据
    self:BindEvent(self.dungeonMgr.EventDispatcher,self.dungeonMgr.ON_UPDATE_MONSTER_NUM,function(self, num, changeValue)
        if changeValue > 0 then return end  --只记录减少
        if l_monsterLastNum < 10 then  --剩余怪物少于10 肯定只剩最后一波 此时直接同步数量
            l_monsterLastNum = num
        else
            l_monsterLastNum = l_monsterLastNum + changeValue
            l_monsterLastNum = l_monsterLastNum < 0 and 0 or l_monsterLastNum
        end
        self.panel.MongserNumTxt.LabText = StringEx.Format("{0}/{1}", l_monsterLastNum, self.hymnMgr.curRouletteLogData.monsterNum)
    end)
    --回合开始
    self:BindEvent(self.hymnMgr.EventDispatcher,self.hymnMgr.ON_ROUND_START,function(self)
        self:ClosePullTips()  --关闭拉杆提示
        --展示场景特效
        local l_fxData = {}
        local l_pos = Vector3.New(58.5, 9.6, 66)  --目前写死的坐标
        l_fxData.position = l_pos
        self.hymnSceneEffect = self:CreateEffect(l_hymnSceneEffectPath, l_fxData)
    end)
    --战斗开始
    self:BindEvent(self.hymnMgr.EventDispatcher,self.hymnMgr.ON_FIGHT_START,function(self)
        --直接重新请求确认一次当前轮信息
        --防止第一轮转盘时关闭转盘 并开关别的UI 引起异常
        --防止进入时正好是别人转转盘的时候 转的时候服务器返回的上一轮信息
        self.hymnMgr.ReqCurTurnInfo()
        self:ClosePullTips()  --关闭拉杆提示
        --防止卡着这个PTC推送的时候 且是弱网的情况下 出现第0轮的现象
        if self.hymnMgr.curRouletteLogData.turnNum == 0 then
            return
        end
        --事件提示增加
        if self.msgRow_promptTips and self.dungeonMgr then
            self.dungeonMgr.ShowDungeonHints(self.msgRow_promptTips.ID, 
                self.msgRow_promptTips.Type[0], 
                self.hymnMgr.curRouletteLogData.prompt, false)
        end
        --展示回合开始动画
        self.panel.TxtRound.UObj:SetActiveEx(true)
        self.panel.TxtRound.LabText = StringEx.Format(Lang("HYMN_TRIAL_TURNS"), self.hymnMgr.curRouletteLogData.turnNum)
        MLuaClientHelper.PlayFxHelper(self.panel.TxtRound.UObj)
        --关闭场景特效
        if self.hymnSceneEffect ~= nil then
            self:DestroyUIEffect(self.hymnSceneEffect)
            self.hymnSceneEffect = nil
        end
    end)
    --回合结束
    self:BindEvent(self.hymnMgr.EventDispatcher,self.hymnMgr.ON_ROUND_OVER,function(self)
        --剩余怪物数量清零
        self.panel.MongserNumTxt.LabText = StringEx.Format("{0}/{1}", 0, self.hymnMgr.curRouletteLogData.monsterNum)
        --关闭信息面板
        if self.hymnMgr.curRouletteLogData.turnNum < l_maxTurnNum then  --轮次间战斗结束的休息时间显示提示
            self.panel.EventTxt.UObj:SetActiveEx(false)
            self.panel.TxtWait.UObj:SetActiveEx(true)
            --点击继续提示
            self:ShowPullTips(Lang("CLICK_SWITCH_AGAIN_TO_START_NEXT"))
        else
            --最后一轮结束关闭信息面板
            self.panel.InfoPanel.UObj:SetActiveEx(false)
        end
        --展示回合结束动画
        self.panel.TxtRound.UObj:SetActiveEx(true)
        self.panel.TxtRound.LabText = Lang("ROUND_OVER")
        MLuaClientHelper.PlayFxHelper(self.panel.TxtRound.UObj)
    end)
    --获取当前轮信息
    self:BindEvent(self.hymnMgr.EventDispatcher,self.hymnMgr.ON_GET_CUR_TURN_INFO,function(self, monsterLastNum)
        self:SetTurnInfo(monsterLastNum) --信息面板信息设置
        if self.hymnMgr.curRouletteLogData.turnNum == 0 then
            --起始 不显示信息面板 显示请拉杆提示
            self.panel.InfoPanel.UObj:SetActiveEx(false)
            --正在转转盘的话 不显示拉杆提示 此处是为了防止第一轮旋转时 有人关闭转盘界面并且开关UI导致显示
            if self.hymnMgr.isTurning then
                self:ClosePullTips()  --关闭拉杆提示
            else
                --点击开始提示
                self:ShowPullTips(Lang("CLICK_SWITCH_TO_START"))
            end
        elseif MPlayerInfo.PlayerDungeonsInfo.LeftMonster == 0 then
            --转盘加间歇 啥都不显示
            if self.hymnMgr.curRouletteLogData.turnNum < l_maxTurnNum then  --轮次间战斗结束的休息时间显示提示
                self.panel.EventTxt.UObj:SetActiveEx(false)
                self.panel.TxtWait.UObj:SetActiveEx(true)
                --点击继续提示
                self:ShowPullTips(Lang("CLICK_SWITCH_AGAIN_TO_START_NEXT"))
            else  --最后一轮结束关闭信息面板
                self.panel.InfoPanel.UObj:SetActiveEx(false)
            end
        else
            --战斗 显示战斗信息 不显示请拉杆提示
            self.panel.InfoPanel.UObj:SetActiveEx(true)
            --关闭转盘界面
            UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialRoulette)
            --关闭场景特效
            if self.hymnSceneEffect ~= nil then
                self:DestroyUIEffect(self.hymnSceneEffect)
                self.hymnSceneEffect = nil
            end
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--设置当前轮信息
function HymnTrialInfoCtrl:SetTurnInfo(monsterLastNum)
    l_monsterLastNum = monsterLastNum or 0
    self.panel.TurnTxt.LabText = self.hymnMgr.curRouletteLogData.turnNum.."/"..l_maxTurnNum
    self.panel.MongserNumTxt.LabText = StringEx.Format("{0}/{1}", l_monsterLastNum, self.hymnMgr.curRouletteLogData.monsterNum)
    self.panel.EventTxt.LabText = self.hymnMgr.curRouletteLogData.eventText
    self.panel.EventTxt.UObj:SetActiveEx(true)
    self.panel.TxtWait.UObj:SetActiveEx(false)
end

--展示拉杆提示
--tipsText  提示的文本
function HymnTrialInfoCtrl:ShowPullTips(tipsText)
    --文字提示
    if self.msgRow_pullTips and self.dungeonMgr then
        self.dungeonMgr.ShowDungeonHints(self.msgRow_pullTips.ID, 
            self.msgRow_pullTips.Type[0], tipsText, false)
    end
    --展示拉杆提示特效
    self:ShowTipPullEffect()
end

--关闭拉杆提示
function HymnTrialInfoCtrl:ClosePullTips()
    MgrMgr:GetMgr("TipsMgr").CloseDungeonHintsStory()  --关闭拉杆提示
    self:CloseTipPullEffect()  --关闭拉杆提示场景特效
end

--展示拉杆提示特效
function HymnTrialInfoCtrl:ShowTipPullEffect()
    self:CloseTipPullEffect()
    local l_fxData = {}
    l_fxData.position = Vector3.New(58.6, 12.5, 43.35)  --目前写死的坐标
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    self.hymnTipPullEffect = self:CreateEffect(l_hymnTipPullEffectPath, l_fxData)
end

--关闭拉杆提示特效
function HymnTrialInfoCtrl:CloseTipPullEffect()
    if self.hymnTipPullEffect ~= nil then
        self:DestroyUIEffect(self.hymnTipPullEffect)
        self.hymnTipPullEffect = nil
    end
end
--lua custom scripts end
