import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  Divider,
  Flex,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';

const PacketInfo = (props) => {
  const { act, data } = useBackend();
  const { packet } = props;

  return (
    <Stack.Item>
      <Flex justify="space-between">
        <Flex.Item align="left">{packet.name}</Flex.Item>
        <Flex.Item align="right">
          <Button
            icon="trash"
            color="red"
            onClick={() => act('delete_packet', { ref: packet.ref })}
          />
        </Flex.Item>
      </Flex>
      <LabeledList>
        <LabeledList.Item label="数据类型">{packet.type}</LabeledList.Item>
        <LabeledList.Item label="来源">
          {packet.source + (packet.job ? ' (' + packet.job + ')' : '')}
        </LabeledList.Item>
        <LabeledList.Item label="类">{packet.race}</LabeledList.Item>
        <LabeledList.Item label="内容">{packet.message}</LabeledList.Item>
        <LabeledList.Item label="语言">{packet.language}</LabeledList.Item>
      </LabeledList>
      <Divider />
    </Stack.Item>
  );
};

const ServerScreen = (props) => {
  const { act, data } = useBackend();
  const { network, server } = data;
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="服务器信息"
          buttons={
            <Button
              content="主菜单"
              icon="home"
              onClick={() => act('return_home')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="网络">{network}</LabeledList.Item>
            <LabeledList.Item label="服务器">{server.name}</LabeledList.Item>
            <LabeledList.Item label="记录总流量">
              {server.traffic >= 1024
                ? server.traffic / 1024 + ' TB'
                : server.traffic + ' GB'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="存储数据包">
          <Stack vertical>
            {server.packets?.map((p) => (
              <PacketInfo key={p.ref} packet={p} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const MainScreen = (props) => {
  const { act, data } = useBackend();
  const { servers, network } = data;
  const [networkId, setNetworkId] = useState(network);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Input
            value={networkId}
            onChange={(e, value) => setNetworkId(value)}
            placeholder="网络ID"
          />
          <Button
            content="扫描"
            onClick={() => act('scan_network', { network_id: networkId })}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="检测到的电信服务器"
          buttons={
            <Button
              content="清除缓存"
              icon="trash"
              color="red"
              disabled={servers.length === 0}
              onClick={() => act('clear_buffer')}
            />
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>地址</Table.Cell>
              <Table.Cell>识别字符</Table.Cell>
              <Table.Cell>名称</Table.Cell>
            </Table.Row>
            {servers?.map((s) => (
              <Table.Row key={s.ref}>
                <Table.Cell>{s.ref}</Table.Cell>
                <Table.Cell>{s.id}</Table.Cell>
                <Table.Cell>
                  <Button
                    content={s.name}
                    onClick={() => act('view_server', { server: s.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const ServerMonitor = (props) => {
  const { act, data } = useBackend();
  const { screen, error } = data;
  return (
    <Window width={575} height={400}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            {error !== '' && <NoticeBox>{error}</NoticeBox>}
          </Stack.Item>
          <Stack.Item grow>
            {(screen === 0 && <MainScreen />) ||
              (screen === 1 && <ServerScreen />)}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
