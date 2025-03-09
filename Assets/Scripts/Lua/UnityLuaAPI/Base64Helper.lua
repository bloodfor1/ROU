---@class Base64Helper

---@type Base64Helper
Base64Helper = { }
---@overload fun(source:string): string
---@return string
---@param encoding System.Text.Encoding
---@param source string
function Base64Helper.EncodeBase64(encoding, source) end
---@overload fun(source:string): string
---@return string
---@param encoding System.Text.Encoding
---@param source string
function Base64Helper.DecodeBase64(encoding, source) end
return Base64Helper
