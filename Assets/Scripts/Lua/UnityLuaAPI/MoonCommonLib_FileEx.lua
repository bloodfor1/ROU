---@class MoonCommonLib.FileEx

---@type MoonCommonLib.FileEx
MoonCommonLib.FileEx = { }
---@param text string
---@param path string
function MoonCommonLib.FileEx.SaveText(text, path) end
---@overload fun(encoding:System.Text.Encoding): string
---@return string
---@param filePath string
---@param encoding System.Text.Encoding
function MoonCommonLib.FileEx:ReadText(filePath, encoding) end
---@param texture UnityEngine.Texture2D
---@param path string
---@param destroyAfterSave boolean
---@param withMipmap boolean
function MoonCommonLib.FileEx.SaveTexture(texture, path, destroyAfterSave, withMipmap) end
---@return UnityEngine.Texture2D
---@param width number
---@param height number
---@param path string
---@param format number
---@param mipmap boolean
function MoonCommonLib.FileEx.OpenTexture(width, height, path, format, mipmap) end
---@param texture UnityEngine.Texture2D
function MoonCommonLib.FileEx.SaveTextureToPlatformAlbum(texture) end
---@param path string
function MoonCommonLib.FileEx.OpenFolder(path) end
---@return string
---@param fileName string
function MoonCommonLib.FileEx.GetDirectoryName(fileName) end
---@return string
---@param path string
---@param separator number
function MoonCommonLib.FileEx.GetFileName(path, separator) end
---@return string
---@param fileName string
---@param separator number
function MoonCommonLib.FileEx.GetFileNameWithoutExtention(fileName, separator) end
---@return string
---@param fileName string
function MoonCommonLib.FileEx.GetFilePathWithoutExtention(fileName) end
---@return boolean
---@param file1 string
---@param file2 string
function MoonCommonLib.FileEx.Compare(file1, file2) end
---@param path string
function MoonCommonLib.FileEx.AssureFileExist(path) end
---@param path string
function MoonCommonLib.FileEx.AssureDirectoryExist(path) end
---@return System.IO.FileInfo
---@param currentPath string
---@param fileName string
function MoonCommonLib.FileEx.FindFileInParents(currentPath, fileName) end
---@return boolean
---@param filename string
function MoonCommonLib.FileEx.StreamingAssetExist(filename) end
---@param path string
function MoonCommonLib.FileEx.MakeFileDirectoryExist(path) end
---@param path string
function MoonCommonLib.FileEx.DeleteFileSafely(path) end
return MoonCommonLib.FileEx
