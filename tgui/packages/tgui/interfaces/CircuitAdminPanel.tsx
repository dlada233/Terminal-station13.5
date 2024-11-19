import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, Stack, Table } from '../components';
import { Window } from '../layouts';

type CircuitAdminPanelData = {
  circuits: {
    ref: string;
    name: string;
    creator: string;
    has_inserter: BooleanLike;
  }[];
};

export const CircuitAdminPanel = (props) => {
  const { act, data } = useBackend<CircuitAdminPanelData>();

  return (
    <Window title="集成电路管理面板" width={1200} height={500}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  onClick={() => {
                    act('disable_circuit_sound');
                  }}
                >
                  关闭所有集成电路声音发射器
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Table>
              <Table.Row header>
                <Table.Cell>集成电路名称</Table.Cell>

                <Table.Cell>创建者</Table.Cell>

                <Table.Cell>动作</Table.Cell>
              </Table.Row>

              {data.circuits.map((circuit) => {
                const createAct = (action: string) => () => {
                  act(action, { circuit: circuit.ref });
                };

                return (
                  <Table.Row key={circuit.ref}>
                    <Table.Cell>{circuit.name}</Table.Cell>

                    <Table.Cell>{circuit.creator}</Table.Cell>

                    <Table.Cell>
                      <Button onClick={createAct('follow_circuit')}>
                        跟随
                      </Button>

                      <Button onClick={createAct('open_circuit')}>打开</Button>

                      <Button onClick={createAct('vv_circuit')}>VV</Button>

                      <Button onClick={createAct('save_circuit')}>保存</Button>

                      <Button onClick={createAct('duplicate_circuit')}>
                        复制
                      </Button>

                      {!!circuit.has_inserter && (
                        <Button onClick={createAct('open_player_panel')}>
                          玩家面板
                        </Button>
                      )}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
