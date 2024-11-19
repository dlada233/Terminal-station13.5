import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { clamp } from 'common/math';
import { vecLength, vecSubtract } from 'common/vector';

import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

const coordsToVec = (coords) => map(coords.split(', '), parseFloat);

export const Gps = (props) => {
  const { act, data } = useBackend();
  const { currentArea, currentCoords, globalmode, power, tag, updating } = data;
  const signals = flow([
    (signals) =>
      map(signals, (signal, index) => {
        // Calculate distance to the target. BYOND distance is capped to 127,
        // that's why we roll our own calculations here.
        const dist =
          signal.dist &&
          Math.round(
            vecLength(
              vecSubtract(
                coordsToVec(currentCoords),
                coordsToVec(signal.coords),
              ),
            ),
          );
        return { ...signal, dist, index };
      }),
    (signals) =>
      sortBy(
        signals,
        // Signals with distance metric go first
        (signal) => signal.dist === undefined,
        // Sort alphabetically
        (signal) => signal.entrytag,
      ),
  ])(data.signals || []);
  return (
    <Window title="全球定位系统" width={470} height={700}>
      <Window.Content scrollable>
        <Section
          title="控制板"
          buttons={
            <Button
              icon="power-off"
              content={power ? '开' : '关'}
              selected={power}
              onClick={() => act('power')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="标签">
              <Button
                icon="pencil-alt"
                content={tag}
                onClick={() => act('rename')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="扫描模式">
              <Button
                icon={updating ? 'unlock' : 'lock'}
                content={updating ? '自动' : '手动'}
                color={!updating && 'bad'}
                onClick={() => act('updating')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="距离">
              <Button
                icon="sync"
                content={globalmode ? '最大' : '本地'}
                selected={!globalmode}
                onClick={() => act('globalmode')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {!!power && (
          <>
            <Section title="当前位置">
              <Box fontSize="18px">
                {currentArea} ({currentCoords})
              </Box>
            </Section>
            <Section title="探测到信号">
              <Table>
                <Table.Row bold>
                  <Table.Cell content="名称" />
                  <Table.Cell collapsing content="描述" />
                  <Table.Cell collapsing content="坐标" />
                </Table.Row>
                {signals.map((signal) => (
                  <Table.Row
                    key={signal.entrytag + signal.coords + signal.index}
                    className="candystripe"
                  >
                    <Table.Cell bold color="label">
                      {signal.entrytag}
                    </Table.Cell>
                    <Table.Cell
                      collapsing
                      opacity={
                        signal.dist !== undefined &&
                        clamp(1.2 / Math.log(Math.E + signal.dist / 20), 0.4, 1)
                      }
                    >
                      {signal.degrees !== undefined && (
                        <Icon
                          mr={1}
                          size={1.2}
                          name="arrow-up"
                          rotation={signal.degrees}
                        />
                      )}
                      {signal.dist !== undefined && signal.dist + 'm'}
                    </Table.Cell>
                    <Table.Cell collapsing>{signal.coords}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
