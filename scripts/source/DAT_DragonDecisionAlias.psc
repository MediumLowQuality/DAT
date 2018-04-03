scriptname DAT_DragonDecisionAlias extends ReferenceAlias

ReferenceAlias Property WaypointRef Auto
ReferenceAlias Property TargetRef Auto
ReferenceAlias Property LeaderRef Auto

Actor myself
float health

Spell Property Dragonrend1 Auto
Spell Property Dragonrend2 Auto
Spell Property Dragonrend3 Auto

; enemy values to track
FormList Property TargetList Auto
int property usingFormList Auto
float[] totalDamage
int[] totalHits
bool[] knowsAboutDragonrend ; to clarify, this will only be true if the dragon knows the actor has dragonrend; if the player has but doesn't use Dragonrend, dragon is not going to just magically know
float averageDamageWeight
float totalDamageWeight
float undetectedThreatReduction
float DragonrendThreatBase
float DragonrendThreatMult

Event onInit()
	goToState("Inactive")
endEvent

state Inactive

endState

state Active

	Event onUpdate()
		
	endEvent

	Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		float damage = health - myself.getActorValue("Health")
		health = myself.getActorValue("Health")
		int listIndex = TargetList.find(akAggressor)
		if(listIndex == -1)
			; if the aggressor is not in our targetList, add him to it
			TargetList.addForm(akAggressor)
			listIndex = 0 ; added forms are at 0, which is frustrating because it leads to the conversion necessitated below
			totalDamage[arrayIndex(listIndex)] = 0.0
			totalHits[arrayIndex(listIndex)] = 0
		endIf
		int index = arrayIndex(listIndex)
		if(damage > 0)
			totalDamage[index] = totalDamage[index] + damage ; i'm really glad += doesn't work with arrays. that would be just too convenient
			totalHits[index] = totalHits[index] + 1
		endIf
		Spell sourceSpell = akSource as Spell
		if(sourceSpell && (sourceSpell == Dragonrend1 || sourceSpell == Dragonrend2 || sourceSpell == Dragonrend3))
			knowsAboutDragonrend[index] = true
		endIf
	endEvent
	
endState

; Utility Functions
function initialize()
	myself = getReference() as Actor
	health = myself.getActorValue("Health")
	registerForSingleUpdate(5.0)
	totalDamage = new float[128]
	totalHits = new int[128]
	knowsAboutDragonrend = new bool[128]
endFunction

function requestFormList()
	;TargetList = HandlerQuest.requestFormList(self)
endFunction
function releaseFormList()
	TargetList.revert()
	;HandlerQuest.releaseFormList(self)
endFunction

int function arrayIndex(int listIndex)
	; because forms are added to form lists at index 0, convert to array indices
	int size = TargetList.getSize()
	int index = size - listIndex - 1
	return index
	; try to deprecate this function once the remainder of the script is complete
endFunction

function selectTarget()
	if(LeaderRef.getReference())
		ReferenceAlias target = (LeaderRef as DAT_DragonDecisionAlias).TargetRef
		TargetRef.forceRefTo(target.getReference())
	else
		bool onGround = myself.getFlyingState() == 0
		float maxThreat = 0
		Actor target = TargetRef.getReference() as Actor
		int i = 0
		while i < TargetList.getSize()
			Actor a = targetList.getAt(i) as Actor
			int rEquip = a.getEquippedItemType(1)
			int lEquip = a.getEquippedItemType(0)
			int index = arrayIndex(i)
			float myTotalDamage = totalDamage[index]
			float averageDamage = myTotalDamage/totalHits[index]
			bool canRanged = rEquip >= 7 || lEquip == 8 || lEquip == 9 ; 7: bow, 8: staff, 9: spell, 10: shield, 11: torch, 12: crossbow. only 8 and 9 can be ranged and in the left hand;
			float canHit = (onGround || canRanged) as float
			float mult = 1.0
			if(!a.isDetectedBy(myself))
				mult *= undetectedThreatReduction
			endIf
			mult *= (knowsAboutDragonrend[index] as float)*DragonrendThreatMult
			float threat = mult * (averageDamage*canHit*averageDamageWeight + myTotalDamage*totalDamageWeight + DragonrendThreatBase)
			if(threat > maxThreat)
				maxThreat = threat
				target = a
			endIf
		endWhile
		TargetRef.forceRefTo(target)
	endIf
endFunction