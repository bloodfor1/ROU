module("Co", package.seeall)
CoProcessor = class("CoProcessor")

local weak_ref_meta = {__mode = "k"}

local setmetatable = setmetatable
local unpack = unpack
local tostring = tostring
local create = coroutine.create
local resume = coroutine.resume
local yield = coroutine.yield
local status = coroutine.status
local running = coroutine.running
local ipairs = ipairs
local pairs = pairs
local select = select
local next = next
local insert = table.insert
local remove = table.remove
local removebyvalue = table.removebyvalue
local traceback = debug.traceback
local getinfo = debug.getinfo
local getupvalue = debug.getupvalue
local Time = Time
local ticktime = Time.fixedTime
local logerror = logError
local sub = string.sub
local find = string.find
local gsub = string.gsub
local gmatch = string.gmatch
local char = string.char
local rep = string.rep

local terminators = {}
local history = {}
local coNames = {}
local activeCoFuncs = {}
local parents = {}

setmetatable(terminators, weak_ref_meta)
setmetatable(history, weak_ref_meta)
setmetatable(coNames, weak_ref_meta)
setmetatable(activeCoFuncs, weak_ref_meta)
setmetatable(parents, weak_ref_meta)

local function _coTerminate(co)
    history[co] = true
    activeCoFuncs[co] = nil
    parents[co] = nil
    local tms = terminators[co]
    if tms then
        for _, f in ipairs(tms) do
            f()
        end
        terminators[co] = nil
    end
end

local function _coTerminateAll(cos)
    for _, co in ipairs(cos) do
        _coTerminate(co)
    end
end


function CoProcessor:ctor()
    self._addlist = {}
    self._removelist = {}
    self._namemap = {}
    self._dirty = -1 -- -1-empty 0-unchanged 1-changed
end

function CoProcessor:Reset()
    if self._dirty == -1 then
        return
    end
    self._dirty = -1
    self._namemap = {}
    local n = #self
    local co
    for i = 1, n do
        co = self[i]
        if not self._removelist[co] then
            _coTerminate(co)
        end
        self[i] = nil
    end
    self._removelist = {}
    n = #self._addlist
    for i = 1, n do
        _coTerminate(self._addlist[i])
        self._addlist[i] = nil
    end
end

local  _tickOne = function(self, co)
    local s, v = resume(co, ticktime)
    if not s then
        v = traceback(co, v)
        logerror(v)
        return false
    end

    return status(co) ~= "dead"
end

local _removeFromNamemap = function(self, co)
    -- for k, v in pairs(self._namemap) do
    -- 	if v == co then
    -- 		self._namemap[k] = nil
    -- 		break
    -- 	end
    -- end
    local name = coNames[co]
    if name and self._namemap[name] == co then
        self._namemap[name] = nil
    end
end

function CoProcessor:Add(f, name)
    local co = create(f)
    activeCoFuncs[co] = f
    if name then
        if self._namemap[name] then
            logerror("co name conflicts: " .. tostring(name) .. "\n" .. traceback())
        end
        self._namemap[name] = co
        coNames[co] = name
    end
    self._dirty = 1
    insert(self._addlist, co)
    if not _tickOne(self, co) and self._dirty ~= -1 then
        removebyvalue(self._addlist, co)
        if name then
            self._namemap[name] = nil
        end
        _coTerminate(co)
    end
    return co
end

function CoProcessor:Contains(co)
    if self._removelist[co] then
        return false
    end
    for i, v in ipairs(self) do
        if v == co then
            return true
        end
    end
    if self._dirty == 1 then
        for i, v in ipairs(self._addlist) do
            if v == co then
                return true
            end
        end
    end
    return false
end


function CoProcessor:ContainsName(name)
    return self._namemap[name] ~= nil
end


function CoProcessor:GetByName(name)
    return self._namemap[name]
end


function CoProcessor:Names()
    return pairs(self._namemap)
end


function CoProcessor:Remove(co)
    co = co or running()
    if self._dirty == -1 or self._removelist[co] then
        return
    end
    if removebyvalue(self._addlist, co) == 0 then
        for _, v in ipairs(self) do
            if v == co then
                self._removelist[co] = true
                _coTerminate(co)
                break
            end
        end
    else
        _coTerminate(co)
    end
    self._dirty = 1
    _removeFromNamemap(self, co)
end


function CoProcessor:RemoveByName(name)
    local co = self._namemap[name]
    if co and not self._removelist[co] then
        if removebyvalue(self._addlist, co) == 0 then
            for _, v in ipairs(self) do
                if v == co then
                    self._removelist[co] = true
                    _coTerminate(co)
                    break
                end
            end
        else
            _coTerminate(co)
        end
        self._dirty = 1
        self._namemap[name] = nil
    end
end


function CoProcessor:Tick(tick)
    if self._dirty == -1 then
        return 0
    end

    ticktime = tick

    if self._dirty == 1 then
        for i = 1, #self._addlist do
            insert(self, self._addlist[i])
        end
        self._addlist = {}
        self._dirty = next(self._removelist) and 1 or 0
    end

    for i, co in ipairs(self) do
        if not self._removelist[co] then
            local result = _tickOne(self, co)
            if self._dirty == -1 then
                break
            elseif not result then
                self._removelist[co] = true
                _coTerminate(co)
                self._dirty = 1
                _removeFromNamemap(self, co)
            end
        end
    end

    local addn = 0
    if self._dirty == 1 then
        addn = #self._addlist
        if addn == 0 then
            self._dirty = 0
        end
        local cur = 1
        local n = #self
        for i = 1, n do
            local co = self[i]
            if not self._removelist[co] then
                self[cur] = co
                cur = cur + 1
            else
                self._removelist[co] = nil
            end
        end
        for i = cur, n do
            self[i] = nil
        end
        --BEGIN_DEBUG
        if next(self._removelist) then
            logerror("co processor's removelist is not clear!\n" .. traceback())
        end
        --END_DEBUG
    end

    local totaln = #self + addn
    if totaln == 0 then
        self._dirty = -1
    end
    return totaln
end



-- 单协程处理器，只能同时处理一个协程
MonoCoProcessor = class("MonoCoProcessor")

function MonoCoProcessor:Reset()
    if self.co then
        _coTerminate(self.co)
    end
    self.co = nil
end

function MonoCoProcessor:Add(f)
    if self.co then
        error("Can't add multiple coroutine in MonoCoProcessor")
    else
        local co = create(f)
        activeCoFuncs[co] = f
        local s, v = resume(co, ticktime)
        if s then
            if status(co) == "dead" then
                _coTerminate(co)
            else
                self.co = co
            end
        else
            _coTerminate(co)
            v = traceback(co, v)
            logerror(v)
        end
        return co
    end
end

function MonoCoProcessor:Contains(co)
    return self.co == co
end

function MonoCoProcessor:Remove(co)
    co = co or running()
    if self.co == co then
        _coTerminate(co)
        self.co = nil
    end
end

function MonoCoProcessor:Tick(tick)
    local co = self.co
    if co then
        ticktime = tick
        local s, v = resume(co, ticktime)
        if not s then
            _coTerminate(co)
            self.co = nil
            v = traceback(co, v)
            logerror(v)
            return 0
        end
        if status(co) == "dead" then
            _coTerminate(co)
            if self.co == co then
                self.co = nil
            end
            return 0
        else
            return 1
        end
    else
        return 0
    end
end

--==============================--
--desc:判断协程是否已终结
--time:2017-11-02 05:20:59
--@co:协程
--return 协程是否已终结
--==============================--
function CoTerminated(co)
    return history[co]
end

--==============================--
--desc:注册一个终结函数，该函数当协程终结时（协程运行完毕或者Remove、Reset、error时）会被调用
--time:2017-08-17 10:57:31
--@f:终结函数
--@co:被注册的协程，默认为当前协程
--return 闭包，调用该闭包则执行本次注册的终结函数并从注册列表中移除
--==============================--
function CoRegisterTerminator(f, co)
    co = co or running()
    assert(co, "Can't register coroutine terminator in main thread!")
    if history[co] then -- 向已经终结的协程注册终结函数，立刻执行
        f()
        return function() end
    else
        local tms = terminators[co]
        if not tms then
            tms = {}
            terminators[co] = tms
        end
        insert(tms, f)
        return function()
            local tms = co and terminators[co]
            if tms then
                for i = #tms, 0, -1 do
                    if tms[i] == f then
                        remove(tms, i)
                        f()
                        break
                    end
                end
            end
        end
    end
end


function CoGetId(co)
    return sub(tostring(co), 9, -1)
end

local CoGetId = CoGetId

function CoGetActiveById(id)
    for co in pairs(activeCoFuncs) do
        if CoGetId(co) == id then
            return co
        end
    end
end

function CoGetActiveUpValues(co)
    local f = activeCoFuncs[co]
    if f then
        local ret = {}
        local i = 1
        while true do
            local k, v = getupvalue(f, i)
            if not k then
                break
            end
            ret[k] = v
            i = i + 1
        end
        return ret
    end
end

function CoGetActiveLocalValues(co, stackLevel)
    local f = activeCoFuncs[co]
    if f then
        local ret = {}
        local i = 1
        while true do
            local k, v = debug.getlocal(co, stackLevel, i)
            if not k then
                break
            end
            ret[k] = v
            i = i + 1
        end
        return ret
    end
end

local function _getValuesText(values)
    local ret = {}
    for k, v in pairs(values) do
        insert(ret, k .. " = " .. tostring(v))
    end
    return table.concat(ret, "\n")
end

local function _getValueText(v, path, printLevel)
    local k
    for i = 2, #path do
        k = path[i]
        if string.match(k, "^[+-]?%s+$") then
            k = tonumber(k)
        end
        v = v[k]
        if not v then
            return "nil"
        end
    end
    return _ToString(v, printLevel)
end

function CoGetActiveUpValuesText(co)
    local values = CoGetActiveUpValues(co)
    return _getValuesText(values)
end

function CoGetActiveLocalValuesText(co, stackLevel)
    local values = CoGetActiveLocalValues(co, stackLevel)
    return _getValuesText(values)
end

function CoGetActiveUpValueText(co, name, printLevel)
    local path = string.split(name, ".")
    local firstName = path[1]
    if firstName then
        local values = CoGetActiveUpValues(co)
        local value = values[firstName]
        if value then
            return _getValueText(value, path, printLevel)
        end
    end
    return "nil"
end

function CoGetActiveLocalValueText(co, stackLevel, name, printLevel)
    local path = string.split(name, ".")
    local firstName = path[1]
    if firstName then
        local values = CoGetActiveLocalValues(co, stackLevel)
        local value = values[firstName]
        if value then
            return _getValueText(value, path, printLevel)
        end
    end
    return "nil"
end

local infoList = {}

function CoGetActiveInfos()
    local function getInfoName(co, f, id)
        local name = coNames[co] or ("[" .. id .. "]")
        local info = getinfo(f, "S")
        if info and info.short_src and info.linedefined then
            name = name .. " <" .. info.short_src .. ":" .. info.linedefined .. ">"
        end
        return name
    end
    local infoMap, idMap = {}, {}
    for _, info in ipairs(infoList) do
        infoMap[info.id] = info
    end
    for co, f in pairs(activeCoFuncs) do
        local id = CoGetId(co)
        idMap[id] = co
        local info = infoMap[id]
        if not info then
            insert(infoList, {id = id, name = getInfoName(co, f, id)})
        end
    end
    array.removeall(infoList, function(info) return not idMap[info.id] end)
    return infoList
end

function CoGetTracebackTree(co)
    local ret = {}
    ret.traceback = traceback(co)
    for k, v in pairs(parents) do
        if v == co then
            if not ret.children then
                ret.children = {}
            end
            insert(ret.children, CoGetTracebackTree(k))
        end
    end
    return ret
end


---------------------------------------------------------------------------------
--region await func
local CoRegisterTerminator = CoRegisterTerminator

function AwaitOne(...)
    local n = select("#", ...)

    if n == 0 then
        return 0
    end

    local t = {}
    local tick = ticktime

    local parent = running()
    local co
    for i = 1, n do
        co = create(select(i, ...))
        t[i] = co
        parents[co] = parent
    end
    local terminate = CoRegisterTerminator(function() _coTerminateAll(t) end)
    while true do
        for i = 1, n do
            local s, v = resume(t[i], tick)

            if not s then
                terminate()
                v = traceback(t[i], v)
                error(v)
            end

            if status(t[i]) == "dead" then
                terminate()
                return i, v
            end
        end

        tick = yield()
    end
end


function AwaitAll(...)
    local n = select("#", ...)

    if n == 0 then
        return nil
    end

    local t = {}
    local result = {}
    local m = 0
    local tick = ticktime

    local parent = running()
    local co
    for i = 1, n do
        co = create(select(i, ...))
        t[i] = co
        parents[co] = parent
    end
    local terminate = CoRegisterTerminator(function() _coTerminateAll(t) end)
    while true do
        for i = 1, n do
            if status(t[i]) ~= "dead" then
                local s, v = resume(t[i], tick)
                if not s then
                    terminate()
                    v = traceback(t[i], v)
                    error(v)
                end
                if status(t[i]) == "dead" then
                    m = m + 1
                    result[i] = v
                    _coTerminate(t[i])

                    if m == n then
                        return unpack(result)
                    end
                end
            end
        end

        tick = yield()
    end
end


function AwaitFirst(f, ...)
    local n = select("#", ...)

    if n == 0 then
        return f()
    end
    local parent = running()
    local first = create(f)
    parents[first] = parent
    local t = {}
    local tick = ticktime

    local co
    for i = 1, n do
        co = create(select(i, ...))
        t[i] = co
        parents[co] = parent
    end
    local terminate = CoRegisterTerminator(function()
        _coTerminate(first)
        _coTerminateAll(t)
    end)
    while true do
        local s, v = resume(first, tick)
        if not s then
            terminate()
            v = traceback(first, v)
            error(v)
        end
        if status(first) == "dead" then
            terminate()
            return v
        end

        for i = 1, n do
            if status(t[i]) ~= "dead" then
                local s, v = resume(t[i], tick)

                if not s then
                    terminate()
                    v = traceback(t[i], v)
                    error(v)
                end
                if status(t[i]) == "dead" then
                    _coTerminate(t[i])
                end
            end
        end

        tick = yield()
    end
end

function AwaitPattern(pattern, ...)
    local n = select("#", ...)
    local curpat = rep("0", n)
    local match = find(curpat, pattern) ~= nil

    local t = {}
    local parent = running()
    local co
    for i = 1, n do
        co = create(select(i, ...))
        t[i] = co
        parents[co] = parent
    end

    if match or n == 0 then
        _coTerminateAll(t)
        return {match = match, pattern = ""}
    end

    local terminate = CoRegisterTerminator(function() _coTerminateAll(t) end)
    local result = {match = false}
    local m = 0
    local tick = ticktime
    local pt = {}

    for i = 1, n do
        pt[i] = 48
    end

    while true do
        for i = 1, n do
            if status(t[i]) ~= "dead" then
                local s, v = resume(t[i], tick)

                if not s then
                    terminate()
                    v = traceback(t[i], v)
                    error(v)
                end

                if status(t[i]) == "dead" then
                    m = m + 1
                    result[i] = v
                    pt[i] = 49
                    _coTerminate(t[i])

                    if m == n then
                        terminate()
                        curpat = char(unpack(pt))
                        result.match = find(curpat, pattern) ~= nil
                        result.pattern = curpat
                        return result
                    end
                else
                    pt[i] = 48
                end
            else
                pt[i] = 49
            end

            curpat = char(unpack(pt))
            match = find(curpat, pattern) ~= nil

            if match then
                terminate()
                result.match = match
                result.pattern = curpat
                return result
            end
        end

        tick = yield()
    end
end


function AwaitTrue(f, ...)
    while not f(...) do
        yield()
    end
end


function AwaitFalse(f, ...)
    while f(...) do
        yield()
    end
end


function AwaitTime(t)
    while t > 1e-10 do
        t = t - (yield() or Time.deltaTime)
    end
    return -t
end


function AwaitFrame()
    yield()
end


function AwaitFrames(n)
    n = n or 1
    while n > 1e-10 do
        yield()
        n = n - 1
    end
end


function AwaitRealtime(t)
    local destTime = Time.realtimeSinceStartup + t
    while Time.realtimeSinceStartup < destTime - 1e-10 do
        yield()
    end
    return Time.realtimeSinceStartup - destTime
end

--==============================--
--desc:等待给定字段与给定值相等
--time:2017-08-24 08:34:55
--@tab:table
--@key:字段名
--@value:比较值
--return
--==============================--
function AwaitEqual(tab, key, value)
    local v = tab[key]
    while v ~= value do
        yield()
        v = tab[key]
    end
end

--==============================--
--desc:等待给定字段与给定值不等
--time:2017-08-24 08:35:27
--@tab:table
--@key:字段名
--@value:比较值
--return 字段值
--==============================--
function AwaitNotEqual(tab, key, value)
    local v = tab[key]
    while v == value do
        yield()
        v = tab[key]
    end
    return v
end

--==============================--
--desc:等待给定字段非nil或false
--time:2017-08-24 08:40:10
--@tab:table
--@key:字段名
--return 字段值
--==============================--
function AwaitNotNilOrFalse(tab, key)
    local v = tab[key]
    while not v do
        yield()
        v = tab[key]
    end
    return v
end

--==============================--
--desc:等待协程执行完（协程必须是通过AddCo创建的）
--time:2017-12-22 04:43:08
--@co:协程
--return
--==============================--
function AwaitCo(co)
    if type(co) == "thread" then
        while not CoTerminated(co) do
            yield()
        end
    end
end

--==============================--
--desc:等待Tween动画完成
--time:2017-12-01 02:34:47
--@fromValue:起始值
--@toValue:终止值
--@speed:速度
--@setter:设置函数
--return
--==============================--
function AwaitTween(fromValue, toValue, speed, setter)
    local value = fromValue
    setter(value)
    local delta
    while true do
        delta = yield()
        value = value + delta * speed
        if value * speed < toValue * speed - 1e-10 then
            setter(value)
        else
            setter(toValue)
            break
        end
    end
end

--==============================--
--desc:等待动画播放一次
--time:13:49 2018/6/4
--return
--==============================--
function AwaitAnimationPlayOnce(animation, clipName)
    local state = animation:get_Item(clipName)
    while animation.isPlaying and state and state.NormalizedTime < 0.999 do
        yield()
    end
end

--==============================--
--desc:等待mechenizm动画播放一次
--time:13:49 2018/6/4
--return
--==============================--
function AwaitAnimatorPlayOnce(animator, clipName)
    local state = animator:GetCurrentAnimatorStateInfo(0)
    while state and (not state:IsName(clipName) or state.NormalizedTime < 0.999) do
        yield()
        state = animator:GetCurrentAnimatorStateInfo(0)
    end
end
--endregion
declareGlobal("AwaitOne", AwaitOne)
declareGlobal("AwaitAll", AwaitAll)
declareGlobal("AwaitFirst", AwaitFirst)
declareGlobal("AwaitPattern", AwaitPattern)
declareGlobal("AwaitTrue", AwaitTrue)
declareGlobal("AwaitFalse", AwaitFalse)
declareGlobal("AwaitTime", AwaitTime)
declareGlobal("AwaitFrame", AwaitFrame)
declareGlobal("AwaitFrames", AwaitFrames)
declareGlobal("AwaitRealtime", AwaitRealtime)
declareGlobal("AwaitEqual", AwaitEqual)
declareGlobal("AwaitNotEqual", AwaitNotEqual)
declareGlobal("AwaitNotNilOrFalse", AwaitNotNilOrFalse)
declareGlobal("AwaitCo", AwaitCo)
declareGlobal("AwaitTween", AwaitTween)
declareGlobal("AwaitAnimationPlayOnce", AwaitAnimationPlayOnce)
declareGlobal("AwaitAnimatorPlayOnce", AwaitAnimatorPlayOnce)
---------------------------------------------------------------------------------
