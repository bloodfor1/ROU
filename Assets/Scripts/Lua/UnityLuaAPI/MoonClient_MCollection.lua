---@class MoonClient.MCollection : MoonClient.MEntity
---@field public CHECK_STATE_TIME number
---@field public AttrCollection MoonClient.MAttrCollection
---@field public Data MoonClient.CollectTable.RowData
---@field public CanCollectArea number
---@field public ObjAtor MoonClient.MObjectAnimator

---@type MoonClient.MCollection
MoonClient.MCollection = { }
---@return MoonClient.MCollection
function MoonClient.MCollection.New() end
---@return boolean
function MoonClient.MCollection:CanShowHeadInfo() end
---@return boolean
function MoonClient.MCollection:CanShowFootFucus() end
---@return boolean
function MoonClient.MCollection:CanShowOutline() end
---@return boolean
function MoonClient.MCollection:CanShowAddItem() end
---@return boolean
function MoonClient.MCollection:CanView() end
---@return boolean
---@param needTips boolean
function MoonClient.MCollection:CanCollect(needTips) end
function MoonClient.MCollection:OnCreated() end
function MoonClient.MCollection:OnDestrory() end
function MoonClient.MCollection:Uninit() end
function MoonClient.MCollection:Recycle() end
return MoonClient.MCollection
