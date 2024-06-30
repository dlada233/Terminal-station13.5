#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
/// Job unavailable due to incompatibility with an antag role.
#define JOB_UNAVAILABLE_ANTAG_INCOMPAT 6
/// Checks for character age.
#define JOB_UNAVAILABLE_AGE 7

/// Used when the `get_job_unavailable_error_message` proc can't make sense of a given code.
#define GENERIC_JOB_UNAVAILABLE_ERROR "Error: Unknown job availability."

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 0

// Keys for jobconfig.toml
#define JOB_CONFIG_PLAYTIME_REQUIREMENTS "Playtime Requirements"
#define JOB_CONFIG_REQUIRED_ACCOUNT_AGE "Required Account Age"
#define JOB_CONFIG_REQUIRED_CHARACTER_AGE "Required Character Age"
#define JOB_CONFIG_SPAWN_POSITIONS "Spawn Positions"
#define JOB_CONFIG_TOTAL_POSITIONS "Total Positions"

/**
 * =======================
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * =======================
 * These names are used as keys in many locations in the database
 * you cannot change them trivially without breaking job bans and
 * role time tracking, if you do this and get it wrong you will die
 * and it will hurt the entire time
 */

//No department
#define JOB_ASSISTANT "助手-Assistant"
#define JOB_PRISONER "囚犯-Prisoner"
//Command
#define JOB_CAPTAIN "舰长-Captain"
#define JOB_HEAD_OF_PERSONNEL "人事部长-Head Of Personnel"
#define JOB_HEAD_OF_SECURITY "安保部长-Head of Security"
#define JOB_RESEARCH_DIRECTOR "科研主管-Research Director"
#define JOB_CHIEF_ENGINEER "首席工程师-Chief Engineer"
#define JOB_CHIEF_MEDICAL_OFFICER "首席医疗官-Chief Medical Officer"
#define JOB_BRIDGE_ASSISTANT "舰桥助理-Bridge Assistant"
#define JOB_VETERAN_ADVISOR "资深安保顾问-Veteran Security Advisor"
//Silicon
#define JOB_AI "AI"
#define JOB_CYBORG "赛博-Cyborg"
#define JOB_PERSONAL_AI "个人AI-Personal AI"
#define JOB_HUMAN_AI "老大哥-Big Brother"
//Security
#define JOB_WARDEN "典狱长-Warden"
#define JOB_DETECTIVE "侦探-Detective"
#define JOB_SECURITY_OFFICER "安全官-Security Officer"
#define JOB_SECURITY_OFFICER_MEDICAL "安全官 (医疗)-Security Officer (Medical)"
#define JOB_SECURITY_OFFICER_ENGINEERING "安全官 (工程)-Security Officer (Engineering)"
#define JOB_SECURITY_OFFICER_SCIENCE "安全官 (科研)-Security Officer (Science)"
#define JOB_SECURITY_OFFICER_SUPPLY "安全官 (货舱)-Security Officer (Cargo)"
#define JOB_CORRECTIONS_OFFICER "狱警-Corrections Officer" // SKYRAT EDIT ADDITION
//Engineering
#define JOB_STATION_ENGINEER "工程师-Engineer"
#define JOB_ATMOSPHERIC_TECHNICIAN "大气技术员-Atmospheric Technician"
#define JOB_ENGINEERING_GUARD "工程安保-Engineering Guard" // SKYRAT EDIT ADDITION
//Medical
#define JOB_CORONER "验尸官-Coroner"
#define JOB_MEDICAL_DOCTOR "医生Medical Doctor"
#define JOB_PARAMEDIC "急救员-Paramedic"
#define JOB_CHEMIST "化学家-Chemist"
#define JOB_ORDERLY "医护员-Orderly" // SKYRAT EDIT ADDITION
//Science
#define JOB_SCIENTIST "科学家-Scientist"
#define JOB_ROBOTICIST "机械学家-Roboticist"
#define JOB_GENETICIST "基因学家-Geneticist"
#define JOB_SCIENCE_GUARD "科研安保-Science Guard""
//Supply
#define JOB_QUARTERMASTER "军需官-Quartermaster"
#define JOB_CARGO_TECHNICIAN "货仓技工-Cargo Technician"
#define JOB_CARGO_GORILLA "货舱大猩猩-Cargo Gorilla"
#define JOB_SHAFT_MINER "竖井矿工-Shaft Miner"
#define JOB_BITRUNNER "比特矿工-Bitrunner"
#define JOB_CUSTOMS_AGENT "海关-Customs Agent" // SKYRAT EDIT ADDITION
//Service
#define JOB_BARTENDER "酒保-Bartender"
#define JOB_BOTANIST "植物学家-Botanist"
#define JOB_COOK "厨师-Cook"
#define JOB_CHEF "伙夫-Chef" // Alternate cook title.
#define JOB_JANITOR "清洁工-Janitor"
#define JOB_CLOWN "小丑-Clown"
#define JOB_MIME "默剧演员-Mime"
#define JOB_CURATOR "图书馆长-Curator"
#define JOB_LAWYER "律师-Lawyer"
#define JOB_CHAPLAIN "牧师-Chaplain"
#define JOB_PSYCHOLOGIST "心理学家-Psychologist"
#define JOB_BARBER "理发师-Barber" // SKYRAT EDIT ADDITION
#define JOB_BOUNCER "服务安保-Service Guard" // SKYRAT EDIT ADDITION
//ERTs
#define JOB_ERT_DEATHSQUAD "行刑队-Death Commando"
#define JOB_ERT_COMMANDER "应急响应部队指挥官-Emergency Response Team Commander"
#define JOB_ERT_OFFICER "安保响应负责人-Security Response Officer"
#define JOB_ERT_ENGINEER "工程响应负责人-Engineering Response Officer"
#define JOB_ERT_MEDICAL_DOCTOR "医疗响应负责人-Medical Response Officer"
#define JOB_ERT_CHAPLAIN "宗教响应负责人-Religious Response Officer"
#define JOB_ERT_JANITOR "清洁响应负责人-Janitorial Response Officer"
#define JOB_ERT_CLOWN "娱乐响应负责人-Entertainment Response Officer"
//CentCom
#define JOB_CENTCOM "中央指挥部-Central Command"
#define JOB_CENTCOM_OFFICIAL "中央指挥部官员-CentCom Official"
#define JOB_CENTCOM_ADMIRAL "将军-Admiral"
#define JOB_CENTCOM_COMMANDER "中央指挥部指挥官-CentCom Commander"
#define JOB_CENTCOM_VIP "VIP访客-VIP Guest"
#define JOB_CENTCOM_BARTENDER "中央指挥部酒保-CentCom Bartender"
#define JOB_CENTCOM_CUSTODIAN "管理人-Custodian"
#define JOB_CENTCOM_THUNDERDOME_OVERSEER "雷霆竞技场观众-Thunderdome Overseer"
#define JOB_CENTCOM_MEDICAL_DOCTOR "医疗官-Medical Officer"
#define JOB_CENTCOM_RESEARCH_OFFICER "科研官-Research Officer"
#define JOB_CENTCOM_SPECIAL_OFFICER "特别行动指挥官-Special Ops Officer"
#define JOB_CENTCOM_PRIVATE_SECURITY "私人安保力量-Private Security Force"
// SKYRAT EDIT ADDITION START
#define JOB_BLUESHIELD "蓝盾-Blueshield"
#define JOB_NT_REP "纳米传讯顾问-Nanotrasen Consultant"
// Nanotrasen Naval Command jobs
#define JOB_NAVAL_ENSIGN "少尉-Ensign"
#define JOB_NAVAL_LIEUTENANT "中尉-Lieutenant"
#define JOB_NAVAL_LTCR "少校-Lieutenant Commander"
#define JOB_NAVAL_COMMANDER "中校-Commander"
#define JOB_NAVAL_CAPTAIN "舰长-Captain"
#define JOB_NAVAL_REAR_ADMIRAL "少将-Rear Admiral"
#define JOB_NAVAL_ADMIRAL "上将-Admiral"
#define JOB_NAVAL_FLEET_ADMIRAL "元帅-Fleet Admiral"
// Off-Station
#define JOB_SPACE_POLICE "太空警察-Space Police"
#define JOB_SOLFED "太阳系联邦-SolFed"
#define JOB_SOLFED_LIASON "太阳系联邦联络人-SolFed Liason"
// SKYRAT EDIT ADDITION END

#define JOB_GROUP_ENGINEERS list( \
	JOB_STATION_ENGINEER, \
	JOB_ATMOSPHERIC_TECHNICIAN, \
)


#define JOB_DISPLAY_ORDER_ASSISTANT 1
#define JOB_DISPLAY_ORDER_CAPTAIN 2
#define JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL 3
#define JOB_DISPLAY_ORDER_BRIDGE_ASSISTANT 4
#define JOB_DISPLAY_ORDER_BARTENDER 5
#define JOB_DISPLAY_ORDER_BOTANIST 6
#define JOB_DISPLAY_ORDER_COOK 7
#define JOB_DISPLAY_ORDER_JANITOR 8
#define JOB_DISPLAY_ORDER_CLOWN 9
#define JOB_DISPLAY_ORDER_MIME 10
#define JOB_DISPLAY_ORDER_CURATOR 11
#define JOB_DISPLAY_ORDER_LAWYER 12
#define JOB_DISPLAY_ORDER_CHAPLAIN 13
#define JOB_DISPLAY_ORDER_PSYCHOLOGIST 14
#define JOB_DISPLAY_ORDER_AI 15
#define JOB_DISPLAY_ORDER_CYBORG 16
#define JOB_DISPLAY_ORDER_CHIEF_ENGINEER 17
#define JOB_DISPLAY_ORDER_STATION_ENGINEER 18
#define JOB_DISPLAY_ORDER_ATMOSPHERIC_TECHNICIAN 19
#define JOB_DISPLAY_ORDER_QUARTERMASTER 20
#define JOB_DISPLAY_ORDER_CARGO_TECHNICIAN 21
#define JOB_DISPLAY_ORDER_SHAFT_MINER 22
#define JOB_DISPLAY_ORDER_BITRUNNER 23
#define JOB_DISPLAY_ORDER_CARGO_GORILLA 24
#define JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER 25
#define JOB_DISPLAY_ORDER_MEDICAL_DOCTOR 26
#define JOB_DISPLAY_ORDER_PARAMEDIC 27
#define JOB_DISPLAY_ORDER_CHEMIST 28
#define JOB_DISPLAY_ORDER_CORONER 29
#define JOB_DISPLAY_ORDER_RESEARCH_DIRECTOR 30
#define JOB_DISPLAY_ORDER_SCIENTIST 31
#define JOB_DISPLAY_ORDER_ROBOTICIST 32
#define JOB_DISPLAY_ORDER_GENETICIST 33
#define JOB_DISPLAY_ORDER_HEAD_OF_SECURITY 34
#define JOB_DISPLAY_ORDER_VETERAN_ADVISOR 35
#define JOB_DISPLAY_ORDER_WARDEN 36
#define JOB_DISPLAY_ORDER_DETECTIVE 37
#define JOB_DISPLAY_ORDER_SECURITY_OFFICER 38
#define JOB_DISPLAY_ORDER_PRISONER 39
#define JOB_DISPLAY_ORDER_SECURITY_MEDIC 100 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_CORRECTIONS_OFFICER 101 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT 102 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_BLUESHIELD 103 //SKYRAT EDIT ADDITON
#define JOB_DISPLAY_ORDER_ORDERLY 104 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_SCIENCE_GUARD 105 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_BOUNCER 106 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_ENGINEER_GUARD 107 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_CUSTOMS_AGENT 108 //SKYRAT EDIT ADDITION
#define JOB_DISPLAY_ORDER_EXP_CORPS 109 //SKYRAT EDIT ADDITON

#define DEPARTMENT_UNASSIGNED "No Department"

#define DEPARTMENT_BITFLAG_SECURITY (1<<0)
#define DEPARTMENT_SECURITY "Security"
#define DEPARTMENT_BITFLAG_COMMAND (1<<1)
#define DEPARTMENT_COMMAND "Command"
#define DEPARTMENT_BITFLAG_SERVICE (1<<2)
#define DEPARTMENT_SERVICE "Service"
#define DEPARTMENT_BITFLAG_CARGO (1<<3)
#define DEPARTMENT_CARGO "Cargo"
#define DEPARTMENT_BITFLAG_ENGINEERING (1<<4)
#define DEPARTMENT_ENGINEERING "Engineering"
#define DEPARTMENT_BITFLAG_SCIENCE (1<<5)
#define DEPARTMENT_SCIENCE "Science"
#define DEPARTMENT_BITFLAG_MEDICAL (1<<6)
#define DEPARTMENT_MEDICAL "Medical"
#define DEPARTMENT_BITFLAG_SILICON (1<<7)
#define DEPARTMENT_SILICON "Silicon"
#define DEPARTMENT_BITFLAG_ASSISTANT (1<<8)
#define DEPARTMENT_ASSISTANT "Assistant"
#define DEPARTMENT_BITFLAG_CAPTAIN (1<<9)
#define DEPARTMENT_CAPTAIN "Captain"
#define DEPARTMENT_BITFLAG_CENTRAL_COMMAND (1<<10) //SKYRAT EDIT CHANGE
#define DEPARTMENT_CENTRAL_COMMAND "Central Command" //SKYRAT EDIT CHANGE

DEFINE_BITFIELD(departments_bitflags, list(
	"SECURITY" = DEPARTMENT_BITFLAG_SECURITY,
	"COMMAND" = DEPARTMENT_BITFLAG_COMMAND,
	"SERVICE" = DEPARTMENT_BITFLAG_SERVICE,
	"CARGO" = DEPARTMENT_BITFLAG_CARGO,
	"ENGINEERING" = DEPARTMENT_BITFLAG_ENGINEERING,
	"SCIENCE" = DEPARTMENT_BITFLAG_SCIENCE,
	"MEDICAL" = DEPARTMENT_BITFLAG_MEDICAL,
	"SILICON" = DEPARTMENT_BITFLAG_SILICON,
	"ASSISTANT" = DEPARTMENT_BITFLAG_ASSISTANT,
	"CAPTAIN" = DEPARTMENT_BITFLAG_CAPTAIN,
))

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Whether this job appears in bold in the job menu.
#define JOB_BOLD_SELECT_TEXT (1<<5)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<6)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<7)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<8)
/// This job cannot have more slots opened by the Head of Personnel (but admins or other random events can still do this).
#define JOB_CANNOT_OPEN_SLOTS (1<<9)
/// This job will not display on the job menu when there are no slots available, instead of appearing greyed out
#define JOB_HIDE_WHEN_EMPTY (1<<10)
/// This job cannot be signed up for at round start or recorded in your preferences
#define JOB_LATEJOIN_ONLY (1<<11)
/// This job is a head of staff.
#define JOB_HEAD_OF_STAFF (1<<12)

DEFINE_BITFIELD(job_flags, list(
	"JOB_ANNOUNCE_ARRIVAL" = JOB_ANNOUNCE_ARRIVAL,
	"JOB_CREW_MANIFEST" = JOB_CREW_MANIFEST,
	"JOB_EQUIP_RANK" = JOB_EQUIP_RANK,
	"JOB_CREW_MEMBER" = JOB_CREW_MEMBER,
	"JOB_NEW_PLAYER_JOINABLE" = JOB_NEW_PLAYER_JOINABLE,
	"JOB_BOLD_SELECT_TEXT" = JOB_BOLD_SELECT_TEXT,
	"JOB_REOPEN_ON_ROUNDSTART_LOSS" = JOB_REOPEN_ON_ROUNDSTART_LOSS,
	"JOB_ASSIGN_QUIRKS" = JOB_ASSIGN_QUIRKS,
	"JOB_CAN_BE_INTERN" = JOB_CAN_BE_INTERN,
	"JOB_CANNOT_OPEN_SLOTS" = JOB_CANNOT_OPEN_SLOTS,
	"JOB_HIDE_WHEN_EMPTY" = JOB_HIDE_WHEN_EMPTY,
	"JOB_LATEJOIN_ONLY" = JOB_LATEJOIN_ONLY,
	"JOB_HEAD_OF_STAFF" = JOB_HEAD_OF_STAFF,
))

/// Combination flag for jobs which are considered regular crew members of the station.
#define STATION_JOB_FLAGS (JOB_ANNOUNCE_ARRIVAL|JOB_CREW_MANIFEST|JOB_EQUIP_RANK|JOB_CREW_MEMBER|JOB_NEW_PLAYER_JOINABLE|JOB_REOPEN_ON_ROUNDSTART_LOSS|JOB_ASSIGN_QUIRKS|JOB_CAN_BE_INTERN)
/// Combination flag for jobs which are considered heads of staff.
#define HEAD_OF_STAFF_JOB_FLAGS (JOB_BOLD_SELECT_TEXT|JOB_CANNOT_OPEN_SLOTS|JOB_HEAD_OF_STAFF)
/// Combination flag for jobs which are enabled by station traits.
#define STATION_TRAIT_JOB_FLAGS (JOB_CANNOT_OPEN_SLOTS|JOB_HIDE_WHEN_EMPTY|JOB_LATEJOIN_ONLY&~JOB_REOPEN_ON_ROUNDSTART_LOSS)

#define FACTION_NONE "None"
#define FACTION_STATION "Station"

// Variable macros used to declare who is the supervisor for a given job, announced to the player when they join as any given job.
#define SUPERVISOR_CAPTAIN "the Captain"
#define SUPERVISOR_CE "the Chief Engineer"
#define SUPERVISOR_CMO "the Chief Medical Officer"
#define SUPERVISOR_HOP "the Head of Personnel"
#define SUPERVISOR_HOS "the Head of Security"
#define SUPERVISOR_QM "the Quartermaster"
#define SUPERVISOR_RD "the Research Director"

/// Mind traits that should be shared by every head of staff. has to be this way cause byond lists lol
#define HEAD_OF_STAFF_MIND_TRAITS TRAIT_FAST_TYING, TRAIT_HIGH_VALUE_RANSOM
