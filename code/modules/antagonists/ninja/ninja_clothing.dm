/**
 * # Ninja Mask
 *
 * Space ninja's mask.  Other than looking cool, doesn't do anything.
 *
 * A mask which only spawns as a part of space ninja's starting kit.  Functions as a gas mask.
 *
 */
/obj/item/clothing/mask/gas/ninja
	name = "忍者面具"
	desc = "贴身的纳米强化面罩，既是空气过滤器也是后现代时尚."
	icon_state = "ninja"
	inhand_icon_state = "sechailer"
	strip_delay = 12 SECONDS
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	has_fov = FALSE

/obj/item/clothing/under/syndicate/ninja
	name = "忍者装"
	desc = "纳米强化连身衣，兼顾了舒适性和战术性."
	icon_state = "ninja_suit"
	strip_delay = 12 SECONDS
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	can_adjust = FALSE
