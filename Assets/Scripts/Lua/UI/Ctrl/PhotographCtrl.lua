--this file is gen by script
--you can edit this file in custom part
--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PhotographPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
PhotographCtrl = class("PhotographCtrl", super)
--lua class define end

--lua functions
function PhotographCtrl:ctor()

    super.ctor(self, CtrlNames.Photograph, UILayer.Function, nil, ActiveType.Exclusive)

    self.IsGroup = true

    self.IgnoreHidePanelNames = {CtrlNames.SelectElement}
    self.cameraType = "Photo"
    self.showMoveOnActive = true
    self.GroupMaskType = GroupMaskType.None --不加bg
    --拍完之后不关闭
    self.closeAfterTakePhoto = false
    self.countDownCameraObj = nil
    self.takePhotoWhenOpen = false
    self.autoSave = false

    self.loadBordTaskId = 0

    --特殊拍照流程
    self.ActiveSpecialTakeCamera = nil
    self.CloseSpecialTakeCamera = nil

end --func end
--next--
function PhotographCtrl:Init()

    MgrMgr:GetMgr("AlbumMgr").InitFolder()
    self.panel = UI.PhotographPanel.Bind(self)
	super.Init(self)

    self._isTakePhoto = false
    self.fashionData = DataMgr:GetData("FashionData")

    self.panel.BtnClose:AddClick(function() self:OnClose() end)
    self.panel.BtnTakePhoto:AddClick(function() self:OnTakePhoto() end)
    self.panel.BtnExpression:AddClick(function() self:OnExpression() end)
    self.panel.BtnBeautify:AddClick(function() self:OnBeautify() end)
    self.panel.BtnChat:AddClick(function() self:OnChat() end)
    self.panel.BtnSendMessage:AddClick(function() self:OnSendChatMessage() end)
    self.panel.BtnSetup:AddClick(function() self:OnSetup() end)
    self.panel.SliderCameraSize:OnSliderChange(function(v)
        v = 1-v
        local maxValue = MScene.GameCamera.CurrentModeComponent.MaxDistance * 1.0
        local minValue = MScene.GameCamera.CurrentModeComponent.MinDistance * 1.0
        MPlayerInfo.CameraDistance = (maxValue - minValue) * v + minValue
    end)
    self.panel.SliderCameraSize.Slider.minValue = 0.0
    self.panel.SliderCameraSize.Slider.maxValue = 1.0
    local l_txtPlaceHolder = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.InputMessage.transform:Find("Placeholder"))
    self.panel.InputMessage.Input.onSelect = function(eventData)
        l_txtPlaceHolder.LabText = ""
    end
    self.panel.InputMessage.Input.onDeselect = function(eventData)
        l_txtPlaceHolder.LabText = Common.Utils.Lang("CHAT_CLICK_INPUT_HINT")
    end
    self:InitShowTypeTog()
    self.borderObj = nil
    self.cachedInfo = {}
    self.cachedElementUIState = nil

end --func end
--next--
function PhotographCtrl:Uninit()

    if self.loadBordTaskId ~=0 then
        MResLoader:CancelAsyncTask(self.loadBordTaskId)
        self.loadBordTaskId = 0
    end
    if self.borderObj ~= nil then
        Object.Destroy(self.borderObj)
    	self.borderObj = nil
    
    end
    
    if self.photoTex ~= nil then
        Object.Destroy(self.photoTex)
    end

    self.photoTex = nil
    self.cachedInfo = {}
    self.cachedElementUIState = nil

    self.countDownCameraObj = nil
    self.takePhotoWhenOpen = false
    self.autoSave = false
    super.Uninit(self)
    self.panel = nil

    --特殊拍照流程
    self.ActiveSpecialTakeCamera = nil
    self.CloseSpecialTakeCamera = nil
    self.closeAfterTakePhoto = false

end --func end
--next--
function PhotographCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == self.fashionData.EUIOpenType.FASHION_PHOTO then
            self:InitWithTakeFashionPhoto(self.uiPanelData.callBack)
        end
        if self.uiPanelData.openType == self.fashionData.EUIOpenType.COUNTDOWN_CAMERA then
            self:InitWithCountDownCamera(self.uiPanelData.cameraObj, self.uiPanelData.judge, self.uiPanelData.autoSave)
        end
        if self.uiPanelData.openType == self.fashionData.EUIOpenType.SPECIAL_PHOTO then
            self:SetCameraType(self.uiPanelData.photoType)
            if self.uiPanelData.targetPos ~= nil then
                if self.uiPanelData.photoType == "VR360Photo" then
                    local l_timer = self:NewUITimer(function()
                        MEventMgr:LuaFireEvent(MEventType.MEvent_CamPhotoTarget, MScene.GameCamera, self.uiPanelData.targetPos)
                    end, 0.05)
                    l_timer:Start()
                else
                    local l_timer = self:NewUITimer(function()
                        local l_vector = string.ro_split(self.uiPanelData.targetPos, ",")
                        print(self.uiPanelData.targetPos)
                        print(l_vector[1])
                        MEventMgr:LuaFireEvent(MEventType.MEvent_CamPhotoRot, MScene.GameCamera, l_vector[1], l_vector[2], true)
                    end, 0.05)
                    l_timer:Start()
                end
            end
        end
    end

    if MPlayerInfo.IsPhotoMode ~= true then
        MPlayerInfo.IsPhotoMode = true
    end
    if self.ActiveSpecialTakeCamera ~= nil then
        self:ActiveSpecialTakeCamera()
    else
        self:CommonActive()
    end

    self:ResetBorderSize()
end --func end
--next--
function PhotographCtrl:OnDeActive()

    self:CustomHideUI()
    self.cameraType = "Photo"
    if self.CloseSpecialTakeCamera then
        self:CloseSpecialTakeCamera()
        self.CloseSpecialTakeCamera = nil
    end
    MPlayerInfo.IsPhotoMode = false
    self._isTakePhoto=false

end --func end

-- 隐藏
function PhotographCtrl:OnHide()

    self:CustomHideUI()
    self._isTakePhoto=false

end

--next--
function PhotographCtrl:Update()

end --func end

--next--
function PhotographCtrl:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts
-----------------------初始化---------------------------------

--初始化选择选项按钮
function PhotographCtrl:InitShowTypeTog()

    self:InitSingleTog("PlayerSelf")
    self:InitSingleTog("TeamMember")
    self:InitSingleTog("Guild")
    self:InitSingleTog("Friend")
    self:InitSingleTog("Mercenary")
    self:InitSingleTog("Couple")
    self:InitSingleTog("OtherPlayer")
    self:InitSingleTog("NPC")
    self:InitSingleTog("Monster")
    self:InitSingleTog("FX")
    self:InitSingleTog("PlayerName")
    self:InitSingleTog("GameInfo")

end

function PhotographCtrl:InitSingleTog(enumName)

    self.panel["Tog"..enumName].Tog.isOn = MPlayerInfo:IsMatchCameraShowMode(MoonClient.CameraShowType[enumName])
    self.panel["Tog"..enumName]:OnToggleChanged(function(b)
        MPlayerInfo:SetShowMode(MoonClient.CameraShowType[enumName], b)
    end)

end

--初始化选择相机按钮
function PhotographCtrl:InitCameraTypeSelectBtn()

    self:InitSingleCameraTypeSelectBtn("Photo")
    self:InitSingleCameraTypeSelectBtn("SelfPhoto")
    self:InitSingleCameraTypeSelectBtn("VR360Photo")
    self:InitSingleCameraTypeSelectBtn("ARPhoto")

    local l_activeBtnCom = self.panel["Btn"..self.cameraType]
    if l_activeBtnCom == nil then
        logError("不存在照相类型为 "..self.cameraType.."的情况！！！ 可用的情况只有 Photo SelfPhoto VR360Photo ARPhoto")
        return
    end
    self:SetCameraTypeSelectBtnActive(l_activeBtnCom, true)
    self:TryChangeCamearaMode(self.cameraType)

end

function PhotographCtrl:SetCameraType(cameraTypeName)
    self.cameraType = cameraTypeName
end

function PhotographCtrl:InitSingleCameraTypeSelectBtn(cameraTypeName)

    if cameraTypeName == "ARPhoto" then
        self.panel["Btn"..cameraTypeName]:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_OPEN_PLEASE_WAITTING"))
        end)
        return
    end

    self.panel["Btn"..cameraTypeName]:AddClick(function()
        self:TryChangeCamearaMode(cameraTypeName)
    end)

end

function PhotographCtrl:ChangeCamearaMode(cameraTypeName)

    if self.panel == nil then
        return
    end

    cameraTypeName = cameraTypeName or "Photo"

    if MPlayerInfo.CurrentPhotoCameraMode ~= MoonClient.MCameraState.SelfPhoto
        and cameraTypeName == "SelfPhoto"
        and MEntityMgr.PlayerEntity.InBattle then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PHOTOGRAPH_CANNOT_SELFY_IN_BATTLE"))
            return
    end

    if MPlayerInfo.CurrentPhotoCameraMode ~= MoonClient.MCameraState.SelfPhoto
        and cameraTypeName == "SelfPhoto"
        and MEntityMgr.PlayerEntity.IsClimb then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PHOTOGRAPH_CANNOT_SELFY_IN_CLIMB"))
            return
    end

    if MPlayerInfo.CurrentPhotoCameraMode ~= MoonClient.MCameraState.SelfPhoto
        and cameraTypeName == "SelfPhoto"
        and MEntityMgr.PlayerEntity.CurrentState == ROGameLibs.StateDefine.kStateCollect then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PHOTOGRAPH_CANNOT_SELFY_IN_COLLECT"))
            return
    end

    local l_selectPanel = self.panel.PhotoTypeSelectPanel.transform
    for i = 0, l_selectPanel.childCount-1 do
        local l_child = l_selectPanel:GetChild(i).gameObject
        self:SetCameraTypeSelectBtnActive(l_child:GetComponent("MLuaUICom"), false)
    end

    MPlayerInfo.CurrentPhotoCameraMode = MoonClient.MCameraState[cameraTypeName]
    self:SetCameraTypeSelectBtnActive(self.panel["Btn"..cameraTypeName], true)
    self.cameraType = cameraTypeName
    self:OnExpression(true)

end

function PhotographCtrl:TryChangeCamearaMode(cameraTypeName)

    if MPlayerInfo.CurrentPhotoCameraMode == MoonClient.MCameraState[cameraTypeName] then
        return
    end

    --自拍模式状态互斥切换
    if cameraTypeName == "SelfPhoto"  then
        --状态互斥检测可行性
        if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_E_Photo) then
            return
        end
        --TODO 临时直接拦截变身时自拍
        if MEntityMgr.singleton.PlayerEntity.IsTransfigured then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_CANNOT_SELFY_NOW"))
            return
        end
        
        MgrMgr:GetMgr("SyncTakePhotoStatusMgr").PreCheckOperateLegalArg(_,MExlusionStates.State_E_Photo,function()
            self:ChangeCamearaMode(cameraTypeName)
        end)
    else
        self:ChangeCamearaMode(cameraTypeName)
    end

end

--设置按钮外观
function PhotographCtrl:SetCameraTypeSelectBtnActive(typeBtnCom, active)

    local l_showContent = typeBtnCom.transform:GetChild(0)
    local l_content = l_showContent:GetComponent("Image") or l_showContent:GetComponent("Text")
    if active then
        typeBtnCom:SetSprite("Photograph", "UI_Photograph_TypeBtn01.png")
        l_content.color = Color.New(255/255.0, 255/255.0, 255/255.0, 185/255.0)
    else
        typeBtnCom:SetSprite("Photograph", "UI_Photograph_TypeBtn02.png")
        l_content.color = Color.New(90/255.0, 105/255.0, 127/255.0, 255/255.0)
    end

end

-----------------------初始化---------------------------------
-----------------------事件回调-------------------------------
--关闭
function PhotographCtrl:OnClose()

    MPlayerInfo.CurrentPhotoCameraMode = MoonClient.MCameraState.Photo
    UIMgr:DeActiveUI(UI.CtrlNames.Photograph)

end

--照相
function PhotographCtrl:OnTakePhoto(callback)

    if self.panel == nil then
        return
    end

    if self._isTakePhoto then
        return
    end

    MAudioMgr:Play("event:/UI/Camera")

    self._isTakePhoto=true

    local photoObjectIds = MoonClient.MCheckInCameraManager.GetTriggerIds()
    self.panel.CameraPanel.gameObject:SetActiveEx(false)
    self:CloseDecalTools()
    --MUIManager:HideUI(MUIManager.MOVE_CONTROLLER);
    MgrMgr:GetMgr("MoveControllerMgr").HideMoveController()

    MUIManager.TransTips.gameObject:SetActiveEx(false)
    MUIManager.TransNormal.gameObject:SetActiveEx(false)
    MUIManager.TransGuiding.gameObject:SetActiveEx(false)

    MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_BeforeTakePhoto)
    UIMgr:DeActiveUI(UI.CtrlNames.TipsDlg)

    self:CacheElementUIState()

    MScreenCapture.TakeScreenShotWithRatio(16 / 9, self.panel.BorderPanel.RectTransform, function(l_photo)

        local l_info = table.ro_deepCopy(self.cachedInfo)
        l_info.role_id = MPlayerInfo.UID
        local l_entity = MEntityMgr.PlayerEntity
        local l_pos = l_entity.Position
        l_info.x = l_pos.x
        l_info.y = l_pos.y
        l_info.z = l_pos.z
        l_info.scene_id = MScene.SceneID
        l_info.operate_type = self:GetPhotoType(self.cameraType)

        if l_info.expression_id then
            if Time.realtimeSinceStartup >= l_info.expression_id_time then
                l_info.expression_id = 0
            end
        end

        if l_info.action_id then
            if Time.realtimeSinceStartup >= l_info.action_id_time then
                l_info.action_id = 0
            end
        end

        self:ResetBorderSize()

        local l_isShare = MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto -- 时尚评分需要添加分享按钮
        --MgrMgr:GetMgr("AlbumMgr").OpenPhotoByScreenCapture(l_photo,nil , nil, false, false, false)
        MgrMgr:GetMgr("AlbumMgr").OpenPhotoByTexture(l_photo,CtrlNames.Photograph , l_info, not self.closeAfterTakePhoto, self.autoSave, l_isShare)
        self.panel.CameraPanel.gameObject:SetActiveEx(true)
        self:OpenDecalTools()
        MgrMgr:GetMgr("MoveControllerMgr").ShowMoveController()
        --MUIManager:ShowUI(MUIManager.MOVE_CONTROLLER)
        UIMgr:ActiveUI(UI.CtrlNames.TipsDlg)

        MUIManager.TransTips.gameObject:SetActiveEx(true)
        MUIManager.TransNormal.gameObject:SetActiveEx(true)
        MUIManager.TransGuiding.gameObject:SetActiveEx(true)

        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_TakePhotoFinish)
        GlobalEventBus:Dispatch(EventConst.Names.PhotographCompleted, photoObjectIds,self.cameraType)

        if callback ~= nil then
            callback()
        end
    end)

end

--打开表情
function PhotographCtrl:OnExpression(isNotNeedActive)

    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.SelectElement)
    if l_ctrl then
        l_ctrl:RemoveAllHandler()
        l_ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
        if MPlayerInfo.CurrentPhotoCameraMode ~= MoonClient.MCameraState.SelfPhoto then
            l_ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
        end
        l_ctrl:SetupHandlers()
    else
        if isNotNeedActive then
            return
        end
        UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
            ctrl:RemoveAllHandler()
            ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
            if MPlayerInfo.CurrentPhotoCameraMode ~= MoonClient.MCameraState.SelfPhoto then
                ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
            end
            ctrl:SetupHandlers()
        end, {InsertPanelName=UI.CtrlNames.Photograph})
    end

end

--美化
function PhotographCtrl:OnBeautify()

    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.SelectElement)
    if l_ctrl then

        if l_ctrl.handlers[UI.HandlerNames.SelectElementShowDecal] ~= nil and l_ctrl.handlers[UI.HandlerNames.SelectElementShowBorder] ~= nil then
            return
        end

        l_ctrl:RemoveAllHandler()
        l_ctrl:AddHandler(UI.HandlerNames.SelectElementShowDecal, Lang("PHOTOGRAPH_DECAL"))
        l_ctrl:AddHandler(UI.HandlerNames.SelectElementShowBorder, Lang("PHOTOGRAPH_BORDER"))
        l_ctrl:SetupHandlers()
    else
        UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
            ctrl:RemoveAllHandler()
            ctrl:AddHandler(UI.HandlerNames.SelectElementShowDecal, Lang("PHOTOGRAPH_DECAL"))
            ctrl:AddHandler(UI.HandlerNames.SelectElementShowBorder, Lang("PHOTOGRAPH_BORDER"))
            ctrl:SetupHandlers()
        end,{InsertPanelName=UI.CtrlNames.Photograph})
    end

end

--打开聊天
function PhotographCtrl:OnChat()

    local l_panel = self.panel.ChatPanel.gameObject
    l_panel:SetActiveEx(not l_panel.activeSelf)

end

--发送消息
function PhotographCtrl:OnSendChatMessage()

    local l_uid = MEntityMgr.PlayerEntity.UID
    local l_msg =  self.panel.InputMessage.Input.text
    local l_channel = DataMgr:GetData("ChatData").EChannel.CurSceneChat

    MgrMgr:GetMgr("ChatMgr").SendChatMsg(MEntityMgr.PlayerEntity.UID, l_msg, l_channel)
    self.panel.InputMessage.Input.text = ""
    self.InputMessage = l_msg
    self:SetInputMessage(l_msg)

end

--打开设置
function PhotographCtrl:OnSetup()

    local l_panel = self.panel.SetupPanel.gameObject
    l_panel:SetActiveEx(not l_panel.activeSelf)

end

--修改相机尺寸
function PhotographCtrl:GetSliderValueByCameraDistance(value)

    local maxValue = MScene.GameCamera.CurrentModeComponent.MaxDistance * 1.0
    local minValue = MScene.GameCamera.CurrentModeComponent.MinDistance * 1.0
    return (value - minValue) / (maxValue - minValue)

end

-----------------------事件回调------------------------------
-----------------------贴纸----------------------------------
function PhotographCtrl:OpenDecalTools()

    local l_content = self.panel.DecalPanel.transform
    for i = 0, l_content.childCount - 1 do
        local l_child = l_content:GetChild(i)
        l_child:Find("BtnDecelExit").gameObject:SetActiveEx(true)
        l_child:Find("BtnDecalScale").gameObject:SetActiveEx(true)
    end

end

function PhotographCtrl:CloseDecalTools()
    local l_content = self.panel.DecalPanel.transform
    for i = 0, l_content.childCount - 1 do
        local l_child = l_content:GetChild(i)
        l_child:Find("BtnDecelExit").gameObject:SetActiveEx(false)
        l_child:Find("BtnDecalScale").gameObject:SetActiveEx(false)
    end
end

function PhotographCtrl:ShowDecal(atlas, decal, decalID)

    local l_decalTable = {}
    local l_newInstance = self:CloneObj(self.panel.DecalInstance.gameObject)
    local l_instanceTran = l_newInstance.transform
    local l_uiCom = l_newInstance:GetComponent("MLuaUICom")

    l_instanceTran:SetParent(self.panel.DecalPanel.transform)
    l_newInstance.gameObject:SetActiveEx(true)
    l_instanceTran.localScale = Vector3.New(1, 1, 1)
    l_instanceTran.localPosition = Vector3.New(0, 0, 0)
    l_uiCom:SetSprite(atlas, decal, true)

    local l_exitBtn = l_instanceTran:Find("BtnDecelExit").gameObject:GetComponent("MLuaUICom")
    local l_scaleDragItemCom = l_instanceTran:Find("BtnDecalScale").gameObject:GetComponent("MLuaUICom")

    l_exitBtn:AddClick(function()
        MResLoader:DestroyObj(l_newInstance)
        self:RemoveDecalID(decalID)
    end)

    l_scaleDragItemCom.ScaleAdjustItem.onChange = function()
        local l_localScale = 1 / l_newInstance.transform.localScale.x
        l_exitBtn.transform:SetLocalScale(l_localScale, l_localScale, l_localScale)
        l_scaleDragItemCom.transform:SetLocalScale(l_localScale, l_localScale, l_localScale)
    end

    l_decalTable.exitBtn = l_exitBtn
    l_decalTable.scaleDragItem = l_scaleDragItemCom

    l_decalTable.CloseTool = function(self)
        self.exitBtn.gameObject:SetActiveEx(false)
        self.l_scaleDragItemCom.gameObject:SetActiveEx(false)
    end

    l_decalTable.OpenTool = function(self)
        self.exitBtn.gameObject:SetActiveEx(true)
        self.l_scaleDragItemCom.gameObject:SetActiveEx(true)
    end

    self:AddDecalID(decalID)
    return l_decalTable

end

function PhotographCtrl:ShowBorder(borderName, borderID)

    if self.borderObj ~= nil then
        Object.Destroy(self.borderObj)
    end
    self.loadBordTaskId = MResLoader:CreateObjAsync("UI/Prefabs/PhotoBorder/"..borderName, function(uobj, sobj, taskId)

        self.loadBordTaskId = 0
        self.borderObj = uobj
        self.borderObj.transform:SetParent(self.panel.BorderPanel.transform)
        self.borderObj.transform:SetAsFirstSibling()
        self.borderObj.transform:SetLocalScaleOne()
        local l_rectTran = self.borderObj:GetComponent("RectTransform")
        l_rectTran.offsetMax = Vector2.New(0, 0)
        l_rectTran.offsetMin = Vector2.New(0, 0)

    end, self)

end

function PhotographCtrl:CommonActive()

    self.panel.SetupPanel.gameObject:SetActiveEx(false)
    self.panel.ChatPanel.gameObject:SetActiveEx(false)
    self.panel.SliderCameraSize.Slider.value = 1 - self:GetSliderValueByCameraDistance(MScene.GameCamera.CurrentModeComponent.DefaultDistance)
    self:BindEvent(GlobalEventBus,EventConst.Names.CameraDistanceChange, function(self, distance)
        self.panel.SliderCameraSize.Slider.value = 1 - self:GetSliderValueByCameraDistance(distance)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.OnCloseShowPhoto, function(self)
        self:ResetElementUIState()
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.ClosePhotograph, function(self)
        self:OnClose()
    end)
    self:InitCameraTypeSelectBtn()
    UIMgr:DeActiveUI(UI.CtrlNames.SelectElement)

end

function PhotographCtrl:CustomHideUI()

end

-----------------------贴纸----------------------------------

function PhotographCtrl:SetBorder(borderID)
    self.cachedInfo.borderID = borderID or 0
end

function PhotographCtrl:AddDecalID(decalID)

    if not self.cachedInfo.decals then
        self.cachedInfo.decals = {}
    end
    table.insert(self.cachedInfo.decals, decalID)

end

function PhotographCtrl:RemoveDecalID(decalID)

    if not self.cachedInfo.decals then
        return
    end

    for i, v in ipairs(self.cachedInfo.decals) do
        if v == decalID then
            table.remove(self.cachedInfo.decals, i)
            break
        end
    end

end

function PhotographCtrl:SetInputMessage(message)

    self.cachedInfo.message = message
    self.cachedInfo.message_time = Time.realtimeSinceStartup + 3.8

end

function PhotographCtrl:SetExpression(expression_id, time)

    self.cachedInfo.expression_id = expression_id
    self.cachedInfo.expression_id_time = Time.realtimeSinceStartup + time

end

function PhotographCtrl:GetPhotoType(photo_type_str)

    if photo_type_str == "SelfPhoto" then
        return 2
    elseif photo_type_str == "VR360Photo" then
        return 1
    elseif photo_type_str == "ARPhoto" then
        return 3
    else
        return 0
    end

end

function PhotographCtrl:SetAction(action_id)

    self.cachedInfo.action_id = action_id
    self.cachedInfo.action_id_time = Time.realtimeSinceStartup + 10

end

function PhotographCtrl:CacheElementUIState()

    self.cachedElementUIState = nil
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.SelectElement)
    if l_ctrl and l_ctrl.handlerTable and l_ctrl.curHandler then
        self.cachedElementUIState = {
            handlersName = table.ro_deepCopy(l_ctrl.handlerTable),
            curHandlerName = l_ctrl.curHandler.name,
        }
        UIMgr:DeActiveUI(UI.CtrlNames.SelectElement)
    end

end

function PhotographCtrl:ResetElementUIState()

    if not self.cachedElementUIState then
        return
    end

    if UIMgr:IsActiveUI(UI.CtrlNames.SelectElement) then
        self.cachedElementUIState = nil
        return
    end

    if not self.cachedElementUIState then
        return
    end

    local l_data = table.ro_deepCopy(self.cachedElementUIState)
    UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
        ctrl:RemoveAllHandler()

        for i, v in ipairs(l_data.handlersName) do
            ctrl:AddHandler(unpack(v))
        end

        ctrl:SetDefaultHandler(l_data.curHandlerName)
        ctrl:SetupHandlers()
    end, {InsertPanelName=UI.CtrlNames.Photograph})
    self.cachedElementUIState = nil

end
------------------倒计时拍照---------------------------

--相机物体
--是否打开时直接拍照
function PhotographCtrl:InitWithCountDownCamera(cameraObj, takePhotoWhenOpen, autoSave)

    if takePhotoWhenOpen == nil then
        takePhotoWhenOpen = false
    end
    if autoSave == nil then
        self.autoSave = false
    end

    self.closeAfterTakePhoto = true
    self.initWithCountDownCamera = true
    self.countDownCameraObj = cameraObj
    self.takePhotoWhenOpen = takePhotoWhenOpen
    self.autoSave = autoSave
    self.ActiveSpecialTakeCamera = self.ActiveWithCountDownCamera
    self.CloseSpecialTakeCamera = self.CloseWithCountDownCamera

end

function PhotographCtrl:ActiveWithCountDownCamera()

    self.panel.ChatPanel.gameObject:SetActiveEx(false)
    self.panel.BtnChat.gameObject:SetActiveEx(false)
    self.panel.PhotoTypeSelectPanel.gameObject:SetActiveEx(false)
    self.panel.SliderCameraSize.gameObject:SetActiveEx(false)
    self.panel.BtnBeautify.gameObject:SetActiveEx(false)
    self.panel.BtnTakePhoto.gameObject:SetActiveEx(false)
    self.panel.SetupPanel.gameObject:SetActiveEx(false)

    MCameraHelper.SetCountDownCamera(self.countDownCameraObj)

    if self.takePhotoWhenOpen then
        self:OnTakePhoto()
    end

end

function PhotographCtrl:CloseWithCountDownCamera()
    MgrMgr:GetMgr("CountDownTakePhotoMgr").StopCountDownTakePhoto()
end
------------------倒计时拍照---------------------------
------------------时尚拍照逻辑start-------------------------

local l_fashionTakePhotoCallback
local l_lastCameraShowTypes
function PhotographCtrl:InitWithTakeFashionPhoto(callback)

    l_fashionTakePhotoCallback = callback
    self.closeAfterTakePhoto = true
    self.ActiveSpecialTakeCamera = self.ActiveWithTakeFashionPhoto
    self.CloseSpecialTakeCamera = self.CloseWithTakeFashionPhoto

end


function PhotographCtrl:ActiveWithTakeFashionPhoto()

    self.panel.BtnClose.gameObject:SetActiveEx(false)
    self.panel.BtnTakePhoto.gameObject:SetActiveEx(false)
    self.panel.ChatPanel.gameObject:SetActiveEx(false)
    self.panel.BtnChat.gameObject:SetActiveEx(false)
    self.panel.PhotoTypeSelectPanel.gameObject:SetActiveEx(false)
    self.panel.SliderCameraSize.gameObject:SetActiveEx(false)
    self.panel.BtnBeautify.gameObject:SetActiveEx(false)
    -- self.panel.BtnExpression.gameObject:SetActiveEx(false)
    self.panel.BtnTakePhoto.gameObject:SetActiveEx(false)
    self.panel.SetupPanel.gameObject:SetActiveEx(false)

    self.panel.TogPlayerSelf.Tog.isOn = true
    self.panel.TogPlayerSelf.Tog.interactable = false
    self.panel.TogPlayerSelf.gameObject:SetActiveEx(false)

    self.panel.TogTeamMember.Tog.isOn = true
    self.panel.TogTeamMember.Tog.interactable = true

    self.panel.TogOtherPlayer.Tog.isOn = false
    self.panel.TogOtherPlayer.Tog.interactable = false
    self.panel.TogOtherPlayer.gameObject:SetActiveEx(false)

    self.panel.TogNPC.Tog.isOn = false
    self.panel.TogNPC.Tog.interactable = false
    self.panel.TogNPC.gameObject:SetActiveEx(false)

    self.panel.TogMonster.Tog.isOn = false
    self.panel.TogMonster.Tog.interactable = false
    self.panel.TogMonster.gameObject:SetActiveEx(false)

    self.panel.TogFX.Tog.isOn = false
    self.panel.TogFX.Tog.interactable = false
    self.panel.TogFX.gameObject:SetActiveEx(false)

    self.panel.TogPlayerName.Tog.isOn = false
    self.panel.TogPlayerName.Tog.interactable = false
    self.panel.TogPlayerName.gameObject:SetActiveEx(false)

    self.panel.TogGameInfo.Tog.isOn = false
    self.panel.TogGameInfo.Tog.interactable = false
    self.panel.TogGameInfo.gameObject:SetActiveEx(false)

    MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto = true
    -- 设置时尚评分3D相机的仰角
    MPlayerInfo:SetCameraRotRangeLimit(MgrMgr:GetMgr("FashionRatingMgr").FashionCameraTiltRange.x, MgrMgr:GetMgr("FashionRatingMgr").FashionCameraTiltRange.x, MgrMgr:GetMgr("FashionRatingMgr").FashionCameraTiltRange.y)
    -- TODO 不应该直接需改内存中配置的值
    MoonClient.CameraPhotoData.MIN_DIS = MgrMgr:GetMgr("FashionRatingMgr").FashionCameraDistanceRange.x
    MoonClient.CameraPhotoData.MAX_DIS = MgrMgr:GetMgr("FashionRatingMgr").FashionCameraDistanceRange.y
    MoonClient.CameraPhotoData.ADAPTER_THRESHOLD = 0
    MPlayerInfo.CameraDistance = MgrMgr:GetMgr("FashionRatingMgr").FashionCameraDistanceRange.x

    l_lastCameraShowTypes = MPlayerInfo.CameraShowTypes

    MEventMgr:LuaFireEvent(MEventType.MEvent_CamCusomOffset,
        MScene.GameCamera, MgrMgr:GetMgr("FashionRatingMgr").FashionPhotoFocusOffset)

    local l_openData = {
        time = MgrMgr:GetMgr("FashionRatingMgr").FashionCameraCountDown,
        callback = function()
            self:OnTakePhoto()
            MPlayerInfo.CameraShowTypes = l_lastCameraShowTypes
            if l_fashionTakePhotoCallback ~= nil then
                l_fashionTakePhotoCallback()
            end
            l_fashionTakePhotoCallback = nil
            l_lastCameraShowTypes = nil
        end
    }
    UIMgr:ActiveUI(UI.CtrlNames.BigCountDown, l_openData)

end


function PhotographCtrl:CloseWithTakeFashionPhoto()

    MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto = false
    -- 恢复时尚评分3D相机仰角范围限制
    MPlayerInfo:RecoveCameraRotRange()
    local l_str = Common.Utils.Lang("Week" .. tostring(MgrMgr:GetMgr("FashionRatingMgr").FashionMagazineTime[0]))
    l_str = l_str .. StringEx.SubString(MgrMgr:GetMgr("FashionRatingMgr").FashionMagazineTime[1], 0, 1) .. ":" .. StringEx.SubString(MgrMgr:GetMgr("FashionRatingMgr").FashionMagazineTime[1], 1, 2)
    CommonUI.Dialog.ShowOKDlg(true, nil, Common.Utils.Lang("FashionRatingFinishDialog", l_str, MgrMgr:GetMgr("FashionRatingMgr").FashionLeaderboardCount))

end

------------------时尚拍照逻辑end

function PhotographCtrl:ResetBorderSize()

    local l_borderRect = self.panel.BorderPanel.RectTransform
    --边框大小重新设置回原来的大小
    l_borderRect.offsetMax = Vector2.New(0, 0)
    l_borderRect.offsetMin = Vector2.New(0, 0)
    -- 异形屏重新设置锚点
    if not MoonClient.SpecialDeviceInfo.SafeAreaIsFullscreen() then
        log("ResetBorderSize", l_borderRect.rect, MoonClient.SpecialDeviceInfo.SafeArea, Screen.width, Screen.height)
        local l_safeArea = MoonClient.SpecialDeviceInfo.SafeArea
        local l_minX = l_safeArea.x / Screen.width
        local l_minY = l_safeArea.y / Screen.height
        local l_maxX = (Screen.width - l_safeArea.width - l_safeArea.x) / Screen.width
        local l_maxY = (Screen.height - l_safeArea.height - l_safeArea.y) / Screen.height
        if l_maxX < 0 then l_maxX = 0 end
        if l_minX < 0 then l_minX = 0 end
        if l_maxY < 0 then l_maxY = 0 end
        if l_minY < 0 then l_minY = 0 end
        local l_scaleX = Screen.width / l_safeArea.width
        local l_scaleY = Screen.height / l_safeArea.height
        l_borderRect.anchorMin = Vector2.New(-l_minX * l_scaleX, -l_minY * l_scaleY)
        l_borderRect.anchorMax = Vector2.New(1 + l_maxX * l_scaleX, 1 + l_maxY * l_scaleY)
    end
end

--lua custom scripts end
return PhotographCtrl