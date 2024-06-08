/obj/item/pinpointer/crew/contractor
	name = "契约指针"
	desc = "一个手持跟踪设备，可以锁定某些信号. 忽略防护服传感器，但精度低得多. "
	icon_state = "pinpointer_syndicate"
	worn_icon_state = "pinpointer_black"
	minimum_range = 25
	has_owner = TRUE
	ignore_suit_sensor_level = TRUE

/obj/item/storage/box/contractor/fulton_extraction
	name = "富尔顿回收套件"
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/contractor/fulton_extraction/PopulateContents()
	new /obj/item/extraction_pack/syndicate(src)
	new /obj/item/fulton_core(src)

/obj/item/paper/contractor_guide
	name = "契约指南"
	default_raw_text = {"欢迎你特工，祝贺你成为新的契约特工. 除了你已经被分配的任务外，这个套件还将为你提供额外可接受的契约，以赚得TC.\
	<p>我们提供了专用的契约太空服. 它更紧凑，可以放入口袋，比你在上行链路中可以获得的辛迪加太空服移动更快. 我们还为你提供了变色龙连体服和面具，这两者都可以根据需要随时更换. 香烟里有特殊混合成分——它会随着时间的推移缓慢治愈你的伤口. </p>\
	<p>你的标准契约警棍比一般电棍的更好用，可能会成为你绑架目标的首选武器. 三个附加物品是从我们现有的物品中随机挑选的. 希望它们对你的任务有用. </p>\
	<p>契约hub位于上行链路的右上角，提供独特的物品和能力. 这些是用契约声望购买的，每次完成契约时都会提供两点声望. </p>\
	<h3>使用平板电脑</h3>\
	<ol>\
		<li>打开辛迪加契约上行程序. </li>\
		<li>在这里，你可以接受契约，并从已完成的契约中领取TC报酬. </li>\
		<li>括号中显示的支付金额是交付时，目标<b>活着</b>获得的额外奖励. 不过不管目标是活着还是死了，只要交付你都会收到括号外数额的报酬. </li>\
		<li>通过将目标带到指定的交付点、呼叫回收并将他们放入舱内来完成契约. </li>\
	</ol>\
	<p>接受契约时要慎重. 虽然你可以看到交付点的位置，但取消契约将使其无法再次接受. </p>\
	<p>平板电脑也可以在任何电池充电器上充电. </p>\
	<h3>回收</h3>\
	<ol>\
		<li>确保你和目标都在交付点. </li>\
		<li>呼叫回收，并从交付点后退. </li>\
		<li>如果失败，确保你的目标在点里面，并且有足够空间让回收舱降落. </li>\
		<li>抓住你的目标并将其拖入舱内. </li>\
	</ol>\
	<h3>赎金</h3>\
	<p>指定什么目标是出于我们自己的一些原因，在我们用完该目标后，我们会开出价码让其组织赎回目标，他们会在几分钟内从你送走他们的地方返回. 别担心，你也能从赎金里得到分成，分成将打到你所装备的任何ID卡上，此外还会支付给你TC. </p>\
	<p>祝你好运，特工. 你可以用附带的打火机烧掉这份文件. </p>"}
