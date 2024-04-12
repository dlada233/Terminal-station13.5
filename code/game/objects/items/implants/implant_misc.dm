/obj/item/implant/weapons_auth
	name = "'枪械认证'植入物"
	desc = "让你可以使用你的枪."
	icon_state = "auth"
	actions_types = null

/obj/item/implant/weapons_auth/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Firearms Authentication Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Allows operation of implant-locked weaponry, preventing equipment from falling into enemy hands."}
	return dat

/obj/item/implant/emp
	name = "'电磁脉冲'植入物"
	desc = "触发一道电磁脉冲."
	icon_state = "emp"
	uses = 3

/obj/item/implant/emp/activate()
	. = ..()
	uses--
	empulse(imp_in, 3, 5)
	if(!uses)
		qdel(src)

/obj/item/implanter/emp
	name = "植入器" // Skyrat edit, was implanter (EMP)
	imp_type = /obj/item/implant/emp
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "一个用于植入'电磁脉冲'植入物的辛迪加植入器" // Skyrat edit

/obj/item/implant/radio
	name = "'无线电'植入物"
	var/obj/item/radio/radio
	var/radio_key
	var/subspace_transmission = FALSE
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "walkietalkie"

/obj/item/implant/radio/activate()
	. = ..()
	// needs to be GLOB.deep_inventory_state otherwise it won't open
	radio.ui_interact(usr, state = GLOB.deep_inventory_state)

/obj/item/implant/radio/Initialize(mapload)
	. = ..()

	radio = new(src)
	// almost like an internal headset, but without the
	// "must be in ears to hear" restriction.
	radio.name = "内置无线电"
	radio.subspace_transmission = subspace_transmission
	radio.canhear_range = 0
	if(radio_key)
		radio.keyslot = new radio_key
	radio.recalculateChannels()

/obj/item/implant/radio/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/implant/radio/mining
	radio_key = /obj/item/encryptionkey/headset_cargo

/obj/item/implant/radio/syndicate
	desc = "-是你吗，上帝? -是我，辛迪加通讯监听员."
	radio_key = /obj/item/encryptionkey/syndicate
	subspace_transmission = TRUE

/obj/item/implant/radio/slime
	name = "史莱姆无线电"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "adamantine_resonator"
	radio_key = /obj/item/encryptionkey/headset_sci
	subspace_transmission = TRUE

/obj/item/implant/radio/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Internal Radio Implant<BR>
				<b>Life:</b> 24 hours<BR>
				<b>Implant Details:</b> Allows user to use an internal radio, useful if user expects equipment loss, or cannot equip conventional radios."}
	return dat

/obj/item/implanter/radio
	name = "植入器(内置无线电)"
	imp_type = /obj/item/implant/radio

/obj/item/implanter/radio/syndicate
	name = "植入器" // Skyrat edit , was originally implanter (internal syndicate radio)
	imp_type = /obj/item/implant/radio/syndicate
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "一个用于植入'内置无线电'植入物的辛迪加植入器" // Skyrat edit

