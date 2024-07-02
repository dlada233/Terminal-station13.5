/obj/item/ammo_casing/foam_dart
	name = "泡沫弹"
	desc = "It's Donk or Don't! 仅限八岁及以上人群使用."
	projectile_type = /obj/projectile/bullet/foam_dart
	caliber = CALIBER_FOAM
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foamdart"
	base_icon_state = "foamdart"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.1125)
	harmful = FALSE
	var/modified = FALSE
	var/static/list/insertable_items_hint = list(/obj/item/pen)
	///For colored magazine overlays.
	var/tip_color = "blue"

/obj/item/ammo_casing/foam_dart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless, TRUE)

/obj/item/ammo_casing/foam_dart/update_icon_state()
	. = ..()
	if(modified)
		icon_state = "[base_icon_state]_empty"
		loaded_projectile?.icon_state = "[loaded_projectile.base_icon_state]_empty_proj"
		return
	icon_state = "[base_icon_state]"
	loaded_projectile?.icon_state = "[loaded_projectile.base_icon_state]_proj"

/obj/item/ammo_casing/foam_dart/update_desc()
	. = ..()
	desc = "It's Donk or Don't! [modified ? "...不过，这把看起来不太安全." : "仅限八岁及以上人群使用."]"

/obj/item/ammo_casing/foam_dart/examine_more(mob/user)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_DART_HAS_INSERT))
		var/list/type_initial_names = list()
		for(var/type in insertable_items_hint)
			var/obj/item/type_item = type
			type_initial_names += "[initial(type_item.name)]"
		. += span_notice("[modified ? "你可以" : "如果用螺丝刀将保险帽拆下来，就可以"]插入一件小型物品\
			[length(type_initial_names) ? "，比如[english_list(type_initial_names, and_text = "或者 ", final_comma_text = "，")]" : ""].")


/obj/item/ammo_casing/foam_dart/attackby(obj/item/attacking_item, mob/user, params)
	var/obj/projectile/bullet/foam_dart/dart = loaded_projectile
	if (attacking_item.tool_behaviour == TOOL_SCREWDRIVER && !modified)
		modified = TRUE
		dart.modified = TRUE
		dart.damage_type = BRUTE
		to_chat(user, span_notice("你把[src]的保险帽打开了."))
		update_appearance()
	else
		return ..()

/obj/item/ammo_casing/foam_dart/riot
	name = "镇暴泡沫弹"
	desc = "用玩具枪来控制人群是谁家的聪明主意? 仅限十八岁及以上人群使用."
	projectile_type = /obj/projectile/bullet/foam_dart/riot
	icon_state = "foamdart_riot"
	base_icon_state = "foamdart_riot"
	tip_color = "red"
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT* 1.125)
