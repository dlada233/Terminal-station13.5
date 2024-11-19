import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type BasketballPanelData = {
  total_votes: number;
  players_min: number;
  players_max: number;
  lobbydata: {
    ckey: string;
    status: string;
  }[];
};

export const BasketballPanel = (props) => {
  const { act, data } = useBackend<BasketballPanelData>();

  return (
    <Window title="篮球" width={650} height={580}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="大厅"
              buttons={
                <>
                  <Button
                    icon="clipboard-check"
                    tooltipPosition="bottom-start"
                    tooltip={`
                    报名参加比赛，如果已有比赛在进行，你将自动报名下场比赛.
                  `}
                    content="报名"
                    onClick={() => act('basketball_signup')}
                  />
                  <Button
                    icon="basketball"
                    disabled={data.total_votes < data.players_min}
                    onClick={() => act('basketball_start')}
                  >
                    开始
                  </Button>
                </>
              }
            >
              <NoticeBox info>
                大厅有 {data.total_votes} 名玩家报名. 这个小游戏 适合{' '}
                {data.players_min} 到 {data.players_max} 名玩家.
              </NoticeBox>

              {data.lobbydata.map((lobbyist) => (
                <Stack
                  key={lobbyist.ckey}
                  className="candystripe"
                  p={1}
                  align="baseline"
                >
                  <Stack.Item grow>{lobbyist.ckey}</Stack.Item>
                  <Stack.Item>状态:</Stack.Item>
                  <Stack.Item
                    color={lobbyist.status === 'Ready' ? 'green' : 'red'}
                  >
                    {lobbyist.status}
                  </Stack.Item>
                </Stack>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item />
        </Stack>
      </Window.Content>
    </Window>
  );
};
