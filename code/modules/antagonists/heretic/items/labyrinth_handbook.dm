/obj/effect/forcefield/wizard/heretic
	name = "迷宫书页"
	desc = "一堆书页在空中飞舞，以不可思议的力量击退不信之人."
	icon_state = "lintel"
	initial_duration = 8 SECONDS

/obj/effect/forcefield/wizard/heretic/Bumped(mob/living/bumpee)
	. = ..()
	if(!istype(bumpee) || IS_HERETIC_OR_MONSTER(bumpee))
		return
	var/throwtarget = get_edge_target_turf(loc, get_dir(loc, get_step_away(bumpee, loc)))
	bumpee.safe_throw_at(throwtarget, 10, 1, force = MOVE_FORCE_EXTREMELY_STRONG)
	visible_message(span_danger("[src]在纸页的风暴中击退[bumpee]!"))

///A heretic item that spawns a barrier at the clicked turf, 3 uses
/obj/item/heretic_labyrinth_handbook
	name = "迷宫手册"
	desc = "一本记载了迷宫规则的手册，由未知物质构成的书页时而蠕动时而紧绷，试图扇动与逃离."
	icon = 'icons/obj/service/library.dmi'
	icon_state = "heretichandbook"
	force = 10
	damtype = BURN
	worn_icon_state = "book"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("砸向", "扇向")
	attack_verb_simple = list("砸向", "扇向")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	///what type of barrier do we spawn when used
	var/barrier_type = /obj/effect/forcefield/wizard/heretic
	///how many uses do we have left
	var/uses = 3

/obj/item/heretic_labyrinth_handbook/examine(mob/user)
	. = ..()
	if(!IS_HERETIC_OR_MONSTER(user))
		return
	. += span_hypnophrase("在视野内任意一块地块上形成障碍物，期间只有你能通过，持续8秒.")
	. += span_hypnophrase("它还有<b>[uses]</b>次使用次数.")

/obj/item/heretic_labyrinth_handbook/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(IS_HERETIC(user))
		var/turf/turf_target = get_turf(target)
		if(locate(barrier_type) in turf_target)
			user.balloon_alert(user, "已经被占据了!")
			return
		turf_target.visible_message(span_warning("大量的纸页出现了!"))
		new /obj/effect/temp_visual/paper_scatter(turf_target)
		playsound(turf_target, 'sound/magic/smoke.ogg', 30)
		new barrier_type(turf_target, user)
		uses--
		if(uses <= 0)
			to_chat(user, span_warning("[src]分崩离析，化成了灰!"))
			qdel(src)
		return
	var/mob/living/carbon/human/human_user = user
	to_chat(human_user, span_userdanger("当你深深地盯着书时，思维烧成了一团，头疼的就像大脑着了火一样."))
	human_user.adjustOrganLoss(ORGAN_SLOT_BRAIN, 30, 190)
	human_user.add_mood_event("gates_of_mansus", /datum/mood_event/gates_of_mansus)
	human_user.dropItemToGround(src)
