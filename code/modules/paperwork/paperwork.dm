/**
 * # Paperwork
 *
 * Paperwork documents that can be stamped by their associated stamp to provide a bonus to cargo.
 *
 * Paperwork documents are a cargo item meant to provide the opportunity to make money.
 * Each piece of paperwork has its own associated stamp it needs to be stamped with. Selling a
 * properly stamped piece of paperwork will provide a cash bonus to the cargo budget. If a document is
 * not properly stamped it will instead drain a small stipend from the cargo budget.
 *
 */

/obj/item/paperwork
	name = "文件"
	desc = "一堆杂乱无章的文档、研究结果和调查结果."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_part"
	inhand_icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	layer = MOB_LAYER
	///The stamp overlay, used to show that the paperwork is complete without making a bunch of sprites
	var/mutable_appearance/stamp_overlay
	///The specific stamp icon to be overlaid on the paperwork
	var/stamp_icon = "paper_stamp-void"
	///The stamp needed to "complete" this form.
	var/stamp_requested = /obj/item/stamp/void
	///Has the paperwork been properly stamped
	var/stamped = FALSE
	///The path to the job of the associated paperwork form
	var/stamp_job
	///Used to store the bonus text that displays when the paperwork's associated role reads it
	var/detailed_desc

/obj/item/paperwork/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("<i>As you sift through the papers, you slowly start to piece together what you're reading.</i>")

/obj/item/paperwork/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(.)
		return

	if(stamped || istype(attacking_item, /obj/item/stamp))
		return

	if(istype(attacking_item, stamp_requested))
		add_stamp()
		to_chat(user, span_notice("You skim through the papers until you find a field reading 'STAMP HERE', and complete the paperwork."))
		return TRUE
	var/datum/action/item_action/chameleon/change/stamp/stamp_action = locate() in attacking_item.actions
	if(isnull(stamp_action))
		to_chat(user, span_warning("You hunt through the papers for somewhere to use [attacking_item], but can't find anything."))
		return TRUE

	to_chat(user, span_notice("[attacking_item] morphs into the appropriate stamp, which you use to complete the paperwork."))
	stamp_action.update_look(stamp_requested)
	add_stamp()
	return TRUE

/obj/item/paperwork/examine_more(mob/user)
	. = ..()

	if(ishuman(user))
		var/mob/living/carbon/human/viewer = user
		if(istype(viewer.mind?.assigned_role, stamp_job)) //Examining the paperwork as the proper job gets you some bonus details
			. += detailed_desc
		else
			if(stamped)
				. += span_info("It looks like these documents have already been stamped. Now they can be returned to Central Command.")
			else
				var/datum/job/stamp_title = stamp_job
				var/title = initial(stamp_title.title)
				. += span_info("Trying to read through it makes your head spin. Judging by the few words you can make out, this looks like a job for the [title].")

/obj/item/paperwork/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins insulting the inefficiency of paperwork and bureaucracy. 看起来是在尝试自杀!"))

	var/obj/item/paper/new_paper = new /obj/item/paper(get_turf(src))
	var/turf/turf_to_throw_at = get_ranged_target_turf(get_turf(src), pick(GLOB.alldirs))
	new_paper.throw_at(turf_to_throw_at, 2)

	var/obj/item/bodypart/BP = user.get_bodypart(pick(BODY_ZONE_HEAD))
	if(BP)
		BP.dismember()
		new_paper.visible_message(span_alert("The [src] launches a sheet of paper, instantly slicing off [user]'s head!"))
	else
		user.visible_message(span_suicide("[user] panics and starts choking to death!"))
		return OXYLOSS

	return MANUAL_SUICIDE

/**
 * Adds the stamp overlay and sets "stamped" to true
 *
 * Adds the stamp overlay to a piece of paperwork, and sets "stamped" to true.
 * Handled as a proc so that an object may be maked as "stamped" even when a stamp isn't present (like the photocopier)
 */
/obj/item/paperwork/proc/add_stamp()
	stamp_overlay = mutable_appearance('icons/obj/service/bureaucracy.dmi', stamp_icon)
	add_overlay(stamp_overlay)
	stamped = TRUE

/**
 * Copies the requested stamp, associated job, and associated icon of a given paperwork type
 *
 * Copies the stamp/job related info of a given paperwork type to the object
 * Used to mutate photocopied/ancient paperwork into behaving like their subtype counterparts without the extra details
 */
/obj/item/paperwork/proc/copy_stamp_info(obj/item/paperwork/paperwork_type)
	stamp_requested = initial(paperwork_type.stamp_requested)
	stamp_job = initial(paperwork_type.stamp_job)
	stamp_icon = initial(paperwork_type.stamp_icon)

//HEAD OF STAFF DOCUMENTS

/obj/item/paperwork/cargo
	stamp_requested = /obj/item/stamp/head/qm
	stamp_job = /datum/job/quartermaster
	stamp_icon = "paper_stamp-qm"

/obj/item/paperwork/cargo/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 这些文件是一堆混乱的装运订单文件。这些文件的排序毫无规律可言.")
	detailed_desc += span_info(" 从表面上看，这里除了一个要求第二台引擎的高优先级请求外，没有什么异常之处.")
	detailed_desc += span_info(" '优先级请求原因'字段被涂掉了，但页边空白处有一条笔记写着'我们只是想试试两台引擎，别担心'.")
	detailed_desc += span_info(" 尽管这些文件杂乱无章，但它们都已被适当填写。你最好在这上面盖个章.")

/obj/item/paperwork/security
	stamp_requested = /obj/item/stamp/head/hos
	stamp_job = /datum/job/head_of_security
	stamp_icon = "paper_stamp-hos"

/obj/item/paperwork/security/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 这堆文件与邻近站点正在处理的一起民事案件有关.")
	detailed_desc += span_info(" 文件要求你审阅由该站律师提交的品行报告.")
	detailed_desc += span_info(" 案件文件详细记录了针对该站安保部门的指控，包括行为不端、骚扰等——")
	detailed_desc += span_info(" 真是一堆废话，安保团队显然只是在做他们必须做的事，你最好在这上面盖个章.")

/obj/item/paperwork/service
	stamp_requested = /obj/item/stamp/head/hop
	stamp_job = /datum/job/head_of_personnel
	stamp_icon = "paper_stamp-hop"

/obj/item/paperwork/service/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 你开始浏览这份文件。这是一份标准的纳米传讯NT-435Z3表格，用于向中央指挥部提出请求.")
	detailed_desc += span_info(" 看来附近的一个站点提交了一份最高优先级的煤炭请求，而且数量之大看似荒谬.")
	detailed_desc += span_info(" 请求中列出的原因似乎是匆忙填写的 -- '寻找为站点供电的替代方法.'")
	detailed_desc += span_info(" 像这样的最高优先级请求可不是什么小事，你最好在这上面盖个章.")

/obj/item/paperwork/medical
	stamp_requested = /obj/item/stamp/head/cmo
	stamp_job = /datum/job/chief_medical_officer
	stamp_icon = "paper_stamp-cmo"

/obj/item/paperwork/medical/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" The stack of documents appear to be a medical report from a nearby station, detailing the autopsy of an unknown xenofauna.")
	detailed_desc += span_info(" Skipping to the end of the report reveals that the specimen was the station bartender's pet monkey.")
	detailed_desc += span_info(" The specimen had been exposed to radiation during an 'unrelated incident with the engine', leading to it's mutated form.")
	detailed_desc += span_info(" Regardless, the autopsy results look like they could be useful. You should probably stamp this.")


/obj/item/paperwork/engineering
	stamp_requested = /obj/item/stamp/head/ce
	stamp_job = /datum/job/chief_engineer
	stamp_icon = "paper_stamp-ce"

/obj/item/paperwork/engineering/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 这些文件是来自邻近站点的电力输出报告，它详细记录了该站点在一个基本轮班期间的电力输出以及其他工程数据.")
	detailed_desc += span_info(" 查看日志时，你注意到电力输出和引擎温度急剧上升，不久后，工程部门周围区域似乎被某种未知力量减压了.")
	detailed_desc += span_info(" 显然，站点的工程部门正在测试一种实验性的引擎设置方式，并且不得不利用附近房间的空气来帮助冷却引擎，完全正确.")
	detailed_desc += span_info(" 哇塞，这真是太厉害了，你最好在这上面盖个章.")

/obj/item/paperwork/research
	stamp_requested = /obj/item/stamp/head/rd
	stamp_job = /datum/job/research_director
	stamp_icon = "paper_stamp-rd"

/obj/item/paperwork/research/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 这些文件详细记录了附近站点进行的一次标准炸弹测试的结果.")
	detailed_desc += span_info(" 随着你进一步阅读，你发现结果中有些奇怪——爆点中心位置似乎不正确.")
	detailed_desc += span_info(" 如果你的计算无误，这次爆炸并非发生在站点的军械库，而是发生在站点的引擎室.")
	detailed_desc += span_info(" 不管怎样，它们仍然是完全可用的测试结果. 你最好在这上面盖个章.")

/obj/item/paperwork/captain
	stamp_requested = /obj/item/stamp/head/captain
	stamp_job = /datum/job/captain
	stamp_icon = "paper_stamp-cap"

/obj/item/paperwork/captain/Initialize(mapload)
	. = ..()

	detailed_desc += span_info(" 这些文件是来自附近站点舰长桌上的一份未签名通信.")
	detailed_desc += span_info(" 这似乎是一条标准的签到信息，报告说该站点正以最佳效率运行.")
	detailed_desc += span_info(" 信息一再声称引擎运行'完全正常'，并且生成了'大量'电力.")
	detailed_desc += span_info(" 所有信息都核实无误，你最好在这上面盖个章.")

//Photocopied paperwork. These are created when paperwork, whether stamped or otherwise, is printed. If it is stamped, it can be sold to cargo at the risk of the paperwork not being accepted (which takes a small fee from cargo).
//If it is unstamped it will lose you money like normal, unless it has been marked with a VOID stamp
/obj/item/paperwork/photocopy
	name = "复印文件"
	desc = "更是一堆杂乱无章的复印文件和文书资料，它们甚至都没有按正确的顺序复印吗"
	stamp_icon = "paper_stamp-pc"
	/// Has the photocopy been marked with a "void" stamp. Used to prevent documents from draining money if they somehow make their way to cargo.
	var/voided = FALSE

/obj/item/paperwork/photocopy/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("这份文书资料上的打印效果使得它几乎完全无法阅读.")

/obj/item/paperwork/photocopy/examine_more(mob/user)
	. = ..()

	if(stamped)
		if(voided)
			. += span_notice("看起来前面已经被标记为‘无效’了，现在恐怕没有人会接受这些文件了.")
		else
			. += span_notice("上面的印章看起来被弄脏了，而且褪色了，中央指挥部应该还是会接受这些文件吧，对吧？")
	else
		. += span_notice("这些看起来只是原始文件的复印件.")

/obj/item/paperwork/photocopy/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/stamp/void) && !stamped && !voided)
		to_chat(user, span_notice("You plant the [attacking_item] firmly onto the front of the documents."))
		stamp_overlay = mutable_appearance('icons/obj/service/bureaucracy.dmi', "paper_stamp-void")
		add_overlay(stamp_overlay)
		voided = TRUE
		stamped = TRUE //It won't get you any money, but it also can't LOSE you money now.
		return

	return ..()

//Ancient paperwork is a subtype of paperwork, meant to be used for any paperwork not spawned by the event.
//It doesn't have any of the flavor text that the event ones spawn with.

/obj/item/paperwork/ancient
	name = "古代文件"
	desc = "这是一堆布满灰尘、丑陋不堪的文件纸屑，你无法从中辨认出任何一个名字、日期或提及的主题，这些到底有多久了？"

/obj/item/paperwork/ancient/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("真的很难判断这些有多旧或者它们是用来做什么的，但无论如何，中央指挥部可能会很重视它们.")

	var/static/list/paperwork_to_use //Make the ancient paperwork function like one of the main types
	if(!paperwork_to_use)
		paperwork_to_use = subtypesof(/obj/item/paperwork)
		paperwork_to_use -= (list(/obj/item/paperwork/ancient, /obj/item/paperwork/photocopy)) //Get rid of the uncopiable paperwork types

	var/obj/item/paperwork/paperwork_type = pick(paperwork_to_use)
	copy_stamp_info(paperwork_type)
