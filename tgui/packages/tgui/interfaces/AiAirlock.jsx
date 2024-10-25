import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const dangerMap = {
  2: {
    color: 'good',
    localStatusText: '离线',
  },
  1: {
    color: 'average',
    localStatusText: '注意',
  },
  0: {
    color: 'bad',
    localStatusText: '最佳',
  },
};

export const AiAirlock = (props) => {
  const { act, data } = useBackend();
  const statusMain = dangerMap[data.power.main] || dangerMap[0];
  const statusBackup = dangerMap[data.power.backup] || dangerMap[0];
  const statusElectrify = dangerMap[data.shock] || dangerMap[0];
  return (
    <Window width={500} height={390}>
      <Window.Content>
        <Section title="电源状况">
          <LabeledList>
            <LabeledList.Item
              label="主要"
              color={statusMain.color}
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!data.power.main}
                  content="Disrupt"
                  onClick={() => act('disrupt-main')}
                />
              }
            >
              {data.power.main ? '在线' : '离线'}{' '}
              {((!data.wires.main_1 || !data.wires.main_2) &&
                '[电缆被剪断了!]') ||
                (data.power.main_timeleft > 0 &&
                  `[${data.power.main_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="备用"
              color={statusBackup.color}
              buttons={
                <Button
                  icon="lightbulb-o"
                  disabled={!data.power.backup}
                  content="中断"
                  onClick={() => act('disrupt-backup')}
                />
              }
            >
              {data.power.backup ? '在线' : '离线'}{' '}
              {((!data.wires.backup_1 || !data.wires.backup_2) &&
                '[电缆被剪断了!]') ||
                (data.power.backup_timeleft > 0 &&
                  `[${data.power.backup_timeleft}s]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="通电"
              color={statusElectrify.color}
              buttons={
                <>
                  <Button
                    icon="wrench"
                    disabled={!(data.wires.shock && data.shock === 0)}
                    content="恢复"
                    onClick={() => act('shock-restore')}
                  />
                  <Button
                    icon="bolt"
                    disabled={!data.wires.shock}
                    content="暂时"
                    onClick={() => act('shock-temp')}
                  />
                  <Button
                    icon="bolt"
                    disabled={!data.wires.shock}
                    content="永久"
                    onClick={() => act('shock-perm')}
                  />
                </>
              }
            >
              {data.shock === 2 ? '安全' : '通电'}{' '}
              {(!data.wires.shock && '[线缆被剪断了!]') ||
                (data.shock_timeleft > 0 && `[${data.shock_timeleft}秒]`) ||
                (data.shock_timeleft === -1 && '[永久]')}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="权限与门控">
          <LabeledList>
            <LabeledList.Item
              label="ID检测"
              color="bad"
              buttons={
                <Button
                  icon={data.id_scanner ? 'power-off' : 'times'}
                  content={data.id_scanner ? '开启' : '关闭'}
                  selected={data.id_scanner}
                  disabled={!data.wires.id_scanner}
                  onClick={() => act('idscan-toggle')}
                />
              }
            >
              {!data.wires.id_scanner && '[线缆被剪断了!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="应急权限"
              buttons={
                <Button
                  icon={data.emergency ? 'power-off' : 'times'}
                  content={data.emergency ? '开启' : '关闭'}
                  selected={data.emergency}
                  onClick={() => act('emergency-toggle')}
                />
              }
            />
            <LabeledList.Divider />
            <LabeledList.Item
              label="门栓"
              color="bad"
              buttons={
                <Button
                  icon={data.locked ? 'lock' : 'unlock'}
                  content={data.locked ? '已放下' : '已收起'}
                  selected={data.locked}
                  disabled={!data.wires.bolts}
                  onClick={() => act('bolt-toggle')}
                />
              }
            >
              {!data.wires.bolts && '[线缆被剪断了!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="门栓灯光"
              color="bad"
              buttons={
                <Button
                  icon={data.lights ? 'power-off' : 'times'}
                  content={data.lights ? '开启' : '关闭'}
                  selected={data.lights}
                  disabled={!data.wires.lights}
                  onClick={() => act('light-toggle')}
                />
              }
            >
              {!data.wires.lights && '[线缆被剪断了!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="外力传感器"
              color="bad"
              buttons={
                <Button
                  icon={data.safe ? 'power-off' : 'times'}
                  content={data.safe ? '开启' : '关闭'}
                  selected={data.safe}
                  disabled={!data.wires.safe}
                  onClick={() => act('safe-toggle')}
                />
              }
            >
              {!data.wires.safe && '[线缆被剪断了!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="定时安全措施"
              color="bad"
              buttons={
                <Button
                  icon={data.speed ? 'power-off' : 'times'}
                  content={data.speed ? '开启' : '关闭'}
                  selected={data.speed}
                  disabled={!data.wires.timing}
                  onClick={() => act('speed-toggle')}
                />
              }
            >
              {!data.wires.timing && '[线缆被剪断了!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="门控"
              color="bad"
              buttons={
                <Button
                  icon={data.opened ? 'sign-out-alt' : 'sign-in-alt'}
                  content={data.opened ? '开启' : '关闭'}
                  selected={data.opened}
                  disabled={data.locked || data.welded}
                  onClick={() => act('open-close')}
                />
              }
            >
              {!!(data.locked || data.welded) && (
                <span>
                  [门{data.locked ? '被门栓锁住' : ''}
                  {data.locked && data.welded ? '而且还' : ''}
                  {data.welded ? '被焊死' : ''}!]
                </span>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
