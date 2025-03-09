--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RollPointPanel"
require "Event/EventConst"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
RollPointCtrl = class("RollPointCtrl", super)
--lua class define end

--lua functions
function RollPointCtrl:ctor()
    super.ctor(self, CtrlNames.RollPoint, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
end --func end
--next--
function RollPointCtrl:Init()
    self.panel = UI.RollPointPanel.Bind(self)
    super.Init(self)
end --func end
--next--
function RollPointCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RollPointCtrl:OnActive()
    self:InitializePanel()
end --func end
--next--
function RollPointCtrl:OnDeActive()
    self:UnInitializePanel()
end --func end
--next--
function RollPointCtrl:Update()
    -- do nothing
end --func end

--next--
function RollPointCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts

local l_head = {}
local l_item = {}
local l_timer = nil

local l_passSec = 0

local MAX_TIME = 14
local AUTO_TIME = 10
local INTEVAL_SHACK = 0.1

local l_effect = { 122027, 122001, 122019 }

function RollPointCtrl:InitializePanel()
    l_head = {}
    l_item = {}
    self.startPoint = nil
    self.tweenIdLeft = nil
    self.tweenIdRight = nil
    self.tweenIdRoll = nil
    self.itemTween = nil
    self.inTween = false
    self.point = 0
    self.finish = false
    self.shakeTween = false
    self.tweenIdTab = {}
    self.headPoint = {}
    self.fx = {}
    l_passSec = 0

    self.panel.Shake.gameObject:SetActiveEx(true)
    self.panel.Reward.gameObject:SetActiveEx(false)
    self:AddEvent()
    self:InitHeadPanel()
    self:InitItemPanel()
    self:InitShakePanel()
    self:StopTimer()
    self.panel.Tips.gameObject:SetActiveEx(true)
    self.panel.Tips.LabText = StringEx.Format(Common.Utils.Lang("ROLL_POINT_TIPS"),
            AUTO_TIME - l_passSec)
    l_timer = self:NewUITimer(function()
        l_passSec = l_passSec + 1
        self.panel.Tips.LabText = StringEx.Format(Common.Utils.Lang("ROLL_POINT_TIPS"),
                AUTO_TIME - l_passSec)
        if l_passSec >= AUTO_TIME then
            local l_roll = self.panel.RollBall.gameObject
            self.rollPos = self.panel.RollBall.gameObject.transform.localPosition
            self.rollTargetPos = Vector3.New(self.rollPos.x, self.rollPos.y - 30, 0)
            self.tweenIdRoll = MUITweenHelper.TweenPos(
                    l_roll, self.rollPos, self.rollTargetPos, 0.2, function()
                    end)
            self.panel.RollGan.transform:SetLocalScaleY(0.6)
            self:StartPlayTween(1)
        end
    end, 1, -1, true)
    l_timer:Start()
end

function RollPointCtrl:UnInitializePanel()
    self:StopTimer()
    self:StopTween()
    for i = 1, #l_item do
        if not MLuaCommonHelper.IsNull(l_item[i].tp) then
            MResLoader:DestroyObj(l_item[i].tp)
        end
        if l_item[i].itemId then
            self:UninitTemplate(l_item[i].btn)
        end
    end
    for i = 1, #l_head do
        if not MLuaCommonHelper.IsNull(l_head[i].go) then
            MResLoader:DestroyObj(l_head[i].go)
        end
    end
    for i, v in ipairs(self.fx) do
        self:DestroyUIEffect(v)
    end
    self.fx = {}

end

function RollPointCtrl:AddEvent()
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ROLL_CONFIRM_NTF, function(a, roleId)
        self:OnRollConfirmEvent(roleId)
    end)
    local l_headMgr = MgrMgr:GetMgr("HeadMgr")
    self:BindEvent(l_headMgr.EventDispatcher, EventConst.Names.HEAD_SET_HEDA, self.OnSetHead)
end

function RollPointCtrl:StopTimer()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
end

function RollPointCtrl:StopTween()
    if self.tweenIdLeft then
        MUITweenHelper.KillTween(self.tweenIdLeft)
        self.tweenIdLeft = nil
    end
    if self.tweenIdRight then
        MUITweenHelper.KillTween(self.tweenIdRight)
        self.tweenIdRight = nil
    end
    if self.tweenIdRoll then
        MUITweenHelper.KillTween(self.tweenIdRoll)
        self.tweenIdRoll = nil
    end
    if self.itemTween then
        MUITweenHelper.KillTween(self.itemTween)
        self.itemTween = nil
    end
    if #self.tweenIdTab > 0 then
        for i = 1, #self.tweenIdTab do
            if self.tweenIdTab[i] then
                MUITweenHelper.KillTween(self.tweenIdTab[i])
            end
        end
    end
    self.tweenIdTab = {}
end

function RollPointCtrl:OnRollConfirmEvent(roleId)
    if tostring(roleId) ~= tostring(MPlayerInfo.UID) then
        self:SetPlayerPointVisible(roleId)
    end
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    if #l_mgr.g_confirmRoleId == #l_mgr.g_roleInfo and not self.finish then
        if self.inTween then
            self:AutoFinish()
        else
            self:OnFinishPanel()
        end
    end
    if #l_mgr.g_confirmRoleId == #l_mgr.g_roleInfo and not self.inTween then
        if l_passSec < MAX_TIME - 2 then
            l_passSec = MAX_TIME - 2
        end
    end
end

function RollPointCtrl:InitHeadPanel()
    l_head = {}
    local l_idList = {}
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    local l_headTpl = self.panel.Head
    local l_emptyTpl = self.panel.ItemEmpty
    local l_emptyNum = 5 - #l_mgr.g_roleInfo
    --按照组队顺序进行排序
    local playeIds = DataMgr:GetData("TeamData").GetTeamPlayerIds()
    --按照roleid存储roleinfo
    local l_roleInfos = {}
    for i = 1, #l_mgr.g_roleInfo do
        local l_info = l_mgr.g_roleInfo[i]
        l_roleInfos[l_info.roleId] = l_info
    end
    for i = 1, #playeIds do
        local l_info = l_roleInfos[playeIds[i]]
        if l_info then
            local l_go = self:CloneObj(l_headTpl.gameObject)
            l_go.transform:SetParent(self.panel.HeadIcon.gameObject.transform)
            l_go:SetLocalScaleToOther(l_headTpl.gameObject)
            l_go:SetActiveEx(true)
            local l_index = #l_head + 1
            l_head[l_index] = {}
            l_head[l_index].roleId = l_info.roleId
            l_head[l_index].point = l_info.point
            l_head[l_index].itemID = l_info.itemID
            l_head[l_index].go = l_go
            self:InitHeadPrefab(l_head[l_index])
            l_idList[#l_idList + 1] = l_info.roleId
            self.headPoint[#self.headPoint + 1] = l_info.point
        end
    end
    table.sort(self.headPoint, function(x, y)
        return x > y
    end)
    if l_emptyNum > 0 then
        for i = 1, l_emptyNum do
            local l_go = self:CloneObj(l_emptyTpl.gameObject)
            l_go.transform:SetParent(self.panel.HeadIcon.gameObject.transform)
            l_go:SetLocalScaleToOther(l_emptyTpl.gameObject)
            l_go:SetActiveEx(true)
            local l_index = #l_head + 1
            l_head[l_index] = {}
            l_head[l_index].roleId = nil
            l_head[l_index].point = nil
            l_head[l_index].go = l_go
        end
    end
    MgrMgr:GetMgr("HeadMgr").SetHead(l_idList)
end

function RollPointCtrl:InitHeadPrefab(head)
    local l_go = head.go
    local l_friendBtn = l_go.transform:Find("FriendBtn").gameObject:GetComponent("MLuaUICom")
    local l_count = l_go.transform:Find("Count").gameObject:GetComponent("MLuaUICom")
    local l_countLab = l_go.transform:Find("Count/Text").gameObject:GetComponent("MLuaUICom")
    local l_RawImg = l_go.transform:Find("Count/Expression/ImgHeadExpression").gameObject:GetComponent("MLuaUICom")
    head.count = l_count
    head.countLab = l_countLab
    head.Parent = l_go.transform:Find("base")
    head.HeadTemplate = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = head.Parent,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    head.PlayerNameStr = ""
    head.addFriend = l_friendBtn
    head.RawImg = l_RawImg.RawImg
    head.count.gameObject:SetActiveEx(false)
    local l_roleId = head.roleId
    local l_point = head.point
    if tostring(l_roleId) == tostring(MPlayerInfo.UID) then
        self.point = l_point
    end

    l_countLab.LabText = l_point .. Common.Utils.Lang("POINT")
end

function RollPointCtrl:OnSetHead(headInfos, roleIdList)
    for i, v in ipairs(roleIdList) do
        headInfo = headInfos[tostring(v)]
        local l_target = nil
        if #l_head > 0 then
            for i = 1, #l_head do
                if tostring(l_head[i].roleId) == tostring(v) then
                    l_target = l_head[i]
                    break
                end
            end
        end

        if headInfo and l_target then
            local l_attr = headInfo.attr
            local l_info = headInfo.player
            ---@type HeadTemplateParam
            param = {
                ShowName = true,
                Name = l_info.name,
                EquipData = l_attr.EquipData
            }

            l_target.HeadTemplate:SetData(param)
            l_target.PlayerNameStr = l_info.name
        end
    end
end

function RollPointCtrl:InitItemPanel()
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    l_item = {}
    local l_emptyTpl = self.panel.ItemEmpty
    local l_emptyNum = 5 - #l_mgr.g_itemInfo

    for i = 1, #l_mgr.g_itemInfo do
        local l_itemId = l_mgr.g_itemInfo[i].itemId
        local l_count = l_mgr.g_itemInfo[i].count
        local l_price = l_mgr.g_itemInfo[i].price
        local l_index = #l_item + 1
        l_item[l_index] = {}
        l_item[l_index].itemId = l_itemId
        l_item[l_index].count = l_count
        l_item[l_index].price = l_price
        l_item[l_index].btn = self:NewTemplate("ItemTemplate", { IsUsePool = false,
                                                                 TemplateParent = self.panel.Icon.gameObject.transform:Find("pos" .. tostring(i)),
                                                                 IsActive = false--,IsShowTips = true
        })
        l_item[l_index].btn:SetData({ ID = l_itemId, IsShowCount = true,
                                      Count = l_count, IsShowTips = false, ButtonMethod = function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_itemId, nil, nil, {
                    IsShowCloseButton = true
                })
            end })
        l_item[l_index].go = l_item[l_index].btn:gameObject()
        l_item[l_index].tp = nil

        local l_kuang = nil
        local l_tp = nil
        if l_index == 1 then
            l_tp = self.panel.ItemBest.gameObject
        end
        if l_index == 2 then
            l_tp = self.panel.ItemSec.gameObject
        end
        if l_index > 2 then
            l_tp = self.panel.ItemNormal.gameObject
        end
        l_kuang = self:CloneObj(l_tp)
        l_item[l_index].tp = l_kuang
        l_kuang.transform:SetParent(l_item[l_index].go.transform)
        l_kuang:SetLocalScaleToOther(l_tp)
        l_kuang:SetLocalPosZero()
        l_kuang:SetActiveEx(true)
    end
    if l_emptyNum > 0 then
        for i = 1, l_emptyNum do
            local l_index = #l_item + 1
            l_item[l_index] = {}
            l_item[l_index].itemId = nil
            l_item[l_index].count = 0
            l_item[l_index].price = 0
            local l_go = self:CloneObj(l_emptyTpl.gameObject)
            l_go.transform:SetParent(self.panel.Icon.gameObject.transform:Find("pos" ..
                    tostring(#l_mgr.g_itemInfo + i)))
            l_go:SetLocalScaleToOther(l_emptyTpl.gameObject)
            l_go:SetLocalPosZero()
            l_go:SetActiveEx(true)
            l_item[l_index].btn = l_go
            l_item[l_index].go = l_go
        end
    end
    self:PlayItemTween(1)
end

function RollPointCtrl:PlayItemTween(index)
    if not self.panel then
        return
    end

    if self.itemTween then
        MUITweenHelper.KillTween(self.itemTween)
        self.itemTween = nil
    end
    if index > 5 then
        return
    end
    local l_target = l_item[index].go
    self.itemTween = MUITweenHelper.TweenScale(l_target, Vector3.New(0, 0, 0), Vector3.New(1, 1, 0), 0.2,
            function()
                index = index + 1
                self:PlayItemTween(index)
            end)
end

function RollPointCtrl:InitShakePanel()
    self.panel.NumLeft1:SetSpriteAsync("Party", "ui_Party_Number_0.png", nil, true)
    self.panel.NumLeft2:SetSpriteAsync("Party", "ui_Party_Number_0.png", nil, true)
    self.panel.NumRight1:SetSpriteAsync("Party", "ui_Party_Number_0.png", nil, true)
    self.panel.NumRight2:SetSpriteAsync("Party", "ui_Party_Number_0.png", nil, true)
    local l_listener = MUIEventListener.Get(self.panel.Roll.gameObject)
    l_listener.onDown = function(go, data)
        local l_roll = self.panel.RollBall.gameObject
        self.rollPos = self.panel.RollBall.gameObject.transform.localPosition
        self.rollTargetPos = Vector3.New(self.rollPos.x, self.rollPos.y - 30, 0)
        self.tweenIdRoll = MUITweenHelper.TweenPos(
                l_roll, self.rollPos, self.rollTargetPos, 0.2, function()
                end)
        self.panel.RollGan.transform:SetLocalScaleY(0.6)
        if self.startPoint then
            self:StartPlayTween(1)
            self.startPoint = nil
        end
        if self.startPoint == nil then
            self.startPoint = data.position.y
            return
        end
    end
    l_listener.onUp = function(go, data)
        if self.startPoint == data.position.y then
            self:StartPlayTween(1)
            self.startPoint = nil
        end
    end
    l_listener.onDragEnd = function(go, data)
        local l_dis = self.startPoint - data.position.y
        if l_dis > 0 then
            local l_value = math.min(l_dis / 130, 1)
            local l_time = math.modf(l_value * 3 + 0.5)
            if l_time < 1 then
                l_time = 1
            end
            self:StartPlayTween(l_time)
        end
        self.startPoint = nil
    end
end

function RollPointCtrl:StartPlayTween(sec)
    self.panel.Tips.gameObject:SetActiveEx(false)
    local l_listener = MUIEventListener.Get(self.panel.Roll.gameObject)
    l_listener.enabled = false
    if self.shakeTween then
        return
    end
    self.shakeTween = true
    self.inTween = true
    MgrMgr:GetMgr("RollMgr").SendRollConfirm()
    self:StopTimer()
    self:StopTween()
    self:AutoFinish()
    local l_leftTime = math.modf((sec) / INTEVAL_SHACK)
    local l_rightTime = math.modf((sec - 0.3) / INTEVAL_SHACK)
    local l_leftGo = self.panel.NumLeft.gameObject
    local l_rightGo = self.panel.NumRight.gameObject
    local l_ten = math.modf(self.point / 10)
    local l_one = self.point - l_ten * 10
    self:PlayTween(l_leftGo, self.panel.NumLeft1, self.panel.NumLeft2,
            self.tweenIdLeft, INTEVAL_SHACK, l_leftTime, l_ten)
    self:PlayTween(l_rightGo, self.panel.NumRight1, self.panel.NumRight2,
            self.tweenIdRight, INTEVAL_SHACK, l_rightTime, l_one)
    local l_roll = self.panel.RollBall.gameObject
    self.tweenIdRoll = MUITweenHelper.TweenPos(
            l_roll, self.rollTargetPos, self.rollPos, 0.2, function()
            end)
    self.panel.RollGan.transform:SetLocalScaleY(1)
end

function RollPointCtrl:PlayTween(go, num1, num2, tweenId, interval, times, value)
    if not self.panel then
        return
    end

    times = math.modf(times)
    local l_v1 = Vector3.New(0, 0, 0)
    local l_v2 = Vector3.New(0, 83, 0)
    local l_value = math.modf(math.random(0, 9))
    if times <= 0 then
        num1:SetSpriteAsync("Party", "ui_Party_Number_" .. tostring(value) .. ".png", nil, true)
        self:OnSelfTweenFinish()
        return
    end
    if times == 1 then
        num1:SetSpriteAsync("Party", "ui_Party_Number_0.png", nil, true)
        num2:SetSpriteAsync("Party", "ui_Party_Number_" .. tostring(value) .. ".png", nil, true)
    end
    if times > 1 then
        num1.Img.sprite = num2.Img.sprite
        num1.Img:SetNativeSize()
        num2:SetSpriteAsync("Party", "ui_Party_Number_" .. tostring(l_value) .. ".png", nil, true)
    end
    tweenId = MUITweenHelper.TweenPos(go, l_v1, l_v2, interval, function()
        if not self.panel then
            return
        end

        times = times - 1
        MUITweenHelper.KillTween(tweenId)
        tweenId = nil
        if times == 0 then
            self:OnSelfTweenFinish()
            return
        end
        self:PlayTween(go, num1, num2, tweenId, interval, times, value)
    end)
end

function RollPointCtrl:OnSelfTweenFinish()
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    self:SetPlayerPointVisible(MPlayerInfo.UID)
    self.inTween = false
    if #l_mgr.g_confirmRoleId == #l_mgr.g_roleInfo then
        if l_passSec < MAX_TIME - 2 then
            l_passSec = MAX_TIME - 2
        end
    end
end

function RollPointCtrl:SetPlayerPointVisible(roleId)
    local l_target = nil
    if #l_head > 0 then
        for i = 1, #l_head do
            if tostring(l_head[i].roleId) == tostring(roleId) then
                l_target = l_head[i]
                break
            end
        end
    end
    if l_target then
        l_target.count.gameObject:SetActiveEx(true)
        local l_rank = 2
        if self.headPoint[1] == l_target.point then
            l_rank = 1
        elseif self.headPoint[#self.headPoint] == l_target.point then
            l_rank = 3
        end
        local l_fxId = l_effect[l_rank]
        local l_fxData = {}
        l_fxData.rawImage = l_target.RawImg
        l_fxData.scaleFac = Vector3.New(3, 3, 3)
        l_fxData.playTime = -1
        local l_zero_rotation = Quaternion.Euler(0, 0, 0)
        l_fxData.rotation = l_zero_rotation
        local l_com_face_ctrl = nil
        l_fxData.loadedCallback = function(go)
            l_com_face_ctrl = go:GetComponent("FaceToCameraObjPrepareData")
            if l_com_face_ctrl then
                l_com_face_ctrl:CustomActive(false)
                local l_objs = l_com_face_ctrl.FaceToCameraObjs
                for i = 0, l_objs.Length - 1 do
                    l_objs[i].transform.localRotation = l_zero_rotation
                end
            end
        end
        l_fxData.destroyHandler = function()
            if l_com_face_ctrl then
                l_com_face_ctrl:CustomActive(true)
            end
        end
        if self.fx[l_target.roleId] then
            self:DestroyUIEffect(self.fx[l_target.roleId])
        end
        self.fx[l_target.roleId] = self:CreateUIEffect(l_fxId, l_fxData)

    end
end

function RollPointCtrl:AutoFinish()
    self.finish = true
    self:StopTimer()
    l_timer = self:NewUITimer(function()
        l_passSec = l_passSec + 1
        if l_passSec >= MAX_TIME then
            self:OnFinishPanel()
        end
    end, 1, -1, true)
    l_timer:Start()
end

function RollPointCtrl:OnFinishPanel()
    self.finish = true
    self:StopTimer()
    self:StopTween()
    local l_value = Vector3.New(0, 83, 0)
    self.panel.NumLeft.gameObject:SetLocalPos(l_value)
    self.panel.NumRight.gameObject:SetLocalPos(l_value)
    local l_ten = math.modf(self.point / 10)
    local l_one = self.point - l_ten * 10
    self.panel.NumLeft2:SetSpriteAsync("Party", "ui_Party_Number_" .. tostring(l_ten) .. ".png", nil, true)
    self.panel.NumRight2:SetSpriteAsync("Party", "ui_Party_Number_" .. tostring(l_one) .. ".png", nil, true)
    if #l_head > 0 then
        for i = 1, #l_head do
            local l_target = l_head[i]
            if l_target.count and not l_target.count.gameObject.activeSelf then
                self:SetPlayerPointVisible(l_target.roleId)
            end
        end
    end
    self:PlayFinishTween()
end

function RollPointCtrl:PlayFinishTween()
    self.panel.Shake.gameObject:SetActiveEx(false)
    self.panel.Reward.gameObject:SetActiveEx(true)
    self.panel.SelfBg.gameObject:SetActiveEx(false)
    self.panel.Icon.gameObject:GetComponent("HorizontalLayoutGroup").enabled = false
    local l_pos = {}
    for i = 1, #l_item do
        local l_targetPos = l_item[i].go.transform.parent.localPosition
        l_pos[i] = Vector3.New(l_targetPos.x, l_targetPos.y - 35, 0)
    end
    self.finishNum = 0
    -- 奖励物品到指定的头像下面
    for i = 1, #l_item do
        local l_target = l_item[i]
        local l_go = l_target.go.transform.parent.gameObject
        local l_targetIndex = i
        if self.headPoint[i] then
            for ii = 1, #l_head do
                --if tostring(l_head[ii].point) == tostring(l_point) then
                if tostring(l_head[ii].itemID) == tostring(l_target.itemId) then
                    l_targetIndex = ii
                    break
                end
            end
        end
        table.insert(self.tweenIdTab, MUITweenHelper.TweenPos(
                l_go, l_go.transform.localPosition, l_pos[l_targetIndex], 0.5, function()
                    self:OnTweenFinish()
                end))
    end
    local l_targetGo = self.panel.HeadIcon.gameObject
    local l_targetPos = self.panel.HeadIcon.gameObject.transform.localPosition

    table.insert(self.tweenIdTab, MUITweenHelper.TweenPos(
            l_targetGo, l_targetPos, Vector3.New(l_targetPos.x, l_targetPos.y + 80, 0), 0.5, function()
            end))
end

function RollPointCtrl:OnTweenFinish()
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    self.finishNum = self.finishNum + 1
    if self.finishNum == 5 then
        self:StopTween()
        local l_target = nil
        local l_showAddBtn = MPlayerInfo.PlayerDungeonsInfo.dungeonData == nil
        if not l_showAddBtn then
            local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
            l_showAddBtn = dungeonData.RollAppearFriend == 1
        end
        if #l_head > 0 then
            for i = 1, #l_head do
                local l_targetHead = l_head[i]
                local l_roleId = l_targetHead.roleId
                if l_roleId then
                    local l_point = l_targetHead.point
                    local l_targetItem = nil
                    if #self.headPoint > 0 then
                        for ii = 1, #self.headPoint do
                            if l_point == self.headPoint[ii] then
                                l_targetItem = l_item[ii]
                                break
                            end
                        end
                    end
                    if l_targetItem then
                        self:BoardCastMsg(l_targetHead.PlayerNameStr, l_point, l_targetItem.itemId, l_targetItem.count)
                    end
                end

                if tostring(l_roleId) == tostring(MPlayerInfo.UID) then
                    l_target = i
                end

                if l_showAddBtn and tostring(l_roleId) ~= tostring(MPlayerInfo.UID)
                        and l_targetHead.addFriend then
                    l_targetHead.addFriend:AddClick(function()
                        MgrMgr:GetMgr("FriendMgr").RequestAddFriend(l_roleId)
                        l_targetHead.addFriend.gameObject:SetActiveEx(false)
                    end)
                    --是好友的情况不显示按钮
                    l_targetHead.addFriend.gameObject:SetActiveEx(not MgrMgr:GetMgr("FriendMgr").IsFriend(l_roleId))
                end
            end
        end
        if l_target then
            local l_pos = l_head[l_target].go.transform.localPosition
            self.panel.SelfBg.gameObject:SetLocalPos(l_pos.x, 0, 0)
            self.panel.SelfBg.gameObject:SetActiveEx(true)
        end

    end
    if l_mgr.g_reward and l_mgr.g_reward.id then
        local l_target = l_mgr.g_reward
        local l_opt = {
            itemId = l_target.id,
            itemOpts = { num = l_target.num, icon = { size = 18, width = 1.4 } },
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
        l_mgr.g_reward = {}
    end
    local l_listener = MUIEventListener.Get(self.panel.BG.gameObject)
    l_listener.onClick = function(go, data)
        self:OnExitPanel()
    end
    local l_exitTime = tonumber(MGlobalConfig:GetInt("RollAutoCloseTime")) or 0
    l_exitTime = l_exitTime > 0 and l_exitTime or 10
    self:StopTimer()
    if l_exitTime and l_exitTime > 0 and l_mgr.g_isTimeLimit then
        l_timer = self:NewUITimer(function()
            l_exitTime = l_exitTime - 1
            if l_exitTime <= 0 then
                self:OnExitPanel()
            end
        end, 1, -1, true)
        l_timer:Start()
    end
end

function RollPointCtrl:OnExitPanel()
    local l_mgr = MgrMgr:GetMgr("RollMgr")
    self:StopTween()
    self:StopTimer()
    if l_mgr.g_callBack then
        l_mgr.g_callBack()
    end

    -- MgrProxy:GetQuickUseMgr().OnItemChangeNtf(l_mgr.g_info)
    l_mgr.OnEnterScene()
    UIMgr:DeActiveUI(UI.CtrlNames.RollPoint)
end

function RollPointCtrl:BoardCastMsg(name, point, id, count)
    if not id then
        return
    end
    local l_item = TableUtil.GetItemTable().GetRowByItemID(tonumber(id))
    if l_item then
        local l_msg = ""
        if self.headPoint[1] == point then
            l_msg = StringEx.Format(Common.Utils.Lang("ROLL_BEST_LUCKY"),
                    name, point, l_item.ItemName .. "*" .. tostring(count))
        else
            l_msg = StringEx.Format(Common.Utils.Lang("ROLL_OTHER_LUCKY"),
                    name, point, l_item.ItemName .. "*" .. tostring(count))
        end
        local l_chartMgr = MgrMgr:GetMgr("ChatMgr")
        local l_chatDataMgr = DataMgr:GetData("ChatData")
        local l_MsgPkg = {}
        l_MsgPkg.channel = l_chatDataMgr.EChannel.TeamChat
        l_MsgPkg.lineType = l_chatDataMgr.EChatPrefabType.System
        l_MsgPkg.subType = Lang("CHAT_CHANNEL_TEAM")
        l_MsgPkg.content = l_msg
        l_MsgPkg.showInMainChat = true
        l_MsgPkg.showDanmu = true
        l_chartMgr.BoardCastMsg(l_MsgPkg)
    end
end
--lua custom scripts end
