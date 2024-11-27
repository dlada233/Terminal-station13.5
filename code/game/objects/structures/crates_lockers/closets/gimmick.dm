/obj/structure/closet/cabinet
	name = "衣柜"
	desc = "老派永远是时尚."
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	max_integrity = 70
	door_anim_time = 0 // no animation

/obj/structure/closet/acloset
	name = "奇怪的储物柜"
	desc = "看起来来自外星!"
	icon_state = "alien"
	material_drop = /obj/item/stack/sheet/mineral/abductor

/obj/structure/closet/gimmick
	name = "管理储物柜"
	desc = "这是一个储物柜，用来存放那些不应该存在的东西."
	icon_state = "syndicate"

/obj/structure/closet/gimmick/russian
	name = "俄罗斯储物柜"
	desc = "存放着俄罗斯标准储备物资."

/obj/structure/closet/gimmick/russian/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/clothing/head/costume/ushanka(src)
	for(var/i in 1 to 5)
		new /obj/item/clothing/under/costume/soviet(src)

/obj/structure/closet/gimmick/tacticool
	name = "战术装备柜"
	desc = "存放着战术装备."

/obj/structure/closet/gimmick/tacticool/PopulateContents()
	..()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)

/obj/structure/closet/gimmick/tacticool/populate_contents_immediate()
	new /obj/item/clothing/glasses/sunglasses(src)

/obj/structure/closet/thunderdome
	name = "雷霆竞技场储柜"
	desc = "所有你需要的东西!"
	anchored = TRUE

/obj/structure/closet/thunderdome/tdred
	name = "雷霆竞技场红队储柜"
	icon_door = "red"

/obj/structure/closet/thunderdome/tdred/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/red(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/security/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdred/populate_contents_immediate()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "雷霆竞技场绿队储柜"
	icon_door = "green"

/obj/structure/closet/thunderdome/tdgreen/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/green(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/security/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen/populate_contents_immediate()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)

/obj/structure/closet/malf/suits
	desc = "存有作战装备."
	icon_state = "syndicate"

/obj/structure/closet/malf/suits/PopulateContents()
	..()
	new /obj/item/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/nasavoid(src)
	new /obj/item/clothing/suit/space/nasavoid(src)
	new /obj/item/crowbar(src)
	new /obj/item/stock_parts/cell(src)
	new /obj/item/multitool(src)

/obj/structure/closet/mini_fridge
	name = "肮脏的迷你冰箱"
	desc = "这是一个小巧的装置，设计用来让几杯饮料带上宜人的冰爽感."
	icon_state = "mini_fridge"
	icon_welded = "welded_small"
	max_mob_size = MOB_SIZE_SMALL
	pass_flags = PASSTABLE
	anchored_tabletop_offset = 3
	anchored = 1
	storage_capacity = 10

/obj/structure/closet/mini_fridge/PopulateContents()
	. = ..()
	new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	if(prob(50))
		new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	if(prob(40))
		new /obj/item/reagent_containers/cup/glass/bottle/beer(src)

/obj/structure/closet/mini_fridge/grimy
	name = "肮脏的迷你冰箱"
	desc = "这是一个小巧的装置，设计用来让几杯饮料带上宜人的冰爽感，然而，这个老旧的装置似乎除了让蟑螂安家之外，没有其他任何作用。"

/obj/structure/closet/mini_fridge/grimy/PopulateContents()
	. = ..()
	if(prob(40))
		if(prob(50))
			new /obj/item/food/pizzaslice/moldy/bacteria(src)
		else
			new /obj/item/food/breadslice/moldy/bacteria(src)
	else if(prob(40))
		if(prob(50))
			new /obj/item/food/syndicake(src)
		else
			new /mob/living/basic/cockroach(src)
