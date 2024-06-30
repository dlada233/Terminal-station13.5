/obj/item/clothing/head/costume
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'

/obj/item/clothing/head/costume/powdered_wig
	name = "司法假发"
	desc = "一顶司法假发."
	icon_state = "pwig"
	inhand_icon_state = "pwig"

/obj/item/clothing/head/costume/hasturhood
	name = "哈斯塔的兜帽"
	desc = "它拥有<i>不可描述</i>的时尚感."
	icon_state = "hasturhood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/syndicatefake
	name = "黑色太空头盔复制品"
	icon = 'icons/obj/clothing/head/spacehelm.dmi'
	worn_icon = 'icons/mob/clothing/head/spacehelm.dmi'
	icon_state = "syndicate-helm-black-red"
	inhand_icon_state = "syndicate-helm-black-red"
	desc = "一个辛迪加太空头盔的塑料复制品，戴上它，你看起来就像一个真正的凶残辛迪加特工！这只是一个玩具，不适合在太空使用！"
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/cueball
	name = "大台球"
	desc = "一个巨大的、无特征的白色球体，戴在你的头上，从这里怎么看到东西？"
	icon_state = "cueball"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/snowman
	name = "雪人头"
	desc = "一个白色的泡沫球.好有节日气氛."
	icon_state = "snowman_h"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/witchwig
	name = "女巫服装假发"
	desc = "咯咯咯咯咯咯咯！"
	icon_state = "witch"
	inhand_icon_state = null
	flags_inv = HIDEHAIR

/obj/item/clothing/head/costume/maidheadband
	name = "女仆头饰"
	desc = "就像那些中国动画里的！"
	icon_state = "maid_headband"

/obj/item/clothing/head/costume/chicken
	name = "鸡头套"
	desc = "咯咯咯！"
	icon_state = "chickenhead"
	inhand_icon_state = "chicken_head"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/griffin
	name = "狮鹫头"
	desc = "为什么不是‘鹰头’？谁知道呢."
	icon_state = "griffinhat"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/xenos
	name = "异形头套"
	icon_state = "xenos"
	inhand_icon_state = "xenos_helm"
	desc = "一个由外星生物甲壳制成的头套."
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/costume/lobsterhat
	name = "泡沫龙虾头"
	desc = "当一切都走向崩溃，保护你的头是最好的选择."
	icon_state = "lobster_hat"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/drfreezehat
	name = "冷冻博士的假发"
	desc = "一个酷酷的假发，适合酷酷的人."
	icon_state = "drfreeze_hat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/costume/shrine_wig
	name = "神社巫女的假发"
	desc = "时尚地治退！"
	flags_inv = HIDEHAIR //秃头
	icon_state = "shrine_wig"
	inhand_icon_state = null
	worn_y_offset = 1

/obj/item/clothing/head/costume/cardborg
	name = "纸盒头盔"
	desc = "一个用盒子做的头盔."
	icon_state = "cardborg_h"
	inhand_icon_state = "cardborg_h"
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

	dog_fashion = /datum/dog_fashion/head/cardborg

/obj/item/clothing/head/costume/cardborg/equipped(mob/living/user, slot)
	..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/costume/cardborg))
			var/obj/item/clothing/suit/costume/cardborg/CB = H.wear_suit
			CB.disguise(user, src)

/obj/item/clothing/head/costume/cardborg/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("standard_borg_disguise")

/obj/item/clothing/head/costume/bronze
	name = "青铜盔"
	desc = "一个由青铜板制成的粗糙头盔，几乎没有任何防护作用."
	icon_state = "clockwork_helmet_old"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEHAIR
	armor_type = /datum/armor/costume_bronze

/obj/item/clothing/head/costume/fancy
	name = "华丽帽子"
	icon_state = "fancy_hat"
	greyscale_colors = "#E3C937#782A81"
	greyscale_config = /datum/greyscale_config/fancy_hat
	greyscale_config_worn = /datum/greyscale_config/fancy_hat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/football_helmet
	name = "橄榄球头盔"
	icon_state = "football_helmet"
	greyscale_colors = "#D74722"
	greyscale_config = /datum/greyscale_config/football_helmet
	greyscale_config_worn = /datum/greyscale_config/football_helmet/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/tv_head
	name = "电视头盔"
	desc = "一个用状态显示器的空壳制成的神秘头饰，真是非常复古的未来主义."
	icon_state = "IPC_helmet"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi' //从状态显示器的墙架中继承.
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	clothing_flags = SNUG_FIT
	flash_protect = FLASH_PROTECTION_SENSITIVE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	var/has_fov = TRUE

/datum/armor/costume_bronze
	melee = 5
	laser = -5
	energy = -15
	bomb = 10
	fire = 20
	acid = 20

/obj/item/clothing/head/costume/tv_head/Initialize(mapload)
	. = ..()
	if(has_fov)
		AddComponent(/datum/component/clothing_fov_visor, FOV_90_DEGREES)

/obj/item/clothing/head/costume/tv_head/fov_less
	desc = "一个用状态显示器的空壳制成的神秘头饰，真是非常复古的未来主义，这款视野更加清晰."
	has_fov = FALSE

/obj/item/clothing/head/costume/irs
	name = "税务局帽"
	desc = "即使在太空中，你也无法逃避税务员."
	icon_state = "irs_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/tmc
	name = "Lost M.C.头巾"
	desc = "一个小巧的红色头巾."
	icon_state = "tmc_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/deckers
	name = "装饰耳机"
	desc = "一对霓虹蓝色的耳机，它看起来非常新未来主义."
	icon_state = "decker_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/yuri
	name = "尤里新兵头盔"
	desc = "一个奇怪的白色头盔，有三个眼孔."
	icon_state = "yuri_helmet"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/allies
	name = "盟军头盔"
	desc = "一顶古老的军用头盔，只有最勇敢的战士才会佩戴.\
	这只是一个复制品，不能保护你免受任何伤害."
	icon_state = "allies_helmet"
	inhand_icon_state = null
