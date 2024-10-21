import { useBackend } from '../../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../../components';

export const PortableBasicInfo = (props) => {
  const { act, data } = useBackend();
  const {
    connected,
    holding,
    on,
    pressure,
    hasHypernobCrystal,
    reactionSuppressionEnabled,
  } = data;
  return (
    <>
      <Section
        title="状态"
        buttons={
          <Button
            icon={on ? 'power-off' : 'times'}
            content={on ? '开启' : '关闭'}
            selected={on}
            onClick={() => act('power')}
          />
        }
      >
        <LabeledList>
          <LabeledList.Item label="气压">
            <AnimatedNumber value={pressure} />
            {' kPa'}
          </LabeledList.Item>
          <LabeledList.Item
            label="输气口"
            color={connected ? 'good' : 'average'}
          >
            {connected ? '已连接' : '未连接'}
          </LabeledList.Item>
          {!!hasHypernobCrystal && (
            <LabeledList.Item label="反应抑制">
              <Button
                icon={data.reactionSuppressionEnabled ? 'snowflake' : 'times'}
                content={data.reactionSuppressionEnabled ? '开启' : '关闭'}
                selected={data.reactionSuppressionEnabled}
                onClick={() => act('reaction_suppression')}
              />
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section
        title="气罐"
        minHeight="82px"
        buttons={
          <Button
            icon="eject"
            content="取出"
            disabled={!holding}
            onClick={() => act('eject')}
          />
        }
      >
        {holding ? (
          <LabeledList>
            <LabeledList.Item label="标签">{holding.name}</LabeledList.Item>
            <LabeledList.Item label="气压">
              <AnimatedNumber value={holding.pressure} />
              {' kPa'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="average">No holding tank</Box>
        )}
      </Section>
    </>
  );
};
