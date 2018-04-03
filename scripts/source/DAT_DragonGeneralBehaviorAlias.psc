scriptname DAT_DragonGeneralBehaviorAlias extends ReferenceAlias

ReferenceAlias Property WaypointRef Auto
ReferenceAlias Property TargetRef Auto
ReferenceAlias Property LeaderRef Auto

Actor Property PlayerRef Auto

Actor myself

; globals and local copies for settings
GlobalVariable Property glob_EnableForceKills Auto
GlobalVariable Property glob_EnableDeathSequenceOverride Auto
GlobalVariable Property glob_EnableStaggerSystem Auto
GlobalVariable Property glob_LiveUpdateRate Auto
GlobalVariable Property glob_DeathUpdateRate Auto
GlobalVariable Property glob_DeathFXRange Auto
GlobalVariable Property glob_DeathForceKillThreshold Auto
int                     i_ForceKillsEnabled
bool                    b_EnableDeathSequenceOverride
bool                    b_EnableStaggerSystem
float                   f_LiveUpdateRate
float                   f_DeathUpdateRate
float                   f_DeathFXRange
float                   f_DeathForceKillThreshold

;variables and properties for death system
float healthPercent
int airKills = 1
int groundKills = 2
Static Property XMarker Auto
ObjectReference NodeMarker ; after being Havoked, the coordinates will be off. So we use this.
MQKillDragonScript Property KillDragonScript Auto
bool MiraakAppeared
Location Property DLC2ApocryphaLocation Auto
WorldSpace Property DLC2ApocryphaWorld auto
Spell Property onDeathPingAbsorbers Auto
MagicEffect Property PingbackEffect Auto
DAT_BackgroundUtilityQuest Property HandlerQuest Auto
FormList Property potentialActors Auto
Actor closestAbsorbingActor
float minDistance

Event onInit()
	myself = getReference() as Actor
	closestAbsorbingActor = None
	healthPercent = 1.0
	recacheGlobals()
	registerAnimations()
	registerForSingleUpdate(f_LiveUpdateRate)
	goToState("Alive")
	Debug.notification("onInit fired")
	Debug.notification("Alias captured to ObjRef: " + myself.getLeveledActorBase().getName())
	Debug.notification("We have the node NPC Head: " + myself.hasNode("NPC Head"))
endEvent

state Alive
	Event onDying(Actor akKiller)
		Debug.notification("onDying fired")
		if(b_EnableDeathSequenceOverride)
			;suppress default death sequence
			(myself as DragonActorScript).goToState("deadDisintegrated")
			Debug.notification("DragonActorScript state: "+ (myself as DragonActorScript).getState())
			goToState("DeadWaiting")
		else
			goToState("DeadComplete")
		endIf
	endEvent
	
	Event onHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		healthPercent = myself.getActorValuePercentage("Health")
		if (i_ForceKillsEnabled > 0 && healthPercent < f_DeathForceKillThreshold)
			if((i_ForceKillsEnabled == airKills || i_ForceKillsEnabled == airKills + groundKills) && myself.getFlyingState() > 0)
				forceKill(akAggressor as Actor, true)  ; dynamic is true because the dragon is flying in this case
			elseif((i_ForceKillsEnabled == groundKills || i_ForceKillsEnabled == airKills + groundKills) && myself.getFlyingState() == 0)
				forceKill(akAggressor as Actor, false) ; dynamic is false because the dragon is already on the ground
			endIf
		endIf
	endEvent
	
	Event onUpdate()
		registerForSingleUpdate(f_LiveUpdateRate); someday I imagine Papyrus will cure me of the good habit of ending lines with semicolons, and I'll hate going back to a language that needs that.
	endEvent
	
	Event onAnimationEvent(ObjectReference akSource, string asEventName)

	endEvent
endState

state DeadWaiting
	Event onBeginState()
		Debug.notification("in state DeadWaiting")
		; soul-taker code copied from dragonActorScript to handle the cases we don't care about, since we're preventing this code from running in dragonActorScript
		if DLC2ApocryphaLocation && DLC2ApocryphaWorld && (PlayerRef.isInLocation(DLC2ApocryphaLocation) || PlayerRef.getWorldSpace() == DLC2ApocryphaWorld)
			gotoState("DeadComplete")
			KillDragonScript.deathSequence(myself)
		elseif KillDragonScript.ShouldMiraakAppear(myself) && !MiraakAppeared
			gotoState("DeadComplete")
; 			Debug.Trace(self + "MiraakAppears")
			MiraakAppeared = true
			KillDragonScript.deathSequence(myself, MiraakAppears = true)
		else
			Debug.notification("doing new behavior")
			;NEW BEHAVIOR HERE
			potentialActors = HandlerQuest.requestFormList(myself)
			minDistance = f_DeathFXRange
			NodeMarker = myself.placeAtMe(XMarker)
			NodeMarker.moveToNode(myself, "NPC Head")
			Debug.notification("casting ping absorbers")
			onDeathPingAbsorbers.cast(myself)
			RegisterForSingleUpdate(f_DeathUpdateRate)
		endIf
	endEvent
	
	Event onUpdate()
		Debug.notification("Update.")
		if(potentialActors.getSize() > 0)
			findClosestAbsorbingActor()
			Debug.notification("Closest actor is " + closestAbsorbingActor.getLeveledActorBase().getName())
			KillDragonScript.deathSequence(myself, closestAbsorbingActor)
			if(closestAbsorbingActor != PlayerRef)
				closestAbsorbingActor.modActorValue("DragonSouls", 1.0) ; player will naturally have souls incremented from sequence. other dragons get their counter incremented here.
			endIf
			closestAbsorbingActor.modActorValue("DragonSouls", myself.getActorValue("DragonSouls")) ; absorb any dragon souls this dragon absorbed
			closestAbsorbingActor = None ; you know in case we do some resurrection shenanigans in the future and have to deal with this again
			potentialActors.revert()
			HandlerQuest.releaseFormList(potentialActors)
			goToState("DeadComplete")
		else			
			NodeMarker.moveToNode(myself, "NPC Head")
			onDeathPingAbsorbers.cast(myself)
			RegisterForSingleUpdate(f_DeathUpdateRate)
		endIf
	endEvent
	
	Event onMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect) ; this event used to catch the pingback spell, cast by actors the detector hits who are dragons/the player
		if(akEffect == PingbackEffect)
			onDeathPingBack(akCaster as Actor)
		endIf
	endEvent
endState

state DeadComplete
	; at this time, empty state
	; may eventually want to handle quest cleanup in here and releasing various variables
endState

; Utility Functions
; getVelocity()
; getSpeed()
; forceKill()
; onDeathPingBack()
; findClosestAbsorbingActor()
; recacheGlobals()
; registerAnimations()

float[] function getVelocity()
{returns velocity in form of direction components and magnitude}
	float x1 = myself.getPositionX()
	float y1 = myself.getPositionY()
	float z1 = myself.getPositionZ()
	float t1 = Utility.getCurrentRealTime()
	Utility.wait(0.1)
	float x2 = myself.getPositionX()
	float y2 = myself.getPositionY()
	float z2 = myself.getPositionZ()
	float t2 = Utility.getCurrentRealTime()
	float dx = x2 - x1
	float dy = y2 - y1
	float dz = z2 - z1
	float dt = t2 - t1
	float vx = dx/dt
	float vy = dy/dt
	float vz = dz/dt
	float mag = Math.sqrt(vx*vx + vy*vy + vz*vz)
	float[] v = new float[4]
	v[0] = vx/mag
	v[1] = vy/mag
	v[2] = vz/mag
	v[3] = mag
endFunction

float function getSpeed()
{returns speed as a scalar. no direction}
	float x1 = myself.getPositionX()
	float y1 = myself.getPositionY()
	float z1 = myself.getPositionZ()
	float t1 = Utility.getCurrentRealTime()
	Utility.wait(0.1)
	float x2 = myself.getPositionX()
	float y2 = myself.getPositionY()
	float z2 = myself.getPositionZ()
	float t2 = Utility.getCurrentRealTime()
	float dx = x2 - x1
	float dy = y2 - y1
	float dz = z2 - z1
	float dt = t2 - t1
	float vt = Math.sqrt(dx*dx + dy*dy + dz*dz)/dt ; vt here is velocity tangential; i may have technically lied about no direction, but vt is just speed in the direction of the path traveled so kind of no direction
	return vt
endFunction

function forceKill(Actor killer = None, bool dynamic = false)
{kills this dragon. if dynamic = true, applies an impulse to the dragon so that it follows the same path}
	Debug.notification("forceKill began")
	float[] v;
	if dynamic
		v = getVelocity()
	endIf
	myself.forceActorValue("Health", 0.0)
	Debug.notification("Health forced to 0")
	myself.startDeferredKill()
	Debug.notification("Deferred kill started")
	myself.endDeferredKill()
	Debug.sendAnimationEvent(myself, "RagdollInstant")
	if dynamic
		myself.applyHavokImpulse(v[0], v[1], v[2], v[3]*myself.getMass())
	endIf
	Debug.notification("forceKill completed")
endFunction

function onDeathPingBack(Actor callingActor)
{Function called when hit with the pingback effect after pinging actors on death. Adds the actor to a formlist; the old approach was not even a little bit threadsafe. FormList can be evaluated sequentially regardless of timing received.}
	float callingDist = NodeMarker.getDistance(callingActor)
	if (!potentialActors.hasForm(callingActor))
		potentialActors.addForm(callingActor)
	endIf
endFunction

function findClosestAbsorbingActor()
	float minDist = f_DeathFXRange + 1.0
	int i = 1
	int j = potentialActors.getSize() - i ; going down to avoid skipping anyone, since additions are made at position 0
	while j >= 0                          ; worst case like this: an actor is evaluated twice, which will be sub-ideal, but not that bad
		j = potentialActors.getSize() - i
		Actor a = potentialActors.getAt(j) as Actor
		float dist = NodeMarker.getDistance(a)
		if(dist < minDist)
			minDist = dist
			closestAbsorbingActor = a
		endIf
		i += 1
	endWhile
endFunction

function recacheGlobals()
	i_ForceKillsEnabled           = glob_EnableForceKills.getValue() as int
	b_EnableDeathSequenceOverride = glob_EnableDeathSequenceOverride.getValue() > 0;
	b_EnableStaggerSystem         = glob_EnableStaggerSystem.getValue() > 0;
	f_LiveUpdateRate              = glob_LiveUpdateRate.getValue()
	f_DeathUpdateRate             = glob_DeathUpdateRate.getValue()
	f_DeathFXRange                = glob_DeathFXRange.getValue()
	f_DeathForceKillThreshold     = glob_DeathForceKillThreshold.getValue()
endFunction

function registerAnimations()
	registerForAnimationEvent(myself, "Injurestart")
endFunction
