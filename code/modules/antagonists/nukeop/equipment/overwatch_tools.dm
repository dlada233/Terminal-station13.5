///One of the special items that spawns in the overwatch agent's room.
/obj/item/paper/fluff/overwatch
	name = "监听员指南 #1"
	color = COLOR_RED
	desc = "辛迪加领导层有关你新工作的一些注意事项!"
	default_raw_text = @{"
恭喜你!你现在位于对纳米传讯自杀任务中唯一的幸存者位置!
好吧，开个玩笑，这类任务往往有着异常高的存活率，但我想这也能提醒你和你的队伍要面对的困难有多严峻.
<br>
你的任务是为空间站队员提供情报支持.
每个行动人员都配备了随身摄像头，可以通过你的照管终端访问.
另外，你已预先拥有可以访问空间站警报、摄像头以及远程操控渗透者号的电路板，
<br>
按你的喜好随意搭建你进行监听工作的场所，在后屋也有你需要的工具和材料.
<br>
祝狩猎愉快!
	"}

/obj/machinery/computer/security/overwatch
	name = "照管终端"
	desc = "你可以在上面调用你队友的随身摄像头，这些所谓摄像头实际是一群微型无人摄像机. \
		敌人要么压根注意不到这些无人机，要么注意到了也打不中."
	icon_screen = "commsyndie"
	icon_keyboard = "syndie_key"
	network = list(OPERATIVE_CAMERA_NET)
	circuit = /obj/item/circuitboard/computer/overwatch

/obj/item/circuitboard/computer/overwatch
	name = "照管随身摄像机"
	build_path = /obj/machinery/computer/security/overwatch
	greyscale_colors = CIRCUIT_COLOR_SECURITY

/obj/item/circuitboard/computer/syndicate_shuttle_docker
	name = "穿梭机控制"
	build_path = /obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	greyscale_colors = CIRCUIT_COLOR_SECURITY

/obj/item/clothing/glasses/overwatch
	name = "智能眼镜"
	desc = "非常先进的墨镜，能显示几乎任何你的看到的东西的详细数据. \
		由于提供信息过于丰富，持续佩戴几个小时可能会让使用者偏头痛."
	icon_state = "sunhudmed"
	flags_cover = GLASSESCOVERSEYES
	flash_protect = FLASH_PROTECTION_WELDER
	clothing_traits = list(TRAIT_REAGENT_SCANNER)
	var/list/hudlist = list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_SECURITY_ADVANCED)
