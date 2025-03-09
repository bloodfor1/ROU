---@class MoonClient.MAnimationMgr : MoonCommonLib.MSingleton_MoonClient.MAnimationMgr

---@type MoonClient.MAnimationMgr
MoonClient.MAnimationMgr = { }
---@return MoonClient.MAnimationMgr
function MoonClient.MAnimationMgr.New() end
---@return boolean
function MoonClient.MAnimationMgr:Init() end
function MoonClient.MAnimationMgr:Uninit() end
---@return MoonClient.MAnimationMgr.ClipInfo
---@param location string
function MoonClient.MAnimationMgr:GetClipInfo(location) end
---@overload fun(): MoonClient.MAnimationMgr.OriginData
---@return MoonClient.MAnimationMgr.OriginData
---@param attr MoonClient.MAttrComponent
function MoonClient.MAnimationMgr:GetDataFromPool(attr) end
---@param data MoonClient.MAnimationMgr.OriginData
function MoonClient.MAnimationMgr:ReturnDataToPool(data) end
---@return boolean
---@param clipName string
function MoonClient.MAnimationMgr:HaveClip(clipName) end
---@overload fun(clipName:string): string
---@overload fun(id:number, attr:MoonClient.MAttrComponent): string
---@return string
---@param id number
---@param data MoonClient.MAnimationMgr.OriginData
function MoonClient.MAnimationMgr:GetClipPath(id, data) end
---@overload fun(id:number, attr:MoonClient.MAttrComponent): string
---@return string
---@param id number
---@param data MoonClient.MAnimationMgr.OriginData
function MoonClient.MAnimationMgr:GetClipName(id, data) end
function MoonClient.MAnimationMgr:Preload() end
return MoonClient.MAnimationMgr
