import { useBackend } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const GhostPoolProtection = (props) => {
  const { act, data } = useBackend();
  const {
    events_or_midrounds,
    spawners,
    station_sentience,
    silicons,
    minigames,
  } = data;
  return (
    <Window title="幽灵池保护" width={400} height={270} theme="admin">
      <Window.Content>
        <Flex grow={1} height="100%">
          <Section
            title="设置"
            buttons={
              <>
                <Button
                  color="good"
                  icon="plus-circle"
                  content="开启所有"
                  onClick={() => act('all_roles')}
                />
                <Button
                  color="bad"
                  icon="minus-circle"
                  content="关闭所有"
                  onClick={() => act('no_roles')}
                />
              </>
            }
          >
            <NoticeBox danger>
              对那些偷偷创建事件的人：如果你开启了‘站点创建感知’功能，人们可能会察觉
              到管理员为你的事件禁用了角色...
            </NoticeBox>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color={events_or_midrounds ? 'good' : 'bad'}
                icon="meteor"
                content="事件及中局规则集"
                onClick={() => act('toggle_events_or_midrounds')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color={spawners ? 'good' : 'bad'}
                icon="pastafarianism"
                content="幽灵角色生成点"
                onClick={() => act('toggle_spawners')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color={station_sentience ? 'good' : 'bad'}
                icon="user-astronaut"
                content="站点创建感知"
                onClick={() => act('toggle_station_sentience')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color={silicons ? 'good' : 'bad'}
                icon="robot"
                content="硅基"
                onClick={() => act('toggle_silicons')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color={minigames ? 'good' : 'bad'}
                icon="gamepad"
                content="迷你游戏"
                onClick={() => act('toggle_minigames')}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                textAlign="center"
                color="orange"
                icon="check"
                content="应用更改"
                onClick={() => act('apply_settings')}
              />
            </Flex.Item>
          </Section>
        </Flex>
      </Window.Content>
    </Window>
  );
};
