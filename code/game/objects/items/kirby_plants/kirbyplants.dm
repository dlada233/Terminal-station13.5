
/obj/item/kirbyplants
	name = "盆栽植物"
	//icon = 'icons/obj/fluff/flora/plants.dmi' // ORIGINAL
	icon = 'modular_skyrat/modules/aesthetics/plants/plants.dmi' // SKYRAT EDIT CHANGE
	icon_state = "plant-01"
	base_icon_state = "plant-01"
	desc = "生长在花盆里的自然景观."
	layer = ABOVE_MOB_LAYER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	item_flags = NO_PIXEL_RANDOM_DROP

	/// Can this plant be trimmed by someone with TRAIT_BONSAI
	var/trimmable = TRUE
	/// Whether this plant is dead and requires a seed to revive
	var/dead = FALSE
	///If it's a special named plant, set this to true to prevent dead-name overriding.
	var/custom_plant_name = FALSE
	var/list/static/random_plant_states
	/// Maximum icon state number - KEEP THIS UP TO DATE
	var/random_state_cap = 43 // SKYRAT EDIT ADDITION

/obj/item/kirbyplants/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/tactical)
	AddComponent(/datum/component/two_handed, require_twohands = TRUE, force_unwielded = 10, force_wielded = 10)
	AddElement(/datum/element/beauty, 500)
	if(icon_state != base_icon_state && icon_state != "plant-25") //mapedit support
		base_icon_state = icon_state
	update_appearance()

/obj/item/kirbyplants/update_name(updates)
	. = ..()
	if(custom_plant_name)
		return
	name = "[dead ? "死掉的":null][initial(name)]"

/obj/item/kirbyplants/update_desc(updates)
	. = ..()
	desc = dead ? "这种无法辨认的植物残骸会让你有一种想要在花盆里种些新东西的感觉." : initial(desc)

/obj/item/kirbyplants/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, dead))
		update_appearance()

/obj/item/kirbyplants/update_icon_state()
	. = ..()
	icon_state = dead ? "plant-25" : base_icon_state

/obj/item/kirbyplants/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!dead && trimmable && HAS_TRAIT(user,TRAIT_BONSAI) && isturf(loc) && I.get_sharpness())
		to_chat(user,span_notice("你开始修剪[src]."))
		if(do_after(user,3 SECONDS,target=src))
			to_chat(user,span_notice("你完成修剪[src]."))
			change_visual()
	if(dead && istype(I, /obj/item/seeds))
		to_chat(user,span_notice("你开始在花盆里种下一颗新的种子."))
		if(do_after(user,3 SECONDS,target=src))
			qdel(I)
			dead = FALSE
			update_appearance()

/// Cycle basic plant visuals
/obj/item/kirbyplants/proc/change_visual()
	if(!random_plant_states)
		generate_states()
	var/current = random_plant_states.Find(icon_state)
	var/next = WRAP(current+1,1,length(random_plant_states))
	icon_state = random_plant_states[next]

/obj/item/kirbyplants/proc/generate_states()
	random_plant_states = list()
	for(var/i in 1 to random_state_cap) //SKYRAT EDIT CHANGE - ORIGINAL: for(var/i in 1 to 24)
		var/number
		if(i < 10)
			number = "0[i]"
		else
			number = "[i]"
		random_plant_states += "plant-[number]"
	random_plant_states += list("applebush", "monkeyplant") //SKYRAT EDIT CHANGE - ORIGINAL:random_plant_states += "applebush"

/obj/item/kirbyplants/random
	icon = 'icons/obj/fluff/flora/_flora.dmi'
	icon_state = "random_plant"

/obj/item/kirbyplants/random/Initialize(mapload)
	. = ..()
	//icon = 'icons/obj/flora/plants.dmi' // ORIGINAL
	icon = 'modular_skyrat/modules/aesthetics/plants/plants.dmi' //SKYRAT EDIT CHANGE
	randomize_base_icon_state()

//Handles randomizing the icon during initialize()
/obj/item/kirbyplants/random/proc/randomize_base_icon_state()
	if(!random_plant_states)
		generate_states()
	base_icon_state = pick(random_plant_states)
	if(!dead) //no need to update the icon if we're already dead.
		update_appearance(UPDATE_ICON)

/obj/item/kirbyplants/random/dead
	icon_state = "plant-25"
	dead = TRUE

/obj/item/kirbyplants/random/dead/research_director
	name = "研究主管的盆栽"
	custom_plant_name = TRUE

/obj/item/kirbyplants/random/dead/update_desc(updates)
	. = ..()
	desc = "植物学员工在研究主管调任后送来的礼物. 上面的标签写着 \"你们都给我回来，听到了吗?\"[dead ? "\n这株看起来已经不是很健康了...":null]"

/obj/item/kirbyplants/random/fullysynthetic
	name = "塑料盆栽"
	desc = "一颗看起来很廉价的假塑料树，非常适合那些植物杀手."
	icon_state = "plant-26"
	custom_materials = (list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4))
	trimmable = FALSE

//Handles randomizing the icon during initialize()
/obj/item/kirbyplants/random/fullysynthetic/randomize_base_icon_state()
	base_icon_state = "plant-[rand(26, 29)]"
	update_appearance(UPDATE_ICON)

//SKYRAT EDIT ADDITION START
/obj/item/kirbyplants/monkey
	name = "猴栽"
	desc = "似乎是纳米传讯科研部门制造的东西，有人称它们为‘可憎异形怪物’，它们的头看起来...活着..."
	icon_state = "monkeyplant"
	trimmable = FALSE
//SKYRAT EDIT ADDITION END

/obj/item/kirbyplants/photosynthetic
	name = "微光盆栽"
	desc = "一株发光的植物."
	icon_state = "plant-09"
	light_color = COLOR_BRIGHT_BLUE
	light_range = 3

/obj/item/kirbyplants/potty
	name = "笨蛋盆栽"
	desc = "一位神秘特工在空间站的酒吧工作，以保护神秘的蛋糕帽."
	icon_state = "potty"
	custom_plant_name = TRUE
	trimmable = FALSE

/obj/item/kirbyplants/fern
	name = "不起眼蕨类"
	desc = "从一颗被遗忘的丛林星球上收集而来的古老植物研究样本."
	icon_state = "fern"
	trimmable = FALSE

/obj/item/kirbyplants/fern/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_ALGAE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 5)
