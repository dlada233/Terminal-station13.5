/datum/supply_pack/engineering
	group = "工程用品"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/shieldgen
	name = "防破裂护罩投影仪"
	desc = "船体又破裂了？别说了，拿上这些纳米传讯防破裂护罩投影仪！\
		使用力场技术把空气留住而封闭空间，内含两台护盾投影仪."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/machinery/shieldgen = 2)
	crate_name = "防破裂护罩投影仪箱"

/datum/supply_pack/engineering/ripley
	name = "APLU MK-I 套件"
	desc = "一套让用户亲自动手组装 ALPU MK-I \"雷普利\" 的套件,\
		一种用于起重、装载重型工程设备和其他站点任务的机甲，不附赠电池."
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/mecha_parts/chassis/ripley,
					/obj/item/mecha_parts/part/ripley_torso,
					/obj/item/mecha_parts/part/ripley_right_arm,
					/obj/item/mecha_parts/part/ripley_left_arm,
					/obj/item/mecha_parts/part/ripley_right_leg,
					/obj/item/mecha_parts/part/ripley_left_leg,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/scanning_module,
					/obj/item/circuitboard/mecha/ripley/main,
					/obj/item/circuitboard/mecha/ripley/peripherals,
					/obj/item/mecha_parts/mecha_equipment/drill,
					/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp,
				)
	crate_name= "APLU MK-I 套件箱"
	crate_type = /obj/structure/closet/crate/science/robo

/datum/supply_pack/engineering/conveyor
	name = "传送带套件"
	desc = "内含三十条传送带以及控制拉杆.\
		如有任何问题，请阅读附赠的说明书."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/stack/conveyor/thirty,
					/obj/item/conveyor_switch_construct,
					/obj/item/paper/guides/conveyor,
				)
	crate_name = "传送带套件箱"

/datum/supply_pack/engineering/engiequipment
	name = "工程装备补给包"
	desc = "内含三条满载工具腰带、工作背心、焊接面罩、安全帽\
		和两副介子护目镜!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/item/storage/belt/utility = 3,
					/obj/item/clothing/suit/hazardvest = 3,
					/obj/item/clothing/head/utility/welding = 3,
					/obj/item/clothing/head/utility/hardhat = 3,
					/obj/item/clothing/glasses/meson/engine = 2,
				)
	crate_name = "工程装备箱"

/datum/supply_pack/engineering/powergamermitts
	name = "绝缘手套补给包"
	desc = "现代社会的支柱，几乎没有因实际工程用途订购过. \
		内含了三双绝缘手套."
	cost = CARGO_CRATE_VALUE * 8 //Made of pure-grade bullshittinium
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/clothing/gloves/color/yellow = 3)
	crate_name = "绝缘手套箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/inducers
	name = "NT-75 无线充电器补给包"
	desc = "没有充电器了? 没关系, 有了NT-75 EPI, 你在任何地方为任何规格的\
		电池设备充电, 内含两把无线充电器."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/inducer/orderable = 2)
	crate_name = "无线充电器箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/pacman
	name = "P.A.C.M.A.N.发电机"
	desc = "工程师们不能设置好引擎? 对你来说不是问题, 只要你掌握了\
		P.A.C.M.A.N.发电机! 吸收等离子体, 吐出甜美的电能."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/machinery/power/port_gen/pacman)
	crate_name = "PACMAN发电机箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/power
	name = "电池补给包"
	desc = "追求电力盈余? 不要再看了, 内含三块高压电池."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/stock_parts/cell/high = 3)
	crate_name = "电池箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/shuttle_engine
	name = "航天飞船引擎"
	desc = "得益于先进的蓝空技术, \
		我们的工程师成功地把整个航天飞船引擎装进了一个小箱子里."
	cost = CARGO_CRATE_VALUE * 6
	access = ACCESS_CE
	access_view = ACCESS_CE
	contains = list(/obj/machinery/power/shuttle_engine/propulsion/burst/cargo)
	crate_name = "航天飞船引擎箱"
	crate_type = /obj/structure/closet/crate/secure/engineering
	special = TRUE

/datum/supply_pack/engineering/tools
	name = "工具箱"
	desc = "任何强健的太空人都离不开他们可靠的工具箱.\
		内含三个电气工具箱和三个机械工具箱."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/storage/toolbox/electrical = 3,
					/obj/item/storage/toolbox/mechanical = 3,
				)
	cost = CARGO_CRATE_VALUE * 5
	crate_name = "工具箱补给箱"

/datum/supply_pack/engineering/portapump
	name = "便携气泵"
	desc = "又有人把船体的气放出去了吗? 我们可以帮到您, \
		内含两台便携气泵."
	cost = CARGO_CRATE_VALUE * 4.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/pump = 2)
	crate_name = "便携气泵补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos

/datum/supply_pack/engineering/portascrubber
	name = "便携虹吸器"
	desc = "用你自己的两台便携虹吸器清理讨厌的等离子泄露."
	cost = CARGO_CRATE_VALUE * 4.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/scrubber = 2)
	crate_name = "便携虹吸器补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos

/datum/supply_pack/engineering/hugescrubber
	name = "大型便携虹吸器"
	desc = "大型的虹吸器为大型的大气灾难."
	cost = CARGO_CRATE_VALUE * 7.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/scrubber/huge/movable/cargo)
	crate_name = "大型便携虹吸器补给箱"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/space_heater
	name = "太空加热器"
	desc = "一个双重用途的加热器/制冷机, 当问题太冷/太热时使用."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/space_heater)
	crate_name = "太空加热器补给箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos

/datum/supply_pack/engineering/bsa
	name = "Bluespace Artillery 蓝空巨炮组件"
	desc = "Nanotrasen海军指挥部的骄傲, \
		传说中的蓝空巨炮是人类工程学的一项惊天壮举, 也是全面战争的决心证明, \
		想要架设它需要高度先进的研究资料."
	cost = CARGO_CRATE_VALUE * 30
	special = TRUE
	access_view = ACCESS_COMMAND
	contains = list(/obj/item/paper/guides/jobs/engineering/bsa,
					/obj/item/circuitboard/machine/bsa/front,
					/obj/item/circuitboard/machine/bsa/middle,
					/obj/item/circuitboard/machine/bsa/back,
					/obj/item/circuitboard/computer/bsa_control,
				)
	crate_name= "蓝空大炮组件箱"

/datum/supply_pack/engineering/dna_vault
	name = "DNA Vault DNA库组件"
	desc = "在这个庞大的科学知识图书馆中, 蕴含着能够赋予人类长寿、超人能力的可能性, \
		想要架设它需要高度先进的研究资料. \
		随货附赠五个DNA库用提取器."
	cost = CARGO_CRATE_VALUE * 24
	special = TRUE
	access_view = ACCESS_COMMAND
	contains = list(/obj/item/circuitboard/machine/dna_vault,
					/obj/item/dna_probe = 5,
				)
	crate_name= "DNA库组件箱"

/datum/supply_pack/engineering/dna_probes
	name = "DNA库提取器"
	desc = "内含五个DNA库提取器."
	cost = CARGO_CRATE_VALUE * 6
	special = TRUE
	access_view = ACCESS_COMMAND
	contains = list(/obj/item/dna_probe = 5)
	crate_name= "DNA库提取器箱"


/datum/supply_pack/engineering/shield_sat
	name = "护盾生成卫星"
	desc = "用这些反陨石防御系统保护整个空间站安全, \
		内含三颗护盾生成卫星."
	cost = CARGO_CRATE_VALUE * 6
	special = TRUE
	access_view = ACCESS_COMMAND
	contains = list(/obj/machinery/satellite/meteor_shield = 3)
	crate_name= "护盾生成卫星箱"


/datum/supply_pack/engineering/shield_sat_control
	name = "护盾系统控制台"
	desc = "刻有护盾卫星控制系统的电路板."
	cost = CARGO_CRATE_VALUE * 10
	special = TRUE
	access_view = ACCESS_COMMAND
	contains = list(/obj/item/circuitboard/computer/sat_control)
	crate_name= "护盾系统控制台电路板箱"


/// Engine Construction

/datum/supply_pack/engine
	group = "工程建设"
	access_view = ACCESS_ENGINEERING
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engine/emitter
	name = "发射器"
	desc = "能在破坏板条箱锁和敌人的同时为力场投影仪提供能量.\
		内含两台高功率能量发生器."
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_CE
	contains = list(/obj/machinery/power/emitter = 2)
	crate_name = "发射器箱"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/field_gen
	name = "力场投影仪"
	desc = "挡在在毁灭与苟活之间的唯一屏障，\
		由发射器提供能量，内含两台力场投影仪."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/machinery/field/generator = 2)
	crate_name = "力场投影仪箱"

/datum/supply_pack/engine/grounding_rods
	name = "避雷针"
	desc = "四根接地避雷针用以承接特斯拉线圈的电击."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/machinery/power/energy_accumulator/grounding_rod = 4)
	crate_name = "避雷针箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/solar
	name = "太阳能板"
	desc = "用这堆先进太阳能板阵列来生产源源不断地清洁能源, \
		内含二十一台太阳能板、一个太阳能控制电路板和一个跟踪插件, \
		如有任何疑问，请翻阅所附说明书."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/solar_assembly = 21,
					/obj/item/circuitboard/computer/solar_control,
					/obj/item/electronics/tracker,
					/obj/item/paper/guides/jobs/engi/solars,
				)
	crate_name = "太阳能板箱"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/supermatter_shard
	name = "超物质碎片"
	desc = "天地的力量凝聚成一颗晶体."
	cost = CARGO_CRATE_VALUE * 20
	access = ACCESS_CE
	contains = list(/obj/machinery/power/supermatter_crystal/shard)
	crate_name = "超物质碎片箱"
	crate_type = /obj/structure/closet/crate/secure/radiation
	dangerous = TRUE
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/engine/tesla_coils
	name = "特斯拉线圈"
	desc = "无论是高压电刑，或者治疗网瘾，又或者只是第三次世界大战，\
		这四台特斯拉线圈都包您满意!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/obj/machinery/power/energy_accumulator/tesla_coil = 4)
	crate_name = "特斯拉线圈"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/hypertorus_fusion_reactor
	name = "HFR 组件"
	desc = "新的和改进的聚变反应堆."
	cost = CARGO_CRATE_VALUE * 23
	access = ACCESS_CE
	contains = list(/obj/item/hfr_box/corner = 4,
					/obj/item/hfr_box/body/fuel_input,
					/obj/item/hfr_box/body/moderator_input,
					/obj/item/hfr_box/body/waste_output,
					/obj/item/hfr_box/body/interface,
					/obj/item/hfr_box/core,
				)
	crate_name = "HFR 组件箱"
	crate_type = /obj/structure/closet/crate/secure/engineering/atmos
	dangerous = TRUE

/datum/supply_pack/engineering/rad_protection_modules
	name = "辐射防护模块"
	desc = "内含多个模块服用防辐射模块."
	hidden = TRUE
	contains = list(/obj/item/mod/module/rad_protection = 3)
	crate_name = "辐射防护模块"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/rad_nebula_shielding_kit
	name = "放射性星云屏蔽系统"
	desc = "内含用于构建放射性星云屏蔽系统的电路板和部件."
	cost = CARGO_CRATE_VALUE * 2

	special = TRUE
	contains = list(
		/obj/item/mod/module/rad_protection = 5,
		/obj/item/circuitboard/machine/radioactive_nebula_shielding = 5,
		/obj/item/paper/fluff/radiation_nebula = 1,
	)
	crate_name = "放射性星云屏蔽系统(重要)箱"
	crate_type = /obj/structure/closet/crate/engineering
