module("Common.UI_TemplatePool", package.seeall)

require "Common/UI_BaseTemplatePoolScrollRect"

local super = Common.UI_TemplatePool.UI_BaseTemplatePoolScrollRect
---@class UI_TemplatePoolScrollRect : UI_BaseTemplatePoolScrollRect
UI_TemplatePoolScrollRect = class("UI_TemplatePoolScrollRect", super)

function UI_TemplatePoolScrollRect:_scrollRectTemplatePoolGetGameObject()
    local template
    local cacheTemplateCount = #self._hideTemplateCache
    if cacheTemplateCount > 0 then
        template = self._hideTemplateCache[cacheTemplateCount]
        table.remove(self._hideTemplateCache, cacheTemplateCount)
    else
        template = self:_baseScrollRectTemplatePoolCreateTemplate()
    end
    template:ActiveTemplate()
    return template:gameObject()
end

function UI_BaseTemplatePoolScrollRect:AddTemplate(data)
    if self.GetDatasMethod == nil then
        table.insert(self.Datas, data)
    end

    if self.isInited then
        self.ScrollRect:AddCell()
    end
end

--删除物体
function UI_BaseTemplatePoolScrollRect:RemoveTemplateByIndex(index)
    if index <= 0 then
        return
    end

    if self.isInited then
        if self.GetDatasMethod == nil then
            table.remove(self.Datas, index)
        end
        self:_baseTemplatePoolRefreshShowIndexOnRemoveTemplate(index)
        self.ScrollRect:DeleteCellWithDataIndex(index - 1)
    end

end

--刷新列表
function UI_BaseTemplatePoolScrollRect:RefreshCells()
    if not self.isInited then
        return
    end

    --- 数据的总数量
    local dataCount = self:getDataCount()
    if self._minCount > dataCount then
        dataCount = self._minCount
    end

    if dataCount > self._maxCount and 0 < self._maxCount then
        dataCount = self._maxCount
    end

    --- scroll里面的数据数量，不是创建obj的数量
    local objCount = self:totalCount()
    if dataCount == objCount then
        self.ScrollRect:RefreshCells()
        return
    end

    if self.C_DEFAULT_SET_DATA_RATE >= self.CreateTemplateRate then
        self.ScrollRect:ShowCells(dataCount)
        return
    end

    --- 可能有一个问题，可能会出现创建过程中，被refresh掉了，这个时候会出现重新刷新的情况
    --- 所以要判断如果是创建过程当中，就只刷数据，不重新创建
    --- 如果到了这里说明是需要分帧创建，但是还没有创建结束
    if objCount < dataCount then
        self.ScrollRect:RefreshCells()
        return
    end

    self._createdItemCount = 0
    --self._delayFrame = true
    self.ScrollRect:ShowCells(0)
end

--刷新单个显示物体
function UI_BaseTemplatePoolScrollRect:RefreshCell(index)
    if index < 1 then
        return
    end

    if self.isInited then
        self.ScrollRect:RefreshCell(index - 1)
    end
end

function UI_BaseTemplatePoolScrollRect:ReplaceTemplateData(index, data)
    if index < 1 then
        return
    end

    if not data then
        return
    end

    local l_originalData = self:getDatas()
    if not l_originalData then
        return
    end

    local l_originalCount = #l_originalData
    if index > l_originalCount then
        return
    end

    l_originalData[index] = data
end

function UI_BaseTemplatePoolScrollRect:AddTotalCount(num)
    self.CellCount = self.CellCount + num
    if self.isInited then
        self.ScrollRect:AddCell(num)
    end
end

--- 获取常规滚动区域自身的缓存数量
function UI_BaseTemplatePoolScrollRect:_getCacheItemCount()
    local cacheCount = #self._hideTemplateCache
    return cacheCount
end

return UI_TemplatePoolScrollRect