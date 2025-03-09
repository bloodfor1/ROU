--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ThemeDungeonArroundPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ThemeDungeonArroundCtrl = class("ThemeDungeonArroundCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("ThemeDungeonMgr")
local l_data = DataMgr:GetData("ThemeDungeonData")
-- 书本数量
local l_bookCount = 8

-- 视觉上的index映射场景中的书本的index
local l_map = {
    [1] = 7,
    [2] = 8,
    [3] = 6,
    [4] = 5,
    [5] = 2,
    [6] = 1,
    [7] = 3,
    [8] = 4,
}

-- 书本打开动画映射
local l_animMap = {
    [1] = 3,
    [2] = 4,
    [3] = 2,
    [4] = 1,
    [5] = 2,
    [6] = 1,
    [7] = 3,
    [8] = 4,
}

local l_commonFxPath = "Effects/Prefabs/Scene/"

--lua functions
function ThemeDungeonArroundCtrl:ctor()

    super.ctor(self, CtrlNames.ThemeDungeonArround, UILayer.Function, nil, ActiveType.Exclusive)

    self.stopMoveOnActive = true
end --func end
--next--
function ThemeDungeonArroundCtrl:Init()

    self.panel = UI.ThemeDungeonArroundPanel.Bind(self)
    super.Init(self)

    self.isInDrag = false
    self.objBook=nil
    self.objBookRotTrans=nil

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    self.panel.CloseBtn:AddClick(function()
        self:CloseUI()
    end)

    self.panel.ButtonHelp:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(20)
        end)
    end)

    self.panel.ImageBox:AddClick(function()
        l_mgr.JudgeThemeAward()
    end)

    MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()

    -- 当前页，按每页8本书进行划分
    self.curPage = 1
    self.constMaxPage = math.ceil(#TableUtil.GetThemeDungeonTable().GetTable() / l_bookCount)
    self.curSceneBookIndex = 1

    self.waitTweenId = nil

    self.waitOpenTimer = nil

    self.extraBooks = {}
    self.books = {}

    self.fxs = {}
    self.fxTimer = nil



    self.panel.Fx.gameObject:SetActiveEx(false)

    self.arroundBook = nil
    self.centerBook = nil
    self.loadTaskId = 0

    self.extraTaskId = 0

    self.lock = false

    self.bookRotSpeed = MGlobalConfig:GetFloat("BookRotAngle", 90)

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isChallengeOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.ThemeChallenge)
    self.panel.ChallengeDungeonBtn:SetActiveEx(l_isChallengeOpen)
    -- 挑战模式
    self.panel.ChallengeDungeonBtn:AddClick(function()
        -- 打开挑战模式界面
        if self.themeDungeonMgr.curThemeId ~= -1 then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_Challenge, {themeDungeonId = self.themeDungeonMgr.curThemeId})
        else
            logError("服务器挑战副本ThemeId未刷新")
            --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_CHALLENGE_NOT_OPEN"))
        end
    end)

    -- 上一页
    self.panel.UpBtn:AddClick(function()
        if self.curPage > 1  then
            self.curPage = self.curPage - 1
            self:JumpToSceneBook(1, true)
            self:RefreshPage()
        end
    end)

    -- 下一页
    self.panel.DownBtn:AddClick(function()
        if self.curPage < self.constMaxPage then
            self.curPage = self.curPage + 1
            self:JumpToSceneBook(1, true)
            self:RefreshPage()
        end
    end)

    self:InitEventListeners()

    self:RefreshPage()
end --func end
--next--
function ThemeDungeonArroundCtrl:Uninit()

    for i = 1, l_bookCount do
        if self.panel.Collider[i] then
            MLuaUIListener.Destroy(self.panel.Collider[i].gameObject)
        end
    end
    if self.panel.ScrollView then
        MLuaUIListener.Destroy(self.panel.ScrollView.gameObject)
    end

    -- self.ringScrollRect = nil
    if self.waitTweenId then
        MUITweenHelper.KillTween(self.waitTweenId)
        self.waitTweenId = nil
    end

    if self.waitOpenTimer then
        self:StopUITimer(self.waitOpenTimer)
        self.waitOpenTimer = nil
    end

    self:ClearDetailTimer()

    if self.extraBooks then
        for k, v in pairs(self.extraBooks) do
            MResLoader:DestroyObj(v)
        end
        self.extraBooks = nil
    end

    if self.fxs then
        for k, v in pairs(self.fxs) do
            if v ~= -1 then
                self:DestroyUIEffect(v)
            end
        end
        self.fxs = nil
    end

    if self.awardCanGetFx then
        self:DestroyUIEffect(self.awardCanGetFx)
        self.awardCanGetFx = nil
    end

    self.books = nil

    self:CloseTimer()

    if self.reconnectTimer then
        self:StopUITimer(self.reconnectTimer)
        self.reconnectTimer = nil
    end

    if self.extraTaskId ~= 0 then
        MResLoader:CancelAsyncTask(self.extraTaskId)
        self.extraTaskId = 0
    end

    self.bookRotSpeed = nil
    self.lock = nil

    self.arroundBook = nil
    self.centerBook = nil

    if self.loadTaskId ~=0 then
        MResLoader:CancelAsyncTask(self.loadTaskId)
        self.loadTaskId = 0
    end

    if self.extraTaskId ~= 0 then
        MResLoader:CancelAsyncTask(self.extraTaskId)
        self.extraTaskId = 0
    end

    self.isInDrag=false
    if self.objBook then
        MResLoader:DestroyObj(self.objBook)
        self.objBook = nil
    end

    if self.objBookRootGo then
        UnityEngine.Object.Destroy(self.objBookRootGo)
        self.objBookRootGo = nil
    end

    self.books = nil
    self.objBookRotTrans = nil


    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ThemeDungeonArroundCtrl:OnActive()

    -- 播放声音
    MAudioMgr:Play("event:/Ambience/Interact/XianZheHuiYi_Click")

    MEntityMgr.HideNpcAndRole = true
    
    MPlayerInfo:CloseCameraMask(MLayer.MASK_PLAYER)
    MPlayerInfo:CloseCameraMask(MLayer.MASK_DUMMY)
    MPlayerInfo:CloseCameraMask(MLayer.MASK_TRANSPARENT_FX)
    MPlayerInfo:CloseCameraMask(MLayer.MASK_MONSTER)

    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)
    if l_npcEntity then
        l_npcEntity.Model.Layer = MLayer.ID_NPC_DEPTH
        MPlayerInfo:ApproachFocus2Entity(Vector3.New(unpack(l_data.CamConfig[1])), Vector3.New(unpack(l_data.CamConfig[3])),
            Vector3.New(unpack(l_data.CamConfig[2])), Vector3.New(unpack(l_data.CamConfig[4])), DG.Tweening.Ease.InCubic, 2.9)

        -- 延迟打开面板
      self.panel.ActivePanel.gameObject:SetActiveEx(false)
        self.waitOpenTimer = self:NewUITimer(function()
            self.panel.ActivePanel.gameObject:SetActiveEx(true)
        end, 2.9)
        self.waitOpenTimer:Start()

        if l_npcEntity.Model.Trans then
            self.arroundBook = l_npcEntity.Model.Trans:Find("Item_Collect_ShuBenXuanZhuan02")
            if self.arroundBook then
                MLuaCommonHelper.SetActiveEx(self.arroundBook.gameObject, false)
            end
        end

        -- 加载八本书
        self.loadTaskId = MResLoader:CreateObjAsync("Prefabs/Item_Scene_Shu", function(uobj, sobj, taskId)
                self.loadTaskId = 0
                self.objBook = uobj
                -- 八本书的根节点
                -- self.objBookRotTrans = self.objBook.transform:Find("Item_Scene_Shu5")
                if not self.objBookRootGo then
                    self.objBookRootGo = GameObject.New("Item_Scene_Shu")
                end
                self.objBook.transform:SetParent(self.objBookRootGo.transform, false)
                self.objBookRotTrans = self.objBook.transform
                MLuaCommonHelper.SetLocalRotEuler(self.objBookRotTrans, 0, 0, 0)
                --todo 疑似切换场景先卸载NPC再卸载异步
                if l_npcEntity == nil then return end
                -- MLuaCommonHelper.SetParent(self.objBook, l_npcEntity.Model.UObj)
                --位置
                local l_tempPos = l_npcEntity.Model.Position
                self.objBookRootGo.transform.position = Vector3.New(l_tempPos.x,l_tempPos.y - 0.38,l_tempPos.z)
                --缩放
                self.objBookRootGo.transform.localScale = l_npcEntity.Model.Scale
                --旋转
                local l_tempRotation = l_npcEntity.Model.Rotation.eulerAngles
                self.objBookRootGo.transform.rotation = Quaternion.Euler(l_tempRotation.x + 3.63, l_tempRotation.y, l_tempRotation.z);

                -- 为什么不用Helper接口赋值 因为l_npcEntity.Model.UObj可能在为空 但是Mode对象里面的属性其实是能取到
                -- MLuaCommonHelper.SetPosToOther(self.objBookRootGo, l_npcEntity.Model.UObj)
                -- MLuaCommonHelper.SetLocalScaleToOther(self.objBookRootGo, l_npcEntity.Model.UObj)
                -- MLuaCommonHelper.SetRotEulerToOther(self.objBookRootGo, l_npcEntity.Model.UObj)
                -- MLuaCommonHelper.SetRotEulerX(self.objBookRootGo, self.objBookRootGo.transform.eulerAngles.x + 3.63)
                -- MLuaCommonHelper.SetPosY(self.objBookRootGo, self.objBookRootGo.transform.position.y - 0.38)
                local l_animator = self.objBookRotTrans:GetComponent("Animator")
                self.objBook:SetActiveEx(false)
                MCommonFunctions.SetLayerRecursive(self.objBook.transform, MLayer.ID_NPC_DEPTH)

                l_animator:Play("Item_Scene_Shu_DaKai", -1, 0)
                self.objBook:SetActiveEx(true)

                self.books = {}
                for i = 1, 8 do
                    local l_trans = self.objBookRotTrans:Find(StringEx.Format("Item_Scene_Shu{0}", i))
                    self.books[i] = l_trans.gameObject
                    self.books[i]:SetActiveEx(true)
                end

                local l_pos = self.objBookRotTrans.position
                l_pos.y = l_pos.y + 1.6
                self:CreateFx(l_commonFxPath .. "Fx_Scenes_ZhuTiFuBen_ShuXuanZhuan_01", l_pos, -1, nil, Vector3.New(2, 2, 2), Quaternion.Euler(0, 180, 0))
            end, self)

    else
        logError("ThemeDungeonArroundCtrl cannot find npc, id=", l_data.ThemeDungeonNPCId)
    end

    self.panel.Award:SetActiveEx(false)
    local l_anim = self.panel.ImageBox.transform:GetComponent("DOTweenAnimation")
    l_mgr.RequestGetThemeWeekAward(true, function()
        if not self.panel then return end

        self.panel.Award:SetActiveEx(true)

		if l_anim then
			l_anim:DORestart()
			l_anim:DOPlayForward()
        end
        
        self:ShowAwardCanGetFx()

    end, true)

    self:RefreshThemeDungeonInfos()

    self.themeDungeonMgr:RequestGetThemeDungeonInfo()
end --func end
--next--
function ThemeDungeonArroundCtrl:OnDeActive()

    MEntityMgr.HideNpcAndRole = false
    
    MPlayerInfo:OpenCameraMask(MLayer.MASK_PLAYER)
    MPlayerInfo:OpenCameraMask(MLayer.MASK_DUMMY)
    MPlayerInfo:OpenCameraMask(MLayer.MASK_TRANSPARENT_FX)
    MPlayerInfo:OpenCameraMask(MLayer.MASK_MONSTER)

    MPlayerInfo:FocusToMyPlayer()
    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)-- or self.npcEntity
    
    if l_npcEntity then
        l_npcEntity.Model.Layer = MLayer.ID_NPC
        if l_npcEntity.Model.Trans then
            local l_arroundBook = l_npcEntity.Model.Trans:Find("Item_Collect_ShuBenXuanZhuan02")
            if l_arroundBook then
                MLuaCommonHelper.SetActiveEx(l_arroundBook.gameObject, true)
            end
        end
    else
        if self.arroundBook and MLuaCommonHelper.IsNull(self.arroundBook) == false then
            MLuaCommonHelper.SetActiveEx(self.arroundBook.gameObject, true)
        end

        if self.centerBook and MLuaCommonHelper.IsNull(self.centerBook) == false then
            MLuaCommonHelper.SetActiveEx(self.centerBook.gameObject, true)
        end
    end
end --func end
--next--
function ThemeDungeonArroundCtrl:Update()

end --func end

--next--
function ThemeDungeonArroundCtrl:OnReconnected()
    super.OnReconnected(self)
    
    if self.reconnectTimer then
        self:StopUITimer(self.reconnectTimer)
        self.reconnectTimer = nil
    end

    local function _resetLayer()
        local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)
        if l_npcEntity then
            l_npcEntity.Model.Layer = MLayer.ID_NPC_DEPTH
        end    
    end

    _resetLayer()

    self.reconnectTimer = self:NewUITimer(function()
        _resetLayer()
    end, 0.5, 3)
    self.reconnectTimer:Start()
end --func end


--next--
function ThemeDungeonArroundCtrl:BindEvents()
    self:BindEvent(self.themeDungeonMgr.EventDispatcher, self.themeDungeonMgr.EventType.ThemeDungeonUIClosed, function()
        self:OnCloseDetailEvent()
    end)

    self:BindEvent(self.themeDungeonMgr.EventDispatcher,self.themeDungeonMgr.EventType.ThemeDungeonInfoChanged,function()
        self.panel.ChallengeDungeonBtn:SetActiveEx(self.themeDungeonMgr.curThemeId ~= -1)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function ThemeDungeonArroundCtrl:CloseUI()

    UIMgr:DeActiveUI(self.name)
end


function ThemeDungeonArroundCtrl:GetSafeIndex(index)
    local l_result = (index - 1) % l_bookCount
    if l_result < 0 then
        l_result = l_result + l_bookCount
    end

    return l_result + 1
end

function ThemeDungeonArroundCtrl:AfterDragEnd()

    local l_transform = self.objBookRotTrans
    local l_y = l_transform.localRotation.eulerAngles.y % 360
    self.curSceneBookIndex = math.floor((l_y / (360 / l_bookCount)) + 0.5) + 1

    local l_curRotation = l_transform.localRotation.eulerAngles
    local l_targetRotation = Vector3.New(l_curRotation.x, (360 / l_bookCount) * (self.curSceneBookIndex - 1), 0)
    -- logError("AfterDragEnd", self.curSceneBookIndex, l_curRotation, l_targetRotation)
    self.waitTweenId = MUITweenHelper.TweenRotationByEuler(l_transform.gameObject, l_curRotation, l_targetRotation, math.abs(l_targetRotation.y - l_curRotation.y) / self.bookRotSpeed, function()
        self.waitTweenId = nil
        self:UpdateUIState(true)
    end)
end


function ThemeDungeonArroundCtrl:JumpToSceneBook(bookIndex, isChangePage)
    if self.waitTweenId then
        return
    end

    self.curSceneBookIndex = bookIndex

    local l_endAngle = (self.curSceneBookIndex-1) * (360 / l_bookCount)
    local l_transform = self.objBookRotTrans
    local l_curRotation = l_transform.localRotation.eulerAngles
    -- 永远转小圈
    if l_endAngle - l_curRotation.y > 180 then
        l_endAngle = l_endAngle - 360
    elseif l_endAngle - l_curRotation.y < -180 then
        l_endAngle = l_endAngle + 360
    end

    local l_rotateTime = math.abs(l_endAngle - l_curRotation.y) / self.bookRotSpeed
    if isChangePage then
        l_endAngle = l_endAngle + 360
        l_rotateTime = math.abs(l_endAngle - l_curRotation.y) / self.bookRotSpeed / 5
    end

    l_nextRotation = Vector3.New(l_curRotation.x, l_endAngle, 0)
    self:UpdateUIState(false)
    self.waitTweenId = MUITweenHelper.TweenRotationByEuler(l_transform.gameObject, l_curRotation, l_nextRotation, l_rotateTime, function()
        self.waitTweenId = nil
        self:UpdateUIState(true)
    end)
end

function ThemeDungeonArroundCtrl:UpdateUIState(flag)
    if self.panel == nil then
        return
    end
    self.panel.ScrollView.CanvasGroup.alpha = flag and 1 or 0
    if flag then
        self:RefreshThemeDungeonInfos()
    end
end

function ThemeDungeonArroundCtrl:ClearDetailTimer()
    if self.openTimer then
        self:StopUITimer(self.openTimer)
        self.openTimer = nil
    end

    if self.closeBookTimer then
        self:StopUITimer(self.closeBookTimer)
        self.closeBookTimer = nil
    end

    if self.openBookFxTimer then
        self:StopUITimer(self.openBookFxTimer)
        self.openBookFxTimer = nil
    end
end

function ThemeDungeonArroundCtrl:RefreshPage()
    self.panel.UpBtn:SetActiveEx(self.curPage > 1)
    self.panel.DownBtn:SetActiveEx(self.curPage < self.constMaxPage)
    self.panel.UpText.LabText = self.curPage - 1
    self.panel.DownText.LabText = self.curPage + 1
    self.panel.PageText.LabText = self.curPage

    self.panel.Page:SetActiveEx(self.constMaxPage > 1)

    self:RefreshThemeDungeonInfos()
end

function ThemeDungeonArroundCtrl:OpenBook()

    local l_themeDungeonId = self:GetThemeDungeonIdByBookIndex(1)
    local l_themeRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(l_themeDungeonId, true)
    -- 暂未开放
    if not l_themeRow then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
        return
    end

    self.lock = true

    self:ClearDetailTimer()

    -- 打开界面
    self.openTimer = self:NewUITimer(function()
        UIMgr:ActiveUI(UI.CtrlNames.Theme_Story, {themeDungeonId = l_themeDungeonId})

        local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)
        if l_npcEntity and l_npcEntity.Model.Trans then
            self.centerBook = l_npcEntity.Model.Trans:Find("Item_Collect_ShuBenXuanZhuan01")
            if self.centerBook then
                MLuaCommonHelper.SetActiveEx(self.centerBook.gameObject, false)
            end
        end
        self.lock = false
    end, 3.4)
    self.openTimer:Start()

    for k, v in pairs(self.extraBooks) do
        v:SetActiveEx(false)
    end

    self.canvas.enabled = false

    MPlayerInfo:ApproachFocus2Entity(Vector3.New(unpack(l_data.CamConfig[3])), Vector3.New(unpack(l_data.CamConfig[5])),
            Vector3.New(unpack(l_data.CamConfig[4])), Vector3.New(unpack(l_data.CamConfig[6])), DG.Tweening.Ease.InOutSine, 1.8)
    self.closeBookTimer = self:NewUITimer(function()
        self:FindSomeOneToClose(function()
            local l_index = self:GetSafeIndex(self.curSceneBookIndex)
            for k, v in pairs(self.books) do
                if k ~= l_map[l_index] then
                    v:SetActiveEx(false)
                end
            end
        end)
    end, 1.8)
    self.closeBookTimer:Start()

    --self.openBookFxTimer = self:NewUITimer(function()
    --    self:CreateFx(l_commonFxPath .. "Fx_Scenes_ZhuTiFuBen_ShuDaKai_01", Vector3.New(61.08, 16.875, 82.053), 2.4)
    --end, 2.3)
    --
    --self.openBookFxTimer:Start()
end

function ThemeDungeonArroundCtrl:OnCloseDetailEvent()
    for k, v in pairs(self.extraBooks) do
        v:SetActiveEx(false)
    end
    for k, v in pairs(self.books) do
        v:SetActiveEx(true)
    end

    self.canvas.enabled = true

    MPlayerInfo:ApproachFocus2Entity(Vector3.New(unpack(l_data.CamConfig[5])), Vector3.New(unpack(l_data.CamConfig[3])),
            Vector3.New(unpack(l_data.CamConfig[6])), Vector3.New(unpack(l_data.CamConfig[4])), DG.Tweening.Ease.Linear, 0)

    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)
    if l_npcEntity and l_npcEntity.Model.Trans then
        local l_centerBook = l_npcEntity.Model.Trans:Find("Item_Collect_ShuBenXuanZhuan01")
        if l_centerBook then
            MLuaCommonHelper.SetActiveEx(l_centerBook.gameObject, true)
        end
    end
end

local l_themeBookPosConfig = {
    [1] = {
        pos = {-0.0229, 1.0728, 2.3199},
        rot = {-7.767, -0.329, 0.533}
    },
    [2] = {
        pos = {-0.0058, 1.0676, 2.3452},
        rot = {-7.767, -0.329, -0.76}
    },
    [3] = {
        pos = {0.002, 1.074, 2.333},
        rot = {-7.767, -0.329, 0.533}
    },
    [4] = {
        pos = {0.002, 1.071, 2.271},
        rot = {-6.595, -0.318, 0.53}
    },
    [5] = {
        pos = {-0.0229, 1.0728, 2.3199},
        rot = {-7.767, -0.329, 0.533}
    },
    [6] = {
        pos = {-0.0058, 1.0676, 2.3452},
        rot = {-7.767, -0.329, -0.76}
    },
    [7] = {
        pos = {0.002, 1.074, 2.333},
        rot = {-7.767, -0.329, 0.533}
    },
    [8] = {
        pos = {0.002, 1.071, 2.271},
        rot = {-6.595, -0.318, 0.53}
    }
}

function ThemeDungeonArroundCtrl:FindSomeOneToClose(callback)

    if self.extraTaskId > 0 then
        return
    end

    local l_index = self:GetSafeIndex(self.curSceneBookIndex)

    local l_npcEntity = MNpcMgr:FindNpcInViewport(l_data.ThemeDungeonNPCId)
    if l_npcEntity then
        local l_bookIndex = l_map[l_index]

        local l_playAnimfunc = function()
            local l_animator = self.extraBooks[l_bookIndex]:GetComponent("Animator")
            self.extraBooks[l_bookIndex]:SetActiveEx(false)
            self.extraBooks[l_bookIndex]:SetActiveEx(true)
            l_animator:Play("Item_Scene_Shu" .. l_bookIndex .. "_ShuDaKai", -1, 0)

            -- l_animator.speed = -1
        end
        if self.extraBooks[l_bookIndex] == nil then
            if self.extraTaskId ~= 0 then
                MResLoader:CancelAsyncTask(self.extraTaskId)
                self.extraTaskId = 0
            end

            self.extraTaskId = MResLoader:CreateObjAsync("Prefabs/Item_Scene_Shu" .. l_bookIndex, function(uobj, sobj, taskId)
                if not self.panel then
                    MResLoader:DestroyObj(uobj)
                    return
                end

                self.extraBooks[l_bookIndex] = uobj
                self.extraTaskId = 0
                MLuaCommonHelper.SetParent(self.extraBooks[l_bookIndex], l_npcEntity.Model.UObj)
                MLuaCommonHelper.SetLocalScale(self.extraBooks[l_bookIndex], 1, 1, 1)
                MLuaCommonHelper.SetLocalRotEuler(self.extraBooks[l_bookIndex], unpack(l_themeBookPosConfig[l_bookIndex].rot))
                MLuaCommonHelper.SetLocalPos(self.extraBooks[l_bookIndex], unpack(l_themeBookPosConfig[l_bookIndex].pos))
                MCommonFunctions.SetLayerRecursive(self.extraBooks[l_bookIndex].transform, MLayer.ID_NPC_DEPTH)
                uobj:SetActiveEx(true)
                l_playAnimfunc()
                self.books[l_map[l_index]]:SetActiveEx(false)
                callback()
            end, self)
        else
            self.books[l_map[l_index]]:SetActiveEx(false)
            l_playAnimfunc()
            callback()
        end
    end
end

function ThemeDungeonArroundCtrl:CreateFx(path, pos, time, parent, scaleFac, rotation)
    
    time = time or -1

    local l_fxData = {}
    l_fxData.playTime = time
    l_fxData.position = pos
    l_fxData.parent = parent
    l_fxData.layer = MLayer.ID_NPC_DEPTH
    if rotation then
        l_fxData.rotation = rotation
    end
    if scaleFac then
        l_fxData.scaleFac = scaleFac
    end

    l_fxData.destroyHandler = function ()
        self.fxs[path] = nil
    end

    if self.fxs[path] and self.fxs[path] ~= -1 then
        self:DestroyUIEffect(self.fxs[path])
        self.fxs[path] = nil
    end

    self.fxs[path] = self:CreateEffect(path, l_fxData)
end

function ThemeDungeonArroundCtrl:CloseTimer()
    
    if self.fxTimer then
        self:StopUITimer(self.fxTimer)
        self.fxTimer = nil
    end
end

-- 正面第一本的书的index为1，逆时针递增
function ThemeDungeonArroundCtrl:GetThemeDungeonIdByBookIndex(index)
    return (self.curSceneBookIndex + index - 2) % l_bookCount + 1 + l_bookCount*(self.curPage-1)
end

-- 通过ui上的书本获取对应的场景中的书本
function ThemeDungeonArroundCtrl:GetSceneBookIndexByUiBookIndex(index)
    -- ui上面朝前方的第一个本的index是3
    return (self.curSceneBookIndex + index -4) % l_bookCount + 1
end

-- 刷新书本信息
function ThemeDungeonArroundCtrl:RefreshThemeDungeonInfos()
    for i = 1, l_bookCount do
        if self.panel.ChapterName[i] then
            local l_themeDungeonId = self:GetThemeDungeonIdByBookIndex(i)
            local l_themeRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(l_themeDungeonId, true)
            local l_isOpen = l_themeRow ~= nil
            self.panel.NameBg[i]:SetActiveEx(l_isOpen)
            self.panel.DungeonName[i]:SetActiveEx(l_isOpen)
            self.panel.ChapterName[i]:SetActiveEx(l_isOpen)
            self.panel.NotOpen[i]:SetActiveEx(not l_isOpen)
            self.panel.Lock[i]:SetActiveEx(l_isOpen)
            if l_themeRow then
                self.panel.ChapterName[i].LabText = l_themeRow.SortChapterText
                self.panel.DungeonName[i].LabText = l_themeRow.ThemeName
                local l_isLocked = MPlayerInfo.Lv < l_themeRow.ChapterLevel
                self.panel.Lock[i]:SetActiveEx(l_isLocked)
                self.panel.LockText[i].LabText = Lang("THEME_DUNGEON_LOCK_FORMAT", l_themeRow.ChapterLevel)
            end
        end
    end
end

function ThemeDungeonArroundCtrl:InitEventListeners()
    local l_speedRate = MGlobalConfig:GetFloat("BookDragSpeed", 1) * 0.1
    local l_dragStart = function(...)
        if self.waitTweenId or self.lock then
            return
        end
        self.isInDrag = true
        self:UpdateUIState(false)
    end

    local l_drag = function(_, e)
        if self.isInDrag and self.objBookRotTrans and self.objBookRotTrans.transform then
            self.objBookRotTrans.transform:Rotate(0, -e.delta.x * l_speedRate, 0)
        end
    end

    local l_dragEnd = function(...)
        if self.isInDrag then
            MAudioMgr:Play("event:/Ambience/Interact/XianZheHuiYi_Shift")

            self.isInDrag = false
            self:AfterDragEnd()
        end
    end

    local l_click = function(index, ...)
        if self.waitTweenId or self.lock then
            return
        end

        -- ui上面朝前方的第一个本的index是3
        -- 只有第一本书是可以打开的
        if index == 3 then
            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeStory) then
                self:OpenBook()
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
            end
        else
            MAudioMgr:Play("event:/Ambience/Interact/XianZheHuiYi_Shift")

            self:JumpToSceneBook(self:GetSceneBookIndexByUiBookIndex(index))
            self:RefreshThemeDungeonInfos()
        end
    end

    for i = 1, l_bookCount do
        local l_listener = MLuaUIListener.Get(self.panel.Collider[i].gameObject)
        l_listener.beginDrag = function (...)
            l_dragStart(...)
        end
        l_listener.onDrag = function (...)
            l_drag(...)
        end
        l_listener.endDrag = function (...)
            l_dragEnd(...)
        end
        local l_cachePos = nil
        l_listener.onDown = function()
            l_cachePos = Input.mousePosition
        end
        l_listener.onUp = function()
            if not l_cachePos then
                return
            end
            local l_new = Input.mousePosition
            if math.abs(l_new.x - l_cachePos.x) <= 5 and math.abs(l_new.y - l_cachePos.y) <= 5 then
                l_click(i)
            end
            l_cachePos = nil
        end
    end

    local l_listener = MLuaUIListener.Get(self.panel.ScrollView.gameObject)
    l_listener.beginDrag = function (...)
        l_dragStart(...)
    end
    l_listener.onDrag = function (...)
        l_drag(...)
    end
    l_listener.endDrag = function (...)
        l_dragEnd(...)
    end
end

function ThemeDungeonArroundCtrl:ShowAwardCanGetFx()
    local l_effectFxData = {}
    l_effectFxData.rawImage = self.panel.Fx.RawImg
    l_effectFxData.scaleFac = Vector3.New(2, 2, 2) 
    self.panel.Fx.gameObject:SetActiveEx(false)
    l_effectFxData.loadedCallback = function(a) self.panel.Fx.gameObject:SetActiveEx(true) end
    l_effectFxData.destroyHandler = function ()
        self.awardCanGetFx = nil
    end
    self.awardCanGetFx = self:CreateUIEffect("Effects/Prefabs/Creature/Common/Fx_Common_TiXing_01", l_effectFxData)
end

--lua custom scripts end
return ThemeDungeonArroundCtrl