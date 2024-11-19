import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  Dimmer,
  Dropdown,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';

const hivestyle = {
  fontWeight: 'bold',
  color: 'yellow',
};

const absorbstyle = {
  color: 'red',
  fontWeight: 'bold',
};

const revivestyle = {
  color: 'lightblue',
  fontWeight: 'bold',
};

const transformstyle = {
  color: 'orange',
  fontWeight: 'bold',
};

const storestyle = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

const hivemindstyle = {
  color: 'violet',
  fontWeight: 'bold',
};

const fallenstyle = {
  color: 'black',
  fontWeight: 'bold',
};

type Memory = {
  name: string;
  story: string;
};

type Info = {
  true_name: string;
  hive_name: string;
  stolen_antag_info: string;
  memories: Memory[];
  objectives: Objective[];
  can_change_objective: BooleanLike;
};

// SKYRAT EDIT change height from 750 to 900
export const AntagInfoChangeling = (props) => {
  return (
    <Window width={720} height={900}>
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Stack vertical fill>
          <Stack.Item maxHeight={16}>
            <IntroductionSection />
          </Stack.Item>
          {/* SKYRAT EDIT ADDITION START */}
          <Stack.Item>
            <Rules />
          </Stack.Item>
          {/* SKYRAT EDIT ADDITION END */}
          <Stack.Item grow={4}>
            <AbilitiesSection />
          </Stack.Item>
          <Stack.Item>
            <HivemindSection />
          </Stack.Item>
          <Stack.Item grow={3}>
            <Stack fill>
              <Stack.Item grow basis={0}>
                <MemoriesSection />
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <VictimPatternsSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const HivemindSection = (props) => {
  const { act, data } = useBackend<Info>();
  const { true_name } = data;
  return (
    <Section fill title="蜂巢意识">
      <Stack vertical fill>
        <Stack.Item textColor="label">
          所有的化形, 无论其出身何处, 都是由{' '}
          <span style={hivemindstyle}>蜂巢意识</span> 联系在一起的.
          你们可以通过以
          <span style={hivemindstyle}>:g</span>开头的消息, 使用你们的精神别名{' '}
          <span style={hivemindstyle}>{true_name}</span> 来与其他化形交流.{' '}
          团结一致，你们能让空间站陷入前所未有的恐怖之中.
        </Stack.Item>
        <Stack.Item>
          <NoticeBox danger>
            虽然大部分化形是你们强大的盟友, 但有些化形却可能选择背刺你们.
            化形能通过吸收同类来大幅提升自己的力量, 而一旦你们被吸收, 就会沦为{' '}
            <span style={fallenstyle}>堕落化形</span> . 这是莫大的耻辱.
          </NoticeBox>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const IntroductionSection = (props) => {
  const { act, data } = useBackend<Info>();
  const { true_name, hive_name, objectives, can_change_objective } = data;
  return (
    <Section fill title="介绍" style={{ overflowY: 'auto' }}>
      <Stack vertical fill>
        <Stack.Item fontSize="25px">
          你们是来自<span style={hivestyle}> {hive_name}</span> 的 {true_name} .
        </Stack.Item>
        <Stack.Item>
          <ObjectivePrintout
            objectives={objectives}
            objectiveFollowup={
              <ReplaceObjectivesButton
                can_change_objective={can_change_objective}
                button_title={'制定新指令'}
                button_colour={'green'}
              />
            }
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const AbilitiesSection = (props) => {
  const { data } = useBackend<Info>();
  return (
    <Section fill title="能力">
      <Stack fill>
        <Stack.Item basis={0} grow>
          <Stack fill vertical>
            <Stack.Item basis={0} textColor="label" grow>
              你们<span style={absorbstyle}>&ensp;吸收DNA</span>
              的能力能让你们偷取被害者的DNA和记忆.
              <span style={absorbstyle}>&ensp;DNA提取叮刺</span>能力
              也能偷取被害者DNA, 并且无法被察觉到,
              但叮刺没法偷取记忆以及语言模式.
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item basis={0} textColor="label" grow>
              你们拥有
              <span style={revivestyle}>&ensp;静滞复活</span> 的能力.
              这意味着除非你们的身体彻底被摧毁，否则你们就不会彻底死掉.
              然而，复活时你们会发出吵闹的噪音，所以你们最好不要在安静环境中的人们面前这么做.
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item basis={0} grow>
          <Stack fill vertical>
            <Stack.Item basis={0} textColor="label" grow>
              你们的
              <span style={transformstyle}>&ensp;变形</span>
              能力能让你们根据收集到 的DNA信息进行变形，无论是致命或非致命的.
              它同样会拟态
              它们所穿着的衣物(并非真的衣服)，这取决你们的身上的服装槽位是否空出.
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item basis={0} textColor="label" grow>
              <span style={storestyle}>&ensp;生物商城</span>是你们购买更多能力的
              地方. 你们有15点基因点来进化出能力,
              在你们吸收一具尸体后可以重启进化,
              返还所有的基因点数用来进化出不同的能力.
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const MemoriesSection = (props) => {
  const { data } = useBackend<Info>();
  const { memories } = data;
  const [selectedMemory, setSelectedMemory] = useState(
    (!!memories && memories[0]) || null,
  );
  const memoryMap = {};
  for (const index in memories) {
    const memory = memories[index];
    memoryMap[memory.name] = memory;
  }

  return (
    <Section
      fill
      scrollable={!!memories && !!memories.length}
      title="窃取到的记忆"
      buttons={
        <Button
          icon="info"
          tooltipPosition="left"
          tooltip={`
            吸收目标能让你们窃取他们的记忆，帮助你们更好地模仿目标!
          `}
        />
      }
    >
      {(!!memories && !memories.length && (
        <Dimmer fontSize="20px">先吸收一名受害者!</Dimmer>
      )) || (
        <Stack vertical>
          <Stack.Item>
            <Dropdown
              width="100%"
              selected={selectedMemory?.name}
              options={memories.map((memory) => {
                return memory.name;
              })}
              onSelected={(selected) => setSelectedMemory(memoryMap[selected])}
            />
          </Stack.Item>
          <Stack.Item>{!!selectedMemory && selectedMemory.story}</Stack.Item>
        </Stack>
      )}
    </Section>
  );
};

const VictimPatternsSection = (props) => {
  const { data } = useBackend<Info>();
  const { stolen_antag_info } = data;
  return (
    <Section fill scrollable={!!stolen_antag_info} title="窃取到的额外信息">
      {(!!stolen_antag_info && stolen_antag_info) || (
        <Dimmer fontSize="20px">先吸收一名受害者!</Dimmer>
      )}
    </Section>
  );
};
