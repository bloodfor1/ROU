---@class MoonClient.MAudioMgr : MoonCommonLib.MSingleton_MoonClient.MAudioMgr
---@field public RunTimeManager MoonCommonLib.IMFModRunTimeManager
---@field public IsPaused boolean
---@field public IsMuted boolean

---@type MoonClient.MAudioMgr
MoonClient.MAudioMgr = { }
---@return MoonClient.MAudioMgr
function MoonClient.MAudioMgr.New() end
---@return boolean
function MoonClient.MAudioMgr:Init() end
function MoonClient.MAudioMgr:Uninit() end
---@overload fun(path:string): void
---@param id number
function MoonClient.MAudioMgr:Play(id) end
---@overload fun(path:string, position:UnityEngine.Vector3): void
---@param id number
---@param position UnityEngine.Vector3
function MoonClient.MAudioMgr:Play3D(id, position) end
---@return MoonCommonLib.IMFModEventInstance
---@param cvId number
function MoonClient.MAudioMgr:PlayCV(cvId) end
function MoonClient.MAudioMgr:StopCV() end
---@return MoonCommonLib.IMFModEventInstance
---@param path string
function MoonClient.MAudioMgr:PlayBGM(path) end
---@param pause boolean
function MoonClient.MAudioMgr:SetPauseBGM(pause) end
function MoonClient.MAudioMgr:StopBGM() end
---@return MoonCommonLib.IMFModEventInstance
function MoonClient.MAudioMgr:GetBGMInstance() end
---@return MoonCommonLib.IMFModEventInstance
---@param path string
---@param period number
function MoonClient.MAudioMgr:PlayEnvironment(path, period) end
function MoonClient.MAudioMgr:StopEnvironment() end
---@param volume number
function MoonClient.MAudioMgr:SetBGMVolume(volume) end
---@param volume System.Single
---@param finalVolume System.Single
function MoonClient.MAudioMgr:GetBGMVolume(volume, finalVolume) end
---@param volume number
function MoonClient.MAudioMgr:SetSEVolume(volume) end
---@param volume System.Single
---@param finalVolume System.Single
function MoonClient.MAudioMgr:GetSEVolume(volume, finalVolume) end
---@param volume number
function MoonClient.MAudioMgr:SetMasterVolume(volume) end
---@param volume System.Single
---@param finalVolume System.Single
function MoonClient.MAudioMgr:GetMasterVolume(volume, finalVolume) end
---@param bankName string
function MoonClient.MAudioMgr:LoadBank(bankName) end
---@param bankName string
function MoonClient.MAudioMgr:UnloadBank(bankName) end
function MoonClient.MAudioMgr:ReloadAll() end
---@return MoonCommonLib.IMFModEventInstance
---@param path string
---@param result MoonCommonLib.IMFModEventInstance
---@param args MoonClient.AudioParam[]
function MoonClient.MAudioMgr:PlayAudio(path, result, args) end
---@overload fun(tableID:number): MoonCommonLib.IMFModEventInstance
---@return MoonCommonLib.IMFModEventInstance
---@param path string
function MoonClient.MAudioMgr:GetEventInstance(path) end
---@overload fun(path:string): MoonCommonLib.IMFModEventInstance
---@overload fun(tableID:number): MoonCommonLib.IMFModEventInstance
---@overload fun(path:string, pos:UnityEngine.Vector3): MoonCommonLib.IMFModEventInstance
---@return MoonCommonLib.IMFModEventInstance
---@param tableID number
---@param pos UnityEngine.Vector3
function MoonClient.MAudioMgr:StartFModInstance(tableID, pos) end
---@param eventInstance MoonCommonLib.IMFModEventInstance
function MoonClient.MAudioMgr:StopFModInstance(eventInstance) end
return MoonClient.MAudioMgr
