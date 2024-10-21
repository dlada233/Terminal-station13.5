/area/station/service
	airlock_wires = /datum/wires/airlock/service

/*
* Bar/Kitchen Areas
*/

/area/station/service/cafeteria
	name = "\improper Cafeteria-自主餐厅"
	icon_state = "cafeteria"

/area/station/service/kitchen
	name = "\improper Kitchen-厨房"
	icon_state = "kitchen"

/area/station/service/kitchen/coldroom
	name = "\improper Kitchen Cold Room-厨房冷库"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/kitchen/diner
	name = "\improper Diner-餐馆"
	icon_state = "diner"

/area/station/service/kitchen/kitchen_backroom
	name = "\improper Kitchen Backroom-厨房后室"
	icon_state = "kitchen_backroom"

/area/station/service/bar
	name = "\improper Bar-酒吧"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "我喜欢呆在酒吧里!"
	mood_trait = TRAIT_EXTROVERT
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/bar/Initialize(mapload)
	. = ..()
	GLOB.bar_areas += src

/area/station/service/bar/atrium
	name = "\improper Atrium-中庭"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/bar/backroom
	name = "\improper Bar Backroom-酒吧后室"
	icon_state = "bar_backroom"

/*
* Entertainment/Library Areas
*/

/area/station/service/theater
	name = "\improper Theater-剧院"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/greenroom
	name = "\improper Greenroom-温室"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/library
	name = "\improper Library-图书馆"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "我很喜欢图书馆!"
	mood_trait = TRAIT_INTROVERT
	area_flags = CULT_PERMITTED | BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/station/service/library/garden
	name = "\improper Library-图书馆花园"
	icon_state = "library_garden"

/area/station/service/library/lounge
	name = "\improper Library-图书馆休息室"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/library/artgallery
	name = "\improper  Art Gallery-艺术画廊"
	icon_state = "library_gallery"

/area/station/service/library/private
	name = "\improper Library-图书馆私人书房"
	icon_state = "library_gallery_private"

/area/station/service/library/upper
	name = "\improper Library-图书馆上层"
	icon_state = "library"

/area/station/service/library/printer
	name = "\improper Library-图书馆打印机室"
	icon_state = "library"

/*
* Chapel/Pubby Monestary Areas
*/

/area/station/service/chapel
	name = "\improper Chapel-教堂"
	icon_state = "chapel"
	mood_bonus = 5
	mood_message = "教堂使我心静神宁."
	mood_trait = TRAIT_SPIRITUAL
	ambience_index = AMBIENCE_HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/service/chapel/monastery
	name = "\improper Monastery-寺庙"

/area/station/service/chapel/office
	name = "\improper Chapel-教堂办公室"
	icon_state = "chapeloffice"

/area/station/service/chapel/asteroid
	name = "\improper Chapel-小行星教堂"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/station/service/chapel/asteroid/monastery
	name = "\improper Monastery-小行星寺庙"

/area/station/service/chapel/dock
	name = "\improper Chapel-教堂码头"
	icon_state = "construction"

/area/station/service/chapel/storage
	name = "\improper Chapel-教堂仓库"
	icon_state = "chapelstorage"

/area/station/service/chapel/funeral
	name = "\improper Chapel-教堂葬礼堂"
	icon_state = "chapelfuneral"

/area/station/service/hydroponics/garden/monastery
	name = "\improper Monastery-寺庙花园"
	icon_state = "hydro"

/*
* Hydroponics/Garden Areas
*/

/area/station/service/hydroponics
	name = "Hydroponics-水培室"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/service/hydroponics/upper
	name = "Upper Hydroponics-水培室上层"
	icon_state = "hydro"

/area/station/service/hydroponics/garden
	name = "Garden-花园"
	icon_state = "garden"

/*
* Misc/Unsorted Rooms
*/

/area/station/service/lawoffice
	name = "\improper Law Office-律师事务所"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/janitor
	name = "\improper Custodial Closet-保管柜"
	icon_state = "janitor"
	area_flags = CULT_PERMITTED | BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/barber
	name = "\improper Barber-理发店"
	icon_state = "barber"

/*
* Abandoned Rooms
*/

/area/station/service/hydroponics/garden/abandoned
	name = "\improper Abandoned Garden-废弃花园"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/kitchen/abandoned
	name = "\improper Abandoned Kitchen-废弃厨房"
	icon_state = "abandoned_kitchen"

/area/station/service/electronic_marketing_den
	name = "\improper Electronic Marketing Den-废弃电商窝点"
	icon_state = "abandoned_marketing_den"

/area/station/service/abandoned_gambling_den
	name = "\improper Abandoned Gambling Den-废弃赌博窝点"
	icon_state = "abandoned_gambling_den"

/area/station/service/abandoned_gambling_den/gaming
	name = "\improper Abandoned Gaming Den-废弃游戏窝点"
	icon_state = "abandoned_gaming_den"

/area/station/service/theater/abandoned
	name = "\improper Abandoned Theater-废弃剧院"
	icon_state = "abandoned_theatre"

/area/station/service/library/abandoned
	name = "\improper Abandoned Library-废弃图书馆"
	icon_state = "abandoned_library"
