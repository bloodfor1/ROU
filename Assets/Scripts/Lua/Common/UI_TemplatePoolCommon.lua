module("Common.UI_TemplatePool", package.seeall)

require "Common/UI_BaseTemplatePool"

local super = Common.UI_TemplatePool.UI_BaseTemplatePool
---@class UI_TemplatePoolCommon : UI_BaseTemplatePool
UI_TemplatePoolCommon = class("UI_TemplatePoolCommon", super)

-->TemplateParent 父物体
function UI_TemplatePoolCommon:ctor(templateInstantiateData)
    super.ctor(self, templateInstantiateData)
    self._setDataIdx = 1
    self._createIdx = 1
    --- item的父物体，new的时候设置一个初始的父物体
    self._templateParent = templateInstantiateData.TemplateParent
    self._showTemplatesParam = nil
end

------------------------------------------------- Start 生命周期和框架内部实现相关 ------------------------------------------------------

-->Parent父物体，不传为new时传递的父物体
function UI_TemplatePoolCommon:_baseTemplatePoolShowTemplates(showTemplateData)
    self._showTemplatesParam = showTemplateData
    local directSetData = self.C_DEFAULT_SET_DATA_RATE >= self.SetDataRate
    local directCreate = self.C_DEFAULT_SET_DATA_RATE >= self.CreateTemplateRate
    local count = self.CellCount

    --- 这里会有很多状态，有四种
    --- 是瞬间创建，而且是瞬间setData
    --- 创建瞬间，分帧setData
    --- 分帧创建，瞬间SetData
    --- 全分帧
    if not directSetData then
        self._setDataIdx = 1
    end

    if not directCreate then
        self._createIdx = 1
        return
    end

    --当没有传父物体时使用初始父物体
    local l_parent = self._templateParent
    if showTemplateData and showTemplateData.Parent then
        l_parent = showTemplateData.Parent
    end

    for i = 1, count do
        local template
        if i > #self.Items then
            template = self:_baseTemplatePoolCreateTemplate()
            table.insert(self.Items, template)
        else
            template = self.Items[i]
        end

        template:SetParent(l_parent)
        template:ActiveTemplate()
        template:SetMethodCallback(self.Method)
        if directSetData then
            self:_baseTemplatePoolSetTemplateData(template, i)
        end
    end

    self._setDataIdx = 1
    for i = count + 1, #self.Items do
        self.Items[i]:DeActiveTemplate()
    end
end

function UI_TemplatePoolCommon:Uninit()
    super.Uninit(self)
    self._templateParent = nil
    self._showTemplatesParam = nil
    self._setDataIdx = 1
    self._createIdx = 1
end

------------------------------------------------- End 生命周期和框架内部实现相关 ------------------------------------------------------

function UI_TemplatePoolCommon:DeActiveAll()
    if self.GetDatasMethod == nil then
        self.Datas = {}
    end

    for i = 1, #self.Items do
        self.Items[i]:DeActiveTemplate()
    end
end

function UI_TemplatePoolCommon:AddTemplate(data)
    if self.GetDatasMethod == nil then
        table.insert(self.Datas, data)
    end

    ---@type BaseUITemplate
    local currentItem = nil
    for i = 1, #self.Items do
        if not self.Items[i]:IsActive() then
            currentItem = self.Items[i]
            break
        end
    end

    if currentItem == nil then
        currentItem = self:_baseTemplatePoolCreateTemplate()
        table.insert(self.Items, currentItem)
    end

    currentItem:SetParent(self._templateParent)
    currentItem:ActiveTemplate()
    self:_baseTemplatePoolSetTemplateData(currentItem, self:getDataCount())
    return currentItem
end

--删除物体
function UI_TemplatePoolCommon:RemoveTemplateByIndex(index)
    if index <= 0 then
        return
    end
    if self.GetDatasMethod == nil then
        if self.Datas == nil then
            return
        end
        if #self.Datas < index then
            return
        end
        table.remove(self.Datas, index)
    end
    if self.isInited == false then
        return
    end
    local currentItem = self.Items[index]
    if currentItem == nil then
        return
    end
    currentItem:DeActiveTemplate()
    self:_baseTemplatePoolRefreshShowIndexOnRemoveTemplate(index)
end

function UI_TemplatePoolCommon:RefreshCells()
    --项的数量 大于 数据数量 去除多余项
    local l_curDataIndex = 1
    for i = 1, #self.Items do
        if self.Items[i]:IsActive() then
            self:_baseTemplatePoolSetTemplateData(self.Items[i], l_curDataIndex)
            l_curDataIndex = l_curDataIndex + 1
        end
    end

    self._setDataIdx = 1
end

--得到显示的物体
--index为显示的序号，从1开始
function UI_TemplatePoolCommon:GetItem(index)
    if index < 1 then
        return nil
    end

    local activeIndex = 1
    for i = 1, #self.Items do
        if self.Items[i]:IsActive() then
            if activeIndex == index then
                return self.Items[i]
            end
            activeIndex = activeIndex + 1
        end
    end

    return nil
end

function UI_TemplatePoolCommon:GetItems()
    return self.Items
end

--得到显示的物体
--从显示的tem列表里查找匹配的tem
--conditionFunc: 条件方法
--function(tem)
--  return ture
--end
function UI_TemplatePoolCommon:FindShowTem(conditionFunc)
    if conditionFunc == nil then
        return nil
    end
    for i, v in ipairs(self.Items) do
        if conditionFunc(v) then
            return v
        end
    end
    return nil
end

--- 如果是设置了刷新率就要接update
function UI_TemplatePoolCommon:OnUpdate()
    if self.isInited == false then
        return
    end
    self:_createTemplateByFrame(self._showTemplatesParam)
    self:_setDataByFrame()
    self:_onUpdate()
end

--- 每一帧创建数据
function UI_TemplatePoolCommon:_createTemplateByFrame(showTemplateData)
    if nil == showTemplateData then
        return
    end

    if self.C_DEFAULT_SET_DATA_RATE >= self.CreateTemplateRate then
        return
    end

    if self._createIdx >= self.CellCount + 1 then
        return
    end

    local directSetData = self.C_DEFAULT_SET_DATA_RATE >= self.SetDataRate
    local l_parent = self._templateParent
    if showTemplateData and showTemplateData.Parent then
        l_parent = showTemplateData.Parent
    end

    local createRange = self.CreateTemplateRate + self._createIdx
    local remainItemCount = self.CellCount - (self._createIdx - 1)
    if nil ~= self._templatePath or nil ~= self._templatePrefab then
        local cacheCount = 0
        if nil ~= self._templatePath then
            cacheCount = MResLoader:GetUnusedObjCountInPool(self._templatePath)
        elseif nil ~= self._templatePrefab then
            cacheCount = MResLoader:GetUnusedObjCountInPoolByAsset(self._templatePrefab.gameObject)
        else
            -- do nothing
        end

        if cacheCount >= self.CreateTemplateRate and cacheCount <= remainItemCount then
            createRange = cacheCount + self._createIdx
        end

        if cacheCount >= self.CreateTemplateRate and cacheCount > remainItemCount then
            createRange = remainItemCount + self._createIdx
        end
    end

    if createRange > self.CellCount then
        createRange = self.CellCount
    end

    for i = self._createIdx, createRange do
        self._createIdx = self._createIdx + 1
        local template
        if i > #self.Items then
            template = self:_baseTemplatePoolCreateTemplate()
            table.insert(self.Items, template)
        else
            template = self.Items[i]
        end

        template:SetParent(l_parent)
        template:ActiveTemplate()
        template:SetMethodCallback(self.Method)
        if directSetData then
            self:_baseTemplatePoolSetTemplateData(template, i)
        end
    end

    for i = self.CellCount + 1, #self.Items do
        self.Items[i]:DeActiveTemplate()
    end
end

--- 每一帧去setData
function UI_TemplatePoolCommon:_setDataByFrame()
    if self.C_DEFAULT_SET_DATA_RATE >= self.SetDataRate then
        return
    end

    if self._setDataIdx > #self.Items then
        return
    end

    for i = self._setDataIdx, self._setDataIdx + self.SetDataRate do
        if i > #self.Items or i > self.CellCount then
            break
        end

        local template = self.Items[i]
        self:_baseTemplatePoolSetTemplateData(template, i)
        self._setDataIdx = self._setDataIdx + 1
    end

    for i = self.CellCount + 1, #self.Items do
        self.Items[i]:DeActiveTemplate()
    end
end

return UI_TemplatePoolCommon