GLOBAL_LIST_INIT(rod_recipes, list ( \
	new/datum/stack_recipe("grille-格栅", /obj/structure/grille, 2, time = 1 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("table frame-桌子框架", /obj/structure/table_frame, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("scooter frame", /obj/item/scooter_frame, 10, time = 2.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("linen bin", /obj/structure/bedsheetbin/empty, 2, time = 0.5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("railing-栏杆", /obj/structure/railing, 2, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_CHECK_DIRECTION, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("railing-栏杆转角", /obj/structure/railing/corner, 1, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_CHECK_DIRECTION, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("railing-栏杆尽头", /obj/structure/railing/corner/end, 1, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_CHECK_DIRECTION, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("railing-栏杆尽头(反)", /obj/structure/railing/corner/end/flip, 1, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_CHECK_DIRECTION, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("tank holder-气瓶架", /obj/structure/tank_holder, 2, time = 0.5 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_FURNITURE), \
	new/datum/stack_recipe("ladder-梯子", /obj/structure/ladder/crafted, 15, time = 15 SECONDS, crafting_flags = CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("catwalk floor tile-脚手架", /obj/item/stack/tile/catwalk_tile, 1, 4, 20, category = CAT_TILES), \
	new/datum/stack_recipe("stairs frame-楼梯框架", /obj/structure/stairs_frame, 10, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE), \
	new/datum/stack_recipe("probing cane-导盲杖", /obj/item/cane/white, 3, time = 1 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY, category = CAT_TOOLS), \
	new/datum/stack_recipe("sharpened iron rodd-磨尖铁棒", /obj/item/ammo_casing/rebar, 1, time = 0.2 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY, category = CAT_WEAPON_AMMO), \
	))

/obj/item/stack/rods
	name = "铁棒"
	desc = "可以用于建造一些东西."
	singular_name = "铁棒"
	icon_state = "rods"
	inhand_icon_state = "rods"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_NORMAL
	force = 9
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	demolition_mod = 1.25
	mats_per_unit = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT)
	max_amount = 50
	attack_verb_continuous = list("hits", "bludgeons", "whacks")
	attack_verb_simple = list("hit", "bludgeon", "whack")
	hitsound = 'sound/weapons/gun/general/grenade_launch.ogg'
	embedding = list(embed_chance = 50)
	novariants = TRUE
	matter_amount = 2
	cost = HALF_SHEET_MATERIAL_AMOUNT
	source = /datum/robot_energy_storage/material/iron
	merge_type = /obj/item/stack/rods

/obj/item/stack/rods/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to stuff \the [src] down [user.p_their()] throat! 看起来是在尝试自杀!"))//it looks like theyre ur mum
	return BRUTELOSS

/obj/item/stack/rods/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	update_appearance()
	AddElement(/datum/element/openspace_item_click_handler)
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Craft iron sheets",
			SCREENTIP_CONTEXT_RMB = "Craft floor tiles",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/spear, /datum/crafting_recipe/stunprod, /datum/crafting_recipe/teleprod) // snatcher prod isn't here as a spoopy secret

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/rods/handle_openspace_click(turf/target, mob/user, list/modifiers)
	target.attackby(src, user, list2params(modifiers))

/obj/item/stack/rods/get_main_recipes()
	. = ..()
	. += GLOB.rod_recipes

/obj/item/stack/rods/update_icon_state()
	. = ..()
	var/amount = get_amount()
	if(amount <= 5)
		icon_state = "rods-[amount]"
	else
		icon_state = "rods"

/obj/item/stack/rods/welder_act(mob/living/user, obj/item/tool)
	if(get_amount() < 2)
		balloon_alert(user, "not enough rods!")
		return
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/sheet/iron/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into iron sheets with [tool]."),
			blind_message = span_hear("你听到焊接声."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(2)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/rods/welder_act_secondary(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, delay = 0, volume = 40))
		var/obj/item/stack/tile/iron/two/new_item = new(user.loc)
		user.visible_message(
			span_notice("[user.name] shaped [src] into floor tiles with [tool]."),
			blind_message = span_hear("你听到焊接声."),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
		use(1)
		user.put_in_inactive_hand(new_item)
		return ITEM_INTERACT_SUCCESS

/obj/item/stack/rods/cyborg/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/stack/rods/two
	amount = 2

/obj/item/stack/rods/ten
	amount = 10

/obj/item/stack/rods/twentyfive
	amount = 25

/obj/item/stack/rods/fifty
	amount = 50

/obj/item/stack/rods/lava
	name = "耐热铁棒"
	desc = "经过处理的特种铁棒，上面的涂层可以抵御岩浆的极端高温，但一旦暴露在真空中涂层就会脱落."
	singular_name = "heat resistant rod"
	icon_state = "rods"
	inhand_icon_state = "rods"
	color = "#5286b9ff"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_NORMAL
	mats_per_unit = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plasma=SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium=SHEET_MATERIAL_AMOUNT)
	max_amount = 30
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	merge_type = /obj/item/stack/rods/lava

/obj/item/stack/rods/lava/thirty
	amount = 30
