---@class MChangeEmotionMono : UnityEngine.MonoBehaviour

---@type MChangeEmotionMono
MChangeEmotionMono = { }
---@return MChangeEmotionMono
function MChangeEmotionMono.New() end
---@param model MoonClient.MModel
function MChangeEmotionMono:SetModel(model) end
---@param id number
function MChangeEmotionMono:SetEye(id) end
---@param id number
function MChangeEmotionMono:SetMouth(id) end
function MChangeEmotionMono:Resume() end
return MChangeEmotionMono
