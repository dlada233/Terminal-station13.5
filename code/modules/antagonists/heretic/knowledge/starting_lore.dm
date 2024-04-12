// Heretic starting knowledge.

/// Global list of all heretic knowledge that have route = PATH_START. List of PATHS.
GLOBAL_LIST_INIT(heretic_start_knowledge, initialize_starting_knowledge())

/**
 * Returns a list of all heretic knowledge TYPEPATHS
 * that have route set to PATH_START.
 */
/proc/initialize_starting_knowledge()
	. = list()
	for(var/datum/heretic_knowledge/knowledge as anything in subtypesof(/datum/heretic_knowledge))
		if(initial(knowledge.route) == PATH_START)
			. += knowledge

/*
 * The base heretic knowledge. Grants the Mansus Grasp spell.
 */
/datum/heretic_knowledge/spell/basic
	name = "启明"
	desc = "开始你的漫宿之旅. \
		赐予你漫宿之握，一种可升级的强大致残法术，无论你是否拥有焦点都可以释放."
	spell_to_add = /datum/action/cooldown/spell/touch/mansus_grasp
	cost = 0
	route = PATH_START

/datum/heretic_knowledge/spell/basic/New()
	. = ..()
	next_knowledge = subtypesof(/datum/heretic_knowledge/limited_amount/starting)

/**
 * The Living Heart heretic knowledge.
 *
 * Gives the heretic a living heart.
 * Also includes a ritual to turn their heart into a living heart.
 */
/datum/heretic_knowledge/living_heart
	name = "活体之心"
	desc = "赐予你一颗活体之心，使你能够追踪献祭目标. \
		如果你失去了活体之心，你可以用一摊血和一朵罂粟将你的心嬗变成活体之心 \
		如果你的心是电子心，那你则需要额外一颗可用的有机心脏."
	required_atoms = list(
		/obj/effect/decal/cleanable/blood = 1,
		/obj/item/food/grown/poppy = 1,
	)
	cost = 0
	priority = MAX_KNOWLEDGE_PRIORITY - 1 // Knowing how to remake your heart is important
	route = PATH_START
	/// The typepath of the organ type required for our heart.
	var/required_organ_type = /obj/item/organ/internal/heart

/datum/heretic_knowledge/living_heart/on_research(mob/user, datum/antagonist/heretic/our_heretic)
	. = ..()

	var/obj/item/organ/where_to_put_our_heart = user.get_organ_slot(our_heretic.living_heart_organ_slot)
	// Our heart slot is not valid to put a heart
	if(!is_valid_heart(where_to_put_our_heart))
		where_to_put_our_heart = null

	// If a heretic is made from a species without a heart, we need to find a backup.
	if(!where_to_put_our_heart)
		var/static/list/backup_organs = list(
			ORGAN_SLOT_LUNGS = /obj/item/organ/internal/lungs,
			ORGAN_SLOT_LIVER = /obj/item/organ/internal/liver,
			ORGAN_SLOT_STOMACH = /obj/item/organ/internal/stomach,
		)

		for(var/backup_slot in backup_organs)
			var/obj/item/organ/look_for_backup = user.get_organ_slot(backup_slot)
			// This backup slot is not a valid slot to put a heart
			if(!is_valid_heart(look_for_backup))
				continue

			// We found a replacement place to put our heart
			where_to_put_our_heart = look_for_backup
			our_heretic.living_heart_organ_slot = backup_slot
			required_organ_type = backup_organs[backup_slot]
			to_chat(user, span_boldnotice("由于你的种族没有心脏，活体之心生成在了你的[look_for_backup.name]."))
			break

	if(where_to_put_our_heart)
		where_to_put_our_heart.AddComponent(/datum/component/living_heart)
		desc = "赐予你一颗活体之心，与你的[where_to_put_our_heart.name]连在一起，\
			使你能够追踪献祭目标. \
			如果你失去了[where_to_put_our_heart.name]，你可以用一摊血和一朵罂粟将你的替代[where_to_put_our_heart.name]嬗变成活体之心. \
			如果你的[where_to_put_our_heart.name]是电子或机械的，\
			那你则需要额外一个可用的有机[where_to_put_our_heart.name]来进行嬗变."

	else
		to_chat(user, span_boldnotice("你没有心脏，也没有任何胸部器官，因此你没法得到活体之心."))

/datum/heretic_knowledge/living_heart/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	var/obj/item/organ/our_living_heart = user.get_organ_slot(our_heretic.living_heart_organ_slot)
	if(our_living_heart)
		qdel(our_living_heart.GetComponent(/datum/component/living_heart))

// Don't bother letting them invoke this ritual if they have a Living Heart already in their chest
/datum/heretic_knowledge/living_heart/can_be_invoked(datum/antagonist/heretic/invoker)
	if(invoker.has_living_heart() == HERETIC_HAS_LIVING_HEART)
		return FALSE
	return TRUE

/datum/heretic_knowledge/living_heart/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	var/datum/antagonist/heretic/our_heretic = IS_HERETIC(user)
	var/obj/item/organ/our_living_heart = user.get_organ_slot(our_heretic.living_heart_organ_slot)
	// Obviously you need a heart in your chest to do a ritual on your... heart
	if(!our_living_heart)
		loc.balloon_alert(user, "仪式失败，你没有[our_heretic.living_heart_organ_slot]!") // "you have no heart!"
		return FALSE
	// For sanity's sake, check if they've got a heart -
	// even though it's not invokable if you already have one,
	// they may have gained one unexpectantly in between now and then
	if(HAS_TRAIT(our_living_heart, TRAIT_LIVING_HEART))
		loc.balloon_alert(user, "仪式失败，以及有了一颗活体之心!")
		return FALSE

	// By this point they are making a new heart
	// If their current heart is organic / not synthetic, we can continue the ritual as normal
	if(is_valid_heart(our_living_heart))
		return TRUE

	// If their current heart is not organic / is synthetic, they need an organic replacement
	// ...But if our organ-to-be-replaced is unremovable, we're screwed
	if(our_living_heart.organ_flags & ORGAN_UNREMOVABLE)
		loc.balloon_alert(user, "仪式失败，[our_heretic.living_heart_organ_slot]不可移除!") // "heart unremovable!"
		return FALSE

	// Otherwise, seek out a replacement in our atoms
	for(var/obj/item/organ/nearby_organ in atoms)
		if(!istype(nearby_organ, required_organ_type))
			continue
		if(!is_valid_heart(nearby_organ))
			continue

		selected_atoms += nearby_organ
		return TRUE

	loc.balloon_alert(user, "仪式失败，需要一颗替代[our_heretic.living_heart_organ_slot]!") // "need a replacement heart!"
	return FALSE

/datum/heretic_knowledge/living_heart/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/datum/antagonist/heretic/our_heretic = IS_HERETIC(user)
	var/obj/item/organ/our_new_heart = user.get_organ_slot(our_heretic.living_heart_organ_slot)

	// Our heart is robotic or synthetic - we need to replace it, and we fortunately should have one by here
	if(!is_valid_heart(our_new_heart))
		var/obj/item/organ/our_replacement_heart = locate(required_organ_type) in selected_atoms
		if(our_replacement_heart)
			// Throw our current heart out of our chest, violently
			user.visible_message(span_boldwarning("[user]的[our_new_heart.name]从胸膛中爆裂而出!"))
			INVOKE_ASYNC(user, TYPE_PROC_REF(/mob, emote), "scream")
			user.apply_damage(20, BRUTE, BODY_ZONE_CHEST)
			// And put our organic heart in its place
			our_replacement_heart.Insert(user, TRUE, TRUE)
			our_new_heart.throw_at(get_edge_target_turf(user, pick(GLOB.alldirs)), 2, 2)
			our_new_heart = our_replacement_heart
		else
			CRASH("[type] required a replacement organic heart in on_finished_recipe, but did not find one.")

	if(!our_new_heart)
		CRASH("[type] somehow made it to on_finished_recipe without a heart. What?")

	// Snowflakey, but if the user used a heart that wasn't beating
	// they'll immediately collapse into a heart attack. Funny but not ideal.
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		carbon_user.set_heartattack(FALSE)

	// Don't delete our shiny new heart
	selected_atoms -= our_new_heart
	// Make it the living heart
	our_new_heart.AddComponent(/datum/component/living_heart)
	to_chat(user, span_warning("当它醒来时，你感到你的[our_new_heart.name]开始越跳越快!"))
	playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
	return TRUE

/// Checks if the passed heart is a valid heart to become a living heart
/datum/heretic_knowledge/living_heart/proc/is_valid_heart(obj/item/organ/new_heart)
	if(!new_heart)
		return FALSE
	if(!new_heart.useable)
		return FALSE
	if(new_heart.organ_flags & (ORGAN_ROBOTIC|ORGAN_FAILING))
		return FALSE

	return TRUE

/**
 * Allows the heretic to craft a spell focus.
 * They require a focus to cast advanced spells.
 */
/datum/heretic_knowledge/amber_focus
	name = "聚焦琥珀"
	desc = "通过嬗变一块玻璃和一双眼睛来创造出聚焦琥珀. \
		焦点对高级咒术来说不可缺少的."
	required_atoms = list(
		/obj/item/organ/internal/eyes = 1,
		/obj/item/stack/sheet/glass = 1,
	)
	result_atoms = list(/obj/item/clothing/neck/heretic_focus)
	cost = 0
	priority = MAX_KNOWLEDGE_PRIORITY - 2 // Not as important as making a heart or sacrificing, but important enough.
	route = PATH_START

/datum/heretic_knowledge/spell/cloak_of_shadows
	name = "黑雾隐"
	desc = "赐予你黑雾隐. 让你的身份完全影藏在紫色的烟雾三分钟，用来保护你的秘密，需要焦点来施法."
	spell_to_add = /datum/action/cooldown/spell/shadow_cloak
	cost = 0
	route = PATH_START

/**
 * Codex Cicatrixi is available at the start:
 * This allows heretics to choose if they want to rush all the influences and take them stealthily, or
 * Construct a codex and take what's left with more points.
 * Another downside to having the book is strip searches, which means that it's not just a free nab, at least until you get exposed - and when you do, you'll probably need the faster drawing speed.
 * Overall, it's a tradeoff between speed and stealth or power.
 */
/datum/heretic_knowledge/codex_cicatrix
	name = "疤痕法典"
	desc = "你可以将一本书、一支特别的笔以及任何皮革或毛皮嬗变为疤痕法典. \
		用疤痕法典抽取‘异响’可以获得额外的知识点，但也会更加容易暴露. 法典还可以更快捷地擦除和绘制嬗变符文，在紧要关头还能作为焦点使用."
	gain_text = "疤痕法典是超自然存在向世间显露出的无数线索中的其中一角，无一不关系着秘密的知识与力量. \
		在皮革的封皮和古旧的书页下，一条通往漫宿的道路时隐时现."
	required_atoms = list(
		/obj/item/book = 1,
		/obj/item/pen = 1,
		list(/mob/living, /obj/item/stack/sheet/leather, /obj/item/stack/sheet/animalhide) = 1,
	)
	banned_atom_types = list(/obj/item/pen)
	result_atoms = list(/obj/item/codex_cicatrix)
	cost = 1
	route = PATH_START
	priority = MAX_KNOWLEDGE_PRIORITY - 3 // Least priority out of the starting knowledges, as it's an optional boon.

/datum/heretic_knowledge/codex_cicatrix/parse_required_item(atom/item_path, number_of_things)
	if(item_path == /obj/item/pen)
		return "特别的笔"
	return ..()

/datum/heretic_knowledge/codex_cicatrix/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/body in atoms)
		if(body.stat != DEAD)
			continue

		selected_atoms += body
		return TRUE
	return FALSE

/datum/heretic_knowledge/codex_cicatrix/cleanup_atoms(list/selected_atoms)
	var/mob/living/body = locate() in selected_atoms
	if(!body)
		return
	// A golem or an android doesn't have skin!
	var/exterior_text = "皮肤"
	// If carbon, it's the limb. If not, it's the body.
	var/ripped_thing = body

	// We will check if it's a carbon's body.
	// If it is, we will damage a random bodypart, and check that bodypart for its body type, to select between 'skin' or 'exterior'.
	if(iscarbon(body))
		var/mob/living/carbon/carbody = body
		var/obj/item/bodypart/bodypart = pick(carbody.bodyparts)
		ripped_thing = bodypart
		bodypart.receive_damage(25, sharpness = SHARP_EDGED)
		if(!(bodypart.bodytype & BODYTYPE_ORGANIC))
			exterior_text = "外皮"
	else
		// If it is not a carbon mob, we will just check biotypes and damage it directly.
		if(body.mob_biotypes & (MOB_MINERAL|MOB_ROBOTIC))
			exterior_text = "外皮"
			body.apply_damage(25, BRUTE)

	// Procure book for flavor text. This is why we call parent at the end.
	var/obj/item/book/le_book = locate() in selected_atoms
	if(!le_book)
		stack_trace("Somehow, no book in codex cicatrix selected atoms! [english_list(selected_atoms)]")
	playsound(body, 'sound/items/poster_ripped.ogg', 100, TRUE)
	body.do_jitter_animation()
	body.visible_message(span_danger("[ripped_thing]的[exterior_text]伴随着可怕的撕裂声分崩离析，碎片缠扰着[le_book || ""]，发出一种古老而神秘的蓝色!"))
	return ..()
