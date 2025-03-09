--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionRewardPanel"
require "UI/Template/LifeProfessionRewardPrefab"
local ClassID = MgrMgr:GetMgr("LifeProfessionMgr").ClassID
local Mgr = MgrMgr:GetMgr("LifeProfessionMgr")
local l_canClose = false
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LifeProfessionRewardCtrl = class("LifeProfessionRewardCtrl", super)
--lua class define end

--lua functions
function LifeProfessionRewardCtrl:ctor()
    super.ctor(self, CtrlNames.LifeProfessionReward, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function LifeProfessionRewardCtrl:Init()
    self.panel = UI.LifeProfessionRewardPanel.Bind(self)
    super.Init(self)

    self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
        if l_canClose then
            if self.CloseFunc ~= nil then
                self.CloseFunc()
            end
            UIMgr:DeActiveUI(CtrlNames.LifeProfessionReward)
        end
    end)

    self.ItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.Parent.transform,
    })

    self.panel.Prefab.LuaUIGroup.gameObject:SetActiveEx(false)
end --func end
--next--
function LifeProfessionRewardCtrl:Uninit()
    self.ItemPool = nil
    self.Datas = {}
    l_canClose = false
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function LifeProfessionRewardCtrl:OnActive()
    local l_isShowing = false
    if self.uiPanelData then
        local l_lifeData = DataMgr:GetData("LifeProfessionData")
        if self.uiPanelData.type == l_lifeData.EUIOpenType.LifeProfessionReward then
            self:SetItemList(self.uiPanelData.classID, self.uiPanelData.itemUpdateDataList, self.uiPanelData.func)
            l_isShowing = self.uiPanelData.isActived
        elseif self.uiPanelData.type == l_lifeData.EUIOpenType.LifeProfessionReward_Fish then
            self:SetItemListFishAuto(self.uiPanelData.classID, self.uiPanelData.info)
        elseif self.uiPanelData.type == l_lifeData.EUIOpenType.LifeProfessionReward_Tip then
            self:SetItemListByDate(self.uiPanelData.itemList, self.uiPanelData.closeFunc, self.uiPanelData.tipsInfo)
        end
    end

    if not l_isShowing then
        if self.Datas ~= nil then
            self.ItemPool:ShowTemplates({ Datas = self.Datas })
        end

        if self.TipsInfo then
            self:SetTipsByTipsInfoData(self.TipsInfo)
        end

        --几秒之后可以点击
        l_canClose = false
        self:StopTimer()
        self.aniTimer = self:NewUITimer(function()
            l_canClose = true
        end, 1)
        self.aniTimer:Start()
        --高度控制
        if self.panel.Parent.transform.childCount <= 4 then
            self.panel.RewardList.LayoutEle.preferredHeight = 80
        elseif self.panel.Parent.transform.childCount <= 8 then
            self.panel.RewardList.LayoutEle.preferredHeight = 155
        else
            self.panel.RewardList.LayoutEle.preferredHeight = 170
        end
    end

end --func end
--next--
function LifeProfessionRewardCtrl:OnDeActive()
    self:StopTimer()
    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.LIFE_PROFESSION, true)
end --func end
--next--
function LifeProfessionRewardCtrl:Update()

end --func end

--next--
function LifeProfessionRewardCtrl:BindEvents()
    --dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
function LifeProfessionRewardCtrl:StopTimer()
    if self.aniTimer then
        self:StopUITimer(self.aniTimer)
        self.aniTimer = nil
    end
end

function LifeProfessionRewardCtrl:SetItemList(classID, rewardDatas, closeFunc)

    self.ClassName = classID
    self.Datas = self.Datas or {}
    
	if nil == rewardDatas then
        logError("[LifeProCtrl] invalid param")
        return
    end
    if rewardDatas~=nil then
        for i = 1,#rewardDatas do
            local l_rewardData = rewardDatas[i]
            self.Datas[#self.Datas+1]={
                ID = l_rewardData.propID,
                Count = l_rewardData.propNum,
            }
        end
    end
    self.CloseFunc = closeFunc
    self:SetTipsById(self.ClassName)

end
--自动钓鱼结算的展示
---@param itemList ItemChange
function LifeProfessionRewardCtrl:SetItemListFishAuto(classID, itemList, closeFunc)
    self.ClassName = classID
    self.Datas = self.Datas or {}
    for k, v in ipairs(itemList) do
        self.Datas[#self.Datas + 1] = {
            ID = v.itemid,
            Count = v.count,
        }
    end

    self.CloseFunc = closeFunc
    self:SetTipsById(self.ClassName)
end

--通用的显示奖励的函数
--参数一 传ItemId和数量 结构如右 {{id=10001,count=10},{id=10002,count=3}}
--参数二 界面关闭的时候的回调 一个funcation 没有传Nil
--参数三 界面显示相关也是一个Table 结构如右{title = "xx界面",tipsInfo="xx界面下方显示的文本",atlas = "顶部图集名",icon = "顶部图片名"}
--参数三.atlas == nil 使用Icon_2模式TiTle
function LifeProfessionRewardCtrl:SetItemListByDate(itemList, closeFunc, tipsInfo)

    self.Datas = self.Datas or {}
    for k, v in ipairs(itemList) do
        self.Datas[#self.Datas + 1] = {
            ID = v.id,
            Count = v.count,
            isSticker = v.isSticker,
        }
    end
    self.CloseFunc = closeFunc
    self.TipsInfo = tipsInfo

end

function LifeProfessionRewardCtrl:SetTipsByTipsInfoData(tipsInfoData)

    if tipsInfoData == nil then
        return
    end
    self.panel.TextInfo.LabText = tipsInfoData.tipsInfo
    if (tipsInfoData.atlas ~= nil) then
        self.panel.Title_1:SetActiveEx(true)
        self.panel.Title_2:SetActiveEx(false)
        self.panel.TxtTitle_1.LabText = tipsInfoData.title
        self.panel.Icon:SetSprite(tipsInfoData.atlas, tipsInfoData.icon, true)
    else
        self.panel.Title_1:SetActiveEx(false)
        self.panel.Title_2:SetActiveEx(true)
        self.panel.TxtTitle_2.LabText = tipsInfoData.title
    end

    --以下设置自适应
    local showState = tipsInfoData.tipsInfo == nil or tipsInfoData.tipsInfo == ""
    self.panel.TextInfo.gameObject:SetActiveEx(not showState)
end

function LifeProfessionRewardCtrl:SetTipsById(classID)
    local text = ""
    local tipsInfo = {}
    tipsInfo.atlas = "CommonIcon"
    if classID == ClassID.Cook or classID == ClassID.FoodFusion then
        tipsInfo.icon = "UI_CommonIcon_Leixing_Liaoli.png"
        text = Lang("LifeProfession_Cook_AwardTips")
    elseif classID == ClassID.Drug or classID == ClassID.MedicineFusion then
        tipsInfo.icon = "UI_CommonIcon_Leixing_Yaoji.png"
        text = Lang("LifeProfession_Drug_AwardTips")
    elseif classID == ClassID.Sweet then
        tipsInfo.icon = "UI_CommonIcon_Leixing_Tiaojiu.png"
        text = Lang("LifeProfession_Sweet_AwardTips")
    elseif classID == ClassID.Fish then
        tipsInfo.icon = "UI_CommonIcon_Leixing_Diaoyu.png"
        text = Lang("LifeProfession_Fish_AwardTips")
    elseif classID == ClassID.Smelt or classID == ClassID.Acces or classID == ClassID.Armor then
        tipsInfo.icon = "UI_CommonIcon_Leixing_Duanzao.png"
        text = Lang("LifeProfession_Smelt_AwardTips")
    else
        tipsInfo.icon = "UI_LifeProfession_Tanchuang_Yelian.png"
        text = "NeedText&NeedText"
    end
    local strSplit = string.ro_split(text, "&")
    if #strSplit == 1 then
        tipsInfo.title = strSplit[1]
    elseif #strSplit == 2 then
        tipsInfo.title = strSplit[1]
        tipsInfo.tipsInfo = strSplit[2]
    end
    self.TipsInfo = tipsInfo
end

return LifeProfessionRewardCtrl
--lua custom scripts end
