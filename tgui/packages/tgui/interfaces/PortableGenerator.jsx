import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const PortableGenerator = (props) => {
  const { act, data } = useBackend();
  const { stack_percent } = data;
  const stackPercentState =
    (stack_percent > 50 && 'good') ||
    (stack_percent > 15 && 'average') ||
    'bad';
  return (
    <Window width={450} height={340}>
      <Window.Content scrollable>
        {!data.anchored && <NoticeBox>发电机未固定.</NoticeBox>}
        <Section title="状态">
          <LabeledList>
            <LabeledList.Item label="电源开关">
              <Button
                icon={data.active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                disabled={!data.ready_to_boot}
              >
                {data.active ? '开' : '关'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label={data.sheet_name + '材料剩余'}>
              <Box inline color={stackPercentState}>
                {data.sheets}
              </Box>
              {data.sheets >= 1 && (
                <Button
                  ml={1}
                  icon="eject"
                  disabled={data.active}
                  onClick={() => act('eject')}
                >
                  取出
                </Button>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="当前材料消耗">
              <ProgressBar
                value={data.stack_percent / 100}
                ranges={{
                  good: [0.1, Infinity],
                  average: [0.01, 0.1],
                  bad: [-Infinity, 0.01],
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="热量水平">
              {data.current_heat < 100 ? (
                <Box inline color="good">
                  正常
                </Box>
              ) : data.current_heat < 200 ? (
                <Box inline color="average">
                  警告
                </Box>
              ) : (
                <Box inline color="bad">
                  危险
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="输出">
          <LabeledList>
            <LabeledList.Item label="当前输出">
              {data.power_output}
            </LabeledList.Item>
            <LabeledList.Item label="调整输出">
              <Button icon="minus" onClick={() => act('lower_power')}>
                {data.power_generated}
              </Button>
              <Button icon="plus" onClick={() => act('higher_power')}>
                {data.power_generated}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="可用功率">
              <Box inline color={!data.connected && 'bad'}>
                {data.connected ? data.power_available : '未连接'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
