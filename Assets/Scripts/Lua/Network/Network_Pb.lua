local pb = require "pb_new"
pb.option "enum_as_value"
pb.option "int64_as_string"
pb.option "use_default_values"

pb.loadfile(PathEx.GetBankPath("PB"))

local closeNewIndexMetaTable = {
    __newindex = function()
        error("you can't use newindex method in protobuf data")
    end,
    __index = function(self, filedName)
        local ret = rawget(self, filedName)
        if not rawget(self, filedName) then
            error("attempt is visit a not exit field:" .. tostring(filedName))
        end
        return ret
    end
}

local sendProtoBufMT = {
    SerializeToString = function(self)
        return pb.encode("KKSG." .. self.___MSG_NAME, self)
    end
}
sendProtoBufMT.__index = sendProtoBufMT

---@return usefirststring
function ParseProtoBufToTable(msgName, datas)
    local pbTb = pb.decode("KKSG." .. msgName, datas)
    setmetatable(pbTb, closeNewIndexMetaTable)
    return pbTb
end

local cache = {}

---@return usefirststring
---@param msgName string
function GetProtoBufSendTable(msgName)
    local result
    if #cache > 0 then
        result = cache[#cache]
        table.remove(cache)
    else
        result = {}
    end
    result = pb.decode("KKSG." .. msgName, "", result)
    result.___MSG_NAME = msgName
    setmetatable(result, sendProtoBufMT)
    return result
end

function RecycleProtoBuf(msgData)
    if not msgData then
        return
    end
    for k,_ in pairs(msgData) do
        msgData[k] = nil
    end
    setmetatable(msgData, nil)
    cache[#cache + 1] = msgData
end