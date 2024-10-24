GLOBAL_LIST_EMPTY(map_delamination_counters)

/// Display days since last delam on incident sign
#define DISPLAY_DELAM (1<<0)
/// Display current number of tram hits on incident sign
#define DISPLAY_TRAM (1<<1)

DEFINE_BITFIELD(sign_features, list(
	"DISPLAY_DELAM" = DISPLAY_DELAM,
	"DISPLAY_TRAM" = DISPLAY_TRAM,
))

#define TREND_RISING "rising"
#define TREND_FALLING "falling"

#define NAME_DUAL "安全事故公告板"
#define NAME_DELAM "分层事故公告板"
#define NAME_TRAM "电车事故公告板"

#define DESC_DUAL "公告站点安全事故记录的显示器，有名为“安全蛾”的特色角色在播报."
#define DESC_DELAM "公告距离上一次分层事故已经过去了多长时间，有名为“安全蛾”的特色角色在播报."
#define DESC_TRAM "公告本次轮班电车事故数量的显示器，有名为“安全蛾”的特色角色在播报."

/**
 * List of safety statistic signs on the map that have delam counting enabled.
 * Required as persistence subsystem loads after the ones present at mapload, and to reset to 0 upon explosion.
 */

/obj/machinery/incident_display
	name = NAME_DELAM
	desc = DESC_DELAM
	icon = 'icons/obj/machines/incident_display.dmi'
	icon_preview = "stat_display_delam"
	icon_state = "stat_display_delam"
	verb_say = "beeps"
	verb_ask = "bloops"
	verb_exclaim = "blares"
	idle_power_usage = 450
	max_integrity = 150
	integrity_failure = 0.75
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4, /datum/material/alloy/titaniumglass = SHEET_MATERIAL_AMOUNT * 4)
	/// What statistics we want the sign to display
	var/sign_features = DISPLAY_DELAM
	/// Tram hits before hazard warning
	var/hit_threshold = 0
	/// Tram hits
	var/hit_count = 0
	/// Shifts without delam
	var/last_delam = 0
	/// Delam record high-score
	var/delam_record = 0

/obj/machinery/incident_display/dual
	name = NAME_DUAL
	desc = DESC_DUAL
	icon_preview = "stat_display_dual"
	icon_state = "stat_display_dual"
	sign_features = DISPLAY_DELAM | DISPLAY_TRAM

/obj/machinery/incident_display/delam
	name = NAME_DELAM
	desc = DESC_DELAM
	icon_preview = "stat_display_delam"
	icon_state = "stat_display_delam"
	sign_features = DISPLAY_DELAM

/obj/machinery/incident_display/tram
	name = NAME_TRAM
	desc = DESC_TRAM
	icon_preview = "stat_display_tram"
	icon_state = "stat_display_tram"
	sign_features = DISPLAY_TRAM

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/incident_display, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/incident_display/delam, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/incident_display/dual, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/incident_display/tram, 32)

/obj/machinery/incident_display/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/incident_display/post_machine_initialize()
	. = ..()
	GLOB.map_delamination_counters += src
	update_delam_count(SSpersistence.rounds_since_engine_exploded, SSpersistence.delam_highscore)
	RegisterSignal(SStransport, COMSIG_TRAM_COLLISION, PROC_REF(update_tram_count))

	update_appearance()

/obj/machinery/incident_display/Destroy()
	GLOB.map_delamination_counters -= src
	return ..()

/obj/machinery/incident_display/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return FALSE

	if(atom_integrity >= max_integrity && !(machine_stat & BROKEN))
		balloon_alert(user, "它不需要修理!")
		return TRUE

	balloon_alert(user, "修理显示器...")
	if(!tool.use_tool(src, user, 4 SECONDS, amount = 0, volume=50))
		return TRUE

	balloon_alert(user, "修理完成")
	atom_integrity = max_integrity
	set_machine_stat(machine_stat & ~BROKEN)
	update_appearance()
	return TRUE

// Switch modes with multitool
/obj/machinery/incident_display/multitool_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return FALSE

	if(sign_features == DISPLAY_TRAM)
		tool.play_tool_sound(src)
		balloon_alert(user, "设置为双类")
		name = NAME_DUAL
		desc = DESC_DUAL
		icon_state = "stat_display_dual"
		sign_features = DISPLAY_DELAM | DISPLAY_TRAM
		update_delam_count(SSpersistence.rounds_since_engine_exploded, SSpersistence.delam_highscore)
		update_tram_count(src, SSpersistence.tram_hits_this_round)
		update_appearance()
		return TRUE
	else if(sign_features == DISPLAY_DELAM)
		tool.play_tool_sound(src)
		balloon_alert(user, "设置为电车")
		name = NAME_TRAM
		desc = DESC_TRAM
		icon_state = "stat_display_tram"
		sign_features = DISPLAY_TRAM
		update_tram_count(src, SSpersistence.tram_hits_this_round)
		update_appearance()
		return TRUE
	else if(sign_features == (DISPLAY_DELAM + DISPLAY_TRAM))
		tool.play_tool_sound(src)
		balloon_alert(user, "设置为分层")
		name = NAME_DELAM
		desc = DESC_DELAM
		icon_state = "stat_display_delam"
		sign_features = DISPLAY_DELAM
		update_delam_count(SSpersistence.rounds_since_engine_exploded, SSpersistence.delam_highscore)
		update_appearance()
		return TRUE

// EMP causes the display to display random numbers or outright break.
/obj/machinery/incident_display/emp_act(severity)
	. = ..()
	if(prob(50))
		set_machine_stat(machine_stat | BROKEN)
		update_appearance()
		return
	name = NAME_DUAL
	desc = DESC_DUAL
	icon_state = "stat_display_dual"
	sign_features = DISPLAY_DELAM | DISPLAY_TRAM
	hit_threshold = rand(1,99)
	hit_count = rand(1,99)
	last_delam = rand(1,99)
	delam_record = rand(1,99)
	update_appearance()

/obj/machinery/incident_display/on_deconstruction(disassembled)
	new /obj/item/stack/sheet/mineral/titanium(drop_location(), 2)
	new /obj/item/shard(drop_location())
	new /obj/item/shard(drop_location())

/obj/machinery/incident_display/proc/update_delam_count(new_count, record)
	delam_record = record
	last_delam = min(new_count, 199)
	update_appearance()

/obj/machinery/incident_display/proc/update_tram_count(source, tram_collisions)
	SIGNAL_HANDLER

	hit_count = min(tram_collisions, 199)
	update_appearance()

/obj/machinery/incident_display/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "stat_display_blank"
		set_light(l_on = FALSE)
		return

	if(machine_stat & BROKEN)
		icon_state = "stat_display_broken"
	else if(sign_features == (DISPLAY_DELAM + DISPLAY_TRAM))
		icon_state = "stat_display_dual"
	else if(sign_features == DISPLAY_DELAM)
		icon_state = "stat_display_delam"
	else if(sign_features == DISPLAY_TRAM)
		icon_state = "stat_display_tram"

	set_light(l_range = 1.7, l_power = 1.5, l_color = LIGHT_COLOR_FAINT_CYAN, l_on = TRUE)

/obj/machinery/incident_display/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	var/mutable_appearance/moff_base_emissive = emissive_appearance(icon, "moff_base_emissive", src, alpha = src.alpha)
	. += moff_base_emissive

	if(sign_features & DISPLAY_DELAM)
		var/mutable_appearance/delam_base_emissive = emissive_appearance(icon, "delam_base_emissive", src, alpha = src.alpha)
		var/delam_display_color
		. += delam_base_emissive
		if(last_delam <= 0)
			delam_display_color = COLOR_DISPLAY_RED
		else
			delam_display_color = COLOR_DISPLAY_YELLOW

		var/delam_pos1 = clamp(last_delam, 0, 199) % 10
		var/mutable_appearance/delam_pos1_overlay = mutable_appearance(icon, "num_[delam_pos1]")
		var/mutable_appearance/delam_pos1_emissive = emissive_appearance(icon, "num_[delam_pos1]_e", src, alpha = src.alpha)
		delam_pos1_overlay.color = delam_display_color
		delam_pos1_overlay.pixel_w = 9
		delam_pos1_emissive.pixel_w = 9
		delam_pos1_overlay.pixel_z = 4
		delam_pos1_emissive.pixel_z = 4
		. += delam_pos1_overlay
		. += delam_pos1_emissive

		var/delam_pos2 = (clamp(last_delam, 0, 199) / 10) % 10
		var/mutable_appearance/delam_pos2_overlay = mutable_appearance(icon, "num_[delam_pos2]")
		var/mutable_appearance/delam_pos2_emissive = emissive_appearance(icon, "num_[delam_pos2]_e", src, alpha = src.alpha)
		delam_pos2_overlay.color = delam_display_color
		delam_pos2_overlay.pixel_w = 4
		delam_pos2_emissive.pixel_w = 4
		delam_pos2_overlay.pixel_z = 4
		delam_pos2_emissive.pixel_z = 4
		. += delam_pos2_overlay
		. += delam_pos2_emissive

		if(last_delam >= 100)
			var/mutable_appearance/there_i_fixed_it_overlay = mutable_appearance(icon, "num_100_red")
			var/mutable_appearance/there_i_fixed_it_emissive = emissive_appearance(icon, "num_100_red", src, alpha = src.alpha)
			. += there_i_fixed_it_overlay
			. += there_i_fixed_it_emissive

		if(last_delam == delam_record)
			var/mutable_appearance/delam_trend_overlay = mutable_appearance(icon, TREND_RISING)
			var/mutable_appearance/delam_trend_emissive = emissive_appearance(icon, "[TREND_RISING]_e", src, alpha = src.alpha)
			delam_trend_overlay.color = COLOR_DISPLAY_GREEN
			delam_trend_overlay.pixel_w = 1
			delam_trend_emissive.pixel_w = 1
			delam_trend_overlay.pixel_z = 6
			delam_trend_emissive.pixel_z = 6
			. += delam_trend_overlay
			. += delam_trend_emissive
		else
			var/mutable_appearance/delam_trend_overlay = mutable_appearance(icon, TREND_FALLING)
			var/mutable_appearance/delam_trend_emissive = emissive_appearance(icon, "[TREND_FALLING]_e", src, alpha = src.alpha)
			delam_trend_overlay.color = COLOR_DISPLAY_RED
			delam_trend_overlay.pixel_w = 1
			delam_trend_emissive.pixel_w = 1
			delam_trend_overlay.pixel_z = 6
			delam_trend_emissive.pixel_z = 6
			. += delam_trend_overlay
			. += delam_trend_emissive

	if(sign_features & DISPLAY_TRAM)
		var/mutable_appearance/tram_base_emissive = emissive_appearance(icon, "tram_base_emissive", src, alpha = src.alpha)
		var/tram_display_color = COLOR_DISPLAY_BLUE

		var/tram_pos1 = hit_count % 10
		var/mutable_appearance/tram_pos1_overlay = mutable_appearance(icon, "num_[tram_pos1]")
		var/mutable_appearance/tram_pos1_emissive = emissive_appearance(icon, "num_[tram_pos1]_e", src, alpha = src.alpha)
		. += tram_base_emissive
		tram_pos1_overlay.color = tram_display_color
		tram_pos1_overlay.pixel_w = 9
		tram_pos1_emissive.pixel_w = 9
		tram_pos1_overlay.pixel_z = -6
		tram_pos1_emissive.pixel_z = -6
		. += tram_pos1_overlay
		. += tram_pos1_emissive

		var/tram_pos2 = (hit_count / 10) % 10
		var/mutable_appearance/tram_pos2_overlay = mutable_appearance(icon, "num_[tram_pos2]")
		var/mutable_appearance/tram_pos2_emissive = emissive_appearance(icon, "num_[tram_pos2]_e", src, alpha = src.alpha)
		tram_pos2_overlay.color = tram_display_color
		tram_pos2_overlay.pixel_w = 4
		tram_pos2_emissive.pixel_w = 4
		tram_pos2_overlay.pixel_z = -6
		tram_pos2_emissive.pixel_z = -6
		. += tram_pos2_overlay
		. += tram_pos2_emissive

		if(hit_count >= 100)
			var/mutable_appearance/there_i_fixed_it_overlay = mutable_appearance(icon, "num_100_blue")
			var/mutable_appearance/there_i_fixed_it_emissive = emissive_appearance(icon, "num_100_blue", src, alpha = src.alpha)
			. += there_i_fixed_it_overlay
			. += there_i_fixed_it_emissive

		if(hit_count > SSpersistence.tram_hits_last_round)
			var/mutable_appearance/tram_trend_overlay = mutable_appearance(icon, TREND_RISING)
			var/mutable_appearance/tram_trend_emissive = emissive_appearance(icon, "[TREND_RISING]_e", src, alpha = src.alpha)
			tram_trend_overlay.color = COLOR_DISPLAY_RED
			tram_trend_overlay.pixel_w = 1
			tram_trend_emissive.pixel_w = 1
			tram_trend_overlay.pixel_z = -4
			tram_trend_emissive.pixel_z = -4
			. += tram_trend_overlay
			. += tram_trend_emissive
		else
			var/mutable_appearance/tram_trend_overlay = mutable_appearance(icon, TREND_FALLING)
			var/mutable_appearance/tram_trend_emissive = emissive_appearance(icon, "[TREND_FALLING]_e", src, alpha = src.alpha)
			tram_trend_overlay.color = COLOR_DISPLAY_GREEN
			tram_trend_overlay.pixel_w = 1
			tram_trend_emissive.pixel_w = 1
			tram_trend_overlay.pixel_z = -4
			tram_trend_emissive.pixel_z = -4
			. += tram_trend_overlay
			. += tram_trend_emissive

/obj/machinery/incident_display/examine(mob/user)
	. = ..()

	if(sign_features & DISPLAY_DELAM)
		if(last_delam >= 0)
			. += span_info("距离上一次分层事件，已经经过[last_delam]次轮班.")
			switch(last_delam)
				if(0)
					. += span_info("这次我们会做得更好.<br/>")
				if(1 to 5)
					. += span_info("还能再接再厉.<br/>")
				if(6 to 10)
					. += span_info("干得好!<br/>")
				if(69)
					. += span_info("漂亮.<br/>")
				else
					. += span_info("真是不可思议!<br/>")
		else
			. += span_info("以防你不知道，现在超物质晶体已经分层了.")

	if(sign_features & DISPLAY_TRAM)
		. += span_info("本次轮班发生了[hit_count]次电车事故.")
		switch(hit_count)
			if(0)
				. += span_info("了不起! 交通安全的榜样.<br/>")
			if(1)
				. += span_info("明天还能做得更好.<br/>")
			if(2 to 5)
				. += span_info("还有提升空间.<br/>")
			if(6 to 10)
				. += span_info("干得好! 纳米传讯的骄傲!<br/>")
			if(69)
				. += span_info("漂亮.<br/>")
			else
				. += span_info("不可思议! 你可能就在医疗部阅读此信息.<br/>")

#undef DISPLAY_DELAM
#undef DISPLAY_TRAM

#undef NAME_DUAL
#undef NAME_DELAM
#undef NAME_TRAM

#undef DESC_DUAL
#undef DESC_DELAM
#undef DESC_TRAM

#undef TREND_RISING
#undef TREND_FALLING
