---@class MoonClient.MPay

---@type MoonClient.MPay
MoonClient.MPay = { }
---@param jsondata string
function MoonClient.MPay.PayInit(jsondata) end
---@param jsondata string
function MoonClient.MPay.PayGame(jsondata) end
---@param jsondata string
function MoonClient.MPay.PayGoods(jsondata) end
---@param jsondata string
function MoonClient.MPay.GetRewardInfo(jsondata) end
---@param jsondata string
function MoonClient.MPay.Purchase(jsondata) end
function MoonClient.MPay.ReVerifyPurchase() end
function MoonClient.MPay.ReConnect() end
---@return string
function MoonClient.MPay.GetDeviceId() end
return MoonClient.MPay
