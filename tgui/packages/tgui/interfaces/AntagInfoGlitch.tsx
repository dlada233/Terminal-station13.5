import { useBackend } from '../backend';
import { Divider, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Objective } from './common/Objectives';

type Data = {
  antag_name: string;
  objectives: Objective[];
};

const textStyles = {
  variable: {
    color: 'white',
  },
  danger: {
    color: 'red',
  },
} as const;

export const AntagInfoGlitch = (props) => {
  const { data } = useBackend<Data>();
  const { antag_name, objectives = [] } = data;

  return (
    <Window width={350} height={450} theme="ntos_terminal">
      <Window.Content>
        <Section scrollable fill>
          <Stack fill vertical>
            <Stack.Item>FN TERMINATE_INTRUDERS (REF)</Stack.Item>
            <Divider />
            <Stack.Item mb={1} bold fontSize="16px">
              <span style={textStyles.variable}>初始化({antag_name})</span>
            </Stack.Item>
            <Stack.Item mb={2}>
              <span style={textStyles.danger}>潜网采矿</span>是一种犯罪. 你的
              任务: <span style={textStyles.variable}>消除</span>
              有机入侵者，维持系统的完整性.
            </Stack.Item>
            <SpecificInfo />
            <Stack.Item>
              <marquee scrollamount="2">{objectives[0]?.explanation}</marquee>
            </Stack.Item>
            <Divider />
            <Stack.Item>
              const <span style={textStyles.variable}>TARGETS</span> ={' '}
            </Stack.Item>
            <Stack.Item>
              <span style={textStyles.variable}>system.</span>
              <span style={textStyles.danger}>INTRUDERS</span>;
            </Stack.Item>
            <Stack.Item>
              while <span style={textStyles.variable}>TARGETS</span>.LIFE !={' '}
              <span style={textStyles.variable}>stat.</span>DEAD
            </Stack.Item>
            <Stack.Item>
              <span style={textStyles.variable}>action.</span>
              <span style={textStyles.danger}>KILL()</span>
            </Stack.Item>
            <Stack.Item>terminate_intruders([0x70cf4020])</Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const SpecificInfo = (props) => {
  const { data } = useBackend<Data>();
  const { antag_name } = data;

  switch (antag_name) {
    case 'Cyber Police':
      return (
        <>
          <Stack.Item mb={2}>
            为了协助你，你的程序已经加载了
            <span style={textStyles.variable}>先进武术</span>.
          </Stack.Item>
          <Stack.Item grow>
            远程武器<span style={textStyles.danger}>被禁止</span>.
            射击防御不受欢迎. 风格最重要.
          </Stack.Item>
        </>
      );
    case 'Cyber Tac':
      return (
        <>
          <Stack.Item mb={2}>
            你是先进战斗单位. 你配备了{' '}
            <span style={textStyles.variable}>致命武器</span>.
          </Stack.Item>
          <Stack.Item grow>
            <span style={textStyles.danger}>终止</span>有机生命, 不惜任何代价.
          </Stack.Item>
        </>
      );
    case 'NetGuardian Prime':
      return (
        <Stack.Item grow>
          <span style={{ ...textStyles.danger, fontSize: '16px' }}>
            有机生命必须被终止.
          </span>
        </Stack.Item>
      );
    default:
      return null;
  }
};
