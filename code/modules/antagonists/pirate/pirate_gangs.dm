///global lists of all pirate gangs that can show up today. they will be taken out of the global lists as spawned so dupes cannot spawn.
GLOBAL_LIST_INIT(light_pirate_gangs, init_pirate_gangs(is_heavy = FALSE))
GLOBAL_LIST_INIT(heavy_pirate_gangs, init_pirate_gangs(is_heavy = TRUE))

///initializes the pirate gangs glob list, adding all subtypes that can roll today.
/proc/init_pirate_gangs(is_heavy)
	var/list/pirate_gangs = list()

	for(var/type in subtypesof(/datum/pirate_gang))
		var/datum/pirate_gang/possible_gang = new type
		if(!possible_gang.can_roll())
			qdel(possible_gang)
		else if(possible_gang.is_heavy_threat == is_heavy)
			pirate_gangs += possible_gang
	return pirate_gangs

///datum for a pirate team that is spawning to attack the station.
/datum/pirate_gang
	///name of this gang, for spawning feedback
	var/name = "太空渣滓"

	///Whether or not this pirate crew is a heavy-level threat
	var/is_heavy_threat = FALSE
	///the random ship name chosen from pirates.json
	var/ship_name
	///the ship they load in on.
	var/ship_template_id = "ERROR"
	///the key to the json list of pirate names
	var/ship_name_pool = "some_json_key"
	///inbound message title the station receives
	var/threat_title = "赶走这帮太空渣滓"
	///the contents of the message sent to the station.
	///%SHIPNAME in the content will be replaced with the pirate ship's name
	///%PAYOFF in the content will be replaced with the requested credits.
	var/threat_content = "这里是%SHIPNAME. 交出%PAYOFF信用点，不然我们就灭了整个宇宙!"
	///station receives this message upon the ship's spawn
	var/arrival_announcement = "我们为了要点票子而来!"
	///what the station can say in response, first item pays the pirates, second item rejects it.
	var/list/possible_answers = list("请离开，我们付钱!", "拿你的头盖骨当碗使.")

	///station responds to message and pays the pirates
	var/response_received = "Yum! 票子到手!"
	///station responds to message and pays the pirates
	var/response_rejected = "Foo! 票子飞了!"
	///station pays the pirates, but after the ship spawned
	var/response_too_late = "你的票子来得太迟了，开始重启世界..."
	///station pays the pirates... but doesn't have enough cash.
	var/response_not_enough = "打给我的银行账户里的票子不够，开始重启世界..."

	/// Have the pirates been paid off?
	var/paid_off = FALSE
	/// The colour of their announcements when sent to players
	var/announcement_color = "red"

/datum/pirate_gang/New()
	. = ..()
	ship_name = pick(strings(PIRATE_NAMES_FILE, ship_name_pool))

///whether this pirate gang can roll today. this is called when the global list initializes, so
///returning FALSE means it cannot show up at all for the entire round.
/datum/pirate_gang/proc/can_roll()
	return TRUE

///returns a new comm_message datum from this pirate gang
/datum/pirate_gang/proc/generate_message(payoff)
	var/built_threat_content = replacetext(threat_content, "%SHIPNAME", ship_name)
	built_threat_content = replacetext(built_threat_content, "%PAYOFF", payoff)
	return new /datum/comm_message(threat_title, built_threat_content, possible_answers)

///classic FTL-esque space pirates.
/datum/pirate_gang/rogues
	name = "海盗"

	ship_template_id = "default"
	ship_name_pool = "rogue_names"

	threat_title = "星区保护要约"
	threat_content = "嘿，伙计, 这里是%SHIPNAME. 不得不注意到你有一艘狂野且没有保险的运输船！ 好TM疯狂，如果它出了事怎么办，嗯?!\
		我们对你们在这个领域的保险费率做了一个快速评估，我们报价%PAYOFF来为你的运输船提供保险."
	arrival_announcement = "你想重新考虑我们的报价? 很遗憾，谈判时间结束了. 开门；因为我们马上要上来了."
	possible_answers = list("购买保险.","拒绝报价.")

	response_received = "白来的甜美票子.我们走吧，兄弟们."
	response_rejected = "不付钱是个错误，现在你该去上上经济学课了."
	response_too_late = "不管你付不付钱，无视是轻蔑我们的尊严. 现在是时候让大家学会尊重了."
	response_not_enough = "你以为少付几个子我们不会发现吗？可爱，我们很快就会见面的."

///aristocrat lizards looking to hunt the serfs
/datum/pirate_gang/silverscales
	name = "银鳞"

	ship_template_id = "silverscale"
	ship_name_pool = "silverscale_names"

	threat_title = "征募"
	threat_content = "这里是%SHIPNAME. 银鳞大人想要你们当地的平民蜥蜴献上贡品，\
		%PAYOFF信用点就能做到."
	arrival_announcement = "显然，你们的船上不适合装那么多东西. 还是放到我们这里来吧!"
	possible_answers = list("我们会付的.","贡品? 真假? 滚.")

	response_received = "非常慷慨的捐赠，愿缇兹拉之爪直抵寰宇尽头."
	response_rejected = "徒劳无用，我们狩猎的第一条原则就是不空手而归."
	response_too_late = "我知道你们想付钱，但狩猎已经开始了."
	response_not_enough = "你们发出了侮辱性的\"捐赠\". 对你们的狩猎已经开始了."

///undead skeleton crew looking for booty
/datum/pirate_gang/skeletons
	name = "骷髅海盗"

	is_heavy_threat = TRUE
	ship_template_id = "dutchman"
	ship_name_pool = "skeleton_names" //just points to THE ONE AND ONLY

	threat_title = "货物转让"
	threat_content = "Ahoy! 这里是%SHIPNAME. 交出%PAYOFF信用点，不然就走木板."
	arrival_announcement = "大家伙，骷髅旗不会一直等你们的；我们躺在一起，准备给你们先来点礼物."
	possible_answers = list("我们会付的.","勒索我们没门.")

	response_received = "感谢信用点，旱鸭子们."
	response_rejected = "啊呀! 准备接敌，我们要抢上一笔啦!"
	response_too_late = "求饶得太晚啦!"
	response_not_enough = "耍我们? 你们会后悔的!"

///Expirienced formed employes of Interdyne Pharmaceutics now in a path of thievery and reckoning
/datum/pirate_gang/interdyne
	name = "不安分的前药学家"

	is_heavy_threat = TRUE
	ship_template_id = "ex_interdyne"
	ship_name_pool = "interdyne_names"

	threat_title = "研究经费"
	threat_content = "幸会，这里是%SHIPNAME. 我们的制药业务需要一些资金. \
		%PAYOFF信用点应该足够了."
	arrival_announcement = "我们谦卑地请求一笔收入，只是用于我们事业的未来研究. 但很遗憾看到你们已经病了，我们将治好它."
	possible_answers = list("好的.","自己去找个班上吧!")

	response_received = "感谢你们的慷慨，你们的钱不会被浪费."
	response_rejected = "啊，你们不是空间站，你们是块肿瘤. 就让我们来切了它吧."
	response_too_late = "希望你们喜欢皮肤癌!"
	response_not_enough = "对于我们的业务来说这远远不够. 恐怕我们得再借一点了."
	announcement_color = "purple"

///Previous Nanotrasen Assitant workers fired for many reasons now looking for revenge and your bank account.
/datum/pirate_gang/grey
	name = "灰潮"

	ship_template_id = "grey"
	ship_name_pool = "grey_names"

	threat_title = "这是抢劫"
	threat_content = "嘿，这里是%SHIPNAME. 把钱交出来. \
		%PAYOFF应该差不多."
	arrival_announcement = "你们那儿东西不错，现在归我们了."
	possible_answers = list("请不要伤害我们.","必将你绳之以法!!")

	response_received = "等等，你们真的给我们钱了？谢谢，但我们还是要来拿剩下的!"
	response_rejected = "绳之以法? 我们就是法! 我们判你有罪!"
	response_too_late = "不管，嗯？准备迎接潮水吧!"
	response_not_enough = "想骗我们？好吧，拿你们的空间站做抵押吧."
	announcement_color = "yellow"


///Agents from the space I.R.S. heavily armed to stea- I mean, collect the station's tax dues
/datum/pirate_gang/irs
	name = "太空国税局"

	is_heavy_threat = TRUE
	ship_template_id = "irs"
	ship_name_pool = "irs_names"

	threat_title = "漏缴税款"
	threat_content = "这里是%SHIPNAME，我们注意到你们的空间站一直没有缴纳税款.. \
		让我们纠正这个问题吧，你们拖欠的税款总额为%PAYOFF，强烈建议你们立刻缴纳税款，我们不需要派队伍去你们空间站上解决问题，对吧？"
	arrival_announcement = "这里是税务冲突处理团队，如果您未能及时缴清税款，请做好被资产清算和因税务欺诈被捕的准备吧."
	possible_answers = list("我正准备付呢. 多谢提醒!","我不管你国税局派谁来，我才不交税呢!")

	response_received = "收到付款，我们向你们致敬，你们是依法纳税的好公民."
	response_rejected = "我们明白了，我们会派一队人去你们的空间站上解决这件事的."
	response_too_late = "太晚了，已经派出A队去直接解决事件了."
	response_not_enough = "你们报错税了，我们派了一队人来协助你们清算资产并以税务欺诈逮捕你们. 我们秉公执法，孩子."
	announcement_color = "yellow"

//Mutated Ethereals who have adopted bluespace technology in all the wrong ways.
/datum/pirate_gang/lustrous
	name = "晶洞清道夫"

	ship_template_id = "geode"
	ship_name_pool = "geode_names"

	threat_title = "不同寻常的传播信号"
	threat_content = "母空水晶破裂了，%SHIPNAME浮现而出. 我们是闪耀者，水晶王的手臂.\
		我们的蓝空尘库存低迷，因此，合成不得不暂停. 支付%PAYOFF将解决这个问题!"
	arrival_announcement = "我们无处不在，我们无时不在."
	possible_answers = list("哈啊...行."," 我们没空陪你们瞎扯，走开.")


	response_received = "出色的传输，合成将会恢复."
	response_rejected = "你们讲话粗鲁无礼需要加以纠正，我们这就开始."
	response_too_late = "你们错过了付钱的彼时，于是顺流而来了此刻的我们."
	response_not_enough = "你们侮辱了我们，我们之间不会有仇恨，只有及时的正义!"
	announcement_color = "purple"

//medieval militia, from OUTER SPACE!
/datum/pirate_gang/medieval
	name = "中世纪战团"

	is_heavy_threat = TRUE
	ship_template_id = "medieval"
	ship_name_pool = "medieval_names"

	threat_title = "快交钱"
	threat_content = "幸会，这里是正在刮地皮的%SHIPNAME，这次遇着你们了!! \
		通常情况下，咱会直接杀光擅闯咱土地的懦夫. \
		但咱也可以对你在咱星域表示欢迎，前提是给咱 %PAYOFF 以表示对咱规矩的尊重!! \
		好好做出明智的选择吧!!(发送消息. 发送消息. 为啥消息没发送啊?)."
	arrival_announcement = "咱刚刚搞懂咋驾驶飞船了，咱马上就会到你那儿!!"
	possible_answers = list("好吧，我还是希望自己的头盖骨留在头上.","弱智，去别处睡觉吧.")

	response_received = "这就够啦，记住谁拥有你们!!"
	response_rejected = "蠢货，咱要拿你杀鸡儆猴!! (有人记得怎么驾驶飞船嘛?)"
	response_too_late = "你已经被包围了蠢货，你们是有病还是无知?!!"
	response_not_enough = "当我小丑吗? 你死定了!! (草了我忘了怎么开船了.)"
