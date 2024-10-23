/datum/supply_pack/medical
	group = "医疗用品"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical/department

/datum/supply_pack/medical/bloodpacks
	name = "血袋补给包"
	desc = "内含十种不同血型的血袋."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/reagent_containers/blood = 2,
					/obj/item/reagent_containers/blood/a_plus,
					/obj/item/reagent_containers/blood/a_minus,
					/obj/item/reagent_containers/blood/b_plus,
					/obj/item/reagent_containers/blood/b_minus,
					/obj/item/reagent_containers/blood/o_plus,
					/obj/item/reagent_containers/blood/o_minus,
					/obj/item/reagent_containers/blood/lizard,
					/obj/item/reagent_containers/blood/ethereal,
				)
	crate_name = "血袋冷藏箱"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/medipen_variety
	name = "医用注射笔包"
	desc = "内含三种医用注射笔，总共八种药物，\
		用于抢救生命危重的患者."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/reagent_containers/hypospray/medipen = 2,
					/obj/item/reagent_containers/hypospray/medipen/ekit = 3,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss = 3)
	crate_name = "医用注射笔箱"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/coroner_crate
	name = "解剖工具包"
	desc = "内含一个解剖扫描仪，\
		当你弄丢了你自己的,又非常需要进行解剖时."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(
		/obj/item/autopsy_scanner = 1,
		/obj/item/storage/medkit/coroner = 1,
	)
	crate_name = "解剖工具箱"

/datum/supply_pack/medical/chemical
	name = "化学入门套件"
	desc = "包含十三种不同的化学物质，做你想做的所有化学实验."
	cost = CARGO_CRATE_VALUE * 2.6
	contains = list(/obj/item/reagent_containers/cup/bottle/hydrogen,
					/obj/item/reagent_containers/cup/bottle/carbon,
					/obj/item/reagent_containers/cup/bottle/nitrogen,
					/obj/item/reagent_containers/cup/bottle/oxygen,
					/obj/item/reagent_containers/cup/bottle/fluorine,
					/obj/item/reagent_containers/cup/bottle/phosphorus,
					/obj/item/reagent_containers/cup/bottle/silicon,
					/obj/item/reagent_containers/cup/bottle/chlorine,
					/obj/item/reagent_containers/cup/bottle/radium,
					/obj/item/reagent_containers/cup/bottle/sacid,
					/obj/item/reagent_containers/cup/bottle/ethanol,
					/obj/item/reagent_containers/cup/bottle/potassium,
					/obj/item/reagent_containers/cup/bottle/sugar,
					/obj/item/clothing/glasses/science,
					/obj/item/reagent_containers/dropper,
					/obj/item/storage/box/beakers,
				)
	crate_name = "化学材料箱"

/datum/supply_pack/medical/defibs
	name = "除颤器补给包"
	desc = "两台给人起死回生的除颤器."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/defibrillator/loaded = 2)
	crate_name = "除颤器箱"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/iv_drip
	name = "静脉输液架"
	desc = "内含输液架两台."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/iv_drip)
	crate_name = "静脉输液架箱"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/supplies
	name = "医疗用品包"
	desc = "内含各种随机医疗用品，不包含一个训练有素的医生."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/reagent_containers/cup/bottle/multiver,
					/obj/item/reagent_containers/cup/bottle/epinephrine,
					/obj/item/reagent_containers/cup/bottle/morphine,
					/obj/item/reagent_containers/cup/bottle/toxin,
					/obj/item/reagent_containers/cup/beaker/large,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/stack/medical/gauze,
					/obj/item/storage/box/bandages,
					/obj/item/storage/box/beakers,
					/obj/item/storage/box/medigels,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/medkit/regular,
					/obj/item/storage/medkit/o2,
					/obj/item/storage/medkit/toxin,
					/obj/item/storage/medkit/brute,
					/obj/item/storage/medkit/fire,
					/obj/item/defibrillator/loaded,
					/obj/item/reagent_containers/blood/o_minus,
					/obj/item/storage/pill_bottle/mining,
					/obj/item/reagent_containers/pill/neurine,
					/obj/item/stack/medical/bone_gel = 2,
					/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs,
				)
	crate_name = "医疗用品箱"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/supplies/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/medical/experimentalmedicine
	name = "实验药物包"
	desc = "装有治疗多种遗传性疾病所需药物的箱子.Sansufentanyl-三舒芬太尼."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/pill_bottle/sansufentanyl = 2)
	crate_name = "实验药物箱"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/surgery
	name = "手术用品包"
	desc = "你立志成为一名外科医生，但苦于没有花里胡哨的学位？\
		那就从这个箱子开始你的梦想！内含DeForest 手术托盘, \
		消毒喷雾和可折叠滚轮床."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/surgery_tray/full,
		/obj/item/reagent_containers/medigel/sterilizine,
		/obj/item/emergency_bed,
	)
	crate_name = "手术用品箱"

/datum/supply_pack/medical/salglucanister
	name = "大型生理盐水储罐"
	desc = "含有大量的葡萄糖-盐水溶液，能用好几天的液体罐，配有一个大型泵用于填充容器，\
		不要直接用泵对着患者灌，\
		可能导致患者用药过量."
	cost = CARGO_CRATE_VALUE * 6
	access = ACCESS_MEDICAL
	contains = list(/obj/machinery/iv_drip/saline)
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/medical/virus
	name = "病毒学用品包"
	desc = "内含十二瓶不同的病毒样本，用于病毒学研究，\
		附带七个烧杯和注射器."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_CMO
	access_view = ACCESS_VIROLOGY
	contains = list(/obj/item/reagent_containers/cup/bottle/flu_virion,
					/obj/item/reagent_containers/cup/bottle/cold,
					/obj/item/reagent_containers/cup/bottle/random_virus = 4,
					/obj/item/reagent_containers/cup/bottle/fake_gbs,
					/obj/item/reagent_containers/cup/bottle/magnitis,
					/obj/item/reagent_containers/cup/bottle/pierrot_throat,
					/obj/item/reagent_containers/cup/bottle/brainrot,
					/obj/item/reagent_containers/cup/bottle/anxiety,
					/obj/item/reagent_containers/cup/bottle/beesease,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/cup/bottle/mutagen,
				)
	crate_name = "病毒学用品箱"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/medical/cmoturtlenecks
	name = "CMO高领毛衣包"
	desc = "内含CMO的高领毛衣和高领毛衣裙."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_CMO
	contains = list(/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck,
					/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt,
				)

/datum/supply_pack/medical/arm_implants
	name = "强化臂植入物"
	desc = "装有两个强化臂植入物的箱子，可以通过手术植入来增强人类手臂的力量.暴露于电磁脉冲后保修作废."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/organ/internal/cyberimp/arm/muscle = 2)
	crate_name = "强化臂 植入物"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
