---@class RenderHeads.Media.AVProVideo.MediaPlayer : UnityEngine.MonoBehaviour
---@field public m_VideoLocation number
---@field public m_VideoPath string
---@field public m_AutoOpen boolean
---@field public m_AutoStart boolean
---@field public m_Loop boolean
---@field public m_Volume number
---@field public m_Muted boolean
---@field public m_PlaybackRate number
---@field public m_Resample boolean
---@field public m_ResampleMode number
---@field public m_ResampleBufferSize number
---@field public m_StereoPacking number
---@field public m_AlphaPacking number
---@field public m_DisplayDebugStereoColorTint boolean
---@field public m_FilterMode number
---@field public m_WrapMode number
---@field public m_AnisoLevel number
---@field public FrameResampler RenderHeads.Media.AVProVideo.Resampler
---@field public Persistent boolean
---@field public VideoLayoutMapping number
---@field public Info RenderHeads.Media.AVProVideo.IMediaInfo
---@field public Control RenderHeads.Media.AVProVideo.IMediaControl
---@field public Player RenderHeads.Media.AVProVideo.IMediaPlayer
---@field public TextureProducer RenderHeads.Media.AVProVideo.IMediaProducer
---@field public Subtitles RenderHeads.Media.AVProVideo.IMediaSubtitles
---@field public Events RenderHeads.Media.AVProVideo.MediaPlayerEvent
---@field public VideoOpened boolean
---@field public PauseMediaOnAppPause boolean
---@field public PlayMediaOnAppUnpause boolean
---@field public ForceFileFormat number
---@field public AudioHeadTransform UnityEngine.Transform
---@field public AudioFocusEnabled boolean
---@field public AudioFocusOffLevelDB number
---@field public AudioFocusWidthDegrees number
---@field public AudioFocusTransform UnityEngine.Transform
---@field public PlatformOptionsWindows RenderHeads.Media.AVProVideo.MediaPlayer.OptionsWindows
---@field public PlatformOptionsMacOSX RenderHeads.Media.AVProVideo.MediaPlayer.OptionsMacOSX
---@field public PlatformOptionsIOS RenderHeads.Media.AVProVideo.MediaPlayer.OptionsIOS
---@field public PlatformOptionsTVOS RenderHeads.Media.AVProVideo.MediaPlayer.OptionsTVOS
---@field public PlatformOptionsAndroid RenderHeads.Media.AVProVideo.MediaPlayer.OptionsAndroid
---@field public PlatformOptionsWindowsPhone RenderHeads.Media.AVProVideo.MediaPlayer.OptionsWindowsPhone
---@field public PlatformOptionsWindowsUWP RenderHeads.Media.AVProVideo.MediaPlayer.OptionsWindowsUWP
---@field public PlatformOptionsWebGL RenderHeads.Media.AVProVideo.MediaPlayer.OptionsWebGL
---@field public PlatformOptionsPS4 RenderHeads.Media.AVProVideo.MediaPlayer.OptionsPS4
---@field public SubtitlesEnabled boolean
---@field public SubtitlePath string
---@field public SubtitleLocation number

---@type RenderHeads.Media.AVProVideo.MediaPlayer
RenderHeads.Media.AVProVideo.MediaPlayer = { }
---@return RenderHeads.Media.AVProVideo.MediaPlayer
function RenderHeads.Media.AVProVideo.MediaPlayer.New() end
---@overload fun(path:string): boolean
---@return boolean
---@param location number
---@param path string
---@param autoPlay boolean
function RenderHeads.Media.AVProVideo.MediaPlayer:OpenVideoFromFile(location, path, autoPlay) end
---@return boolean
---@param buffer System.Byte[]
---@param autoPlay boolean
function RenderHeads.Media.AVProVideo.MediaPlayer:OpenVideoFromBuffer(buffer, autoPlay) end
---@return boolean
---@param length uint64
---@param autoPlay boolean
function RenderHeads.Media.AVProVideo.MediaPlayer:StartOpenChunkedVideoFromBuffer(length, autoPlay) end
---@return boolean
---@param chunk System.Byte[]
---@param offset uint64
---@param chunkSize uint64
function RenderHeads.Media.AVProVideo.MediaPlayer:AddChunkToVideoBuffer(chunk, offset, chunkSize) end
---@return boolean
function RenderHeads.Media.AVProVideo.MediaPlayer:EndOpenChunkedVideoFromBuffer() end
---@return boolean
---@param fileLocation number
---@param filePath string
function RenderHeads.Media.AVProVideo.MediaPlayer:EnableSubtitles(fileLocation, filePath) end
function RenderHeads.Media.AVProVideo.MediaPlayer:DisableSubtitles() end
function RenderHeads.Media.AVProVideo.MediaPlayer:CloseVideo() end
function RenderHeads.Media.AVProVideo.MediaPlayer:Play() end
function RenderHeads.Media.AVProVideo.MediaPlayer:Pause() end
function RenderHeads.Media.AVProVideo.MediaPlayer:Stop() end
---@param pause boolean
function RenderHeads.Media.AVProVideo.MediaPlayer:Rewind(pause) end
---@return number
function RenderHeads.Media.AVProVideo.MediaPlayer.GetPlatform() end
---@return RenderHeads.Media.AVProVideo.MediaPlayer.PlatformOptions
function RenderHeads.Media.AVProVideo.MediaPlayer:GetCurrentPlatformOptions() end
---@return RenderHeads.Media.AVProVideo.MediaPlayer.PlatformOptions
---@param platform number
function RenderHeads.Media.AVProVideo.MediaPlayer:GetPlatformOptions(platform) end
---@return string
---@param platform number
function RenderHeads.Media.AVProVideo.MediaPlayer.GetPlatformOptionsVariable(platform) end
---@return string
---@param location number
function RenderHeads.Media.AVProVideo.MediaPlayer.GetPath(location) end
---@return string
---@param path string
---@param location number
function RenderHeads.Media.AVProVideo.MediaPlayer.GetFilePath(path, location) end
---@return RenderHeads.Media.AVProVideo.BaseMediaPlayer
function RenderHeads.Media.AVProVideo.MediaPlayer:CreatePlatformMediaPlayer() end
function RenderHeads.Media.AVProVideo.MediaPlayer:SaveFrameToPng() end
---@param target UnityEngine.Texture2D
---@param callback (fun(extractedFrame:UnityEngine.Texture2D):void)
---@param timeSeconds number
---@param accurateSeek boolean
---@param timeoutMs number
---@param timeThresholdMs number
function RenderHeads.Media.AVProVideo.MediaPlayer:ExtractFrameAsync(target, callback, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs) end
---@return UnityEngine.Texture2D
---@param target UnityEngine.Texture2D
---@param timeSeconds number
---@param accurateSeek boolean
---@param timeoutMs number
---@param timeThresholdMs number
function RenderHeads.Media.AVProVideo.MediaPlayer:ExtractFrame(target, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs) end
return RenderHeads.Media.AVProVideo.MediaPlayer
