import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  Dropdown,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  transportId: string;
  controllerActive: number;
  controllerOperational: BooleanLike;
  travelDirection: number;
  destinationPlatform: string;
  idlePlatform: string;
  recoveryMode: BooleanLike;
  currentSpeed: number;
  currentLoad: number;
  statusSF: BooleanLike;
  statusCE: BooleanLike;
  statusES: BooleanLike;
  statusPD: BooleanLike;
  statusDR: BooleanLike;
  statusCL: BooleanLike;
  statusBS: BooleanLike;
  destinations: TramDestination[];
};

type TramDestination = {
  name: string;
  dest_icons: string[];
  id: number;
};

export const TramController = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    transportId,
    controllerActive,
    controllerOperational,
    travelDirection,
    destinationPlatform,
    idlePlatform,
    recoveryMode,
    currentSpeed,
    currentLoad,
    statusSF,
    statusCE,
    statusES,
    statusPD,
    statusDR,
    statusCL,
    statusBS,
    destinations = [],
  } = data;

  const [tripDestination, setTripDestination] = useState('');

  return (
    <Window title="电车控制" width={778} height={327} theme="dark">
      <Window.Content>
        <Stack>
          <Stack.Item grow={4}>
            <Section title="系统状态">
              <LabeledList>
                <LabeledList.Item label="系统ID">
                  {transportId}
                </LabeledList.Item>
                <LabeledList.Item
                  label="控制器队列"
                  color={controllerActive ? 'blue' : 'good'}
                >
                  {controllerActive ? '处理中' : '就绪'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="机器状态"
                  color={controllerOperational ? 'good' : 'bad'}
                >
                  {controllerOperational ? '正常' : '故障'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="处理器状态"
                  color={recoveryMode ? 'average' : 'good'}
                >
                  {recoveryMode ? '过载' : '正常'}
                </LabeledList.Item>
                <LabeledList.Item label="处理器负载">
                  <ProgressBar
                    value={currentLoad}
                    minValue={0}
                    maxValue={15}
                    ranges={{
                      good: [-Infinity, 5],
                      average: [5, 7.5],
                      bad: [7.5, Infinity],
                    }}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="当前速度">
                  <ProgressBar
                    value={currentSpeed}
                    minValue={0}
                    maxValue={32}
                    ranges={{
                      good: [28, Infinity],
                      average: [24, 28],
                      bad: [0.1, 24],
                      white: [-Infinity, 0],
                    }}
                  >
                    {toFixed(currentSpeed * 2.25, 0) + ' km/h'}
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="位置数据">
              <LabeledList>
                <LabeledList.Item label="方向">
                  {travelDirection === 4 ? '出站' : '入站'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="待命平台"
                  color={controllerActive ? '' : 'blue'}
                >
                  {idlePlatform}
                </LabeledList.Item>
                <LabeledList.Item
                  label="目的地平台"
                  color={controllerActive ? 'blue' : ''}
                >
                  {destinationPlatform}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow={6}>
            <Section title="控制">
              <NoticeBox>
                纳米传讯不对因有轨电车而导致的任何伤害和死亡负责.
              </NoticeBox>
              <Button
                icon="arrows-rotate"
                color="yellow"
                my={1}
                lineHeight={2}
                width="28%"
                minHeight={2}
                textAlign="center"
                onClick={() => act('reset', {})}
              >
                重置/开启
              </Button>
              <Button
                icon="square"
                color="bad"
                my={1}
                lineHeight={2}
                width="28%"
                minHeight={2}
                textAlign="center"
                onClick={() => act('estop', {})}
              >
                急停/关闭
              </Button>
              <Button
                icon="play"
                color="green"
                disabled={statusES || statusSF}
                my={1}
                lineHeight={2}
                width="42%"
                minHeight={2}
                textAlign="center"
                onClick={() =>
                  act('dispatch', {
                    tripDestination: tripDestination,
                  })
                }
              >
                开始: 目的地
              </Button>
              <Dropdown
                width="98.5%"
                options={destinations.map((id) => id.name)}
                selected={tripDestination}
                placeholder="选择目的地"
                onSelected={(value) => setTripDestination(value)}
              />
              <Button
                icon="bars"
                color="blue"
                my={1}
                lineHeight={2}
                width="25%"
                minHeight={2}
                textAlign="center"
                onClick={() => act('dopen', {})}
              >
                开门
              </Button>
              <Button
                icon="bars"
                color="blue"
                my={1}
                lineHeight={2}
                width="25%"
                minHeight={2}
                textAlign="center"
                onClick={() => act('dclose', {})}
              >
                关门
              </Button>
              <Button
                icon="bars"
                color={statusBS ? 'good' : 'bad'}
                my={1}
                lineHeight={2}
                width="48%"
                minHeight={2}
                textAlign="center"
                onClick={() => act('togglesensors', {})}
              >
                旁路门传感器
              </Button>
            </Section>
            <Section title="Operational">
              <Button
                color={statusES ? 'red' : 'transparent'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                急停
              </Button>
              <Button
                color={statusSF ? 'yellow' : 'transparent'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                故障
              </Button>
              <Button
                color={statusCE ? 'teal' : 'transparent'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                通信
              </Button>
              <Button
                color={statusPD ? 'blue' : 'transparent'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                RQST
              </Button>
              <Button
                color={statusDR ? 'transparent' : 'blue'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                车门
              </Button>
              <Button
                color={statusCL ? 'blue' : 'transparent'}
                my={1}
                lineHeight={2}
                width="16%"
                minHeight={2}
                textAlign="center"
              >
                忙碌
              </Button>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
