import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const DisposalUnit = (props) => {
  const { act, data } = useBackend();
  let stateColor;
  let stateText;
  if (data.full_pressure) {
    stateColor = 'good';
    stateText = '就绪';
  } else if (data.panel_open) {
    stateColor = 'bad';
    stateText = '电源关闭';
  } else if (data.pressure_charging) {
    stateColor = 'average';
    stateText = '加压中';
  } else {
    stateColor = 'bad';
    stateText = '关闭';
  }
  return (
    <Window width={300} height={180}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="状态" color={stateColor}>
              {stateText}
            </LabeledList.Item>
            <LabeledList.Item label="压力">
              <ProgressBar value={data.per} color="good" />
            </LabeledList.Item>
            <LabeledList.Item label="处理">
              <Button
                icon={data.flush ? 'toggle-on' : 'toggle-off'}
                disabled={data.isai || data.panel_open}
                content={data.flush ? '解除' : '接合'}
                onClick={() => act(data.flush ? 'handle-0' : 'handle-1')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="取出">
              <Button
                icon="sign-out-alt"
                disabled={data.isai}
                content="取出内容物"
                onClick={() => act('eject')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="电源">
              <Button
                icon="power-off"
                disabled={data.panel_open}
                selected={data.pressure_charging}
                onClick={() =>
                  act(data.pressure_charging ? 'pump-0' : 'pump-1')
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
