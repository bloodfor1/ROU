--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillLearningPanel = {}

--lua model end

--lua functions
---@class SkillLearningPanel.AddSkillPointPanel.BtnLearnSkillInstance
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtSkillName5 MoonClient.MLuaUICom
---@field TxtSkillName3 MoonClient.MLuaUICom
---@field TxtSkillLv MoonClient.MLuaUICom
---@field SkillName5 MoonClient.MLuaUICom
---@field SkillName3 MoonClient.MLuaUICom
---@field SkillLvBg MoonClient.MLuaUICom
---@field PlusTxt MoonClient.MLuaUICom
---@field PlusLab MoonClient.MLuaUICom
---@field learnEff MoonClient.MLuaUICom
---@field ImgBG2 MoonClient.MLuaUICom
---@field ImgBG MoonClient.MLuaUICom
---@field BtnSelectSkill MoonClient.MLuaUICom
---@field BtnReduceSkillPoint MoonClient.MLuaUICom
---@field BtnPlusSkillPoint MoonClient.MLuaUICom

---@class SkillLearningPanel.AddSkillPointPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field LineContainter MoonClient.MLuaUICom
---@field FrontSkillLineInstance MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field BtnLearnSkillInstance SkillLearningPanel.AddSkillPointPanel.BtnLearnSkillInstance

---@class SkillLearningPanel.SkillLeaningPreviewPanel.LeftPreview
---@field PanelRef MoonClient.MLuaUIPanel
---@field VitText MoonClient.MLuaUICom
---@field VitNameText MoonClient.MLuaUICom
---@field StrText MoonClient.MLuaUICom
---@field StrNameText MoonClient.MLuaUICom
---@field ProviewProName MoonClient.MLuaUICom
---@field ProviewProEnglishName MoonClient.MLuaUICom
---@field ProfessionPainting MoonClient.MLuaUICom
---@field PreviewProIcon MoonClient.MLuaUICom
---@field LukText MoonClient.MLuaUICom
---@field LukNameText MoonClient.MLuaUICom
---@field IntText MoonClient.MLuaUICom
---@field IntNameText MoonClient.MLuaUICom
---@field DexText MoonClient.MLuaUICom
---@field DexNameText MoonClient.MLuaUICom
---@field AttrPolygon MoonClient.MLuaUICom
---@field Attribute MoonClient.MLuaUICom
---@field AgiText MoonClient.MLuaUICom
---@field AgiNameText MoonClient.MLuaUICom

---@class SkillLearningPanel.SkillLeaningPreviewPanel.RightPreview.ProfessionSkillClass
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName MoonClient.MLuaUICom[]
---@field SkillLv MoonClient.MLuaUICom[]
---@field SkillIcon MoonClient.MLuaUICom[]
---@field Skill MoonClient.MLuaUICom[]
---@field SchoolName MoonClient.MLuaUICom
---@field School MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field BtnPlaySkill MoonClient.MLuaUICom[]

---@class SkillLearningPanel.SkillLeaningPreviewPanel.RightPreview
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtGotoNext MoonClient.MLuaUICom
---@field TextTask MoonClient.MLuaUICom
---@field TextLevel MoonClient.MLuaUICom
---@field TaskCheck MoonClient.MLuaUICom
---@field SkillParent MoonClient.MLuaUICom
---@field PreviewProIntroduce MoonClient.MLuaUICom
---@field NotFinishTask MoonClient.MLuaUICom
---@field NotFinishLv MoonClient.MLuaUICom
---@field LevelCheck MoonClient.MLuaUICom
---@field FinishTask MoonClient.MLuaUICom
---@field FinishLv MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonTask MoonClient.MLuaUICom
---@field ButtonLevel MoonClient.MLuaUICom
---@field BtnGotoNext MoonClient.MLuaUICom
---@field ProfessionSkillClass SkillLearningPanel.SkillLeaningPreviewPanel.RightPreview.ProfessionSkillClass

---@class SkillLearningPanel.SkillLeaningPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field LeftPreview SkillLearningPanel.SkillLeaningPreviewPanel.LeftPreview
---@field RightPreview SkillLearningPanel.SkillLeaningPreviewPanel.RightPreview

---@class SkillLearningPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtSlotLv MoonClient.MLuaUICom[]
---@field TxtSaverTip MoonClient.MLuaUICom
---@field TxtRemainingPoint MoonClient.MLuaUICom
---@field TxtProfessionName MoonClient.MLuaUICom
---@field TxtProfessionEnglishName MoonClient.MLuaUICom
---@field TxtCurrentSkillPoint MoonClient.MLuaUICom
---@field TopButtonPanel MoonClient.MLuaUICom
---@field TogUseMaxLevel MoonClient.MLuaUICom
---@field TogQueueMaxLevel MoonClient.MLuaUICom
---@field TogManSlot MoonClient.MLuaUICom
---@field ToggleTpl MoonClient.MLuaUICom[]
---@field ToggleProfessionTwo MoonClient.MLuaUICom
---@field ToggleProfessionThree MoonClient.MLuaUICom
---@field ToggleProfessionOne MoonClient.MLuaUICom
---@field ToggleProfessionFour MoonClient.MLuaUICom
---@field ToggleBaseSkill MoonClient.MLuaUICom
---@field TogAutoSlot MoonClient.MLuaUICom
---@field SlotHurt MoonClient.MLuaUICom
---@field SkillQueue MoonClient.MLuaUICom
---@field SkillPointSaverPanel MoonClient.MLuaUICom
---@field SkillPointPanel MoonClient.MLuaUICom
---@field SkillPoint MoonClient.MLuaUICom
---@field SkillPlan MoonClient.MLuaUICom
---@field SkillIconClone MoonClient.MLuaUICom
---@field SKILLICON MoonClient.MLuaUICom
---@field SkillAddPointContent MoonClient.MLuaUICom
---@field ShowSlotSkillContent MoonClient.MLuaUICom
---@field SettingSkillScroll MoonClient.MLuaUICom
---@field RightJobText MoonClient.MLuaUICom
---@field RightJobShadow MoonClient.MLuaUICom
---@field RightJobPic MoonClient.MLuaUICom
---@field RightJobName MoonClient.MLuaUICom
---@field RightJobImage MoonClient.MLuaUICom
---@field RightJobChooseBtn MoonClient.MLuaUICom
---@field QueueTxtSlotLv MoonClient.MLuaUICom[]
---@field QueueSlotIcons MoonClient.MLuaUICom[]
---@field QueueShowSlotSkillContent MoonClient.MLuaUICom
---@field QueueSettingSkillScroll MoonClient.MLuaUICom
---@field QueuePanelSlot MoonClient.MLuaUICom[]
---@field QueueNoOpen MoonClient.MLuaUICom
---@field QueueNone MoonClient.MLuaUICom
---@field QueueImgUp MoonClient.MLuaUICom
---@field QueueImgDown MoonClient.MLuaUICom
---@field QueueHelpSkillsParent MoonClient.MLuaUICom
---@field QueueHelpParts MoonClient.MLuaUICom
---@field QueueBG2 MoonClient.MLuaUICom
---@field QueueBG1 MoonClient.MLuaUICom
---@field Queue MoonClient.MLuaUICom[]
---@field ProfessionScrollView MoonClient.MLuaUICom
---@field ProfessionInfoPanel MoonClient.MLuaUICom
---@field PanelSlot MoonClient.MLuaUICom[]
---@field NotFinishLv MoonClient.MLuaUICom
---@field NoOpenHint MoonClient.MLuaUICom
---@field MainQueueIcon MoonClient.MLuaUICom
---@field LineContainter MoonClient.MLuaUICom
---@field LeftJobText MoonClient.MLuaUICom
---@field LeftJobShadow MoonClient.MLuaUICom
---@field LeftJobPic MoonClient.MLuaUICom
---@field LeftJobName MoonClient.MLuaUICom
---@field LeftJobImage MoonClient.MLuaUICom
---@field LeftJobChooseBtn MoonClient.MLuaUICom
---@field LearnSkillTxt MoonClient.MLuaUICom
---@field JobChoose MoonClient.MLuaUICom
---@field ImgUp MoonClient.MLuaUICom
---@field ImgProfessionIcon MoonClient.MLuaUICom
---@field ImgDown MoonClient.MLuaUICom
---@field Image_LvText MoonClient.MLuaUICom
---@field HurtSkillsParent MoonClient.MLuaUICom
---@field HurtParts MoonClient.MLuaUICom
---@field HelpSkillTxt MoonClient.MLuaUICom
---@field HelpSkillsParent MoonClient.MLuaUICom
---@field HelpParts MoonClient.MLuaUICom
---@field EmptyPoint MoonClient.MLuaUICom
---@field DoubleSlotIcons MoonClient.MLuaUICom[]
---@field DoubleDiskBtns MoonClient.MLuaUICom
---@field CommonSkillsParent MoonClient.MLuaUICom
---@field CommonParts MoonClient.MLuaUICom
---@field ClassicsTxtSlotLv MoonClient.MLuaUICom[]
---@field ClassicsPanelSlot MoonClient.MLuaUICom[]
---@field ClassicSlotIcons MoonClient.MLuaUICom[]
---@field ClassicsBtns MoonClient.MLuaUICom
---@field ClassicsBtnManTrs MoonClient.MLuaUICom
---@field ButtonSettingPanel MoonClient.MLuaUICom
---@field BtnResetSkillPoint MoonClient.MLuaUICom
---@field BtnRecommendSkillPointText MoonClient.MLuaUICom
---@field BtnRecommendSkillPoint MoonClient.MLuaUICom
---@field BtnManTrs MoonClient.MLuaUICom
---@field BtnCloseTip MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnCancelSkillPoint MoonClient.MLuaUICom
---@field BtnApplySkillPoint MoonClient.MLuaUICom
---@field BGContainter MoonClient.MLuaUICom
---@field Bg_zikuang5Text MoonClient.MLuaUICom
---@field Bg_zikuang3Text MoonClient.MLuaUICom
---@field BaseSkillTxt MoonClient.MLuaUICom
---@field AttrParent MoonClient.MLuaUICom
---@field AddPointArrowUp MoonClient.MLuaUICom
---@field AddPointArrowDown MoonClient.MLuaUICom
---@field AddSkillPointPanel SkillLearningPanel.AddSkillPointPanel
---@field SkillLeaningPreviewPanel SkillLearningPanel.SkillLeaningPreviewPanel

---@return SkillLearningPanel
---@param ctrl UIBase
function SkillLearningPanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.SkillLearningPanel