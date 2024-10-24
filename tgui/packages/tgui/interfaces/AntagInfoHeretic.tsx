import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Section, Stack, Tabs } from '../components';
import { CssColor } from '../constants';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';

const hereticRed = {
  color: '#e03c3c',
};

const hereticBlue = {
  fontWeight: 'bold',
  color: '#2185d0',
};

const hereticPurple = {
  fontWeight: 'bold',
  color: '#bd54e0',
};

const hereticGreen = {
  fontWeight: 'bold',
  color: '#20b142',
};

const hereticYellow = {
  fontWeight: 'bold',
  color: 'yellow',
};

type Knowledge = {
  path: string;
  name: string;
  desc: string;
  gainFlavor: string;
  cost: number;
  disabled: boolean;
  hereticPath: string;
  color: CssColor;
};

type KnowledgeInfo = {
  learnableKnowledge: Knowledge[];
  learnedKnowledge: Knowledge[];
};

type Info = {
  charges: number;
  total_sacrifices: number;
  ascended: BooleanLike;
  objectives: Objective[];
  can_change_objective: BooleanLike;
};

const IntroductionSection = (props) => {
  const { data, act } = useBackend<Info>();
  const { objectives, ascended, can_change_objective } = data;

  return (
    <Stack justify="space-evenly" height="100%" width="100%">
      <Stack.Item grow>
        <Section title="你是异教徒!" fill fontSize="14px">
          <Stack vertical>
            <FlavorSection />
            <Stack.Divider />
            {/* SKYRAT EDIT ADDITION START */}
            <Stack.Item>
              <Rules />
            </Stack.Item>
            {/* SKYRAT EDIT ADDITION END */}
            <Stack.Divider />
            <GuideSection />
            <Stack.Divider />
            <InformationSection />
            <Stack.Divider />

            {!ascended && (
              <Stack.Item>
                <ObjectivePrintout
                  fill
                  titleMessage={
                    can_change_objective
                      ? '你的OPFOR目标是你的主要目标，但为了飞升，你仍有这些目标需要完成' /* SKYRAT EDIT CHANGE - opfor objectives */
                      : '你的OPFOR目标是你的主要目标，运用你的黑暗学识来完成你的目标' /* SKYRAT EDIT CHANGE - opfor objectives  */
                  }
                  objectives={objectives}
                  objectiveFollowup={
                    <ReplaceObjectivesButton
                      can_change_objective={can_change_objective}
                      button_title={'拒绝飞升'}
                      button_colour={'red'}
                      button_tooltip={
                        '背弃漫宿来完成你自定的目标，此选项将导致你无法飞升!'
                      }
                    />
                  }
                />
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const FlavorSection = () => {
  return (
    <Stack.Item>
      <Stack vertical textAlign="center" fontSize="14px">
        <Stack.Item>
          <i>
            又是平凡无奇的一天，在一份毫无意义的工作中度过.
            你感到周围有一丝&nbsp;
            <span style={hereticBlue}>微光</span>
            &nbsp;闪烁，空气中似乎弥漫着某种&nbsp;
            <span style={hereticRed}>奇异</span>
            &nbsp;的氛围. 你向内审视， 发现了一个将改变生活的秘密.
          </i>
        </Stack.Item>
        <Stack.Item>
          <b>
            <span style={hereticPurple}>漫宿的大门</span>
            &nbsp;向你的思维敞开.
          </b>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const GuideSection = () => {
  return (
    <Stack.Item>
      <Stack vertical fontSize="14px">
        <Stack.Item>
          - 在空间站里寻找那些无法被普通肉眼察觉，但撕裂了现实的&nbsp;
          <span style={hereticPurple}>异响</span>
          &nbsp;，&nbsp;
          <b>右键</b>它们将为你提供&nbsp;
          <span style={hereticBlue}>知识点</span>. 点击后它们将对所有人可见.
        </Stack.Item>
        <Stack.Item>
          - 使用的&nbsp;
          <span style={hereticRed}>活体之心</span>
          &nbsp;来追踪&nbsp;
          <span style={hereticRed}>献祭目标</span>，但请注意:
          使用它将发出强烈的心跳声，附近的人可能会有所察觉. 这个能力与你
          <b>心脏</b>相关连 - 如果你失去了心脏,
          你需要完成某个仪式来重新获取一颗.
        </Stack.Item>
        <Stack.Item>
          - 要画出献祭和仪式用的&nbsp;
          <span style={hereticGreen}>嬗变符文</span>&nbsp; 需要你一只手激活
          <span style={hereticGreen}>漫宿之握</span>
          &nbsp;，同时另一只手持有书写工具(笔或蜡笔)对地板进行刻画.
        </Stack.Item>
        <Stack.Item>
          - 依靠<span style={hereticRed}>活体之心</span>来找到 你的目标.
          将濒死或更糟糕的他们带回&nbsp;
          <span style={hereticGreen}>嬗变符文</span>处 进行&nbsp;
          <span style={hereticRed}>献祭</span>来获得&nbsp;
          <span style={hereticBlue}>知识点数</span>. 漫宿
          <b>只</b>接受被&nbsp;
          <span style={hereticRed}>活体之心</span>所标记的目标.
        </Stack.Item>
        <Stack.Item>
          - 为你自己创造一个<span style={hereticYellow}>焦点</span>
          ，焦点能让你释 放更多的高级法术.
        </Stack.Item>
        <Stack.Item>
          - 完成所有目标，你将能进行
          <span style={hereticYellow}>最终仪式</span>. 完成它来获得无上力量!
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const InformationSection = (props) => {
  const { data } = useBackend<Info>();
  const { charges, total_sacrifices, ascended } = data;
  return (
    <Stack.Item>
      <Stack vertical fill>
        {!!ascended && (
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>You have</Stack.Item>
              <Stack.Item fontSize="24px">
                <Box inline color="yellow">
                  飞升
                </Box>
                !
              </Stack.Item>
            </Stack>
          </Stack.Item>
        )}
        <Stack.Item>
          你拥有<b>{charges || 0}</b>&nbsp;
          <span style={hereticBlue}>知识点数</span>.
        </Stack.Item>
        <Stack.Item>
          你总共完成了&nbsp;
          <b>{total_sacrifices || 0}</b>&nbsp;
          <span style={hereticRed}>献祭</span>.
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const ResearchedKnowledge = (props) => {
  const { data } = useBackend<KnowledgeInfo>();
  const { learnedKnowledge } = data;

  return (
    <Stack.Item grow>
      <Section title="已获取知识" fill scrollable>
        <Stack vertical>
          {(!learnedKnowledge.length && '无!') ||
            learnedKnowledge.map((learned) => (
              <Stack.Item key={learned.name}>
                <Button
                  width="100%"
                  color={learned.color}
                  content={`${learned.hereticPath} - ${learned.name}`}
                  tooltip={learned.desc}
                />
              </Stack.Item>
            ))}
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const KnowledgeShop = (props) => {
  const { data, act } = useBackend<KnowledgeInfo>();
  const { learnableKnowledge } = data;

  return (
    <Stack.Item grow>
      <Section title="潜在可用的知识" fill scrollable>
        {(!learnableKnowledge.length && 'None!') ||
          learnableKnowledge.map((toLearn) => (
            <Stack.Item key={toLearn.name} mb={1}>
              <Button
                width="100%"
                color={toLearn.color}
                disabled={toLearn.disabled}
                content={`${toLearn.hereticPath} - ${
                  toLearn.cost > 0
                    ? `${toLearn.name}: ${toLearn.cost}
                  点数`
                    : toLearn.name
                }`}
                tooltip={toLearn.desc}
                onClick={() => act('research', { path: toLearn.path })}
              />
              {!!toLearn.gainFlavor && (
                <BlockQuote>
                  <i>{toLearn.gainFlavor}</i>
                </BlockQuote>
              )}
            </Stack.Item>
          ))}
      </Section>
    </Stack.Item>
  );
};

const ResearchInfo = (props) => {
  const { data } = useBackend<Info>();
  const { charges } = data;

  return (
    <Stack justify="space-evenly" height="100%" width="100%">
      <Stack.Item grow>
        <Stack vertical height="100%">
          <Stack.Item fontSize="20px" textAlign="center">
            你拥有<b>{charges || 0}</b>&nbsp;
            <span style={hereticBlue}>知识点数</span>
            来花费.
          </Stack.Item>
          <Stack.Item grow>
            <Stack height="100%">
              <ResearchedKnowledge />
              <KnowledgeShop />
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const AntagInfoHeretic = (props) => {
  const { data } = useBackend<Info>();
  const { ascended } = data;

  const [currentTab, setTab] = useState(0);

  return (
    <Window width={675} height={635}>
      <Window.Content
        style={{
          backgroundImage: 'none',
          background: ascended
            ? 'radial-gradient(circle, rgba(24,9,9,1) 54%, rgba(31,10,10,1) 60%, rgba(46,11,11,1) 80%, rgba(47,14,14,1) 100%);'
            : 'radial-gradient(circle, rgba(9,9,24,1) 54%, rgba(10,10,31,1) 60%, rgba(21,11,46,1) 80%, rgba(24,14,47,1) 100%);',
        }}
      >
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                icon="info"
                selected={currentTab === 0}
                onClick={() => setTab(0)}
              >
                信息栏
              </Tabs.Tab>
              <Tabs.Tab
                icon={currentTab === 1 ? 'book-open' : 'book'}
                selected={currentTab === 1}
                onClick={() => setTab(1)}
              >
                研究栏
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {(currentTab === 0 && <IntroductionSection />) || <ResearchInfo />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
