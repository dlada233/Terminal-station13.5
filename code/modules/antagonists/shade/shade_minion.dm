/**
 * 此数据用于拥有主人但不是血教徒的幽灵。
 * 邪教徒得到邪教数据而不是这个数据。
 * 他们受制于自己的创造者的命令，可能是一位牧师或矿工。
 * 严格来说，他们不是'反派'，但他们具有类似反派的属性。
 */
/datum/antagonist/shade_minion
	name = "\improper 忠诚的灵魂"
	show_in_antagpanel = FALSE
	show_in_roundend = FALSE
	silent = TRUE
	ui_name = "AntagInfoShade"
	count_against_dynamic_roll_chance = FALSE
	/// 此幽灵的主人名称。
	var/master_name = "无"

/datum/antagonist/shade_minion/ui_static_data(mob/user)
	var/list/data = list()
	data["master_name"] = master_name
	return data

/// 应用新的主人到幽灵，也会再次显示弹出窗口。
/datum/antagonist/shade_minion/proc/update_master(master_name)
	if (src.master_name == master_name)
		return

	src.master_name = master_name
	update_static_data(owner.current)
	INVOKE_ASYNC(src, PROC_REF(display_panel))

/// 显示信息面板，移出到自己的处理过程中以处理信号。
/datum/antagonist/shade_minion/proc/display_panel()
	var/datum/action/antag_info/info_button = info_button_ref?.resolve()
	info_button?.Trigger()
