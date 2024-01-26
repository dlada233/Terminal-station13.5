/obj/item/climbing_hook
	name = "攀岩钩"
	desc = "带着绳索的标准攀岩钩，绳子质量一般，再加上你的体重和其他因素，极端情况下无法确保正常使用."
	icon = 'icons/obj/mining.dmi'
	icon_state = "climbingrope"
	inhand_icon_state = "crowbar_brass"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	force = 5
	throwforce = 10
	reach = 2
	throw_range = 4
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("重击了", "挥舞甩击", "攻击了")
	attack_verb_simple = list("重击了", "挥舞甩击", "攻击了")
	resistance_flags = FLAMMABLE
	///how many times can we climb with this rope
	var/uses = 5
	///climb time
	var/climb_time = 2.5 SECONDS

/obj/item/climbing_hook/examine(mob/user)
	. = ..()
	var/list/look_binds = user.client.prefs.key_bindings["look up"]
	. += span_notice("首先，保持目光朝上 <b>[english_list(look_binds, nothing_text = "(nothing bound)", and_text = " or ", comma_text = ", or ")]!</b>")
	. += span_notice("然后，点击靠近你上方洞口的固体地面.")
	. += span_notice("这根绳子看起来再用[uses]次会断掉.")

/obj/item/climbing_hook/afterattack(turf/open/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(target.z == user.z)
		return
	if(!istype(target) || isopenspaceturf(target))
		return

	var/turf/user_turf = get_turf(user)
	var/turf/above = GET_TURF_ABOVE(user_turf)
	if(target_blocked(target, above))
		return
	if(!isopenspaceturf(above) || !above.Adjacent(target)) //are we below a hole, is the target blocked, is the target adjacent to our hole
		balloon_alert(user, "堵住了!")
		return

	var/away_dir = get_dir(above, target)
	user.visible_message(span_notice("[user]开始用[src]向上爬."), span_notice("你需要正确地构住[src]并向上移动."))
	playsound(target, 'sound/effects/picaxe1.ogg', 50) //plays twice so people above and below can hear
	playsound(user_turf, 'sound/effects/picaxe1.ogg', 50)
	var/list/effects = list(new /obj/effect/temp_visual/climbing_hook(target, away_dir), new /obj/effect/temp_visual/climbing_hook(user_turf, away_dir))

	if(do_after(user, climb_time, target))
		user.forceMove(target)
		uses--

	if(uses <= 0)
		user.visible_message(span_warning("[src]断裂!"))
		qdel(src)

	QDEL_LIST(effects)

// didnt want to mess up is_blocked_turf_ignore_climbable
/// checks if our target is blocked, also checks for border objects facing the above turf and climbable stuff
/obj/item/climbing_hook/proc/target_blocked(turf/target, turf/above)
	if(target.density || above.density)
		return TRUE

	for(var/atom/movable/atom_content as anything in target.contents)
		if(isliving(atom_content))
			continue
		if(HAS_TRAIT(atom_content, TRAIT_CLIMBABLE))
			continue
		if((atom_content.flags_1 & ON_BORDER_1) && atom_content.dir != get_dir(target, above)) //if the border object is facing the hole then it is blocking us, likely
			continue
		if(atom_content.density)
			return TRUE
	return FALSE

/obj/item/climbing_hook/emergency
	name = "应急攀岩钩"
	desc = "带着绳索的应急攀岩钩，绳子极廉价，可能经不起长时间使用."
	uses = 2
	climb_time = 4 SECONDS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/climbing_hook/syndicate
	name = "可疑地攀岩钩"
	desc = "真的很可疑的攀岩钩，上面刻着辛迪加的标志，看起来相当耐用."
	icon_state = "climbingrope_s"
	uses = 10
	climb_time = 1.5 SECONDS

/obj/item/climbing_hook/infinite //debug stuff
	name = "无限攀岩钩"
	desc = "A plasteel hook, with rope. Upon closer inspection, the rope appears to be made out of plasteel woven into regular rope, amongst many other reinforcements."
	uses = INFINITY
	climb_time = 1 SECONDS

/obj/effect/temp_visual/climbing_hook
	icon = 'icons/mob/silicon/aibots.dmi'
	icon_state = "path_indicator"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	duration = 4 SECONDS

/obj/effect/temp_visual/climbing_hook/Initialize(mapload, direction)
	. = ..()
	dir = direction
