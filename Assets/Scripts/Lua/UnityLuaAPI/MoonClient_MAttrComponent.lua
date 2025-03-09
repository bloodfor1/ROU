---@class MoonClient.MAttrComponent : MoonClient.MComponent
---@field public ID number
---@field public EntityTableData MoonClient.EntityTable.RowData
---@field public EntityID number
---@field public UID uint64
---@field public Name string
---@field public Prefab string
---@field public DisplayWeight number
---@field public IsDead boolean
---@field public Level number
---@field public IsSelfMgrEntity boolean
---@field public MiniMapIcon number
---@field public FightGroup number
---@field public RunSpeed number
---@field public RealRunSpeed number
---@field public RunAtorSpeed number
---@field public VehicleSpeed number
---@field public BattleVehicleSpeed number
---@field public VehicleOrRunSpeed number
---@field public MaxHP number
---@field public MaxSP number
---@field public HP number
---@field public SP number
---@field public DefType number
---@field public HPPercent number
---@field public SPPercent number
---@field public Species number
---@field public TransfigureID number
---@field public ShapeshiftID number
---@field public PresentDataReal MoonClient.PresentTable.RowData
---@field public PresentDataView MoonClient.PresentTable.RowData
---@field public CommonIdleAnimPath string
---@field public DefaultEquip MoonClient.DefaultEquipTable.RowData
---@field public EquipData MoonClient.MEquipData
---@field public Hiding boolean
---@field public IsCombinedModel boolean
---@field public IsMale boolean
---@field public Freezing boolean
---@field public AttrList System.Collections.Generic.Dictionary_KKSG.AttrType_System.Int32

---@type MoonClient.MAttrComponent
MoonClient.MAttrComponent = { }
---@return MoonClient.MAttrComponent
function MoonClient.MAttrComponent.New() end
function MoonClient.MAttrComponent:Reset() end
function MoonClient.MAttrComponent:OnDetachFromHost() end
---@param hostObj MoonClient.MObject
function MoonClient.MAttrComponent:OnAttachToHost(hostObj) end
---@param dic System.Collections.Generic.IDictionary_KKSG.AttrType_System.Int32
function MoonClient.MAttrComponent:OnStateSync(dic) end
---@return number
---@param t number
function MoonClient.MAttrComponent:GetAttr(t) end
---@param t number
---@param value number
function MoonClient.MAttrComponent:SetAttr(t, value) end
function MoonClient.MAttrComponent:ClearAttr() end
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetWeaponEx(itemId, fromBag) end
---@param effectId number
function MoonClient.MAttrComponent:SetBeiLuZi(effectId) end
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetWeapon(itemId, fromBag) end
---@param headId number
function MoonClient.MAttrComponent:SetHead(headId) end
---@param frame_id number
function MoonClient.MAttrComponent:SetHeadIconFrame(frame_id) end
---@param hairStyleId number
function MoonClient.MAttrComponent:SetHair(hairStyleId) end
---@param eyeId number
function MoonClient.MAttrComponent:SetEye(eyeId) end
---@param eyeColorId number
function MoonClient.MAttrComponent:SetEyeColor(eyeColorId) end
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetFashion(itemId, fromBag) end
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetOrnament(itemId, fromBag) end
---@param t number
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetOrnamentByType(t, itemId, fromBag) end
---@param t number
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrComponent:SetOrnamentByIntType(t, itemId, fromBag) end
---@param hairStyleId number
function MoonClient.MAttrComponent:SetBuffHair(hairStyleId) end
---@param itemId number
---@param equipData MoonClient.MEquipData
---@param model MoonClient.MModel
function MoonClient.MAttrComponent.SetOrnamentFake(itemId, equipData, model) end
return MoonClient.MAttrComponent
