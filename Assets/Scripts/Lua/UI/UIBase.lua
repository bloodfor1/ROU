module("UI", package.seeall)

---@class UIBase
UIBase = class("UIBase")

EUICacheLv = {
    None = -1,
    VeryLow = 0,
    Low = 1,
    Middle = 2,
    High = 3,
    VeryHigh = 4,
}

--事件系统需要的相关参数
eventSystem = nil
pointEventData = nil
pointRes = nil

------------------------------- 生命周期 -------------------------------
--[Comment]
--@inheritable
--Class
function UIBase:ctor()

    self.uObj = nil                     --当前UI的资源保存             
    self._panelSound = nil                --音频播放组件保存
    self.uTrans = nil                   --资源Obj的Transform缓存
    self._basePanelAsyncLoadTaskId = 0              --当前资源加载的任务Id缓存 底层使用 外部不需要关注
    self.cacheGrade = EUICacheLv.None   --缓存级别
    self.isInited = false               --是否初始化完成 在执行了Init之后设置
    self.isActive = false               --是否执行了Active函数 在执行了Active后设置为true 在执行了DeActive后设置为false 理论上外部不需要使用这个参数
    self.isShowing = false              --是否显示状态 界面是否处于打开状态
    self.isReactive = false             --是否是二次激活同一个UI 该变量用于判定是否需要在OnDeactive里面重置数据
    self._isBindEventsFinish = false     --是否绑定结束了事件
    self.usePool = false                --资源卸载 是否回池
    self.guideArrow = nil               --新手指引箭头

    self._panelCSharpClassReference = nil

    self.supportPassThrough = false       --是否支持透传
    self.passThroughCount = 0             --可透传次数

    self.eventDispatchers = {}          --用于存储事件相关
    self.uiModels = {}                  --用于存储UI模型相关
    self.uiEffects = {}                 --用于存储业务特效
    self.uiTimers = {}                  --用于存储业务的Timer
    self.uiPanelData = {}               --用于存储由UIManager在ActiveUI的时候传递的Data数据
    self.cloneTmpls = {}
    ---@type BaseUITemplate[]
    self.templates = {}
    ---@type UI_TemplatePoolCommon[]
    self.templatePools = {}
    self._redSignProcessors = {}

    self.panelMask = nil

    --------------------头像相关--------------------------
    self.head2dList = {}     -- Head2D的GameObject的列表
    ------------------------------------------------------

end

---------------------------------------------------- Start 生命周期 -------------------------------------------------------



---------------------------------------------------- End 生命周期 ----------------------------------------------------------

--[Comment]
--@inheritable
-- 加载资源（Active&LoadUI时调用）
-- 加载prefab相关资源，并实例化
function UIBase:Load(callBack)
    -- 正在加载中重复调用的保护
    if self:_isPanelLoading() then
        return
    end
    if self.uObj ~= nil then
        logError("UI " .. self.name .. " is already loaded")
        return
    end

    local l_location = "UI/Prefabs/" .. self.name
    self._basePanelAsyncLoadTaskId = MResLoader:CreateObjAsync(l_location, function(uobj, sobj, taskId)
        self:OnLoaded(uobj, callBack)
    end, self, self.usePool)
end

--[Comment]
--@inheritable
-- 加载资源完成
function UIBase:OnLoaded(obj, callBack)
    self._basePanelAsyncLoadTaskId = 0
    if not obj then
        logError("cannot load ui GameObject, name=" .. self.name)
        return
    end

    obj.name = self.name
    self.uObj = obj
    self._panelSound = self.uObj:GetComponent("PanelSound")
    self.uTrans = obj.transform
    -- 挂载obj到对应层
    self:_AddObjToParent()

    MLuaCommonHelper.SetLocalPos(obj, 0, 0, 0)
    MLuaCommonHelper.SetLocalRot(obj, 0, 0, 0, 0)
    MLuaCommonHelper.SetLocalScale(obj, 1, 1, 1)
    MLuaCommonHelper.SetRectTransformOffset(obj, 0, 0, 0, 0)

    if self:IsCached() then
        --如果是缓存的UI，那么尝试提前把相关Bundle卸载
        local l_location = "UI/Prefabs/" .. self.name
        MResLoader:RequestUnloadBundle(l_location, ".prefab")
    end

    self:Init()

    if callBack ~= nil then
        callBack(self)
    end
end

---@param panelRef MoonClient.MLuaUIPanel
function UIBase:OnBindPanel(panelRef)
    self.isFullScreen = panelRef.IsFullScreen
    self._panelCSharpClassReference = panelRef
end

--[Comment]
--@inheritable
-- 释放资源
function UIBase:Unload()

    if self:_isPanelLoading() then
        MResLoader:CancelAsyncTask(self._basePanelAsyncLoadTaskId)
        self._basePanelAsyncLoadTaskId = 0
    end

    self._panelSound = nil
    if self.uObj ~= nil then
        MResLoader:DestroyObj(self.uObj, self.usePool)
        self.uObj = nil
    end
    self.uTrans = nil
end

--界面物体是否存在
function UIBase:_isGameObjectExist()
    if self.uObj == nil then
        return false
    end
    if MLuaCommonHelper.IsNull(self.uObj) then
        return false
    end
    return true
end

--[Comment]
--@inheritable
--初始化（OnLoaded后调用）
function UIBase:Init()
    self.isInited = true
end

--[Comment]
--@inheritable
--销毁（UnLoad后调用&关闭游戏进程后调用）
function UIBase:Uninit()
    self.isInited = false

    if self.panelMask then
        self.panelMask:Uninit()
        self.panelMask = nil
    end

    --加载的头像回池
    self:DestroyHead2Ds()

    for i = #self._redSignProcessors, 1, -1 do
        self:UninitRedSign(self._redSignProcessors[i])
    end
    self._redSignProcessors = {}

    for i = 1, #self.templates do
        self.templates[i]:Uninit()
    end
    self.templates = {}

    for i = 1, #self.templatePools do
        self.templatePools[i]:Uninit()
    end
    self.templatePools = {}

    for k, _ in pairs(self.cloneTmpls) do
        if not MLuaCommonHelper.IsNull(k) then
            MResLoader:ClearObjPool(k)
        end
    end

    self.cloneTmpls = {}
    self.supportPassThrough = false
    self.passThroughCount = 0
    self.passThroughObj = nil
    self.passThroughPhase = "Began"
    self.forcePassThrough = false
    self.uiPanelData = {}
    self.eventDispatchers = {}
end

--isNeedUnLoad 是否需要卸载本身Panel对象本身
function UIBase:_releaseAll(isNeedUnLoad)
    --Timer卸载
    self:DestroyAllUITimer()
    --卸载所有界面创建的特效
    self:DestroyAllUIEffect()
    --卸载所有界面创建的模型
    self:DestroyAllUIModel()
    --卸载界面对象 由Ctrl由自身IsCatch决定 Handler由Ctrl的isCatch决定
    if isNeedUnLoad then
        self:Unload()
        self.panel = nil
    end
end

function UIBase:_basePanelAfterOnActive()
    for i = 1, #self.templates do
        self.templates[i]:BaseTemplateOnPanelActive()
    end

    if self._panelSound then
        self._panelSound:PlaySound()
    end
end

--[Comment]
--@inheritable
--关闭UI后的处理（OnDeActive后调用）
function UIBase:_basePanelAfterOnDeActive()

    self._panelCSharpClassReference:ClearAllComponent()

    for i = 1, #self.templates do
        self.templates[i]:BaseTemplateOnPanelDeActive()
    end

    for i = 1, #self.templatePools do
        self.templatePools[i]:BaseTemplatePoolOnPanelDeActive()
    end

end

--对外提供绑定事件的接口
---@param eventDispatcher EventDispatcher @add 事件触发器
---@param eventKey string | number @add 事件名
---@param eventFunction function @add 事件回调
function UIBase:BindEvent(eventDispatcher, eventKey, eventFunction)
    if eventDispatcher == nil then
        logError("eventDispatcher is nil , self.name : " .. self.name)
        return
    end
    if eventKey == nil then
        logError("eventKey is nil , self.name : " .. self.name)
        return
    end
    if eventFunction == nil then
        logError("eventFunction is nil, self.name : " .. self.name)
        return
    end
    --事件eventDispatcher存储
    if self.eventDispatchers[eventDispatcher] == nil then
        self.eventDispatchers[eventDispatcher] = {}
    end
    --事件的Key存储
    if self.eventDispatchers[eventDispatcher].eventTable == nil then
        self.eventDispatchers[eventDispatcher].eventTable = {}
    end
    --存储
    table.insert(self.eventDispatchers[eventDispatcher], eventKey)
    eventDispatcher:Add(eventKey, eventFunction, self)
end

function UIBase:_basePanelBindEvents()
    if self._isBindEventsFinish then
        return
    end
    self._isBindEventsFinish = true
    self:BindEvents()
end

--[Comment]
--@private
--解绑事件
function UIBase:_basePanelUnBindEvents()
    if self._isBindEventsFinish == false then
        return
    end
    self._isBindEventsFinish = false
    for dispatcher, eventNames in pairs(self.eventDispatchers) do
        local l_dispatcher = dispatcher
        if l_dispatcher then
            for index, value in ipairs(eventNames) do
                l_dispatcher:RemoveObjectAllFunc(value, self)
                --logGreen(self.name,ToString(value))
            end
        else
            logError("eventdispatcher is nil self.name : " .. self.name)
        end
        self.eventDispatchers[dispatcher] = {}
    end
    self.eventDispatchers = {}
end

function UIBase:IsShowing()
    return self.isActive and self.isInited and self.isShowing
end

function UIBase:IsActive()
    return self.isActive and self.isInited
end

function UIBase:IsInited()
    return self.isInited
end

function UIBase:IsReactive()
    return self.isReactive
end

--外部调用显示界面
function UIBase:BasePanelShowUI(isPlayTween)
    self:_basePanelShowUI(isPlayTween)
end

function UIBase:BasePanelRefresh()
    self:OnHide()
    self:OnDeActive()
    self:OnActive()
    self:OnShow()
    self:_setVisible(true)
end

--[Comment]
--私有函数 设置层级 visible==true 设置UI层 visible==false 设置Invisible层 
function UIBase:_setVisible(isVisible)
    if self.isInited == false then
        return
    end
    if not self:_isGameObjectExist() then
        logError("界面物体不存在,界面名字："..tostring(self.name))
        return
    end
    if MLuaCommonHelper.IsNull(self._panelCSharpClassReference) then
        logError("界面引用的CSharp类不存在,界面名字："..tostring(self.name))
        return
    end

    self._panelCSharpClassReference:SetVisible(isVisible)
    self:_basePanelSetTemplateVisible(isVisible)
    self:_basePanelSetMaskVisible(isVisible)
end

--[Comment]
--私有函数 设置Canvase的射线检测
function UIBase:_setRaycaster(isEnabled)
    if self.isInited == false then
        return
    end
    self._panelCSharpClassReference:SetRaycastersEnabled(isEnabled)
end

--[Comment]
--控制template的显示与隐藏 @param bool enable true:显示 false:隐藏
function UIBase:_basePanelSetTemplateVisible(enable)
    for i = 1, #self.templates do
        self.templates[i]:BaseTemplateOnPanelVisible(enable)
    end

    for i = 1, #self.templatePools do
        self.templatePools[i]:BaseTemplatePoolOnPanelVisible(enable)
    end
end

function UIBase:_basePanelSetMaskVisible(isVisible)
    if self.panelMask == nil then
        return
    end
    self.panelMask:SetVisible(isVisible)
end

--[Comment]
--判断该UI是否该缓存
--@des 缓存的UI在关闭时不会清除资源
function UIBase:IsCached()
    return self.cacheGrade ~= EUICacheLv.None and self.cacheGrade <= MQualityGradeSetting.GetCurLevel()
end

--[Comment]
--设置UI为不缓存
function UIBase:UnCacheUI()
    self.cacheGrade = EUICacheLv.None
end

--资源是否正在加载
function UIBase:_isPanelLoading()
    local isLoading = self._basePanelAsyncLoadTaskId > 0
    if Application.isEditor then
        local isHasAsyncTask = MResLoader:HasAsyncTask(self._basePanelAsyncLoadTaskId)
        if isLoading ~= isHasAsyncTask then
            LogError("缓存了Load任务id，但是并没有异步任务")
        end
    end
    return isLoading
end

function UIBase:CloneObj(obj, usePool)
    if obj == nil then
        logError("obj is nil on CloneObj")
        return nil
    end

    if self.cloneTmpls[obj] == nil then
        self.cloneTmpls[obj] = true
    end

    if usePool == nil then
        usePool = true
    end

    return MResLoader:CloneObj(obj, usePool)
end

--[Comment]
--@override
--打开UI（Active->BindEvents->OnActive->OnShow()->AfterOnActive())
function UIBase:Active()
end

--[Comment]
--@override
--关闭UI（Deactive->UnBindEvents->OnHide->OnDeActive->AfterOnDeActive())
function UIBase:DeActive()
end

--[Comment]
--@override
-- 窗口显示时（Active后调用）
function UIBase:OnActive()
end
--[Comment]
--@override
--窗口关闭时（DeActive后调用）
function UIBase:OnDeActive()
end

--[Comment]
--@override
--显示
function UIBase:OnShow()
    return false
end

--[Comment]
--@override
--隐藏
function UIBase:OnHide()
    return false
end

--[Comment]
--@override
--绑定事件(Active后&OnActive前调用)
function UIBase:BindEvents()
end

--[Comment]
--@override
-- 更新
function UIBase:Update()
end

--[Comment]
--@override
--触摸事件处理
function UIBase:UpdateInput(touchItem)
end

--[Comment]
--@override
--游戏登出
function UIBase:OnLogout()
end

--[Comment]
--@override
--断线重连
function UIBase:OnReconnected()
end

--[Comment]
--@override
--设置UI对象的父元素
function UIBase:_AddObjToParent()
end

------------------------------- 生命周期相关接口 -------------------------------

function UIBase:NewPanelMask(maskColor, maskDelayClickTime, clickMethod)
    if self.uTrans == nil then
        logError("遮罩创建的时机不对，界面还没创建时就调用了创建遮罩方法,界面名字："..tostring(self.name))
        return
    end

    self.panelMask = UIManager.UIGroupMask.new(self.uTrans, maskColor, maskDelayClickTime)
    self.panelMask:SetMaskClickMethod(clickMethod)
end

------------------------------- 创建模型相关 -----------------------------------
--[[ 
数据结构如下:
modelData = 
{
    defaultEquipId = ,
    presentId = ,
    rawImage = ,
}
]]--
--根据DefaultEquipId 创建模型
function UIBase:CreateUIModelByDefaultEquipId(modelData)
    if self.uiModels == nil then
        self.uiModels = {}
    end
    if modelData.rawImage == nil then
        logError("创建模型必须传RawImage对象~ 请相关程序检查自身逻辑。")
        return
    end
    if modelData.defaultEquipId == nil then
        logError("创建模型必须传defaultEquipId~ 请相关程序检查自身逻辑。")
        return
    end
    if modelData.presentId == nil then
        logError("创建模型必须传presentId~ 请相关程序检查自身逻辑。")
        return
    end
    local l_model = MUIModelManagerEx:CreateModelByDefaultEquipId(modelData.defaultEquipId, modelData.presentId, modelData.rawImage)
    --数据存储
    self:SaveModelData(l_model)
    return l_model
end

--[[ 
数据结构如下:
modelData = 
{
    itemId = ,
    rawImage = 
}
]]--
--根据ItemId 创建模型
function UIBase:CreateUIModelByItemId(modelData)
    if self.uiModels == nil then
        self.uiModels = {}
    end
    if modelData.rawImage == nil then
        logError("创建模型必须传RawImage对象~ 请相关程序检查自身逻辑。")
        return
    end
    if modelData.itemId == nil then
        logError("创建模型必须传itemId~ 请相关程序检查自身逻辑。")
        return
    end
    local l_model = MUIModelManagerEx:CreateModelByItemId(modelData.itemId, modelData.rawImage)
    --数据存储
    self:SaveModelData(l_model)
    return l_model
end

--[[ 
数据结构如下:
modelData = 
{
    prefabPath = ,
    rawImage = ,
    defaultAnim = ,
}
]]--
--根据PrefabPath 创建模型
function UIBase:CreateUIModelByPrefabPath(modelData)
    if self.uiModels == nil then
        self.uiModels = {}
    end
    if modelData.rawImage == nil then
        logError("创建模型必须传rawImage对象~请相关程序检查自身逻辑。")
        return
    end
    if modelData.prefabPath == nil then
        logError("创建模型必须传prefabPath~请相关程序检查自身逻辑。")
        return
    end
    local l_model = MUIModelManagerEx:CreateModel(modelData.prefabPath, modelData.rawImage, modelData.defaultAnim or "")
    --数据存储
    self:SaveModelData(l_model)
    return l_model
end

--modelData存放的是一个模型数组的LuaTable数组
--本质就是C#里面的* MUIModelData * 这个数据结构
--常用的几个参数
function UIBase:CreateUIModel(modelData)
    if self.uiModels == nil then
        self.uiModels = {}
    end
    local l_modelData = MUIModelManagerEx:GetDataFromPool()
    
    if modelData.rawImage == nil then
        logError("创建模型必须传RawImage对象~请相关程序检查自身逻辑。")
        return
    end
        
    l_modelData.rawImage = modelData.rawImage or l_modelData.rawImage
    l_modelData.attr = modelData.attr or l_modelData.attr
    l_modelData.useShadow = modelData.useShadow or l_modelData.useShadow
    l_modelData.useOutLine = modelData.useOutLine or l_modelData.useOutLine
    l_modelData.useCustomLight = modelData.useCustomLight or l_modelData.useCustomLight
    l_modelData.isOneFrame = modelData.isOneFrame or l_modelData.isOneFrame
    l_modelData.isCameraMatrixCustom = modelData.isCameraMatrixCustom or l_modelData.isCameraMatrixCustom
    l_modelData.isCameraPosRotCustom = modelData.isCameraPosRotCustom or l_modelData.isCameraPosRotCustom
    l_modelData.cameraPos = modelData.cameraPos or l_modelData.cameraPos
    l_modelData.cameraRot = modelData.cameraRot or l_modelData.cameraRot
    l_modelData.vMatrix = modelData.vMatrix or l_modelData.vMatrix
    l_modelData.pMatrix = modelData.pMatrix or l_modelData.pMatrix
    l_modelData.customLightDirX = modelData.customLightDirX or l_modelData.customLightDirX
    l_modelData.customLightDirY = modelData.customLightDirY or l_modelData.customLightDirY
    l_modelData.customLightDirZ = modelData.customLightDirZ or l_modelData.customLightDirZ
    l_modelData.position = modelData.position or l_modelData.position
    l_modelData.scale = modelData.scale or l_modelData.scale
    l_modelData.rotation = modelData.rotation or l_modelData.rotation
    l_modelData.width = modelData.width or l_modelData.width
    l_modelData.height = modelData.height or l_modelData.height
    l_modelData.enablePostEffect = modelData.enablePostEffect or l_modelData.enablePostEffect
    l_modelData.position = modelData.position or l_modelData.position
    l_modelData.scale = modelData.scale or l_modelData.scale
    l_modelData.defaultAnim = modelData.defaultAnim or l_modelData.defaultAnim
    l_modelData.prefabPath = modelData.prefabPath or l_modelData.prefabPath
    l_modelData.isMask = modelData.isMask or l_modelData.isMask

    local l_model = MUIModelManagerEx:CreateModel(l_modelData)
    MUIModelManagerEx:ReturnDataToPool(l_modelData)
    --数据存储
    self:SaveModelData(l_model)
    return l_model
end

--模型数据存储
function UIBase:SaveModelData(uiModel)
    if uiModel == nil then
        return
    end
    if self.uiModels == nil then
        self.uiModels = {}
    end

    for key, value in pairs(self.uiModels) do
        if value == uiModel then
            self:DestroyUIModel(value)
        end
    end
    table.insert(self.uiModels, uiModel)
end

--直接卸载某一个模型对象
function UIBase:DestroyUIModel(uiModel)
    if self.uiModels == nil then
        return
    end
    if uiModel then
        local isExist = false
        for i = #self.uiModels, 1, -1 do
            if self.uiModels[i] == uiModel then
                table.remove(self.uiModels, i)
                isExist = true
                break
            end
        end
        if not isExist then
            logRed("卸载某个Self没有存储的UIModel 相关程序查看下逻辑~ ：UIName :" .. self.name)
        end
        MUIModelManagerEx:DestroyModel(uiModel)
        uiModel = nil
    end
end

--关闭界面 卸载所有由该UI创建的模型
function UIBase:DestroyAllUIModel()
    if self.uiModels then
        for key, value in pairs(self.uiModels) do
            MUIModelManagerEx:DestroyModel(value)
        end
        self.uiModels = nil
    end
end
------------------------------- 创建模型相关 -----------------------------------

------------------------------- 创建特效相关 -----------------------------------
--[[ 
数据结构如下:
modelData = 
{
    effectPath = ,
    effectOriginData = 
}
]]--

function UIBase:_createEffectData(effectOriginData)
    if self.uiEffects == nil then
        self.uiEffects = {}
    end

    if effectOriginData == nil then
        logError("创建模型必须传effectOriginData ~请相关程序检查自身逻辑。")
        return 0
    end

    local l_fxData = MFxMgr:GetDataFromPool()
    l_fxData.playTime = effectOriginData.playTime or l_fxData.playTime
    l_fxData.attachedModel = effectOriginData.attachedModel or l_fxData.attachedModel
    l_fxData.loadedCallback = effectOriginData.loadedCallback or l_fxData.loadedCallback
    l_fxData.destroyHandler = effectOriginData.destroyHandler or l_fxData.destroyHandler
    l_fxData.layer = effectOriginData.layer or l_fxData.layer
    l_fxData.follow = effectOriginData.follow or l_fxData.follow
    l_fxData.warningTime = effectOriginData.warningTime or l_fxData.warningTime
    l_fxData.mask = effectOriginData.mask or l_fxData.mask
    l_fxData.playTime = effectOriginData.playTime or l_fxData.playTime
    l_fxData.parent = effectOriginData.parent or l_fxData.parent
    l_fxData.scaleFac = effectOriginData.scaleFac or l_fxData.scaleFac
    l_fxData.position = effectOriginData.position or l_fxData.position
    l_fxData.rotation = effectOriginData.rotation or l_fxData.rotation
    l_fxData.uiSortOrder = effectOriginData.uiSortOrder or l_fxData.uiSortOrder
    l_fxData.rawImage = effectOriginData.rawImage or l_fxData.rawImage
    l_fxData.useVector3OneScale = effectOriginData.useVector3OneScale or l_fxData.useVector3OneScale
    return l_fxData
end

--创建普通特效
function UIBase:CreateEffect(effectPath, effectOriginData)
    local l_fxData = self:_createEffectData(effectOriginData)
    local l_effect = MFxMgr:CreateFx(effectPath, l_fxData)
    --数据存储
    self:SaveEffetcData(l_effect)
    MFxMgr:ReturnDataToPool(l_fxData)
    return l_effect
end

--创建UI特效的接口
function UIBase:CreateUIEffect(effectPath, effectOriginData)
    if effectOriginData.rawImage == nil then
        logError("创建模型必须传effectOriginData.rawImage ~请相关程序检查自身逻辑。")
        return 0
    end
    if self.uiEffects == nil then
        self.uiEffects = {}
    end
    local l_fxData = self:_createEffectData(effectOriginData)
    local l_effect = MFxMgr:CreateFxForRT(effectPath, l_fxData)
    --数据存储
    self:SaveEffetcData(l_effect)
    MFxMgr:ReturnDataToPool(l_fxData)
    return l_effect
end

--重播UI特效的接口
function UIBase:ReplayUIEffect(effectID, effectOriginData)
    if effectOriginData.rawImage == nil then
        logError("Replay模型必须传effectOriginData.rawImage ~请相关程序检查自身逻辑。")
    end
    if self.uiEffects == nil then
        self.uiEffects = {}
    end
    local l_fxData = self:_createEffectData(effectOriginData)
    MFxMgr:Replay(effectID, l_fxData)
    MFxMgr:ReturnDataToPool(l_fxData)
end

--特效创建数据存储
function UIBase:SaveEffetcData(uiEffectId)
    if uiEffectId == nil then
        return
    end
    if self.uiEffects == nil then
        self.uiEffects = {}
    end
    for key, value in pairs(self.uiEffects) do
        if value == uiEffectId then
            self:DestroyUIEffect(uiEffectId)
        end
    end
    table.insert(self.uiEffects, uiEffectId)
end

--根据特效Id卸载单个特效
function UIBase:DestroyUIEffect(uiEffectId)
    if self.uiEffects == nil then
        return
    end

    local isExist = false
    for i = #self.uiEffects, 1, -1 do
        if self.uiEffects[i] == uiEffectId then
            table.remove(self.uiEffects, i)
            isExist = true
            break
        end
    end
    if not isExist then
        logRed("卸载某个Self没有存储的UIEffect 相关程序查看下逻辑~ ：UIName :" .. self.name)
    end
    MFxMgr:DestroyFx(uiEffectId)
end

--关闭界面 卸载所有由该UI创建的模型
function UIBase:DestroyAllUIEffect()
    if self.uiEffects then
        for key, value in pairs(self.uiEffects) do
            MFxMgr:DestroyFx(value)
        end
        self.uiEffects = nil
    end
end
------------------------------- 创建特效相关 -----------------------------------

------------------------------- 创建Timer相关 -----------------------------------
--[[ 
参数如下:
modelData = 
{
    func = Timer回调函数,
    duration = 多久之后开始执行,
    loop = 是否循环,
    scale = false 采用deltaTime计时,true 采用 unscaledDeltaTime计时
}
]]--
--创建UITimer的接口
function UIBase:NewUITimer(func, duration, loop, scale)
    if self.uiTimers == nil then
        self.uiTimers = {}
    end
    local l_timer = Timer.New(func, duration, loop, scale)
    --数据存储
    self:SaveTimerData(l_timer)
    return l_timer
end

--Timer数据存储
function UIBase:SaveTimerData(uiTimer)
    if uiTimer == nil then
        return
    end
    if self.uiTimers == nil then
        self.uiTimers = {}
    end
    for key, value in pairs(self.uiTimers) do
        if value == uiTimer then
            self:StopUITimer(value)
        end
    end
    table.insert(self.uiTimers, uiTimer)
end

--停止某个Timer
function UIBase:StopUITimer(uiTimer)
    if self.uiTimers == nil then
        return
    end
    local isExist = false
    for i = #self.uiTimers, 1, -1 do
        if self.uiTimers[i] == uiTimer then
            table.remove(self.uiTimers, i)
            isExist = true
            break
        end
    end
    if not isExist then
        logRed("卸载某个Self没有存储的uiTimer 相关程序查看下逻辑~ ：UIName :" .. self.name)
    end
    if uiTimer then
        uiTimer:Stop()
        uiTimer = nil
    end
end

--关闭界面 卸载所有由该UI创建的Timer
function UIBase:DestroyAllUITimer()
    if self.uiTimers then
        for key, value in pairs(self.uiTimers) do
            value:Stop()
            value = nil
        end
        self.uiTimers = nil
    end
end
------------------------------- 创建Timer相关 -----------------------------------

------------------------------- Template相关 -----------------------------------
function UIBase:NewTemplate(templateName, data)

    require("UI/Template/" .. templateName)
    if data == nil then
        data = {}
    end

    data.ParentPanelClass=self
    local l_template = UITemplate[templateName].new(data)
    table.insert(self.templates, l_template)

    return l_template
end

function UIBase:UninitTemplate(template)

    if template == nil then
        logError("调用UninitTemplate，但是传递的是nil,界面名字："..tostring(self.name))
        return
    end

    table.ro_removeValue(self.templates, template)
    template:Uninit()
end

---@return UI_TemplatePoolCommon
function UIBase:NewTemplatePool(data)
    if data == nil then
        data={}
    end
    data.ParentPanelClass=self
    local l_templatePool = Common.UI_TemplatePool.new(data)
    table.insert(self.templatePools, l_templatePool)

    return l_templatePool
end

function UIBase:UninitTemplatePool(templatePool)

    if templatePool == nil then
        logError("调用UninitTemplatePool，但是传递的是nil,界面名字："..tostring(self.name))
        return
    end

    table.ro_removeValue(self.templatePools, templatePool)
    templatePool:Uninit()
end
------------------------------- Template相关 -----------------------------------

------------------------------- 新手引导+红点相关 -------------------------------
--销毁新手指引
function UIBase:UninitGuideArrow()
    --新手指引箭头销毁
    if self.guideArrow ~= nil then
        self:UninitTemplate(self.guideArrow)
        self.guideArrow = nil
        MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver(true)
    end
end

function UIBase:NewRedSign(redSignData)

    local l_parent
    if redSignData.RedSignParent then
        l_parent = redSignData.RedSignParent
    elseif redSignData.ClickButton then
        l_parent = redSignData.ClickButton.Transform
    elseif redSignData.ClickTogEx then
        l_parent = redSignData.ClickTogEx.Transform
    elseif redSignData.ClickTog then
        l_parent = redSignData.ClickTog.Transform
    elseif redSignData.Listener then
        l_parent = redSignData.Listener.Transform
    end
    redSignData.RedSignTemplate = self:NewTemplate("RedSignTemplate", {
        TemplateParent = l_parent
    })
    local l_redSignProcessor = MgrMgr:GetMgr("RedSignMgr").RedSignProcessor.new(redSignData)
    table.insert(self._redSignProcessors, l_redSignProcessor)
    return l_redSignProcessor

end

function UIBase:UninitRedSign(redSignProcessor)

    if redSignProcessor == nil then
        logError("调用UninitRedSign，但是传递的是nil,界面名字："..tostring(self.name))
        return
    end

    table.ro_removeValue(self._redSignProcessors, redSignProcessor)
    self:UninitTemplate(redSignProcessor:GetRedSignTemplate())
    redSignProcessor:Uninit()
end
------------------------------- 新手引导+红点相关 -------------------------------


--动态从池中创建Head2D的Obj
--parentTrans 需要挂在到的父节点Trans
---@return MoonClient.MHeadBehaviour
function UIBase:CreateHead2D(parentTrans, offsetX, offsetY, scale)
    local l_head2D = MResLoader:CreateObjFromPool("UI/Prefabs/Head2D")
    l_head2D.gameObject:SetActiveEx(true)
    l_head2D.transform:SetParent(parentTrans)
    l_head2D:SetLocalPos(offsetX or 0, offsetY or 0, 0)
    l_head2D:SetLocalScale(1, 1, 1)
    l_head2D:SetLocalRotEuler(0, 0, 0)
    local l_headCom = l_head2D:GetComponent("MHeadBehaviour")
    table.insert(self.head2dList, l_head2D)
    return l_headCom
end

--清理当前界面动态创建的所有Head2D的Obj
function UIBase:DestroyHead2Ds()
    for k, v in pairs(self.head2dList) do
        MResLoader:DestroyObj(v)
    end
    self.head2dList = {}

end

-------------------------------一些特殊的功能---------------------------------
--[Comment]
--获取第一个射线检测到的Obj
function UIBase:GetFirstRaycastObj(touchItem)
    self:updateEventInfos()
    pointRes:Clear()
    pointEventData.position = touchItem.Position
    eventSystem:RaycastAll(pointEventData, pointRes)
    if pointRes.Count > 0 then
        return pointRes[0].gameObject
    end
end

--目前透传目标需满足：1.实现了IPointerClickHandler的控件；2.开启了raycast
--注意：每个开启了透传的ctrl或handler均会执行一次透传方法（找到最近的目标执行点击函数）
--param@enable:使能透传
--param@count:透传的次数 0不可透传，-1永久透传，大于0只可透传的次数 (默认-1)
--param@force:强制透传 (默认false)
--param@gameObj:可透传的的对象
--param@afterClick:true代表点击事件之后检测透传 (默认false)
function UIBase:SetPassThroughFunc(enable, gameObj, force, count, afterClick)
    if count == 0 or not enable then
        self.supportPassThrough = false
        self.passThroughObj = nil
        return
    end
    self.supportPassThrough = true
    self.passThroughCount = count and count or -1
    self.passThroughObj = gameObj
    self.passThroughPhase = afterClick and "Ended" or "Began"
    self.forcePassThrough = force and true or false
end

function UIBase:updateEventInfos()
    if eventSystem == nil then
        eventSystem = EventSystem.current
    end
    if pointEventData == nil then
        pointEventData = PointerEventData.New(eventSystem)
    end
    if pointRes == nil then
        pointRes = RaycastResultList.New()
    end
end
function UIBase:GetEventSystemAndPointEventData()
    if eventSystem == nil then
        eventSystem = EventSystem.current
    end
    if pointEventData == nil then
        pointEventData = PointerEventData.New(eventSystem)
    end
    return eventSystem, pointEventData
end

--[Comment]
--处理透传
function UIBase:passThroughHandler(touchItem)
    if not self.isActive or not self.supportPassThrough or MLuaCommonHelper.IsNull(self.passThroughObj) then
        return
    end
    if tostring(touchItem.Phase) ~= self.passThroughPhase then
        return
    end
    if self.passThroughCount == 0 then
        self.supportPassThrough = false
        return
    elseif self.passThroughCount > 0 then
        self.passThroughCount = self.passThroughCount - 1
    end
    self:updateEventInfos()
    pointRes:Clear()
    pointEventData.position = touchItem.Position
    eventSystem:RaycastAll(pointEventData, pointRes)

    if pointRes.Count > 1 then
        local l_go = pointRes[0].gameObject
        if l_go.name == self.passThroughObj.name then
            local l_passThroughGo = pointRes[1].gameObject
            MLuaCommonHelper.ExecuteClickEvent(l_passThroughGo, pointEventData)
        elseif self.forcePassThrough then
            MLuaCommonHelper.ExecuteClickEvent(l_go, pointEventData)
        end
    end
end
-------------------------------End 一些特殊的功能---------------------------------

return UIBase