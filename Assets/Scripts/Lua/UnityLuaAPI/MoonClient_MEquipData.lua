---@class MoonClient.MEquipData
---@field public _iconFrameId number
---@field public UseTemp boolean
---@field public IsNaked boolean
---@field public BodyModelTemp string
---@field public WeaponModelTemp string
---@field public EOrnamentHeadTemp string
---@field public EOrnamentFaceTemp string
---@field public EOrnamentMouthTemp string
---@field public EOrnamentBackTemp string
---@field public EOrnamentTailTemp string
---@field public WeaponModelExTemp string
---@field public EyeColorIDTmp number
---@field public HairIDTmp number
---@field public HairModelTmp string
---@field public HairStyleIDTmp number
---@field public HeadEditor string
---@field public IsHikaruEditor boolean
---@field public HairEditor string
---@field public HairSpec System.Collections.Generic.HashSet_System.String
---@field public DefaultEquip MoonClient.DefaultEquipTable.RowData
---@field public IsMale boolean
---@field public ProfessionID number
---@field public EyeID number
---@field public EyeColorID number
---@field public EyeModel number
---@field public EyeColor string
---@field public HairID number
---@field public HairStyleID number
---@field public BuffHairStyleID number
---@field public HairSpecTex string
---@field public HairTex string
---@field public HairModel string
---@field public HairColor string
---@field public HeadID number
---@field public IconFrameID number
---@field public OrnamentHeadItemID number
---@field public OrnamentHeadFromBagItemID number
---@field public HeadModel string
---@field public HeadTex string
---@field public EmojiTex string
---@field public OrnamentFaceItemID number
---@field public OrnamentMouthItemID number
---@field public OrnamentBackItemID number
---@field public OrnamentTailItemID number
---@field public OrnamentFaceFromBagItemID number
---@field public OrnamentMouthFromBagItemID number
---@field public OrnamentBackFromBagItemID number
---@field public OrnamentTailFromBagItemID number
---@field public RealOrnHeadID number
---@field public RealOrnFaceID number
---@field public RealOrnMouthID number
---@field public RealOrnBackID number
---@field public RealOrnTailID number
---@field public OrnHeadModel string
---@field public OrnFaceModel string
---@field public OrnMouthModel string
---@field public OrnBackModel string
---@field public OrnTailModel string
---@field public WeaponItemIDFromBag number
---@field public WeaponExItemIDFromBag number
---@field public WeaponModel string
---@field public WeaponExModel string
---@field public WeaponNeedEx boolean
---@field public FashionFromBagItemID number
---@field public FashionItemID number
---@field public RealFashionItemID number
---@field public BodyModel string
---@field public BodyModel_S string
---@field public IsHikaru boolean
---@field public BeiluziEffectId number
---@field public BeiLuZiEffect string

---@type MoonClient.MEquipData
MoonClient.MEquipData = { }
---@return MoonClient.MEquipData
function MoonClient.MEquipData.New() end
---@param state boolean
function MoonClient.MEquipData:SetUseTempMode(state) end
---@return MoonClient.MEquipData
function MoonClient.MEquipData.CreateEquipData() end
---@param equipData MoonClient.MEquipData
function MoonClient.MEquipData.ReleaseEquipData(equipData) end
---@param equipData MoonClient.MEquipData
function MoonClient.MEquipData.RemoveOrnament(equipData) end
---@param equipData MoonClient.MEquipData
---@param attrEquipData MoonClient.MEquipData
---@param withFashionID boolean
---@param withWeaponModel boolean
function MoonClient.MEquipData.TransmissionProcess(equipData, attrEquipData, withFashionID, withWeaponModel) end
---@param data MoonClient.MEquipData
function MoonClient.MEquipData:Copy(data) end
function MoonClient.MEquipData:Reset() end
---@return MoonClient.MEquipData
function MoonClient.MEquipData:Clone() end
function MoonClient.MEquipData:Get() end
function MoonClient.MEquipData:Release() end
function MoonClient.MEquipData:Destory() end
return MoonClient.MEquipData
