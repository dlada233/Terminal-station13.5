// Slightly improved version of the normal RCD, mostly as an engineering 'I got hella bread' purchase
/obj/item/construction/rcd/improved
	name = "Improved RCD 改进型"
	desc = "一种用于快速建造和拆卸的手持设备，以牺牲建造速度为代价换来了更大的材料储存空间，可使用铁、塑钢、玻璃或压缩物质仓进行装填."
	icon_state = "ircd"
	inhand_icon_state = "ircd"
	max_matter = 220
	matter = 220
	delay_mod = 1.3
	upgrade = RCD_UPGRADE_FRAMES | RCD_UPGRADE_SIMPLE_CIRCUITS
