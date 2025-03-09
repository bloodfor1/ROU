require "UI/UIBase"
module("UITemplate", package.seeall)

-- UI的基类
local super = UI.UIBase
---@class BaseUITemplate : UIBase
BaseUITemplate = class("BaseUITemplate", super)

-- TemplatePrefab模版Prefab
-- TemplatePath Prefab的路径
-- TemplateParent 父物体
-- TemplatePool 包含模板的池（不需要传）
-- IsActive 是否显示，默认为显示
-- Data数据，如果不为空会调用SetData(data)方法
-- TemplatePrefab和TemplatePath必需传一个
-- LoadCallback 加载完的回调
-- IsUsePool 是否走对象池实例化
function BaseUITemplate:ctor(templateData)

    super.ctor(self)

    -- 使用模版管理类的时候实例化出很多prefab，ShowIndex为数据的序号。从1开始
    self.ShowIndex = 0

    if templateData.TemplatePrefab then
        self._templatePrefab = templateData.TemplatePrefab
    end
    if templateData.TemplatePath then
        self.TemplatePath = templateData.TemplatePath
    end
    --可以传需已经实例化好的Go进来 但是又这个参数就不能穿TemplatePrefab和TemplatePath
    if templateData.TemplateInstanceGo then
        self.TemplateInstanceGo = templateData.TemplateInstanceGo
        self._templatePrefab = nil
        self.TemplatePath = nil
    end

    if templateData.IsUsePool ~= nil then
        self.usePool = templateData.IsUsePool
    else
        self.usePool = true
    end

    self._isSetData = false
    if templateData.Data then
        self._templateData = templateData.Data
        self._additionalData = templateData.AdditionalData
        self._isSetData = true
    end

    if templateData.IsActive ~= nil then
        self.isActive = templateData.IsActive
    else
        self.isActive = true
    end

    if templateData.TemplateParent then
        self.TemplateParent = templateData.TemplateParent
    end

    self.isShowing = true

    -- 是否选择，仅做为性能优化使用
    self._isSelect = false

    if templateData.TemplatePool then
        self.TemplatePool = templateData.TemplatePool
    end

    -- 一个从外部传递过来的回调，自己选择传递和调用
    if templateData.Method then
        self.MethodCallback = templateData.Method
    end

    self.Parameter = nil

    ---@type UIBase
    local parentPanelClass=templateData.ParentPanelClass
    --Template所在的界面是否是打开的
    self._isPanelActive = parentPanelClass:IsActive()

    self._loadCallbacks = nil
    self:_baseTemplateSetLoadCallback(templateData.LoadCallback)
    self:_baseTemplateCreateGameObject(parentPanelClass)
end

function BaseUITemplate:AddLoadCallback(callback)
    if callback == nil then
        return
    end
    if Application.isEditor then
        if type(callback) ~= "function" then
            logError("传递的回调不是方法,界面名字："..tostring(self.name))
            return
        end
    end
    if self.isInited then
        callback(self)
    else
        self:_baseTemplateSetLoadCallback(callback)
    end
end

function BaseUITemplate:ActiveTemplate()
    if self.isActive then
        return
    end
    self.isActive = true
    self:_baseTemplateActiveTemplate()
end

function BaseUITemplate:DeActiveTemplate()
    self:_baseTemplateDeActiveTemplate()
end

function BaseUITemplate:SetParent(parent)
    if MLuaCommonHelper.IsNull(parent) then
        logError("设置Template父物体，但是传递的父物体是空的,界面名字："..tostring(self.name))
        return
    end
    self.TemplateParent = parent
    if self.isInited == false then
        return
    end
    self:_baseTemplateSetPanelParent()
end

function BaseUITemplate:gameObject()
    if self.isInited == false then
        logError("物体还没有初始化，就取物体，请修改逻辑，考虑异步,界面名字："..tostring(self.name))
        return nil
    end
    if MLuaCommonHelper.IsNull(self.uObj) then
        logError("物体是空的，可能的原因是界面已经销毁，但还再取,界面名字："..tostring(self.name))
        return nil
    end
    return self.uObj
end

function BaseUITemplate:transform()
    if self.isInited == false then
        logError("物体还没有初始化，就取物体，请修改逻辑，考虑异步,界面名字："..tostring(self.name))
        return nil
    end
    if MLuaCommonHelper.IsNull(self.uTrans) then
        logError("物体是空的，可能的原因是界面已经销毁，但还再取,界面名字："..tostring(self.name))
        return nil
    end
    return self.uTrans
end

function BaseUITemplate:SetGameObjectScale(x,y,z)
    ---@type UnityEngine.Transform
    local l_tran = self:transform()
    if l_tran==nil then
        return
    end
    l_tran:SetLocalScale(x,y,z)
end

function BaseUITemplate:SetGameObjectActive(isActive)
    if isActive then
        self:ActiveTemplate()
    else
        self:DeActiveTemplate()
    end
end

function BaseUITemplate:SetData(data, additionalData)
    self._isSetData = true
    if self.isInited then
        self:OnSetData(data, additionalData)
        self._templateData = nil
        self._additionalData = nil
    else
        self._templateData = data
        self._additionalData = additionalData
    end
end

----------------------------------------- Start 生命周期 ----------------------------------------------------------------

function BaseUITemplate:_baseTemplateSetLoadCallback(callback)
    if callback == nil then
        return
    end
    if self._loadCallbacks == nil then
        self._loadCallbacks = {}
    end
    table.insert(self._loadCallbacks, callback)
end

---@param parentPanelClass UIBase
function BaseUITemplate:_baseTemplateCreateGameObject(parentPanelClass)
    -- 如果已经初始化
    if self.isInited then
        logError("重复初始化,界面名字："..tostring(self.name))
        return
    end
    if parentPanelClass == nil then
        logError("此Template不是使用我们封装的方法进行创建的，需使用self:NewTemplate或self:NewTemplatePool进行创建,界面名字："..tostring(self.name))
    end
    if self._templatePrefab then
        local gameObject
        if parentPanelClass then
            gameObject = parentPanelClass:CloneObj(self._templatePrefab)
        else
            gameObject = self:CloneObj(self._templatePrefab)
        end
        self:OnLoaded(gameObject)
    elseif self.TemplatePath then
        self._basePanelAsyncLoadTaskId = MResLoader:CreateObjAsync(self.TemplatePath, function(gameObject, cbObj, taskId)
            self:OnLoaded(gameObject)
        end, self, self.usePool)
    elseif self.TemplateInstanceGo then
        self:OnLoaded(self.TemplateInstanceGo)
    else
        logError("没有传递TemplatePrefab、TemplatePath或TemplateGameObject，如果传了这些参数，请打日志查看是否是空的,界面名字："..tostring(self.name))
    end
end

function BaseUITemplate:OnLoaded(obj)
    self._basePanelAsyncLoadTaskId = 0
    if not obj then
        logError("cannot load ui GameObject, name=" .. tostring(self.TemplatePath))
        return
    end

    self.name = obj.name
    self.uObj = obj
    self.uTrans = obj.transform

    self:_baseTemplateSetPanelParent()

    local group = self.uObj:GetComponent("MLuaUIGroup")
    self.Parameter = BindMLuaGroup(group)
    self._panelCSharpClassReference = group

    self:Init()

    if self._isSetData then
        self:SetData(self._templateData, self._additionalData)
    end

    --如果是打开状态，需要打开界面，绑定事件
    if self.isActive then
        self:_baseTemplateActiveTemplate()
    else
        --如果是关闭状态，只关闭界面就好了
        self.uObj:SetActiveEx(false)
    end

    self:BaseTemplateOnPanelVisible(self.isShowing)

    if self._isSelect then
        self:OnSelect()
    end

    if self._loadCallbacks ~= nil then
        for i = 1, #self._loadCallbacks do
            self._loadCallbacks[i](self)
        end
    end
    self._loadCallbacks = nil
end

function BaseUITemplate:_baseTemplateSetPanelParent()
    if not self:_isGameObjectExist() then
        logError("设置界面父物体时物体是空的,界面名字："..tostring(self.name))
        return
    end
    if self.TemplateParent == nil then
        return
    end
    self.uTrans:SetParent(self.TemplateParent, false)
end

--初始化时调用
function BaseUITemplate:Init()
    super.Init(self)
end

--销毁时需要调用的方法
function BaseUITemplate:Uninit()

    if self.isInited then
        self:OnDeActive()
        self:_basePanelUnBindEvents()
        self:OnDestroy()
    end

    self.ShowIndex = 0
    self.Parameter = nil

    self._templatePrefab = nil
    self.TemplatePath = nil
    self.TemplateInstanceGo = nil
    self.TemplateParent = nil
    self.MethodCallback = nil

    self._isSelect = false
    self.isShowing = true
    self._templateData = nil
    self._additionalData = nil
    self._isSetData = false
    self.isActive = true

    self._isPanelActive = true
    self.TemplatePool = nil

    self._loadCallbacks = nil

    super.Uninit(self)
    self:_releaseAll(true)
end

--Template绑定事件
function BaseUITemplate:_baseTemplateBindEvents()
    --没有加载完
    if self.isInited == false then
        return
    end
    --界面是关闭的
    if self._isPanelActive==false then
        return
    end
    --自己是关闭的
    if self.isActive == false then
        return
    end
    self:_basePanelBindEvents()
end

--打开Template
function BaseUITemplate:_baseTemplateActiveTemplate()
    if self.isInited == false then
        return
    end
    self.uObj:SetActiveEx(true)
    self:OnActive()
    self:BaseTemplateOnTemplateActive()
end

--Template打开时调用，递归对所有的Template绑定事件
function BaseUITemplate:BaseTemplateOnTemplateActive()
    self:_baseTemplateBindEvents()
    for i = 1, #self.templates do
        self.templates[i]:BaseTemplateOnTemplateActive()
    end
    for i = 1, #self.templatePools do
        self.templatePools[i]:BaseTemplatePoolOnTemplateActive()
    end
end

--关闭Template
function BaseUITemplate:_baseTemplateDeActiveTemplate()
    if self.isActive == false then
        return
    end
    self.isActive = false
    if self.isInited == false then
        return
    end
    self.uObj:SetActiveEx(false)
    self:OnDeActive()
    self:BaseTemplateOnTemplateDeActive()
end

--Template关闭时调用，递归对所有的Template解绑事件
function BaseUITemplate:BaseTemplateOnTemplateDeActive()
    self:_basePanelUnBindEvents()
    for i = 1, #self.templates do
        self.templates[i]:BaseTemplateOnTemplateDeActive()
    end
    for i = 1, #self.templatePools do
        self.templatePools[i]:BaseTemplatePoolOnTemplateDeActive()
    end
end

---界面打开、关闭、显示、隐藏
--只会在界面打开时调用
function BaseUITemplate:BaseTemplateOnPanelActive()
    self._isPanelActive = true
    --如果此Template是关闭的，无需操作
    if self.isActive == false then
        return
    end
    --如果没有初始化，无需操作
    if self.isInited == false then
        return
    end
    self:_baseTemplateBindEvents()
    self:_basePanelAfterOnActive()
end

--只会在界面关闭时调用
function BaseUITemplate:BaseTemplateOnPanelDeActive()
    self._isPanelActive = false
    if self.isInited == false then
        return
    end
    self:_basePanelAfterOnDeActive()

    --如果此Template是关闭的，无需操作
    if self.isActive == false then
        return
    end

    self:_basePanelUnBindEvents()
end

--设置Template的显示隐藏
--Template的显示隐藏只有界面的显示隐藏会触发
function BaseUITemplate:BaseTemplateOnPanelVisible(isShowing)
    self.isShowing = isShowing

    if self.isInited == false then
        return
    end
    self:_setVisible(isShowing)
    self:OnSetVisible(isShowing)
end

----------------------------------------- End 生命周期 ------------------------------------------------------------------

function BaseUITemplate:SetDataAndIndex(data, dataIndex, additionalData)
    self.ShowIndex = dataIndex
    self:SetData(data, additionalData)
end

--选中当前template
function BaseUITemplate:Select()
    self._isSelect = true
    if self.isInited then
        self:OnSelect()
    end
end
function BaseUITemplate:IsSelect()
     return self._isSelect
end
--取消选中当前template
function BaseUITemplate:Deselect()
    --进行一步优化，一般都是未选择状态，所以判断当是选择状态时才调用取消选择
    if self._isSelect then
        self._isSelect = false

        if self.isInited then
            self:OnDeselect()
        end
    end
end

function BaseUITemplate:SetMethodCallback(method)
    self.MethodCallback = method
end

function BaseUITemplate:OnSetData(data, additionalData)
end

--子类需要覆写的方法

--销毁时调用
function BaseUITemplate:OnDestroy()
end
--打开时调用
function BaseUITemplate:OnActive()
end
--关闭时调用
function BaseUITemplate:OnDeActive()
end

function BaseUITemplate:OnSelect()
end

function BaseUITemplate:OnDeselect()
end

function BaseUITemplate:BindEvents()
end

function BaseUITemplate:OnSetVisible(visible)

end

function BaseUITemplate:rectTransform()
    if self.isInited == false then
        logError("物体还没有初始化，就取物体，请修改逻辑，考虑异步,界面名字："..tostring(self.name))
        return nil
    end
    if MLuaCommonHelper.IsNull(self.uTrans) then
        logError("物体是空的，可能的原因是界面已经销毁，但还再取,界面名字："..tostring(self.name))
        return nil
    end
    if MLuaCommonHelper.IsNull(self.rectTrans) then
        self.rectTrans = self:transform():GetComponent("RectTransform")
    end
    return self.rectTrans
end

--- 由templatePool来调用驱动的Update函数，为了和已有的Update进行区分
function BaseUITemplate:OnTemplatePoolUpdate()
    if not self.isActive then
        return
    end

    if not self.isInited then
        return
    end

    if nil == self._onTemplatePoolUpdate then
        return
    end

    self:_onTemplatePoolUpdate()
end

---@Description:选中当前template（通知包含池）
function BaseUITemplate:NotiyPoolSelect()
    if self.TemplatePool == nil then
        return
    end
    self.TemplatePool:CancelSelectTemplate()
    self._isSelect = true
    self.TemplatePool:SelectTemplate(self.ShowIndex)
end
---@Description:取消选中当前template（通知包含池）
function BaseUITemplate:NotiyPoolCancelSelect()
    if self.TemplatePool == nil then
        return
    end
    self.TemplatePool:CancelSelectTemplate()
end

return BaseUITemplate