Scriptname DAT_AreaSoulPingEffectScript extends activemagiceffect  

Spell Property CounterPing Auto
Keyword Property ActorTypeDragon Auto
Actor Property PlayerRef Auto

Event onEffectStart(Actor akTarget, Actor akCaster)
	; to avoid SKSE for something trivial, we need to call a function on akCaster that passes back this object
	; the problem is that the function we really want is tied to an alias, not the actor, so casting is pretty much right out
	; so we fire a spell back, so that akCaster gets an event like this to evaluate the actor
	
	if (akTarget != akCaster && (akTarget.hasKeyword(ActorTypeDragon) || akTarget == PlayerRef))
		Debug.notification(akCaster.getLeveledActorBase().getName() + " pinged " + akTarget.getLeveledActorBase().getName() + ". Counterpinging...")
		CounterPing.cast(akTarget, akCaster)
	endIf
endEvent