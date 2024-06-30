/datum/action/cooldown/spell/pointed/apetra_vulnera
	name = "皮开肉绽"
	desc = "目标的所有受创伤超过15点的身体部位大量出血. \
		如果没有符合条件的部位则随机重伤一个的部位."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "apetra_vulnera"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 45 SECONDS

	invocation = "AP'TRA VULN'RA!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cast_range = 4
	/// What type of wound we apply
	var/wound_type = /datum/wound/slash/flesh/critical/cleave

/datum/action/cooldown/spell/pointed/apetra_vulnera/is_valid_target(atom/cast_on)
	return ..() && ishuman(cast_on)

/datum/action/cooldown/spell/pointed/apetra_vulnera/cast(mob/living/carbon/human/cast_on)
	. = ..()

	if(IS_HERETIC_OR_MONSTER(cast_on))
		return FALSE

	if(!cast_on.blood_volume)
		return FALSE

	if(cast_on.can_block_magic(antimagic_flags))
		cast_on.visible_message(
			span_danger("[cast_on]的伤口发光，但很快就排斥了效果!"),
			span_danger("在保护下，你的伤口受到了什么但只是有点刺痛，")
		)
		return FALSE

	var/a_limb_got_damaged = FALSE
	for(var/obj/item/bodypart/bodypart in cast_on.bodyparts)
		if(bodypart.brute_dam < 15)
			continue
		a_limb_got_damaged = TRUE
		var/datum/wound/slash/crit_wound = new wound_type()
		crit_wound.apply_wound(bodypart)

	if(!a_limb_got_damaged)
		var/datum/wound/slash/crit_wound = new wound_type()
		crit_wound.apply_wound(pick(cast_on.bodyparts))

	cast_on.visible_message(
		span_danger("[cast_on]的伤口被一股邪祟的力量撑裂!"),
		span_danger("你的伤口被一股邪祟的力量撑裂!")
	)

	new /obj/effect/temp_visual/cleave(get_turf(cast_on))

	return TRUE
