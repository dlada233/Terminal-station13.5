import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Teleporter = (props) => {
  const { act, data } = useBackend();
  const {
    calibrated,
    calibrating,
    power_station,
    regime_set,
    teleporter_hub,
    target,
  } = data;
  return (
    <Window width={360} height={130}>
      <Window.Content>
        <Section>
          {(!power_station && (
            <Box color="bad" textAlign="center">
              未连接到电源站.
            </Box>
          )) ||
            (!teleporter_hub && (
              <Box color="bad" textAlign="center">
                未连接到hub.
              </Box>
            )) || (
              <LabeledList>
                <LabeledList.Item label="状态">
                  <Button
                    content={regime_set}
                    onClick={() => act('regimeset')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="目标">
                  <Button
                    icon="edit"
                    content={target}
                    onClick={() => act('settarget')}
                  />
                </LabeledList.Item>
                <LabeledList.Item
                  label="标定"
                  buttons={
                    <Button
                      icon="tools"
                      content="标定"
                      onClick={() => act('calibrate')}
                    />
                  }
                >
                  {(calibrating && <Box color="average">进行中</Box>) ||
                    (calibrated && <Box color="good">最优</Box>) || (
                      <Box color="bad">非最优</Box>
                    )}
                </LabeledList.Item>
              </LabeledList>
            )}
        </Section>
      </Window.Content>
    </Window>
  );
};
