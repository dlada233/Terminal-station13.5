//The hunters!!
/datum/antagonist/fugitive_hunter
	name = "赏金猎人"
	roundend_category = "逃亡者"
	silent = TRUE //greet called by the spawn
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_HUNTERS
	prevent_roundtype_conversion = FALSE
	antag_hud_name = "fugitive_hunter"
	suicide_cry = "FOR GLORY!!"
	count_against_dynamic_roll_chance = FALSE
	var/datum/team/fugitive_hunters/hunter_team
	var/backstory = "error"

/datum/antagonist/fugitive_hunter/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/fugitive_hunter/forge_objectives() //this isn't an actual objective because it's about round end rosters
	var/datum/objective/capture = new /datum/objective
	capture.owner = owner
	capture.explanation_text = "捉捕空间站上的逃亡者，把他们全都放进飞船里的蓝空捕获机."
	objectives += capture

/datum/antagonist/fugitive_hunter/greet()
	switch(backstory)
		if(HUNTER_PACK_COPS)
			to_chat(owner, span_boldannounce("我是太空警察的一员，代表正义而来!"))
			to_chat(owner, "<B>罪犯就在太空站上，我们植入了特殊的装置来识别他们.</B>")
			to_chat(owner, "<B>对于管理该站的公司，我们已经没有约束它的权力了，所以安保部门是否肯于我们合作还是个谜.</B>")
		if(HUNTER_PACK_RUSSIAN)
			to_chat(owner, span_danger("Ay blyat. 我是俄国的太空走私犯! 我们的货在飞行途中微笑着离开了我们的船!"))
			to_chat(owner, span_danger("一个穿绿色制服的家伙向我们打招呼，说会将我们的货安全送回，但代价是我们要帮他一个忙:"))
			to_chat(owner, span_danger("当地的一个空间站里藏着逃犯，这个人正在追捕他们，他想要逃犯回来，无论死活."))
			to_chat(owner, span_danger("没了我们的货，我们将无法维持生计，所以我们只能按照他说的做，把逃犯抓回来吧."))
		if(HUNTER_PACK_BOUNTY)
			to_chat(owner, span_danger("上钟了伙计. 我是赏金猎人! 马上就要到达目标的藏身地点."))
			to_chat(owner, span_danger("简报上说那是一个科研空间站，一个不怎么寻常的地方."))
			to_chat(owner, span_danger("我们的客户答应付一大笔钱，所以可不能搞砸了这次工作. 希望我们很快能拿到这笔钱..."))
		if(HUNTER_PACK_PSYKER)
			to_chat(owner, span_danger("晚上好，我们是灵能猎人——不，灵能猎手！"))
			to_chat(owner, span_danger("一个脑灵通过全息板向我们提出了一个无法拒绝的提议. 我们为他们绑架一些蠢货，作为交换我们得到终身供应的脏血."))
			to_chat(owner, span_danger("最近我们的脏血供应越来越少了——我们怎么能说不呢？狂欢必须继续！"))

	to_chat(owner, span_boldannounce("你不是一个可以随意杀人的反派，但你确实可以做任何事来确保抓住逃犯，即使这意味着要打穿空间站。"))
	owner.announce_objectives()

/datum/antagonist/fugitive_hunter/create_team(datum/team/fugitive_hunters/new_team)
	if(!new_team)
		for(var/datum/antagonist/fugitive_hunter/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.hunter_team)
				hunter_team = H.hunter_team
				return
		hunter_team = new /datum/team/fugitive_hunters
		hunter_team.backstory = backstory
		hunter_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	hunter_team = new_team

/datum/antagonist/fugitive_hunter/get_team()
	return hunter_team

/datum/antagonist/fugitive_hunter/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current)

/datum/team/fugitive_hunters
	var/backstory = "error"

/datum/team/fugitive_hunters/proc/update_objectives(initial = FALSE)
	objectives = list()
	var/datum/objective/O = new()
	O.team = src
	objectives += O

/datum/team/fugitive_hunters/proc/assemble_fugitive_results()
	var/list/fugitives_counted = list()
	var/list/fugitives_dead = list()
	var/list/fugitives_captured = list()
	for(var/datum/antagonist/fugitive/A in GLOB.antagonists)
		if(!A.owner)
			stack_trace("Antagonist datum without owner in GLOB.antagonists: [A]")
			continue
		fugitives_counted += A
		if(A.owner.current.stat == DEAD)
			fugitives_dead += A
		if(A.is_captured)
			fugitives_captured += A
	. = list(fugitives_counted, fugitives_dead, fugitives_captured) //okay, check out how cool this is.

/datum/team/fugitive_hunters/proc/all_hunters_dead()
	var/dead_boys = 0
	for(var/I in members)
		var/datum/mind/hunter_mind = I
		if(!(ishuman(hunter_mind.current) || (hunter_mind.current.stat == DEAD)))
			dead_boys++
	return dead_boys >= members.len

/datum/team/fugitive_hunters/proc/get_result()
	var/list/fugitive_results = assemble_fugitive_results()
	var/list/fugitives_counted = fugitive_results[1]
	var/list/fugitives_dead = fugitive_results[2]
	var/list/fugitives_captured = fugitive_results[3]
	var/hunters_dead = all_hunters_dead()
	//this gets a little confusing so follow the comments if it helps
	if(!fugitives_counted.len)
		return
	if(fugitives_captured.len)//any captured
		if(fugitives_captured.len == fugitives_counted.len)//if the hunters captured all the fugitives, there's a couple special wins
			if(!fugitives_dead)//specifically all of the fugitives alive
				return FUGITIVE_RESULT_BADASS_HUNTER
			else if(hunters_dead)//specifically all of the hunters died (while capturing all the fugitives)
				return FUGITIVE_RESULT_POSTMORTEM_HUNTER
			else//no special conditional wins, so just the normal major victory
				return FUGITIVE_RESULT_MAJOR_HUNTER
		else if(!hunters_dead)//so some amount captured, and the hunters survived.
			return FUGITIVE_RESULT_HUNTER_VICTORY
		else//so some amount captured, but NO survivors.
			return FUGITIVE_RESULT_MINOR_HUNTER
	else//from here on out, hunters lost because they did not capture any fugitive dead or alive. there are different levels of getting beat though:
		if(!fugitives_dead)//all fugitives survived
			return FUGITIVE_RESULT_MAJOR_FUGITIVE
		else if(fugitives_dead < fugitives_counted)//at least ANY fugitive lived
			return FUGITIVE_RESULT_FUGITIVE_VICTORY
		else if(!hunters_dead)//all fugitives died, but none were taken in by the hunters. minor win
			return FUGITIVE_RESULT_MINOR_FUGITIVE
		else//all fugitives died, all hunters died, nobody brought back. seems weird to not give fugitives a victory if they managed to kill the hunters but literally no progress to either goal should lead to a nobody wins situation
			return FUGITIVE_RESULT_STALEMATE

/datum/team/fugitive_hunters/roundend_report() // 显示逃亡者的数量，但不显示是否赢了，以防没有安保
	if(!members.len)
		return

	var/list/result = list()

	result += "<div class='panel redborder'>……<B>[members.len]</B>[backstory]试图追捕他们！"

	for(var/datum/mind/M in members)
		result += "<b>[printplayer(M)]</b>"

	switch(get_result())
		if(FUGITIVE_RESULT_BADASS_HUNTER)//使用定义
			result += "<span class='greentext big'>[capitalize(backstory)]传奇胜利！</span>"
			result += "<B>这些[backstory]成功抓获了所有逃亡者，而且全都是活捉！</B>"
		if(FUGITIVE_RESULT_POSTMORTEM_HUNTER)
			result += "<span class='greentext big'>[capitalize(backstory)]尸检胜利！</span>"
			result += "<B>这些[backstory]成功抓获了所有逃亡者，但他们全都死了！好吓人！</B>"
		if(FUGITIVE_RESULT_MAJOR_HUNTER)
			result += "<span class='greentext big'>[capitalize(backstory)]重大胜利</span>"
			result += "<B>这些[backstory]成功抓获了所有逃亡者，不论是死是活.</B>"
		if(FUGITIVE_RESULT_HUNTER_VICTORY)
			result += "<span class='greentext big'>[capitalize(backstory)]胜利</span>"
			result += "<B>这些[backstory]成功抓获了一名逃亡者，不论是死是活.</B>"
		if(FUGITIVE_RESULT_MINOR_HUNTER)
			result += "<span class='greentext big'>[capitalize(backstory)]小胜利</span>"
			result += "<B>所有[backstory]都死了，但他们成功抓获了一名逃亡者，不论是死是活.</B>"
		if(FUGITIVE_RESULT_STALEMATE)
			result += "<span class='neutraltext big'>血腥僵局</span>"
			result += "<B>所有人都死了，也没有逃亡者被抓获！</B>"
		if(FUGITIVE_RESULT_MINOR_FUGITIVE)
			result += "<span class='redtext big'>逃亡者小胜利</span>"
			result += "<B>所有逃亡者都死了，但没有人被抓获！</B>"
		if(FUGITIVE_RESULT_FUGITIVE_VICTORY)
			result += "<span class='redtext big'>逃亡者胜利</span>"
			result += "<B>一个逃亡者幸存，没有人被[backstory]抓获.</B>"
		if(FUGITIVE_RESULT_MAJOR_FUGITIVE)
			result += "<span class='redtext big'>逃亡者重大胜利</span>"
			result += "<B>所有逃亡者都活了下来并且没有被抓获！</B>"
		else //get_result 返回null - 可能是bug或没有逃亡者
			result += "<span class='neutraltext big'>恶作剧电话！</span>"
			result += "<B>叫来了[capitalize(backstory)]，但没有逃亡者...?</B>"

	result += "</div>"

	return result.Join("<br>")
