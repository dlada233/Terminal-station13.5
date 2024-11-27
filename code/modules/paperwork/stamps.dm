/obj/item/stamp
	name = "批准印章"
	desc = "盖重要文件的橡皮图章."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "stamp-ok"
	worn_icon_state = "nothing"
	inhand_icon_state = "stamp"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.6)
	pressure_resistance = 2
	attack_verb_continuous = list("stamps")
	attack_verb_simple = list("stamp")

/obj/item/stamp/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] stamps 'VOID' on [user.p_their()] forehead, then promptly falls over, dead."))
	playsound(src, 'sound/items/handling/standard_stamp.ogg', 50, vary = TRUE)
	return OXYLOSS

/obj/item/stamp/get_writing_implement_details()
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/paper)
	return list(
		interaction_mode = MODE_STAMPING,
		stamp_icon_state = icon_state,
		stamp_class = sheet.icon_class_name(icon_state)
	)

/obj/item/stamp/law
	name = "law office's rubber stamp"
	icon_state = "stamp-law"
	dye_color = DYE_LAW

/obj/item/stamp/head

/obj/item/stamp/head/Initialize(mapload)
	. = ..()
	// All maps should have at least 1 of each head of staff stamp
	REGISTER_REQUIRED_MAP_ITEM(1, INFINITY)

/obj/item/stamp/head/captain
	name = "舰长印章"
	icon_state = "stamp-cap"
	dye_color = DYE_CAPTAIN

/obj/item/stamp/head/hop
	name = "人事部长印章"
	icon_state = "stamp-hop"
	dye_color = DYE_HOP

/obj/item/stamp/head/hos
	name = "安保部长印章"
	icon_state = "stamp-hos"
	dye_color = DYE_HOS

/obj/item/stamp/head/ce
	name = "工程部长印章"
	icon_state = "stamp-ce"
	dye_color = DYE_CE

/obj/item/stamp/head/rd
	name = "研究主管印章"
	icon_state = "stamp-rd"
	dye_color = DYE_RD

/obj/item/stamp/head/cmo
	name = "首席医疗官印章"
	icon_state = "stamp-cmo"
	dye_color = DYE_CMO

/obj/item/stamp/head/qm
	name = "军需官印章"
	icon_state = "stamp-qm"
	dye_color = DYE_QM

/obj/item/stamp/denied
	name = "否决印章"
	icon_state = "stamp-deny"
	dye_color = DYE_REDCOAT

/obj/item/stamp/void
	name = "无效印章"
	icon_state = "stamp-void"

/obj/item/stamp/clown
	name = "小丑印章"
	icon_state = "stamp-clown"
	dye_color = DYE_CLOWN

/obj/item/stamp/clown/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/stamp/mime
	name = "默剧印章"
	icon_state = "stamp-mime"
	dye_color = DYE_MIME

/obj/item/stamp/chap
	name = "牧师印章"
	icon_state = "stamp-chap"
	dye_color = DYE_CHAP

/obj/item/stamp/centcom
	name = "中央指挥部印章"
	icon_state = "stamp-centcom"
	dye_color = DYE_CENTCOM

/obj/item/stamp/syndicate
	name = "辛迪加印章"
	icon_state = "stamp-syndicate"
	dye_color = DYE_SYNDICATE

/obj/item/stamp/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)
