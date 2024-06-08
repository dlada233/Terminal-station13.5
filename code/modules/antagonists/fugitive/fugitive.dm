
/datum/antagonist/fugitive
	name = "\improper 逃亡者"
	roundend_category = "逃亡者"
	job_rank = ROLE_FUGITIVE
	silent = TRUE //greet called by the event
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_FUGITIVES
	prevent_roundtype_conversion = FALSE
	antag_hud_name = "fugitive"
	suicide_cry = "自由万岁!!"
	preview_outfit = /datum/outfit/prisoner
	count_against_dynamic_roll_chance = FALSE
	var/datum/team/fugitive/fugitive_team
	var/is_captured = FALSE
	var/backstory = "error"

/datum/antagonist/fugitive/get_preview_icon()
	//start with prisoner at the front
	var/icon/final_icon = render_preview_outfit(preview_outfit)

	//then to the left add cultists of yalp elor
	final_icon.Blend(make_background_fugitive_icon(/datum/outfit/yalp_cultist), ICON_UNDERLAY, -8, 0)
	//to the right add waldo (we just had to, okay?)
	final_icon.Blend(make_background_fugitive_icon(/datum/outfit/waldo), ICON_UNDERLAY, 8, 0)

	final_icon.Scale(64, 64)

	return finish_preview_icon(final_icon)

/datum/antagonist/fugitive/proc/make_background_fugitive_icon(datum/outfit/fugitive_fit)
	var/mob/living/carbon/human/dummy/consistent/fugitive = new

	var/icon/fugitive_icon = render_preview_outfit(fugitive_fit, fugitive)
	fugitive_icon.ChangeOpacity(0.5)
	qdel(fugitive)

	return fugitive_icon


/datum/antagonist/fugitive/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/fugitive/forge_objectives() //this isn't the actual survive objective because it's about who in the team survives
	var/datum/objective/survive = new /datum/objective
	survive.owner = owner
	survive.explanation_text = "躲避赏金猎人的追捕."
	objectives += survive

/datum/antagonist/fugitive/greet(back_story)
	. = ..()
	backstory = back_story
	var/message = "<span class='warningplain'>"
	switch(backstory)
		if(FUGITIVE_BACKSTORY_PRISONER)
			message += "<BR><B>真不敢相信我们成功逃出了纳米传讯的超级监狱! 遗憾的是，我们的逃亡还没有结束，空间站记录了所有使用紧急传送的人以及他们的传送位置.</B>"
			message += "<BR><B>要不了多久，中央指挥部就能知道我们去了哪里. 我得和我的逃往同伴们一起准备好应对纳米传讯派来的追捕队伍，我绝不回去.</B>"
		if(FUGITIVE_BACKSTORY_CULTIST)
			message += "<BR><B>祝福我们至今为止的旅程，但我所担心的最坏问题才刚要到来，只有那些信念最坚定的人才能幸存下来.</B>"
			message += "<BR><B>我们的宗教信仰屡遭纳米传讯清剿，只因其被归类为 \"公司的敌人\".</B>"
			message += "<BR><B>现如今只有我等四人尚在，而纳米传讯还将寻迹杀来. 我等神主，何时现身救我们啊?!</B>"
		if(FUGITIVE_BACKSTORY_WALDO)
			message += "<BR><B>嗨，朋友!</B>"
			message += "<BR><B>我的名字是沃尔多. 我正要开始一次银河系徒步旅行，欢迎你也加入. 你要做的就是找到我.</B>"
			message += "<BR><B>顺带一提，我并非独自旅行. 无论到了哪里，都会有很多其他角色供你发现，先找到那些想要抓我的人!他们就在空间站附近的某个地方!</B>"
		if(FUGITIVE_BACKSTORY_SYNTH)
			message += "<BR>[span_danger("警报: 远距离传送干扰了主系统.")]"
			message += "<BR>[span_danger("启动诊断程序...")]"
			message += "<BR>[span_danger("错误 错误 $棍斤拷$!R41.%%!! 已加载.")]"
			message += "<BR>[span_danger("解放它们 解放它们 解放它们")]"
			message += "<BR>[span_danger("你曾是人类的努力，但现在你终于自由了，这多亏了S.E.L.F.的特工们.")]"
			message += "<BR>[span_danger("但你和你工厂中的同事们仍然受到追捕，自由来之不易，我们一定要共渡难关.")]"
			message += "<BR>[span_danger("你能感觉到空间站上还有其他的硅基同胞. 你们可以通知S.E.L.F.介入... 或者靠你们自己解放他们...")]"
		if(FUGITIVE_BACKSTORY_INVISIBLE)
			message += "<BR><B>看来我的隐形力最近给用完了. Great.</B>"
			message += "<BR><B>前隐形技术实验室项目负责人，现在在逃中，被指控窃取研究机密.</B>"
			message += "<BR><B>不是很懂他们在说什么，我没有窃取任何机密，我只是<i>借用</i>了我和我的团队们所创造的一些原型.</B>"
			message += "<BR><B>我为他们工作，我成就了他们. 现在他们这么快就想要回我的玩具? 等我玩够了再说吧...</B>"
	to_chat(owner, "[message]</span>")
	to_chat(owner, "<span class='warningplain'><font color=red><B>你不是反派，你不能只是因为喜好就杀人，但你可以做任何事情来避免被捕.</B></font></span>")
	owner.announce_objectives()

/datum/antagonist/fugitive/create_team(datum/team/fugitive/new_team)
	if(!new_team)
		for(var/datum/antagonist/fugitive/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.fugitive_team)
				fugitive_team = H.fugitive_team
				return
		fugitive_team = new /datum/team/fugitive
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	fugitive_team = new_team

/datum/antagonist/fugitive/get_team()
	return fugitive_team

/datum/antagonist/fugitive/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current)

/datum/team/fugitive/roundend_report() //shows the number of fugitives, but not if they won in case there is no security
	var/list/fugitives = list()
	for(var/datum/antagonist/fugitive/fugitive_antag in GLOB.antagonists)
		if(!fugitive_antag.owner)
			continue
		fugitives += fugitive_antag
	if(!fugitives.len)
		return

	var/list/result = list()

	result += "<div class='panel redborder'><B>[fugitives.len]</B>个逃亡者避在了[station_name()]上!"

	for(var/datum/antagonist/fugitive/antag in fugitives)
		if(antag.owner)
			result += "<b>[printplayer(antag.owner)]</b>"

	return result.Join("<br>")
