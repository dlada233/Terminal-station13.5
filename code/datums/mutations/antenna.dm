/datum/mutation/human/antenna
	name = "天线"
	desc = "受影响者身上长出了一根天线，普遍认为这使他们能被动访问公共无线电频道."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You feel an antenna sprout from your forehead.</span>"
	text_lose_indication = "<span class='notice'>Your antenna shrinks back down.</span>"
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 8
	var/datum/weakref/radio_weakref

/obj/item/implant/radio/antenna
	name = "内部天线器官"
	desc = "内部的天线器官，科学界还没有给它起一个好名字."
	icon = 'icons/obj/devices/voice.dmi'//maybe make a unique sprite later. not important
	icon_state = "walkietalkie"

/obj/item/implant/radio/antenna/Initialize(mapload)
	. = ..()
	radio.name = "内部天线"

/datum/mutation/human/antenna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	var/obj/item/implant/radio/antenna/linked_radio = new(owner)
	linked_radio.implant(owner, null, TRUE, TRUE)
	radio_weakref = WEAKREF(linked_radio)

/datum/mutation/human/antenna/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	var/obj/item/implant/radio/antenna/linked_radio = radio_weakref.resolve()
	if(linked_radio)
		QDEL_NULL(linked_radio)

/datum/mutation/human/antenna/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))//-MUTATIONS_LAYER+1

/datum/mutation/human/antenna/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/mindreader
	name = "读心者"
	desc = "受影响者可以查看他人最近的记忆."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你感到脑海深处传来阵阵遥远的声音.</span>"
	text_lose_indication = "<span class='notice'>遥远的声音渐渐消失.</span>"
	power_path = /datum/action/cooldown/spell/pointed/mindread
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 8
	locked = TRUE

/datum/action/cooldown/spell/pointed/mindread
	name = "读心"
	desc = "翻阅目标的心灵."
	button_icon_state = "mindread"
	school = SCHOOL_PSYCHIC
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	ranged_mousepointer = 'icons/effects/mouse_pointers/mindswap_target.dmi'

/datum/action/cooldown/spell/pointed/mindread/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	ADD_TRAIT(grant_to, TRAIT_MIND_READER, GENETIC_MUTATION)

/datum/action/cooldown/spell/pointed/mindread/Remove(mob/remove_from)
	. = ..()
	REMOVE_TRAIT(remove_from, TRAIT_MIND_READER, GENETIC_MUTATION)

/datum/action/cooldown/spell/pointed/mindread/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/living_cast_on = cast_on
	if(!living_cast_on.mind)
		to_chat(owner, span_warning("[cast_on]没有可以读的心灵!"))
		return FALSE
	if(living_cast_on.stat == DEAD)
		to_chat(owner, span_warning("[cast_on]已经死了!"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/mindread/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		to_chat(owner, span_warning("当你试图深入[cast_on]的心灵时, \
			你被一道精神屏障挡住了. 看来你的尝试失败了."))
		return

	if(cast_on == owner)
		to_chat(owner, span_warning("你潜入你的脑海... 是的，这就是你的脑海."))
		return

	to_chat(owner, span_boldnotice(" 你潜入 [cast_on]的脑海..."))
	if(prob(20))
		// chance to alert the read-ee
		to_chat(cast_on, span_danger("你感觉到一股陌生的意识进入你的脑海."))

	var/list/recent_speech = cast_on.copy_recent_speech(copy_amount = 3, line_chance = 50)
	if(length(recent_speech))
		to_chat(owner, span_boldnotice("你捕捉到他们过去对话的记忆片段..."))
		for(var/spoken_memory in recent_speech)
			to_chat(owner, span_notice("[spoken_memory]"))

	if(iscarbon(cast_on))
		var/mob/living/carbon/carbon_cast_on = cast_on
		to_chat(owner, span_boldnotice("你发现其的意图是[carbon_cast_on.combat_mode ? "伤害" : "帮助"]..."))
		to_chat(owner, span_boldnotice("你发现了目标的真实身份，是[carbon_cast_on.mind.name]."))

/datum/mutation/human/mindreader/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "antenna", -FRONT_MUTATIONS_LAYER+1))

/datum/mutation/human/mindreader/get_visual_indicator()
	return visual_indicators[type][1]
