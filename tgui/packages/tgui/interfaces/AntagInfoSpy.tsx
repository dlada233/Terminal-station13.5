import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { Window } from '../layouts';
import { Objective, ObjectivePrintout } from './common/Objectives';

const greenText = {
  fontWeight: 'italics',
  color: '#20b142',
};

const redText = {
  fontWeight: 'italics',
  color: '#e03c3c',
};

type Data = {
  antag_name: string;
  uplink_location: string | null;
  objectives: Objective[];
};

export const AntagInfoSpy = () => {
  const { data } = useBackend<Data>();
  const { antag_name, uplink_location, objectives } = data;
  return (
    <Window width={380} height={420} theme="ntos_darkmode">
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Section title={`你是${antag_name || '间谍'}.`}>
          <Stack vertical fill ml={1} mr={1}>
            <Stack.Item fontSize={1.2}>
              你的{uplink_location || '某物'}
              实际上是特殊的上行链路，它将指示你在空间站上偷窃东西.
            </Stack.Item>
            <Stack.Item>
              <span style={greenText}>
                <b>拿在手中使用</b>即可访问你的上行链路, 然后用其
                <b>右键</b>目标即可完成偷窃.
              </span>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              你可能并非孤身一人: 空间站上可能有其他间谍在.
            </Stack.Item>
            <Stack.Item>
              你可以自由选择合作或者对抗, 但
              <span style={redText}>你不可以分享奖励.</span>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item>
              <ObjectivePrintout
                titleMessage={'你的任务，如果你接受的话:'}
                objectives={objectives}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
