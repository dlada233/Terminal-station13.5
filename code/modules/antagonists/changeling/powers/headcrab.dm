/datum/action/changeling/headcrab
	name = "最后手段"
	desc = "我们在必要时刻可以牺牲掉当前的身体，将我们置于一只更弱小的生物体内，这只生物可以在未来将我们注射进新的强壮躯体内. 花费20点化学物质."
	helptext = "我们将被置于一只弱小的生物体内，我们可以攻击一具尸体来种下一颗卵，它会慢慢成长成一具能为我们所用的躯体."
	button_icon_state = "last_resort"
	chemical_cost = 20
	dna_cost = 1
	req_human = TRUE
	req_stat = DEAD
	ignores_fakedeath = TRUE
	disabled_by_fire = FALSE

/datum/action/changeling/headcrab/sting_action(mob/living/user)
	set waitfor = FALSE
	var/confirm = tgui_alert(user, "你确定希望摧毁你的身体并创造一只猎头蚴吗?", "最后手段", list("Yes", "No"))
	if(confirm != "Yes")
		return

	..()
	var/datum/mind/stored_mind = user.mind
	var/list/organs = user.get_organs_for_zone(BODY_ZONE_HEAD, TRUE)

	explosion(user, light_impact_range = 2, adminlog = TRUE, explosion_cause = src)
	for(var/mob/living/carbon/human/blinded_human in range(2, user))
		var/obj/item/organ/internal/eyes/eyes = blinded_human.get_organ_slot(ORGAN_SLOT_EYES)
		if(!eyes || blinded_human.is_blind())
			continue
		to_chat(blinded_human, span_userdanger("你被一阵血雨蒙眼"))
		blinded_human.Stun(4 SECONDS)
		blinded_human.set_eye_blur_if_lower(40 SECONDS)
		blinded_human.adjust_confusion(12 SECONDS)

	for(var/mob/living/silicon/blinded_silicon in range(2,user))
		to_chat(blinded_silicon, span_userdanger("你的传感器被一阵血雨瘫痪!"))
		blinded_silicon.Paralyze(6 SECONDS)

	var/turf/user_turf = get_turf(user)
	user.transfer_observers_to(user_turf) // user is about to be deleted, store orbiters on the turf
	if(user.stat != DEAD)
		user.investigate_log("因猎头蚴出生而爆裂.", INVESTIGATE_DEATHS)
	user.gib(DROP_ALL_REMAINS)
	. = TRUE
	addtimer(CALLBACK(src, PROC_REF(spawn_headcrab), stored_mind, user_turf, organs), 1 SECONDS)

/// Creates the headrab to occupy
/datum/action/changeling/headcrab/proc/spawn_headcrab(datum/mind/stored_mind, turf/spawn_location, list/organs)
	var/mob/living/basic/headslug/crab = new(spawn_location)
	for(var/obj/item/organ/I in organs)
		I.forceMove(crab)

	stored_mind.transfer_to(crab, force_key_move = TRUE)
	spawn_location.transfer_observers_to(crab)
	to_chat(crab, span_warning("你们从已经炸成血雨的身体中冲了出来!"))
