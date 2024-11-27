//THIS FILE HAS BEEN EDITED BY SKYRAT EDIT

/obj/structure/dresser//SKYRAT EDIT - ICON OVERRIDDEN BY AESTHETICS - SEE MODULE
	name = "梳妆台"
	desc = "做工精美的木制梳妆台，里面装满各式贴身衣物."
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "dresser"
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("你开始用扳手[anchored ? "解固" : "固定"][src]."))
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, span_notice("你成功的用扳手[anchored ? "解固" : "固定"][src]."))
			set_anchored(!anchored)
	else
		return ..()

/obj/structure/dresser/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)

/obj/structure/dresser/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!Adjacent(user))//no tele-grooming
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/dressing_human = user
	if(HAS_TRAIT(dressing_human, TRAIT_NO_UNDERWEAR))
		to_chat(dressing_human, span_warning("你根本不会穿贴身衣物."))
		return

	var/choice = tgui_input_list(user, "内裤，胸罩，贴身衫，或者袜子?", "更衣", list("内裤", "内裤颜色", "胸罩", "胸罩颜色", "贴身衫", "贴身衫颜色", "袜子", "袜子颜色")) //SKYRAT EDIT ADDITION - Colorable Undershirt/Socks/Bra
	if(isnull(choice))
		return

	if(!Adjacent(user))
		return
	switch(choice)
		if("内裤")
			var/new_undies = tgui_input_list(user, "选择你的内裤", "更换", SSaccessories.underwear_list)
			if(new_undies)
				dressing_human.underwear = new_undies
		if("内裤颜色")
			var/new_underwear_color = input(dressing_human, "选择你的内裤颜色", "内裤颜色", dressing_human.underwear_color) as color|null
			if(new_underwear_color)
				dressing_human.underwear_color = sanitize_hexcolor(new_underwear_color)
		if("贴身衫")
			var/new_undershirt = tgui_input_list(user, "选择你的贴身衫", "更换", SSaccessories.undershirt_list)
			if(new_undershirt)
				dressing_human.undershirt = new_undershirt
		if("袜子")
			var/new_socks = tgui_input_list(user, "选择你的袜子", "更换", SSaccessories.socks_list)
			if(new_socks)
				dressing_human.socks = new_socks
		//SKYRAT EDIT ADDITION BEGIN - Colorable Undershirt/Socks/Bras
		if("贴身衫颜色")
			var/new_undershirt_color = input(dressing_human, "选择你的贴身衫颜色", "贴身衫颜色", dressing_human.undershirt_color) as color|null
			if(new_undershirt_color)
				dressing_human.undershirt_color = sanitize_hexcolor(new_undershirt_color)
		if("袜子颜色")
			var/new_socks_color = input(dressing_human, "选择你的袜子颜色", "袜子颜色", dressing_human.socks_color) as color|null
			if(new_socks_color)
				dressing_human.socks_color = sanitize_hexcolor(new_socks_color)

		if("胸罩")
			var/new_bra = tgui_input_list(user, "选择你的胸罩", "更换", SSaccessories.bra_list)
			if(new_bra)
				dressing_human.bra = new_bra

		if("胸罩颜色")
			var/new_bra_color = input(dressing_human, "选择你的胸罩颜色", "胸罩颜色", dressing_human.bra_color) as color|null
			if(new_bra_color)
				dressing_human.bra_color = sanitize_hexcolor(new_bra_color)

		//SKYRAT EDIT ADDITION END - Colorable Undershirt/Socks/Bras

	add_fingerprint(dressing_human)
	dressing_human.update_body()
