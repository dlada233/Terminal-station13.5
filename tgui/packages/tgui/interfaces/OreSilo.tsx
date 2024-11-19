import { classes } from 'common/react';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Icon,
  Image,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
  Tooltip,
  VirtualList,
} from '../components';
import { Window } from '../layouts';
import { MaterialAccessBar } from './Fabrication/MaterialAccessBar';
import { Material } from './Fabrication/Types';

type Machine = {
  name: string;
  icon: string;
  onHold: boolean;
  location: string;
};

type Log = {
  rawMaterials: string;
  machineName: string;
  areaName: string;
  action: string;
  amount: number;
  time: string;
  noun: string;
};

enum Tab {
  Machines,
  Logs,
}

type Data = {
  SHEET_MATERIAL_AMOUNT: number;
  materials: Material[];
  machines: Machine[];
  logs: Log[];
};

export const OreSilo = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { SHEET_MATERIAL_AMOUNT, machines, logs } = data;

  const [currentTab, setCurrentTab] = useState<Tab>(Tab.Logs);

  return (
    <Window title="矿仓" width={620} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                icon="plug"
                selected={currentTab === Tab.Machines}
                onClick={() => setCurrentTab(Tab.Machines)}
              >
                连接
              </Tabs.Tab>
              <Tabs.Tab
                icon="book-bookmark"
                selected={currentTab === Tab.Logs}
                onClick={() => setCurrentTab(Tab.Logs)}
              >
                日志
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {currentTab === Tab.Machines ? (
              <MachineList
                machines={machines!}
                onPause={(index) => act('hold', { id: index })}
                onRemove={(index) => act('remove', { id: index })}
              />
            ) : null}
            {currentTab === Tab.Logs ? <LogsList logs={logs!} /> : null}
          </Stack.Item>
          <Stack.Item>
            <Section fill>
              <MaterialAccessBar
                availableMaterials={data.materials}
                SHEET_MATERIAL_AMOUNT={SHEET_MATERIAL_AMOUNT}
                onEjectRequested={(material, amount) =>
                  act('eject', { ref: material.ref, amount })
                }
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

type MachineListProps = {
  machines: Machine[];
  onPause: (index: number) => void;
  onRemove: (index: number) => void;
};

const MachineList = (props: MachineListProps) => {
  const { machines, onPause, onRemove } = props;

  return machines.length > 0 ? (
    <Section fill scrollable>
      {machines.map((machine, index) => (
        <MachineDisplay
          key={index}
          machine={machine}
          onPause={() => onPause(index + 1)}
          onRemove={() => onRemove(index + 1)}
        />
      ))}
    </Section>
  ) : (
    <NoticeBox>未连接到机器!</NoticeBox>
  );
};

type MachineProps = {
  machine: Machine;
  onPause: () => void;
  onRemove: () => void;
};

const MachineDisplay = (props: MachineProps) => {
  const { machine, onPause, onRemove } = props;

  let machineName = machine.name;
  const index = machineName.indexOf('('); // some techfabs have their location attached to their name
  if (index >= 0) {
    machineName = machineName.substring(0, index);
  }
  machineName = `${machineName.trimEnd()} (${machine.location})`;

  return (
    <Box className="FabricatorRecipe">
      <Box
        className={
          machine.onHold
            ? classes([
                'FabricatorRecipe__Title',
                'FabricatorRecipe__Title--disabled',
              ])
            : 'FabricatorRecipe__Title'
        }
      >
        <Box className="FabricatorRecipe__Icon">
          <Image
            width={'32px'}
            height={'32px'}
            src={`data:image/jpeg;base64,${machine.icon}`}
          />
        </Box>
        <Box className="FabricatorRecipe__Label">{machineName}</Box>
      </Box>

      <Tooltip
        content={
          machine.onHold
            ? `恢复 ${machine.name} 供应.`
            : `搁置 ${machine.name} 使用.`
        }
      >
        <Box
          className={classes([
            'FabricatorRecipe__Button',
            'FabricatorRecipe__Button--icon',
          ])}
          onClick={(_) => {
            onPause();
          }}
        >
          <Icon name={machine.onHold ? 'circle-play' : 'circle-pause'} />
        </Box>
      </Tooltip>
      <Tooltip content={`断开 ${machine.name} 连接.`}>
        <Box
          className={classes([
            'FabricatorRecipe__Button',
            'FabricatorRecipe__Button--icon',
          ])}
          onClick={(_) => {
            onRemove();
          }}
        >
          <Icon name="trash-can" />
        </Box>
      </Tooltip>
    </Box>
  );
};

type LogsListProps = {
  logs: Log[];
};

const LogsList = (props: LogsListProps) => {
  const { logs } = props;

  return logs.length > 0 ? (
    <Box pr={1} height="100%" overflowY="scroll">
      <VirtualList>
        {logs.map((log, index) => (
          <LogEntry key={index} log={log} />
        ))}
      </VirtualList>
    </Box>
  ) : (
    <NoticeBox>当前没有日志条目!</NoticeBox>
  );
};

type LogProps = {
  log: Log;
};

const LogEntry = (props: LogProps) => {
  const { log } = props;
  return (
    <Section
      title={`${capitalize(log.action)}: x${Math.abs(log.amount)} ${log.noun}`}
    >
      <LabeledList>
        <LabeledList.Item label="时间">{log.time}</LabeledList.Item>
        <LabeledList.Item label="机器">
          {capitalize(log.machineName)}
        </LabeledList.Item>
        <LabeledList.Item label="地点">{log.areaName}</LabeledList.Item>
        <LabeledList.Item label="材料" color={log.amount > 0 ? 'good' : 'bad'}>
          {log.rawMaterials}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
