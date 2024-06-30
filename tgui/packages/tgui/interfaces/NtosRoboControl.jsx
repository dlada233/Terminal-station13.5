import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from '../components';
import { NtosWindow } from '../layouts';

const getMuleByRef = (mules, ref) => {
  return mules?.find((mule) => mule.mule_ref === ref);
};

export const NtosRoboControl = (props) => {
  const { act, data } = useBackend();
  const [tab_main, setTab_main] = useSharedState('tab_main', 1);
  const { bots, drones, id_owner, droneaccess, dronepingtypes } = data;

  return (
    <NtosWindow width={550} height={550}>
      <NtosWindow.Content scrollable>
        <Section title="Robot Control Console">
          <LabeledList>
            <LabeledList.Item label="ID 卡">{id_owner}</LabeledList.Item>
            <LabeledList.Item label="范围内的机器人">
              {data.botcount}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Stack.Item>
          <Tabs>
            <Tabs.Tab
              icon="robot"
              lineHeight="23px"
              selected={tab_main === 1}
              onClick={() => setTab_main(1)}
            >
              机器人
            </Tabs.Tab>
            <Tabs.Tab
              icon="hammer"
              lineHeight="23px"
              selected={tab_main === 2}
              onClick={() => setTab_main(2)}
            >
              无人机
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        {tab_main === 1 && (
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item label="范围内的无人机">
                  {data.botcount}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {bots?.map((robot) => (
              <RobotInfo key={robot.bot_ref} robot={robot} />
            ))}
          </Stack.Item>
        )}
        {tab_main === 2 && (
          <Stack.Item grow>
            <Section>
              <Button
                icon="address-card"
                tooltip="Grant/Remove Drone access to interact with machines and wires that would otherwise be deemed dangerous."
                color={droneaccess ? 'good' : 'bad'}
                onClick={() => act('changedroneaccess')}
              >
                {droneaccess ? 'Grant Drone Access' : 'Revoke Drone Access'}
              </Button>
              <Box my={1}>Drone Pings</Box>
              {dronepingtypes.map((ping_type) => (
                <Button
                  key={ping_type}
                  icon="bullhorn"
                  tooltip="Issue a drone ping."
                  onClick={() => act('ping_drones', { ping_type })}
                >
                  {ping_type}
                </Button>
              ))}
            </Section>
            {drones?.map((drone) => (
              <DroneInfo key={drone.drone_ref} drone={drone} />
            ))}
          </Stack.Item>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const RobotInfo = (props) => {
  const { robot } = props;
  const { act, data } = useBackend();
  const mules = data.mules || [];
  // Get a mule object
  const mule = !!robot.mule_check && getMuleByRef(mules, robot.bot_ref);
  // Color based on type of a robot
  const color =
    robot.mule_check === 1 ? 'rgba(110, 75, 14, 1)' : 'rgba(74, 59, 140, 1)';
  return (
    <Section
      title={robot.name}
      style={{
        border: `4px solid ${color}`,
      }}
      buttons={
        mule && (
          <>
            <Button
              icon="play"
              tooltip="前往目的地"
              onClick={() =>
                act('go', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="pause"
              tooltip="停止移动"
              onClick={() =>
                act('stop', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="home"
              tooltip="返回停泊处"
              tooltipPosition="bottom-start"
              onClick={() =>
                act('home', {
                  robot: mule.mule_ref,
                })
              }
            />
          </>
        )
      }
    >
      <Stack>
        <Stack.Item grow={1} basis={0}>
          <LabeledList>
            <LabeledList.Item label="型号">{robot.model}</LabeledList.Item>
            <LabeledList.Item label="位置">{robot.locat}</LabeledList.Item>
            <LabeledList.Item label="状态">{robot.mode}</LabeledList.Item>
            {mule && (
              <>
                <LabeledList.Item label="Bot ID">{mule.id}</LabeledList.Item>
                <LabeledList.Item label="搭载货物">
                  {mule.load || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="停泊处">{mule.home}</LabeledList.Item>
                <LabeledList.Item label="目的地">
                  {mule.dest || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="电力">
                  <ProgressBar
                    value={mule.power}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                      good: [60, Infinity],
                      average: [20, 60],
                      bad: [-Infinity, 20],
                    }}
                  />
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Stack.Item>
        <Stack.Item width="150px">
          {mule && (
            <>
              <Button
                fluid
                content="设置目的地"
                onClick={() =>
                  act('destination', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="设置ID"
                onClick={() =>
                  act('setid', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="设置停泊处"
                onClick={() =>
                  act('sethome', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="卸下货物"
                onClick={() =>
                  act('unload', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="自动返航"
                checked={mule.autoReturn}
                onClick={() =>
                  act('autoret', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="自动取货"
                checked={mule.autoPickup}
                onClick={() =>
                  act('autopick', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="送达报告"
                checked={mule.reportDelivery}
                onClick={() =>
                  act('report', {
                    robot: mule.mule_ref,
                  })
                }
              />
            </>
          )}
          {!mule && (
            <>
              <Button
                fluid
                content="停止巡航"
                onClick={() =>
                  act('patroloff', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="开始巡航"
                onClick={() =>
                  act('patrolon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="召唤"
                onClick={() =>
                  act('summon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="弹出个人人工智能"
                onClick={() =>
                  act('ejectpai', {
                    robot: robot.bot_ref,
                  })
                }
              />
            </>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const DroneInfo = (props) => {
  const { drone } = props;
  const { act, data } = useBackend();
  const color = 'rgba(74, 59, 140, 1)';

  return (
    <Section
      title={drone.name}
      style={{
        border: `4px solid ${color}`,
      }}
    >
      <Stack>
        <Stack.Item grow={1} basis={0}>
          <LabeledList>
            <LabeledList.Item label="状态">
              <Box color={drone.status ? '受损' : '良好'}>
                {drone.status ? '无响应' : '正常'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
