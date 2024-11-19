import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

export const EngravedMessage = (props) => {
  const { act, data } = useBackend();
  const {
    admin_mode,
    creator_key,
    creator_name,
    has_liked,
    has_disliked,
    hidden_message,
    is_creator,
    num_likes,
    num_dislikes,
    realdate,
  } = data;
  return (
    <Window width={600} height={300}>
      <Window.Content scrollable>
        <Section>
          <Box bold textAlign="center" fontSize="20px" mb={2}>
            {decodeHtmlEntities(hidden_message)}
          </Box>
          <Stack>
            <Stack.Item grow={1.05}>
              <Button
                fluid
                icon="arrow-up"
                content={' ' + num_likes}
                disabled={is_creator}
                selected={has_liked}
                textAlign="center"
                fontSize="16px"
                lineHeight="24px"
                onClick={() => act('like')}
              />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button
                fluid
                icon="circle"
                disabled={is_creator}
                selected={!has_disliked && !has_liked}
                textAlign="center"
                fontSize="16px"
                lineHeight="24px"
                onClick={() => act('neutral')}
              />
            </Stack.Item>
            <Stack.Item grow={1.05}>
              <Button
                fluid
                icon="arrow-down"
                content={' ' + num_dislikes}
                disabled={is_creator}
                selected={has_disliked}
                textAlign="center"
                fontSize="16px"
                lineHeight="24px"
                onClick={() => act('dislike')}
              />
            </Stack.Item>
          </Stack>
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="创建在">{realdate}</LabeledList.Item>
          </LabeledList>
        </Section>
        {!!admin_mode && (
          <Section
            title="管理员面板"
            buttons={
              <Button
                icon="times"
                content="删除"
                color="bad"
                onClick={() => act('delete')}
              />
            }
          >
            <LabeledList>
              <LabeledList.Item label="创建者Ckey">
                {creator_key}
              </LabeledList.Item>
              <LabeledList.Item label="创建者角色姓名">
                {creator_name}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
