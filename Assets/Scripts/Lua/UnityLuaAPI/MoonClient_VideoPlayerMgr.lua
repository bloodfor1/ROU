---@class MoonClient.VideoPlayerMgr : MoonCommonLib.MonoSingleton_MoonClient.VideoPlayerMgr

---@type MoonClient.VideoPlayerMgr
MoonClient.VideoPlayerMgr = { }
---@return MoonClient.VideoPlayerMgr
function MoonClient.VideoPlayerMgr.New() end
---@return boolean
function MoonClient.VideoPlayerMgr:Init() end
function MoonClient.VideoPlayerMgr:Uninit() end
---@param isLooping boolean
function MoonClient.VideoPlayerMgr:SetLooping(isLooping) end
---@return boolean
function MoonClient.VideoPlayerMgr:IsLooping() end
---@return boolean
---@param url string
---@param autoPlay boolean
---@param onPrepare (fun():void)
---@param onPlay (fun():void)
---@param onEnd (fun():void)
---@param onError (fun():void)
---@param location number
function MoonClient.VideoPlayerMgr:PrepareByUrl(url, autoPlay, onPrepare, onPlay, onEnd, onError, location) end
---@return boolean
---@param location string
---@param autoPlay boolean
---@param onPrepare (fun():void)
---@param onPlay (fun():void)
---@param onEnd (fun():void)
---@param onError (fun():void)
---@param fileLocation number
function MoonClient.VideoPlayerMgr:Prepare(location, autoPlay, onPrepare, onPlay, onEnd, onError, fileLocation) end
function MoonClient.VideoPlayerMgr:Play() end
function MoonClient.VideoPlayerMgr:Pause() end
function MoonClient.VideoPlayerMgr:Resume() end
---@param pause boolean
function MoonClient.VideoPlayerMgr:Rewind(pause) end
function MoonClient.VideoPlayerMgr:Stop() end
---@return boolean
function MoonClient.VideoPlayerMgr:CanPlay() end
---@return boolean
function MoonClient.VideoPlayerMgr:IsPlaying() end
---@return boolean
function MoonClient.VideoPlayerMgr:IsSeeking() end
---@return boolean
function MoonClient.VideoPlayerMgr:IsPaused() end
---@return boolean
function MoonClient.VideoPlayerMgr:IsFinished() end
---@return boolean
function MoonClient.VideoPlayerMgr:IsBuffering() end
---@return number
function MoonClient.VideoPlayerMgr:GetCurrentTimeMs() end
---@return number
function MoonClient.VideoPlayerMgr:GetCurrentDateTimeSecondsSince1970() end
---@param timeMs number
function MoonClient.VideoPlayerMgr:Seek(timeMs) end
---@param timeMs number
function MoonClient.VideoPlayerMgr:SeekFast(timeMs) end
---@param timeMs number
---@param beforeMs number
---@param afterMs number
function MoonClient.VideoPlayerMgr:SeekWithTolerance(timeMs, beforeMs, afterMs) end
---@return number
function MoonClient.VideoPlayerMgr:GetPlaybackRate() end
---@param rate number
function MoonClient.VideoPlayerMgr:SetPlaybackRate(rate) end
---@param bMute boolean
function MoonClient.VideoPlayerMgr:MuteAudio(bMute) end
---@return boolean
function MoonClient.VideoPlayerMgr:IsMuted() end
---@param volume number
function MoonClient.VideoPlayerMgr:SetVolume(volume) end
---@param balance number
function MoonClient.VideoPlayerMgr:SetBalance(balance) end
---@return number
function MoonClient.VideoPlayerMgr:GetVolume() end
---@return number
function MoonClient.VideoPlayerMgr:GetBalance() end
---@param open boolean
function MoonClient.VideoPlayerMgr:DebugOverlay(open) end
---@param target UnityEngine.Texture2D
---@param callback (fun(extractedFrame:UnityEngine.Texture2D):void)
---@param timeSeconds number
---@param accurateSeek boolean
---@param timeoutMs number
---@param timeThresholdMs number
function MoonClient.VideoPlayerMgr:ExtractFrameAsync(target, callback, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs) end
---@return UnityEngine.Texture2D
---@param target UnityEngine.Texture2D
---@param timeSeconds number
---@param accurateSeek boolean
---@param timeoutMs number
---@param timeThresholdMs number
function MoonClient.VideoPlayerMgr:ExtractFrame(target, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs) end
---@return boolean
---@param go UnityEngine.GameObject
---@param bind boolean
function MoonClient.VideoPlayerMgr:BindMediaPlayer(go, bind) end
function MoonClient.VideoPlayerMgr.Release() end
---@return boolean
---@param location string
function MoonClient.VideoPlayerMgr.IsMovieExist(location) end
---@return string
---@param location string
---@param fileLocation MoonCommonLib.EFileLocation
function MoonClient.VideoPlayerMgr.GetVideoUrl(location, fileLocation) end
return MoonClient.VideoPlayerMgr
