import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
  TextArea,
} from '../../components';
import { NtosWindow } from '../../layouts';
import { ChatScreen } from './ChatScreen';
import { NtChat, NtMessenger, NtPicture } from './types';

type NtosMessengerData = {
  can_spam: BooleanLike;
  is_silicon: BooleanLike;
  owner?: NtMessenger;
  saved_chats: Record<string, NtChat>;
  messengers: Record<string, NtMessenger>;
  sort_by_job: BooleanLike;
  alert_silenced: BooleanLike;
  alert_able: BooleanLike;
  sending_and_receiving: BooleanLike;
  open_chat: string;
  stored_photos?: NtPicture[];
  selected_photo_path?: string;
  on_spam_cooldown: BooleanLike;
  virus_attach: BooleanLike;
  sending_virus: BooleanLike;
};

export const NtosMessenger = (props) => {
  const { data } = useBackend<NtosMessengerData>();
  const {
    is_silicon,
    saved_chats,
    stored_photos,
    selected_photo_path,
    open_chat,
    messengers,
    sending_virus,
  } = data;

  let content: JSX.Element;
  if (open_chat !== null) {
    const openChat = saved_chats[open_chat];
    const temporaryRecipient = messengers[open_chat];

    if (!openChat && !temporaryRecipient) {
      content = <ContactsScreen />;
    } else {
      content = (
        <ChatScreen
          storedPhotos={stored_photos}
          selectedPhoto={selected_photo_path}
          isSilicon={is_silicon}
          sendingVirus={sending_virus}
          canReply={openChat ? openChat.can_reply : !!temporaryRecipient}
          messages={openChat ? openChat.messages : []}
          recipient={openChat ? openChat.recipient : temporaryRecipient}
          unreads={openChat ? openChat.unread_messages : 0}
          chatRef={openChat?.ref}
        />
      );
    }
  } else {
    content = <ContactsScreen />;
  }

  return (
    <NtosWindow width={600} height={850}>
      <NtosWindow.Content>{content}</NtosWindow.Content>
    </NtosWindow>
  );
};

const ContactsScreen = (props: any) => {
  const { act, data } = useBackend<NtosMessengerData>();
  const {
    owner,
    alert_silenced,
    alert_able,
    sending_and_receiving,
    saved_chats,
    messengers,
    sort_by_job,
    can_spam,
    is_silicon,
    virus_attach,
    sending_virus,
  } = data;

  const [searchUser, setSearchUser] = useState('');

  const sortByUnreads = (array: NtChat[]) =>
    sortBy(array, (chat) => chat.unread_messages);

  const searchChatByName = createSearch(
    searchUser,
    (chat: NtChat) => chat.recipient.name + chat.recipient.job,
  );
  const searchMessengerByName = createSearch(
    searchUser,
    (messenger: NtMessenger) => messenger.name + messenger.job,
  );

  const chatToButton = (chat: NtChat) => {
    return (
      <ChatButton
        key={chat.ref}
        name={`${chat.recipient.name} (${chat.recipient.job})`}
        chatRef={chat.ref}
        unreads={chat.unread_messages}
      />
    );
  };

  const messengerToButton = (messenger: NtMessenger) => {
    return (
      <ChatButton
        key={messenger.ref}
        name={`${messenger.name} (${messenger.job})`}
        chatRef={messenger.ref!}
        unreads={0}
      />
    );
  };

  const openChatsArray = sortByUnreads(Object.values(saved_chats)).filter(
    searchChatByName,
  );

  const filteredChatButtons = openChatsArray
    .filter((c) => c.visible)
    .map(chatToButton);

  const messengerButtons = Object.entries(messengers)
    .filter(
      ([ref, messenger]) =>
        openChatsArray.every((chat) => chat.recipient.ref !== ref) &&
        searchMessengerByName(messenger),
    )
    .map(([_, messenger]) => messenger)
    .map(messengerToButton)
    .concat(openChatsArray.filter((chat) => !chat.visible).map(chatToButton));

  const noId = !owner && !is_silicon;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Stack vertical textAlign="center">
            <Box bold>
              <Icon name="address-card" mr={1} />
              太空短信 V6.5.3
            </Box>
            <Box italic opacity={0.3} mt={1}>
              从2467年开始为您服务至今
            </Box>
            <Divider hidden />
            <Box>
              <Button
                icon="bell"
                disabled={!alert_able}
                content={
                  alert_able && !alert_silenced ? '铃声: 开' : '铃声: 关'
                }
                onClick={() => act('PDA_toggleAlerts')}
              />
              <Button
                icon="address-card"
                content={
                  sending_and_receiving ? '发送/接收: 开' : '发送/接收: 关'
                }
                onClick={() => act('PDA_toggleSendingAndReceiving')}
              />
              <Button
                icon="bell"
                content="设置铃声"
                onClick={() => act('PDA_ringSet')}
              />
              <Button
                icon="sort"
                content={`排序方式: ${sort_by_job ? '职位' : '姓名'}`}
                onClick={() => act('PDA_changeSortStyle')}
              />
              {!!virus_attach && (
                <Button
                  icon="bug"
                  color="bad"
                  content={`附加病毒: ${sending_virus ? '是' : '否'}`}
                  onClick={() => act('PDA_toggleVirus')}
                />
              )}
            </Box>
          </Stack>
          <Divider hidden />
          <Stack justify="space-between">
            <Box m={0.5}>
              <Icon name="magnifying-glass" mr={1} />
              搜索用户
            </Box>
            <Input
              width="220px"
              placeholder="姓名或职业名搜索..."
              value={searchUser}
              onInput={(_, value) => setSearchUser(value)}
            />
          </Stack>
        </Section>
      </Stack.Item>
      {filteredChatButtons.length > 0 && (
        <Stack.Item grow={1}>
          <Stack vertical fill>
            <Section>
              <Icon name="comments" mr={1} />
              过往消息
            </Section>
            <Section fill scrollable>
              <Stack vertical>{filteredChatButtons}</Stack>
            </Section>
          </Stack>
        </Stack.Item>
      )}
      <Stack.Item grow={2}>
        <Stack vertical fill>
          <Section>
            <Stack>
              <Box m={0.5}>
                <Icon name="address-card" mr={1} />
                已发现用户
              </Box>
            </Stack>
          </Section>
          <Section fill scrollable>
            <Stack vertical pb={1} fill>
              {messengerButtons.length === 0 && (
                <Stack align="center" justify="center" fill pl={4}>
                  <Icon color="gray" name="user-slash" size={2} />
                  <Stack.Item fontSize={1.5} ml={3}>
                    未找到用户.
                  </Stack.Item>
                </Stack>
              )}
              {messengerButtons}
            </Stack>
          </Section>
        </Stack>
      </Stack.Item>
      {!!can_spam && (
        <Stack.Item>
          <SendToAllSection />
        </Stack.Item>
      )}
      {noId && <NoIDDimmer />}
    </Stack>
  );
};

type ChatButtonProps = {
  name: string;
  unreads: number;
  chatRef: string;
};

const ChatButton = (props: ChatButtonProps) => {
  const { act } = useBackend();
  const unreadMessages = props.unreads;
  const hasUnreads = unreadMessages > 0;
  return (
    <Button
      icon={hasUnreads && 'envelope'}
      key={props.chatRef}
      fluid
      onClick={() => {
        act('PDA_viewMessages', { ref: props.chatRef });
      }}
    >
      {hasUnreads &&
        `[${unreadMessages <= 9 ? unreadMessages : '9+'} 未读消息${
          unreadMessages !== 1 ? 's' : ''
        }]`}{' '}
      {props.name}
    </Button>
  );
};

const SendToAllSection = (props) => {
  const { data, act } = useBackend<NtosMessengerData>();
  const { on_spam_cooldown } = data;

  const [message, setmessage] = useState('');

  return (
    <>
      <Section>
        <Stack justify="space-between">
          <Stack.Item align="center">
            <Icon name="satellite-dish" mr={1} ml={0.5} />
            发送至所有人
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="arrow-right"
              disabled={on_spam_cooldown || message === ''}
              tooltip={on_spam_cooldown && '发送更多消息前请等待!'}
              tooltipPosition="auto-start"
              onClick={() => {
                act('PDA_sendEveryone', { message: message });
                setmessage('');
              }}
            >
              发送
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
      <Section>
        <TextArea
          height={6}
          value={message}
          placeholder="发送消息至所有人..."
          onChange={(event, value: string) => setmessage(value)}
        />
      </Section>
    </>
  );
};

const NoIDDimmer = () => {
  return (
    <Dimmer>
      <Stack align="baseline" vertical>
        <Stack ml={-2}>
          <Icon color="red" name="address-card" size={10} />
        </Stack>
        <Stack.Item fontSize="18px">请插入ID张卡以继续.</Stack.Item>
      </Stack>
    </Dimmer>
  );
};
