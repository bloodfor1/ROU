--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MedalTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MedalTipsCtrl = class("MedalTipsCtrl", super)
--缓存一个MedalData的引用
local l_medalData = DataMgr:GetData("MedalData")
local l_medalMgr = MgrMgr:GetMgr("MedalMgr")
--lua class define end

--lua functions
function MedalTipsCtrl:ctor()

    super.ctor(self, CtrlNames.MedalTips, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.MedalTips

end --func end
--next--
function MedalTipsCtrl:Init()

    self.panel = UI.MedalTipsPanel.Bind(self)
    super.Init(self)

    self.panel.ClassificationAttrTip.LabText = Common.Utils.Lang("MEDAL_TIP_NOW_ATTR")

    --self:SetBlockOpt(BlockColor.Dark, function ()
    --    UIMgr:DeActiveUI(UI.CtrlNames.MedalTips)
    --end)

end --func end
--next--
function MedalTipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MedalTipsCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == l_medalData.EMedalOpenType.ChooseMedalAttr then
            self:ChooseMedalAttr(self.uiPanelData.medalData, self.uiPanelData.stateNum)
        end
        if self.uiPanelData.openType == l_medalData.EMedalOpenType.RefreshShowInfo then
            self:RefreshShowInfo(self.uiPanelData.medalData)
        end
    end

end --func end
--next--
function MedalTipsCtrl:OnDeActive()
    Data.PlayerInfoModel.COINCHANGE:RemoveObjectAllFunc(Data.onDataChange, self)
    --清除前置特效
    if self.EffectID then
        self:DestroyUIEffect(self.EffectID)
        self.EffectID = nil
    end

    --清除背景特效
    if self.EffectBgID then
        self:DestroyUIEffect(self.EffectBgID)
        self.EffectBgID = nil
    end

    --清除数据
    self:ClearUpValues()
end --func end
--next--
function MedalTipsCtrl:Update()


end --func end



--next--
function MedalTipsCtrl:BindEvents()

    --服务器加成
    self:BindEvent(l_medalMgr.EventDispatcher, l_medalMgr.MEDAL_TIP_SHOW_HELP, function(mgr, prestige)
        self.panel.HelpPanel:SetActiveEx(true)
        self.panel.TextMessage.LabText = Common.Utils.Lang("MEDAL_BASIC_TIPS_INFO")
        self.panel.TextPrestige.LabText = StringEx.Format(Common.Utils.Lang("MEDAL_TIP_ADD_PRESTIGE"), prestige / 100)
        local sizeY = self.panel.TipPanel.RectTransform.sizeDelta.y
        self.panel.HelpTipPanel.transform.localPosition = Vector2.New(338, sizeY / 2 - 3)
    end)
    self:BindEvent(l_medalMgr.EventDispatcher, l_medalMgr.MEDAL_GLORY_UPGRADE, function(mgr, medalData, isGloryLevelUp)
        self:RefreshShowInfo(medalData)
        if isGloryLevelUp then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MEDAL_GLORY_MEDAL_UPLEVEL"), medalData.Name, medalData.level))
            self:PlayGloryUpgradeAnim()
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--勋章Id
local MedalId = 402
--ZenyId
local ZenyId = 101
--选择勋章属性
function MedalTipsCtrl:ChooseMedalAttr(medalData, stateNum)
    self.panel.ViewAttrTipPanel:SetActiveEx(true)
    self.panel.TipPanel:SetActiveEx(false)
    local sizeY = self.panel.ViewAttrSelectPanel.RectTransform.sizeDelta.y
    self.panel.ViewAttrSelectPanel.transform.localPosition = Vector2.New(0, sizeY / 2)
    self:CreateHolyMedalViewAttr(medalData, stateNum)
end

function MedalTipsCtrl:RefreshShowInfo(medalData)
    self.panel.TipPanel:SetActiveEx(true)
    --名称
    self.panel.MedalName.LabText = medalData.Name
    if medalData.type == 1 then
        self.panel.MedalName.LabColor = Color.New(71 / 255, 136 / 255, 176 / 255)
        self.panel.HeadText.LabText = Common.Utils.Lang("MEDAL_GLORY")
    elseif medalData.type == 2 then
        self.panel.MedalName.LabColor = Color.New(236 / 255, 121 / 255, 29 / 255)
        self.panel.HeadText.LabText = Common.Utils.Lang("MEDAL_HOLY")
    end
    --描述
    self.panel.Describe.LabText = medalData.Dec
    --等级
    self.panel.MedalLv.LabText = ""
    if medalData.level ~= 0 then
        self.panel.MedalLv:SetActiveEx(true)
        self.panel.MedalLv.LabText = StringEx.Format(Common.Utils.Lang("LEVEL"), medalData.level)
    end
    --进度
    self.panel.ProgressSliderObj:SetActiveEx(medalData.type == 1 and medalData.isActivate)
    --图片
    self.panel.MedalIcon:SetSprite(medalData.Atlas, medalData.Spt)
    --隐藏部分控件
    self.panel.ViewAttrTipPanel:SetActiveEx(false)
    self.panel.HelpPanel:SetActiveEx(false)
    self.panel.ClassificationViewAttr:SetActiveEx(false)
    self.panel.ClassificationAttr:SetActiveEx(false)
    self.panel.ClassificationNextAttr:SetActiveEx(false)
    self.panel.ClassificationActive:SetActiveEx(false)
    self.panel.ClassificationPrestige:SetActiveEx(false)
    self.panel.Describe:SetActiveEx(false)
    self.panel.BtnTip1:SetActiveEx(false)
    self.panel.BtnTipPlus:SetActiveEx(false)
    self.panel.BtnTip2:SetActiveEx(false)
    self.panel.ButtonDesc:SetActiveEx(false)
    self.panel.DescMax:SetActiveEx(false)
    self.panel.HelpButton:SetActiveEx(false)
    self.panel.BtnViewAttr:SetActiveEx(false)

    --帮助按钮
    self.panel.MaskHelpBG:AddClick(function()
        self.panel.HelpPanel:SetActiveEx(false)
    end)

    --属性预览
    self.panel.MaskViewAttrBG:AddClick(function()
        self.panel.ViewAttrTipPanel:SetActiveEx(false)
    end)

    self:RefreshClassification(medalData)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.TipPanel.RectTransform)
end

--处理具体数据条件
function MedalTipsCtrl:RefreshClassification(medalData)
    if medalData.type == 1 then
        --光辉勋章
        if medalData.isActivate then
            --已激活
            self.panel.ClassificationAttr:SetActiveEx(true)
            self.panel.ClassificationNextAttr:SetActiveEx(true)
            self.panel.HelpButton:SetActiveEx(true)
            self.panel.Describe:SetActiveEx(true)
            --帮助按钮
            self.panel.HelpButton:AddClick(function()
                l_medalMgr.RequestMedalPrestigeAddition(medalData.MedalId)
            end)
            --当前效果
            --self.panel.ClassificationAttrTip.LabText = Common.Utils.Lang("MEDAL_TIP_NOW_ATTR")
            --下级属性
            if medalData.level < medalData.MaxLv then
                self.panel.ClassificationNextAttrTip.LabText = Common.Utils.Lang("MEDAL_TIP_NEXT_ATTR")
                self:CreateNextAttrScroll(medalData, true)
            else
                self.panel.ClassificationNextAttr:SetActiveEx(false)
            end
            --按钮
            if medalData.level >= medalData.MaxLv then
                self.panel.ClassificationPrestige:SetActiveEx(false)
                self.panel.ButtonDesc:SetActiveEx(true)
                self.panel.ProgressSliderObj:SetActiveEx(false)
                self.panel.ButtonDesc.LabText = Common.Utils.Lang("MEDAL_TIP_LEVEL_MAX")
                self.panel.ButtonDesc.LabColor = Color.New(52 / 255, 52 / 255, 52 / 255, 1)
            else
                local nextOpenLevel = -1
                for k = 0, medalData.BaseMaxLv.Length - 1 do
                    if medalData.level == medalData.BaseMaxLv[k][1] then
                        if MPlayerInfo.Lv <= medalData.BaseMaxLv[k][0] then
                            nextOpenLevel = medalData.BaseMaxLv[k][0]
                        end
                        break
                    end
                end
                if nextOpenLevel == -1 then
                    self.panel.ClassificationPrestige:SetActiveEx(true)
                    self.panel.BtnTip1:SetActiveEx(true)
                    self.panel.BtnTipText1.LabText = Common.Utils.Lang("MEDAL_TIP_UPGRADE_MEDAL")
                    self.panel.BtnTip1:AddClick(function()
                        if l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level) <= Data.BagModel:GetCoinOrPropNumById(MedalId) then
                                -- and l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.level) <= Data.BagModel:GetCoinOrPropNumById(ZenyId) then
                            l_medalMgr.RequestMedalOperate(1, l_medalData.EMedalOperate.Upgrade, medalData.MedalId, 0, 1, l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.MedalId,medalData.level))
                        else
                            -- if l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.level) > Data.BagModel:GetCoinOrPropNumById(ZenyId) then
                            --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_ZENY_NOT_ENOUGTH"))
                            --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(ZenyId, self.panel.ZenyBtn.transform, nil, nil, true)
                            -- end
                            if l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level) > Data.BagModel:GetCoinOrPropNumById(MedalId) then
                                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PRESTIGE_NOT_ENOUGH"))
                                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(MedalId, self.panel.PrestigeBtn.transform, nil, nil, true)
                            end
                        end
                    end)
                    --进阶10次
                    self.panel.BtnTipPlus:SetActiveEx(true)
                    self.panel.BtnTipTextPlus.LabText = Common.Utils.Lang("MEDAL_TIP_UPGRADE_MEDAL_TIMES",l_medalData.GetMedalUpdateTimes())
                    self.panel.BtnTipPlus:AddClick(function()
                        local l_confirmfunc = function (arg1, arg2, arg3)
                            if l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level) <= Data.BagModel:GetCoinOrPropNumById(MedalId) then
                                l_medalMgr.RequestMedalOperate(1, l_medalData.EMedalOperate.Upgrade, medalData.MedalId, 0, l_medalData.GetMedalUpdateTimes(),l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.MedalId,medalData.level))
                            else
                                if l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level) > Data.BagModel:GetCoinOrPropNumById(MedalId) then
                                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PRESTIGE_NOT_ENOUGH"))
                                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(MedalId, self.panel.PrestigeBtn.transform, nil, nil, true)
                                end
                            end
                        end
                        local val = Common.Serialization.LoadData("MEDALTIPS", MPlayerInfo.UID:tostring())
                        if val== nil then
                            self:ShowMedalConsumeDialog(medalData,l_confirmfunc)
                            return
                        end
                        l_confirmfunc()
                    end)
                else
                    self.panel.ButtonDesc:SetActiveEx(true)
                    self.panel.ClassificationPrestige:SetActiveEx(false)
                    self.panel.ButtonDesc.LabText = StringEx.Format(Common.Utils.Lang("MEDAL_TIP_LEVEL_FILL"), nextOpenLevel + 1)
                    self.panel.ButtonDesc.LabColor = Color.New(52 / 255, 52 / 255, 52 / 255, 1)
                end
            end
            --消耗声望
            --声望条
            local nowProgress = medalData.prestigeProgress
            local fillProgress = l_medalData.GetGloryUpgradeTotalCostByLevel(medalData.MedalId,medalData.level)
            self.panel.SliderProgress.Slider.value = nowProgress / fillProgress
            self.panel.Txt_Slider.LabText = nowProgress .. "/" .. fillProgress
            local l_costMedalNum = Common.CommonUIFunc.ShowCoinStatusText(MedalId,l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level))
            local l_costZenyNum = Common.CommonUIFunc.ShowCoinStatusText(ZenyId,l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.MedalId,medalData.level))
            self.panel.PrestigeUsedText.LabText = l_costMedalNum .. "/" .. tostring(Data.BagModel:GetCoinOrPropNumById(MedalId))
            self.panel.PrestigeCostText.LabText = l_costZenyNum .. "/" .. tostring(Data.BagModel:GetCoinOrPropNumById(ZenyId))
            self.panel.ZenyBtn:AddClick(function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(ZenyId, self.panel.ZenyBtn.transform, nil, nil, false)
            end)
            self.panel.PrestigeBtn:AddClick(function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(MedalId, self.panel.PrestigeBtn.transform, nil, nil, false)
            end)
        else
            --未激活
            self.panel.ClassificationAttr:SetActiveEx(true)
            self.panel.ClassificationActive:SetActiveEx(true)
            self.panel.Describe:SetActiveEx(true)
            --激活条件
            self:CreateActiveScroll(medalData, true)
        end
        --属性
        self:CreateAttrScroll(medalData, true)
    elseif medalData.type == 2 then
        --神圣勋章
        if medalData.isActivate then
            --已激活
            self.panel.ClassificationAttr:SetActiveEx(true)
            self.panel.ClassificationNextAttr:SetActiveEx(true)
            self.panel.BtnViewAttr:SetActiveEx(true)
            self.panel.Describe:SetActiveEx(true)
            --全部属性预览
            self.panel.BtnViewAttr:AddClick(function()
                self.panel.ViewAttrTipPanel:SetActiveEx(true)
                local sizeY = self.panel.TipPanel.RectTransform.sizeDelta.y
                self.panel.ViewAttrSelectPanel.transform.localPosition = Vector2.New(363, sizeY / 2 + 10)
                self:CreateHolyMedalViewAttr(medalData, 2)
            end)
            --当前效果
            -- self.panel.ClassificationAttrTip.LabText = Common.Utils.Lang("MEDAL_TIP_NOW_ATTR")
            self:CreateAttrScroll(medalData, false)
            --下级预览
            if medalData.level < medalData.MaxLv then
                self.panel.ClassificationNextAttrTip.LabText = Common.Utils.Lang("MEDAL_TIP_NEXT_ATTR")
                self:CreateNextAttrScroll(medalData, false)
            else
                self.panel.ClassificationNextAttr:SetActiveEx(false)
            end
            --按钮
            self.panel.BtnTip1:SetActiveEx(true)
            self.panel.BtnTipText1.LabText = Common.Utils.Lang("MEDAL_TIP_RESET")
            self.panel.BtnTip1:AddClick(function()
                l_medalMgr.ShowMedalOperateDlg(2, l_medalData.EMedalOperate.Reset, medalData, -1, Common.Utils.Lang("MEDAL_HOLY"))
                UIMgr:DeActiveUI(self.name)
            end)
            if medalData.level >= medalData.MaxLv then
                self.panel.DescMax:SetActiveEx(true)
                self.panel.ButtonDesc:SetActiveEx(false)
                self.panel.ButtonDesc.LabText = Common.Utils.Lang("MEDAL_TIP_MAXLEVEL")
                self.panel.ButtonDesc.LabColor = Color.New(235 / 255, 76 / 255, 78 / 255, 1)
                self.panel.DescMax.LabText = Common.Utils.Lang("MEDAL_TIP_MAXLEVEL")
                self.panel.DescMax.LabColor = Color.New(235 / 255, 76 / 255, 78 / 255, 1)
            else
                self.panel.BtnTip2:SetActiveEx(true)
                self.panel.BtnTipText2.LabText = Common.Utils.Lang("MEDAL_TIP_UPGRADE")
                self.panel.BtnTip2:AddClick(function()
                    l_medalMgr.ShowMedalOperateDlg(2, l_medalData.EMedalOperate.Upgrade, medalData, -1, Common.Utils.Lang("MEDAL_HOLY"))
                    UIMgr:DeActiveUI(self.name)
                end)
            end
        else
            --未激活
            self.panel.ClassificationActive:SetActiveEx(true)
            self.panel.ClassificationViewAttr:SetActiveEx(true)
            self.panel.Describe:SetActiveEx(true)
            --属性列表
            self:CreateHolyMedalViewAttr(medalData, 1)
            --激活条件
            self:CreateActiveScroll(medalData, false)
        end
    end
    if not self.panel.BtnTip1.gameObject.activeSelf and not self.panel.BtnTip2.gameObject.activeSelf and not self.panel.ButtonDesc.gameObject.activeSelf then
        self.panel.ButtonsPanel:SetActiveEx(false)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.TipPanel.RectTransform)
end

function MedalTipsCtrl:ShowMedalConsumeDialog(medalData,confirmfunc)
    local l_zeny = l_medalData.GetGloryZenyUpgradeCostByLevel(medalData.MedalId,medalData.level)
    local l_medalNum = l_medalData.GetGloryMedalUpgradeCostByLevel(medalData.MedalId,medalData.level)
    --消耗
    local l_consumeDatas = {}
    local l_data_zeny = {}
    l_data_zeny.ID = GameEnum.l_virProp.Coin101
    l_data_zeny.IsShowCount = false
    l_data_zeny.IsShowRequire = true
    l_data_zeny.RequireCount = l_zeny * l_medalData.GetMedalUpdateTimes()

    local l_data_medal = {}
    l_data_medal.ID = GameEnum.l_virProp.Prestige
    l_data_medal.IsShowCount = false
    l_data_medal.IsShowRequire = true
    l_data_medal.RequireCount = l_medalNum * l_medalData.GetMedalUpdateTimes()
    table.insert(l_consumeDatas, l_data_medal)
    table.insert(l_consumeDatas, l_data_zeny)

    CommonUI.Dialog.ShowConsumeDlg("",Common.Utils.Lang("CONFIRME_MEDAL_UPDATE",l_medalData.GetMedalUpdateTimes()),
        function (arg1, arg2, arg3)
            confirmfunc()
        end,function (arg1, arg2, arg3)
            
        end,l_consumeDatas)
end


--激活条件组件表
local activeItemTable = {}
--已达成颜色
local finishColor = Color.New(230 / 255, 162 / 255, 65 / 255, 1)
--未达成颜色
local notFinishColor = Color.New(151 / 255, 152 / 255, 153 / 255, 1)

--激活条件列表
function MedalTipsCtrl:CreateActiveScroll(medalData, isGlory)
    local taskMgr = MgrMgr:GetMgr("TaskMgr")
    local achievementMgr = MgrMgr:GetMgr("AchievementMgr")
    --清除激活条件组件
    for k, v in ipairs(activeItemTable) do
        MResLoader:DestroyObj(v)
    end
    activeItemTable = {}
    --计算长度
    local length = medalData.Activition.Length

    --创建激活条件组件
    local activeItem = self.panel.ClassificationActiveText.gameObject
    for k = 0, length - 1 do
        local attrTemp = self:CloneObj(activeItem)
        attrTemp.transform:SetParent(activeItem.transform.parent.transform)
        attrTemp.transform.localScale = activeItem.transform.localScale
        attrTemp:SetActiveEx(true)
        --显示文字
        local activateData = medalData.Activition[k]
        local activateDec = medalData.ActivitionDec[k]
        attrTemp:GetComponent("MLuaUICom").LabText = activateDec

        --获取是否已经完成
        local isFinish = l_medalMgr.GetMedalActiveState(medalData.activeProgress, k) == "1"
        attrTemp.transform:Find("lock"):GetComponent("MLuaUICom"):SetActiveEx(isFinish)
        attrTemp.transform:Find("unlock"):GetComponent("MLuaUICom"):SetActiveEx(not isFinish)
        if isFinish then
            attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):SetActiveEx(false)
            attrTemp:GetComponent("MLuaUICom").LabColor = finishColor
        else
            attrTemp:GetComponent("MLuaUICom").LabColor = notFinishColor
            --前往
            if activateData[0] == 1 then
                --任务
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):SetActiveEx(true)
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):AddClick(function()
                    UIMgr:DeActiveUI(self.name)
                    UIMgr:DeActiveUI(UI.CtrlNames.Medal)
                    taskMgr.OnQuickTaskClickWithTaskId(activateData[1])
                end)
            elseif activateData[0] == 5 then
                --成就
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):SetActiveEx(true)
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):AddClick(function()
                    UIMgr:DeActiveUI(self.name)
                    MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(activateData[1])
                end)
            elseif activateData[0] == 6 then
                --成就勋章
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):SetActiveEx(true)
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):AddClick(function()
                    UIMgr:DeActiveUI(self.name)
                    MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true)
                end)
            else
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):SetActiveEx(false)
                attrTemp.transform:Find("ClassificationActiveButton"):GetComponent("MLuaUICom"):AddClick(function()
                    UIMgr:DeActiveUI(self.name)
                end)
            end
        end
    end
end

--当前属性组件表
local attrItemTable = {}

--当前属性列表
function MedalTipsCtrl:CreateAttrScroll(medalData, isGlory)
    --清除当前属性组件
    for k, v in ipairs(attrItemTable) do
        MResLoader:DestroyObj(v)
    end
    attrItemTable = {}
    --计算长度
    local length
    if isGlory then
        local indexLevel = medalData.level
        if not medalData.isActivate then
            indexLevel = 1
        end
        if medalData.attrInfo then
            length = #medalData.attrInfo[indexLevel]
        else
            logError("光辉勋章配置错误 MedalTable中多配了或MedalAttrTable中少配了 medalId => " .. medalData.MedalId)
            return
        end
    else
        length = 1
    end
    --创建当前属性组件
    local attrItem = self.panel.ClassificationAttrText.gameObject
    for k = 0, length - 1 do
        local attrTemp = self:CloneObj(attrItem)
        attrTemp.transform:SetParent(attrItem.transform.parent.transform)
        attrTemp.transform.localScale = attrItem.transform.localScale
        attrTemp:SetActiveEx(true)
        table.insert(attrItemTable, attrTemp)
        --显示文字
        local preStr = tonumber(medalData.Object) == 1 and Lang("MERCENARY_STR") or ""
        local attrStr = ""
        if isGlory then
            local indexLevel = medalData.level
            if not medalData.isActivate then
                indexLevel = 1
            end
            local attrId = medalData.attrInfo[indexLevel][k + 1]
            if attrId then

                if tonumber(attrId[1]) == 0 then
                    local attr = { type = 0, id = tonumber(attrId[2]), val = tonumber(attrId[4]) }
                    local equipMgr = MgrMgr:GetMgr("EquipMgr")
                    attrStr = tostring(equipMgr.GetAttrStrByData(attr))
                else
                    --装备属性
                    local dec = medalData.attrInfo[indexLevel].dec
                    if dec ~= "" then
                        local l_index = string.find(dec, "pro")
                        local l_preIndex = string.sub(dec, l_index + 4, l_index + 4)
                        if l_preIndex == "%" then
                            attrStr = string.gsub(dec, "{pro}", (tonumber(medalData.attrInfo[indexLevel][k + 1][5]) / 100))
                        else
                            attrStr = string.gsub(dec, "{pro}", medalData.attrInfo[indexLevel][k + 1][5])
                        end
                    end
                end
            end
        else
            local buffData = medalData.attrInfo[self:GetProId(medalData)][medalData.attrPos + 1]
            if buffData then
                attrStr = buffData.BuffText[medalData.level - 1]
            else
                attrTemp:SetActiveEx(false)
                logError("找不到对应的AttrPos => " .. medalData.attrPos .. " medalId => " .. medalData.MedalId .. " Profession => " .. MPlayerInfo.ProID)
            end
        end
        attrTemp:GetComponent("MLuaUICom").LabText = preStr .. attrStr
    end
end

--下级属性组件表
local nextAttrItemTable = {}

--下级属性列表
function MedalTipsCtrl:CreateNextAttrScroll(medalData, isGlory)
    --清除下级属性组件
    for k, v in ipairs(nextAttrItemTable) do
        MResLoader:DestroyObj(v)
    end
    nextAttrItemTable = {}
    --计算长度
    local length
    if isGlory then
        if medalData.attrInfo then
            length = #medalData.attrInfo[medalData.level + 1]
        else
            logError("光辉勋章配置错误 MedalTable中多配了或MedalAttrTable中少配了 medalId => " .. medalData.MedalId)
            return
        end
    else
        length = 1
    end
    --创建下级属性组件
    local nextAttrItem = self.panel.ClassificationAttrNextText.gameObject
    for k = 0, length - 1 do
        local attrTemp = self:CloneObj(nextAttrItem)
        attrTemp.transform:SetParent(nextAttrItem.transform.parent.transform)
        attrTemp.transform.localScale = nextAttrItem.transform.localScale
        attrTemp:SetActiveEx(true)
        table.insert(nextAttrItemTable, attrTemp)
        local preStr = tonumber(medalData.Object) == 1 and Lang("MERCENARY_STR") or ""
        --显示文字
        local attrStr = ""
        if isGlory then
            local attrId = medalData.attrInfo[medalData.level + 1][k + 1]
            if attrId then
                if tonumber(attrId[1]) == 0 then
                    local attr = { type = 0, id = tonumber(attrId[2]), val = tonumber(attrId[4]) }
                    local equipMgr = MgrMgr:GetMgr("EquipMgr")
                    attrStr = tostring(equipMgr.GetAttrStrByData(attr))
                else
                    --装备属性
                    local dec = medalData.attrInfo[medalData.level + 1].dec
                    local l_index = string.find(dec, "pro")
                    local l_preIndex = string.sub(dec, l_index + 4, l_index + 4)
                    if l_preIndex == "%" then
                        attrStr = string.gsub(dec, "{pro}", (tonumber(medalData.attrInfo[medalData.level + 1][k + 1][5]) / 100))
                    else
                        attrStr = string.gsub(dec, "{pro}", medalData.attrInfo[medalData.level + 1][k + 1][5])
                    end
                end
            end
        else
            local buffData = medalData.attrInfo[self:GetProId(medalData)][medalData.attrPos + 1]
            if buffData then
                attrStr = buffData.BuffText[medalData.level]
            else
                attrTemp:SetActiveEx(false)
                logError("找不到对应的AttrPos => " .. medalData.attrPos .. " medalId => " .. medalData.MedalId .. " Profession => " .. MPlayerInfo.ProID)
            end
        end
        attrTemp:GetComponent("MLuaUICom").LabText = preStr .. attrStr
    end
end

--预览属性组件表
local viewAttrItemTable = {}
--选中的属性组件
local chooseAttrItem
--选中的属性ID
local chooseAttrId
--创建预览组件滚动条
function MedalTipsCtrl:CreateHolyMedalViewAttr(medalData, state)

    if medalData == nil or medalData.attrInfo == nil then
        return
    end

    --state 1激活属性预览 2流派属性库 3重置属性库 4选择属性库
    local attrItem
    --判断职业
    if state == 1 then
        --属性数量动态
        self.panel.ClassificationViewAttrTip.LabText = StringEx.Format(Common.Utils.Lang("MEDAL_TIP_GET_ONE_ATTR"), #medalData.attrInfo[self:GetProId(medalData)])
        attrItem = self.panel.ClassificationViewAttrText.gameObject
    elseif state == 2 then
        self.panel.ViewAttrSelectTitle.LabText = StringEx.Format(Common.Utils.Lang("MEDAL_TIP_ATTR_LIB"), medalData.Name)
        attrItem = self.panel.ViewAttrSelect.gameObject
    elseif state == 3 or state == 4 then
        self.panel.ViewAttrSelectTitle.LabText = Common.Utils.Lang("MEDAL_TIP_CHOOSE_ATTR")
        attrItem = self.panel.ViewAttrSelect.gameObject
        self.panel.MaskViewAttrBG:AddClick(function()
            UIMgr:DeActiveUI(self.name)
        end)
    end
    --清除预览属性组件
    for k, v in ipairs(viewAttrItemTable) do
        MResLoader:DestroyObj(v)
    end
    viewAttrItemTable = {}
    --创建预览属性组件
    --for k=0, #medalData.attrInfo[self:GetProId(medalData)]-1 do
    for k, v in ipairs(medalData.attrInfo[self:GetProId(medalData)]) do
        local attrTemp = self:CloneObj(attrItem)
        attrTemp.transform:SetParent(attrItem.transform.parent.transform)
        attrTemp.transform.localScale = attrItem.transform.localScale
        attrTemp:SetActiveEx(true)
        table.insert(viewAttrItemTable, attrTemp)
        --显示文字
        if state == 1 then
            attrTemp.transform:Find("ClassificationViewAttrLab"):GetComponent("MLuaUICom").LabText = v.BuffText[0]
        elseif state == 2 then
            attrTemp.transform:Find("ViewAttrText"):GetComponent("MLuaUICom").LabText = v.BuffText[medalData.level - 1]
            attrTemp.transform:Find("BtnSelect"):GetComponent("MLuaUICom"):SetActiveEx(false)
        elseif state == 3 or state == 4 then
            attrTemp.transform:Find("ViewAttrText"):GetComponent("MLuaUICom").LabText = state == 3 and v.BuffText[medalData.level - 1] or v.BuffText[1]
            attrTemp.transform:Find("BtnSelect"):GetComponent("MLuaUICom"):SetActiveEx(true)
            attrTemp.transform:Find("BtnSelect"):GetComponent("MLuaUICom"):AddClick(function()
                UIMgr:DeActiveUI(self.name)
                local attrType = state == 3 and l_medalData.EMedalOperate.Reset or l_medalData.EMedalOperate.Activate
                l_medalMgr.RequestMedalOperate(2, attrType, medalData.MedalId, k - 1)
            end)
        end
        if state == 2 or state == 3 or state == 4 then
            local viewAttr = attrTemp.transform:Find("ViewAttrText"):GetComponent("MLuaUICom")
            local viewAttrPos = viewAttr.RectTransform.sizeDelta
            if attrTemp.transform:Find("BtnSelect"):GetComponent("MLuaUICom").gameObject.activeSelf then
                viewAttr.RectTransform.sizeDelta = Vector2(240, viewAttrPos.y)
            else
                viewAttr.RectTransform.sizeDelta = Vector2(318, viewAttrPos.y)
            end
        end
    end
end

function MedalTipsCtrl:GetProId(medalData)
    local proId = MPlayerInfo.ProID
    if proId == 1000 then
        logError("初心者不能使用勋章系统")
        return proId
    end

    if not medalData.attrInfo[proId] then
        --proId = TableUtil.GetProfessionTable().GetRowById(proId).ParentProfession
        local proList = Common.CommonUIFunc.GetPlayerProfessionList(proId)
        if #proList <= 0 then
            logError("输入的职业Id有误,请检查 Mx")
        end
        proId = #proList > 0 and proList[1] or proId
    end
    return proId
end

--播放光辉勋章升级动画
function MedalTipsCtrl:PlayGloryUpgradeAnim()
    --清除前置特效
    if self.EffectID then
        self:DestroyUIEffect(self.EffectID)
        self.EffectID = nil
    end
    --前置升级特效
    self.panel.IconFx.RawImg.enabled = false
    local l_fxData = {}
    l_fxData.rawImage = self.panel.IconFx.RawImg
    self.EffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_MedalPromotion_01", l_fxData)



    --清除背景特效
    if self.EffectBgID then
        self:DestroyUIEffect(self.EffectBgID)
        self.EffectBgID = nil
    end
    --背景升级特效
    self.panel.IconBgFx.RawImg.enabled = false
    local l_fxData_bg = {}
    l_fxData_bg.rawImage = self.panel.IconBgFx.RawImg
    l_fxData_bg.loadedCallback = function(a)
        self.panel.IconBgFx.UObj:SetActiveEx(true)
    end
    l_fxData_bg.destroyHandler = function()
        self.EffectBgID = nil
    end
    self.EffectBgID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_MedalPromotion_02", l_fxData_bg)
end

function MedalTipsCtrl:ClearUpValues()
    viewAttrItemTable = {}
    chooseAttrItem = nil
    chooseAttrId = nil
    activeItemTable = {}
    attrItemTable = {}
    nextAttrItemTable = {}
end
--lua custom scripts end

return MedalTipsCtrl
