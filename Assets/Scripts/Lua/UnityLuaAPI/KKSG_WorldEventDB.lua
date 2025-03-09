---@class KKSG.WorldEventDB
---@field public WorldeventidFieldNumber number
---@field public EventLevelFieldNumber number
---@field public SceneidFieldNumber number
---@field public XFieldNumber number
---@field public YFieldNumber number
---@field public ZFieldNumber number
---@field public RFieldNumber number
---@field public FatherTaskIdFieldNumber number
---@field public EventtypeFieldNumber number
---@field public EventobjidFieldNumber number
---@field public EndTimeFieldNumber number
---@field public PointIndexFieldNumber number
---@field public Parser Google.Protobuf.MessageParser_KKSG.WorldEventDB
---@field public Descriptor Google.Protobuf.Reflection.MessageDescriptor
---@field public Worldeventid number
---@field public EventLevel number
---@field public Sceneid number
---@field public X number
---@field public Y number
---@field public Z number
---@field public R number
---@field public FatherTaskId number
---@field public Eventtype number
---@field public Eventobjid number
---@field public EndTime uint64
---@field public PointIndex number

---@type KKSG.WorldEventDB
KKSG.WorldEventDB = { }
---@overload fun(): KKSG.WorldEventDB
---@return KKSG.WorldEventDB
---@param other KKSG.WorldEventDB
function KKSG.WorldEventDB.New(other) end
---@return KKSG.WorldEventDB
function KKSG.WorldEventDB:Clone() end
---@overload fun(other:System.Object): boolean
---@return boolean
---@param other KKSG.WorldEventDB
function KKSG.WorldEventDB:Equals(other) end
---@return number
function KKSG.WorldEventDB:GetHashCode() end
---@return string
function KKSG.WorldEventDB:ToString() end
---@param output Google.Protobuf.CodedOutputStream
function KKSG.WorldEventDB:WriteTo(output) end
---@return number
function KKSG.WorldEventDB:CalculateSize() end
---@overload fun(other:KKSG.WorldEventDB): void
---@param input Google.Protobuf.CodedInputStream
function KKSG.WorldEventDB:MergeFrom(input) end
return KKSG.WorldEventDB
