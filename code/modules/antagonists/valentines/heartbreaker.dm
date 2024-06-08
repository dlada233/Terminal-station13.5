/datum/antagonist/heartbreaker
	name = "\improper 单身狗"
	roundend_category = "情人节"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	suicide_cry = "FOR LONELINESS!!"

/datum/antagonist/heartbreaker/forge_objectives()
	var/datum/objective/martyr/normiesgetout = new
	normiesgetout.owner = owner
	objectives += normiesgetout

/datum/antagonist/heartbreaker/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/heartbreaker/greet()
	. = ..()
	to_chat(owner, span_warning("<B>就你没有约会对象! 除了你所有人都玩得很开心! 你不能就这么度过...</B>"))
	owner.announce_objectives()
