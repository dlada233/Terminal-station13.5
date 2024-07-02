/obj/item/firing_pin
	name = "电子撞针"
	desc = "微型的开火认证装置，插入火器来规定它的操作对象；纳米安全法规要求所有的新枪械都设计为必须安装撞针才能开火."
	icon = 'icons/obj/devices/gunmod.dmi'
	icon_state = "firing_pin"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("戳")
	attack_verb_simple = list("戳")
	var/fail_message = "invalid user!"
	/// Explode when user check is failed.
	var/selfdestruct = FALSE
	/// Can forcefully replace other pins.
	var/force_replace = FALSE
	/// Can be replaced by any pin.
	var/pin_hot_swappable = FALSE
	///Can be removed from the gun using tools or replaced by a pin with force_replace
	var/pin_removable = TRUE
	var/obj/item/gun/gun

/obj/item/firing_pin/New(newloc)
	..()
	if(isgun(newloc))
		gun = newloc

/obj/item/firing_pin/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isgun(interacting_with))
		return NONE

	var/obj/item/gun/targeted_gun = interacting_with
	var/obj/item/firing_pin/old_pin = targeted_gun.pin
	if(old_pin?.pin_removable && (force_replace || old_pin.pin_hot_swappable))
		if(Adjacent(user))
			user.put_in_hands(old_pin)
		else
			old_pin.forceMove(targeted_gun.drop_location())
		old_pin.gun_remove(user)

	if(!targeted_gun.pin)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return .
		if(gun_insert(user, targeted_gun))
			if(old_pin)
				balloon_alert(user, "已更换撞针")
			else
				balloon_alert(user, "已安装撞针")
	else
		to_chat(user, span_notice("这把枪已经安装了撞针."))

	return ITEM_INTERACT_SUCCESS

/obj/item/firing_pin/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "authentication checks overridden")
	return TRUE

/obj/item/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	forceMove(gun)
	gun.pin = src
	return TRUE

/obj/item/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	return

/obj/item/firing_pin/proc/pin_auth(mob/living/user)
	return TRUE

/obj/item/firing_pin/proc/auth_fail(mob/living/user)
	if(user)
		balloon_alert(user, fail_message)
	if(selfdestruct)
		if(user)
			user.show_message("[span_danger("自动销毁...")]<br>", MSG_VISUAL)
			to_chat(user, span_userdanger("[gun]爆炸了!"))
		explosion(src, devastation_range = -1, light_impact_range = 2, flash_range = 3)
		if(gun)
			qdel(gun)


/obj/item/firing_pin/magic
	name = "魔法水晶碎片"
	desc = "小魔法水晶碎片，可以让魔法武器开火."


// Test pin, works only near firing range.
/obj/item/firing_pin/test_range
	name = "靶场撞针"
	desc = "该安全撞针限制武器只在靶场范围内开火."
	fail_message = "test range check failed!"
	pin_hot_swappable = TRUE

/obj/item/firing_pin/test_range/pin_auth(mob/living/user)
	if(!istype(user))
		return FALSE
	if (istype(get_area(user), /area/station/security/range))
		return TRUE
	return FALSE


// Implant pin, checks for implant
/obj/item/firing_pin/implant
	name = "植入键撞针"
	desc = "该安保撞针限制武器只能被拥有特定植入物的人使用."
	fail_message = "implant check failed!"
	var/obj/item/implant/req_implant = null

/obj/item/firing_pin/implant/pin_auth(mob/living/user)
	if(user)
		for(var/obj/item/implant/I in user.implants)
			if(req_implant && I.type == req_implant)
				return TRUE
	return FALSE

/obj/item/firing_pin/implant/mindshield
	name = "心盾撞针"
	desc = "该安保撞针限制武器只能被拥有心盾植入物的人使用."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

/obj/item/firing_pin/implant/pindicate
	name = "辛迪加撞针"
	icon_state = "firing_pin_pindi"
	req_implant = /obj/item/implant/weapons_auth



// Honk pin, clown's joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun!
/obj/item/firing_pin/clown
	name = "搞笑撞针"
	desc = "先进的小丑技术将武器们变得更加实用."
	color = COLOR_YELLOW
	fail_message = "honk!"
	force_replace = TRUE

/obj/item/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src, 'sound/items/bikehorn.ogg', 50, TRUE)
	return FALSE

// Ultra-honk pin, clown's deadly joke item.
// A gun with ultra-honk pin is useful for clown and useless for everyone else.
/obj/item/firing_pin/clown/ultra
	name = "超级搞笑撞针"

/obj/item/firing_pin/clown/ultra/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, TRUE)
	if(QDELETED(user))  //how the hell...?
		stack_trace("/obj/item/firing_pin/clown/ultra/pin_auth called with a [isnull(user) ? "null" : "invalid"] user.")
		return TRUE
	if(HAS_TRAIT(user, TRAIT_CLUMSY)) //clumsy
		return TRUE
	if(user.mind)
		if(is_clown_job(user.mind.assigned_role)) //traitor clowns can use this, even though they're technically not clumsy
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/clownop)) //clown ops aren't clumsy by default and technically don't have an assigned role of "Clown", but come on, they're basically clowns
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/nukeop/leader/clownop)) //Wanna hear a funny joke?
			return TRUE //The clown op leader antag datum isn't a subtype of the normal clown op antag datum.
	return FALSE

/obj/item/firing_pin/clown/ultra/gun_insert(mob/living/user, obj/item/gun/G)
	..()
	G.clumsy_check = FALSE

/obj/item/firing_pin/clown/ultra/gun_remove(mob/living/user)
	gun.clumsy_check = initial(gun.clumsy_check)
	..()

// Now two times deadlier!
/obj/item/firing_pin/clown/ultra/selfdestruct
	name = "超级超级搞笑撞针"
	desc = "先进的小丑技术将武器们变得更加实用，它带了一个小小的硝基香蕉电荷."
	selfdestruct = TRUE


// DNA-keyed pin.
// When you want to keep your toys for yourself.
/obj/item/firing_pin/dna
	name = "DNA键撞针"
	desc = "该撞针限制武器只能被特定DNA人物使用，安装武器后的第一次发射以建立DNA链接."
	icon_state = "firing_pin_dna"
	fail_message = "dna check failed!"
	var/unique_enzymes = null

/obj/item/firing_pin/dna/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(iscarbon(interacting_with))
		var/mob/living/carbon/M = interacting_with
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			balloon_alert(user, "DNA锁设置")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(user && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE
	return FALSE

/obj/item/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(user && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			balloon_alert(user, "DNA锁设置")
	else
		..()

/obj/item/firing_pin/dna/dredd
	desc = "该撞针限制武器只能被特定DNA人物使用，安装武器后的第一次发射以建立DNA链接，有一个微型的炸药安装在这支撞针上."
	selfdestruct = TRUE

// Paywall pin, brought to you by ARMA 3 DLC.
// Checks if the user has a valid bank account on an ID and if so attempts to extract a one-time payment to authorize use of the gun. Otherwise fails to shoot.
/obj/item/firing_pin/paywall
	name = "付费撞针"
	desc = "该撞针使武器开火时从使用者的银行账户中扣款，付款方式可事前自定义设置."
	color = COLOR_GOLD
	fail_message = ""
	///list of account IDs which have accepted the license prompt. If this is the multi-payment pin, then this means they accepted the waiver that each shot will cost them money
	var/list/gun_owners = list()
	///how much gets paid out to license yourself to the gun
	var/payment_amount
	var/datum/bank_account/pin_owner
	///if true, user has to pay everytime they fire the gun
	var/multi_payment = FALSE
	var/owned = FALSE
	///purchase prompt to prevent spamming it, set to the user who opens to prompt to prevent locking the gun up for other users.
	var/active_prompt_user

/obj/item/firing_pin/paywall/attack_self(mob/user)
	multi_payment = !multi_payment
	to_chat(user, span_notice("你将撞针设置为 [( multi_payment ) ? "每次发射扣款" : "一次性许可证扣款"]."))

/obj/item/firing_pin/paywall/examine(mob/user)
	. = ..()
	if(pin_owner)
		. += span_notice("该撞针由[pin_owner.account_holder]的银行账户授权支付.")

/obj/item/firing_pin/paywall/gun_insert(mob/living/user, obj/item/gun/G)
	if(!pin_owner)
		to_chat(user, span_warning("错误: 安装撞针前，请先刷有效身份证件!"))
		user.put_in_hands(src)
		return FALSE
	gun = G
	forceMove(gun)
	gun.pin = src
	if(multi_payment)
		gun.desc += span_notice(" [gun.name]每次开火将消费[payment_amount]信用点[( payment_amount > 1 ) ? "" : ""].")
		return TRUE
	gun.desc += span_notice(" [gun.name]的许可证费用为[payment_amount]信用点[( payment_amount > 1 ) ? "" : ""].")
	return TRUE


/obj/item/firing_pin/paywall/gun_remove(mob/living/user)
	gun.desc = initial(desc)
	..()

/obj/item/firing_pin/paywall/attackby(obj/item/M, mob/living/user, params)
	if(isidcard(M))
		var/obj/item/card/id/id = M
		if(!id.registered_account)
			to_chat(user, span_warning("错误: 该身份证件没有绑定的银行账户!"))
			return
		if(id.registered_account != pin_owner && owned)
			to_chat(user, span_warning("错误: 该撞针已经被授权支付了!"))
			return
		if(id.registered_account == pin_owner)
			to_chat(user, span_notice("你把证件从撞针上解绑."))
			gun_owners -= user.get_bank_account()
			pin_owner = null
			owned = FALSE
			return
		var/transaction_amount = tgui_input_number(user, "填写用于枪支购买的有效预付款", "预付款")
		if(!transaction_amount || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
			return
		pin_owner = id.registered_account
		owned = TRUE
		payment_amount = transaction_amount
		gun_owners += user.get_bank_account()
		to_chat(user, span_notice("你将证件连接到撞针."))

/obj/item/firing_pin/paywall/pin_auth(mob/living/user)
	if(!istype(user))//nice try commie
		return FALSE
	var/datum/bank_account/credit_card_details = user.get_bank_account()
	if(credit_card_details in gun_owners)
		if(multi_payment && credit_card_details)
			if(!gun.can_shoot())
				return TRUE //So you don't get charged for attempting to fire an empty gun.
			if(credit_card_details.adjust_money(-payment_amount, "撞针: 枪租"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "撞针: 支付枪租")
				return TRUE
			to_chat(user, span_warning("错误: 用户余额不足，交易无法进行!"))
			return FALSE
		return TRUE
	if(!credit_card_details)
		to_chat(user, span_warning("错误: 用户没有有效的银行账户来支付金额!"))
		return FALSE
	if(active_prompt_user == user)
		return FALSE
	active_prompt_user = user
	var/license_request = tgui_alert(user, "对于[( multi_payment ) ? "[gun.name]的每次射击" : "[gun.name]的使用许可证"]，你希望支付多少[payment_amount]信用点[( payment_amount > 1 ) ? "" : ""]?", "武器购买", list("Yes", "No"), 15 SECONDS)
	if(!user.can_perform_action(src))
		active_prompt_user = null
		return FALSE
	switch(license_request)
		if("Yes")
			if(multi_payment)
				gun_owners += credit_card_details
				to_chat(user, span_notice("枪械租赁条款成立，祝你今日平安!"))

			else if(credit_card_details.adjust_money(-payment_amount, "撞针: 枪械许可证"))
				if(pin_owner)
					pin_owner.adjust_money(payment_amount, "撞针: 购买枪械许可证")
				gun_owners += credit_card_details
				to_chat(user, span_notice("枪械许可证已购买，祝你今日平安!"))

			else
				to_chat(user, span_warning("错误: 用户余额不足，交易无法进行!"))

		if("No", null)
			to_chat(user, span_warning("错误: 用户已拒绝购买枪支许可证"))
	active_prompt_user = null
	return FALSE //we return false here so you don't click initially to fire, get the prompt, accept the prompt, and THEN the gun

// Explorer Firing Pin- Prevents use on station Z-Level, so it's justifiable to give Explorers guns that don't suck.
/obj/item/firing_pin/explorer
	name = "内陆撞针"
	desc = "澳大利亚国防军使用的一种撞针，限制武器无法在太空站范围内开火."
	icon_state = "firing_pin_explorer"
	fail_message = "在站里不能开火，伙计!"

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/explorer/pin_auth(mob/living/user)
	var/turf/station_check = get_turf(user)
	if(!station_check || is_station_level(station_check.z))
		return FALSE
	return TRUE

// Laser tag pins
/obj/item/firing_pin/tag
	name = "激光大战撞针"
	desc = "休闲游戏激光大战所用激光枪的撞针，确保使用者穿着对应的游戏背心."
	fail_message = "suit check failed!"
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return TRUE
	to_chat(user, span_warning("你需要穿戴对应的[tagcolor]激光标靶背心!"))
	return FALSE

/obj/item/firing_pin/tag/red
	name = "红色信号激光撞针"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "红色"

/obj/item/firing_pin/tag/blue
	name = "蓝色信号激光撞针"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "蓝色"

/obj/item/firing_pin/monkey
	name = "猿锁撞针"
	desc = "该撞针限制武器只能由猴子使用."
	fail_message = "非我猴类!"

/obj/item/firing_pin/monkey/pin_auth(mob/living/user)
	if(!is_simian(user))
		playsound(src, SFX_SCREECH, 75, TRUE)
		return FALSE
	return TRUE

/obj/item/firing_pin/Destroy()
	if(gun)
		gun.pin = null
		gun = null
	return ..()
