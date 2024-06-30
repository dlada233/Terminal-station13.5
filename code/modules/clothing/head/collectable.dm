
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "收藏帽"
	desc = "一顶罕见的收藏帽."
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = null

/obj/item/clothing/head/collectable/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/series, /obj/item/clothing/head/collectable, "超级罕见收藏帽")

/obj/item/clothing/head/collectable/petehat
	name = "超罕见Pete的帽子！"
	desc = "它有淡淡的等离子气味."
	icon_state = "petehat"

/obj/item/clothing/head/collectable/xenom
	name = "收藏级异形头套！"
	desc = "嘶嘶嘶！"
	clothing_flags = SNUG_FIT
	icon_state = "xenom"

/obj/item/clothing/head/collectable/chef
	name = "收藏级厨师帽"
	desc = "一顶罕见的厨师帽，适合帽子收藏家！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "chef"
	inhand_icon_state = "chefhat"
	dog_fashion = /datum/dog_fashion/head/chef

/obj/item/clothing/head/collectable/paper
	name = "收藏级纸帽"
	desc = "看起来像一顶普通的纸帽，实际上是一顶罕见且有价值的收藏版纸帽，远离水、火和图书馆长."
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "paper"
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/tophat
	name = "收藏级高顶帽"
	desc = "一顶只有最尊贵的帽子收藏家才会戴的高顶帽."
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "tophat"
	inhand_icon_state = "that"

/obj/item/clothing/head/collectable/captain
	name = "收藏级船长帽"
	desc = "一顶让你看起来像真正船长的收藏级帽子！"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "captain"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/captain

/obj/item/clothing/head/collectable/police
	name = "收藏级警察帽"
	desc = "一顶收藏级的警察帽，这顶帽子强调你就是法律."
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "policehelm"
	dog_fashion = /datum/dog_fashion/head/warden

/obj/item/clothing/head/collectable/beret
	name = "收藏级贝雷帽"
	desc = "一顶收藏级的红色贝雷帽，它有淡淡的大蒜味."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	dog_fashion = /datum/dog_fashion/head/beret

/obj/item/clothing/head/collectable/welding
	name = "收藏级焊接头盔"
	desc = "一顶收藏级的焊接头盔，含铅量减少了80%！不适合实际焊接，任何在佩戴此头盔时进行的焊接均由佩戴者自担风险！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "welding"
	inhand_icon_state = "welding"
	lefthand_file = 'icons/mob/inhands/clothing/masks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/masks_righthand.dmi'
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/collectable/slime
	name = "收藏级史莱姆帽"
	desc = "就像一个真正的脑蛞蝓！"
	icon_state = "headslime"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT

/obj/item/clothing/head/collectable/flatcap
	name = "收藏级平顶帽"
	desc = "一顶收藏级的农民平顶帽！"
	icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = null

/obj/item/clothing/head/collectable/pirate
	name = "收藏级海盗帽"
	desc = "你会成为一个伟大的Dread Syndie Roberts！"
	icon_state = "pirate"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/collectable/kitty
	name = "收藏级猫耳"
	desc = "这毛感觉...有点太真实了."
	icon_state = "kitty"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/collectable/rabbitears
	name = "收藏级兔耳"
	desc = "没有兔脚那么幸运！"
	icon_state = "bunny"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head/rabbit

/obj/item/clothing/head/collectable/wizard
	name = "收藏级巫师帽"
	desc = "注意：佩戴此帽子所获得的任何魔法能力纯属巧合."
	icon = 'icons/obj/clothing/head/wizard.dmi'
	worn_icon = 'icons/mob/clothing/head/wizard.dmi'
	icon_state = "wizard"
	dog_fashion = /datum/dog_fashion/head/blue_wizard

/obj/item/clothing/head/collectable/hardhat
	name = "收藏级安全帽"
	desc = "警告！不提供任何实际保护或照明，但非常华丽！"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	clothing_flags = SNUG_FIT
	icon_state = "hardhat0_yellow"
	inhand_icon_state = null
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/head/collectable/hos
	name = "收藏级安全主管帽"
	desc = "现在你也可以殴打囚犯、设置荒唐的刑期并无理由逮捕人了！"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "hoscap"

/obj/item/clothing/head/collectable/hop
	name = "收藏级人事主管帽"
	desc = "轮到你来处理过多的文书工作、签名、印章，并雇用更多的小丑了！文件，请！"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	icon_state = "hopcap"
	dog_fashion = /datum/dog_fashion/head/hop

/obj/item/clothing/head/collectable/thunderdome
	name = "收藏级雷霆竞技头盔"
	desc = "加油红队！我是说绿队！我是说红队！不，绿队！"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome_helmet"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR|HIDEHAIR

/obj/item/clothing/head/collectable/swat
	name = "收藏级特警头盔"
	desc = "那不是真血，那是红色油漆." //参考实际描述
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie_helmet"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEHAIR
