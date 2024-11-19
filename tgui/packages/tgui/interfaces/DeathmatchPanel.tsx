import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

type Lobby = {
  name: string;
  players: number;
  max_players: number;
  map: string;
  playing: BooleanLike;
};

type Data = {
  hosting: BooleanLike;
  admin: BooleanLike;
  playing: string;
  lobbies: Lobby[];
};

export function DeathmatchPanel(props) {
  const { act, data } = useBackend<Data>();
  const { hosting } = data;

  return (
    <Window title="死亡竞赛大厅列表" width={360} height={400}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <NoticeBox danger>
              参与后，你仍能回到原本的身体 (不保证100%)!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <LobbyPane />
          </Stack.Item>
          <Stack.Item>
            <Button
              disabled={!!hosting}
              fluid
              textAlign="center"
              color="good"
              onClick={() => act('host')}
            >
              创建大厅
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

function LobbyPane(props) {
  const { data } = useBackend<Data>();
  const { lobbies = [] } = data;

  return (
    <Section fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell>房主</Table.Cell>
          <Table.Cell>地图</Table.Cell>
          <Table.Cell>
            <Tooltip content="玩家">
              <Icon name="users" />
            </Tooltip>
          </Table.Cell>
          <Table.Cell align="center">
            <Icon name="hammer" />
          </Table.Cell>
        </Table.Row>

        {lobbies.length === 0 && (
          <Table.Row>
            <Table.Cell colSpan={4}>
              <NoticeBox textAlign="center">未找到大厅. 开始一个!</NoticeBox>
            </Table.Cell>
          </Table.Row>
        )}

        {lobbies.map((lobby, index) => (
          <LobbyDisplay key={index} lobby={lobby} />
        ))}
      </Table>
    </Section>
  );
}

function LobbyDisplay(props) {
  const { act, data } = useBackend<Data>();
  const { admin, playing, hosting } = data;
  const { lobby } = props;

  const isActive = (!!hosting || !!playing) && playing !== lobby.name;

  return (
    <Table.Row className="candystripe" key={lobby.name}>
      <Table.Cell>
        {!admin ? (
          lobby.name
        ) : (
          <Dropdown
            width={10}
            noChevron
            selected={lobby.name}
            options={['关闭', '浏览']}
            onSelected={(value) =>
              act('admin', {
                id: lobby.name,
                func: value,
              })
            }
          />
        )}
      </Table.Cell>
      <Table.Cell>{lobby.map}</Table.Cell>
      <Table.Cell collapsing>
        {lobby.players}/{lobby.max_players}
      </Table.Cell>
      <Table.Cell collapsing>
        {!lobby.playing ? (
          <>
            <Button
              disabled={isActive}
              color="good"
              onClick={() => act('join', { id: lobby.name })}
            >
              {playing === lobby.name ? '浏览' : '加入'}
            </Button>
            <Button
              color="caution"
              icon="eye"
              onClick={() => act('spectate', { id: lobby.name })}
            />
          </>
        ) : (
          <Button
            disabled={isActive}
            color="good"
            onClick={() => act('spectate', { id: lobby.name })}
          >
            观战
          </Button>
        )}
      </Table.Cell>
    </Table.Row>
  );
}
