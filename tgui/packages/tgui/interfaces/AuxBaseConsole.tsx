import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';
import { ShuttleConsoleContent } from './ShuttleConsole';

type Data = {
  type: string;
  blind_drop: BooleanLike;
  turrets: Turret[];
};

type Turret = {
  ref: string;
  key: string;
  name: string;
  integrity: number;
  status: string;
  direction: string;
  distance: number;
};

const STATUS_COLOR_KEYS = {
  ERROR: 'bad',
  Disabled: 'bad',
  Firing: 'average',
  'All Clear': 'good',
} as const;

enum TAB {
  Shuttle = 1,
  Aux,
}

export const AuxBaseConsole = (props) => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState(TAB.Shuttle);
  const { type, blind_drop, turrets = [] } = data;

  return (
    <Window
      width={turrets.length ? 620 : 350}
      height={turrets.length ? 310 : 260}
    >
      <Window.Content scrollable={!!turrets.length}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === TAB.Shuttle}
            onClick={() => setTab(TAB.Shuttle)}
          >
            {type === 'shuttle' ? '飞船发射' : '基地发射'}
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === TAB.Aux}
            onClick={() => setTab(TAB.Aux)}
          >
            炮塔 ({turrets.length})
          </Tabs.Tab>
        </Tabs>
        {tab === TAB.Shuttle && (
          <ShuttleConsoleContent type={type} blind_drop={blind_drop} />
        )}
        {tab === TAB.Aux && <AuxBaseConsoleContent />}
      </Window.Content>
    </Window>
  );
};

export const AuxBaseConsoleContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { turrets = [] } = data;

  return (
    <Section
      fill
      scrollable
      title="炮塔控制"
      buttons={
        !!turrets.length && (
          <Button icon="power-off" onClick={() => act('turrets_power')}>
            电源开关
          </Button>
        )
      }
    >
      {!turrets.length ? (
        <NoticeBox>没有连接到的炮塔</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>单位</Table.Cell>
            <Table.Cell>情况</Table.Cell>
            <Table.Cell>状态</Table.Cell>
            <Table.Cell>方向</Table.Cell>
            <Table.Cell>距离</Table.Cell>
            <Table.Cell>电力</Table.Cell>
          </Table.Row>
          {turrets.map((turret) => (
            <Table.Row key={turret.key}>
              <Table.Cell bold>{turret.name}</Table.Cell>
              <Table.Cell>{turret.integrity}%</Table.Cell>
              <Table.Cell color={STATUS_COLOR_KEYS[turret.status] || 'bad'}>
                {turret.status}
              </Table.Cell>
              <Table.Cell>{turret.direction}</Table.Cell>
              <Table.Cell>{turret.distance}m</Table.Cell>
              <Table.Cell>
                <Button
                  icon="power-off"
                  onClick={() =>
                    act('single_turret_power', {
                      single_turret_power: turret.ref,
                    })
                  }
                >
                  开关
                </Button>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};
