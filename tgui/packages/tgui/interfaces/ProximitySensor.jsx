import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const ProximitySensor = (props) => {
  const { act, data } = useBackend();
  const { minutes, seconds, timing, scanning, sensitivity } = data;
  return (
    <Window width={250} height={185}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="状态">
              <Button
                icon={scanning ? 'lock' : 'unlock'}
                content={scanning ? '激活' : '未激活'}
                selected={scanning}
                onClick={() => act('scanning')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="探测范围">
              <Button
                icon="backward"
                disabled={scanning}
                onClick={() => act('sense', { range: -1 })}
              />{' '}
              {String(sensitivity).padStart(1, '1')}{' '}
              <Button
                icon="forward"
                disabled={scanning}
                onClick={() => act('sense', { range: 1 })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="自动激活计时"
          buttons={
            <Button
              icon={'clock-o'}
              content={timing ? '停止' : '开始'}
              selected={timing}
              disabled={scanning}
              onClick={() => act('time')}
            />
          }
        >
          <Button
            icon="fast-backward"
            disabled={scanning || timing}
            onClick={() => act('input', { adjust: -30 })}
          />
          <Button
            icon="backward"
            disabled={scanning || timing}
            onClick={() => act('input', { adjust: -1 })}
          />{' '}
          {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}{' '}
          <Button
            icon="forward"
            disabled={scanning || timing}
            onClick={() => act('input', { adjust: 1 })}
          />
          <Button
            icon="fast-forward"
            disabled={scanning || timing}
            onClick={() => act('input', { adjust: 30 })}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
