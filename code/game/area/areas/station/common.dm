/area/station/commons
	name = "\improper Crew Facilities"
	icon_state = "commons"
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/*
* Dorm Areas
*/

/area/station/commons/dorms
	name = "\improper Dormitories-宿舍"
	icon_state = "dorms"

/area/station/commons/dorms/room1
	name = "\improper 宿舍1室"
	icon_state = "room1"

/area/station/commons/dorms/room2
	name = "\improper 宿舍2室"
	icon_state = "room2"

/area/station/commons/dorms/room3
	name = "\improper 宿舍3室"
	icon_state = "room3"

/area/station/commons/dorms/room4
	name = "\improper 宿舍4室"
	icon_state = "room4"

/area/station/commons/dorms/apartment1
	name = "\improper 宿舍公寓1"
	icon_state = "apartment1"

/area/station/commons/dorms/apartment2
	name = "\improper 宿舍公寓2"
	icon_state = "apartment2"

/area/station/commons/dorms/barracks
	name = "\improper Sleep Barracks-睡眠营房"

/area/station/commons/dorms/barracks/male
	name = "\improper Sleep Barracks-男睡眠营房"
	icon_state = "dorms_male"

/area/station/commons/dorms/barracks/female
	name = "\improper Sleep Barracks-女睡眠营房"
	icon_state = "dorms_female"

/area/station/commons/dorms/laundry
	name = "\improper Laundry Room-洗衣房"
	icon_state = "laundry_room"

/area/station/commons/toilet
	name = "\improper Dormitory Toilets-宿舍厕所"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/commons/toilet/auxiliary
	name = "\improper Auxiliary Restrooms-辅助基地卫生间"
	icon_state = "toilet"

/area/station/commons/toilet/locker
	name = "\improper Locker Toilets-更衣室厕所"
	icon_state = "toilet"

/area/station/commons/toilet/restrooms
	name = "\improper Restrooms-卫生间"
	icon_state = "toilet"

/*
* Rec and Locker Rooms
*/

/area/station/commons/locker
	name = "\improper Locker Room-更衣室"
	icon_state = "locker"

/area/station/commons/lounge
	name = "\improper Bar Lounge-酒吧"
	icon_state = "lounge"
	mood_bonus = 5
	mood_message = "我爱酒吧!"
	mood_trait = TRAIT_EXTROVERT
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/commons/fitness
	name = "\improper Fitness Room-健身房"
	icon_state = "fitness"

/area/station/commons/fitness/locker_room
	name = "\improper Unisex Locker Room-男女更衣室"
	icon_state = "locker"

/area/station/commons/fitness/locker_room/male
	name = "\improper Male Locker Room-男性更衣室"
	icon_state = "locker_male"

/area/station/commons/fitness/locker_room/female
	name = "\improper Female Locker Room-女性更衣室"
	icon_state = "locker_female"

/area/station/commons/fitness/recreation
	name = "\improper Recreation Area-休闲区域"
	icon_state = "rec"

/area/station/commons/fitness/recreation/entertainment
	name = "\improper Entertainment Center-娱乐中心"
	icon_state = "entertainment"

/*
* Vacant Rooms
*/

/area/station/commons/vacant_room
	name = "\improper Vacant Room-空房间"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT

/area/station/commons/vacant_room/office
	name = "\improper Vacant Office-空办公室"
	icon_state = "vacant_office"

/area/station/commons/vacant_room/commissary
	name = "\improper Vacant Commissary-空食堂"
	icon_state = "vacant_commissary"

/*
* Storage Rooms
*/

/area/station/commons/storage
	name = "\improper Commons Storage-一般仓库"

/area/station/commons/storage/tools
	name = "\improper Auxiliary Tool Storage-辅助工具仓库"
	icon_state = "tool_storage"

/area/station/commons/storage/primary
	name = "\improper Primary Tool Storage-主要工具仓库"
	icon_state = "primary_storage"

/area/station/commons/storage/art
	name = "\improper Art Supply Storage-艺创物品仓库"
	icon_state = "art_storage"

/area/station/commons/storage/emergency/starboard
	name = "\improper Starboard Emergency Storage-右舷应急仓库"
	icon_state = "emergency_storage"

/area/station/commons/storage/emergency/port
	name = "\improper Port Emergency Storage-港口应急仓库"
	icon_state = "emergency_storage"

/area/station/commons/storage/mining
	name = "\improper Public Mining Storage-公共采矿仓库"
	icon_state = "mining_storage"
