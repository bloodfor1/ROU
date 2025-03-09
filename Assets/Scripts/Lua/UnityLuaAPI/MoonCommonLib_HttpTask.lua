---@class MoonCommonLib.HttpTask
---@field public CurrentType number
---@field public Url string
---@field public Finished boolean
---@field public Running boolean
---@field public Canceled boolean
---@field public NowSize int64
---@field public HttpRes number

---@type MoonCommonLib.HttpTask
MoonCommonLib.HttpTask = { }
---@return MoonCommonLib.HttpTask
---@param url string
function MoonCommonLib.HttpTask.Create(url) end
---@return MoonCommonLib.HttpTask
---@param timeout number
function MoonCommonLib.HttpTask:TimeOut(timeout) end
---@return MoonCommonLib.HttpTask
---@param callback (fun():void)
function MoonCommonLib.HttpTask:SetCallback(callback) end
---@return MoonCommonLib.HttpTask
---@param post System.Byte[]
function MoonCommonLib.HttpTask:Post(post) end
---@return MoonCommonLib.HttpTask
---@param key string
---@param value string
function MoonCommonLib.HttpTask:AddHeader(key, value) end
---@return number
---@param savePath string
---@param succ System.Boolean
---@param continueDownload boolean
---@param hash string
function MoonCommonLib.HttpTask:Download(savePath, succ, continueDownload, hash) end
---@return number
---@param result System.String
function MoonCommonLib.HttpTask:GetResponse(result) end
---@return System.Collections.IEnumerator
---@param callback (fun(arg1:number, arg2:string):void)
function MoonCommonLib.HttpTask:GetResponseAynsc(callback) end
---@return System.Collections.IEnumerator
---@param callback (fun(arg1:number, arg2:string):void)
function MoonCommonLib.HttpTask:GetResponseByCoroutine(callback) end
function MoonCommonLib.HttpTask:Cancel() end
return MoonCommonLib.HttpTask
