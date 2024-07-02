/datum/supply_pack/vending
	group = "自动售货机补货单元"

/datum/supply_pack/vending/bartending
	name = "Booze-o-mat and Coffee 补货单元"
	desc = "Bring on the booze and coffee vending machine refills."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee,
				)
	crate_name = "bartending 补货单元"

/datum/supply_pack/vending/cigarette
	name = "Cigarette 补货单元"
	desc = "Don't believe the reports - smoke today! Contains a \
		cigarette vending machine refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/cigarette)
	crate_name = "cigarette 补货单元"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/dinnerware
	name = "Dinnerware 补货单元"
	desc = "More knives for the chef."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/dinnerware)
	crate_name = "dinnerware 补货单元"

/datum/supply_pack/vending/science/modularpc
	name = "Deluxe Silicate Selections Restock"
	desc = "What's a computer? Contains a Deluxe Silicate Selections restocking unit."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/modularpc)
	crate_name = "computer 补货单元"

/datum/supply_pack/vending/engivend
	name = "EngiVend 补货单元"
	desc = "The engineers are out of metal foam grenades? This should help."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/engivend)
	crate_name = "engineering 补货单元"

/datum/supply_pack/vending/games
	name = "Games 补货单元"
	desc = "Get your game on with this game vending machine refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/games)
	crate_name = "games 补货单元"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/hydro_refills
	name = "Hydroponics Vending Machines Refills"
	desc = "When the clown takes all the banana seeds. \
		Contains a NutriMax refill and a MegaSeed Servitor refill."
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/vending_refill/hydroseeds,
					/obj/item/vending_refill/hydronutrients,
				)
	crate_name = "hydroponics 补货单元"

/datum/supply_pack/vending/imported
	name = "Imported Vending Machines"
	desc = "Vending machines famous in other parts of the galaxy."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/vending_refill/sustenance,
					/obj/item/vending_refill/robotics,
					/obj/item/vending_refill/sovietsoda,
					/obj/item/vending_refill/engineering,
				)
	crate_name = "unlabeled 补货单元"

/datum/supply_pack/vending/medical
	name = "Medical Vending Crate"
	desc = "Contains one NanoMed Plus refill, one NanoDrug Plus refill, \
		and one wall-mounted NanoMed refill."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs,
					/obj/item/vending_refill/wallmed,
				)
	crate_name = "medical vending crate"

/datum/supply_pack/vending/ptech
	name = "PTech 补货单元"
	desc = "Not enough cartridges after half the crew lost their PDA \
		to explosions? This may fix it."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/vending_refill/cart)
	crate_name = "\improper PTech 补货单元"

/datum/supply_pack/vending/sectech
	name = "SecTech 补货单元"
	desc = "Officer Paul bought all the donuts? Then refill the security \
		vendor with this crate."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_SECURITY
	contains = list(/obj/item/vending_refill/security)
	crate_name = "\improper SecTech 补货单元"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/vending/snack
	name = "Snack 补货单元"
	desc = "One vending machine refill of cavity-bringin' goodness! \
		The number one dentist recommended order!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/snack)
	crate_name = "snacks 补货单元"

/datum/supply_pack/vending/cola
	name = "Softdrinks 补货单元"
	desc = "Got whacked by a toolbox, but you still have those pesky teeth? \
		Get rid of those pearly whites with this soda machine refill, today!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/cola)
	crate_name = "soft drinks 补货单元"

/datum/supply_pack/vending/vendomat
	name = "Part-Mart & YouTool 补货单元"
	desc = "More tools for your IED testing facility."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/assist,
					/obj/item/vending_refill/youtool,
				)
	crate_name = "\improper Part-Mart & YouTool 补货单元"

/datum/supply_pack/vending/clothesmate
	name = "ClothesMate 补货单元"
	desc = "Out of cowboy boots? Buy this crate."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/clothing)
	crate_name = "\improper ClothesMate 补货单元"


/// Clothing Vending Restocks

/datum/supply_pack/vending/wardrobes/autodrobe
	name = "Autodrobe 补货单元"
	desc = "Autodrobe missing your favorite dress? Solve that issue today \
		with this autodrobe refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/autodrobe)
	crate_name = "autodrobe 补货单元"

/datum/supply_pack/vending/wardrobes/cargo
	name = "Cargo Wardrobe 补货单元"
	desc = "This crate contains a refill for the CargoDrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/cargo_wardrobe)
	crate_name = "cargo department 补货单元"

/datum/supply_pack/vending/wardrobes/engineering
	name = "Engineering Wardrobe 补货单元"
	desc = "This crate contains refills for the EngiDrobe and AtmosDrobe."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/engi_wardrobe,
					/obj/item/vending_refill/wardrobe/atmos_wardrobe,
				)
	crate_name = "engineering department wardrobe 补货单元"

/datum/supply_pack/vending/wardrobes/general
	name = "General Wardrobes 补货单元"
	desc = "This crate contains refills for the CuraDrobe, BarDrobe, \
		ChefDrobe and ChapDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/curator_wardrobe,
					/obj/item/vending_refill/wardrobe/bar_wardrobe,
					/obj/item/vending_refill/wardrobe/chef_wardrobe,
					/obj/item/vending_refill/wardrobe/chap_wardrobe,
				)
	crate_name = "general wardrobes vendor refills"

/datum/supply_pack/vending/wardrobes/hydroponics
	name = "Hydrobe 补货单元"
	desc = "This crate contains a refill for the Hydrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/hydro_wardrobe)
	crate_name = "hydrobe 补货单元"

/datum/supply_pack/vending/wardrobes/janitor
	name = "JaniDrobe 补货单元"
	desc = "This crate contains a refill for the JaniDrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/jani_wardrobe)
	crate_name = "janidrobe 补货单元"

/datum/supply_pack/vending/wardrobes/medical
	name = "Medical Wardrobe 补货单元"
	desc = "This crate contains refills for the MediDrobe, \
		ChemDrobe, ViroDrobe, and MortiDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/medi_wardrobe,
					/obj/item/vending_refill/wardrobe/chem_wardrobe,
					/obj/item/vending_refill/wardrobe/viro_wardrobe,
					/obj/item/vending_refill/wardrobe/coroner_wardrobe,
				)
	crate_name = "medical department wardrobe 补货单元"

/datum/supply_pack/vending/wardrobes/science
	name = "Science Wardrobe 补货单元"
	desc = "This crate contains refills for the SciDrobe, \
		GeneDrobe, and RoboDrobe."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/vending_refill/wardrobe/robo_wardrobe,
					/obj/item/vending_refill/wardrobe/gene_wardrobe,
					/obj/item/vending_refill/wardrobe/science_wardrobe,
				)
	crate_name = "science department wardrobe 补货单元"

/datum/supply_pack/vending/wardrobes/security
	name = "Security Wardrobe 补货单元"
	desc = "This crate contains refills for the SecDrobe, \
		DetDrobe and LawDrobe."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/wardrobe/sec_wardrobe,
					/obj/item/vending_refill/wardrobe/det_wardrobe,
					/obj/item/vending_refill/wardrobe/law_wardrobe,
				)
	crate_name = "security department 补货单元"
