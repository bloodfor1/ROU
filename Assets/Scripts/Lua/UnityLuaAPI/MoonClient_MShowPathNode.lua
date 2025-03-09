---@class MoonClient.MShowPathNode : UnityEngine.MonoBehaviour
---@field public PathType number
---@field public Origin UnityEngine.Transform
---@field public Destination UnityEngine.Transform
---@field public OriginPosition UnityEngine.Vector3
---@field public DestinationPostion UnityEngine.Vector3
---@field public PathNode UnityEngine.Transform
---@field public DistanceWithOrigin number
---@field public DistanceWithDestination number
---@field public Interval number
---@field public IsPlayOnEnable boolean

---@type MoonClient.MShowPathNode
MoonClient.MShowPathNode = { }
---@return MoonClient.MShowPathNode
function MoonClient.MShowPathNode.New() end
function MoonClient.MShowPathNode:ShowPath() end
return MoonClient.MShowPathNode
