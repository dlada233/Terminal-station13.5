/*
 * 如果你能看到上级对象，则应用基于角色的情绪.
 *
 * - 对在物品可见范围内的人应用情绪.
 * - 不会重新应用已经拥有情绪的人.
 * - 如果成功应用情绪，则发送信号.
 */
/datum/proximity_monitor/advanced/demoraliser
	var/datum/demoralise_moods/moods

/datum/proximity_monitor/advanced/demoraliser/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, datum/demoralise_moods/moods)
	. = ..()
	src.moods = moods
	RegisterSignal(host, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/proximity_monitor/advanced/demoraliser/field_turf_crossed(atom/movable/crossed, turf/location)
	if (!isliving(crossed))
		return
	if (!can_see(crossed, host, current_range))
		return
	on_seen(crossed)

/*
 * [COMSIG_ATOM_EXAMINE] 的信号处理程序.
 * 立即尝试对检查者应用情绪，忽略接近检查.
 * 如果有人想通过摄像头让自己感到悲伤，那是他们的选择，我想.
 */
/datum/proximity_monitor/advanced/demoraliser/proc/on_examine(datum/source, mob/examiner)
	SIGNAL_HANDLER
	if (isliving(examiner))
		on_seen(examiner)

/**
 * 当有人看着令人沮丧的物体时调用.
 * 如果他们是清醒的并且没有已有的情绪，则应用情绪.
 * 根据他们是反派、当权者还是“其他”（假设为船员）应用不同的情绪.
 *
 * 参数
 * * viewer - 看着这个物体的人.
 */
/datum/proximity_monitor/advanced/demoraliser/proc/on_seen(mob/living/viewer)
	if (!viewer.mind)
		return
	// 如果你不清醒，你太忙或已经死了，无法看宣传
	if (viewer.stat != CONSCIOUS)
		return
	if(viewer.is_blind())
		return
	if (!should_demoralise(viewer))
		return
	if(!viewer.can_read(host, moods.reading_requirements, TRUE)) //如果是基于文本的消极情绪数据，确保角色有阅读能力.如果只是图像，确保其亮度足够让他们看见.
		return


	if (is_special_character(viewer))
		to_chat(viewer, span_notice("[moods.antag_notification]"))
		viewer.add_mood_event(moods.mood_category, moods.antag_mood)
	else if (viewer.mind.assigned_role.departments_bitflags & (DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_COMMAND))
		to_chat(viewer, span_notice("[moods.authority_notification]"))
		viewer.add_mood_event(moods.mood_category, moods.authority_mood)
	else
		to_chat(viewer, span_notice("[moods.crew_notification]"))
		viewer.add_mood_event(moods.mood_category, moods.crew_mood)

	SEND_SIGNAL(host, COMSIG_DEMORALISING_EVENT, viewer.mind)

/**
 * 如果用户能够体验情绪并且没有已经存在的与此数据相关的情绪，则返回 true，否则返回 false.
 *
 * 参数
 * * viewer - 刚看到上级对象的人.
 */
/datum/proximity_monitor/advanced/demoraliser/proc/should_demoralise(mob/living/viewer)
	if (!viewer.mob_mood)
		return FALSE

	return !viewer.mob_mood.has_mood_of_category(moods.mood_category)

/// 此任务的情绪应用类别
/// 用于根据玩家状态减少重复的情绪应用代码
/datum/demoralise_moods
	/// 要应用于情绪的情绪类别
	var/mood_category
	/// 当反派收到此情绪时要显示的文本
	var/antag_notification
	/// 要应用于反派的情绪数据
	var/datum/mood_event/antag_mood
	/// 当船员收到此情绪时要显示的文本
	var/crew_notification
	/// 要应用于船员的情绪数据
	var/datum/mood_event/crew_mood
	/// 当工作人员收到此情绪时要显示的文本
	var/authority_notification
	/// 用于识字检查
	var/reading_requirements = READING_CHECK_LIGHT
	/// 要应用于工作人员或安全人员的情绪数据
	var/datum/mood_event/authority_mood

/datum/demoralise_moods/poster
	mood_category = "邪恶海报"
	antag_notification = "好海报."
	antag_mood = /datum/mood_event/traitor_poster_antag
	crew_notification = "等等，那张海报上说的是真的吗？"
	crew_mood = /datum/mood_event/traitor_poster_crew
	authority_notification = "嘿！谁贴的这张海报？"
	authority_mood = /datum/mood_event/traitor_poster_auth
	reading_requirements = (READING_CHECK_LITERACY | READING_CHECK_LIGHT)

/datum/mood_event/traitor_poster_antag
	description = "我正在做正确的事."
	mood_change = 2
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_poster_crew
	description = "那张海报让我对我的工作感到难过..."
	mood_change = -2
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_poster_auth
	description = "那张海报最好不要让船员有任何奇怪的想法..."
	mood_change = -3
	timeout = 2 MINUTES
	hidden = TRUE

/datum/demoralise_moods/graffiti
	mood_category = "邪恶涂鸦"
	antag_notification = "三头蛇.不错."
	antag_mood = /datum/mood_event/traitor_graffiti_antag
	crew_notification = "那是...三头蛇吗？"
	crew_mood = /datum/mood_event/traitor_graffiti_crew
	authority_notification = "三头蛇只会带来麻烦."
	authority_mood = /datum/mood_event/traitor_graffiti_auth

/datum/mood_event/traitor_graffiti_antag
	description = "辛迪加标志？多么大胆."
	mood_change = 2
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_graffiti_crew
	description = "辛迪加标志？我在这里安全吗？"
	mood_change = -2
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_graffiti_auth
	description = "是谁在这里画了辛迪加标志？！"
	mood_change = -3
	timeout = 2 MINUTES
	hidden = TRUE

/datum/demoralise_moods/module
	mood_category = "模块"
	antag_notification = "我感到奇怪的清爽."
	antag_mood = /datum/mood_event/traitor_module_antag
	crew_notification = "我的头好痛.感觉像是有什么东西在我的脑袋里钉钉子！"
	crew_mood = /datum/mood_event/traitor_module_crew
	authority_notification = "我的头开始晕了.敌人就在门口.我孤身一人..."
	authority_mood = /datum/mood_event/traitor_module_auth
	reading_requirements = (READING_CHECK_LIGHT)

/datum/mood_event/traitor_module_antag
	description = "我想我要故意制造麻烦."
	mood_change = 1
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_module_crew
	description = "他们在这个站点上！我知道的！他们会抓到我的！"
	mood_change = -4
	timeout = 2 MINUTES
	hidden = TRUE

/datum/mood_event/traitor_module_auth
	description = "这个站上的人都不支持我，敌人可能是任何人！我必须采取更严厉的措施..."
	mood_change = -5
	timeout = 2 MINUTES
	hidden = TRUE
