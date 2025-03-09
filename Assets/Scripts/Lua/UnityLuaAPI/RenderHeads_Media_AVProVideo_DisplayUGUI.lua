---@class RenderHeads.Media.AVProVideo.DisplayUGUI : UnityEngine.UI.MaskableGraphic
---@field public _mediaPlayer RenderHeads.Media.AVProVideo.MediaPlayer
---@field public m_UVRect UnityEngine.Rect
---@field public _setNativeSize boolean
---@field public _scaleMode number
---@field public _noDefaultDisplay boolean
---@field public _displayInEditor boolean
---@field public _defaultTexture UnityEngine.Texture
---@field public mainTexture UnityEngine.Texture
---@field public CurrentMediaPlayer RenderHeads.Media.AVProVideo.MediaPlayer
---@field public uvRect UnityEngine.Rect

---@type RenderHeads.Media.AVProVideo.DisplayUGUI
RenderHeads.Media.AVProVideo.DisplayUGUI = { }
---@return RenderHeads.Media.AVProVideo.DisplayUGUI
function RenderHeads.Media.AVProVideo.DisplayUGUI.New() end
---@return boolean
function RenderHeads.Media.AVProVideo.DisplayUGUI:HasValidTexture() end
function RenderHeads.Media.AVProVideo.DisplayUGUI:SetNativeSize() end
return RenderHeads.Media.AVProVideo.DisplayUGUI
