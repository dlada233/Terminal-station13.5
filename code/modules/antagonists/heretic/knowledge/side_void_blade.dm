// Sidepaths for knowledge between Void and Blade.

/// The max health given to Shattered Risen
#define RISEN_MAX_HEALTH 125

/datum/heretic_knowledge/limited_amount/risen_corpse
	name = "破碎秘仪-Risen corpse"
	desc = "你可以将一具带有灵魂的尸体、一双乳胶或丁腈手套以及一件任意外衣（如盔甲）进行嬗变以创造一个破碎返生者\
		破碎返生者是强大的食尸鬼，拥有125点生命值，自带两把残忍的武器，但无法拿取物品，同一时间也只能创造一只."
	gain_text = "我目睹了一股冰冷破碎的力量将这具尸体拖回了返生的状态. \
		当它行动时，就像碎玻璃一样嘎吱作响，它的手已经看不出人形了，掌心满是锋利的骨头碎片."
	next_knowledge = list(
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/blade_dance,
	)
	required_atoms = list(
		/obj/item/clothing/suit = 1,
		/obj/item/clothing/gloves/latex = 1,
	)
	limit = 1
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/limited_amount/risen_corpse/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/body in atoms)
		if(body.stat != DEAD)
			continue
		if(!IS_VALID_GHOUL_MOB(body) || HAS_TRAIT(body, TRAIT_HUSK))
			to_chat(user, span_hierophant_warning("[body]的状态无法被做成食尸鬼."))
			continue
		if(!body.mind)
			to_chat(user, span_hierophant_warning("[body]没有神智，不能被做成食尸鬼."))
			continue
		if(!body.client && !body.mind.get_ghost(ghosts_with_clients = TRUE))
			to_chat(user, span_hierophant_warning("[body]体内没有灵魂，不能被做成食尸鬼."))
			continue

		// We will only accept valid bodies with a mind, or with a ghost connected that used to control the body
		selected_atoms += body
		return TRUE

	loc.balloon_alert(user, "仪式失败，尸体不可用!")
	return FALSE

/datum/heretic_knowledge/limited_amount/risen_corpse/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/mob/living/carbon/human/soon_to_be_ghoul = locate() in selected_atoms
	if(QDELETED(soon_to_be_ghoul)) // No body? No ritual
		stack_trace("[type] reached on_finished_recipe without a human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "仪式失败，尸体不可用!")
		return FALSE

	soon_to_be_ghoul.grab_ghost()
	if(!soon_to_be_ghoul.mind || !soon_to_be_ghoul.client)
		stack_trace("[type] reached on_finished_recipe without a minded / cliented human in selected_atoms to make a ghoul out of.")
		loc.balloon_alert(user, "仪式失败，尸体不可用!")
		return FALSE

	selected_atoms -= soon_to_be_ghoul
	make_risen(user, soon_to_be_ghoul)
	return TRUE

/// Make [victim] into a shattered risen ghoul.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/make_risen(mob/living/user, mob/living/carbon/human/victim)
	user.log_message("在[key_name(victim)]上创造了破碎返生者.", LOG_GAME)
	victim.log_message("变成了在[key_name(user)]上创造的破碎返生者.", LOG_VICTIM, log_globally = FALSE)
	message_admins("[ADMIN_LOOKUPFLW(user)]创造了一名破碎返生者，[ADMIN_LOOKUPFLW(victim)].")

	victim.apply_status_effect(
		/datum/status_effect/ghoul,
		RISEN_MAX_HEALTH,
		user.mind,
		CALLBACK(src, PROC_REF(apply_to_risen)),
		CALLBACK(src, PROC_REF(remove_from_risen)),
	)

/// Callback for the ghoul status effect - what effects are applied to the ghoul.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/apply_to_risen(mob/living/risen)
	LAZYADD(created_items, WEAKREF(risen))
	risen.AddComponent(/datum/component/mutant_hands, mutant_hand_path = /obj/item/mutant_hand/shattered_risen)

/// Callback for the ghoul status effect - cleaning up effects after the ghoul status is removed.
/datum/heretic_knowledge/limited_amount/risen_corpse/proc/remove_from_risen(mob/living/risen)
	LAZYREMOVE(created_items, WEAKREF(risen))
	qdel(risen.GetComponent(/datum/component/mutant_hands))

#undef RISEN_MAX_HEALTH

/// The "hand" "weapon" used by shattered risen
/obj/item/mutant_hand/shattered_risen
	name = "碎骨"
	desc = "曾经是正常的人类拳头，现在团聚着锋利的碎骨."
	color = "#001aff"
	hitsound = SFX_SHATTER
	force = 16
	wound_bonus = -30
	bare_wound_bonus = 15
	demolition_mod = 1.5
	sharpness = SHARP_EDGED

/obj/item/mutant_hand/shattered_risen/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/mutant_hand/shattered_risen/visual_equipped(mob/user, slot)
	. = ..()

	// Even hand indexes are right hands,
	// Odd hand indexes are left hand
	// ...But also, we swap it intentionally here,
	// so right icon is shown on the left (Because hands)
	if(user.get_held_index_of_item(src) % 2 == 1)
		icon_state = "[base_icon_state]_right"
	else
		icon_state = "[base_icon_state]_left"

/datum/heretic_knowledge/rune_carver
	name = "雕刻刀-Rune carver"
	desc = "你可以将一把刀、一块玻璃碎片盒一张纸嬗变成一把雕刻刀. \
		雕刻刀可以让你雕刻出难以被察觉的陷阱，不信之人一旦走上去就会触发. 另外这也是一把方便的投掷武器."
	gain_text = "蚀刻，雕刻...永远地. 力量潜藏在万物之间. 我可以揭开它的面纱! \
		我可以雕刻巨岩，揭露枷锁!"
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/duel_stance,
	)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/shard = 1,
		/obj/item/paper = 1,
	)
	result_atoms = list(/obj/item/melee/rune_carver)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/summon/maid_in_mirror
	name = "镜中少女-Maid in mirror"
	desc = "你可以将五片钛、一个闪光灯、一套护甲和一块肺嬗变成一名镜中少女. \
		镜中少女是优秀的战士，可以通过进出镜界而变得无形，擅长侦察与伏击."
	gain_text = "每个反射面都泛出不存在的色彩，都是通往奇异世界的大门. 水晶玻璃铺成楼梯，利刃尖刀砌成墙壁，如若无人指引，步步下血池."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_pull,
		/datum/heretic_knowledge/spell/furious_steel,
	)
	required_atoms = list(
		/obj/item/stack/sheet/mineral/titanium = 5,
		/obj/item/clothing/suit/armor = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/organ/internal/lungs = 1,
	)
	cost = 1
	route = PATH_SIDE
	mob_to_summon = /mob/living/basic/heretic_summon/maid_in_the_mirror
	poll_ignore_define = POLL_IGNORE_MAID_IN_MIRROR
