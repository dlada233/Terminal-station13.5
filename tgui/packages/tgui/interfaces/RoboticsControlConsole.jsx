import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const RoboticsControlConsole = (props) => {
  const { act, data } = useBackend();
  const [tab, setTab] = useSharedState('tab', 1);
  const { can_hack, can_detonate, cyborgs = [], drones = [] } = data;

  return (
    <Window width={500} height={460}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}
          >
            赛博 ({cyborgs.length})
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}
          >
            无人机 ({drones.length})
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && (
          <Cyborgs
            cyborgs={cyborgs}
            can_hack={can_hack}
            can_detonate={can_detonate}
          />
        )}
        {tab === 2 && <Drones drones={drones} />}
      </Window.Content>
    </Window>
  );
};

const Cyborgs = (props) => {
  const { cyborgs, can_hack, can_detonate } = props;
  const { act, data } = useBackend();
  if (!cyborgs.length) {
    return <NoticeBox>访问范围内未检测到赛博单位</NoticeBox>;
  }
  return cyborgs.map((cyborg) => {
    return (
      <Section
        key={cyborg.ref}
        title={cyborg.name}
        buttons={
          <>
            {!!can_hack && !cyborg.emagged && (
              <Button
                icon="terminal"
                content="黑入"
                color="bad"
                onClick={() =>
                  act('magbot', {
                    ref: cyborg.ref,
                  })
                }
              />
            )}
            <Button.Confirm
              icon={cyborg.locked_down ? 'unlock' : 'lock'}
              color={cyborg.locked_down ? 'good' : 'default'}
              content={cyborg.locked_down ? '释放' : '限制'}
              onClick={() =>
                act('stopbot', {
                  ref: cyborg.ref,
                })
              }
            />
            {!!can_detonate && (
              <Button.Confirm
                icon="bomb"
                content="引爆"
                color="bad"
                onClick={() =>
                  act('killbot', {
                    ref: cyborg.ref,
                  })
                }
              />
            )}
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="状态">
            <Box
              color={
                cyborg.status ? 'bad' : cyborg.locked_down ? 'average' : 'good'
              }
            >
              {cyborg.status
                ? '无响应'
                : cyborg.locked_down
                  ? '被限制'
                  : '正常运转'}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Charge">
            <Box
              color={
                cyborg.charge <= 30
                  ? 'bad'
                  : cyborg.charge <= 70
                    ? 'average'
                    : 'good'
              }
            >
              {typeof cyborg.charge === 'number'
                ? cyborg.charge + '%'
                : '未找到'}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="模式">{cyborg.module}</LabeledList.Item>
          <LabeledList.Item label="上级AI">
            <Box color={cyborg.synchronization ? 'default' : 'average'}>
              {cyborg.synchronization || '无'}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};

const Drones = (props) => {
  const { drones } = props;
  const { act } = useBackend();

  if (!drones.length) {
    return <NoticeBox>在访问范围内未检测到无人机</NoticeBox>;
  }

  return drones.map((drone) => {
    return (
      <Section
        key={drone.ref}
        title={drone.name}
        buttons={
          <Button.Confirm
            icon="bomb"
            content="引爆"
            color="bad"
            onClick={() =>
              act('killdrone', {
                ref: drone.ref,
              })
            }
          />
        }
      >
        <LabeledList>
          <LabeledList.Item label="状态">
            <Box color={drone.status ? 'bad' : 'good'}>
              {drone.status ? '无响应' : '正常运转'}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};
