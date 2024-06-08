/obj/item/implant/camouflage
	name = "实验性迷彩植入物"
	desc = "允许植入者融入周围环境. Cool!"
	actions_types = list(/datum/action/item_action/camouflage)

/obj/item/implant/camouflage/emp_act(severity)
	. = ..()

	if(prob(15 * severity))
		visible_message(span_warning("你植入物内的隐形系统开始超负荷运转!"), blind_message = span_hear("你听到嘶嘶声和火花的噼啪声."))
		for(var/datum/action/item_action/camouflage/cloaking_ability in actions)
			cloaking_ability.remove_cloaking()

/datum/action/item_action/camouflage
	name = "激活迷彩"
	desc = "激活迷城植入物，融入到周围的环境中..."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "invisibility"
	/// The alpha we move to when activating this action.
	var/camouflage_alpha = 35
	/// Are we currently cloaking ourself?
	var/cloaking = FALSE

/datum/action/item_action/camouflage/Remove(mob/living/remove_from)
	if(owner)
		remove_cloaking()

	return ..()

/datum/action/item_action/camouflage/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE

	if(cloaking)
		remove_cloaking()
	else
		owner.alpha = camouflage_alpha
		to_chat(owner, span_notice("你激活你的迷彩植入物，融入到周围的环境..."))
		cloaking = TRUE

	return TRUE

/**
 * Returns the owner's alpha value to its initial value,
 *
 * Disables cloaking and flashes sparks. Used when toggling the ability, as well as to
 * make sure the action properly resets its owner when removed.
 */

/datum/action/item_action/camouflage/proc/remove_cloaking()
	do_sparks(2, FALSE, owner)
	owner.alpha = initial(owner.alpha)
	to_chat(owner, span_notice("你关闭了你的迷彩，你能被别人看见了..."))
	cloaking = FALSE

/obj/item/reagent_containers/hypospray/medipen/invisibility
	name = "隐形自动注射器"
	desc = "内含稳定态的土星X化合物. 为秘密特种作战而生产，为那些喜欢裸体的特工生产."
	icon_state = "invispen"
	base_icon_state = "invispen"
	volume = 20 //By my estimate this will last you about 10-ish mintues
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/drug/saturnx/stable = 20)
	label_examine = FALSE
