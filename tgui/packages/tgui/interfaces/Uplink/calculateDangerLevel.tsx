import { Box, Flex } from '../../components';

export const calculateProgression = (progression_points: number) => {
  return Math.round(progression_points / 6) / 10;
};

const badGradient = 'reputation-bad';
const normalGradient = 'reputation-normal';
const goodGradient = 'reputation-good';
const veryGoodGradient = 'reputation-very-good';
const ultraGoodGradient = 'reputation-super-good';
const bestGradient = 'reputation-best';

export type Rank = {
  minutesLessThan: number;
  title: string;
  gradient: string;
};

export const ranks: Rank[] = [
  {
    minutesLessThan: 5,
    title: '毫无威胁',
    gradient: badGradient,
  },
  {
    minutesLessThan: 10,
    title: '不值一提',
    gradient: normalGradient,
  },
  {
    minutesLessThan: 20,
    title: '无足轻重',
    gradient: normalGradient,
  },
  {
    minutesLessThan: 30,
    title: '小有妨碍',
    gradient: goodGradient,
  },
  {
    minutesLessThan: 50,
    title: '隐患重重',
    gradient: goodGradient,
  },
  {
    minutesLessThan: 70,
    title: '如芒在背',
    gradient: veryGoodGradient,
  },
  {
    minutesLessThan: 90,
    title: '咄咄逼人',
    gradient: veryGoodGradient,
  },
  {
    minutesLessThan: 110,
    title: '气势汹汹',
    gradient: ultraGoodGradient,
  },
  {
    minutesLessThan: 140,
    title: '势不可挡',
    gradient: ultraGoodGradient,
  },
  {
    minutesLessThan: -1,
    title: '灭顶之灾',
    gradient: bestGradient,
  },
];

export const dangerDefault = 50 * 600;

let lastMinutesThan = -1;
export const dangerLevelsTooltip = (
  <Box preserveWhitespace>
    <Flex direction="column" mt={1}>
      {ranks.map((value) => {
        if (lastMinutesThan === -1) {
          lastMinutesThan = 0;
        }
        const progression = calculateProgression(lastMinutesThan * 600);
        const text = `${value.title} (${progression})`;

        lastMinutesThan = value.minutesLessThan;
        return (
          <Flex.Item key={value.minutesLessThan} mt={0.1}>
            <Box
              color="white"
              className={value.gradient}
              style={{
                borderRadius: '5px',
                display: 'inline-block',
              }}
              px={0.8}
              py={0.6}
            >
              {text}
            </Box>
          </Flex.Item>
        );
      })}
    </Flex>
  </Box>
);

export const getDangerLevel = (progression_points: number) => {
  const minutes = progression_points / 600;

  for (let index = 0; index < ranks.length; index++) {
    const rank = ranks[index];
    if (minutes < rank.minutesLessThan) {
      return rank;
    }
  }

  return ranks[ranks.length - 1];
};

export const calculateDangerLevel = (
  progression_points: number,
  textOnly: boolean,
) => {
  const minutes = progression_points / 600;
  const displayedProgression = calculateProgression(progression_points);
  const dangerLevel = getDangerLevel(progression_points);
  if (textOnly) {
    return (
      <Box as="span">
        {dangerLevel.title} ({displayedProgression})
      </Box>
    );
  }
  return (
    <Box
      color="white"
      className={dangerLevel.gradient}
      style={{
        borderRadius: '5px',
        display: 'inline-block',
      }}
      px={0.8}
      py={0.6}
    >
      {dangerLevel.title} ({displayedProgression})
    </Box>
  );
};
