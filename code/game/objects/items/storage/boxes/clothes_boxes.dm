// This contains all boxes that will possess something wearable, like an outfit or something similar.area

/obj/item/storage/box/gloves
	name = "乳胶手套盒"
	desc = "内含无菌乳胶手套."
	illustration = "latex"

/obj/item/storage/box/gloves/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/gloves/latex(src)

/obj/item/storage/box/masks
	name = "无菌口罩盒"
	desc = "这个盒子里装有无菌医用口罩."
	illustration = "sterile"

/obj/item/storage/box/masks/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/storage/box/rxglasses
	name = "眼镜盒"
	desc = "这个盒子里装的是近视眼镜."
	illustration = "glasses"

/obj/item/storage/box/rxglasses/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/tape_wizard
	name = "Tape Wizard - Episode 23"
	desc = "A box containing the costume used by legendary entertainment icon 'Super Tape Wizard'. It got a little stuck on its way out."

/obj/item/storage/box/tape_wizard/PopulateContents()
	new /obj/item/clothing/head/wizard/tape/fake(src)
	new /obj/item/clothing/suit/wizrobe/tape/fake(src)
	new /obj/item/staff/tape(src)
	new /obj/item/stack/sticky_tape(src)

/obj/item/storage/box/fakesyndiesuit
	name = "太空套装盒"
	desc = "一个光滑、结实的盒子，用来装太空服的复制品."
	icon_state = "syndiebox"
	illustration = "syndiesuit"

/obj/item/storage/box/fakesyndiesuit/PopulateContents()
	new /obj/item/clothing/head/syndicatefake(src)
	new /obj/item/clothing/suit/syndicatefake(src)

/obj/item/storage/box/syndie_kit/space_dragon/PopulateContents()
	new /obj/item/dna_probe/carp_scanner(src)
	new /obj/item/clothing/suit/hooded/carp_costume/spaceproof/old(src)
	new /obj/item/clothing/mask/gas/carp(src)

/obj/item/storage/box/deputy
	name = "警用袖章盒"
	desc = "发给代理安保人员."
	icon_state = "secbox"
	illustration = "depband"

/obj/item/storage/box/deputy/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/clothing/accessory/armband/deputy(src)

/obj/item/storage/box/hero
	name = "Courageous Tomb Raider - 1940's."
	desc = "This legendary figure of still dubious historical accuracy is thought to have been a world-famous archeologist who embarked on countless adventures in far away lands, along with his trademark whip and fedora hat."

/obj/item/storage/box/hero/PopulateContents()
	new /obj/item/clothing/head/fedora/curator(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/clothing/suit/jacket/curator(src)
	new /obj/item/clothing/under/rank/civilian/curator/treasure_hunter(src)
	new /obj/item/melee/curator_whip(src)

/obj/item/storage/box/hero/astronaut
	name = "First Man on the Moon - 1960's."
	desc = "One small step for a man, one giant leap for mankind. Relive the beginnings of space exploration with this fully functional set of vintage EVA equipment."

/obj/item/storage/box/hero/astronaut/PopulateContents()
	new /obj/item/clothing/suit/space/nasavoid(src)
	new /obj/item/clothing/head/helmet/space/nasavoid(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/gps(src)

/obj/item/storage/box/hero/scottish
	name = "Braveheart, the Scottish rebel - 1300's."
	desc = "Seemingly a legendary figure in the battle for Scottish independence, this historical figure is closely associated with blue facepaint, big swords, strange man skirts, and his ever enduring catchphrase: 'FREEDOM!!'"

/obj/item/storage/box/hero/scottish/PopulateContents()
	new /obj/item/claymore/weak/ceremonial(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/under/costume/kilt(src)
	new /obj/item/toy/crayon/spraycan(src)

/obj/item/storage/box/hero/carphunter
	name = "Carp Hunter, Wildlife Expert - 2506."
	desc = "Despite his nickname, this wildlife expert was mainly known as a passionate environmentalist and conservationist, often coming in contact with dangerous wildlife to teach about the beauty of nature."

/obj/item/storage/box/hero/carphunter/PopulateContents()
	new /obj/item/clothing/mask/gas/carp(src)
	new /obj/item/clothing/suit/hooded/carp_costume/spaceproof/old(src)
	new /obj/item/knife/hunting(src)
	new /obj/item/storage/box/papersack/meat(src)

/obj/item/storage/box/hero/mothpioneer
	name = "Mothic Fleet Pioneer - 2100's."
	desc = "Some claim that the fleet engineers are directly responsible for most modern advancements in spacefaring designs. Although the exact details of their past contributions are somewhat fuzzy, their ingenuity remains unmatched and unquestioned to this day."

/obj/item/storage/box/hero/mothpioneer/PopulateContents()
	new /obj/item/clothing/head/mothcap(src)
	new /obj/item/clothing/suit/mothcoat/original(src)
	new /obj/item/crowbar(src)
	new /obj/item/flashlight/lantern(src)
	new /obj/item/screwdriver(src)
	new /obj/item/stack/sheet/glass/fifty(src)
	new /obj/item/stack/sheet/iron/fifty(src)
	new /obj/item/wrench(src)

/obj/item/storage/box/hero/etherealwarden
	name = "Ethereal Trailwarden - 2450's."
	desc = "Many fantastical stories are told of valiant trail wardens, even by offworlders who, thanks to their guidance, avoided an untimely demise while traveling the sometimes treacherous roads of Sprout. In truth their job entails far more walking and fixing roads than slaying dragons, but it is no less important and well respected: keeping the roads and trails safe and well maintained is for many settlements a matter of survival."

/obj/item/storage/box/hero/etherealwarden/PopulateContents()
	new /obj/item/clothing/suit/hooded/ethereal_raincoat/trailwarden(src)
	new /obj/item/clothing/under/ethereal_tunic/trailwarden(src)
	new /obj/item/storage/backpack/saddlepack(src)

/obj/item/storage/box/holy
	name = "圣骑士装备"
	/// This item is used to generate a preview image for this set.
	/// It could be any item, doesn't even necessarily need to be something in the kit
	var/obj/item/typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/templar

/obj/item/storage/box/holy/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain(src)
	new /obj/item/clothing/suit/chaplainsuit/armor/templar(src)

/obj/item/storage/box/holy/clock
	name = "被遗忘的装备"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/clock

/obj/item/storage/box/holy/clock/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain/clock(src)
	new /obj/item/clothing/suit/chaplainsuit/armor/clock(src)

/obj/item/storage/box/holy/student
	name = "亵渎学者装备"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/studentuni

/obj/item/storage/box/holy/student/PopulateContents()
	new /obj/item/clothing/suit/chaplainsuit/armor/studentuni(src)
	new /obj/item/clothing/head/helmet/chaplain/cage(src)

/obj/item/storage/box/holy/sentinel
	name = "Stone Sentinel Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/ancient

/obj/item/storage/box/holy/sentinel/PopulateContents()
	new /obj/item/clothing/suit/chaplainsuit/armor/ancient(src)
	new /obj/item/clothing/head/helmet/chaplain/ancient(src)

/obj/item/storage/box/holy/witchhunter
	name = "猎巫人装备"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/witchhunter

/obj/item/storage/box/holy/witchhunter/PopulateContents()
	new /obj/item/clothing/suit/chaplainsuit/armor/witchhunter(src)
	new /obj/item/clothing/head/helmet/chaplain/witchunter_hat(src)

/obj/item/storage/box/holy/adept
	name = "Divine Adept Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/adept

/obj/item/storage/box/holy/adept/PopulateContents()
	new /obj/item/clothing/suit/chaplainsuit/armor/adept(src)
	new /obj/item/clothing/head/helmet/chaplain/adept(src)

/obj/item/storage/box/holy/follower
	name = "牧师追随者装备"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/leader

/obj/item/storage/box/holy/follower/PopulateContents()
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/leader(src)

/obj/item/storage/box/holy/divine_archer
	name = "圣弓骑士装备"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/divine_archer

/obj/item/storage/box/holy/divine_archer/PopulateContents()
	new /obj/item/clothing/under/rank/civilian/chaplain/divine_archer(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/divine_archer(src)
	new /obj/item/clothing/gloves/divine_archer(src)
	new /obj/item/clothing/shoes/divine_archer(src)
