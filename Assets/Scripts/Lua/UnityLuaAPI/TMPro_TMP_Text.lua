---@class TMPro.TMP_Text : UnityEngine.UI.MaskableGraphic
---@field public text string
---@field public isRightToLeftText boolean
---@field public font TMPro.TMP_FontAsset
---@field public fontSharedMaterial UnityEngine.Material
---@field public fontSharedMaterials UnityEngine.Material[]
---@field public fontMaterial UnityEngine.Material
---@field public fontMaterials UnityEngine.Material[]
---@field public color UnityEngine.Color
---@field public alpha number
---@field public enableVertexGradient boolean
---@field public colorGradient TMPro.VertexGradient
---@field public colorGradientPreset TMPro.TMP_ColorGradient
---@field public spriteAsset TMPro.TMP_SpriteAsset
---@field public tintAllSprites boolean
---@field public overrideColorTags boolean
---@field public faceColor UnityEngine.Color32
---@field public outlineColor UnityEngine.Color32
---@field public outlineWidth number
---@field public fontSize number
---@field public fontScale number
---@field public fontWeight number
---@field public pixelsPerUnit number
---@field public enableAutoSizing boolean
---@field public fontSizeMin number
---@field public fontSizeMax number
---@field public fontStyle number
---@field public isUsingBold boolean
---@field public alignment number
---@field public characterSpacing number
---@field public wordSpacing number
---@field public lineSpacing number
---@field public lineSpacingAdjustment number
---@field public paragraphSpacing number
---@field public characterWidthAdjustment number
---@field public enableWordWrapping boolean
---@field public wordWrappingRatios number
---@field public overflowMode number
---@field public isTextOverflowing boolean
---@field public firstOverflowCharacterIndex number
---@field public linkedTextComponent TMPro.TMP_Text
---@field public isLinkedTextComponent boolean
---@field public isTextTruncated boolean
---@field public enableKerning boolean
---@field public extraPadding boolean
---@field public richText boolean
---@field public parseCtrlCharacters boolean
---@field public isOverlay boolean
---@field public isOrthographic boolean
---@field public enableCulling boolean
---@field public ignoreRectMaskCulling boolean
---@field public ignoreVisibility boolean
---@field public horizontalMapping number
---@field public verticalMapping number
---@field public mappingUvLineOffset number
---@field public renderMode number
---@field public geometrySortingOrder number
---@field public firstVisibleCharacter number
---@field public maxVisibleCharacters number
---@field public maxVisibleWords number
---@field public maxVisibleLines number
---@field public useMaxVisibleDescender boolean
---@field public pageToDisplay number
---@field public margin UnityEngine.Vector4
---@field public textInfo TMPro.TMP_TextInfo
---@field public havePropertiesChanged boolean
---@field public isUsingLegacyAnimationComponent boolean
---@field public transform UnityEngine.Transform
---@field public rectTransform UnityEngine.RectTransform
---@field public autoSizeTextContainer boolean
---@field public mesh UnityEngine.Mesh
---@field public isVolumetricText boolean
---@field public bounds UnityEngine.Bounds
---@field public textBounds UnityEngine.Bounds
---@field public flexibleHeight number
---@field public flexibleWidth number
---@field public minWidth number
---@field public minHeight number
---@field public maxWidth number
---@field public maxHeight number
---@field public preferredWidth number
---@field public preferredHeight number
---@field public renderedWidth number
---@field public renderedHeight number
---@field public layoutPriority number

---@type TMPro.TMP_Text
TMPro.TMP_Text = { }
---@return TMPro.TMP_Text
function TMPro.TMP_Text.New() end
---@overload fun(): void
---@param ignoreActiveState boolean
function TMPro.TMP_Text:ForceMeshUpdate(ignoreActiveState) end
---@param mesh UnityEngine.Mesh
---@param index number
function TMPro.TMP_Text:UpdateGeometry(mesh, index) end
---@overload fun(): void
---@param flags number
function TMPro.TMP_Text:UpdateVertexData(flags) end
---@param vertices UnityEngine.Vector3[]
function TMPro.TMP_Text:SetVertices(vertices) end
function TMPro.TMP_Text:UpdateMeshPadding() end
---@param targetColor UnityEngine.Color
---@param duration number
---@param ignoreTimeScale boolean
---@param useAlpha boolean
function TMPro.TMP_Text:CrossFadeColor(targetColor, duration, ignoreTimeScale, useAlpha) end
---@param alpha number
---@param duration number
---@param ignoreTimeScale boolean
function TMPro.TMP_Text:CrossFadeAlpha(alpha, duration, ignoreTimeScale) end
---@overload fun(text:string): void
---@overload fun(text:System.Text.StringBuilder): void
---@overload fun(text:string, syncTextInputBox:boolean): void
---@overload fun(text:string, arg0:number): void
---@overload fun(text:string, arg0:number, arg1:number): void
---@param text string
---@param arg0 number
---@param arg1 number
---@param arg2 number
function TMPro.TMP_Text:SetText(text, arg0, arg1, arg2) end
---@overload fun(sourceText:System.Char[]): void
---@overload fun(sourceText:System.Char[], start:number, length:number): void
---@param sourceText System.Int32[]
---@param start number
---@param length number
function TMPro.TMP_Text:SetCharArray(sourceText, start, length) end
---@overload fun(): UnityEngine.Vector2
---@overload fun(text:string): UnityEngine.Vector2
---@overload fun(width:number, height:number): UnityEngine.Vector2
---@return UnityEngine.Vector2
---@param text string
---@param width number
---@param height number
function TMPro.TMP_Text:GetPreferredValues(text, width, height) end
---@overload fun(): UnityEngine.Vector2
---@return UnityEngine.Vector2
---@param onlyVisibleCharacters boolean
function TMPro.TMP_Text:GetRenderedValues(onlyVisibleCharacters) end
---@return TMPro.TMP_TextInfo
---@param text string
function TMPro.TMP_Text:GetTextInfo(text) end
---@overload fun(): void
---@param uploadGeometry boolean
function TMPro.TMP_Text:ClearMesh(uploadGeometry) end
---@return string
function TMPro.TMP_Text:GetParsedText() end
return TMPro.TMP_Text
