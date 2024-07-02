/obj/item/clothing/head/chaplain/
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'

/obj/item/clothing/head/chaplain/clownmitre
	name = "Honkmother帽"
	desc = "当信徒仰望你辉煌的小帽时，很难看到地板上的香蕉皮."
	icon_state = "clownmitre"

/obj/item/clothing/head/chaplain/kippah
	name = "犹太帽"
	desc = "表明你遵循犹太哈拉哈，让灵魂更加正统."
	icon_state = "kippah"

/obj/item/clothing/head/chaplain/medievaljewhat
	name = "中世纪犹太帽"
	desc = "一个滑稽的帽子，戴在站点受压迫的宗教少数群体头上."
	icon_state = "medievaljewhat"

/obj/item/clothing/head/chaplain/taqiyah/white
	name = "白色塔吉亚"
	desc = "显示你对真主的虔诚."
	icon_state = "taqiyahwhite"

/obj/item/clothing/head/chaplain/taqiyah/white/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small)

/obj/item/clothing/head/chaplain/taqiyah/red
	name = "红色塔吉亚"
	desc = "显示你对真主的虔诚."
	icon_state = "taqiyahred"

/obj/item/clothing/head/chaplain/taqiyah/red/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small)
