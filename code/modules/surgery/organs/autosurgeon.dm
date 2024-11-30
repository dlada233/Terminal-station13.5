/obj/item/autosurgeon
	name = "全自动手术仪"
	desc = "一种能自动将植入物、技术芯片或器官插入使用者体内，而无需进行大规模手术的设备. \
		它有一个插入植入物或器官的插槽和一个螺丝刀插槽，用于移除意外添加的物品."
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "autosurgeon"
	inhand_icon_state = "nothing"
	w_class = WEIGHT_CLASS_SMALL

	/// How many times you can use the autosurgeon before it becomes useless
	var/uses = INFINITE
	/// What organ will the autosurgeon sub-type will start with. ie, CMO autosurgeon start with a medi-hud.
	var/starting_organ
	/// The organ currently loaded in the autosurgeon, ready to be implanted.
	var/obj/item/organ/stored_organ
	/// The list of organs and their children we allow into the autosurgeon. An empty list means no whitelist.
	var/list/organ_whitelist = list()
	/// The percentage modifier for how fast you can use the autosurgeon to implant other people.
	var/surgery_speed = 1
	/// The overlay that shows when the autosurgeon has an organ inside of it.
	var/loaded_overlay = "autosurgeon_loaded_overlay"

/obj/item/autosurgeon/attack_self_tk(mob/user)
	return //stops TK fuckery

/obj/item/autosurgeon/Initialize(mapload)
	. = ..()
	if(starting_organ)
		load_organ(new starting_organ(src))

/obj/item/autosurgeon/update_overlays()
	. = ..()
	if(stored_organ)
		. += loaded_overlay
		. += emissive_appearance(icon, loaded_overlay, src)

/obj/item/autosurgeon/proc/load_organ(obj/item/organ/loaded_organ, mob/living/user)
	if(user)
		if(stored_organ)
			to_chat(user, span_alert("[src]已经存储了一个植入物."))
			return

		if(uses == 0)
			to_chat(user, span_alert("[src]使用次数已用完，无法再加载更多植入物."))
			return

		if(organ_whitelist.len)
			var/organ_whitelisted
			for(var/whitelisted_organ in organ_whitelist)
				if(istype(loaded_organ, whitelisted_organ))
					organ_whitelisted = TRUE
					break
			if(!organ_whitelisted)
				to_chat(user, span_alert("[src]与[loaded_organ]不兼容."))
				return

		if(!user.transferItemToLoc(loaded_organ, src))
			to_chat(user, span_alert("[loaded_organ]粘在了你的手上!"))
			return

	stored_organ = loaded_organ
	loaded_organ.forceMove(src)

	name = "[initial(name)] ([stored_organ.name])" //to tell you the organ type, like "suspicious autosurgeon (Reviver implant)"
	update_appearance()

/obj/item/autosurgeon/proc/use_autosurgeon(mob/living/target, mob/living/user, implant_time)
	if(!stored_organ)
		to_chat(user, span_alert("[src]当前没有存储任何植入物"))
		return

	if(!uses)
		to_chat(user, span_alert("[src]已经被使用过，工具已经钝化，无法重新激活."))
		return

	if(implant_time)
		user.visible_message(
			span_notice("[user]准备使用[src]对[target]进行操作."),
			span_notice("你开始准备使用[src]对[target]进行操作."),
		)
		if(!do_after(user, (implant_time * surgery_speed), target))
			return

	if(target != user)
		log_combat(user, target, "使用自动手术仪将[stored_organ]植入", "[src]", "在[AREACOORD(target)]")
		user.visible_message(span_notice("[user]按下了[src]上的按钮，它刺入了[target]的身体."), span_notice("你按下了[src]上的按钮， 它刺入了[target]的身体."))
	else
		user.visible_message(
			span_notice("[user]按下了[src]上的按钮，然后它刺入了身体."),
			span_notice("你按下了[src]上的按钮，它刺入了你的身体."),
		)

	stored_organ.Insert(target)//insert stored organ into the user
	stored_organ = null
	name = initial(name) //get rid of the organ in the name
	playsound(target.loc, 'sound/weapons/circsawhit.ogg', 50, vary = TRUE)
	update_appearance()

	if(uses)
		uses--
	if(uses == 0)
		desc = "[initial(desc)]使用次数看起来已经用完了."

/obj/item/autosurgeon/attack_self(mob/user)//when the object it used...
	use_autosurgeon(user, user)

/obj/item/autosurgeon/attack(mob/living/target, mob/living/user, params)
	add_fingerprint(user)
	use_autosurgeon(target, user, 8 SECONDS)

/obj/item/autosurgeon/attackby(obj/item/attacking_item, mob/user, params)
	if(isorgan(attacking_item))
		load_organ(attacking_item, user)
	else
		return ..()



/obj/item/autosurgeon/screwdriver_act(mob/living/user, obj/item/screwtool)
	if(..())
		return TRUE
	if(!stored_organ)
		to_chat(user, span_warning("[src]中没有植入物需要移除!"))
	else
		var/atom/drop_loc = user.drop_location()
		for(var/atom/movable/stored_implant as anything in src)
			stored_implant.forceMove(drop_loc)
			to_chat(user, span_notice("你从[src]中移除[stored_organ]."))
			stored_organ = null

		screwtool.play_tool_sound(src)
		if (uses)
			uses--
		if(!uses)
			desc = "[initial(desc)]使用次数看起来已经用完了."
		update_appearance(UPDATE_ICON)
	return TRUE

/obj/item/autosurgeon/medical_hud
	name = "全自动手术仪"
	desc = "这是一次性使用的全自动手术仪，内置医疗抬头显示器增强装置。可以使用螺丝刀将其拆除，但无法重新植入."
	uses = 1
	starting_organ = /obj/item/organ/internal/cyberimp/eyes/hud/medical


/obj/item/autosurgeon/syndicate
	name = "可疑全自动手术仪"
	icon_state = "autosurgeon_syndicate"
	surgery_speed = 0.75
	loaded_overlay = "autosurgeon_syndicate_loaded_overlay"

/obj/item/autosurgeon/syndicate/laser_arm
	desc = "这是一次性使用的可疑全自动手术仪，内置战斗型激光臂增强装置。可以使用螺丝刀将其拆除，但无法重新植入."
	uses = 1
	starting_organ = /obj/item/organ/internal/cyberimp/arm/gun/laser

/obj/item/autosurgeon/syndicate/thermal_eyes
	starting_organ = /obj/item/organ/internal/eyes/robotic/thermals

/obj/item/autosurgeon/syndicate/thermal_eyes/single_use
	uses = 1

/obj/item/autosurgeon/syndicate/xray_eyes
	starting_organ = /obj/item/organ/internal/eyes/robotic/xray

/obj/item/autosurgeon/syndicate/xray_eyes/single_use
	uses = 1

/obj/item/autosurgeon/syndicate/anti_stun
	starting_organ = /obj/item/organ/internal/cyberimp/brain/anti_stun

/obj/item/autosurgeon/syndicate/anti_stun/single_use
	uses = 1

/obj/item/autosurgeon/syndicate/reviver
	starting_organ = /obj/item/organ/internal/cyberimp/chest/reviver

/obj/item/autosurgeon/syndicate/reviver/single_use
	uses = 1

/obj/item/autosurgeon/syndicate/commsagent
	desc = "这是一种会自动（且痛苦地）植入器官的设备，看起来有人特别改装了它，只能植入...舌头，真是骇人听闻."
	starting_organ = /obj/item/organ/internal/tongue

/obj/item/autosurgeon/syndicate/commsagent/Initialize(mapload)
	. = ..()
	organ_whitelist += /obj/item/organ/internal/tongue

/obj/item/autosurgeon/syndicate/emaggedsurgerytoolset
	starting_organ = /obj/item/organ/internal/cyberimp/arm/surgery/emagged

/obj/item/autosurgeon/syndicate/emaggedsurgerytoolset/single_use
	uses = 1

/obj/item/autosurgeon/syndicate/contraband_sechud
	desc = "内含违禁的安全抬头显示器（SecHUD）植入物，健康扫描仪无法检测."
	uses = 1
	starting_organ = /obj/item/organ/internal/cyberimp/eyes/hud/security/syndicate
