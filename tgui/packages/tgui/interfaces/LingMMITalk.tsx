import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, ByondUi, Stack, TextArea } from '../components';
import { Window } from '../layouts';

type Data = {
  mmi_view: string;
};

export const LingMMITalk = (props) => {
  const { data, act } = useBackend<Data>();
  const [mmiMessage, setmmiMessage] = useState('');

  return (
    <Window title="诱饵脑MMI视图" height={360} width={360}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item align="center">
            <ByondUi
              width="240px"
              height="240px"
              params={{
                id: data.mmi_view,
                type: 'map',
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Stack width="100%">
              <Stack.Item width="85%">
                <TextArea
                  height="60px"
                  placeholder="发送消息让我们的诱饵大脑说话."
                  onChange={(_, value) => setmmiMessage(value)}
                  value={mmiMessage}
                />
              </Stack.Item>
              <Stack.Item align="center">
                <Button
                  textAlign="center"
                  content="发送"
                  onClick={() => {
                    act('send_mmi_message', { message: mmiMessage });
                    setmmiMessage('');
                  }}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
