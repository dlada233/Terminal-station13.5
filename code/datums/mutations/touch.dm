/datum/mutation/human/shock
	name = "电击之触"
	desc = "可以将体内过剩的电能通过双手释放来电击他人."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = "<span class='notice'>你感觉到电力流过你的双手.</span>"
	text_lose_indication = "<span class='notice'>你手上的电能消散了.</span>"
	power_path = /datum/action/cooldown/spell/touch/shock
	instability = 35
	energy_coeff = 1
	power_coeff = 1

/datum/mutation/human/shock/modify()
	. = ..()
	var/datum/action/cooldown/spell/touch/shock/to_modify =.

	if(!istype(to_modify)) // null or invalid
		return

	if(GET_MUTATION_POWER(src) <= 1)
		to_modify.chain = initial(to_modify.chain)
		return

	to_modify.chain = TRUE

/datum/action/cooldown/spell/touch/shock
	name = "电击之触"
	desc = "将电能汇聚到手中，电击他人."
	button_icon_state = "zap"
	sound = 'sound/weapons/zapbang.ogg'
	cooldown_time = 12 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = NONE

	//Vars for zaps made when power chromosome is applied, ripped and toned down from reactive tesla armor code.
	///This var decides if the spell should chain, dictated by presence of power chromosome
	var/chain = FALSE
	///Affects damage, should do about 1 per limb
	var/zap_power = 7500
	///Range of tesla shock bounces
	var/zap_range = 7
	///flags that dictate what the tesla shock can interact with, Can only damage mobs, Cannot damage machines or generate energy
	var/zap_flags = ZAP_MOB_DAMAGE

	hand_path = /obj/item/melee/touch_attack/shock
	draw_message = span_notice("你将电能汇聚到手中.")
	drop_message = span_notice("你让手上的电能消散.")

/datum/action/cooldown/spell/touch/shock/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		if(carbon_victim.electrocute_act(15, caster, 1, SHOCK_NOGLOVES | SHOCK_NOSTUN))//doesnt stun. never let this stun
			carbon_victim.dropItemToGround(carbon_victim.get_active_held_item())
			carbon_victim.dropItemToGround(carbon_victim.get_inactive_held_item())
			carbon_victim.adjust_confusion(15 SECONDS)
			carbon_victim.visible_message(
				span_danger("[caster] 电击了 [victim]!"),
				span_userdanger("[caster] 电击了你!"),
			)
			if(chain)
				tesla_zap(source = victim, zap_range = zap_range, power = zap_power, cutoff = 1e3, zap_flags = zap_flags)
				carbon_victim.visible_message(span_danger("一道电弧从[victim]体内爆裂而出!"))
			return TRUE

	else if(isliving(victim))
		var/mob/living/living_victim = victim
		if(living_victim.electrocute_act(15, caster, 1, SHOCK_NOSTUN))
			living_victim.visible_message(
				span_danger("[caster] 电击了 [victim]!"),
				span_userdanger("[caster] 电击了你!"),
			)
			if(chain)
				tesla_zap(source = victim, zap_range = zap_range, power = zap_power, cutoff = 1e3, zap_flags = zap_flags)
				living_victim.visible_message(span_danger("一道电弧从[victim]体内爆裂而出!"))
			return TRUE

	to_chat(caster, span_warning("电击似乎对[victim]没有影响..."))
	return TRUE

/obj/item/melee/touch_attack/shock
	name = "\improper 电击之触"
	desc = "这就像是小时候摩擦地毯然后去电你的朋友，但危险程度要高得多."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "zapper"
	inhand_icon_state = "zapper"
