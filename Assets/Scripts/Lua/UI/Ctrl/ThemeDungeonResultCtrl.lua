--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ThemeDungeonResultPanel"
require "UI/Template/ThumbTemplate"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ThemeDungeonResultCtrl = class("ThemeDungeonResultCtrl", super)
--lua class define end

--lua functions
function ThemeDungeonResultCtrl:ctor()

    super.ctor(self, CtrlNames.ThemeDungeonResult, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function ThemeDungeonResultCtrl:Init()

    self.panel = UI.ThemeDungeonResultPanel.Bind(self)
    super.Init(self)

    --RT背景的设置
    --MoonClient.MPostEffectMgr.GrabRTForBgInstance:SetCapatureScreenForBg(self.panel.RTBg.RawImg)
    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.panel.GoBtn.enabled = false
    self.panel.GoBtn:AddClick(function()
        if l_timer ~= nil then
            self:StopUITimer(l_timer)
            l_timer = nil
            l_index = 0
        end
        self:OnResultBtnClick()
    end)

end --func end
--next--
function ThemeDungeonResultCtrl:Uninit()

    --RT背景的清理
    --MoonClient.MPostEffectMgr.GrabRTForBgInstance:StopCapatureScreenForBg()
    super.Uninit(self)
    self.panel = nil
    self.ThumbTemplatePool = nil

end --func end
--next--
function ThemeDungeonResultCtrl:OnActive()

    self:OnInit()
    self.panel.AssistTxt:SetActiveEx(DataMgr:GetData("ThemeDungeonData").IsAssistReward)
    DataMgr:GetData("ThemeDungeonData").SetIsAssistReward(false)

end --func end
--next--
function ThemeDungeonResultCtrl:OnDeActive()
    DataMgr:GetData("ThemeDungeonData").RefreshAllDungeonRewardItem()
    self:OnUnInit()

end --func end
--next--
function ThemeDungeonResultCtrl:Update()

end --func end



--next--
function ThemeDungeonResultCtrl:BindEvents()
    --收到点赞消息
    self:BindEvent(MgrMgr:GetMgr("DungeonMgr").EventDispatcher,MgrMgr:GetMgr("DungeonMgr").UPDATE_ENCOURAGE_NUM, function(self, roleID)
        if DataMgr:GetData("ThemeDungeonData").ThumbQueue[roleID] then
            DataMgr:GetData("ThemeDungeonData").ThumbQueue[roleID].index = DataMgr:GetData("ThemeDungeonData").ThumbQueue[roleID].index + 1
            for i = 1, #self.ThumbTemplatePool.Items do
                if self.ThumbTemplatePool.Items[i].data.roleId == roleID then
                    self.ThumbTemplatePool.Items[i]:OnThumbEvent(roleID)
                    break
                end
            end
        end
        
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
local l_time = tonumber(MGlobalConfig:GetFloat("DungeonResultExitTime")) or 0
l_time = l_time > 0 and l_time or 10

local l_timer = nil
local l_index = 0
local l_data = DataMgr:GetData("ThemeDungeonData")

function ThemeDungeonResultCtrl:OnInit()
    l_index = 0
    self.playerHeadIndex = 0
    self.ThumbTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ThumbTemplate,
        TemplatePrefab = self.panel.TeamPrefab.LuaUIGroup.gameObject,
        TemplateParent = self.panel.Achievement.transform
    })
    self:InitVictoryPanel()
end

--结算界面显示初始化
function ThemeDungeonResultCtrl:InitVictoryPanel()
    self.hasShowExtraRewards = false
    self.panel.VictoryPanel.gameObject:SetActiveEx(true)
    self.panel.ThumbPanel.gameObject:SetActiveEx(false)
    self.panel.Theme_Desc.gameObject:SetActiveEx(false)

    MAudioMgr:Play("event:/UI/Victory")
    if l_timer ~= nil then
        self:StopUITimer(l_timer)
        l_timer = nil
        l_index = 0
    end
    self.panel.TipsLab.LabText = ""
    ---时间
    self.panel.TimeLab.LabText = DataMgr:GetData("ThemeDungeonData").DungeonCostTimeStr

    self:ShowAwardList()
    self.panel.VictoryPanel.FxAnim:PlayAll()
    self.panel.fx1.FxAnim:PlayAll()
    self.panel.fx2.FxAnim:PlayAll()
    self.panel.GoBtn.FxAnim:PlayAll()
    self.panel.GoBtn.enabled = true
    local l_effectTime = 3

    local l_extraRewardItems = l_data.GetExtraRewardItems()
    --有额外奖励时正常奖励延迟展示
    if  #l_extraRewardItems>0 then
        l_effectTime = l_effectTime + 3
    end

    self.effectTimer = self:NewUITimer(function()
        l_effectTime = l_effectTime - 1
        if l_effectTime <= 0 then
            self:StopUITimer(self.effectTimer)
            self.effectTimer = nil

            self:showExtraRewardList()
        end
    end, 1, -1, true)
    self.effectTimer:Start()

    self:ShowEffect()
end

function ThemeDungeonResultCtrl:ShowEndTimer()
    if MgrMgr:GetMgr("RollMgr").CanRoll then
        self.panel.TipsLab.LabText = StringEx.Format(Common.Utils.Lang("DUNGEONS_RESULT_TIME"), tostring(l_time - l_index))
        l_timer = self:NewUITimer(function()
            l_index = l_index + 1
            self.panel.TipsLab.LabText = StringEx.Format(Common.Utils.Lang("DUNGEONS_RESULT_TIME"), tostring(l_time - l_index))
            if l_index >= l_time then
                self:OnResultBtnClick()
            end
        end, 1, l_time, true)
        l_timer:Start()
    end

end

function ThemeDungeonResultCtrl:ShowEffect()
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

    if self.fx3 ~= nil then
        self:DestroyUIEffect(self.fx3)
        self.fx3 = nil
    end
    local l_fxData3 = {}
    l_fxData3.rawImage = self.panel.Effect3.RawImg
    self.fx3 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_JieSuanBoLi_01", l_fxData3)
end

function ThemeDungeonResultCtrl:OnResultBtnClick()
    if not self.hasShowExtraRewards then
        self:showExtraRewardList()
        return
    end
    local l_data = DataMgr:GetData("ThemeDungeonData")
    if not l_data.SinglePlayerDungeon and table.ro_size(l_data.DungeonResultInfo) > 1 then
        self:InitThumbPanel()
    else
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonResult)
        MgrMgr:GetMgr("RollMgr").PlayRollOrLuckyDraw(
                MgrMgr:GetMgr("RollMgr").g_RollContext.RollContextDungeonsResult, function()
                    local l_pastTime = tonumber(tostring(MServerTimeMgr.UtcSeconds)) - MgrMgr:GetMgr("DungeonMgr").DungeonResultTime
                    local l_remainTime = MgrMgr:GetMgr("DungeonMgr").DungeonRemainTime - l_pastTime
                    if l_remainTime > 0 then
                        local l_data =
                        {
                            startTime = MServerTimeMgr.UtcSeconds,
                            remainTime = l_remainTime
                        }
                        UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
                    end
                end, false)
    end
end
function ThemeDungeonResultCtrl:OnUnInit()

    if l_timer ~= nil then
        self:StopUITimer(l_timer)
        l_timer = nil
        l_index = 0
    end
    if self.effectTimer ~= nil then
        self:StopUITimer(self.effectTimer)
        self.effectTimer = nil
    end
    if self.fx1 ~= nil then
        self:DestroyUIEffect(self.fx1)
        self.fx1 = nil
    end
    if self.fx2 ~= nil then
        self:DestroyUIEffect(self.fx2)
        self.fx2 = nil
    end
    if self.fx3 ~= nil then
        self:DestroyUIEffect(self.fx3)
        self.fx3 = nil
    end
    --奖励列表池释放
    self.awardTemplatePool = nil
end

--组队状态显示队员结算
function ThemeDungeonResultCtrl:InitThumbPanel()
    self.lastTime = 0
    if l_timer ~= nil then
        self:StopUITimer(l_timer)
        l_timer = nil
        l_index = 0
    end
    if self.effectTimer ~= nil then
        self:StopUITimer(self.effectTimer)
        self.effectTimer = nil
    end
    --手动退出
    self.panel.ComeBackBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonResult)
        MgrMgr:GetMgr("RollMgr").PlayRollOrLuckyDraw(
                MgrMgr:GetMgr("RollMgr").g_RollContext.RollContextDungeonsResult, function()
                    local l_pastTime = tonumber(tostring(MServerTimeMgr.UtcSeconds)) - MgrMgr:GetMgr("DungeonMgr").DungeonResultTime
                    local l_remainTime = MgrMgr:GetMgr("DungeonMgr").DungeonRemainTime - l_pastTime
                    if l_remainTime > 0 then
                        local l_data =
                        {
                            startTime = MServerTimeMgr.UtcSeconds,
                            remainTime = l_remainTime
                        }
                        UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
                    end
                end, true)
    end)
    self.panel.VictoryPanel.gameObject:SetActiveEx(false)
    self.panel.ThumbPanel.gameObject:SetActiveEx(true)
    self.panel.Theme_Desc.gameObject:SetActiveEx(true)

    self.panel.ComeBackDes.LabText = Common.Utils.Lang("DUNGEONS_RESULT_COMEBACK")
    local resultDatas = {}
    --根据队友人数实例化组件
    for k, v in pairs(l_data.DungeonResultInfo) do
        local data = {}
        data.roleId = k
        data.isTaken = v.isTaken
        data.isHit = v.isHit
        data.isDamage = v.isDamage
        data.isHeal = v.isHeal
        data.professionID = v.professionID
        table.insert(resultDatas, data)
    end
    self.ThumbTemplatePool:ShowTemplates({ Datas = resultDatas })
end

--获取的奖励展示
function ThemeDungeonResultCtrl:ShowAwardList()
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        return
    end
    --奖励数据表制作
    local l_reward = l_data.GetAllRewardItems()
    --奖励列表项的池创建
    self.awardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.AwardContent.transform
    })

    --奖励显示
    self.awardTemplatePool:ShowTemplates({ Datas = l_reward })
    l_data.DungeonRewardItem = {}
end

function ThemeDungeonResultCtrl:showExtraRewardList()
    self.hasShowExtraRewards = true
    local l_extraRewardItems = l_data.GetExtraRewardItems()
    --没有额外奖励直接进入下一步环节
    if l_extraRewardItems==nil or #l_extraRewardItems<1 then
        self:ShowEndTimer()
        return
    end

    self.panel.Panel_ExtraReward:SetActiveEx(true)
    self.panel.Panel_ExtraReward:PlayDynamicEffect(-1,{
        loadedCallback = function()
            self.panel.Txt_ExtraRewardTip:SetActiveEx(true)
            self.panel.Panel_TimeTip:SetActiveEx(false)
            if self.awardTemplatePool==nil then
                return
            end
            self.awardTemplatePool:ShowTemplates({ Datas = l_extraRewardItems })
        end
    })

    self:ShowEndTimer()
end

return ThemeDungeonResultCtrl
--lua custom scripts end
