--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.ForgeData", package.seeall)
--lua model end

ForgeHoleSite=nil
ForgeLevelShow=nil
ForgeLevelShowSection=nil
ForgeLevelShowArmor=nil
ForgeLevelShowSectionArmor=nil

--lua functions
function Init()

    ForgeHoleSite=MGlobalConfig:GetSequenceOrVectorInt("ForgeHoleSite")
    ForgeLevelShow=MGlobalConfig:GetSequenceOrVectorInt("ForgeLevelShow")
    ForgeLevelShowSection=MGlobalConfig:GetSequenceOrVectorInt("ForgeLevelShowSection")
    ForgeLevelShowArmor=MGlobalConfig:GetSequenceOrVectorInt("ForgeLevelShow_Armor")
    ForgeLevelShowSectionArmor=MGlobalConfig:GetSequenceOrVectorInt("ForgeLevelShowSection_Armor")
	
end --func end
--next--
function UnInit()

    ForgeHoleSite=nil
    ForgeLevelShow=nil
    ForgeLevelShowSection=nil
    ForgeLevelShowArmor=nil
    ForgeLevelShowSectionArmor=nil
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ModuleData.ForgeData