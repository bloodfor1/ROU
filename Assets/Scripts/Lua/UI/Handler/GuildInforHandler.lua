--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildInforPanel"
require "UI/Template/GuildNewsItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
GuildInforHandler = class("GuildInforHandler", super)
--lua class define end

local l_guildMgr = nil
local l_guildData = nil
local l_guildCrystalMgr = nil
local l_guildSdkMgr = nil
local l_curIconId = 0
local l_guildCrystalLv = 0  --华丽水晶等级
local l_curNewsList = {}  --当前展示的新闻列表内容
local l_allNewsList = {} --全新闻数据列表
local l_curBelongTypeList = {} --存储筛选后的新闻列表
local l_pageItemNum = 20  --每页新闻数
local l_pageNo = 1 -- 当前页码
local l_bulletinType = 1  -- 公告栏展示的类型 1:公会公告  2:招募宣言
local l_guildGroupBtnType = 0 --公会绑群按钮的事件类型 0无 1创建 2解绑 3加入 4提醒
local l_curNewsType = nil

--lua functions
function GuildInforHandler:ctor()

    super.ctor(self, HandlerNames.GuildInfor, 0)

end --func end
--next--
function GuildInforHandler:Init()

    self.panel = UI.GuildInforPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    l_guildCrystalMgr = MgrMgr:GetMgr("GuildCrystalMgr")
    l_guildSdkMgr = MgrMgr:GetMgr("GuildSDKMgr")
    l_guildCrystalLv = 0
    l_guildGroupBtnType = 0
    l_curNewsType = l_guildData.ENewsType.News

    self.timerCrystalBuff = nil  --华丽水晶BUFF计时器申明

    --按钮点击事件绑定
    self:ButtonEventBind()

    --公会贡献动态赋值
    self.panel.DescribeText.LabText = Lang("GUILD_FUND_DESCRIBE")

    --公会新闻列表项的池创建
    self.guildNewsTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildNewsItemTemplate,
        TemplatePrefab = self.panel.GuildNewsItemPrefab.Prefab.gameObject,
        --TemplateParent = self.panel.NewsContent.transform
        ScrollRect=self.panel.NewsScrollView.LoopScroll
    })

    --绑群信息展示
    self:ShowGroupInfo()
    self:InitGuildSprit()
end --func end
--next--
function GuildInforHandler:Uninit()

    self.guildNewsTemplatePool = nil
    l_bulletinType = 1
    --重置新闻缓存
    l_curNewsList = {}
    l_allNewsList = {}
    l_pageNo = 1
    l_guildGroupBtnType = 0
    l_guildSdkMgr = nil
    l_guildMgr = nil
    l_guildData = nil
    l_guildCrystalMgr = nil
    l_curNewsType = nil
    self:ReleasePanel()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildInforHandler:OnActive()
    
	self.panel.InfoTitle.LabText = Lang("GUILD_NOTICE")
	self.panel.Obj_Img_Boli:SetActiveEx(false)

end --func end
--next--
function GuildInforHandler:OnDeActive()
    if self.GuildSpriteModel ~= nil then
        self:DestroyUIModel(self.GuildSpriteModel)
        self.GuildSpriteModel = nil
    end
    self:ReleaseTimer()
end --func end

-- 隐藏
function GuildInforHandler:OnHide()
    self.panel.DescribePanel.UObj:SetActiveEx(false)
end

-- 显示
function GuildInforHandler:OnShow()

    --请求公会信息 和 公会新闻
    l_guildMgr.ReqGuildInfo()
    l_guildMgr.ReqGuildNews()
    --请求建筑信息 华丽水晶等级实时更新用
    MgrMgr:GetMgr("GuildBuildMgr").ReqGuildBuildMsg()

end
--next--
function GuildInforHandler:Update()


end --func end


--next--
function GuildInforHandler:BindEvents()
    self:EventInit()
end --func end

--next--
--lua functions end

--lua custom scripts
--事件绑定
function GuildInforHandler:EventInit()

    --公会信息获取后事件
    self:BindEvent(l_guildMgr.EventDispatcher, l_guildMgr.ON_GET_GUILD_INFO, function(self)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        self:SetGuildInfo(l_guildData.guildBaseInfo)
    end)
    --公会建筑信息获取后事件
    self:BindEvent(MgrMgr:GetMgr("GuildBuildMgr").EventDispatcher, MgrMgr:GetMgr("GuildBuildMgr").ON_GET_NEW_GUILD_BUILD_INFO, 
        function(self)
            --销毁时生命周期引起的小概率异常容错
            if not self.panel.PanelRef then
                return
            end
            --更新华丽水晶等级
            self:SetGuildCrystalLevelInfo()
            --华丽水晶建筑等级大于0时请求最新的华丽水晶数据
            if l_guildCrystalLv > 0 then
                l_guildCrystalMgr.ReqGetGuildCrystalInfo()  
            end
        end)
    --公会华丽水晶信息获取后事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_GET_GUILD_CRYSTAL_INFO,
        function(self)
            --销毁时生命周期引起的小概率异常容错
            if not self.panel.PanelRef then
                return
            end
            --更新充能数据和水晶祈福BUFF数据
            self:SetGuildCrystalChargeInfo()
            self:SetGuildCrystalBuffInfo()
        end)
    --公会新闻获取后事件
    self:BindEvent(l_guildMgr.EventDispatcher, l_guildMgr.ON_GUILD_NEWS_GET, function(self, newsList)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        self:ShowGuildNewsNew(newsList)
    end)
    --公会图标修改后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_ICON_MODIFY,function(self, iconId)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(iconId)
        self.panel.GuildIcon:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
    end)
    --公会公告修改后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_NOTICE_MODIFY,function(self, newNotice)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        local l_noticeText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(newNotice)
        self.panel.Notice.LabText = l_noticeText
    end)
    --招募宣言修改后事件
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_WORDS_MODIFY,function(self, newWords)
        --销毁时生命周期引起的小概率异常容错
        if not self.panel.PanelRef then
            return
        end
        local l_wordsText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(newWords)
        self.panel.Words.LabText = l_wordsText
    end)

    --公会群状态展示事件
    -- self:BindEvent(l_guildSdkMgr.EventDispatcher,l_guildSdkMgr.ON_SHOW_GUILD_GROUP_STATUS,function(self)
    --     self:ShowGroupInfo()
    -- end)
    
    --从后台切回游戏事件
    self:BindEvent(l_guildSdkMgr.EventDispatcher,l_guildSdkMgr.ON_GET_BACK_GAME_TO_REFRESH,function(self)
        --logGreen("get back ctrl")
        if not l_guildMgr then
            return
        end
        --重新请求所有数据
        l_guildMgr.ReqGuildInfo()
        l_guildMgr.ReqGuildNews()
        --l_guildSdkMgr.ReqGuildGroupBindInfo()
    end)
end

--按钮点击事件绑定
function GuildInforHandler:ButtonEventBind()

    --公会图标点击
    self.panel.GuildIcon:AddClick(function(ctrl)
        local l_openData = {
            type = l_guildData.EUIOpenType.GuildIconSelect,
            iconId = l_guildData.guildBaseInfo.icon_id,
            openType = 1
        }
        UIMgr:ActiveUI(UI.CtrlNames.GuildIconSelect, l_openData)
    end)
    --公会华丽水晶信息按钮点击
    self.panel.BtnGuildCrystal:AddClick(function()
        if l_guildCrystalLv == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CRYSTAL_INFO_UNLOCK_TIP"))
        else
            self.panel.GuildCrystalPanel.UObj:SetActiveEx(true)
            self:SetGuildCrystalBuffInfo()  --实时获取BUFF信息
            l_guildCrystalMgr.ReqGetGuildCrystalInfo()  --请求最新的华丽水晶数据
        end
    end)
    --公会华丽水晶信息透明背景点击
    self.panel.GuildCrystalPanelBtn:AddClick(function()
        self.panel.GuildCrystalPanel.UObj:SetActiveEx(false)
    end)
     --公会华丽水晶信息界面前往按钮点击
    self.panel.BtnGoToCrystal:AddClick(function()
        --前往华丽水晶
        l_guildMgr.GuildFindPath_FuncId(l_guildData.EGuildFunction.GuildCrystal)
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
    end)
    --说明问号按钮点击
    self.panel.BtnInfo:AddClick(function()
        self.panel.DescribePanel.UObj:SetActiveEx(true)
    end)
    --说明界面点击关闭
    self.panel.DescribePanel:AddClick(function()
        self.panel.DescribePanel.UObj:SetActiveEx(false)
    end)
    --公告栏滑动切换内容
    self.panel.ContentView.Listener.endDrag=(function()
        self:SwitchBulletinType()
    end)
    --公告栏修改按钮点击
    self.panel.BtnMsgModify:AddClick(function()
        local l_openData = {
            type = l_guildData.EUIOpenType.GuildModifyInfor,
            bulletinType = l_bulletinType
        }
        UIMgr:ActiveUI(UI.CtrlNames.GuildModifyInfor, l_openData)
    end)
    --回到公会按钮点击
    self.panel.BtnEnter:AddClick(function()
        
        if MScene.SceneID ~= l_guildData.GUILD_SCENE_ID then
            if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                l_guildMgr.ReqEnterGuildScene()
                UIMgr:DeActiveUI(UI.CtrlNames.Guild)
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_IN_GUILD_SCENE"))
        end
            
    end)
    --公会群按钮点击
    self.panel.BtnGuildGroup:AddClick(function()
        if l_guildGroupBtnType == 1 then
            --创建
            l_guildSdkMgr.ReqCreateGuildGroup()
        elseif l_guildGroupBtnType == 2 then
            --解绑
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("ENSURE_UNBIND_GUILD_GROUP"), function()
                l_guildSdkMgr.ReqUnbindGuildGroup()
            end)
        elseif l_guildGroupBtnType == 3 then
            --加入
            l_guildSdkMgr.ReqJoinGuildGroup()
        elseif l_guildGroupBtnType == 4 then
            --提醒
            l_guildSdkMgr.ReqRemindChairmanToBindGroup()
        end
    end)
    --[[--公会朋友圈按钮点击
    self.panel.BtnFriend:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_OPEN_PLEASE_WAITTING"))
    end)--]]

    self.panel.GuildSprite:SetActiveEx(false)
    self.panel.ScreenPanel:SetActiveEx(false)
    --是否打开精灵
    self.panel.Tog_GuildSprite.Tog.isOn = false
    self.panel.Tog_GuildSprite:OnToggleChanged(function(value)
        self.panel.GuildSprite.gameObject:SetRectTransformPos(l_guildMgr.gSpriteInitPos.x,l_guildMgr.gSpriteInitPos.y)
        self.panel.GuildSprite:SetActiveEx(value)
        if value then
            self.panel.Container:SetActiveEx(false)
            self:SetupSpriteTimer()
        end
    end)
    --筛选
    self.panel.Btn_Screen:AddClick(function()
        if self.typeTog == nil or table.maxn(self.typeTog) == 0 then
            self.panel.ScreenPanel:SetActiveEx(false)
            return
        end
        self.panel.ScreenPanel:SetActiveEx(true)
        if self.typeTog then
            for i = 1, table.maxn(self.typeTog) do
                if self.typeTog[i].ui then
                    self.typeTog[i].TogCom.Tog.isOn = true
                end
            end
        end
    end)
    self.panel.Btn_CloseScreen:AddClick(function()
        self.panel.ScreenPanel:SetActiveEx(false)
    end)
    --新闻
    self.panel.Tog_News:OnToggleExChanged(function(value)
        if value then
            l_curNewsType = l_guildData.ENewsType.News
            self:ShowNewsByNewsType()
        end
    end)
    --点滴
    self.panel.Tog_Infos:OnToggleExChanged(function(value)
        if value then
            l_curNewsType = l_guildData.ENewsType.NewsDrop
            self:ShowNewsByNewsType()
        end
    end)
end

--公会信息界面设置公会信息
function GuildInforHandler:SetGuildInfo(info)

    if info.icon_id and info.name and info.chairman and info.chairman.base_info and info.level and info.total_member and info.cur_member then
        --数据都则存在无操作
    else
        --存在必要数据为空数据的情况这里统一做报错日志  目前会偶先服务器数据完全不可信的情况
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_ERROR_FROM_SERVER"))
        logError("报错日志: 服务器传回数据为空 错误ID为 "..tostring(info.id))
        --这里不做returen 后面所有数据都加了容错
    end

    local l_iconId = info.icon_id or 1  --加容错 防止服务器传回为空导致报错
    local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(l_iconId)
    self.panel.GuildIcon:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)

    self.panel.GuildName.LabText = info.name or "--"
    self.panel.GuildID.LabText = StringEx.Format(Lang("GUILD_ID"), tostring(info.id or "--"))

    if info.chairman and info.chairman.base_info then
        if info.chairman.base_info.sex ~= 0 then
            self.panel.ChairmanSexIcon:SetSprite("Common", "UI_Common_TypeFemale.png", true)
        else
            self.panel.ChairmanSexIcon:SetSprite("Common", "UI_Common_TypeMale.png", true)
        end
        self.panel.ChairmanName.LabText = info.chairman.base_info.name or "--"
    end

    self.panel.GuildLv.LabText = "Lv."..(info.level or "--")
    self.panel.MemberNum.LabText = (info.cur_member or "--").."/"..(info.total_member or "--")

    --资金处要修改 目前只显示当前数量
    self.panel.FundTxt.LabText = tostring(info.cur_money).."/"..tostring(info.total_money)
    if MLuaCommonHelper.Long(info.cur_money) == MLuaCommonHelper.Long(info.total_money) then
        self.panel.FundTxt.LabColor = Color.New(255/255.0, 79/255.0, 79/255.0)
    else
        self.panel.FundTxt.LabColor = Color.New(85/255.0, 153/255.0, 236/255.0)
    end

    --self.panel.GuildActivity.LabText = info.activeness
    --announce 公告  declaration 宣言
    local l_noticeText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(info.announce or "")
    self.panel.Notice.LabText = l_noticeText
    local l_wordsText = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(info.declaration or "")
    self.panel.Words.LabText = l_wordsText

    --如果不是管理人员职位则不显示公告栏修改按钮 图标按钮不可点击
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Director then
        self.panel.BtnMsgModify.UObj:SetActiveEx(false)
        self.panel.GuildIcon.Btn.interactable = false
    end

    --华丽水晶数据相关设置
    self:SetGuildCrystalLevelInfo()
    self:SetGuildCrystalBuffInfo()
end

--设置公会华丽水晶等级相关数据
function GuildInforHandler:SetGuildCrystalLevelInfo()
    --华丽水晶的等级显示
    local l_guildCrystalInfo = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal)
    l_guildCrystalLv = l_guildCrystalInfo and l_guildCrystalInfo.level or 0
    self.panel.GuildCrystalLv.LabText = tostring(l_guildCrystalLv)
    self.panel.CrystalTitle.LabText = Lang("GUILD_CRYSTAL_INFO_TITLE", l_guildCrystalLv)
end

--设置华丽水晶充能相关内容
function GuildInforHandler:SetGuildCrystalChargeInfo()
    --当前充能的华丽水晶名称获取
    local l_curChargedCrystalNames = ""
    for i = 1, 6 do
        local l_crystalInfo = l_guildData.GetCrystalInfo(i)
        if l_crystalInfo.isCharged then
            local l_crystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_crystalInfo.id)
            l_curChargedCrystalNames = l_curChargedCrystalNames..Lang(l_crystalData.CrystalName).." "
        end
    end
    self.panel.TxtCrysatlCharge.LabText = #l_curChargedCrystalNames > 0 and l_curChargedCrystalNames or Lang("NONE")
end

--设置华丽水晶BUFF相关内容
function GuildInforHandler:SetGuildCrystalBuffInfo()
    --判断华丽水晶功能是否开启
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_guildData.EGuildFunction.GuildCrystal) then
        self.panel.BtnGuildCrystal.UObj:SetActiveEx(false)
        return
    end

    --判断当前是否有华丽水晶的BUFF
    if l_guildData.guildCrystalInfo.buffLeftTime > 0 then
        self.panel.BtnGuildCrystal:SetGray(false)
        self.panel.BuffNone.UObj:SetActiveEx(false)
        self.panel.BuffTime.UObj:SetActiveEx(true)
        self.panel.BuffProperty.UObj:SetActiveEx(true)
        --Buff属性列表获取
        local l_buffAttrList = l_guildData.guildCrystalInfo.buffAttrList
        for i = 1, 3 do
            if i <= #l_buffAttrList then
                --参数赋值
                self.panel.BuffPropertyBox[i].UObj:SetActiveEx(true)
                local l_buffAttr = l_guildData.guildCrystalInfo.buffAttrList[i]
                local l_attrRow = TableUtil.GetAttrDecision().GetRowById(l_buffAttr.attr_type)
                if l_attrRow then
                    local l_isPercentage = l_attrRow.TipParaEnum == 1  --是否是百分比数据
                    local l_value = l_buffAttr.attr_value
                    if l_buffAttr.attr_extra_value and l_buffAttr.attr_extra_value > 0 then
                        l_value = l_value + l_buffAttr.attr_extra_value
                    end
                    self.panel.BuffName[i].LabText = StringEx.Format(l_attrRow.TipTemplate, "")
                    self.panel.BuffValue[i].LabText = l_isPercentage and "+"..tostring(l_value / 100).."%" or "+"..tostring(l_value)
                end
            else
                self.panel.BuffPropertyBox[i].UObj:SetActiveEx(false)
            end
        end
        --华丽水晶倒计时
        self:SetCrystalBuffTimer()
    else
        --无BUFF时 属性栏展示提示
        self.panel.BtnGuildCrystal:SetGray(true)
        self.panel.BuffNone.UObj:SetActiveEx(true)
        self.panel.BuffTime.UObj:SetActiveEx(false)
        self.panel.BuffProperty.UObj:SetActiveEx(false)
    end
end

--设置华丽水晶BUFF的倒计时
function GuildInforHandler:SetCrystalBuffTimer()
    if not self.timerCrystalBuff and l_guildData.guildCrystalInfo.buffLeftTime > 0 then
        local l_day, l_hour, l_minuite = l_guildCrystalMgr.GetCrystalBuffTimerTime(l_guildData.guildCrystalInfo.buffLeftTime)
        self.panel.BuffTime.LabText = Lang("LAST_TIME_D_H_M_WITH_BRACKETS", l_day, l_hour, l_minuite)
        self.timerCrystalBuff = self:NewUITimer(function()
            l_guildData.guildCrystalInfo.buffLeftTime = l_guildData.guildCrystalInfo.buffLeftTime - 1
            if l_guildData.guildCrystalInfo.buffLeftTime <= 0 and self.timerCrystalBuff then
                self.timerCrystalBuff:Stop()
                self.timerCrystalBuff = nil
                self.panel.BuffTime.UObj:SetActiveEx(false)
                --计时时间到了之后 重新请求水晶信息获取新的经验
                l_guildCrystalMgr.ReqGetGuildCrystalInfo()
                return
            end
            local l_day, l_hour, l_minuite = l_guildCrystalMgr.GetCrystalBuffTimerTime(l_guildData.guildCrystalInfo.buffLeftTime)
            self.panel.BuffTime.LabText = Lang("LAST_TIME_D_H_M_WITH_BRACKETS", l_day, l_hour, l_minuite)
        end,1,-1,true)
        self.timerCrystalBuff:Start()
    end
end

--设置华丽水晶BUFF相关内容
-- function GuildInforHandler:SetGuildCrystalBuffInfo()
--     --当前身上的华丽水晶BUFF属性获取
--     local l_crystalBuffInfo = nil
--     local l_allBuffInfo = MgrMgr:GetMgr("BuffMgr").g_playerAddBuffInfo
--     for i = 1, #l_allBuffInfo do
--         local l_buffInfo = l_allBuffInfo[i]
--         if l_buffInfo.tableInfo and l_buffInfo.tableInfo.Id == l_guildData.GUILD_CRYSTAL_BUFF_ID then
--             l_crystalBuffInfo = l_buffInfo
--             break
--         end
--     end
--     --界面华丽水晶信息展示按钮颜色设置（无BUFF时置灰 有BUFF时亮起）
--     self.panel.BtnGuildCrystal:SetGray(l_crystalBuffInfo == nil)

--     --华丽水晶祈福BUFF属性获取
--     local l_buffPropertyInfos = {}
--     if l_crystalBuffInfo then
--         if l_crystalBuffInfo.buffAttrDecision ~= nil then
--             local l_itor = l_crystalBuffInfo.buffAttrDecision:GetEnumerator()
--             while l_itor:MoveNext() do
--                 local l_k = l_itor.Current.Key
--                 local l_v = tonumber(l_itor.Current.Value)
--                 local l_attrRow = TableUtil.GetAttrDecision().GetRowById(l_k)
--                 if l_attrRow then
--                     local l_buffPropertyInfo = {}
--                     local l_isPercentage = l_attrRow.TipParaEnum == 1  --是否是百分比数据
--                     l_buffPropertyInfo.name = StringEx.Format(l_attrRow.TipTemplate, "")
--                     l_buffPropertyInfo.value = l_isPercentage and "+"..tostring(l_v / 100).."%" or "+"..tostring(l_v)
--                     table.insert(l_buffPropertyInfos, l_buffPropertyInfo)
--                 end
--             end
--         end
--     end
--     --华丽水晶信息界面祈福BUFF属性展示
--     self.panel.BuffNone.UObj:SetActiveEx(#l_buffPropertyInfos == 0)
--     for i = 1, 3 do
--         if i > #l_buffPropertyInfos then
--             self.panel.BuffPropertyBox[i].UObj:SetActiveEx(false)
--         else
--             self.panel.BuffPropertyBox[i].UObj:SetActiveEx(true)
            
--         end
--     end
-- end

--公告面板左右拖拽 切换内容
function GuildInforHandler:SwitchBulletinType()
    if l_bulletinType == 1 then
        --当前是公会公告 往左拉切换到招募宣言
        if self.panel.NoticeBox.RectTransform.localPosition.x < -50 then
            self.panel.InfoTitle.LabText = Lang("GUILD_RECRUITWORDS")
            -- self.panel.SwitchNotice.Img.color = Color.New(227/255.0, 214/255.0, 185/255.0)
            -- self.panel.SwitchWords.Img.color = Color.New(223/255.0, 197/255.0, 141/255.0)
            self.panel.WordsBox.Transform:SetParent(self.panel.ContentView.Transform)
            self.panel.NoticeBox.Transform:SetParent(self.panel.WordsBox.Transform)
            self.panel.ContentView.Scroll.content = self.panel.WordsBox.RectTransform
            l_bulletinType = 2
            self.panel.SwitchWordsOn.gameObject:SetActiveEx(true)
            self.panel.SwitchNoticeOn.gameObject:SetActiveEx(false)
        end
    else
        --当前是招募宣言 往右拉切换到公会公告
        if self.panel.WordsBox.RectTransform.localPosition.x > 50 then
            self.panel.InfoTitle.LabText = Lang("GUILD_NOTICE")
            -- self.panel.SwitchNotice.Img.color = Color.New(223/255.0, 197/255.0, 141/255.0)
            -- self.panel.SwitchWords.Img.color = Color.New(227/255.0, 214/255.0, 185/255.0)
            self.panel.NoticeBox.Transform:SetParent(self.panel.ContentView.Transform)
            self.panel.WordsBox.Transform:SetParent(self.panel.NoticeBox.Transform)
            self.panel.ContentView.Scroll.content = self.panel.NoticeBox.RectTransform
            l_bulletinType = 1
            self.panel.SwitchWordsOn.gameObject:SetActiveEx(false)
            self.panel.SwitchNoticeOn.gameObject:SetActiveEx(true)
        end
    end
end


--公会新闻展示
--newsList 新闻数据列表
function GuildInforHandler:ShowGuildNewsNew(newsList)
    --重置缓存
    l_curNewsList = {}  --当前展示的新闻列表内容
    l_allNewsList = {}  --全新闻数据列表
    l_pageNo = 1

    for i=1,#newsList do
        local l_isDataRight = true  --用于确认数据是否正确
        local l_newsId = newsList[i].type
        local l_msgData,l_content,l_params,l_localArgs,l_extraLinkData = MgrMgr:GetMgr("MessageRouterMgr").GetMessageContent(newsList[i].id, nil, newsList[i])
        if not l_msgData then return false end
        local l_newsInfo = TableUtil.GetGuildNewsTable().GetRowByNewsID(l_newsId)
        local l_newsData = {}
        local l_newsBelong = Common.Functions.SequenceToTable(l_newsInfo.NewsBelong)
        --存储是点滴还是新闻
        l_newsData.newsShowType = (l_newsBelong[1] ~= 1) and l_guildData.ENewsType.News or l_guildData.ENewsType.NewsDrop
        --存储具体的筛选类型
        l_newsData.newsBelongType = l_newsBelong[2]
        --存储新闻的具体显示类型
        l_newsData.newsType = l_newsInfo.NewsType
        --表格数据
        l_newsData.tableData = l_newsInfo
        --策划配置数据
        l_newsData.belongTypeData = l_guildMgr.GetGuildBelongTypeData(l_newsData.newsBelongType)
        l_newsData.content = l_content
        l_newsData.extraLinkData = l_extraLinkData
        l_newsData.announceData = newsList[i]
        --正确的数据加入缓存数据表中
        if l_isDataRight then
            table.insert(l_allNewsList, l_newsData)
            if i <= l_pageItemNum then
                table.insert(l_curNewsList, l_newsData)
            end
        end
    end
    self:ShowNewsByNewsType()
end

--公会新闻展示
--newsList 新闻数据列表
function GuildInforHandler:ShowGuildNews(newsList)
    --重置缓存
    l_curNewsList = {}  --当前展示的新闻列表内容
    l_allNewsList = {}  --全新闻数据列表
    l_pageNo = 1

    for i=1,#newsList do
        local l_isDataRight = true  --用于确认数据是否正确
        local l_newsId = newsList[i].type

        local l_msgData,l_content = MgrMgr:GetMgr("MessageRouterMgr").OnMessage(newsList[i].id, nil, newsList[i])
        if not l_msgData then return false end

        local l_newsInfo = TableUtil.GetGuildNewsTable().GetRowByNewsID(l_newsId)
        local l_newsArgs = {}
        --[[
        for i, v in ipairs(newsList[i].args.local_name_list) do
            table.insert(l_newsArgs, Lang(v))
        end
        ]]--
        local l_msgData = TableUtil.GetMessageTable().GetRowByID(l_newsInfo.NewsContent)
        local l_newsData = {}
        local l_newsBelong = Common.Functions.SequenceToTable(l_newsInfo.NewsBelong)
        --存储是点滴还是新闻
        l_newsData.newsShowType = (l_newsBelong[1] ~= 1) and l_guildData.ENewsType.News or l_guildData.ENewsType.NewsDrop
        --存储具体的筛选类型
        l_newsData.newsBelongType = l_newsBelong[2]
        --存储新闻的具体显示类型
        l_newsData.newsType = l_newsInfo.NewsType
        --表格数据
        l_newsData.tableData = l_newsInfo
        --策划配置数据
        l_newsData.belongTypeData = l_guildMgr.GetGuildBelongTypeData(l_newsData.newsBelongType)
        l_newsData.content = l_msgData.Content
        --[[
        if l_newsData.newsType == 1 then
            --%s创建了【%s】公会！
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2], l_newsArgs[3])
        elseif l_newsData.newsType == 2 or l_newsData.newsType == 4 then
            --%s修改了公会宣言。
            --%s加入了公会，热烈欢迎～
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2])
        elseif l_newsData.newsType == 3 then
            --%s表现出众，被任命为%s。
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            l_newsArgs[3] = l_guildData.GetPositionName(tonumber(l_newsArgs[3]))
            l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2], l_newsArgs[3])
        elseif l_newsData.newsType == 6 then
            --厉害了，恭喜%s解锁了【%s】成就
            --参数顺序 玩家ID 玩家名 成就的id rid time
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            --成就超链接处理
            l_newsData.achievementId = tonumber(l_newsArgs[3])
            l_newsData.rid = l_newsArgs[4]
            l_newsData.time = l_newsArgs[5]
            local l_row = TableUtil.GetAchievementDetailTable().GetRowByID(tonumber(l_newsArgs[3]))
            if l_row then
                local l_achievementName = l_row.Name
                local l_achievementLink = StringEx.Format("<a href=ShowAchievementDetail>{0}</a>", GetColorText(l_achievementName, RoColorTag.Blue))
                l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2], l_achievementLink)
            else
                l_isDataRight = false
            end
        elseif l_newsData.newsType == 7 then
            --%s竟然将%s精炼至%s级，变得更强了呢
            --参数顺序 玩家ID 玩家名 装备的id uid rid 强化等级
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            --装备超链接处理
            l_newsData.uid = l_newsArgs[4]
            l_newsData.rid = l_newsArgs[5]
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_newsArgs[3]))
            if l_itemRow then
                local l_equipLink = StringEx.Format("<a href=ShowEquipDetail>{0}</a>", GetColorText(l_itemRow.ItemName, RoColorTag.Blue))
                l_equipLink = GetImageText(l_itemRow.ItemIcon, l_itemRow.ItemAtlas) .. l_equipLink
                l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2], l_equipLink, l_newsArgs[6])
            else
                l_isDataRight = false
            end
        elseif l_newsData.newsType == 10 then
            --%s慷慨解囊，为公会华丽水晶购买了%s研究经验，太感谢了。
            --参数顺序 玩家ID 玩家名 经验值
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2] = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2], l_newsArgs[3])
        elseif l_newsData.newsType == 11 then
            --{0}慷慨解囊，在公会宴会为大家开启了香槟祝福，太感谢了。
            --参数顺序 玩家ID 玩家名
            l_newsData.playerId = l_newsArgs[1]
            l_newsArgs[2]  = StringEx.Format("<a href=ShowPlayerDetail>{0}</a>", GetColorText(l_newsArgs[2], RoColorTag.Blue))
            l_newsData.content = StringEx.Format(l_msgData.Content, l_newsArgs[2])
        else
            --无超链接类型
            --经过大家的共同努力，公会%s等级提升到%s级了！
            l_newsData.content = StringEx.Format(l_msgData.Content, unpack(l_newsArgs))
        end
        ]]--
        --正确的数据加入缓存数据表中
        if l_isDataRight then
            table.insert(l_allNewsList, l_newsData)
            if i <= l_pageItemNum then
                table.insert(l_curNewsList, l_newsData)
            end
        end
    end

    -- self.guildNewsTemplatePool:ShowTemplates({Datas = l_curNewsList})
    -- self.guildNewsTemplatePool:ShowTemplates({Datas = l_allNewsList})
    self:ShowNewsByNewsType()
end

--根据新闻类型显示新闻
--isBelong主要用于处理筛选的类型
function GuildInforHandler:ShowNewsByNewsType(isBelong)
    local l_finShowList = {}
    local l_TypeShowList= {}
    for index, value in ipairs(l_allNewsList) do
        if value.newsShowType == l_curNewsType then
            if isBelong then
                if l_curBelongTypeList[value.newsBelongType] then
                    table.insert(l_finShowList,value)
                end
            else
                table.insert(l_finShowList,value)
            end
            if l_curNewsType == l_guildData.ENewsType.News then
                if l_TypeShowList[value.newsBelongType] == nil then
                    l_TypeShowList[value.newsBelongType] = {}
                end
                if isBelong then
                    table.insert(l_TypeShowList[value.newsBelongType],value)
                end
            elseif l_curNewsType == l_guildData.ENewsType.NewsDrop then
                if l_TypeShowList[value.newsBelongType] == nil then
                    l_TypeShowList[value.newsBelongType] = {}
                end
                table.insert(l_TypeShowList[value.newsBelongType],value)
            end
        end
    end
    if not isBelong then
        self:CreateScreenPanel(l_TypeShowList)
    end
    self.panel.Obj_Img_Boli:SetActiveEx(#l_finShowList==0)
    self.guildNewsTemplatePool:ShowTemplates({Datas = l_finShowList})
end

--列表展示增页
function GuildInforHandler:AddNewsShow()

    local l_allNum = #l_allNewsList  --最大数量
    local l_nextPageMaxIndex = (l_pageNo + 1) * l_pageItemNum  --下一页索引最大值
    local l_lastIndex = l_nextPageMaxIndex > l_allNum and l_allNum or l_nextPageMaxIndex  --取两者较小者

    for i = l_pageNo * l_pageItemNum + 1, l_lastIndex do
        self.guildNewsTemplatePool:AddTemplate(l_allNewsList[i],
        self.panel.GuildNewsItemPrefab.Prefab.gameObject)
    end

    l_pageNo = l_pageNo + 1  -- 当前页数加1
end

--初始化公会精灵
function GuildInforHandler:InitGuildSprit()

    local l_clipPath = MAnimationMgr:GetClipPath("NPC_F_GongHuiJiXiangWu_Idle")
    local l_modelData = {
        prefabPath = "Prefabs/NPC_F_GongHuiJiXiangWu",
        rawImage = self.panel.GuildRawImage.RawImg,
        defaultAnim = l_clipPath,
    }
    self.GuildSpriteModel = self:CreateUIModelByPrefabPath(l_modelData)

    self.panel.GuildSprite.Listener.onDrag=(function(go,eventData)
        local targetPos = Common.CommonUIFunc.GetScreenDragPos(self.panel.GuildSprite.RectTransform,eventData.position)
        local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(targetPos)
        l_cgPos.z = 0
        self.panel.GuildSprite.RectTransform.position = l_cgPos
    end)
end

--喵喵随机对话框
function GuildInforHandler:SetupSpriteTimer()
    self:ReleaseTimer()
    local randomNextTime = function()
        math.randomseed(Common.TimeMgr.GetUtcTimeByTimeTable())
        return math.random(l_guildMgr.gSpriteShoutTime,l_guildMgr.gSpriteWaitTime)
    end
    --间隔
    self.roundSpineTimer = self:NewUITimer(function()
        local str = self:GetSpriteTalkInfo()
        if str then
            self.panel.Container:SetActiveEx(true)
            self.panel.GuildSpriteTxt.LabText = str
        end
        self:StopUITimer(self.roundSpineTimer)
        self.roundSpineTimer.duration = randomNextTime()
        self.textTimer:Start()
    end, randomNextTime(), -1, true)
    
    --喊话持续时间
    self.textTimer = self:NewUITimer(function()
        self.panel.Container:SetActiveEx(false)
        self:StopUITimer(self.textTimer)
        self.roundSpineTimer:Start()
    end,randomNextTime(), -1, true)

    self.roundSpineTimer:Start()
end

--获取随机获取精灵汉化内容
function GuildInforHandler:GetSpriteTalkInfo()
    local l_finTallList = {}
    local totalWeight = 0
    for index, value in ipairs(l_allNewsList) do
        if value.tableData.TalkWeight > 0 then
            value.talkSmalWeight = totalWeight
            totalWeight = totalWeight + value.tableData.TalkWeight
            value.talkBigWeight = totalWeight
            table.insert(l_finTallList,value)
        end
    end
    math.randomseed(Common.TimeMgr.GetUtcTimeByTimeTable())
    local weightIndex = math.random(0,totalWeight)
    for index, value in ipairs(l_finTallList) do
        if weightIndex >= value.talkSmalWeight and weightIndex < value.talkBigWeight then
            return value.content
        end
    end
    return nil
end

--初始化筛选界面
function GuildInforHandler:CreateScreenPanel(typeShowList)
    self:ReleasePanel()
    self.typeTog = {}
    local i = 1
    for key, value in pairs(typeShowList) do
        self.typeTog[i] = {}
        self.typeTog[i].ui = self:CloneObj(self.panel.Tog_Type.gameObject)
        self.typeTog[i].ui.transform:SetParent(self.panel.Tog_Type.transform.parent)
        self.typeTog[i].ui.transform:SetLocalScaleOne()
        self.typeTog[i].ui:SetActiveEx(true)
        self:ExportElement(self.typeTog[i])
        local l_belongTypeData = l_guildMgr.GetGuildBelongTypeData(key)
        self.typeTog[i].Text.LabText = Lang(l_belongTypeData.belongTypeName)
        self.typeTog[i].Icon:SetSprite(l_belongTypeData.belongTypeAtlas,l_belongTypeData.belongTypeSprite)
        -------------默认为全选-----------------
        if l_curBelongTypeList[key] == nil then
            l_curBelongTypeList[key] = {}
        end
        self.typeTog[i].TogCom.Tog.isOn = true
        ---------------------------------------
        self.typeTog[i].TogCom:OnToggleChanged(function(togValue)
            if togValue then
                if l_curBelongTypeList[key] == nil then
                    l_curBelongTypeList[key] = {}
                end
            else
                if l_curBelongTypeList[key] ~= nil then
                    l_curBelongTypeList[key] = nil
                end
            end
            self:ShowNewsByNewsType(true)
        end)
        i = i + 1
    end
    self.panel.Tog_Type.gameObject:SetActiveEx(false)
end

function GuildInforHandler:ReleaseTimer()

    if self.timerCrystalBuff then
        self.timerCrystalBuff:Stop()
        self.timerCrystalBuff = nil
    end

    if self.roundSpineTimer then
        self:StopUITimer(self.roundSpineTimer)
    end

    if self.textTimer then
        self:StopUITimer(self.textTimer)
    end
    self.roundSpineTimer = nil
    self.textTimer = nil
end

function GuildInforHandler:ExportElement(element)
    element.Icon = element.ui.transform:Find("Img_Background/Img_TypeIcon"):GetComponent("MLuaUICom")
    element.Text = element.ui.transform:Find("Img_Background/Tog_TypeTxt"):GetComponent("MLuaUICom")
    element.TogCom = element.ui.transform:GetComponent("MLuaUICom")
end

function GuildInforHandler:ReleasePanel()
    if self.typeTog then
        for i = 1, table.maxn(self.typeTog) do
            if self.typeTog[i].ui then
                MResLoader:DestroyObj(self.typeTog[i].ui)
            end
        end
        self.typeTog = nil
    end
end

--绑群相关内容暂时
function GuildInforHandler:ShowGroupInfo()

    --非移动平台不展示按钮
    -- if not (Application.isMobilePlatform and tonumber(l_guildData.zoneId) >= 8001 and tonumber(l_guildData.zoneId) <= 8004) then
    self.panel.GuildGroupState.LabText = Lang("NO_BINDED")
    self.panel.BtnGuildGroup.UObj:SetActiveEx(false)
    return
    -- end

    -- --初始化按钮类型
    -- l_guildGroupBtnType = 0
    -- --根据绑群情况判断
    -- if l_guildData.selfGuildMsg.guildGroupBindState then
    --     --有群
    --     self.panel.GuildGroupState.LabText = Lang("BINDED")
    --     if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
    --         --会长
    --         self.panel.BtnGuildGroup.UObj:SetActiveEx(true)
    --         self.panel.BtnGuildGroupText.LabText = Lang("UNBIND")
    --         l_guildGroupBtnType = 2
    --     else
    --         --非会长
    --         if l_guildData.selfGuildMsg.isJoinedGroup then
    --             --已加入
    --             self.panel.BtnGuildGroup.UObj:SetActiveEx(false)
    --         else
    --             --未加入
    --             self.panel.BtnGuildGroup.UObj:SetActiveEx(true)
    --             self.panel.BtnGuildGroupText.LabText = Lang("JOIN_TEAMOFFER")
    --             l_guildGroupBtnType = 3
    --         end
    --     end
    -- else
    --     --无群
    --     self.panel.GuildGroupState.LabText = Lang("NO_BINDED")
    --     if l_guildData.GetSelfGuildPosition() == l_guildData.EPositionType.Chairmen then
    --         --会长
    --         self.panel.BtnGuildGroup.UObj:SetActiveEx(true)
    --         self.panel.BtnGuildGroupText.LabText = Lang("CREATE_GUILD_GROUP")
    --         l_guildGroupBtnType = 1
    --     else
    --         --非会长 只有QQ平台需要显示提醒
    --         local l_loginret = MLogin.GetLoginData()
    --         if l_loginret and l_loginret.flag == EFlag.eFlag_Succ then
    --             if l_loginret.platform == EPlatform.ePlatform_QQ then
    --                 --QQ平台
    --                 self.panel.BtnGuildGroup.UObj:SetActiveEx(true)
    --                 self.panel.BtnGuildGroupText.LabText = Lang("REMIND")
    --                 l_guildGroupBtnType = 4
    --                 return
    --             end
    --         end
    --         self.panel.BtnGuildGroup.UObj:SetActiveEx(false)
    --     end
    -- end

end
--lua custom scripts end
return GuildInforHandler