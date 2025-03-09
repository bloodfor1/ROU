--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildUpgradePanel"
require "UI/Template/GuildBuildingItemTemplate"
require "UI/Template/GuildBuildingScetionItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local l_guildData = nil
local l_guildBuildMgr = nil
local l_curBuildingId = 1  --当前选中的建筑ID 打开时默认为 1——大厅
local l_curData = nil  --当前选中的建筑的数据 包含id 名字 图集 介绍
local l_curInfo = nil  --当前选中建筑的在线信息 包括 id 等级 是否正在升级 升级剩余时间
local l_curDetail = nil --当前选中建筑的详细信息 包括 id 等级 是否满级 升级资金消耗 升级耗时 升级前置条件 属性选项A 属性选项B 属性选项C
local l_btnType = 1  --升级按钮类型 1升级 2参与建设
local l_upgradeTimeCount = 0  --升级剩余时间
local l_npcId = nil  --焦点的npc的id

--lua class define
local super = UI.UIBaseCtrl
GuildUpgradeCtrl = class("GuildUpgradeCtrl", super)
--lua class define end

--lua functions
function GuildUpgradeCtrl:ctor()

    super.ctor(self, CtrlNames.GuildUpgrade, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildUpgradeCtrl:Init()

    self.panel = UI.GuildUpgradePanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildBuildMgr = MgrMgr:GetMgr("GuildBuildMgr")

    self.isCreatedBuildPool = false  --是否已创建建筑选择列表 防止每次都重新设置数据 导致列表自己回到原始位置
    self.timer = nil --计时器

    --按钮事件绑定
    self:ButtonClickEventAdd()

    --公会建筑列表项的池创建
    self.guildBuildingTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildBuildingItemTemplate,
        TemplatePrefab = self.panel.GuildBuildingItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.BuildingScrollView.LoopScroll
    })
    --公会建筑功能预览列表池创建
    self.guildBuildingSectionTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildBuildingScetionItemTemplate,
        TemplatePrefab = self.panel.GuildBuildingScetionItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ScetionScrollView.LoopScroll
    })

    --初始化时隐藏预设的界面
    self.panel.NormalMsgPanel.UObj:SetActiveEx(false)
    self.panel.UpgradeCostPanel.UObj:SetActiveEx(false)
    self.panel.MaxLevelPanel.UObj:SetActiveEx(false)
    self.panel.UpgradingPanel.UObj:SetActiveEx(false)

    l_guildBuildMgr.ReqGuildBuildMsg()

end --func end
--next--
function GuildUpgradeCtrl:Uninit()

    self.curSelectedItem = nil
    self.isCreatedBuildPool = false
    
    l_curBuildingId = 1
    l_curData = nil
    l_curInfo = nil
    l_curDetail = nil
    l_btnType = 1
    l_npcId = nil
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, true)
    MPlayerInfo:FocusToMyPlayer()

    self.guildBuildingTemplatePool = nil
    self.guildBuildingSectionTemplatePool = nil

    l_guildBuildMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildUpgradeCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == l_guildData.EUIOpenType.GuildUpgrade then
            self:SetNpc(self.uiPanelData.npcId)
        end
    end

    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, false)
    if l_npcId then
        self:FocusToNpc()
    end

end --func end
--next--
function GuildUpgradeCtrl:OnDeActive()


end --func end
--next--
function GuildUpgradeCtrl:Update()


end --func end


--next--
function GuildUpgradeCtrl:OnReconnected()
    
    super.OnReconnected(self)
    if l_npcId and self:IsShowing() then
        self:FocusToNpc()
    end

end --func end
--next--
function GuildUpgradeCtrl:BindEvents()

    --获取新的公会建筑信息事件
    self:BindEvent(l_guildBuildMgr.EventDispatcher,l_guildBuildMgr.ON_GET_NEW_GUILD_BUILD_INFO,function(self)
        self:RefreshDetailPanel()
    end)
    --公会捐献/捐赠完成后事件
    self:BindEvent(l_guildBuildMgr.EventDispatcher,l_guildBuildMgr.ON_GUILD_BUILD_TIME_CHECK,function(self, lastTime)
        l_upgradeTimeCount = lastTime
        self.panel.TimeCount.LabText = l_guildBuildMgr.GetBuildLastTimeStr(l_upgradeTimeCount)
    end)
    --被踢出回调
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher,MgrMgr:GetMgr("GuildMgr").ON_GUILD_KICKOUT,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildUpgrade)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--设置NPC的ID
function GuildUpgradeCtrl:SetNpc(npcId)
    l_npcId = npcId
end

--NPC模型展示
function GuildUpgradeCtrl:FocusToNpc()

    if not l_npcId then
        return
    end

    local l_npc_entity = MNpcMgr:FindNpcInViewport(l_npcId)
    if l_npc_entity then
        local l_right_vec = l_npc_entity.Model.Rotation * Vector3.right
        local l_temp2 = -0.8
        MPlayerInfo:FocusToOrnamentBarter(l_npcId, l_right_vec.x * l_temp2, 1, l_right_vec.z * l_temp2, 4, 10, 5)
    else
        logError(StringEx.Format("找不到场景中的npc npc_id:{0}", l_npcId))
        return
    end

    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

--刷新展示界面
function GuildUpgradeCtrl:RefreshDetailPanel()
    l_curData = TableUtil.GetGuildBuildingTable().GetRowById(l_curBuildingId)
    l_curInfo = l_guildData.GetGuildBuildInfo(l_curBuildingId) or {}  --默认空表容错
    l_curDetail = TableUtil.GetGuildUpgradingTable().GetRowById(l_curData.Id * 100 + (l_curInfo.level or 1))
    --建筑列表展示
    if not self.isCreatedBuildPool then
        local l_buildDatas = TableUtil.GetGuildBuildingTable().GetTable()
        self.guildBuildingTemplatePool:ShowTemplates({Datas=l_buildDatas, Method=function(buildingItem)
                self:BuildingItemClick(buildingItem)
            end})
        self.isCreatedBuildPool = true
    else
        self.guildBuildingTemplatePool:RefreshCells()
    end
    if self.curSelectedItem ~= nil then self.curSelectedItem:SetSelect(true) end
    --调用界面展示
    self:ShowDetailPanel()
end

--界面展示
function GuildUpgradeCtrl:ShowDetailPanel()
    self.panel.NormalMsgPanel.UObj:SetActiveEx(true)
    self.panel.BuildImg:SetSprite(l_curData.ItemAtlas2D, l_curData.ItemIcon2D, true)
    self.panel.BuildingName.LabText = l_curData.Building
    self.panel.LevelText.LabText = StringEx.Format("<I>{0}</I>", l_curInfo.level or 1)
    self.panel.Introduction.LabText = l_curData.BriefIntroduction

    if l_curInfo.is_upgrading then  --如果正在升级
        self.panel.UpgradeCostPanel.UObj:SetActiveEx(false)
        self.panel.MaxLevelPanel.UObj:SetActiveEx(false)
        self.panel.UpgradingPanel.UObj:SetActiveEx(true)
        --倒计时显示
        l_upgradeTimeCount = l_curInfo.upgrade_left_time
        self.panel.TimeCount.LabText = l_guildBuildMgr.GetBuildLastTimeStr(l_upgradeTimeCount)
        if not self.timer then --记得销毁
            self.timer = self:NewUITimer(function()
                if self.panel then
                    self.panel.TimeCount.LabText = l_guildBuildMgr.GetBuildLastTimeStr(l_upgradeTimeCount)
                    l_upgradeTimeCount = l_upgradeTimeCount - 1
                    if l_upgradeTimeCount <= 0 and self.timer then
                        self:StopUITimer(self.timer)
                        self.timer = nil
                    end
                else
                    if self.timer then
                        self:StopUITimer(self.timer)
                        self.timer = nil
                    end
                end
            end,1,-1,true)
            self.timer:Start()
        end
        --属性栏标题修改
        self.panel.PreviewTitleText.LabText = Lang("UPGRADE_PREVIEW")
        --按钮变成参与建设
        l_btnType = 2
        self.panel.BtnUpgrade.UObj:SetActiveEx(true)
        self.panel.BtnUpgradeGray.UObj:SetActiveEx(false)
        self.panel.BtnUpgradeText.LabText = Lang("ATTEND_BUILD")
        --隐藏升级限制条件
        self.panel.Condition.UObj:SetActiveEx(false)

    else  --未在升级的情况
        self.panel.UpgradingPanel.UObj:SetActiveEx(false)
        if l_curDetail.isMaxLevel then  --如果已经满级
            self.panel.UpgradeCostPanel.UObj:SetActiveEx(false)
            self.panel.MaxLevelPanel.UObj:SetActiveEx(true)
            --属性栏标题修改
            self.panel.PreviewTitleText.LabText = Lang("CURRENT_EFFECTIVE")
            --显示灰色升级按钮
            self.panel.BtnUpgrade.UObj:SetActiveEx(false)
            self.panel.BtnUpgradeGray.UObj:SetActiveEx(true)
            --隐藏升级限制条件
            self.panel.Condition.UObj:SetActiveEx(false)

        else  --如果未满级
            self.panel.UpgradeCostPanel.UObj:SetActiveEx(true)
            self.panel.MaxLevelPanel.UObj:SetActiveEx(false)
            --显示升级限制条件
            self.panel.Condition.UObj:SetActiveEx(true)
            local l_limitCode = l_curDetail.UpgradingLimits
            if l_limitCode.Count == 0 then
                --如果限制条件为空 则显示空
                self.panel.Condition.LabText = ""
            else
                --解析限制条件
                local isAchieved = true
                local l_limitStr = "（"..Lang("NEED2")
                for i = 0, l_limitCode.Count - 1 do
                    local l_limitBuildingId = l_limitCode:get_Item(i, 0)
                    local l_limitBuildingLv = l_limitCode:get_Item(i, 1)
                    local l_limitStrTemp = StringEx.Format("{0} Lv.{1}", TableUtil.GetGuildBuildingTable().GetRowById(l_limitBuildingId).Building, l_limitBuildingLv)
                    if i > 0 then l_limitStr = l_limitStr.."、" end
                    l_limitStr = l_limitStr..l_limitStrTemp
                    --确认是否满足要求
                    if isAchieved then
                        for i = 1, #l_guildData.guildBuildInfo do
                            if l_guildData.guildBuildInfo[i].id == l_limitBuildingId and l_guildData.guildBuildInfo[i].level < l_limitBuildingLv then
                                isAchieved = false
                                break
                            end
                        end
                    end
                end
                l_limitStr = l_limitStr.."）"
                self.panel.Condition.LabText = l_limitStr
                --条件文字颜色设置
                if isAchieved then
                    self.panel.Condition.LabColor = Color.New(95/255.0, 183/255.0, 31/255.0)
                else
                    self.panel.Condition.LabColor = Color.New(235/255.0, 76/255.0, 78/255.0)
                end
            end
            --进度条参数赋值
            local l_curPercent = DataMgr:GetData("GuildData").guildBaseInfo.cur_money / l_curDetail.BankrollCost
            if DataMgr:GetData("GuildData").guildBaseInfo.cur_money >= l_curDetail.BankrollCost then
                self.panel.FundSlider.Slider.value = 1
            else
                self.panel.FundSlider.Slider.value = l_curPercent
            end
            self.panel.FundText.LabText = StringEx.Format(Lang("GUILD_UPDATE_COST_BAR_NUM_TEXT"), DataMgr:GetData("GuildData").guildBaseInfo.cur_money, l_curDetail.BankrollCost)
            --属性栏标题修改
            self.panel.PreviewTitleText.LabText = Lang("UPGRADE_PREVIEW")
            --按钮变成升级
            l_btnType = 1
            self.panel.BtnUpgrade.UObj:SetActiveEx(true)
            self.panel.BtnUpgradeGray.UObj:SetActiveEx(false)
            self.panel.BtnUpgradeText.LabText = Lang("UPGRADE")
        end
    end

    local l_sectionList = {}
    table.insert(l_sectionList, self:GetSection(l_curDetail.SectionA, l_curDetail.SectionAValue))
    table.insert(l_sectionList, self:GetSection(l_curDetail.SectionB, l_curDetail.SectionBValue))
    table.insert(l_sectionList, self:GetSection(l_curDetail.SectionC, l_curDetail.SectionCValue))

    self.guildBuildingSectionTemplatePool:ShowTemplates({Datas = l_sectionList})

end

--按钮点击事件绑定
function GuildUpgradeCtrl:ButtonClickEventAdd()
    --升级按钮
    self.panel.BtnUpgrade:AddClick(function()
        self:BtnUpgrade()
    end)
    --灰色升级按钮
    self.panel.BtnUpgradeGray:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILD_ALREADY_MAX_LEVEL"))
    end)
    --返回按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildUpgrade)
    end)
    --右箭头按钮
    self.panel.BtnArrowRight:AddClick(function()
        -- body
    end)
    --左箭头按钮
    self.panel.BtnArrowLeft:AddClick(function()
        -- body
    end)
end

--升级按钮点击
function GuildUpgradeCtrl:BtnUpgrade()
    if l_btnType == 1 then  --升级
        --权限确认
        if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Director then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PERMISSION_NOT_ENOUGH_NEED_DIRECTOR"))
            return
        end
        --是否有别的建筑正在升级确认
        for i = 1, #l_guildData.guildBuildInfo do
            if l_guildData.guildBuildInfo[i].is_upgrading then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_OTHER_BUILD_IS_UPGRADING"))
                return
            end
        end
        --前置条件确认
        local l_limitCode = l_curDetail.UpgradingLimits
        if l_limitCode.Count > 0 then
            for i = 0, l_limitCode.Count - 1 do
                local l_limitBuildingId = l_limitCode:get_Item(i, 0)
                local l_limitBuildingLv = l_limitCode:get_Item(i, 1)
                for i = 1, #l_guildData.guildBuildInfo do
                    if l_guildData.guildBuildInfo[i].id == l_limitBuildingId then
                        if l_guildData.guildBuildInfo[i].level < l_limitBuildingLv then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("GUILD_BUILD_UPGRADE_CONDITION_NOT_ENOUGH"),
                                    TableUtil.GetGuildBuildingTable().GetRowById(l_limitBuildingId).Building, l_limitBuildingLv))
                            return
                        end
                        break
                    end
                end
            end
        end
        --资金确认
        if MLuaCommonHelper.Long(DataMgr:GetData("GuildData").guildBaseInfo.cur_money) < MLuaCommonHelper.Long(l_curDetail.BankrollCost) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILD_UPGRADE_MONEY_NOT_ENOUGH"))
            return
        end
        --请求升级
        l_guildBuildMgr.ReqGuildBuildUpgrade(l_curBuildingId)

    else  --参与建设
        l_guildBuildMgr.OpenGuildAttendBuildPanel(tonumber(l_curDetail.Id))
    end
end

--获取属性文本
function GuildUpgradeCtrl:GetSection(sectionStr, sectionValueStr)
    if sectionStr and not string.ro_isEmpty(sectionStr) then
        local l_sectionValues = string.ro_split(sectionValueStr, "=")
        local l_valueCount = #l_sectionValues
        return StringEx.Format(sectionStr, unpack(l_sectionValues))
    else
        return nil
    end
end

--图标点击事件
function GuildUpgradeCtrl:BuildingItemClick(buildingItem)
    local l_buildingInfo = l_guildData.GetGuildBuildInfo(buildingItem.data.Id)
    if l_buildingInfo then
        -- 设置当前数据
        l_curData = buildingItem.data
        l_curBuildingId = l_curData.Id
        l_curInfo = l_buildingInfo
        l_curDetail = TableUtil.GetGuildUpgradingTable().GetRowById(l_curData.Id * 100 + (l_curInfo.level or 1))
        -- 界面展示方法调用
        self:ShowDetailPanel()
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then self.curSelectedItem:SetSelect(false) end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = buildingItem
        self.curSelectedItem:SetSelect(true)
    else
        --如果没有对应信息 则提示暂未开放
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_OPEN_PLEASE_WAITTING"))
        return
    end
end
--lua custom scripts end
return GuildUpgradeCtrl