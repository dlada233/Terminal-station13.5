import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const RemoteRobotControl = (props) => {
  return (
    <Window title="远程机器人控制" width={500} height={500}>
      <Window.Content scrollable>
        <RemoteRobotControlContent />
      </Window.Content>
    </Window>
  );
};

export const RemoteRobotControlContent = (props) => {
  const { act, data } = useBackend();
  const { robots = [] } = data;
  if (!robots.length) {
    return (
      <Section>
        <NoticeBox textAlign="center">未检测到机器人</NoticeBox>
      </Section>
    );
  }
  return robots.map((robot) => {
    return (
      <Section
        key={robot.ref}
        title={robot.name + ' (' + robot.model + ')'}
        buttons={
          <>
            <Button
              icon="tools"
              content="访问界面"
              onClick={() =>
                act('interface', {
                  ref: robot.ref,
                })
              }
            />
            <Button
              icon="phone-alt"
              content="呼叫"
              onClick={() =>
                act('callbot', {
                  ref: robot.ref,
                })
              }
            />
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="状态">
            <Box
              inline
              color={
                decodeHtmlEntities(robot.mode) === '不活动'
                  ? 'bad'
                  : decodeHtmlEntities(robot.mode) === '待命'
                    ? 'average'
                    : 'good'
              }
            >
              {decodeHtmlEntities(robot.mode)}
            </Box>{' '}
            {(robot.hacked && (
              <Box inline color="bad">
                (被黑入)
              </Box>
            )) ||
              ''}
          </LabeledList.Item>
          <LabeledList.Item label="位置">{robot.location}</LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};
