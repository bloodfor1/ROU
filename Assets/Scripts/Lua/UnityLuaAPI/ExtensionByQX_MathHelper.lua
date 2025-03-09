---@class ExtensionByQX.MathHelper

---@type ExtensionByQX.MathHelper
ExtensionByQX.MathHelper = { }
---@return boolean
---@param number number
function ExtensionByQX.MathHelper.IsEven(number) end
---@return number
---@param n number
function ExtensionByQX.MathHelper.PowByTwo(n) end
---@overload fun(container:number, containee:number): boolean
---@overload fun(container:int64, containee:int64): boolean
---@return boolean
---@param container int64
---@param containee number
function ExtensionByQX.MathHelper.IsLogicContainBit(container, containee) end
---@overload fun(container:number, index:number): boolean
---@return boolean
---@param container int64
---@param index number
function ExtensionByQX.MathHelper.IsLogicContainBitWithIndex(container, index) end
---@return number
function ExtensionByQX.MathHelper.RandomValueExclusive() end
---@param min_select number
---@param max_select number
---@param weights System.Collections.Generic.List_System.Int32
---@param result System.Collections.Generic.List_System.Int32
function ExtensionByQX.MathHelper.RandomSelect(min_select, max_select, weights, result) end
---@return boolean
---@param num number
---@param idx number
function ExtensionByQX.MathHelper.BitIsOne(num, idx) end
---@return number
---@param percent System.Collections.Generic.IList_System.Single
function ExtensionByQX.MathHelper.RandomGetIndexInPercent(percent) end
---@overload fun(valueA:number, valueB:number, distanceValue:number): boolean
---@return boolean
---@param valueA UnityEngine.Vector2
---@param valueB UnityEngine.Vector2
---@param distanceValue number
function ExtensionByQX.MathHelper.IsApproximately(valueA, valueB, distanceValue) end
return ExtensionByQX.MathHelper
