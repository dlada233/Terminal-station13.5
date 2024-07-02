/obj/item/bear_armor
	name = "熊堆甲"
	desc = "一堆杂乱的装甲碎块，显然是为一只熊量身打造的.有些还用管道胶带粘着,还有一个指甲锉，其中一块装甲板上用俄语潦草地写着一些说明.这……看起来不太靠谱."
	icon = 'icons/obj/tools.dmi'
	icon_state = "bear_armor_upgrade"

/obj/item/bear_armor/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /mob/living/basic/bear))
		return NONE
	var/mob/living/basic/bear/bear = interacting_with
	if(bear.armored)
		to_chat(user, span_warning("[bear] has already been armored up!"))
		return ITEM_INTERACT_BLOCKING
	bear.armored = TRUE
	bear.maxHealth += 60
	bear.health += 60
	bear.armour_penetration += 20
	bear.melee_damage_lower += 3
	bear.melee_damage_upper += 5
	bear.wound_bonus += 5
	bear.update_icons()
	to_chat(user, span_info("你将装甲板绑在[bear_target]身上，然后用指甲锉磨利这只熊的爪子，这可真是个好主意."))
	qdel(src)
	return ITEM_INTERACT_SUCCESS
