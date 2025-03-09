module("Common", package.seeall)
-- 数据结构：数组，以连续自然数为索引的table
-- 其中定义若干用于处理数组的函数

local ipairs = ipairs
local insert = table.insert

array = {}

array.empty = setmetatable({}, {__newindex = function() error("Try to alter table array.empty(readonly)!") end})

function array.each(t, f)
    for i, v in ipairs(t) do
        if f then f(v) end
    end
end

function array.veach(t, f)
    for i, v in pairs(t) do
        if f then f(v) end
    end
end

function array.contains(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

function array.addUnique(t, v)
    if not array.contains(t, v) then
        table.insert(t, v)
    end
end

--==============================--
--desc:查找第一个符合条件的元素
--time:2017-07-14 02:18:59
--@t:数组
--@f:查找函数
--return 第一个符合条件的元素，没有则返回nil
--==============================--
function array.find(t, f)
    for i, v in ipairs(t) do
        if f(v) then
            return v, i
        end
    end
    return nil
end

--==============================--
--desc:查找全部符合条件的元素
--time:2017-06-26 03:18:45
--@t:数组
--@f:查找函数
--return 符合条件的元素的数组
--==============================--
function array.findall(t, f)
    local result = {}
    for _, v in ipairs(t) do
        if f(v) then
            insert(result, v)
        end
    end
    return result
end

function array.maxof(t, f)
    local n = #t
    local ret = t[1]
    local val = ret and f(ret)
    local temp = nil
    local tempval = nil
    for i = 2, n do
        temp = t[i]
        tempval = f(temp)
        if not val or (tempval and tempval > val) then
            ret = temp
            val = tempval
        end
    end
    return ret, val
end

function array.minof(t, f)
    local n = #t
    local ret = t[1]
    local val = ret and f(ret)
    local temp = nil
    local tempval = nil
    for i = 2, n do
        temp = t[i]
        tempval = f(temp)
        if not val or (tempval and tempval < val) then
            ret = temp
            val = tempval
        end
    end
    return ret, val
end

--==============================--
--desc:扫描数组
--time:2017-06-26 02:42:33
--@t:数组
--@scanf:扫描函数，第一个参数为数组元素，第二个参数为中间扫描结果，返回更新后的扫描结果
--@initValue:扫描结果的初值
--return 扫描结果
--==============================--
function array.scan(t, scanf, initValue)
    local result = initValue
    for _, v in ipairs(t) do
        result = scanf(v, result)
    end
    return result
end

--==============================--
--desc:映射数组
--time:2017-06-26 02:41:32
--@t:原数组
--@converter:映射字段或函数，nil表示恒等映射
--return 映射后的数组
--==============================--
function array.map(t, f)
    local result = {}
    local tp = type(f)
    if tp == "string" then
        for _, v in ipairs(t) do
            insert(result, v[f])
        end
    elseif tp == "function" then
        for _, v in ipairs(t) do
            insert(result, f(v))
        end
    else
        for _, v in ipairs(t) do
            insert(result, v)
        end
    end
    return result
end

function array.union(t1, t2)
    local t = array.copy(t1)
    table.mergeArray(t, t2)
    return t
end

--==============================--
--desc:计算两个集合（数组）的差
--time:2017-06-26 02:41:32
--@t1:集合1
--@t2:集合2
--@cmper:比较函数，nil表示默认比较函数（==）
--return 集合的差
--==============================--
function array.substract(t1, t2, cmper)
    local result = {}
    local equal = false
    for _, v1 in ipairs(t1) do
        equal = false
        for _, v2 in ipairs(t2) do
            if cmper then
                if cmper(v1, v2) then
                    equal = true
                    break
                end
            elseif v1 == v2 then
                equal = true
                break
            end
        end
        if not equal then
            insert(result, v1)
        end
    end
    return result
end

--==============================--
--desc:移除区间内的元素
--time:2017-09-19 07:45:21
--@t:集合
--@from:移除的起始索引
--@to:移除的终止索引
--return 
--==============================--
function array.removerange(t, from, to)
    from = from or 1
    local n = #t
    to = to or n
    local d = to - from + 1
    for i = to + 1, n do
        t[i - d] = t[i]
    end
    for i = n - d + 1, n do
        t[i] = nil
    end
end

--==============================--
--desc:移除符合条件的元素
--time:2017-09-19 07:45:58
--@t:集合
--@predicate:移除条件
--return 
--==============================--
function array.removeall(t, predicate)
    local n = #t
    local j = 0
    for i = 1, n do
        if not predicate(t[i]) then
            j = j + 1
            t[j] = t[i]
        end
    end
    for i = j + 1, n do
        t[i] = nil
    end
end

--==============================--
--desc:统计符合条件的元素数目
--time:2017-09-20 02:06:02
--@t:数组
--@match:如果是函数，统计使该函数返回true的数量；如果不是函数，统计等于该值的数量
--return 符合条件的元素数目
--==============================--
function array.countof(t, match)
    local count = 0
    if type(match) == "function" then
        for i = #t, 1, -1 do
            if match(t[i]) then
                count = count + 1
            end
        end
    else
        for i = #t, 1, -1 do
            if match == t[i] then
                count = count + 1
            end
        end
    end
    return count
end

--==============================--
--desc:生成指定数量的数组元素并插入到数组尾部
--time:2017-09-21 05:43:10
--@t:数组
--@generator:如果是函数，其返回值作为数组元素；如果不是函数，其自身作为数组元素
--@count:生成的数量
--return 扩充后的数组
--==============================--
function array.spawn(t, generator, count)
    if type(generator) == "function" then
        for i = 1, count do
            insert(t, generator(i))
        end
    else
        for i = 1, count do
            insert(t, generator)
        end
    end
    return t
end

--==============================--
--desc:浅拷贝数组
--time:2017-09-21 06:44:59
--@t:数组
--return 拷贝数组
--==============================--
function array.copy(t)
    local ret = {}
    for i, v in ipairs(t or {}) do
        ret[i] = v
    end
    return ret
end

--==============================--
--desc:按照指定字段排序
--time:2017-09-21 08:05:21
--@t:数组
--@fieldName:排序的字段名
--@desc:是否降序
--return 
--==============================--
function array.sortby(t, fieldName, desc)
    if desc then
        table.sort(t, function(lhs, rhs) return lhs[fieldName] > rhs[fieldName] end)
    else
        table.sort(t, function(lhs, rhs) return lhs[fieldName] < rhs[fieldName] end)
    end
end

--==============================--
--desc:过滤数组中元素
--time:16:27 2017/11/10
--return
--==============================--
function array.filter(t, f)
    local ret = {}
    for i, v in ipairs(t) do
        if f(v) then
            insert(ret, f(v))
        end
    end
    return ret
end

function array.indexof(t, v)
    local idx = -1
    for i, value in ipairs(t) do
        if v == value then
            idx = i
            break
        end
    end
    return idx
end

--==============================--
--desc:将数组元素分组
--time:2017-12-09 05:45:04
--@t:数组
--@args:分组函数/字段，多个参数表示多级分组
--return 分组结果
--==============================--
function array.group(t, ...)
    local function rawgroup(tab, funcs, index, func)
        local ret = {}
        local key, group
        for i, v in ipairs(tab) do
            key = func(v)
            group = ret[key]
            if not group then
                group = {}
                ret[key] = group
            end
            insert(group, v)
        end
        index = index + 1
        local next = funcs[index]
        if next then
            for k, v in pairs(ret) do
                ret[k] = rawgroup(v, funcs, index, next)
            end
        end
        return ret
    end
    local fs = array.map({...}, function(f)
        return type(f) == "function" and f or function(v) return v[f] end
    end)
    return rawgroup(t, fs, 1, fs[1])
end