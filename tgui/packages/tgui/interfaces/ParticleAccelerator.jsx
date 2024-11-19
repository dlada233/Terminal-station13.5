// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const ParticleAccelerator = (props) => {
  const { act, data } = useBackend();
  const { assembled, power, strength } = data;
  return (
    <Window width={350} height={185}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="状态"
              buttons={
                <Button
                  icon={'sync'}
                  content={'运行扫描'}
                  onClick={() => act('scan')}
                />
              }
            >
              <Box color={assembled ? 'good' : 'bad'}>
                {assembled ? '就绪 - 所有部件均已到位' : '所有部件未全部检测到'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="粒子加速器控制面板">
          <LabeledList>
            <LabeledList.Item label="电源">
              <Button
                icon={power ? 'power-off' : 'times'}
                content={power ? '开' : '关'}
                selected={power}
                disabled={!assembled}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="粒子强度">
              <Button
                icon="backward"
                disabled={!assembled}
                onClick={() => act('remove_strength')}
              />{' '}
              {String(strength).padStart(1, '0')}{' '}
              <Button
                icon="forward"
                disabled={!assembled}
                onClick={() => act('add_strength')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
