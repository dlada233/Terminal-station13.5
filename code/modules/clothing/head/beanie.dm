
//BeanieStation13 Redux

//再加一个毛绒球帽子，让我们更加包容!!

/obj/item/clothing/head/beanie
	name = "毛线帽"
	desc = "一款时尚的毛线帽，对于那些有敏锐时尚感的人和那些不能忍受头顶着凉的人来说，这是一款完美的冬季头饰."
	icon = 'icons/obj/clothing/head/beanie.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "beanie"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "beanie_cloth"
	custom_price = PAYCHECK_CREW * 1.2
	greyscale_colors = "#EEEEEE#EEEEEE"
	greyscale_config = /datum/greyscale_config/beanie
	greyscale_config_worn = /datum/greyscale_config/beanie/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/beanie/black
	name = "黑色毛线帽"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/head/beanie/red
	name = "红色毛线帽"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/head/beanie/darkblue
	name = "深蓝色毛线帽"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/head/beanie/yellow
	name = "黄色毛线帽"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/head/beanie/orange
	name = "橙色毛线帽"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/head/beanie/christmas
	name = "圣诞毛线帽"
	greyscale_colors = "#038000#960000"

/obj/item/clothing/head/beanie/durathread
	name = "杜拉棉毛线帽"
	desc = "一款由杜拉棉纤维制成的毛线帽，其坚韧的纤维为佩戴者提供了一些保护."
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "beanie_durathread"
	greyscale_colors = "#8291A1#8291A1"
	armor_type = /datum/armor/beanie_durathread

/obj/item/clothing/head/rasta
	name = "拉斯塔帽"
	desc = "完美地藏住那些脏辫."
	icon = 'icons/obj/clothing/head/beanie.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "beanierasta"

/obj/item/clothing/head/waldo
	name = "红色条纹毛绒球帽"
	desc = "如果你要进行全球徒步旅行，你需要一些防寒保护."
	icon = 'icons/obj/clothing/head/beanie.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "waldo_hat"

//还没有狗狗的时尚精灵 :( 可怜的伊恩还不能像我们一样酷

/obj/item/clothing/head/beanie/black/dboy
	name = "测试对象毛线帽"
	desc = "一顶脏兮兮且破旧的黑色毛线帽.这是粘液还是油脂？"
	/// 用于d-boy自己看到的额外文本
	var/datum/weakref/beanie_owner = null

/datum/armor/beanie_durathread
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5

/obj/item/clothing/head/beanie/black/dboy/equipped(mob/user, slot)
	. = ..()
	if(iscarbon(user) && !beanie_owner)
		beanie_owner = WEAKREF(user)

/obj/item/clothing/head/beanie/black/dboy/examine(mob/user)
	. = ..()
	if(IS_WEAKREF_OF(user, beanie_owner))
		. += span_purple("它覆盖着只有你的眼睛被破坏到一定程度才能看到的奇异残骸.")
