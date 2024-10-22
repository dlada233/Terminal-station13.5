import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Collapsible,
  ColorBox,
  Dimmer,
  Dropdown,
  Icon,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { formatEnergy, formatPower, formatSiUnit } from '../format';
import { Window } from '../layouts';

type MODsuitData = {
  // Static
  ui_theme: string;
  control: string;
  complexity_max: number;
  parts: PartData[];
  // Dynamic
  suit_status: SuitStatus;
  user_status: UserStatus;
  module_custom_status: ModuleCustomStatus;
  module_info: Module[];
};

type PartData = {
  slot: string;
  name: string;
};

type SuitStatus = {
  core_name: string;
  cell_charge_current: number;
  cell_charge_max: number;
  active: BooleanLike;
  open: BooleanLike;
  seconds_electrified: number;
  malfunctioning: BooleanLike;
  locked: BooleanLike;
  interface_break: BooleanLike;
  complexity: number;
  selected_module: string;
  ai_name: string;
  has_pai: boolean;
  is_ai: boolean;
  link_id: string;
  link_freq: string;
  link_call: string;
};

type UserStatus = {
  user_name: string;
  user_assignment: string;
};

type ModuleCustomStatus = {
  health: number;
  health_max: number;
  loss_brute: number;
  loss_fire: number;
  loss_tox: number;
  loss_oxy: number;
  is_user_irradiated: BooleanLike;
  background_radiation_level: number;
  display_time: BooleanLike;
  shift_time: string;
  shift_id: string;
  body_temperature: number;
  nutrition: number;
  dna_unique_identity: string;
  dna_unique_enzymes: string;
  viruses: VirusData[];
};

type VirusData = {
  name: string;
  type: string;
  stage: number;
  maxstage: number;
  cure: string;
};

type Module = {
  module_name: string;
  description: string;
  module_type: number;
  module_active: BooleanLike;
  pinned: BooleanLike;
  idle_power: number;
  active_power: number;
  use_energy: number;
  module_complexity: number;
  cooldown_time: number;
  cooldown: number;
  id: string;
  ref: string;
  configuration_data: ModuleConfig[];
};

type ModuleConfig = {
  display_name: string;
  type: string;
  value: number;
  values: [];
};

export const MODsuit = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { ui_theme } = data;
  const { interface_break } = data.suit_status;
  return (
    <Window width={800} height={640} theme={ui_theme} title="模块服界面">
      <Window.Content scrollable={!interface_break}>
        <MODsuitContent />
      </Window.Content>
    </Window>
  );
};

export const MODsuitContent = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { interface_break } = data.suit_status;
  return (
    <Box>
      {interface_break ? (
        <LockedInterface />
      ) : (
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <SuitStatusSection />
              </Stack.Item>
              <Stack.Item grow>
                <UserStatusSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <ModuleSection />
          </Stack.Item>
          <Stack.Item>
            <HardwareSection />
          </Stack.Item>
        </Stack>
      )}
    </Box>
  );
};

const ConfigureNumberEntry = (props) => {
  const { name, value, module_ref } = props;
  const { act } = useBackend();
  return (
    <NumberInput
      value={value}
      minValue={-50}
      maxValue={50}
      step={1}
      stepPixelSize={5}
      width="39px"
      onChange={(value) =>
        act('configure', {
          key: name,
          value: value,
          ref: module_ref,
        })
      }
    />
  );
};

const ConfigureBoolEntry = (props) => {
  const { name, value, module_ref } = props;
  const { act } = useBackend();
  return (
    <Button.Checkbox
      checked={value}
      onClick={() =>
        act('configure', {
          key: name,
          value: !value,
          ref: module_ref,
        })
      }
    />
  );
};

const ConfigureColorEntry = (props) => {
  const { name, value, module_ref } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="paint-brush"
        onClick={() =>
          act('configure', {
            key: name,
            ref: module_ref,
          })
        }
      />
      <ColorBox color={value} mr={0.5} />
    </>
  );
};

const ConfigureListEntry = (props) => {
  const { name, value, values, module_ref } = props;
  const { act } = useBackend();
  return (
    <Dropdown
      selected={value}
      options={values}
      onSelected={(value) =>
        act('configure', {
          key: name,
          value: value,
          ref: module_ref,
        })
      }
    />
  );
};

const ConfigurePinEntry = (props) => {
  const { name, value, module_ref } = props;
  const { act } = useBackend();
  return (
    <Button
      onClick={() =>
        act('configure', { key: name, value: !value, ref: module_ref })
      }
      icon="thumbtack"
      selected={value}
      tooltip="放置快捷按钮"
      tooltipPosition="left"
    />
  );
};

const ConfigureDataEntry = (props) => {
  const { name, display_name, type, value, values, module_ref } = props;
  const configureEntryTypes = {
    number: <ConfigureNumberEntry {...props} />,
    bool: <ConfigureBoolEntry {...props} />,
    color: <ConfigureColorEntry {...props} />,
    list: <ConfigureListEntry {...props} />,
    pin: <ConfigurePinEntry {...props} />,
  };
  return (
    <LabeledList.Item label={display_name}>
      {configureEntryTypes[type]}
    </LabeledList.Item>
  );
};

const LockedInterface = () => (
  <Section align="center" fill>
    <Icon color="red" name="exclamation-triangle" size={15} />
    <Box fontSize="30px" color="red">
      错误: 界面无响应
    </Box>
  </Section>
);

const LockedModule = (props) => {
  const { act, data } = useBackend();
  return (
    <Dimmer>
      <Stack>
        <Stack.Item fontSize="16px" color="blue">
          模块服无电力
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const ConfigureScreen = (props) => {
  const { configuration_data, module_ref, module_name } = props;
  const configuration_keys = Object.keys(configuration_data);
  return (
    <Box pb={1}>
      <LabeledList>
        {configuration_keys.map((key) => {
          const data = configuration_data[key];
          return (
            <ConfigureDataEntry
              key={data.key}
              name={key}
              display_name={data.display_name}
              type={data.type}
              value={data.value}
              values={data.values}
              module_ref={module_ref}
            />
          );
        })}
      </LabeledList>
    </Box>
  );
};

const moduleTypeAction = (param) => {
  switch (param) {
    case 1:
      return '使用';
    case 2:
      return '切换';
    case 3:
      return '选择';
  }
};

const radiationLevels = (param) => {
  switch (param) {
    case 1:
      return '低';
    case 2:
      return '中';
    case 3:
      return '高';
    case 4:
      return '极高';
  }
};

const SuitStatusSection = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const {
    core_name,
    cell_charge_current,
    cell_charge_max,
    active,
    open,
    seconds_electrified,
    malfunctioning,
    locked,
    ai_name,
    has_pai,
    is_ai,
    link_id,
    link_freq,
    link_call,
  } = data.suit_status;
  const { display_time, shift_time, shift_id } = data.module_custom_status;
  const status = malfunctioning ? '故障' : active ? '激活' : '未激活';
  const charge_percent = Math.round(
    (100 * cell_charge_current) / cell_charge_max,
  );

  return (
    <Section
      title="模块服状态"
      fill
      buttons={
        <Button
          icon="power-off"
          color={active ? 'good' : 'default'}
          content={status}
          onClick={() => act('activate')}
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="充能">
          <ProgressBar
            value={cell_charge_current / cell_charge_max}
            ranges={{
              good: [0.6, Infinity],
              average: [0.3, 0.6],
              bad: [-Infinity, 0.3],
            }}
            style={{
              textShadow: '1px 1px 0 black',
            }}
          >
            {!core_name
              ? '未检测到核心'
              : cell_charge_max === 1
                ? '缺少电池'
                : cell_charge_current === 1e31
                  ? '无限'
                  : `${formatSiUnit(
                      cell_charge_current,
                      0,
                      'J',
                    )} / ${formatSiUnit(
                      cell_charge_max,
                      0,
                      'J',
                    )} (${charge_percent}%)`}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="ID锁">
          <Button
            icon={locked ? 'lock' : 'lock-open'}
            color={locked ? 'good' : 'default'}
            content={locked ? '已上锁' : '未上锁'}
            onClick={() => act('lock')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="模块通话">
          <Button
            icon={'wifi'}
            color={link_call ? 'good' : 'default'}
            disabled={!link_freq}
            tooltip={link_freq ? '' : '使用多功能工具设置频率!'}
            content={
              link_freq
                ? link_call
                  ? '呼叫 (' + link_call + ')'
                  : '呼叫 (' + link_id + ')'
                : '频率未设置'
            }
            onClick={() => act('call')}
          />
        </LabeledList.Item>
        {!!open && (
          <LabeledList.Item label="覆盖">
            <Box color="red">开启</Box>
          </LabeledList.Item>
        )}
        {!!seconds_electrified && (
          <LabeledList.Item label="电路">
            <Box color="red">短路</Box>
          </LabeledList.Item>
        )}
        {!!ai_name && (
          <LabeledList.Item label="pAI 控制">
            {has_pai && (
              <Button
                icon="eject"
                content="取出pAI"
                disabled={is_ai}
                onClick={() => act('eject_pai')}
              />
            )}
          </LabeledList.Item>
        )}
      </LabeledList>
      {!!display_time && (
        <Section title="操作" mt={2}>
          <LabeledList.Item label="时间">
            {active ? shift_time : '00:00:00'}
          </LabeledList.Item>
          <LabeledList.Item label="数字">
            {active && shift_id ? shift_id : '???'}
          </LabeledList.Item>
        </Section>
      )}
    </Section>
  );
};

const HardwareSection = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { control } = data;
  const { ai_name, core_name } = data.suit_status;
  return (
    <Section title="硬件设备" style={{ textTransform: 'capitalize' }}>
      <LabeledList>
        <LabeledList.Item label="AI助手">
          {ai_name || '未检测到AI'}
        </LabeledList.Item>
        <LabeledList.Item label="核心">
          {core_name || '未检测到核心'}
        </LabeledList.Item>
        <LabeledList.Item label="控制单元">{control}</LabeledList.Item>
        <ModParts />
      </LabeledList>
    </Section>
  );
};

const ModParts = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { parts } = data;
  return (
    <>
      {parts.map((part) => {
        return (
          <LabeledList.Item key={part.slot} label={part.slot + '插槽'}>
            {part.name}
          </LabeledList.Item>
        );
      })}
    </>
  );
};

const UserStatusSection = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { active } = data.suit_status;
  const { user_name, user_assignment } = data.user_status;
  const {
    health,
    health_max,
    loss_brute,
    loss_fire,
    loss_tox,
    loss_oxy,
    is_user_irradiated,
    background_radiation_level,
    body_temperature,
    nutrition,
    dna_unique_identity,
    dna_unique_enzymes,
    viruses,
  } = data.module_custom_status;
  return (
    <Section title="用户状态" fill>
      {!active && <LockedModule />}
      <LabeledList>
        {health !== undefined && (
          <LabeledList.Item label="健康">
            <ProgressBar
              value={active ? health / health_max : 0}
              ranges={{
                good: [0.5, Infinity],
                average: [0.2, 0.5],
                bad: [-Infinity, 0.2],
              }}
            >
              <AnimatedNumber value={active ? health : 0} />
            </ProgressBar>
          </LabeledList.Item>
        )}
        {loss_brute !== undefined && (
          <LabeledList.Item label="创伤">
            <ProgressBar
              value={active ? loss_brute / health_max : 0}
              ranges={{
                good: [-Infinity, 0.2],
                average: [0.2, 0.5],
                bad: [0.5, Infinity],
              }}
            >
              <AnimatedNumber value={active ? loss_brute : 0} />
            </ProgressBar>
          </LabeledList.Item>
        )}
        {loss_fire !== undefined && (
          <LabeledList.Item label="烧伤">
            <ProgressBar
              value={active ? loss_fire / health_max : 0}
              ranges={{
                good: [-Infinity, 0.2],
                average: [0.2, 0.5],
                bad: [0.5, Infinity],
              }}
            >
              <AnimatedNumber value={active ? loss_fire : 0} />
            </ProgressBar>
          </LabeledList.Item>
        )}
        {loss_oxy !== undefined && (
          <LabeledList.Item label="窒息伤">
            <ProgressBar
              value={active ? loss_oxy / health_max : 0}
              ranges={{
                good: [-Infinity, 0.2],
                average: [0.2, 0.5],
                bad: [0.5, Infinity],
              }}
            >
              <AnimatedNumber value={active ? loss_oxy : 0} />
            </ProgressBar>
          </LabeledList.Item>
        )}
        {loss_tox !== undefined && (
          <LabeledList.Item label="毒素伤">
            <ProgressBar
              value={active ? loss_tox / health_max : 0}
              ranges={{
                good: [-Infinity, 0.2],
                average: [0.2, 0.5],
                bad: [0.5, Infinity],
              }}
            >
              <AnimatedNumber value={active ? loss_tox : 0} />
            </ProgressBar>
          </LabeledList.Item>
        )}
        {background_radiation_level !== undefined && (
          <LabeledList.Item label="辐射">
            {!active ? (
              'Unknown'
            ) : is_user_irradiated ? (
              <NoticeBox danger>User Irradiated</NoticeBox>
            ) : background_radiation_level ? (
              <NoticeBox>
                {`环境辐射: ${radiationLevels(background_radiation_level)}`}
              </NoticeBox>
            ) : (
              <NoticeBox info>Not Detected</NoticeBox>
            )}
          </LabeledList.Item>
        )}
        {body_temperature !== undefined && (
          <LabeledList.Item label="体温">
            {`${active ? Math.round(body_temperature) : 0} K`}
          </LabeledList.Item>
        )}
        {nutrition !== undefined && (
          <LabeledList.Item label="饱腹感">
            {`${active ? Math.round(nutrition) : 0}`}
          </LabeledList.Item>
        )}
        <LabeledList.Item label="姓名">{user_name}</LabeledList.Item>
        <LabeledList.Item label="工作">{user_assignment}</LabeledList.Item>
        {dna_unique_identity !== undefined && (
          <LabeledList.Item label="指纹">
            <Box
              style={{
                wordBreak: 'break-all',
                wordWrap: 'break-word',
              }}
            >
              {active ? dna_unique_identity : '???'}
            </Box>
          </LabeledList.Item>
        )}
        {dna_unique_enzymes !== undefined && (
          <LabeledList.Item label="DNA酶">
            <Box
              style={{
                wordBreak: 'break-all',
                wordWrap: 'break-word',
              }}
            >
              {active ? dna_unique_enzymes : '???'}
            </Box>
          </LabeledList.Item>
        )}
      </LabeledList>
      {!!viruses && (
        <Section title="疾病">
          {viruses.map((virus) => {
            return (
              <Collapsible title={virus.name} key={virus.name}>
                <LabeledList>
                  <LabeledList.Item label="传染性">
                    {virus.type}
                  </LabeledList.Item>
                  <LabeledList.Item label="阶段">
                    {virus.stage}/{virus.maxstage}
                  </LabeledList.Item>
                  <LabeledList.Item label="治愈方法">
                    {virus.cure}
                  </LabeledList.Item>
                </LabeledList>
              </Collapsible>
            );
          })}
        </Section>
      )}
    </Section>
  );
};

const ModuleSection = (props) => {
  const { act, data } = useBackend<MODsuitData>();
  const { complexity_max, module_info } = data;
  const { complexity } = data.suit_status;
  const [configureState, setConfigureState] = useState('');

  return (
    <Section
      title="模块"
      fill
      buttons={`${complexity} / ${complexity_max} 复杂度已使用.`}
    >
      {!module_info.length ? (
        <NoticeBox>未检测到模块</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell colSpan={3}>作用</Table.Cell>
            <Table.Cell>名称</Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="plug"
                tooltip="闲置能量花费"
                tooltipPosition="top"
              />
            </Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="lightbulb"
                tooltip="激活能量花费"
                tooltipPosition="top"
              />
            </Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="bolt"
                tooltip="使用能量花费"
                tooltipPosition="top"
              />
            </Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="save"
                tooltip="复杂度"
                tooltipPosition="top"
              />
            </Table.Cell>
          </Table.Row>
          {module_info.map((module) => {
            return (
              <Table.Row key={module.ref}>
                <Table.Cell width={1}>
                  <Button
                    onClick={() => act('select', { ref: module.ref })}
                    icon={
                      module.module_type === 3
                        ? module.module_active
                          ? 'check-square-o'
                          : 'square-o'
                        : 'power-off'
                    }
                    selected={module.module_active}
                    tooltip={moduleTypeAction(module.module_type)}
                    tooltipPosition="left"
                    disabled={!module.module_type || module.cooldown > 0}
                  />
                </Table.Cell>
                <Table.Cell width={1}>
                  <Button
                    onClick={() =>
                      setConfigureState(
                        configureState === module.ref ? '' : module.ref,
                      )
                    }
                    icon="cog"
                    selected={configureState === module.ref}
                    tooltip="配置"
                    tooltipPosition="left"
                    disabled={module.configuration_data.length === 0}
                  />
                </Table.Cell>
                <Table.Cell width={1}>
                  <Button
                    onClick={() => act('pin', { ref: module.ref })}
                    icon="thumbtack"
                    selected={module.pinned}
                    tooltip="添加快捷按钮"
                    tooltipPosition="left"
                    disabled={!module.module_type}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Collapsible
                    title={module.module_name}
                    color={module.module_active ? 'green' : 'default'}
                  >
                    <Section mr={-19}>{module.description}</Section>
                  </Collapsible>
                  {configureState === module.ref && (
                    <ConfigureScreen
                      configuration_data={module.configuration_data}
                      module_ref={module.ref}
                      module_name={module.module_name}
                    />
                  )}
                </Table.Cell>
                <Table.Cell textAlign="center">
                  <div
                    style={{
                      display: 'inline-block',
                      width: '60px',
                    }}
                  >
                    {formatPower(module.idle_power)}
                  </div>
                </Table.Cell>
                <Table.Cell textAlign="center">
                  <div
                    style={{
                      display: 'inline-block',
                      width: '60px',
                    }}
                  >
                    {formatPower(module.active_power)}
                  </div>
                </Table.Cell>
                <Table.Cell textAlign="center">
                  <div
                    style={{
                      display: 'inline-block',
                      width: '60px',
                    }}
                  >
                    {formatEnergy(module.use_energy)}
                  </div>
                </Table.Cell>
                <Table.Cell textAlign="center">
                  <div
                    style={{
                      display: 'inline-block',
                      width: '10px',
                    }}
                  >
                    {module.module_complexity}
                  </div>
                </Table.Cell>
              </Table.Row>
            );
          })}
        </Table>
      )}
    </Section>
  );
};
