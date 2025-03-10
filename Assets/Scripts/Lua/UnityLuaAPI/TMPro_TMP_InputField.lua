---@class TMPro.TMP_InputField : UnityEngine.UI.Selectable
---@field public shouldHideMobileInput boolean
---@field public text string
---@field public isFocused boolean
---@field public caretBlinkRate number
---@field public caretWidth number
---@field public textViewport UnityEngine.RectTransform
---@field public textComponent TMPro.TMP_Text
---@field public placeholder UnityEngine.UI.Graphic
---@field public verticalScrollbar UnityEngine.UI.Scrollbar
---@field public scrollSensitivity number
---@field public caretColor UnityEngine.Color
---@field public customCaretColor boolean
---@field public selectionColor UnityEngine.Color
---@field public onEndEdit TMPro.TMP_InputField.SubmitEvent
---@field public onSubmit TMPro.TMP_InputField.SubmitEvent
---@field public onSelect TMPro.TMP_InputField.SelectionEvent
---@field public onDeselect TMPro.TMP_InputField.SelectionEvent
---@field public onTextSelection TMPro.TMP_InputField.TextSelectionEvent
---@field public onEndTextSelection TMPro.TMP_InputField.TextSelectionEvent
---@field public onValueChanged TMPro.TMP_InputField.OnChangeEvent
---@field public onValidateInput (fun(text:string, charIndex:number, addedChar:number):number)
---@field public characterLimit number
---@field public pointSize number
---@field public fontAsset TMPro.TMP_FontAsset
---@field public onFocusSelectAll boolean
---@field public resetOnDeActivation boolean
---@field public restoreOriginalTextOnEscape boolean
---@field public isRichTextEditingAllowed boolean
---@field public contentType number
---@field public lineType number
---@field public inputType number
---@field public keyboardType number
---@field public characterValidation number
---@field public inputValidator TMPro.TMP_InputValidator
---@field public readOnly boolean
---@field public richText boolean
---@field public multiLine boolean
---@field public asteriskChar number
---@field public wasCanceled boolean
---@field public caretPosition number
---@field public selectionAnchorPosition number
---@field public selectionFocusPosition number
---@field public stringPosition number
---@field public selectionStringAnchorPosition number
---@field public selectionStringFocusPosition number

---@type TMPro.TMP_InputField
TMPro.TMP_InputField = { }
---@param shift boolean
function TMPro.TMP_InputField:MoveTextEnd(shift) end
---@param shift boolean
function TMPro.TMP_InputField:MoveTextStart(shift) end
---@param shift boolean
---@param ctrl boolean
function TMPro.TMP_InputField:MoveToEndOfLine(shift, ctrl) end
---@param shift boolean
---@param ctrl boolean
function TMPro.TMP_InputField:MoveToStartOfLine(shift, ctrl) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnPointerDown(eventData) end
---@param e UnityEngine.Event
function TMPro.TMP_InputField:ProcessEvent(e) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro.TMP_InputField:OnUpdateSelected(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnScroll(eventData) end
function TMPro.TMP_InputField:ForceLabelUpdate() end
---@param update number
function TMPro.TMP_InputField:Rebuild(update) end
function TMPro.TMP_InputField:LayoutComplete() end
function TMPro.TMP_InputField:GraphicUpdateComplete() end
function TMPro.TMP_InputField:ActivateInputField() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro.TMP_InputField:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function TMPro.TMP_InputField:OnPointerClick(eventData) end
function TMPro.TMP_InputField:OnControlClick() end
function TMPro.TMP_InputField:DeactivateInputField() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro.TMP_InputField:OnDeselect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function TMPro.TMP_InputField:OnSubmit(eventData) end
---@param pointSize number
function TMPro.TMP_InputField:SetGlobalPointSize(pointSize) end
---@param fontAsset TMPro.TMP_FontAsset
function TMPro.TMP_InputField:SetGlobalFontAsset(fontAsset) end
return TMPro.TMP_InputField
