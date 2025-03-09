---@class MoonClient.UICDImgHelper : UnityEngine.MonoBehaviour

---@type MoonClient.UICDImgHelper
MoonClient.UICDImgHelper = { }
---@return MoonClient.UICDImgHelper
function MoonClient.UICDImgHelper.New() end
---@return MoonClient.UICDImgHelper
---@param go UnityEngine.GameObject
function MoonClient.UICDImgHelper.Get(go) end
---@param go UnityEngine.GameObject
function MoonClient.UICDImgHelper.Destroy(go) end
---@param cur number
---@param total number
function MoonClient.UICDImgHelper:SetCD(cur, total) end
return MoonClient.UICDImgHelper
