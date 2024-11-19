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

export const GravityGenerator = (props) => {
  const { data } = useBackend();
  const { operational } = data;
  return (
    <Window width={400} height={155}>
      <Window.Content>
        {!operational && <NoticeBox>No data available</NoticeBox>}
        {!!operational && <GravityGeneratorContent />}
      </Window.Content>
    </Window>
  );
};

const GravityGeneratorContent = (props) => {
  const { act, data } = useBackend();
  const { breaker, charge_count, charging_state, on, operational } = data;
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="供电">
          <Button
            icon={breaker ? 'power-off' : 'times'}
            content={breaker ? '开启' : '关闭'}
            selected={breaker}
            disabled={!operational}
            onClick={() => act('gentoggle')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="重力场充能">
          <ProgressBar
            value={charge_count / 100}
            ranges={{
              good: [0.7, Infinity],
              average: [0.3, 0.7],
              bad: [-Infinity, 0.3],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="充能状况">
          {charging_state === 0 &&
            ((on && <Box color="good">完全充能</Box>) || (
              <Box color="bad">未充能</Box>
            ))}
          {charging_state === 1 && <Box color="average">充能中</Box>}
          {charging_state === 2 && <Box color="average">溃能中</Box>}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
