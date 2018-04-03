scriptname DAT_BackgroundUtilityQuest extends Quest

ReferenceAlias Property PlayerAlias Auto

; for formList distribution
FormList Property MetaList Auto
Actor[] FormListUsers

; for global recaching
FormList Property ActiveActors Auto
Spell Property RecacheGlobalsSpell Auto


; for traits
FormList Property FireAffinity Auto
FormList Property FireTraits Auto
FormList Property IceAffinity Auto
FormList Property IceTraits Auto
FormList Property BruteAffinity Auto
FormList Property BruteTraits Auto
FormList Property TongueAffinity Auto
FormList Property TongueTraits Auto
FormList Property EarthAffinity Auto
FormList Property EarthTraits Auto
FormList Property OblivionAffinity Auto
FormList Property OblivionTraits Auto

Event onInit()
	FormListUsers = new Actor[128]
endEvent

FormList function requestFormList(Actor requester)
{simulates creating a new form list by handing out the first empty form list in the meta list that isn't currently in use}
	int i = 0
	Actor a = requester
	while i < 128 && a ; find an unused FormList
		a = FormListUsers[i]
		i += 1
	endWhile
	i -= 1; last time through the loop will still trigger i += 1 line; would prefer if --i was a thing but you take what you can get
	FormListUsers[i] = requester
	return MetaList.getAt(i) as FormList
endFunction

function releaseFormList(FormList usedList)
{releases the formlist; should be called when actor is done with the list, otherwise used form lists will increase over time}
	usedList.revert() ; in case our last user didn't clean it out
	int i = MetaList.find(usedList)
	FormListUsers[i] = None
endFunction

function castGlobalRecache()
{has the player reference cast a spell on actors; aliases will update their local copies of global values when actor is hit by the spell}
	int i = 1
	int j = 1
	Actor PlayerRef = PlayerAlias.getReference() as Actor
	while j >= 0
		j = ActiveActors.getSize() - i
		Actor a = ActiveActors.getAt(j) as Actor
		RecacheGlobalsSpell.cast(PlayerRef, a)
		i += 1
	endWhile
endFunction

function assignTraits(Actor dragon, FormList traitsList, int elementalAffinity, int bruteTongueAffinity, int earthOblivionAffinity)
	FormList temp = requestFormList(dragon)
	; identify dragon's element
	; for each affinity:
	;	add affinity trait to traitsList
	; 	clone all eligible traits to temp
	; 	for each affinity level:
	; 		roll random index; get ability at index from temp, add to traits list, remove from temp
	;  that's basically it
	releaseFormList(temp)
endFunction 