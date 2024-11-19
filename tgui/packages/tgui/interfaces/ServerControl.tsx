import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, Collapsible, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  server_connected: BooleanLike;
  servers: ServerData[];
  consoles: ConsoleData[];
  logs: LogData[];
};

type ServerData = {
  server_name: string;
  server_details: string;
  server_disabled: string;
  server_ref: string;
};

type ConsoleData = {
  console_name: string;
  console_location: string;
  console_locked: string;
  console_ref: string;
};

type LogData = {
  node_name: string;
  node_cost: string;
  node_researcher: string;
  node_research_location: string;
};

export const ServerControl = (props) => {
  const { act, data } = useBackend<Data>();
  const { server_connected, servers, consoles, logs } = data;
  if (!server_connected) {
    return (
      <Window width={575} height={450}>
        <Window.Content>
          <NoticeBox textAlign="center" danger>
            Not connected to a Server. Please sync one using a multitool.
          </NoticeBox>
        </Window.Content>
      </Window>
    );
  }
  return (
    <Window width={575} height={400}>
      <Window.Content scrollable>
        {!servers ? (
          <NoticeBox mt={2} info>
            未找到服务器.
          </NoticeBox>
        ) : (
          <Section>
            <Table textAlign="center">
              <Table.Row header>
                <Table.Cell>研究服务器</Table.Cell>
              </Table.Row>
              {servers.map((server) => (
                <>
                  <Table.Row
                    header
                    key={server.server_ref}
                    className="candystripe"
                  />
                  <Table.Cell> {server.server_name}</Table.Cell>
                  <Button
                    mt={1}
                    tooltip={server.server_details}
                    color={server.server_disabled ? 'bad' : 'good'}
                    content={server.server_disabled ? '离线' : '在线'}
                    fluid
                    textAlign="center"
                    onClick={() =>
                      act('lockdown_server', {
                        selected_server: server.server_ref,
                      })
                    }
                  />
                </>
              ))}
            </Table>
          </Section>
        )}

        {!consoles ? (
          <NoticeBox mt={2} info>
            未找到控制终端.
          </NoticeBox>
        ) : (
          <Section align="right">
            <Table textAlign="center">
              <Table.Row header>
                <Table.Cell>研究控制台</Table.Cell>
              </Table.Row>
              {consoles.map((console) => (
                <>
                  <Table.Row
                    header
                    key={console.console_ref}
                    className="candystripe"
                  />
                  <Table.Cell>
                    {' '}
                    {console.console_name} - 位置: {console.console_location}{' '}
                  </Table.Cell>
                  <Button
                    mt={1}
                    color={console.console_locked ? 'bad' : 'good'}
                    content={console.console_locked ? '被锁定' : '未锁定'}
                    fluid
                    textAlign="center"
                    onClick={() =>
                      act('lock_console', {
                        selected_console: console.console_ref,
                      })
                    }
                  />
                </>
              ))}
            </Table>
          </Section>
        )}

        <Collapsible title="研究记录">
          {!logs.length ? (
            <NoticeBox mt={2} info>
              未发现研究记录.
            </NoticeBox>
          ) : (
            <Section>
              <Table>
                <Table.Row header>
                  <Table.Cell>研究名称</Table.Cell>
                  <Table.Cell>花费</Table.Cell>
                  <Table.Cell>研究者姓名</Table.Cell>
                  <Table.Cell>控制台位置</Table.Cell>
                </Table.Row>
                {logs.map((server_log) => (
                  <Table.Row
                    mt={1}
                    key={server_log.node_name}
                    className="candystripe"
                  >
                    <Table.Cell>{server_log.node_name}</Table.Cell>
                    <Table.Cell>{server_log.node_cost}</Table.Cell>
                    <Table.Cell>{server_log.node_researcher}</Table.Cell>
                    <Table.Cell>{server_log.node_research_location}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          )}
        </Collapsible>
      </Window.Content>
    </Window>
  );
};
