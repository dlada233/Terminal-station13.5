import { toFixed } from 'common/math';
import { classes } from 'common/react';
import { GasmixParser } from 'tgui/interfaces/common/GasmixParser';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Collapsible,
  Icon,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from '../../components';
import { formatPower } from '../../format';
import { MainData, MechModule } from './data';

const moduleSlotIcon = (param) => {
  switch (param) {
    case 'mecha_l_arm':
      return 'hand';
    case 'mecha_r_arm':
      return 'hand';
    case 'mecha_utility':
      return 'screwdriver-wrench';
    case 'mecha_power':
      return 'bolt';
    case 'mecha_armor':
      return 'shield-halved';
    default:
      return 'screwdriver-wrench';
  }
};

const moduleSlotLabel = (param) => {
  switch (param) {
    case 'mecha_l_arm':
      return '左臂模块';
    case 'mecha_r_arm':
      return '右臂模块';
    case 'mecha_utility':
      return '工具模块';
    case 'mecha_power':
      return '电源模块';
    case 'mecha_armor':
      return '装甲模块';
    default:
      return '通用模块';
  }
};

export const ModulesPane = (props) => {
  const { act, data } = useBackend<MainData>();
  const { modules, selected_module_index, weapons_safety } = data;
  return (
    <Section
      title="装备"
      fill
      style={{ overflowY: 'auto' }}
      buttons={
        <Button
          icon={!weapons_safety ? 'triangle-exclamation' : 'helmet-safety'}
          color={!weapons_safety ? 'red' : 'default'}
          onClick={() => act('toggle_safety')}
          content={!weapons_safety ? '安全协议禁用' : '安全协议开启'}
        />
      }
    >
      <Stack>
        <Stack.Item>
          {modules.map((module, i) =>
            !module.ref ? (
              <Button
                maxWidth={16}
                p="4px"
                pr="8px"
                fluid
                key={i}
                color="transparent"
              >
                <Stack>
                  <Stack.Item width="32px" height="32px" textAlign="center">
                    <Icon
                      fontSize={1.5}
                      mx={0}
                      my="8px"
                      name={moduleSlotIcon(module.slot)}
                    />
                  </Stack.Item>
                  <Stack.Item
                    lineHeight="32px"
                    style={{
                      textTransform: 'capitalize',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {`${moduleSlotLabel(module.slot)}槽位`}
                  </Stack.Item>
                </Stack>
              </Button>
            ) : (
              <Button
                maxWidth={16}
                p="4px"
                pr="8px"
                fluid
                key={i}
                selected={i === selected_module_index}
                onClick={() =>
                  act('select_module', {
                    index: i,
                  })
                }
              >
                <Stack>
                  <Stack.Item lineHeight="0">
                    <Box
                      className={classes(['mecha_equipment32x32', module.icon])}
                    />
                  </Stack.Item>
                  <Stack.Item
                    lineHeight="32px"
                    style={{
                      textTransform: 'capitalize',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {module.name}
                  </Stack.Item>
                </Stack>
              </Button>
            ),
          )}
        </Stack.Item>
        <Stack.Item grow pl={1}>
          {selected_module_index !== null && modules[selected_module_index] && (
            <ModuleDetails module={modules[selected_module_index]} />
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const ModuleDetails = (props) => {
  const { act, data } = useBackend<MainData>();
  const { slot, name, desc, icon, detachable, ref, snowflake } = props.module;
  return (
    <Box>
      <Section>
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <h2 style={{ textTransform: 'capitalize' }}>{name}</h2>
                <Box italic opacity={0.5}>
                  {moduleSlotLabel(slot)}
                </Box>
              </Stack.Item>
              {!!detachable && (
                <Stack.Item>
                  <Button
                    color="transparent"
                    icon="eject"
                    tooltip="分离"
                    fontSize={1.5}
                    onClick={() =>
                      act('equip_act', {
                        ref: ref,
                        gear_action: 'detach',
                      })
                    }
                  />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Item>{desc}</Stack.Item>
        </Stack>
      </Section>
      <Section>
        {snowflake && snowflake.snowflake_id === MECHA_SNOWFLAKE_ID_EJECTOR ? (
          <SnowflakeCargo module={props.module} />
        ) : snowflake &&
          snowflake.snowflake_id === MECHA_SNOWFLAKE_ID_AIR_TANK ? (
          <SnowflakeAirTank module={props.module} />
        ) : snowflake &&
          snowflake.snowflake_id === MECHA_SNOWFLAKE_ID_OREBOX_MANAGER ? (
          <SnowflakeOrebox module={props.module} />
        ) : (
          <LabeledList>
            <ModuleDetailsBasic module={props.module} />
            {!!snowflake && <ModuleDetailsExtra module={props.module} />}
          </LabeledList>
        )}
      </Section>
    </Box>
  );
};

const ModuleDetailsBasic = (props) => {
  const { act, data } = useBackend<MainData>();
  const { power_level, weapons_safety } = data;
  const {
    ref,
    slot,
    integrity,
    can_be_toggled,
    can_be_triggered,
    active,
    active_label,
    equip_cooldown,
    energy_per_use,
  } = props.module;
  return (
    <>
      {integrity < 1 && (
        <LabeledList.Item
          label="完整性"
          buttons={
            <Button
              content="修理"
              icon="wrench"
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'repair',
                })
              }
            />
          }
        >
          <ProgressBar
            ranges={{
              good: [0.75, Infinity],
              average: [0.25, 0.75],
              bad: [-Infinity, 0.25],
            }}
            value={integrity}
          />
        </LabeledList.Item>
      )}
      {!weapons_safety && ['mecha_l_arm', 'mecha_r_arm'].includes(slot) && (
        <LabeledList.Item label="安全保险" color="red">
          <NoticeBox danger>保险:关</NoticeBox>
        </LabeledList.Item>
      )}
      {!!energy_per_use && (
        <LabeledList.Item label="电力消耗">
          {`${formatPower(energy_per_use)}, ${
            power_level ? toFixed(power_level / energy_per_use) : 0
          } 次使用剩余`}
        </LabeledList.Item>
      )}
      {!!equip_cooldown && (
        <LabeledList.Item label="冷却">{equip_cooldown}</LabeledList.Item>
      )}
      {!!can_be_toggled && (
        <LabeledList.Item label={active_label}>
          <Button
            icon="power-off"
            content={active ? '开启' : '关闭'}
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'toggle',
              })
            }
            selected={active}
          />
        </LabeledList.Item>
      )}
      {!!can_be_triggered && (
        <LabeledList.Item label={active_label}>
          <Button
            icon="power-off"
            content="激活"
            disabled={active}
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'toggle',
              })
            }
          />
        </LabeledList.Item>
      )}
    </>
  );
};

const MECHA_SNOWFLAKE_ID_SLEEPER = 'sleeper_snowflake';
const MECHA_SNOWFLAKE_ID_SYRINGE = 'syringe_snowflake';
const MECHA_SNOWFLAKE_ID_MODE = 'mode_snowflake';
const MECHA_SNOWFLAKE_ID_EXTINGUISHER = 'extinguisher_snowflake';
const MECHA_SNOWFLAKE_ID_EJECTOR = 'ejector_snowflake';
const MECHA_SNOWFLAKE_ID_OREBOX_MANAGER = 'orebox_manager_snowflake';
const MECHA_SNOWFLAKE_ID_RADIO = 'radio_snowflake';
const MECHA_SNOWFLAKE_ID_AIR_TANK = 'air_tank_snowflake';
const MECHA_SNOWFLAKE_ID_WEAPON_BALLISTIC = 'ballistic_weapon_snowflake';
const MECHA_SNOWFLAKE_ID_GENERATOR = 'generator_snowflake';
const MECHA_SNOWFLAKE_ID_ORE_SCANNER = 'orescanner_snowflake';
const MECHA_SNOWFLAKE_ID_CLAW = 'lawclaw_snowflake';
const MECHA_SNOWFLAKE_ID_RCD = 'rcd_snowflake';

export const ModuleDetailsExtra = (props: { module: MechModule }) => {
  const module = props.module;
  switch (module.snowflake.snowflake_id) {
    case MECHA_SNOWFLAKE_ID_WEAPON_BALLISTIC:
      return <SnowflakeWeaponBallistic module={module} />;
    case MECHA_SNOWFLAKE_ID_EXTINGUISHER:
      return <SnowflakeExtinguisher module={module} />;
    case MECHA_SNOWFLAKE_ID_SLEEPER:
      return <SnowflakeSleeper module={module} />;
    case MECHA_SNOWFLAKE_ID_SYRINGE:
      return <SnowflakeSyringe module={module} />;
    case MECHA_SNOWFLAKE_ID_MODE:
      return <SnowflakeMode module={module} />;
    case MECHA_SNOWFLAKE_ID_RADIO:
      return <SnowflakeRadio module={module} />;
    case MECHA_SNOWFLAKE_ID_GENERATOR:
      return <SnowflakeGeneraor module={module} />;
    case MECHA_SNOWFLAKE_ID_ORE_SCANNER:
      return <SnowflakeOreScanner module={module} />;
    case MECHA_SNOWFLAKE_ID_CLAW:
      return <SnowflakeLawClaw module={module} />;
    case MECHA_SNOWFLAKE_ID_RCD:
      return <SnowflakeRCD module={module} />;
    default:
      return null;
  }
};

const SnowflakeWeaponBallistic = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const {
    projectiles,
    max_magazine,
    projectiles_cache,
    projectiles_cache_max,
    disabledreload,
    ammo_type,
    mode,
  } = props.module.snowflake;
  return (
    <>
      {!!ammo_type && (
        <LabeledList.Item label="弹药">{ammo_type}</LabeledList.Item>
      )}
      <LabeledList.Item
        label="已装载"
        buttons={
          !disabledreload &&
          projectiles_cache > 0 && (
            <Button
              icon="redo"
              disabled={projectiles >= max_magazine}
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'reload',
                })
              }
            >
              换弹
            </Button>
          )
        }
      >
        <ProgressBar value={projectiles / max_magazine}>
          {`${projectiles} / ${max_magazine}`}
        </ProgressBar>
      </LabeledList.Item>
      {!!projectiles_cache_max && (
        <LabeledList.Item label="储存">
          <ProgressBar value={projectiles_cache / projectiles_cache_max}>
            {`${projectiles_cache} / ${projectiles_cache_max}`}
          </ProgressBar>
        </LabeledList.Item>
      )}
      {!!mode && <SnowflakeMode module={props.module} />}
    </>
  );
};

const SnowflakeSleeper = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const {
    patient,
    contained_reagents,
    injectible_reagents,
    has_brain_damage,
    has_traumas,
  } = props.module.snowflake;
  return !patient ? (
    <LabeledList.Item label="患者">None</LabeledList.Item>
  ) : (
    <>
      <LabeledList.Item
        label="患者"
        buttons={
          <Button
            icon="eject"
            tooltip="弹出"
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'eject',
              })
            }
          />
        }
      >
        {patient.patient_name}
      </LabeledList.Item>
      <LabeledList.Item label="健康">
        <ProgressBar
          ranges={{
            good: [0.75, Infinity],
            average: [0.25, 0.75],
            bad: [-Infinity, 0.25],
          }}
          value={patient.patient_health}
        />
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="状况">
        {patient.patient_state}
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="体温">
        {patient.core_temp} C
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="创伤">
        {patient.brute_loss}
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="烧伤程度">
        {patient.burn_loss}
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="毒素含量">
        {patient.toxin_loss}
      </LabeledList.Item>
      <LabeledList.Item className="candystripe" label="呼吸系统损伤">
        {patient.oxygen_loss}
      </LabeledList.Item>
      {!!has_brain_damage && (
        <LabeledList.Item className="candystripe" label="检测到">
          脑损伤
        </LabeledList.Item>
      )}
      {!!has_traumas && (
        <LabeledList.Item className="candystripe" label="检测到">
          脑神经性损伤
        </LabeledList.Item>
      )}
      <LabeledList.Item label="试剂细节">
        {contained_reagents.map((reagent) => (
          <LabeledList.Item
            key={reagent.name}
            className="candystripe"
            label={reagent.name}
          >
            <LabeledList.Item label={`${reagent.volume}u`} />
          </LabeledList.Item>
        ))}
      </LabeledList.Item>
      <LabeledList.Item label="试剂注入">
        {injectible_reagents
          ? injectible_reagents.map((reagent) => (
              <LabeledList.Item
                className="candystripe"
                key={reagent.name}
                label={reagent.name}
              >
                <LabeledList.Item label={`${reagent.volume}u`}>
                  <Button
                    onClick={() =>
                      act('equip_act', {
                        ref: ref,
                        gear_action: `inject_reagent_${reagent.name}`,
                      })
                    }
                  >
                    注入
                  </Button>
                </LabeledList.Item>
              </LabeledList.Item>
            ))
          : '不可用'}
      </LabeledList.Item>
    </>
  );
};
type Data = {
  contained_reagents: Reagent[];
  analyzed_reagents: KnownReagent[];
};
type Reagent = {
  name: string;
  volume: number;
};
type KnownReagent = {
  name: string;
  enabled: boolean;
};
const SnowflakeSyringe = (props) => {
  const { act, data } = useBackend<MainData>();
  const { power_level, weapons_safety } = data;
  const { ref, energy_per_use, equip_cooldown } = props.module;
  const {
    mode,
    syringe,
    max_syringe,
    reagents,
    total_reagents,
    contained_reagents,
    analyzed_reagents,
  } = props.module.snowflake;
  return (
    <>
      <LabeledList.Item label="注射器">
        <ProgressBar value={syringe / max_syringe}>
          {`${syringe} / ${max_syringe}`}
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="试剂">
        <ProgressBar value={reagents / total_reagents}>
          {`${reagents} / ${total_reagents} 单位（u)`}
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="模式">
        <Button
          content={mode}
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'change_mode',
            })
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="合成">
        {analyzed_reagents.map((reagent) => (
          <LabeledList.Item key={reagent.name} label={reagent.name}>
            <Button.Checkbox
              checked={reagent.enabled}
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: `toggle_reagent_${reagent.name}`,
                })
              }
            />
          </LabeledList.Item>
        ))}
      </LabeledList.Item>
      <LabeledList.Item>
        <Button
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: `purge_all`,
            })
          }
        >
          清除所有
        </Button>
      </LabeledList.Item>
      {contained_reagents.map((reagent) => (
        <LabeledList.Item key={reagent.name} label={reagent.name}>
          <LabeledList.Item label={`${reagent.volume}u`}>
            <Button
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: `purge_reagent_${reagent.name}`,
                })
              }
            >
              清除
            </Button>
          </LabeledList.Item>
        </LabeledList.Item>
      ))}
    </>
  );
};

const SnowflakeMode = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { mode, mode_label } = props.module.snowflake;
  return (
    <LabeledList.Item label={mode_label}>
      <Button
        content={mode}
        onClick={() =>
          act('equip_act', {
            ref: ref,
            gear_action: 'change_mode',
          })
        }
      />
    </LabeledList.Item>
  );
};

const SnowflakeRadio = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { microphone, speaker, minFrequency, maxFrequency, frequency } =
    props.module.snowflake;
  return (
    <>
      <LabeledList.Item label="麦克风">
        <Button
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'toggle_microphone',
            })
          }
          selected={microphone}
          icon={microphone ? 'microphone' : 'microphone-slash'}
        >
          {microphone ? '开启' : '关闭'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="扬声器">
        <Button
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'toggle_speaker',
            })
          }
          selected={speaker}
          icon={speaker ? 'volume-up' : 'volume-mute'}
        >
          {speaker ? '开启' : '关闭'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="频率">
        <NumberInput
          animated
          unit="kHz"
          step={0.2}
          stepPixelSize={10}
          minValue={minFrequency / 10}
          maxValue={maxFrequency / 10}
          value={frequency / 10}
          format={(value) => toFixed(value, 1)}
          onDrag={(value) =>
            act('equip_act', {
              ref: ref,
              gear_action: 'set_frequency',
              new_frequency: value * 10,
            })
          }
        />
      </LabeledList.Item>
    </>
  );
};

const SnowflakeAirTank = (props) => {
  const { act, data } = useBackend<MainData>();
  const { cabin_sealed, one_atmosphere } = data;
  const { ref, integrity, active } = props.module;
  const {
    auto_pressurize_on_seal,
    port_connected,
    tank_release_pressure,
    tank_release_pressure_min,
    tank_release_pressure_max,
    tank_pump_active,
    tank_pump_direction,
    tank_pump_pressure,
    tank_pump_pressure_min,
    tank_pump_pressure_max,
    tank_air,
    cabin_air,
  } = props.module.snowflake;
  return (
    <Box>
      <LabeledList>
        {integrity < 1 && (
          <LabeledList.Item
            label="完整度"
            buttons={
              <Button
                content="维修"
                icon="wrench"
                onClick={() =>
                  act('equip_act', {
                    ref: ref,
                    gear_action: 'repair',
                  })
                }
              />
            }
          >
            <ProgressBar
              ranges={{
                good: [0.75, Infinity],
                average: [0.25, 0.75],
                bad: [-Infinity, 0.25],
              }}
              value={integrity}
            />
          </LabeledList.Item>
        )}
      </LabeledList>
      <Section
        title="气罐"
        buttons={
          <Button
            icon="power-off"
            content={
              active ? (!cabin_sealed ? '释放暂停' : '加压驾驶舱') : '释放关闭'
            }
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'toggle',
              })
            }
            selected={active}
          />
        }
      >
        <LabeledList>
          <LabeledList.Item label="自动调节">
            <Button
              content={auto_pressurize_on_seal ? '密封加压' : '手动'}
              selected={auto_pressurize_on_seal}
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'toggle_auto_pressurize',
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="驾驶舱气压">
            <NumberInput
              value={tank_release_pressure}
              unit="kPa"
              width="75px"
              minValue={tank_release_pressure_min}
              maxValue={tank_release_pressure_max}
              step={10}
              onChange={(value) =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'set_cabin_pressure',
                  new_pressure: value,
                })
              }
            />
            <Button
              icon="sync"
              disabled={tank_release_pressure === Math.round(one_atmosphere)}
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'set_cabin_pressure',
                  new_pressure: Math.round(one_atmosphere),
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item
            label="管道端口"
            buttons={
              <Button
                icon="info"
                color="transparent"
                tooltip="停在在气体连接端口上，将内部气罐与气体网络连接起来."
              />
            }
          >
            <Button
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  gear_action: 'toggle_port',
                })
              }
              selected={port_connected}
            >
              {port_connected ? '已连接' : '连接断开'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="外部气泵"
        buttons={
          <Button
            icon="power-off"
            content={tank_pump_active ? 'On' : 'Off'}
            selected={tank_pump_active}
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'toggle_tank_pump',
              })
            }
          />
        }
      >
        <LabeledList.Item label="方向">
          <Button
            content={tank_pump_direction ? '外部 → 气罐' : '气罐 → 外部'}
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'toggle_tank_pump_direction',
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="目标气压">
          <NumberInput
            value={tank_pump_pressure}
            unit="kPa"
            width="75px"
            minValue={tank_pump_pressure_min}
            maxValue={tank_pump_pressure_max}
            step={10}
            format={(value) => `${Math.round(value)}`}
            onChange={(value) =>
              act('equip_act', {
                ref: ref,
                gear_action: 'set_tank_pump_pressure',
                new_pressure: value,
              })
            }
          />
          <Button
            icon="sync"
            disabled={tank_pump_pressure === Math.round(one_atmosphere)}
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'set_tank_pump_pressure',
                new_pressure: Math.round(one_atmosphere),
              })
            }
          />
        </LabeledList.Item>
      </Section>
      <Section title="传感器">
        <Collapsible title="气罐空气">
          <GasmixParser gasmix={tank_air} />
        </Collapsible>
        {cabin_sealed ? (
          <Collapsible title="驾驶舱空气">
            <GasmixParser gasmix={cabin_air} />
          </Collapsible>
        ) : (
          <NoticeBox>
            <Icon name="wind" mr={1} />
            驾驶舱开启
          </NoticeBox>
        )}
      </Section>
    </Box>
  );
};

const SnowflakeOrebox = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { contents } = props.module.snowflake;
  return (
    <Section
      title="内容空间"
      buttons={
        <Button
          icon="arrows-down-to-line"
          content="丢弃"
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'dump',
            })
          }
          disabled={!Object.keys(contents).length}
        />
      }
    >
      {Object.keys(contents).length ? (
        Object.keys(contents).map((item, i) => (
          <Stack key={i}>
            <Stack.Item lineHeight="0">
              <Box
                m="-4px"
                className={classes([
                  'mecha_equipment32x32',
                  contents[item].icon,
                ])}
              />
            </Stack.Item>
            <Stack.Item
              lineHeight="24px"
              style={{
                textTransform: 'capitalize',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
            >
              {`${contents[item].amount}x ${contents[item].name}`}
            </Stack.Item>
          </Stack>
        ))
      ) : (
        <NoticeBox info>矿石箱是空的</NoticeBox>
      )}
    </Section>
  );
};

const SnowflakeCargo = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { cargo, cargo_capacity } = props.module.snowflake;
  return (
    <Box>
      <Section title="内容空间" buttons={`${cargo.length} / ${cargo_capacity}`}>
        {!cargo.length ? (
          <NoticeBox info>容室是空的</NoticeBox>
        ) : (
          cargo.map((item, i) => (
            <Button
              fluid
              py={0.2}
              key={i}
              icon="eject"
              onClick={() =>
                act('equip_act', {
                  ref: ref,
                  cargoref: item.ref,
                  gear_action: 'eject',
                })
              }
              style={{
                textTransform: 'capitalize',
              }}
            >
              {item.name}
            </Button>
          ))
        )}
      </Section>
    </Box>
  );
};

const SnowflakeExtinguisher = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { reagents, total_reagents, reagents_required } =
    props.module.snowflake;
  return (
    <>
      <LabeledList.Item
        label="水"
        buttons={
          <Button
            content="重注满"
            icon="fill"
            onClick={() =>
              act('equip_act', {
                ref: ref,
                gear_action: 'refill',
              })
            }
          />
        }
      >
        <ProgressBar value={reagents} minValue={0} maxValue={total_reagents}>
          {reagents}
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="灭火器">
        <Button
          content="激活"
          color="red"
          disabled={reagents < reagents_required}
          icon="fire-extinguisher"
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'activate',
            })
          }
        />
      </LabeledList.Item>
    </>
  );
};

const SnowflakeGeneraor = (props) => {
  const { act, data } = useBackend<MainData>();
  const { sheet_material_amount } = data;
  const { ref, active, name } = props.module;
  const { fuel } = props.module.snowflake;
  return (
    <LabeledList.Item label="燃料量">
      {fuel === null
        ? '无'
        : toFixed(fuel * sheet_material_amount, 0.1) + ' cm³'}
    </LabeledList.Item>
  );
};

const SnowflakeOreScanner = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { cooldown } = props.module.snowflake;
  return (
    <LabeledList.Item label="通风口扫描仪">
      <NoticeBox info={cooldown <= 0 ? true : false}>
        {cooldown / 10 > 0 ? '充能中...' : '已准备好扫描'}
        <Button
          my={1}
          width="100%"
          icon="satellite-dish"
          color={cooldown <= 0 ? 'green' : 'transparent'}
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'area_scan',
            })
          }
          disabled={cooldown <= 0 ? false : true}
        >
          扫描附近所有通风口
        </Button>
      </NoticeBox>
    </LabeledList.Item>
  );
};

const SnowflakeLawClaw = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { autocuff } = props.module.snowflake;
  return (
    <LabeledList.Item
      label="手铐嫌犯"
      buttons={
        <Button
          content="开关"
          color={autocuff ? 'green' : 'blue'}
          icon="handcuffs"
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'togglecuff',
            })
          }
        />
      }
    />
  );
};

const SnowflakeRCD = (props) => {
  const { act, data } = useBackend<MainData>();
  const { ref } = props.module;
  const { scan_ready, deconstructing, mode } = props.module.snowflake;
  return (
    <>
      <LabeledList.Item label="破坏性扫描">
        <Button
          icon="satellite-dish"
          color={scan_ready ? 'green' : 'transparent'}
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'rcd_scan',
            })
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="解构中">
        <Button
          icon="power-off"
          content={deconstructing ? '开' : '关'}
          color={deconstructing ? 'green' : 'blue'}
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'toggle_deconstruct',
            })
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="建筑模式">
        <Button
          content={mode}
          onClick={() =>
            act('equip_act', {
              ref: ref,
              gear_action: 'change_mode',
            })
          }
        />
      </LabeledList.Item>
    </>
  );
};
