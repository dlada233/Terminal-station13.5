/// Dress the crew as magical clowns
/datum/grand_finale/clown
	name = "欢庆"
	desc = "倾泻汇聚至今的所有魔力！送每个人都去读小丑大学！让他们为你而互相恶作剧！"
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "clown"
	glow_colour = "#ffff0048"

/datum/grand_finale/clown/trigger(mob/living/carbon/human/invoker)
	for(var/mob/living/carbon/human/victim as anything in GLOB.human_list)
		victim.Unconscious(3 SECONDS)
		if (!victim.mind || IS_HUMAN_INVADER(victim) || victim == invoker)
			continue
		if (HAS_TRAIT(victim, TRAIT_CLOWN_ENJOYER))
			victim.add_mood_event("clown_world", /datum/mood_event/clown_world)
		to_chat(victim, span_notice("世界旋转并融化，过去倒放在眼前.\n\
			生命漫步回到海洋，收缩成虚无；行星爆炸，成为风暴的尘埃.\
			星星赶回到宇宙开始的时刻相互迎接...一瞬间你又回到了现在. \n\
			一切都如同过去和一直以来的一样. \n\n\
			一个游离的想法出现在你的脑海中. \n\
			[span_hypnophrase("我很高兴能在小丑研究空间站[station_name()]上当小丑!")] \n\
			是这样...对吧?"))
		if (is_clown_job(victim.mind.assigned_role))
			var/datum/action/cooldown/spell/conjure_item/clown_pockets/new_spell = new(victim)
			new_spell.Grant(victim)
			continue
		if (!ismonkey(victim)) // Monkeys cannot yet wear clothes
			dress_as_magic_clown(victim)
		if (prob(15))
			create_vendetta(victim.mind, invoker.mind)

/**
 * Clown enjoyers who are effected by this become ecstatic, they have achieved their life's dream.
 * This moodlet is equivalent to the one for simply being a traitor.
 */
/datum/mood_event/clown_world
	mood_change = 4

/datum/mood_event/clown_world/add_effects(param)
	description = "我爱死在小丑研究空间站[station_name()]上工作了!!"

/// Dress the passed mob as a magical clown, self-explanatory
/datum/grand_finale/clown/proc/dress_as_magic_clown(mob/living/carbon/human/victim)
	var/obj/effect/particle_effect/fluid/smoke/poof = new(get_turf(victim))
	poof.lifetime = 2 SECONDS

	var/obj/item/tank/internal = victim.internal
	// We're about to take off your pants so those are going to fall out
	var/obj/item/pocket_L = victim.get_item_by_slot(ITEM_SLOT_LPOCKET)
	var/obj/item/pocket_R = victim.get_item_by_slot(ITEM_SLOT_RPOCKET)
	var/obj/item/id = victim.get_item_by_slot(ITEM_SLOT_ID)
	var/obj/item/belt = victim.get_item_by_slot(ITEM_SLOT_BELT)

	var/obj/pants = victim.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	var/obj/mask = victim.get_item_by_slot(ITEM_SLOT_MASK)
	QDEL_NULL(pants)
	QDEL_NULL(mask)
	if(isplasmaman(victim))
		victim.equip_to_slot_if_possible(new /obj/item/clothing/under/plasmaman/clown/magic(), ITEM_SLOT_ICLOTHING, disable_warning = TRUE)
		victim.equip_to_slot_if_possible(new /obj/item/clothing/mask/gas/clown_hat/plasmaman(), ITEM_SLOT_MASK, disable_warning = TRUE)
	else
		victim.equip_to_slot_if_possible(new /obj/item/clothing/under/rank/civilian/clown/magic(), ITEM_SLOT_ICLOTHING, disable_warning = TRUE)
		victim.equip_to_slot_if_possible(new /obj/item/clothing/mask/gas/clown_hat(), ITEM_SLOT_MASK, disable_warning = TRUE)

	var/obj/item/clothing/mask/gas/clown_hat/clown_mask = victim.get_item_by_slot(ITEM_SLOT_MASK)
	if (clown_mask)
		var/list/options = GLOB.clown_mask_options
		clown_mask.icon_state = options[pick(clown_mask.clownmask_designs)]
		victim.update_worn_mask()
		clown_mask.update_item_action_buttons()

	equip_to_slot_then_hands(victim, ITEM_SLOT_LPOCKET, pocket_L)
	equip_to_slot_then_hands(victim, ITEM_SLOT_RPOCKET, pocket_R)
	equip_to_slot_then_hands(victim, ITEM_SLOT_ID, id)
	equip_to_slot_then_hands(victim, ITEM_SLOT_BELT, belt)
	victim.internal = internal
