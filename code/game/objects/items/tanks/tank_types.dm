/* Types of tanks!
 * Contains:
 * Oxygen
 * Anesthetic
 * Air
 * Plasma
 * Emergency Oxygen
 * Generic
 */

/// Allows carbon to toggle internals via AltClick of the equipped tank.
/obj/item/tank/internals/AltClick(mob/user)
	..()
	if((loc == user) && user.can_perform_action(src, FORBID_TELEKINESIS_REACH|NEED_HANDS))
		toggle_internals(user)

/obj/item/tank/internals/examine(mob/user)
	. = ..()
	. += span_notice("Alt+左键拧开输气阀门.")

/*
 * Oxygen
 */
/obj/item/tank/internals/oxygen
	name = "氧气瓶"
	desc = "一罐蓝色的氧气瓶."
	icon_state = "oxygen"
	inhand_icon_state = "oxygen_tank"
	tank_holder_icon_state = "holder_oxygen"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back


/obj/item/tank/internals/oxygen/populate_gas()
	air_contents.assert_gas(/datum/gas/oxygen)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)


/obj/item/tank/internals/oxygen/yellow
	desc = "一罐黄色的氧气瓶."
	icon_state = "oxygen_f"
	inhand_icon_state = "oxygen_f_tank"
	tank_holder_icon_state = "holder_oxygen_f"
	dog_fashion = null

/obj/item/tank/internals/oxygen/red
	desc = "一罐红色的氧气瓶."
	icon_state = "oxygen_fr"
	inhand_icon_state = "oxygen_fr_tank"
	tank_holder_icon_state = "holder_oxygen_fr"
	dog_fashion = null

/obj/item/tank/internals/oxygen/empty/populate_gas()
	return

/*
 * Anesthetic
 */
/obj/item/tank/internals/anesthetic
	name = "麻醉气体瓶"
	desc = "麻醉气体由N2O与O2的混合而成."
	icon_state = "anesthetic"
	inhand_icon_state = "an_tank"
	tank_holder_icon_state = "holder_anesthetic"
	force = 10

/obj/item/tank/internals/anesthetic/populate_gas()
	air_contents.assert_gases(/datum/gas/oxygen, /datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD

/obj/item/tank/internals/anesthetic/examine(mob/user)
	. = ..()
	. += span_notice("有一行警告刻在瓶身上...")
	. += span_warning("N2O并不会在人体内被消耗，所以病人将呼出N20...请待在通风良好的地方进行工作，以免发生大气事故.")

/*
 * Plasma
 */
/obj/item/tank/internals/plasma
	name = "等离子气瓶"
	desc = "含有危险的等离子，请勿吸入，警告: 极度易燃."
	icon_state = "plasma"
	inhand_icon_state = "plasma_tank"
	worn_icon_state = "plasmatank"
	tank_holder_icon_state = null
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = null //they have no straps!
	force = 8


/obj/item/tank/internals/plasma/populate_gas()
	air_contents.assert_gas(/datum/gas/plasma)
	air_contents.gases[/datum/gas/plasma][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/plasma/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.status) || (F.ptank))
			return
		if(!user.transferItemToLoc(src, F))
			return
		src.master = F
		F.ptank = src
		F.update_appearance()
	else
		return ..()

/obj/item/tank/internals/plasma/full/populate_gas()
	air_contents.assert_gas(/datum/gas/plasma)
	air_contents.gases[/datum/gas/plasma][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/plasma/empty/populate_gas()
	return

/*
 * Plasmaman Plasma Tank
 */

/obj/item/tank/internals/plasmaman
	name = "等离子吸入瓶"
	desc = "专为吸入使用而设计的等离子瓶，适用于等离子形式的生命体，换言之，如果你不是等离子人，你就不应该使用它."
	icon_state = "plasmaman_tank"
	inhand_icon_state = "plasmaman_tank"
	tank_holder_icon_state = null
	force = 10
	distribute_pressure = TANK_PLASMAMAN_RELEASE_PRESSURE

/obj/item/tank/internals/plasmaman/populate_gas()
	air_contents.assert_gas(/datum/gas/plasma)
	air_contents.gases[/datum/gas/plasma][MOLES] = (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/plasmaman/full/populate_gas()
	air_contents.assert_gas(/datum/gas/plasma)
	air_contents.gases[/datum/gas/plasma][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)


/obj/item/tank/internals/plasmaman/belt
	icon_state = "plasmaman_tank_belt"
	inhand_icon_state = "plasmaman_tank_belt"
	worn_icon_state = "plasmaman_tank_belt"
	tank_holder_icon_state = null
	worn_icon = null
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 6 //same size as the engineering ones but plasmamen have special lungs that consume less plasma per breath
	w_class = WEIGHT_CLASS_SMALL //thanks i forgot this

/obj/item/tank/internals/plasmaman/belt/full/populate_gas()
	air_contents.assert_gas(/datum/gas/plasma)
	air_contents.gases[/datum/gas/plasma][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/obj/item/tank/internals/plasmaman/belt/empty/populate_gas()
	return



/*
 * Emergency Oxygen
 */
/obj/item/tank/internals/emergency_oxygen
	name = "应急氧气瓶"
	desc = "用于紧急情况，容量很少，所以平时请节省用量."
	icon_state = "emergency"
	inhand_icon_state = "emergency_tank"
	worn_icon_state = "emergency"
	tank_holder_icon_state = "holder_emergency"
	worn_icon = null
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	volume = 3 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)


/obj/item/tank/internals/emergency_oxygen/populate_gas()
	air_contents.assert_gas(/datum/gas/oxygen)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)


/obj/item/tank/internals/emergency_oxygen/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/engi
	name = "扩容应急氧气瓶"
	icon_state = "emergency_engi"
	inhand_icon_state = "emergency_engi_tank"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	worn_icon = null
	volume = 6 // should last 24 minutes if full

/obj/item/tank/internals/emergency_oxygen/engi/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/double
	name = "双联应急氧气瓶"
	icon_state = "emergency_double"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	volume = 12 //If it's double of the above, shouldn't it be double the volume??

/obj/item/tank/internals/emergency_oxygen/double/empty/populate_gas()
	return

// *
// * GENERIC
// *

/obj/item/tank/internals/generic
	name = "气体瓶"
	desc = "用于储存和运输气体的通用气体瓶，当然可以用来吸入人体."
	icon_state = "generic"
	inhand_icon_state = "generic_tank"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back

/obj/item/tank/internals/generic/populate_gas()
	return

/*
 * Funny internals
 */
/obj/item/tank/internals/emergency_oxygen/engi/clown
	name = "应急奇趣瓶"
	desc = "用于紧急情况，含有很少的氧气和额外一种有趣的气体."
	icon_state = "emergency_clown"
	inhand_icon_state = "emergency_clown"
	worn_icon_state = "emergency_clown"
	tank_holder_icon_state = "holder_emergency_clown"
	distribute_pressure = TANK_CLOWN_RELEASE_PRESSURE

/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o

/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o/populate_gas()
	air_contents.assert_gases(/datum/gas/oxygen, /datum/gas/nitrous_oxide)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.95
	air_contents.gases[/datum/gas/nitrous_oxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.05

/obj/item/tank/internals/emergency_oxygen/engi/clown/bz

/obj/item/tank/internals/emergency_oxygen/engi/clown/bz/populate_gas()
	air_contents.assert_gases(/datum/gas/oxygen, /datum/gas/bz)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.9
	air_contents.gases[/datum/gas/bz][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.1

/obj/item/tank/internals/emergency_oxygen/engi/clown/helium
	distribute_pressure = TANK_CLOWN_RELEASE_PRESSURE + 2

/obj/item/tank/internals/emergency_oxygen/engi/clown/helium/populate_gas()
	air_contents.assert_gases(/datum/gas/oxygen, /datum/gas/helium)
	air_contents.gases[/datum/gas/oxygen][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.75
	air_contents.gases[/datum/gas/helium][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * 0.25
