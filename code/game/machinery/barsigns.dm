/obj/machinery/barsign // All Signs are 64 by 32 pixels, they take two tiles
	name = "酒吧招牌"
	desc = "A bar sign which has not been initialized, somehow. Complain at a coder!"
	icon = 'icons/obj/machines/barsigns.dmi'
	icon_state = "empty"
	req_access = list(ACCESS_BAR)
	max_integrity = 500
	integrity_failure = 0.5
	armor_type = /datum/armor/sign_barsign
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.15
	/// Selected barsign being used
	var/datum/barsign/chosen_sign
	/// Do we attempt to rename the area we occupy when the chosen sign is changed?
	var/change_area_name = FALSE
	/// What kind of sign do we drop upon being disassembled?
	var/disassemble_result = /obj/item/wallframe/barsign

/datum/armor/sign_barsign
	melee = 20
	bullet = 20
	laser = 20
	energy = 100
	fire = 50
	acid = 50

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/barsign, 32)

/obj/machinery/barsign/Initialize(mapload)
	. = ..()
	//Roundstart/map specific barsigns "belong" in their area and should be renaming it, signs created from wallmounts will not.
	change_area_name = mapload
	set_sign(new /datum/barsign/hiddensigns/signoff)
	find_and_hang_on_wall()

/obj/machinery/barsign/proc/set_sign(datum/barsign/sign)
	if(!istype(sign))
		return

	var/area/bar_area = get_area(src)
	if(change_area_name && sign.rename_area)
		rename_area(bar_area, sign.name)

	chosen_sign = sign
	update_appearance()

/obj/machinery/barsign/update_icon_state()
	if(!(machine_stat & BROKEN) && (!(machine_stat & NOPOWER) || machine_stat & EMPED) && chosen_sign && chosen_sign.icon_state)
		icon_state = chosen_sign.icon_state
	else
		icon_state = "empty"

	return ..()

/obj/machinery/barsign/update_desc()
	. = ..()

	if(chosen_sign && chosen_sign.desc)
		desc = chosen_sign.desc

/obj/machinery/barsign/update_name()
	. = ..()
	if(chosen_sign && chosen_sign.rename_area)
		name = "[initial(name)] ([chosen_sign.name])"
	else
		name = "[initial(name)]"

/obj/machinery/barsign/update_overlays()
	. = ..()

	if(((machine_stat & NOPOWER) && !(machine_stat & EMPED)) || (machine_stat & BROKEN))
		return

	if(chosen_sign && chosen_sign.light_mask)
		. += emissive_appearance(icon, "[chosen_sign.icon_state]-light-mask", src)

/obj/machinery/barsign/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		set_light(0)
		return
	if(chosen_sign && chosen_sign.neon_color)
		set_light(MINIMUM_USEFUL_LIGHT_RANGE, 0.7, chosen_sign.neon_color)

/obj/machinery/barsign/proc/set_sign_by_name(sign_name)
	for(var/datum/barsign/sign as anything in subtypesof(/datum/barsign))
		if(initial(sign.name) == sign_name)
			var/new_sign = new sign
			set_sign(new_sign)

/obj/machinery/barsign/atom_break(damage_flag)
	. = ..()
	if(machine_stat & BROKEN)
		set_sign(new /datum/barsign/hiddensigns/signoff)

/obj/machinery/barsign/on_deconstruction(disassembled)
	if(disassembled)
		new disassemble_result(drop_location())
	else
		new /obj/item/stack/sheet/iron(drop_location(), 2)
		new /obj/item/stack/cable_coil(drop_location(), 2)

/obj/machinery/barsign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src.loc, 'sound/effects/glasshit.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, TRUE)

/obj/machinery/barsign/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/barsign/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!allowed(user))
		balloon_alert(user, "访问被拒绝!")
		return
	if(machine_stat & (NOPOWER|BROKEN|EMPED))
		balloon_alert(user, "控件没有响应!")
		return
	pick_sign(user)

/obj/machinery/barsign/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	panel_open = !panel_open
	if(panel_open)
		balloon_alert(user, "检修盖已打开")
		set_sign(new /datum/barsign/hiddensigns/signoff)
		return ITEM_INTERACT_SUCCESS

	balloon_alert(user, "检修盖已关闭")

	if(machine_stat & (NOPOWER|BROKEN) || !chosen_sign)
		set_sign(new /datum/barsign/hiddensigns/signoff)
	else
		set_sign(chosen_sign)

	return ITEM_INTERACT_SUCCESS

/obj/machinery/barsign/wrench_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		balloon_alert(user, "先打开检修盖!")
		return ITEM_INTERACT_BLOCKING

	tool.play_tool_sound(src)
	if(!do_after(user, (10 SECONDS), target = src))
		return ITEM_INTERACT_BLOCKING

	tool.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/barsign/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/blueprints) && !change_area_name)
		if(!panel_open)
			balloon_alert(user, "先打开检修盖!")
			return TRUE

		change_area_name = TRUE
		balloon_alert(user, "招牌已注册")
		return TRUE

	if(istype(attacking_item, /obj/item/stack/cable_coil) && panel_open)
		var/obj/item/stack/cable_coil/wire = attacking_item

		if(atom_integrity >= max_integrity)
			balloon_alert(user, "不需要修理!")
			return TRUE

		if(!wire.use(2))
			balloon_alert(user, "需要两份线缆!")
			return TRUE

		balloon_alert(user, "已修理")
		atom_integrity = max_integrity
		set_machine_stat(machine_stat & ~BROKEN)
		update_appearance()
		return TRUE

	return ..()

/obj/machinery/barsign/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	set_machine_stat(machine_stat | EMPED)
	addtimer(CALLBACK(src, PROC_REF(fix_emp), chosen_sign), 60 SECONDS)
	set_sign(new /datum/barsign/hiddensigns/empbarsign)

/// Callback to un-emp the sign some time.
/obj/machinery/barsign/proc/fix_emp(datum/barsign/sign)
	set_machine_stat(machine_stat & ~EMPED)
	if(!istype(sign))
		return

	set_sign(sign)

/obj/machinery/barsign/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(machine_stat & (NOPOWER|BROKEN|EMPED))
		balloon_alert(user, "控件没有响应!")
		return FALSE

	balloon_alert(user, "非法酒吧招牌已加载")
	addtimer(CALLBACK(src, PROC_REF(finish_emag_act)), 10 SECONDS)
	return TRUE

/// Timer proc, called after ~10 seconds after [emag_act], since [emag_act] returns a value and cannot sleep
/obj/machinery/barsign/proc/finish_emag_act()
	set_sign(new /datum/barsign/hiddensigns/syndibarsign)

/obj/machinery/barsign/proc/pick_sign(mob/user)
	var/picked_name = tgui_input_list(user, "可用招牌", "酒吧招牌", sort_list(get_bar_names()))
	if(isnull(picked_name))
		return
	set_sign_by_name(picked_name)
	SSblackbox.record_feedback("tally", "barsign_picked", 1, chosen_sign.type)

/proc/get_bar_names()
	var/list/names = list()
	for(var/d in subtypesof(/datum/barsign))
		var/datum/barsign/D = d
		if(!initial(D.hidden))
			names += initial(D.name)
	. = names

/datum/barsign
	/// User-visible name of the sign.
	var/name
	/// Icon state associated with this sign
	var/icon_state
	/// Description shown in the sign's examine text.
	var/desc
	/// Hidden from list of selectable options.
	var/hidden = FALSE
	/// Rename the area when this sign is selected.
	var/rename_area = TRUE
	/// If a barsign has a light mask for emission effects
	var/light_mask = TRUE
	/// The emission color of the neon light
	var/neon_color

/datum/barsign/New()
	if(!desc)
		desc = "它显示\"[name]\"."

// Specific bar signs.

/datum/barsign/maltesefalcon
	name = "The Maltese falcon马耳他之鹰"
	icon_state = "maltesefalcon"
	desc = "马耳他之鹰, 太空酒吧与烧烤."
	neon_color = "#5E8EAC"

/datum/barsign/thebark
	name = "The Bark-狗叫"
	icon_state = "thebark"
	desc = "Ian选择的酒吧."
	neon_color = "#f7a604"

/datum/barsign/harmbaton
	name = "The Harmbaton-警棒"
	icon_state = "theharmbaton"
	desc = "为安保人员和助力提供绝佳的用餐体验."
	neon_color = "#ff7a4d"

/datum/barsign/thesingulo
	name = "The Singulo-奇点"
	icon_state = "thesingulo"
	desc = "人们甚至不敢提起它的名字."
	neon_color = "#E600DB"

/datum/barsign/thedrunkcarp
	name = "The Drunk Carp-醉鲤鱼"
	icon_state = "thedrunkcarp"
	desc = "不要喝酒后游泳."
	neon_color = "#a82196"

/datum/barsign/scotchservinwill
	name = "Scotch Servin Willy's"
	icon_state = "scotchservinwill"
	desc = "威利确实从小丑晋升为了调酒师."
	neon_color = "#fee4bf"

/datum/barsign/officerbeersky
	name = "Beersky-比斯基警官的"
	icon_state = "officerbeersky"
	desc = "吃一口甜甜圈，喝一杯酒."
	neon_color = "#16C76B"

/datum/barsign/thecavern
	name = "The Cavern-洞穴"
	icon_state = "thecavern"
	desc = "边喝边听美妙的音乐."
	neon_color = "#0fe500"

/datum/barsign/theouterspess
	name = "The Outer Spess"
	icon_state = "theouterspess"
	desc = "这家酒吧实际上并不位于太空."
	neon_color = "#30f3cc"

/datum/barsign/slipperyshots
	name = "The Slippery Shots-滑射"
	icon_state = "slipperyshots"
	desc = "随着射击不断滑向醉酒!"
	neon_color = "#70DF00"

/datum/barsign/thegreytide
	name = "The Grey Tide-灰潮"
	icon_state = "thegreytide"
	desc = "放下你的工具箱日子，享受一杯慵懒的啤酒吧!"
	neon_color = "#00F4D6"

/datum/barsign/honkednloaded
	name = "Honked 'n' Loaded"
	icon_state = "honkednloaded"
	desc = "Honk."
	neon_color = "#FF998A"

/datum/barsign/le_cafe_silencieux
	name = "Le Café Silencieux"
	icon_state = "le_cafe_silencieux"
	desc = "..."
	neon_color = "#ffffff"

/datum/barsign/thenest
	name = "The Nest-鸟巢"
	icon_state = "thenest"
	desc = "一个在打击罪犯的漫长之夜后退休喝酒的好地方."
	neon_color = "#4d6796"

/datum/barsign/thecoderbus
	name = "The Coderbus-编程总线"
	icon_state = "thecoderbus"
	desc = "一家极具争议的酒吧，以其种类繁多、不断变化的饮料而闻名."
	neon_color = "#ffffff"

/datum/barsign/theadminbus
	name = "The Adminbus-行政巴士"
	icon_state = "theadminbus"
	desc = "主要被太空法官访问的酒吧，它的炸裂程度远不如法庭现场."
	neon_color = "#ffffff"

/datum/barsign/oldcockinn
	name = "The Old Cock Inn-老公鸡旅店"
	icon_state = "oldcockinn"
	desc = "招牌的某些特征让你绝望."
	neon_color = "#a4352b"

/datum/barsign/thewretchedhive
	name = "The Wretched Hive-卑劣蜂巢"
	icon_state = "thewretchedhive"
	desc = "法律上我们有义务提醒你在饮用前检查饮料中的酸."
	neon_color = "#26b000"

/datum/barsign/robustacafe
	name = "The Robusta Cafe-罗布斯塔咖啡"
	icon_state = "robustacafe"
	desc = "连续5年保持'最致命酒吧斗殴'记录."
	neon_color = "#c45f7a"

/datum/barsign/emergencyrumparty
	name = "The Emergency Rum Party-应急朗姆趴"
	icon_state = "emergencyrumparty"
	desc = "在长期停业后最近重新获得许可."
	neon_color = "#f90011"

/datum/barsign/combocafe
	name = "The Combo Cafe-组合咖啡"
	icon_state = "combocafe"
	desc = "以其完全没有创意的饮料组合而闻名."
	neon_color = "#33ca40"

/datum/barsign/vladssaladbar
	name = "Vlad的沙拉吧"
	icon_state = "vladssaladbar"
	desc = "在新的管理下. Vlad总是有点太喜欢那把霰弹枪了."
	neon_color = "#306900"

/datum/barsign/theshaken
	name = "The Shaken-战栗"
	icon_state = "theshaken"
	desc = "这家店不供应搅拌饮料."
	neon_color = "#dcd884"

/datum/barsign/thealenath
	name = "The Ale' Nath"
	icon_state = "thealenath"
	desc = "All right, buddy. I think you've had EI NATH. Time to get a cab."
	neon_color = "#ed0000"

/datum/barsign/thealohasnackbar
	name = "The Aloha Snackbar"
	icon_state = "alohasnackbar"
	desc = "A tasteful, inoffensive tiki bar sign."
	neon_color = ""

/datum/barsign/thenet
	name = "The Net-数据网"
	icon_state = "thenet"
	desc = "You just seem to get caught up in it for hours."
	neon_color = "#0e8a00"

/datum/barsign/maidcafe
	name = "Maid Cafe-女仆咖啡"
	icon_state = "maidcafe"
	desc = "Welcome back, master!"
	neon_color = "#ff0051"

/datum/barsign/the_lightbulb
	name = "The Lightbulb-灯泡"
	icon_state = "the_lightbulb"
	desc = "A cafe popular among moths and moffs. Once shut down for a week after the bartender used mothballs to protect her spare uniforms."
	neon_color = "#faff82"

/datum/barsign/goose
	name = "The Loose Goose-醉鹅"
	icon_state = "goose"
	desc = "Drink till you puke and/or break the laws of reality!"
	neon_color = "#00cc33"

/datum/barsign/maltroach
	name = "Maltroach-蛾螂"
	icon_state = "maltroach"
	desc = "Mothroaches politely greet you into the bar, or are they greeting eachother?"
	neon_color = "#649e8a"

/datum/barsign/rock_bottom
	name = "Rock Bottom-洞底"
	icon_state = "rock-bottom"
	desc = "When it feels like you're stuck in a pit, might as well have a drink."
	neon_color = "#aa2811"

/datum/barsign/orangejuice
	name = "Oranges' Juicery-橙汁厂"
	icon_state = "orangejuice"
	desc = "For those who wish to be optimally tactful to the non-alcoholic population."
	neon_color = COLOR_ORANGE

/datum/barsign/tearoom
	name = "Little Treats Tea Room-小茶室"
	icon_state = "little_treats"
	desc = "A delightfully relaxing tearoom for all the fancy lads in the cosmos."
	neon_color = COLOR_LIGHT_ORANGE

/datum/barsign/assembly_line
	name = "The Assembly Line-流水线"
	icon_state = "the-assembly-line"
	desc = "Where every drink is masterfully crafted with industrial efficiency!"
	neon_color = "#ffffff"

/datum/barsign/bargonia
	name = "Bargonia"
	icon_state = "bargonia"
	desc = "The warehouse yearns for a higher calling... so Supply has declared BARGONIA!"
	neon_color = COLOR_WHITE

/datum/barsign/cult_cove
	name = "Cult Cove-血教湾"
	icon_state = "cult-cove"
	desc = "Nar'Sie's favourite retreat"
	neon_color = COLOR_RED

/datum/barsign/neon_flamingo
	name = "Neon Flamingo-霓虹火烈鸟"
	icon_state = "neon-flamingo"
	desc = "A bus for all but the flamboyantly challenged."
	neon_color = COLOR_PINK

/datum/barsign/slowdive
	name = "Slowdive-缓慢下潜"
	icon_state = "slowdive"
	desc = "First stop out of hell, last stop before heaven."
	neon_color = COLOR_RED

/datum/barsign/the_red_mons
	name = "The Red Mons-红月"
	icon_state = "the-red-mons"
	desc = "Drinks from the Red Planet."
	neon_color = COLOR_RED

/datum/barsign/the_rune
	name = "The Rune-符文"
	icon_state = "therune"
	desc = "Reality Shifting drinks."
	neon_color = COLOR_RED

/datum/barsign/the_wizard
	name = "The Wizard-巫师"
	icon_state = "the-wizard"
	desc = "Magical mixes."
	neon_color = COLOR_RED

/datum/barsign/months_moths_moths
	name = "Moths Moths Moths-蛾蛾蛾"
	icon_state = "moths-moths-moths"
	desc = "LIVE MOTHS!"
	neon_color = COLOR_RED

// Hidden signs list below this point

/datum/barsign/hiddensigns
	hidden = TRUE

/datum/barsign/hiddensigns/empbarsign
	name = "EMP'd"
	icon_state = "empbarsign"
	desc = "Something has gone very wrong."
	rename_area = FALSE

/datum/barsign/hiddensigns/syndibarsign
	name = "Syndi Cat"
	icon_state = "syndibarsign"
	desc = "Syndicate or die."
	neon_color = "#ff0000"

/datum/barsign/hiddensigns/signoff
	name = "Off"
	icon_state = "empty"
	desc = "This sign doesn't seem to be on."
	rename_area = FALSE
	light_mask = FALSE

// For other locations that aren't in the main bar
/obj/machinery/barsign/all_access
	req_access = null
	disassemble_result = /obj/item/wallframe/barsign/all_access

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/barsign/all_access, 32)

/obj/item/wallframe/barsign
	name = "酒吧招牌框架"
	desc = "用来帮助把乌合之众拉进你的酒吧，还需要一些组装."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "barsign"
	result_path = /obj/machinery/barsign
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	)
	pixel_shift = 32

/obj/item/wallframe/barsign/Initialize(mapload)
	. = ..()
	desc += "可以使用[span_bold("车站蓝图")]把招牌同所占区域相关联."

/obj/item/wallframe/barsign/try_build(turf/on_wall, mob/user)
	. = ..()
	if(!.)
		return .

	if(isopenturf(get_step(on_wall, EAST))) //This takes up 2 tiles so we want to make sure we have two tiles to hang it from.
		balloon_alert(user, "needs more support!")
		return FALSE

/obj/item/wallframe/barsign/all_access
	desc = "Used to help draw the rabble into your bar. Some assembly required. This one doesn't have an access lock."
	result_path = /obj/machinery/barsign/all_access
