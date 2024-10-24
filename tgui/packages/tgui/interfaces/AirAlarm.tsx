import { BooleanLike } from 'common/react';
import { Fragment } from 'react';
import {
  Box,
  Button,
  LabeledList,
  Modal,
  NumberInput,
  Section,
  Table,
  VirtualList,
} from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import {
  Scrubber,
  ScrubberProps,
  Vent,
  VentProps,
} from './common/AtmosControls';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type AirAlarmData = {
  locked: BooleanLike;
  siliconUser: BooleanLike;
  emagged: BooleanLike;
  dangerLevel: 0 | 1 | 2;
  atmosAlarm: BooleanLike; // fix this
  fireAlarm: BooleanLike;
  faultStatus: 0 | 1 | 2;
  faultLocation: string;
  sensor: BooleanLike;
  allowLinkChange: BooleanLike;
  envData: {
    name: string;
    value: string; // preformatted in backend, shorter code that way.
    danger: 0 | 1 | 2;
  }[];
  tlvSettings: {
    id: string;
    name: string;
    unit: string;
    warning_min: number;
    hazard_min: number;
    warning_max: number;
    hazard_max: number;
  }[];
  vents: VentProps[];
  scrubbers: ScrubberProps[];
  selectedModePath: string;
  panicSiphonPath: string;
  filteringPath: string;
  modes: {
    name: string;
    desc: string;
    path: string;
    danger: BooleanLike;
  }[];
  thresholdTypeMap: Record<string, number>;
};

export const AirAlarm = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const locked = data.locked && !data.siliconUser;
  return (
    <Window width={475} height={650}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox />
        <AirAlarmStatus />
        {!locked && <AirAlarmControl />}
      </Window.Content>
    </Window>
  );
};

const AirAlarmStatus = (props) => {
  const { data } = useBackend<AirAlarmData>();
  const { envData } = data;
  const dangerMap = {
    0: {
      color: 'good',
      localStatusText: '最佳',
    },
    1: {
      color: 'average',
      localStatusText: '注意',
    },
    2: {
      color: 'bad',
      localStatusText: '危险 (室内需求)',
    },
  };
  const faultMap = {
    0: {
      color: 'green',
      areaFaultText: '无',
    },
    1: {
      color: 'purple',
      areaFaultText: '手动触发',
    },
    2: {
      color: 'average',
      areaFaultText: '自动检测',
    },
  };
  const localStatus = dangerMap[data.dangerLevel] || dangerMap[0];
  const areaFault = faultMap[data.faultStatus] || faultMap[0];
  return (
    <Section title="空气状况">
      <LabeledList>
        {(envData.length > 0 && (
          <>
            {envData.map((entry) => {
              const status = dangerMap[entry.danger] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={entry.name}
                  color={status.color}
                >
                  {entry.value}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item label="本地状况" color={localStatus.color}>
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="区域状况"
              color={data.atmosAlarm || data.fireAlarm ? 'bad' : 'good'}
            >
              {(data.atmosAlarm && '大气警报') ||
                (data.fireAlarm && '火灾警报') ||
                '运行正常'}
            </LabeledList.Item>
            <LabeledList.Item label="故障状况" color={areaFault.color}>
              {areaFault.areaFaultText}
            </LabeledList.Item>
            <LabeledList.Item
              label="故障定位"
              color={data.faultLocation ? 'blue' : 'green'}
            >
              {data.faultLocation || '无'}
            </LabeledList.Item>
          </>
        )) || (
          <LabeledList.Item label="警告" color="bad">
            无法获得空气样本进行分析.
          </LabeledList.Item>
        )}
        {!!data.emagged && (
          <LabeledList.Item label="警告" color="bad">
            安全措施离线，设备可能出现异常行为.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const AIR_ALARM_ROUTES = {
  home: {
    title: '空气控制',
    component: () => AirAlarmControlHome,
  },
  vents: {
    title: '通风口控制',
    component: () => AirAlarmControlVents,
  },
  scrubbers: {
    title: '抽气口控制',
    component: () => AirAlarmControlScrubbers,
  },
  modes: {
    title: '运行模式',
    component: () => AirAlarmControlModes,
  },
  thresholds: {
    title: '警报阈值',
    component: () => AirAlarmControlThresholds,
  },
} as const;

type Screen = keyof typeof AIR_ALARM_ROUTES;

const AirAlarmControl = (props) => {
  const [screen, setScreen] = useLocalState<Screen>('screen', 'home');
  const route = AIR_ALARM_ROUTES[screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={
        screen && (
          <Button
            icon="arrow-left"
            content="返回"
            onClick={() => setScreen('home')}
          />
        )
      }
    >
      <Component />
    </Section>
  );
};

//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [screen, setScreen] = useLocalState<Screen>('screen', 'home');
  const {
    selectedModePath,
    panicSiphonPath,
    filteringPath,
    atmosAlarm,
    sensor,
    allowLinkChange,
  } = data;
  const isPanicSiphoning = selectedModePath === panicSiphonPath;
  return (
    <>
      <Button
        icon={atmosAlarm ? 'exclamation-triangle' : 'exclamation'}
        color={atmosAlarm && 'caution'}
        content="区域大气警报"
        onClick={() => act(atmosAlarm ? 'reset' : 'alarm')}
      />
      <Box mt={1} />
      <Button
        icon={isPanicSiphoning ? 'exclamation-triangle' : 'exclamation'}
        color={isPanicSiphoning && 'danger'}
        content="恐慌性抽气"
        onClick={() =>
          act('mode', {
            mode: isPanicSiphoning ? filteringPath : panicSiphonPath,
          })
        }
      />
      <Box mt={2} />
      <Button
        icon="sign-out-alt"
        content="通风口控制"
        onClick={() => setScreen('vents')}
      />
      <Box mt={1} />
      <Button
        icon="filter"
        content="抽气口控制"
        onClick={() => setScreen('scrubbers')}
      />
      <Box mt={1} />
      <Button
        icon="cog"
        content="运行模式"
        onClick={() => setScreen('modes')}
      />
      <Box mt={1} />
      <Button
        icon="chart-bar"
        content="警报阈值"
        onClick={() => setScreen('thresholds')}
      />
      {!!sensor && !!allowLinkChange && (
        <Box mt={1}>
          <Button.Confirm
            icon="link-slash"
            content="断开传感器"
            color="danger"
            onClick={() => act('disconnect_sensor')}
          />
        </Box>
      )}
    </>
  );
};

//  Vents
// --------------------------------------------------------

const AirAlarmControlVents = (props) => {
  const { data } = useBackend<AirAlarmData>();
  const { vents } = data;
  if (!vents || vents.length === 0) {
    return <span>无可显示内容</span>;
  }
  return (
    <VirtualList>
      {vents.map((vent) => (
        <Vent key={vent.refID} {...vent} />
      ))}
    </VirtualList>
  );
};

//  Scrubbers
// --------------------------------------------------------

const AirAlarmControlScrubbers = (props) => {
  const { data } = useBackend<AirAlarmData>();
  const { scrubbers } = data;
  if (!scrubbers || scrubbers.length === 0) {
    return <span>无可显示内容</span>;
  }
  return (
    <VirtualList>
      {scrubbers.map((scrubber) => (
        <Scrubber key={scrubber.refID} {...scrubber} />
      ))}
    </VirtualList>
  );
};

//  Modes
// --------------------------------------------------------

const AirAlarmControlModes = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const { modes, selectedModePath } = data;
  if (!modes || modes.length === 0) {
    return <span>无可显示内容</span>;
  }
  return (
    <>
      {modes.map((mode) => (
        <Fragment key={mode.path}>
          <Button
            icon={
              mode.path === selectedModePath ? 'check-square-o' : 'square-o'
            }
            color={
              mode.path === selectedModePath && (mode.danger ? 'red' : 'green')
            }
            content={mode.name + ' - ' + mode.desc}
            onClick={() => act('mode', { mode: mode.path })}
          />
          <Box mt={1} />
        </Fragment>
      ))}
    </>
  );
};

//  Thresholds
// --------------------------------------------------------

type EditingModalProps = {
  id: string;
  name: string;
  type: number;
  typeVar: string;
  typeName: string;
  unit: string;
  oldValue: number;
  finish: () => void;
};

const EditingModal = (props: EditingModalProps) => {
  const { act, data } = useBackend<AirAlarmData>();
  const { id, name, type, typeVar, typeName, unit, oldValue, finish } = props;
  return (
    <Modal>
      <Section
        title={'阈值编辑器'}
        buttons={<Button onClick={() => finish()} icon="times" color="red" />}
      >
        <Box mb={1.5}>
          {`编辑${name.toLowerCase()}的${typeName.toLowerCase()}值...`}
        </Box>
        {oldValue === -1 ? (
          <Button
            onClick={() =>
              act('set_threshold', {
                threshold: id,
                threshold_type: type,
                value: 0,
              })
            }
          >
            {'开启'}
          </Button>
        ) : (
          <>
            <NumberInput
              onChange={(value) =>
                act('set_threshold', {
                  threshold: id,
                  threshold_type: type,
                  value: value,
                })
              }
              unit={unit}
              value={oldValue}
              minValue={0}
              maxValue={100000}
              step={10}
            />
            <Button
              onClick={() =>
                act('set_threshold', {
                  threshold: id,
                  threshold_type: type,
                  value: -1,
                })
              }
            >
              {'关闭'}
            </Button>
          </>
        )}
      </Section>
    </Modal>
  );
};

const AirAlarmControlThresholds = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [activeModal, setActiveModal] = useLocalState<Omit<
    EditingModalProps,
    'oldValue'
  > | null>('tlvModal', null);
  const { tlvSettings, thresholdTypeMap } = data;
  return (
    <>
      <Table>
        <Table.Row>
          <Table.Cell bold>Threshold</Table.Cell>
          <Table.Cell bold color="bad">
            低于时危险
          </Table.Cell>
          <Table.Cell bold color="average">
            低于时警告
          </Table.Cell>
          <Table.Cell bold color="average">
            高于时警告
          </Table.Cell>
          <Table.Cell bold color="bad">
            高于时危险
          </Table.Cell>
          <Table.Cell bold>Actions</Table.Cell>
        </Table.Row>
        {tlvSettings.map((tlv) => (
          <Table.Row key={tlv.name}>
            <Table.Cell>{tlv.name}</Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['hazard_min'],
                    typeVar: 'hazard_min',
                    typeName: 'Minimum Hazard',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }
              >
                {tlv.hazard_min === -1
                  ? '关闭'
                  : tlv.hazard_min + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['warning_min'],
                    typeVar: 'warning_min',
                    typeName: 'Minimum Warning',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }
              >
                {tlv.warning_min === -1
                  ? '关闭'
                  : tlv.warning_min + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['warning_max'],
                    typeVar: 'warning_max',
                    typeName: 'Maximum Warning',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }
              >
                {tlv.warning_max === -1
                  ? '关闭'
                  : tlv.warning_max + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['hazard_max'],
                    typeVar: 'hazard_max',
                    typeName: 'Maximum Hazard',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }
              >
                {tlv.hazard_max === -1
                  ? '关闭'
                  : tlv.hazard_max + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <>
                <Button
                  color="green"
                  icon="sync"
                  onClick={() =>
                    act('reset_threshold', {
                      threshold: tlv.id,
                      threshold_type: thresholdTypeMap['all'],
                    })
                  }
                />
                <Button
                  color="red"
                  icon="times"
                  onClick={() =>
                    act('set_threshold', {
                      threshold: tlv.id,
                      threshold_type: thresholdTypeMap['all'],
                      value: -1,
                    })
                  }
                />
              </>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
      {activeModal && (
        <EditingModal
          oldValue={
            (tlvSettings.find((tlv) => tlv.id === activeModal.id) || {})[
              activeModal.typeVar
            ]
          }
          {...activeModal}
        />
      )}
    </>
  );
};
