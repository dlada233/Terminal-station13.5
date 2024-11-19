import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const ExosuitControlConsole = (props) => {
  const { act, data } = useBackend();
  const { mechs = [] } = data;
  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        {mechs.length === 0 && <NoticeBox>未检测到外骨骼</NoticeBox>}
        {mechs.map((mech) => (
          <Section
            key={mech.tracker_ref}
            title={mech.name}
            buttons={
              <>
                <Button
                  icon="envelope"
                  content="消息"
                  disabled={!mech.pilot}
                  onClick={() =>
                    act('send_message', {
                      tracker_ref: mech.tracker_ref,
                    })
                  }
                />
                <Button
                  icon="wifi"
                  content={mech.emp_recharging ? '充电中...' : 'EMP爆发'}
                  color="bad"
                  disabled={mech.emp_recharging}
                  onClick={() =>
                    act('shock', {
                      tracker_ref: mech.tracker_ref,
                    })
                  }
                />
              </>
            }
          >
            <LabeledList>
              <LabeledList.Item label="完整性">
                <Box
                  color={
                    (mech.integrity <= 30 && 'bad') ||
                    (mech.integrity <= 70 && 'average') ||
                    'good'
                  }
                >
                  {mech.integrity}%
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="充能">
                <Box
                  color={
                    (mech.charge <= 30 && 'bad') ||
                    (mech.charge <= 70 && 'average') ||
                    'good'
                  }
                >
                  {(typeof mech.charge === 'number' && mech.charge + '%') ||
                    '未找到'}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="气瓶">
                {(typeof mech.airtank === 'number' && (
                  <AnimatedNumber
                    value={mech.airtank}
                    format={(value) => toFixed(value, 2) + ' kPa'}
                  />
                )) ||
                  '未装备'}
              </LabeledList.Item>
              <LabeledList.Item label="驾驶员">
                {(mech.pilot.length > 0 &&
                  mech.pilot.map((pilot) => (
                    <Box key={pilot} inline>
                      {pilot}
                      {mech.pilot.length > 1 ? '|' : ''}
                    </Box>
                  ))) ||
                  '无'}
              </LabeledList.Item>
              <LabeledList.Item label="位置">
                {mech.location || '未知'}
              </LabeledList.Item>
              {mech.cargo_space >= 0 && (
                <LabeledList.Item label="使用货仓空间">
                  <Box
                    color={
                      (mech.cargo_space <= 30 && 'good') ||
                      (mech.cargo_space <= 70 && 'average') ||
                      'bad'
                    }
                  >
                    {mech.cargo_space}%
                  </Box>
                </LabeledList.Item>
              )}
            </LabeledList>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
