module("UIManager", package.seeall)

UIPanelDebuger = class("UIPanelDebuger")

function UIPanelDebuger:Test()

    local testTable = {}

    table.insert(testTable, 1)
    table.insert(testTable, 2)
    table.insert(testTable, 3)
    table.insert(testTable, 4)
    table.insert(testTable, 5)

    for i = 1, Mathf.Pow(#testTable, #testTable + 1) do
        local resultTable = self:_getCombinationWithIndex(testTable, i)
        if resultTable == nil then
            break
        end
        local resultText = ""
        for j = 1, #resultTable do
            if j ~= 1 then
                resultText = resultText .. "、"
            end
            resultText = resultText .. tostring(resultTable[j])
        end
        logGreen("resultTable,index:" .. tostring(i) .. "  result:" .. resultText)
    end
end

--调用方式
--UIMgr:OpenUIPanelDebuger()
--UIPanelDebuger:TestPanelActive()
function UIPanelDebuger:TestPanelActive()
    local methodTable = {}

    table.insert(methodTable, function()
        UIMgr:ActiveUI(UI.CtrlNames.Bag, nil, nil, true)
    end)
    table.insert(methodTable, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Bag, true)
    end)
    table.insert(methodTable, function()
        UIMgr:ShowUI(UI.CtrlNames.Bag, true)
    end)
    table.insert(methodTable, function()
        UIMgr:HideUI(UI.CtrlNames.Bag, true)
    end)
    table.insert(methodTable, function()
        UIMgr:ActiveUI(UI.CtrlNames.Bag, nil, nil, false)
    end)
    table.insert(methodTable, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Bag, false)
    end)
    table.insert(methodTable, function()
        UIMgr:ShowUI(UI.CtrlNames.Bag, false)
    end)
    table.insert(methodTable, function()
        UIMgr:HideUI(UI.CtrlNames.Bag, false)
    end)

    table.insert(methodTable, function()
        UIMgr:ActiveUI(UI.CtrlNames.Mall, nil, nil, true)
    end)
    table.insert(methodTable, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Mall, true)
    end)
    table.insert(methodTable, function()
        UIMgr:ShowUI(UI.CtrlNames.Mall, true)
    end)
    table.insert(methodTable, function()
        UIMgr:HideUI(UI.CtrlNames.Mall, true)
    end)
    table.insert(methodTable, function()
        UIMgr:ActiveUI(UI.CtrlNames.Mall, nil, nil, false)
    end)
    table.insert(methodTable, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Mall, false)
    end)
    table.insert(methodTable, function()
        UIMgr:ShowUI(UI.CtrlNames.Mall, false)
    end)
    table.insert(methodTable, function()
        UIMgr:HideUI(UI.CtrlNames.Mall, false)
    end)

    local index = 0
    local testTimer = Timer.New(function()
        index=index+1
        local resultTable = self:_getCombinationWithIndex(methodTable, index)
        if resultTable == nil then
            testTimer:Stop()
            logYellow("测试结束")
        end
        for i = 1, #resultTable do
            resultTable[i]()
        end
    end, 1, -1, true)
    testTimer:Start()



    --for i = 1, Mathf.Pow(#methodTable, #methodTable+1) do
    --    local resultTable= self:_getCombinationWithIndex(methodTable,i)
    --    if resultTable == nil then
    --        break
    --    end
    --
    --end
end

function UIPanelDebuger:_getCombinationWithIndex(dataTable, index)
    if index <= 0 then
        logError("传递的index为" .. tostring(index))
        return
    end
    local dataCount = #dataTable
    if dataCount <= 0 then
        logError("传递的数据个数为0")
        return
    end
    --index从0开始比较好计算
    index = index - 1
    local resultTable = nil
    for exponential = 1, dataCount do
        --当前区间的总数
        local currentExponentialLevelCount = Mathf.Pow(dataCount, exponential)
        --如果index小于此区间的总数，说明在此区间之内
        if index < currentExponentialLevelCount then
            --指数个数即为组合的元素个数
            for i = 1, exponential do
                if resultTable == nil then
                    resultTable = {}
                end
                local currentIndex
                --如果是最后一位，要使用%来取
                if i == exponential then
                    currentIndex = (index % dataCount)
                else
                    --计算当前位置的元素Index
                    local currentPowValue = Mathf.Pow(dataCount, exponential - i)
                    currentIndex = index / currentPowValue
                    currentIndex = math.floor(currentIndex)
                    --根据当前的元素Index来计算下一位的元素所在区间的index
                    index = index - (currentIndex * currentPowValue)
                end
                currentIndex = tonumber(currentIndex)
                table.insert(resultTable, dataTable[currentIndex + 1])
            end
            break
        else
            --转到下一个区间，index减去当前区间个数
            index = index - currentExponentialLevelCount
        end
    end
    return resultTable
end

declareGlobal("UIPanelDebuger", UIPanelDebuger.new())

return UIPanelDebuger

