/**
 * Command
 */

/obj/item/modular_computer/pda/heads
	greyscale_config = /datum/greyscale_config/tablet/head
	greyscale_colors = "#67A364#a92323"
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
	)

/obj/item/modular_computer/pda/heads/captain
	name = "舰长PDA"
	greyscale_config = /datum/greyscale_config/tablet/captain
	greyscale_colors = "#2C7CB2#FF0000#FFFFFF#FFD55B"
	inserted_item = /obj/item/pen/fountain/captain

/obj/item/modular_computer/pda/heads/captain/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TABLET_CHECK_DETONATE, PROC_REF(tab_no_detonate))
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/heads/captain/proc/tab_no_detonate()
	SIGNAL_HANDLER
	return COMPONENT_TABLET_NO_DETONATE

/obj/item/modular_computer/pda/heads/hop
	name = "人事部长PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#374f7e#a52f29#a52f29"
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/modular_computer/pda/heads/hos
	name = "安保部长PDA"
	greyscale_config = /datum/greyscale_config/tablet/head
	greyscale_colors = "#EA3232#0000CC"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/records/security,
	)

/obj/item/modular_computer/pda/heads/ce
	name = "工程部长PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#D99A2E#69DBF3#FAFAFA"
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
	)

/obj/item/modular_computer/pda/heads/cmo
	name = "首席医疗官PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#FAFAFA#000099#3F96CC"
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/maintenance/phys_scanner,
		/datum/computer_file/program/records/medical,
	)

/obj/item/modular_computer/pda/heads/rd
	name = "科研主管PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#FAFAFA#000099#B347BC"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/borg_monitor,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/science,
		/datum/computer_file/program/status,
		/datum/computer_file/program/signal_commander,
	)

/obj/item/modular_computer/pda/heads/quartermaster
	name = "军需官PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#c4b787#18191e#8b4c31"
	inserted_item = /obj/item/pen/survival
	stored_paper = 20
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/restock_tracker,
	)

/**
 * Security
 */

/obj/item/modular_computer/pda/security
	name = "安全官PDA"
	greyscale_colors = "#EA3232#0000cc"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/detective
	name = "侦探PDA"
	greyscale_colors = "#805A2F#990202"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/warden
	name = "典狱长PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double
	greyscale_colors = "#EA3232#0000CC#363636"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
	)

/**
 * Engineering
 */

/obj/item/modular_computer/pda/engineering
	name = "工程师PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#D99A2E#69DBF3#E3DF3D"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,
	)

/obj/item/modular_computer/pda/atmos
	name = "大气技术员PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#EEDC43#00E5DA#727272"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,
	)

/**
 * Science
 */

/obj/item/modular_computer/pda/science
	name = "科学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#FAFAFA#000099#B347BC"
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/science,
		/datum/computer_file/program/signal_commander,
	)

/obj/item/modular_computer/pda/roboticist
	name = "机械学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double
	greyscale_colors = "#484848#0099CC#D94927"
	starting_programs = list(
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
	)

/obj/item/modular_computer/pda/geneticist
	name = "基因学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double
	greyscale_colors = "#FAFAFA#000099#0097CA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/**
 * Medical
 */

/obj/item/modular_computer/pda/medical
	name = "医生PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#FAFAFA#000099#3F96CC"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/medical/paramedic
	name = "急救员PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_double
	greyscale_colors = "#28334D#000099#3F96CC"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/radar/lifeline,
	)

/obj/item/modular_computer/pda/chemist
	name = "化学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#FAFAFA#355FAC#EA6400"

/obj/item/modular_computer/pda/coroner
	name = "验尸官PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#FAFAFA#000099#1f2026"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/crew_manifest,
	)

/**
 * Supply
 */

/obj/item/modular_computer/pda/cargo
	name = "货仓技工PDA"
	greyscale_colors = "#8b4c31#2c2e32"
	stored_paper = 20
	starting_programs = list(
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/restock_tracker,
	)

/obj/item/modular_computer/pda/shaftminer
	name = "竖井矿工PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#927444#8b4c31#4c202d"
	starting_programs = list(
		/datum/computer_file/program/skill_tracker,
	)

/obj/item/modular_computer/pda/bitrunner
	name = "比特矿工PDA"
	greyscale_colors = "#D6B328#6BC906"
	starting_programs = list(
		/datum/computer_file/program/arcade,
		/datum/computer_file/program/skill_tracker,
	)

/**
 * Service
 */

/obj/item/modular_computer/pda/janitor
	name = "清洁工PDA"
	greyscale_colors = "#933ea8#235AB2"
	starting_programs = list(
		/datum/computer_file/program/skill_tracker,
		/datum/computer_file/program/radar/custodial_locator,
	)

/obj/item/modular_computer/pda/chaplain
	name = "牧师PDA"
	greyscale_config = /datum/greyscale_config/tablet/chaplain
	greyscale_colors = "#333333#D11818"

/obj/item/modular_computer/pda/lawyer
	name = "律师PDA"
	greyscale_colors = "#4C76C8#FFE243"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/modular_computer/pda/lawyer/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/botanist
	name = "植物学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#50E193#E26F41#71A7CA"

/obj/item/modular_computer/pda/cook
	name = "厨师PDA"
	greyscale_colors = "#FAFAFA#A92323"

/obj/item/modular_computer/pda/bar
	name = "酒保PDA"
	greyscale_colors = "#333333#C7C7C7"
	inserted_item = /obj/item/pen/fountain

/obj/item/modular_computer/pda/clown
	name = "小丑PDA"
	inserted_disk = /obj/item/computer_disk/virus/clown
	icon_state = "pda-clown"
	greyscale_config = null
	greyscale_colors = null
	inserted_item = /obj/item/toy/crayon/rainbow

/obj/item/modular_computer/pda/clown/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/slippery,\
		knockdown = 12 SECONDS,\
		lube_flags = NO_SLIP_WHEN_WALKING,\
		on_slip_callback = CALLBACK(src, PROC_REF(AfterSlip)),\
		can_slip_callback = CALLBACK(src, PROC_REF(try_slip)),\
		slot_whitelist = list(ITEM_SLOT_ID, ITEM_SLOT_BELT),\
	)
	AddComponent(/datum/component/wearertargeting/sitcomlaughter, CALLBACK(src, PROC_REF(after_sitcom_laugh)))

/// Returns whether the PDA can slip or not, if we have a wearer then check if they are in a position to slip someone.
/obj/item/modular_computer/pda/clown/proc/try_slip(mob/living/slipper, mob/living/slippee)
	if(isnull(slipper))
		return TRUE
	if(!istype(slipper.get_item_by_slot(ITEM_SLOT_FEET), /obj/item/clothing/shoes/clown_shoes))
		to_chat(slipper,span_warning("[src]没能让任何人滑到，也许我不该放弃我的遗物..."))
		return FALSE
	return TRUE

/obj/item/modular_computer/pda/clown/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "pda_stripe_clown") // clowns have eyes that go over their screen, so it needs to be compiled last

/obj/item/modular_computer/pda/clown/proc/AfterSlip(mob/living/carbon/human/M)
	if (istype(M) && (M.real_name != saved_identification))
		var/obj/item/computer_disk/virus/clown/cart = inserted_disk
		if(istype(cart) && cart.charges < 5)
			cart.charges++
			playsound(src,'sound/machines/ping.ogg',30,TRUE)

/obj/item/modular_computer/pda/clown/proc/after_sitcom_laugh(mob/victim)
	victim.visible_message("[src]爆发出一阵欢笑!")

/obj/item/modular_computer/pda/mime
	name = "默剧PDA"
	inserted_disk = /obj/item/computer_disk/virus/mime
	greyscale_config = /datum/greyscale_config/tablet/mime
	greyscale_colors = "#FAFAFA#EA3232"
	inserted_item = /obj/item/toy/crayon/mime
	starting_programs = list(
		/datum/computer_file/program/emojipedia,
	)

/obj/item/modular_computer/pda/mime/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/msg in stored_files)
		msg.mime_mode = TRUE
		msg.alert_silenced = TRUE

/obj/item/modular_computer/pda/curator
	name = "馆长PDA"
	desc = "一台实验型微型计算机."
	greyscale_config = null
	greyscale_colors = null
	icon_state = "pda-library"
	inserted_item = /obj/item/pen/fountain
	long_ranged = TRUE
	starting_programs = list(
		/datum/computer_file/program/emojipedia,
		/datum/computer_file/program/newscaster,
	)

/* // SKYRAT EDIT REMOVAL BEGIN - Mutes the Curator's ringer on spawn
/obj/item/modular_computer/pda/curator/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/msg in stored_files)
		msg.alert_silenced = TRUE
*/ // SKYRAT EDIT REMOVAL END

/obj/item/modular_computer/pda/psychologist
	name = "心理学家PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#333333#000099#3F96CC"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
	)

/**
 * No Department/Station Trait
 */
/obj/item/modular_computer/pda/assistant
	name = "助手PDA"
	starting_programs = list(
		/datum/computer_file/program/bounty_board,
	)

/obj/item/modular_computer/pda/bridge_assistant
	name = "舰桥助手PDA"
	greyscale_colors = "#374f7e#a92323"
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
	)

/obj/item/modular_computer/pda/veteran_advisor
	name = "security advisor PDA"
	greyscale_colors = "#EA3232#FFD700"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/coupon, //veteran discount
		/datum/computer_file/program/skill_tracker,
	)

/obj/item/modular_computer/pda/human_ai
	name = "modular interface"
	icon_state = "pda-silicon-human"
	base_icon_state = "pda-silicon-human"
	greyscale_config = null
	greyscale_colors = null

	has_light = FALSE //parity with borg PDAs
	comp_light_luminosity = 0
	inserted_item = null
	has_pda_programs = FALSE
	starting_programs = list(
		/datum/computer_file/program/messenger,
		/datum/computer_file/program/secureye/human_ai,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/status,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
	)

/**
 * Non-roles
 */
/obj/item/modular_computer/pda/syndicate
	name = "军用PDA"
	greyscale_colors = "#891417#80FF80"
	saved_identification = "John Doe"
	saved_job = "Citizen"
	device_theme = PDA_THEME_SYNDICATE

/obj/item/modular_computer/pda/syndicate/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/messenger/msg = locate() in stored_files
	if(msg)
		msg.invisible = TRUE

/obj/item/modular_computer/pda/clear
	name = "透明款PDA"
	icon_state = "pda-clear"
	greyscale_config = null
	greyscale_colors = null
	long_ranged = TRUE

/obj/item/modular_computer/pda/clear/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/themeify/theme_app = locate() in stored_files
	if(theme_app)
		for(var/theme_key in GLOB.pda_name_to_theme - GLOB.default_pda_themes)
			theme_app.imported_themes += theme_key

/obj/item/modular_computer/pda/clear/get_messenger_ending()
	return "来自我的晶体PDA"
