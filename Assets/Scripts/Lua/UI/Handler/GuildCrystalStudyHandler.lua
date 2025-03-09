--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildCrystalStudyPanel"
require "UI/Template/CrystalPropertyChangeItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
GuildCrystalStudyHandler = class("GuildCrystalStudyHandler", super)
--lua class define end

local l_guildData = nil
local l_guildCrystalMgr = nil
local l_selectCrystalInfo = nil  --选中的水晶的信息
local l_selectCrystalLevelData = nil  --选中的水晶的等级数据

--lua functions
function GuildCrystalStudyHandler:ctor()

    super.ctor(self, HandlerNames.GuildCrystalStudy, 0)

end --func end
--next--
function GuildCrystalStudyHandler:Init()

    self.panel = UI.GuildCrystalStudyPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildCrystalMgr = MgrMgr:GetMgr("GuildCrystalMgr")

    --研究帮助按钮的文字说明
    self.studyHelpTip = nil

    self.timer = nil --经验获取计时器

    --属性变化池申明
    self.propertyChangePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CrystalPropertyChangeItemTemplate,
        TemplatePrefab = self.panel.CrystalPropertyChangeItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.PropertyScrollView.LoopScroll
    })

    --按钮点击事件绑定
    self:ButtonEventBind()

end --func end
--next--
function GuildCrystalStudyHandler:Uninit()

    self.studyHelpTip = nil

    l_selectCrystalInfo = nil
    l_selectCrystalLevelData = nil
    l_guildCrystalMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildCrystalStudyHandler:OnActive()

    --快速升级按钮 防连点
    self.quickClicked = false

    --研究速率显示 只和水晶的建筑等级相关
    local l_crystalInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal) or {}  --默认空表容错
    local l_crystalDetail = TableUtil.GetGuildUpgradingTable().GetRowById(l_guildData.EBuildingType.Crystal * 100 + (l_crystalInfo.level or 1))
    self.panel.StudySpeed.LabText = Lang("GUILD_CRYSTAL_STUDY_SPEED", l_crystalDetail and l_crystalDetail.BlessingStudyExpPerHour or 0)
    
end --func end
--next--
function GuildCrystalStudyHandler:OnDeActive()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

end --func end
--next--
function GuildCrystalStudyHandler:Update()


end --func end


--next--
function GuildCrystalStudyHandler:OnShow()

    --切换标签页事件发送
    l_guildCrystalMgr.SwitchCrystalHandler(1)
    --请求水晶信息
    l_guildCrystalMgr.ReqGetGuildCrystalInfo()

    --如果有选中的水晶则选中选中目标水晶
    if l_selectCrystalInfo then
        l_guildCrystalMgr.SelectOneCrystal(l_selectCrystalInfo.id)
    else
        --默认选中研究中的 或 第一个水晶
        l_selectCrystalInfo = l_guildData.GetCrystalInfo(1)
        for i = 2, 6 do
            local l_temp = l_guildData.GetCrystalInfo(i)
            if l_temp.isStudy then
                l_selectCrystalInfo = l_temp
                break
            end
        end
        l_selectCrystalLevelData = TableUtil.GetGuildCrystalLevelTable().GetRowByCrystalLevelId(l_selectCrystalInfo.id * 100 + l_selectCrystalInfo.level)
    end

    self:ShowBaseInfo()
    self:ShowPropertyInfo()
    self:ShowUpgradeInfo()

end --func end

--next--
function GuildCrystalStudyHandler:BindEvents()

    --水晶选择事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_SELECT_CRYSTAL, function(self, crystalId)
        if l_guildCrystalMgr.curShowHandlerId == 1 then
            l_selectCrystalInfo = l_guildData.GetCrystalInfo(crystalId)
            l_selectCrystalLevelData = TableUtil.GetGuildCrystalLevelTable().GetRowByCrystalLevelId(l_selectCrystalInfo.id * 100 + l_selectCrystalInfo.level)
            self:ShowBaseInfo()
            self:ShowPropertyInfo()
            self:ShowUpgradeInfo()
            --按钮灰置设置
            if l_selectCrystalInfo.isStudy then
                self.panel.BtnSetStudyBlock.UObj:SetActiveEx(true)
            else
                self.panel.BtnSetStudyBlock.UObj:SetActiveEx(false)
            end
        end
    end)
    --水晶相关信息获取事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_GET_GUILD_CRYSTAL_INFO, function(self)
        if l_guildCrystalMgr.curShowHandlerId == 1 then
            if l_selectCrystalInfo then
                l_selectCrystalInfo = l_guildData.GetCrystalInfo(l_selectCrystalInfo.id)
                l_selectCrystalLevelData = TableUtil.GetGuildCrystalLevelTable().GetRowByCrystalLevelId(l_selectCrystalInfo.id * 100 + l_selectCrystalInfo.level)
            else
                l_selectCrystalInfo = l_guildData.GetCrystalInfo(1)
                l_selectCrystalLevelData = TableUtil.GetGuildCrystalLevelTable().GetRowByCrystalLevelId(l_selectCrystalInfo.id * 100 + l_selectCrystalInfo.level)
            end
            self:ShowBaseInfo()
            self:ShowPropertyInfo()
            self:ShowUpgradeInfo()
            --研究经验升级计时器设置
            self:SetTimerForStudy()
            --按钮灰置设置
            self.panel.BtnSetStudyBlock.UObj:SetActiveEx(l_selectCrystalInfo.isStudy)
        end
    end)
    --水晶相关信息获取事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_GUILD_CRYSTAL_QUICK_UPDATE, function(self)
        self.quickClicked = false
    end)
    --断线重连事件
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher, MgrMgr:GetMgr("GuildMgr").ON_GUILD_RECONNECT, function(self)
        self.quickClicked = false
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
--按钮点击事件绑定
function GuildCrystalStudyHandler:ButtonEventBind()
    --研究帮助按钮点击
    self.panel.BtnStudyHelp:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainText.LabText = self.studyHelpTip
        self.panel.ExplainBubble.RectTransform.pivot = Vector2.New(1, 0)

        local l_worldPos = self.panel.BtnStudyHelp.Transform.position
        local l_viewPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.ExplainPanel.Transform)
        self.panel.ExplainBubble.RectTransform.anchoredPosition = Vector2.New(l_viewPos.x - 15, l_viewPos.y - 15)
    end)
    --研究速率帮助按钮点击
    self.panel.BtnStudySpeedHelp:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainText.LabText = Lang("GUILD_CRYSTAL_STUDY_SPEED_TIP")
        self.panel.ExplainBubble.RectTransform.pivot = Vector2.New(0, 0)

        local l_worldPos = self.panel.BtnStudySpeedHelp.Transform.position
        local l_viewPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.ExplainPanel.Transform)
        self.panel.ExplainBubble.RectTransform.anchoredPosition = Vector2.New(l_viewPos.x + 15, l_viewPos.y - 15)
    end)
    --帮助界面背景点击
    self.panel.BtnCloseExplain:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
    end)
    --设置研究按钮点击
    self.panel.BtnSetStudy:AddClick(function()
        self:SetStudy()
    end)
    --快速升级按钮点击
    self.panel.BtnQuickUpgrade:AddClick(function()
        if not self.quickClicked then
            self:QuickUpgrade()
        end
    end)
end

--展示水晶基础信息
function GuildCrystalStudyHandler:ShowBaseInfo()

    local l_selectCrystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_selectCrystalInfo.id)
    self.panel.CrystalIcon:SetSprite(l_selectCrystalData.CrystalIconAltas, l_selectCrystalData.CrystalIconName, true)
    self.panel.CrystalIcon.UObj:SetActiveEx(true)
    self.panel.IsStudying.UObj:SetActiveEx(l_selectCrystalInfo.isStudy)
    self.panel.SelectCrystalName.LabText = Lang("TROLLEY_REFIT_SKILL_LIMIT", Lang(l_selectCrystalData.CrystalName), l_selectCrystalInfo.level)
    --帮助说明的文本赋值
    self.studyHelpTip = Lang("GUILD_CRYSTAL_STUDY_HELP_TIP",
            Lang(l_selectCrystalData.CrystalName), Lang(l_selectCrystalData.CrystalName),
            Lang(l_selectCrystalData.CrystalName), Lang(l_selectCrystalData.CrystalName))
end

--展示水晶属性信息
function GuildCrystalStudyHandler:ShowPropertyInfo()

    --下阶属性标题的显示控制
    self.panel.NextPropertyTitle.UObj:SetActiveEx(not l_selectCrystalLevelData.isMaxLevel)
    --获取下一等级的属性
    local l_propertyDataList = {}
    if l_selectCrystalLevelData.isMaxLevel then
        for i = 0, l_selectCrystalLevelData.CrystalBonuses.Count - 1 do
            local l_propertyData = {}
            l_propertyData.curName, l_propertyData.curValue = self:GetPropertyData(l_selectCrystalLevelData.CrystalBonuses[i][1],
                    l_selectCrystalLevelData.CrystalBonuses[i][3])
            table.insert(l_propertyDataList, l_propertyData)
        end
    else
        local l_nextCrystalLevelData = TableUtil.GetGuildCrystalLevelTable().GetRowByCrystalLevelId(l_selectCrystalInfo.id * 100 + l_selectCrystalInfo.level + 1)
        for i = 0, l_nextCrystalLevelData.CrystalBonuses.Count - 1 do
            local l_propertyData = {}
            if i < l_selectCrystalLevelData.CrystalBonuses.Count then
                l_propertyData.curName, l_propertyData.curValue = self:GetPropertyData(l_selectCrystalLevelData.CrystalBonuses[i][1],
                        l_selectCrystalLevelData.CrystalBonuses[i][3])
            end
            l_propertyData.nextName, l_propertyData.nextValue = self:GetPropertyData(l_nextCrystalLevelData.CrystalBonuses[i][1],
                    l_nextCrystalLevelData.CrystalBonuses[i][3])
            table.insert(l_propertyDataList, l_propertyData)
        end
    end

    self.propertyChangePool:ShowTemplates({ Datas = l_propertyDataList })

end

--获取水晶建筑的加成信息
--attrId 属性ID
--attrValue 属性加成值
function GuildCrystalStudyHandler:GetPropertyData(attrId, attrValue)
    local l_attrRow = TableUtil.GetAttrDecision().GetRowById(attrId)
    if l_attrRow then
        local l_attrName = StringEx.Format(l_attrRow.TipTemplate, "")
        local l_attrValue = l_attrRow.TipParaEnum == 1 and "+" .. tostring(attrValue / 100) .. "%" or "+" .. tostring(attrValue)
        return l_attrName, l_attrValue
    end
    return "", ""
end

--展示水晶升级信息
function GuildCrystalStudyHandler:ShowUpgradeInfo()

    if l_selectCrystalLevelData.isMaxLevel then
        --已满级的情况
        self.panel.UpgradeContent.UObj:SetActiveEx(false)
        self.panel.MaxLevelTip.UObj:SetActiveEx(true)
    else
        --未满级的情况
        self.panel.UpgradeContent.UObj:SetActiveEx(true)
        self.panel.MaxLevelTip.UObj:SetActiveEx(false)
        --经验条数据
        self.panel.ProgressText.LabText = tostring(l_selectCrystalInfo.exp) .. "/" .. tostring(l_selectCrystalLevelData.CrystalExpSpend)
        local l_percentage = tonumber(tostring(l_selectCrystalInfo.exp)) / tonumber(tostring(l_selectCrystalLevelData.CrystalExpSpend))
        self.panel.ProgressSlider.Slider.value = l_percentage > 1 and 1 or l_percentage
        --华丽水晶建筑等级条件
        self.panel.LimitText[1].LabText = Lang("NEED_CRYSTAL_BUILDING_LEVEL", l_selectCrystalLevelData.UpgradeCondition1Value)
        if self:GetCrystalBuildingLevel() < l_selectCrystalLevelData.UpgradeCondition1Value then
            self.panel.LimitTipIcon[1]:SetSprite("Medal", "UI_Medal_ponit_02.png", true)
            self.panel.LimitText[1].LabColor = Color.New(175 / 255.0, 182 / 255.0, 208 / 255.0)
        else
            self.panel.LimitTipIcon[1]:SetSprite("Medal", "UI_Medal_ponit_01.png", true)
            self.panel.LimitText[1].LabColor = Color.New(229 / 255.0, 162 / 255.0, 65 / 255.0)
        end
        --属性水晶等级总和条件
        if l_selectCrystalLevelData.UpgradeCondition2Value == 0 then
            self.panel.LimitBox2.UObj:SetActiveEx(false)
        else
            self.panel.LimitBox2.UObj:SetActiveEx(true)
            self.panel.LimitText[2].LabText = Lang("NEED_CRYSTAL_TOTAL_LEVEL", l_selectCrystalLevelData.UpgradeCondition2Value)
            if self:GetCrystalTotalLevel() < l_selectCrystalLevelData.UpgradeCondition2Value then
                self.panel.LimitTipIcon[2]:SetSprite("Medal", "UI_Medal_ponit_02.png", true)
                self.panel.LimitText[2].LabColor = Color.New(175 / 255.0, 182 / 255.0, 208 / 255.0)
            else
                self.panel.LimitTipIcon[2]:SetSprite("Medal", "UI_Medal_ponit_01.png", true)
                self.panel.LimitText[2].LabColor = Color.New(229 / 255.0, 162 / 255.0, 65 / 255.0)
            end
        end
    end

end

--设置研究
function GuildCrystalStudyHandler:SetStudy()

    --判断职位
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Director then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIRECTOR_CAN_SET_STUDY"))
        return
    end

    --判断是否正在研究
    if l_selectCrystalInfo.isStudy then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THIS_CRYSTAL_IS_STUDYING"))
        return
    end

    if self:CheckCanUpgrade() then
        local l_selectCrystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_selectCrystalInfo.id)
        local l_costText = Lang("CHECK_GUILD_CRYSTAL_SET_STUDY", Lang(l_selectCrystalData.CrystalName))
        local l_curStudyName = Lang("NONE")
        for i = 1, #l_guildData.guildCrystalInfo.crystalList do
            if l_guildData.guildCrystalInfo.crystalList[i].isStudy then
                local l_crystalId = l_guildData.guildCrystalInfo.crystalList[i].id
                local l_crystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_crystalId)
                if l_crystalData then
                    l_curStudyName = Lang(l_crystalData.CrystalName)
                end
                break
            end
        end
        local l_haveText = Lang("CURRENT_STUDY_CRYSTAL", GetColorText(l_curStudyName, RoColorTag.Yellow))
        CommonUI.Dialog.ShowCostCheckDlg(true, Lang("CRYSTAL_STUDY"), l_costText, l_haveText, function()
            l_guildCrystalMgr.ReqGuildCrystalStudy(l_selectCrystalInfo.id)
        end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD)
    end

end

--快速升级
function GuildCrystalStudyHandler:QuickUpgrade()
    if self:CheckCanUpgrade() then
        --最大购买次数获取
        local l_maxWeekQuickUpgradeTimes = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalWeekLimit").Value)
        if l_guildData.guildCrystalInfo.quickUpgradeUsedCount >= l_maxWeekQuickUpgradeTimes then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THIS_WEEK_QUICK_UPGRADE_TIMES_IS_OVER"))
            return
        end
        
        --钻石消耗和图标获取
        local l_crystalExpPriceStr = TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalExpPrice").Value
        local l_crystalExpPriceGroup = string.ro_split(l_crystalExpPriceStr, "=")
        local l_diamondCost = tonumber(l_crystalExpPriceGroup[2])
        local l_diamondItemData = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_crystalExpPriceGroup[1]))
        local l_diamondIconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_diamondItemData.ItemIcon, l_diamondItemData.ItemAtlas, 20, 1)
        --可获取的经验获取
        local l_expGet = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalExpNum").Value)

        --提示文字拼接
        local l_costText = Lang("GUILD_CRYSTAL_QUICK_UPGRADE_CHECK",
                l_diamondIconStr, 
                MNumberFormat.GetNumberFormat(l_diamondCost), 
                l_expGet,
                l_maxWeekQuickUpgradeTimes - l_guildData.guildCrystalInfo.quickUpgradeUsedCount, 
                l_maxWeekQuickUpgradeTimes)
        local l_haveText = Lang("CURRENT_HAVE", l_diamondIconStr .. tostring(Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103)))
        CommonUI.Dialog.ShowCostCheckDlg(true, Lang("QUICK_UPGRADE"), l_costText, l_haveText, function()
            --判断钻石数量是否足够
            if Data.BagModel:GetCoinOrPropNumById(tonumber(l_crystalExpPriceGroup[1])) < l_diamondCost then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH_CAN_NOT_BUY"))
                return
            end

            --请求快速升级
            l_guildCrystalMgr.ReqGuildCrystalQuickUpgrade(l_selectCrystalInfo.id)
            self.quickClicked = true
        end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD,true)
    end
end

--检查是否可升级
function GuildCrystalStudyHandler:CheckCanUpgrade()
    --判断当前是否有选中的水晶
    if not l_selectCrystalInfo then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ONE_CRYSTAL"))
        return false
    end
    --验证是否满级
    if l_selectCrystalLevelData.isMaxLevel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THIS_CRYSTAL_IS_MAX_LEVEL"))
        return false
    end
    --验证华丽水晶建筑等级是否足够
    if self:GetCrystalBuildingLevel() < l_selectCrystalLevelData.UpgradeCondition1Value then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_CRYSTAL_BUILDING_LEVEL", l_selectCrystalLevelData.UpgradeCondition1Value))
        return false
    end
    --验证属性水晶等级总后是否满足
    if self:GetCrystalTotalLevel() < l_selectCrystalLevelData.UpgradeCondition2Value then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_CRYSTAL_TOTAL_LEVEL", l_selectCrystalLevelData.UpgradeCondition2Value))
        return false
    end
    --通过检测返回true
    return true
end

--获取华丽水晶建筑等级
function GuildCrystalStudyHandler:GetCrystalBuildingLevel()
    local l_crystalBuildingInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal) or {}
    local l_crystalBuildingLevel = l_crystalBuildingInfo.level or 0
    return l_crystalBuildingLevel
end

--获取水晶等级总和
function GuildCrystalStudyHandler:GetCrystalTotalLevel()
    local l_crystalLevelTotal = 0
    for i = 1, #l_guildData.guildCrystalInfo.crystalList do
        l_crystalLevelTotal = l_crystalLevelTotal + l_guildData.guildCrystalInfo.crystalList[i].level
    end
    return l_crystalLevelTotal
end

--设置研究经验增长计时器
function GuildCrystalStudyHandler:SetTimerForStudy()
    if not self.timer and l_guildData.guildCrystalInfo.getExeTimeRemain > 0 then
        self.timer = self:NewUITimer(function()
            l_guildData.guildCrystalInfo.getExeTimeRemain = l_guildData.guildCrystalInfo.getExeTimeRemain - 1
            if l_guildData.guildCrystalInfo.getExeTimeRemain <= 0 and self.timer then
                self:StopUITimer(self.timer)
                self.timer = nil
                --计时时间到了之后 重新请求水晶信息获取新的经验
                l_guildCrystalMgr.ReqGetGuildCrystalInfo()
            end
        end, 1, -1, true)
        self.timer:Start()
    end
end
--lua custom scripts end
return GuildCrystalStudyHandler