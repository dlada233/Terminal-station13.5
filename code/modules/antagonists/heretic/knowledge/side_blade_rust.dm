// Sidepaths for knowledge between Rust and Blade.
/datum/heretic_knowledge/armor
	name = "锻甲的仪式"
	desc = "允许你将一张桌子和一副防毒面具嬗变成一套邪术盔甲. \
		邪术盔甲能提供优越的防护性，在戴上兜帽时还会提供焦点."
	gain_text = "锈山慷慨地欢迎铁匠，铁匠慷慨地回报锈山."
	next_knowledge = list(
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/blade_dance,
	)
	required_atoms = list(
		/obj/structure/table = 1,
		/obj/item/clothing/mask/gas = 1,
	)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/eldritch)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/crucible
	name = "喰食坩埚"
	desc = "你可以将一个水箱和一张桌子嬗变成喰食坩埚. \
		喰食坩埚可以用来酿造强大的药水，但在多次使用之间必须投喂身体部位."
	gain_text = "无法召唤贵族的身影为我带来了纯粹的苦楚.\
		但在祭司的关注下，我偶然发现了一份不同的配方..."
	next_knowledge = list(
		/datum/heretic_knowledge/duel_stance,
		/datum/heretic_knowledge/spell/area_conversion,
	)
	required_atoms = list(
		/obj/structure/reagent_dispensers/watertank = 1,
		/obj/structure/table = 1,
	)
	result_atoms = list(/obj/structure/destructible/eldritch_crucible)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/rifle
	name = "猎狮人的步枪"
	desc = "你可以将任意比如管道枪的弹道武器、任意兽皮、照相机和一块木板来嬗变出猎狮人的步枪. \
		猎狮人的步枪弹容量三发，可以正常射击. 但要注意子弹伤害将会随着射击距离而变化，距离越远，伤害越高."
	gain_text = "我在古董店遇到一位老人，挥舞着一把不同寻常的武器. \
		虽然我当时买不起，但他们曾经为我展示过如何制作它."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/realignment,
		/datum/heretic_knowledge/spell/rust_construction,
		/datum/heretic_knowledge/rifle_ammo,
	)
	required_atoms = list(
		/obj/item/gun/ballistic = 1,
		/obj/item/stack/sheet/animalhide = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/camera = 1,
	)
	result_atoms = list(/obj/item/gun/ballistic/rifle/lionhunter)
	cost = 1
	route = PATH_SIDE

/datum/heretic_knowledge/rifle_ammo
	name = "猎狮人的步枪子弹 (免费)"
	desc = "你可以将包括霰弹枪在内的任意三颗子弹或弹壳与任意兽皮嬗变成一条猎狮人的步枪弹夹."
	gain_text = "这把武器发射三颗粗铁球，致命且迅速.但我很快就打光了这些无可替代的弹药. \
		这把枪想要的东西很特别."
	required_atoms = list(
		/obj/item/stack/sheet/animalhide = 1,
		/obj/item/ammo_casing = 3,
	)
	result_atoms = list(/obj/item/ammo_box/strilka310/lionhunter)
	cost = 0
	route = PATH_SIDE
	/// A list of calibers that the ritual will deny. Only ballistic calibers are allowed.
	var/static/list/caliber_blacklist = list(
		CALIBER_LASER,
		CALIBER_ENERGY,
		CALIBER_FOAM,
		CALIBER_ARROW,
		CALIBER_HARPOON,
		CALIBER_HOOK,
	)

/datum/heretic_knowledge/rifle_ammo/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	for(var/obj/item/ammo_casing/casing in atoms)
		if(!(casing.caliber in caliber_blacklist))
			continue

		// Remove any casings in the caliber_blacklist list from atoms
		atoms -= casing

	// We removed any invalid casings from the atoms list,
	// return to allow the ritual to fill out selected atoms with the new list
	return TRUE

/datum/heretic_knowledge/spell/rust_charge
	name = "锈能冲锋"
	desc = "冲锋必须在生锈的地块上开始，伤害并锈蚀冲锋范围内的东西，若接触到生锈物体还会直接将其摧毁."
	gain_text = "山开始闪烁不定，思绪随着接近终点而开始游荡. 但我很快恢复了继续前进的决斗，最后的路途将愈加凶险."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/furious_steel,
		/datum/heretic_knowledge/spell/entropic_plume,
	)
	spell_to_add = /datum/action/cooldown/mob_cooldown/charge/rust
	cost = 1
	route = PATH_SIDE
