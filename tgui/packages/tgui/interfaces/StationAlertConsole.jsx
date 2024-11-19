import { sortBy } from 'common/collections';

import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const StationAlertConsole = (props) => {
  const { data } = useBackend();
  const { cameraView } = data;
  return (
    <Window width={cameraView ? 390 : 345} height={587}>
      <Window.Content scrollable>
        <StationAlertConsoleContent />
      </Window.Content>
    </Window>
  );
};

export const StationAlertConsoleContent = (props) => {
  const { act, data } = useBackend();
  const { cameraView } = data;

  const sortingKey = {
    Fire: 0,
    Atmosphere: 1,
    Power: 2,
    Burglar: 3,
    Motion: 4,
    Camera: 5,
  };

  const sortedAlarms = sortBy(
    data.alarms || [],
    (alarm) => sortingKey[alarm.name],
  );

  return (
    <>
      {sortedAlarms.map((category) => (
        <Section key={category.name} title={category.name + '警报'}>
          <ul>
            {category.alerts.length === 0 && (
              <li className="color-good">系统正常</li>
            )}
            {category.alerts.map((alert) => (
              <Stack key={alert.name} height="30px" align="baseline">
                <Stack.Item grow>
                  <li className="color-average">
                    {alert.name}{' '}
                    {!!cameraView && alert.sources > 1
                      ? ' (' + alert.sources + '来源)'
                      : ''}
                  </li>
                </Stack.Item>
                {!!cameraView && (
                  <Stack.Item>
                    <Button
                      textAlign="center"
                      width="100px"
                      icon={alert.cameras ? 'video' : ''}
                      disabled={!alert.cameras}
                      content={
                        alert.cameras === 1
                          ? alert.cameras + '摄像头'
                          : alert.cameras > 1
                            ? alert.cameras + '摄像头'
                            : '无摄像头'
                      }
                      onClick={() =>
                        act('select_camera', {
                          alert: alert.ref,
                        })
                      }
                    />
                  </Stack.Item>
                )}
              </Stack>
            ))}
          </ul>
        </Section>
      ))}
    </>
  );
};
