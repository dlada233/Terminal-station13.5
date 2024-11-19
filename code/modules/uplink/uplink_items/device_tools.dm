/datum/uplink_category/device_tools
	name = "杂项.小工具"
	weight = 3

/datum/uplink_item/device_tools
	category = /datum/uplink_category/device_tools

/datum/uplink_item/device_tools/soap
	name = "辛迪加肥皂"
	desc = "一种看起来很邪恶的肥皂，用于清除血迹阻止案件侦破，你也可以把它放在地上让人滑倒."
	item = /obj/item/soap/syndie
	cost = 1
	surplus = 50
	illegal_tech = FALSE

/datum/uplink_item/device_tools/surgerybag
	name = "辛迪加手术行李袋"
	desc = "辛迪加手术帆布袋是包含所有手术工具、手术布、辛迪加牌MMI、束缚衣和口套."
	item = /obj/item/storage/backpack/duffelbag/syndie/surgery
	cost = 4
	surplus = 66

/datum/uplink_item/device_tools/encryptionkey
	name = "辛迪加密密钥"
	desc = "一个加密密钥，当插入无线电耳机时，允许你收听所有部门频道，并且还向你开放辛迪加通讯频道. 此外，这把钥匙还可以保护你的耳机免受无线电干扰."
	item = /obj/item/encryptionkey/syndicate
	cost = 2
	surplus = 75
	restricted = TRUE

/datum/uplink_item/device_tools/syndietome
	name = "辛迪加之书"
	desc = "辛迪加花费巨大的代价获得的稀有神器，对某种邪教的神奇书籍进行了逆向工程，\
		虽然缺乏原始版本的神秘能力，但这些低级副本仍然非常有用，能够在战场上降下幸与祸，但不足点在于它们偶尔会咬掉手指."
	item = /obj/item/book/bible/syndicate
	cost = 5

/datum/uplink_item/device_tools/tram_remote
	name = "电车远程控制"
	desc = "当连接到有轨电车的车载计算机系统时，该设备允许用户远程操作控制.包括方向切换和急速模式，以电车事故的名义制造意外死亡是再合适不过了!"
	item = /obj/item/assembly/control/transport/remote
	cost = 2

/datum/uplink_item/device_tools/thermal
	name = "热成像眼镜"
	desc = "这些护目镜可以伪装成空间站里常见的眼镜，它们通过捕捉物体的光热将其转化为一种特殊光，让你透过墙壁看到生物. \
			较热的物体，如赛博和人工智能核心，比墙壁和气闸等较冷的物体发出更多的这种光."
	item = /obj/item/clothing/glasses/thermal/syndi
	cost = 4

/datum/uplink_item/device_tools/cutouts
	name = "自适应纸板"
	desc = "这些纸板剪纸上涂有一层材料，防止变色的同时让图像看起来更逼真，这个包包含三个纸板和一个蜡笔用来改变纸板形象的蜡笔."
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/* // SKYRAT EDIT REMOVAL
/datum/uplink_item/device_tools/briefcase_launchpad
	name = "Briefcase Launchpad"
	desc = "A briefcase containing a launchpad, a device able to teleport items and people to and from targets up to eight tiles away from the briefcase. \
			Also includes a remote control, disguised as an ordinary folder. Touch the briefcase with the remote to link it."
	surplus = 0
	item = /obj/item/storage/briefcase/launchpad
	cost = 6

/datum/uplink_item/device_tools/syndicate_teleporter
	name = "Experimental Syndicate Teleporter"
	desc = "A handheld device that teleports the user 4-8 meters forward. \
			Beware, teleporting into a wall will trigger a parallel emergency teleport; \
			however if that fails, you may need to be stitched back together. \
			Comes with 4 charges, recharges randomly. Warranty null and void if exposed to an electromagnetic pulse."
	item = /obj/item/storage/box/syndie_kit/syndicate_teleporter
	cost = 8
*/ //END SKYRAT EDIT

/datum/uplink_item/device_tools/camera_app
	name = "SyndEye-辛迪之眼"
	desc = "一个包含应用程序的数据软盘，该应用程序可以让您观看摄像头并跟踪船员."
	item = /obj/item/computer_disk/syndicate/camera_app
	cost = 1
	surplus = 90
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/military_belt
	name = "胸挂"
	desc = "一套坚固的七槽胸挂，能够容纳各种战术装备."
	item = /obj/item/storage/belt/military
	cost = 1

/datum/uplink_item/device_tools/doorjack
	name = "气闸认证覆写卡"
	desc = "一种特殊的密码序列器，专门设计用于覆写空间站气闸门访问密码，在破解了一定数量的气闸后，设备将需要一些时间来充电."
	item = /obj/item/card/emag/doorjack
	cost = 3

/datum/uplink_item/device_tools/fakenucleardisk
	name = "诱饵核软盘"
	desc = "这只是一个普通的软盘，远看它和真的一模一样，但在舰长的仔细检查下，它就站不住脚了；不要试图用这个来完成你的目标，糊弄鬼呢!"
	item = /obj/item/disk/nuclear/fake
	cost = 1
	surplus = 1
	illegal_tech = FALSE

/datum/uplink_item/device_tools/frame
	name = "F.R.A.M.E.软盘"
	desc = "当你把F.R.A.M.E.软盘插入一台具有发信功能的设备上时，将能在短信界面发送五次病毒. \
			当你发送携带病毒的短信后，收到短信的设备将会被植入一个0Tc的上行链路，并立刻进入链路页面. \
			而你则会立刻收到进入链路页面的解锁密码，一般在短信铃声中输入，此外，你可以将Tc存入软盘，这样发送病毒时生成的上行链路就将自带Tc.\
			这个物品常用于特工创建备用上行链路."
	item = /obj/item/computer_disk/virus/frame
	cost = 4
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/frame/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	. = ..()
	var/obj/item/computer_disk/virus/frame/target = .
	if(!target)
		return
	target.current_progression = uplink_handler.progression_points

/datum/uplink_item/device_tools/failsafe
	name = "上行链路自毁代码"
	desc = "当输入后立刻销毁上行链路."
	item = ABSTRACT_UPLINK_ITEM
	cost = 1
	surplus = 0
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/failsafe/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	var/datum/component/uplink/uplink = source.GetComponent(/datum/component/uplink)
	if(!uplink)
		return
	if(!uplink.unlock_note) //no note means it can't be locked (typically due to being an implant.)
		to_chat(user, span_warning("此设备不支持代码输入!"))
		return

	uplink.failsafe_code = uplink.generate_code()
	var/code = "[islist(uplink.failsafe_code) ? english_list(uplink.failsafe_code) : uplink.failsafe_code]"
	var/datum/antagonist/traitor/traitor_datum = user.mind?.has_antag_datum(/datum/antagonist/traitor)
	if(traitor_datum)
		traitor_datum.antag_memory += "<b>上行链路自毁代码:</b> [code]" + "<br>"
		traitor_datum.update_static_data_for_all_viewers()
	to_chat(user, span_warning("这条上行链路的新自毁代码是: [code].[traitor_datum ? " 你可以查看你的反派信息来回忆." : null]"))
	return source //For log icon

/datum/uplink_item/device_tools/toolbox
	name = "辛迪加工具箱"
	desc = "辛迪加的工具箱使用了可疑的红黑相间色，里面配备了一套包括多功能工具和绝缘的战术手套等一系列工具."
	item = /obj/item/storage/toolbox/syndicate
	cost = 1
	illegal_tech = FALSE

/datum/uplink_item/device_tools/rad_laser
	name = "放射性微型激光器"
	desc = "放射性微激光器被伪装成了健康分析仪的样子，它可以使人在一段可自定义的延迟后失去行动能力，其作用原理如下: \
			在使用时，它会释放出强烈的辐射，除非做了完全防护，否则所有人都会丧失行动能力. \
			它有两个设置选项：强度（用以控制辐射的功率）、波长（控制触发效果的延迟时间）."
	item = /obj/item/healthanalyzer/rad_laser
	cost = 3
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/* SKYRAT EDIT REMOVAL - It's laggy and doesn't really add much roleplay value
/datum/uplink_item/device_tools/suspiciousphone
	name = "Protocol CRAB-17 Phone"
	desc = "The Protocol CRAB-17 Phone, a phone borrowed from an unknown third party, it can be used to crash the space market, funneling the losses of the crew to your bank account.\
	The crew can move their funds to a new banking site though, unless they HODL, in which case they deserve it."
	item = /obj/item/suspiciousphone
	restricted = TRUE
	cost = 7
	limited_stock = 1
*/ // SKYRAT EDIT REMOVAL END

/datum/uplink_item/device_tools/binary
	name = "二进制转译密钥"
	desc = "这是一种无线电密钥，插入耳机后对你开放AI与Cyborg等机械生命的交流频道，\
			只是偷听的话是不会被发现的，但在决定发言前请务必谨慎，\
			因为除非它们与你结盟，否则它们会报告你的行为."
	item = /obj/item/encryptionkey/binary
	cost = 5
	surplus = 75
	restricted = TRUE

/datum/uplink_item/device_tools/emag
	name = "加密定序器"
	desc = "你可以叫它加密定序器、电磁卡或者EMAG，这张小卡片可以解锁电子设备中的各种隐藏功能、破坏预定功能以及骇入解锁(气闸门除外)."
	item = /obj/item/card/emag
	cost = 4

/datum/uplink_item/device_tools/stimpack
	name = "加速剂"
	desc = "Stimpacks-加速剂，成就了许多伟大英雄的药剂，让你在注射后五分钟内跑得飞快且几乎免疫眩晕和击倒."
	item = /obj/item/reagent_containers/hypospray/medipen/stimulants
	cost = 5
	surplus = 90

/datum/uplink_item/device_tools/super_pointy_tape
	name = "超级尖锐胶带"
	desc = "一个万能的超级尖胶带，这种胶带上有数百个微小的金属倒刺，可以分成五次使用，\
			你可以把它粘到物品上，这样当你把该物品扔出去时，它就会粘在他们身上，如果被扯下来还会伤到他们."
	item = /obj/item/stack/sticky_tape/pointy/super
	cost = 1

/datum/uplink_item/device_tools/hacked_module
	name = "被骇入的AI法令上传模块"
	desc = "当与上传控制台一起使用时，该模块允许您将特别优先法令上传到AI. \
			在输入法令时措辞要小心，因为AI可能会寻找漏洞加以利用."
	progression_minimum = 30 MINUTES
	item = /obj/item/ai_module/syndicate
	cost = 4

/datum/uplink_item/device_tools/hypnotic_flash
	name = "催眠闪光灯"
	desc = "一种能催眠目标的改良闪光灯，但如果目标不是处于精神脆弱的状态，闪他们只能导致暂时的眩晕."
	item = /obj/item/assembly/flash/hypnotic
	cost = 7

/datum/uplink_item/device_tools/hypnotic_grenade
	name = "催眠闪光弹"
	desc = "一种改进的闪光弹，能够催眠目标，闪光弹的声音部分会引起幻觉，并诱导受害者进入催眠状态."
	item = /obj/item/grenade/hypnotic
	cost = 12

/datum/uplink_item/device_tools/singularity_beacon
	name = "电力灯塔"
	desc = "当拧到电网中的电线上并激活时，这个大型设备会将任何活跃的引力奇点或特斯拉球拉向它，\
			当然，当超物质引擎还在正常运行时，这是行不通的. 由于它的大小，它不能被收纳和拿在手里. \
			所以我们会先给你一个小型信标，在激活后电力灯塔将直接传送到你的脚下."
	progression_minimum = 30 MINUTES
	item = /obj/item/sbeacondrop
	cost = 10
	surplus = 0 // not while there isnt one on any station
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/device_tools/powersink
	name = "电力汲取器"
	desc = "当拧到电网中的电线上并激活时，这个大型设备就会亮起来，极大地增加了电网负载，最终导致全站停电，\
			由于它的大小，它不能被存到普通的口袋中；此外，如果电网中有太多电力，将会发生爆炸."
	progression_minimum = 20 MINUTES
	item = /obj/item/powersink
	cost = 11

/datum/uplink_item/device_tools/syndicate_contacts
	name = "偏光隐形眼镜"
	desc = "高科技隐形眼镜可以直接与眼睛表面贴合，使眼睛免受强光的伤害，并且几乎无法被探测到."
	item = /obj/item/syndicate_contacts
	cost = 3

/datum/uplink_item/device_tools/syndicate_climbing_hook
	name = "辛迪加攀岩钩"
	desc = "高科技的绳索，精致的挂钩，攀爬技术的巅峰，只适用于爬洞."
	item = /obj/item/climbing_hook/syndicate
	cost = 1
