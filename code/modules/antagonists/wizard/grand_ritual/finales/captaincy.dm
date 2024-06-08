/// Become the official Captain of the station
/datum/grand_finale/usurp
	name = "篡位"
	desc = "倾泻汇聚至今的所有魔力！改写时间，让你成为这个空间站无可争议的舰长."
	icon = 'icons/obj/card.dmi'
	icon_state = "card_gold"

/datum/grand_finale/usurp/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)]篡得了舰长之位")
	var/list/former_captains = list()
	var/list/other_crew = list()
	SEND_SOUND(world, sound('sound/magic/timeparadox2.ogg'))

	for (var/mob/living/carbon/human/crewmate as anything in GLOB.human_list)
		if (!crewmate.mind)
			continue
		crewmate.Unconscious(3 SECONDS) // Everyone falls unconscious but not everyone gets told about a new captain
		if (crewmate == invoker || IS_HUMAN_INVADER(crewmate))
			continue
		to_chat(crewmate, span_notice("世界旋转并融化，过去倒放在眼前.\n\
			生命漫步回到海洋，收缩成虚无；行星爆炸，成为风暴的尘埃. \
			星星赶回到宇宙开始的时刻相互迎接...一瞬间你又回到了现在. \n\
			一切都如同过去和一直以来的一样. \n\n\
			一个游离的想法出现在你的脑海中. \n\
			[span_hypnophrase("我很高兴[invoker.real_name]是我们合法的正式舰长!")] \n\
			是...这样没错吧?"))
		if (is_captain_job(crewmate.mind.assigned_role))
			former_captains += crewmate
			demote_to_assistant(crewmate)
			continue
		if (crewmate.stat != DEAD)
			other_crew += crewmate

	dress_candidate(invoker)
	GLOB.manifest.modify(invoker.real_name, JOB_CAPTAIN, JOB_CAPTAIN)
	minor_announce("舰长[invoker.real_name]正在甲板上!")

	// Enlist some crew to try and restore the natural order
	for (var/mob/living/carbon/human/former_captain as anything in former_captains)
		create_vendetta(former_captain.mind, invoker.mind)
	for (var/mob/living/carbon/human/random_crewmate as anything in other_crew)
		if (prob(10))
			create_vendetta(random_crewmate.mind, invoker.mind)

/**
 * Anyone who thought they were Captain is in for a nasty surprise, and won't be very happy about it
 */
/datum/grand_finale/usurp/proc/demote_to_assistant(mob/living/carbon/human/former_captain)
	var/obj/effect/particle_effect/fluid/smoke/exit_poof = new(get_turf(former_captain))
	exit_poof.lifetime = 2 SECONDS

	former_captain.unequip_everything()
	if(isplasmaman(former_captain))
		former_captain.equipOutfit(/datum/outfit/plasmaman)
		former_captain.internal = former_captain.get_item_for_held_index(2)
	else
		former_captain.equipOutfit(/datum/outfit/job/assistant)

	GLOB.manifest.modify(former_captain.real_name, JOB_ASSISTANT, JOB_ASSISTANT)
	var/list/valid_turfs = list()
	// Used to be into prison but that felt a bit too mean
	for (var/turf/exile_turf as anything in get_area_turfs(/area/station/maintenance, subtypes = TRUE))
		if (isspaceturf(exile_turf) || exile_turf.is_blocked_turf())
			continue
		valid_turfs += exile_turf
	do_teleport(former_captain, pick(valid_turfs), no_effects = TRUE)
	var/obj/effect/particle_effect/fluid/smoke/enter_poof = new(get_turf(former_captain))
	enter_poof.lifetime = 2 SECONDS

/**
 * Does some item juggling to try to dress you as both a Wizard and Captain without deleting any items you have bought.
 * ID, headset, and uniform are forcibly replaced. Other slots are only filled if unoccupied.
 * We could forcibly replace shoes and gloves too but people might miss their insuls or... meown shoes?
 */
/datum/grand_finale/usurp/proc/dress_candidate(mob/living/carbon/human/invoker)
	// Won't be needing these
	var/obj/id = invoker.get_item_by_slot(ITEM_SLOT_ID)
	QDEL_NULL(id)
	var/obj/headset = invoker.get_item_by_slot(ITEM_SLOT_EARS)
	QDEL_NULL(headset)
	// We're about to take off your pants so those are going to fall out
	var/obj/item/pocket_L = invoker.get_item_by_slot(ITEM_SLOT_LPOCKET)
	var/obj/item/pocket_R = invoker.get_item_by_slot(ITEM_SLOT_RPOCKET)
	// In case we try to put a PDA there
	var/obj/item/belt = invoker.get_item_by_slot(ITEM_SLOT_BELT)
	belt?.moveToNullspace()

	var/obj/pants = invoker.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	QDEL_NULL(pants)
	invoker.equipOutfit(/datum/outfit/job/wizard_captain)
	// And put everything back!
	equip_to_slot_then_hands(invoker, ITEM_SLOT_BELT, belt)
	equip_to_slot_then_hands(invoker, ITEM_SLOT_LPOCKET, pocket_L)
	equip_to_slot_then_hands(invoker, ITEM_SLOT_RPOCKET, pocket_R)

/// An outfit which replaces parts of a wizard's clothes with captain's clothes but keeps the robes
/datum/outfit/job/wizard_captain
	name = "舰长 (巫师转变而来)"
	jobtype = /datum/job/captain
	id = /obj/item/card/id/advanced/gold
	id_trim = /datum/id_trim/job/captain
	uniform = /obj/item/clothing/under/rank/captain/parade
	belt = /obj/item/modular_computer/pda/heads/captain
	ears = /obj/item/radio/headset/heads/captain/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/captain
	shoes = /obj/item/clothing/shoes/laceup
	accessory = /obj/item/clothing/accessory/medal/gold/captain
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/station_charter = 1,
	)
	box = null
