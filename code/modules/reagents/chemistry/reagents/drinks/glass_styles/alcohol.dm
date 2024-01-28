/datum/glass_style/drinking_glass/beer
	required_drink_type = /datum/reagent/consumable/ethanol/beer
	name = "啤酒"
	desc = "一杯冰凉的啤酒."
	icon_state = "beerglass"

/datum/glass_style/drinking_glass/beer/light
	required_drink_type = /datum/reagent/consumable/ethanol/beer/light
	name = "淡啤酒"
	desc = "一杯掺了水的冰凉的啤酒."

/datum/glass_style/drinking_glass/beer/light
	required_drink_type = /datum/reagent/consumable/ethanol/beer/maltliquor
	name = "麦芽酒"
	desc = "一杯冰凉的麦芽酒."

/datum/glass_style/drinking_glass/beer/green
	required_drink_type = /datum/reagent/consumable/ethanol/beer/green
	name = "生啤酒"
	desc = "一杯冰凉的生啤酒."
	icon_state = "greenbeerglass"

/datum/glass_style/drinking_glass/kahlua
	required_drink_type = /datum/reagent/consumable/ethanol/kahlua
	name = "RR咖啡酒"
	desc = "该死，这东西看起来很结实!"
	icon_state ="kahluaglass"

/datum/glass_style/drinking_glass/whiskey
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey
	name = "威士忌"
	desc = "杯中柔滑、烟熏的威士忌让这杯酒看起来很有品位."
	icon_state = "whiskeyglass"

/datum/glass_style/drinking_glass/whiskey/kong
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey/kong
	name = "空"
	desc = "让你疯狂!&#174;"

/datum/glass_style/drinking_glass/whiskey/candycorn
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "玉米糖酒"
	desc = "有利于你的想象力."

/datum/glass_style/drinking_glass/thirteenloko
	required_drink_type = /datum/reagent/consumable/ethanol/thirteenloko
	name = "十三洛克"
	desc = "这是13号Loko，它的质量是最高的."
	icon_state = "thirteen_loko_glass"

/datum/glass_style/drinking_glass/vodka
	required_drink_type = /datum/reagent/consumable/ethanol/vodka
	name = "伏特加"
	desc = "一杯伏特加"
	icon_state = "ginvodkaglass"

/datum/glass_style/drinking_glass/gin
	required_drink_type = /datum/reagent/consumable/ethanol/gin
	name = "金酒"
	desc = "或者琴酒、杜松子酒什么都好."
	icon_state = "ginvodkaglass"

/datum/glass_style/drinking_glass/rum
	required_drink_type = /datum/reagent/consumable/ethanol/rum
	name = "朗姆酒"
	desc = "现在你想祈祷有一件海盗服，是吗?"
	icon_state = "rumglass"

/datum/glass_style/drinking_glass/tequila
	required_drink_type = /datum/reagent/consumable/ethanol/tequila
	name = "龙舌兰酒"
	desc = "现在只差奇怪的颜色了!"
	icon_state = "tequilaglass"

/datum/glass_style/drinking_glass/vermouth
	required_drink_type = /datum/reagent/consumable/ethanol/vermouth
	name = "味美思"
	desc = "你想知道为什么你要喝这杯纯酒."
	icon_state = "vermouthglass"

/datum/glass_style/drinking_glass/wine
	required_drink_type = /datum/reagent/consumable/ethanol/wine
	name = "红酒"
	desc = "一种看起来很高雅的饮料."
	icon_state = "wineglass"

/datum/glass_style/drinking_glass/grappa
	required_drink_type = /datum/reagent/consumable/ethanol/grappa
	name = "格拉巴酒"
	desc = "一种最初用来防止浪费的上等饮料，也叫果渣白兰地."
	icon_state = "grappa"

/datum/glass_style/drinking_glass/amaretto
	required_drink_type = /datum/reagent/consumable/ethanol/amaretto
	name = "杏仁酒"
	desc = "一种看起来像糖浆的甜饮料."
	icon_state = "amarettoglass"
/datum/glass_style/drinking_glass/cognac
	required_drink_type = /datum/reagent/consumable/ethanol/cognac
	name = "干邑白兰地"
	desc = "妈的，你拿着这个就觉得自己像个法国贵族."
	icon_state = "cognacglass"

/datum/glass_style/drinking_glass/absinthe
	required_drink_type = /datum/reagent/consumable/ethanol/absinthe
	name = "苦艾酒"
	desc = "它的味道和它的气味一样浓烈."
	icon_state = "absinthe"

/datum/glass_style/drinking_glass/hooch
	required_drink_type = /datum/reagent/consumable/ethanol/hooch
	name = "爱尔啤酒"
	desc = "一杯冰凉的爱尔啤酒."
	icon_state = "aleglass"

/datum/glass_style/drinking_glass/goldschlager
	required_drink_type = /datum/reagent/consumable/ethanol/goldschlager
	name = "金杜松子酒"
	desc = "百分百证明了少女们会喝任何含黄金的东西."
	icon = 'icons/obj/drinks/mixed_drinks.dmi'
	icon_state = "goldschlagerglass"

/datum/glass_style/drinking_glass/patron
	required_drink_type = /datum/reagent/consumable/ethanol/patron
	name = "Patron-主顾"
	desc = "在酒吧里喝酒，和一群低级的女人在一起."
	icon = 'icons/obj/drinks/mixed_drinks.dmi'
	icon_state = "patronglass"

/datum/glass_style/drinking_glass/sake
	required_drink_type = /datum/reagent/consumable/ethanol/sake
	name = "清酒"
	desc = "一杯传统的清酒."
	icon_state = "sakecup"

/datum/glass_style/drinking_glass/fernet
	required_drink_type = /datum/reagent/consumable/ethanol/fernet
	name = "Fernet-菲奈特"
	desc = "纯粹的菲奈特，只有疯子才会一个人喝这个." //Hi Kevum

/datum/glass_style/drinking_glass/fruit_wine
	required_drink_type = /datum/reagent/consumable/ethanol/fruit_wine
	// This should really be dynamic like "pineapple wine" or something
	// but seeing as fruit wine half doesn't work already I'm not inclined to add support for that now
	name = "Fruit wine-果酒"
	desc = "用植物酿造的酒."

/datum/glass_style/drinking_glass/champagne
	required_drink_type = /datum/reagent/consumable/ethanol/champagne
	name = "香槟"
	desc = "The flute clearly displays the slowly rising bubbles."
	icon_state = "champagne_glass"

/datum/glass_style/drinking_glass/pruno
	required_drink_type = /datum/reagent/consumable/ethanol/pruno
	name = "pruno-监狱酒"
	desc = "由水果、糖和绝望制成的发酵监狱酒，狱警喜欢没收这个，这也是狱警做过的唯一一件好事."
	icon_state = "glass_orange"

/datum/glass_style/drinking_glass/navy_rum
	required_drink_type = /datum/reagent/consumable/ethanol/navy_rum
	name = "海军朗姆酒"
	desc = "把支柱接好，上帝保佑国王."
	icon_state = "ginvodkaglass"

/datum/glass_style/drinking_glass/curacao
	required_drink_type = /datum/reagent/consumable/ethanol/curacao
	name = "柑香酒"
	desc = "It's blue, da ba dee."
	icon_state = "curacao"

/datum/glass_style/drinking_glass/bitters
	required_drink_type = /datum/reagent/consumable/ethanol/bitters
	name = "苦精"
	desc = "通常你会想把它和别的东西混在一起."
	icon_state = "bitters"

/datum/glass_style/drinking_glass/coconut_rum
	required_drink_type = /datum/reagent/consumable/ethanol/coconut_rum
	name = "coconut rum"
	desc = "Breathe in and relax, you're on vacation until this glass is empty."
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = "ginvodkaglass"

/datum/glass_style/drinking_glass/yuyake
	required_drink_type = /datum/reagent/consumable/ethanol/yuyake
	name = "yūyake"
	desc = "It's the saccharine essence of the 70s in a glass... the 1970s, that is!"
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = "glass_red"

/datum/glass_style/drinking_glass/shochu
	required_drink_type = /datum/reagent/consumable/ethanol/shochu
	name = "shochu"
	desc = "A strong rice wine."
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = "ginvodkaglass"

/datum/glass_style/drinking_glass/rice_beer
	required_drink_type = /datum/reagent/consumable/ethanol/rice_beer
	name = "rice beer"
	desc = "A fine, light rice beer. Best enjoyed cold."
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = "rice_beer"

// Shot glasses

/datum/glass_style/shot_glass/kahlua
	required_drink_type = /datum/reagent/consumable/ethanol/kahlua
	icon_state ="shotglasscream"

/datum/glass_style/shot_glass/whiskey
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey
	icon_state = "shotglassbrown"

/datum/glass_style/shot_glass/whiskey/kong
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey/kong

/datum/glass_style/shot_glass/whiskey/candycorn
	required_drink_type = /datum/reagent/consumable/ethanol/whiskey/candycorn

/datum/glass_style/shot_glass/vodka
	required_drink_type = /datum/reagent/consumable/ethanol/vodka
	icon_state = "shotglassclear"

/datum/glass_style/shot_glass/rum
	required_drink_type = /datum/reagent/consumable/ethanol/rum
	icon_state = "shotglassbrown"

/datum/glass_style/shot_glass/tequila
	required_drink_type = /datum/reagent/consumable/ethanol/tequila
	icon_state = "shotglassgold"

/datum/glass_style/shot_glass/vermouth
	required_drink_type = /datum/reagent/consumable/ethanol/vermouth
	icon_state = "shotglassclear"

/datum/glass_style/shot_glass/wine
	required_drink_type = /datum/reagent/consumable/ethanol/wine
	icon_state = "shotglassred"

/datum/glass_style/shot_glass/amaretto
	required_drink_type = /datum/reagent/consumable/ethanol/amaretto
	icon_state = "shotglassgold"

/datum/glass_style/shot_glass/cognac
	required_drink_type = /datum/reagent/consumable/ethanol/cognac
	icon_state = "shotglassbrown"

/datum/glass_style/shot_glass/absinthe
	required_drink_type = /datum/reagent/consumable/ethanol/absinthe
	icon_state = "shotglassgreen"

/datum/glass_style/drinking_glass/hooch
	required_drink_type = /datum/reagent/consumable/ethanol/hooch
	name = "Hooch"
	desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
	icon_state = "glass_brown2"

/datum/glass_style/shot_glass/goldschlager
	required_drink_type = /datum/reagent/consumable/ethanol/goldschlager
	icon_state = "shotglassgold"

/datum/glass_style/shot_glass/patron
	required_drink_type = /datum/reagent/consumable/ethanol/patron
	icon_state = "shotglassclear"
