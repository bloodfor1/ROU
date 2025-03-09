module("Common.UI_TemplatePool", package.seeall)

require "Common/UI_BaseTemplatePoolScrollRect"

local super = Common.UI_TemplatePool.UI_BaseTemplatePoolScrollRect
---@class UI_TemplatePoolMultipleTemplate : UI_BaseTemplatePoolScrollRect
UI_TemplatePoolMultipleTemplate = class("UI_TemplatePoolMultipleTemplate", super)

-- PreloadPaths 需要预加载的prefab路径
-- GetTemplateAndPrefabMethod 获取prefab的方法
function UI_TemplatePoolMultipleTemplate:ctor(templateInstantiateData)
    self._preloadPrefabPaths = templateInstantiateData.PreloadPaths
    self._getTemplateAndPrefabMethod = templateInstantiateData.GetTemplateAndPrefabMethod

    if self._preloadPrefabPaths == nil then
        logError("使用MultipleTemplatePool需要传PreloadPaths参数," ..
                "PreloadPaths是所有预加载的Prefab的路径，没有就传空表," ..
                "PreloadPaths是一个Table，数据是此TemplatePool中所有Template使用的Prefab的路径")
        return
    end

    self._preloadedPrefabs = nil
    self._preloadedTasks = nil

    super.ctor(self, templateInstantiateData)
end

--UI_BaseTemplatePool调用
---@override UI_BaseTemplatePool
function UI_TemplatePoolMultipleTemplate:_baseTemplatePoolPrepareLoad()
    local preloadPrefabPathCount = #self._preloadPrefabPaths
    if preloadPrefabPathCount > 0 then
        self._preloadedPrefabs = {}
        self._preloadedTasks = {}
        for i = 1, preloadPrefabPathCount do
            local asyncLoadTaskId = self:_baseTemplatePoolLoad(self._preloadPrefabPaths[i])
            if asyncLoadTaskId > 0 then
                self._preloadedTasks[asyncLoadTaskId] = true
            end
        end
    else
        self:_onBaseTemplatePoolAfterLoaded()
    end
end

--UI_BaseTemplatePool调用
---@override UI_BaseTemplatePool
function UI_TemplatePoolMultipleTemplate:_onBaseTemplatePoolLoaded(gameObjectAsset, asyncLoadTaskId)
    self._preloadedTasks[asyncLoadTaskId] = nil
    table.insert(self._preloadedPrefabs, gameObjectAsset)

    if #self._preloadedPrefabs == #self._preloadPrefabPaths then
        self:_onBaseTemplatePoolAfterLoaded()
    end
end

function UI_TemplatePoolMultipleTemplate:_baseTemplatePoolShowTemplates(showTemplateData)
    self.ScrollRect:ClearActiveCells()
    super._baseTemplatePoolShowTemplates(self, showTemplateData)
end

function UI_TemplatePoolMultipleTemplate:_scrollRectTemplatePoolGetGameObject(index)
    index = index + 1
    local templateClass, templatePrefab = self._getTemplateAndPrefabMethod(self:getData(index))
    local template

    for i = 1, #self._hideTemplateCache do
        local cacheTemplate = self._hideTemplateCache[i]
        if cacheTemplate._templatePrefab == templatePrefab or cacheTemplate.TemplatePath == templatePrefab then
            template = cacheTemplate
            table.remove(self._hideTemplateCache, i)
            break
        end
    end

    if template == nil then
        template = self:_multipleTemplatePoolCreateTemplate(templateClass, templatePrefab)
    end
    template:ActiveTemplate()

    return template:gameObject()
end

function UI_TemplatePoolMultipleTemplate:_multipleTemplatePoolCreateTemplate(templateClass, templatePrefab)

    self._templateClass = templateClass

    if type(templatePrefab) == "string" then
        self._templatePath = templatePrefab
    else
        self._templatePrefab = templatePrefab
    end

    local template = self:_baseScrollRectTemplatePoolCreateTemplate()
    return template
end

function UI_TemplatePoolMultipleTemplate:Uninit()
    super.Uninit(self)

    if self._preloadedTasks then
        for k, v in pairs(self._preloadedTasks) do
            MResLoader:CancelAsyncTask(k)
        end
        self._preloadedTasks = nil
    end

    if self._preloadedPrefabs then
        for _, v in ipairs(self._preloadedPrefabs) do
            MResLoader:ReleaseSharedAsset(v)
        end
        self._preloadedPrefabs = nil
    end

    self._getTemplateAndPrefabMethod = nil
end

function UI_TemplatePoolMultipleTemplate:AddTemplate(data, limit)
    local l_overflow = false
    self.Datas = self.Datas or {}
    table.insert(self.Datas, data)

    if limit then
        if #self.Datas > limit then
            table.remove(self.Datas, 1)
            l_overflow = true
        end
    end

    if l_overflow then
        --满格-且在顶部位置
        if self.ScrollRect.cellStartIndex <= 0 then
            local l_pos = self.ScrollRect.content.anchoredPosition
            self:ShowTemplates({ Datas = self.Datas })
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.ScrollRect.content)
            self.ScrollRect:SetContentAnchoredPosition(l_pos)
        else
            --满格-在非顶部
            self.ScrollRect.cellStartIndex = self.ScrollRect.cellStartIndex - 1
            self.ScrollRect.cellEndIndex = self.ScrollRect.cellEndIndex - 1
        end
    else
        --未满30的情况
        self.ScrollRect:AddCell(1)
    end
end

return UI_TemplatePoolMultipleTemplate