import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, NoticeBox, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { SecurityRecordTabs } from './RecordTabs';
import { SecurityRecordView } from './RecordView';
import { SecurityRecordsData } from './types';

export const SecurityRecords = (props) => {
  const { data } = useBackend<SecurityRecordsData>();
  const { authenticated } = data;

  return (
    <Window title="安保档案" width={750} height={550}>
      <Window.Content>
        <Stack fill>{!authenticated ? <RestrictedView /> : <AuthView />}</Stack>
      </Window.Content>
    </Window>
  );
};

/** Unauthorized view. User can only log in with ID */
const RestrictedView = (props) => {
  const { act } = useBackend<SecurityRecordsData>();

  return (
    <Stack.Item grow>
      <Stack fill vertical>
        <Stack.Item grow />
        <Stack.Item align="center" grow={2}>
          <Icon color="average" name="exclamation-triangle" size={15} />
        </Stack.Item>
        <Stack.Item align="center" grow>
          <Box color="red" fontSize="18px" bold mt={5}>
            纳米传讯 安保HUB
          </Box>
        </Stack.Item>
        <Stack.Item>
          <NoticeBox align="right">
            你尚未登录.
            <Button ml={2} icon="lock-open" onClick={() => act('login')}>
              登录
            </Button>
          </NoticeBox>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

/** Logged in view */
const AuthView = (props) => {
  const { act } = useBackend<SecurityRecordsData>();

  return (
    <>
      <Stack.Item grow>
        <SecurityRecordTabs />
      </Stack.Item>
      <Stack.Item grow={2}>
        <Stack fill vertical>
          <Stack.Item grow>
            <SecurityRecordView />
          </Stack.Item>
          <Stack.Item>
            <NoticeBox align="right" info>
              确保你的工作空间安全.
              <Button
                align="right"
                icon="lock"
                color="good"
                ml={2}
                onClick={() => act('logout')}
              >
                注销
              </Button>
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
};
