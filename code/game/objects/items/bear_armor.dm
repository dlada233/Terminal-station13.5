/obj/item/bear_armor
	name = "熊堆甲"
	desc = "一堆杂乱的装甲碎块，显然是为一只熊量身打造的.有些还用管道胶带粘着,还有一个指甲锉，其中一块装甲板上用俄语潦草地写着一些说明.这……看起来不太靠谱."
	icon = 'icons/obj/tools.dmi'
	icon_state = "bear_armor_upgrade"

/obj/item/bear_armor/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	if(!istype(target, /mob/living/basic/bear))
		return
	var/mob/living/basic/bear/bear_target = target
	if(bear_target.armored)
		to_chat(user, span_warning("[bear_target]已经穿着装备了!"))
		return
	bear_target.armored = TRUE
	bear_target.maxHealth += 60
	bear_target.health += 60
	bear_target.armour_penetration += 20
	bear_target.melee_damage_lower += 3
	bear_target.melee_damage_upper += 5
	bear_target.wound_bonus += 5
	bear_target.update_icons()
	to_chat(user, span_info("你将装甲板绑在[bear_target]身上，然后用指甲锉磨利[bear_target.p_their()]的爪子.这可真是个好主意."))
	qdel(src)
