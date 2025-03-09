---@class MoonClient.MAnimator
---@field public STATE_EMPTY string
---@field public STATE_IDLE string
---@field public STATE_FIDLE string
---@field public STATE_CARRY_IDLE string
---@field public STATE_SELFY_IDLE string
---@field public STATE_SHOOT_IDLE string
---@field public STATE_MOVE string
---@field public STATE_FMOVE string
---@field public STATE_CARRY_MOVE string
---@field public STATE_SELFY_MOVE string
---@field public STATE_BORN string
---@field public STATE_DEAD string
---@field public STATE_STUN string
---@field public STATE_BEHIT string
---@field public STATE_SINGING string
---@field public STATE_SKILL string
---@field public STATE_SPECIAL string
---@field public STATE_START_CLIMB_UP string
---@field public STATE_START_CLIMB_DOWN string
---@field public STATE_CLIMB_IDLE string
---@field public STATE_CLIMBING string
---@field public STATE_END_CLIMB_UP string
---@field public STATE_END_CLIMB_DOWN string
---@field public STATE_FISHING_WAIT_IDLE string
---@field public STATE_FISHING_IDLE string
---@field public STATE_FISHING_START string
---@field public STATE_FISHING_UP_ROD string
---@field public STATE_FISHING_UPPING_ROD string
---@field public STATE_FISHING_BIG_UP_ROD string
---@field public STATE_FISHING_AUTO string
---@field public STATE_TEMP_ANIM string
---@field public Host MoonClient.MGameObject
---@field public IsLoaded boolean
---@field public IsPreloadFinished boolean
---@field public Enabled boolean
---@field public Speed number
---@field public CullingMode number

---@type MoonClient.MAnimator
MoonClient.MAnimator = { }
---@return MoonClient.MAnimator
function MoonClient.MAnimator.New() end
---@return number
---@param name string
function MoonClient.MAnimator:GetInteger(name) end
---@param name string
---@param value number
function MoonClient.MAnimator:SetInteger(name, value) end
---@return number
---@param name string
function MoonClient.MAnimator:GetFloat(name) end
---@param name string
---@param value number
function MoonClient.MAnimator:SetFloat(name, value) end
---@return boolean
---@param name string
function MoonClient.MAnimator:GetBool(name) end
---@param name string
---@param value boolean
function MoonClient.MAnimator:SetBool(name, value) end
---@return boolean
---@param stateName string
function MoonClient.MAnimator:InState(stateName) end
---@overload fun(host:MoonClient.MGameObject, ator:UnityEngine.Animator, ctrlPath:string): void
---@param model MoonClient.MModel
---@param host MoonClient.MGameObject
---@param ator UnityEngine.Animator
---@param ctrlPath string
function MoonClient.MAnimator:Init(model, host, ator, ctrlPath) end
---@param stateName string
---@param normalizedTime number
function MoonClient.MAnimator:Play(stateName, normalizedTime) end
---@param stateName string
---@param fadeTime number
---@param normalizedTime number
function MoonClient.MAnimator:CrossFade(stateName, fadeTime, normalizedTime) end
function MoonClient.MAnimator:PlayCurrent() end
function MoonClient.MAnimator:Reset() end
---@return MoonClient.MAnimator.MAnimInfo
function MoonClient.MAnimator:GetCurrentAnimInfo() end
---@return MoonClient.MAnimator.MAnimInfo
---@param key string
function MoonClient.MAnimator:GetAnimInfo(key) end
---@return MoonClient.MAnimator.MAnimInfo
---@param key string
---@param clipPath string
---@param blendTreeKey string
function MoonClient.MAnimator:OverrideAnim(key, clipPath, blendTreeKey) end
function MoonClient.MAnimator:Get() end
function MoonClient.MAnimator:Release() end
function MoonClient.MAnimator:Destory() end
function MoonClient.MAnimator:Recycle() end
return MoonClient.MAnimator
