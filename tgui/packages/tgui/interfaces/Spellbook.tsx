import { BooleanLike } from 'common/react';
import { ReactNode } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Divider,
  Icon,
  Input,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

enum SpellCategory {
  Offensive = '进攻',
  Defensive = '防御',
  Mobility = '位移',
  Assistance = '辅助',
  Rituals = '仪式',
}

type byondRef = string;

type SpellEntry = {
  // Name of the spell
  name: string;
  // Description of what the spell does
  desc: string;
  // Byond REF of the spell entry datum
  ref: byondRef;
  // Whether the spell requires wizard clothing to cast
  requires_wizard_garb: BooleanLike;
  // Spell points required to buy the spell
  cost: number;
  // How many times the spell has been bought
  times: number;
  // Cooldown length of the spell once cast once
  cooldown: number;
  // Category of the spell
  cat: SpellCategory;
  // Whether the spell is refundable
  refundable: BooleanLike;
  // The verb displayed when buying
  buyword: Buywords;
};

type Data = {
  owner: string;
  points: number;
  semi_random_bonus: number;
  full_random_bonus: number;
  entries: SpellEntry[];
};

type TabType = {
  title: string;
  blurb?: string;
  component?: () => ReactNode;
  locked?: boolean;
  scrollable?: boolean;
};

const TAB2NAME: TabType[] = [
  {
    title: '署名',
    blurb:
      '这本书只对它的主人负责，当然每个主人也只有一本，魔法书与其主人之间的永久契约确保了如此强大的神器不会落入敌人之手，或被用于违法行为，如贩卖魔法.',
    component: () => <EnscribedName />,
  },
  {
    title: '目录',
    component: () => <TableOfContents />,
  },
  {
    title: '进攻',
    blurb: '用于破坏的法术及物品.',
    scrollable: true,
  },
  {
    title: '防御',
    blurb: '能提高生存能力或降低敌人攻击能力的法术及物品.',
    scrollable: true,
  },
  {
    title: '位移',
    blurb: '用于提高你移动能力的法术及物品，最好至少购买一项.',
    scrollable: true,
  },
  {
    title: '辅助',
    blurb: '能从外部引入力量来帮助或强化你的法术和物品.',
    scrollable: true,
  },
  {
    title: '挑战',
    blurb:
      '巫师联盟需要赢得更多威望，让空间站武装起来对付你，而你能获得更多的魔法书点数.',
    locked: true,
    scrollable: true,
  },
  {
    title: '仪式',
    blurb: '这些强大的魔法能改变现实的结构，并不总是对你有利.',
    scrollable: true,
  },
  {
    title: '预设配装',
    blurb: '巫师联盟承认，选择困难是人之常情，在这里您可以直接选择预设的配装.',
    component: () => <Loadouts />,
  },
  {
    title: '随机配装',
    blurb: '用于不喜欢预设，希望人生充满了混乱的人，不建议经验尚浅的巫师使用.',
    component: () => <Randomize />,
  },
];

enum Buywords {
  Learn = '学习',
  Summon = '召唤',
  Cast = '举行',
}

const BUYWORD2ICON = {
  Learn: 'plus',
  Summon: 'hat-wizard',
  Cast: 'meteor',
};

const EnscribedName = (props) => {
  const { data } = useBackend<Data>();
  const { owner } = data;
  return (
    <>
      <Box
        mt={25}
        mb={-3}
        fontSize="50px"
        color="bad"
        textAlign="center"
        fontFamily="Ink Free"
      >
        {owner}
      </Box>
      <Divider />
    </>
  );
};

const lineHeightToc = '34.6px';

const TableOfContents = (props) => {
  const [tabIndex, setTabIndex] = useLocalState('tab-index', 1);
  return (
    <Box textAlign="center">
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="pen"
        disabled
        content="真名绑定"
      />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="clipboard"
        disabled
        content="目录"
      />
      <Divider />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="fire"
        content="致命法术"
        onClick={() => setTabIndex(3)}
      />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="shield-alt"
        content="防御法术"
        onClick={() => setTabIndex(3)}
      />
      <Divider />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="globe-americas"
        content="魔法位移术"
        onClick={() => setTabIndex(5)}
      />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="users"
        content="辅助及召唤术"
        onClick={() => setTabIndex(5)}
      />
      <Divider />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="crown"
        content="挑战项目"
        onClick={() => setTabIndex(7)}
      />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="magic"
        content="仪式项目"
        onClick={() => setTabIndex(7)}
      />
      <Divider />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="thumbs-up"
        content="巫师预设配装"
        onClick={() => setTabIndex(9)}
      />
      <Button
        lineHeight={lineHeightToc}
        fluid
        icon="dice"
        content="神秘随机化"
        onClick={() => setTabIndex(9)}
      />
    </Box>
  );
};

const LockedPage = (props) => {
  const { act, data } = useBackend<Data>();
  const { owner } = data;
  return (
    <Dimmer>
      <Stack vertical>
        <Stack.Item>
          <Icon color="purple" name="lock" size={10} />
        </Stack.Item>
        <Stack.Item fontSize="18px" color="purple">
          The Wizard Federation has locked this page.
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const PointLocked = (props) => {
  return (
    <Dimmer>
      <Stack vertical>
        <Stack.Item>
          <Icon color="purple" name="dollar-sign" size={10} />
          <div
            style={{
              background: 'purple',
              bottom: '60%',
              left: '33%',
              height: '10px',
              position: 'relative',
              transform: 'rotate(45deg)',
              width: '150px',
            }}
          />
        </Stack.Item>
        <Stack.Item fontSize="18px" color="purple">
          You do not have enough points to use this page.
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

type WizardLoadout = {
  loadoutId: string;
  loadoutColor: string;
  name: string;
  blurb: string;
  icon: string;
  author: string;
};

const SingleLoadout = (props: WizardLoadout) => {
  const { act } = useBackend<WizardLoadout>();
  const { author, name, blurb, icon, loadoutId, loadoutColor } = props;
  return (
    <Stack.Item grow>
      <Section width={LoadoutWidth} title={name}>
        {blurb}
        <Divider />
        <Button.Confirm
          confirmContent="Confirm Purchase?"
          confirmIcon="dollar-sign"
          confirmColor="good"
          fluid
          icon={icon}
          content="Purchase Loadout"
          onClick={() =>
            act('purchase_loadout', {
              id: loadoutId,
            })
          }
        />
        <Divider />
        <Box color={loadoutColor}>Added by {author}.</Box>
      </Section>
    </Stack.Item>
  );
};

const LoadoutWidth = 19.17;

const Loadouts = (props) => {
  const { data } = useBackend<Data>();
  const { points } = data;
  // Future todo : Make these datums on the DM side
  return (
    <Stack ml={0.5} mt={-0.5} vertical fill>
      {points < 10 && <PointLocked />}
      <Stack.Item>
        <Stack fill>
          <SingleLoadout
            loadoutId="loadout_classic"
            loadoutColor="purple"
            name="经典巫师"
            icon="fire"
            author="Archchancellor Gray"
            blurb={`
                经典法师款，在2550年代疯狂流行，
                自带火球术、魔法飞弹、
                裂解之手和虚空漫步.
                本套装关键在于所有的东西都很简单粗暴.
              `}
          />
          <SingleLoadout
            name="雷神下凡"
            icon="hammer"
            loadoutId="loadout_hammer"
            loadoutColor="green"
            author="Jegudiel Worldshaker"
            blurb={`
                发挥雷神之锤的神力! 最好不要让它离手.
                预设内有唤来术、突变术、闪现术、斥力墙、特斯拉电弧和雷神之锤.
                妥善运用变异这种多功能的魔法:
                比如进行有限的远程攻击和避免糟糕的闪现.
              `}
          />
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <SingleLoadout
            name="亡灵军队"
            icon="pastafarianism"
            loadoutId="loadout_army"
            loadoutColor="yellow"
            author="Prospero Spellstone"
            blurb={`
                如果有人愿意为你杀人的时候，为什么还要亲自动手呢?
                用一下装备拥抱混沌: 灵魂石碎片、变化法杖,
                不死石、传送和虚空漫步! 记住，拒绝进攻性法术!
              `}
          />
          <SingleLoadout
            name="灵魂行者"
            icon="skull"
            loadoutId="loadout_tap"
            loadoutColor="white"
            author="Tom the Empty"
            blurb={`
                拥抱黑暗，深入灵魂.
                你可以通过心灵交换进入新的身体，然后不断地为某些长充能法术进行灵魂注能，
                比如裂解之手等.
              `}
          />
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const lineHeightRandomize = 6;

const Randomize = (props) => {
  const { act, data } = useBackend<Data>();
  const { points, semi_random_bonus, full_random_bonus } = data;
  return (
    <Stack fill vertical>
      {points < 10 && <PointLocked />}
      <Stack.Item>
        Semi-Randomize will ensure you at least get some mobility and lethality.
        Guaranteed to have {semi_random_bonus} points worth of spells.
      </Stack.Item>
      <Stack.Item>
        <Button.Confirm
          confirmContent="Cowabunga it is?"
          confirmIcon="dice-three"
          lineHeight={lineHeightRandomize}
          fluid
          icon="dice-three"
          content="半随机!"
          onClick={() => act('semirandomize')}
        />
        <Divider />
      </Stack.Item>
      <Stack.Item>
        Full Random will give you anything. There&apos;s no going back, either!
        Guaranteed to have {full_random_bonus} points worth of spells.
      </Stack.Item>
      <Stack.Item>
        <NoticeBox danger>
          <Button.Confirm
            confirmContent="Cowabunga it is?"
            confirmIcon="dice"
            lineHeight={lineHeightRandomize}
            fluid
            color="black"
            icon="dice"
            content="全随机!"
            onClick={() => act('randomize')}
          />
        </NoticeBox>
      </Stack.Item>
    </Stack>
  );
};

const SearchSpells = (props) => {
  const { data } = useBackend<Data>();
  const [spellSearch] = useLocalState('spell-search', '');
  const { entries } = data;

  const filterEntryList = (entries: SpellEntry[]) => {
    const searchStatement = spellSearch.toLowerCase();
    if (searchStatement === 'robeless') {
      // Lets you just search for robeless spells, you're welcome mindswap-bros
      return entries.filter((entry) => !entry.requires_wizard_garb);
    }

    return entries.filter(
      (entry) =>
        entry.name.toLowerCase().includes(searchStatement) ||
        // Unsure about including description. Wizard spell descriptions
        // are painfully original and use the same verbiage often,
        // which may both be a benefit and a curse
        entry.desc.toLowerCase().includes(searchStatement) ||
        // Also opting to include category
        // so you can search "rituals" to see them all at once
        entry.cat.toLowerCase().includes(searchStatement),
    );
  };

  const filteredEntries = filterEntryList(entries);

  if (filteredEntries.length === 0) {
    return (
      <Stack width="100%" vertical>
        <Stack.Item>
          <NoticeBox>{`找不到法术!`}</NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <Box italic align="center" color="lightgrey">
            {`提示: 搜索"Robeless" 会显示不需要巫师服装的法术!`}
          </Box>
        </Stack.Item>
      </Stack>
    );
  }
  return (
    <SpellTabDisplay
      TabSpells={filteredEntries}
      CooldownOffset={32}
      PointOffset={84}
    />
  );
};

const SpellTabDisplay = (props: {
  TabSpells: SpellEntry[];
  CooldownOffset?: number;
  PointOffset?: number;
}) => {
  const { act, data } = useBackend<Data>();
  const { points } = data;
  const { TabSpells, CooldownOffset, PointOffset } = props;

  const getTimeOrCat = (entry: SpellEntry) => {
    if (entry.cat === SpellCategory.Rituals) {
      if (entry.times) {
        return `花费 ${entry.times} 次.`;
      } else {
        return '尚未花费.';
      }
    } else {
      if (entry.cooldown) {
        return `${entry.cooldown}秒 冷却`;
      } else {
        return '';
      }
    }
  };

  return (
    <Stack vertical>
      {TabSpells.sort((a, b) => a.name.localeCompare(b.name)).map((entry) => (
        <Stack.Item key={entry.name}>
          <Divider />
          <Stack mt={1.3} width="100%" position="absolute" textAlign="left">
            <Stack.Item width="120px" ml={CooldownOffset}>
              {getTimeOrCat(entry)}
            </Stack.Item>
            <Stack.Item width="60px" ml={PointOffset}>
              {entry.cost} points
            </Stack.Item>
            {entry.buyword === Buywords.Learn && (
              <Stack.Item>
                <Button
                  mt={-0.8}
                  icon="tshirt"
                  color={entry.requires_wizard_garb ? 'bad' : 'green'}
                  tooltipPosition="bottom-start"
                  tooltip={
                    entry.requires_wizard_garb
                      ? '需要巫师服装.'
                      : '无需巫师服装.'
                  }
                />
              </Stack.Item>
            )}
          </Stack>
          <Section title={entry.name}>
            <Stack>
              <Stack.Item grow>{entry.desc}</Stack.Item>
              <Stack.Item>
                <Divider vertical />
              </Stack.Item>
              <Stack.Item>
                <Button
                  fluid
                  textAlign="center"
                  color={points >= entry.cost ? 'green' : 'bad'}
                  disabled={points < entry.cost}
                  width={7}
                  icon={BUYWORD2ICON[entry.buyword]}
                  content={entry.buyword}
                  onClick={() =>
                    act('purchase', {
                      spellref: entry.ref,
                    })
                  }
                />
                <br />
                {(!entry.refundable && <NoticeBox>No refunds.</NoticeBox>) || (
                  <Button
                    textAlign="center"
                    width={7}
                    icon="arrow-left"
                    content="退款"
                    onClick={() =>
                      act('refund', {
                        spellref: entry.ref,
                      })
                    }
                  />
                )}
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const CategoryDisplay = (props: { ActiveCat: TabType }) => {
  const { data } = useBackend<Data>();
  const { entries } = data;
  const { ActiveCat } = props;

  const TabSpells = entries.filter((entry) => entry.cat === ActiveCat.title);

  return (
    <>
      {!!ActiveCat.locked && <LockedPage />}
      <Stack vertical>
        {ActiveCat.blurb && (
          <Stack.Item>
            <Box textAlign="center" bold height="30px">
              {ActiveCat.blurb}
            </Box>
          </Stack.Item>
        )}
        <Stack.Item>
          {(ActiveCat.component && ActiveCat.component()) || (
            <SpellTabDisplay TabSpells={TabSpells} PointOffset={38} />
          )}
        </Stack.Item>
      </Stack>
    </>
  );
};

const widthSection = '466px';
const heightSection = '456px';

export const Spellbook = (props) => {
  const { data } = useBackend<Data>();
  const { points } = data;
  const [tabIndex, setTabIndex] = useLocalState('tab-index', 1);
  const [spellSearch, setSpellSearch] = useLocalState('spell-search', '');
  const ActiveCat = TAB2NAME[tabIndex - 1];
  const ActiveNextCat = TAB2NAME[tabIndex];

  // Has a chance of selecting a random funny verb instead of "Searching"
  const SelectSearchVerb = () => {
    let found = Math.random();
    if (found <= 0.03) {
      return '搜索中';
    }
    if (found <= 0.06) {
      return '沉思中';
    }
    if (found <= 0.09) {
      return '探测中';
    }
    if (found <= 0.12) {
      return '占卜中';
    }
    if (found <= 0.15) {
      return '窥视中';
    }
    if (found <= 0.18) {
      return '冥想中';
    }
    if (found <= 0.21) {
      return '探寻中';
    }
    if (found <= 0.24) {
      return '凝视中';
    }
    if (found <= 0.27) {
      return '学习中';
    }
    if (found <= 0.3) {
      return '回顾中';
    }

    return '搜索中';
  };

  const SelectedVerb = SelectSearchVerb();

  return (
    <Window title="魔法书" theme="wizard" width={950} height={540}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack fill>
              {spellSearch.length > 1 ? (
                <Stack.Item grow>
                  <Section
                    title={`${SelectedVerb}...`}
                    scrollable
                    height={heightSection}
                    fill
                    buttons={
                      <Button
                        content={`停止 ${SelectedVerb}`}
                        icon="arrow-rotate-left"
                        onClick={() => setSpellSearch('')}
                      />
                    }
                  >
                    <SearchSpells />
                  </Section>
                </Stack.Item>
              ) : (
                <>
                  <Stack.Item grow>
                    <Section
                      scrollable={ActiveCat.scrollable}
                      textAlign="center"
                      width={widthSection}
                      height={heightSection}
                      fill
                      title={ActiveCat.title}
                      buttons={
                        <>
                          <Button
                            mr={57}
                            disabled={tabIndex === 1}
                            icon="arrow-left"
                            content="Previous Page"
                            onClick={() => setTabIndex(tabIndex - 2)}
                          />
                          <Box textAlign="right" bold mt={-3.3} mr={1}>
                            {tabIndex}
                          </Box>
                        </>
                      }
                    >
                      <CategoryDisplay ActiveCat={ActiveCat} />
                    </Section>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Section
                      scrollable={ActiveNextCat.scrollable}
                      textAlign="center"
                      width={widthSection}
                      height={heightSection}
                      fill
                      title={ActiveNextCat.title}
                      buttons={
                        <>
                          <Button
                            mr={0}
                            icon="arrow-right"
                            disabled={tabIndex === 9}
                            content="下一页"
                            onClick={() => setTabIndex(tabIndex + 2)}
                          />
                          <Box textAlign="left" bold mt={-3.3} ml={-59.8}>
                            {tabIndex + 1}
                          </Box>
                        </>
                      }
                    >
                      <CategoryDisplay ActiveCat={ActiveNextCat} />
                    </Section>
                  </Stack.Item>
                </>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow>
                  <ProgressBar value={points / 10}>
                    {points + ' 剩余点数.'}
                  </ProgressBar>
                </Stack.Item>
                <Stack.Item>
                  <Input
                    width={15}
                    placeholder="搜索法术中..."
                    onInput={(e, val) => setSpellSearch(val)}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
