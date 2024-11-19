import { BooleanLike } from 'common/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  BossID: string;
  GameActive: BooleanLike;
  Hitpoints: number;
  PauseState: BooleanLike;
  PlayerHitpoints: number;
  PlayerMP: number;
  Status: string;
  TicketCount: number;
};

export function NtosArcade(props) {
  return (
    <NtosWindow width={450} height={350}>
      <NtosWindow.Content>
        <Section title="轰炸古巴皮特超级版" textAlign="center">
          <Stack fill>
            <Stack.Item>
              <PlayerStats />
            </Stack.Item>
            <Stack.Item>
              <BossBar />
            </Stack.Item>
          </Stack>
          <BottomButtons />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
}

function PlayerStats(props) {
  const { data } = useBackend<Data>();
  const { PauseState, PlayerHitpoints, PlayerMP, Status } = data;

  return (
    <>
      <LabeledList>
        <LabeledList.Item label="玩家健康">
          <ProgressBar
            value={PlayerHitpoints}
            minValue={0}
            maxValue={30}
            ranges={{
              olive: [31, Infinity],
              good: [20, 31],
              average: [10, 20],
              bad: [-Infinity, 10],
            }}
          >
            {PlayerHitpoints}HP
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="玩家魔力">
          <ProgressBar
            value={PlayerMP}
            minValue={0}
            maxValue={10}
            ranges={{
              purple: [11, Infinity],
              violet: [3, 11],
              bad: [-Infinity, 3],
            }}
          >
            {PlayerMP}MP
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <NoticeBox danger={!PauseState}>{Status}</NoticeBox>
    </>
  );
}

function BossBar(props) {
  const { data } = useBackend<Data>();
  const { BossID, Hitpoints } = data;

  return (
    <>
      <ProgressBar
        value={Hitpoints}
        minValue={0}
        maxValue={45}
        ranges={{
          good: [30, Infinity],
          average: [5, 30],
          bad: [-Infinity, 5],
        }}
      >
        <AnimatedNumber value={Hitpoints} />
        HP
      </ProgressBar>
      <Box m={1} />
      <Section inline width="156px" textAlign="center">
        <img src={resolveAsset(BossID)} />
      </Section>
    </>
  );
}

function BottomButtons(props) {
  const { act, data } = useBackend<Data>();
  const { GameActive, PauseState, TicketCount } = data;

  return (
    <>
      <Button
        icon="fist-raised"
        tooltip="全力以赴!"
        tooltipPosition="top"
        disabled={!GameActive || !!PauseState}
        onClick={() => act('Attack')}
      >
        攻击!
      </Button>
      <Button
        icon="band-aid"
        tooltip="治愈自己!"
        tooltipPosition="top"
        disabled={!GameActive || !!PauseState}
        onClick={() => act('Heal')}
      >
        治疗!
      </Button>
      <Button
        icon="magic"
        tooltip="回复你的魔力!"
        tooltipPosition="top"
        disabled={!GameActive || !!PauseState}
        onClick={() => act('Recharge_Power')}
      >
        回魔!
      </Button>

      <Box>
        <Button
          icon="sync-alt"
          tooltip="再来一局也无妨."
          tooltipPosition="top"
          disabled={!!GameActive}
          onClick={() => act('Start_Game')}
        >
          开始游戏
        </Button>
        <Button
          icon="ticket-alt"
          tooltip="在您当地的街机上兑换奖品!"
          tooltipPosition="top"
          disabled={!!GameActive}
          onClick={() => act('Dispense_Tickets')}
        >
          兑换奖券
        </Button>
      </Box>
      <Box color={TicketCount >= 1 ? 'good' : 'normal'}>
        获得奖券: {TicketCount}
      </Box>
    </>
  );
}
