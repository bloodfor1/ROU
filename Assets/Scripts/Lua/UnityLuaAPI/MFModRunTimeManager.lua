---@class MFModRunTimeManager : UnityEngine.MonoBehaviour
---@field public Deprecated boolean

---@type MFModRunTimeManager
MFModRunTimeManager = { }
---@return MFModRunTimeManager
function MFModRunTimeManager.New() end
---@param path string
---@param position UnityEngine.Vector3
function MFModRunTimeManager:PlayOneShot(path, position) end
---@param path string
---@param gameObject UnityEngine.GameObject
function MFModRunTimeManager:PlayOneShotAttached(path, gameObject) end
---@return MoonCommonLib.IMFModEventInstance
---@param path string
function MFModRunTimeManager:CreateInstance(path) end
---@return MoonCommonLib.IMFmodEventDescription
---@param path string
function MFModRunTimeManager:GetEventDescription(path) end
---@overload fun(bankName:string, loadSamples:boolean): void
---@param bankName UnityEngine.TextAsset
---@param loadSamples boolean
function MFModRunTimeManager:LoadBank(bankName, loadSamples) end
---@param bankName string
function MFModRunTimeManager:UnloadBank(bankName) end
---@return MoonCommonLib.IMFmodBus
---@param path string
function MFModRunTimeManager:GetBus(path) end
---@return MoonCommonLib.IMFmodVCA
---@param path string
function MFModRunTimeManager:GetVCA(path) end
---@param instance MoonCommonLib.IMFModEventInstance
---@param transform UnityEngine.Transform
---@param rigidBody UnityEngine.Rigidbody
function MFModRunTimeManager:AttachInstanceToGameObject(instance, transform, rigidBody) end
---@param instance MoonCommonLib.IMFModEventInstance
function MFModRunTimeManager:DetachInstanceFromGameObject(instance) end
function MFModRunTimeManager:AnyBankLoading() end
function MFModRunTimeManager:WaitForAllLoads() end
---@param paused boolean
function MFModRunTimeManager:PauseAllEvents(paused) end
---@param muted boolean
function MFModRunTimeManager:MuteAllEvents(muted) end
---@param gameObject UnityEngine.GameObject
function MFModRunTimeManager:AddListener(gameObject) end
---@return System.Guid
---@param path string
function MFModRunTimeManager:PathToGUID(path) end
---@return boolean
---@param path string
function MFModRunTimeManager:EventExist(path) end
function MFModRunTimeManager:Init() end
return MFModRunTimeManager
