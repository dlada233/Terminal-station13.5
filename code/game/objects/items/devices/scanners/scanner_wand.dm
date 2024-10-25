/obj/item/scanner_wand
	name = "诊断亭扫描棒"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "scanner_wand"
	inhand_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "可以扫描人体的棒子，一般插在医疗诊断亭上供其自动使用."
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_BULKY
	var/selected_target = null

/obj/item/scanner_wand/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]_active", src) //nice little visual flash when scanning someone else.

	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(25))
		user.visible_message(span_warning("[user]对自己进行扫描."), \
		to_chat(user, span_info("你尝试扫描[M], 然后你意识到自己把扫描仪拿反了. 哎呦.")))
		selected_target = user
		return

	if(!ishuman(M))
		to_chat(user, span_info("你只能扫描类人的非机器生物."))
		selected_target = null
		return

	user.visible_message(span_notice("[user]对[M]进行扫描."), \
						span_notice("你扫描[M]的状态."))
	selected_target = M
	return

/obj/item/scanner_wand/attack_self(mob/user)
	to_chat(user, span_info("你清除了扫描器的当前目标."))
	selected_target = null

/obj/item/scanner_wand/proc/return_patient()
	var/returned_target = selected_target
	return returned_target
