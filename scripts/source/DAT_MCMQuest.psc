scriptname DAT_MCMQuest extends SKI_ConfigBase

bool globalsChanged

; string literals are listed below, for reference when setting up translates
; format strings
string fs_1PointPercent = "{1}%"
string fs_2PointSeconds = "{2} seconds"
; mod name
string mn = "Dragon Attack Tactics"
; page names
string pn_General  = "General"
string pn_Injuries = "Injuries"
string pn_Death    = "Death"
; general page string literals
string lab_EnableInjuryHandler           = "Enable the injury system:"
string lab_EnableForceKills              = "Enable force kills:"
string lab_EnableDeathOverride           = "Enable death sequenc:"
string info_EnableInjuryHandler          = "When injuries are enabled, any hit has a chance to injure a dragon. The chance goes up as the dragon's health goes down, but is reduced each time the dragon is successfully injured. Dragons can recover from injuries, but each injury has a chance to be crippling, preventing the dragon from recovering usually."
string info_EnableForceKills             = "When force kills are enabled, dragons will be killed insantly, skipping their death animation. For flying dragons, this means the dragon will not continue flying until it finds a place to land."
string info_EnableDeathSequenceOverride  = "When enabled, the regular death sequence will be overridden. The new sequence allows other dragons to absorb souls, and allows configuring soul absorbtion range. The player will take all souls a dragon has when killing the dragon."
; injury page string literals
string lab_InjuriesFlatThreshold       = "Vanilla injury threshold:"
string lab_InjuryHeader                = "Injury Chance"
string lab_CrippleHeader               = "Cripple Chance"
string lab_DurationHeader              = "Injury Duration"
string lab_ShowExplanation             = "Show Explanation"
string lab_MaximumChance               = "Maximum chance:"
string lab_BaseChance                  = "Base chance:"
string lab_HealthExponent              = "Health exponent:"
string lab_InjuriesCoefficient         = "Injuries coefficient:"
string lab_InjuriesExponent            = "Injuries exponent:"
string lab_InjuriesOffset              = "Injuries offset:"
string lab_CrippleChanceCoefficient    = "Scaling coefficient:"
string lab_DurationLClamp              = "Minimum injury duration:"
string lab_DurationUClamp              = "Maximum injury duration:"
string lab_DurationMean                = "Average injury duration:"
string lab_DurationStdDev              = "Standard deviation:"
string lab_EvaluateClampPools          = "Update Chances Below"
string lab_LClampPool                  = "Chance to get lower bound:"
string lab_UClampPool                  = "Chance to get upper bound:"
string info_FlatThreshold              = "When the injury system is disabled, dragons will be automatically and permanently injured after falling below a certain amount of their health, just like in vanilla Skyrim.\nDefault: 35%"
string info_BaseInjuryChance           = "The base chance to injure a dragon at 100% of its health, and no injuries.\nDefault: 5%"
string info_MaxInjuryChance            = "The maximum chance to injure a dragon at 0% of its health, and no injuries.\nDefault: 25%"
string info_InjuryHealthExponent       = "k1 in the probability equation. Controls the weight of the dragon's health on the chance to injure the dragon. Note that 0 must be entered as 0, not 0.0 or anything else, to set the value to 0.\nDefault: 2.5"
string info_InjuriesCoefficient        = "k2 in the probability equation. Controls the scale of the dragon's injuries. Note that 0 must be entered as 0, not 0.0 or anything else, to set the value to 0.\nDefault: 0.333"
string info_InjuriesExponent           = "k3 in the probability equation. Controls the weight of the dragon's injuries. Note that 0 must be entered as 0, not 0.0 or anything else, to set the value to 0.\nDefault: 1.5"
string info_CrippleBaseChance          = "The base chance for any injury to cripple the dragon.\nDefault: 5%"
string info_CrippleChanceCoefficient   = "k1 in the probability equation. This controls the scale of the variable part of the equation.\nDefault: 5%"
string info_CrippleHealthExponent      = "k2 in the probability equation. This controls the weight of the dragon's health on the chance to injure the dragon. Note that 0 must be entered exactly for a value of 0.\nDefault: 0.75"
string info_CrippleInjuriesCoefficient = "k3 in the probability equation. This controls the scaling of the dragon's injuries. Note that 0 must be entered exactly for a value of 0.\nDefault: 6.0"
string info_CrippleInjuriesOffset      = "k4 in the probability equation. This adds a flat offset to the dragon's sustained injuries for crippling only. Note that 0 must be entered exactly for a value of 0.\nDefault: 2.0"
string info_CrippleInjuriesExponent    = "k5 in the probability equation. This controls the weight of the dragon's sustained injuries. Note that 0 must be entered exactly for a value of 0.\nDefault: 0.5"
string info_DurationMean               = "The average of the normal distribution.\nDefault: 35.0"
string info_DurationStdDev             = "The standard deviation of the normal distribution. If you're not exactly sure what that means, you should probably view the explanation before setting this.\nDefault: 15.0"
string info_DurationLClamp             = "The lower bound on the normal distribution. All injuries are guaranteed to last at least this long.\nDefault: 0.01"
string info_DurationUClamp             = "The upper bound on the normal distribution. All injuries are guaranteed to last at most this long.\nDefault: 90.0"
string info_EvaluateInjuryClampPools   = "A number given by a normal distribution can theoretically be anywhere from negative to positive infinity.\nPractically, the range is limited by the size of float Papyrus can use, and by the bounds applied.\nThe chance to get exactly the bound is given by the chance to get any value below or above the bound, since that number will automatically be moved to the appropriate bound."

; general page state names
string sn_EnableInjuryHandler = "EnableInjury"
string sn_EnableForceKills    = "EnableForceKills"
string sn_EnableDeathOverride = "EnableDeathOverride"

; general page variables
GlobalVariable Property DAT_EnableInjuryHandler Auto
GlobalVariable Property DAT_EnableForceKills Auto
GlobalVariable Property DAT_EnableDeathSequenceOverride Auto
string[] property forceKillOptions auto

; general page defaults
bool def_EnableInjuryHandler         = true
int  def_EnableForceKills            = 1
bool def_EnableDeathSequenceOverride = true

; injury page state names
string sn_InjuriesFlatThreshold      = "InjuriesFlatThreshold"
string sn_InjuryExplanation          = "InjuryExplanation"
string sn_BaseInjuryChance           = "BaseInjuryChance"
string sn_MaxInjuryChance            = "MaxInjuryChance"
string sn_InjuryHealthExponent       = "InjuryHealthExponent"
string sn_InjuriesCoefficient        = "InjuriesCoefficient"
string sn_InjuriesExponent           = "InjuriesExponent"
string sn_DurationExplanation        = "InjuryDurationExplanation"
string sn_InjuryDurationMean         = "InjuryDurationMean"
string sn_InjuryDurationStdDev       = "InjuryDurationStdDev"
string sn_InjuryDurationLClamp       = "InjuryDurationLClamp"
string sn_InjuryDurationUClamp       = "InjuryDurationUClamp"
string sn_CrippleExplanation         = "CrippleExplanation"
string sn_CrippleBaseChance          = "CrippleBaseChance"
string sn_CrippleChanceCoefficient   = "CrippleChanceCoefficient"
string sn_CrippleHealthExponent      = "CrippleHealthExponent"
string sn_CrippleInjuriesCoefficient = "CrippleInjuriesCoefficient"
string sn_CrippleInjuriesOffset      = "CrippleInjuriesOffset"
string sn_CrippleInjuriesExponent    = "CrippleInjuriesExponent"
string sn_InjuryEvaluateClampPools   = "InjuryEvaluateClampPools"
string sn_InjuryLClampPool           = "InjuryLClampPool"
string sn_InjuryUClampPool           = "InjuryUClampPool"

; injury page variables
GlobalVariable Property DAT_BaseInjuryChance Auto
GlobalVariable Property DAT_MaxInjuryChance Auto
GlobalVariable Property DAT_InjuryHealthExponent Auto
GlobalVariable Property DAT_InjuriesCoefficient Auto
GlobalVariable Property DAT_InjuriesExponent Auto
GlobalVariable Property DAT_InjuryDurationMean Auto
GlobalVariable Property DAT_InjuryDurationStdDev Auto
GlobalVariable Property DAT_InjuryDurationLClamp Auto
GlobalVariable Property DAT_InjuryDurationUClamp Auto
GlobalVariable Property DAT_CrippleBaseChance Auto
GlobalVariable Property DAT_CrippleChanceCoefficient Auto
GlobalVariable Property DAT_CrippleHealthExponent Auto
GlobalVariable Property DAT_CrippleInjuriesCoefficient Auto
GlobalVariable Property DAT_CrippleInjuriesOffset Auto
GlobalVariable Property DAT_CrippleInjuriesExponent Auto
GlobalVariable Property DAT_InjuriesFlatThreshold Auto

; injury page defaults
float def_LiveUpdateRate
float def_BaseInjuryChance           = 0.05
float def_MaxInjuryChance            = 0.25
float def_InjuryHealthExponent       = 2.5
float def_InjuriesCoefficient        = 0.3333333
float def_InjuriesExponent           = 1.5
float def_InjuryDurationMean         = 35.0
float def_InjuryDurationStdDev       = 15.0
float def_InjuryDurationLClamp       = 0.01
float def_InjuryDurationUClamp       = 90.0
float def_CrippleBaseChance          = 0.05
float def_CrippleChanceCoefficient   = 0.05
float def_CrippleHealthExponent      = 0.75
float def_CrippleInjuriesCoefficient = 6.0
float def_CrippleInjuriesOffset      = 2.0
float def_CrippleInjuriesExponent    = 0.5
float def_InjuriesFlatThreshold      = 0.35

; death page state names
; death page variables
; death page defaults

Event onConfigInit()
	ModName = mn
	Pages = new String[3]
	Pages[0] = pn_General
	Pages[1] = pn_Injuries
	Pages[2] = pn_Death
	globalsChanged = false
endEvent

Event onPageReset(String page)
	if(page == "")
	elseif(page == pn_General)
		buildGeneralPage()
	elseif(page == pn_Injuries)
		buildInjuriesPage()
	elseif(page == pn_Death)
		buildDeathPage()
	endIf
endEvent

Event onKeyDown(int keyCode)
	advanceCustomContent()
endEvent

function buildGeneralPage()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddToggleOptionST(sn_EnableInjuryHandler, lab_EnableInjuryHandler, DAT_EnableInjuryHandler.getValue() as bool)
	AddMenuOptionST(sn_EnableForceKills, "Enable force kills:", ForceKillOptions[DAT_EnableForceKills.getValue() as int])
	AddToggleOptionST(sn_EnableDeathOverride, "Enable death sequence override:", DAT_EnableDeathSequenceOverride.getValue() as bool)
endFunction

function buildInjuriesPage()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddToggleOptionST(sn_EnableInjuryHandler, lab_EnableInjuryHandler, DAT_EnableInjuryHandler.getValue() as bool)
	AddSliderOptionST(sn_InjuriesFlatThreshold, lab_InjuriesFlatThreshold, DAT_InjuriesFlatThreshold.getValue() * 100.0, fs_1PointPercent)
	AddEmptyOption()
	AddHeaderOption(lab_InjuryHeader)
	AddTextOptionST(sn_InjuryExplanation, "", lab_ShowExplanation)
	AddSliderOptionST(sn_MaxInjuryChance, lab_MaximumChance, DAT_MaxInjuryChance.getValue() * 100.0, fs_1PointPercent)
	AddSliderOptionST(sn_BaseInjuryChance,lab_BaseChance, DAT_BaseInjuryChance.getValue() * 100.0, fs_1PointPercent)
	AddInputOptionST(sn_InjuryHealthExponent, lab_HealthExponent, StringUtil.substring(DAT_InjuryHealthExponent.getValue() as string, 0, 3))
	AddInputOptionST(sn_InjuriesCoefficient, lab_InjuriesCoefficient, StringUtil.substring(DAT_InjuriesCoefficient.getValue() as string, 0, 3))
	AddInputOptionST(sn_InjuriesExponent, lab_InjuriesExponent, StringUtil.substring(DAT_InjuriesExponent.getValue() as string, 0, 3))
	AddEmptyOption()
	AddHeaderOption(lab_CrippleHeader)
	AddTextOptionST(sn_CrippleExplanation, "", lab_ShowExplanation)
	AddSliderOptionST(sn_CrippleBaseChance, lab_BaseChance, DAT_CrippleBaseChance.getValue() * 100.0, fs_1PointPercent)
	AddSliderOptionST(sn_CrippleChanceCoefficient, lab_CrippleChanceCoefficient, DAT_CrippleBaseChance.getValue() * 100.0, fs_1PointPercent)
	AddInputOptionST(sn_CrippleHealthExponent, lab_HealthExponent, StringUtil.substring(DAT_CrippleHealthExponent.getValue() as string, 0, 3))
	AddInputOptionST(sn_CrippleInjuriesCoefficient, lab_InjuriesCoefficient, StringUtil.substring(DAT_CrippleInjuriesCoefficient.getValue() as string, 0, 3))
	AddInputOptionST(sn_CrippleInjuriesOffset, lab_InjuriesOffset, StringUtil.substring(DAT_CrippleInjuriesOffset.getValue() as string, 0, 3))
	AddInputOptionST(sn_CrippleInjuriesExponent, lab_InjuriesExponent, StringUtil.substring(DAT_CrippleInjuriesExponent.getValue() as string, 0, 3))
	AddEmptyOption()
	AddHeaderOption(lab_DurationHeader)
	AddTextOptionST(sn_DurationExplanation, "", lab_ShowExplanation)
	AddSliderOptionST(sn_InjuryDurationLClamp, lab_DurationLClamp, DAT_InjuryDurationLClamp.getValue(), fs_2PointSeconds)
	AddSliderOptionST(sn_InjuryDurationUClamp, lab_DurationUClamp, DAT_InjuryDurationUClamp.getValue(), fs_2PointSeconds)
	AddSliderOptionST(sn_InjuryDurationMean, lab_DurationMean, DAT_InjuryDurationMean.getValue(), fs_2PointSeconds)
	AddSliderOptionST(sn_InjuryDurationStdDev, lab_DurationStdDev, DAT_InjuryDurationStdDev.getValue(), fs_2PointSeconds)
	AddTextOptionST(sn_InjuryEvaluateClampPools, "", lab_EvaluateClampPools)
	AddTextOptionST(sn_InjuryLClampPool, lab_LClampPool, "")
	AddTextOptionST(sn_InjuryUClampPool, lab_UClampPool, "")
endFunction

function buildDeathPage()

endFunction

state TemplateStateCloneMe
	Event onHighlightST() ; text, toggles, sliders, menus, colors, keymaps, inputs
	endEvent
	Event onDefaultST() ; text, toggles, sliders, menus, colors, keymaps, inputs
	endEvent
	Event onSelectST() ; text, toggles
	endEvent
	Event onSliderOpenST() ; sliders
	endEvent
	Event onSliderAcceptST(float value) ; sliders
	endEvent
	Event onMenuOpenST() ; menus
	endEvent
	Event onMenuAcceptST(int index) ; menus
	endEvent
	Event onColorOpenST() ; colors
	endEvent
	Event onColorAcceptST(int color) ; colors
	endEvent
	Event onKeyMapChangeST(int keyCode, string conflictControl, string conflictName) ; keymaps
	endEvent
	Event onInputOpenST() ; inputs
	endEvent
	Event onInputAcceptST(string value) ; inputs
	endEvent
endState

state EnableInjury ; complete
	Event onHighlightST()
		setInfoText(info_EnableInjuryHandler)
	endEvent
	
	Event onDefaultST()
		globalsChanged = DAT_EnableInjuryHandler.getValue() == 1.0 || globalsChanged
		DAT_EnableInjuryHandler.setValue(1.0)
		setToggleOptionValueST(true)
	endEvent
	
	Event onSelectST()
		bool val = DAT_EnableInjuryHandler.getValue() as bool
		val = !val
		DAT_EnableInjuryHandler.setValue(val as float)
		setToggleOptionValueST(val)
		globalsChanged = true
	endEvent
endState

state InjuriesFlatThreshold ; complete
	Event onHighlightST()
		setInfoText(info_FlatThreshold)
	endEvent
	
	Event onDefaultST()
		globalsChanged = def_InjuriesFlatThreshold == DAT_InjuriesFlatThreshold.getValue() || globalsChanged
		DAT_InjuriesFlatThreshold.setValue(def_InjuriesFlatThreshold)
		setSliderOptionValueST(def_InjuriesFlatThreshold, fs_1PointPercent)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_InjuriesFlatThreshold.getValue() * 100.0)
		setSliderDialogDefaultValue(def_InjuriesFlatThreshold * 100.0)
		setSliderDialogRange(0.0, 100.0) ; pls do not actually do 0
		setSliderDialogInterval(0.1) 
	endEvent
	
	Event onSliderAcceptST(float value)
		float temp = value/100.0
		globalsChanged = temp == DAT_InjuriesFlatThreshold.getValue() || globalsChanged
		DAT_InjuriesFlatThreshold.setValue(temp)
		setSliderOptionValueST(value, fs_1PointPercent)
	endEvent
endState

state InjuryExplanation
	Event onSelectST()
		registerForKey(44) ; Z-key; will take literal out later.
		loadCustomContent("DAT/InjuryInfographic.dds", 1.0, 1.0)
	endEvent
endState

state BaseInjuryChance ; complete
	Event onHighlightST()
		setInfoText(info_BaseInjuryChance)
	endEvent
	
	Event onDefaultST()
		DAT_BaseInjuryChance.setValue(def_BaseInjuryChance)
		setSliderOptionValueST(def_BaseInjuryChance * 100.0, fs_1PointPercent)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_BaseInjuryChance.getValue() * 100.0)
		setSliderDialogDefaultValue(def_BaseInjuryChance * 100.0)
		setSliderDialogRange(0.0, 100.0) ; pls do not actually do 100
		setSliderDialogInterval(0.1) ; yeah it's gonna suck to have 1000 possible values, which is unfortunate
	endEvent
	
	Event onSliderAcceptST(float value)
		float temp = value/100.0
		globalsChanged = temp == DAT_BaseInjuryChance.getValue() || globalsChanged
		DAT_BaseInjuryChance.setValue(temp)
		SetSliderOptionValueST(value, fs_1PointPercent)
	endEvent
endState

state MaxInjuryChance ; complete
	Event onHighlightST()
		setInfoText(info_MaxInjuryChance)
	endEvent
	
	Event onDefaultST()
		DAT_MaxInjuryChance.setValue(def_MaxInjuryChance)
		setSliderOptionValueST(def_MaxInjuryChance * 100.0, fs_1PointPercent)	
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_MaxInjuryChance.getValue() * 100.0)
		setSliderDialogDefaultValue(def_MaxInjuryChance * 100.0)
		setSliderDialogRange(0.0, 100.0) ; pls do not actually do 0
		setSliderDialogInterval(0.1) 
	endEvent
	
	Event onSliderAcceptST(float value)
		float temp = value/100.0
		globalsChanged = temp == DAT_MaxInjuryChance.getValue() || globalsChanged
		DAT_MaxInjuryChance.setValue(temp)
		setSliderOptionValueST(value, fs_1PointPercent)
	endEvent
endState

state InjuryHealthExponent ; complete
	Event onHighlightST()
		setInfoText(info_InjuryHealthExponent)
	endEvent
	
	Event onDefaultST()
		DAT_InjuryHealthExponent.setValue(def_InjuryHealthExponent)
		setInputOptionValueST(StringUtil.substring(DAT_InjuryHealthExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_InjuryHealthExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(fvalue != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_InjuryHealthExponent.getValue() || globalsChanged
			DAT_InjuryHealthExponent.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_InjuryHealthExponent.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state InjuriesCoefficient ; complete
	Event onHighlightST()
		setInfoText(info_InjuriesCoefficient)
	endEvent
	
	Event onDefaultST()
		DAT_InjuriesCoefficient.setValue(def_InjuriesCoefficient)
		setInputOptionValueST(StringUtil.substring(DAT_InjuriesCoefficient.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_InjuriesCoefficient.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(fvalue != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_InjuriesCoefficient.getValue() || globalsChanged
			DAT_InjuriesCoefficient.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_InjuriesCoefficient.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state InjuriesExponent ; complete
	Event onHighlightST()
		setInfoText(info_InjuriesExponent)
	endEvent
	
	Event onDefaultST()
		DAT_InjuriesExponent.setValue(def_InjuriesExponent)
		setInputOptionValueST(StringUtil.substring(DAT_InjuriesCoefficient.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_InjuriesExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(value != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_InjuriesExponent.getValue() || globalsChanged
			DAT_InjuriesExponent.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_InjuriesExponent.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state InjuryDurationExplanation
	Event onSelectST()
	endEvent
endState

state InjuryDurationMean ; complete
	Event onHighlightST()
		setInfoText(info_DurationMean)
	endEvent
	
	Event onDefaultST()
		DAT_InjuryDurationMean.setValue(def_InjuryDurationMean)
		setSliderOptionValueST(def_InjuryDurationMean, fs_2PointSeconds)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_InjuryDurationMean.getValue())
		setSliderDialogDefaultValue(def_InjuryDurationMean)
		setSliderDialogRange(DAT_InjuryDurationLClamp.getValue(), DAT_InjuryDurationUClamp.getValue())
		setSliderDialogInterval(0.01) ; fewer due to bounds, but still many.
	endEvent
	
	Event onSliderAcceptST(float value)
		globalsChanged = value == DAT_InjuryDurationMean.getValue() || globalsChanged
		DAT_InjuryDurationMean.setValue(value)
		setSliderOptionValueST(value, fs_2PointSeconds)
	endEvent
endState

state InjuryDurationStdDev ; complete
	Event onHighlightST()
		setInfoText(info_DurationStdDev)
	endEvent
	
	Event onDefaultST()
		DAT_InjuryDurationStdDev.setValue(def_InjuryDurationStdDev)
		setSliderOptionValueST(def_InjuryDurationStdDev, fs_2PointSeconds)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_InjuryDurationStdDev.getValue())
		setSliderDialogDefaultValue(def_InjuryDurationStdDev)
		setSliderDialogRange(0.0, 40.0)
		setSliderDialogInterval(0.01)
	endEvent
	
	Event onSliderAcceptST(float value)
		globalsChanged = value == DAT_InjuryDurationStdDev.getValue() || globalsChanged
		DAT_InjuryDurationStdDev.setValue(value)
		setSliderOptionValueST(value, fs_2PointSeconds)
	endEvent
endState

state InjuryDurationLClamp ; complete
	Event onHighlightST()
		setInfoText(info_DurationLClamp)
	endEvent
	
	Event onDefaultST()
		DAT_InjuryDurationLClamp.setValue(def_InjuryDurationLClamp)
		setSliderOptionValueST(def_InjuryDurationLClamp, fs_2PointSeconds)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_InjuryDurationLClamp.getValue())
		setSliderDialogDefaultValue(def_InjuryDurationLClamp)
		setSliderDialogRange(0.0, 120.0)
		setSliderDialogInterval(0.01) ; up to 10,000 now. use a mouse for your own sake.
	endEvent
	
	Event onSliderAcceptST(float value)
		globalsChanged = value == DAT_InjuryDurationLClamp.getValue() || globalsChanged
		DAT_InjuryDurationLClamp.setValue(value)
		setSliderOptionValueST(value, fs_2PointSeconds)
	endEvent
endState

state InjuryDurationUClamp ; complete
	Event onHighlightST()
		setInfoText(info_DurationUClamp)
	endEvent
	
	Event onDefaultST()
		DAT_InjuryDurationUClamp.setValue(def_InjuryDurationUClamp)
		setSliderOptionValueST(def_InjuryDurationUClamp, fs_2PointSeconds)	
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_InjuryDurationUClamp.getValue())
		setSliderDialogDefaultValue(def_InjuryDurationUClamp)
		setSliderDialogRange(0.0, 120.0)
		setSliderDialogInterval(0.01) ; up to 10,000 now. use a mouse for your own sake.
	endEvent
	
	Event onSliderAcceptST(float value)
		globalsChanged = value == DAT_InjuryDurationUClamp.getValue() || globalsChanged
		DAT_InjuryDurationUClamp.setValue(value)
		setSliderOptionValueST(value, fs_2PointSeconds)
	endEvent
endState

state CrippleExplanation
	Event onSelectST()
	endEvent
endState

state CrippleBaseChance ; complete
	Event onHighlightST()
		setInfoText(info_CrippleBaseChance)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleBaseChance.setValue(def_CrippleBaseChance)
		setSliderOptionValueST(def_CrippleBaseChance * 100.0, fs_1PointPercent)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_CrippleBaseChance.getValue() * 100.0)
		setSliderDialogDefaultValue(def_CrippleBaseChance * 100.0)
		setSliderDialogRange(0.0, 100.0) ; pls do not actually do 100
		setSliderDialogInterval(0.1) ; yeah it's gonna suck to have 1000 possible values, which is unfortunate
	endEvent
	
	Event onSliderAcceptST(float value)
		float temp = value/100.0
		DAT_CrippleBaseChance.setValue(temp)
		globalsChanged = temp == DAT_CrippleBaseChance.getValue() || globalsChanged
		setSliderOptionValueST(value, fs_1PointPercent)
	endEvent
endState

state CrippleChanceCoefficient ; complete
	Event onHighlightST()
		setInfoText(info_CrippleChanceCoefficient)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleChanceCoefficient.setValue(def_CrippleChanceCoefficient)
		setSliderOptionValueST(def_CrippleChanceCoefficient * 100.0, fs_1PointPercent)
	endEvent
	
	Event onSliderOpenST()
		setSliderDialogStartValue(DAT_CrippleChanceCoefficient.getValue() * 100.0)
		setSliderDialogDefaultValue(def_CrippleChanceCoefficient * 100.0)
		setSliderDialogRange(0.0, 100.0) ; pls do not actually do 100
		setSliderDialogInterval(0.1) ; yeah it's gonna suck to have 1000 possible values, which is unfortunate
	endEvent
	
	Event onSliderAcceptST(float value)
		float temp = value/100.0
		globalsChanged = temp == DAT_CrippleChanceCoefficient.getValue() || globalsChanged
		DAT_CrippleChanceCoefficient.setValue(temp)
		setSliderOptionValueST(value, fs_1PointPercent)
	endEvent
endState

state CrippleHealthExponent ; complete
	Event onHighlightST()
		setInfoText(info_CrippleHealthExponent)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleHealthExponent.setValue(def_CrippleHealthExponent)
		setInputOptionValueST(StringUtil.substring(DAT_CrippleHealthExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_CrippleHealthExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(value != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_CrippleHealthExponent.getValue() || globalsChanged
			DAT_CrippleHealthExponent.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_CrippleHealthExponent.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state CrippleInjuriesCoefficient ; complete
	Event onHighlightST()
		setInfoText(info_CrippleInjuriesCoefficient)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleInjuriesCoefficient.setValue(def_CrippleInjuriesCoefficient)
		setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesCoefficient.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_CrippleInjuriesCoefficient.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(value != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_CrippleInjuriesCoefficient.getValue() || globalsChanged
			DAT_CrippleInjuriesCoefficient.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesCoefficient.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state CrippleInjuriesOffset ; complete
	Event onHighlightST()
		setInfoText(info_CrippleInjuriesOffset)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleInjuriesOffset.setValue(def_CrippleInjuriesOffset)
		setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesOffset.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_CrippleInjuriesOffset.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(value != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_CrippleInjuriesOffset.getValue() || globalsChanged
			DAT_CrippleInjuriesOffset.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesOffset.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state CrippleInjuriesExponent ; complete
	Event onHighlightST()
		setInfoText(info_CrippleInjuriesExponent)
	endEvent
	
	Event onDefaultST()
		DAT_CrippleInjuriesOffset.setValue(def_CrippleInjuriesExponent)
		setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputOpenST()
		setInputDialogStartText(StringUtil.substring(DAT_CrippleInjuriesExponent.getValue() as string, 0, 3))
	endEvent
	
	Event onInputAcceptST(string value)
		float fvalue = value as float
		if(value != 0.0 || value == "0")
			globalsChanged = fvalue == DAT_CrippleInjuriesExponent.getValue() || globalsChanged
			DAT_CrippleInjuriesExponent.setValue(fvalue)
			setInputOptionValueST(StringUtil.substring(DAT_CrippleInjuriesExponent.getValue() as string, 0, 3))
		endIf
	endEvent
endState

state InjuryEvaluateClampPools ; complete
	Event onHighlightST()
		setInfoText(info_EvaluateInjuryClampPools)
	endEvent
	Event onDefaultST()
	endEvent
	Event onSelectST()
		float lowerPool = MLQ_NormalDistribution.evaluateLowerClampPool(DAT_InjuryDurationMean.getValue(), DAT_InjuryDurationStdDev.getValue(), DAT_InjuryDurationLClamp.getValue()) * 100.0
		string valLower = StringUtil.substring(lowerPool as string, 0, 3) + "%"
		float upperPool = MLQ_NormalDistribution.evaluateUpperClampPool(DAT_InjuryDurationMean.getValue(), DAT_InjuryDurationStdDev.getValue(), DAT_InjuryDurationUClamp.getValue()) * 100.0
		string valUpper = StringUtil.substring(upperPool as string, 0, 3) + "%"
		setTextOptionValueST(valLower, false, sn_InjuryLClampPool)
		setTextOptionValueST(valUpper, false, sn_InjuryUClampPool)
	endEvent
endState

state InjuryLClampPool
	Event onHighlightST()
	endEvent
	Event onDefaultST()
	endEvent
	Event onSelectST()
	endEvent
endState

state InjuryUClampPool
	Event onHighlightST()
	endEvent
	Event onDefaultST()
	endEvent
	Event onSelectST()
	endEvent
endState

state EnableForceKills ; complete
	Event onHighlightST()
		setInfoText(info_EnableForceKills)
	endEvent
	
	Event onDefaultST()
		globalsChanged = DAT_EnableForceKills.getValue() == (def_EnableForceKills as float) || globalsChanged
		DAT_EnableForceKills.setValue(def_EnableForceKills as float)
		setMenuOptionValueST(ForceKillOptions[def_EnableForceKills])
	endEvent
	
	Event onMenuOpenST()
		setMenuDialogStartIndex(DAT_EnableForceKills.getValue() as int)
		setMenuDialogDefaultIndex(def_EnableForceKills)
		setMenuDialogOptions(forceKillOptions)
	endEvent
	
	Event onMenuAcceptST(int index)
		globalsChanged = DAT_EnableForceKills.getValue() == (index as float) || globalsChanged
		DAT_EnableForceKills.setValue(index as float)
		setMenuOptionValueST(ForceKillOptions[index])
	endEvent
endState

state EnableDeathOverride ; complete
	Event onHighlightST()
		setInfoText(info_EnableDeathSequenceOverride)
	endEvent
	
	Event onDefaultST()
		globalsChanged = DAT_EnableDeathSequenceOverride.getValue() == (def_EnableDeathSequenceOverride as float) || globalsChanged
		DAT_EnableDeathSequenceOverride.setValue(def_EnableDeathSequenceOverride as float)
		setToggleOptionValueST(def_EnableDeathSequenceOverride)
	endEvent
	
	Event onSelectST()
		globalsChanged = true
		bool val = DAT_EnableDeathSequenceOverride.getValue() as bool
		val = !val
		DAT_EnableDeathSequenceOverride.setValue(val as float)
		setToggleOptionValueST(val)
	endEvent
endState

function advanceCustomContent()
	unloadCustomContent()
	unregisterForKey(44)
endFunction

function castGlobalRecache()
	if(globalsChanged)
		((self as Quest) as DAT_BackgroundUtilityQuest).castGlobalRecache()
		globalsChanged = false
	endIf
endFunction
