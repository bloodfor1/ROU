module("Common.UI_TemplatePool", package.seeall)

---@class UI_BaseTemplatePool
UI_BaseTemplatePool = class("UI_BaseTemplatePool")

local _gameObjectType = System.Type.GetType("UnityEngine.GameObject, UnityEngine.CoreModule")
local _prefabSuffix = ".prefab"
---@param baseTemplatePool UI_BaseTemplatePool
local _resourceLoaderCallback = function(gameObject, baseTemplatePool, asyncLoadTaskId)
    baseTemplatePool:_onBaseTemplatePoolLoaded(gameObject, asyncLoadTaskId)
end

--TemplatePrefab和TemplatePath必需传一个
---@class TemplatePoolParam
---@field TemplatePrefab @模版Prefab
---@field TemplatePath string @Prefab的路径
---@field TemplateClassName string
---@field UITemplateClass @模版类
---@field GetTemplateAndPrefabMethod
---@field Method function
---@field GetDatasMethod function
---@field CreateObjPerFrame number @每一帧创建GO的数量
---@field SetCountPerFrame number @每一帧setData的数量，默认为空，如果是空，则设置全量data，如果不是空，这个时候会启用update，每一帧会设置置顶数量的数据
---@field NeedAutoSelected boolean @是否需要自动选择，会决定在分帧加载之后会不会进行选择操作

---@param templateInstantiateData TemplatePoolParam
function UI_BaseTemplatePool:ctor(templateInstantiateData)
    ---分帧设置
    -- 默认时间，如果时间小于等于这个值，认为是同步操作
    self.C_DEFAULT_SET_DATA_RATE = 0
    -- 设置每一帧setData的数量，默认是全部加载，设置这个数量之后需要调用Update
    self.SetDataRate = self.C_DEFAULT_SET_DATA_RATE
    self.CreateTemplateRate = self.C_DEFAULT_SET_DATA_RATE
    self.NeedAutoSelected = false
    if templateInstantiateData.NeedAutoSelected then
        self.NeedAutoSelected = true
    end

    if nil ~= templateInstantiateData.SetCountPerFrame then
        self.SetDataRate = templateInstantiateData.SetCountPerFrame
    end
    -- 如果有设置分帧创建Template的参数，则分针创建
    if nil ~= templateInstantiateData.CreateObjPerFrame then
        self.CreateTemplateRate = templateInstantiateData.CreateObjPerFrame
    end
    ---分帧设置

    self.isInited = false
    --- 显示用的最大数量和最小数量，初始化为0，如果是0的状态下认为两个值生效
    self._maxCount = 0
    self._minCount = 0
    --创建的Template保存的回调方法
    self.Method = templateInstantiateData.Method
    --获取数据的方法
    self.GetDatasMethod = templateInstantiateData.GetDatasMethod
    --当前选择的index
    self.CurrentSelectIndex = 0
    ---@type BaseUITemplate[]
    self.Items = {}
    self.Datas = {}
    --此个数为显示的Cell总个数
    self.CellCount = 0
    self.cloneTmpls = {}

    self._templateClass = self:_baseTemplatePoolGetTemplateClassWithData(templateInstantiateData)

    self._templatePrefab = templateInstantiateData.TemplatePrefab
    if self._templatePrefab then
        self._templatePrefab:SetActiveEx(false)
    end
    self._templatePath = self:_baseTemplatePoolGetTemplatePathWithData(templateInstantiateData)

    self._parentPanelClass = templateInstantiateData.ParentPanelClass
    self._additionalData = nil
    self._showTemplateData = nil
    self._loadCallbacks = nil
    self._basePanelAsyncLoadTaskId = 0
    self._cacheGameObjectAsset = nil
    self:_baseTemplatePoolPrepareLoad()
end

-->Datas模版类需要使用的数据集合
-->Method一个回调方法
--根据数据个数显示相应的物体
function UI_BaseTemplatePool:ShowTemplates(showTemplateData)
    self:_baseTemplatePoolPrepareShowTemplates(showTemplateData)
    if self.isInited == false then
        self._showTemplateData = showTemplateData
        return
    end
    self:_baseTemplatePoolShowTemplates(showTemplateData)
end

function UI_BaseTemplatePool:AddLoadCallback(callback)
    if callback == nil then
        return
    end
    if Application.isEditor then
        if type(callback) ~= "function" then
            logError("传递的回调不是方法")
            return
        end
    end
    if self.isInited then
        callback(self)
    else
        self:_baseTemplatePoolSetLoadCallback(callback)
    end
end

function UI_BaseTemplatePool:_baseTemplatePoolSetLoadCallback(callback)
    if callback == nil then
        return
    end
    if self._loadCallbacks == nil then
        self._loadCallbacks = {}
    end
    table.insert(self._loadCallbacks, callback)
end

--选择Template
function UI_BaseTemplatePool:SelectTemplate(index)
    if 0 < self.SetDataRate and self.NeedAutoSelected then
        self.CurrentSelectIndex = index
        return
    end

    if self.CurrentSelectIndex ~= 0 then
        local lastTemplate = self:GetItem(self.CurrentSelectIndex)
        if lastTemplate then
            lastTemplate:Deselect()
        end
    end

    self.CurrentSelectIndex = index
    local currentTemplate = self:GetItem(index)
    if currentTemplate then
        currentTemplate:Select()
    end
end

function UI_BaseTemplatePool:CancelSelectTemplate()
    self:SelectTemplate(0)
end

function UI_BaseTemplatePool:GetCurrentSelectTemplateData()
    return self:getData(self.CurrentSelectIndex)
end

--移除Template
function UI_BaseTemplatePool:RemoveTemplate(data)
    if self.GetDatasMethod ~= nil then
        --外部管理数据，如果先删除再调用就取不到index；如果先调用再删除，显示时取到的数据不对
        logError("使用外部处理数据的方式不能使用此方法")
        return
    end
    local index = self:getDataIndex(data)
    self:RemoveTemplateByIndex(index)
end

function UI_BaseTemplatePool:getDatas()
    local dataList
    if self.GetDatasMethod ~= nil then
        dataList = self.GetDatasMethod()
    else
        dataList = self.Datas
    end

    if dataList == nil then
        logError("取到的数据是空的")
        dataList = {}
    end
    return dataList
end

function UI_BaseTemplatePool:getData(index)
    local dataList = self:getDatas()
    if dataList == nil then
        return nil
    end
    return dataList[index]
end

function UI_BaseTemplatePool:getDataIndex(data)
    local dataList = self:getDatas()
    if dataList == nil then
        return 0
    end
    local index = 0
    for i = 1, #dataList do
        if dataList[i] == data then
            index = i
            break
        end
    end
    return index
end

function UI_BaseTemplatePool:getDataCount()
    local dataList = self:getDatas()
    if dataList == nil then
        return 0
    end
    return #dataList
end

------------------------------------------------- Start 生命周期和框架内部实现相关 ------------------------------------------------------

--准备加载
function UI_BaseTemplatePool:_baseTemplatePoolPrepareLoad()
    if self._templatePrefab then
        self:_onBaseTemplatePoolAfterLoaded()
    elseif self._templatePath then
        self._basePanelAsyncLoadTaskId = self:_baseTemplatePoolLoad(self._templatePath)
    else
        logError("没有传递TemplatePrefab或TemplatePath,可能的原因为：" ..
                "1、这两个参数都没传 2、物体上的MLuaUIGroup脚本上的IsGenerateCodeInUpper选项不要勾选")
    end
end

--加载资源
function UI_BaseTemplatePool:_baseTemplatePoolLoad(templatePath)
    return MResLoader:GetSharedAssetAsync(_gameObjectType, templatePath, _prefabSuffix, _resourceLoaderCallback, self)
end

--加载完调用
function UI_BaseTemplatePool:_onBaseTemplatePoolLoaded(gameObjectAsset, asyncLoadTaskId)
    self._basePanelAsyncLoadTaskId = 0
    self._cacheGameObjectAsset = gameObjectAsset
    self:_onBaseTemplatePoolAfterLoaded()
end

--Template资源准备好后调用
function UI_BaseTemplatePool:_onBaseTemplatePoolAfterLoaded()
    self:Init()
    if self._showTemplateData then
        self:_baseTemplatePoolShowTemplates(self._showTemplateData)
        self._showTemplateData = nil
    end
    if self._loadCallbacks ~= nil then
        for i = 1, #self._loadCallbacks do
            self._loadCallbacks[i](self)
        end
    end
    self._loadCallbacks = nil
end

function UI_BaseTemplatePool:_baseTemplatePoolCreateTemplate()
    --由于滑动组件自己设置Parent，所以这里不传Parent
    local template = self._templateClass.new({
        TemplatePath = self._templatePath,
        TemplatePrefab = self._templatePrefab,
        Method = self.Method,
        TemplatePool = self,
        ParentPanelClass = self._parentPanelClass,
    })
    return template
end

function UI_BaseTemplatePool:_baseTemplatePoolPrepareShowTemplates(showTemplateData)
    local dataCount = 0
    if self.GetDatasMethod ~= nil then
        local dataList = self.GetDatasMethod()
        if dataList ~= nil then
            dataCount = #dataList
        end
    else
        if showTemplateData then
            self.Datas = showTemplateData.Datas
        end
        dataCount = #self.Datas
    end

    if showTemplateData then
        self._additionalData = showTemplateData.AdditionalData
        if showTemplateData.ShowMaxCount ~= nil then
            self._maxCount = showTemplateData.ShowMaxCount
            if dataCount > showTemplateData.ShowMaxCount then
                dataCount = showTemplateData.ShowMaxCount
            end
        end

        if showTemplateData.ShowMinCount ~= nil then
            self._minCount = showTemplateData.ShowMinCount
            if dataCount < showTemplateData.ShowMinCount then
                dataCount = showTemplateData.ShowMinCount
            end
        end

        if showTemplateData.Method then
            self.Method = showTemplateData.Method
        end
    end

    self.CellCount = dataCount
end

--子类覆写
function UI_BaseTemplatePool:_baseTemplatePoolShowTemplates(showTemplateData)
end

--设置Template数据
---@param template BaseUITemplate
function UI_BaseTemplatePool:_baseTemplatePoolSetTemplateData(template, dataIndex)
    template:SetDataAndIndex(self:getData(dataIndex), dataIndex, self._additionalData)
    if self.CurrentSelectIndex == dataIndex then
        template:Select()
    else
        template:Deselect()
    end
end

function UI_BaseTemplatePool:Init()
    self.isInited = true
end

function UI_BaseTemplatePool:Uninit()
    self:BaseTemplatePoolOnPanelDeActive()
    if self._basePanelAsyncLoadTaskId > 0 then
        MResLoader:CancelAsyncTask(self._basePanelAsyncLoadTaskId)
        self._basePanelAsyncLoadTaskId = 0
    end
    if self._cacheGameObjectAsset then
        MResLoader:ReleaseSharedAsset(self._cacheGameObjectAsset)
        self._cacheGameObjectAsset = nil
    end

    self:ClearCloneObj()
    self._templateClass = nil
    self._templatePath = nil
    self._templatePrefab = nil
    self.Items = nil
    self.Datas = nil
    self.Method = nil
    self.GetDatasMethod = nil
    self._showTemplateData = nil
    self._maxCount = 0
    self._minCount = 0
    self.isInited = false
    self._parentPanelClass = nil
end

function UI_BaseTemplatePool:_baseTemplatePoolGetTemplateClassWithData(templateInstantiateData)
    if templateInstantiateData.TemplateClassName then
        require("UI/Template/" .. templateInstantiateData.TemplateClassName)
        return UITemplate[templateInstantiateData.TemplateClassName]
    end
    if templateInstantiateData.UITemplateClass then
        return templateInstantiateData.UITemplateClass
    end
    if templateInstantiateData.GetTemplateAndPrefabMethod == nil then
        logError("没有传TemplateClassName或UITemplateClass或GetTemplateAndPrefabMethod或者传递的是空," ..
                "如果传递的是UITemplateClass，请看一下是否require了这个文件，建议传TemplateClassName")
    end
    return nil
end

function UI_BaseTemplatePool:_baseTemplatePoolGetTemplatePathWithData(templateInstantiateData)
    if self._templatePrefab then
        return nil
    end
    if templateInstantiateData.TemplatePath then
        return templateInstantiateData.TemplatePath
    end
    if self._templateClass == nil then
        return nil
    end
    if self._templateClass.TemplatePath == nil then
        return nil
    end
    return self._templateClass.TemplatePath
end

function UI_BaseTemplatePool:BaseTemplatePoolOnTemplateActive()
    for i, template in pairs(self.Items) do
        template:BaseTemplateOnTemplateActive()
    end
end

function UI_BaseTemplatePool:BaseTemplatePoolOnTemplateDeActive()
    for i, template in pairs(self.Items) do
        template:BaseTemplateOnTemplateDeActive()
    end
end

--只有界面关闭的时候调用
--考虑到界面关闭后再打开，按理说需要根据数据重新进行显示
--因此在关闭时就把所有的Template销毁
function UI_BaseTemplatePool:BaseTemplatePoolOnPanelDeActive()
    for i, template in pairs(self.Items) do
        template:Uninit()
    end

    self.Items = {}
    self.Datas = {}
    self.CellCount = 0
    self._showTemplateData = nil
end

--只在界面显示隐藏时调用
function UI_BaseTemplatePool:BaseTemplatePoolOnPanelVisible(visible)
    if self.Items ~= nil then
        for i, item in pairs(self.Items) do
            item:BaseTemplateOnPanelVisible(visible)
        end
    end
end

--在移除Template时更改Template的ShowIndex
function UI_BaseTemplatePool:_baseTemplatePoolRefreshShowIndexOnRemoveTemplate(index)
    if self.Items == nil then
        return
    end
    ---@param template BaseUITemplate
    for i, template in pairs(self.Items) do
        --大于移除的Template的ShowIndex减一
        if template.ShowIndex > index then
            template.ShowIndex = template.ShowIndex - 1
        end
    end
end

------------------------------------------------- End 生命周期和框架内部实现相关 ------------------------------------------------------

--- templatePool当中会触发单个template的update
function UI_BaseTemplatePool:_onUpdate()
    for instanceID, singleTemplate in pairs(self.Items) do
        singleTemplate:OnTemplatePoolUpdate()
    end
end

-------------------------------------------------- 需要废弃 --------------------------------------------------------------

--根据数据获取Template
function UI_BaseTemplatePool:GetTemplateWithData(data)
    local index = self:getDataIndex(data)
    if index <= 0 then
        return nil
    end
    return self:GetItem(index)
end

function UI_BaseTemplatePool:CloneObj(obj)
    if obj == nil then
        logError("obj is nil on CloneObj")
        return nil
    end

    if self.cloneTmpls[obj] == nil then
        self.cloneTmpls[obj] = true
    end

    return MResLoader:CloneObj(obj, true)
end

function UI_BaseTemplatePool:ClearCloneObj()
    for k, _ in pairs(self.cloneTmpls) do
        if not MLuaCommonHelper.IsNull(k) then
            MResLoader:ClearObjPool(k)
        end
    end

    self.cloneTmpls = {}
end
-------------------------------------------------- 需要废弃 --------------------------------------------------------------

return UI_BaseTemplatePool