import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const TransferValve = (props) => {
  const { act, data } = useBackend();
  const { tank_one, tank_two, attached_device, valve } = data;
  return (
    <Window width={310} height={300}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="阀门状态">
              <Button
                icon={valve ? 'unlock' : 'lock'}
                content={valve ? '打开' : '关闭'}
                disabled={!tank_one || !tank_two}
                onClick={() => act('toggle')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="阀门附件"
          buttons={
            <Button
              content="配置"
              icon={'cog'}
              disabled={!attached_device}
              onClick={() => act('device')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="附件">
              {attached_device ? (
                <Button
                  icon={'eject'}
                  content={attached_device}
                  disabled={!attached_device}
                  onClick={() => act('remove_device')}
                />
              ) : (
                <Box color="average">未组装</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="附件一">
          <LabeledList>
            <LabeledList.Item label="附件">
              {tank_one ? (
                <Button
                  icon={'eject'}
                  content={tank_one}
                  disabled={!tank_one}
                  onClick={() => act('tankone')}
                />
              ) : (
                <Box color="average">无气瓶</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="附件二">
          <LabeledList>
            <LabeledList.Item label="附件">
              {tank_two ? (
                <Button
                  icon={'eject'}
                  content={tank_two}
                  disabled={!tank_two}
                  onClick={() => act('tanktwo')}
                />
              ) : (
                <Box color="average">无气瓶</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
