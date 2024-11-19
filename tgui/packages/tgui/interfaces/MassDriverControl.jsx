import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const MassDriverControl = (props) => {
  const { act, data } = useBackend();
  const { connected, minutes, seconds, timing, power, poddoor } = data;
  return (
    <Window width={300} height={connected ? 215 : 107}>
      <Window.Content>
        {!!connected && (
          <Section
            title="自动发射"
            buttons={
              <Button
                icon={'clock-o'}
                content={timing ? '停止' : '开始'}
                selected={timing}
                onClick={() => act('time')}
              />
            }
          >
            <Button
              icon="fast-backward"
              disabled={timing}
              onClick={() => act('input', { adjust: -30 })}
            />
            <Button
              icon="backward"
              disabled={timing}
              onClick={() => act('input', { adjust: -1 })}
            />{' '}
            {String(minutes).padStart(2, '0')}:
            {String(seconds).padStart(2, '0')}{' '}
            <Button
              icon="forward"
              disabled={timing}
              onClick={() => act('input', { adjust: 1 })}
            />
            <Button
              icon="fast-forward"
              disabled={timing}
              onClick={() => act('input', { adjust: 30 })}
            />
          </Section>
        )}
        <Section
          title="控制"
          buttons={
            <Button
              icon={'toggle-on'}
              content="开关外门"
              disabled={timing || !poddoor}
              onClick={() => act('door')}
            />
          }
        >
          {(!!connected && (
            <>
              <LabeledList>
                <LabeledList.Item
                  label="电力等级"
                  buttons={
                    <Button
                      icon={'bomb'}
                      content="发射测试"
                      disabled={timing}
                      onClick={() => act('driver_test')}
                    />
                  }
                >
                  <NumberInput
                    value={power}
                    width="40px"
                    step={1}
                    minValue={0.25}
                    maxValue={16}
                    onChange={(value) => {
                      return act('set_power', {
                        power: value,
                      });
                    }}
                  />
                </LabeledList.Item>
              </LabeledList>
              <Button
                fluid
                content="发射"
                disabled={timing}
                mt={1.5}
                icon="arrow-up"
                textAlign="center"
                onClick={() => act('launch')}
              />
            </>
          )) || <Box color="bad">未连接到质量发射器</Box>}
        </Section>
      </Window.Content>
    </Window>
  );
};
