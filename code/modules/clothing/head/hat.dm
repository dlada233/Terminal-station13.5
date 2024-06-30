/obj/item/clothing/head/hats
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'

/obj/item/clothing/head/hats/centhat
	name = "中心指挥部帽"
	icon_state = "centcom"
	desc = "做皇帝感觉真好."
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_centhat
	strip_delay = 80

/datum/armor/hats_centhat
	melee = 30
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/costume/constable
	name = "警官头盔"
	desc = "一顶英国风格的头盔."
	icon_state = "constable"
	inhand_icon_state = null
	custom_price = PAYCHECK_COMMAND * 1.5
	worn_y_offset = 4

/obj/item/clothing/head/costume/spacepolice
	name = "太空警察帽"
	desc = "巡逻日常路线的蓝色帽子."
	icon_state = "policecap_families"
	inhand_icon_state = null

/obj/item/clothing/head/costume/canada
	name = "红色条纹礼帽"
	desc = "闻起来像新鲜的甜甜圈洞. / <i>Il sent comme des trous de beignets frais.</i>"
	icon_state = "canada"
	inhand_icon_state = null

/obj/item/clothing/head/costume/redcoat
	name = "红杉军帽"
	icon_state = "redcoat"
	desc = "<i>'我猜这是一个红头发的人.'</i>"

/obj/item/clothing/head/costume/mailman
	name = "邮差帽"
	icon_state = "mailman"
	desc = "<i>'准时'</i> 邮件服务头饰."
	clothing_traits = list(TRAIT_HATED_BY_DOGS)

/obj/item/clothing/head/bio_hood/plague
	name = "瘟疫医生帽"
	desc = "这些曾被瘟疫医生使用.将保护你免受瘟疫的影响."
	icon_state = "plaguedoctor"
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT | STACKABLE_HELMET_EXEMPT
	armor_type = /datum/armor/bio_hood_plague
	flags_inv = NONE

/datum/armor/bio_hood_plague
	bio = 100

/obj/item/clothing/head/costume/nursehat
	name = "护士帽"
	desc = "能够快速识别训练有素的医疗人员."
	icon_state = "nursehat"
	dog_fashion = /datum/dog_fashion/head/nurse

/obj/item/clothing/head/hats/bowler
	name = "圆顶礼帽"
	desc = "绅士，精英上船了！"
	icon_state = "bowler"
	inhand_icon_state = null

/obj/item/clothing/head/costume/bearpelt
	name = "熊皮帽"
	desc = "毛茸茸的."
	icon_state = "bearpelt"
	inhand_icon_state = null

/obj/item/clothing/head/flatcap
	name = "平顶帽"
	desc = "工人阶级的帽子."
	icon_state = "beret_flat"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#8F7654"
	inhand_icon_state = null

/obj/item/clothing/head/cowboy
	name = "牛仔帽"
	desc = "在我的城镇里，没有人能够骗过绞刑手."
	icon = 'icons/obj/clothing/head/cowboy.dmi'
	worn_icon = 'icons/mob/clothing/head/cowboy.dmi'
	icon_state = "cowboy_hat_brown"
	worn_icon_state = "hunter"
	inhand_icon_state = null
	armor_type = /datum/armor/head_cowboy
	resistance_flags = FIRE_PROOF | ACID_PROOF
	/// 有机会帽子为你挡住子弹
	var/deflect_chance = 2

/obj/item/clothing/head/cowboy/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/bullet_intercepting,\
		block_chance = deflect_chance,\
		active_slots = ITEM_SLOT_HEAD,\
		on_intercepted = CALLBACK(src, PROC_REF(on_intercepted_bullet)),\
	)

/// 当我们拦截到子弹时，将帽子抛出去
/obj/item/clothing/head/cowboy/proc/on_intercepted_bullet(mob/living/victim, obj/projectile/bullet)
	victim.visible_message(span_warning("子弹把[victim]的帽子打飞了！"))
	victim.dropItemToGround(src, force = TRUE, silent = TRUE)
	throw_at(get_edge_target_turf(loc, pick(GLOB.alldirs)), range = 3, speed = 3)
	playsound(victim, get_sfx(SFX_RICOCHET), 100, TRUE)

/datum/armor/head_cowboy
	melee = 5
	bullet = 5
	laser = 5
	energy = 15

/// 赏金猎人的帽子，很可能拦截子弹
/obj/item/clothing/head/cowboy/bounty
	name = "赏金猎人帽"
	desc = "伸手摘星吧，伙计."
	icon_state = "bounty_hunter"
	worn_icon_state = "hunter"
	deflect_chance = 50

/obj/item/clothing/head/cowboy/black
	name = "恶棍帽"
	desc = "脖子上系着绳子的人并不总是被绞死的."
	icon_state = "cowboy_hat_black"
	worn_icon_state = "cowboy_hat_black"
	inhand_icon_state = "cowboy_hat_black"

/// 更容易拦截子弹，因为你很可能在这个帽子上不戴你的改装服
/obj/item/clothing/head/cowboy/black/syndicate
	deflect_chance = 25

/obj/item/clothing/head/cowboy/white
	name = "十加仑帽"
	desc = "世界上有两种人，拿枪的和挖坑的.你懂吗？"
	icon_state = "cowboy_hat_white"
	worn_icon_state = "cowboy_hat_white"
	inhand_icon_state = "cowboy_hat_white"

/obj/item/clothing/head/cowboy/grey
	name = "漂泊者帽"
	desc = "没有名字的助手的帽子."
	icon_state = "cowboy_hat_grey"
	worn_icon_state = "cowboy_hat_grey"
	inhand_icon_state = "cowboy_hat_grey"

/obj/item/clothing/head/cowboy/red
	name = "副警长帽"
	desc = "不要让花哨的颜色愚弄你，这顶帽子见证了一些可怕的事情."
	icon_state = "cowboy_hat_red"
	worn_icon_state = "cowboy_hat_red"
	inhand_icon_state = "cowboy_hat_red"

/obj/item/clothing/head/cowboy/brown
	name = "警长帽"
	desc = "伸手摘星吧，伙计."
	icon_state = "cowboy_hat_brown"
	worn_icon_state = "cowboy_hat_brown"
	inhand_icon_state = "cowboy_hat_brown"

/obj/item/clothing/head/costume/santa
	name = "圣诞帽"
	desc = "在圣诞节的第一天，我的老板给了我这个！"
	icon_state = "santahatnorm"
	inhand_icon_state = "that"
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/head/costume/santa/gags
	name = "圣诞帽"
	desc = "在圣诞节的第一天，我的老板给了我这个！"
	desc = "On the first day of christmas my employer gave to me!"
	icon_state = "santa_hat"
	greyscale_colors = "#cc0000#f8f8f8"
	greyscale_config = /datum/greyscale_config/santa_hat
	greyscale_config_worn = /datum/greyscale_config/santa_hat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/jester
	name = "弄臣帽"
	desc = "带有铃铛的帽子，给套装增添一些欢乐气氛."
	icon_state = "jester_map"
	greyscale_colors = "#00ff00#ff0000"
	greyscale_config = /datum/greyscale_config/jester_hat
	greyscale_config_worn = /datum/greyscale_config/jester_hat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/jesteralt
	name = "弄臣帽"
	desc = "带有铃铛的帽子，给套装增添一些欢乐气氛."
	icon_state = "jester2"

/obj/item/clothing/head/costume/rice_hat
	name = "稻田斗笠"
	desc = "欢迎来到稻田，混蛋."
	icon_state = "rice_hat"

/obj/item/clothing/head/costume/lizard
	name = "蜥蜴皮帽"
	desc = "就为了制作这顶帽子，有多少蜥蜴死去？快继续做吧，我看不得这些."
	icon_state = "lizard"

/obj/item/clothing/head/costume/scarecrow_hat
	name = "稻草人帽"
	desc = "一个简单的稻草帽."
	icon_state = "scarecrow_hat"

/obj/item/clothing/head/costume/pharaoh
	name = "法老帽"
	desc = "走得像埃及人一样."
	icon_state = "pharoah_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/nemes
	name = "尼美斯头饰"
	desc = "豪华的太空墓不包括在内."
	icon_state = "nemes_headdress"

/obj/item/clothing/head/costume/delinquent
	name = "恶棍帽"
	desc = "好可怕."
	icon_state = "delinquent"

/obj/item/clothing/head/hats/intern
	name = "中央指挥部首席实习生小圆帽"
	desc = "小圆帽和软帽混合体，带着中央指挥部的绿，你必须对支配同事有强烈欲望才会同意戴上这个."
	icon_state = "intern_hat"
	inhand_icon_state = null

/obj/item/clothing/head/hats/coordinator
	name = "策划人帽"
	desc = "派对策划人的帽子，时尚！"
	icon_state = "capcap"
	inhand_icon_state = "that"
	armor_type = /datum/armor/hats_coordinator

/datum/armor/hats_coordinator
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/costume/jackbros
	name = "霜之帽"
	desc = "Hee-ho!"
	icon_state = "JackFrostHat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/weddingveil
	name = "婚礼面纱"
	desc = "一条薄薄的白色面纱."
	icon_state = "weddingveil"
	inhand_icon_state = null

/obj/item/clothing/head/hats/centcom_cap
	name = "中央指挥部指挥官帽"
	icon_state = "centcom_cap"
	desc = "由最优秀的中央指挥部指挥官佩戴，帽子内衬上刻着两个淡淡的字母."
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_centcom_cap
	strip_delay = (8 SECONDS)
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON //SKYRAT EDIT 让人形生物戴上这顶帽子

/datum/armor/hats_centcom_cap
	melee = 30
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/fedora/human_leather
	name = "人皮帽"
	desc = "这会吓唬他们，所有人都将知晓我的恐怖."
	icon_state = "human_leather"
	inhand_icon_state = null

/obj/item/clothing/head/costume/ushanka
	name = "乌什卡帽"
	desc = "西伯利亚冬季的完美选择，对吧？"
	icon_state = "ushankadown"
	inhand_icon_state = null
	flags_inv = HIDEEARS //SKYRAT EDIT (Original: HIDEEARS|HIDEHAIR)
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	dog_fashion = /datum/dog_fashion/head/ushanka
	var/earflaps = TRUE
	///Sprite visible when the ushanka flaps are folded up.
	var/upsprite = "ushankaup"
	///Sprite visible when the ushanka flaps are folded down.
	var/downsprite = "ushankadown"

/obj/item/clothing/head/costume/ushanka/attack_self(mob/user)
	if(earflaps)
		icon_state = upsprite
		inhand_icon_state = upsprite
		to_chat(user, span_notice("你将乌什卡上的耳瓣抬起."))
	else
		icon_state = downsprite
		inhand_icon_state = downsprite
		to_chat(user, span_notice("你将乌什卡上的耳瓣放下."))
	earflaps = !earflaps

/obj/item/clothing/head/costume/ushanka/polar
	name = "bear hunter's ushanka"
	desc = "Handcrafted in Siberia from real polar bears."
	icon_state = "ushankadown_polar"
	upsprite = "ushankaup_polar"
	downsprite = "ushankadown_polar"

/obj/item/clothing/head/costume/nightcap/blue
	name = "蓝色睡帽"
	desc = "适合所有梦想家和瞌睡虫."
	icon_state = "sleep_blue"

/obj/item/clothing/head/costume/nightcap/red
	name = "红色睡帽"
	desc = "适合所有梦想家和瞌睡虫."
	icon_state = "sleep_red"

/obj/item/clothing/head/costume/paper_hat
	name = "纸帽"
	desc = "一顶由纸制成的薄帽."
	icon_state = "paper"
	worn_icon_state = "paper"
	dog_fashion = /datum/dog_fashion/head
