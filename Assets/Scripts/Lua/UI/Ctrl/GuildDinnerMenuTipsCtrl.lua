--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildDinnerMenuTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GuildDinnerMenuTipsCtrl = class("GuildDinnerMenuTipsCtrl", super)
--lua class define end

--lua functions
function GuildDinnerMenuTipsCtrl:ctor()
    
    super.ctor(self, CtrlNames.GuildDinnerMenuTips, UILayer.Function, nil, ActiveType.None)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent
    self.ClosePanelNameOnClickMask=UI.CtrlNames.GuildDinnerMenuTips

end --func end
--next--
function GuildDinnerMenuTipsCtrl:Init()
    
    self.panel = UI.GuildDinnerMenuTipsPanel.Bind(self)
    super.Init(self)

    self.isEatAlready = false
end --func end
--next--
function GuildDinnerMenuTipsCtrl:Uninit()

    self.isEatAlready = false

    self:clearModels()
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function GuildDinnerMenuTipsCtrl:OnActive()
    
    if self.uiPanelData then
        local l_guildData = DataMgr:GetData("GuildData")
        if self.uiPanelData.type == l_guildData.EUIOpenType.GuildDinnerMenuTips then
            local l_dishData = self.uiPanelData.dishData
            self:SetDinnerMenuTipsData(l_dishData.makers, l_dishData.dishCount, 
                tonumber(tostring(l_dishData.costTime)), self.uiPanelData.isEated)
        end
    end

end --func end
--next--
function GuildDinnerMenuTipsCtrl:OnDeActive()
    
    
end --func end
--next--
function GuildDinnerMenuTipsCtrl:Update()
    
    
end --func end

--next--
function GuildDinnerMenuTipsCtrl:BindEvents()
    
    
end --func end

--next--
--lua functions end

--lua custom scripts
--设置参数
function GuildDinnerMenuTipsCtrl:SetDinnerMenuTipsData(roleDatas, dishCount, costTime, isEatAlready)
    --记录是否已经吃过一次该菜肴
    self.isEatAlready = isEatAlready
    --玩家数不对 则直接关闭
    if #roleDatas < 2 then 
        UIMgr:DeActiveUI(UI.CtrlNames.GuildDinnerMenuTips)
        return 
    end

    local l_guildData = DataMgr:GetData("GuildData")
    local l_guildDinnerMgr = MgrMgr:GetMgr("GuildDinnerMgr")
    local l_isSelfMake = false  --是否是自己制作
    self:clearModels()
    --人物模型和名字
    self.playerModels = {}
    self.waitGetPlayerInfos = {}
    for i = 1, 2 do
        --判断制作者是否是自己
        local l_roleUID = roleDatas[i].role_id
        if l_roleUID == MPlayerInfo.UID then l_isSelfMake = true end
        --名d字
        self.panel.ChefName[i].LabText = roleDatas[i].name
        --模型
        self.panel.RoleView.UObj:SetActiveEx(false)
        table.insert(self.waitGetPlayerInfos,l_roleUID)
    end
    self:getPlayerInfoFromServer(1,self.waitGetPlayerInfos[1])
    --菜的数量
    self.panel.DishesNum.LabText = Lang("GUILD_DINNER_DISHES_COUNT", dishCount)
    self.panel.DishesTip.LabText = Lang("GUILD_DINNER_DISH_TIP", dishCount)
    --烹饪事件
    local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(costTime)
    self.panel.CookTime.LabText = Lang("TIMESHOW_M_S", l_minuite, l_second)
    --品尝按钮
    self.panel.BtnTaste:AddClick(function ()
        if self.isEatAlready then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_COOK_EAT_REAPET"))
            return
        end
        if Common.TimeMgr.GetNowTimestamp() > tonumber(tostring(l_guildData.curDishData.endTime)) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CUR_GUILD_DINNER_DISH_TIME_OUT"))
        else
            l_guildDinnerMgr.OnGuildEat()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.GuildDinnerMenuTips)
    end)
    --分享按钮
    self.panel.BtnShare.UObj:SetActiveEx(l_isSelfMake)
    self.panel.BtnShare:AddClick(function ()
        if Common.TimeMgr.GetNowTimestamp() > tonumber(tostring(l_guildData.curDishData.endTime)) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CUR_GUILD_DINNER_DISH_TIME_OUT"))
            UIMgr:DeActiveUI(UI.CtrlNames.GuildDinnerMenuTips)
            return
        end
        l_guildDinnerMgr.ReqGuildDinnerShareDish()
    end)
    
end
function GuildDinnerMenuTipsCtrl:getPlayerInfoFromServer(index,uid)
    if uid==nil then
        self.waitGetPlayerInfos = {}
        return
    end
    MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(uid, function(playInfo)
        if self.panel == nil then
            return
        end
        self:ShowPlayerModel(playInfo, index)
        local l_nextIndex = index + 1
        local l_nextPlayerUID = self.waitGetPlayerInfos[l_nextIndex]
        self:getPlayerInfoFromServer(l_nextIndex,l_nextPlayerUID)
    end)
end
--展示玩家模型
--playInfo 玩家数据
--index 索引
function GuildDinnerMenuTipsCtrl:ShowPlayerModel(playInfo, index)
    local l_attr = playInfo:GetAttribData()
    local l_animationPath = playInfo:GetPathFightIdleAnim()

    local l_fxData = {}
    l_fxData.rawImage = self.panel.RoleView.RawImg
    l_fxData.attr = l_attr

    --比心动画路径拼接
    local l_isMale = l_attr.IsMale
    local l_animPath = "Anims/Common/Model_"
    if l_isMale then
        l_animPath = l_animPath.."M/Common_M_BiXin01_"
    else
        l_animPath = l_animPath.."F/Common_F_BiXin01_"
    end
    if index == 1 then 
        l_animPath = l_animPath.."A"
    else
        l_animPath = l_animPath.."P"
    end

    l_fxData.defaultAnim = l_animPath
    self.playerModels[index] = self:CreateUIModel(l_fxData)

    self.playerModels[index]:AddLoadGoCallback(function(go)
        self.playerModels[index].Trans:SetPos(-1.05 + index * 0.7, 0.2, 0)
        self.playerModels[index].Rotation = Quaternion.Euler(0, 270 - 180 * index, 0)
        self.panel.RoleView.UObj:SetActiveEx(true)
    end)

    
end
function GuildDinnerMenuTipsCtrl:clearModels()
    --人物模型销毁
    if self.playerModels then
        for i = #self.playerModels, 1, -1 do
            self:DestroyUIModel(self.playerModels[i])
            self.playerModels[i] = nil
        end
    end
    self.playerModels = nil
end
--lua custom scripts end
return GuildDinnerMenuTipsCtrl