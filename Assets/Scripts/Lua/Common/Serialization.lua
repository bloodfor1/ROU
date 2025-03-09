---
--- Created by richardjiang.
--- DateTime: 2018/7/31 21:38
---
---@module Common.Serialization
module("Common.Serialization", package.seeall)
local SetString = UnityEngine.PlayerPrefs.SetString
local GetString = UnityEngine.PlayerPrefs.GetString
local cachedDatas = {}

--==============================--
--desc:序列化table
--time:2017-08-16 05:23:00
--@t:table，必须可序列化（元素不能含有对非匿名table或function的引用）
--return 序列化生成的字符串
--==============================--
function Serialize(t, history)
    if t == nil then
        return ""
    elseif type(t) == "table" then
        local temp = {}
        for k, v in pairs(t) do
            local kstr
            local vstr
            if type(k) == "string" then
                kstr = "['" .. k .. "']"
            else
                kstr = "[" .. tostring(k) .. "]"
            end
            if type(v) == "table" then
                history = history or {}
                if history[v] then
                    error("serialize failed! reference of key " .. tostring(k) .. " is a non-anonymous table.")
                else
                    history[v] = k
                    vstr = Serialize(v, history)
                end
            else
                vstr = Serialize(v, history)
            end
            if vstr then
                temp[#temp + 1] = kstr .. "=" .. vstr
            end
        end
        return "{" .. table.concat(temp, ",") .. "}"
    elseif type(t) == "string" then
        return "'" .. t .. "'"
    else
        return tostring(t)
    end
end

--==============================--
--desc:反序列化table
--time:2017-08-16 05:23:39
--@str:待解析的字符串
--return 反序列化生成的table
--==============================--
function Deserialize(str)
    if str and str ~= "" then
        local f, err = loadstring("return " .. str)
        if not f then
            logError("deserialize failed: " .. err .. "\n" .. debug.traceback())
            return nil
        end
        return f()
    end
end

--==============================--
--desc:按账号保存数据至本地
--time:2017-09-23 05:48:06
--@key:数据的key
--@value:数据
--@charId:账号ID，默认为当前账号ID
--return
--==============================--
function StoreData(key, value, charId)
    if charId then
        key = charId .. ":" .. key
    end
    value = Serialize(value)
    if cachedDatas[key] ~= value then
        cachedDatas[key] = value
        SetString(key, value)
    end
end

--==============================--
--desc:按账号读取本地数据
--time:2017-09-23 05:48:58
--@key:数据的key
--@charId:账号ID，默认为当前账号ID
--return 数据
--==============================--
function LoadData(key, charId)
    if charId then
        key = charId .. ":" .. key
    end
    local cached = cachedDatas[key]
    if not cached then
        cached = GetString(key)
        cachedDatas[key] = cached
    end
    return Deserialize(cached)
end