/obj/item/organ/internal/heart/gland/plasma
	abductor_hint = "等离子废气排放器. 使被劫持者随机地释放等离子云."
	cooldown_low = 1200
	cooldown_high = 1800
	icon_state = "slime"
	uses = -1
	mind_control_uses = 1
	mind_control_duration = 800

/obj/item/organ/internal/heart/gland/plasma/activate()
	to_chat(owner, span_warning("你感觉有点胀气."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), owner, span_userdanger("一阵剧痛袭来，你感到胃部剧痛难忍.")), 15 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(vomit_plasma)), 200)

/obj/item/organ/internal/heart/gland/plasma/proc/vomit_plasma()
	if(!owner)
		return
	owner.visible_message(span_danger("[owner]吐出一团等离子云!"))
	var/turf/open/T = get_turf(owner)
	if(istype(T))
		T.atmos_spawn_air("[GAS_PLASMA]=50;[TURF_TEMPERATURE(T20C)]")
	owner.vomit(VOMIT_CATEGORY_DEFAULT)
