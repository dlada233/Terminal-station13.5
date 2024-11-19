import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  sensorStatus: BooleanLike;
  operatingStatus: number;
  inboundPlatform: number;
  outboundPlatform: number;
};

export const CrossingSignal = (props) => {
  const { data } = useBackend<Data>();

  const { sensorStatus, operatingStatus, inboundPlatform, outboundPlatform } =
    data;

  return (
    <Window title="交通信号" width={400} height={175} theme="dark">
      <Window.Content>
        <Section title="系统状态">
          <LabeledList>
            <LabeledList.Item
              label="运行状态"
              color={operatingStatus ? 'bad' : 'good'}
            >
              {operatingStatus ? '降级' : '正常'}
            </LabeledList.Item>
            <LabeledList.Item
              label="传感器状态"
              color={sensorStatus ? 'good' : 'bad'}
            >
              {sensorStatus ? '已连接' : '故障'}
            </LabeledList.Item>
            <LabeledList.Item label="进入站台">
              {inboundPlatform}
            </LabeledList.Item>
            <LabeledList.Item label="发送站台">
              {outboundPlatform}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
