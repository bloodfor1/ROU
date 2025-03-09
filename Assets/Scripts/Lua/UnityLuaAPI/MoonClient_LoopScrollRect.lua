---@class MoonClient.LoopScrollRect : UnityEngine.EventSystems.UIBehaviour
---@field public IsHorizontal boolean
---@field public reverseDirection boolean
---@field public rubberScale number
---@field public cellStartIndex number
---@field public cellEndIndex number
---@field public OnEndDragCallback (fun(arg1:MoonClient.LoopScrollRect, arg2:UnityEngine.EventSystems.PointerEventData):void)
---@field public OnBeginDragCallback (fun(arg1:MoonClient.LoopScrollRect, arg2:UnityEngine.EventSystems.PointerEventData):void)
---@field public OnDragCallback (fun(obj:MoonClient.LoopScrollRect):void)
---@field public totalCount number
---@field public viewport UnityEngine.RectTransform
---@field public content UnityEngine.RectTransform
---@field public elasticity number
---@field public inertia boolean
---@field public decelerationRate number
---@field public scrollSensitivity number
---@field public m_Dragging boolean
---@field public Moveing boolean
---@field public Scrollbar UnityEngine.UI.Scrollbar
---@field public ScrollbarVisibility number
---@field public minWidth number
---@field public preferredWidth number
---@field public flexibleWidth number
---@field public minHeight number
---@field public preferredHeight number
---@field public flexibleHeight number
---@field public layoutPriority number

---@type MoonClient.LoopScrollRect
MoonClient.LoopScrollRect = { }
---@return number
function MoonClient.LoopScrollRect:GetScrollSize() end
---@return number
function MoonClient.LoopScrollRect:GetContentSize() end
---@return number
function MoonClient.LoopScrollRect:GetContentAnchoredPosition() end
---@return UnityEngine.Transform
function MoonClient.LoopScrollRect.GetCacheParent() end
---@overload fun(_getCellGameObject:(fun(arg:number):UnityEngine.GameObject), _destroyMethod:(fun(obj:UnityEngine.GameObject):void), _onCellShow:(fun(arg1:UnityEngine.Transform, arg2:number):void)): void
---@param _totalCount number
---@param _getCellGameObject (fun(arg:number):UnityEngine.GameObject)
---@param _destroyMethod (fun(obj:UnityEngine.GameObject):void)
---@param _onCellShow (fun(arg1:UnityEngine.Transform, arg2:number):void)
function MoonClient.LoopScrollRect:Initialize(_totalCount, _getCellGameObject, _destroyMethod, _onCellShow) end
function MoonClient.LoopScrollRect:Uninit() end
function MoonClient.LoopScrollRect:Release() end
---@return number
function MoonClient.LoopScrollRect:GetContentConstraintCount() end
---@return number
---@param totalCount number
---@param startIndex number
---@param isAdaptionPosition boolean
---@param isToStartPosition boolean
function MoonClient.LoopScrollRect:ShowCells(totalCount, startIndex, isAdaptionPosition, isToStartPosition) end
---@return number
---@param isToStartPosition boolean
function MoonClient.LoopScrollRect:RefillCellsWithExistingCellStartIndex(isToStartPosition) end
---@return number
---@param startIndex number
---@param isToStartPosition boolean
function MoonClient.LoopScrollRect:RefillCells(startIndex, isToStartPosition) end
---@param index number
function MoonClient.LoopScrollRect:SetCellWithRightPosition(index) end
function MoonClient.LoopScrollRect:MoveToShowStart() end
function MoonClient.LoopScrollRect:MoveToDown() end
---@param offset number
function MoonClient.LoopScrollRect:RefillCellsFromEnd(offset) end
function MoonClient.LoopScrollRect:RefreshCells() end
---@param dataIndex number
function MoonClient.LoopScrollRect:RefreshCell(dataIndex) end
---@param cellIndex number
function MoonClient.LoopScrollRect:RefreshScrollCellWithCellIndex(cellIndex) end
function MoonClient.LoopScrollRect:ClearActiveCells() end
function MoonClient.LoopScrollRect:ResetScroll() end
---@return UnityEngine.Transform
---@param dataIndex number
function MoonClient.LoopScrollRect:GetCellByIdx(dataIndex) end
---@return number
function MoonClient.LoopScrollRect:GetShowCellStartIndex() end
---@return number
function MoonClient.LoopScrollRect:GetShowCellEndIndex() end
---@return number
---@param showIndex number
function MoonClient.LoopScrollRect:GetCellIndexWithShowIndex(showIndex) end
---@return boolean
---@param dataIndex number
function MoonClient.LoopScrollRect:IsCellCanShowWithDataIndex(dataIndex) end
---@return boolean
---@param cellIndex number
function MoonClient.LoopScrollRect:IsCellCanShowWithCellIndex(cellIndex) end
---@return number
function MoonClient.LoopScrollRect:GetCellStartIndex() end
---@return number
function MoonClient.LoopScrollRect:GetCellEndIndex() end
---@return boolean
---@param dataIndex number
function MoonClient.LoopScrollRect:IsScrollRectExistingCellWithDataIndex(dataIndex) end
---@return number
---@param dataIndex number
function MoonClient.LoopScrollRect:GetExistingCellIndexWithDataIndex(dataIndex) end
---@return number
---@param cellIndex number
function MoonClient.LoopScrollRect:GetExistingDataIndexWithCellIndex(cellIndex) end
---@return boolean
function MoonClient.LoopScrollRect:IsScrollRectExistingStartCell() end
---@return boolean
function MoonClient.LoopScrollRect:IsScrollRectExistingEndCell() end
---@return boolean
---@param isStart boolean
function MoonClient.LoopScrollRect:IsScrollRectExistingCellWithDirection(isStart) end
---@return number
function MoonClient.LoopScrollRect:GetShowCount() end
---@return number
function MoonClient.LoopScrollRect:GetPreviousCellCount() end
---@param addCount number
function MoonClient.LoopScrollRect:AddCell(addCount) end
---@param deleteCount number
function MoonClient.LoopScrollRect:DeleteCell(deleteCount) end
---@param dataIndex number
function MoonClient.LoopScrollRect:DeleteCellWithDataIndex(dataIndex) end
---@param changeValue number
function MoonClient.LoopScrollRect:ChangeTotalCount(changeValue) end
function MoonClient.LoopScrollRect:StopScroll() end
---@param index number
---@param speed number
---@param callback (fun():void)
function MoonClient.LoopScrollRect:ScrollToCell(index, speed, callback) end
function MoonClient.LoopScrollRect:RefreshScrollCells() end
---@param startIndex number
function MoonClient.LoopScrollRect:RefreshScrollCellsWithStartIndex(startIndex) end
---@return number
function MoonClient.LoopScrollRect:GetSurplusCellCount() end
---@param method (fun(obj:number):void)
function MoonClient.LoopScrollRect:SetOnValueChangedMethod(method) end
---@param executing number
function MoonClient.LoopScrollRect:Rebuild(executing) end
function MoonClient.LoopScrollRect:LayoutComplete() end
function MoonClient.LoopScrollRect:GraphicUpdateComplete() end
---@return boolean
function MoonClient.LoopScrollRect:IsActive() end
function MoonClient.LoopScrollRect:StopMovement() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.LoopScrollRect:OnInitializePotentialDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.LoopScrollRect:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.LoopScrollRect:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.LoopScrollRect:OnDrag(eventData) end
---@param dictance UnityEngine.Vector2
function MoonClient.LoopScrollRect:SetContentOffset(dictance) end
---@param position UnityEngine.Vector2
function MoonClient.LoopScrollRect:SetContentAnchoredPosition(position) end
---@param offset number
---@param isStopAtEnd boolean
function MoonClient.LoopScrollRect:SetContentAnchoredPositionWithOffset(offset, isStopAtEnd) end
---@return number
function MoonClient.LoopScrollRect:GetNormalizedPosition() end
---@param value number
function MoonClient.LoopScrollRect:SetNormalizedPosition(value) end
function MoonClient.LoopScrollRect:CalculateLayoutInputHorizontal() end
function MoonClient.LoopScrollRect:CalculateLayoutInputVertical() end
function MoonClient.LoopScrollRect:SetLayoutHorizontal() end
function MoonClient.LoopScrollRect:SetLayoutVertical() end
---@param transform UnityEngine.Transform
---@param bounds UnityEngine.Bounds
function MoonClient.LoopScrollRect.ShowBounds(transform, bounds) end
function MoonClient.LoopScrollRect:CheckLayout() end
return MoonClient.LoopScrollRect
