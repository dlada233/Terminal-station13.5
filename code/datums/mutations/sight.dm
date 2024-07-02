//Nearsightedness restricts your vision by several tiles.
/datum/mutation/human/nearsight
	name = "近视"
	desc = "该突变的携带者视力不佳."
	instability = NEGATIVE_STABILITY_MODERATE
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>你看东西不太清楚.</span>"

/datum/mutation/human/nearsight/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.become_nearsighted(GENETIC_MUTATION)

/datum/mutation/human/nearsight/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_nearsighted(GENETIC_MUTATION)

///Blind makes you blind. Who knew?
/datum/mutation/human/blind
	name = "失明"
	desc = "使对象完全失明."
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你的眼睛看不见了.</span>"

/datum/mutation/human/blind/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.become_blind(GENETIC_MUTATION)

/datum/mutation/human/blind/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_blind(GENETIC_MUTATION)

///Thermal Vision lets you see mobs through walls
/datum/mutation/human/thermal
	name = "热成像视觉"
	desc = "该基因组的使用者可以直观地感知到独特的人类热特征."
	quality = POSITIVE
	difficulty = 18
	text_gain_indication = "<span class='notice'>你可以看到从皮肤散发出的热量...</span>"
	text_lose_indication = "<span class='notice'>你不再能感知到皮肤散发的热量...</span>"
	instability = POSITIVE_INSTABILITY_MAJOR // thermals aren't station equipment
	synchronizer_coeff = 1
	power_coeff = 1
	energy_coeff = 1
	power_path = /datum/action/cooldown/spell/thermal_vision

/datum/mutation/human/thermal/on_losing(mob/living/carbon/human/owner)
	if(..())
		return

	// Something went wront and we still have the thermal vision from our power, no cheating.
	if(HAS_TRAIT_FROM(owner, TRAIT_THERMAL_VISION, GENETIC_MUTATION))
		REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
		owner.update_sight()

/datum/mutation/human/thermal/modify()
	. = ..()
	var/datum/action/cooldown/spell/thermal_vision/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.eye_damage = 10 * GET_MUTATION_SYNCHRONIZER(src)
	to_modify.thermal_duration = 10 SECONDS * GET_MUTATION_POWER(src)

/datum/action/cooldown/spell/thermal_vision
	name = "激活热成像"
	desc = "你可以用视力作为代价，切换为热成像视觉."
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "augmented_eyesight"

	cooldown_time = 25 SECONDS
	spell_requirements = NONE

	/// How much eye damage is given on cast
	var/eye_damage = 10
	/// The duration of the thermal vision
	var/thermal_duration = 10 SECONDS

/datum/action/cooldown/spell/thermal_vision/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	remove_from.update_sight()
	return ..()

/datum/action/cooldown/spell/thermal_vision/is_valid_target(atom/cast_on)
	return isliving(cast_on) && !HAS_TRAIT(cast_on, TRAIT_THERMAL_VISION)

/datum/action/cooldown/spell/thermal_vision/cast(mob/living/cast_on)
	. = ..()
	ADD_TRAIT(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	cast_on.update_sight()
	to_chat(cast_on, span_info("你紧眯双眼，眼前的景象逐渐被热信号填满."))
	addtimer(CALLBACK(src, PROC_REF(deactivate), cast_on), thermal_duration)

/datum/action/cooldown/spell/thermal_vision/proc/deactivate(mob/living/cast_on)
	if(QDELETED(cast_on) || !HAS_TRAIT_FROM(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION))
		return

	REMOVE_TRAIT(cast_on, TRAIT_THERMAL_VISION, GENETIC_MUTATION)
	cast_on.update_sight()
	to_chat(cast_on, span_info("你眨了几次眼，视力恢复正常，但眼睛里传来一阵钝痛."))

	if(iscarbon(cast_on))
		var/mob/living/carbon/carbon_cast_on = cast_on
		carbon_cast_on.adjustOrganLoss(ORGAN_SLOT_EYES, eye_damage)

///X-ray Vision lets you see through walls.
/datum/mutation/human/xray
	name = "X射线视觉"
	desc = "一种奇怪的基因，可以让使用者看穿墙壁." //actual x-ray would mean you'd constantly be blasting rads, wich might be fun for later //hmb
	text_gain_indication = "<span class='notice'>墙壁突然消失了!</span>"
	instability = POSITIVE_INSTABILITY_MAJOR
	locked = TRUE

/datum/mutation/human/xray/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_XRAY_VISION, GENETIC_MUTATION)
	owner.update_sight()

/datum/mutation/human/xray/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_XRAY_VISION, GENETIC_MUTATION)
	owner.update_sight()


///Laser Eyes lets you shoot lasers from your eyes!
/datum/mutation/human/laser_eyes
	name = "激光眼"
	desc = "Reflects concentrated light back from the eyes."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = "<span class='notice'>You feel pressure building up behind your eyes.</span>"
	layer_used = FRONT_MUTATIONS_LAYER
	limb_req = BODY_ZONE_HEAD

/datum/mutation/human/laser_eyes/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', "lasereyes", -FRONT_MUTATIONS_LAYER))

/datum/mutation/human/laser_eyes/on_acquiring(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	RegisterSignal(H, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_ranged_attack))

/datum/mutation/human/laser_eyes/on_losing(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	UnregisterSignal(H, COMSIG_MOB_ATTACK_RANGED)

/datum/mutation/human/laser_eyes/get_visual_indicator()
	return visual_indicators[type][1]

///Triggers on COMSIG_MOB_ATTACK_RANGED. Does the projectile shooting.
/datum/mutation/human/laser_eyes/proc/on_ranged_attack(mob/living/carbon/human/source, atom/target, modifiers)
	SIGNAL_HANDLER

	if(!source.combat_mode)
		return
	to_chat(source, span_warning("你发射了激光眼!"))
	source.changeNext_move(CLICK_CD_RANGE)
	source.newtonian_move(get_dir(target, source))
	var/obj/projectile/beam/laser/laser_eyes/LE = new(source.loc)
	LE.firer = source
	LE.def_zone = ran_zone(source.zone_selected)
	LE.preparePixelProjectile(target, source, modifiers)
	INVOKE_ASYNC(LE, TYPE_PROC_REF(/obj/projectile, fire))
	playsound(source, 'sound/weapons/taser2.ogg', 75, TRUE)

///Projectile type used by laser eyes
/obj/projectile/beam/laser/laser_eyes
	name = "射线"
	icon = 'icons/mob/effects/genetics.dmi'
	icon_state = "eyelasers"

/datum/mutation/human/illiterate
	name = "文盲"
	desc = "引起严重的失语症，导致无法阅读或写作."
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你感觉无法阅读或书写任何文字.</span>"
	text_lose_indication = "<span class='danger'>你恢复了阅读和书写的能力.</span>"

/datum/mutation/human/illiterate/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_ILLITERATE, GENETIC_MUTATION)

/datum/mutation/human/illiterate/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_ILLITERATE, GENETIC_MUTATION)
