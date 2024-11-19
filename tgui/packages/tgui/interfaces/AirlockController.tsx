import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type AirlockControllerData = {
  airlockState: string;
  sensorPressure: number;
  pumpStatus: string;
  interiorStatus: string;
  exteriorStatus: string;
};

type AirlockStatus = {
  primary: string;
  icon: string;
  color: string;
};

export const AirlockController = (props) => {
  const { data } = useBackend<AirlockControllerData>();
  const { airlockState, pumpStatus, interiorStatus, exteriorStatus } = data;
  const currentStatus: AirlockStatus = getAirlockStatus(airlockState);
  const nameToUpperCase = (str: string) =>
    str.replace(/^\w/, (c) => c.toUpperCase());

  return (
    <Window width={500} height={190}>
      <Window.Content>
        <Section title="气闸状况" buttons={<AirLockButtons />}>
          <LabeledList>
            <LabeledList.Item label="当前状况">
              {currentStatus.primary}
            </LabeledList.Item>
            <LabeledList.Item label="室内气压">
              <PressureIndicator currentStatus={currentStatus} />
            </LabeledList.Item>
            <LabeledList.Item label="控制泵">
              {nameToUpperCase(pumpStatus)}
            </LabeledList.Item>
            <LabeledList.Item label="内部门">
              <Box color={interiorStatus === 'open' && 'good'}>
                {nameToUpperCase(interiorStatus)}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="外部门">
              <Box color={exteriorStatus === 'open' && 'good'}>
                {nameToUpperCase(exteriorStatus)}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Displays the buttons on top of the window to cycle the airlock */
const AirLockButtons = (props) => {
  const { act, data } = useBackend<AirlockControllerData>();
  const { airlockState } = data;
  switch (airlockState) {
    case 'pressurize':
    case 'depressurize':
      return (
        <Button icon="stop-circle" onClick={() => act('abort')}>
          中止
        </Button>
      );
    case 'closed':
      return (
        <>
          <Button icon="lock-open" onClick={() => act('cycleInterior')}>
            开启内部气闸
          </Button>
          <Button icon="lock-open" onClick={() => act('cycleExterior')}>
            开启外部气闸
          </Button>
        </>
      );
    case 'inopen':
      return (
        <>
          <Button icon="lock" onClick={() => act('cycleClosed')}>
            关闭内部气闸
          </Button>
          <Button icon="sync" onClick={() => act('cycleExterior')}>
            循环外部气闸
          </Button>
        </>
      );
    case 'outopen':
      return (
        <>
          <Button icon="lock" onClick={() => act('cycleClosed')}>
            关闭外部气闸
          </Button>
          <Button icon="sync" onClick={() => act('cycleInterior')}>
            循环内部气闸
          </Button>
        </>
      );
    default:
      return null;
  }
};

/** Displays the numeric pressure alongside an icon for the user */
const PressureIndicator = (props) => {
  const { data } = useBackend<AirlockControllerData>();
  const { sensorPressure } = data;
  const {
    currentStatus: { icon, color },
  } = props;
  let spin = icon === 'fan';

  return (
    <Box color={color}>
      {sensorPressure} kPa {icon && <Icon name={icon} spin={spin} />}
    </Box>
  );
};

/** Displays the current status as two text strings, depending on door state. */
const getAirlockStatus = (airlockState): AirlockStatus => {
  switch (airlockState) {
    case 'inopen':
      return {
        primary: '内部气闸开启',
        icon: '',
        color: 'good',
      };
    case 'pressurize':
      return {
        primary: '循环至内部气闸',
        icon: 'fan',
        color: 'average',
      };
    case 'closed':
      return {
        primary: '不运转',
        icon: '',
        color: 'white',
      };
    case 'depressurize':
      return {
        primary: '循环至外部气闸',
        icon: 'fan',
        color: 'average',
      };
    case 'outopen':
      return {
        primary: '外部气闸开启',
        icon: 'exclamation-triangle',
        color: 'bad',
      };
    default:
      return {
        primary: '位置',
        icon: '',
        color: 'average',
      };
  }
};
