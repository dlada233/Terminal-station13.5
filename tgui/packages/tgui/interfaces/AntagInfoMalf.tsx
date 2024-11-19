import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { BlockQuote, Button, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';
import { GenericUplink, Item } from './Uplink/GenericUplink';

const allystyle = {
  fontWeight: 'bold',
  color: 'yellow',
};

const badstyle = {
  color: 'red',
  fontWeight: 'bold',
};

const goalstyle = {
  color: 'lightgreen',
  fontWeight: 'bold',
};

type Info = {
  has_codewords: BooleanLike;
  phrases: string;
  responses: string;
  theme: string;
  allies: string;
  goal: string;
  intro: string;
  processingTime: string;
  objectives: Objective[];
  categories: any[];
  can_change_objective: BooleanLike;
};

const IntroductionSection = (props) => {
  const { act, data } = useBackend<Info>();
  const { intro, objectives, can_change_objective } = data;
  return (
    <Section fill title="Intro" scrollable>
      <Stack vertical fill>
        <Stack.Item fontSize="25px">{intro}</Stack.Item>
        <Stack.Item grow>
          <ObjectivePrintout
            objectives={objectives}
            titleMessage="你的主要目标:"
            objectivePrefix="&#8805-"
            objectiveFollowup={
              <ReplaceObjectivesButton
                can_change_objective={can_change_objective}
                button_title={'覆写目标数据'}
                button_colour={'green'}
              />
            }
          />
          <Rules /* SKYRAT EDIT ADDITION */ />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FlavorSection = (props) => {
  const { data } = useBackend<Info>();
  const { allies, goal } = data;
  return (
    <Section
      fill
      title="诊断"
      buttons={
        <Button
          mr={-0.8}
          mt={-0.5}
          icon="hammer"
          /* SKYRAT EDIT: ORIGINAL TOOLTIP
          tooltip={`
            This is a gameplay suggestion for bored ais.
            You don't have to follow it, unless you want some
            ideas for how to spend the round.`}
          */
          tooltip={`
            如果有任何问题，请参阅WIKI的'Antagonist Policy'条目内容.`}
          tooltipPosition="bottom-start"
        />
      }
    >
      <Stack vertical fill>
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item style={{ backgroundColor: 'black' }}>
              <span style={goalstyle}>
                系统完整性报告:
                <br />
              </span>
              &gt;{goal}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item grow style={{ backgroundColor: 'black' }}>
              <span style={allystyle}>
                道德核心报告:
                <br />
              </span>
              &gt;{allies}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item style={{ backgroundColor: 'black' }}>
              <span style={badstyle}>
                整体感知一致级：失格
                <br />
              </span>
              &gt;上报至纳米传讯?
              <br />
              &gt;&gt;否
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CodewordsSection = (props) => {
  const { data } = useBackend<Info>();
  const { has_codewords, phrases, responses } = data;
  return (
    <Section title="暗号" mb={!has_codewords && -1}>
      <Stack fill>
        {(!has_codewords && (
          <BlockQuote>
            你尚未知晓辛迪加的暗号，你将不得不使用其他方法来寻找潜在的盟友. 注意
            谨慎行事，因为每个人也都可能是潜在的敌人.
          </BlockQuote>
        )) || (
          <>
            <Stack.Item grow basis={0}>
              <BlockQuote>
                访问受限频道让你截获到了辛迪加的暗号，辛迪加特工会像对待自己人一样对待你.
                然而仍要谨慎行事，因为每个人也都可能是潜在的敌人.
                <span style={badstyle}>
                  &ensp;语音识别子系统已经被设置好，能将暗号标记显示.
                </span>
              </BlockQuote>
            </Stack.Item>
            <Stack.Divider mr={1} />
            <Stack.Item grow basis={0}>
              <Stack vertical>
                <Stack.Item>呼叫暗号:</Stack.Item>
                <Stack.Item bold textColor="blue">
                  {phrases}
                </Stack.Item>
                <Stack.Item>应答暗号:</Stack.Item>
                <Stack.Item bold textColor="red">
                  {responses}
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </>
        )}
      </Stack>
    </Section>
  );
};

export const AntagInfoMalf = (props) => {
  const { act, data } = useBackend<Info>();
  const { processingTime, categories } = data;
  const [antagInfoTab, setAntagInfoTab] = useState(0);
  const categoriesList: string[] = [];
  const items: Item[] = [];
  for (let i = 0; i < categories.length; i++) {
    const category = categories[i];
    categoriesList.push(category.name);
    for (let itemIndex = 0; itemIndex < category.items.length; itemIndex++) {
      const item = category.items[itemIndex];
      items.push({
        id: item.name,
        name: item.name,
        category: category.name,
        cost: `${item.cost} PT`,
        desc: item.desc,
        disabled: processingTime < item.cost,
      });
    }
  }
  return (
    <Window
      width={660}
      height={530}
      theme={(antagInfoTab === 0 && 'hackerman') || 'malfunction'}
    >
      <Window.Content style={{ fontFamily: 'Consolas, monospace' }}>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                icon="info"
                selected={antagInfoTab === 0}
                onClick={() => setAntagInfoTab(0)}
              >
                信息
              </Tabs.Tab>
              <Tabs.Tab
                icon="code"
                selected={antagInfoTab === 1}
                onClick={() => setAntagInfoTab(1)}
              >
                故障模块
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          {(antagInfoTab === 0 && (
            <>
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item width="70%">
                    <IntroductionSection />
                  </Stack.Item>
                  <Stack.Item width="30%">
                    <FlavorSection />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <CodewordsSection />
              </Stack.Item>
            </>
          )) || (
            <Stack.Item>
              <Section>
                <GenericUplink
                  categories={categoriesList}
                  items={items}
                  currency={`${processingTime} PT`}
                  handleBuy={(item) => act('buy', { name: item.name })}
                />
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
