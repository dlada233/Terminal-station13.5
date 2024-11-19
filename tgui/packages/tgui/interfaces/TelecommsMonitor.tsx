import { classes } from 'common/react';
import { toTitleCase } from 'common/string';
import { useMemo, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

enum Screen {
  Main,
  Machine,
}

type Machine = {
  id: string;
  name: string;
  icon: string;
};

type BaseMachine = { network: string; linkedMachines: Machine[] } & Machine;

type Data = {
  screen: Screen;
  statusMessage: string;
  machine?: BaseMachine;
  network: string;
  machines?: Machine[];
};

export const TelecommsMonitor = (props: any) => {
  const { data } = useBackend<Data>();
  const { screen, statusMessage } = data;

  return (
    <Window width={350} height={500} title="电信监控终端">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            {!!statusMessage && <NoticeBox>{statusMessage}</NoticeBox>}
          </Stack.Item>
          <Stack.Item grow>
            {(screen === Screen.Main && <MainScreen />) ||
              (screen === Screen.Machine && <MachineScreen />)}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MainScreen = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { network, machines = [] } = data;

  const [networkId, setNetworkId] = useState(network);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section fill>
          <Stack fill>
            <Stack.Item grow>
              <Input
                fluid
                value={networkId}
                onChange={(_, value) => setNetworkId(value)}
                placeholder="输入网络ID..."
              />
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('probe', { id: networkId })}>
                探测网络
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <MachineList
          title="已检测网络实体"
          buttons={
            <Button
              icon="trash"
              color="red"
              tooltip="刷新缓存"
              disabled={machines.length === 0}
              onClick={() => act('flush')}
            />
          }
          machines={machines}
          onSelect={(machine) => act('view', { id: machine.id })}
        />
      </Stack.Item>
    </Stack>
  );
};

const MachineScreen = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { id, name, network, linkedMachines } = data.machine!;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="实体信息"
          buttons={
            <Button icon="home" onClick={() => act('home')}>
              主菜单
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="网络">{network}</LabeledList.Item>
            <LabeledList.Item label="网络ID">{id}</LabeledList.Item>
            <LabeledList.Item label="网络实体">
              {toTitleCase(name)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <MachineList
          title="已连接实体"
          machines={linkedMachines}
          onSelect={(machine) => act('view', { id: machine.id })}
        />
      </Stack.Item>
    </Stack>
  );
};

type MachineListProps = {
  title: string;
  buttons?: React.ReactNode;
  machines: Machine[];
  onSelect: (machine: Machine) => void;
};

const MachineList = (props: MachineListProps) => {
  const { title, buttons, machines, onSelect } = props;

  const [searching, setSearching] = useState(false);
  const [search, setSearch] = useState('');

  const sortedMachines = useMemo(
    () =>
      machines.filter((machine) =>
        machine.id.toLowerCase().includes(search.toLowerCase()),
      ),
    [search, machines.length],
  );

  return (
    <Section
      fill
      title={title}
      buttons={
        <>
          <Button
            icon="magnifying-glass"
            selected={searching}
            disabled={machines.length === 0}
            tooltip="以ID搜索"
            onClick={() => setSearching(!searching)}
          />
          {buttons}
        </>
      }
    >
      {sortedMachines.length > 0 ? (
        <Stack fill vertical>
          <Stack.Item grow>
            <Stack fill vertical overflowY="scroll">
              {sortedMachines.map((machine, index) => (
                <Stack.Item key={index}>
                  <Button
                    fluid
                    verticalAlignContent="middle"
                    tooltip={toTitleCase(machine.name)}
                    onClick={() => onSelect(machine)}
                  >
                    <Stack fill align="center">
                      <Stack.Item>
                        <Box
                          className={classes(['tcomms32x32', machine.icon])}
                        />
                      </Stack.Item>
                      <Stack.Item grow>{machine.id}</Stack.Item>
                    </Stack>
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          {searching && (
            <Stack.Item height={2}>
              <Input
                mx={1}
                fluid
                autoFocus
                value={search}
                verticalAlign="middle"
                placeholder="输入机器ID..."
                onChange={(_e, value) => setSearch(value)}
              />
            </Stack.Item>
          )}
        </Stack>
      ) : (
        <NoticeBox>未连接到机器!</NoticeBox>
      )}
    </Section>
  );
};
