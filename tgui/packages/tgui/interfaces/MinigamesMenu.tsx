import { useBackend } from '../backend';
import { Button, Divider, Section, Stack } from '../components';
import { Window } from '../layouts';

export const MinigamesMenu = (props) => {
  const { act } = useBackend();

  return (
    <Window title="迷你游戏菜单" width={530} height={320}>
      <Window.Content>
        <Section title="选择迷你游戏" textAlign="center" fill>
          <Stack>
            <Stack.Item grow>
              <Button
                content="CTF"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('ctf')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="狼人杀"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('mafia')}
              />
            </Stack.Item>
          </Stack>
          <Divider />
          <Stack>
            <Stack.Item grow>
              <Button
                content="篮球比赛"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('basketball')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="死亡竞赛"
                fluid
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('deathmatch')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
