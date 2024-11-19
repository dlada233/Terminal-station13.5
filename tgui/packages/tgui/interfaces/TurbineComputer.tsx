import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  Modal,
  NumberInput,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type TurbineInfo = {
  connected: BooleanLike;
  active: BooleanLike;
  rpm: number;
  power: number;
  temp: number;
  integrity: number;
  parts_linked: BooleanLike;
  parts_ready: BooleanLike;
  max_rpm: number;
  max_temperature: number;
  regulator: number;
};

export const TurbineComputer = (props) => {
  const { act, data } = useBackend<TurbineInfo>();
  const parts_not_connected = !data.parts_linked && (
    <Modal>
      <Box
        style={{ margin: 'auto' }}
        width="200px"
        textAlign="center"
        minHeight="39px"
      >
        {'部件未连接，使用多功能工具对核心转子再试一次'}
      </Box>
    </Modal>
  );
  const parts_not_ready = data.parts_linked && !data.parts_ready && (
    <Modal>
      <Box
        style={{ margin: 'auto' }}
        width="200px"
        textAlign="center"
        minHeight="39px"
      >
        {'部分部件有开启检修舱门，请关闭后再启动'}
      </Box>
    </Modal>
  );
  return (
    <Window width={310} height={240}>
      <Window.Content>
        <Section
          title="状态"
          buttons={
            <Button
              icon={data.active ? 'power-off' : 'times'}
              content={data.active ? '在线' : '离线'}
              selected={data.active}
              disabled={!!(data.rpm >= 1000) || !data.parts_linked}
              onClick={() => act('toggle_power')}
            />
          }
        >
          {parts_not_connected}
          {parts_not_ready}
          <LabeledList>
            <LabeledList.Item label="进入调节器">
              <NumberInput
                animated
                value={data.regulator * 100}
                unit="%"
                step={1}
                minValue={1}
                maxValue={100}
                onDrag={(value) =>
                  act('regulate', {
                    regulate: value * 0.01,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="涡轮机完整性y">
              <ProgressBar
                value={data.integrity}
                minValue={0}
                maxValue={100}
                ranges={{
                  good: [60, 100],
                  average: [40, 59],
                  bad: [0, 39],
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="涡轮机速度">
              {data.rpm} RPM
            </LabeledList.Item>
            <LabeledList.Item label="最大涡轮机速度">
              {data.max_rpm} RPM
            </LabeledList.Item>
            <LabeledList.Item label="进入温度">{data.temp} K</LabeledList.Item>
            <LabeledList.Item label="最大温度">
              {data.max_temperature} K
            </LabeledList.Item>
            <LabeledList.Item label="发电功率">
              {data.power * 4 * 0.001} kW
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
