import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const RadioactiveMicrolaser = (props) => {
  const { act, data } = useBackend();
  const {
    irradiate,
    stealth,
    scanmode,
    intensity,
    wavelength,
    on_cooldown,
    cooldown,
  } = data;
  return (
    <Window title="放射性微型激光器" width={320} height={335} theme="syndicate">
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="激光状态">
              <Box color={on_cooldown ? 'average' : 'good'}>
                {on_cooldown ? '充能中' : '就绪'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="扫描仪控制">
          <LabeledList>
            <LabeledList.Item label="辐照">
              <Button
                icon={irradiate ? 'power-off' : 'times'}
                content={irradiate ? '开' : '关'}
                selected={irradiate}
                onClick={() => act('irradiate')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="隐秘模式">
              <Button
                icon={stealth ? 'eye-slash' : 'eye'}
                content={stealth ? '开' : '关'}
                disabled={!irradiate}
                selected={stealth}
                onClick={() => act('stealth')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="扫描模式">
              <Button
                icon={scanmode ? 'mortar-pestle' : 'heartbeat'}
                content={scanmode ? '扫描试剂' : '扫描健康'}
                disabled={irradiate && stealth}
                onClick={() => act('scanmode')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="激光设置">
          <LabeledList>
            <LabeledList.Item label="辐射强度">
              <Button
                icon="fast-backward"
                onClick={() => act('radintensity', { adjust: -5 })}
              />
              <Button
                icon="backward"
                onClick={() => act('radintensity', { adjust: -1 })}
              />{' '}
              <NumberInput
                value={Math.round(intensity)}
                width="40px"
                minValue={1}
                maxValue={20}
                step={1}
                onChange={(value) => {
                  return act('radintensity', {
                    target: value,
                  });
                }}
              />{' '}
              <Button
                icon="forward"
                onClick={() => act('radintensity', { adjust: 1 })}
              />
              <Button
                icon="fast-forward"
                onClick={() => act('radintensity', { adjust: 5 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="辐射波长">
              <Button
                icon="fast-backward"
                onClick={() => act('radwavelength', { adjust: -5 })}
              />
              <Button
                icon="backward"
                onClick={() => act('radwavelength', { adjust: -1 })}
              />{' '}
              <NumberInput
                value={Math.round(wavelength)}
                width="40px"
                minValue={0}
                maxValue={120}
                step={1}
                onChange={(value) => {
                  return act('radwavelength', {
                    target: value,
                  });
                }}
              />{' '}
              <Button
                icon="forward"
                onClick={() => act('radwavelength', { adjust: 1 })}
              />
              <Button
                icon="fast-forward"
                onClick={() => act('radwavelength', { adjust: 5 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="激光冷却">
              <Box inline bold>
                {cooldown}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
