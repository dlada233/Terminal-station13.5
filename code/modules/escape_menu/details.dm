// This doesn't instantiate right away, since we rely on other GLOBs
GLOBAL_DATUM(escape_menu_details, /atom/movable/screen/escape_menu/details)

/// Provides a singleton for the escape menu details screen.
/proc/give_escape_menu_details()
	if (isnull(GLOB.escape_menu_details))
		GLOB.escape_menu_details = new

	return GLOB.escape_menu_details

/atom/movable/screen/escape_menu/details
	screen_loc = "EAST:-180,NORTH:-25"
	maptext_height = 100
	maptext_width = 200

/atom/movable/screen/escape_menu/details/Initialize(mapload, datum/hud/hud_owner)
	. = ..()

	update_text()
	START_PROCESSING(SSescape_menu, src)

/atom/movable/screen/escape_menu/details/Destroy()
	if (GLOB.escape_menu_details == src)
		stack_trace("Something tried to delete the escape menu details screen")
		return QDEL_HINT_LETMELIVE

	STOP_PROCESSING(SSescape_menu, src)
	return ..()

/atom/movable/screen/escape_menu/details/process(seconds_per_tick)
	update_text()

/atom/movable/screen/escape_menu/details/proc/update_text()
	var/new_maptext = {"
		<span style='text-align: right; line-height: 0.7'>
			回合ID: [GLOB.round_id || "未设置"]<br />
			回合时间: [ROUND_TIME()]<br />
			地图: [SSmapping.config?.map_name || "加载中..."]<br />
			时间膨胀: [round(SStime_track.time_dilation_current,1)]%<br />
		</span>
	"}

	maptext = MAPTEXT(new_maptext)
