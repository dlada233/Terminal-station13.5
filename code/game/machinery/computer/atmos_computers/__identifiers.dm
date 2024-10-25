// ATMOSIA GAS MONITOR SUITE TAGS
// Things that use these include atmos control monitors, sensors, inputs, and outlets.
// They last three adds _sensor, _in, and _out respectively to the id_tag variable.
// Dont put underscores here, we use them as delimiters.

#define ATMOS_GAS_MONITOR_O2 GAS_O2
#define ATMOS_GAS_MONITOR_PLAS GAS_PLASMA
#define ATMOS_GAS_MONITOR_AIR GAS_AIR
#define ATMOS_GAS_MONITOR_MIX "mix"
#define ATMOS_GAS_MONITOR_N2O GAS_N2O
#define ATMOS_GAS_MONITOR_N2 GAS_N2
#define ATMOS_GAS_MONITOR_CO2 GAS_CO2
#define ATMOS_GAS_MONITOR_BZ GAS_BZ
#define ATMOS_GAS_MONITOR_FREON GAS_FREON
#define ATMOS_GAS_MONITOR_HALON GAS_HALON
#define ATMOS_GAS_MONITOR_HEALIUM GAS_HEALIUM
#define ATMOS_GAS_MONITOR_H2 GAS_HYDROGEN
#define ATMOS_GAS_MONITOR_HYPERNOBLIUM GAS_HYPER_NOBLIUM
#define ATMOS_GAS_MONITOR_MIASMA GAS_MIASMA
#define ATMOS_GAS_MONITOR_NITRIUM GAS_NITRIUM
#define ATMOS_GAS_MONITOR_PLUOXIUM GAS_PLUOXIUM
#define ATMOS_GAS_MONITOR_PROTO_NITRATE GAS_PROTO_NITRATE
#define ATMOS_GAS_MONITOR_TRITIUM GAS_TRITIUM
#define ATMOS_GAS_MONITOR_H2O GAS_WATER_VAPOR
#define ATMOS_GAS_MONITOR_ZAUKER GAS_ZAUKER
#define ATMOS_GAS_MONITOR_HELIUM GAS_HEALIUM
#define ATMOS_GAS_MONITOR_ANTINOBLIUM GAS_ANTINOBLIUM
#define ATMOS_GAS_MONITOR_INCINERATOR "incinerator"
#define ATMOS_GAS_MONITOR_ORDNANCE_BURN "ordnanceburn"
#define ATMOS_GAS_MONITOR_ORDNANCE_FREEZER "ordnancefreezer"
#define ATMOS_GAS_MONITOR_DISTRO "distro"
#define ATMOS_GAS_MONITOR_WASTE "waste"
#define ATMOS_GAS_MONITOR_ENGINE "engine"

///maps an air sensor's chamber id to its input valve[ i.e. outlet_injector] id
#define CHAMBER_INPUT_FROM_ID(chamber_id) ((chamber_id) + "_in")
///maps an air sensor's chamber id to its output valve[i.e. vent pump] id
#define CHAMBER_OUTPUT_FROM_ID(chamber_id) ((chamber_id) + "_out")

///list of all air sensor's created round start
GLOBAL_LIST_EMPTY(map_loaded_sensors)

// Human-readble names of these funny tags.
GLOBAL_LIST_INIT(station_gas_chambers, list(
	ATMOS_GAS_MONITOR_O2 = "氧气供应",
	ATMOS_GAS_MONITOR_PLAS = "等离子气体供应",
	ATMOS_GAS_MONITOR_AIR = "混合空气供应",
	ATMOS_GAS_MONITOR_N2O = "一氧化二氮供应",
	ATMOS_GAS_MONITOR_N2 = "氮气供应",
	ATMOS_GAS_MONITOR_CO2 = "二氧化碳供应",
	ATMOS_GAS_MONITOR_BZ = "BZ供应",
	ATMOS_GAS_MONITOR_FREON = "氟利昂供应",
	ATMOS_GAS_MONITOR_HALON = "Halon-哈龙供应",
	ATMOS_GAS_MONITOR_HEALIUM = "Healium-疗气供应",
	ATMOS_GAS_MONITOR_H2 = "Hydrogen-氢气供应 ",
	ATMOS_GAS_MONITOR_HYPERNOBLIUM = "Hypernoblium-超铌供应",
	ATMOS_GAS_MONITOR_MIASMA = "Miasma-瘴气供应",
	ATMOS_GAS_MONITOR_NITRIUM = "Nitrium-亚硝基兴奋气体供应",
	ATMOS_GAS_MONITOR_PLUOXIUM = "Pluoxium-钷供应",
	ATMOS_GAS_MONITOR_PROTO_NITRATE = "Proto-Nitrate-原硝酸供应",
	ATMOS_GAS_MONITOR_TRITIUM = "Tritium-氚供应",
	ATMOS_GAS_MONITOR_H2O = "水蒸气供应",
	ATMOS_GAS_MONITOR_ZAUKER = "Zauker-扎克供应",
	ATMOS_GAS_MONITOR_HELIUM = "Helium-氦供应",
	ATMOS_GAS_MONITOR_ANTINOBLIUM = "Antinoblium-反铌供应",
	ATMOS_GAS_MONITOR_MIX = "混合室",
	ATMOS_GAS_MONITOR_INCINERATOR = "燃烧室",
	ATMOS_GAS_MONITOR_ORDNANCE_BURN = "军械燃烧室",
	ATMOS_GAS_MONITOR_ORDNANCE_FREEZER = "军械冷冻室",
	ATMOS_GAS_MONITOR_DISTRO = "分送回路",
	ATMOS_GAS_MONITOR_WASTE = "废气回路",
	ATMOS_GAS_MONITOR_ENGINE = "超物质引擎室",
))
