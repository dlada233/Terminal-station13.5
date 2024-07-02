/datum/mutation/human/geladikinesis
	name = "冻凝操控"
	desc = "允许使用者运用水分和冰冻之力来凝聚出雪花."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你的手感觉很冷.</span>"
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 10
	synchronizer_coeff = 1
	power_path = /datum/action/cooldown/spell/conjure_item/snow

/datum/action/cooldown/spell/conjure_item/snow
	name = "造雪"
	desc = "聚焦冰冻之力，创造雪花，适用于冰雪建筑."
	button_icon_state = "snow"

	cooldown_time = 5 SECONDS
	spell_requirements = NONE

	item_type = /obj/item/stack/sheet/mineral/snow
	delete_old = FALSE
	delete_on_failure = FALSE

/datum/mutation/human/cryokinesis
	name = "冰冻操控"
	desc = "从超低温的虚空汲取负能量，根据使用者意愿冻结周围环境."
	quality = POSITIVE //upsides and downsides
	text_gain_indication = "<span class='notice'>Your hand feels cold.</span>"
	instability = POSITIVE_INSTABILITY_MODERATE
	difficulty = 12
	synchronizer_coeff = 1
	energy_coeff = 1
	power_path = /datum/action/cooldown/spell/pointed/projectile/cryo

/datum/action/cooldown/spell/pointed/projectile/cryo
	name = "冰冻光线"
	desc = "发射一道冰冻射线攻击目标."
	button_icon_state = "icebeam"
	base_icon_state = "icebeam"
	active_overlay_icon_state = "bg_spell_border_active_blue"
	cooldown_time = 16 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE

	active_msg = "你聚精会神地操控冰冻!"
	deactive_msg = "你放松了控制."
	projectile_type = /obj/projectile/temp/cryo
