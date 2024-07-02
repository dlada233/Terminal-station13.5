/// Some defines for items the daemon forge can create.
#define NARSIE_ARMOR "Nar'Sie硬化甲"
#define FLAGELLANT_ARMOR "苦修者长袍"
#define ELDRITCH_SWORD "邪血长剑"

// Cult forge. Gives out combat weapons.
/obj/structure/destructible/cult/item_dispenser/forge
	name = "恶魔熔炉"
	desc = "一个熔炉，用于制造Nar'Sie军队使用的邪恶武器."
	cult_examine_tip = "可以用来创造Nar'Sie硬化甲, 苦修者长袍以及邪血长剑."
	icon_state = "forge"
	light_range = 2
	light_color = LIGHT_COLOR_LAVA
	break_message = "<span class='warning'>恶魔熔炉发出一声惨叫，碎成一地!</span>"

/obj/structure/destructible/cult/item_dispenser/forge/setup_options()
	var/static/list/forge_items = list(
		NARSIE_ARMOR = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/clothing/suits/armor.dmi', icon_state = "cult_armor"),
			OUTPUT_ITEMS = list(/obj/item/clothing/suit/hooded/cultrobes/hardened),
			),
		FLAGELLANT_ARMOR = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/clothing/suits/armor.dmi', icon_state = "cultrobes"),
			OUTPUT_ITEMS = list(/obj/item/clothing/suit/hooded/cultrobes/berserker),
			),
		ELDRITCH_SWORD = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/weapons/sword.dmi', icon_state = "cultblade"),
			OUTPUT_ITEMS = list(/obj/item/melee/cultblade),
			),
	)

	options = forge_items

/obj/structure/destructible/cult/item_dispenser/forge/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_cult_italic("你在黑暗知识指引下操作[src]，创造了[spawned_item]!"))

/obj/structure/destructible/cult/item_dispenser/forge/engine
	name = "熔岩引擎"
	desc = "用于驱动穿梭机的神秘引擎."
	debris = list()

#undef NARSIE_ARMOR
#undef FLAGELLANT_ARMOR
#undef ELDRITCH_SWORD
