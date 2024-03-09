GLOBAL_LIST_INIT(abductor_gear, subtypesof(/datum/abductor_gear))

#define CATEGORY_BASIC_GEAR "基本装备"
#define CATEGORY_ADVANCED_GEAR "先进装备"
#define CATEGORY_MISC_GEAR "杂项"

/datum/abductor_gear
	/// Name of the gear
	var/name = "Generic Abductor Gear"
	/// Description of the gear
	var/description = "Generic description."
	/// Unique ID of the gear
	var/id = "abductor_generic"
	/// Credit cost of the gear
	var/cost = 1
	/// Build path of the gear itself
	var/build_path = null
	/// Category of the gear
	var/category = CATEGORY_BASIC_GEAR

/datum/abductor_gear/agent_helmet
	name = "特工头盔"
	description = "以尖刺风格进行绑架，阻碍电子追踪手段."
	id = "agent_helmet"
	build_path = list(/obj/item/clothing/head/helmet/abductor = 1)

/datum/abductor_gear/agent_vest
	name = "特工背心"
	description = "一件装载了先进隐形技术的背心，可在战斗与隐身两种模式间切换."
	id = "agent_vest"
	build_path = list(/obj/item/clothing/suit/armor/abductor/vest = 1)

/datum/abductor_gear/radio_silencer
	name = "无线电静默仪"
	description = "用于关闭无线电通讯设备的小型装置."
	id = "radio_silencer"
	build_path = list(/obj/item/abductor/silencer = 1)

/datum/abductor_gear/science_tool
	name = "科研工具"
	description = "用于检索样本和扫描外观的双模式工具，扫描行动可以通过摄像头完成."
	id = "science_tool"
	build_path = list(/obj/item/abductor/gizmo = 1)

/datum/abductor_gear/advanced_baton
	name = "先进电棍"
	description = "一把四模式的电棍，用于使样本丧失行动能力并加以束缚."
	id = "advanced_baton"
	cost = 2
	build_path = list(/obj/item/melee/baton/abductor = 1)

/datum/abductor_gear/superlingual_matrix
	name = "超语言矩阵"
	description = "一个神秘的结构，可以让用户之间进行即时通讯，拿在手里使用它会将其调谐到你的母舰频道上，直到你需要吃东西为止都十分有效."
	id = "superlingual_matrix"
	build_path = list(/obj/item/organ/internal/tongue/abductor = 1)
	category = CATEGORY_MISC_GEAR

/datum/abductor_gear/mental_interface
	name = "心灵接口仪"
	description = "一种可以直接与有知觉的大脑交流的双模式工具. 可用于向目标发送脑内消息，\
			或向带有未耗尽次数的腺体的测试对象发送命令."
	id = "mental_interface"
	cost = 2
	build_path = list(/obj/item/abductor/mind_device = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/reagent_synthesizer
	name = "试剂合成器"
	description = "利用原始物质合成多种试剂." // proto-matter
	id = "reagent_synthesizer"
	cost = 2
	build_path = list(/obj/item/abductor_machine_beacon/chem_dispenser = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/shrink_ray
	name = "缩小射线炮"
	description = "这是一项可怕的外星技术，通过增加局部空间中原子的磁力，暂时使物体缩小. \
			或者只是太空魔法，不管怎么样，它就是缩小了."
	id = "shrink_ray"
	cost = 2
	build_path = list(/obj/item/gun/energy/shrink_ray = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/omnitool
	name = "外星全能工具"
	description = "一款集成了大量功能的手持工具，能满足医疗和骇入等各种需求. \
				右键在医用和骇入两个工具集间切换."
	id = "omnitool"
	cost = 2
	build_path = list(/obj/item/abductor/alien_omnitool = 1)
	category = CATEGORY_ADVANCED_GEAR

/datum/abductor_gear/cow
	name = "备用奶牛"
	description = "在曾经的劫持行动中剩下的样本."
	id = "cow"
	build_path = list(/mob/living/basic/cow = 1, /obj/item/food/grown/wheat = 3)
	category = CATEGORY_MISC_GEAR

/datum/abductor_gear/posters
	name = "装饰海报"
	description = "一些海报，用来装饰母舰(甚至是空间站)的墙壁。"
	id = "poster"
	build_path = list(/obj/item/poster/random_abductor = 2)
	category = CATEGORY_MISC_GEAR

#undef CATEGORY_BASIC_GEAR
#undef CATEGORY_ADVANCED_GEAR
#undef CATEGORY_MISC_GEAR
