/obj/item/clothing/head/helmet
	name = "头盔"
	desc = "标准的安全头盔，可以减轻头部的冲击."
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/head_helmet
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT
	flags_cover = HEADCOVERSEYES|EARS_COVERED
	flags_inv = HIDEHAIR
	dog_fashion = /datum/dog_fashion/head/helmet

/datum/armor/head_helmet
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/head/helmet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/sec

/obj/item/clothing/head/helmet/sec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/sec/attackby(obj/item/attacking_item, mob/user, params)
	if(issignaler(attacking_item))
		var/obj/item/assembly/signaler/attached_signaler = attacking_item
		// There's a flashlight in us. Remove it first, or it'll be lost forever!
		var/obj/item/flashlight/seclite/blocking_us = locate() in src
		if(blocking_us)
			to_chat(user, span_warning("[blocking_us]挡住了，摘下先!"))
			return TRUE

		if(!attached_signaler.secured)
			to_chat(user, span_warning("先固定住[attached_signaler]!"))
			return TRUE

		to_chat(user, span_notice("你将 [attached_signaler] 添加到 [src]."))

		qdel(attached_signaler)
		var/obj/item/bot_assembly/secbot/secbot_frame = new(loc)
		user.put_in_hands(secbot_frame)

		qdel(src)
		return TRUE

	return ..()

/obj/item/clothing/head/helmet/alt
	name = "防弹头盔"
	desc = "一款防弹战斗头盔，能有效保护佩戴者免受传统子弹和爆炸的伤害，但程度有限."
	icon_state = "helmetalt"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/helmet_alt
	dog_fashion = null

/datum/armor/helmet_alt
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	fire = 50
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine
	name = "战术作战头盔"
	desc = "一款战术黑色头盔，用一块玻璃密封以防外界危害，但实际防护能力有限."
	icon_state = "marine_command"
	inhand_icon_state = "marine_helmet"
	armor_type = /datum/armor/helmet_marine
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null

/datum/armor/helmet_marine
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/item/clothing/head/helmet/marine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, starting_light = new /obj/item/flashlight/seclite(src), light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine/security
	name = "陆战队重型头盔"
	icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "陆战队工程头盔"
	icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "陆战队医疗头盔"
	icon_state = "marine_medic"

/obj/item/clothing/head/helmet/marine/pmc
	icon_state = "marine"
	desc = "一款战术黑色头盔，设计用于保护头部免受行动中遭受的各种伤害，其卓越的耐用性弥补了其缺乏太空适应性的缺陷."
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	clothing_flags = null
	armor_type = /datum/armor/pmc

/obj/item/clothing/head/helmet/old
	name = "老化的头盔"
	desc = "标准的安全头盔，由于老化，头盔的面罩会阻挡使用者远距离的视野."
	tint = 2

/obj/item/clothing/head/helmet/blueshirt
	name = "蓝色头盔"
	desc = "可靠的，蓝色调的头盔，提醒你你仍然欠那个工程师一杯啤酒."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift_helmet"
	custom_premium_price = PAYCHECK_COMMAND


/obj/item/clothing/head/helmet/toggleable
	visor_vars_to_toggle = NONE
	dog_fashion = null
	///chat message when the visor is toggled down.
	var/toggle_message
	///chat message when the visor is toggled up.
	var/alt_toggle_message

/obj/item/clothing/head/helmet/toggleable/attack_self(mob/user)
	adjust_visor(user)

/obj/item/clothing/head/helmet/toggleable/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][up ? "up" : ""]"

/obj/item/clothing/head/helmet/toggleable/riot
	name = "防暴头盔"
	desc = "这是一款专门设计用于防范近距离攻击的头盔."
	icon_state = "riot"
	inhand_icon_state = "riot_helmet"
	toggle_message = "You pull the visor down on"
	alt_toggle_message = "You push the visor up on"
	armor_type = /datum/armor/toggleable_riot
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)

/datum/armor/toggleable_riot
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 15

/obj/item/clothing/head/helmet/balloon
	name = "balloon helmet"
	desc = "A helmet made out of balloons. Its likes saw great usage in the Great Clown - Mime War. Surprisingly resistant to fire. Mimes were doing unspeakable things."
	icon_state = "helmet_balloon"
	inhand_icon_state = "helmet_balloon"
	armor_type = /datum/armor/balloon
	flags_inv = HIDEHAIR|HIDEEARS|HIDESNOUT
	resistance_flags = FIRE_PROOF
	dog_fashion = null

/datum/armor/balloon
	melee = 10
	fire = 60
	acid = 50

/obj/item/clothing/head/helmet/toggleable/justice
	name = "正义头盔"
	desc = "WEEEEOOO. WEEEEEOOO. WEEEEOOOO."
	icon_state = "justice"
	inhand_icon_state = "justice_helmet"
	toggle_message = "You turn off the lights on"
	alt_toggle_message = "You turn on the lights on"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	///Cooldown for toggling the visor.
	COOLDOWN_DECLARE(visor_toggle_cooldown)
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop

/obj/item/clothing/head/helmet/toggleable/justice/adjust_visor(mob/living/user)
	if(!COOLDOWN_FINISHED(src, visor_toggle_cooldown))
		return FALSE
	COOLDOWN_START(src, visor_toggle_cooldown, 2 SECONDS)
	return ..()

/obj/item/clothing/head/helmet/toggleable/justice/visor_toggling()
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/toggleable/justice/Initialize(mapload)
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/toggleable/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/toggleable/justice/escape
	name = "警报头盔"
	desc = "WEEEEOOO. WEEEEEOOO. STOP THAT MONKEY. WEEEOOOO."
	icon_state = "justice2"

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT头盔"
	desc = "一款非常坚固的、适合太空环境的头盔，采用邪恶的红黑色条纹图案."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie_helmet"
	armor_type = /datum/armor/helmet_swat
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	strip_delay = 80
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)

/datum/armor/helmet_swat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 50
	bio = 90
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "\improper SWAT头盔"
	desc = "一款非常坚固的头盔，顶部印有纳米传讯标志."
	icon_state = "swat"
	inhand_icon_state = "swat_helmet"
	clothing_flags = STACKABLE_HELMET_EXEMPT
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF


/obj/item/clothing/head/helmet/thunderdome
	name = "\improper 雷霆竞技头盔"
	desc = "<i>'Let the battle commence!'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome_helmet"
	armor_type = /datum/armor/helmet_thunderdome
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80
	dog_fashion = null

/datum/armor/helmet_thunderdome
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/thunderdome/holosuit
	cold_protection = null
	heat_protection = null
	armor_type = /datum/armor/thunderdome_holosuit

/datum/armor/thunderdome_holosuit
	melee = 10
	bullet = 10

/obj/item/clothing/head/helmet/roman
	name = "\improper 罗马头盔"
	desc = "一款由青铜和皮革制成的古代头盔."
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/helmet_roman
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman_helmet"
	strip_delay = 100
	dog_fashion = null

/datum/armor/helmet_roman
	melee = 25
	laser = 25
	energy = 10
	bomb = 10
	fire = 100
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/roman/fake
	desc = "一款由塑料和皮革制成的仿古头盔."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "\improper 罗马军团头盔"
	desc = "一款由青铜和皮革制成的古代头盔，顶部有一束红色的冠."
	icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "一款由塑料和皮革制成的仿古头盔，顶部有一束红色的冠."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/gladiator
	name = "角斗士头盔"
	desc = "Ave，Imperator，morituri te salutant."
	icon_state = "gladiator"
	inhand_icon_state = "gladiator_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/redtaghelm
	name = "红色激光标记头盔"
	desc = "他们选择了自己的结局."
	icon_state = "redtaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "redtag_helmet"
	armor_type = /datum/armor/helmet_redtaghelm
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/datum/armor/helmet_redtaghelm
	melee = 15
	bullet = 10
	laser = 20
	energy = 10
	bomb = 20
	acid = 50

/obj/item/clothing/head/helmet/bluetaghelm
	name = "蓝色激光标记头盔"
	desc = "他们需要更多的人手."
	icon_state = "bluetaghelm"
	flags_cover = HEADCOVERSEYES
	inhand_icon_state = "bluetag_helmet"
	armor_type = /datum/armor/helmet_bluetaghelm
	// Offer about the same protection as a hardhat.
	dog_fashion = null

/datum/armor/helmet_bluetaghelm
	melee = 15
	bullet = 10
	laser = 20
	energy = 10
	bomb = 20
	acid = 50

/obj/item/clothing/head/helmet/knight
	name = "中世纪头盔"
	desc = "一款经典的金属头盔."
	icon_state = "knight_green"
	inhand_icon_state = "knight_helmet"
	armor_type = /datum/armor/helmet_knight
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)

/datum/armor/helmet_knight
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "骑士头盔"
	desc = "一款经典的中世纪头盔，如果你倒过来拿，你会发现它实际上是一个桶."
	icon_state = "knight_greyscale"
	inhand_icon_state = null
	armor_type = /datum/armor/knight_greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/obj/item/clothing/head/helmet/durathread
	name = "杜拉棉头盔"
	desc = "一顶由杜拉棉和皮革制成的头盔."
	icon_state = "durathread"
	inhand_icon_state = "durathread_helmet"
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/helmet_durathread
	strip_delay = 60

/datum/armor/helmet_durathread
	melee = 20
	bullet = 10
	laser = 30
	energy = 40
	bomb = 15
	fire = 40
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet
	name = "俄罗斯头盔"
	desc = "可以放一瓶伏特加."
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor_type = /datum/armor/helmet_rus_helmet

/datum/armor/helmet_rus_helmet
	melee = 25
	bullet = 30
	energy = 10
	bomb = 10
	fire = 20
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/helmet)

/obj/item/clothing/head/helmet/rus_ushanka
	name = "战斗风帽"
	desc = "100% 熊皮."
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor_type = /datum/armor/helmet_rus_ushanka

/datum/armor/helmet_rus_ushanka
	melee = 25
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 50
	fire = -10
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/elder_atmosian
	name = "古代大气头盔"
	desc = "一顶由人类可得到的最坚固和最稀有材料制成的绝佳头盔."
	icon_state = "h2helmet"
	inhand_icon_state = "h2_helmet"
	armor_type = /datum/armor/helmet_elder_atmosian
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/datum/armor/helmet_elder_atmosian
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 85
	bio = 10
	fire = 65
	acid = 40
	wound = 15

/obj/item/clothing/head/helmet/military
	name = "Crude Helmet"
	desc = "A cheaply made kettle helmet with an added faceplate to protect your eyes and mouth."
	icon_state = "military"
	inhand_icon_state = "knight_helmet"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_FLASH
	strip_delay = 80
	dog_fashion = null
	armor_type = /datum/armor/helmet_military

/datum/armor/helmet_military
	melee = 45
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 10
	acid = 50
	wound = 20

/obj/item/clothing/head/helmet/military/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/clothing_fov_visor, FOV_90_DEGREES)

/obj/item/clothing/head/helmet/knight/warlord
	name = "golden barbute helmet"
	desc = "There is no man behind the helmet, only a terrible thought."
	icon_state = "warlord"
	inhand_icon_state = null
	armor_type = /datum/armor/helmet_warlord
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_FLASH
	slowdown = 0.2

/datum/armor/helmet_warlord
	melee = 70
	bullet = 60
	laser = 70
	energy = 70
	bomb = 40
	fire = 50
	acid = 50
	wound = 30
