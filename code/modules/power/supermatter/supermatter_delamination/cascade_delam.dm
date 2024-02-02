/datum/sm_delam/cascade

/datum/sm_delam/cascade/can_select(obj/machinery/power/supermatter_crystal/sm)
	if(!sm.is_main_engine)
		return FALSE
	var/total_moles = sm.absorbed_gasmix.total_moles()
	if(total_moles < MOLE_PENALTY_THRESHOLD * sm.absorption_ratio)
		return FALSE
	for (var/gas_path in list(/datum/gas/antinoblium, /datum/gas/hypernoblium))
		var/percent = sm.gas_percentage[gas_path]
		if(!percent || percent < 0.4)
			return FALSE
	return TRUE

/datum/sm_delam/cascade/delam_progress(obj/machinery/power/supermatter_crystal/sm)
	if(!..())
		return FALSE

	sm.radio.talk_into(
		sm,
		"危险: 超结构振荡频率超标.",
		sm.damage >= sm.emergency_point ? sm.emergency_channel : sm.warning_channel
	)
	var/list/messages = list(
		"你周围的空间似乎在波动游移...",
		"你听到一个尖锐的声音.",
		"你感到背部有刺痛感.",
		"有些东西感觉很不对劲.",
		"一种被淹没的恐惧感席卷了你.",
	)
	for(var/mob/victim as anything in GLOB.player_list)
		to_chat(victim, span_danger(pick(messages)))

	return TRUE

/datum/sm_delam/cascade/on_select(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] is heading towards a cascade. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("is heading towards a cascade.", INVESTIGATE_ENGINE)

	sm.warp = new(sm)
	sm.vis_contents += sm.warp
	animate(sm.warp, time = 1, transform = matrix().Scale(0.5,0.5))
	animate(time = 9, transform = matrix())

	addtimer(CALLBACK(src, PROC_REF(announce_cascade), sm), 2 MINUTES)

/datum/sm_delam/cascade/on_deselect(obj/machinery/power/supermatter_crystal/sm)
	message_admins("[sm] will no longer cascade. [ADMIN_VERBOSEJMP(sm)]")
	sm.investigate_log("will no longer cascade.", INVESTIGATE_ENGINE)

	sm.vis_contents -= sm.warp
	QDEL_NULL(sm.warp)

/datum/sm_delam/cascade/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Supermatter [sm] at [ADMIN_VERBOSEJMP(sm)] triggered a cascade delam.")
	sm.investigate_log("triggered a cascade delam.", INVESTIGATE_ENGINE)

	effect_explosion(sm)
	effect_emergency_state()
	effect_cascade_demoralize()
	priority_announce("在你的区域发生了C型共振移位事件，扫描显示局部振荡通量影响了空间和重力子结构. \
		并形成了多个共振点，请注意防范.", "Nanotrasen观星协会", ANNOUNCER_SPANOMALIES)
	sleep(2 SECONDS)
	effect_strand_shuttle()
	sleep(5 SECONDS)
	var/obj/cascade_portal/rift = effect_evac_rift_start()
	RegisterSignal(rift, COMSIG_QDELETING, PROC_REF(end_round_holder))
	SSsupermatter_cascade.can_fire = TRUE
	SSsupermatter_cascade.cascade_initiated = TRUE
	effect_crystal_mass(sm, rift)
	return ..()

/datum/sm_delam/cascade/examine(obj/machinery/power/supermatter_crystal/sm)
	return list(span_bolddanger("晶体以极快的速度振动，扭曲了周围的空间!"))

/datum/sm_delam/cascade/overlays(obj/machinery/power/supermatter_crystal/sm)
	return list()

/datum/sm_delam/cascade/count_down_messages(obj/machinery/power/supermatter_crystal/sm)
	var/list/messages = list()
	messages += "晶体分层迫在眉睫. 超物质已面临临界完整性失效，超过谐波频率限制，诱发扰动场不能启用."
	messages += "晶体超结构恢复到安全运行界限，谐波频率恢复到紧急范围内，反谐振滤波器启动."
	messages += "在共振诱导稳定之前将保持."
	return messages

/datum/sm_delam/cascade/proc/announce_cascade(obj/machinery/power/supermatter_crystal/sm)
	if(QDELETED(sm))
		return FALSE
	if(!can_select(sm))
		return FALSE
	priority_announce("注意: 远程扫描显示[station_name()]内的一个对象产生了异常数量的谐波通量，可能会引发共振崩溃.",
	"Nanotrasen观星协会", 'sound/misc/airraid.ogg')
	return TRUE

/// Signal calls cant sleep, we gotta do this.
/datum/sm_delam/cascade/proc/end_round_holder()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(effect_evac_rift_end))
