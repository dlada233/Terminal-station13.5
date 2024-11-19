// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const MicrofusionGunControl = (props) => {
  const { act, data } = useBackend();
  const { current_players, servers = [] } = data;
  return (
    <Window title="服务器控制面板" width={500} height={700}>
      <Window.Content>
        {servers.len === 0 ? (
          <NoticeBox>当前没有服务器在线.</NoticeBox>
        ) : (
          servers.map((server) => (
            <Section
              key={server.name}
              title={server.name}
              buttons={
                <Button
                  icon="connect"
                  content="连接"
                  onClick={() =>
                    act('connect', {
                      server_ref: server.name,
                    })
                  }
                />
              }
            >
              <LabeledList>
                <LabeledList.Item label="玩家">
                  {server.players}/{server.max_players}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))
        )}
      </Window.Content>
    </Window>
  );
};
