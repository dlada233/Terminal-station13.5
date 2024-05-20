/// Some defines for items the cult archives can create.
#define CULT_BLINDFOLD "狂热者眼罩"
#define CURSE_ORB "穿梭机诅咒"
#define VEIL_WALKER "帷幕行者套装"

// Cult archives. Gives out utility items.
/obj/structure/destructible/cult/item_dispenser/archives
	name = "文献台"
	desc = "一张堆满了晦涩难懂的手稿和用未知语言写成的大部头书的桌子. 上面的文字会让你起鸡皮疙瘩."
	cult_examine_tip = "可以用来创造狂热者眼罩，穿梭机诅咒法球以及帷幕行者套装."
	icon_state = "tomealtar"
	light_range = 1.5
	light_color = LIGHT_COLOR_FIRE
	break_message = "<span class='warning'>文献台上书卷化成了灰，桌子也碎掉了!</span>"

/obj/structure/destructible/cult/item_dispenser/archives/setup_options()
	var/static/list/archive_items = list(
		CULT_BLINDFOLD = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/clothing/glasses.dmi', icon_state = "blindfold"),
			OUTPUT_ITEMS = list(/obj/item/clothing/glasses/hud/health/night/cultblind),
			),
		CURSE_ORB = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/antags/cult/items.dmi', icon_state = "shuttlecurse"),
			OUTPUT_ITEMS = list(/obj/item/shuttle_curse),
			),
		VEIL_WALKER = list(
			PREVIEW_IMAGE = image(icon = 'icons/obj/antags/cult/items.dmi', icon_state = "shifter"),
			OUTPUT_ITEMS = list(/obj/item/cult_shift, /obj/item/flashlight/flare/culttorch),
			),
	)

	options = archive_items

/obj/structure/destructible/cult/item_dispenser/archives/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_cultitalic("你从[src]中生成了[spawned_item]!"))

// Preset for the library that doesn't spawn runed metal on destruction.
/obj/structure/destructible/cult/item_dispenser/archives/library
	debris = list()

#undef CULT_BLINDFOLD
#undef CURSE_ORB
#undef VEIL_WALKER
