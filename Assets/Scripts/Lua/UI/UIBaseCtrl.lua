require("Data/BaseModel")
require "UI/UIBase"
require "Misc/UISupportBackDefine"

module("UI", package.seeall)

-- UI的基类
local super = UI.UIBase
---@class UIBaseCtrl : UIBase
UIBaseCtrl = class("UIBaseCtrl", super)

-- Tween动画类型
UITweenType = Common.CommonUIFunc.UITweenType

-- 层级定义
UILayer = {
    Normal = 0,
    Function = 1,
    Tips = 2,
    Guiding = 3,
    Top = 4,
}

-- 层级深度值
UILayerSort = {
    --设置为None为不覆盖层级，使用上级层级
    None = 0,
    [UILayer.Normal] = 20,
    [UILayer.Function] = 40,
    [UILayer.Tips] = 60,
    [UILayer.Guiding] = 80,
    [UILayer.Top] = 100,
    Normal = 20,
    Function = 40,
    Tips = 60,
    Guiding = 80,
    Top = 100,
}

-- UI展现类型
ActiveType = {
    None = 0,
    Normal = 1, --正常
    Exclusive = 2, --独占，会把所有Exclusive和Normal类的UI隐藏
    Standalone = 3 --独立
}

-- 遮罩颜色  需要特殊的自己加
BlockColor = {
    Dark = Color.New(0, 0, 0, 180 / 255), --默认黑色55%半透明
    Transparent = 1,
}

-- 遮罩类型
GroupMaskType = {
    None = 1, --没有遮罩
    Show = 2, --有遮罩
    Default = 3, --Exclusive类型界面并且不是全屏界面加遮罩
}

------------------------------- Start 生命周期 ------------------------------
--[Comment]
--@inheritable
--name -> uiName
--sortLayer -> uiLayerSort
--tweenType -> 动画类型
--activeType -> UI类型
function UIBaseCtrl:ctor(name, groupContainerType, tweenType, activeType)

    self.ActiveType = activeType and activeType or ActiveType.None -- UI类型
    self.GroupContainerType = groupContainerType          -- UI的层级 Top Normal Function等
    self.GroupMaskType = GroupMaskType.Default --默认带遮罩
    self.panelParent = nil

    self.name = name                    -- uiName
    self.canvas = nil                   -- 存储当前UI的Canvas组件引用
    self.rootUObj = nil                 -- 存储Handler所属的父对象
    self.isFullScreen = false           -- 标识是否全屏界面
    self.stopMoveOnActive = false       -- 打开时停止移动，只针对Exclusive
    self.showMoveOnActive = false       -- 打开状态下显示移动框，只针对Exclusive
    self.overrideSortLayer = nil        -- 打开的时候主动设置Canvas的SortingOrder
    self.IsCloseOnSwitchScene = false     -- 是否需要且场景,关闭当前UI 默认是不关闭
    self.IsTakePartInGroupStack = UISupportBackDefine.Get(name) -- 是否支持堆栈式关闭
    self.isNavigationDisabled = false   -- 该界面打开时是否需要屏蔽寻路
    self.ignoreHideUI = {}              -- 当此UI打开时，一定不会屏蔽的UI

    self.baseCtrlDeActiveCallBack = nil

    -------------------Tween动画相关-----------------------
    self.basePanelTweenId = 0
    self.basePanelTweenType = tweenType
    self.basePanelTweenTime = 0.3
    if self.basePanelTweenType and self.basePanelTweenType > UITweenType.Alpha then
        self.basePanelTweenDelta = 32
    else
        self.basePanelTweenDelta = 256
    end
    self.basePanelTweenCallBack = nil
    ------------------------------------------------------

    -------------------Handler相关------------------------
    self.toggleTpl = nil    --页签模板
    self.toggles = {}       --页签模板对象
    ---@type UIBaseHandler
    self.curHandler = nil   --当前处于的页签
    self.handlers = {}      --当前Ctrl的所有Handler存储
    ------------------------------------------------------

    super.ctor(self)
end

--UIBase实现以下三个周期
--Load()
--OnLoaded()
--Unload()

--[Comment]
--@inheritable
--初始化（OnLoaded后调用）
function UIBaseCtrl:Init()
    super.Init(self)
    self.canvas = self.uObj:GetComponent("Canvas")
    if self.canvas == nil then
        logError("界面上的Canvas是空的，界面名字："..self.name)
    end
    self:SetupHandlers()
end

--[Comment]
--@inheritable
--销毁（UnLoad后调用）
function UIBaseCtrl:Uninit()

    if self.basePanelTweenId > 0 then
        MUITweenHelper.KillTween(self.basePanelTweenId)
        self.basePanelTweenId = 0
    end

    self:uninitHandler()
    self.canvas = nil
    self.canvasGroup = nil

    local l_panelName = self.name

    super.Uninit(self)

    UIMgr:RemovePanelClassCache(l_panelName)
end

function UIBaseCtrl:GetPanelName()
    return self.name
end

--[Comment]
--@override
--临时逻辑 整理好UIManager后回删除
function UIBaseCtrl:ActiveTemp(parent, callback, isPlayTween, uiPanelData)
    self.panelParent = parent
    self.uiPanelData = uiPanelData
    self.isShowing = true
    if self.curHandler then
        self.curHandler.isShowing = true
    end
    self:Active(callback, isPlayTween)
end

--[Comment]
--@override
--打开UI（Active->BindEvents->OnActive->OnShow()->AfterOnActive())
function UIBaseCtrl:Active(uiPanelData, isPlayTween)

    if self.basePanelTweenId > 0 then
        self:_basePanelStopTween(false)
        self.isActive = true
    end

    if self.isActive then
        if self.isInited then
            self.isReactive = true
            self.isShowing = true
            if type(uiPanelData) == "function" then
                uiPanelData(self)
            end
            self:_basePanelBindEvents()
            self:setPanelParent()
            self:BasePanelRefresh()
            self:_recoverAlpha()
            if self.curHandler and self.curHandler.isInited then
                self.curHandler:BasePanelRefresh()
            end
            return
        end
    end

    self.isActive = true
    if self.isNavigationDisabled then
        MTransferMgr:NavigationDisabledByUI(self.name, function(...)
            self:NavigationDisabledCallback()
        end)
    end

    if self.uObj ~= nil then
        --如果UI已经加载了
        self:_activeAfterLoaded(uiPanelData, isPlayTween)
    else
        self:Load(function(ctrl)
            ctrl:_activeAfterLoaded(uiPanelData, isPlayTween)
        end)
    end
end

function UIBaseCtrl:BasePanelSetDeActiveCallBack(deActiveCallBack)
    self:_basePanelSetDeActiveCallBack(deActiveCallBack)
end

--[Comment]
--@override
--关闭UI（Deactive->UnBindEvents->OnHide->OnDeActive->->AfterOnDeActive())
function UIBaseCtrl:DeActive(isPlayTween)

    if self.isActive == false then
        return
    end

    if self.isNavigationDisabled then
        MTransferMgr:NavigationEnabledByUI(self.name)
    end

    self.isActive = false
    self.isShowing = false
    self.isReactive = false

    if self.uObj ~= nil then
        self:_basePanelUnBindEvents() --提前解除事件绑定，防止在关闭UI的过程中来了事件导致不可预知的异常
        self:_basePanelSetMainCameraState(true)

        self:_basePanelStopTween(true)

        if self:_isNeedPlayBasePanelTween(isPlayTween) then
            self:_basePanelCreateTween(true, self:_basePanelGetDeActiveTweenCallBack())
        else
            self:_deActiveUObj()
        end
    else
        self:Unload()
        self:_baseCtrlCallDeActiveCallBack()
    end
end

function UIBaseCtrl:_basePanelSetDeActiveCallBack(deActiveCallBack)
    self:_baseCtrlCallDeActiveCallBack()
    self.baseCtrlDeActiveCallBack = deActiveCallBack
end
function UIBaseCtrl:_baseCtrlCallDeActiveCallBack()
    if self.baseCtrlDeActiveCallBack then
        self.baseCtrlDeActiveCallBack(self.name)
        self.baseCtrlDeActiveCallBack = nil
    end
end

--[Comment]
--@inheritable
--显示 对OnShow的包装 目的是去掉上层对Super.OnShow的调用 上层只需要实现OnShow就可以了
function UIBaseCtrl:_basePanelShowUI(isPlayTween)
    if self.isActive == false then
        return
    end
    if self.isShowing then
        return
    end
    self.isShowing = true
    if self.isInited == false then
        return
    end

    self:_setVisible(true)

    if self.curHandler then
        self.curHandler:BasePanelShowUI()
    end

    self:_basePanelStopTween(true)
    if self:_isNeedPlayBasePanelTween(isPlayTween) then
        self:_basePanelCreateTween(false, self:_basePanelGetActiveTweenCallBack())
    else
        self:_basePanelSetMainCameraState(false)
    end

    self:OnShow()
end

function UIBaseCtrl:_setVisible(isVisible)
    super._setVisible(self, isVisible)

    if self.curHandler then
        self.curHandler:_setVisible(isVisible)
    end
end

--[Comment]
--@inheritable
--隐藏 对OnShow的包装 目的是去掉上层对Super.OnShow的调用 上层只需要实现OnHide就可以了
function UIBaseCtrl:BasePanelHideUI(isPlayTween)
    if self.isActive == false then
        return
    end
    if self.isShowing==false then
        return
    end
    self.isShowing = false
    if self.isInited == false then
        return
    end

    self:_basePanelSetMainCameraState(true)

    self:_basePanelStopTween(true)

    if self:_isNeedPlayBasePanelTween(isPlayTween) then
        self:_basePanelCreateTween(true, self:_basePanelGetHideTweenCallBack())
    else
        self:_setVisible(false)
        if self.curHandler then
            self.curHandler:BasePanelHideUI()
        end
    end

    self:OnHide()
end

------------------------------- End 生命周期 ------------------------------

------------------------------- Start 生命周期相关接口 ---------------------
--[Comment]
--@override
--打开UI的后处理函数
function UIBaseCtrl:_activeAfterLoaded(uiPanelData, isPlayTween)
    self:setPanelParent()
    self:SetOverrideSortLayer(self.overrideSortLayer)
    self:_setVisible(self.isShowing)

    if type(uiPanelData) == "function" then
        uiPanelData(self)
    end

    self:_basePanelBindEvents()
    self:OnActive()
    self:OnShow()
    self:_basePanelAfterOnActive()

    if self.isShowing == false then
        self:OnHide()
        return
    end

    self:_basePanelStopTween(true)

    if self:_isNeedPlayBasePanelTween(isPlayTween) then
        self:_basePanelCreateTween(false, self:_basePanelGetActiveTweenCallBack())
    else
        self:_recoverAlpha()
        self:_basePanelSetMainCameraState(false)
    end
end

--[Comment]
--@私有函数 内容调用
--Deactive UI的后处理函数
function UIBaseCtrl:_deActiveUObj()
    if self.uObj == nil then
        return
    end

    self:SetOverrideSortLayer(self.overrideSortLayer)

    --新手指引箭头关闭
    self:UninitGuideArrow()
    self:OnHide()
    self:OnDeActive()
    self:_basePanelAfterOnDeActive()

    self.uObj.transform:SetParent(UIMgr:GetDeActiveCacheContainerTransform(), false)
    local isPanelCache=self:IsCached()
    if isPanelCache then
        self:_setVisible(false)
    else
        self:Uninit()
    end
    self:_releaseAll(not isPanelCache)

    self:_baseCtrlCallDeActiveCallBack()
end

--[Comment]
--设置UI对象的父元素
function UIBaseCtrl:_AddObjToParent()
    self:setPanelParent()
end

function UIBaseCtrl:setPanelParent()
    if self.uObj == nil then
        return
    end
    if self.panelParent == nil then
        logError("设置界面父物体时父物体是空的")
        return
    end
    self.uTrans:SetParent(self.panelParent, false)
    self.uTrans:SetAsLastSibling()

    self:_baseCtrlCallDeActiveCallBack()
end

function UIBaseCtrl:SetPanelParentData(panelParent)
    self.panelParent = panelParent
end

function UIBaseCtrl:_basePanelCreateTween(isFadeOut, tweenCallBack)
    self:_setRaycaster(false)
    self.basePanelTweenCallBack = tweenCallBack
    self.basePanelTweenId = Common.CommonUIFunc.TweenUI(self.uObj, self:_basePanelGetTweenType(), self.basePanelTweenDelta, self.basePanelTweenTime, isFadeOut, function()
        self.basePanelTweenId = 0
        if self.basePanelTweenCallBack then
            self.basePanelTweenCallBack()
            self.basePanelTweenCallBack = nil
        end

    end)
end

function UIBaseCtrl:_isNeedPlayBasePanelTween(isPlayTween)
    if not isPlayTween then
        return false
    end
    local tweenType = self:_basePanelGetTweenType()
    if tweenType == nil then
        return false
    end
    if tweenType == UITweenType.None then
        return false
    end
    return true
end

function UIBaseCtrl:_basePanelStopTween(isPlayCallBack)
    if self.basePanelTweenId <= 0 then
        return
    end
    if self.basePanelTweenCallBack then
        if isPlayCallBack then
            self.basePanelTweenCallBack()
        end
        self.basePanelTweenCallBack = nil
    end
    MUITweenHelper.KillTween(self.basePanelTweenId)
    self:_basePanelResetTransform()
    self.basePanelTweenId = 0

end

function UIBaseCtrl:_basePanelGetActiveTweenCallBack()
    return function()
        if self.uObj ~= nil then
            self:_basePanelResetTransform()
            self:_setRaycaster(true)
            self:_basePanelSetMainCameraState(false)
        end
    end
end

function UIBaseCtrl:_basePanelGetDeActiveTweenCallBack()
    return function()
        if not self.isActive then
            self:_basePanelResetTransform()
            self:_deActiveUObj()
        end
    end
end

function UIBaseCtrl:_basePanelGetHideTweenCallBack()
    return function()
        self:_setVisible(false)
        self:_basePanelResetTransform()
        if self.curHandler then
            self.curHandler:BasePanelHideUI()
        end
    end
end

function UIBaseCtrl:_basePanelResetTransform()
    MLuaCommonHelper.SetLocalPos(self.uObj, 0, 0, 0)
    MLuaCommonHelper.SetRectTransformOffset(self.uObj, 0, 0, 0, 0)
end

--设置全局相机的显示状态
function UIBaseCtrl:_basePanelSetMainCameraState(isActive)
    if isActive then
        UIMgr:ActiveMainCamera(self.name, self.isFullScreen)
    else
        UIMgr:DeActiveMainCamera(self.name, self.isFullScreen)
    end
end

--[Comment]
--设置override sortlayer 在关闭界面之后会自行恢复
--sortlayer 要设置的层级
function UIBaseCtrl:SetOverrideSortLayer(sortingOrder)
    if self.canvas == nil then
        logError("界面上的Canvas是空的，界面名字："..self.name)
        return
    end
    if sortingOrder == nil then
        self.canvas.overrideSorting = false
    else
        self.canvas.overrideSorting = true
        self.canvas.sortingOrder = sortingOrder
    end
end

function UIBaseCtrl:_basePanelGetTweenType()
    local qualityLevel = MQualityGradeSetting.GetCurLevel()
    if qualityLevel > 1 then
        return self.basePanelTweenType
    else
        return nil
    end
end

--[Comment]
--@私有函数 内容调用
--用于处理UI的Alpha
function UIBaseCtrl:_recoverAlpha()

    if self.uObj and not self.canvasGroup then
        self.canvasGroup = self.uObj:GetComponent("CanvasGroup")
    end
    if self.canvasGroup then
        self.canvasGroup.alpha = 1
    end
end

--[Comment]
--私有函数 设置Ctrl + Handler的Canvase的射线检测
function UIBaseCtrl:_setRaycaster(enable)
    super._setRaycaster(self, enable)
    if self.curHandler then
        self.curHandler:_setRaycaster(enable)
    end
end

------------------------------- End 生命周期相关接口 ---------------------

------------------------------- Handlers相关的逻辑 -----------------------

--[Comment]
--@Public Ctrl创建Handler
--@param table handlerOptTb 格式：{{1=>handlerName, 2=>toggleDesc, 3=>atlas, 4=>spriteOn, 5=>spriteOff, 6=>checkMethod, 7=>clickCheckMethod}}
--@param go toggleTpl 页签模板
--@param go rootUObj handler的父对象，传空则默认为所属ctrl对象
--@param string defaultHandlerName 默认打开的handler名
function UIBaseCtrl:InitHandler(handlerOptTb, toggleTpl, rootUObj, defaultHandlerName)
    if type(handlerOptTb) ~= "table" or MLuaCommonHelper.IsNull(toggleTpl) then
        logError("params is invalid, please check it!")
        return false
    end
    -- 可能为0，不需要报错
    if #handlerOptTb == 0 then
        return false
    end

    self.toggleTpl = toggleTpl
    self.rootUObj = rootUObj
    for i, handlerInfo in ipairs(handlerOptTb) do
        self:createOneHandler(handlerInfo)
    end

    if defaultHandlerName ~= false then
        self:SelectOneHandler(defaultHandlerName)
    end
end

--[Comment]
--私用函数 底层调用 卸载handler
function UIBaseCtrl:uninitHandler()
    if self.handlers ~= nil then
        for k, _ in pairs(self.handlers) do
            self:EnsureUnloadHandler(k)
        end
    end
    self.handlers = {}
    self.toggleTpl = nil
    self.toggles = {}
    self.curHandler = nil
    self.rootUObj = nil
end

--[Comment]
--私用函数 底层调用 创建一个Handler 
function UIBaseCtrl:createOneHandler(optArr)
    --toggleName, toggleDesc, toggleAtlas, toggleOnSprite, toggleOffSprite, checkMethod, clickCheckMethod
    local l_name = optArr[1]
    if l_name == nil then
        logError("l_name is nil")
        return false
    end

    if self.handlers[l_name] ~= nil then
        logError("same name with handler:" .. tostring(l_name))
        return false
    end

    local l_suffix = "Handler"
    local l_handlerName = l_name .. l_suffix

    require("UI/Handler/" .. l_handlerName)
    if UI[l_handlerName] == nil then
        logError("handlerCtrl has errors, please check file:" .. tostring(l_handlerName))
        return false
    end

    local l_toggle = self:AddOneToggle(optArr)
    l_toggle:OnToggleExChanged(function(value)
        if value == true then
            self:ShowHandler(l_name)
        end
    end)

    local l_handler = UI[l_handlerName].new()
    l_handler.toggle = l_toggle
    self.handlers[l_name] = l_handler
end

--[Comment]
--选中某一个Handler
function UIBaseCtrl:SelectOneHandler(handlerName, callback)
    if Common.Utils.IsNilOrEmpty(handlerName) then
        handlerName = self.toggles[1].name
    end

    if self:ShowHandler(handlerName, callback) then
        -- 模拟页签点击
        for i = 1, table.maxn(self.toggles) do
            if self.toggles[i] and self.toggles[i].name == handlerName then
                self.toggles[i].toggleExComp.isOn = true
                break
            end
        end

        return self.handlers[handlerName]
    end

    return nil
end

function UIBaseCtrl:ShowHandler(handlerName, callback)
    local l_lastHandlerName = nil
    local l_handler = self.handlers[handlerName]
    if not l_handler then
        return false
    end
    if self.curHandler then
        l_lastHandlerName = self.curHandler.name
        if self.curHandler == l_handler then
            l_handler:SetActiveCallback(callback)
            return true
        end

        if self.curHandler:IsInited() then
            self.curHandler:BasePanelHideUI()
        else
            self.curHandler:DeActive()
        end
    end
    self.curHandler = l_handler
    if l_handler:IsInited() then
        l_handler:BasePanelShowUI()
        self:OnHandlerSwitch(handlerName, l_lastHandlerName)
        if callback then
            callback(l_handler)
        end
    else
        l_handler:Active(self, callback)
        self:OnHandlerActive(handlerName)
    end

    return true
end

function UIBaseCtrl:HideHandler(handlerName)
    local l_handler = self.handlers[handlerName]
    if not l_handler then
        return false
    end

    l_handler:BasePanelHideUI()
    return true
end

function UIBaseCtrl:AddHandlerToToggleEx(optArr, mytoggle, funcName, parent)
    local l_name = optArr
    if l_name == nil then
        logError("l_name is nil")
        return false
    end

    if self.handlers[l_name] ~= nil then
        logError("same name with handler:" .. tostring(l_name))
        return false
    end

    local l_suffix = "Handler"
    local l_handlerName = l_name .. l_suffix

    require("UI/Handler/" .. l_handlerName)
    if UI[l_handlerName] == nil then
        logError("handlerCtrl has errors, please check file:" .. tostring(l_handlerName))
        return false
    end
    table.insert(self.toggles, mytoggle)
    mytoggle:OnToggleExChanged(function(value)
        if value == true then
            self:ShowHandler(l_name, function(handler)
                handler.uObj.transform:SetParent(parent)
            end)
        end
        if funcName then
            self:ToggleFunc(funcName, value)
        end
    end)
    local l_handler = UI[l_handlerName].new()
    l_handler.toggle = mytoggle
    self.handlers[l_name] = l_handler
end

function UIBaseCtrl:AddOneToggle(optArr)
    --toggleName, toggleDesc, toggleAtlas, toggleOnSprite, toggleOffSprite, checkMethod, clickCheckMethod, usePool
    local l_name, l_desc, l_atlas, l_spriteOn, l_spriteOff, l_checkMethod, l_clickCheckMethod, l_usePool = unpack(optArr)
    if self.toggleTpl == nil then
        logError("please set toggleTpl first! name = " .. l_name)
    end
    for i = 1, table.maxn(self.toggles) do
        if self.toggles[i] and self.toggles[i].name == l_name then
            return nil
        end
    end
    local l_one_toggle = {}
    l_one_toggle.usePool = l_usePool
    local l_index = table.maxn(self.toggles)
    l_one_toggle.ui = self:CloneObj(self.toggleTpl.gameObject)
    l_one_toggle.ui.gameObject:SetActiveEx(true)
    l_one_toggle.ui.transform:SetParent(self.toggleTpl.transform.parent)
    l_one_toggle.ui.transform:SetLocalScaleOne()
    local l_posX = self.toggleTpl.transform.anchoredPosition.x
    l_one_toggle.ui.transform.anchoredPosition = Vector3.New(l_posX, -l_index * 50 - 150, 0)
    self.toggleTpl.gameObject:SetActiveEx(false)
    self:ExportElement(l_one_toggle)
    l_one_toggle.toggleGroup:RefreshTogglePosition()
    l_one_toggle.name = l_name
    l_one_toggle.buttonOnText.LabText = l_desc
    l_one_toggle.buttonOffText.LabText = l_desc
    -- 设置标签图片
    if l_atlas and l_spriteOn then
        l_one_toggle.buttonOnImg:SetSpriteAsync(l_atlas, l_spriteOn, nil, true)
        l_one_toggle.buttonOffImg:SetSpriteAsync(l_atlas, l_spriteOff or l_spriteOn, nil, true)
    end
    --设置检测方法 判断是否生效
    l_one_toggle.checkMethod = nil  --新版UI暂不支持页签置灰 代码暂时保留 2020/03/17 cmd
    -- if l_checkMethod then
    --     l_one_toggle.checkMethod = l_checkMethod
    --     if l_one_toggle.checkMethod() then
    --         l_one_toggle.toggleExComp:SetGray(false)
    --     else
    --         l_one_toggle.toggleExComp:SetGray(true)
    --     end
    -- else
    --     l_one_toggle.checkMethod = nil
    -- end
    --点击时的检测事件判断
    if l_clickCheckMethod then
        l_one_toggle.toggleExComp:SetCheckMethodOnBtnOn(l_clickCheckMethod)
        l_one_toggle.toggleExComp:SetCheckMethodOnBtnOff(l_clickCheckMethod)
    end
    table.insert(self.toggles, l_one_toggle)
    return l_one_toggle.toggleEx
end

function UIBaseCtrl:RemoveOneToggle(toggleName)
    for i = 1, table.maxn(self.toggles) do
        if self.toggles[i] and self.toggles[i].name == toggleName then
            local l_usePool = true
            if self.toggles[i].usePool ~= nil then
                l_usePool = self.toggles[i].usePool
            end
            MResLoader:DestroyObj(self.toggles[i].ui, l_usePool)
            self.toggles[i] = nil
            return
        end
    end
end

--刷新样式 用于l_checkMethod的条件外部变化后更新显示 cmd 2019/06/06
function UIBaseCtrl:RefreshToggleStyle()
    for i = 1, table.maxn(self.toggles) do
        local l_one_toggle = self.toggles[i]
        if l_one_toggle and l_one_toggle.checkMethod then
            if l_one_toggle.checkMethod() then
                l_one_toggle.toggleExComp:SetGray(false)
            else
                l_one_toggle.toggleExComp:SetGray(true)
            end
        end
    end
end

function UIBaseCtrl:EnsureUnloadHandler(handlerName)
    if self.handlers[handlerName] ~= nil then
        if self.curHandler == self.handlers[handlerName] then
            self.curHandler = nil
        end
        self:RemoveOneToggle(handlerName)
        self.handlers[handlerName]:DeActive()
        self.handlers[handlerName] = nil
    end
end

function UIBaseCtrl:_getChildText(uiTransform)
    local ret = nil
    local childCount = uiTransform.childCount
    for i = 1, childCount do
        local text = uiTransform:GetChild(i - 1):GetComponent("Text")
        if text then
            ret = text
            break
        end
        text = uiTransform:GetChild(i - 1):GetComponent("TextMeshProUGUI")
        if text then
            ret = text
            break
        end
    end

    if ret then
        ret = MLuaClientHelper.GetOrCreateMLuaUICom(ret.gameObject)
    end

    return ret
end

function UIBaseCtrl:ExportElement(element)
    element.toggleExComp = element.ui.transform:GetComponent("UIToggleEx")
    if element.toggleExComp == nil then
        logError("[ExportElement]toggleTpl has no component UIToggleEx, check it!!!")
        return
    end
    element.buttonOnText = self:_getChildText(element.toggleExComp.buttonOn.transform)
    element.buttonOffText = self:_getChildText(element.toggleExComp.buttonOff.transform)
    element.toggleGroup = element.toggleExComp.group
    element.toggleEx = element.toggleExComp.transform:GetComponent("MLuaUICom")
    element.buttonOnImg = element.toggleExComp.imgSetterOn
    element.buttonOffImg = element.toggleExComp.imgSetterOff
end

function UIBaseCtrl:GetHandlerByName(handlerName)
    return self.handlers[handlerName]
end

function UIBaseCtrl:IsHandlerActive(handlerName)
    return self.curHandler == self.handlers[handlerName]
end

function UIBaseCtrl:GetHandlerTogExByName(handlerName, notShowError)
    local l_toggle = nil
    for i, v in pairs(self.toggles) do
        if v.name == handlerName then
            l_toggle = v.toggleEx
            break
        end
    end
    if not notShowError and not l_toggle then
        logError("Toggle is can not be find name = " .. handlerName)
    end
    return l_toggle
end
function UIBaseCtrl:Close()
    UIMgr:DeActiveUI(self.name)
end
------------------------------- END Handlers -------------------------------

--[Comment]
--@override
--触摸事件处理
function UIBaseCtrl:UpdateInput(touchItem)
    if self.curHandler and self.curHandler.uObj then
        self.curHandler:UpdateInput(touchItem)
    end
    self:passThroughHandler(touchItem)
end

--[Comment]
--@override
--设置handler信息 该函数在有Handler的Ctrl面板实现
function UIBaseCtrl:SetupHandlers()
end

--[Comment]
--@override
--打开某个handler后的回调
function UIBaseCtrl:OnHandlerActive(handlerName)
end

--[Comment]
--@override
--handler切换后的回调
function UIBaseCtrl:OnHandlerSwitch(handlerName, lastHandlerName)
end

--[Comment]
--@override
-- 窗口显示时（Active后调用）
function UIBaseCtrl:OnActive()
end

--[Comment]
--@override
--窗口关闭时（DeActive后调用）
function UIBaseCtrl:OnDeActive()
end

function UIBaseCtrl:OnShow()
end
function UIBaseCtrl:OnHide()
end

--[Comment]
--@override
--绑定事件(Active后&OnActive前调用)
function UIBaseCtrl:BindEvents()
end

--[Comment]
--@override
-- 更新
function UIBaseCtrl:Update()
    if self.curHandler and self.curHandler.uObj then
        self.curHandler:Update()
    end
end

--[Comment]
--@override
--游戏登出
function UIBaseCtrl:OnLogout()
end

--[Comment]
--@override
--断线重连
function UIBaseCtrl:OnReconnected()

end

function UIBaseCtrl:NavigationDisabledCallback(...)
end

return UIBaseCtrl