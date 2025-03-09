module("Common.UI_TemplatePool", package.seeall)

require "Common/UI_BaseTemplatePool"

local super = Common.UI_TemplatePool.UI_BaseTemplatePool
---@class UI_BaseTemplatePoolScrollRect : UI_BaseTemplatePool
UI_BaseTemplatePoolScrollRect = class("UI_BaseTemplatePoolScrollRect", super)

function UI_BaseTemplatePoolScrollRect:ctor(templateInstantiateData)
    ---@type table<number, number>
    self._cacheMap = {}
    self._createdItemCount = 0
    self._startIdx = 0
    self._moved = false

    --循环滚动条
    self.ScrollRect = templateInstantiateData.ScrollRect
    --对隐藏不用的Template的缓存
    self._hideTemplateCache = {}
    --初始化循环滚动条
    self._cacheParent = MoonClient.LoopScrollRect.GetCacheParent()
    self.ScrollRect:Initialize(
            function(dataIndex)
                return self:_scrollRectTemplatePoolGetGameObject(dataIndex)
            end,
            function(cellGameObject)
                self:_scrollRectTemplatePoolDestroyGameObject(cellGameObject)
            end,
            function(cellTransform, dataIndex)
                self:_scrollRectTemplatePoolOnCellShow(cellTransform, dataIndex)
            end)

    --翻页组件
    self:CheckPagesComponent(templateInstantiateData.pagesCom)
    super.ctor(self, templateInstantiateData)
end

---------------------------------------- Start 在Lua中ScrollRect的调用封装 -----------------------------------------------------------------------

function UI_BaseTemplatePoolScrollRect:DeActiveAll()
    if self.GetDatasMethod == nil then
        self.Datas = {}
    end
    self.ScrollRect:ClearActiveCells()
end

function UI_BaseTemplatePoolScrollRect:ScrollToCell(index, speed)
    if index < 1 then
        return
    end
    self.ScrollRect:ScrollToCell(index - 1, speed)
end

function UI_BaseTemplatePoolScrollRect:totalCount()
    if self.isInited then
        return self.ScrollRect.totalCount
    end
    return 0
end

--根据显示的index获取数据index
function UI_BaseTemplatePoolScrollRect:GetCellStartIndex()
    return self.ScrollRect:GetCellStartIndex() + 1
end

function UI_BaseTemplatePoolScrollRect:GetCellEndIndex()
    return self.ScrollRect:GetCellEndIndex() + 1
end

function UI_BaseTemplatePoolScrollRect:GetCellIndexWithShowIndex(index)
    return self.ScrollRect:GetCellIndexWithShowIndex(index) + 1
end

function UI_BaseTemplatePoolScrollRect:GetShowCount()
    return self.ScrollRect:GetShowCount()
end

function UI_BaseTemplatePoolScrollRect:StopMovement()
    return self.ScrollRect:StopMovement()
end

--拖拽开始回调
function UI_BaseTemplatePoolScrollRect:SetDragBeginCallBack(callback)
    self.ScrollRect.OnBeginDragCallback = callback
end
--拖拽中回调 尽量不要用这个(拖拽的时候每帧执行)
function UI_BaseTemplatePoolScrollRect:SetDragCallBack(callback)
    self.ScrollRect.OnDragCallback = callback
end
--拖拽结束回调
function UI_BaseTemplatePoolScrollRect:SetDragEndCallBack(callback)
    self.ScrollRect.OnEndDragCallback = callback
end

---------------------------------------- End 在Lua中ScrollRect的调用封装 -----------------------------------------------------------------------

---------------------------------------- Start 生命周期和框架内部实现相关 ------------------------------------------------------

--子类覆写
function UI_BaseTemplatePoolScrollRect:_scrollRectTemplatePoolGetGameObject()
    logError("需子类覆写")
    return nil
end

function UI_BaseTemplatePoolScrollRect:_scrollRectTemplatePoolDestroyGameObject(cellGameObject)
    local template = self.Items[cellGameObject:GetInstanceID()]
    if template == nil then
        self:_logErrorWithNoneGameObject(cellGameObject)
        return
    end

    template:SetParent(self._cacheParent)
    table.insert(self._hideTemplateCache, template)
    template:DeActiveTemplate()
end

function UI_BaseTemplatePoolScrollRect:_scrollRectTemplatePoolOnCellShow(cellTransform, dataIndex)
    if MLuaCommonHelper.IsNull(cellTransform) then
        logError("调用onCellShow时传递的cellTransform是空的，dataIndex：" .. tostring(dataIndex))
        return
    end

    dataIndex = dataIndex + 1
    local template = self.Items[cellTransform.gameObject:GetInstanceID()]
    if not template then
        self:_logErrorWithNoneGameObject(cellTransform.gameObject)
        return
    end

    local directSetData = self.C_DEFAULT_SET_DATA_RATE >= self.SetDataRate
    if directSetData then
        self:_baseTemplatePoolSetTemplateData(template, dataIndex)
    else
        local instanceID = cellTransform.gameObject:GetInstanceID()
        self._cacheMap[instanceID] = dataIndex
    end
end

---@param showTemplateData TemplatePoolParam
function UI_BaseTemplatePoolScrollRect:_baseTemplatePoolShowTemplates(showTemplateData)
    self._moved = false
    self._startIdx = 0
    local isAdaptionPosition = true
    local isToStartPosition = true
    if showTemplateData then
        if showTemplateData.StartScrollIndex then
            if showTemplateData.StartScrollIndex > 1 then
                self._startIdx = showTemplateData.StartScrollIndex - 1
            end
        end

        if showTemplateData.IsNeedShowCellWithStartIndex ~= nil then
            isAdaptionPosition = showTemplateData.IsNeedShowCellWithStartIndex
        end

        if showTemplateData.IsToStartPosition ~= nil then
            isToStartPosition = showTemplateData.IsToStartPosition
        end
    end

    if self.C_DEFAULT_SET_DATA_RATE >= self.CreateTemplateRate then
        self.ScrollRect:ShowCells(self.CellCount, self._startIdx, isAdaptionPosition, isToStartPosition)
        return
    end

    self._createdItemCount = 0
    --- 这里要清空，因为可能外界不断的调用这个接口，反复调用数量不一样的时候，如果刷新率比较低，可能会出现残留的情况
    --- 一旦这个缓存出现了残留，分帧加载的时候就会触发没有的数据，就会出现显示错误
    self._cacheMap = {}
    --- 假如需要设置起始位置，这边一开始能够滚动到指定位置的数据量是不够的，所以要添加够，然后再触发滚动
    if 0 < self._startIdx then
        self.ScrollRect:ShowCells(self.CellCount, self._startIdx, isAdaptionPosition, isToStartPosition)
        self._createdItemCount = self.CellCount
        return
    end

    self.ScrollRect:ShowCells(0, self._startIdx, isAdaptionPosition, isToStartPosition)
end

--创建Template
function UI_BaseTemplatePoolScrollRect:_baseScrollRectTemplatePoolCreateTemplate()
    local template = self:_baseTemplatePoolCreateTemplate()
    local instanceID = template:gameObject():GetInstanceID()

    if Application.isEditor then
        template:gameObject().name = template:gameObject().name .. ":" .. tostring(instanceID)
    end

    self.Items[instanceID] = template
    return template
end

function UI_BaseTemplatePoolScrollRect:Uninit()

    if not MLuaCommonHelper.IsNull(self.ScrollRect) then
        self.ScrollRect:Uninit()
        self.ScrollRect = nil
    end

    super.Uninit(self)

    --这个里面的Template也会存在Items中，所以直接置空就可以
    self._hideTemplateCache = nil

    self._cacheParent = nil
end

function UI_BaseTemplatePoolScrollRect:_logErrorWithNoneGameObject(gameObject)
    logError("找不到这个物体:" .. tostring(gameObject:GetInstanceID()))
end

---@override UI_BaseTemplatePool
function UI_BaseTemplatePoolScrollRect:BaseTemplatePoolOnPanelDeActive()

    if self.ScrollRect then
        self.ScrollRect:ResetScroll()
    end

    for i, template in pairs(self.Items) do
        template:SetParent(self._cacheParent)
    end

    super.BaseTemplatePoolOnPanelDeActive(self)
    self._hideTemplateCache = {}
end

---------------------------------------- End 生命周期和框架内部实现相关 ------------------------------------------------------

---------------------------------------- Start 分帧相关 -----------------------------------------------------------------------

--- 如果是设置了刷新率就要接update
function UI_BaseTemplatePoolScrollRect:OnUpdate()
    if self.isInited == false then
        return
    end
    self:_createTemplateByFrame()
    self:_setDataByFrame()
    self:_onUpdate()
end

--- 分帧创建template
function UI_BaseTemplatePoolScrollRect:_createTemplateByFrame()
    if self.C_DEFAULT_SET_DATA_RATE >= self.CreateTemplateRate then
        return
    end

    if self._createdItemCount >= self.CellCount then
        return
    end

    self:_createFromScrollCache()
    self:_createFromResPool()
    self:_forceCreate()
end

--- 从自身缓存池中创建obj
---@return number
function UI_BaseTemplatePoolScrollRect:_createFromScrollCache()
    local remainItemCount = self.CellCount - self._createdItemCount
    if 0 >= remainItemCount then
        return
    end

    local cacheCount = self:_getCacheItemCount()
    if 0 >= cacheCount then
        return
    end

    if cacheCount >= self.CreateTemplateRate and cacheCount <= remainItemCount then
        self.ScrollRect:AddCell(cacheCount)
        self._createdItemCount = self._createdItemCount + cacheCount
        return
    end

    if cacheCount >= self.CreateTemplateRate and cacheCount > remainItemCount then
        self.ScrollRect:AddCell(remainItemCount)
        self._createdItemCount = self._createdItemCount + remainItemCount
        return
    end
end

--- 从resPool当中创建obj
--- 2 如果当前数量小于池中数量，则逐帧添加
--- 这里可能出现我每一帧要创建5个，但是实际上我只有4个空位的情况，如果出现了，则修正
---@return number
function UI_BaseTemplatePoolScrollRect:_createFromResPool()
    local remainItemCount = self.CellCount - self._createdItemCount
    if 0 >= remainItemCount then
        return
    end

    if nil == self._templatePath and nil == self._templatePrefab then
        return
    end

    local cacheCount = 0
    if nil ~= self._templatePath then
        cacheCount = MResLoader:GetUnusedObjCountInPool(self._templatePath)
    elseif nil ~= self._templatePrefab then
        cacheCount = MResLoader:GetUnusedObjCountInPoolByAsset(self._templatePrefab.gameObject)
    else
        -- do nothing
    end

    if cacheCount >= self.CreateTemplateRate and cacheCount <= remainItemCount then
        self.ScrollRect:AddCell(cacheCount)
        self._createdItemCount = self._createdItemCount + cacheCount
        return
    end

    if cacheCount >= self.CreateTemplateRate and cacheCount > remainItemCount then
        self.ScrollRect:AddCell(remainItemCount)
        self._createdItemCount = self._createdItemCount + remainItemCount
        return
    end
end

--- 强制创建obj
---@return number
function UI_BaseTemplatePoolScrollRect:_forceCreate()
    local remainItemCount = self.CellCount - self._createdItemCount
    if 0 >= remainItemCount then
        return
    end

    if remainItemCount < self.CreateTemplateRate then
        self.ScrollRect:AddCell(remainItemCount)
        self._createdItemCount = self._createdItemCount + remainItemCount
    else
        self.ScrollRect:AddCell(self.CreateTemplateRate)
        self._createdItemCount = self._createdItemCount + self.CreateTemplateRate
    end
end

--- 这是一个lua坑，快排算法在比较数据相等的时候会抛异常
function UI_BaseTemplatePoolScrollRect._sortFunc(a, b)
    if a.data_idx == b.data_idx then
        return false
    end

    return a.data_idx < b.data_idx
end

--- 分帧去为template设置数据
function UI_BaseTemplatePoolScrollRect:_setDataByFrame()
    if self.C_DEFAULT_SET_DATA_RATE >= self.SetDataRate then
        return
    end

    local reverseList = {}
    for instanceID, dataIdx in pairs(self._cacheMap) do
        local pair = {
            data_idx = dataIdx,
            instance_id = instanceID,
        }

        table.insert(reverseList, pair)
    end

    table.sort(reverseList, self._sortFunc)

    local i = 0
    local deletedInstMap = {}
    for id, pair in pairs(reverseList) do
        local dataIdx = pair.data_idx
        local instanceID = pair.instance_id
        local template = self.Items[instanceID]
        deletedInstMap[instanceID] = 1

        --- 为什么要判断是否为空，原因是scroll当中的instanceID和dataIdx的对应关系可能会发生变化
        --- 也就是可能因为切页等原因格子位置变了，所以这里可能会获取到空数据
        if nil ~= template then
            self:_baseTemplatePoolSetTemplateData(template, dataIdx)
            i = i + 1
            if i >= self.SetDataRate then
                break
            end
        end
    end

    for instanceID, dataIdx in pairs(deletedInstMap) do
        self._cacheMap[instanceID] = nil
    end
end

--- 多态方法
function UI_BaseTemplatePoolScrollRect:_getCacheItemCount()
    return 0
end

---------------------------------------- End 分帧相关 -----------------------------------------------------------------------

---------------------------------------- 需要废弃 -----------------------------------------------------------------------

--得到显示的物体
--从显示的tem列表里查找匹配的tem
--conditionFunc: 条件方法
--function(tem)
--  return ture
--end
function UI_BaseTemplatePoolScrollRect:FindShowTem(conditionFunc)
    if conditionFunc == nil then
        return nil
    end
    local l_startIndex = self.ScrollRect:GetCellStartIndex()
    local l_endIndex = self.ScrollRect:GetCellEndIndex()
    for i = l_startIndex, l_endIndex do
        local cellTransform = self.ScrollRect:GetCellByIdx(i)
        if cellTransform ~= nil then
            local l_tem = self.Items[cellTransform.gameObject:GetInstanceID()]
            if conditionFunc(l_tem) then
                return l_tem
            end
        end
    end
    return nil
end

-- speed表示滑动速度，0表示直接跳转
function UI_BaseTemplatePoolScrollRect:ScrollAndSelectIndexByDataCondition(conditionFunc, speed)
    speed = speed or 0
    local l_datas = self:getDatas()
    local l_index = nil
    if conditionFunc then
        for i, data in ipairs(l_datas) do
            if conditionFunc(data) then
                l_index = i
                break
            end
        end
    end

    if l_index then
        self:SelectTemplate(l_index)
        self:ScrollToCell(l_index, speed)
    end
end

--根据数据index得到Template
--index为数据的序号，从1开始
--此方法已废弃，不要使用
--废弃原因为：使用ScrollRect并不是全部创建出来，用此方法并不一定能取到想要的Template，导致很多隐藏Bug
--如果想要处理选择请用封装好的SelectTemplate方法
function UI_BaseTemplatePoolScrollRect:GetItem(dataIndex, changeSortMode)
    if dataIndex < 1 then
        return nil
    end
    if changeSortMode ~= nil and changeSortMode then
        dataIndex = self:ChangeIndexSort(dataIndex)
    end
    dataIndex = dataIndex - 1
    local cellTransform = self.ScrollRect:GetCellByIdx(dataIndex)
    if cellTransform ~= nil then
        return self.Items[cellTransform.gameObject:GetInstanceID()]
    end
    return nil
end

function UI_BaseTemplatePoolScrollRect:ChangeIndexSort(dataIndex)
    local l_columnItemNum = self.PagesCom.pageChildNum / self.PagesCom.constraintCount
    local l_curPage = math.ceil(dataIndex / self.PagesCom.pageChildNum)
    local l_dataNumBeforeCurPage = l_curPage * self.PagesCom.pageChildNum
    local l_index = dataIndex - l_dataNumBeforeCurPage
    local l_row = math.ceil(l_index / l_columnItemNum)
    local l_column = l_index - l_row * l_columnItemNum

    dataIndex = l_column * self.PagesCom.constraintCount + l_row + l_dataNumBeforeCurPage
    return dataIndex
end

function UI_BaseTemplatePoolScrollRect:CheckPagesComponent(pagesCom)
    self.PagesCom = nil;
    if pagesCom == nil then
        return
    end
    if not self.ScrollRect then
        logError("缺少ScrollRect！")
        return ;
    end
    if pagesCom.pagesGroup == nil then
        logError("缺少翻页必须的组件：pagesGroup！")
        return
    end
    if pagesCom.pagesItem == nil then
        logError("缺少翻页必须的组件：pagesItem！")
        return
    end
    if pagesCom.pageChildNum == nil or pagesCom.pageChildNum < 1 then
        logError("每页的的项数不能少于1：pageChildNum need greater than 0！")
        return
    end
    pagesCom.curPagesIndex = 0

    self.ScrollRect.OnBeginDragCallback = function(scroll, pointerData)
        self.PagesCom.pointPosition = pointerData.position
    end
    self.ScrollRect.OnEndDragCallback = function(scroll, pointerData)
        self.PagesCom.pointPosition = pointerData.position - self.PagesCom.pointPosition
        if self.PagesCom.pointPosition.x >= 0 then
            if self.PagesCom.pointPosition.x > 75 or self.PagesCom.curPagesIndex == 0 then
                self:MoveToPages(self.PagesCom.curPagesIndex - 1)
            else
                self:MoveToPages(self.PagesCom.curPagesIndex)
            end
        else
            if self.PagesCom.pointPosition.x < -75 or self.PagesCom.curPagesIndex == self.PagesCom.pagesMax - 1 then
                self:MoveToPages(self.PagesCom.curPagesIndex + 1)
            else
                self:MoveToPages(self.PagesCom.curPagesIndex)
            end
        end
    end

    self.PagesCom = pagesCom
end

function UI_BaseTemplatePoolScrollRect:MoveToPages(index)
    local l_border = false
    if index < 0 then
        index = 0
        l_border = true
    elseif index > self.PagesCom.pagesMax - 1 then
        index = self.PagesCom.pagesMax - 1
        l_border = true
    end

    for i = 1, #self.PagesCom.pageTogs do
        self.PagesCom.pageTogs[i].isOn = (index == (i - 1))
    end

    self.PagesCom.curPagesIndex = index

    if not l_border then
        local l_showIndex = self.PagesCom.curPagesIndex * self.PagesCom.pageChildNum
        self.ScrollRect:StopMovement()
        self.ScrollRect:ScrollToCell(l_showIndex, 4000)
    end
end

function UI_BaseTemplatePoolScrollRect:UpdateData(showDatas, needChangeSort)
    if self.PagesCom == nil then
        logError("UpdateDataSort仅适用于翻页组件！")
        return showDatas
    end
    if showDatas == nil then
        return showDatas
    end
    local l_dataCount = #showDatas
    if l_dataCount < 1 then
        l_dataCount = 1
        showDatas[1] = {}
    end

    self.PagesCom.constraintCount = self.ScrollRect:GetContentConstraintCount();
    self.PagesCom.pagesMax = math.ceil(l_dataCount / self.PagesCom.pageChildNum)
    local l_totalChildNum = self.PagesCom.pagesMax * self.PagesCom.pageChildNum;
    while l_dataCount < l_totalChildNum do
        showDatas[l_dataCount + 1] = {}
        l_dataCount = l_dataCount + 1
    end
    --调整显示的pagesItem个数
    while self.PagesCom.pagesGroup.transform.childCount < self.PagesCom.pagesMax do
        if self._parentPanelClass == nil then
            logError("此TemplatePool不是使用我们封装的方法进行创建的，请修改逻辑,全部使用封装的方法进行创建")
        end
        local l_page
        if self._parentPanelClass then
            l_page = self._parentPanelClass:CloneObj(self.PagesCom.pagesItem.gameObject)
        else
            l_page = self:CloneObj(self.PagesCom.pagesItem.gameObject)
        end
        l_page.transform:SetParent(self.PagesCom.pagesGroup.transform)
        l_page.transform:SetLocalScaleOne()
    end

    self.PagesCom.pageTogs = {}
    for i = 0, self.PagesCom.pagesGroup.transform.childCount - 1 do
        local l_child = self.PagesCom.pagesGroup.transform:GetChild(i).gameObject
        l_child:SetActiveEx(i < self.PagesCom.pagesMax)
        local l_tog = l_child:GetComponent("UIToggleEx")
        l_tog.isOn = (i == 0)
        if i < self.PagesCom.pagesMax then
            self.PagesCom.pageTogs[#self.PagesCom.pageTogs + 1] = l_tog
        end
    end
    local l_resultData = showDatas;
    if needChangeSort then
        l_resultData = self:changeSort(showDatas);
    end
    self:ShowTemplates({ Datas = l_resultData })
    return l_resultData;
end
--不支持外部直接调用
function UI_BaseTemplatePoolScrollRect:changeSort(showDatas)
    if self.PagesCom == nil or self.ScrollRect == nil then
        return showDatas;
    end
    --每页重新排序
    local l_sortDatas = {}
    local l_rowItemNum = self.PagesCom.pageChildNum / self.PagesCom.constraintCount
    for i = 0, self.PagesCom.pagesMax - 1 do
        local l_itemsNumBeforeCurPage = i * self.PagesCom.pageChildNum;
        for j = 1, self.PagesCom.pageChildNum do
            local l_index = l_itemsNumBeforeCurPage + j
            local l_PosY = math.ceil(j / l_rowItemNum)
            local l_PosX = j - (l_PosY - 1) * l_rowItemNum
            local l_PosIndex = 0
            if not self.ScrollRect.IsHorizontal then
                local l_tempPosX = l_PosX;
                l_PosX = l_PosY
                l_PosY = l_tempPosX
                l_PosIndex = l_rowItemNum * (l_PosY - 1) + l_PosX
            else
                l_PosIndex = self.PagesCom.constraintCount * (l_PosX - 1) + l_PosY
            end
            local l_NewIndex = l_PosIndex + (l_itemsNumBeforeCurPage)
            l_sortDatas[l_NewIndex] = showDatas[l_index]
        end
    end
    return l_sortDatas;
end
---------------------------------------- 需要废弃 -----------------------------------------------------------------------

return UI_BaseTemplatePoolScrollRect