/// Open all of the doors
/datum/grand_finale/all_access
	name = "开门"
	desc = "倾泻汇聚至今的所有魔力！强制解锁他们的每一扇门！世上再无人会被拒门之外！"
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "knock"

/datum/grand_finale/all_access/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)]移除了所有气闸门的权限限制")
	for(var/obj/machinery/door/target_door as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(is_station_level(target_door.z))
			target_door.unlock()
			target_door.req_access = list()
			target_door.req_one_access = list()
			INVOKE_ASYNC(target_door, TYPE_PROC_REF(/obj/machinery/door/airlock, open))
			CHECK_TICK
	priority_announce("AULIE OXIN FIERA!!", null, 'sound/magic/knock.ogg', sender_override = "[invoker.real_name]", color_override = "purple")
