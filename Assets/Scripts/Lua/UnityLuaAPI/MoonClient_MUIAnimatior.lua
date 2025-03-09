---@class MoonClient.MUIAnimatior : UnityEngine.MonoBehaviour
---@field public Animator UnityEngine.Animator

---@type MoonClient.MUIAnimatior
MoonClient.MUIAnimatior = { }
---@return MoonClient.MUIAnimatior
function MoonClient.MUIAnimatior.New() end
---@param stateName string
---@param completeCallBack (fun():void)
function MoonClient.MUIAnimatior:Play(stateName, completeCallBack) end
---@return boolean
---@param stateName string
function MoonClient.MUIAnimatior:IsPlaying(stateName) end
return MoonClient.MUIAnimatior
