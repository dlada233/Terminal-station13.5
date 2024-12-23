import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { BlockQuote, Box, Dimmer, Icon, Section, Stack } from '../components';
import { Window } from '../layouts';

type Bounty = {
  name: string;
  help: string;
  difficulty: string;
  reward: string;
  claimed: BooleanLike;
  can_claim: BooleanLike;
};

type Data = {
  time_left: number;
  bounties: Bounty[];
};

const difficulty_to_color = {
  easy: 'good',
  medium: 'average',
  hard: 'bad',
};

const BountyDimmer = (props: { text: string; color: string }) => {
  return (
    <Dimmer>
      <Stack>
        <Stack.Item>
          <Icon name="user-secret" size={2} color={props.color} />
        </Stack.Item>
        <Stack.Item align={'center'} italic>
          {props.text}
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const BountyDisplay = (props: { bounty: Bounty }) => {
  const { bounty } = props;

  return (
    <Section>
      {!!bounty.claimed && <BountyDimmer color="bad" text="Claimed!" />}
      {!bounty.can_claim && !bounty.claimed && (
        <BountyDimmer
          color="average"
          text="你的赞助人认为你不适合完成这件事."
        />
      )}
      <Stack vertical ml={1}>
        <Stack.Item>
          <Box
            style={{
              textTransform: 'capitalize',
            }}
            color={difficulty_to_color[bounty.difficulty.toLowerCase()]}
          >
            {bounty.name}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <BlockQuote italic>{bounty.help}</BlockQuote>
        </Stack.Item>
        <Stack.Item italic>奖励: {bounty.reward}</Stack.Item>
      </Stack>
    </Section>
  );
};

// Formats a number of deciseconds into a string minutes:seconds
const format_deciseconds = (deciseconds: number) => {
  const seconds = Math.floor(deciseconds / 10);
  const minutes = Math.floor(seconds / 60);

  const seconds_left = seconds % 60;
  const minutes_left = minutes % 60;

  const seconds_string = seconds_left.toString().padStart(2, '0');
  const minutes_string = minutes_left.toString().padStart(2, '0');

  return `${minutes_string}:${seconds_string}`;
};

export const SpyUplink = () => {
  const { data } = useBackend<Data>();
  const { bounties, time_left } = data;

  return (
    <Window width={450} height={615} theme="ntos_darkmode">
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Section
          fill
          title="间谍奖励"
          scrollable
          buttons={
            <Box mt={0.4}>距离刷新时间: {format_deciseconds(time_left)}</Box>
          }
        >
          <Stack vertical fill>
            <Stack.Item>
              {bounties.map((bounty) => (
                <Stack.Item key={bounty.name} className="candystripe">
                  <BountyDisplay bounty={bounty} />
                </Stack.Item>
              ))}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
