--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HymnTrialRoulettePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HymnTrialRouletteCtrl = class("HymnTrialRouletteCtrl", super)
--lua class define end

local l_hymnMgr = nil
local l_rouletteModel = nil  --转盘模型
local l_playerModel = nil  --人物模型
local l_rotateTime = 8 --转盘旋转时间
local l_selectEffect = nil  --转盘选中时的特效
local l_selectEffectPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_ShengGeShiLian_TurnTable_04"  --转盘选中时的特效路径

--lua functions
function HymnTrialRouletteCtrl:ctor()

    super.ctor(self, CtrlNames.HymnTrialRoulette, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function HymnTrialRouletteCtrl:Init()

    self.panel = UI.HymnTrialRoulettePanel.Bind(self)
    super.Init(self)

    self.IgnoreHidePanelNames = { UI.CtrlNames.HymnTrialInfo }

    --RT背景的设置
    MoonClient.MPostEffectMgr.GrabRTForBgInstance:SetCapatureScreenForBg(self.panel.RTBg.RawImg)
    self.panel.RTBg:SetRawImgMaterial("")

    l_hymnMgr = MgrMgr:GetMgr("HymnTrialMgr")
    --转盘旋转时间读表
    l_rotateTime = MGlobalConfig:GetFloat("TurnTableDuringTime") * 0.7
    --按钮事件绑定
    self:ButtonClickEventAdd()
    
    --确认数据存在则继续 如果数据已经被清理（加载界面的时候触发登出了）则直接关闭本界面
    if l_hymnMgr.curRouletteLogData.playerId then
        --转盘模型展示
        self:ShowRoulette()
        --请求拉杆者的玩家数据
        self:ReqShowPlayerInfo(l_hymnMgr.curRouletteLogData.playerId)
    end

end --func end


--next--
function HymnTrialRouletteCtrl:Uninit()

    --RT背景的清理 放最前面 防止别处异常导致画面卡死
    MoonClient.MPostEffectMgr.GrabRTForBgInstance:StopCapatureScreenForBg()

    if self.tweenMove_Inner then
        self.tweenMove_Inner:DOKill()
        self.tweenMove_Inner = nil
    end

    if self.tweenMove_Outer then
        self.tweenMove_Outer:DOKill()
        self.tweenMove_Outer = nil
    end

    --转盘选中时的特效销毁
    if l_selectEffect ~= nil then
        self:DestroyUIEffect(l_selectEffect)
        l_selectEffect = nil
    end

    --转盘模型销毁
    if l_rouletteModel ~=nil then
        --如果模型已经加载出来了 回池前模型的动态特效设置还原
        if l_rouletteModel.Trans then
            local l_elementEventSolt = l_rouletteModel.Trans:GetChild(1):GetChild(11)
            l_elementEventSolt:GetChild(0).gameObject:SetActiveEx(true)
            l_elementEventSolt:GetChild(1).gameObject:SetActiveEx(true)
        end
        --回池销毁
        self:DestroyUIModel(l_rouletteModel)
        l_rouletteModel = nil
    end
    --人物模型销毁
    if l_playerModel ~=nil then
        self:DestroyUIModel(l_playerModel)
        l_playerModel = nil
    end

    l_hymnMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function HymnTrialRouletteCtrl:OnActive()

end --func end
--next--
function HymnTrialRouletteCtrl:OnDeActive()

end --func end
--next--
function HymnTrialRouletteCtrl:Update()

    if not l_hymnMgr or not l_hymnMgr.curRouletteLogData.playerId then
        UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialRoulette)
    end

end --func end



--next--
function HymnTrialRouletteCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--按钮事件绑定
function HymnTrialRouletteCtrl:ButtonClickEventAdd()
    --关闭按钮
    self.panel.BtnQuit:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialRoulette)
    end)
end

--转盘模型展示
function HymnTrialRouletteCtrl:ShowRoulette()

    local l_curRouletteLogData = l_hymnMgr.curRouletteLogData  --缓存下来扔进闭包 防止手机加载慢 回调刚好卡登出报错 

    local l_fxData = {}
    l_fxData.rawImage = self.panel.RouletteView.RawImg
    l_fxData.prefabPath = l_hymnMgr.rouletteModelPath

    l_rouletteModel = self:CreateUIModel(l_fxData)
    l_rouletteModel:AddLoadModelCallback(function(m)

        --虽然用了闭包缓存了数据 但是再做一次数据验证 双保险防报错
        if not l_curRouletteLogData.playerId then
            UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialRoulette)
        end

        --位置设置
        self.panel.RouletteView.gameObject:SetActiveEx(true)
        l_rouletteModel.Trans:SetPos(0, 0.35, 4)
        l_rouletteModel.Scale = Vector3.New(0.9, 0.7, 0.6)
        l_rouletteModel.Rotation = Quaternion.Euler(-45, 180, 180)
        --转盘外圈数字符文显示控制
        for i = 1, 12 do
            local l_numEventInfo = TableUtil.GetHSMonsterNumTable().GetRowByEventID(i)
            local l_num = l_numEventInfo.Num
            local l_ten = math.floor(l_num / 10)
            local l_single = l_num % 10
            for j = 0, 9 do
                if j ~= l_ten then
                    --十位数数字
                    l_rouletteModel.Trans:GetChild(2):GetChild(i-1):GetChild(0):GetChild(j).gameObject:SetActiveEx(false)
                end

                if j ~= l_single then
                    --个位数数字
                    l_rouletteModel.Trans:GetChild(2):GetChild(i-1):GetChild(1):GetChild(j).gameObject:SetActiveEx(false)
                end
            end
        end
        --元素槽特效初始化
        local l_elementEventSolt = l_rouletteModel.Trans:GetChild(1):GetChild(11)
        l_elementEventSolt:GetChild(0).gameObject:SetActiveEx(true)
        l_elementEventSolt:GetChild(1).gameObject:SetActiveEx(false)
        --刷新圆盘的显示
        MUIModelManagerEx:RefreshModel(l_rouletteModel)

        --转盘上的元素随机事件特效播放
        MLuaClientHelper.PlayFxHelper(l_rouletteModel.Trans:GetChild(1):GetChild(11):GetChild(0).gameObject)

        --常驻窜中特效播放
        MLuaClientHelper.PlayFxHelper(l_rouletteModel.Trans:GetChild(4):GetChild(0).gameObject)

        --内圈旋转角度的索引获取 和 随机多圈数获取
        local l_eventAngleIndex = math.random(l_curRouletteLogData.eventEndAngle.Count) - 1
        local l_innerRandomRange = MGlobalConfig:GetSequenceOrVectorInt("InnerRingCycleNumber")
        local l_innerTurns = math.random(l_innerRandomRange[0], l_innerRandomRange[1])
        --内圈旋转
        self.tweenMove_Inner = l_rouletteModel.Trans:GetChild(1).gameObject:GetComponent("DOTweenAnimation")
        self.tweenMove_Inner:DOKill()
        self.tweenMove_Inner.duration = l_rotateTime
        self.tweenMove_Inner.endValueV3 = Vector3.New(0, 0, l_innerTurns * 360 + l_curRouletteLogData.eventEndAngle[l_eventAngleIndex])
        self.tweenMove_Inner.onComplete:RemoveAllListeners()
        self.tweenMove_Inner.onComplete:AddListener(function()
            --随机元素判断
            local l_eventId = l_curRouletteLogData.innerEventId
            if l_hymnMgr.elementOffset[l_eventId] then
                local l_elementEventSolt = l_rouletteModel.Trans:GetChild(1):GetChild(11)
                l_elementEventSolt:GetChild(0).gameObject:SetActiveEx(false)
                l_elementEventSolt:GetChild(1).gameObject:SetActiveEx(true)
                MLuaClientHelper.SetMaterialMainTexST(l_elementEventSolt:GetChild(1).gameObject, 
                    l_hymnMgr.elementScale[1], l_hymnMgr.elementScale[2],
                    l_hymnMgr.elementOffset[l_eventId].x, l_hymnMgr.elementOffset[l_eventId].y)
                --刷新圆盘的显示
                MUIModelManagerEx:RefreshModel(l_rouletteModel)
            end

            --选中时的特效加载
            local l_fxData_selectEffect = {}
            l_fxData_selectEffect.rawImage = self.panel.SelectEffectView.RawImg
            l_fxData_selectEffect.rotation = Quaternion.Euler(90, 0, 0)
            l_fxData_selectEffect.parent = l_rouletteModel.Trans:GetChild(4)
            l_fxData_selectEffect.loadedCallback = function(a) self.panel.SelectEffectView.gameObject:SetActiveEx(true) end
            l_fxData_selectEffect.destroyHandler = function ()
                l_selectEffect = nil
            end
            l_selectEffect = self:CreateUIEffect(l_selectEffectPath, l_fxData_selectEffect)

            --日志和事件文字展示
            self:ShowEvenAndLogText(l_curRouletteLogData)

            --天气变化
            local result = MEnvironWeatherGM.SetClientDataByType(0,
                MoonClient.MSceneEnvoriment.MPeriodType.IntToEnum(l_curRouletteLogData.weatherCode[0]),
                MoonClient.MSceneEnvoriment.MWeatherType.IntToEnum(l_curRouletteLogData.weatherCode[1]))
            if not result then
                logError("时间段：" .. tostring(l_curRouletteLogData.weatherCode[0]) .. ", 天气：" .. tostring(l_curRouletteLogData.weatherCode[1]) .. ", 组合当前地图不存在！！！")
            end

            --幸运事件点赞
            if l_curRouletteLogData.isPraise then
                l_hymnMgr.ShowPraiseForLuckyEvent()
            end
        end)
        self.tweenMove_Inner:CreateTween()
        self.tweenMove_Inner:DORestart()


        --外圈旋转
        local l_outerRandomRange = MGlobalConfig:GetSequenceOrVectorInt("OuterRingCycleNumber")
        local l_outerTurns = math.random(l_outerRandomRange[0], l_outerRandomRange[1])
        self.tweenMove_Outer = l_rouletteModel.Trans:GetChild(2).gameObject:GetComponent("DOTweenAnimation")
        self.tweenMove_Outer:DOKill()
        self.tweenMove_Outer.duration = l_rotateTime - 2
        self.tweenMove_Outer.endValueV3 = Vector3.New(0, 0, l_outerTurns * 360 + l_curRouletteLogData.numberAngle)
        self.tweenMove_Outer:CreateTween()
        self.tweenMove_Outer:DORestart()
    end)

end

--请求拉杆者的玩家数据
function HymnTrialRouletteCtrl:ReqShowPlayerInfo(UID)
    --请求服务角色外观数据
    MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(UID, function(obj)
        if self.panel == nil then
            return
        end
        self:ShowPlayerModel(obj)
    end)
end

--展示玩家模型
function HymnTrialRouletteCtrl:ShowPlayerModel(playInfo)

    l_hymnMgr.curRouletteLogData.playerName = playInfo.name  -- 当前轮数据获取拉杆者名字(用于日志展示)
    local l_attr = playInfo:GetAttribData()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.PlayerView.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = playInfo:GetPathFightIdleAnim()

    l_playerModel = self:CreateUIModel(l_fxData)
    l_playerModel.Position = Vector3.New(0, 0.84, 3.2)
    l_playerModel.Scale = Vector3.New(1.2, 1.2, 1.2)
    l_playerModel.Rotation = Quaternion.Euler(20, 180, 0)
    l_playerModel:AddLoadModelCallback(function(m)
        self.panel.PlayerView.UObj:SetActiveEx(true)
    end)

    

    --玩家名字显示
    self.panel.PlayerName.LabText = l_hymnMgr.curRouletteLogData.playerName

end

--事件和日志文字展示
function HymnTrialRouletteCtrl:ShowEvenAndLogText(curRouletteLogData)
    --上部事件文字展示
    self.panel.EventTextGroup.UObj:SetActiveEx(true)
    self.panel.EventTxt.LabText = curRouletteLogData.eventText
    MLuaClientHelper.PlayFxHelper(self.panel.EventTextGroup.UObj)
    --日志文字展示
    self.panel.TurnsTxt.UObj:SetActiveEx(true)
    self.panel.TurnsTxt.LabText = Lang("HYMN_TRIAL_TURNS", curRouletteLogData.turnNum)
    self.panel.LogTxt.UObj:SetActiveEx(true)
    self.panel.LogTxt.LabText = StringEx.Format(curRouletteLogData.logText,
            curRouletteLogData.playerName,
            curRouletteLogData.monsterNum)
end
--lua custom scripts end
