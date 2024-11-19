// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Divider,
  Flex,
  Input,
  LabeledList,
  Section,
} from '../components';
import { Window } from '../layouts';

export const NifSoulPoem = (props) => {
  const { act, data } = useBackend();
  const {
    name_to_send,
    text_to_send,
    messages = [],
    receiving_data,
    transmitting_data,
    theme,
  } = data;
  return (
    <Window width={500} height={700} theme={theme}>
      <Window.Content scrollable>
        <Section title="消息">
          {messages.map((message) => (
            <Flex.Item key={message.key}>
              <Box textAlign="center" fontSize="14px">
                <b>{message.sender_name} </b>
                <Button
                  icon="trash"
                  tooltip={'删除这条消息'}
                  onClick={() =>
                    act('remove_message', { message_to_remove: message })
                  }
                />
              </Box>
              <Divider />
              <Box>{message.message}</Box>
              <br />
              <BlockQuote>接收时间: {message.timestamp}</BlockQuote>
            </Flex.Item>
          ))}
        </Section>
        <Section title="设置">
          <LabeledList>
            <LabeledList.Item label={'显示姓名'}>
              <Input
                value={name_to_send}
                onInput={(e, value) => act('change_name', { new_name: value })}
                width="100%"
              />
            </LabeledList.Item>
            <LabeledList.Item label={'消息'}>
              <Input
                value={text_to_send}
                onInput={(e, value) =>
                  act('change_message', { new_message: value })
                }
                width="100%"
              />
            </LabeledList.Item>
            <LabeledList.Item label="切换传输">
              <Button
                fluid
                onClick={() => act('toggle_transmitting', {})}
                color={transmitting_data ? 'green' : 'red'}
              >
                {transmitting_data ? 'True' : 'False'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="切花接收">
              <Button
                fluid
                onClick={() => act('toggle_receiving', {})}
                color={receiving_data ? 'green' : 'red'}
              >
                {receiving_data ? 'True' : 'False'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
