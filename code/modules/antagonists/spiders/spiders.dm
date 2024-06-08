/datum/antagonist/spider
	name = "蜘蛛"
	antagpanel_category = ANTAG_GROUP_ARACHNIDS
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	/// 由女王下达给我们的命令
	var/directive

/datum/antagonist/spider/New(directive)
	. = ..()
	src.directive = directive

/datum/antagonist/spider/on_gain()
	forge_objectives(directive)
	return ..()

/datum/antagonist/spider/greet()
	. = ..()
	owner.announce_objectives()

/datum/objective/spider
	explanation_text = "传播虫害."

/datum/objective/spider/New(directive)
	..()
	if(directive)
		explanation_text = "您的女王给了您一项指令！无论代价如何都请遵循它：[directive]"

/datum/objective/spider/check_completion()
	return owner.current.stat != DEAD

/datum/antagonist/spider/forge_objectives()
	var/datum/objective/spider/objective = new(directive)
	objective.owner = owner
	objectives += objective

/// 没有女王的肉蜘蛛的子类型
/datum/antagonist/spider/flesh
	name = "血肉蜘蛛"

/datum/antagonist/spider/flesh/forge_objectives()
	var/datum/objective/custom/destroy = new()
	destroy.owner = owner
	destroy.explanation_text = "制造混乱并吞噬活体血肉."
	objectives += destroy

	var/datum/objective/survive/dont_die = new()
	dont_die.owner = owner
	objectives += dont_die

/datum/antagonist/spider/flesh/greet()
	. = ..()
	to_chat(owner, span_boldwarning("你是由化形创造出来的可怖活物，你对你物种之外的所有生物都有攻击性...甚至对你你的创造者也是. \
		<br>只要几秒钟内避免受到伤害，你的可塑肉体将迅速再生."))
