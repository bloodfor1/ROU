---@class MoonClient.MVoice

---@type MoonClient.MVoice
MoonClient.MVoice = { }
---@return number
---@param jsondata string
function MoonClient.MVoice.SetSpeakerVolume(jsondata) end
---@return number
function MoonClient.MVoice.StartRecording() end
---@return number
function MoonClient.MVoice.StopRecording() end
---@return number
---@param jsondata string
function MoonClient.MVoice.PlayRecordedFile(jsondata) end
---@return number
function MoonClient.MVoice.StopPlayFile() end
---@param uploadFinishCallback (fun():void)
---@param playFinishCallback (fun():void)
function MoonClient.MVoice.RegisterCallBack(uploadFinishCallback, playFinishCallback) end
return MoonClient.MVoice
