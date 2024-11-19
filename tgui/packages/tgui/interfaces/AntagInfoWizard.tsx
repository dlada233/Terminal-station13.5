import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';

const teleportstyle = {
  color: 'yellow',
};

const robestyle = {
  color: 'lightblue',
};

const destructionstyle = {
  color: 'red',
};

const defensestyle = {
  color: 'orange',
};

const transportstyle = {
  color: 'yellow',
};

const summonstyle = {
  color: 'cyan',
};

const ritualstyle = {
  color: 'violet',
};

const grandritualstyle = {
  fontWeight: 'bold',
  color: '#bd54e0',
};

type GrandRitual = {
  remaining: number;
  next_area: string;
};

type Info = {
  objectives: Objective[];
  ritual: GrandRitual;
  can_change_objective: BooleanLike;
};

// SKYRAT EDIT CHANGE - height from 630 to 700
export const AntagInfoWizard = (props) => {
  const { data, act } = useBackend<Info>();
  const { ritual, objectives, can_change_objective } = data;

  return (
    <Window width={620} height={700} theme="wizard">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section scrollable fill>
              <Stack vertical>
                <Stack.Item textColor="red" fontSize="20px">
                  你是太空巫师!
                </Stack.Item>
                <Stack.Item>
                  <ObjectivePrintout
                    objectives={objectives}
                    titleMessage="太空巫师联盟给了你以下任务:"
                    objectiveFollowup={
                      <ReplaceObjectivesButton
                        can_change_objective={can_change_objective}
                        button_title={'进行个人追求'}
                        button_colour={'violet'}
                      />
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <RitualPrintout ritual={ritual} />
                </Stack.Item>
                {/* SKYRAT EDIT ADDITION START */}
                <Stack.Item>
                  <Rules />
                </Stack.Item>
                {/* SKYRAT EDIT ADDITION END */}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section fill title="魔法书">
              <Stack vertical fill>
                <Stack.Item>
                  你手上有本魔法书，能让你浏览魔法库.
                  <br />
                  <span style={destructionstyle}>
                    致命页具有攻击性的法术，能摧毁你的敌人.
                  </span>
                  <br />
                  <span style={defensestyle}>
                    防御页具有防御性的法术，帮助你活下去.
                    记住，你可能可以毁灭灭地，但仍是肉躯.
                  </span>
                  <br />
                  <span style={transportstyle}>
                    位移页具有位移法术，这对持续存活和完成任务非常重要.
                  </span>
                  <br />
                  <span style={summonstyle}>
                    辅助页具有召唤和辅助法术，注意，不是所有的召唤物都对你抱有善意.
                  </span>
                  <br />
                  <span style={ritualstyle}>
                    仪式页具有能对整个全局施加影响的强大仪式，能让空间站自我崩坏.
                    注意， 仪式要么代价昂贵，要么意义大于效果.
                  </span>
                </Stack.Item>
                <Stack.Item textColor="lightgreen">
                  (如果你不确定选什么或者你是新手巫师, 请翻至
                  &quot;预设配装&quot; 页. 在
                  那里你能发现一些套装组合，很适合新手巫师发挥.)
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="杂项装备">
              <Stack>
                <Stack.Item>
                  <span style={teleportstyle}>传送卷轴:</span> 使用来传送到
                  任何你想要的地方，但是无法回到藏身处，所以确保你在出发前做足了准备.
                  <br />
                  <span style={robestyle}>巫师袍:</span> 用于释放大部分法术. 你
                  的魔法书会告诉你哪些法术不穿巫师袍就无法释放.
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section textAlign="center" textColor="red" fontSize="20px">
              记住: 别忘了准备法术.
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const RitualPrintout = (props: { ritual: GrandRitual }) => {
  const { ritual } = props;
  if (!ritual.next_area) {
    return null;
  }
  return (
    <Box>
      或者, 通过在几处魔力汇聚地上利用法阵来举行{' '}
      <span style={grandritualstyle}>大仪式 </span>
      .
      <br />
      你必须完成
      <span style={grandritualstyle}> {ritual.remaining}</span>次以上的仪式.
      <br />
      你的下一处仪式地点是
      <span style={grandritualstyle}> {ritual.next_area}</span>.
    </Box>
  );
};
