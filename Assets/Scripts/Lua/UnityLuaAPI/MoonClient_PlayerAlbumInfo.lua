---@class MoonClient.PlayerAlbumInfo

---@type MoonClient.PlayerAlbumInfo
MoonClient.PlayerAlbumInfo = { }
---@return MoonClient.PlayerAlbumInfo
function MoonClient.PlayerAlbumInfo.New() end
---@param path string
---@param message string
function MoonClient.PlayerAlbumInfo:SetPhotoMessage(path, message) end
---@return string
---@param path string
function MoonClient.PlayerAlbumInfo:GetPhotoMessage(path) end
---@param path string
function MoonClient.PlayerAlbumInfo:RemovePhotoMessage(path) end
---@return string
---@param path string
function MoonClient.PlayerAlbumInfo:GetPhotoDateInfo(path) end
---@return string
---@param path string
function MoonClient.PlayerAlbumInfo:GetPhotoPlaceInfo(path) end
return MoonClient.PlayerAlbumInfo
