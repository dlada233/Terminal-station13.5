// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type ICESData = {
  current_credits: number;
  next_run: string;
  active_players: number;
  lowpop_players: number;
  lowpop_multiplier: number;
  midpop_players: number;
  midpop_multiplier: number;
  highpop_players: number;
  highpop_multiplier: number;
};

type Props = {
  context: any;
};

export const IntensityCredits = (props) => {
  const { act, data } = useBackend<ICESData>();

  const {
    current_credits,
    next_run,
    active_players,
    lowpop_players,
    lowpop_multiplier,
    midpop_players,
    midpop_multiplier,
    highpop_players,
    highpop_multiplier,
  } = data;

  return (
    <Window title="ICES事件面板" width={480} height={320} theme="admin">
      <Window.Content>
        <Section title="状态">
          <Flex direction="column">
            <Flex.Item>强度分数: {current_credits}</Flex.Item>
            <Flex.Item>下次事件: {next_run}</Flex.Item>
            <Flex.Item>活跃玩家: {active_players}</Flex.Item>
            <Flex.Item>高人口阈值: {highpop_players}</Flex.Item>
            <Flex.Item>高人口乘数: {highpop_multiplier}x</Flex.Item>
            <Flex.Item>中人口阈值: {midpop_players}</Flex.Item>
            <Flex.Item>中人口乘数: {midpop_multiplier}x</Flex.Item>
            <Flex.Item>低人口阈值: {lowpop_players}</Flex.Item>
            <Flex.Item>低人口乘数: {lowpop_multiplier}x</Flex.Item>
          </Flex>
        </Section>
        <Section title="配置">
          <NoticeBox>这里什么都没有喵:3</NoticeBox>
        </Section>
      </Window.Content>
    </Window>
  );
};
