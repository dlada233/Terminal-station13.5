#define DEFAULT_DOOMSDAY_TIMER 4500
#define DOOMSDAY_ANNOUNCE_INTERVAL 600

#define VENDOR_TIPPING_USES 8
#define MALF_VENDOR_TIPPING_TIME 0.5 SECONDS //within human reaction time
#define MALF_VENDOR_TIPPING_CRIT_CHANCE 100 //percent - guaranteed

#define MALF_AI_ROLL_TIME 0.5 SECONDS
#define MALF_AI_ROLL_COOLDOWN 1 SECONDS + MALF_AI_ROLL_TIME
#define MALF_AI_ROLL_DAMAGE 75
#define MALF_AI_ROLL_CRIT_CHANCE 5 //percent

GLOBAL_LIST_INIT(blacklisted_malf_machines, typecacheof(list(
		/obj/machinery/field/containment,
		/obj/machinery/power/supermatter_crystal,
		/obj/machinery/gravity_generator,
		/obj/machinery/doomsday_device,
		/obj/machinery/nuclearbomb,
		/obj/machinery/nuclearbomb/selfdestruct,
		/obj/machinery/nuclearbomb/syndicate,
		/obj/machinery/syndicatebomb,
		/obj/machinery/syndicatebomb/badmin,
		/obj/machinery/syndicatebomb/badmin/clown,
		/obj/machinery/syndicatebomb/empty,
		/obj/machinery/syndicatebomb/self_destruct,
		/obj/machinery/syndicatebomb/training,
		/obj/machinery/atmospherics/pipe/layer_manifold,
		/obj/machinery/atmospherics/pipe/multiz,
		/obj/machinery/atmospherics/pipe/smart,
		/obj/machinery/atmospherics/pipe/smart/manifold, //mapped one
		/obj/machinery/atmospherics/pipe/smart/manifold4w, //mapped one
		/obj/machinery/atmospherics/pipe/color_adapter,
		/obj/machinery/atmospherics/pipe/bridge_pipe,
		/obj/machinery/atmospherics/pipe/heat_exchanging/simple,
		/obj/machinery/atmospherics/pipe/heat_exchanging/junction,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w,
		/obj/machinery/atmospherics/components/tank,
		/obj/machinery/atmospherics/components/unary/portables_connector,
		/obj/machinery/atmospherics/components/unary/passive_vent,
		/obj/machinery/atmospherics/components/unary/heat_exchanger,
		/obj/machinery/atmospherics/components/unary/hypertorus/core,
		/obj/machinery/atmospherics/components/unary/hypertorus/waste_output,
		/obj/machinery/atmospherics/components/unary/hypertorus/moderator_input,
		/obj/machinery/atmospherics/components/unary/hypertorus/fuel_input,
		/obj/machinery/hypertorus/interface,
		/obj/machinery/hypertorus/corner,
		/obj/machinery/atmospherics/components/binary/valve,
		/obj/machinery/portable_atmospherics/canister,
	)))

GLOBAL_LIST_INIT(malf_modules, subtypesof(/datum/ai_module))

/// The malf AI action subtype. All malf actions are subtypes of this.
/datum/action/innate/ai
	name = "AI行动"
	desc = "你不确定这是做什么的，但非常的哔哔滋滋."
	background_icon_state = "bg_tech_blue"
	overlay_icon_state = "bg_tech_blue_border"
	button_icon = 'icons/mob/actions/actions_AI.dmi'
	/// The owner AI, so we don't have to typecast every time
	var/mob/living/silicon/ai/owner_AI
	/// If we have multiple uses of the same power
	var/uses
	/// If we automatically use up uses on each activation
	var/auto_use_uses = TRUE
	/// If applicable, the time in deciseconds we have to wait before using any more modules
	var/cooldown_period

/datum/action/innate/ai/Grant(mob/living/player)
	. = ..()
	if(!isAI(owner))
		WARNING("AI行为[name]试图授予自身给非AImob[key_name(player)]!")
		qdel(src)
	else
		owner_AI = owner

/datum/action/innate/ai/IsAvailable(feedback = FALSE)
	. = ..()
	if(owner_AI && owner_AI.malf_cooldown > world.time)
		return

/datum/action/innate/ai/Trigger(trigger_flags)
	. = ..()
	if(auto_use_uses)
		adjust_uses(-1)
	if(cooldown_period)
		owner_AI.malf_cooldown = world.time + cooldown_period

/datum/action/innate/ai/proc/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("[name]还剩余<b>[uses]</b>次使用次数."))
	if(uses <= 0)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("[name]使用次数耗尽!"))
		qdel(src)

/// Framework for ranged abilities that can have different effects by left-clicking stuff.
/datum/action/innate/ai/ranged
	name = "远程AI行动"
	auto_use_uses = FALSE //This is so we can do the thing and disable/enable freely without having to constantly add uses
	click_action = TRUE

/datum/action/innate/ai/ranged/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("[name]还剩余<b>[uses]</b>次使用次数."))
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("[name]使用次数耗尽!"))
		Remove(owner)
		QDEL_IN(src, 10 SECONDS) //let any active timers on us finish up

/// The base module type, which holds info about each ability.
/datum/ai_module
	var/name = "通用模块"
	var/category = "通用类目"
	var/description = "通用描述"
	var/cost = 5
	/// If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/one_purchase = FALSE
	/// If the module gives an active ability, use this. Mutually exclusive with upgrade.
	var/power_type = /datum/action/innate/ai
	/// If the module gives a passive upgrade, use this. Mutually exclusive with power_type.
	var/upgrade = FALSE
	/// Text shown when an ability is unlocked
	var/unlock_text = span_notice("Hello World!")
	/// Sound played when an ability is unlocked
	var/unlock_sound

/// Applies upgrades
/datum/ai_module/proc/upgrade(mob/living/silicon/ai/AI)
	return

/// Modules causing destruction
/datum/ai_module/destructive
	category = "破坏性模块"

/// Modules with stealthy and utility uses
/datum/ai_module/utility
	category = "工具性模块"

/// Modules that are improving AI abilities and assets
/datum/ai_module/upgrade
	category = "升级模块"

/// Doomsday Device: Starts the self-destruct timer. It can only be stopped by killing the AI completely.
/datum/ai_module/destructive/nuke_station
	name = "末日装置"
	description = "激活一种能消灭空间站上所有有机生命的武器，需要450秒来获得控制. \
		只能在空间站上使用，若你的核心被移出空间站或被摧毁，武器将失效. \
		如果能控制部长办公室的APC，获取该武器的控制将容易许多."
	cost = 130
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/nuke_station
	unlock_text = span_notice("你小心翼翼地与站内的自毁装置建立连接，你现在可以随时激活它.")
	///List of areas that grant discounts. "heads_quarters" will match any head of staff office.
	var/list/discount_areas = list(
		/area/station/command/heads_quarters,
		/area/station/ai_monitored/command/nuke_storage
	)
	///List of hacked head of staff office areas. Includes the vault too. Provides a 20 PT discount per (Min 50 PT cost)
	var/list/hacked_command_areas = list()

/datum/action/innate/ai/nuke_station
	name = "末日装置"
	desc = "激活末日装置，该操作不可撤销."
	button_icon_state = "doomsday_device"
	auto_use_uses = FALSE

/datum/action/innate/ai/nuke_station/Activate()
	var/turf/T = get_turf(owner)
	if(!istype(T) || !is_station_level(T.z))
		to_chat(owner, span_warning("你无法在离开空间站时激活末日装置."))
		return
	if(tgui_alert(owner, "发送启动信号? (true = 启动, false = 取消)", "purge_all_life()", list("confirm = TRUE;", "confirm = FALSE;")) != "confirm = TRUE;")
		return
	if (active || owner_AI.stat == DEAD)
		return //prevent the AI from activating an already active doomsday or while they are dead
	if (!isturf(owner_AI.loc))
		return //prevent AI from activating doomsday while shunted or carded, fucking abusers
	active = TRUE
	set_up_us_the_bomb(owner)

/datum/action/innate/ai/nuke_station/proc/set_up_us_the_bomb(mob/living/owner)
	set waitfor = FALSE
	message_admins("[key_name_admin(owner)][ADMIN_FLW(owner)]启动了AI末日装置.")
	var/pass = prob(10) ? "******" : "hunter2"
	to_chat(owner, "<span class='small boldannounce'>运行 -o -a '自毁'</span>")
	sleep(0.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small boldannounce'>运行 可执行文件 '自毁'...</span>")
	sleep(rand(10, 30))
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	owner.playsound_local(owner, 'sound/misc/bloblarm.ogg', 50, 0, use_reverb = FALSE)
	to_chat(owner, span_userdanger("!!! 未经授权的自毁装置访问 !!!"))
	to_chat(owner, span_boldannounce("这是3级安保违规. 该事件将上报中央指挥部."))
	for(var/i in 1 to 3)
		sleep(2 SECONDS)
		if(QDELETED(owner) || !isturf(owner_AI.loc))
			active = FALSE
			return
		to_chat(owner, span_boldannounce("发送安保报告至中央指挥部.....[rand(0, 9) + (rand(20, 30) * i)]%"))
	sleep(0.3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small boldannounce'>未经经经 'akjv9c88asdf12nb' [pass]</span>")
	owner.playsound_local(owner, 'sound/items/timer.ogg', 50, 0, use_reverb = FALSE)
	sleep(3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("认证通过. 欢迎，akjv9c88asdf12nb."))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(0.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("启动自毁装置? (Y/N)"))
	owner.playsound_local(owner, 'sound/misc/compiler-stage1.ogg', 50, 0, use_reverb = FALSE)
	sleep(2 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small boldannounce'>Y</span>")
	sleep(1.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("确认启动自毁装置? (Y/N)"))
	owner.playsound_local(owner, 'sound/misc/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(1 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small boldannounce'>Y</span>")
	sleep(rand(15, 25))
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("请重复密码确认."))
	owner.playsound_local(owner, 'sound/misc/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(1.4 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small boldannounce'>[pass]</span>")
	sleep(4 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("认证通过. 发送启动信号..."))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	if (owner_AI.stat != DEAD)
		priority_announce("全空间站系统内检测到敌对运行数据，请停用你的AI以防止其道德核心进一步损坏.", "异常警报", ANNOUNCER_AIMALF)
		SSsecurity_level.set_level(SEC_LEVEL_DELTA)
		var/obj/machinery/doomsday_device/DOOM = new(owner_AI)
		owner_AI.nuking = TRUE
		owner_AI.doomsday_device = DOOM
		owner_AI.doomsday_device.start()
		for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
			P.switch_mode_to(TRACK_MALF_AI) //Pinpointers start tracking the AI wherever it goes

		notify_ghosts(
			"[owner_AI]启动了末日装置!",
			source = owner_AI,
			header = "DOOOOOOM!!!",
		)

		qdel(src)

/obj/machinery/doomsday_device
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	name = "末日装置"
	icon_state = "nuclearbomb_base"
	desc = "一种大规模分解有机生命的武器."
	density = TRUE
	verb_exclaim = "blares"
	use_power = NO_POWER_USE
	var/timing = FALSE
	var/obj/effect/countdown/doomsday/countdown
	var/detonation_timer
	var/next_announce
	var/mob/living/silicon/ai/owner

/obj/machinery/doomsday_device/Initialize(mapload)
	. = ..()
	if(!isAI(loc))
		stack_trace("Doomsday created outside an AI somehow, shit's fucking broke. Anyway, we're just gonna qdel now. Go make a github issue report.")
		return INITIALIZE_HINT_QDEL
	owner = loc
	countdown = new(src)

/obj/machinery/doomsday_device/Destroy()
	timing = FALSE
	QDEL_NULL(countdown)
	STOP_PROCESSING(SSfastprocess, src)
	SSshuttle.clearHostileEnvironment(src)
	SSmapping.remove_nuke_threat(src)
	SSsecurity_level.set_level(SEC_LEVEL_RED)
	for(var/mob/living/silicon/robot/borg in owner?.connected_robots)
		borg.lamp_doom = FALSE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update
	owner?.doomsday_device = null
	owner?.nuking = null
	owner = null
	for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
		P.switch_mode_to(TRACK_NUKE_DISK) //Party's over, back to work, everyone
		P.alert = FALSE
	return ..()

/obj/machinery/doomsday_device/proc/start()
	detonation_timer = world.time + DEFAULT_DOOMSDAY_TIMER
	next_announce = world.time + DOOMSDAY_ANNOUNCE_INTERVAL
	timing = TRUE
	countdown.start()
	START_PROCESSING(SSfastprocess, src)
	SSshuttle.registerHostileEnvironment(src)
	SSmapping.add_nuke_threat(src) //This causes all blue "circuit" tiles on the map to change to animated red icon state.
	for(var/mob/living/silicon/robot/borg in owner.connected_robots)
		borg.lamp_doom = TRUE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update

/obj/machinery/doomsday_device/proc/seconds_remaining()
	. = max(0, (round((detonation_timer - world.time) / 10)))

/obj/machinery/doomsday_device/process()
	var/turf/T = get_turf(src)
	if(!T || !is_station_level(T.z))
		minor_announce("末日装置离开空间站范围，正在中止", "错误 错误 $錯wu$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		owner.ShutOffDoomsdayDevice()
		return
	if(!timing)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/sec_left = seconds_remaining()
	if(!sec_left)
		timing = FALSE
		sound_to_playing_players('sound/machines/alarm.ogg')
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(play_cinematic), /datum/cinematic/malf, world, CALLBACK(src, PROC_REF(trigger_doomsday))), 10 SECONDS)

	else if(world.time >= next_announce)
		minor_announce("距离末日装置启动还有[sec_left]秒!", "错误 错误 $錯wu$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		next_announce += DOOMSDAY_ANNOUNCE_INTERVAL

/obj/machinery/doomsday_device/proc/trigger_doomsday()
	callback_on_everyone_on_z(SSmapping.levels_by_trait(ZTRAIT_STATION), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bring_doomsday)), src)
	to_chat(world, span_bold("AI用[src]清除了空间站的生命!"))
	SSticker.force_ending = FORCE_END_ROUND

/proc/bring_doomsday(mob/living/victim, atom/source)
	if(issilicon(victim))
		return FALSE

	to_chat(victim, span_userdanger("来自[source]的冲击波将你从原子层面分解!"))
	victim.investigate_log("被末日装置分解.", INVESTIGATE_DEATHS)
	victim.dust()
	return TRUE

/// Hostile Station Lockdown: Locks, bolts, and electrifies every airlock on the station. After 90 seconds, the doors reset.
/datum/ai_module/destructive/lockdown
	name = "敌对空间站封锁"
	description = "超载气闸门，防爆门和防火闸，将它们全部闭锁. \
		注意! 该指令也使所有气闸门通电. 门控系统网络将在90秒后重置，短暂地打开站点所有的门."
	cost = 30
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/lockdown
	unlock_text = span_notice("你将潜伏木马上传到门控系统，你可以随时发送信号来启动该木马.")
	unlock_sound = 'sound/machines/boltsdown.ogg'

/datum/action/innate/ai/lockdown
	name = "封锁"
	desc = "关闭、锁定并通电每一扇气闸门、防爆门和防火闸，持续90秒后自动重置."
	button_icon_state = "lockdown"
	uses = 1
	/// Badmin / exploit abuse prevention.
	/// Check tick may sleep in activate() and we don't want this to be spammable.
	var/hack_in_progress  = FALSE

/datum/action/innate/ai/lockdown/IsAvailable(feedback)
	return ..() && !hack_in_progress

/datum/action/innate/ai/lockdown/Activate()
	hack_in_progress = TRUE
	for(var/obj/machinery/door/locked_down as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(QDELETED(locked_down) || !is_station_level(locked_down.z))
			continue
		INVOKE_ASYNC(locked_down, TYPE_PROC_REF(/obj/machinery/door, hostile_lockdown), owner)
		CHECK_TICK

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_malf_ai_undo_lockdown)), 90 SECONDS)

	var/obj/machinery/computer/communications/random_comms_console = locate() in GLOB.shuttle_caller_list
	random_comms_console?.post_status("警报", "锁定")

	minor_announce("在门控系统中检测到敌对运行. 隔离封锁协议已生效，请保持冷静.", "网络警报:", TRUE)
	to_chat(owner, span_danger("封锁完成，90秒后网络重置."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce),
		"系统自动重启完成，祝您今天愉快.",
		"网络重置:"), 90 SECONDS)
	hack_in_progress = FALSE

/// For Lockdown malf AI ability. Opens all doors on the station.
/proc/_malf_ai_undo_lockdown()
	for(var/obj/machinery/door/locked_down as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(QDELETED(locked_down) || !is_station_level(locked_down.z))
			continue
		INVOKE_ASYNC(locked_down, TYPE_PROC_REF(/obj/machinery/door, disable_lockdown))
		CHECK_TICK

/// Override Machine: Allows the AI to override a machine, animating it into an angry, living version of itself.
/datum/ai_module/destructive/override_machine
	name = "机器超驰"
	description = "超驰一台机器的程序，让它攻击除机器外的所有人. 购买后可使用4次"
	cost = 30
	power_type = /datum/action/innate/ai/ranged/override_machine
	unlock_text = span_notice("你从太空暗网获取了一种病毒，然后分发给了空间站的机器.")
	unlock_sound = 'sound/machines/airlock_alien_prying.ogg'

/datum/action/innate/ai/ranged/override_machine
	name = "超驰机器"
	desc = "激活目标机器，使其攻击附近所有人."
	button_icon_state = "override_machine"
	uses = 4
	ranged_mousepointer = 'icons/effects/mouse_pointers/override_machine_target.dmi'
	enable_text = span_notice("你接入了空间站的电力网络，点击一台机器使其暴走.")
	disable_text = span_notice("你解除了对电力网络的控制.")

/datum/action/innate/ai/ranged/override_machine/New()
	. = ..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/ranged/override_machine/do_ability(mob/living/caller, atom/clicked_on)
	if(caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE
	if(!ismachinery(clicked_on))
		to_chat(caller, span_warning("你能让机器暴走!"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on
	if(!clicked_machine.can_be_overridden() || is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(caller, span_warning("这台机器无法超驰!"))
		return FALSE

	caller.playsound_local(caller, 'sound/misc/interference.ogg', 50, FALSE, use_reverb = FALSE)

	clicked_machine.audible_message(span_userdanger("[clicked_machine]发出嗡嗡声!"))
	addtimer(CALLBACK(src, PROC_REF(animate_machine), caller, clicked_machine), 5 SECONDS) //kabeep!
	unset_ranged_ability(caller, span_danger("发送超驰信号..."))
	adjust_uses(-1) //adjust after we unset the active ability since we may run out of charges, thus deleting the ability

	if(uses)
		desc = "[initial(desc)] 剩余[uses]次使用次数."
		build_all_button_icons()
	return TRUE

/datum/action/innate/ai/ranged/override_machine/proc/animate_machine(mob/living/caller, obj/machinery/to_animate)
	if(QDELETED(to_animate))
		return

	new /mob/living/simple_animal/hostile/mimic/copy/machine(get_turf(to_animate), to_animate, caller, TRUE)

/// Destroy RCDs: Detonates all non-cyborg RCDs on the station.
/datum/ai_module/destructive/destroy_rcd
	name = "销毁RCD"
	description = "发送一束特殊脉冲来引爆空间站上所有的非赛博RCD(快捷建造工具)."
	cost = 25
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/destroy_rcds
	unlock_text = span_notice("经过临时改装，你的无线电能够发送一束信号引爆所有的RCD.")
	unlock_sound = 'sound/items/timer.ogg'

/datum/action/innate/ai/destroy_rcds
	name = "销毁RCD"
	desc = "引爆空间站上所有的非赛博RCD."
	button_icon_state = "detonate_rcds"
	uses = 1
	cooldown_period = 10 SECONDS

/datum/action/innate/ai/destroy_rcds/Activate()
	for(var/I in GLOB.rcd_list)
		if(!istype(I, /obj/item/construction/rcd/borg)) //Ensures that cyborg RCDs are spared.
			var/obj/item/construction/rcd/RCD = I
			RCD.detonate_pulse()
	to_chat(owner, span_danger("RCD引爆脉冲已发射."))
	owner.playsound_local(owner, 'sound/machines/twobeep.ogg', 50, 0)

/// Overload Machine: Allows the AI to overload a machine, detonating it after a delay. Two uses per purchase.
/datum/ai_module/destructive/overload_machine
	name = "机器过载"
	description = "使机器电机过热，摧毁自身引发小型爆炸. 购买后可使用2次"
	cost = 20
	power_type = /datum/action/innate/ai/ranged/overload_machine
	unlock_text = span_notice("你能让空间站的APC将过量电力直输至指定机器内.")
	unlock_sound = 'sound/effects/comfyfire.ogg' //definitely not comfy, but it's the closest sound to "roaring fire" we have

/datum/action/innate/ai/ranged/overload_machine
	name = "过载机器"
	desc = "使机器过热，短时间后引起小型爆炸."
	button_icon_state = "overload_machine"
	uses = 2
	ranged_mousepointer = 'icons/effects/mouse_pointers/overload_machine_target.dmi'
	enable_text = span_notice("你接入了空间站电力网络，点击一个机器将其引爆.")
	disable_text = span_notice("你解除了对电力网络的控制.")

/datum/action/innate/ai/ranged/overload_machine/New()
	..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/ranged/overload_machine/proc/detonate_machine(mob/living/caller, obj/machinery/to_explode)
	if(QDELETED(to_explode))
		return

	var/turf/machine_turf = get_turf(to_explode)
	message_admins("[ADMIN_LOOKUPFLW(caller)] 过载了 [to_explode.name] ([to_explode.type]) 在 [ADMIN_VERBOSEJMP(machine_turf)].")
	caller.log_message("过载了 [to_explode.name] ([to_explode.type])", LOG_ATTACK)
	explosion(to_explode, heavy_impact_range = 2, light_impact_range = 3)
	if(!QDELETED(to_explode)) //to check if the explosion killed it before we try to delete it
		qdel(to_explode)

/datum/action/innate/ai/ranged/overload_machine/do_ability(mob/living/caller, atom/clicked_on)
	if(caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE
	if(!ismachinery(clicked_on))
		to_chat(caller, span_warning("你只能让机器过载!"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on
	if(is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(caller, span_warning("这台设备无法过载!"))
		return FALSE

	caller.playsound_local(caller, SFX_SPARKS, 50, 0)
	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 剩余[uses]次使用次数."
		build_all_button_icons()

	clicked_machine.audible_message(span_userdanger("[clicked_machine]传出剧烈的嗡嗡声!"))
	addtimer(CALLBACK(src, PROC_REF(detonate_machine), caller, clicked_machine), 5 SECONDS) //kaboom!
	unset_ranged_ability(caller, span_danger("过载机器..."))
	return TRUE

/// Blackout: Overloads a random number of lights across the station. Three uses.
/datum/ai_module/destructive/blackout
	name = "灭灯"
	description = "尝试让空间站的照明电路过载，损坏一些灯泡. 购买后可使用3次."
	cost = 15
	power_type = /datum/action/innate/ai/blackout
	unlock_text = span_notice("你连接到电力网络，将过量的电力输送到空间站的照明电路上.")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/blackout
	name = "灭灯"
	desc = "随机过载空间站的照明."
	button_icon_state = "blackout"
	uses = 3
	auto_use_uses = FALSE

/datum/action/innate/ai/blackout/New()
	..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/blackout/Activate()
	for(var/obj/machinery/power/apc/apc as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
		if(prob(30 * apc.overload))
			apc.overload_lighting()
		else
			apc.overload++
	to_chat(owner, span_notice("输送过量电流至电力网络."))
	owner.playsound_local(owner, SFX_SPARKS, 50, 0)
	adjust_uses(-1)
	if(QDELETED(src) || uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		return
	desc = "[initial(desc)] 剩余[uses]次使用次数."
	build_all_button_icons()

/// HIGH IMPACT HONKING
/datum/ai_module/destructive/megahonk
	name = "对讲机高亢噪音"
	description = "用对讲机发出一种对听觉造成巨大干扰的高亢噪音，但无法穿透听觉防护设备. 购买后可使用2次."
	cost = 20
	power_type = /datum/action/innate/ai/honk
	unlock_text = span_notice("你将险恶的声音文件上传到每台对讲机中...")
	unlock_sound = 'sound/items/airhorn.ogg'

/datum/action/innate/ai/honk
	name = "对讲机高亢噪音"
	desc = "通过对讲机用刺耳的HONK声震撼整个空间站!"
	button_icon_state = "intercom"
	uses = 2

/datum/action/innate/ai/honk/Activate()
	to_chat(owner, span_clown("对讲机系统播放你准备好的文件."))
	for(var/obj/item/radio/intercom/found_intercom as anything in GLOB.intercoms_list)
		if(!found_intercom.is_on() || !found_intercom.get_listening() || found_intercom.wires.is_cut(WIRE_RX)) //Only operating intercoms play the honk
			continue
		found_intercom.audible_message(message = "[found_intercom]噼里啪啦响了一会.", hearing_distance = 3)
		playsound(found_intercom, 'sound/items/airhorn.ogg', 100, TRUE)
		for(var/mob/living/carbon/honk_victim in ohearers(6, found_intercom))
			var/turf/victim_turf = get_turf(honk_victim)
			if(isspaceturf(victim_turf) && !victim_turf.Adjacent(found_intercom)) //Prevents getting honked in space
				continue
			if(honk_victim.soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 30, deafen_pwr = 60)) //Ear protection will prevent these effects
				honk_victim.set_jitter_if_lower(120 SECONDS)
				to_chat(honk_victim, span_clown("HOOOOONK!"))

/// Robotic Factory: Places a large machine that converts humans that go through it into cyborgs. Unlocking this ability removes shunting.
/datum/ai_module/utility/place_cyborg_transformer
	name = "机器人工厂 (移除‘分流’能力)"
	description = "可以在任意地方用珍贵的纳米机器人建造一台机器，它会缓慢地为你生产忠诚的赛博." // Skyrat edit
	cost = 100
	power_type = /datum/action/innate/ai/place_transformer
	unlock_text = span_notice("你与太空亚马逊公司取得联系，下单了一台机器人工厂.")
	unlock_sound = 'sound/machines/ping.ogg'

/datum/action/innate/ai/place_transformer
	name = "放置机器人工厂"
	desc = "放置一台能高效制造赛博的机器. 附赠传送带." // Skyrat edit
	button_icon_state = "robotic_factory"
	uses = 1
	auto_use_uses = FALSE //So we can attempt multiple times
	var/list/turfOverlays

/datum/action/innate/ai/place_transformer/New()
	..()
	for(var/i in 1 to 3)
		var/image/I = image("icon" = 'icons/turf/overlays.dmi')
		LAZYADD(turfOverlays, I)

/datum/action/innate/ai/place_transformer/Activate()
	if(!owner_AI.can_place_transformer(src))
		return
	active = TRUE
	if(tgui_alert(owner, "确定要将机器放置到这里吗?", "确定?", list("Yes", "No")) == "No")
		active = FALSE
		return
	if(!owner_AI.can_place_transformer(src))
		active = FALSE
		return
	var/turf/T = get_turf(owner_AI.eyeobj)
	var/obj/machinery/transformer_rp/conveyor = new(T) //SKYRAT EDIT CHANGE - SILLICONQOL - ORIGINAL: var/obj/machinery/transformer/conveyor = new(T)
	conveyor.master_ai = owner
	playsound(T, 'sound/effects/phasein.ogg', 100, TRUE)
	if(owner_AI.can_shunt) //prevent repeated messages
		owner_AI.can_shunt = FALSE
		to_chat(owner, span_warning("你不能再把你的核心转移到APC上了."))
	adjust_uses(-1)
	active = FALSE

/mob/living/silicon/ai/proc/remove_transformer_image(client/C, image/I, turf/T)
	if(C && I.loc == T)
		C.images -= I

/mob/living/silicon/ai/proc/can_place_transformer(datum/action/innate/ai/place_transformer/action)
	if(!eyeobj || !isturf(loc) || incapacitated() || !action)
		return
	var/turf/middle = get_turf(eyeobj)
	var/list/turfs = list(middle, locate(middle.x - 1, middle.y, middle.z), locate(middle.x + 1, middle.y, middle.z))
	var/alert_msg = "空间不足!确保你的机器放在一个干净的区域范围和地板上."
	var/success = TRUE
	for(var/n in 1 to 3) //We have to do this instead of iterating normally because of how overlay images are handled
		var/turf/T = turfs[n]
		if(!isfloorturf(T))
			success = FALSE
		var/datum/camerachunk/C = GLOB.cameranet.getCameraChunk(T.x, T.y, T.z)
		if(!C.visibleTurfs[T])
			alert_msg = "你没有这个位置的摄像头视野!"
			success = FALSE
		for(var/atom/movable/AM in T.contents)
			if(AM.density)
				alert_msg = "该范围内不得有任何物品!"
				success = FALSE
		var/image/I = action.turfOverlays[n]
		I.loc = T
		client.images += I
		I.icon_state = "[success ? "green" : "red"]Overlay" //greenOverlay and redOverlay for success and failure respectively
		addtimer(CALLBACK(src, PROC_REF(remove_transformer_image), client, I, T), 30)
	if(!success)
		to_chat(src, span_warning("[alert_msg]"))
	return success

/// Air Alarm Safety Override: Unlocks the ability to enable dangerous modes on all air alarms.
/datum/ai_module/utility/break_air_alarms
	name = "空气警报超驰"
	description = "关闭所有空气警报的安全装置，这将允许你使用极端危险环境模式. \
			任何人都可以通过检查空气警报面板来发现它的正常功能失灵."
	one_purchase = TRUE
	cost = 50
	power_type = /datum/action/innate/ai/break_air_alarms
	unlock_text = span_notice("你解除了所有空气警报的安全保险，你可以随时按下‘是’来确认...you bastard.")
	unlock_sound = 'sound/effects/space_wind.ogg'

/datum/action/innate/ai/break_air_alarms
	name = "超驰空气警报"
	desc = "在所有空气警报上启用极端危险设置."
	button_icon_state = "break_air_alarms"
	uses = 1

/datum/action/innate/ai/break_air_alarms/Activate()
	for(var/obj/machinery/airalarm/AA in GLOB.air_alarms)
		if(!is_station_level(AA.z))
			continue
		AA.obj_flags |= EMAGGED
	to_chat(owner, span_notice("空间站内所有的空气警报安全装置都已失效，在上面可以启用极端危险环境模式."))
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, 0)

/// Thermal Sensor Override: Unlocks the ability to disable all fire alarms from doing their job.
/datum/ai_module/utility/break_fire_alarms
	name = "热感应器超驰"
	description = "让你控制所有火灾报警器上的热感应器，使其无法再感应火焰，从而无法触发警报."
	one_purchase = TRUE
	cost = 25
	power_type = /datum/action/innate/ai/break_fire_alarms
	unlock_text = span_notice("你可以用手动控制取代所有的火灾报警器的热感应功能，允许你随意开关它们.")
	unlock_sound = 'sound/machines/FireAlarm1.ogg'

/datum/action/innate/ai/break_fire_alarms
	name = "超驰热感应器"
	desc = "禁用所有的火灾报警器的自动热感应，使警报无效化."
	button_icon_state = "break_fire_alarms"
	uses = 1

/datum/action/innate/ai/break_fire_alarms/Activate()
	for(var/obj/machinery/firealarm/bellman as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/firealarm))
		if(!is_station_level(bellman.z))
			continue
		bellman.obj_flags |= EMAGGED
		bellman.update_appearance()
	for(var/obj/machinery/door/firedoor/firelock as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/firedoor))
		if(!is_station_level(firelock.z))
			continue
		firelock.emag_act(owner_AI, src)
	to_chat(owner, span_notice("空间站上所有的热感应器都被关闭了，火灾警报将无法被触发."))
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, 0)

/// Disable Emergency Lights
/datum/ai_module/utility/emergency_lights
	name = "关闭应急照明"
	description = "切断整个空间站的应急灯光，如果停止照明供电，则照明系统不会启用应急电力."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/emergency_lights
	unlock_text = span_notice("你接入电网，找到了通用照明和备用照明之间的连接线路.")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/emergency_lights
	name = "关闭应急照明"
	desc = "关闭所有的应急照明，请注意，应急照明可以通过重启APC来恢复."
	button_icon_state = "emergency_lights"
	uses = 1

/datum/action/innate/ai/emergency_lights/Activate()
	for(var/obj/machinery/light/L as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(is_station_level(L.z))
			L.no_low_power = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light/, update), FALSE)
		CHECK_TICK
	to_chat(owner, span_notice("应急照明连接线路被切断."))
	owner.playsound_local(owner, 'sound/effects/light_flicker.ogg', 50, FALSE)

/// Reactivate Camera Network: Reactivates up to 30 cameras across the station.
/datum/ai_module/utility/reactivate_cameras
	name = "重新激活摄像头网络"
	description = "在摄像头网络上运行全网诊断，重置焦点并将电力重新路由到故障摄像头. \
		可以用来修理多达30台摄像头."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/reactivate_cameras
	unlock_text = span_notice("你将纳米机器部署至摄像头网络上.")
	unlock_sound = 'sound/items/wirecutter.ogg'

/datum/action/innate/ai/reactivate_cameras
	name = "重新激活摄像头"
	desc = "重新激活整个空间站的故障摄像头. 有多次使用次数."
	button_icon_state = "reactivate_cameras"
	uses = 30
	auto_use_uses = FALSE
	cooldown_period = 30

/datum/action/innate/ai/reactivate_cameras/New()
	..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/reactivate_cameras/Activate()
	var/fixed_cameras = 0
	for(var/obj/machinery/camera/C as anything in GLOB.cameranet.cameras)
		if(!uses)
			break
		if(!C.status || C.view_range != initial(C.view_range))
			C.toggle_cam(owner_AI, 0) //Reactivates the camera based on status. Badly named proc.
			C.view_range = initial(C.view_range)
			fixed_cameras++
			uses-- //Not adjust_uses() so it doesn't automatically delete or show a message
	to_chat(owner, span_notice("诊断完成!摄像头重新激活: <b>[fixed_cameras]</b>. 重新激活次数剩余: <b>[uses]</b>."))
	owner.playsound_local(owner, 'sound/items/wirecutter.ogg', 50, 0)
	adjust_uses(0, TRUE) //Checks the uses remaining
	if(QDELETED(src) || !uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		return
	desc = "[initial(desc)] 剩余[uses]次使用次数."
	build_all_button_icons()

/// Upgrade Camera Network: EMP-proofs all cameras, in addition to giving them X-ray vision.
/datum/ai_module/upgrade/upgrade_cameras
	name = "升级摄像头网络"
	description = "为摄像头网络安装光谱扫描和冗余电器固件，使其具备光放大性X射线视觉功能与抗电磁脉冲功能. 购买后立刻完成升级." //I <3 pointless technobabble
	//This used to have motion sensing as well, but testing quickly revealed that giving it to the whole cameranet is PURE HORROR.
	cost = 35 //Decent price for omniscience!
	upgrade = TRUE
	unlock_text = span_notice("OTA固件分配完成! 摄像头已升级: CAMSUPGRADED.光放大系统上线.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/upgrade_cameras/upgrade(mob/living/silicon/ai/AI)
	// Sets up nightvision
	RegisterSignal(AI, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(on_update_sight))
	AI.update_sight()

	var/upgraded_cameras = 0
	for(var/obj/machinery/camera/camera as anything in GLOB.cameranet.cameras)
		var/obj/structure/camera_assembly/assembly = camera.assembly_ref?.resolve()
		if(!assembly)
			continue

		var/upgraded = FALSE

		if(!camera.isXRay())
			camera.upgradeXRay(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_xray_firmware_active and clean up isxray()
			//Update what it can see.
			GLOB.cameranet.updateVisibility(camera, 0)
			upgraded = TRUE

		if(!camera.isEmpProof())
			camera.upgradeEmpProof(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_emp_firmware_active and clean up isemp()
			upgraded = TRUE

		if(upgraded)
			upgraded_cameras++
	unlock_text = replacetext(unlock_text, "CAMSUPGRADED", "<b>[upgraded_cameras]</b>") //This works, since unlock text is called after upgrade()

/datum/ai_module/upgrade/upgrade_cameras/proc/on_update_sight(mob/source)
	SIGNAL_HANDLER
	// Dim blue, pretty
	source.lighting_color_cutoffs = blend_cutoff_colors(source.lighting_color_cutoffs, list(5, 25, 35))

/// AI Turret Upgrade: Increases the health and damage of all turrets.
/datum/ai_module/upgrade/upgrade_turrets
	name = "AI炮塔升级"
	description = "永久提高所有AI炮塔的功率与生命值，购买后立刻完成升级."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("你建立了一条电力支路到你的炮塔，提高了它们的生命值和伤害.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/upgrade_turrets/upgrade(mob/living/silicon/ai/AI)
	for(var/obj/machinery/porta_turret/ai/turret as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/porta_turret/ai))
		turret.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES | EMP_PROTECT_CONTENTS)
		turret.max_integrity = 200
		turret.repair_damage(200)
		turret.lethal_projectile = /obj/projectile/beam/laser/heavylaser //Once you see it, you will know what it means to FEAR.
		turret.lethal_projectile_sound = 'sound/weapons/lasercannonfire.ogg'

/// Enhanced Surveillance: Enables AI to hear conversations going on near its active vision.
/datum/ai_module/upgrade/eavesdrop
	name = "强化监视"
	description = "通过隐藏式麦克风和唇读软件的配合，你可以用你的摄像头来偷听谈话. 购买后立刻完成升级."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("OTA固件分配完成! 摄像头升级: 强化监视包上线.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/ai_module/upgrade/eavesdrop/upgrade(mob/living/silicon/ai/AI)
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE

/// Unlock Mech Domination: Unlocks the ability to dominate mechs. Big shocker, right?
/datum/ai_module/upgrade/mecha_domination
	name = "解锁机甲控制"
	description = "让你可以黑进机甲的内部电脑，将所有的程序分流进去，然后还把里面的人赶出去. \
		不要让机甲离开空间站范围，也不要让其被摧毁. 购买后立刻完成升级."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("病毒包编译完成. 随时可以选择一个机甲作为目标. <b>你必须一直待在空间站内，丢失信号将导致整个系统关闭.</b>")
	unlock_sound = 'sound/mecha/nominal.ogg'

/datum/ai_module/upgrade/mecha_domination/upgrade(mob/living/silicon/ai/AI)
	AI.can_dominate_mechs = TRUE //Yep. This is all it does. Honk!

/datum/ai_module/upgrade/voice_changer
	name = "变声器"
	description = "允许你改变AI的声音. 购买后立刻完成升级."
	cost = 40
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/voice_changer
	unlock_text = span_notice("OTA固件分配完成! 变声器上线.")
	unlock_sound = 'sound/items/rped.ogg'

/datum/action/innate/ai/voice_changer
	name="变声器"
	button_icon_state = "voice_changer"
	desc = "允许你改变AI的声音."
	auto_use_uses  = FALSE
	var/obj/machinery/ai_voicechanger/voice_changer_machine

/datum/action/innate/ai/voice_changer/Activate()
	if(!voice_changer_machine)
		voice_changer_machine = new(owner_AI)
	voice_changer_machine.ui_interact(usr)

/obj/machinery/ai_voicechanger
	name = "变声器"
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"
	/// The AI this voicechanger belongs to
	var/mob/living/silicon/ai/owner
	/// Whether this AI is speaking loudly (bigger text)
	var/loudvoice = FALSE
	// Verb used when voicechanger is on
	var/say_verb
	/// Name used when voicechanger is on
	var/say_name
	/// Span used when voicechanger is on
	var/say_span
	/// TRUE if the AI is changing its voice
	var/changing_voice = FALSE
	/// Saved loudvoice state, used to restore after a voice change
	var/prev_loud
	/// Saved verb state, used to restore after a voice change
	var/prev_verbs
	/// Saved span state, used to restore after a voice change
	var/prev_span

/obj/machinery/ai_voicechanger/Initialize(mapload)
	. = ..()
	if(!isAI(loc))
		return INITIALIZE_HINT_QDEL
	owner = loc
	owner.ai_voicechanger = src
	prev_verbs = list("say" = owner.verb_say, "ask" = owner.verb_ask, "exclaim" = owner.verb_exclaim , "yell" = owner.verb_yell  )
	prev_span = owner.speech_span
	say_name = owner.name
	say_verb = owner.verb_say
	say_span = owner.speech_span

/obj/machinery/ai_voicechanger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiVoiceChanger")
		ui.open()

/obj/machinery/ai_voicechanger/Destroy()
	if(owner)
		owner.ai_voicechanger = null
		owner = null
	return ..()

/obj/machinery/ai_voicechanger/ui_data(mob/user)
	var/list/data = list()
	data["voices"] = list("normal", SPAN_ROBOT, SPAN_YELL, SPAN_CLOWN) //manually adding this since i dont see other option
	data["loud"] = loudvoice
	data["on"] = changing_voice
	data["say_verb"] = say_verb
	data["name"] = say_name
	return data

/obj/machinery/ai_voicechanger/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			changing_voice = !changing_voice
			if(changing_voice)
				prev_verbs["say"] = owner.verb_say
				owner.verb_say	= say_verb
				prev_verbs["ask"] = owner.verb_ask
				owner.verb_ask	= say_verb
				prev_verbs["exclaim"] = owner.verb_exclaim
				owner.verb_exclaim	= say_verb
				prev_verbs["yell"] = owner.verb_yell
				owner.verb_yell	= say_verb
				prev_span = owner.speech_span
				owner.speech_span = say_span
				prev_loud = owner.radio.use_command
				owner.radio.use_command = loudvoice
			else
				owner.verb_say	= prev_verbs["say"]
				owner.verb_ask	= prev_verbs["ask"]
				owner.verb_exclaim	= prev_verbs["exclaim"]
				owner.verb_yell	= prev_verbs["yell"]
				owner.speech_span = prev_span
				owner.radio.use_command = prev_loud
		if("loud")
			loudvoice = !loudvoice
			if(changing_voice)
				owner.radio.use_command = loudvoice
		if("look")
			say_span = params["look"]
			if(changing_voice)
				owner.speech_span = say_span
		if("verb")
			say_verb = params["verb"]
			if(changing_voice)
				owner.verb_say = say_verb
				owner.verb_ask = say_verb
				owner.verb_exclaim = say_verb
				owner.verb_yell = say_verb
		if("name")
			say_name = params["name"]

/datum/ai_module/utility/emag
	name = "定向超驰"
	description = "让你可以EMAG你能访问的任何机器."
	cost = 20
	power_type = /datum/action/innate/ai/ranged/emag
	unlock_text = span_notice("你从辛迪加数据库泄露中下载到了一个非法软件包，并将其集成到固件中，在此过程中你还抵御了几次对内核的入侵.")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/ranged/emag
	name = "定向超驰"
	desc = "让你能有效的EMAG你点击的任何东西."
	button_icon = 'icons/obj/card.dmi'
	button_icon_state = "emag"
	uses = 7
	auto_use_uses = FALSE
	enable_text = span_notice("你将辛迪加软件包加载到最近的内存中.")
	disable_text = span_notice("你卸载了辛迪加软件包.")
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/innate/ai/ranged/emag/Destroy()
	return ..()

/datum/action/innate/ai/ranged/emag/New()
	. = ..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/ranged/emag/do_ability(mob/living/caller, atom/clicked_on)

	// Only things with of or subtyped of any of these types may be remotely emagged
	var/static/list/compatable_typepaths = list(
		/obj/machinery,
		/obj/structure,
		/obj/item/radio/intercom,
		/obj/item/modular_computer,
		/mob/living/simple_animal/bot,
		/mob/living/silicon,
	)

	if (!isAI(caller))
		return FALSE

	var/mob/living/silicon/ai/ai_caller = caller

	if(ai_caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE

	if (!ai_caller.can_see(clicked_on))
		clicked_on.balloon_alert(ai_caller, "没有视野!")
		return FALSE

	if (ismachinery(clicked_on))
		var/obj/machinery/clicked_machine = clicked_on
		if (!clicked_machine.is_operational)
			clicked_machine.balloon_alert(ai_caller, "不可操作!")
			return FALSE

	if (!(is_type_in_list(clicked_on, compatable_typepaths)))
		clicked_on.balloon_alert(ai_caller, "不兼容!")
		return FALSE

	if (istype(clicked_on, /obj/machinery/door/airlock)) // I HATE THIS CODE SO MUCHHH
		var/obj/machinery/door/airlock/clicked_airlock = clicked_on
		if (!clicked_airlock.canAIControl(ai_caller))
			clicked_airlock.balloon_alert(ai_caller, "无法连接!")
			return FALSE

	if (istype(clicked_on, /obj/machinery/airalarm))
		var/obj/machinery/airalarm/alarm = clicked_on
		if (alarm.aidisabled)
			alarm.balloon_alert(ai_caller, "无法连接!")
			return FALSE

	if (istype(clicked_on, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/clicked_apc = clicked_on
		if (clicked_apc.aidisabled)
			clicked_apc.balloon_alert(ai_caller, "无法连接!")
			return FALSE

	if (!clicked_on.emag_act(ai_caller))
		to_chat(ai_caller, span_warning("恶意软件植入失败!")) // lets not overlap balloon alerts
		return FALSE

	to_chat(ai_caller, span_notice("软件包植入成功."))

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 剩余[uses]次使用次数."
		build_all_button_icons()
	else
		unset_ranged_ability(ai_caller, span_warning("使用次数耗尽!"))

	return TRUE

/datum/ai_module/utility/core_tilt
	name = "滚动伺服系统"
	description = "让你缓慢地滚动，你的身体将碾压任何挡道的东西."
	cost = 10
	one_purchase = FALSE
	power_type = /datum/action/innate/ai/ranged/core_tilt
	unlock_sound = 'sound/effects/bang.ogg'
	unlock_text = span_notice("你获得翻滚和碾压东西的能力.")

/datum/action/innate/ai/ranged/core_tilt
	name = "翻滚"
	button_icon_state = "roll_over"
	desc = "让你朝所选方向滚动，碾碎任何挡在道路上的东西."
	auto_use_uses = FALSE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	uses = 20
	COOLDOWN_DECLARE(time_til_next_tilt)
	enable_text = span_notice("你内部的滚动伺服系统开始运作，准备让你翻滚.点击相邻地块来滚动到它们上面!")
	disable_text = span_notice("你接触滚动协议.")

	/// How long does it take for us to roll?
	var/roll_over_time = MALF_AI_ROLL_TIME
	/// On top of [roll_over_time], how long does it take for the ability to cooldown?
	var/roll_over_cooldown = MALF_AI_ROLL_COOLDOWN

/datum/action/innate/ai/ranged/core_tilt/New()
	. = ..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/ranged/core_tilt/do_ability(mob/living/caller, atom/clicked_on)

	if (!COOLDOWN_FINISHED(src, time_til_next_tilt))
		caller.balloon_alert(caller, "冷却中!")
		return FALSE

	if (!isAI(caller))
		return FALSE
	var/mob/living/silicon/ai/ai_caller = caller

	if (ai_caller.incapacitated() || !isturf(ai_caller.loc))
		return FALSE

	var/turf/target = get_turf(clicked_on)
	if (isnull(target))
		return FALSE

	if (target == ai_caller.loc)
		target.balloon_alert(ai_caller, "不能原地翻滚!")
		return FALSE

	var/picked_dir = get_dir(ai_caller, target)
	if (!picked_dir)
		return FALSE
	var/turf/temp_target = get_step(ai_caller, picked_dir) // we can move during the timer so we cant just pass the ref

	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(temp_target, roll_over_time)
	ai_caller.balloon_alert_to_viewers("翻滚...")
	addtimer(CALLBACK(src, PROC_REF(do_roll_over), ai_caller, picked_dir), roll_over_time)

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 剩余[uses]次使用次数."
		build_all_button_icons()

	COOLDOWN_START(src, time_til_next_tilt, roll_over_cooldown)

/datum/action/innate/ai/ranged/core_tilt/proc/do_roll_over(mob/living/silicon/ai/ai_caller, picked_dir)
	if (ai_caller.incapacitated() || !isturf(ai_caller.loc)) // prevents bugs where the ai is carded and rolls
		return

	var/turf/target = get_step(ai_caller, picked_dir) // in case we moved we pass the dir not the target turf

	if (isnull(target))
		return

	var/paralyze_time = clamp(6 SECONDS, 0 SECONDS, (roll_over_cooldown * 0.9)) //the clamp prevents stunlocking as the max is always a little less than the cooldown between rolls

	return ai_caller.fall_and_crush(target, MALF_AI_ROLL_DAMAGE, MALF_AI_ROLL_CRIT_CHANCE, null, paralyze_time, picked_dir, rotation = get_rotation_from_dir(picked_dir))

/// Used in our radial menu, state-checking proc after the radial menu sleeps
/datum/action/innate/ai/ranged/core_tilt/proc/radial_check(mob/living/silicon/ai/caller)
	if (QDELETED(caller) || caller.incapacitated() || caller.stat == DEAD)
		return FALSE

	if (uses <= 0)
		return FALSE

	return TRUE

/datum/action/innate/ai/ranged/core_tilt/proc/get_rotation_from_dir(dir)
	switch (dir)
		if (NORTH, NORTHWEST, WEST, SOUTHWEST)
			return 270 // try our best to not return 180 since it works badly with animate
		if (EAST, NORTHEAST, SOUTH, SOUTHEAST)
			return 90
		else
			stack_trace("non-standard dir entered to get_rotation_from_dir. (got: [dir])")
			return 0

/datum/ai_module/utility/remote_vendor_tilt
	name = "远程售货机倾倒"
	description = "让你可以远程使售货机朝任意方向倾倒."
	cost = 15
	one_purchase = FALSE
	power_type = /datum/action/innate/ai/ranged/remote_vendor_tilt
	unlock_sound = 'sound/effects/bang.ogg'
	unlock_text = span_notice("你获得了远程使售货机倾倒至任何相邻地块的能力.")

/datum/action/innate/ai/ranged/remote_vendor_tilt
	name = "远程倾倒售货机"
	desc = "让售货机向任意方向倾倒."
	button_icon_state = "vendor_tilt"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	uses = VENDOR_TIPPING_USES
	var/time_to_tilt = MALF_VENDOR_TIPPING_TIME
	enable_text = span_notice("你准备摇晃你所选定的售货机.")
	disable_text = span_notice("你不在试图摇晃售货机.")

/datum/action/innate/ai/ranged/remote_vendor_tilt/New()
	. = ..()
	desc = "[desc] 剩余[uses]次使用次数."

/datum/action/innate/ai/ranged/remote_vendor_tilt/do_ability(mob/living/caller, atom/clicked_on)

	if (!isAI(caller))
		return FALSE
	var/mob/living/silicon/ai/ai_caller = caller

	if(ai_caller.incapacitated())
		unset_ranged_ability(caller)
		return FALSE

	if(!isvendor(clicked_on))
		clicked_on.balloon_alert(ai_caller, "不是售货机!")
		return FALSE

	var/obj/machinery/vending/clicked_vendor = clicked_on

	if (clicked_vendor.tilted)
		clicked_vendor.balloon_alert(ai_caller, "已经倾倒了!")
		return FALSE

	if (!clicked_vendor.tiltable)
		clicked_vendor.balloon_alert(ai_caller, "无法倾倒!")
		return FALSE

	if (!clicked_vendor.is_operational)
		clicked_vendor.balloon_alert(ai_caller, "不可用!")
		return FALSE

	var/picked_dir_string = show_radial_menu(ai_caller, clicked_vendor, GLOB.all_radial_directions, custom_check = CALLBACK(src, PROC_REF(radial_check), caller, clicked_vendor))
	if (isnull(picked_dir_string))
		return FALSE
	var/picked_dir = text2dir(picked_dir_string)

	var/turf/target = get_step(clicked_vendor, picked_dir)
	if (!ai_caller.can_see(target))
		to_chat(ai_caller, span_warning("你看不到目标地块!"))
		return FALSE

	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(target, time_to_tilt)
	clicked_vendor.visible_message(span_warning("[clicked_vendor]开始倾倒..."))
	clicked_vendor.balloon_alert_to_viewers("倾倒...")
	addtimer(CALLBACK(src, PROC_REF(do_vendor_tilt), clicked_vendor, target), time_to_tilt)

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 剩余[uses]次使用次数."
		build_all_button_icons()

	unset_ranged_ability(caller, span_danger("倾倒..."))
	return TRUE

/datum/action/innate/ai/ranged/remote_vendor_tilt/proc/do_vendor_tilt(obj/machinery/vending/vendor, turf/target)
	if (QDELETED(vendor))
		return FALSE

	if (vendor.tilted || !vendor.tiltable)
		return FALSE

	vendor.tilt(target, MALF_VENDOR_TIPPING_CRIT_CHANCE)

/// Used in our radial menu, state-checking proc after the radial menu sleeps
/datum/action/innate/ai/ranged/remote_vendor_tilt/proc/radial_check(mob/living/silicon/ai/caller, obj/machinery/vending/clicked_vendor)
	if (QDELETED(caller) || caller.incapacitated() || caller.stat == DEAD)
		return FALSE

	if (QDELETED(clicked_vendor))
		return FALSE

	if (uses <= 0)
		return FALSE

	if (!caller.can_see(clicked_vendor))
		to_chat(caller, span_warning("看不见[clicked_vendor]!"))
		return FALSE

	return TRUE

#undef DEFAULT_DOOMSDAY_TIMER
#undef DOOMSDAY_ANNOUNCE_INTERVAL

#undef VENDOR_TIPPING_USES
#undef MALF_VENDOR_TIPPING_TIME
#undef MALF_VENDOR_TIPPING_CRIT_CHANCE

#undef MALF_AI_ROLL_COOLDOWN
#undef MALF_AI_ROLL_TIME
#undef MALF_AI_ROLL_DAMAGE
#undef MALF_AI_ROLL_CRIT_CHANCE
