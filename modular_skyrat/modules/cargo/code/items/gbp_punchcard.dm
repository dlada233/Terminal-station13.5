#define GBP_PUNCH_REWARD 100

/obj/item/card/id
	COOLDOWN_DECLARE(gbp_redeem_cooldown)

/obj/item/gbp_punchcard
	name = "杰出助手积分卡"
	desc = "杰出助手积分计划旨在为Nanotrasen站点和殖民地上无业或无薪的人群提供额外的收入<br>\
	只需让任意部门主管再您的积分卡上打孔，就可以到杰出助手积分兑换机处兑换，每次打孔可兑换100信用点！<br>\
	每张积分卡最多可打孔六次，兑换现有积分卡时会自动发放新卡，所以请不要遗失您的积分卡."
	icon = 'modular_skyrat/modules/cargo/icons/punchcard.dmi'
	icon_state = "punchcard_0"
	w_class = WEIGHT_CLASS_TINY
	var/max_punches = 6
	var/punches = 0
	COOLDOWN_DECLARE(gbp_punch_cooldown)

/obj/item/gbp_punchcard/starting
	icon_state = "punchcard_1"
	punches = 1 // GBP_PUNCH_REWARD credits by default

/obj/item/gbp_punchcard/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/gbp_puncher))
		if(!COOLDOWN_FINISHED(src, gbp_punch_cooldown))
			balloon_alert(user, "cooldown! [DisplayTimeText(COOLDOWN_TIMELEFT(src, gbp_punch_cooldown))]")
			return
		if(punches < max_punches)
			punches++
			icon_state = "punchcard_[punches]"
			COOLDOWN_START(src, gbp_punch_cooldown, 90 SECONDS)
			log_econ("[user] punched a GAP card that is now at [punches]/[max_punches] punches.")
			playsound(attacking_item, 'sound/items/boxcutter_activate.ogg', 100)
			if(punches == max_punches)
				playsound(src, 'sound/items/party_horn.ogg', 100)
				say("恭喜，您已经完成了您的积分卡！")
		else
			balloon_alert(user, "no room!")

/obj/item/gbp_puncher
	name = "杰出助手积分打孔机"
	desc = "用于杰出助手积分系统的打孔机，在积分卡上使用就可以打孔了，有事业心的助手可能会纠缠你要求为它们的卡打孔."
	icon = 'modular_skyrat/modules/cargo/icons/punchcard.dmi'
	icon_state = "puncher"
	w_class = WEIGHT_CLASS_TINY

/obj/machinery/gbp_redemption
	name = "杰出助手积分兑换机"
	desc = "在这里兑换你的杰出助手积分，根据打孔数量获得奖励，同时领取一张新积分卡!"
	icon = 'modular_skyrat/modules/cargo/icons/punchcard.dmi'
	icon_state = "gbp_machine"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/gbp_redemption

/obj/machinery/gbp_redemption/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/gbp_redemption/attackby(obj/item/attacking_item, mob/user, params)
	if(default_deconstruction_screwdriver(user, "gbp_machine_open", "gbp_machine", attacking_item))
		return

	if(default_pry_open(attacking_item, close_after_pry = TRUE))
		return

	if(default_deconstruction_crowbar(attacking_item))
		return

	if(istype(attacking_item, /obj/item/gbp_punchcard))
		var/obj/item/gbp_punchcard/punchcard = attacking_item
		var/amount_to_reward = punchcard.punches * GBP_PUNCH_REWARD
		if(!punchcard.punches)
			playsound(src, 'sound/machines/scanbuzz.ogg', 100)
			say("你不能兑换一张未打孔的卡！")
			return

		var/obj/item/card/id/card_used
		if(isliving(user))
			var/mob/living/living_user = user
			card_used = living_user.get_idcard(TRUE)

		if(isnull(card_used))
			return

		if(!COOLDOWN_FINISHED(card_used, gbp_redeem_cooldown))
			balloon_alert(user, "冷静点！ [DisplayTimeText(COOLDOWN_TIMELEFT(card_used, gbp_redeem_cooldown))]")
			return

		if(!card_used.registered_account || !istype(card_used.registered_account.account_job, /datum/job/assistant))
			playsound(src, 'sound/machines/scanbuzz.ogg', 100)
			say("没有有效的助手银行账户，无法兑换积分卡！")
			return

		if(punchcard.punches < punchcard.max_punches)
			if(tgui_alert(user, "你还没有打满积分卡，你确定要兑换，并开始15分钟的兑换限制吗？", "这真是个愚蠢的举动", list("No", "Yes")) != "Yes")
				return

		if(!punchcard.punches) // check to see if someone left the dialog open to redeem a card twice
			return

		var/validated_punches = punchcard.punches
		punchcard.punches = 0
		playsound(src, 'sound/machines/printer.ogg', 100)
		card_used.registered_account.adjust_money(amount_to_reward, "GAP: [validated_punches] punches")
		log_econ("[amount_to_reward] credits were rewarded to [card_used.registered_account.account_holder]'s account for redeeming a GAP card.")
		say("[amount_to_reward] 奖励已发放至您的账户, 并附赠您一个口粮包! 感谢您成为一名杰出助手! 请拿好您的新积分卡.")
		COOLDOWN_START(card_used, gbp_redeem_cooldown, 12 MINUTES)
		user.temporarilyRemoveItemFromInventory(punchcard)
		qdel(punchcard)
		var/obj/item/storage/fancy/nugget_box/nuggies = new(get_turf(src))
		var/obj/item/gbp_punchcard/replacement_card = new(get_turf(src))
		user.put_in_hands(nuggies)
		user.put_in_hands(replacement_card)
		return

	return ..()

/obj/item/circuitboard/machine/gbp_redemption
	name = "杰出助手积分兑换机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/gbp_redemption
	req_components = list(
		/datum/stock_part/servo = 1)


/datum/outfit/job/rd/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1
	)

/datum/outfit/job/hos/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/hop/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/ce/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/cmo/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/captain/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/quartermaster/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(
		/obj/item/gbp_puncher = 1,
	)

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/human, visualsOnly)
	. = ..()
	backpack_contents += list(/obj/item/gbp_punchcard/starting)

/datum/design/board/gbp_machine
	name = "杰出助手积分兑换机电路板"
	desc = "用于杰出助手积分兑换机的电路板."
	id = "gbp_machine"
	build_path = /obj/item/circuitboard/machine/gbp_redemption
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
