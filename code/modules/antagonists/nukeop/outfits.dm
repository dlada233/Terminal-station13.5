/datum/outfit/syndicate
	name = "辛迪加核特工 - 基础"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/storage/backpack/fireproof
	ears = /obj/item/radio/headset/syndicate/alt
	l_pocket = /obj/item/modular_computer/pda/nukeops
	r_pocket = /obj/item/pen/edagger
	id = /obj/item/card/id/advanced/chameleon
	belt = /obj/item/gun/ballistic/automatic/pistol/clandestine

	skillchips = list(/obj/item/skillchip/disk_verifier)
	box = /obj/item/storage/box/survival/syndie
	/// Amount of TC to automatically store in this outfit's uplink.
	var/tc = 25
	/// Enables big voice on this outfit's headset, used for nukie leaders.
	var/command_radio = FALSE
	/// The type of uplink to be given on equip.
	var/uplink_type = /obj/item/uplink/nuclear

	id_trim = /datum/id_trim/chameleon/operative

/datum/outfit/syndicate/plasmaman
	name = "辛迪加核特工 - 基本 (等离子人)"
	head = /obj/item/clothing/head/helmet/space/plasmaman/syndie
	uniform = /obj/item/clothing/under/plasmaman/syndicate
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/syndicate/leader
	name = "辛迪加核队队长 - 基本"
	command_radio = TRUE

	id_trim = /datum/id_trim/chameleon/operative/nuke_leader

/datum/outfit/syndicate/leader/plasmaman
	name = "辛迪加核队队长 - 基本 (等离子人)"
	head = /obj/item/clothing/head/helmet/space/plasmaman/syndie
	uniform = /obj/item/clothing/under/plasmaman/syndicate
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/syndicate/post_equip(mob/living/carbon/human/nukie, visualsOnly = FALSE)
	if(visualsOnly)
		return

	// We don't require the nukiebase be loaded to function, but lets go ahead and kick off loading just in case
	INVOKE_ASYNC(SSmapping, TYPE_PROC_REF(/datum/controller/subsystem/mapping, lazy_load_template), LAZY_TEMPLATE_KEY_NUKIEBASE)
	var/obj/item/radio/radio = nukie.ears
	radio.set_frequency(FREQ_SYNDICATE)
	radio.freqlock = RADIO_FREQENCY_LOCKED
	if(command_radio)
		radio.command = TRUE
		radio.use_command = TRUE

	if(ispath(uplink_type, /obj/item/uplink/nuclear) || tc) // /obj/item/uplink/nuclear understands 0 tc
		var/obj/item/uplink = new uplink_type(nukie, nukie.key, tc)
		nukie.equip_to_slot_or_del(uplink, ITEM_SLOT_BACKPACK, indirect_action = TRUE)

	var/obj/item/implant/weapons_auth/weapons_implant = new/obj/item/implant/weapons_auth(nukie)
	weapons_implant.implant(nukie)
	var/obj/item/implant/explosive/explosive_implant = new/obj/item/implant/explosive(nukie)
	explosive_implant.implant(nukie)
	nukie.faction |= ROLE_SYNDICATE
	nukie.update_icons()

/datum/outfit/syndicate/full
	name = "辛迪加核特工 - 全装"

	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/mod/control/pre_equipped/nuclear
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	internals_slot = ITEM_SLOT_RPOCKET
	belt = /obj/item/storage/belt/military
	r_hand = /obj/item/gun/ballistic/shotgun/bulldog
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/pistol/clandestine = 1,
		/obj/item/pen/edagger = 1,
	)

/datum/outfit/syndicate/full/plasmaman
	name = "辛迪加核特工 - 全装 (等离子人)"
	back = /obj/item/mod/control/pre_equipped/nuclear/plasmaman
	uniform = /obj/item/clothing/under/plasmaman/syndicate
	r_pocket = /obj/item/tank/internals/plasmaman/belt/full
	mask = null

/datum/outfit/syndicate/full/plasmaman/New()
	backpack_contents += /obj/item/clothing/head/helmet/space/plasmaman/syndie
	return ..()

/datum/outfit/syndicate/reinforcement
	name = "辛迪加核特工 - 增援部队"
	tc = 0
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/plastikov = 1,
		/obj/item/ammo_box/magazine/plastikov9mm = 2,
	)
	var/faction = "辛迪加"

/datum/outfit/syndicate/reinforcement/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	to_chat(H, span_notice("你是[faction]特工，被派来协助核小队执行任务. \
		支援你的友军，以及牢记: 打倒纳米传讯."))

/datum/outfit/syndicate/reinforcement/plasmaman
	name = "辛迪加核特工 - 增援部队 (等离子人)"
	head = /obj/item/clothing/head/helmet/space/plasmaman/syndie
	uniform = /obj/item/clothing/under/plasmaman/syndicate
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
	tc = 0

/datum/outfit/syndicate/reinforcement/gorlex
	name = "辛迪加特工 - Gorlex增援部队"
	suit = /obj/item/clothing/suit/armor/vest/alt
	head = /obj/item/clothing/head/helmet/swat
	neck = /obj/item/clothing/neck/large_scarf/syndie
	glasses = /obj/item/clothing/glasses/cold
	faction = "Gorlex掠夺者"

/datum/outfit/syndicate/reinforcement/cybersun
	name = "辛迪加特工 - 赛博森增援部队"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/jacket/oversized
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/sunglasses
	mask = /obj/item/clothing/mask/cigarette/cigar
	faction = "赛博森工业集团"

/datum/outfit/syndicate/reinforcement/donk
	name = "辛迪加特工 - 杜客增援部队"
	suit = /obj/item/clothing/suit/hazardvest
	head = /obj/item/clothing/head/utility/hardhat/orange
	shoes = /obj/item/clothing/shoes/workboots
	glasses = /obj/item/clothing/glasses/meson
	faction = "杜客公司"

/datum/outfit/syndicate/reinforcement/waffle
	name = "辛迪加特工 - 华夫增援部队"
	uniform = /obj/item/clothing/under/syndicate/camo
	suit = /obj/item/clothing/suit/armor/vest
	head = /obj/item/clothing/head/helmet/blueshirt
	glasses = /obj/item/clothing/glasses/welding/up
	faction = "华夫公司"

/datum/outfit/syndicate/reinforcement/interdyne
	name = "辛迪加特工 - Interdyne增援部队"
	uniform = /obj/item/clothing/under/syndicate/scrubs
	suit = /obj/item/clothing/suit/toggle/labcoat/interdyne
	head = /obj/item/clothing/head/beret/medical
	gloves = /obj/item/clothing/gloves/latex
	neck = /obj/item/clothing/neck/stethoscope
	glasses = /obj/item/clothing/glasses/hud/health
	mask = /obj/item/clothing/mask/breath/medical
	faction = "Interdyne制药公司"

/datum/outfit/syndicate/reinforcement/mi13
	name = "辛迪加特工 - MI13增援部队"
	uniform = /obj/item/clothing/under/syndicate/sniper
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	faction = "MI13"
