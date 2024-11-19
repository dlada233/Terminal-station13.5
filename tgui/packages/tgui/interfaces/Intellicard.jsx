import { useBackend } from '../backend';
import {
  BlockQuote,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Intellicard = (props) => {
  const { act, data } = useBackend();
  const {
    name,
    isDead,
    isBraindead,
    health,
    wireless,
    radio,
    wiping,
    laws = [],
  } = data;
  const offline = isDead || isBraindead;
  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        <Section
          title={name || '清空卡'}
          buttons={
            !!name && (
              <Button
                icon="trash"
                content={wiping ? '停止擦去' : '擦去'}
                disabled={isDead}
                onClick={() => act('wipe')}
              />
            )
          }
        >
          {!!name && (
            <LabeledList>
              <LabeledList.Item label="状态" color={offline ? 'bad' : 'good'}>
                {offline ? '离线' : '运作'}
              </LabeledList.Item>
              <LabeledList.Item label="软件完整性">
                <ProgressBar
                  value={health}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    good: [70, Infinity],
                    average: [50, 70],
                    bad: [-Infinity, 50],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="设置">
                <Button
                  icon="signal"
                  content="无线活动"
                  selected={wireless}
                  onClick={() => act('wireless')}
                />
                <Button
                  icon="microphone"
                  content="子空间无线电"
                  selected={radio}
                  onClick={() => act('radio')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="法律">
                {laws.map((law) => (
                  <BlockQuote key={law}>{law}</BlockQuote>
                ))}
              </LabeledList.Item>
            </LabeledList>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
