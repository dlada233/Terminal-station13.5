// Sidepaths for knowledge between Knock and Moon.

/datum/heretic_knowledge/spell/mind_gate
	name = "心灵之门"
	desc = "赐予你名为心灵之门的法术，\
		这个法术对你自己造成20点脑损伤，但会让目标产生幻觉、陷入10秒混乱、缺氧并造成脑损伤."
	gain_text = "我的心像门一样打开，它的洞察力将使我领悟真理."
	next_knowledge = list(
		/datum/heretic_knowledge/key_ring,
		/datum/heretic_knowledge/spell/moon_smile,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/mind_gate
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/unfathomable_curio
	name = "奇异珍品-Unfathomable curio"
	desc = "你可以将3根铁棒、肺和任何腰带嬗变成奇异珍品，\
			一条可以装载刀刃和仪式物品的腰带. \
			穿上它会遮蔽你，并为你抵挡5次攻击，\
			抵挡次数在战斗之外会缓慢恢复."
	gain_text = "漫宿内藏有许多珍品，是常人无法看到的"
	next_knowledge = list(
		/datum/heretic_knowledge/spell/burglar_finesse,
		/datum/heretic_knowledge/moon_amulet,
	)
	required_atoms = list(
		/obj/item/organ/internal/lungs = 1,
		/obj/item/stack/rods = 3,
		/obj/item/storage/belt = 1,
	)
	result_atoms = list(/obj/item/storage/belt/unfathomable_curio)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/painting
	name = "非封闭性艺术-Painting"
	desc = "你可以将一张画布和一个特定的物品嬗变成一件艺术品，有不同的艺术画作可供创造，取决于你采用什么样的特定物品. 以下是配方: \
			《姐妹与流泪的他》（需要眼睛）：清晰你自己的思维，让不信之人产生幻觉. \
			《第一大欲》（需要任意身体部位）: 为你提供随机的器官，让不信之人对肉体产生渴望. \
			《山丘上的密林》（需要任意农作物）: 为你提供风信子和罂粟，被不信之人检查时会传播葛藤. \
			《门外的女士》（需要手套）: 清除你的突变，让不信之人突变并使其发痒. \
			《爬过锈山》（需要垃圾）: 诅咒不信之人，让他们走过的地面生锈. \
			不信之人可以通过检查这些画作来抵消大多数效果."
	gain_text = "灵感之风吹拂而过，越过墙壁与大门，无形之物想要再被描绘，被凡人之眼所欣赏，而我将为它们实现这个愿望."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/burglar_finesse,
		/datum/heretic_knowledge/moon_amulet,
	)
	required_atoms = list(/obj/item/canvas = 1)
	result_atoms = list(/obj/item/canvas)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/painting/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(locate(/obj/item/organ/internal/eyes) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/weeping)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/organ/internal/eyes = 1,
		)
		return TRUE

	if(locate(/obj/item/bodypart) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/desire)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/bodypart = 1,
		)
		return TRUE

	if(locate(/obj/item/food/grown) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/vines)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/food/grown = 1,
		)
		return TRUE

	if(locate(/obj/item/clothing/gloves) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/beauty)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/clothing/gloves = 1,
		)
		return TRUE

	if(locate(/obj/item/trash) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/rust)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/trash = 1,
		)
		return TRUE

	user.balloon_alert(user, "no additional atom present!")
	return FALSE
