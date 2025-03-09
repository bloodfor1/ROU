---@class MoonClient.UIMarquee : UnityEngine.MonoBehaviour
---@field public MaskWidth number
---@field public StagnationTime number
---@field public LoopTimes number
---@field public Speed number
---@field public StartFromHead boolean
---@field public goRectTransform UnityEngine.RectTransform
---@field public goLayout UnityEngine.UI.LayoutElement

---@type MoonClient.UIMarquee
MoonClient.UIMarquee = { }
---@return MoonClient.UIMarquee
function MoonClient.UIMarquee.New() end
---@param maskWidth number
---@param stagnationTime number
---@param loopTimes number
---@param speed number
function MoonClient.UIMarquee:SetMarqueeParam(maskWidth, stagnationTime, loopTimes, speed) end
---@param func (fun():void)
function MoonClient.UIMarquee:SetFinish(func) end
---@return System.Collections.IEnumerator
function MoonClient.UIMarquee:StartMarqueeFromHead() end
---@return System.Collections.IEnumerator
function MoonClient.UIMarquee:StartMarquee() end
function MoonClient.UIMarquee:CheckStartMarquee() end
function MoonClient.UIMarquee:ResetMarquee() end
---@param isVisble boolean
function MoonClient.UIMarquee:SetVisible(isVisble) end
return MoonClient.UIMarquee
