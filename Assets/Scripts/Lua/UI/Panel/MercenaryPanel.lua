--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MercenaryPanel = {}

--lua model end

--lua functions
---@class MercenaryPanel.MercenaryIntroductionCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field SchoolText MoonClient.MLuaUICom
---@field School MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field Male MoonClient.MLuaUICom
---@field Gender MoonClient.MLuaUICom
---@field Female MoonClient.MLuaUICom
---@field ContentText MoonClient.MLuaUICom
---@field ConstellationImg MoonClient.MLuaUICom
---@field Constellation MoonClient.MLuaUICom

---@class MercenaryPanel.MercenaryRecruitCondition
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskImage MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field CostText MoonClient.MLuaUICom
---@field Cost MoonClient.MLuaUICom
---@field ConditionText MoonClient.MLuaUICom

---@class MercenaryPanel.MercenaryEquipAttr
---@field PanelRef MoonClient.MLuaUIPanel
---@field AttrValueText MoonClient.MLuaUICom
---@field AttrNameText MoonClient.MLuaUICom

---@class MercenaryPanel.MercenaryTalentInfo.MercenaryTalentCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentLvMax MoonClient.MLuaUICom
---@field TalentLv4 MoonClient.MLuaUICom
---@field TalentLv3 MoonClient.MLuaUICom
---@field TalentLv2 MoonClient.MLuaUICom
---@field TalentLv1 MoonClient.MLuaUICom
---@field TalentImg MoonClient.MLuaUICom
---@field SelectEffect MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class MercenaryPanel.MercenaryTalentInfo
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalentLvMax MoonClient.MLuaUICom
---@field TalentLv4 MoonClient.MLuaUICom
---@field TalentLv3 MoonClient.MLuaUICom
---@field TalentLv2 MoonClient.MLuaUICom
---@field TalentLv1 MoonClient.MLuaUICom
---@field TalentImg MoonClient.MLuaUICom
---@field TalentDetailScroll MoonClient.MLuaUICom
---@field TalentDetailContent MoonClient.MLuaUICom
---@field StudyText MoonClient.MLuaUICom
---@field Study MoonClient.MLuaUICom
---@field SelectEffect MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field LockText MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field DesText MoonClient.MLuaUICom
---@field MercenaryTalentCell MercenaryPanel.MercenaryTalentInfo.MercenaryTalentCell

---@class MercenaryPanel.MercenaryCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field SubBtn MoonClient.MLuaUICom
---@field Selection MoonClient.MLuaUICom
---@field Notrecruited MoonClient.MLuaUICom
---@field NotOpen MoonClient.MLuaUICom
---@field LockLevelText MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LevelUp MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field JobImg MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field DieTimeText MoonClient.MLuaUICom
---@field Die MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom
---@field Attack MoonClient.MLuaUICom
---@field AddBtn MoonClient.MLuaUICom

---@class MercenaryPanel.MercenaryUpgradeItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Item MoonClient.MLuaUICom
---@field ExpText MoonClient.MLuaUICom

---@class MercenaryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VitText MoonClient.MLuaUICom
---@field UpgradeItemsContent MoonClient.MLuaUICom
---@field UpgradeItemsBackBtn MoonClient.MLuaUICom
---@field UpgradeItems MoonClient.MLuaUICom
---@field UpgradeHelpBtn MoonClient.MLuaUICom
---@field UpgradeBtn MoonClient.MLuaUICom
---@field UpgradeArrow MoonClient.MLuaUICom
---@field TalentUpgradeBtn MoonClient.MLuaUICom
---@field TalentTog MoonClient.MLuaUICom
---@field TalentTimeText MoonClient.MLuaUICom
---@field TalentTime MoonClient.MLuaUICom
---@field TalentSwitchBtn MoonClient.MLuaUICom
---@field TalentStudyBtn MoonClient.MLuaUICom
---@field TalentStrengthenBtn MoonClient.MLuaUICom
---@field TalentResetBtn MoonClient.MLuaUICom
---@field TalentNameText MoonClient.MLuaUICom
---@field TalentLvMax MoonClient.MLuaUICom
---@field TalentLv4 MoonClient.MLuaUICom
---@field TalentLv3 MoonClient.MLuaUICom
---@field TalentLv2 MoonClient.MLuaUICom
---@field TalentLv1 MoonClient.MLuaUICom
---@field TalentLockText MoonClient.MLuaUICom
---@field TalentLevelText MoonClient.MLuaUICom
---@field TalentInfoScroll MoonClient.MLuaUICom
---@field TalentInfoContent MoonClient.MLuaUICom
---@field TalentImg MoonClient.MLuaUICom
---@field TalentIcon MoonClient.MLuaUICom
---@field TalentEffect MoonClient.MLuaUICom
---@field TalentDetail MoonClient.MLuaUICom
---@field TalentDesText MoonClient.MLuaUICom
---@field TalentCostText MoonClient.MLuaUICom
---@field TalentCost MoonClient.MLuaUICom
---@field StrText MoonClient.MLuaUICom
---@field StoryText MoonClient.MLuaUICom
---@field StoryContent MoonClient.MLuaUICom
---@field SkillTog MoonClient.MLuaUICom
---@field Skill MoonClient.MLuaUICom
---@field RecruitContent MoonClient.MLuaUICom
---@field RecruitCondition MoonClient.MLuaUICom
---@field PointIcon MoonClient.MLuaUICom
---@field PointCostIcon MoonClient.MLuaUICom
---@field OutFightContent MoonClient.MLuaUICom
---@field OptionSkillHelpBtn MoonClient.MLuaUICom
---@field OptionSkillContent MoonClient.MLuaUICom
---@field OnekeyUpgradeBtn MoonClient.MLuaUICom
---@field NotRecruitImg MoonClient.MLuaUICom
---@field NoTalent MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field MerTalent MoonClient.MLuaUICom
---@field MerEquipment MoonClient.MLuaUICom
---@field MercenaryPointHelpBtn MoonClient.MLuaUICom
---@field MercenaryLevel MoonClient.MLuaUICom
---@field MercenaryImg MoonClient.MLuaUICom
---@field LukText MoonClient.MLuaUICom
---@field Liubianxing MoonClient.MLuaUICom
---@field LevelUpEffect MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field LevelSliderText MoonClient.MLuaUICom
---@field LevelSlider MoonClient.MLuaUICom
---@field JobImg MoonClient.MLuaUICom
---@field IntText MoonClient.MLuaUICom
---@field IntroductionTog MoonClient.MLuaUICom
---@field IntroductionContent MoonClient.MLuaUICom
---@field Introduction MoonClient.MLuaUICom
---@field InFightPos MoonClient.MLuaUICom[]
---@field InFightContent MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom[]
---@field GMAllEquipUpgradeBtn MoonClient.MLuaUICom
---@field FixSkillContent MoonClient.MLuaUICom
---@field EquipZenyText MoonClient.MLuaUICom
---@field EquipZeny MoonClient.MLuaUICom
---@field EquipUpgradeHighest MoonClient.MLuaUICom
---@field EquipUpgradeBtns MoonClient.MLuaUICom
---@field EquipUpgradeBtn MoonClient.MLuaUICom
---@field EquipTog MoonClient.MLuaUICom[]
---@field EquipPosText MoonClient.MLuaUICom[]
---@field EquipPanel MoonClient.MLuaUICom
---@field EquipNameText MoonClient.MLuaUICom[]
---@field EquipmentTog MoonClient.MLuaUICom
---@field EquipLevelup MoonClient.MLuaUICom[]
---@field EquipLevelText MoonClient.MLuaUICom[]
---@field EquipImg MoonClient.MLuaUICom[]
---@field EquipIconImg MoonClient.MLuaUICom[]
---@field EquipEffect MoonClient.MLuaUICom
---@field EquipDetail MoonClient.MLuaUICom[]
---@field EquipCoinText MoonClient.MLuaUICom
---@field EquipCoin MoonClient.MLuaUICom
---@field EquipAttrContent MoonClient.MLuaUICom[]
---@field EquipAdvanceEffect MoonClient.MLuaUICom
---@field EquipAdvanceBtn MoonClient.MLuaUICom
---@field DexText MoonClient.MLuaUICom
---@field CurrencyText MoonClient.MLuaUICom
---@field Coins MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field BtnBack MoonClient.MLuaUICom
---@field AttrScroll MoonClient.MLuaUICom
---@field AttributeTog MoonClient.MLuaUICom
---@field Attribute MoonClient.MLuaUICom
---@field AttrContent MoonClient.MLuaUICom
---@field AgiText MoonClient.MLuaUICom
---@field AdvanceBtn MoonClient.MLuaUICom
---@field AdvanceArrow MoonClient.MLuaUICom
---@field MercenaryIntroductionCell MercenaryPanel.MercenaryIntroductionCell
---@field MercenaryRecruitCondition MercenaryPanel.MercenaryRecruitCondition
---@field MercenaryEquipAttr MercenaryPanel.MercenaryEquipAttr
---@field MercenaryTalentInfo MercenaryPanel.MercenaryTalentInfo
---@field MercenaryCell MercenaryPanel.MercenaryCell
---@field MercenaryUpgradeItem MercenaryPanel.MercenaryUpgradeItem

---@return MercenaryPanel
---@param ctrl UIBase
function MercenaryPanel.Bind(ctrl)
	
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
return UI.MercenaryPanel