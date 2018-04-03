scriptname DAT_InjuryControllerAlias extends ReferenceAlias

ReferenceAlias Property WaypointRef Auto
ReferenceAlias Property TargetRef Auto
ReferenceAlias Property LeaderRef Auto

Actor Property PlayerRef Auto

Actor myself

; globals and local copies for settings
GlobalVariable Property glob_EnableInjuryHandler Auto
GlobalVariable Property glob_LiveUpdateRate Auto
GlobalVariable Property glob_BaseInjuryChance Auto
GlobalVariable Property glob_MaxInjuryChance Auto
GlobalVariable Property glob_InjuryHealthExponent Auto
GlobalVariable Property glob_InjuriesCoefficient Auto
GlobalVariable Property glob_InjuriesExponent Auto
GlobalVariable Property glob_InjuryDurationMean Auto
GlobalVariable Property glob_InjuryDurationStdDev Auto
GlobalVariable Property glob_InjuryDurationLClamp Auto
GlobalVariable Property glob_InjuryDurationUClamp Auto
GlobalVariable Property glob_CrippleBaseChance Auto
GlobalVariable Property glob_CrippleChanceCoefficient Auto
GlobalVariable Property glob_CrippleHealthExponent Auto
GlobalVariable Property glob_CrippleInjuriesCoefficient Auto
GlobalVariable Property glob_CrippleInjuriesOffset Auto
GlobalVariable Property glob_CrippleInjuriesExponent Auto
GlobalVariable Property glob_InjuriesFlatThreshold Auto
bool                    b_EnableInjuryHandler
float                   f_LiveUpdateRate
float                   f_BaseInjuryChance
float                   f_MaxInjuryChance
float                   f_InjuryHealthExponent
float                   f_InjuriesCoefficient
float                   f_InjuryDurationMean
float                   f_InjuryDurationStdDev
float                   f_InjuryDurationLClamp
float                   f_InjuryDurationUClamp
float                   f_InjuriesExponent
float                   f_CrippleBaseChance
float                   f_CrippleChanceCoefficient
float                   f_CrippleHealthExponent
float                   f_CrippleInjuriesCoefficient
float                   f_CrippleInjuriesOffset
float                   f_CrippleInjuriesExponent
float                   f_InjuriesFlatThreshold

;variables for injury system
float healthPercent
int totalInjuries
bool injured
float injuryDuration
float injuryWearoffTime
bool timerStarted
bool crippled
Spell Property InjuredNoFlyAbility Auto

Event onInit()
	myself = getReference() as Actor
	healthPercent = 1.0
	totalInjuries = 0
	injured = false
	crippled = false
	injuryWearoffTime = 0.0
	timerStarted = false
	recacheGlobals()
	if(b_EnableInjuryHandler)
		goToState("Active")
	else
		goToState("Inactive")
	endIf
endEvent

state Inactive
	Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		healthPercent = myself.getActorValuePercentage("Health")
		if(!injured && healthPercent <= f_InjuriesFlatThreshold)
			injureMe()
		endIf
	endEvent
	
	Event onUpdate()
		if(injured && healthPercent > f_InjuriesFlatThreshold) ; the case where we are using vanilla injuries and we are injured and the dragon has healed over his threshold
			myself.removeSpell(InjuredNoFlyAbility) ; see look at how clean and not "override everything ever" this system is compared to vanilla injuries and DCO's random setAllowFlying(). anybody can change it, but only intentionally. it's beautiful.
		endIf
		registerForSingleUpdate(f_LiveUpdateRate); someday I imagine Papyrus will cure me of the good habit of ending lines with semicolons, and I'll hate going back to a language that needs that.
	endEvent
endState

state Active
	Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		healthPercent = myself.getActorValuePercentage("Health")
		if (!injured && !crippled)
			float injuryChance = ((f_MaxInjuryChance - f_BaseInjuryChance)*Math.pow(1.0 - healthPercent, f_InjuryHealthExponent)+f_BaseInjuryChance)/Math.pow(1.0 + totalInjuries * f_InjuriesCoefficient, f_InjuriesExponent)
			Debug.notification("Injury chance: " + injuryChance)
			float injuryRoll = Utility.randomFloat();
			Debug.notification("Injury roll: " + injuryRoll)
			if(injuryRoll <= injuryChance)
				Debug.notification("Injury roll succeeded. Injuring.")
				injureMe()
			endIf
		endIf
	endEvent
	
	Event onUpdate() ; theoretically, this should only fire when the dragon is injured; we only register in injureMe(), and we only re-register when not removing the update
		float now = Utility.getCurrentRealTime()
		if(!timerStarted)
			timerStarted = myself.getFlyingState() > 0 ; you know this is way easier than catching anim events although the update rate may be sub-bueno for this being reactive; another reason to optimize the onUpdate loop so you can update more
			injuryWearoffTime = now + injuryDuration
		elseif(!crippled && injured) ; by the power of elseif, we won't even evaluate if the injury could have worn off until we've started the timer for it
			Debug.notification("Checking injury wear off")
			if now > injuryWearoffTime
				Debug.notification("Injury wore off. Flying is allowed.")
				myself.removeSpell(InjuredNoFlyAbility)
				injured = false
				timerStarted = false
				return ; in this branch, to avoid shitting up the engine with unnecessary onUpdate events, we exit the event before registering for the next update, to break the onUpdate loop
			endIf
		endIf
		registerForSingleUpdate(f_LiveUpdateRate); someday I imagine Papyrus will cure me of the good habit of ending lines with semicolons, and I'll hate going back to a language that needs that.
	endEvent
endState

;utility functions
; injureMe()
; recacheGlobals()

function injureMe() ; please don't make the name weird
	injured = true ; internal bookkeeping
	totalInjuries += 1
	myself.addSpell(InjuredNoFlyAbility) ; the big thing really
	debug.sendAnimationEvent(myself, "Injurestart")
	Debug.notification("Injured. Rolling for crippled...")
	float crippleChance = f_CrippleChanceCoefficient*Math.pow(1.0 - healthPercent, f_CrippleHealthExponent)*Math.pow(f_CrippleInjuriesCoefficient * totalInjuries + f_CrippleInjuriesOffset, f_CrippleInjuriesExponent) + f_CrippleBaseChance
	Debug.notification("Cripple chance: " + crippleChance)
	float crippleRoll = Utility.randomFloat()
	if(crippleRoll <= crippleChance)
		Debug.notification("Cripple roll succeeded. Crippling.")
		crippled = true
	else
		float now = Utility.getCurrentRealTime()
		injuryDuration =  MLQ_NormalDistribution.random(mean = f_InjuryDurationMean, stdDev = f_InjuryDurationStdDev, usingClamps = true, lowerClamp = f_InjuryDurationLClamp, upperClamp = f_InjuryDurationUClamp)
		Debug.notification("Cripple roll failed; injury wears off in " + injuryDuration + " seconds")
		;after this, we should catch the landing anim event, then set timerStarted to true and the injuryWearoffTime to when event time plus the duration
		registerForSingleUpdate(f_LiveUpdateRate)
	endIf
endFunction

function recacheGlobals()
	b_EnableInjuryHandler         = glob_EnableInjuryHandler.getValue() > 0;
	f_LiveUpdateRate              = glob_LiveUpdateRate.getValue()
	f_BaseInjuryChance            = glob_BaseInjuryChance.getValue()
	f_MaxInjuryChance             = glob_MaxInjuryChance.getValue()
	f_InjuryHealthExponent        = glob_InjuryHealthExponent.getValue()
	f_InjuriesCoefficient         = glob_InjuriesCoefficient.getValue()
	f_InjuriesExponent            = glob_InjuriesExponent.getValue()
	f_InjuryDurationMean          = glob_InjuryDurationMean.getValue()
	f_InjuryDurationStdDev        = glob_InjuryDurationStdDev.getValue()
	f_InjuryDurationLClamp        = glob_InjuryDurationLClamp.getValue()
	f_InjuryDurationUClamp        = glob_InjuryDurationUClamp.getValue()
	f_CrippleBaseChance           = glob_CrippleBaseChance.getValue()
	f_CrippleBaseChance           = glob_CrippleChanceCoefficient.getValue()
	f_CrippleChanceCoefficient    = glob_CrippleHealthExponent.getValue()
	f_CrippleHealthExponent       = glob_CrippleInjuriesCoefficient.getValue()
	f_CrippleInjuriesCoefficient  = glob_CrippleInjuriesOffset.getValue()
	f_CrippleInjuriesOffset       = glob_CrippleInjuriesOffset.getValue()
	f_CrippleInjuriesExponent     = glob_CrippleInjuriesExponent.getValue()
	f_InjuriesFlatThreshold       = glob_InjuriesFlatThreshold.getValue()
endFunction