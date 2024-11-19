import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const StackingConsole = (props) => {
  const { act, data } = useBackend();
  const { machine } = data;
  return (
    <Window width={320} height={340}>
      <Window.Content scrollable>
        {!machine ? (
          <NoticeBox>未连接到堆垛机</NoticeBox>
        ) : (
          <StackingConsoleContent />
        )}
      </Window.Content>
    </Window>
  );
};

export const StackingConsoleContent = (props) => {
  const { act, data } = useBackend();
  const {
    input_direction,
    output_direction,
    stacking_amount,
    contents = [],
  } = data;
  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="堆垛数量">
            {stacking_amount || '未知'}
          </LabeledList.Item>
          <LabeledList.Item
            label="输入"
            buttons={
              <Button
                icon="rotate"
                content="转向"
                onClick={() =>
                  act('rotate', {
                    input: 1,
                  })
                }
              />
            }
          >
            <Box style={{ textTransform: 'capitalize' }}>{input_direction}</Box>
          </LabeledList.Item>
          <LabeledList.Item
            label="输出"
            buttons={
              <Button
                icon="rotate"
                content="转向"
                onClick={() =>
                  act('rotate', {
                    input: 0,
                  })
                }
              />
            }
          >
            <Box style={{ textTransform: 'capitalize' }}>
              {output_direction}
            </Box>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="存储材料">
        {!contents.length ? (
          <NoticeBox>无存储材料</NoticeBox>
        ) : (
          <LabeledList>
            {contents.map((sheet) => (
              <LabeledList.Item
                key={sheet.type}
                label={sheet.name}
                buttons={
                  <Button
                    icon="eject"
                    content="放出"
                    onClick={() =>
                      act('release', {
                        type: sheet.type,
                      })
                    }
                  />
                }
              >
                {sheet.amount || '未知'}
              </LabeledList.Item>
            ))}
          </LabeledList>
        )}
      </Section>
    </>
  );
};
