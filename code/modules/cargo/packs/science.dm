/datum/supply_pack/science
	group = "科研用品"
	access_view = ACCESS_RESEARCH
	crate_type = /obj/structure/closet/crate/science

/datum/supply_pack/science/plasma
	name = "等离子组装包"
	desc = "所有把东西烧成灰所需的东西, \
		三罐等离子气瓶，三个点火器，三个距离传感器以及\
		三个计时器."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/tank/internals/plasma = 3,
					/obj/item/assembly/igniter = 3,
					/obj/item/assembly/prox_sensor = 3,
					/obj/item/assembly/timer = 3,
				)
	crate_name = "等离子组装包"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/science/raw_flux_anomaly
	name = "原始通量异常"
	desc = "内含原始通量异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/flux)
	crate_name = "原始通量异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_hallucination_anomaly
	name = "原始幻觉异常"
	desc = "内含原始幻觉异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/hallucination)
	crate_name = "原始幻觉异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_grav_anomaly
	name = "原始重力异常"
	desc = "内含原始通量异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/grav)
	crate_name = "原始重力异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_vortex_anomaly
	name = "原始涡流异常"
	desc = "内含原始涡流异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/vortex)
	crate_name = "原始涡流异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_bluespace_anomaly
	name = "原始蓝空异常"
	desc = "内含原始蓝空异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/bluespace)
	crate_name = "原始蓝空异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_pyro_anomaly
	name = "原始火焰异常"
	desc = "内含原始火焰异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/pyro)
	crate_name = "原始火焰异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_bioscrambler_anomaly
	name = "原始生物扰频异常"
	desc = "内含原始生物扰频异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/bioscrambler)
	crate_name = "原始生物扰频异常"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_dimensional_anomaly
	name = "原始维度异常"
	desc = "内含原始维度异常，可以被加工成威力强大的人造体."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/dimensional)
	crate_name = "原始维度异常"
	crate_type = /obj/structure/closet/crate/secure/science


/datum/supply_pack/science/robotics
	name = "机器人配装包"
	desc = "用忠诚的机器人军队取代那些挑剔的人类! \
		包含四个距离传感器，两个空急救箱，两个红色安全帽，\
		两个机械工具箱和两个清洁机器人组件!"
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/assembly/prox_sensor = 5,
					/obj/item/healthanalyzer = 2,
					/obj/item/clothing/head/utility/hardhat/red = 2,
					/obj/item/storage/medkit = 2)
	crate_name = "机器人配装箱"
	crate_type = /obj/structure/closet/crate/secure/science/robo

/datum/supply_pack/science/rped
	name = "RPED快捷零件替换机"
	desc = "需要重建ORM但一切已经在一次炸弹实验后被摧毁了? \
		购买此物是NT能给你最好的补偿."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/part_replacer/cargo)
	crate_name = "RPED箱"

/datum/supply_pack/science/shieldwalls
	name = "护盾投影仪"
	desc = "这些高功率的护盾投影仪可以阻挡各种生命形式，\
		一次购买有四台投影仪."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_TELEPORTER
	access_view = ACCESS_TELEPORTER
	contains = list(/obj/machinery/power/shieldwallgen = 4)
	crate_name = "护盾投影仪箱"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/transfer_valves
	name = "气罐转移阀"
	desc = "让全空间站火热起来的关键道具.\
		内含两台."
	cost = CARGO_CRATE_VALUE * 12
	access = ACCESS_RD
	contains = list(/obj/item/transfer_valve = 2)
	crate_name = "气罐转移阀箱"
	crate_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/science/monkey_helmets
	name = "猴子心灵增幅器"
	desc = "有些时候猴子比人更好用，\
		但它们智商太低，不懂得如何操作精密仪器，所以你需要让它们带上这个."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/monkey_sentience = 2)
	crate_name = "猴子心灵增幅器箱"

/datum/supply_pack/science/cytology
	name = "细胞学用品包"
	desc = "失控的研究对象摧毁了实验室? \
		这里有全套的重建用品, \
		包含一个显微镜，活检工具，两个培养皿，一盒拭子和一个管道工具."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_XENOBIOLOGY
	contains = list(/obj/structure/microscope,
					/obj/item/biopsy_tool,
					/obj/item/storage/box/petridish = 2,
					/obj/item/storage/box/swab,
					/obj/item/construction/plumbing/research,
				)
	crate_name = "细胞学用品箱"

/datum/supply_pack/science/mod_core
	name = "模块核心"
	desc = "模块核心是用于组装模块服的必要零件，一次购买获得三个模块核心."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/mod/core/standard = 3)
	crate_name = "\improper 模块核心箱"
	crate_type = /obj/structure/closet/crate/secure/science/robo
