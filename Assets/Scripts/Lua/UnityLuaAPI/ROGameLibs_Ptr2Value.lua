---@class ROGameLibs.Ptr2Value

---@type ROGameLibs.Ptr2Value
ROGameLibs.Ptr2Value = { }
---@return UnityEngine.Vector3
function ROGameLibs.Ptr2Value:PtrToUnityVector3() end
---@return ROGameLibs.Vector3
function ROGameLibs.Ptr2Value:ToGameLibVector() end
---@return System.Int32[]
---@param length number
function ROGameLibs.Ptr2Value:PtrToIntArray(length) end
---@return System.Single[]
---@param length number
function ROGameLibs.Ptr2Value:PtrToFloatArray(length) end
---@return System.Byte[]
---@param length number
function ROGameLibs.Ptr2Value:PtrToByteArray(length) end
---@return ROGameLibs.SWIGTYPE_p_void
function ROGameLibs.Ptr2Value:AnyToVoid() end
---@return ROGameLibs.Vector3
function ROGameLibs.Ptr2Value:PtrToVector3() end
---@return ROGameLibs.Vector3
function ROGameLibs.Ptr2Value:Round() end
---@overload fun(): System.Char[]
---@overload fun(): System.Boolean[]
---@overload fun(): System.Int32[]
---@overload fun(): System.UInt32[]
---@overload fun(): System.Single[]
---@overload fun(): System.Double[]
---@overload fun(): System.Int64[]
---@return System.Char[]
function ROGameLibs.Ptr2Value:VectorToArray() end
---@return ROGameLibs.CharVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetCharVector(rowData, nameHash) end
---@return ROGameLibs.CharVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetCharVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.BoolVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetBoolVector(rowData, nameHash) end
---@return ROGameLibs.BoolVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetBoolVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.IntVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetIntVector(rowData, nameHash) end
---@return ROGameLibs.IntVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetIntVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.UIntVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetUIntVector(rowData, nameHash) end
---@return ROGameLibs.UIntVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetUIntVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.FloatVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetFloatVector(rowData, nameHash) end
---@return ROGameLibs.FloatVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetFloatVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.DoubleVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetDoubleVector(rowData, nameHash) end
---@return ROGameLibs.DoubleVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetDoubleVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.LongVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetLongVector(rowData, nameHash) end
---@return ROGameLibs.LongVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetLongVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.StringVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetStringVector(rowData, nameHash) end
---@return ROGameLibs.StringVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetStringVectorFromPool(rowData, nameHash, memOwn) end
---@overload fun(): MoonCommonLib.MSeq_System.Char
---@overload fun(): MoonCommonLib.MSeq_System.Boolean
---@overload fun(): MoonCommonLib.MSeq_System.Int32
---@overload fun(): MoonCommonLib.MSeq_System.UInt32
---@overload fun(): MoonCommonLib.MSeq_System.Single
---@overload fun(): MoonCommonLib.MSeq_System.Double
---@overload fun(): MoonCommonLib.MSeq_System.Int64
---@return MoonCommonLib.MSeq_System.Char
function ROGameLibs.Ptr2Value:SequenceToMSeq() end
---@return ROGameLibs.CharSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetCharSequence(rowData, nameHash) end
---@return ROGameLibs.CharSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetCharSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.BoolSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetBoolSequence(rowData, nameHash) end
---@return ROGameLibs.BoolSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetBoolSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.IntSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetIntSequence(rowData, nameHash) end
---@return ROGameLibs.IntSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetIntSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.UIntSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetUIntSequence(rowData, nameHash) end
---@return ROGameLibs.UIntSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetUIntSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.FloatSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetFloatSequence(rowData, nameHash) end
---@return ROGameLibs.FloatSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetFloatSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.DoubleSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetDoubleSequence(rowData, nameHash) end
---@return ROGameLibs.DoubleSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetDoubleSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.LongSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetLongSequence(rowData, nameHash) end
---@return ROGameLibs.LongSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetLongSequenceFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.StringSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetStringSequence(rowData, nameHash) end
---@return ROGameLibs.StringSequence
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetStringSequenceFromPool(rowData, nameHash, memOwn) end
---@overload fun(): MoonCommonLib.MSeqList_System.Char
---@overload fun(): MoonCommonLib.MSeqList_System.Boolean
---@overload fun(): MoonCommonLib.MSeqList_System.Int32
---@overload fun(): MoonCommonLib.MSeqList_System.UInt32
---@overload fun(): MoonCommonLib.MSeqList_System.Single
---@overload fun(): MoonCommonLib.MSeqList_System.Double
---@overload fun(): MoonCommonLib.MSeqList_System.Int64
---@return MoonCommonLib.MSeqList_System.Char
function ROGameLibs.Ptr2Value:SequenceVectorToMSeqList() end
---@return ROGameLibs.CharSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetCharSequenceVector(rowData, nameHash) end
---@return ROGameLibs.CharSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetCharSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.BoolSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetBoolSequenceVector(rowData, nameHash) end
---@return ROGameLibs.BoolSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetBoolSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.IntSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetIntSequenceVector(rowData, nameHash) end
---@return ROGameLibs.IntSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetIntSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.UIntSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetUIntSequenceVector(rowData, nameHash) end
---@return ROGameLibs.UIntSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetUIntSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.FloatSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetFloatSequenceVector(rowData, nameHash) end
---@return ROGameLibs.FloatSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetFloatSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.DoubleSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetDoubleSequenceVector(rowData, nameHash) end
---@return ROGameLibs.DoubleSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetDoubleSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.LongSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetLongSequenceVector(rowData, nameHash) end
---@return ROGameLibs.LongSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetLongSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.StringSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetStringSequenceVector(rowData, nameHash) end
---@return ROGameLibs.StringSequenceVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetStringSequenceVectorFromPool(rowData, nameHash, memOwn) end
---@overload fun(): System.Char_Array[]
---@overload fun(): System.Boolean_Array[]
---@overload fun(): System.Int32_Array[]
---@overload fun(): System.UInt32_Array[]
---@overload fun(): System.Single_Array[]
---@overload fun(): System.Double_Array[]
---@overload fun(): System.Int64_Array[]
---@return System.Char_Array[]
function ROGameLibs.Ptr2Value:VectorVectorToVectorList() end
---@return ROGameLibs.CharVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetCharVectorVector(rowData, nameHash) end
---@return ROGameLibs.CharVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetCharVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.BoolVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetBoolVectorVector(rowData, nameHash) end
---@return ROGameLibs.BoolVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetBoolVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.IntVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetIntVectorVector(rowData, nameHash) end
---@return ROGameLibs.IntVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetIntVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.UIntVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetUIntVectorVector(rowData, nameHash) end
---@return ROGameLibs.UIntVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetUIntVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.FloatVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetFloatVectorVector(rowData, nameHash) end
---@return ROGameLibs.FloatVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetFloatVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.DoubleVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetDoubleVectorVector(rowData, nameHash) end
---@return ROGameLibs.DoubleVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetDoubleVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.LongVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetLongVectorVector(rowData, nameHash) end
---@return ROGameLibs.LongVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetLongVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.StringVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
function ROGameLibs.Ptr2Value.GetStringVectorVector(rowData, nameHash) end
---@return ROGameLibs.StringVectorVector
---@param rowData ROGameLibs.TableDataRowValue
---@param nameHash number
---@param memOwn boolean
function ROGameLibs.Ptr2Value.GetStringVectorVectorFromPool(rowData, nameHash, memOwn) end
---@return ROGameLibs.RONetEvent
function ROGameLibs.Ptr2Value:PtrToRONetEvent() end
---@return System.Collections.Generic.List_System.UInt64
function ROGameLibs.Ptr2Value:PtrToList() end
return ROGameLibs.Ptr2Value
