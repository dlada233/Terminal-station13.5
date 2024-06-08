/// 生成一个契约伙伴给一个生成用户，并分配给新玩家一个给定的密钥.
/proc/spawn_contractor_partner(mob/living/user, key)
	var/mob/living/carbon/human/partner = new()
	var/datum/outfit/contractor_partner/partner_outfit = new()

	partner_outfit.equip(partner)

	var/obj/structure/closet/supplypod/arrival_pod = new(null, STYLE_SYNDICATE)
	arrival_pod.explosionSize = list(0,0,0,1)
	arrival_pod.bluespace = TRUE

	var/turf/free_location = find_obstruction_free_location(2, user)

	// 我们非常想送他们 - 如果找不到合适的位置，就直接降落在他们身上.
	if (!free_location)
		free_location = get_turf(user)

	partner.forceMove(arrival_pod)
	partner.ckey = key

	/// 我们给一个参考，将作为支援单位的心智
	var/datum/antagonist/traitor/contractor_support/new_datum = partner.mind.add_antag_datum(/datum/antagonist/traitor/contractor_support)

	to_chat(partner, "\n[span_alertwarning("[user.real_name]是你的上级，遵循他们给出的任何命令，你只要协助他们执行任务就好. ")]")
	to_chat(partner, "[span_alertwarning("如果他们死亡或无法执行任务，你应尽最大努力协助该任务区域的其他活跃特工. ")]")

	new /obj/effect/pod_landingzone(free_location, arrival_pod)
	return new_datum

/// 支援单位有自己的非常基础的反派数据，用于管理员日志记录.
/datum/antagonist/traitor/contractor_support
	name = "契约支援单位"
	show_in_roundend = FALSE
	give_objectives = TRUE
	give_uplink = FALSE

/datum/antagonist/traitor/contractor_support/forge_traitor_objectives()
	var/datum/objective/generic_objective = new
	generic_objective.name = "遵循契约签署人的命令"
	generic_objective.explanation_text = "遵循你的命令. 协助该任务区域的特工. "
	generic_objective.completed = TRUE
	objectives += generic_objective

/datum/antagonist/traitor/contractor_support/forge_ending_objective()
	return

/datum/outfit/contractor_partner
	name = "契约支援单位"

	uniform = /obj/item/clothing/under/chameleon
	suit = /obj/item/clothing/suit/chameleon
	back = /obj/item/storage/backpack
	belt = /obj/item/modular_computer/pda/chameleon
	mask = /obj/item/clothing/mask/cigarette/syndicate
	shoes = /obj/item/clothing/shoes/chameleon/noslip
	ears = /obj/item/radio/headset/chameleon
	id = /obj/item/card/id/advanced/chameleon
	r_hand = /obj/item/storage/toolbox/syndicate
	id_trim = /datum/id_trim/chameleon/operative

	backpack_contents = list(
		/obj/item/storage/box/survival,
		/obj/item/implanter/uplink,
		/obj/item/clothing/mask/chameleon,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
		/obj/item/lighter,
	)

/datum/outfit/contractor_partner/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/clothing/mask/cigarette/syndicate/cig = H.get_item_by_slot(ITEM_SLOT_MASK)
	cig.light()
