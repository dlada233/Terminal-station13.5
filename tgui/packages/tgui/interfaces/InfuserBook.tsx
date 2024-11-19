import { paginate, range } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type Entry = {
  name: string;
  infuse_mob_name: string;
  desc: string;
  threshold_desc: string;
  qualities: string[];
  tier: number;
};

type DnaInfuserData = {
  entries: Entry[];
};

type BookPosition = {
  chapter: number;
  pageInChapter: number;
};

type TierData = {
  desc: string;
  icon: string;
  name: string;
};

const PAGE_HEIGHT = 30;

const TIER2TIERDATA: TierData[] = [
  {
    name: '轻度突变',
    desc: `
      轻度突变体通常拥有更小的潜在突变列表，并且在注入多个器官时不会获得额外增益. 这里
      主要是常见种族、装饰部位以及诸如此类的东西，总是可用!
    `,
    icon: 'circle-o',
  },
  {
    name: '常规突变',
    desc: `
      常规突变体在将其DNA注入到你自身时都会获得额外奖励，并且在轮班期间经常能够稳定地找到它们. 总是可用!
    `,
    icon: 'circle-half-stroke',
  },
  {
    name: '深度突变',
    desc: `
      深度突变在拥有额外增益的同时，优点与缺点也更加明显，并且在轮班期间更加难以找到. 必须
      先解锁较低等级的DNA突变增益，才能解锁高度突变.
    `,
    icon: 'circle',
  },
  {
    name: '畸变',
    desc: `
      我们能从试管中培养出更强力的突变体，并将其命名为”畸变体”，畸变体要么具有强大的实用效用，要么具有极其异常的特质，
      或者干脆是有极度致命的能力.
    `,
    icon: 'teeth',
  },
];

export const InfuserBook = (props) => {
  const { data, act } = useBackend<DnaInfuserData>();
  const { entries } = data;

  const [bookPosition, setBookPosition] = useState({
    chapter: 0,
    pageInChapter: 0,
  });
  const { chapter, pageInChapter } = bookPosition;

  const paginatedEntries = paginateEntries(entries);

  let currentEntry = paginatedEntries[chapter][pageInChapter];

  const switchChapter = (newChapter) => {
    if (chapter === newChapter) {
      return;
    }
    setBookPosition({ chapter: newChapter, pageInChapter: 0 });
    act('play_flip_sound'); // just so we can play a sound fx on page turn
  };

  const setPage = (newPage) => {
    const newBookPosition: BookPosition = { ...bookPosition };
    if (newPage < 0) {
      if (newBookPosition.chapter === 0) {
        return;
      }
      newBookPosition.chapter = chapter - 1;
      newBookPosition.pageInChapter = paginatedEntries[chapter - 1].length - 1;
      if (newBookPosition.pageInChapter < 0) {
        newBookPosition.pageInChapter = 0;
      }
    } else if (newPage > paginatedEntries[chapter].length - 1) {
      if (newBookPosition.chapter === 3) {
        return;
      } else {
        newBookPosition.pageInChapter = 0;
        newBookPosition.chapter = chapter + 1;
      }
    } else {
      newBookPosition.pageInChapter = newPage;
    }
    setBookPosition(newBookPosition);
    act('play_flip_sound'); // just so we can play a sound fx on page turn
  };

  const tabs = [
    '介绍',
    '等级0 - 轻度突变',
    '等级1 - 常规突变',
    '等级2 - 深度突变',
    '等级3 - 畸变 - 访问受限',
  ];

  const paginatedTabs = paginate(tabs, 3);

  const restrictedNext = chapter === 3 && pageInChapter === 0;

  return (
    <Window title="DNA注入手册" width={620} height={500}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item mb={-1}>
            {paginatedTabs.map((tabRow, i) => (
              <Tabs height="30px" mb="0px" fill fluid key={i}>
                {tabRow.map((tab) => {
                  const tabIndex = tabs.indexOf(tab);
                  const tabIcon = TIER2TIERDATA[tabIndex - 1]
                    ? TIER2TIERDATA[tabIndex - 1].icon
                    : 'info';
                  return (
                    <Tabs.Tab
                      icon={tabIcon}
                      key={tabIndex}
                      selected={chapter === tabIndex}
                      onClick={
                        tabIndex === 4
                          ? undefined
                          : () => switchChapter(tabIndex)
                      }
                    >
                      <Box color={tabIndex === 4 && 'red'}>{tab}</Box>
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            ))}
          </Stack.Item>
          <Stack.Item>
            {chapter === 0 ? (
              <InfuserInstructions />
            ) : (
              <InfuserEntry entry={currentEntry} />
            )}
          </Stack.Item>
          <Stack.Item textAlign="center">
            <Stack fontSize="18px" fill>
              <Stack.Item grow={2}>
                <Button onClick={() => setPage(pageInChapter - 1)} fluid>
                  上一页
                </Button>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section fitted fill pt="3px">
                  页 {pageInChapter + 1}/
                  {paginatedEntries[chapter].length + (chapter === 0 ? 1 : 0)}
                </Section>
              </Stack.Item>
              <Stack.Item grow={2}>
                <Button
                  color={restrictedNext && 'black'}
                  onClick={() => setPage(pageInChapter + 1)}
                  fluid
                >
                  {restrictedNext ? '访问受限' : '下一页'}
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const InfuserInstructions = (props) => {
  return (
    <Section title="DNA注入指南" height={PAGE_HEIGHT}>
      <Stack vertical>
        <Stack.Item fontSize="16px">DNA注入能做什么?</Stack.Item>
        <Stack.Item color="label">
          DNA注入是一种将死去生物的DNA整合到你自己身上的做法，将你的器官突变成一种
          介于你原本种族和注入生物之间的融合器官.
          虽然这种做法会让你进一步远离原本种族，
          并带来一系列...不幸的副作用，但它同时也会赋予你新的能力.{' '}
          <b>
            最重要的是，你必须理解基因突变体通常会变得更加擅长特定事物，尤其是在被增益的阈值方面.
          </b>
        </Stack.Item>
        <Stack.Item fontSize="16px">我被说服了! 我该怎么注入?</Stack.Item>
        <Stack.Item color="label">
          1. 将一只死亡的生物放入机器中，这就是你要进行融合的对象.
          <br />
          2. 进入机器，就像你进入DNA扫描仪一样.
          <br />
          3. 让外部人员启动机器.
          <br />
          <Box mt="10px" inline color="white">
            完成以上步骤，你就会成功!
            请注意，融合过程中，融和源（即死亡的生物）将会被彻底摧毁.
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
type InfuserEntryProps = {
  entry: Entry;
};

const InfuserEntry = (props: InfuserEntryProps) => {
  const { entry } = props;

  const tierData = TIER2TIERDATA[entry.tier];

  return (
    <Section
      fill
      title={entry.name + '的突变'}
      height={PAGE_HEIGHT}
      buttons={
        <Button tooltip={tierData.desc} icon={tierData.icon}>
          {tierData.name}
        </Button>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <BlockQuote>
            {entry.desc}{' '}
            {entry.threshold_desc && (
              <>如果注入了足够的DNA，{entry.threshold_desc}</>
            )}
          </BlockQuote>
        </Stack.Item>
        <Stack.Item grow>
          特质:
          {entry.qualities.map((quality) => {
            return (
              <Box color="label" key={quality}>
                - {quality}
              </Box>
            );
          })}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          将{' '}
          <Box inline color={entry.name === '拒绝' ? 'red' : 'green'}>
            {entry.infuse_mob_name}
          </Box>{' '}
          的DNA注入实验对象体内即可得到.
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const paginateEntries = (collection: Entry[]): Entry[][] => {
  const pages: Entry[][] = [];
  let maxTier = -1;
  // find highest tier entry
  collection.forEach((entry) => {
    if (entry.tier > maxTier) {
      maxTier = entry.tier;
    }
  });
  // negative 1 to account for introduction, which has no entries
  let tier = -1;
  for (let _ in range(tier, maxTier + 1)) {
    pages.push(collection.filter((entry) => entry.tier === tier));
    tier++;
  }
  return pages;
};
