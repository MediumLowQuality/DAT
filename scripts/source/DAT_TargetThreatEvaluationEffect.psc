scriptname DAT_TargetThreatEvaluationEffect extends activemagiceffect

Actor myself
Actor trackingActor

float totalDamage
int totalHits
float averageDamage

float threat

string property DamageTrackerAV Auto
string property ThreatAV Auto

MagicEffect Property UpdateDamageDoneEffect Auto
MagicEffect Property PingBackMyThreatEffect Auto

Spell Property PingBackMyThreatSpell Auto

Event onEffectStart(Actor akTarget, Actor akCaster)
	myself = akTarget
	trackingActor = akCaster
endEvent

Event onMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if(akCaster as Actor = trackingActor)
		if(akEffect == UpdateDamageDoneEffect)
			totalDamage += myself.getActorValue(DamageTrackerAV)
			totalHits += 1
			averageDamage = totalDamage/totalHits
			myself.setActorValue(DamageTrackerAV, 0)
		elseif(akEffect == PingBackMyThreatEffect)
			;evaluate threat
			
			;send threat
			myself.setActorValue(ThreatAV, threat)
			PingBackMyThreatEffect.cast()
		endIf
	endIf
endEvent